#define M61_DISABLE 1
#include "dmalloc.hh"
#include <cstdlib>
#include <cstring>
#include <cstdio>
#include <cinttypes>
#include <cassert>

// You may write code here.
// (Helper functions, types, structs, macros, globals, etc.)

#include <iostream>
#include <unordered_map>
#include <vector>
#include <algorithm>
#include <functional>
#include <iomanip>

using namespace std;

#define CANARY_SIZE 200 // Size of the canary regions
#define CANARY_PATTERN 0xDEADBEEF // The canary pattern

// Definition of metadataHeader
typedef struct metadataHeader {
    size_t size;
    const char* file;
    long line;
    void* ptr;
    struct metadataHeader* next;
} metadataHeader;

// Global head of linkedlist storing metadataHeaders
static metadataHeader* head = NULL;

typedef struct FreedPointerNode {
    void* ptr;
    struct FreedPointerNode* next;
} FreedPointerNode;

FreedPointerNode* freedPointersHead = NULL;

// Declaration of the global stats variable
struct dmalloc_statistics stats_ptr = {
    .nactive = 0,
    .active_size = 0,
    .ntotal = 0,
    .total_size = 0,
    .nfail = 0,
    .fail_size = 0,
    .heap_min = (uintptr_t)-1, // Typically, initialize to maximum possible value
    .heap_max = 0
};

void insertFreedPointer(void* ptr) {
    FreedPointerNode* newNode = (FreedPointerNode*)malloc(sizeof(FreedPointerNode));
    if (!newNode) {
        fprintf(stderr, "Error: Failed to allocate memory for freed pointer tracking.\n");
        exit(EXIT_FAILURE);
    }
    newNode->ptr = ptr;
    newNode->next = freedPointersHead;
    freedPointersHead = newNode;
}

int isDoubleFree(void* ptr) {
    FreedPointerNode* current = freedPointersHead;
    while (current) {
        if (current->ptr == ptr) {
            return 1; // Pointer found, indicating a double free
        }
        current = current->next;
    }
    return 0; // Pointer not found, safe to free
}

// Function to fill canaries with the canary pattern
void fill_canary(void* start, size_t length) {
    uint32_t* p = (uint32_t*)start;
    for (size_t i = 0; i < length / sizeof(uint32_t); ++i) {
        p[i] = CANARY_PATTERN;
    }
}

// Check for any canary modifications
int check_canaries(metadataHeader* meta) {
    // Calculate pointers to the canary regions
    uint32_t* under_canary = (uint32_t*)((char*)(meta + 1));
    uint32_t* over_canary = (uint32_t*)((char*)meta->ptr + meta->size);
    
    // Check the underflow and overflow canaries
    for (size_t i = 0; i < CANARY_SIZE / sizeof(uint32_t); ++i) {
        if (under_canary[i] != CANARY_PATTERN || over_canary[i] != CANARY_PATTERN) {
            return (under_canary[i] != CANARY_PATTERN) ? -1 : 1; // -1 for underflow, 1 for overflow
        }
    }
    
    return 0; // No corruption detected
}

// Function to insert medatadataHeader at the beginnning of linkedlist
void* insert_metadataHeader(size_t sz, const char* file, long line) {
    // Calculate the total size needed for metadata, canaries, and user data
    size_t total_size;
    if (sz > SIZE_MAX - sizeof(metadataHeader) - (2 * CANARY_SIZE)) {
        // Potential overflow detected, handle accordingly
        return NULL;
    } else {
        total_size = sizeof(metadataHeader) + (2 * CANARY_SIZE) + sz;
    }
    
    // Allocate the memory block
    uintptr_t block_addr = (uintptr_t)base_malloc(total_size);
    if (block_addr == 0) {
        return NULL; // Allocation failed
    }
    
    // Initialize the metadataHeader
    metadataHeader* meta = (metadataHeader*)block_addr;
    meta->size = sz;
    meta->file = file;
    meta->line = line;
    
    // Set up the underflow canary
    uintptr_t under_canary_addr = block_addr + sizeof(metadataHeader);
    fill_canary((void*)under_canary_addr, CANARY_SIZE);
    
    // Calculate the pointer to the user data, after the underflow canary
    meta->ptr = (void*)(under_canary_addr + CANARY_SIZE);
    
    // Set up the overflow canary after the user data
    uintptr_t over_canary_addr = (uintptr_t)meta->ptr + sz;
    fill_canary((void*)over_canary_addr, CANARY_SIZE);
    
    // Insert the metadata at the beginning of the global list
    meta->next = head;
    head = meta;
    
    // Return the pointer to the user data portion
    return meta->ptr;
}

metadataHeader* findMetadataForInteriorPointer(void* user_ptr) {
    metadataHeader* current = head;
    uintptr_t ptr_addr = (uintptr_t)user_ptr;
    while (current != NULL) {
        uintptr_t block_start = (uintptr_t)(current + 1) + CANARY_SIZE; // Adjust based on actual layout
        uintptr_t block_end = block_start + current->size;
        if (ptr_addr >= block_start && ptr_addr < block_end) {
            return current; // Pointer is inside this block
        }
        current = current->next;
    }
    return NULL; // Not found within any block
}

// Function to remove a metadata header and free memory
void remove_metadataHeader(void* user_ptr, const char* file, long line) {
    if (!user_ptr) return; // Do nothing if the user pointer is NULL

    // Convert the user pointer back to the start of the block to access the metadataHeader
    uintptr_t user_addr = (uintptr_t)user_ptr;
    uintptr_t under_canary_addr = user_addr - CANARY_SIZE; // Address of the underflow canary
    uintptr_t meta_addr = under_canary_addr - sizeof(metadataHeader); // Address of the metadataHeader

    // Search for the metadataHeader in the global list before checking canaries
    metadataHeader** indirect = &head;
    while (*indirect && (uintptr_t)(*indirect) != meta_addr) {
        indirect = &(*indirect)->next;
    }

    // If metadataHeader is found in the list, check canaries and proceed
    if (*indirect) {
        metadataHeader* meta = *indirect; // Use found metadataHeader
        
        // Now that we have confirmed the block is part of our allocations, check canaries
        if (check_canaries(meta) != 0) {
            fprintf(stderr, "MEMORY BUG %s:%ld: detected wild write during free of pointer %p\n", meta->file, meta->line, user_ptr);
            exit(1);
        }

        // Update global stats
        stats_ptr.nactive--;
        stats_ptr.active_size -= meta->size;

        insertFreedPointer(user_ptr);

        // Remove the metadataHeader from the list
        *indirect = meta->next;

        // Clear data on memory
        memset(meta, 0, sizeof(metadataHeader) + 2 * CANARY_SIZE + meta->size);

        // Finally, free the entire block including metadata, canaries, and user data
        base_free((void*)meta_addr);
    } else {
        uintptr_t ptr_addr = (uintptr_t)user_ptr;
        metadataHeader* found = findMetadataForInteriorPointer(user_ptr);
        if (isDoubleFree(user_ptr)) {
            fprintf(stderr, "MEMORY BUG: %s:%ld: invalid free of pointer %p, double free\n", file, line, user_ptr);
            exit(1);
        } else if (ptr_addr < stats_ptr.heap_min || ptr_addr > stats_ptr.heap_max) {
            fprintf(stderr, "MEMORY BUG: %s:%ld: invalid free of pointer %p, not in heap\n", file, line, user_ptr);
            exit(1);
        } else {
            fprintf(stderr, "MEMORY BUG: %s:%ld: invalid free of pointer %p, not allocated\n", file, line, user_ptr);
            fprintf(stderr, "  %s:%ld: %p is %ld bytes inside a %ld byte region allocated here\n", found->file, found->line, user_ptr, ptr_addr - (uintptr_t)found->ptr, found->size);
            exit(1);
        } 
    }
}


void update_stats_malloc(void* ptr, size_t size, const char* file, long line) {
    (void)file; 
    (void)line;

    if (ptr == NULL) {
        // Allocation failed
        stats_ptr.nfail++;
        stats_ptr.fail_size += size;
        return;
    }

    // Successful allocation
    stats_ptr.ntotal++;
    stats_ptr.nactive++;
    stats_ptr.total_size += size;
    stats_ptr.active_size += size;
    uintptr_t addr = (uintptr_t)ptr;
    if (stats_ptr.heap_min == 0 || addr < stats_ptr.heap_min) {
        stats_ptr.heap_min = addr;
    }
    if (addr + size > stats_ptr.heap_max) {
        stats_ptr.heap_max = addr + size;
    }
}

// Hash map key: file and line
struct hashMapKey {
    string file;
    int line;
};

// Hash map value: memory allocated
struct hashMapValue {
    size_t total_bytes = 0;

    hashMapValue() = default; // Add default constructor
    hashMapValue(size_t bytes) : total_bytes(bytes) {}
};

// Hashing function
struct hashFunction {
    size_t operator()(const hashMapKey& k) const {
        return hash<string>()(k.file) ^ hash<int>()(k.line);
    }
};

// Function to validate hash map key
struct keyValidation {
    bool operator()(const hashMapKey& lhs, const hashMapKey& rhs) const {
        return lhs.file == rhs.file && lhs.line == rhs.line;
    }
};

// Hash map definition
unordered_map<hashMapKey, hashMapValue, hashFunction, keyValidation> memory_allocations;

// Update memory allocations in hash map
void update_allocations(const string& file, int line, size_t size) {
    hashMapKey key{file, line};
    memory_allocations[key].total_bytes += size;
}

// Print top N heavy hitters
void print_heavy_hitters(size_t count) {
    size_t total_bytes_allocated = 0;

    // Calculate the total allocated bytes in the entire hash map
    for (const auto& entry : memory_allocations) {
        total_bytes_allocated += entry.second.total_bytes;
    }

    // Use vector to sort hash map
    vector<pair<hashMapKey, hashMapValue>> hashMapVector(memory_allocations.begin(), memory_allocations.end());

    // Sort hash maps in descending order of total_bytes allocated
    sort(hashMapVector.begin(), hashMapVector.end(),
         [&](const auto& a, const auto& b) {
            return a.second.total_bytes > b.second.total_bytes;
         }
    );

    // Print top N allocations
    for (size_t i = 0; i < min(count, hashMapVector.size()); ++i) {
        const auto& alloc = hashMapVector[i];
        double percentage = static_cast<double>(alloc.second.total_bytes) * 100 / total_bytes_allocated;
        cout << fixed << setprecision(1) << "HEAVY HITTER: " << alloc.first.file << ":" << alloc.first.line
             << ": " << alloc.second.total_bytes << " bytes (~" << percentage << "%)\n";
    }
}

/// dmalloc_malloc(sz, file, line)
///    Return a pointer to `sz` bytes of newly-allocated dynamic memory.
///    The memory is not initialized. If `sz == 0`, then dmalloc_malloc must
///    return a unique, newly-allocated pointer value. The allocation
///    request was at location `file`:`line`.

void* dmalloc_malloc(size_t sz, const char* file, long line) {
    (void) file, (void) line;   // avoid uninitialized variable warnings

     // Use insert_metadataHeader to allocate memory and set up canaries
    void* user_ptr = insert_metadataHeader(sz, file, line);
    if (user_ptr != NULL) {
        // Allocation was successful, update global statistics
        update_stats_malloc(user_ptr, sz, file, line);

        // Update heavy hitters report
        update_allocations(file, line, sz);

    } else {
        // Allocation failed, update global statistics accordingly
        stats_ptr.nfail++;
        stats_ptr.fail_size += sz;
        return NULL;
    }

    return user_ptr;
}


/// dmalloc_free(ptr, file, line)
///    Free the memory space pointed to by `ptr`, which must have been
///    returned by a previous call to dmalloc_malloc. If `ptr == NULL`,
///    does nothing. The free was called at location `file`:`line`.

void dmalloc_free(void* ptr, const char* file, long line) {
    (void) file, (void) line;   // avoid uninitialized variable warnings
    
    if (!ptr) {
        return;
    }

    remove_metadataHeader(ptr, file, line); // Handles canary checks, list manipulation, and memory freeing
}


/// dmalloc_calloc(nmemb, sz, file, line)
///    Return a pointer to newly-allocated dynamic memory big enough to
///    hold an array of `nmemb` elements of `sz` bytes each. If `sz == 0`,
///    then must return a unique, newly-allocated pointer value. Returned
///    memory should be initialized to zero. The allocation request was at
///    location `file`:`line`.

void* dmalloc_calloc(size_t nmemb, size_t sz, const char* file, long line) {
    // Your code here (to fix test014).
    if (nmemb > SIZE_MAX / sz) {
        // Multiplication would overflow
        stats_ptr.nfail++;
        stats_ptr.fail_size += sz;
        return NULL;
    }
    void* ptr = dmalloc_malloc(nmemb * sz, file, line);
    if (ptr) {
        memset(ptr, 0, nmemb * sz);
    }
    return ptr;
}


/// dmalloc_get_statistics(stats)
///    Store the current memory statistics in `*stats`.

void dmalloc_get_statistics(dmalloc_statistics* stats) {
    // Stub: set all statistics to enormous numbers
    memset(stats, 255, sizeof(dmalloc_statistics));
    // Your code here.
    *stats = stats_ptr;
}


/// dmalloc_print_statistics()
///    Print the current memory statistics.

void dmalloc_print_statistics() {
    dmalloc_statistics stats;
    dmalloc_get_statistics(&stats);

    printf("alloc count: active %10llu   total %10llu   fail %10llu\n",
           stats.nactive, stats.ntotal, stats.nfail);
    printf("alloc size:  active %10llu   total %10llu   fail %10llu\n",
           stats.active_size, stats.total_size, stats.fail_size);
}


/// dmalloc_print_leak_report()
///    Print a report of all currently-active allocated blocks of dynamic
///    memory.

void dmalloc_print_leak_report() {
    metadataHeader* current = head;
    while (current != NULL) {
        // For each non-freed block, print the leak report
        printf("LEAK CHECK: %s:%ld: allocated object %p with size %zu\n",
               current->file, current->line, current->ptr, current->size);
        current = current->next;
    }
}


/// dmalloc_print_heavy_hitter_report()
///    Print a report of heavily-used allocation locations.

void dmalloc_print_heavy_hitter_report() {
    // Your heavy-hitters code here
    print_heavy_hitters(5);
}
