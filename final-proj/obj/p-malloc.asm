
obj/p-malloc.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:
extern uint8_t end[];

uint8_t* heap_top;
uint8_t* stack_bottom;

void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	53                   	push   %rbx
  100005:	48 83 ec 08          	sub    $0x8,%rsp

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  100009:	cd 31                	int    $0x31
  10000b:	89 c3                	mov    %eax,%ebx
    pid_t p = getpid();

    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  10000d:	b8 37 30 10 00       	mov    $0x103037,%eax
  100012:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100018:	48 89 05 e9 1f 00 00 	mov    %rax,0x1fe9(%rip)        # 102008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  10001f:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  100022:	48 83 e8 01          	sub    $0x1,%rax
  100026:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10002c:	48 89 05 cd 1f 00 00 	mov    %rax,0x1fcd(%rip)        # 102000 <stack_bottom>
  100033:	eb 02                	jmp    100037 <process_main+0x37>

// yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void yield(void) {
    asm volatile ("int %0" : /* no result */
  100035:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
	if ((rand() % ALLOC_SLOWDOWN) < p) {
  100037:	e8 ca 07 00 00       	call   100806 <rand>
  10003c:	48 63 d0             	movslq %eax,%rdx
  10003f:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  100046:	48 c1 fa 25          	sar    $0x25,%rdx
  10004a:	89 c1                	mov    %eax,%ecx
  10004c:	c1 f9 1f             	sar    $0x1f,%ecx
  10004f:	29 ca                	sub    %ecx,%edx
  100051:	6b d2 64             	imul   $0x64,%edx,%edx
  100054:	29 d0                	sub    %edx,%eax
  100056:	39 d8                	cmp    %ebx,%eax
  100058:	7d db                	jge    100035 <process_main+0x35>
	    void * ret = malloc(PAGESIZE);
  10005a:	bf 00 10 00 00       	mov    $0x1000,%edi
  10005f:	e8 20 00 00 00       	call   100084 <malloc>
	    if(ret == NULL)
  100064:	48 85 c0             	test   %rax,%rax
  100067:	74 04                	je     10006d <process_main+0x6d>
		break;
	    *((int*)ret) = p;       // check we have write access
  100069:	89 18                	mov    %ebx,(%rax)
  10006b:	eb c8                	jmp    100035 <process_main+0x35>
  10006d:	cd 32                	int    $0x32
	}
	yield();
    }
    // After running out of memory, do nothing forever
    while (1) {
  10006f:	eb fc                	jmp    10006d <process_main+0x6d>

0000000000100071 <free>:
static block_header* head = NULL;
static block_header* heap_start = NULL;
static block_header* heap_end = NULL;

void free(void *firstbyte) {
    if (firstbyte == NULL) {
  100071:	48 85 ff             	test   %rdi,%rdi
  100074:	74 0d                	je     100083 <free+0x12>
        return; 
    }

    block_header *header = (block_header *)((char *)firstbyte - sizeof(block_header));
    
    if (header->is_free == 1) {
  100076:	83 7f f8 01          	cmpl   $0x1,-0x8(%rdi)
  10007a:	74 07                	je     100083 <free+0x12>
        return; 
    }
    header->is_free = 1;
  10007c:	c7 47 f8 01 00 00 00 	movl   $0x1,-0x8(%rdi)
}
  100083:	c3                   	ret

0000000000100084 <malloc>:

void *malloc(uint64_t numbytes) {
    if (numbytes == 0) {
  100084:	48 85 ff             	test   %rdi,%rdi
  100087:	0f 84 02 01 00 00    	je     10018f <malloc+0x10b>
        return NULL;
    }

    numbytes = (numbytes + sizeof(block_header) + sizeof(block_footer) + 7) & ~7; 
  10008d:	48 8d 4f 27          	lea    0x27(%rdi),%rcx
  100091:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx

    if (heap_start == NULL) {
  100095:	48 83 3d 83 1f 00 00 	cmpq   $0x0,0x1f83(%rip)        # 102020 <heap_start>
  10009c:	00 
  10009d:	74 1e                	je     1000bd <malloc+0x39>
        heap_start = (block_header *)sbrk(0);
        heap_end = heap_start;
        head = heap_start; 
    }

    block_header *current = head; 
  10009f:	48 8b 05 82 1f 00 00 	mov    0x1f82(%rip),%rax        # 102028 <head>
    block_header *prev = NULL;

    while (current != NULL && current < heap_end) {
  1000a6:	48 85 c0             	test   %rax,%rax
  1000a9:	0f 84 9c 00 00 00    	je     10014b <malloc+0xc7>
  1000af:	48 8b 3d 62 1f 00 00 	mov    0x1f62(%rip),%rdi        # 102018 <heap_end>
    block_header *prev = NULL;
  1000b6:	be 00 00 00 00       	mov    $0x0,%esi
  1000bb:	eb 3d                	jmp    1000fa <malloc+0x76>
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  1000bd:	bf 00 00 00 00       	mov    $0x0,%edi
  1000c2:	cd 3a                	int    $0x3a
  1000c4:	48 89 05 45 1f 00 00 	mov    %rax,0x1f45(%rip)        # 102010 <result.0>
        heap_start = (block_header *)sbrk(0);
  1000cb:	48 89 05 4e 1f 00 00 	mov    %rax,0x1f4e(%rip)        # 102020 <heap_start>
        heap_end = heap_start;
  1000d2:	48 89 05 3f 1f 00 00 	mov    %rax,0x1f3f(%rip)        # 102018 <heap_end>
        head = heap_start; 
  1000d9:	48 89 05 48 1f 00 00 	mov    %rax,0x1f48(%rip)        # 102028 <head>
  1000e0:	eb bd                	jmp    10009f <malloc+0x1b>
                current->next = new_blk;

                block_footer *new_footer = (block_footer *)((char *)new_blk + new_blk->size - sizeof(block_footer));
                new_footer->size = new_blk->size;
            } else {
                current->is_free = 0; 
  1000e2:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%rax)
  1000e9:	eb 53                	jmp    10013e <malloc+0xba>
            footer->size = current->size;

            return (void *)((char *)current + sizeof(block_header));
        }
        prev = current;
        current = current->next;
  1000eb:	48 8b 50 08          	mov    0x8(%rax),%rdx
    while (current != NULL && current < heap_end) {
  1000ef:	48 89 c6             	mov    %rax,%rsi
  1000f2:	48 85 d2             	test   %rdx,%rdx
  1000f5:	74 57                	je     10014e <malloc+0xca>
  1000f7:	48 89 d0             	mov    %rdx,%rax
  1000fa:	48 39 f8             	cmp    %rdi,%rax
  1000fd:	73 4f                	jae    10014e <malloc+0xca>
        if (current->is_free && current->size >= numbytes) {
  1000ff:	83 78 10 00          	cmpl   $0x0,0x10(%rax)
  100103:	74 e6                	je     1000eb <malloc+0x67>
  100105:	48 8b 10             	mov    (%rax),%rdx
  100108:	48 39 ca             	cmp    %rcx,%rdx
  10010b:	72 de                	jb     1000eb <malloc+0x67>
            if (current->size >= numbytes + sizeof(block_header) + sizeof(block_footer) + 8) {
  10010d:	48 8d 71 28          	lea    0x28(%rcx),%rsi
  100111:	48 39 f2             	cmp    %rsi,%rdx
  100114:	72 cc                	jb     1000e2 <malloc+0x5e>
                current->size = numbytes;
  100116:	48 89 08             	mov    %rcx,(%rax)
                block_header *new_blk = (block_header *)((char *)current + numbytes);
  100119:	48 8d 34 08          	lea    (%rax,%rcx,1),%rsi
                new_blk->size = original_size - numbytes;
  10011d:	48 29 ca             	sub    %rcx,%rdx
  100120:	48 89 16             	mov    %rdx,(%rsi)
                new_blk->is_free = 1;
  100123:	c7 46 10 01 00 00 00 	movl   $0x1,0x10(%rsi)
                new_blk->next = current->next;
  10012a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  10012e:	48 89 56 08          	mov    %rdx,0x8(%rsi)
                current->next = new_blk;
  100132:	48 89 70 08          	mov    %rsi,0x8(%rax)
                block_footer *new_footer = (block_footer *)((char *)new_blk + new_blk->size - sizeof(block_footer));
  100136:	48 8b 16             	mov    (%rsi),%rdx
                new_footer->size = new_blk->size;
  100139:	48 89 54 16 f8       	mov    %rdx,-0x8(%rsi,%rdx,1)
            block_footer *footer = (block_footer *)((char *)current + current->size - sizeof(block_footer));
  10013e:	48 8b 10             	mov    (%rax),%rdx
            footer->size = current->size;
  100141:	48 89 54 10 f8       	mov    %rdx,-0x8(%rax,%rdx,1)
            return (void *)((char *)current + sizeof(block_header));
  100146:	48 83 c0 18          	add    $0x18,%rax
  10014a:	c3                   	ret
    block_header *prev = NULL;
  10014b:	48 89 c6             	mov    %rax,%rsi
  10014e:	48 89 cf             	mov    %rcx,%rdi
  100151:	cd 3a                	int    $0x3a
  100153:	48 89 05 b6 1e 00 00 	mov    %rax,0x1eb6(%rip)        # 102010 <result.0>
    }

    block_header *new_block = (block_header *)sbrk(numbytes);
    if (new_block == (void *)-1) {
  10015a:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  10015e:	74 35                	je     100195 <malloc+0x111>
        return NULL; 
    }
    new_block->size = numbytes;
  100160:	48 89 08             	mov    %rcx,(%rax)
    new_block->is_free = 0;
  100163:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%rax)
    new_block->next = NULL;
  10016a:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
  100171:	00 

    if (prev) {
  100172:	48 85 f6             	test   %rsi,%rsi
  100175:	74 04                	je     10017b <malloc+0xf7>
        prev->next = new_block; 
  100177:	48 89 46 08          	mov    %rax,0x8(%rsi)
    }

    block_footer *footer = (block_footer *)((char *)new_block + numbytes - sizeof(block_footer));
    footer->size = numbytes;
  10017b:	48 89 4c 01 f8       	mov    %rcx,-0x8(%rcx,%rax,1)
    heap_end = (block_header *)((char *)new_block + numbytes);
  100180:	48 01 c1             	add    %rax,%rcx
  100183:	48 89 0d 8e 1e 00 00 	mov    %rcx,0x1e8e(%rip)        # 102018 <heap_end>
    return (void *)((char *)new_block + sizeof(block_header));
  10018a:	48 83 c0 18          	add    $0x18,%rax
  10018e:	c3                   	ret
        return NULL;
  10018f:	b8 00 00 00 00       	mov    $0x0,%eax
  100194:	c3                   	ret
        return NULL; 
  100195:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10019a:	c3                   	ret

000000000010019b <calloc>:

void *calloc(uint64_t num, uint64_t sz) {
  10019b:	55                   	push   %rbp
  10019c:	48 89 e5             	mov    %rsp,%rbp
  10019f:	41 54                	push   %r12
  1001a1:	53                   	push   %rbx
    if (sz && num > UINT64_MAX / sz) {
  1001a2:	48 85 f6             	test   %rsi,%rsi
  1001a5:	74 3e                	je     1001e5 <calloc+0x4a>
  1001a7:	48 89 f0             	mov    %rsi,%rax
  1001aa:	48 f7 e7             	mul    %rdi
  1001ad:	70 3e                	jo     1001ed <calloc+0x52>
        return NULL; 
    }

    uint64_t total_size = num * sz;
  1001af:	48 89 c3             	mov    %rax,%rbx
    if (total_size == 0) {
        return NULL; 
  1001b2:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    if (total_size == 0) {
  1001b8:	48 85 c0             	test   %rax,%rax
  1001bb:	74 20                	je     1001dd <calloc+0x42>
    }

    void *ptr = malloc(total_size);
  1001bd:	48 89 c7             	mov    %rax,%rdi
  1001c0:	e8 bf fe ff ff       	call   100084 <malloc>
  1001c5:	49 89 c4             	mov    %rax,%r12
    if (ptr == NULL) {
  1001c8:	48 85 c0             	test   %rax,%rax
  1001cb:	74 10                	je     1001dd <calloc+0x42>
        return NULL;
    }

    memset(ptr, 0, total_size);
  1001cd:	48 89 da             	mov    %rbx,%rdx
  1001d0:	be 00 00 00 00       	mov    $0x0,%esi
  1001d5:	48 89 c7             	mov    %rax,%rdi
  1001d8:	e8 6c 04 00 00       	call   100649 <memset>
    return ptr;
}
  1001dd:	4c 89 e0             	mov    %r12,%rax
  1001e0:	5b                   	pop    %rbx
  1001e1:	41 5c                	pop    %r12
  1001e3:	5d                   	pop    %rbp
  1001e4:	c3                   	ret
        return NULL; 
  1001e5:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  1001eb:	eb f0                	jmp    1001dd <calloc+0x42>
        return NULL; 
  1001ed:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  1001f3:	eb e8                	jmp    1001dd <calloc+0x42>

00000000001001f5 <realloc>:

void *realloc(void *ptr, uint64_t sz) {
  1001f5:	55                   	push   %rbp
  1001f6:	48 89 e5             	mov    %rsp,%rbp
  1001f9:	41 56                	push   %r14
  1001fb:	41 55                	push   %r13
  1001fd:	41 54                	push   %r12
  1001ff:	53                   	push   %rbx
  100200:	48 89 f3             	mov    %rsi,%rbx
    if (ptr == NULL) {
  100203:	48 85 ff             	test   %rdi,%rdi
  100206:	74 51                	je     100259 <realloc+0x64>
  100208:	49 89 fc             	mov    %rdi,%r12
        return malloc(sz);
    }

    if (sz == 0) {
  10020b:	48 85 f6             	test   %rsi,%rsi
  10020e:	74 56                	je     100266 <realloc+0x71>
        free(ptr);
        return NULL;
    }

    block_header *header = (block_header *)((char *)ptr - sizeof(block_header));
    uint64_t current_size = header->size - sizeof(block_header) - sizeof(block_footer);
  100210:	48 8b 47 e8          	mov    -0x18(%rdi),%rax
  100214:	4c 8d 70 e0          	lea    -0x20(%rax),%r14

    if (sz == current_size) {
        return ptr;
  100218:	49 89 fd             	mov    %rdi,%r13
    if (sz == current_size) {
  10021b:	4c 39 f6             	cmp    %r14,%rsi
  10021e:	74 2d                	je     10024d <realloc+0x58>
    }

    void *new_ptr = malloc(sz);
  100220:	48 89 f7             	mov    %rsi,%rdi
  100223:	e8 5c fe ff ff       	call   100084 <malloc>
  100228:	49 89 c5             	mov    %rax,%r13
    if (new_ptr == NULL) {
  10022b:	48 85 c0             	test   %rax,%rax
  10022e:	74 1d                	je     10024d <realloc+0x58>
        return NULL; 
    }
    uint64_t size_to_copy = (current_size < sz) ? current_size : sz;
  100230:	4c 39 f3             	cmp    %r14,%rbx
  100233:	4c 89 f2             	mov    %r14,%rdx
  100236:	48 0f 46 d3          	cmovbe %rbx,%rdx
    memcpy(new_ptr, ptr, size_to_copy);
  10023a:	4c 89 e6             	mov    %r12,%rsi
  10023d:	48 89 c7             	mov    %rax,%rdi
  100240:	e8 06 03 00 00       	call   10054b <memcpy>

    free(ptr); 
  100245:	4c 89 e7             	mov    %r12,%rdi
  100248:	e8 24 fe ff ff       	call   100071 <free>
    return new_ptr;
}
  10024d:	4c 89 e8             	mov    %r13,%rax
  100250:	5b                   	pop    %rbx
  100251:	41 5c                	pop    %r12
  100253:	41 5d                	pop    %r13
  100255:	41 5e                	pop    %r14
  100257:	5d                   	pop    %rbp
  100258:	c3                   	ret
        return malloc(sz);
  100259:	48 89 f7             	mov    %rsi,%rdi
  10025c:	e8 23 fe ff ff       	call   100084 <malloc>
  100261:	49 89 c5             	mov    %rax,%r13
  100264:	eb e7                	jmp    10024d <realloc+0x58>
        free(ptr);
  100266:	e8 06 fe ff ff       	call   100071 <free>
        return NULL;
  10026b:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  100271:	eb da                	jmp    10024d <realloc+0x58>

0000000000100273 <defrag>:

void defrag() {
    if (head == NULL || head->next == NULL) {
  100273:	48 8b 05 ae 1d 00 00 	mov    0x1dae(%rip),%rax        # 102028 <head>
  10027a:	48 85 c0             	test   %rax,%rax
  10027d:	74 3b                	je     1002ba <defrag+0x47>
  10027f:	48 83 78 08 00       	cmpq   $0x0,0x8(%rax)
  100284:	75 04                	jne    10028a <defrag+0x17>
  100286:	c3                   	ret
        if (current->is_free && next->is_free) {
            current->size += next->size; 
            current->next = next->next; 
            block_footer *footer = (block_footer *)((char *)current + current->size - sizeof(block_footer));
            footer->size = current->size;
            continue; 
  100287:	48 89 d0             	mov    %rdx,%rax
    while (current != NULL && current->next != NULL) {
  10028a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  10028e:	48 85 d2             	test   %rdx,%rdx
  100291:	74 27                	je     1002ba <defrag+0x47>
        if (current->is_free && next->is_free) {
  100293:	83 78 10 00          	cmpl   $0x0,0x10(%rax)
  100297:	74 ee                	je     100287 <defrag+0x14>
  100299:	83 7a 10 00          	cmpl   $0x0,0x10(%rdx)
  10029d:	74 e8                	je     100287 <defrag+0x14>
            current->size += next->size; 
  10029f:	48 8b 0a             	mov    (%rdx),%rcx
  1002a2:	48 03 08             	add    (%rax),%rcx
  1002a5:	48 89 08             	mov    %rcx,(%rax)
            current->next = next->next; 
  1002a8:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  1002ac:	48 89 50 08          	mov    %rdx,0x8(%rax)
            footer->size = current->size;
  1002b0:	48 89 4c 08 f8       	mov    %rcx,-0x8(%rax,%rcx,1)
            continue; 
  1002b5:	48 89 c2             	mov    %rax,%rdx
  1002b8:	eb cd                	jmp    100287 <defrag+0x14>
        }

        prev = current;
        current = next;
    }
}
  1002ba:	c3                   	ret

00000000001002bb <quickSort>:
    info->largest_free_chunk = largest_free_chunk;
    return 0;
}

void quickSort(long *size_array, void **ptr_array, int left, int right) {
    if (left >= right) return; 
  1002bb:	39 ca                	cmp    %ecx,%edx
  1002bd:	0f 8d 13 01 00 00    	jge    1003d6 <quickSort+0x11b>
void quickSort(long *size_array, void **ptr_array, int left, int right) {
  1002c3:	55                   	push   %rbp
  1002c4:	48 89 e5             	mov    %rsp,%rbp
  1002c7:	41 57                	push   %r15
  1002c9:	41 56                	push   %r14
  1002cb:	41 55                	push   %r13
  1002cd:	41 54                	push   %r12
  1002cf:	53                   	push   %rbx
  1002d0:	48 83 ec 08          	sub    $0x8,%rsp
  1002d4:	48 89 fb             	mov    %rdi,%rbx
  1002d7:	49 89 f5             	mov    %rsi,%r13
  1002da:	41 89 d2             	mov    %edx,%r10d
  1002dd:	41 89 cc             	mov    %ecx,%r12d

    // Partition step
    long pivot = size_array[(left + right) / 2];
  1002e0:	8d 14 0a             	lea    (%rdx,%rcx,1),%edx
  1002e3:	89 d0                	mov    %edx,%eax
  1002e5:	c1 e8 1f             	shr    $0x1f,%eax
  1002e8:	01 d0                	add    %edx,%eax
  1002ea:	d1 f8                	sar    %eax
  1002ec:	48 98                	cltq
  1002ee:	48 8b 0c c7          	mov    (%rdi,%rax,8),%rcx
    int i = left;
    int j = right;
  1002f2:	44 89 e2             	mov    %r12d,%edx
    int i = left;
  1002f5:	45 89 d6             	mov    %r10d,%r14d
    while (i <= j) {
  1002f8:	eb 6d                	jmp    100367 <quickSort+0xac>
  1002fa:	41 83 c6 01          	add    $0x1,%r14d
  1002fe:	4d 63 f6             	movslq %r14d,%r14
  100301:	4a 8d 44 03 08       	lea    0x8(%rbx,%r8,1),%rax
        while (size_array[i] > pivot) i++;  
  100306:	49 89 c3             	mov    %rax,%r11
  100309:	48 8b 30             	mov    (%rax),%rsi
  10030c:	4d 89 f0             	mov    %r14,%r8
  10030f:	49 83 c6 01          	add    $0x1,%r14
  100313:	48 83 c0 08          	add    $0x8,%rax
  100317:	48 39 ce             	cmp    %rcx,%rsi
  10031a:	7f ea                	jg     100306 <quickSort+0x4b>
  10031c:	45 89 c6             	mov    %r8d,%r14d
  10031f:	49 c1 e0 03          	shl    $0x3,%r8
        while (size_array[j] < pivot) j--;  
  100323:	48 63 c2             	movslq %edx,%rax
  100326:	4c 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%r9
  10032d:	00 
  10032e:	4e 8d 3c 0b          	lea    (%rbx,%r9,1),%r15
  100332:	49 8b 3f             	mov    (%r15),%rdi
  100335:	48 39 f9             	cmp    %rdi,%rcx
  100338:	7e 28                	jle    100362 <quickSort+0xa7>
  10033a:	83 ea 01             	sub    $0x1,%edx
  10033d:	48 63 d2             	movslq %edx,%rdx
  100340:	48 8d 44 c3 f8       	lea    -0x8(%rbx,%rax,8),%rax
  100345:	49 89 c7             	mov    %rax,%r15
  100348:	48 8b 38             	mov    (%rax),%rdi
  10034b:	49 89 d1             	mov    %rdx,%r9
  10034e:	48 83 ea 01          	sub    $0x1,%rdx
  100352:	48 83 e8 08          	sub    $0x8,%rax
  100356:	48 39 cf             	cmp    %rcx,%rdi
  100359:	7c ea                	jl     100345 <quickSort+0x8a>
  10035b:	44 89 ca             	mov    %r9d,%edx
  10035e:	49 c1 e1 03          	shl    $0x3,%r9
        if (i <= j) {
  100362:	41 39 d6             	cmp    %edx,%r14d
  100365:	7e 1e                	jle    100385 <quickSort+0xca>
    while (i <= j) {
  100367:	41 39 d6             	cmp    %edx,%r14d
  10036a:	7f 3a                	jg     1003a6 <quickSort+0xeb>
        while (size_array[i] > pivot) i++;  
  10036c:	4d 63 c6             	movslq %r14d,%r8
  10036f:	49 c1 e0 03          	shl    $0x3,%r8
  100373:	4e 8d 1c 03          	lea    (%rbx,%r8,1),%r11
  100377:	49 8b 33             	mov    (%r11),%rsi
  10037a:	48 39 f1             	cmp    %rsi,%rcx
  10037d:	0f 8c 77 ff ff ff    	jl     1002fa <quickSort+0x3f>
  100383:	eb 9e                	jmp    100323 <quickSort+0x68>
            long tempSize = size_array[i];
            void* tempPtr = ptr_array[i];
  100385:	4d 01 e8             	add    %r13,%r8
  100388:	49 8b 00             	mov    (%r8),%rax
            size_array[i] = size_array[j];
  10038b:	49 89 3b             	mov    %rdi,(%r11)
            ptr_array[i] = ptr_array[j];
  10038e:	4d 01 e9             	add    %r13,%r9
  100391:	49 8b 39             	mov    (%r9),%rdi
  100394:	49 89 38             	mov    %rdi,(%r8)
            size_array[j] = tempSize;
  100397:	49 89 37             	mov    %rsi,(%r15)
            ptr_array[j] = tempPtr;
  10039a:	49 89 01             	mov    %rax,(%r9)
            i++;
  10039d:	41 83 c6 01          	add    $0x1,%r14d
            j--;
  1003a1:	83 ea 01             	sub    $0x1,%edx
  1003a4:	eb c1                	jmp    100367 <quickSort+0xac>
        }
    }

    // Recursive step
    quickSort(size_array, ptr_array, left, j);
  1003a6:	89 d1                	mov    %edx,%ecx
  1003a8:	44 89 d2             	mov    %r10d,%edx
  1003ab:	4c 89 ee             	mov    %r13,%rsi
  1003ae:	48 89 df             	mov    %rbx,%rdi
  1003b1:	e8 05 ff ff ff       	call   1002bb <quickSort>
    quickSort(size_array, ptr_array, i, right);
  1003b6:	44 89 e1             	mov    %r12d,%ecx
  1003b9:	44 89 f2             	mov    %r14d,%edx
  1003bc:	4c 89 ee             	mov    %r13,%rsi
  1003bf:	48 89 df             	mov    %rbx,%rdi
  1003c2:	e8 f4 fe ff ff       	call   1002bb <quickSort>
}
  1003c7:	48 83 c4 08          	add    $0x8,%rsp
  1003cb:	5b                   	pop    %rbx
  1003cc:	41 5c                	pop    %r12
  1003ce:	41 5d                	pop    %r13
  1003d0:	41 5e                	pop    %r14
  1003d2:	41 5f                	pop    %r15
  1003d4:	5d                   	pop    %rbp
  1003d5:	c3                   	ret
  1003d6:	c3                   	ret

00000000001003d7 <quickSortStart>:

// Function to start the quicksort
void quickSortStart(long *size_array, void **ptr_array, int n) {
  1003d7:	55                   	push   %rbp
  1003d8:	48 89 e5             	mov    %rsp,%rbp
    quickSort(size_array, ptr_array, 0, n - 1);
  1003db:	8d 4a ff             	lea    -0x1(%rdx),%ecx
  1003de:	ba 00 00 00 00       	mov    $0x0,%edx
  1003e3:	e8 d3 fe ff ff       	call   1002bb <quickSort>
}
  1003e8:	5d                   	pop    %rbp
  1003e9:	c3                   	ret

00000000001003ea <heap_info>:
    if (info == NULL) return -1;
  1003ea:	48 85 ff             	test   %rdi,%rdi
  1003ed:	0f 84 52 01 00 00    	je     100545 <heap_info+0x15b>
int heap_info(heap_info_struct *info) {
  1003f3:	55                   	push   %rbp
  1003f4:	48 89 e5             	mov    %rsp,%rbp
  1003f7:	41 57                	push   %r15
  1003f9:	41 56                	push   %r14
  1003fb:	41 55                	push   %r13
  1003fd:	41 54                	push   %r12
  1003ff:	53                   	push   %rbx
  100400:	48 83 ec 18          	sub    $0x18,%rsp
  100404:	49 89 fe             	mov    %rdi,%r14
    block_header *current = head; 
  100407:	48 8b 05 1a 1c 00 00 	mov    0x1c1a(%rip),%rax        # 102028 <head>
    while (current != NULL) {  
  10040e:	48 85 c0             	test   %rax,%rax
  100411:	74 7e                	je     100491 <heap_info+0xa7>
    uint64_t largest_free_chunk = 0;
  100413:	bb 00 00 00 00       	mov    $0x0,%ebx
    int total_free_space = 0;
  100418:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    int alloc_count = 0;
  10041e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  100424:	eb 0d                	jmp    100433 <heap_info+0x49>
            alloc_count++;
  100426:	41 83 c4 01          	add    $0x1,%r12d
        current = current->next; 
  10042a:	48 8b 40 08          	mov    0x8(%rax),%rax
    while (current != NULL) {  
  10042e:	48 85 c0             	test   %rax,%rax
  100431:	74 15                	je     100448 <heap_info+0x5e>
        if (current->is_free) {
  100433:	83 78 10 00          	cmpl   $0x0,0x10(%rax)
  100437:	74 ed                	je     100426 <heap_info+0x3c>
            total_free_space += current->size;
  100439:	48 8b 10             	mov    (%rax),%rdx
  10043c:	41 01 d5             	add    %edx,%r13d
            if (current->size > largest_free_chunk) {
  10043f:	48 39 d3             	cmp    %rdx,%rbx
  100442:	48 0f 42 da          	cmovb  %rdx,%rbx
  100446:	eb e2                	jmp    10042a <heap_info+0x40>
    if (alloc_count == 0) {
  100448:	45 85 e4             	test   %r12d,%r12d
  10044b:	74 4f                	je     10049c <heap_info+0xb2>
    long *size_array = (long *)malloc(alloc_count * sizeof(long));
  10044d:	49 63 c4             	movslq %r12d,%rax
  100450:	48 c1 e0 03          	shl    $0x3,%rax
  100454:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  100458:	48 89 c7             	mov    %rax,%rdi
  10045b:	e8 24 fc ff ff       	call   100084 <malloc>
  100460:	49 89 c7             	mov    %rax,%r15
    void **ptr_array = (void **)malloc(alloc_count * sizeof(void *));
  100463:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  100467:	e8 18 fc ff ff       	call   100084 <malloc>
  10046c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    if (size_array == NULL || ptr_array == NULL) {
  100470:	4d 85 ff             	test   %r15,%r15
  100473:	74 5a                	je     1004cf <heap_info+0xe5>
  100475:	48 85 c0             	test   %rax,%rax
  100478:	74 55                	je     1004cf <heap_info+0xe5>
    current = head; 
  10047a:	48 8b 05 a7 1b 00 00 	mov    0x1ba7(%rip),%rax        # 102028 <head>
    while (current != NULL) { 
  100481:	48 85 c0             	test   %rax,%rax
  100484:	0f 84 8b 00 00 00    	je     100515 <heap_info+0x12b>
    int index = 0;
  10048a:	b9 00 00 00 00       	mov    $0x0,%ecx
  10048f:	eb 5f                	jmp    1004f0 <heap_info+0x106>
    uint64_t largest_free_chunk = 0;
  100491:	bb 00 00 00 00       	mov    $0x0,%ebx
    int total_free_space = 0;
  100496:	41 bd 00 00 00 00    	mov    $0x0,%r13d
        info->num_allocs = 0;
  10049c:	41 c7 06 00 00 00 00 	movl   $0x0,(%r14)
        info->size_array = NULL;
  1004a3:	49 c7 46 08 00 00 00 	movq   $0x0,0x8(%r14)
  1004aa:	00 
        info->ptr_array = NULL;
  1004ab:	49 c7 46 10 00 00 00 	movq   $0x0,0x10(%r14)
  1004b2:	00 
        info->free_space = total_free_space;
  1004b3:	45 89 6e 18          	mov    %r13d,0x18(%r14)
        info->largest_free_chunk = largest_free_chunk;
  1004b7:	41 89 5e 1c          	mov    %ebx,0x1c(%r14)
        return 0;
  1004bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1004c0:	48 83 c4 18          	add    $0x18,%rsp
  1004c4:	5b                   	pop    %rbx
  1004c5:	41 5c                	pop    %r12
  1004c7:	41 5d                	pop    %r13
  1004c9:	41 5e                	pop    %r14
  1004cb:	41 5f                	pop    %r15
  1004cd:	5d                   	pop    %rbp
  1004ce:	c3                   	ret
        free(size_array);  
  1004cf:	4c 89 ff             	mov    %r15,%rdi
  1004d2:	e8 9a fb ff ff       	call   100071 <free>
        free(ptr_array);
  1004d7:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  1004db:	e8 91 fb ff ff       	call   100071 <free>
        return -1;
  1004e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1004e5:	eb d9                	jmp    1004c0 <heap_info+0xd6>
        current = current->next;
  1004e7:	48 8b 40 08          	mov    0x8(%rax),%rax
    while (current != NULL) { 
  1004eb:	48 85 c0             	test   %rax,%rax
  1004ee:	74 25                	je     100515 <heap_info+0x12b>
        if (!current->is_free) {
  1004f0:	83 78 10 00          	cmpl   $0x0,0x10(%rax)
  1004f4:	75 f1                	jne    1004e7 <heap_info+0xfd>
            size_array[index] = current->size - sizeof(block_header) - sizeof(block_footer);
  1004f6:	48 63 f1             	movslq %ecx,%rsi
  1004f9:	48 8b 38             	mov    (%rax),%rdi
  1004fc:	48 8d 57 e0          	lea    -0x20(%rdi),%rdx
  100500:	49 89 14 f7          	mov    %rdx,(%r15,%rsi,8)
            ptr_array[index] = (void *)((char *)current + sizeof(block_header));
  100504:	48 8d 50 18          	lea    0x18(%rax),%rdx
  100508:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  10050c:	48 89 14 f7          	mov    %rdx,(%rdi,%rsi,8)
            index++;
  100510:	83 c1 01             	add    $0x1,%ecx
  100513:	eb d2                	jmp    1004e7 <heap_info+0xfd>
    quickSortStart(size_array, ptr_array, alloc_count);
  100515:	44 89 e2             	mov    %r12d,%edx
  100518:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  10051c:	4c 89 ff             	mov    %r15,%rdi
  10051f:	e8 b3 fe ff ff       	call   1003d7 <quickSortStart>
    info->num_allocs = alloc_count;
  100524:	45 89 26             	mov    %r12d,(%r14)
    info->size_array = size_array;
  100527:	4d 89 7e 08          	mov    %r15,0x8(%r14)
    info->ptr_array = ptr_array;
  10052b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  10052f:	49 89 46 10          	mov    %rax,0x10(%r14)
    info->free_space = total_free_space;
  100533:	45 89 6e 18          	mov    %r13d,0x18(%r14)
    info->largest_free_chunk = largest_free_chunk;
  100537:	41 89 5e 1c          	mov    %ebx,0x1c(%r14)
    return 0;
  10053b:	b8 00 00 00 00       	mov    $0x0,%eax
  100540:	e9 7b ff ff ff       	jmp    1004c0 <heap_info+0xd6>
    if (info == NULL) return -1;
  100545:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  10054a:	c3                   	ret

000000000010054b <memcpy>:


// memcpy, memmove, memset, strcmp, strlen, strnlen
//    We must provide our own implementations.

void* memcpy(void* dst, const void* src, size_t n) {
  10054b:	55                   	push   %rbp
  10054c:	48 89 e5             	mov    %rsp,%rbp
  10054f:	48 83 ec 28          	sub    $0x28,%rsp
  100553:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  100557:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  10055b:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  10055f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100563:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  100567:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  10056b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  10056f:	eb 1c                	jmp    10058d <memcpy+0x42>
        *d = *s;
  100571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100575:	0f b6 10             	movzbl (%rax),%edx
  100578:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10057c:	88 10                	mov    %dl,(%rax)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  10057e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  100583:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  100588:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  10058d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  100592:	75 dd                	jne    100571 <memcpy+0x26>
    }
    return dst;
  100594:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  100598:	c9                   	leave
  100599:	c3                   	ret

000000000010059a <memmove>:

void* memmove(void* dst, const void* src, size_t n) {
  10059a:	55                   	push   %rbp
  10059b:	48 89 e5             	mov    %rsp,%rbp
  10059e:	48 83 ec 28          	sub    $0x28,%rsp
  1005a2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1005a6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1005aa:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1005ae:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1005b2:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    char* d = (char*) dst;
  1005b6:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1005ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (s < d && s + n > d) {
  1005be:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1005c2:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  1005c6:	73 6a                	jae    100632 <memmove+0x98>
  1005c8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  1005cc:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1005d0:	48 01 d0             	add    %rdx,%rax
  1005d3:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
  1005d7:	73 59                	jae    100632 <memmove+0x98>
        s += n, d += n;
  1005d9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1005dd:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  1005e1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1005e5:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        while (n-- > 0) {
  1005e9:	eb 17                	jmp    100602 <memmove+0x68>
            *--d = *--s;
  1005eb:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  1005f0:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
  1005f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1005f9:	0f b6 10             	movzbl (%rax),%edx
  1005fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100600:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  100602:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  100606:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  10060a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  10060e:	48 85 c0             	test   %rax,%rax
  100611:	75 d8                	jne    1005eb <memmove+0x51>
    if (s < d && s + n > d) {
  100613:	eb 2e                	jmp    100643 <memmove+0xa9>
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
  100615:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  100619:	48 8d 42 01          	lea    0x1(%rdx),%rax
  10061d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  100621:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100625:	48 8d 48 01          	lea    0x1(%rax),%rcx
  100629:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  10062d:	0f b6 12             	movzbl (%rdx),%edx
  100630:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  100632:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  100636:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  10063a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  10063e:	48 85 c0             	test   %rax,%rax
  100641:	75 d2                	jne    100615 <memmove+0x7b>
        }
    }
    return dst;
  100643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  100647:	c9                   	leave
  100648:	c3                   	ret

0000000000100649 <memset>:

void* memset(void* v, int c, size_t n) {
  100649:	55                   	push   %rbp
  10064a:	48 89 e5             	mov    %rsp,%rbp
  10064d:	48 83 ec 28          	sub    $0x28,%rsp
  100651:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  100655:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  100658:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  10065c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100660:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  100664:	eb 15                	jmp    10067b <memset+0x32>
        *p = c;
  100666:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100669:	89 c2                	mov    %eax,%edx
  10066b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10066f:	88 10                	mov    %dl,(%rax)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100671:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  100676:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  10067b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  100680:	75 e4                	jne    100666 <memset+0x1d>
    }
    return v;
  100682:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  100686:	c9                   	leave
  100687:	c3                   	ret

0000000000100688 <strlen>:

size_t strlen(const char* s) {
  100688:	55                   	push   %rbp
  100689:	48 89 e5             	mov    %rsp,%rbp
  10068c:	48 83 ec 18          	sub    $0x18,%rsp
  100690:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
  100694:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  10069b:	00 
  10069c:	eb 0a                	jmp    1006a8 <strlen+0x20>
        ++n;
  10069e:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; *s != '\0'; ++s) {
  1006a3:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  1006a8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1006ac:	0f b6 00             	movzbl (%rax),%eax
  1006af:	84 c0                	test   %al,%al
  1006b1:	75 eb                	jne    10069e <strlen+0x16>
    }
    return n;
  1006b3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  1006b7:	c9                   	leave
  1006b8:	c3                   	ret

00000000001006b9 <strnlen>:

size_t strnlen(const char* s, size_t maxlen) {
  1006b9:	55                   	push   %rbp
  1006ba:	48 89 e5             	mov    %rsp,%rbp
  1006bd:	48 83 ec 20          	sub    $0x20,%rsp
  1006c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1006c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    size_t n;
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1006c9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  1006d0:	00 
  1006d1:	eb 0a                	jmp    1006dd <strnlen+0x24>
        ++n;
  1006d3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1006d8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  1006dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1006e1:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  1006e5:	74 0b                	je     1006f2 <strnlen+0x39>
  1006e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1006eb:	0f b6 00             	movzbl (%rax),%eax
  1006ee:	84 c0                	test   %al,%al
  1006f0:	75 e1                	jne    1006d3 <strnlen+0x1a>
    }
    return n;
  1006f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  1006f6:	c9                   	leave
  1006f7:	c3                   	ret

00000000001006f8 <strcpy>:

char* strcpy(char* dst, const char* src) {
  1006f8:	55                   	push   %rbp
  1006f9:	48 89 e5             	mov    %rsp,%rbp
  1006fc:	48 83 ec 20          	sub    $0x20,%rsp
  100700:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  100704:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    char* d = dst;
  100708:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  10070c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    do {
        *d++ = *src++;
  100710:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  100714:	48 8d 42 01          	lea    0x1(%rdx),%rax
  100718:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  10071c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100720:	48 8d 48 01          	lea    0x1(%rax),%rcx
  100724:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
  100728:	0f b6 12             	movzbl (%rdx),%edx
  10072b:	88 10                	mov    %dl,(%rax)
    } while (d[-1]);
  10072d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100731:	48 83 e8 01          	sub    $0x1,%rax
  100735:	0f b6 00             	movzbl (%rax),%eax
  100738:	84 c0                	test   %al,%al
  10073a:	75 d4                	jne    100710 <strcpy+0x18>
    return dst;
  10073c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  100740:	c9                   	leave
  100741:	c3                   	ret

0000000000100742 <strcmp>:

int strcmp(const char* a, const char* b) {
  100742:	55                   	push   %rbp
  100743:	48 89 e5             	mov    %rsp,%rbp
  100746:	48 83 ec 10          	sub    $0x10,%rsp
  10074a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  10074e:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  100752:	eb 0a                	jmp    10075e <strcmp+0x1c>
        ++a, ++b;
  100754:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  100759:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  10075e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100762:	0f b6 00             	movzbl (%rax),%eax
  100765:	84 c0                	test   %al,%al
  100767:	74 1d                	je     100786 <strcmp+0x44>
  100769:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10076d:	0f b6 00             	movzbl (%rax),%eax
  100770:	84 c0                	test   %al,%al
  100772:	74 12                	je     100786 <strcmp+0x44>
  100774:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100778:	0f b6 10             	movzbl (%rax),%edx
  10077b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10077f:	0f b6 00             	movzbl (%rax),%eax
  100782:	38 c2                	cmp    %al,%dl
  100784:	74 ce                	je     100754 <strcmp+0x12>
    }
    return ((unsigned char) *a > (unsigned char) *b)
  100786:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10078a:	0f b6 00             	movzbl (%rax),%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100793:	0f b6 00             	movzbl (%rax),%eax
  100796:	38 d0                	cmp    %dl,%al
  100798:	0f 92 c0             	setb   %al
  10079b:	0f b6 d0             	movzbl %al,%edx
        - ((unsigned char) *a < (unsigned char) *b);
  10079e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1007a2:	0f b6 00             	movzbl (%rax),%eax
  1007a5:	89 c1                	mov    %eax,%ecx
  1007a7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1007ab:	0f b6 00             	movzbl (%rax),%eax
  1007ae:	38 c1                	cmp    %al,%cl
  1007b0:	0f 92 c0             	setb   %al
  1007b3:	0f b6 c0             	movzbl %al,%eax
  1007b6:	29 c2                	sub    %eax,%edx
  1007b8:	89 d0                	mov    %edx,%eax
}
  1007ba:	c9                   	leave
  1007bb:	c3                   	ret

00000000001007bc <strchr>:

char* strchr(const char* s, int c) {
  1007bc:	55                   	push   %rbp
  1007bd:	48 89 e5             	mov    %rsp,%rbp
  1007c0:	48 83 ec 10          	sub    $0x10,%rsp
  1007c4:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  1007c8:	89 75 f4             	mov    %esi,-0xc(%rbp)
    while (*s && *s != (char) c) {
  1007cb:	eb 05                	jmp    1007d2 <strchr+0x16>
        ++s;
  1007cd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while (*s && *s != (char) c) {
  1007d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1007d6:	0f b6 00             	movzbl (%rax),%eax
  1007d9:	84 c0                	test   %al,%al
  1007db:	74 0e                	je     1007eb <strchr+0x2f>
  1007dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1007e1:	0f b6 00             	movzbl (%rax),%eax
  1007e4:	8b 55 f4             	mov    -0xc(%rbp),%edx
  1007e7:	38 d0                	cmp    %dl,%al
  1007e9:	75 e2                	jne    1007cd <strchr+0x11>
    }
    if (*s == (char) c) {
  1007eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1007ef:	0f b6 00             	movzbl (%rax),%eax
  1007f2:	8b 55 f4             	mov    -0xc(%rbp),%edx
  1007f5:	38 d0                	cmp    %dl,%al
  1007f7:	75 06                	jne    1007ff <strchr+0x43>
        return (char*) s;
  1007f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1007fd:	eb 05                	jmp    100804 <strchr+0x48>
    } else {
        return NULL;
  1007ff:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
  100804:	c9                   	leave
  100805:	c3                   	ret

0000000000100806 <rand>:
// rand, srand

static int rand_seed_set;
static unsigned rand_seed;

int rand(void) {
  100806:	55                   	push   %rbp
  100807:	48 89 e5             	mov    %rsp,%rbp
    if (!rand_seed_set) {
  10080a:	8b 05 20 18 00 00    	mov    0x1820(%rip),%eax        # 102030 <rand_seed_set>
  100810:	85 c0                	test   %eax,%eax
  100812:	75 0a                	jne    10081e <rand+0x18>
        srand(819234718U);
  100814:	bf 9e 87 d4 30       	mov    $0x30d4879e,%edi
  100819:	e8 24 00 00 00       	call   100842 <srand>
    }
    rand_seed = rand_seed * 1664525U + 1013904223U;
  10081e:	8b 05 10 18 00 00    	mov    0x1810(%rip),%eax        # 102034 <rand_seed>
  100824:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
  10082a:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  10082f:	89 05 ff 17 00 00    	mov    %eax,0x17ff(%rip)        # 102034 <rand_seed>
    return rand_seed & RAND_MAX;
  100835:	8b 05 f9 17 00 00    	mov    0x17f9(%rip),%eax        # 102034 <rand_seed>
  10083b:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  100840:	5d                   	pop    %rbp
  100841:	c3                   	ret

0000000000100842 <srand>:

void srand(unsigned seed) {
  100842:	55                   	push   %rbp
  100843:	48 89 e5             	mov    %rsp,%rbp
  100846:	48 83 ec 08          	sub    $0x8,%rsp
  10084a:	89 7d fc             	mov    %edi,-0x4(%rbp)
    rand_seed = seed;
  10084d:	8b 45 fc             	mov    -0x4(%rbp),%eax
  100850:	89 05 de 17 00 00    	mov    %eax,0x17de(%rip)        # 102034 <rand_seed>
    rand_seed_set = 1;
  100856:	c7 05 d0 17 00 00 01 	movl   $0x1,0x17d0(%rip)        # 102030 <rand_seed_set>
  10085d:	00 00 00 
}
  100860:	90                   	nop
  100861:	c9                   	leave
  100862:	c3                   	ret

0000000000100863 <fill_numbuf>:
//    Print a message onto the console, starting at the given cursor position.

// snprintf, vsnprintf
//    Format a string into a buffer.

static char* fill_numbuf(char* numbuf_end, unsigned long val, int base) {
  100863:	55                   	push   %rbp
  100864:	48 89 e5             	mov    %rsp,%rbp
  100867:	48 83 ec 28          	sub    $0x28,%rsp
  10086b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  10086f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  100873:	89 55 dc             	mov    %edx,-0x24(%rbp)
    static const char upper_digits[] = "0123456789ABCDEF";
    static const char lower_digits[] = "0123456789abcdef";

    const char* digits = upper_digits;
  100876:	48 c7 45 f8 80 17 10 	movq   $0x101780,-0x8(%rbp)
  10087d:	00 
    if (base < 0) {
  10087e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  100882:	79 0b                	jns    10088f <fill_numbuf+0x2c>
        digits = lower_digits;
  100884:	48 c7 45 f8 a0 17 10 	movq   $0x1017a0,-0x8(%rbp)
  10088b:	00 
        base = -base;
  10088c:	f7 5d dc             	negl   -0x24(%rbp)
    }

    *--numbuf_end = '\0';
  10088f:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  100894:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100898:	c6 00 00             	movb   $0x0,(%rax)
    do {
        *--numbuf_end = digits[val % base];
  10089b:	8b 45 dc             	mov    -0x24(%rbp),%eax
  10089e:	48 63 c8             	movslq %eax,%rcx
  1008a1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1008a5:	ba 00 00 00 00       	mov    $0x0,%edx
  1008aa:	48 f7 f1             	div    %rcx
  1008ad:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1008b1:	48 01 d0             	add    %rdx,%rax
  1008b4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  1008b9:	0f b6 10             	movzbl (%rax),%edx
  1008bc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1008c0:	88 10                	mov    %dl,(%rax)
        val /= base;
  1008c2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  1008c5:	48 63 f0             	movslq %eax,%rsi
  1008c8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1008cc:	ba 00 00 00 00       	mov    $0x0,%edx
  1008d1:	48 f7 f6             	div    %rsi
  1008d4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    } while (val != 0);
  1008d8:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  1008dd:	75 bc                	jne    10089b <fill_numbuf+0x38>
    return numbuf_end;
  1008df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1008e3:	c9                   	leave
  1008e4:	c3                   	ret

00000000001008e5 <printer_vprintf>:
#define FLAG_NUMERIC            (1<<5)
#define FLAG_SIGNED             (1<<6)
#define FLAG_NEGATIVE           (1<<7)
#define FLAG_ALT2               (1<<8)

void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1008e5:	55                   	push   %rbp
  1008e6:	48 89 e5             	mov    %rsp,%rbp
  1008e9:	53                   	push   %rbx
  1008ea:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  1008f1:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
  1008f8:	89 b5 74 ff ff ff    	mov    %esi,-0x8c(%rbp)
  1008fe:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  100905:	48 89 8d 60 ff ff ff 	mov    %rcx,-0xa0(%rbp)
#define NUMBUFSIZ 24
    char numbuf[NUMBUFSIZ];

    for (; *format; ++format) {
  10090c:	e9 8a 09 00 00       	jmp    10129b <printer_vprintf+0x9b6>
        if (*format != '%') {
  100911:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100918:	0f b6 00             	movzbl (%rax),%eax
  10091b:	3c 25                	cmp    $0x25,%al
  10091d:	74 31                	je     100950 <printer_vprintf+0x6b>
            p->putc(p, *format, color);
  10091f:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100926:	4c 8b 00             	mov    (%rax),%r8
  100929:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100930:	0f b6 00             	movzbl (%rax),%eax
  100933:	0f b6 c8             	movzbl %al,%ecx
  100936:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  10093c:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100943:	89 ce                	mov    %ecx,%esi
  100945:	48 89 c7             	mov    %rax,%rdi
  100948:	41 ff d0             	call   *%r8
            continue;
  10094b:	e9 43 09 00 00       	jmp    101293 <printer_vprintf+0x9ae>
        }

        // process flags
        int flags = 0;
  100950:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        for (++format; *format; ++format) {
  100957:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  10095e:	01 
  10095f:	eb 44                	jmp    1009a5 <printer_vprintf+0xc0>
            const char* flagc = strchr(flag_chars, *format);
  100961:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100968:	0f b6 00             	movzbl (%rax),%eax
  10096b:	0f be c0             	movsbl %al,%eax
  10096e:	89 c6                	mov    %eax,%esi
  100970:	bf a0 15 10 00       	mov    $0x1015a0,%edi
  100975:	e8 42 fe ff ff       	call   1007bc <strchr>
  10097a:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (flagc) {
  10097e:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  100983:	74 30                	je     1009b5 <printer_vprintf+0xd0>
                flags |= 1 << (flagc - flag_chars);
  100985:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  100989:	48 2d a0 15 10 00    	sub    $0x1015a0,%rax
  10098f:	ba 01 00 00 00       	mov    $0x1,%edx
  100994:	89 c1                	mov    %eax,%ecx
  100996:	d3 e2                	shl    %cl,%edx
  100998:	89 d0                	mov    %edx,%eax
  10099a:	09 45 ec             	or     %eax,-0x14(%rbp)
        for (++format; *format; ++format) {
  10099d:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1009a4:	01 
  1009a5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1009ac:	0f b6 00             	movzbl (%rax),%eax
  1009af:	84 c0                	test   %al,%al
  1009b1:	75 ae                	jne    100961 <printer_vprintf+0x7c>
  1009b3:	eb 01                	jmp    1009b6 <printer_vprintf+0xd1>
            } else {
                break;
  1009b5:	90                   	nop
            }
        }

        // process width
        int width = -1;
  1009b6:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
        if (*format >= '1' && *format <= '9') {
  1009bd:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1009c4:	0f b6 00             	movzbl (%rax),%eax
  1009c7:	3c 30                	cmp    $0x30,%al
  1009c9:	7e 67                	jle    100a32 <printer_vprintf+0x14d>
  1009cb:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1009d2:	0f b6 00             	movzbl (%rax),%eax
  1009d5:	3c 39                	cmp    $0x39,%al
  1009d7:	7f 59                	jg     100a32 <printer_vprintf+0x14d>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1009d9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  1009e0:	eb 2e                	jmp    100a10 <printer_vprintf+0x12b>
                width = 10 * width + *format++ - '0';
  1009e2:	8b 55 e8             	mov    -0x18(%rbp),%edx
  1009e5:	89 d0                	mov    %edx,%eax
  1009e7:	c1 e0 02             	shl    $0x2,%eax
  1009ea:	01 d0                	add    %edx,%eax
  1009ec:	01 c0                	add    %eax,%eax
  1009ee:	89 c1                	mov    %eax,%ecx
  1009f0:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1009f7:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1009fb:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  100a02:	0f b6 00             	movzbl (%rax),%eax
  100a05:	0f be c0             	movsbl %al,%eax
  100a08:	01 c8                	add    %ecx,%eax
  100a0a:	83 e8 30             	sub    $0x30,%eax
  100a0d:	89 45 e8             	mov    %eax,-0x18(%rbp)
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100a10:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100a17:	0f b6 00             	movzbl (%rax),%eax
  100a1a:	3c 2f                	cmp    $0x2f,%al
  100a1c:	0f 8e 85 00 00 00    	jle    100aa7 <printer_vprintf+0x1c2>
  100a22:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100a29:	0f b6 00             	movzbl (%rax),%eax
  100a2c:	3c 39                	cmp    $0x39,%al
  100a2e:	7e b2                	jle    1009e2 <printer_vprintf+0xfd>
        if (*format >= '1' && *format <= '9') {
  100a30:	eb 75                	jmp    100aa7 <printer_vprintf+0x1c2>
            }
        } else if (*format == '*') {
  100a32:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100a39:	0f b6 00             	movzbl (%rax),%eax
  100a3c:	3c 2a                	cmp    $0x2a,%al
  100a3e:	75 68                	jne    100aa8 <printer_vprintf+0x1c3>
            width = va_arg(val, int);
  100a40:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a47:	8b 00                	mov    (%rax),%eax
  100a49:	83 f8 2f             	cmp    $0x2f,%eax
  100a4c:	77 30                	ja     100a7e <printer_vprintf+0x199>
  100a4e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a55:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100a59:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a60:	8b 00                	mov    (%rax),%eax
  100a62:	89 c0                	mov    %eax,%eax
  100a64:	48 01 d0             	add    %rdx,%rax
  100a67:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a6e:	8b 12                	mov    (%rdx),%edx
  100a70:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100a73:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a7a:	89 0a                	mov    %ecx,(%rdx)
  100a7c:	eb 1a                	jmp    100a98 <printer_vprintf+0x1b3>
  100a7e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a85:	48 8b 40 08          	mov    0x8(%rax),%rax
  100a89:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100a8d:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a94:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100a98:	8b 00                	mov    (%rax),%eax
  100a9a:	89 45 e8             	mov    %eax,-0x18(%rbp)
            ++format;
  100a9d:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100aa4:	01 
  100aa5:	eb 01                	jmp    100aa8 <printer_vprintf+0x1c3>
        if (*format >= '1' && *format <= '9') {
  100aa7:	90                   	nop
        }

        // process precision
        int precision = -1;
  100aa8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
        if (*format == '.') {
  100aaf:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100ab6:	0f b6 00             	movzbl (%rax),%eax
  100ab9:	3c 2e                	cmp    $0x2e,%al
  100abb:	0f 85 00 01 00 00    	jne    100bc1 <printer_vprintf+0x2dc>
            ++format;
  100ac1:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100ac8:	01 
            if (*format >= '0' && *format <= '9') {
  100ac9:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100ad0:	0f b6 00             	movzbl (%rax),%eax
  100ad3:	3c 2f                	cmp    $0x2f,%al
  100ad5:	7e 67                	jle    100b3e <printer_vprintf+0x259>
  100ad7:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100ade:	0f b6 00             	movzbl (%rax),%eax
  100ae1:	3c 39                	cmp    $0x39,%al
  100ae3:	7f 59                	jg     100b3e <printer_vprintf+0x259>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100ae5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  100aec:	eb 2e                	jmp    100b1c <printer_vprintf+0x237>
                    precision = 10 * precision + *format++ - '0';
  100aee:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  100af1:	89 d0                	mov    %edx,%eax
  100af3:	c1 e0 02             	shl    $0x2,%eax
  100af6:	01 d0                	add    %edx,%eax
  100af8:	01 c0                	add    %eax,%eax
  100afa:	89 c1                	mov    %eax,%ecx
  100afc:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100b03:	48 8d 50 01          	lea    0x1(%rax),%rdx
  100b07:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  100b0e:	0f b6 00             	movzbl (%rax),%eax
  100b11:	0f be c0             	movsbl %al,%eax
  100b14:	01 c8                	add    %ecx,%eax
  100b16:	83 e8 30             	sub    $0x30,%eax
  100b19:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100b1c:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100b23:	0f b6 00             	movzbl (%rax),%eax
  100b26:	3c 2f                	cmp    $0x2f,%al
  100b28:	0f 8e 85 00 00 00    	jle    100bb3 <printer_vprintf+0x2ce>
  100b2e:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100b35:	0f b6 00             	movzbl (%rax),%eax
  100b38:	3c 39                	cmp    $0x39,%al
  100b3a:	7e b2                	jle    100aee <printer_vprintf+0x209>
            if (*format >= '0' && *format <= '9') {
  100b3c:	eb 75                	jmp    100bb3 <printer_vprintf+0x2ce>
                }
            } else if (*format == '*') {
  100b3e:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100b45:	0f b6 00             	movzbl (%rax),%eax
  100b48:	3c 2a                	cmp    $0x2a,%al
  100b4a:	75 68                	jne    100bb4 <printer_vprintf+0x2cf>
                precision = va_arg(val, int);
  100b4c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b53:	8b 00                	mov    (%rax),%eax
  100b55:	83 f8 2f             	cmp    $0x2f,%eax
  100b58:	77 30                	ja     100b8a <printer_vprintf+0x2a5>
  100b5a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b61:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100b65:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b6c:	8b 00                	mov    (%rax),%eax
  100b6e:	89 c0                	mov    %eax,%eax
  100b70:	48 01 d0             	add    %rdx,%rax
  100b73:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b7a:	8b 12                	mov    (%rdx),%edx
  100b7c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100b7f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b86:	89 0a                	mov    %ecx,(%rdx)
  100b88:	eb 1a                	jmp    100ba4 <printer_vprintf+0x2bf>
  100b8a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b91:	48 8b 40 08          	mov    0x8(%rax),%rax
  100b95:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100b99:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100ba0:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100ba4:	8b 00                	mov    (%rax),%eax
  100ba6:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                ++format;
  100ba9:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100bb0:	01 
  100bb1:	eb 01                	jmp    100bb4 <printer_vprintf+0x2cf>
            if (*format >= '0' && *format <= '9') {
  100bb3:	90                   	nop
            }
            if (precision < 0) {
  100bb4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  100bb8:	79 07                	jns    100bc1 <printer_vprintf+0x2dc>
                precision = 0;
  100bba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
            }
        }

        // process main conversion character
        int base = 10;
  100bc1:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%rbp)
        unsigned long num = 0;
  100bc8:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  100bcf:	00 
        int length = 0;
  100bd0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
        char* data = "";
  100bd7:	48 c7 45 c8 a6 15 10 	movq   $0x1015a6,-0x38(%rbp)
  100bde:	00 
    again:
        switch (*format) {
  100bdf:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100be6:	0f b6 00             	movzbl (%rax),%eax
  100be9:	0f be c0             	movsbl %al,%eax
  100bec:	83 e8 43             	sub    $0x43,%eax
  100bef:	83 f8 37             	cmp    $0x37,%eax
  100bf2:	0f 87 9f 03 00 00    	ja     100f97 <printer_vprintf+0x6b2>
  100bf8:	89 c0                	mov    %eax,%eax
  100bfa:	48 8b 04 c5 b8 15 10 	mov    0x1015b8(,%rax,8),%rax
  100c01:	00 
  100c02:	ff e0                	jmp    *%rax
        case 'l':
        case 'z':
            length = 1;
  100c04:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
            ++format;
  100c0b:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100c12:	01 
            goto again;
  100c13:	eb ca                	jmp    100bdf <printer_vprintf+0x2fa>
        case 'd':
        case 'i': {
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100c15:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  100c19:	74 5d                	je     100c78 <printer_vprintf+0x393>
  100c1b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c22:	8b 00                	mov    (%rax),%eax
  100c24:	83 f8 2f             	cmp    $0x2f,%eax
  100c27:	77 30                	ja     100c59 <printer_vprintf+0x374>
  100c29:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c30:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100c34:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c3b:	8b 00                	mov    (%rax),%eax
  100c3d:	89 c0                	mov    %eax,%eax
  100c3f:	48 01 d0             	add    %rdx,%rax
  100c42:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c49:	8b 12                	mov    (%rdx),%edx
  100c4b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100c4e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c55:	89 0a                	mov    %ecx,(%rdx)
  100c57:	eb 1a                	jmp    100c73 <printer_vprintf+0x38e>
  100c59:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c60:	48 8b 40 08          	mov    0x8(%rax),%rax
  100c64:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100c68:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c6f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100c73:	48 8b 00             	mov    (%rax),%rax
  100c76:	eb 5c                	jmp    100cd4 <printer_vprintf+0x3ef>
  100c78:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c7f:	8b 00                	mov    (%rax),%eax
  100c81:	83 f8 2f             	cmp    $0x2f,%eax
  100c84:	77 30                	ja     100cb6 <printer_vprintf+0x3d1>
  100c86:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c8d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100c91:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c98:	8b 00                	mov    (%rax),%eax
  100c9a:	89 c0                	mov    %eax,%eax
  100c9c:	48 01 d0             	add    %rdx,%rax
  100c9f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100ca6:	8b 12                	mov    (%rdx),%edx
  100ca8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100cab:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100cb2:	89 0a                	mov    %ecx,(%rdx)
  100cb4:	eb 1a                	jmp    100cd0 <printer_vprintf+0x3eb>
  100cb6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100cbd:	48 8b 40 08          	mov    0x8(%rax),%rax
  100cc1:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100cc5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100ccc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100cd0:	8b 00                	mov    (%rax),%eax
  100cd2:	48 98                	cltq
  100cd4:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  100cd8:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100cdc:	48 c1 f8 38          	sar    $0x38,%rax
  100ce0:	25 80 00 00 00       	and    $0x80,%eax
  100ce5:	89 45 a4             	mov    %eax,-0x5c(%rbp)
            num = negative ? -x : x;
  100ce8:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  100cec:	74 09                	je     100cf7 <printer_vprintf+0x412>
  100cee:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100cf2:	48 f7 d8             	neg    %rax
  100cf5:	eb 04                	jmp    100cfb <printer_vprintf+0x416>
  100cf7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100cfb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  100cff:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  100d02:	83 c8 60             	or     $0x60,%eax
  100d05:	09 45 ec             	or     %eax,-0x14(%rbp)
            break;
  100d08:	e9 cf 02 00 00       	jmp    100fdc <printer_vprintf+0x6f7>
        }
        case 'u':
        format_unsigned:
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100d0d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  100d11:	74 5d                	je     100d70 <printer_vprintf+0x48b>
  100d13:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100d1a:	8b 00                	mov    (%rax),%eax
  100d1c:	83 f8 2f             	cmp    $0x2f,%eax
  100d1f:	77 30                	ja     100d51 <printer_vprintf+0x46c>
  100d21:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100d28:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100d2c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100d33:	8b 00                	mov    (%rax),%eax
  100d35:	89 c0                	mov    %eax,%eax
  100d37:	48 01 d0             	add    %rdx,%rax
  100d3a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100d41:	8b 12                	mov    (%rdx),%edx
  100d43:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100d46:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100d4d:	89 0a                	mov    %ecx,(%rdx)
  100d4f:	eb 1a                	jmp    100d6b <printer_vprintf+0x486>
  100d51:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100d58:	48 8b 40 08          	mov    0x8(%rax),%rax
  100d5c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100d60:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100d67:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100d6b:	48 8b 00             	mov    (%rax),%rax
  100d6e:	eb 5c                	jmp    100dcc <printer_vprintf+0x4e7>
  100d70:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100d77:	8b 00                	mov    (%rax),%eax
  100d79:	83 f8 2f             	cmp    $0x2f,%eax
  100d7c:	77 30                	ja     100dae <printer_vprintf+0x4c9>
  100d7e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100d85:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100d89:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100d90:	8b 00                	mov    (%rax),%eax
  100d92:	89 c0                	mov    %eax,%eax
  100d94:	48 01 d0             	add    %rdx,%rax
  100d97:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100d9e:	8b 12                	mov    (%rdx),%edx
  100da0:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100da3:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100daa:	89 0a                	mov    %ecx,(%rdx)
  100dac:	eb 1a                	jmp    100dc8 <printer_vprintf+0x4e3>
  100dae:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100db5:	48 8b 40 08          	mov    0x8(%rax),%rax
  100db9:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100dbd:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100dc4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100dc8:	8b 00                	mov    (%rax),%eax
  100dca:	89 c0                	mov    %eax,%eax
  100dcc:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC;
  100dd0:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
            break;
  100dd4:	e9 03 02 00 00       	jmp    100fdc <printer_vprintf+0x6f7>
        case 'x':
            base = -16;
  100dd9:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            goto format_unsigned;
  100de0:	e9 28 ff ff ff       	jmp    100d0d <printer_vprintf+0x428>
        case 'X':
            base = 16;
  100de5:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%rbp)
            goto format_unsigned;
  100dec:	e9 1c ff ff ff       	jmp    100d0d <printer_vprintf+0x428>
        case 'p':
            num = (uintptr_t) va_arg(val, void*);
  100df1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100df8:	8b 00                	mov    (%rax),%eax
  100dfa:	83 f8 2f             	cmp    $0x2f,%eax
  100dfd:	77 30                	ja     100e2f <printer_vprintf+0x54a>
  100dff:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100e06:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100e0a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100e11:	8b 00                	mov    (%rax),%eax
  100e13:	89 c0                	mov    %eax,%eax
  100e15:	48 01 d0             	add    %rdx,%rax
  100e18:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100e1f:	8b 12                	mov    (%rdx),%edx
  100e21:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100e24:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100e2b:	89 0a                	mov    %ecx,(%rdx)
  100e2d:	eb 1a                	jmp    100e49 <printer_vprintf+0x564>
  100e2f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100e36:	48 8b 40 08          	mov    0x8(%rax),%rax
  100e3a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100e3e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100e45:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100e49:	48 8b 00             	mov    (%rax),%rax
  100e4c:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            base = -16;
  100e50:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  100e57:	81 4d ec 21 01 00 00 	orl    $0x121,-0x14(%rbp)
            break;
  100e5e:	e9 79 01 00 00       	jmp    100fdc <printer_vprintf+0x6f7>
        case 's':
            data = va_arg(val, char*);
  100e63:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100e6a:	8b 00                	mov    (%rax),%eax
  100e6c:	83 f8 2f             	cmp    $0x2f,%eax
  100e6f:	77 30                	ja     100ea1 <printer_vprintf+0x5bc>
  100e71:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100e78:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100e7c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100e83:	8b 00                	mov    (%rax),%eax
  100e85:	89 c0                	mov    %eax,%eax
  100e87:	48 01 d0             	add    %rdx,%rax
  100e8a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100e91:	8b 12                	mov    (%rdx),%edx
  100e93:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100e96:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100e9d:	89 0a                	mov    %ecx,(%rdx)
  100e9f:	eb 1a                	jmp    100ebb <printer_vprintf+0x5d6>
  100ea1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ea8:	48 8b 40 08          	mov    0x8(%rax),%rax
  100eac:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100eb0:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100eb7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100ebb:	48 8b 00             	mov    (%rax),%rax
  100ebe:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            break;
  100ec2:	e9 15 01 00 00       	jmp    100fdc <printer_vprintf+0x6f7>
        case 'C':
            color = va_arg(val, int);
  100ec7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ece:	8b 00                	mov    (%rax),%eax
  100ed0:	83 f8 2f             	cmp    $0x2f,%eax
  100ed3:	77 30                	ja     100f05 <printer_vprintf+0x620>
  100ed5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100edc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100ee0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ee7:	8b 00                	mov    (%rax),%eax
  100ee9:	89 c0                	mov    %eax,%eax
  100eeb:	48 01 d0             	add    %rdx,%rax
  100eee:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100ef5:	8b 12                	mov    (%rdx),%edx
  100ef7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100efa:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100f01:	89 0a                	mov    %ecx,(%rdx)
  100f03:	eb 1a                	jmp    100f1f <printer_vprintf+0x63a>
  100f05:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100f0c:	48 8b 40 08          	mov    0x8(%rax),%rax
  100f10:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100f14:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100f1b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100f1f:	8b 00                	mov    (%rax),%eax
  100f21:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
            goto done;
  100f27:	e9 67 03 00 00       	jmp    101293 <printer_vprintf+0x9ae>
        case 'c':
            data = numbuf;
  100f2c:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100f30:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = va_arg(val, int);
  100f34:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100f3b:	8b 00                	mov    (%rax),%eax
  100f3d:	83 f8 2f             	cmp    $0x2f,%eax
  100f40:	77 30                	ja     100f72 <printer_vprintf+0x68d>
  100f42:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100f49:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100f4d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100f54:	8b 00                	mov    (%rax),%eax
  100f56:	89 c0                	mov    %eax,%eax
  100f58:	48 01 d0             	add    %rdx,%rax
  100f5b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100f62:	8b 12                	mov    (%rdx),%edx
  100f64:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100f67:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100f6e:	89 0a                	mov    %ecx,(%rdx)
  100f70:	eb 1a                	jmp    100f8c <printer_vprintf+0x6a7>
  100f72:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100f79:	48 8b 40 08          	mov    0x8(%rax),%rax
  100f7d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100f81:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100f88:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100f8c:	8b 00                	mov    (%rax),%eax
  100f8e:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  100f91:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            break;
  100f95:	eb 45                	jmp    100fdc <printer_vprintf+0x6f7>
        default:
            data = numbuf;
  100f97:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100f9b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = (*format ? *format : '%');
  100f9f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100fa6:	0f b6 00             	movzbl (%rax),%eax
  100fa9:	84 c0                	test   %al,%al
  100fab:	74 0c                	je     100fb9 <printer_vprintf+0x6d4>
  100fad:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100fb4:	0f b6 00             	movzbl (%rax),%eax
  100fb7:	eb 05                	jmp    100fbe <printer_vprintf+0x6d9>
  100fb9:	b8 25 00 00 00       	mov    $0x25,%eax
  100fbe:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  100fc1:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            if (!*format) {
  100fc5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100fcc:	0f b6 00             	movzbl (%rax),%eax
  100fcf:	84 c0                	test   %al,%al
  100fd1:	75 08                	jne    100fdb <printer_vprintf+0x6f6>
                format--;
  100fd3:	48 83 ad 68 ff ff ff 	subq   $0x1,-0x98(%rbp)
  100fda:	01 
            }
            break;
  100fdb:	90                   	nop
        }

        if (flags & FLAG_NUMERIC) {
  100fdc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100fdf:	83 e0 20             	and    $0x20,%eax
  100fe2:	85 c0                	test   %eax,%eax
  100fe4:	74 1e                	je     101004 <printer_vprintf+0x71f>
            data = fill_numbuf(numbuf + NUMBUFSIZ, num, base);
  100fe6:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100fea:	48 83 c0 18          	add    $0x18,%rax
  100fee:	8b 55 e0             	mov    -0x20(%rbp),%edx
  100ff1:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  100ff5:	48 89 ce             	mov    %rcx,%rsi
  100ff8:	48 89 c7             	mov    %rax,%rdi
  100ffb:	e8 63 f8 ff ff       	call   100863 <fill_numbuf>
  101000:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        }

        const char* prefix = "";
  101004:	48 c7 45 c0 a6 15 10 	movq   $0x1015a6,-0x40(%rbp)
  10100b:	00 
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  10100c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  10100f:	83 e0 20             	and    $0x20,%eax
  101012:	85 c0                	test   %eax,%eax
  101014:	74 48                	je     10105e <printer_vprintf+0x779>
  101016:	8b 45 ec             	mov    -0x14(%rbp),%eax
  101019:	83 e0 40             	and    $0x40,%eax
  10101c:	85 c0                	test   %eax,%eax
  10101e:	74 3e                	je     10105e <printer_vprintf+0x779>
            if (flags & FLAG_NEGATIVE) {
  101020:	8b 45 ec             	mov    -0x14(%rbp),%eax
  101023:	25 80 00 00 00       	and    $0x80,%eax
  101028:	85 c0                	test   %eax,%eax
  10102a:	74 0a                	je     101036 <printer_vprintf+0x751>
                prefix = "-";
  10102c:	48 c7 45 c0 a7 15 10 	movq   $0x1015a7,-0x40(%rbp)
  101033:	00 
            if (flags & FLAG_NEGATIVE) {
  101034:	eb 73                	jmp    1010a9 <printer_vprintf+0x7c4>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  101036:	8b 45 ec             	mov    -0x14(%rbp),%eax
  101039:	83 e0 10             	and    $0x10,%eax
  10103c:	85 c0                	test   %eax,%eax
  10103e:	74 0a                	je     10104a <printer_vprintf+0x765>
                prefix = "+";
  101040:	48 c7 45 c0 a9 15 10 	movq   $0x1015a9,-0x40(%rbp)
  101047:	00 
            if (flags & FLAG_NEGATIVE) {
  101048:	eb 5f                	jmp    1010a9 <printer_vprintf+0x7c4>
            } else if (flags & FLAG_SPACEPOSITIVE) {
  10104a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  10104d:	83 e0 08             	and    $0x8,%eax
  101050:	85 c0                	test   %eax,%eax
  101052:	74 55                	je     1010a9 <printer_vprintf+0x7c4>
                prefix = " ";
  101054:	48 c7 45 c0 ab 15 10 	movq   $0x1015ab,-0x40(%rbp)
  10105b:	00 
            if (flags & FLAG_NEGATIVE) {
  10105c:	eb 4b                	jmp    1010a9 <printer_vprintf+0x7c4>
            }
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  10105e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  101061:	83 e0 20             	and    $0x20,%eax
  101064:	85 c0                	test   %eax,%eax
  101066:	74 42                	je     1010aa <printer_vprintf+0x7c5>
  101068:	8b 45 ec             	mov    -0x14(%rbp),%eax
  10106b:	83 e0 01             	and    $0x1,%eax
  10106e:	85 c0                	test   %eax,%eax
  101070:	74 38                	je     1010aa <printer_vprintf+0x7c5>
                   && (base == 16 || base == -16)
  101072:	83 7d e0 10          	cmpl   $0x10,-0x20(%rbp)
  101076:	74 06                	je     10107e <printer_vprintf+0x799>
  101078:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  10107c:	75 2c                	jne    1010aa <printer_vprintf+0x7c5>
                   && (num || (flags & FLAG_ALT2))) {
  10107e:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  101083:	75 0c                	jne    101091 <printer_vprintf+0x7ac>
  101085:	8b 45 ec             	mov    -0x14(%rbp),%eax
  101088:	25 00 01 00 00       	and    $0x100,%eax
  10108d:	85 c0                	test   %eax,%eax
  10108f:	74 19                	je     1010aa <printer_vprintf+0x7c5>
            prefix = (base == -16 ? "0x" : "0X");
  101091:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  101095:	75 07                	jne    10109e <printer_vprintf+0x7b9>
  101097:	b8 ad 15 10 00       	mov    $0x1015ad,%eax
  10109c:	eb 05                	jmp    1010a3 <printer_vprintf+0x7be>
  10109e:	b8 b0 15 10 00       	mov    $0x1015b0,%eax
  1010a3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1010a7:	eb 01                	jmp    1010aa <printer_vprintf+0x7c5>
            if (flags & FLAG_NEGATIVE) {
  1010a9:	90                   	nop
        }

        int len;
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  1010aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  1010ae:	78 24                	js     1010d4 <printer_vprintf+0x7ef>
  1010b0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1010b3:	83 e0 20             	and    $0x20,%eax
  1010b6:	85 c0                	test   %eax,%eax
  1010b8:	75 1a                	jne    1010d4 <printer_vprintf+0x7ef>
            len = strnlen(data, precision);
  1010ba:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1010bd:	48 63 d0             	movslq %eax,%rdx
  1010c0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  1010c4:	48 89 d6             	mov    %rdx,%rsi
  1010c7:	48 89 c7             	mov    %rax,%rdi
  1010ca:	e8 ea f5 ff ff       	call   1006b9 <strnlen>
  1010cf:	89 45 bc             	mov    %eax,-0x44(%rbp)
  1010d2:	eb 0f                	jmp    1010e3 <printer_vprintf+0x7fe>
        } else {
            len = strlen(data);
  1010d4:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  1010d8:	48 89 c7             	mov    %rax,%rdi
  1010db:	e8 a8 f5 ff ff       	call   100688 <strlen>
  1010e0:	89 45 bc             	mov    %eax,-0x44(%rbp)
        }
        int zeros;
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  1010e3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1010e6:	83 e0 20             	and    $0x20,%eax
  1010e9:	85 c0                	test   %eax,%eax
  1010eb:	74 20                	je     10110d <printer_vprintf+0x828>
  1010ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  1010f1:	78 1a                	js     10110d <printer_vprintf+0x828>
            zeros = precision > len ? precision - len : 0;
  1010f3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1010f6:	3b 45 bc             	cmp    -0x44(%rbp),%eax
  1010f9:	7e 08                	jle    101103 <printer_vprintf+0x81e>
  1010fb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1010fe:	2b 45 bc             	sub    -0x44(%rbp),%eax
  101101:	eb 05                	jmp    101108 <printer_vprintf+0x823>
  101103:	b8 00 00 00 00       	mov    $0x0,%eax
  101108:	89 45 b8             	mov    %eax,-0x48(%rbp)
  10110b:	eb 5c                	jmp    101169 <printer_vprintf+0x884>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  10110d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  101110:	83 e0 20             	and    $0x20,%eax
  101113:	85 c0                	test   %eax,%eax
  101115:	74 4b                	je     101162 <printer_vprintf+0x87d>
  101117:	8b 45 ec             	mov    -0x14(%rbp),%eax
  10111a:	83 e0 02             	and    $0x2,%eax
  10111d:	85 c0                	test   %eax,%eax
  10111f:	74 41                	je     101162 <printer_vprintf+0x87d>
                   && !(flags & FLAG_LEFTJUSTIFY)
  101121:	8b 45 ec             	mov    -0x14(%rbp),%eax
  101124:	83 e0 04             	and    $0x4,%eax
  101127:	85 c0                	test   %eax,%eax
  101129:	75 37                	jne    101162 <printer_vprintf+0x87d>
                   && len + (int) strlen(prefix) < width) {
  10112b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  10112f:	48 89 c7             	mov    %rax,%rdi
  101132:	e8 51 f5 ff ff       	call   100688 <strlen>
  101137:	89 c2                	mov    %eax,%edx
  101139:	8b 45 bc             	mov    -0x44(%rbp),%eax
  10113c:	01 d0                	add    %edx,%eax
  10113e:	39 45 e8             	cmp    %eax,-0x18(%rbp)
  101141:	7e 1f                	jle    101162 <printer_vprintf+0x87d>
            zeros = width - len - strlen(prefix);
  101143:	8b 45 e8             	mov    -0x18(%rbp),%eax
  101146:	2b 45 bc             	sub    -0x44(%rbp),%eax
  101149:	89 c3                	mov    %eax,%ebx
  10114b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  10114f:	48 89 c7             	mov    %rax,%rdi
  101152:	e8 31 f5 ff ff       	call   100688 <strlen>
  101157:	89 c2                	mov    %eax,%edx
  101159:	89 d8                	mov    %ebx,%eax
  10115b:	29 d0                	sub    %edx,%eax
  10115d:	89 45 b8             	mov    %eax,-0x48(%rbp)
  101160:	eb 07                	jmp    101169 <printer_vprintf+0x884>
        } else {
            zeros = 0;
  101162:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
        }
        width -= len + zeros + strlen(prefix);
  101169:	8b 55 bc             	mov    -0x44(%rbp),%edx
  10116c:	8b 45 b8             	mov    -0x48(%rbp),%eax
  10116f:	01 d0                	add    %edx,%eax
  101171:	48 63 d8             	movslq %eax,%rbx
  101174:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  101178:	48 89 c7             	mov    %rax,%rdi
  10117b:	e8 08 f5 ff ff       	call   100688 <strlen>
  101180:	48 8d 14 03          	lea    (%rbx,%rax,1),%rdx
  101184:	8b 45 e8             	mov    -0x18(%rbp),%eax
  101187:	29 d0                	sub    %edx,%eax
  101189:	89 45 e8             	mov    %eax,-0x18(%rbp)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  10118c:	eb 25                	jmp    1011b3 <printer_vprintf+0x8ce>
            p->putc(p, ' ', color);
  10118e:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  101195:	48 8b 08             	mov    (%rax),%rcx
  101198:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  10119e:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1011a5:	be 20 00 00 00       	mov    $0x20,%esi
  1011aa:	48 89 c7             	mov    %rax,%rdi
  1011ad:	ff d1                	call   *%rcx
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1011af:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  1011b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1011b6:	83 e0 04             	and    $0x4,%eax
  1011b9:	85 c0                	test   %eax,%eax
  1011bb:	75 36                	jne    1011f3 <printer_vprintf+0x90e>
  1011bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  1011c1:	7f cb                	jg     10118e <printer_vprintf+0x8a9>
        }
        for (; *prefix; ++prefix) {
  1011c3:	eb 2e                	jmp    1011f3 <printer_vprintf+0x90e>
            p->putc(p, *prefix, color);
  1011c5:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1011cc:	4c 8b 00             	mov    (%rax),%r8
  1011cf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  1011d3:	0f b6 00             	movzbl (%rax),%eax
  1011d6:	0f b6 c8             	movzbl %al,%ecx
  1011d9:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1011df:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1011e6:	89 ce                	mov    %ecx,%esi
  1011e8:	48 89 c7             	mov    %rax,%rdi
  1011eb:	41 ff d0             	call   *%r8
        for (; *prefix; ++prefix) {
  1011ee:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  1011f3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  1011f7:	0f b6 00             	movzbl (%rax),%eax
  1011fa:	84 c0                	test   %al,%al
  1011fc:	75 c7                	jne    1011c5 <printer_vprintf+0x8e0>
        }
        for (; zeros > 0; --zeros) {
  1011fe:	eb 25                	jmp    101225 <printer_vprintf+0x940>
            p->putc(p, '0', color);
  101200:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  101207:	48 8b 08             	mov    (%rax),%rcx
  10120a:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  101210:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  101217:	be 30 00 00 00       	mov    $0x30,%esi
  10121c:	48 89 c7             	mov    %rax,%rdi
  10121f:	ff d1                	call   *%rcx
        for (; zeros > 0; --zeros) {
  101221:	83 6d b8 01          	subl   $0x1,-0x48(%rbp)
  101225:	83 7d b8 00          	cmpl   $0x0,-0x48(%rbp)
  101229:	7f d5                	jg     101200 <printer_vprintf+0x91b>
        }
        for (; len > 0; ++data, --len) {
  10122b:	eb 32                	jmp    10125f <printer_vprintf+0x97a>
            p->putc(p, *data, color);
  10122d:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  101234:	4c 8b 00             	mov    (%rax),%r8
  101237:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  10123b:	0f b6 00             	movzbl (%rax),%eax
  10123e:	0f b6 c8             	movzbl %al,%ecx
  101241:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  101247:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  10124e:	89 ce                	mov    %ecx,%esi
  101250:	48 89 c7             	mov    %rax,%rdi
  101253:	41 ff d0             	call   *%r8
        for (; len > 0; ++data, --len) {
  101256:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  10125b:	83 6d bc 01          	subl   $0x1,-0x44(%rbp)
  10125f:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  101263:	7f c8                	jg     10122d <printer_vprintf+0x948>
        }
        for (; width > 0; --width) {
  101265:	eb 25                	jmp    10128c <printer_vprintf+0x9a7>
            p->putc(p, ' ', color);
  101267:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  10126e:	48 8b 08             	mov    (%rax),%rcx
  101271:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  101277:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  10127e:	be 20 00 00 00       	mov    $0x20,%esi
  101283:	48 89 c7             	mov    %rax,%rdi
  101286:	ff d1                	call   *%rcx
        for (; width > 0; --width) {
  101288:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  10128c:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  101290:	7f d5                	jg     101267 <printer_vprintf+0x982>
        }
    done: ;
  101292:	90                   	nop
    for (; *format; ++format) {
  101293:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  10129a:	01 
  10129b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1012a2:	0f b6 00             	movzbl (%rax),%eax
  1012a5:	84 c0                	test   %al,%al
  1012a7:	0f 85 64 f6 ff ff    	jne    100911 <printer_vprintf+0x2c>
    }
}
  1012ad:	90                   	nop
  1012ae:	90                   	nop
  1012af:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  1012b3:	c9                   	leave
  1012b4:	c3                   	ret

00000000001012b5 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  1012b5:	55                   	push   %rbp
  1012b6:	48 89 e5             	mov    %rsp,%rbp
  1012b9:	48 83 ec 20          	sub    $0x20,%rsp
  1012bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1012c1:	89 f0                	mov    %esi,%eax
  1012c3:	89 55 e0             	mov    %edx,-0x20(%rbp)
  1012c6:	88 45 e4             	mov    %al,-0x1c(%rbp)
    console_printer* cp = (console_printer*) p;
  1012c9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1012cd:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1012d1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1012d5:	48 8b 40 08          	mov    0x8(%rax),%rax
  1012d9:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
  1012de:	48 39 d0             	cmp    %rdx,%rax
  1012e1:	72 0c                	jb     1012ef <console_putc+0x3a>
        cp->cursor = console;
  1012e3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1012e7:	48 c7 40 08 00 80 0b 	movq   $0xb8000,0x8(%rax)
  1012ee:	00 
    }
    if (c == '\n') {
  1012ef:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%rbp)
  1012f3:	75 78                	jne    10136d <console_putc+0xb8>
        int pos = (cp->cursor - console) % 80;
  1012f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1012f9:	48 8b 40 08          	mov    0x8(%rax),%rax
  1012fd:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  101303:	48 d1 f8             	sar    %rax
  101306:	48 89 c1             	mov    %rax,%rcx
  101309:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  101310:	66 66 66 
  101313:	48 89 c8             	mov    %rcx,%rax
  101316:	48 f7 ea             	imul   %rdx
  101319:	48 c1 fa 05          	sar    $0x5,%rdx
  10131d:	48 89 c8             	mov    %rcx,%rax
  101320:	48 c1 f8 3f          	sar    $0x3f,%rax
  101324:	48 29 c2             	sub    %rax,%rdx
  101327:	48 89 d0             	mov    %rdx,%rax
  10132a:	48 c1 e0 02          	shl    $0x2,%rax
  10132e:	48 01 d0             	add    %rdx,%rax
  101331:	48 c1 e0 04          	shl    $0x4,%rax
  101335:	48 29 c1             	sub    %rax,%rcx
  101338:	48 89 ca             	mov    %rcx,%rdx
  10133b:	89 55 fc             	mov    %edx,-0x4(%rbp)
        for (; pos != 80; pos++) {
  10133e:	eb 25                	jmp    101365 <console_putc+0xb0>
            *cp->cursor++ = ' ' | color;
  101340:	8b 45 e0             	mov    -0x20(%rbp),%eax
  101343:	83 c8 20             	or     $0x20,%eax
  101346:	89 c6                	mov    %eax,%esi
  101348:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10134c:	48 8b 40 08          	mov    0x8(%rax),%rax
  101350:	48 8d 48 02          	lea    0x2(%rax),%rcx
  101354:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  101358:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  10135c:	89 f2                	mov    %esi,%edx
  10135e:	66 89 10             	mov    %dx,(%rax)
        for (; pos != 80; pos++) {
  101361:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  101365:	83 7d fc 50          	cmpl   $0x50,-0x4(%rbp)
  101369:	75 d5                	jne    101340 <console_putc+0x8b>
        }
    } else {
        *cp->cursor++ = c | color;
    }
}
  10136b:	eb 24                	jmp    101391 <console_putc+0xdc>
        *cp->cursor++ = c | color;
  10136d:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
  101371:	8b 55 e0             	mov    -0x20(%rbp),%edx
  101374:	09 d0                	or     %edx,%eax
  101376:	89 c6                	mov    %eax,%esi
  101378:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10137c:	48 8b 40 08          	mov    0x8(%rax),%rax
  101380:	48 8d 48 02          	lea    0x2(%rax),%rcx
  101384:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  101388:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  10138c:	89 f2                	mov    %esi,%edx
  10138e:	66 89 10             	mov    %dx,(%rax)
}
  101391:	90                   	nop
  101392:	c9                   	leave
  101393:	c3                   	ret

0000000000101394 <console_vprintf>:

int console_vprintf(int cpos, int color, const char* format, va_list val) {
  101394:	55                   	push   %rbp
  101395:	48 89 e5             	mov    %rsp,%rbp
  101398:	48 83 ec 30          	sub    $0x30,%rsp
  10139c:	89 7d ec             	mov    %edi,-0x14(%rbp)
  10139f:	89 75 e8             	mov    %esi,-0x18(%rbp)
  1013a2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  1013a6:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
    struct console_printer cp;
    cp.p.putc = console_putc;
  1013aa:	48 c7 45 f0 b5 12 10 	movq   $0x1012b5,-0x10(%rbp)
  1013b1:	00 
    if (cpos < 0 || cpos >= CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1013b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  1013b6:	78 09                	js     1013c1 <console_vprintf+0x2d>
  1013b8:	81 7d ec cf 07 00 00 	cmpl   $0x7cf,-0x14(%rbp)
  1013bf:	7e 07                	jle    1013c8 <console_vprintf+0x34>
        cpos = 0;
  1013c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
    cp.cursor = console + cpos;
  1013c8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1013cb:	48 98                	cltq
  1013cd:	48 01 c0             	add    %rax,%rax
  1013d0:	48 05 00 80 0b 00    	add    $0xb8000,%rax
  1013d6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1013da:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  1013de:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  1013e2:	8b 75 e8             	mov    -0x18(%rbp),%esi
  1013e5:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  1013e9:	48 89 c7             	mov    %rax,%rdi
  1013ec:	e8 f4 f4 ff ff       	call   1008e5 <printer_vprintf>
    return cp.cursor - console;
  1013f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1013f5:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1013fb:	48 d1 f8             	sar    %rax
}
  1013fe:	c9                   	leave
  1013ff:	c3                   	ret

0000000000101400 <console_printf>:

int console_printf(int cpos, int color, const char* format, ...) {
  101400:	55                   	push   %rbp
  101401:	48 89 e5             	mov    %rsp,%rbp
  101404:	48 83 ec 60          	sub    $0x60,%rsp
  101408:	89 7d ac             	mov    %edi,-0x54(%rbp)
  10140b:	89 75 a8             	mov    %esi,-0x58(%rbp)
  10140e:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  101412:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  101416:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  10141a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  10141e:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  101425:	48 8d 45 10          	lea    0x10(%rbp),%rax
  101429:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  10142d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  101431:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  101435:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  101439:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  10143d:	8b 75 a8             	mov    -0x58(%rbp),%esi
  101440:	8b 45 ac             	mov    -0x54(%rbp),%eax
  101443:	89 c7                	mov    %eax,%edi
  101445:	e8 4a ff ff ff       	call   101394 <console_vprintf>
  10144a:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
  10144d:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
  101450:	c9                   	leave
  101451:	c3                   	ret

0000000000101452 <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  101452:	55                   	push   %rbp
  101453:	48 89 e5             	mov    %rsp,%rbp
  101456:	48 83 ec 20          	sub    $0x20,%rsp
  10145a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  10145e:	89 f0                	mov    %esi,%eax
  101460:	89 55 e0             	mov    %edx,-0x20(%rbp)
  101463:	88 45 e4             	mov    %al,-0x1c(%rbp)
    string_printer* sp = (string_printer*) p;
  101466:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  10146a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (sp->s < sp->end) {
  10146e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  101472:	48 8b 50 08          	mov    0x8(%rax),%rdx
  101476:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10147a:	48 8b 40 10          	mov    0x10(%rax),%rax
  10147e:	48 39 c2             	cmp    %rax,%rdx
  101481:	73 1a                	jae    10149d <string_putc+0x4b>
        *sp->s++ = c;
  101483:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  101487:	48 8b 40 08          	mov    0x8(%rax),%rax
  10148b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  10148f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  101493:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  101497:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
  10149b:	88 10                	mov    %dl,(%rax)
    }
    (void) color;
}
  10149d:	90                   	nop
  10149e:	c9                   	leave
  10149f:	c3                   	ret

00000000001014a0 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  1014a0:	55                   	push   %rbp
  1014a1:	48 89 e5             	mov    %rsp,%rbp
  1014a4:	48 83 ec 40          	sub    $0x40,%rsp
  1014a8:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  1014ac:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  1014b0:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  1014b4:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    string_printer sp;
    sp.p.putc = string_putc;
  1014b8:	48 c7 45 e8 52 14 10 	movq   $0x101452,-0x18(%rbp)
  1014bf:	00 
    sp.s = s;
  1014c0:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1014c4:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (size) {
  1014c8:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  1014cd:	74 33                	je     101502 <vsnprintf+0x62>
        sp.end = s + size - 1;
  1014cf:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  1014d3:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  1014d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1014db:	48 01 d0             	add    %rdx,%rax
  1014de:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  1014e2:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  1014e6:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  1014ea:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  1014ee:	be 00 00 00 00       	mov    $0x0,%esi
  1014f3:	48 89 c7             	mov    %rax,%rdi
  1014f6:	e8 ea f3 ff ff       	call   1008e5 <printer_vprintf>
        *sp.s = 0;
  1014fb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1014ff:	c6 00 00             	movb   $0x0,(%rax)
    }
    return sp.s - s;
  101502:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  101506:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
}
  10150a:	c9                   	leave
  10150b:	c3                   	ret

000000000010150c <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  10150c:	55                   	push   %rbp
  10150d:	48 89 e5             	mov    %rsp,%rbp
  101510:	48 83 ec 70          	sub    $0x70,%rsp
  101514:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  101518:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  10151c:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  101520:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  101524:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  101528:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  10152c:	c7 45 b0 18 00 00 00 	movl   $0x18,-0x50(%rbp)
  101533:	48 8d 45 10          	lea    0x10(%rbp),%rax
  101537:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  10153b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  10153f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    int n = vsnprintf(s, size, format, val);
  101543:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  101547:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  10154b:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  10154f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  101553:	48 89 c7             	mov    %rax,%rdi
  101556:	e8 45 ff ff ff       	call   1014a0 <vsnprintf>
  10155b:	89 45 cc             	mov    %eax,-0x34(%rbp)
    va_end(val);
    return n;
  10155e:	8b 45 cc             	mov    -0x34(%rbp),%eax
}
  101561:	c9                   	leave
  101562:	c3                   	ret

0000000000101563 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  101563:	55                   	push   %rbp
  101564:	48 89 e5             	mov    %rsp,%rbp
  101567:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  10156b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  101572:	eb 13                	jmp    101587 <console_clear+0x24>
        console[i] = ' ' | 0x0700;
  101574:	8b 45 fc             	mov    -0x4(%rbp),%eax
  101577:	48 98                	cltq
  101579:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%rax,%rax,1)
  101580:	00 20 07 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  101583:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  101587:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
  10158e:	7e e4                	jle    101574 <console_clear+0x11>
    }
    cursorpos = 0;
  101590:	c7 05 62 7a fb ff 00 	movl   $0x0,-0x4859e(%rip)        # b8ffc <cursorpos>
  101597:	00 00 00 
}
  10159a:	90                   	nop
  10159b:	c9                   	leave
  10159c:	c3                   	ret
