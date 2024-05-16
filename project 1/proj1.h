// proj1.h                                          Stan Eisenstat (09/17/15)
//
// System header files and macros for proj1

#define _GNU_SOURCE
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
 
// Write message to stderr using format FORMAT
#define WARN(format,...) fprintf (stderr, "proj1: " format "\n", __VA_ARGS__)

// Write message to stderr using format FORMAT and exit.
#define DIE(format,...)  WARN(format,__VA_ARGS__), exit (EXIT_FAILURE)

// Double the size of an allocated block PTR with NMEMB members and update
// NMEMB accordingly.  (NMEMB is only the size in bytes if PTR is a char *.)
#define DOUBLE(ptr,nmemb) realloc (ptr, (nmemb *= 2) * sizeof(*ptr))

#define INITIAL_MACRO_NAME_SIZE 1024
#define INITIAL_MACRO_VALUE_SIZE 1024

typedef struct MacroNode {
    char *name;             // Name of the macro
    char *value;       // Definition or replacement text of the macro
    struct MacroNode *next; // Pointer to the next node
} MacroNode;

typedef struct {
    char *data;     // Pointer to the character array
    size_t size;  // Current length of the string
    size_t capacity; // Current allocated capacity
} DynamicString;

void processMacros(FILE *file, MacroNode **head, DynamicString *dynamicString);

void readMacroName(FILE *file, char *macro);

char *parseMacroName(FILE *file);

char *parseMacroValue(FILE *file);

char *parseMacroArgument(FILE *file);

bool handleEscapeCharacterFromFile(FILE *file, DynamicString *dynamicString);

MacroNode *createMacroNode(const char *name, const char *value);

void insertMacroNode(MacroNode **head, MacroNode *newNode);

void freeMacroNode(MacroNode *node);

void freeMacroList(MacroNode *head);

char *string_copy(const char *s);

MacroNode *findMacroNode(MacroNode *head, const char *macroName);

void deleteMacroNode(MacroNode **head, const char *name);

DynamicString *createDynamicString(size_t initialCapacity);

void appendToDynamicString(DynamicString *str, const char *text);

void freeDynamicString(DynamicString *str);

void printDynamicString(const DynamicString *str);

char *replacePlaceholder(const char *macroDefinition, const char *replacement);

void parseIfMacro(FILE *file, char *cond, char *thenPart, char *elsePart, size_t argSize);

void parseExpandAfter(FILE *file, char *before, char *after, size_t argSize);

FILE *createTempStream(const char *str);

FILE *removeComments(FILE *source);

void concatenateTempStreams(FILE *dest, FILE *src);

char *expandMacrosInSubstring(const char *substring, MacroNode **macroList);

int isBuiltInMacro(const char *macroName);

void appendCharToDynamicString(DynamicString *dynamicString, char ch);

void appendMacroText(DynamicString *dynamicString, const char *text, size_t textLength);

size_t extractMacroDetails(const char *str, size_t index, char *macroName, char *macroArg);

void processBuiltInMacros(DynamicString *sourceString, const char *macro, size_t *index, DynamicString *targetString, MacroNode **macroList);

void extractDefDetails(const char *str, size_t *index, char **macroName, char **macroValue);

void extractName(const char *str, size_t *index, char **name);

void processInclude(DynamicString *dynamicString, const char *filePath, MacroNode **macroList);

void extractFilePath(const char *str, size_t *index, char *filePath);

void processExpandAfter(DynamicString *dynamicString, const char *before, const char *after, MacroNode **macroList);

void parseExpandAfterDetails(const char *str, size_t *index, char *before, char *after);

void parseIfDetails(const char *str, size_t *index, char *cond, char *thenPart, char *elsePart);

size_t extractConditionalPart(const char *str, size_t i, char *part);

void parseIfdefDetails(const char *str, size_t *index, char *macroName, char *thenPart, char *elsePart, MacroNode **macroList);

void appendConditionalResult(DynamicString *dynamicString, const char *condition, const char *thenPart, const char *elsePart);

void readMacroArgument(FILE *file, char *buffer, size_t bufferSize);

void clearDynamicString(DynamicString *str);

void expandMacrosUsingStack(DynamicString *dynamicString, MacroNode **macroList);

bool handleEscapeCharacter(DynamicString *dynamicString, DynamicString *resultString);

void reverseString(char *str);

char popCharFromDynamicString(DynamicString *str);

void pushStringToDynamicString(DynamicString *str, const char *text);

void extractMacroFromStack(DynamicString *dynamicString, char *macroName, char *macroArg);

void processBuiltInMacrosFromStack(DynamicString *sourceString, const char *macro, DynamicString *targetString, MacroNode **macroList);

void extractDefDetailsFromStack(DynamicString *sourceString, char **macroName, char **macroValue);

void extractFilePathFromStack(DynamicString *sourceString, char *filePath);

void parseIfDetailsFromStack(DynamicString *sourceString, char *cond, char *thenPart, char *elsePart);

void extractConditionalPartFromStack(DynamicString *sourceString, char *part);

void parseIfdefDetailsFromStack(DynamicString *sourceString, char *macroName, char *thenPart, char *elsePart);

void parseExpandAfterDetailsFromStack(DynamicString *sourceString, char *before, char *after);

void extractMacroNameFromStack(DynamicString *stack, char **macroName);

void extractMacroArgFromStack(DynamicString *stack, char **macroArg);

