#include "malloc.h"

#ifndef UINT64_MAX
#define UINT64_MAX 0xFFFFFFFFFFFFFFFFULL
#endif

typedef struct block_header {
    uint64_t size;  
    struct block_header* next; 
    int is_free;  
} block_header;

typedef struct block_footer {
    uint64_t size; 
} block_footer;

static block_header* head = NULL;
static block_header* heap_start = NULL;
static block_header* heap_end = NULL;

void free(void *firstbyte) {
    if (firstbyte == NULL) {
        return; 
    }

    block_header *header = (block_header *)((char *)firstbyte - sizeof(block_header));
    
    if (header->is_free == 1) {
        return; 
    }
    header->is_free = 1;
}

void *malloc(uint64_t numbytes) {
    if (numbytes == 0) {
        return NULL;
    }

    numbytes = (numbytes + sizeof(block_header) + sizeof(block_footer) + 7) & ~7; 

    if (heap_start == NULL) {
        heap_start = (block_header *)sbrk(0);
        heap_end = heap_start;
        head = heap_start; 
    }

    block_header *current = head; 
    block_header *prev = NULL;

    while (current != NULL && current < heap_end) {
        if (current->is_free && current->size >= numbytes) {
            if (current->size >= numbytes + sizeof(block_header) + sizeof(block_footer) + 8) {
                // Split the block
                uint64_t original_size = current->size;
                current->size = numbytes;

                block_header *new_blk = (block_header *)((char *)current + numbytes);
                new_blk->size = original_size - numbytes;
                new_blk->is_free = 1;
                new_blk->next = current->next;
                current->next = new_blk;

                block_footer *new_footer = (block_footer *)((char *)new_blk + new_blk->size - sizeof(block_footer));
                new_footer->size = new_blk->size;
            } else {
                current->is_free = 0; 
            }

            block_footer *footer = (block_footer *)((char *)current + current->size - sizeof(block_footer));
            footer->size = current->size;

            return (void *)((char *)current + sizeof(block_header));
        }
        prev = current;
        current = current->next;
    }

    block_header *new_block = (block_header *)sbrk(numbytes);
    if (new_block == (void *)-1) {
        return NULL; 
    }
    new_block->size = numbytes;
    new_block->is_free = 0;
    new_block->next = NULL;

    if (prev) {
        prev->next = new_block; 
    }

    block_footer *footer = (block_footer *)((char *)new_block + numbytes - sizeof(block_footer));
    footer->size = numbytes;
    heap_end = (block_header *)((char *)new_block + numbytes);
    return (void *)((char *)new_block + sizeof(block_header));
}

void *calloc(uint64_t num, uint64_t sz) {
    if (sz && num > UINT64_MAX / sz) {
        return NULL; 
    }

    uint64_t total_size = num * sz;
    if (total_size == 0) {
        return NULL; 
    }

    void *ptr = malloc(total_size);
    if (ptr == NULL) {
        return NULL;
    }

    memset(ptr, 0, total_size);
    return ptr;
}

void *realloc(void *ptr, uint64_t sz) {
    if (ptr == NULL) {
        return malloc(sz);
    }

    if (sz == 0) {
        free(ptr);
        return NULL;
    }

    block_header *header = (block_header *)((char *)ptr - sizeof(block_header));
    uint64_t current_size = header->size - sizeof(block_header) - sizeof(block_footer);

    if (sz == current_size) {
        return ptr;
    }

    void *new_ptr = malloc(sz);
    if (new_ptr == NULL) {
        return NULL; 
    }
    uint64_t size_to_copy = (current_size < sz) ? current_size : sz;
    memcpy(new_ptr, ptr, size_to_copy);

    free(ptr); 
    return new_ptr;
}

void defrag() {
    if (head == NULL || head->next == NULL) {
        return;
    }

    block_header *current = head;
    block_header *prev = NULL;

    while (current != NULL && current->next != NULL) {
        block_header *next = current->next;
        if (current->is_free && next->is_free) {
            current->size += next->size; 
            current->next = next->next; 
            block_footer *footer = (block_footer *)((char *)current + current->size - sizeof(block_footer));
            footer->size = current->size;
            continue; 
        }

        prev = current;
        current = next;
    }
}

void quickSort(long *size_array, void **ptr_array, int left, int right);
void quickSortStart(long *size_array, void **ptr_array, int n);

int heap_info(heap_info_struct *info) {
    if (info == NULL) return -1;

    int alloc_count = 0;
    int total_free_space = 0;
    uint64_t largest_free_chunk = 0;

    block_header *current = head; 
    while (current != NULL) {  
        if (current->is_free) {
            total_free_space += current->size;
            if (current->size > largest_free_chunk) {
                largest_free_chunk = current->size;
            }
        } else {
            alloc_count++;
        }

        current = current->next; 
    }

    if (alloc_count == 0) {
        info->num_allocs = 0;
        info->size_array = NULL;
        info->ptr_array = NULL;
        info->free_space = total_free_space;
        info->largest_free_chunk = largest_free_chunk;
        return 0;
    }

    long *size_array = (long *)malloc(alloc_count * sizeof(long));
    void **ptr_array = (void **)malloc(alloc_count * sizeof(void *));
    
    if (size_array == NULL || ptr_array == NULL) {
        free(size_array);  
        free(ptr_array);
        return -1;
    }

    current = head; 
    int index = 0;
    while (current != NULL) { 
        if (!current->is_free) {
            size_array[index] = current->size - sizeof(block_header) - sizeof(block_footer);
            ptr_array[index] = (void *)((char *)current + sizeof(block_header));
            index++;
        }
        current = current->next;
    }

    quickSortStart(size_array, ptr_array, alloc_count);

    info->num_allocs = alloc_count;
    info->size_array = size_array;
    info->ptr_array = ptr_array;
    info->free_space = total_free_space;
    info->largest_free_chunk = largest_free_chunk;
    return 0;
}

void quickSort(long *size_array, void **ptr_array, int left, int right) {
    if (left >= right) return; 

    // Partition step
    long pivot = size_array[(left + right) / 2];
    int i = left;
    int j = right;
    while (i <= j) {
        while (size_array[i] > pivot) i++;  
        while (size_array[j] < pivot) j--;  
        if (i <= j) {
            long tempSize = size_array[i];
            void* tempPtr = ptr_array[i];
            size_array[i] = size_array[j];
            ptr_array[i] = ptr_array[j];
            size_array[j] = tempSize;
            ptr_array[j] = tempPtr;
            i++;
            j--;
        }
    }

    // Recursive step
    quickSort(size_array, ptr_array, left, j);
    quickSort(size_array, ptr_array, i, right);
}

// Function to start the quicksort
void quickSortStart(long *size_array, void **ptr_array, int n) {
    quickSort(size_array, ptr_array, 0, n - 1);
}

