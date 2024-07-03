#include "process.h"

typedef struct DirNode {
    char *path;
    struct DirNode *next;
} DirNode;

// Global pointer to the top of the stack
DirNode *dirStackTop = NULL;

static int exeSimpleCmd(const CMD *cmd);
int exePipeline(const CMD *cmd);
int exeCond(const CMD *cmd);
int exeSubCmd(const CMD *cmd);
int exeBackground(const CMD *cmd);
int exeSepEnd(const CMD *cmd);
static int changeDirectory(const CMD *cmd);
static int handleRedirections(const CMD *cmd);
static void updateEnvVariables(const char* oldPath, const char* newPath);
void pushDir(const char *dir);
static int pushd(const CMD *cmd);
void freeDirStack();
static int popd();
static void setExitStatus(int status);
void reapBackgroundProcesses();

int process(const CMD *cmd) {
    int status = 0;
    if (cmd == NULL) {
        return errno;
    }

    reapBackgroundProcesses(); // Reap any zombies from previously executed background processes
    switch (cmd->type) {
        case SIMPLE:
            status = exeSimpleCmd(cmd);
            break;

        case PIPE:
            status = exePipeline(cmd);
            break;
        
        case SEP_AND:
        case SEP_OR:
            status = exeCond(cmd);
            break;

        case SUBCMD:
            status = exeSubCmd(cmd);
            break;
        
        case SEP_BG:
            status = exeBackground(cmd);
            if (cmd->right != NULL) {
                status = process(cmd->right);
            }
            break;
        
        case SEP_END: 
            status = exeSepEnd(cmd);
            break;

        default:
            fprintf(stderr, "Unsupported command type.\n");
            return errno;
    }
    setExitStatus(status);
    reapBackgroundProcesses(); // Reap any new zombies that might have been created by the last command
    return status;
}

static int exeSimpleCmd(const CMD *cmd) {
    if (strcmp(cmd->argv[0], "cd") == 0) {
        if (cmd->argc > 2) {
            fprintf(stderr, "cd: too many arguments\n");
            return EXIT_FAILURE; // Indicate error due to too many arguments
        }
        int originalStdout = -1;
        if (cmd->toType != NONE) {
            originalStdout = dup(STDOUT_FILENO);
            if (handleRedirections(cmd) != 0) {
                return errno;
            }
        }
        int status = changeDirectory(cmd);
        fflush(stdout);
        if (originalStdout != -1) {
            if (dup2(originalStdout, STDOUT_FILENO) == -1) {
                perror("dup2"); 
            }
            close(originalStdout); 
        }
        return status;
    } else if (strcmp(cmd->argv[0], "pushd") == 0) {
        if (cmd->argc != 2) { 
            fprintf(stderr, "pushd: too many arguments\n");
            return EXIT_FAILURE; 
        }
        int originalStdout = -1;
        if (cmd->toType != NONE) {
            originalStdout = dup(STDOUT_FILENO);
            if (handleRedirections(cmd) != 0) {
                return errno;
            }
        }
        int status = pushd(cmd);
        fflush(stdout);
        if (originalStdout != -1) {
            if (dup2(originalStdout, STDOUT_FILENO) == -1) {
                perror("dup2"); 
            }
            close(originalStdout); 
        }
        return status;
    } else if (strcmp(cmd->argv[0], "popd") == 0) {
        if (cmd->argc != 1) { 
            fprintf(stderr, "popd: too many arguments\n");
            return EXIT_FAILURE; 
        }
        int originalStdout = -1;
        if (cmd->toType != NONE) {
            originalStdout = dup(STDOUT_FILENO);
            if (handleRedirections(cmd) != 0) {
                return errno;
            }
        }
        int status = popd();
        fflush(stdout);
        if (originalStdout != -1) {
            if (dup2(originalStdout, STDOUT_FILENO) == -1) {
                perror("dup2"); 
            }
            close(originalStdout); 
        }
        return status;
    } else {
        pid_t pid = fork();
        if (pid == 0) { 
            // Set local environment variables specified in the command
            for (int i = 0; i < cmd->nLocal; ++i) {
                setenv(cmd->locVar[i], cmd->locVal[i], 1); // Override existing value
            }

            if (handleRedirections(cmd) != 0) {
                exit(errno);
            }
            execvp(cmd->argv[0], cmd->argv);
            perror("execvp");
            exit(errno); 
        } else if (pid > 0) { 
            int status;
            waitpid(pid, &status, 0);
            return STATUS(status);
        } else {
            perror("fork");
            return errno;
        }
    }
}

static int changeDirectory(const CMD *cmd) {
    // Validate the number of arguments
    if (cmd->argc > 2) {
        fprintf(stderr, "cd: too many arguments\n");
        return errno; // Indicate error due to too many arguments
    }

    // Get the current working directory without assuming its size
    char *oldPath = getcwd(NULL, 0);
    if (!oldPath) {
        fprintf(stderr, "cd: getcwd fail: %s\n", strerror(errno));
        return errno;
    }

    char *targetPath = cmd->argc == 2 ? cmd->argv[1] : NULL;
    if (!targetPath) {
        targetPath = getenv("HOME");
        if (!targetPath) {
            fprintf(stderr, "cd: HOME not set\n");
            free(oldPath);
            return errno; // Indicate error due to HOME being undefined
        }
    } else if (strcmp(targetPath, "~") == 0) {
        targetPath = getenv("HOME");
        if (!targetPath) {
            fprintf(stderr, "cd: HOME not set\n");
            free(oldPath);
            return errno; // Indicate error due to HOME being undefined
        }
    } else if (strcmp(targetPath, "-") == 0) {
        targetPath = getenv("OLDPWD");
        if (!targetPath) {
            fprintf(stderr, "cd: OLDPWD not set\n");
            free(oldPath);
            return errno; // Indicate error due to OLDPWD being undefined
        }
    }

    // Attempt to change directory and handle errors
    if (chdir(targetPath) != 0) {
        fprintf(stderr, "cd: chdir fail: %s\n", strerror(errno));
        free(oldPath);
        return errno; // Return error due to chdir failure (such as non-existent directory)
    }

    // Get the new path after changing directory
    char *newPath = getcwd(NULL, 0);
    if (!newPath) {
        fprintf(stderr, "cd: getcwd fail: %s\n", strerror(errno));
        free(oldPath);
        return errno;
    }

    // Update environment variables to reflect change
    updateEnvVariables(oldPath, newPath);

    free(oldPath);
    free(newPath);
    return 0;
}

static void updateEnvVariables(const char* oldPath, const char* newPath) {
    setenv("OLDPWD", oldPath, 1);  // Update OLDPWD with old path
    setenv("PWD", newPath, 1);     // Update PWD with new path
}

void pushDir(const char *dir) {
    DirNode *newNode = (DirNode *)malloc(sizeof(DirNode));
    if (!newNode) {
        perror("malloc");
        return;
    }
    newNode->path = strdup(dir); 
    if (!newNode->path) {
        // perror("strdup");
        fprintf(stderr, "Error duplicating directory string: ");
        free(newNode);
        return;
    }
    newNode->next = dirStackTop;  
    dirStackTop = newNode;
}

static int pushd(const CMD *cmd) {
    // Get the current directory
    char *currentDir = getcwd(NULL, 0);
    if (!currentDir) {
        fprintf(stderr, "Error: getcwd failed: %s\n", strerror(errno));
        return errno;
    }

    // Push the current directory to the stack
    pushDir(currentDir);

    // Change to the new directory
    const char *newDir = cmd->argv[1];
    if (newDir == NULL || chdir(newDir) != 0) {
        fprintf(stderr, "cd: chdir to '%s' failed: %s\n", newDir ? newDir : "NULL", strerror(errno));
        free(currentDir);
        return errno;
    }
    free(currentDir); 

    currentDir = getcwd(NULL, 0);
    printf("%s ", currentDir);  // Print the new current directory

    DirNode *node = dirStackTop;
    while (node != NULL) {
        // Print the directory path
        printf("%s", node->path);
        
        // Check if this is not the last node in the stack
        if (node->next != NULL) {
            printf(" "); 
        }
        
        node = node->next; // Move to the next node
    }
    printf("\n");
    free(currentDir);

    return 0;
}

void freeDirStack() {
    while (dirStackTop != NULL) {
        DirNode *temp = dirStackTop;
        dirStackTop = dirStackTop->next;
        free(temp->path);
        free(temp);
    }
}

static int popd() {
    // Check if the stack is empty
    if (dirStackTop == NULL) {
        fprintf(stderr, "Directory stack is empty\n");
        return errno;
    }

    // Pop the top directory from the stack
    DirNode *topNode = dirStackTop;
    dirStackTop = dirStackTop->next;

    // Change to the directory that was just popped
    if (chdir(topNode->path) != 0) {
        perror("chdir");
        free(topNode->path);  
        free(topNode);        
        return errno;
    }

    // Free the memory for the popped directory
    free(topNode->path);
    free(topNode);

    char *currentDir = getcwd(NULL, 0);
    if (currentDir) {
        printf("%s", currentDir); 
        free(currentDir);
    } else {
        perror("getcwd");
    }

    DirNode *node = dirStackTop;
    while (node != NULL) {
        // Print the directory path
        printf("%s", node->path);
        
        // Check if this is not the last node in the stack
        if (node->next != NULL) {
            printf(" "); // Print a space only if there's another node after this one
        }
        
        node = node->next; // Move to the next node
    }
    printf("\n");
    return 0;
}

static void setExitStatus(int status) {
    char statusStr[12];
    snprintf(statusStr, sizeof(statusStr), "%d", status);
    setenv("?", statusStr, 1);
}

static int handleRedirections(const CMD *cmd) {
    // Input redirection
    if (cmd->fromType != NONE) {
        int fdIn;
        switch (cmd->fromType) {
            case RED_IN: 
                fdIn = open(cmd->fromFile, O_RDONLY);
                if (fdIn < 0) {
                    perror("Failed to open input file");
                    return errno;
                }
                if (dup2(fdIn, STDIN_FILENO) < 0) {
                    perror("Failed to redirect standard input");
                    return errno;
                }
                close(fdIn); 
                break;

            case RED_IN_HERE: // Here document
                {
                    char tmpFilename[] = "/tmp/shell_here_docXXXXXX";
                    int fdHere = mkstemp(tmpFilename);
                    if (fdHere < 0) {
                        perror("Failed to create temporary file for here document");
                        return errno;
                    }

                    // Write the here document content to the temporary file
                    if (write(fdHere, cmd->fromFile, strlen(cmd->fromFile)) < 0) {
                        perror("Failed to write to temporary file for here document");
                        close(fdHere);
                        unlink(tmpFilename); 
                        return errno;
                    }

                    // Seek back to the beginning of the file
                    if (lseek(fdHere, 0, SEEK_SET) < 0) {
                        perror("Failed to seek in temporary file for here document");
                        close(fdHere);
                        unlink(tmpFilename);
                        return errno;
                    }

                    // Redirect standard input to the temporary file
                    if (dup2(fdHere, STDIN_FILENO) < 0) {
                        perror("Failed to redirect standard input for here document");
                        close(fdHere);
                        unlink(tmpFilename);
                        return errno;
                    }

                    close(fdHere); 
                    unlink(tmpFilename); // Remove the temporary file from the filesystem
                }
                break;
        }
    }

    // Output redirection
    if (cmd->toType != NONE) {
        int fdOut;
        switch (cmd->toType) {
            case RED_OUT: 
                fdOut = open(cmd->toFile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
                break;
            case RED_OUT_APP:
                fdOut = open(cmd->toFile, O_WRONLY | O_CREAT | O_APPEND, 0644);
                break;
        }
        if (fdOut < 0) {
            perror("Failed to open output file");
            return errno;
        }
        if (dup2(fdOut, STDOUT_FILENO) < 0) {
            perror("Failed to redirect standard output");
            return errno;
        }
        close(fdOut); 
    }

    return 0;
}

int exePipeline(const CMD *cmd) {
    if (cmd == NULL) return errno; 

    if (cmd->type != PIPE) {
        return process(cmd);
    }

    int pipefd[2];
    pid_t pidLeft, pidRight;
    int status = 0;

    // Create a pipe.
    if (pipe(pipefd) == -1) {
        perror("pipe");
        return errno;
    }

    // Handle the left side of the pipe.
    pidLeft = fork();
    if (pidLeft == -1) {
        perror("fork");
        return errno;
    } else if (pidLeft == 0) { 
        dup2(pipefd[1], STDOUT_FILENO);
        close(pipefd[0]); // Close the read end; not needed in this child.
        close(pipefd[1]);
        exit(exePipeline(cmd->left));
    }

    // Handle the right side of the pipe in the parent process.
    pidRight = fork();
    if (pidRight == -1) {
        perror("fork");
        return errno;
    } else if (pidRight == 0) { 
        dup2(pipefd[0], STDIN_FILENO);
        close(pipefd[1]);
        close(pipefd[0]);
        exit(exePipeline(cmd->right));
    }

    close(pipefd[0]);
    close(pipefd[1]);

    int leftStatus = 0;
    int rightStatus = 0;

    // Wait for both child processes to complete.
    waitpid(pidLeft, &leftStatus, 0); 
    waitpid(pidRight, &rightStatus, 0);    

    if ((status = STATUS(rightStatus)) != 0) {
        return status;
    }
    return STATUS(leftStatus); 
}

int exeCond(const CMD *cmd) {
    if (cmd == NULL) return errno; 

    int leftStatus = process(cmd->left); 

    switch (cmd->type) {
        case SEP_AND:
            if (leftStatus == 0) {
                return process(cmd->right);
            } else {
                return leftStatus;
            }
        case SEP_OR:
            if (leftStatus != 0) {
                return process(cmd->right);
            } else {
                return leftStatus;
            }
        default:
            // Handle unexpected cmd->type
            fprintf(stderr, "Unexpected command type.\n");
            return errno;
    }
}

int exeSubCmd(const CMD *subcmd) {
    if (subcmd == NULL) {
        return errno; 
    }

    int pid = fork();
    if (pid == -1) {
        perror("fork");
        return errno; 
    } else if (pid == 0) { 
        // Setup environment and apply redirections as needed
        for (int i = 0; i < subcmd->nLocal; ++i) {
            setenv(subcmd->locVar[i], subcmd->locVal[i], 1); 
        }
        if (handleRedirections(subcmd) != 0) {
            exit(errno); 
        }

        int status = process(subcmd->left); 
        exit(status);
    } else { // Parent process
        int waitStatus;
        waitpid(pid, &waitStatus, 0);
        return waitStatus; 
    }
}

int exeSepEnd(const CMD *cmd) {
    int status;
    status = process(cmd->left); 
    if (cmd->right != NULL) {
        status = process(cmd->right);
    }
    return status;
}

int exeBackground(const CMD *cmd) {
    int status = 0;
    pid_t pid;
    
    if (cmd->left->type != SEP_BG && cmd->left->type != SEP_END) {
        if (cmd->type == SEP_BG) {
            if ((pid = fork()) == -1) {
                perror("Fork failed");
                return errno;
            } else if (pid == 0) {
                exit(process(cmd->left));
            } else {
                fprintf(stderr, "Backgrounded: %d\n", pid);
            }     
        } else if (cmd->type == SEP_END) {
            status = process(cmd->left);
        }
    } else {
        exeBackground(cmd->left);
        if (cmd->type == SEP_BG)
        {
            if ((pid = fork()) == -1) {
                perror("Fork failed");
                return errno;
            } else if (pid == 0) {
                exit(process(cmd->left->right));
            } else {
                fprintf(stderr, "Backgrounded: %d\n", pid);
            }        
        } else {
            status = process(cmd->left->right);
        }
    } 
    return status;
}

void reapBackgroundProcesses() {
    pid_t pid;
    int status;

    while ((pid = waitpid(-1, &status, WNOHANG)) > 0) {
        fprintf(stderr, "Completed: %d (%d)\n", pid, WEXITSTATUS(status));
    }
}