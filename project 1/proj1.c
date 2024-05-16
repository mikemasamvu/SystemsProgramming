#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "proj1.h"

int main(int argc, char *argv[]) {
    MacroNode *macroList = NULL;
    size_t initialCapacity = 100;

    // Initialize DynamicString
    DynamicString *dynamicString = createDynamicString(initialCapacity);
    if (!dynamicString) {
        fprintf(stderr, "Failed to initialize dynamic string\n");
        return EXIT_FAILURE;
    }

    // Create a single temporary file for concatenating all input
    FILE *tempStream = createTempStream("");

    if (argc == 1) {
        // No files specified, read from standard input and remove comments
        FILE *stdinTempStream = removeComments(stdin);
        concatenateTempStreams(tempStream, stdinTempStream);
        fclose(stdinTempStream);
    } else {
        // Concatenate each file specified in the command line arguments into the tempStream
        for (int i = 1; i < argc; i++) {
            FILE *file = fopen(argv[i], "r");
            if (file == NULL) {
                DIE("Error opening file: %s", argv[i]);
            }

            FILE *fileTempStream = removeComments(file);
            fclose(file); // Close the original file

            concatenateTempStreams(tempStream, fileTempStream);
            fclose(fileTempStream);
        }
    }

    rewind(tempStream); // Rewind the tempStream to the beginning for processing
    processMacros(tempStream, &macroList, dynamicString);
    fclose(tempStream); // Close and delete the temporary file

    // Final expansion of macros using the stack method
    expandMacrosUsingStack(dynamicString, &macroList);

    // Print the result and clean up
    printDynamicString(dynamicString);
    freeDynamicString(dynamicString);
    freeMacroList(macroList); // Assuming this function frees the macro list
    return EXIT_SUCCESS;
}

void processMacros(FILE *file, MacroNode **head, DynamicString *dynamicString) {
    int ch;
    char macro[1024];

    while ((ch = fgetc(file)) != EOF) {
        if (ch == '\\') 
        {
            if (handleEscapeCharacterFromFile(file, dynamicString)){
                continue;
            } else {
                // Read macro name until '{' is encountered
                readMacroName(file, macro);
                // Read macro value - assumes it's enclosed in curly braces
                if (strcmp(macro, "def") == 0) {
                    char *macroName = parseMacroName(file);

                    if (fgetc(file) == '{') {
                        // Parse the macro value dynamically
                        char *macroValue = parseMacroValue(file);

                        if (!macroValue) {
                            fprintf(stderr, "Error: Failed to parse macro value\n");
                            exit(1); // Replace EXIT_FAILURE with your desired error code
                        }

                        // Check if the macro already exists in the list
                        if (findMacroNode(*head, macroName) != NULL) {
                            fprintf(stderr, "Error: Macro '%s' already exists\n", macroName);
                            free(macroValue); // Free the macro value before exiting
                            exit(1); // Replace EXIT_FAILURE with your desired error code
                        }

                        // Insert new macro into the list
                        MacroNode *newNode = createMacroNode(macroName, macroValue);
                        insertMacroNode(head, newNode);
                        free(macroValue); // Free the macro value after it's copied in createMacroNode
                    } else {
                        fprintf(stderr, "Error: Expected opening brace after macro name\n");
                        exit(1);
                    }

                    free(macroName); // Free the macro name
                    int ch;
                    while ((ch = fgetc(file)) != EOF) {
                        appendCharToDynamicString(dynamicString, (char)ch);
                    }
                } else if (strcmp(macro, "undef") == 0) {
                    // Dynamically read the macro name enclosed in curly braces
                    char *macroName = parseMacroName(file);
                    if (macroName) {
                        // Successfully read the macro name

                        // Delete the macro node with this name from the list
                        deleteMacroNode(head, macroName);

                        // Free the dynamically allocated macro name
                        free(macroName);
                    } else {
                        fprintf(stderr, "Error: Failed to read macro name\n");
                        exit(1);
                    }
                } else if (findMacroNode(*head, macro)) {
                    // Macro is already defined, so expand it

                    // Dynamically read the macro argument enclosed in curly braces
                    char *macroArg = parseMacroArgument(file);
                    if (macroArg) {
                        // Successfully read the macro argument

                        // Get the macro node again for expansion
                        MacroNode *foundMacro = findMacroNode(*head, macro);
                        if (foundMacro) {
                            char *expandedMacro = replacePlaceholder(foundMacro->value, macroArg);
                            if (expandedMacro) {
                                // Append expandedMacro to your dynamic string
                                appendToDynamicString(dynamicString, expandedMacro);
                                free(expandedMacro); // Free the memory allocated by replacePlaceholder
                            }
                        }

                        // Free the dynamically allocated macro argument
                        free(macroArg);
                    } else {
                        fprintf(stderr, "Error: Failed to read macro argument\n");
                        exit(1);
                    }
                    int ch;
                    while ((ch = fgetc(file)) != EOF) {
                        appendCharToDynamicString(dynamicString, (char)ch);
                    }
                }
                else if (strcmp(macro, "if") == 0) {
                    char cond[1024], thenPart[1024], elsePart[1024];

                    // Parse the COND, THEN, and ELSE parts of the \if macro
                    parseIfMacro(file, cond, thenPart, elsePart, sizeof(cond));  // sizeof(cond) is used as argSize for all

                    // Evaluate COND - true if non-empty, false if empty
                    if (strlen(cond) > 0) {
                        // COND is non-empty, use THEN part
                        appendToDynamicString(dynamicString, thenPart);
                    } else {
                        // COND is empty, use ELSE part
                        appendToDynamicString(dynamicString, elsePart);
                    }
                }
                else if (strcmp(macro, "ifdef") == 0) {
                    char name[1024], thenPart[1024], elsePart[1024];

                    // Parse the NAME, THEN, and ELSE parts of the \ifdef macro
                    parseIfMacro(file, name, thenPart, elsePart, sizeof(name));  // Reuse parseIfMacro for argument parsing

                    // Check if the macro NAME exists
                    if (findMacroNode(*head, name)) {
                        // NAME exists, use THEN part
                        appendToDynamicString(dynamicString, thenPart);
                    } else {
                        // NAME does not exist, use ELSE part
                        appendToDynamicString(dynamicString, elsePart);
                    }
                }
                else if (strcmp(macro, "include") == 0) {
                    char filePath[1024] = {0};

                    // Read the file path argument
                    if (fgetc(file) == '{') {
                        int i = 0, ch;
                        int braceCount = 1;  // Start with 1 to account for the first opening brace

                        while ((ch = fgetc(file)) != EOF && i < sizeof(filePath) - 1) {
                            if (ch == '{') {
                                braceCount++;
                            } else if (ch == '}') {
                                braceCount--;
                                if (braceCount == 0) {
                                    break;  // All braces are balanced, end of the file path
                                }
                            }
                            filePath[i++] = ch;
                        }

                        filePath[i] = '\0';  // Null-terminate the string
                    } else {
                        fprintf(stderr, "Error: Expected opening brace\n");
                        exit(1);
                    }

                    // Open the specified file
                    FILE *includedFile = fopen(filePath, "r");
                    if (!includedFile) {
                        fprintf(stderr, "Error: Unable to open included file %s\n", filePath);
                        exit(1);
                    }

                    // Read all characters from the included file and append them to dynamicString
                    while ((ch = fgetc(includedFile)) != EOF) {
                        appendCharToDynamicString(dynamicString, ch);
                    }

                    fclose(includedFile);

                    // Continue reading from the original file and append characters to dynamicString until EOF
                    while ((ch = fgetc(file)) != EOF) {
                        appendCharToDynamicString(dynamicString, ch);
                    }
                }
                else if (strcmp(macro, "expandafter") == 0) {
                    char before[1024] = {0}, after[1024] = {0};

                    // Parse the BEFORE and AFTER arguments using parseExpandAfter
                    parseExpandAfter(file, before, after, sizeof(before));

                    // Recursively process the AFTER argument
                    char *expandedAfter = expandMacrosInSubstring(after, head);

                    // Concatenate BEFORE and expanded AFTER
                    char *beforeAfterConcat = malloc(strlen(before) + strlen(expandedAfter) + 1);
                    if (!beforeAfterConcat) {
                        fprintf(stderr, "Error: Memory allocation failed\n");
                        exit(1);
                    }
                    strcpy(beforeAfterConcat, before);
                    strcat(beforeAfterConcat, expandedAfter);
                    free(expandedAfter);  // Free the expanded AFTER part

                    // Read the rest of the file into a new string
                    DynamicString *restOfFileString = createDynamicString(1024); // Assuming you have a dynamic string implementation
                    int ch;
                    while ((ch = fgetc(file)) != EOF) {
                        appendCharToDynamicString(restOfFileString, ch); // Assuming this function appends a single character to a dynamic string
                    }

                    // Concatenate rest of the file with BEFORE+AFTER
                    char *finalConcatenated = malloc(strlen(beforeAfterConcat) + strlen(restOfFileString->data) + 1);
                    if (!finalConcatenated) {
                        fprintf(stderr, "Error: Memory allocation failed for final concatenation\n");
                        exit(1);
                    }
                    strcpy(finalConcatenated, beforeAfterConcat);
                    strcat(finalConcatenated, restOfFileString->data);
                    free(beforeAfterConcat);
                    freeDynamicString(restOfFileString); // Free the dynamic string used for the rest of the file

                    // Process the final concatenated string for macros
                    char *fullyExpanded = expandMacrosInSubstring(finalConcatenated, head);
                    free(finalConcatenated); // Free the final concatenated string

                    // Append the fully expanded string
                    appendToDynamicString(dynamicString, fullyExpanded);
                    free(fullyExpanded); // Free the fully expanded string
                } else {
                    fprintf(stderr, "Error: Macro '%s' not found\n", macro);
                    exit(1);
                }
            }  
        } else {
            // Handle normal characters
            char normalChar[2] = {ch, '\0'};  // Convert char to string for appending
            appendToDynamicString(dynamicString, normalChar);
        }
    }
}

void readMacroName(FILE *file, char *macro) {
    int ch;
    int count = 0;

    while ((ch = fgetc(file)) != EOF && ch != '{' && count < 99) {
        if (!isalnum(ch)) {
            fprintf(stderr, "Error: Non-alphanumeric character encountered\n");
            exit(1);
        }
        macro[count++] = ch;
    }
    
    if (ch == EOF) {
        fprintf(stderr, "Error: Unexpected end of file\n");
        exit(1);
    } else if (ch == '\n') {
        fprintf(stderr, "Error: Newline encountered before '{'\n");
        exit(1);
    } else if (ch != '{') {
        fprintf(stderr, "Error: '{' not found\n");
        exit(1);
    } else {
        // Put the '{' back into the file stream
        ungetc(ch, file);
    }

    macro[count] = '\0'; // Null-terminate the string
}

char *parseMacroName(FILE *file) {
    int ch;
    size_t size = INITIAL_MACRO_NAME_SIZE;
    size_t count = 0;
    char *macroName = malloc(size);
    if (!macroName) {
        fprintf(stderr, "Error: Memory allocation failed\n");
        exit(1);
    }

    // Expecting an opening brace '{'
    ch = fgetc(file);
    if (ch == EOF) {
        free(macroName);
        fprintf(stderr, "Error: Unexpected end of file\n");
        exit(1);
    } else if (ch != '{') {
        free(macroName);
        fprintf(stderr, "Error: Expected opening brace '{'\n");
        exit(1);
    }

    // Read macro name
    while ((ch = fgetc(file)) != '}' && ch != EOF) {
        if (!isalnum(ch)) {
            free(macroName);
            fprintf(stderr, "Error: Non-alphanumeric character encountered in macro name\n");
            exit(1);
        }
        if (count >= size - 1) {
            char *temp = realloc(macroName, size *= 2);
            if (!temp) {
                free(macroName);
                fprintf(stderr, "Error: Memory reallocation failed\n");
                exit(1);
            }
            macroName = temp;
        }
        macroName[count++] = ch;
    }

    // Check for closing brace
    if (ch != '}') {
        free(macroName);
        fprintf(stderr, "Error: Expected closing brace '}'\n");
        exit(1);
    }

    // Null-terminate the macro name
    macroName[count] = '\0';
    // Ensure macro name is not empty
    if (count == 0) {
        free(macroName);
        fprintf(stderr, "Error: Macro name is empty\n");
        exit(1);
    }

    return macroName;
}

char *parseMacroValue(FILE *file) {
    int ch;
    size_t size = INITIAL_MACRO_VALUE_SIZE;
    size_t count = 0;
    char *macroValue = malloc(size);
    if (!macroValue) {
        fprintf(stderr, "Error: Memory allocation failed for macro value\n");
        exit(1);
    }

    int braceCount = 1;  // Start with 1 for the already read opening brace

    while (braceCount > 0 && (ch = fgetc(file)) != EOF) {
        if (ch == '{') {
            braceCount++;
        } else if (ch == '}') {
            braceCount--;
            if (braceCount == 0) {
                break; // Found matching closing brace
            }
        }

        // Add character to macro value
        if (count >= size - 1) {
            char *temp = realloc(macroValue, size *= 2);
            if (!temp) {
                free(macroValue);
                fprintf(stderr, "Error: Memory reallocation failed for macro value\n");
                exit(1);
            }
            macroValue = temp;
        }
        macroValue[count++] = ch;
    }

    // Check for unbalanced braces
    if (braceCount != 0) {
        free(macroValue);
        fprintf(stderr, "Error: Unbalanced braces in macro value\n");
        exit(1);
    }

    // Null-terminate the macro value
    macroValue[count] = '\0';

    return macroValue;
}

char *parseMacroArgument(FILE *file) {
    int ch;
    size_t size = 1024; // Initial buffer size
    size_t count = 0;
    char *macroArg = malloc(size * sizeof(char));
    if (!macroArg) {
        perror("Failed to allocate memory for macro argument");
        exit(1);
    }

    int braceCount = 1;  // Start with 1 for the first opening brace

    // Expecting an opening brace '{'
    if ((ch = fgetc(file)) != '{') {
        free(macroArg);
        fprintf(stderr, "Error: Expected opening brace '{' for macro argument\n");
        exit(1);
    }

    while (braceCount > 0 && (ch = fgetc(file)) != EOF) {
        if (ch == '{') {
            braceCount++;
        } else if (ch == '}') {
            braceCount--;
            if (braceCount == 0) {
                break; // Found matching closing brace
            }
        }

        // Add character to macro argument
        if (count >= size - 1) {
            char *temp = realloc(macroArg, size *= 2);
            if (!temp) {
                free(macroArg);
                perror("Failed to reallocate memory for macro argument");
                exit(1);
            }
            macroArg = temp;
        }
        macroArg[count++] = ch;
    }

    // Check for unbalanced braces
    if (braceCount != 0) {
        free(macroArg);
        fprintf(stderr, "Error: Unbalanced braces in macro argument\n");
        exit(1);
    }

    // Null-terminate the macro argument
    macroArg[count] = '\0';

    return macroArg;
}

bool handleEscapeCharacterFromFile(FILE *file, DynamicString *dynamicString) {
    // Get the first character from dynamicString
    char ch = fgetc(file);

    if (ch == '\\' || ch == '#' || ch == '%' || ch == '{' || ch == '}') {
        appendCharToDynamicString(dynamicString, '\\');
        appendCharToDynamicString(dynamicString, ch);
        return true;
    } else if ((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9')) {
        ungetc(ch, file);
        return false;
    } else {
        appendCharToDynamicString(dynamicString, '\\');
        appendCharToDynamicString(dynamicString, ch);
        return true;
    }
}

MacroNode *createMacroNode(const char *name, const char *value) {
    MacroNode *node = malloc(sizeof(MacroNode));
    if (node) {
        node->name = string_copy(name);
        node->value = string_copy(value);
        node->next = NULL;
    }
    return node;
}

void insertMacroNode(MacroNode **head, MacroNode *newNode) {
    newNode->next = *head;
    *head = newNode;
}

void freeMacroNode(MacroNode *node) {
    free(node->name);
    free(node->value);
    free(node);
}

void freeMacroList(MacroNode *head) {
    while (head) {
        MacroNode *tmp = head;
        head = head->next;
        freeMacroNode(tmp);
    }
}

char *string_copy(const char *s) {
    char *new_str = malloc(strlen(s) + 1); // +1 for the null terminator
    if (new_str != NULL) {
        strcpy(new_str, s);
    }
    return new_str;
}

MacroNode *findMacroNode(MacroNode *head, const char *macroName) {
    while (head != NULL) {
        if (strcmp(head->name, macroName) == 0) {
            return head; // Found the macro
        }
        head = head->next;
    }
    return NULL; // Macro not found
}

void deleteMacroNode(MacroNode **head, const char *name) {
    MacroNode *temp = *head, *prev = NULL;
    while (temp != NULL && strcmp(temp->name, name) != 0) {
        prev = temp;
        temp = temp->next;
    }
    if (temp == NULL) { // not found
        fprintf(stderr, "Error: Macro '%s' not found\n", name);
        exit(1); 
    }

    if (prev == NULL) {
        *head = temp->next;
    } else {
        prev->next = temp->next;
    }
    freeMacroNode(temp);
}

DynamicString *createDynamicString(size_t initialCapacity) {
    DynamicString *str = malloc(sizeof(DynamicString));
    if (!str) {
        perror("Failed to allocate DynamicString");
        return NULL;
    }

    str->data = malloc(initialCapacity * sizeof(char));
    if (str->data) {
        str->data[0] = '\0'; // Initialize with an empty string
        str->size = 0;
        str->capacity = initialCapacity;
    } else {
        free(str);
        perror("Failed to allocate data for DynamicString");
        return NULL;
    }

    return str;
}

void freeDynamicString(DynamicString *str) {
    if (str) {
        // Free the data field
        if (str->data) {
            free(str->data);
        }
        // Free the DynamicString struct itself
        free(str);
    }
}

// Function to append text to a DynamicString
void appendToDynamicString(DynamicString *str, const char *text) {
    size_t textLength = strlen(text);

    // Ensure there's enough capacity (including the null terminator)
    while (str->size + textLength + 1 > str->capacity) {
        char *newData = DOUBLE(str->data, str->capacity);
        if (newData == NULL) {
            perror("Failed to resize dynamic string");
            exit(EXIT_FAILURE);
        }
        str->data = newData;
    }

    // Copy new text into the string
    strcpy(str->data + str->size, text);
    str->size += textLength;
}

void printDynamicString(const DynamicString *str) {
    if (str && str->data) {
        printf("%s", str->data);
    }
}

char *replacePlaceholder(const char *macroDefinition, const char *replacement) {
    size_t bufferSize = 1024; // Initial buffer size
    char *result = malloc(bufferSize * sizeof(char));
    if (!result) {
        perror("Failed to allocate memory for expanded macro");
        return NULL;
    }

    result[0] = '\0'; // Start with an empty string

    size_t usedLength = 0; // Track used length of result

    for (const char *current = macroDefinition; *current != '\0'; ) {
        char *nextPlaceholder = strchr(current, '#');
        if (nextPlaceholder == NULL) {
            strcat(result, current); // Append remaining part
            break;
        }

        size_t segmentLength = nextPlaceholder - current;
        bool isEscaped = false;

        // Check if '#' is preceded by backslashes
        size_t backslashCount = 0;
        while (segmentLength > backslashCount && *(nextPlaceholder - backslashCount - 1) == '\\') {
            backslashCount++;
        }

        if (backslashCount > 0) {
            if (backslashCount % 2 == 0) {
                // Even number of backslashes: append half the backslashes and the replacement
                segmentLength -= backslashCount / 2;
            } else {
                // Odd number of backslashes: append all but one backslash and the '#'
                isEscaped = true;
                segmentLength -= backslashCount - 1;
            }
        }

        size_t newLength = usedLength + segmentLength + (isEscaped ? 1 : strlen(replacement));

        // Resize if necessary
        if (newLength >= bufferSize - 1) {
            bufferSize = newLength + 1; // Increase buffer size
            char *temp = realloc(result, bufferSize * sizeof(char));
            if (!temp) {
                free(result);
                perror("Failed to reallocate memory for expanded macro");
                return NULL;
            }
            result = temp;
        }

        // Append part before '#'
        strncat(result, current, segmentLength);

        // Append the appropriate number of backslashes
        for (size_t i = 0; i < backslashCount / 2; ++i) {
            strcat(result, "\\");
        }

        // Append the '#' or replacement
        if (isEscaped) {
            strcat(result, "#");
        } else {
            strcat(result, replacement);
        }

        usedLength = strlen(result);
        current = nextPlaceholder + 1; // Move past the placeholder or escaped character
    }

    return result; // Return the expanded string
}

void parseIfMacro(FILE *file, char *cond, char *thenPart, char *elsePart, size_t argSize) {
    int ch;
    int bracesCount;

    for (int i = 0; i < 3; i++) { // Loop to read the three arguments: COND, THEN, ELSE
        char *arg = (i == 0) ? cond : ((i == 1) ? thenPart : elsePart);
        size_t j = 0;

        // Expecting an opening brace '{'
        if ((ch = fgetc(file)) != '{') {
            fprintf(stderr, "Error: Expected opening brace for argument %d\n", i + 1);
            exit(1);
        }

        bracesCount = 1; // Reset brace count for each argument

        while (bracesCount > 0 && (ch = fgetc(file)) != EOF && j < argSize - 1) {
            if (ch == '{') {
                bracesCount++;  // Increase count for nested opening brace
            } else if (ch == '}') {
                bracesCount--;  // Decrease count for closing brace
            }

            if (bracesCount > 0) {
                arg[j++] = ch;  // Store character if we're not at the closing brace of the top-level argument
            }
        }

        arg[j] = '\0'; // Null-terminate the argument string

        if (ch == EOF) {
            fprintf(stderr, "Error: Unexpected end of file while reading argument %d\n", i + 1);
            exit(1);
        }

        if (bracesCount != 0) {
            fprintf(stderr, "Error: Unbalanced braces in argument %d\n", i + 1);
            exit(1);
        }
    }
}

void parseExpandAfter(FILE *file, char *before, char *after, size_t argSize) {
    int ch;
    int bracesCount = 0; // Initially no braces

    // Parse the BEFORE argument
    if ((ch = fgetc(file)) != '{') {
        fprintf(stderr, "Error: Expected opening brace for BEFORE argument\n");
        exit(1);
    }

    bracesCount = 1; // Account for the opening brace
    size_t i = 0;
    while ((ch = fgetc(file)) != EOF && i < argSize - 1) {
        if (ch == '{') {
            bracesCount++;
        } else if (ch == '}') {
            bracesCount--;
            if (bracesCount == 0) {
                break; // End of BEFORE argument
            }
        }
        before[i++] = ch;
    }
    before[i] = '\0'; // Null-terminate the BEFORE argument

    // Parse the AFTER argument
    if ((ch = fgetc(file)) != '{') {
        fprintf(stderr, "Error: Expected opening brace for AFTER argument\n");
        exit(1);
    }

    bracesCount = 1; // Reset for the opening brace of AFTER argument
    i = 0;
    while ((ch = fgetc(file)) != EOF && i < argSize - 1) {
        if (ch == '{') {
            bracesCount++;
        } else if (ch == '}') {
            bracesCount--;
            if (bracesCount == 0) {
                break; // End of AFTER argument
            }
        }
        after[i++] = ch;
    }
    after[i] = '\0'; // Null-terminate the AFTER argument
}

FILE *createTempStream(const char *str) {
    FILE *stream = tmpfile();
    if (!stream) {
        fprintf(stderr, "Unable to create a temporary file\n");
        exit(1);
    }

    if (fputs(str, stream) == EOF) {
        fprintf(stderr, "Failed to write to temporary file\n");
        fclose(stream);
        exit(1);
    }

    rewind(stream); // Rewind the file to the beginning
    return stream;
}

FILE *removeComments(FILE *source) {
    FILE *tempStream = createTempStream("");
    int ch, prev = EOF;
    int isComment = 0, skipLineStart = 0, isEscapeChar = 0;

    while ((ch = fgetc(source)) != EOF) {
        if (isComment) {
            if (ch == '\n') {
                isComment = 0;
                skipLineStart = 1;
            }
        } else {
            if (ch == '\\' && !isEscapeChar) {
                isEscapeChar = 1; // Set flag if escape character is encountered
            } else if (ch == '%' && !isEscapeChar) {
                isComment = 1;
            } else if (skipLineStart && (ch == ' ' || ch == '\t')) {
                continue; // Skip leading blanks/tabs
            } else {
                skipLineStart = 0;
                if (isEscapeChar && ch != '%') {
                    // If it was an escape character but not before '%', write the escape character
                    fputc('\\', tempStream);
                }
                fputc(ch, tempStream);
                isEscapeChar = 0; // Reset escape character flag
            }
        }
        prev = ch;
    }
    prev = EOF;
    if (!isComment && prev != EOF) {
        fputc(prev, tempStream); // Write the last character if needed
    }

    rewind(tempStream);
    return tempStream;
}

void concatenateTempStreams(FILE *dest, FILE *src) {
    char buffer[1024];
    while (fgets(buffer, sizeof(buffer), src) != NULL) {
        fputs(buffer, dest);
    }
}

char *expandMacrosInSubstring(const char *substring, MacroNode **macroList) {
    DynamicString *processedString = createDynamicString(strlen(substring) + 1);
    if (!processedString) {
        fprintf(stderr, "Failed to initialize dynamic string\n");
        return NULL;
    }
    appendToDynamicString(processedString, substring);

    int macrosExpanded;
    
    do {
        macrosExpanded = 0;
        DynamicString *tempString = createDynamicString(processedString->capacity);
        size_t index = 0;

        while (index < processedString->size) {
            if (processedString->data[index] == '\\' && processedString->size != 1) {
                char macroName[1024] = {0}, macroArg[1024] = {0};
                size_t nextIndex = extractMacroDetails(processedString->data, index, macroName, macroArg);

                if (isBuiltInMacro(macroName)) {
                    // Process built-in macro
                    processBuiltInMacros(processedString, macroName, &index, tempString, macroList);
                    nextIndex = index;
                } else {
                    // Process user-defined macro
                    MacroNode *foundMacro = findMacroNode(*macroList, macroName);
                    if (foundMacro) {
                        char *expandedMacro = replacePlaceholder(foundMacro->value, macroArg);
                        appendToDynamicString(tempString, expandedMacro);
                        free(expandedMacro);
                    } else {
                        // Append unprocessed macro text
                        // appendMacroText(tempString, processedString->data + index, nextIndex - index);
                        fprintf(stderr, "Error: Macro '%s' not found\n", macroName);
                        exit(1);
                    }
                }

                macrosExpanded = 1;
                index = nextIndex;
            } else {
                appendCharToDynamicString(tempString, processedString->data[index]);
                index++;
            }
        }
        freeDynamicString(processedString);
        processedString = tempString;
    } while (macrosExpanded);

    char *result = string_copy(processedString->data);
    freeDynamicString(processedString);
    return result;
}

int isBuiltInMacro(const char *macroName) {
    static const char *builtInMacros[] = {"def", "undef", "include", "if", "ifdef", "expandafter"};
    size_t numBuiltInMacros = sizeof(builtInMacros) / sizeof(builtInMacros[0]);

    for (size_t i = 0; i < numBuiltInMacros; i++) {
        if (strcmp(macroName, builtInMacros[i]) == 0) {
            return 1; // It's a built-in macro
        }
    }
    return 0; // Not a built-in macro
}

void appendCharToDynamicString(DynamicString *dynamicString, char ch) {
    if (dynamicString->size + 1 >= dynamicString->capacity) {
        // Resize the dynamic string
        dynamicString->data = DOUBLE(dynamicString->data, dynamicString->capacity);
        if (!dynamicString->data) {
            fprintf(stderr, "Failed to resize dynamic string\n");
            exit(1);
        }
    }

    dynamicString->data[dynamicString->size] = ch;
    dynamicString->size++;
    dynamicString->data[dynamicString->size] = '\0'; // Ensure null termination
}

void appendMacroText(DynamicString *dynamicString, const char *text, size_t textLength) {
    while (dynamicString->size + textLength >= dynamicString->capacity) {
        // Resize the dynamic string
        dynamicString->data = DOUBLE(dynamicString->data, dynamicString->capacity);
        if (!dynamicString->data) {
            fprintf(stderr, "Failed to resize dynamic string\n");
            exit(1);
        }
    }

    strncpy(dynamicString->data + dynamicString->size, text, textLength);
    dynamicString->size += textLength;
    dynamicString->data[dynamicString->size] = '\0'; // Ensure null termination
}

size_t extractMacroDetails(const char *str, size_t index, char *macroName, char *macroArg) {
    size_t i = index + 1; // Skip the backslash
    size_t nameLen = 0;
    
    // Extract macro name
    while (str[i] != '{' && str[i] != '\0' && nameLen < 1023) {
        macroName[nameLen++] = str[i++];
    }
    macroName[nameLen] = '\0';

    if (str[i] != '{') {
        fprintf(stderr, "Error: Macro argument not properly enclosed with braces\n");
        exit(1);
    }

    // Extract macro argument
    i++; // Skip the opening brace
    size_t argLen = 0;
    int braceCount = 1;
    while (str[i] != '\0' && argLen < 1023) {
        if (str[i] == '{') {
            braceCount++;
        } else if (str[i] == '}') {
            braceCount--;
            if (braceCount == 0) {
                break; // Closing brace of macro argument
            }
        }
        macroArg[argLen++] = str[i++];
    }
    macroArg[argLen] = '\0';

    if (braceCount != 0) {
        fprintf(stderr, "Error: Unbalanced braces in macro argument\n");
        exit(1);
    }

    return i + 1; // Return the index after the closing brace
}

void processBuiltInMacros(DynamicString *sourceString, const char *macro, size_t *index, DynamicString *targetString, MacroNode **macroList) {

    if (strcmp(macro, "def") == 0) {
        char *macroName = NULL;
        char *macroValue = NULL;

        extractDefDetails(sourceString->data, index, &macroName, &macroValue);
        if (findMacroNode(*macroList, macroName) != NULL) {
            fprintf(stderr, "Error: Macro '%s' already exists\n", macroName);
            exit(1); 
        }

        MacroNode *newNode = createMacroNode(macroName, macroValue);
        insertMacroNode(macroList, newNode);

        // Free dynamically allocated memory
        free(macroName);
        free(macroValue);
    } else if (strcmp(macro, "undef") == 0) {
        char *macroName = NULL;
        extractName(sourceString->data, index, &macroName);

        // Check if the macro exists before deleting
        MacroNode *existingMacro = findMacroNode(*macroList, macroName);
        if (existingMacro) {
            deleteMacroNode(macroList, macroName);
        } else {
            fprintf(stderr, "Error: Macro '%s' not found for undef\n", macroName);
            exit(1); 
        }

        free(macroName);
    } else if (strcmp(macro, "include") == 0) {
        char filePath[1024] = {0};
        extractFilePath(sourceString->data, index, filePath);
        processInclude(targetString, filePath, macroList);
    } else if (strcmp(macro, "if") == 0) {
        char cond[1024], thenPart[1024], elsePart[1024];
        parseIfDetails(sourceString->data, index, cond, thenPart, elsePart);
        appendConditionalResult(targetString, cond, thenPart, elsePart);
    } else if (strcmp(macro, "ifdef") == 0) {
        char macroName[1024], thenPart[1024], elsePart[1024];
        parseIfdefDetails(sourceString->data, index, macroName, thenPart, elsePart, macroList);
        appendConditionalResult(targetString, findMacroNode(*macroList, macroName) ? "1" : "", thenPart, elsePart);
    } else if (strcmp(macro, "expandafter") == 0) {
        char before[1024] = {0}, after[1024] = {0};
        parseExpandAfterDetails(sourceString->data, index, before, after);
        processExpandAfter(targetString, before, after, macroList);
    }
}

void extractDefDetails(const char *str, size_t *index, char **macroName, char **macroValue) {
    size_t i = *index + 5; // Skip past "\def{"
    size_t nameLen = 0;

    // Extract macro name
    *macroName = malloc(1024 * sizeof(char));
    if (!(*macroName)) {
        fprintf(stderr, "Error: Memory allocation failed\n");
        exit(1);
    }

    while (str[i] != '}' && str[i] != '\0' && nameLen < 1023) {
        (*macroName)[nameLen++] = str[i++];
    }
    (*macroName)[nameLen] = '\0';

    if (str[i] != '}' || str[++i] != '{') {
        fprintf(stderr, "Error: Malformed def macro\n");
        exit(1);
    }

    // Extract macro value
    i++; // Skip past '{'
    size_t valueLen = 0;
    int braceCount = 1;

    *macroValue = malloc(1024 * sizeof(char));
    if (!(*macroValue)) {
        fprintf(stderr, "Error: Memory allocation failed\n");
        exit(1);
    }

    while (str[i] != '\0' && valueLen < 1023) {
        if (str[i] == '{') {
            braceCount++;
        } else if (str[i] == '}') {
            braceCount--;
            if (braceCount == 0) {
                break; // Closing brace of macro value
            }
        }
        (*macroValue)[valueLen++] = str[i++];
    }
    (*macroValue)[valueLen] = '\0';

    if (braceCount != 0) {
        fprintf(stderr, "Error: Unbalanced braces in def macro\n");
        exit(1);
    }

    *index = i + 1; // Update index
}

void extractName(const char *str, size_t *index, char **name) {
    size_t i = *index + strlen("\\undef{"); // Skip past "\undef{"
    size_t nameLen = 0;

    // Dynamically allocate memory for name
    *name = malloc(1024 * sizeof(char));
    if (!*name) {
        fprintf(stderr, "Error: Memory allocation failed\n");
        exit(1);
    }

    while (str[i] != '}' && str[i] != '\0' && nameLen < 1023) {
        (*name)[nameLen++] = str[i++];
    }
    (*name)[nameLen] = '\0';

    if (str[i] != '}') {
        fprintf(stderr, "Error: Malformed undef macro\n");
        exit(1);
    }

    *index = i + 1; // Update index
}

void processInclude(DynamicString *dynamicString, const char *filePath, MacroNode **macroList) {
    FILE *includedFile = fopen(filePath, "r");
    if (!includedFile) {
        fprintf(stderr, "Error: Unable to open included file %s\n", filePath);
        exit(1);
    }

    char ch;
    // Read all characters from the included file and append them to dynamicString
    while ((ch = fgetc(includedFile)) != EOF) {
        appendCharToDynamicString(dynamicString, ch);
    }

    fclose(includedFile);
}

void extractFilePath(const char *str, size_t *index, char *filePath) {
    size_t i = *index + 9; // Skip past "\include{"
    size_t pathLen = 0;

    while (str[i] != '}' && str[i] != '\0' && pathLen < 1023) {
        filePath[pathLen++] = str[i++];
    }
    filePath[pathLen] = '\0';

    if (str[i] != '}') {
        fprintf(stderr, "Error: Malformed include macro\n");
        exit(1);
    }

    *index = i + 1; // Update index
}

void processExpandAfter(DynamicString *dynamicString, const char *before, const char *after, MacroNode **macroList) {
    char *expandedAfter = expandMacrosInSubstring(after, macroList);
    appendToDynamicString(dynamicString, before);
    appendToDynamicString(dynamicString, expandedAfter);
    free(expandedAfter);
}

void parseExpandAfterDetails(const char *str, size_t *index, char *before, char *after) {
    size_t i = *index + strlen("\\expandafter{"); // Skip past "\expandafter{"
    
    // Extract the BEFORE part
    size_t beforeLen = 0;
    int beforeNestingLevel = 1; // Start with a nesting level of 1
    while (str[i] != '\0' && beforeLen < 1023) {
        if (str[i] == '{') {
            beforeNestingLevel++;
        } else if (str[i] == '}') {
            beforeNestingLevel--;
            if (beforeNestingLevel == 0) {
                break; // End of the BEFORE part
            }
        }
        before[beforeLen++] = str[i++];
    }
    before[beforeLen] = '\0';

    if (beforeNestingLevel != 0) {
        fprintf(stderr, "Error: Malformed expandafter macro, unbalanced brackets in BEFORE part\n");
        exit(1);
    }
    i++; // Skip the closing brace of the BEFORE part

    if (str[i] != '{') {
        fprintf(stderr, "Error: Malformed expandafter macro, missing '{' before AFTER part\n");
        exit(1);
    }
    i++; // Skip past '{' to start reading the AFTER part

    // Extract the AFTER part
    size_t afterLen = 0;
    int afterNestingLevel = 1; // Start with a nesting level of 1
    while (str[i] != '\0' && afterLen < 1023) {
        if (str[i] == '{') {
            afterNestingLevel++;
        } else if (str[i] == '}') {
            afterNestingLevel--;
            if (afterNestingLevel == 0) {
                break; // End of the AFTER part
            }
        }
        after[afterLen++] = str[i++];
    }
    after[afterLen] = '\0';

    if (afterNestingLevel != 0) {
        fprintf(stderr, "Error: Malformed expandafter macro, unbalanced brackets in AFTER part\n");
        exit(1);
    }

    *index = i + 1; // Update index to the character after the closing brace of AFTER part
}



void parseIfDetails(const char *str, size_t *index, char *cond, char *thenPart, char *elsePart) {
    size_t i = *index + strlen("\\if"); // Move past "\if" only

    // Extract the condition
    i = extractConditionalPart(str, i, cond);

    // Extract the then-part
    i = extractConditionalPart(str, i, thenPart);

    // Extract the else-part
    i = extractConditionalPart(str, i, elsePart);

    *index = i;
}

size_t extractConditionalPart(const char *str, size_t i, char *part) {
    if (str[i] != '{') {
        fprintf(stderr, "Error: Malformed if macro, missing '{'\n");
        exit(1);
    }
    i++; // Skip the opening brace

    size_t len = 0;
    int braceCount = 1; // Start after the opening brace
    while (str[i] != '\0' && braceCount > 0 && len < 1023) {
        if (str[i] == '{') {
            braceCount++;
        } else if (str[i] == '}') {
            braceCount--;
        }

        if (braceCount > 0) {
            part[len++] = str[i];
        }
        i++;
    }
    part[len] = '\0'; // Null-terminate the string

    if (braceCount != 0) {
        fprintf(stderr, "Error: Unbalanced braces in if macro\n");
        exit(1);
    }

    return i;
}


void parseIfdefDetails(const char *str, size_t *index, char *macroName, char *thenPart, char *elsePart, MacroNode **macroList) {
    size_t i = *index + strlen("\\ifdef{"); // Move past "\\ifdef{"

    // Extract the macro name
    i = extractConditionalPart(str, i, macroName);

    // Extract the then-part
    i = extractConditionalPart(str, i, thenPart);

    // Extract the else-part
    i = extractConditionalPart(str, i, elsePart);

    *index = i;
}

void appendConditionalResult(DynamicString *dynamicString, const char *condition, const char *thenPart, const char *elsePart) {
    if (condition && condition[0] != '\0') {
        // Condition is true (non-empty for \if, "1" for \ifdef)
        appendToDynamicString(dynamicString, thenPart);
    } else {
        // Condition is false (empty string)
        appendToDynamicString(dynamicString, elsePart);
    }
}

void readMacroArgument(FILE *file, char *buffer, size_t bufferSize) {
    int ch, i = 0;
    int braceCount = 0;
    bool insideBraces = false;

    while ((ch = fgetc(file)) != EOF && i < bufferSize - 1) {
        if (ch == '{' && !insideBraces) {
            insideBraces = true;
            braceCount++;
            continue;
        } else if (ch == '{') {
            braceCount++;
        } else if (ch == '}') {
            braceCount--;
            if (braceCount == 0) break;
        }

        if (insideBraces) {
            buffer[i++] = ch;
        }
    }
    buffer[i] = '\0'; // Null-terminate the string

    if (braceCount != 0) {
        fprintf(stderr, "Error: Unbalanced braces in macro argument\n");
        exit(1);
    }
}

void clearDynamicString(DynamicString *str) {
    if (str && str->data) {
        // Set the first character to null terminator, effectively clearing the string
        str->data[0] = '\0';
        // Reset the size of the string to 0
        str->size = 0;
    }
}

void expandMacrosUsingStack(DynamicString *dynamicString, MacroNode **macroList) {
    reverseString(dynamicString->data); // Convert dynamicString to a stack

    DynamicString *resultString = createDynamicString(dynamicString->capacity);
    if (!resultString) {
        fprintf(stderr, "Failed to initialize result dynamic string\n");
        exit(1);
    }

    while (dynamicString->size > 0) {
        char ch = popCharFromDynamicString(dynamicString);

        if (ch == '\\') {
            // Extract the macro name and arguments from the stack
            if (handleEscapeCharacter(dynamicString, resultString)) {
                continue;
            } else {
                char *macroName = NULL;
                extractMacroNameFromStack(dynamicString, &macroName); 
                
                // Check if it's a built-in macro or a user-defined macro
                if (isBuiltInMacro(macroName)) {
                    // Process the built-in macro directly from the stack and push the result back to the stack
                    DynamicString *tempString = createDynamicString(1024);
                    processBuiltInMacrosFromStack(dynamicString, macroName, tempString, macroList);
                    pushStringToDynamicString(dynamicString, tempString->data);
                    freeDynamicString(tempString);
                } else {
                    // Process a user-defined macro
                    char *macroArg = NULL;
                    extractMacroArgFromStack(dynamicString, &macroArg);

                    // Find and expand the macro
                    MacroNode *foundMacro = findMacroNode(*macroList, macroName);
                    if (foundMacro) {
                        char *expandedMacro = replacePlaceholder(foundMacro->value, macroArg);
                        pushStringToDynamicString(dynamicString, expandedMacro);

                        // Free the dynamically allocated memory for macroArg and expandedMacro
                        free(macroArg);
                        free(expandedMacro);
                    } else {
                        // Free the dynamically allocated memory for macroArg
                        free(macroArg);
                    }
                }
                free(macroName);
            }
            
        } else {
            appendCharToDynamicString(resultString, ch);
        }
    }

    // Replace the original dynamicString's data with the resultString's data
    free(dynamicString->data);
    dynamicString->data = resultString->data;
    dynamicString->size = resultString->size;
    dynamicString->capacity = resultString->capacity;
    free(resultString); // Free only the structure, not the data
}

bool handleEscapeCharacter(DynamicString *dynamicString, DynamicString *resultString) {
    if (dynamicString->size == 0) {
        // Nothing to handle if dynamicString is empty
        return false;
    }

    // Get the first character from dynamicString
    char ch = popCharFromDynamicString(dynamicString);

    if (ch == '\\' || ch == '#' || ch == '%' || ch == '{' || ch == '}') {
        appendCharToDynamicString(resultString, ch);
        return true;
    } else if ((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9')) {
        char temp[2] = {ch, '\0'};
        pushStringToDynamicString(dynamicString, temp);
        return false;
    } else {
        appendCharToDynamicString(resultString, '\\');
        appendCharToDynamicString(resultString, ch);
        return true;
    }
}


void reverseString(char *str) {
    int length = strlen(str);
    for (int i = 0; i < length / 2; ++i) {
        char temp = str[i];
        str[i] = str[length - i - 1];
        str[length - i - 1] = temp;
    }
}

char popCharFromDynamicString(DynamicString *str) {
    if (str->size == 0) {
        fprintf(stderr, "Error: Attempt to pop from empty string\n");
        exit(EXIT_FAILURE);
    }

    char popChar = str->data[str->size - 1];
    str->data[str->size - 1] = '\0'; // Null terminate the string
    str->size--;

    return popChar;
}

void pushStringToDynamicString(DynamicString *str, const char *text) {
    // Copy and reverse the text before pushing
    char *reversedText = string_copy(text);
    if (!reversedText) {
        fprintf(stderr, "Error: Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    reverseString(reversedText);

    // Check capacity and resize if necessary
    size_t textLength = strlen(reversedText);
    while (str->size + textLength >= str->capacity) {
        str->data = (char*)DOUBLE(str->data, str->capacity);
        if (!str->data) {
            fprintf(stderr, "Error: Memory reallocation failed\n");
            exit(EXIT_FAILURE);
        }
    }

    // Append the reversed text
    strcat(str->data, reversedText);
    str->size += textLength;

    free(reversedText);
}

void extractMacroFromStack(DynamicString *dynamicString, char *macroName, char *macroArg) {
    int indexName = 0, indexArg = 0, braceCount = 0;
    int readingArg = 0;
    char ch;

    // Pop characters to get macro name and argument
    while (dynamicString->size > 0) {
        ch = popCharFromDynamicString(dynamicString);

        // Check for the start or end of the macro argument
        if (ch == '{') {
            braceCount++;
            if (braceCount == 1) {
                readingArg = 1;
                continue;
            }
        } else if (ch == '}') {
            braceCount--;
            if (braceCount == 0) {
                break;
            }
        }

        // Store characters in macroName or macroArg
        if (readingArg) {
            macroArg[indexArg++] = ch;
        } else {
            macroName[indexName++] = ch;
        }
    }

    // Null-terminate the strings
    macroName[indexName] = '\0';
    macroArg[indexArg] = '\0';

    if (braceCount != 0) {
        fprintf(stderr, "Error: Unbalanced braces in macro argument\n");
        exit(1);
    }
}

void processBuiltInMacrosFromStack(DynamicString *sourceString, const char *macro, DynamicString *targetString, MacroNode **macroList) {

    if (strcmp(macro, "def") == 0) {
        char *macroName = NULL;
        char *macroValue = NULL;
        extractDefDetailsFromStack(sourceString, &macroName, &macroValue);
        // Check if the macro already exists in the list
        if (findMacroNode(*macroList, macroName) != NULL) {
            fprintf(stderr, "Error: Macro '%s' already exists\n", macroName);
            exit(1); // Replace 1 with your desired error code
        }
        MacroNode *newNode = createMacroNode(macroName, macroValue);
        insertMacroNode(macroList, newNode);
        free(macroName);
        free(macroValue);
    } else if (strcmp(macro, "undef") == 0) {
        char *macroName = NULL;
        extractMacroArgFromStack(sourceString, &macroName);
        MacroNode *existingMacro = findMacroNode(*macroList, macroName);
        if (existingMacro) {
            deleteMacroNode(macroList, macroName);
        } else {
            fprintf(stderr, "Warning: Attempted to undefine non-existent macro '%s'\n", macroName);
        }
        free(macroName);
    } else if (strcmp(macro, "include") == 0) {
        char filePath[1024] = {0};
        extractFilePathFromStack(sourceString, filePath);
        processInclude(targetString, filePath, macroList);
    } else if (strcmp(macro, "if") == 0) {
        char cond[1024], thenPart[1024], elsePart[1024];
        parseIfDetailsFromStack(sourceString, cond, thenPart, elsePart);
        appendConditionalResult(targetString, cond, thenPart, elsePart);
    } else if (strcmp(macro, "ifdef") == 0) {
        char macroName[1024], thenPart[1024], elsePart[1024];
        parseIfdefDetailsFromStack(sourceString, macroName, thenPart, elsePart);
        appendConditionalResult(targetString, findMacroNode(*macroList, macroName) ? "1" : "", thenPart, elsePart);
    } else if (strcmp(macro, "expandafter") == 0) {
        char before[1024] = {0}, after[1024] = {0};
        parseExpandAfterDetailsFromStack(sourceString, before, after);
        processExpandAfter(targetString, before, after, macroList);
    }
}

void extractDefDetailsFromStack(DynamicString *sourceString, char **macroName, char **macroValue) {
    size_t nameCapacity = 1024, valueCapacity = 1024; // Initial capacities
    *macroName = malloc(nameCapacity * sizeof(char));
    *macroValue = malloc(valueCapacity * sizeof(char));
    if (!*macroName || !*macroValue) {
        fprintf(stderr, "Error: Memory allocation failed\n");
        exit(1);
    }

    size_t nameLen = 0, valueLen = 0;
    char ch;
    int braceCount = 1; // Start with 1 for the initial opening brace

    // Skip the initial opening brace
    if (sourceString->size > 0 && popCharFromDynamicString(sourceString) != '{') {
        fprintf(stderr, "Error: Expected opening brace at the start\n");
        exit(1);
    }

    // First loop to read macro name
    while (sourceString->size > 0 && (ch = popCharFromDynamicString(sourceString)) != '}') {
        if (!isalnum(ch)) {
            fprintf(stderr, "Error: Non-alphanumeric character encountered in macro name\n");
            exit(1);
        }
        if (nameLen >= nameCapacity - 1) {
            *macroName = DOUBLE(*macroName, nameCapacity);
            if (!*macroName) {
                fprintf(stderr, "Error: Memory reallocation failed\n");
                exit(1);
            }
        }
        (*macroName)[nameLen++] = ch;
    }
    (*macroName)[nameLen] = '\0'; // Null-terminate the macro name
    braceCount--;

    if (ch != '}') {
        fprintf(stderr, "Error: Expected closing brace for macro name\n");
        exit(1);
    }

    // Second loop to read macro value
    ch = popCharFromDynamicString(sourceString);
    braceCount++;
    while (sourceString->size > 0 && braceCount > 0) {
        ch = popCharFromDynamicString(sourceString);
        if (ch == '{') {
            braceCount++;
        } else if (ch == '}') {
            braceCount--;
        }
        if (braceCount > 0) {
            if (valueLen >= valueCapacity - 1) {
                *macroValue = DOUBLE(*macroValue, valueCapacity);
                if (!*macroValue) {
                    fprintf(stderr, "Error: Memory reallocation failed\n");
                    exit(1);
                }
            }
            (*macroValue)[valueLen++] = ch;
        }
    }
    (*macroValue)[valueLen] = '\0'; // Null-terminate the macro value

    if (braceCount != 0) {
        fprintf(stderr, "Error: Unbalanced braces in macro value\n");
        exit(1);
    }
}

void extractMacroNameFromStack(DynamicString *stack, char **macroName) {
    int len = 0;
    char ch;
    size_t argCapacity = 1024;

    // Check the top character of the stack before popping
    while (stack->size > 0 && stack->data[stack->size - 1] != '{') {
        ch = popCharFromDynamicString(stack);
        if (len == 0) {
            // Allocate memory for macroName if it's the first character
            *macroName = malloc(argCapacity * sizeof(char));
            if (!*macroName) {
                fprintf(stderr, "Error: Memory allocation failed\n");
                exit(1);
            }
        }
        (*macroName)[len++] = ch;
        if (len >= argCapacity - 1) {
            // Resize the allocated memory using DOUBLE macro
            *macroName = DOUBLE(*macroName, argCapacity);
            if (!*macroName) {
                fprintf(stderr, "Error: Memory reallocation failed\n");
                exit(1);
            }
        }
    }

    if (len > 0) {
        (*macroName)[len] = '\0'; // Null-terminate the macro name
    } else {
        // If no characters were read, free the allocated memory
        free(*macroName);
        *macroName = NULL;
    }
}

void extractFilePathFromStack(DynamicString *sourceString, char *filePath) {
    size_t pathLen = 0;
    char ch, prevCh = 0; // prevCh to track the previous character
    int braceCount = 0;  // To track the number of opening braces
    bool isEscaped = false; // Flag to indicate if the current character is escaped

    // Skip the initial opening brace '{'
    if (sourceString->size > 0 && popCharFromDynamicString(sourceString) != '{') {
        fprintf(stderr, "Error: Expected opening brace '{' at the start\n");
        exit(1);
    }

    while (sourceString->size > 0) {
        ch = popCharFromDynamicString(sourceString);

        if (prevCh == '\\' && !isEscaped) {
            isEscaped = true; // Current character is escaped
        } else {
            isEscaped = false; // Current character is not escaped
        }

        // Handle nested braces considering escape characters
        if (!isEscaped && ch == '{') {
            braceCount++;
        } else if (!isEscaped && ch == '}') {
            if (braceCount == 0) {
                // Closing brace of file path found
                break;
            }
            braceCount--;
        }

        filePath[pathLen++] = ch;
        prevCh = ch; // Update prevCh to the current character
    }

    filePath[pathLen] = '\0';  // Null-terminate the file path

    // Check for unbalanced braces
    if (braceCount != 0) {
        fprintf(stderr, "Error: Unbalanced braces in file path\n");
        exit(1);
    }
}

void parseIfDetailsFromStack(DynamicString *sourceString, char *cond, char *thenPart, char *elsePart) {
    extractConditionalPartFromStack(sourceString, cond);
    extractConditionalPartFromStack(sourceString, thenPart);
    extractConditionalPartFromStack(sourceString, elsePart);
}

void extractConditionalPartFromStack(DynamicString *sourceString, char *part) {
    size_t len = 0;
    int braceCount = 0;
    char ch;

    while (sourceString->size > 0) {
        ch = popCharFromDynamicString(sourceString);

        if (ch == '{') {
            if (braceCount == 0) {
                // Skip the first opening brace
                braceCount = 1;
                continue;
            } else {
                braceCount++;
            }
        } else if (ch == '}') {
            braceCount--;
            if (braceCount == 0) {
                break; // End of this conditional part
            }
        }

        part[len++] = ch;
    }

    part[len] = '\0'; // Null-terminate the string

    if (braceCount != 0) {
        fprintf(stderr, "Error: Unbalanced braces in if macro\n");
        exit(1);
    }
}

void parseIfdefDetailsFromStack(DynamicString *sourceString, char *macroName, char *thenPart, char *elsePart) {
    extractConditionalPartFromStack(sourceString, macroName); // Macro name
    extractConditionalPartFromStack(sourceString, thenPart);  // Then-part
    extractConditionalPartFromStack(sourceString, elsePart);  // Else-part
}

void parseExpandAfterDetailsFromStack(DynamicString *sourceString, char *before, char *after) {
    // Initialize lengths
    size_t beforeLen = 0, afterLen = 0;
    char ch;
    int braceCount = 0;

    // Extract the BEFORE part
    while ((ch = popCharFromDynamicString(sourceString)) != EOF && beforeLen < 1023) {
        if (ch == '{') {
            braceCount++;
            if (braceCount == 1) continue; // Skip the first opening brace
        } else if (ch == '}') {
            braceCount--;
            if (braceCount == 0) break; // Found closing brace of BEFORE part
        }
        before[beforeLen++] = ch;
    }
    before[beforeLen] = '\0';

    if (braceCount != 0) {
        fprintf(stderr, "Error: Malformed expandafter macro, unbalanced braces in BEFORE part\n");
        exit(1);
    }

    // Reset braceCount for AFTER part
    braceCount = 0;

    // Extract the AFTER part
    while ((ch = popCharFromDynamicString(sourceString)) != EOF && afterLen < 1023) {
        if (ch == '{') {
            braceCount++;
            if (braceCount == 1) continue; // Skip the first opening brace
        } else if (ch == '}') {
            braceCount--;
            if (braceCount == 0) break; // Found closing brace of AFTER part
        }
        after[afterLen++] = ch;
    }
    after[afterLen] = '\0';

    if (braceCount != 0) {
        fprintf(stderr, "Error: Malformed expandafter macro, unbalanced braces in AFTER part\n");
        exit(1);
    }
}

void extractMacroArgFromStack(DynamicString *stack, char **macroArg) {
    size_t argCapacity = 1024; // Initial capacity
    *macroArg = malloc(argCapacity * sizeof(char));
    if (!*macroArg) {
        fprintf(stderr, "Error: Memory allocation failed for macro argument\n");
        exit(1);
    }

    int len = 0, braceCount = 1;
    char ch, prevCh = 0; // prevCh to track the previous character
    bool isEscaped = false; // Track if the current character is escaped

    // Skip the opening brace '{' by popping it
    if (stack->size > 0) {
        popCharFromDynamicString(stack);
    }

    // Extract characters until the closing brace '}' is encountered
    while (stack->size > 0 && braceCount > 0) {
        ch = popCharFromDynamicString(stack);

        if (prevCh == '\\' && !isEscaped) {
            isEscaped = true; // Current character is escaped
        } else {
            isEscaped = false; // Current character is not escaped
        }

        if (ch == '}' && !isEscaped) {
            braceCount--;
            if (braceCount == 0) {
                break; // Stop extracting as the closing brace is reached
            }
        } else if (ch == '{' && !isEscaped) {
            braceCount++;
        }

        // Resize if necessary
        if (len >= argCapacity - 1) {
            *macroArg = DOUBLE(*macroArg, argCapacity);
            if (!*macroArg) {
                fprintf(stderr, "Error: Memory reallocation failed for macro argument\n");
                exit(1);
            }
        }

        (*macroArg)[len++] = ch;
        prevCh = ch; // Update prevCh to the current character
    }

    (*macroArg)[len] = '\0'; // Null-terminate the macro argument
    if (braceCount != 0) {
        fprintf(stderr, "Error: Unbalanced braces in macro argument\n");
        exit(1);
    }
}






































