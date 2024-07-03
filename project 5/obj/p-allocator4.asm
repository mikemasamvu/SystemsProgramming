
obj/p-allocator4.full:     file format elf64-x86-64


Disassembly of section .text:

00000000001c0000 <process_main>:
uint8_t* stack_bottom;

// Program that starts allocating page by page from its heap
// till it reaches stack OR runs out of memory

void process_main(void) {
  1c0000:	55                   	push   %rbp
  1c0001:	48 89 e5             	mov    %rsp,%rbp
  1c0004:	53                   	push   %rbx
  1c0005:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  1c0009:	cd 31                	int    $0x31
  1c000b:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  1c000d:	89 c7                	mov    %eax,%edi
  1c000f:	e8 74 03 00 00       	call   1c0388 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  1c0014:	b8 17 30 1c 00       	mov    $0x1c3017,%eax
  1c0019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  1c001f:	48 89 05 e2 1f 00 00 	mov    %rax,0x1fe2(%rip)        # 1c2008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  1c0026:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  1c0029:	48 83 e8 01          	sub    $0x1,%rax
  1c002d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  1c0033:	48 89 05 c6 1f 00 00 	mov    %rax,0x1fc6(%rip)        # 1c2000 <stack_bottom>
  1c003a:	eb 02                	jmp    1c003e <process_main+0x3e>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  1c003c:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  1c003e:	e8 09 03 00 00       	call   1c034c <rand>
  1c0043:	48 63 d0             	movslq %eax,%rdx
  1c0046:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  1c004d:	48 c1 fa 25          	sar    $0x25,%rdx
  1c0051:	89 c1                	mov    %eax,%ecx
  1c0053:	c1 f9 1f             	sar    $0x1f,%ecx
  1c0056:	29 ca                	sub    %ecx,%edx
  1c0058:	6b d2 64             	imul   $0x64,%edx,%edx
  1c005b:	29 d0                	sub    %edx,%eax
  1c005d:	39 d8                	cmp    %ebx,%eax
  1c005f:	7d db                	jge    1c003c <process_main+0x3c>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  1c0061:	48 8b 3d a0 1f 00 00 	mov    0x1fa0(%rip),%rdi        # 1c2008 <heap_top>
  1c0068:	48 3b 3d 91 1f 00 00 	cmp    0x1f91(%rip),%rdi        # 1c2000 <stack_bottom>
  1c006f:	74 1c                	je     1c008d <process_main+0x8d>
//    Allocate a page of memory at address `addr` and allow process to
//    write to it. `Addr` must be page-aligned (i.e., a multiple of
//    PAGESIZE == 4096). Returns 0 on success and -1 on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  1c0071:	cd 33                	int    $0x33
  1c0073:	85 c0                	test   %eax,%eax
  1c0075:	78 16                	js     1c008d <process_main+0x8d>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  1c0077:	48 8b 05 8a 1f 00 00 	mov    0x1f8a(%rip),%rax        # 1c2008 <heap_top>
  1c007e:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  1c0080:	48 81 05 7d 1f 00 00 	addq   $0x1000,0x1f7d(%rip)        # 1c2008 <heap_top>
  1c0087:	00 10 00 00 
  1c008b:	eb af                	jmp    1c003c <process_main+0x3c>
    asm volatile ("int %0" : /* no result */
  1c008d:	cd 32                	int    $0x32
        }
        sys_yield();
    }

    // After running out of memory, do nothing forever
    while (1) {
  1c008f:	eb fc                	jmp    1c008d <process_main+0x8d>

00000000001c0091 <memcpy>:


// memcpy, memmove, memset, strcmp, strlen, strnlen
//    We must provide our own implementations.

void* memcpy(void* dst, const void* src, size_t n) {
  1c0091:	55                   	push   %rbp
  1c0092:	48 89 e5             	mov    %rsp,%rbp
  1c0095:	48 83 ec 28          	sub    $0x28,%rsp
  1c0099:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c009d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1c00a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1c00a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1c00a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1c00ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c00b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  1c00b5:	eb 1c                	jmp    1c00d3 <memcpy+0x42>
        *d = *s;
  1c00b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c00bb:	0f b6 10             	movzbl (%rax),%edx
  1c00be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c00c2:	88 10                	mov    %dl,(%rax)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1c00c4:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  1c00c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1c00ce:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  1c00d3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1c00d8:	75 dd                	jne    1c00b7 <memcpy+0x26>
    }
    return dst;
  1c00da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1c00de:	c9                   	leave
  1c00df:	c3                   	ret

00000000001c00e0 <memmove>:

void* memmove(void* dst, const void* src, size_t n) {
  1c00e0:	55                   	push   %rbp
  1c00e1:	48 89 e5             	mov    %rsp,%rbp
  1c00e4:	48 83 ec 28          	sub    $0x28,%rsp
  1c00e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c00ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1c00f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1c00f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1c00f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    char* d = (char*) dst;
  1c00fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0100:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (s < d && s + n > d) {
  1c0104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0108:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  1c010c:	73 6a                	jae    1c0178 <memmove+0x98>
  1c010e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  1c0112:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c0116:	48 01 d0             	add    %rdx,%rax
  1c0119:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
  1c011d:	73 59                	jae    1c0178 <memmove+0x98>
        s += n, d += n;
  1c011f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c0123:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  1c0127:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c012b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        while (n-- > 0) {
  1c012f:	eb 17                	jmp    1c0148 <memmove+0x68>
            *--d = *--s;
  1c0131:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  1c0136:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
  1c013b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c013f:	0f b6 10             	movzbl (%rax),%edx
  1c0142:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c0146:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  1c0148:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c014c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  1c0150:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  1c0154:	48 85 c0             	test   %rax,%rax
  1c0157:	75 d8                	jne    1c0131 <memmove+0x51>
    if (s < d && s + n > d) {
  1c0159:	eb 2e                	jmp    1c0189 <memmove+0xa9>
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
  1c015b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  1c015f:	48 8d 42 01          	lea    0x1(%rdx),%rax
  1c0163:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  1c0167:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c016b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  1c016f:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  1c0173:	0f b6 12             	movzbl (%rdx),%edx
  1c0176:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  1c0178:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c017c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  1c0180:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  1c0184:	48 85 c0             	test   %rax,%rax
  1c0187:	75 d2                	jne    1c015b <memmove+0x7b>
        }
    }
    return dst;
  1c0189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1c018d:	c9                   	leave
  1c018e:	c3                   	ret

00000000001c018f <memset>:

void* memset(void* v, int c, size_t n) {
  1c018f:	55                   	push   %rbp
  1c0190:	48 89 e5             	mov    %rsp,%rbp
  1c0193:	48 83 ec 28          	sub    $0x28,%rsp
  1c0197:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c019b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  1c019e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1c01a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c01a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  1c01aa:	eb 15                	jmp    1c01c1 <memset+0x32>
        *p = c;
  1c01ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1c01af:	89 c2                	mov    %eax,%edx
  1c01b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c01b5:	88 10                	mov    %dl,(%rax)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1c01b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1c01bc:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  1c01c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1c01c6:	75 e4                	jne    1c01ac <memset+0x1d>
    }
    return v;
  1c01c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1c01cc:	c9                   	leave
  1c01cd:	c3                   	ret

00000000001c01ce <strlen>:

size_t strlen(const char* s) {
  1c01ce:	55                   	push   %rbp
  1c01cf:	48 89 e5             	mov    %rsp,%rbp
  1c01d2:	48 83 ec 18          	sub    $0x18,%rsp
  1c01d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
  1c01da:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  1c01e1:	00 
  1c01e2:	eb 0a                	jmp    1c01ee <strlen+0x20>
        ++n;
  1c01e4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; *s != '\0'; ++s) {
  1c01e9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  1c01ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c01f2:	0f b6 00             	movzbl (%rax),%eax
  1c01f5:	84 c0                	test   %al,%al
  1c01f7:	75 eb                	jne    1c01e4 <strlen+0x16>
    }
    return n;
  1c01f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  1c01fd:	c9                   	leave
  1c01fe:	c3                   	ret

00000000001c01ff <strnlen>:

size_t strnlen(const char* s, size_t maxlen) {
  1c01ff:	55                   	push   %rbp
  1c0200:	48 89 e5             	mov    %rsp,%rbp
  1c0203:	48 83 ec 20          	sub    $0x20,%rsp
  1c0207:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c020b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    size_t n;
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1c020f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  1c0216:	00 
  1c0217:	eb 0a                	jmp    1c0223 <strnlen+0x24>
        ++n;
  1c0219:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1c021e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  1c0223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0227:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  1c022b:	74 0b                	je     1c0238 <strnlen+0x39>
  1c022d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0231:	0f b6 00             	movzbl (%rax),%eax
  1c0234:	84 c0                	test   %al,%al
  1c0236:	75 e1                	jne    1c0219 <strnlen+0x1a>
    }
    return n;
  1c0238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  1c023c:	c9                   	leave
  1c023d:	c3                   	ret

00000000001c023e <strcpy>:

char* strcpy(char* dst, const char* src) {
  1c023e:	55                   	push   %rbp
  1c023f:	48 89 e5             	mov    %rsp,%rbp
  1c0242:	48 83 ec 20          	sub    $0x20,%rsp
  1c0246:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c024a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    char* d = dst;
  1c024e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0252:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    do {
        *d++ = *src++;
  1c0256:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  1c025a:	48 8d 42 01          	lea    0x1(%rdx),%rax
  1c025e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  1c0262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0266:	48 8d 48 01          	lea    0x1(%rax),%rcx
  1c026a:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
  1c026e:	0f b6 12             	movzbl (%rdx),%edx
  1c0271:	88 10                	mov    %dl,(%rax)
    } while (d[-1]);
  1c0273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0277:	48 83 e8 01          	sub    $0x1,%rax
  1c027b:	0f b6 00             	movzbl (%rax),%eax
  1c027e:	84 c0                	test   %al,%al
  1c0280:	75 d4                	jne    1c0256 <strcpy+0x18>
    return dst;
  1c0282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1c0286:	c9                   	leave
  1c0287:	c3                   	ret

00000000001c0288 <strcmp>:

int strcmp(const char* a, const char* b) {
  1c0288:	55                   	push   %rbp
  1c0289:	48 89 e5             	mov    %rsp,%rbp
  1c028c:	48 83 ec 10          	sub    $0x10,%rsp
  1c0290:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  1c0294:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  1c0298:	eb 0a                	jmp    1c02a4 <strcmp+0x1c>
        ++a, ++b;
  1c029a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1c029f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  1c02a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c02a8:	0f b6 00             	movzbl (%rax),%eax
  1c02ab:	84 c0                	test   %al,%al
  1c02ad:	74 1d                	je     1c02cc <strcmp+0x44>
  1c02af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c02b3:	0f b6 00             	movzbl (%rax),%eax
  1c02b6:	84 c0                	test   %al,%al
  1c02b8:	74 12                	je     1c02cc <strcmp+0x44>
  1c02ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c02be:	0f b6 10             	movzbl (%rax),%edx
  1c02c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c02c5:	0f b6 00             	movzbl (%rax),%eax
  1c02c8:	38 c2                	cmp    %al,%dl
  1c02ca:	74 ce                	je     1c029a <strcmp+0x12>
    }
    return ((unsigned char) *a > (unsigned char) *b)
  1c02cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c02d0:	0f b6 00             	movzbl (%rax),%eax
  1c02d3:	89 c2                	mov    %eax,%edx
  1c02d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c02d9:	0f b6 00             	movzbl (%rax),%eax
  1c02dc:	38 d0                	cmp    %dl,%al
  1c02de:	0f 92 c0             	setb   %al
  1c02e1:	0f b6 d0             	movzbl %al,%edx
        - ((unsigned char) *a < (unsigned char) *b);
  1c02e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c02e8:	0f b6 00             	movzbl (%rax),%eax
  1c02eb:	89 c1                	mov    %eax,%ecx
  1c02ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c02f1:	0f b6 00             	movzbl (%rax),%eax
  1c02f4:	38 c1                	cmp    %al,%cl
  1c02f6:	0f 92 c0             	setb   %al
  1c02f9:	0f b6 c0             	movzbl %al,%eax
  1c02fc:	29 c2                	sub    %eax,%edx
  1c02fe:	89 d0                	mov    %edx,%eax
}
  1c0300:	c9                   	leave
  1c0301:	c3                   	ret

00000000001c0302 <strchr>:

char* strchr(const char* s, int c) {
  1c0302:	55                   	push   %rbp
  1c0303:	48 89 e5             	mov    %rsp,%rbp
  1c0306:	48 83 ec 10          	sub    $0x10,%rsp
  1c030a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  1c030e:	89 75 f4             	mov    %esi,-0xc(%rbp)
    while (*s && *s != (char) c) {
  1c0311:	eb 05                	jmp    1c0318 <strchr+0x16>
        ++s;
  1c0313:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while (*s && *s != (char) c) {
  1c0318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c031c:	0f b6 00             	movzbl (%rax),%eax
  1c031f:	84 c0                	test   %al,%al
  1c0321:	74 0e                	je     1c0331 <strchr+0x2f>
  1c0323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0327:	0f b6 00             	movzbl (%rax),%eax
  1c032a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  1c032d:	38 d0                	cmp    %dl,%al
  1c032f:	75 e2                	jne    1c0313 <strchr+0x11>
    }
    if (*s == (char) c) {
  1c0331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0335:	0f b6 00             	movzbl (%rax),%eax
  1c0338:	8b 55 f4             	mov    -0xc(%rbp),%edx
  1c033b:	38 d0                	cmp    %dl,%al
  1c033d:	75 06                	jne    1c0345 <strchr+0x43>
        return (char*) s;
  1c033f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0343:	eb 05                	jmp    1c034a <strchr+0x48>
    } else {
        return NULL;
  1c0345:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
  1c034a:	c9                   	leave
  1c034b:	c3                   	ret

00000000001c034c <rand>:
// rand, srand

static int rand_seed_set;
static unsigned rand_seed;

int rand(void) {
  1c034c:	55                   	push   %rbp
  1c034d:	48 89 e5             	mov    %rsp,%rbp
    if (!rand_seed_set) {
  1c0350:	8b 05 ba 1c 00 00    	mov    0x1cba(%rip),%eax        # 1c2010 <rand_seed_set>
  1c0356:	85 c0                	test   %eax,%eax
  1c0358:	75 0a                	jne    1c0364 <rand+0x18>
        srand(819234718U);
  1c035a:	bf 9e 87 d4 30       	mov    $0x30d4879e,%edi
  1c035f:	e8 24 00 00 00       	call   1c0388 <srand>
    }
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1c0364:	8b 05 aa 1c 00 00    	mov    0x1caa(%rip),%eax        # 1c2014 <rand_seed>
  1c036a:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
  1c0370:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  1c0375:	89 05 99 1c 00 00    	mov    %eax,0x1c99(%rip)        # 1c2014 <rand_seed>
    return rand_seed & RAND_MAX;
  1c037b:	8b 05 93 1c 00 00    	mov    0x1c93(%rip),%eax        # 1c2014 <rand_seed>
  1c0381:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  1c0386:	5d                   	pop    %rbp
  1c0387:	c3                   	ret

00000000001c0388 <srand>:

void srand(unsigned seed) {
  1c0388:	55                   	push   %rbp
  1c0389:	48 89 e5             	mov    %rsp,%rbp
  1c038c:	48 83 ec 08          	sub    $0x8,%rsp
  1c0390:	89 7d fc             	mov    %edi,-0x4(%rbp)
    rand_seed = seed;
  1c0393:	8b 45 fc             	mov    -0x4(%rbp),%eax
  1c0396:	89 05 78 1c 00 00    	mov    %eax,0x1c78(%rip)        # 1c2014 <rand_seed>
    rand_seed_set = 1;
  1c039c:	c7 05 6a 1c 00 00 01 	movl   $0x1,0x1c6a(%rip)        # 1c2010 <rand_seed_set>
  1c03a3:	00 00 00 
}
  1c03a6:	90                   	nop
  1c03a7:	c9                   	leave
  1c03a8:	c3                   	ret

00000000001c03a9 <fill_numbuf>:
//    Print a message onto the console, starting at the given cursor position.

// snprintf, vsnprintf
//    Format a string into a buffer.

static char* fill_numbuf(char* numbuf_end, unsigned long val, int base) {
  1c03a9:	55                   	push   %rbp
  1c03aa:	48 89 e5             	mov    %rsp,%rbp
  1c03ad:	48 83 ec 28          	sub    $0x28,%rsp
  1c03b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c03b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1c03b9:	89 55 dc             	mov    %edx,-0x24(%rbp)
    static const char upper_digits[] = "0123456789ABCDEF";
    static const char lower_digits[] = "0123456789abcdef";

    const char* digits = upper_digits;
  1c03bc:	48 c7 45 f8 d0 12 1c 	movq   $0x1c12d0,-0x8(%rbp)
  1c03c3:	00 
    if (base < 0) {
  1c03c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  1c03c8:	79 0b                	jns    1c03d5 <fill_numbuf+0x2c>
        digits = lower_digits;
  1c03ca:	48 c7 45 f8 f0 12 1c 	movq   $0x1c12f0,-0x8(%rbp)
  1c03d1:	00 
        base = -base;
  1c03d2:	f7 5d dc             	negl   -0x24(%rbp)
    }

    *--numbuf_end = '\0';
  1c03d5:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  1c03da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c03de:	c6 00 00             	movb   $0x0,(%rax)
    do {
        *--numbuf_end = digits[val % base];
  1c03e1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  1c03e4:	48 63 c8             	movslq %eax,%rcx
  1c03e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1c03eb:	ba 00 00 00 00       	mov    $0x0,%edx
  1c03f0:	48 f7 f1             	div    %rcx
  1c03f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c03f7:	48 01 d0             	add    %rdx,%rax
  1c03fa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  1c03ff:	0f b6 10             	movzbl (%rax),%edx
  1c0402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0406:	88 10                	mov    %dl,(%rax)
        val /= base;
  1c0408:	8b 45 dc             	mov    -0x24(%rbp),%eax
  1c040b:	48 63 f0             	movslq %eax,%rsi
  1c040e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1c0412:	ba 00 00 00 00       	mov    $0x0,%edx
  1c0417:	48 f7 f6             	div    %rsi
  1c041a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    } while (val != 0);
  1c041e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  1c0423:	75 bc                	jne    1c03e1 <fill_numbuf+0x38>
    return numbuf_end;
  1c0425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1c0429:	c9                   	leave
  1c042a:	c3                   	ret

00000000001c042b <printer_vprintf>:
#define FLAG_NUMERIC            (1<<5)
#define FLAG_SIGNED             (1<<6)
#define FLAG_NEGATIVE           (1<<7)
#define FLAG_ALT2               (1<<8)

void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1c042b:	55                   	push   %rbp
  1c042c:	48 89 e5             	mov    %rsp,%rbp
  1c042f:	53                   	push   %rbx
  1c0430:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  1c0437:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
  1c043e:	89 b5 74 ff ff ff    	mov    %esi,-0x8c(%rbp)
  1c0444:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  1c044b:	48 89 8d 60 ff ff ff 	mov    %rcx,-0xa0(%rbp)
#define NUMBUFSIZ 24
    char numbuf[NUMBUFSIZ];

    for (; *format; ++format) {
  1c0452:	e9 8a 09 00 00       	jmp    1c0de1 <printer_vprintf+0x9b6>
        if (*format != '%') {
  1c0457:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c045e:	0f b6 00             	movzbl (%rax),%eax
  1c0461:	3c 25                	cmp    $0x25,%al
  1c0463:	74 31                	je     1c0496 <printer_vprintf+0x6b>
            p->putc(p, *format, color);
  1c0465:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c046c:	4c 8b 00             	mov    (%rax),%r8
  1c046f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0476:	0f b6 00             	movzbl (%rax),%eax
  1c0479:	0f b6 c8             	movzbl %al,%ecx
  1c047c:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1c0482:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0489:	89 ce                	mov    %ecx,%esi
  1c048b:	48 89 c7             	mov    %rax,%rdi
  1c048e:	41 ff d0             	call   *%r8
            continue;
  1c0491:	e9 43 09 00 00       	jmp    1c0dd9 <printer_vprintf+0x9ae>
        }

        // process flags
        int flags = 0;
  1c0496:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        for (++format; *format; ++format) {
  1c049d:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c04a4:	01 
  1c04a5:	eb 44                	jmp    1c04eb <printer_vprintf+0xc0>
            const char* flagc = strchr(flag_chars, *format);
  1c04a7:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c04ae:	0f b6 00             	movzbl (%rax),%eax
  1c04b1:	0f be c0             	movsbl %al,%eax
  1c04b4:	89 c6                	mov    %eax,%esi
  1c04b6:	bf f0 10 1c 00       	mov    $0x1c10f0,%edi
  1c04bb:	e8 42 fe ff ff       	call   1c0302 <strchr>
  1c04c0:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (flagc) {
  1c04c4:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  1c04c9:	74 30                	je     1c04fb <printer_vprintf+0xd0>
                flags |= 1 << (flagc - flag_chars);
  1c04cb:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  1c04cf:	48 2d f0 10 1c 00    	sub    $0x1c10f0,%rax
  1c04d5:	ba 01 00 00 00       	mov    $0x1,%edx
  1c04da:	89 c1                	mov    %eax,%ecx
  1c04dc:	d3 e2                	shl    %cl,%edx
  1c04de:	89 d0                	mov    %edx,%eax
  1c04e0:	09 45 ec             	or     %eax,-0x14(%rbp)
        for (++format; *format; ++format) {
  1c04e3:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c04ea:	01 
  1c04eb:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c04f2:	0f b6 00             	movzbl (%rax),%eax
  1c04f5:	84 c0                	test   %al,%al
  1c04f7:	75 ae                	jne    1c04a7 <printer_vprintf+0x7c>
  1c04f9:	eb 01                	jmp    1c04fc <printer_vprintf+0xd1>
            } else {
                break;
  1c04fb:	90                   	nop
            }
        }

        // process width
        int width = -1;
  1c04fc:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
        if (*format >= '1' && *format <= '9') {
  1c0503:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c050a:	0f b6 00             	movzbl (%rax),%eax
  1c050d:	3c 30                	cmp    $0x30,%al
  1c050f:	7e 67                	jle    1c0578 <printer_vprintf+0x14d>
  1c0511:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0518:	0f b6 00             	movzbl (%rax),%eax
  1c051b:	3c 39                	cmp    $0x39,%al
  1c051d:	7f 59                	jg     1c0578 <printer_vprintf+0x14d>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c051f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  1c0526:	eb 2e                	jmp    1c0556 <printer_vprintf+0x12b>
                width = 10 * width + *format++ - '0';
  1c0528:	8b 55 e8             	mov    -0x18(%rbp),%edx
  1c052b:	89 d0                	mov    %edx,%eax
  1c052d:	c1 e0 02             	shl    $0x2,%eax
  1c0530:	01 d0                	add    %edx,%eax
  1c0532:	01 c0                	add    %eax,%eax
  1c0534:	89 c1                	mov    %eax,%ecx
  1c0536:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c053d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1c0541:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  1c0548:	0f b6 00             	movzbl (%rax),%eax
  1c054b:	0f be c0             	movsbl %al,%eax
  1c054e:	01 c8                	add    %ecx,%eax
  1c0550:	83 e8 30             	sub    $0x30,%eax
  1c0553:	89 45 e8             	mov    %eax,-0x18(%rbp)
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c0556:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c055d:	0f b6 00             	movzbl (%rax),%eax
  1c0560:	3c 2f                	cmp    $0x2f,%al
  1c0562:	0f 8e 85 00 00 00    	jle    1c05ed <printer_vprintf+0x1c2>
  1c0568:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c056f:	0f b6 00             	movzbl (%rax),%eax
  1c0572:	3c 39                	cmp    $0x39,%al
  1c0574:	7e b2                	jle    1c0528 <printer_vprintf+0xfd>
        if (*format >= '1' && *format <= '9') {
  1c0576:	eb 75                	jmp    1c05ed <printer_vprintf+0x1c2>
            }
        } else if (*format == '*') {
  1c0578:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c057f:	0f b6 00             	movzbl (%rax),%eax
  1c0582:	3c 2a                	cmp    $0x2a,%al
  1c0584:	75 68                	jne    1c05ee <printer_vprintf+0x1c3>
            width = va_arg(val, int);
  1c0586:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c058d:	8b 00                	mov    (%rax),%eax
  1c058f:	83 f8 2f             	cmp    $0x2f,%eax
  1c0592:	77 30                	ja     1c05c4 <printer_vprintf+0x199>
  1c0594:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c059b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c059f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c05a6:	8b 00                	mov    (%rax),%eax
  1c05a8:	89 c0                	mov    %eax,%eax
  1c05aa:	48 01 d0             	add    %rdx,%rax
  1c05ad:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c05b4:	8b 12                	mov    (%rdx),%edx
  1c05b6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c05b9:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c05c0:	89 0a                	mov    %ecx,(%rdx)
  1c05c2:	eb 1a                	jmp    1c05de <printer_vprintf+0x1b3>
  1c05c4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c05cb:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c05cf:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c05d3:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c05da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c05de:	8b 00                	mov    (%rax),%eax
  1c05e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
            ++format;
  1c05e3:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c05ea:	01 
  1c05eb:	eb 01                	jmp    1c05ee <printer_vprintf+0x1c3>
        if (*format >= '1' && *format <= '9') {
  1c05ed:	90                   	nop
        }

        // process precision
        int precision = -1;
  1c05ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
        if (*format == '.') {
  1c05f5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c05fc:	0f b6 00             	movzbl (%rax),%eax
  1c05ff:	3c 2e                	cmp    $0x2e,%al
  1c0601:	0f 85 00 01 00 00    	jne    1c0707 <printer_vprintf+0x2dc>
            ++format;
  1c0607:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c060e:	01 
            if (*format >= '0' && *format <= '9') {
  1c060f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0616:	0f b6 00             	movzbl (%rax),%eax
  1c0619:	3c 2f                	cmp    $0x2f,%al
  1c061b:	7e 67                	jle    1c0684 <printer_vprintf+0x259>
  1c061d:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0624:	0f b6 00             	movzbl (%rax),%eax
  1c0627:	3c 39                	cmp    $0x39,%al
  1c0629:	7f 59                	jg     1c0684 <printer_vprintf+0x259>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1c062b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  1c0632:	eb 2e                	jmp    1c0662 <printer_vprintf+0x237>
                    precision = 10 * precision + *format++ - '0';
  1c0634:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  1c0637:	89 d0                	mov    %edx,%eax
  1c0639:	c1 e0 02             	shl    $0x2,%eax
  1c063c:	01 d0                	add    %edx,%eax
  1c063e:	01 c0                	add    %eax,%eax
  1c0640:	89 c1                	mov    %eax,%ecx
  1c0642:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0649:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1c064d:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  1c0654:	0f b6 00             	movzbl (%rax),%eax
  1c0657:	0f be c0             	movsbl %al,%eax
  1c065a:	01 c8                	add    %ecx,%eax
  1c065c:	83 e8 30             	sub    $0x30,%eax
  1c065f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1c0662:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0669:	0f b6 00             	movzbl (%rax),%eax
  1c066c:	3c 2f                	cmp    $0x2f,%al
  1c066e:	0f 8e 85 00 00 00    	jle    1c06f9 <printer_vprintf+0x2ce>
  1c0674:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c067b:	0f b6 00             	movzbl (%rax),%eax
  1c067e:	3c 39                	cmp    $0x39,%al
  1c0680:	7e b2                	jle    1c0634 <printer_vprintf+0x209>
            if (*format >= '0' && *format <= '9') {
  1c0682:	eb 75                	jmp    1c06f9 <printer_vprintf+0x2ce>
                }
            } else if (*format == '*') {
  1c0684:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c068b:	0f b6 00             	movzbl (%rax),%eax
  1c068e:	3c 2a                	cmp    $0x2a,%al
  1c0690:	75 68                	jne    1c06fa <printer_vprintf+0x2cf>
                precision = va_arg(val, int);
  1c0692:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0699:	8b 00                	mov    (%rax),%eax
  1c069b:	83 f8 2f             	cmp    $0x2f,%eax
  1c069e:	77 30                	ja     1c06d0 <printer_vprintf+0x2a5>
  1c06a0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c06a7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c06ab:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c06b2:	8b 00                	mov    (%rax),%eax
  1c06b4:	89 c0                	mov    %eax,%eax
  1c06b6:	48 01 d0             	add    %rdx,%rax
  1c06b9:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c06c0:	8b 12                	mov    (%rdx),%edx
  1c06c2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c06c5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c06cc:	89 0a                	mov    %ecx,(%rdx)
  1c06ce:	eb 1a                	jmp    1c06ea <printer_vprintf+0x2bf>
  1c06d0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c06d7:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c06db:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c06df:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c06e6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c06ea:	8b 00                	mov    (%rax),%eax
  1c06ec:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                ++format;
  1c06ef:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c06f6:	01 
  1c06f7:	eb 01                	jmp    1c06fa <printer_vprintf+0x2cf>
            if (*format >= '0' && *format <= '9') {
  1c06f9:	90                   	nop
            }
            if (precision < 0) {
  1c06fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  1c06fe:	79 07                	jns    1c0707 <printer_vprintf+0x2dc>
                precision = 0;
  1c0700:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
            }
        }

        // process main conversion character
        int base = 10;
  1c0707:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%rbp)
        unsigned long num = 0;
  1c070e:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  1c0715:	00 
        int length = 0;
  1c0716:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
        char* data = "";
  1c071d:	48 c7 45 c8 f6 10 1c 	movq   $0x1c10f6,-0x38(%rbp)
  1c0724:	00 
    again:
        switch (*format) {
  1c0725:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c072c:	0f b6 00             	movzbl (%rax),%eax
  1c072f:	0f be c0             	movsbl %al,%eax
  1c0732:	83 e8 43             	sub    $0x43,%eax
  1c0735:	83 f8 37             	cmp    $0x37,%eax
  1c0738:	0f 87 9f 03 00 00    	ja     1c0add <printer_vprintf+0x6b2>
  1c073e:	89 c0                	mov    %eax,%eax
  1c0740:	48 8b 04 c5 08 11 1c 	mov    0x1c1108(,%rax,8),%rax
  1c0747:	00 
  1c0748:	ff e0                	jmp    *%rax
        case 'l':
        case 'z':
            length = 1;
  1c074a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
            ++format;
  1c0751:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c0758:	01 
            goto again;
  1c0759:	eb ca                	jmp    1c0725 <printer_vprintf+0x2fa>
        case 'd':
        case 'i': {
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1c075b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  1c075f:	74 5d                	je     1c07be <printer_vprintf+0x393>
  1c0761:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0768:	8b 00                	mov    (%rax),%eax
  1c076a:	83 f8 2f             	cmp    $0x2f,%eax
  1c076d:	77 30                	ja     1c079f <printer_vprintf+0x374>
  1c076f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0776:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c077a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0781:	8b 00                	mov    (%rax),%eax
  1c0783:	89 c0                	mov    %eax,%eax
  1c0785:	48 01 d0             	add    %rdx,%rax
  1c0788:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c078f:	8b 12                	mov    (%rdx),%edx
  1c0791:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c0794:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c079b:	89 0a                	mov    %ecx,(%rdx)
  1c079d:	eb 1a                	jmp    1c07b9 <printer_vprintf+0x38e>
  1c079f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c07a6:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c07aa:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c07ae:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c07b5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c07b9:	48 8b 00             	mov    (%rax),%rax
  1c07bc:	eb 5c                	jmp    1c081a <printer_vprintf+0x3ef>
  1c07be:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c07c5:	8b 00                	mov    (%rax),%eax
  1c07c7:	83 f8 2f             	cmp    $0x2f,%eax
  1c07ca:	77 30                	ja     1c07fc <printer_vprintf+0x3d1>
  1c07cc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c07d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c07d7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c07de:	8b 00                	mov    (%rax),%eax
  1c07e0:	89 c0                	mov    %eax,%eax
  1c07e2:	48 01 d0             	add    %rdx,%rax
  1c07e5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c07ec:	8b 12                	mov    (%rdx),%edx
  1c07ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c07f1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c07f8:	89 0a                	mov    %ecx,(%rdx)
  1c07fa:	eb 1a                	jmp    1c0816 <printer_vprintf+0x3eb>
  1c07fc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0803:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0807:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c080b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0812:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0816:	8b 00                	mov    (%rax),%eax
  1c0818:	48 98                	cltq
  1c081a:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1c081e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1c0822:	48 c1 f8 38          	sar    $0x38,%rax
  1c0826:	25 80 00 00 00       	and    $0x80,%eax
  1c082b:	89 45 a4             	mov    %eax,-0x5c(%rbp)
            num = negative ? -x : x;
  1c082e:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  1c0832:	74 09                	je     1c083d <printer_vprintf+0x412>
  1c0834:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1c0838:	48 f7 d8             	neg    %rax
  1c083b:	eb 04                	jmp    1c0841 <printer_vprintf+0x416>
  1c083d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1c0841:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1c0845:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  1c0848:	83 c8 60             	or     $0x60,%eax
  1c084b:	09 45 ec             	or     %eax,-0x14(%rbp)
            break;
  1c084e:	e9 cf 02 00 00       	jmp    1c0b22 <printer_vprintf+0x6f7>
        }
        case 'u':
        format_unsigned:
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1c0853:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  1c0857:	74 5d                	je     1c08b6 <printer_vprintf+0x48b>
  1c0859:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0860:	8b 00                	mov    (%rax),%eax
  1c0862:	83 f8 2f             	cmp    $0x2f,%eax
  1c0865:	77 30                	ja     1c0897 <printer_vprintf+0x46c>
  1c0867:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c086e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c0872:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0879:	8b 00                	mov    (%rax),%eax
  1c087b:	89 c0                	mov    %eax,%eax
  1c087d:	48 01 d0             	add    %rdx,%rax
  1c0880:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0887:	8b 12                	mov    (%rdx),%edx
  1c0889:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c088c:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0893:	89 0a                	mov    %ecx,(%rdx)
  1c0895:	eb 1a                	jmp    1c08b1 <printer_vprintf+0x486>
  1c0897:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c089e:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c08a2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c08a6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c08ad:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c08b1:	48 8b 00             	mov    (%rax),%rax
  1c08b4:	eb 5c                	jmp    1c0912 <printer_vprintf+0x4e7>
  1c08b6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c08bd:	8b 00                	mov    (%rax),%eax
  1c08bf:	83 f8 2f             	cmp    $0x2f,%eax
  1c08c2:	77 30                	ja     1c08f4 <printer_vprintf+0x4c9>
  1c08c4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c08cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c08cf:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c08d6:	8b 00                	mov    (%rax),%eax
  1c08d8:	89 c0                	mov    %eax,%eax
  1c08da:	48 01 d0             	add    %rdx,%rax
  1c08dd:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c08e4:	8b 12                	mov    (%rdx),%edx
  1c08e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c08e9:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c08f0:	89 0a                	mov    %ecx,(%rdx)
  1c08f2:	eb 1a                	jmp    1c090e <printer_vprintf+0x4e3>
  1c08f4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c08fb:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c08ff:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c0903:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c090a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c090e:	8b 00                	mov    (%rax),%eax
  1c0910:	89 c0                	mov    %eax,%eax
  1c0912:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC;
  1c0916:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
            break;
  1c091a:	e9 03 02 00 00       	jmp    1c0b22 <printer_vprintf+0x6f7>
        case 'x':
            base = -16;
  1c091f:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            goto format_unsigned;
  1c0926:	e9 28 ff ff ff       	jmp    1c0853 <printer_vprintf+0x428>
        case 'X':
            base = 16;
  1c092b:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%rbp)
            goto format_unsigned;
  1c0932:	e9 1c ff ff ff       	jmp    1c0853 <printer_vprintf+0x428>
        case 'p':
            num = (uintptr_t) va_arg(val, void*);
  1c0937:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c093e:	8b 00                	mov    (%rax),%eax
  1c0940:	83 f8 2f             	cmp    $0x2f,%eax
  1c0943:	77 30                	ja     1c0975 <printer_vprintf+0x54a>
  1c0945:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c094c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c0950:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0957:	8b 00                	mov    (%rax),%eax
  1c0959:	89 c0                	mov    %eax,%eax
  1c095b:	48 01 d0             	add    %rdx,%rax
  1c095e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0965:	8b 12                	mov    (%rdx),%edx
  1c0967:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c096a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0971:	89 0a                	mov    %ecx,(%rdx)
  1c0973:	eb 1a                	jmp    1c098f <printer_vprintf+0x564>
  1c0975:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c097c:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0980:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c0984:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c098b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c098f:	48 8b 00             	mov    (%rax),%rax
  1c0992:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            base = -16;
  1c0996:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1c099d:	81 4d ec 21 01 00 00 	orl    $0x121,-0x14(%rbp)
            break;
  1c09a4:	e9 79 01 00 00       	jmp    1c0b22 <printer_vprintf+0x6f7>
        case 's':
            data = va_arg(val, char*);
  1c09a9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c09b0:	8b 00                	mov    (%rax),%eax
  1c09b2:	83 f8 2f             	cmp    $0x2f,%eax
  1c09b5:	77 30                	ja     1c09e7 <printer_vprintf+0x5bc>
  1c09b7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c09be:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c09c2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c09c9:	8b 00                	mov    (%rax),%eax
  1c09cb:	89 c0                	mov    %eax,%eax
  1c09cd:	48 01 d0             	add    %rdx,%rax
  1c09d0:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c09d7:	8b 12                	mov    (%rdx),%edx
  1c09d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c09dc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c09e3:	89 0a                	mov    %ecx,(%rdx)
  1c09e5:	eb 1a                	jmp    1c0a01 <printer_vprintf+0x5d6>
  1c09e7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c09ee:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c09f2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c09f6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c09fd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0a01:	48 8b 00             	mov    (%rax),%rax
  1c0a04:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            break;
  1c0a08:	e9 15 01 00 00       	jmp    1c0b22 <printer_vprintf+0x6f7>
        case 'C':
            color = va_arg(val, int);
  1c0a0d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a14:	8b 00                	mov    (%rax),%eax
  1c0a16:	83 f8 2f             	cmp    $0x2f,%eax
  1c0a19:	77 30                	ja     1c0a4b <printer_vprintf+0x620>
  1c0a1b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a22:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c0a26:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a2d:	8b 00                	mov    (%rax),%eax
  1c0a2f:	89 c0                	mov    %eax,%eax
  1c0a31:	48 01 d0             	add    %rdx,%rax
  1c0a34:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0a3b:	8b 12                	mov    (%rdx),%edx
  1c0a3d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c0a40:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0a47:	89 0a                	mov    %ecx,(%rdx)
  1c0a49:	eb 1a                	jmp    1c0a65 <printer_vprintf+0x63a>
  1c0a4b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a52:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0a56:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c0a5a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0a61:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0a65:	8b 00                	mov    (%rax),%eax
  1c0a67:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
            goto done;
  1c0a6d:	e9 67 03 00 00       	jmp    1c0dd9 <printer_vprintf+0x9ae>
        case 'c':
            data = numbuf;
  1c0a72:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  1c0a76:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = va_arg(val, int);
  1c0a7a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a81:	8b 00                	mov    (%rax),%eax
  1c0a83:	83 f8 2f             	cmp    $0x2f,%eax
  1c0a86:	77 30                	ja     1c0ab8 <printer_vprintf+0x68d>
  1c0a88:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a8f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c0a93:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a9a:	8b 00                	mov    (%rax),%eax
  1c0a9c:	89 c0                	mov    %eax,%eax
  1c0a9e:	48 01 d0             	add    %rdx,%rax
  1c0aa1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0aa8:	8b 12                	mov    (%rdx),%edx
  1c0aaa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c0aad:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0ab4:	89 0a                	mov    %ecx,(%rdx)
  1c0ab6:	eb 1a                	jmp    1c0ad2 <printer_vprintf+0x6a7>
  1c0ab8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0abf:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0ac3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c0ac7:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0ace:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0ad2:	8b 00                	mov    (%rax),%eax
  1c0ad4:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  1c0ad7:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            break;
  1c0adb:	eb 45                	jmp    1c0b22 <printer_vprintf+0x6f7>
        default:
            data = numbuf;
  1c0add:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  1c0ae1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = (*format ? *format : '%');
  1c0ae5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0aec:	0f b6 00             	movzbl (%rax),%eax
  1c0aef:	84 c0                	test   %al,%al
  1c0af1:	74 0c                	je     1c0aff <printer_vprintf+0x6d4>
  1c0af3:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0afa:	0f b6 00             	movzbl (%rax),%eax
  1c0afd:	eb 05                	jmp    1c0b04 <printer_vprintf+0x6d9>
  1c0aff:	b8 25 00 00 00       	mov    $0x25,%eax
  1c0b04:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  1c0b07:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            if (!*format) {
  1c0b0b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0b12:	0f b6 00             	movzbl (%rax),%eax
  1c0b15:	84 c0                	test   %al,%al
  1c0b17:	75 08                	jne    1c0b21 <printer_vprintf+0x6f6>
                format--;
  1c0b19:	48 83 ad 68 ff ff ff 	subq   $0x1,-0x98(%rbp)
  1c0b20:	01 
            }
            break;
  1c0b21:	90                   	nop
        }

        if (flags & FLAG_NUMERIC) {
  1c0b22:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0b25:	83 e0 20             	and    $0x20,%eax
  1c0b28:	85 c0                	test   %eax,%eax
  1c0b2a:	74 1e                	je     1c0b4a <printer_vprintf+0x71f>
            data = fill_numbuf(numbuf + NUMBUFSIZ, num, base);
  1c0b2c:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  1c0b30:	48 83 c0 18          	add    $0x18,%rax
  1c0b34:	8b 55 e0             	mov    -0x20(%rbp),%edx
  1c0b37:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  1c0b3b:	48 89 ce             	mov    %rcx,%rsi
  1c0b3e:	48 89 c7             	mov    %rax,%rdi
  1c0b41:	e8 63 f8 ff ff       	call   1c03a9 <fill_numbuf>
  1c0b46:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        }

        const char* prefix = "";
  1c0b4a:	48 c7 45 c0 f6 10 1c 	movq   $0x1c10f6,-0x40(%rbp)
  1c0b51:	00 
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  1c0b52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0b55:	83 e0 20             	and    $0x20,%eax
  1c0b58:	85 c0                	test   %eax,%eax
  1c0b5a:	74 48                	je     1c0ba4 <printer_vprintf+0x779>
  1c0b5c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0b5f:	83 e0 40             	and    $0x40,%eax
  1c0b62:	85 c0                	test   %eax,%eax
  1c0b64:	74 3e                	je     1c0ba4 <printer_vprintf+0x779>
            if (flags & FLAG_NEGATIVE) {
  1c0b66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0b69:	25 80 00 00 00       	and    $0x80,%eax
  1c0b6e:	85 c0                	test   %eax,%eax
  1c0b70:	74 0a                	je     1c0b7c <printer_vprintf+0x751>
                prefix = "-";
  1c0b72:	48 c7 45 c0 f7 10 1c 	movq   $0x1c10f7,-0x40(%rbp)
  1c0b79:	00 
            if (flags & FLAG_NEGATIVE) {
  1c0b7a:	eb 73                	jmp    1c0bef <printer_vprintf+0x7c4>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  1c0b7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0b7f:	83 e0 10             	and    $0x10,%eax
  1c0b82:	85 c0                	test   %eax,%eax
  1c0b84:	74 0a                	je     1c0b90 <printer_vprintf+0x765>
                prefix = "+";
  1c0b86:	48 c7 45 c0 f9 10 1c 	movq   $0x1c10f9,-0x40(%rbp)
  1c0b8d:	00 
            if (flags & FLAG_NEGATIVE) {
  1c0b8e:	eb 5f                	jmp    1c0bef <printer_vprintf+0x7c4>
            } else if (flags & FLAG_SPACEPOSITIVE) {
  1c0b90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0b93:	83 e0 08             	and    $0x8,%eax
  1c0b96:	85 c0                	test   %eax,%eax
  1c0b98:	74 55                	je     1c0bef <printer_vprintf+0x7c4>
                prefix = " ";
  1c0b9a:	48 c7 45 c0 fb 10 1c 	movq   $0x1c10fb,-0x40(%rbp)
  1c0ba1:	00 
            if (flags & FLAG_NEGATIVE) {
  1c0ba2:	eb 4b                	jmp    1c0bef <printer_vprintf+0x7c4>
            }
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1c0ba4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0ba7:	83 e0 20             	and    $0x20,%eax
  1c0baa:	85 c0                	test   %eax,%eax
  1c0bac:	74 42                	je     1c0bf0 <printer_vprintf+0x7c5>
  1c0bae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0bb1:	83 e0 01             	and    $0x1,%eax
  1c0bb4:	85 c0                	test   %eax,%eax
  1c0bb6:	74 38                	je     1c0bf0 <printer_vprintf+0x7c5>
                   && (base == 16 || base == -16)
  1c0bb8:	83 7d e0 10          	cmpl   $0x10,-0x20(%rbp)
  1c0bbc:	74 06                	je     1c0bc4 <printer_vprintf+0x799>
  1c0bbe:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  1c0bc2:	75 2c                	jne    1c0bf0 <printer_vprintf+0x7c5>
                   && (num || (flags & FLAG_ALT2))) {
  1c0bc4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1c0bc9:	75 0c                	jne    1c0bd7 <printer_vprintf+0x7ac>
  1c0bcb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0bce:	25 00 01 00 00       	and    $0x100,%eax
  1c0bd3:	85 c0                	test   %eax,%eax
  1c0bd5:	74 19                	je     1c0bf0 <printer_vprintf+0x7c5>
            prefix = (base == -16 ? "0x" : "0X");
  1c0bd7:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  1c0bdb:	75 07                	jne    1c0be4 <printer_vprintf+0x7b9>
  1c0bdd:	b8 fd 10 1c 00       	mov    $0x1c10fd,%eax
  1c0be2:	eb 05                	jmp    1c0be9 <printer_vprintf+0x7be>
  1c0be4:	b8 00 11 1c 00       	mov    $0x1c1100,%eax
  1c0be9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c0bed:	eb 01                	jmp    1c0bf0 <printer_vprintf+0x7c5>
            if (flags & FLAG_NEGATIVE) {
  1c0bef:	90                   	nop
        }

        int len;
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  1c0bf0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  1c0bf4:	78 24                	js     1c0c1a <printer_vprintf+0x7ef>
  1c0bf6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0bf9:	83 e0 20             	and    $0x20,%eax
  1c0bfc:	85 c0                	test   %eax,%eax
  1c0bfe:	75 1a                	jne    1c0c1a <printer_vprintf+0x7ef>
            len = strnlen(data, precision);
  1c0c00:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1c0c03:	48 63 d0             	movslq %eax,%rdx
  1c0c06:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  1c0c0a:	48 89 d6             	mov    %rdx,%rsi
  1c0c0d:	48 89 c7             	mov    %rax,%rdi
  1c0c10:	e8 ea f5 ff ff       	call   1c01ff <strnlen>
  1c0c15:	89 45 bc             	mov    %eax,-0x44(%rbp)
  1c0c18:	eb 0f                	jmp    1c0c29 <printer_vprintf+0x7fe>
        } else {
            len = strlen(data);
  1c0c1a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  1c0c1e:	48 89 c7             	mov    %rax,%rdi
  1c0c21:	e8 a8 f5 ff ff       	call   1c01ce <strlen>
  1c0c26:	89 45 bc             	mov    %eax,-0x44(%rbp)
        }
        int zeros;
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  1c0c29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0c2c:	83 e0 20             	and    $0x20,%eax
  1c0c2f:	85 c0                	test   %eax,%eax
  1c0c31:	74 20                	je     1c0c53 <printer_vprintf+0x828>
  1c0c33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  1c0c37:	78 1a                	js     1c0c53 <printer_vprintf+0x828>
            zeros = precision > len ? precision - len : 0;
  1c0c39:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1c0c3c:	3b 45 bc             	cmp    -0x44(%rbp),%eax
  1c0c3f:	7e 08                	jle    1c0c49 <printer_vprintf+0x81e>
  1c0c41:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1c0c44:	2b 45 bc             	sub    -0x44(%rbp),%eax
  1c0c47:	eb 05                	jmp    1c0c4e <printer_vprintf+0x823>
  1c0c49:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0c4e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  1c0c51:	eb 5c                	jmp    1c0caf <printer_vprintf+0x884>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  1c0c53:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0c56:	83 e0 20             	and    $0x20,%eax
  1c0c59:	85 c0                	test   %eax,%eax
  1c0c5b:	74 4b                	je     1c0ca8 <printer_vprintf+0x87d>
  1c0c5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0c60:	83 e0 02             	and    $0x2,%eax
  1c0c63:	85 c0                	test   %eax,%eax
  1c0c65:	74 41                	je     1c0ca8 <printer_vprintf+0x87d>
                   && !(flags & FLAG_LEFTJUSTIFY)
  1c0c67:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0c6a:	83 e0 04             	and    $0x4,%eax
  1c0c6d:	85 c0                	test   %eax,%eax
  1c0c6f:	75 37                	jne    1c0ca8 <printer_vprintf+0x87d>
                   && len + (int) strlen(prefix) < width) {
  1c0c71:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  1c0c75:	48 89 c7             	mov    %rax,%rdi
  1c0c78:	e8 51 f5 ff ff       	call   1c01ce <strlen>
  1c0c7d:	89 c2                	mov    %eax,%edx
  1c0c7f:	8b 45 bc             	mov    -0x44(%rbp),%eax
  1c0c82:	01 d0                	add    %edx,%eax
  1c0c84:	39 45 e8             	cmp    %eax,-0x18(%rbp)
  1c0c87:	7e 1f                	jle    1c0ca8 <printer_vprintf+0x87d>
            zeros = width - len - strlen(prefix);
  1c0c89:	8b 45 e8             	mov    -0x18(%rbp),%eax
  1c0c8c:	2b 45 bc             	sub    -0x44(%rbp),%eax
  1c0c8f:	89 c3                	mov    %eax,%ebx
  1c0c91:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  1c0c95:	48 89 c7             	mov    %rax,%rdi
  1c0c98:	e8 31 f5 ff ff       	call   1c01ce <strlen>
  1c0c9d:	89 c2                	mov    %eax,%edx
  1c0c9f:	89 d8                	mov    %ebx,%eax
  1c0ca1:	29 d0                	sub    %edx,%eax
  1c0ca3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  1c0ca6:	eb 07                	jmp    1c0caf <printer_vprintf+0x884>
        } else {
            zeros = 0;
  1c0ca8:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
        }
        width -= len + zeros + strlen(prefix);
  1c0caf:	8b 55 bc             	mov    -0x44(%rbp),%edx
  1c0cb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  1c0cb5:	01 d0                	add    %edx,%eax
  1c0cb7:	48 63 d8             	movslq %eax,%rbx
  1c0cba:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  1c0cbe:	48 89 c7             	mov    %rax,%rdi
  1c0cc1:	e8 08 f5 ff ff       	call   1c01ce <strlen>
  1c0cc6:	48 8d 14 03          	lea    (%rbx,%rax,1),%rdx
  1c0cca:	8b 45 e8             	mov    -0x18(%rbp),%eax
  1c0ccd:	29 d0                	sub    %edx,%eax
  1c0ccf:	89 45 e8             	mov    %eax,-0x18(%rbp)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1c0cd2:	eb 25                	jmp    1c0cf9 <printer_vprintf+0x8ce>
            p->putc(p, ' ', color);
  1c0cd4:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0cdb:	48 8b 08             	mov    (%rax),%rcx
  1c0cde:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1c0ce4:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0ceb:	be 20 00 00 00       	mov    $0x20,%esi
  1c0cf0:	48 89 c7             	mov    %rax,%rdi
  1c0cf3:	ff d1                	call   *%rcx
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1c0cf5:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  1c0cf9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0cfc:	83 e0 04             	and    $0x4,%eax
  1c0cff:	85 c0                	test   %eax,%eax
  1c0d01:	75 36                	jne    1c0d39 <printer_vprintf+0x90e>
  1c0d03:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  1c0d07:	7f cb                	jg     1c0cd4 <printer_vprintf+0x8a9>
        }
        for (; *prefix; ++prefix) {
  1c0d09:	eb 2e                	jmp    1c0d39 <printer_vprintf+0x90e>
            p->putc(p, *prefix, color);
  1c0d0b:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0d12:	4c 8b 00             	mov    (%rax),%r8
  1c0d15:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  1c0d19:	0f b6 00             	movzbl (%rax),%eax
  1c0d1c:	0f b6 c8             	movzbl %al,%ecx
  1c0d1f:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1c0d25:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0d2c:	89 ce                	mov    %ecx,%esi
  1c0d2e:	48 89 c7             	mov    %rax,%rdi
  1c0d31:	41 ff d0             	call   *%r8
        for (; *prefix; ++prefix) {
  1c0d34:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  1c0d39:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  1c0d3d:	0f b6 00             	movzbl (%rax),%eax
  1c0d40:	84 c0                	test   %al,%al
  1c0d42:	75 c7                	jne    1c0d0b <printer_vprintf+0x8e0>
        }
        for (; zeros > 0; --zeros) {
  1c0d44:	eb 25                	jmp    1c0d6b <printer_vprintf+0x940>
            p->putc(p, '0', color);
  1c0d46:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0d4d:	48 8b 08             	mov    (%rax),%rcx
  1c0d50:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1c0d56:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0d5d:	be 30 00 00 00       	mov    $0x30,%esi
  1c0d62:	48 89 c7             	mov    %rax,%rdi
  1c0d65:	ff d1                	call   *%rcx
        for (; zeros > 0; --zeros) {
  1c0d67:	83 6d b8 01          	subl   $0x1,-0x48(%rbp)
  1c0d6b:	83 7d b8 00          	cmpl   $0x0,-0x48(%rbp)
  1c0d6f:	7f d5                	jg     1c0d46 <printer_vprintf+0x91b>
        }
        for (; len > 0; ++data, --len) {
  1c0d71:	eb 32                	jmp    1c0da5 <printer_vprintf+0x97a>
            p->putc(p, *data, color);
  1c0d73:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0d7a:	4c 8b 00             	mov    (%rax),%r8
  1c0d7d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  1c0d81:	0f b6 00             	movzbl (%rax),%eax
  1c0d84:	0f b6 c8             	movzbl %al,%ecx
  1c0d87:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1c0d8d:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0d94:	89 ce                	mov    %ecx,%esi
  1c0d96:	48 89 c7             	mov    %rax,%rdi
  1c0d99:	41 ff d0             	call   *%r8
        for (; len > 0; ++data, --len) {
  1c0d9c:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  1c0da1:	83 6d bc 01          	subl   $0x1,-0x44(%rbp)
  1c0da5:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  1c0da9:	7f c8                	jg     1c0d73 <printer_vprintf+0x948>
        }
        for (; width > 0; --width) {
  1c0dab:	eb 25                	jmp    1c0dd2 <printer_vprintf+0x9a7>
            p->putc(p, ' ', color);
  1c0dad:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0db4:	48 8b 08             	mov    (%rax),%rcx
  1c0db7:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1c0dbd:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0dc4:	be 20 00 00 00       	mov    $0x20,%esi
  1c0dc9:	48 89 c7             	mov    %rax,%rdi
  1c0dcc:	ff d1                	call   *%rcx
        for (; width > 0; --width) {
  1c0dce:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  1c0dd2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  1c0dd6:	7f d5                	jg     1c0dad <printer_vprintf+0x982>
        }
    done: ;
  1c0dd8:	90                   	nop
    for (; *format; ++format) {
  1c0dd9:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c0de0:	01 
  1c0de1:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0de8:	0f b6 00             	movzbl (%rax),%eax
  1c0deb:	84 c0                	test   %al,%al
  1c0ded:	0f 85 64 f6 ff ff    	jne    1c0457 <printer_vprintf+0x2c>
    }
}
  1c0df3:	90                   	nop
  1c0df4:	90                   	nop
  1c0df5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  1c0df9:	c9                   	leave
  1c0dfa:	c3                   	ret

00000000001c0dfb <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  1c0dfb:	55                   	push   %rbp
  1c0dfc:	48 89 e5             	mov    %rsp,%rbp
  1c0dff:	48 83 ec 20          	sub    $0x20,%rsp
  1c0e03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c0e07:	89 f0                	mov    %esi,%eax
  1c0e09:	89 55 e0             	mov    %edx,-0x20(%rbp)
  1c0e0c:	88 45 e4             	mov    %al,-0x1c(%rbp)
    console_printer* cp = (console_printer*) p;
  1c0e0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0e13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1c0e17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c0e1b:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0e1f:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
  1c0e24:	48 39 d0             	cmp    %rdx,%rax
  1c0e27:	72 0c                	jb     1c0e35 <console_putc+0x3a>
        cp->cursor = console;
  1c0e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c0e2d:	48 c7 40 08 00 80 0b 	movq   $0xb8000,0x8(%rax)
  1c0e34:	00 
    }
    if (c == '\n') {
  1c0e35:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%rbp)
  1c0e39:	75 78                	jne    1c0eb3 <console_putc+0xb8>
        int pos = (cp->cursor - console) % 80;
  1c0e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c0e3f:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0e43:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1c0e49:	48 d1 f8             	sar    %rax
  1c0e4c:	48 89 c1             	mov    %rax,%rcx
  1c0e4f:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1c0e56:	66 66 66 
  1c0e59:	48 89 c8             	mov    %rcx,%rax
  1c0e5c:	48 f7 ea             	imul   %rdx
  1c0e5f:	48 c1 fa 05          	sar    $0x5,%rdx
  1c0e63:	48 89 c8             	mov    %rcx,%rax
  1c0e66:	48 c1 f8 3f          	sar    $0x3f,%rax
  1c0e6a:	48 29 c2             	sub    %rax,%rdx
  1c0e6d:	48 89 d0             	mov    %rdx,%rax
  1c0e70:	48 c1 e0 02          	shl    $0x2,%rax
  1c0e74:	48 01 d0             	add    %rdx,%rax
  1c0e77:	48 c1 e0 04          	shl    $0x4,%rax
  1c0e7b:	48 29 c1             	sub    %rax,%rcx
  1c0e7e:	48 89 ca             	mov    %rcx,%rdx
  1c0e81:	89 55 fc             	mov    %edx,-0x4(%rbp)
        for (; pos != 80; pos++) {
  1c0e84:	eb 25                	jmp    1c0eab <console_putc+0xb0>
            *cp->cursor++ = ' ' | color;
  1c0e86:	8b 45 e0             	mov    -0x20(%rbp),%eax
  1c0e89:	83 c8 20             	or     $0x20,%eax
  1c0e8c:	89 c6                	mov    %eax,%esi
  1c0e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c0e92:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0e96:	48 8d 48 02          	lea    0x2(%rax),%rcx
  1c0e9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  1c0e9e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0ea2:	89 f2                	mov    %esi,%edx
  1c0ea4:	66 89 10             	mov    %dx,(%rax)
        for (; pos != 80; pos++) {
  1c0ea7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  1c0eab:	83 7d fc 50          	cmpl   $0x50,-0x4(%rbp)
  1c0eaf:	75 d5                	jne    1c0e86 <console_putc+0x8b>
        }
    } else {
        *cp->cursor++ = c | color;
    }
}
  1c0eb1:	eb 24                	jmp    1c0ed7 <console_putc+0xdc>
        *cp->cursor++ = c | color;
  1c0eb3:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
  1c0eb7:	8b 55 e0             	mov    -0x20(%rbp),%edx
  1c0eba:	09 d0                	or     %edx,%eax
  1c0ebc:	89 c6                	mov    %eax,%esi
  1c0ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c0ec2:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0ec6:	48 8d 48 02          	lea    0x2(%rax),%rcx
  1c0eca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  1c0ece:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0ed2:	89 f2                	mov    %esi,%edx
  1c0ed4:	66 89 10             	mov    %dx,(%rax)
}
  1c0ed7:	90                   	nop
  1c0ed8:	c9                   	leave
  1c0ed9:	c3                   	ret

00000000001c0eda <console_vprintf>:

int console_vprintf(int cpos, int color, const char* format, va_list val) {
  1c0eda:	55                   	push   %rbp
  1c0edb:	48 89 e5             	mov    %rsp,%rbp
  1c0ede:	48 83 ec 30          	sub    $0x30,%rsp
  1c0ee2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  1c0ee5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  1c0ee8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  1c0eec:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
    struct console_printer cp;
    cp.p.putc = console_putc;
  1c0ef0:	48 c7 45 f0 fb 0d 1c 	movq   $0x1c0dfb,-0x10(%rbp)
  1c0ef7:	00 
    if (cpos < 0 || cpos >= CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1c0ef8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  1c0efc:	78 09                	js     1c0f07 <console_vprintf+0x2d>
  1c0efe:	81 7d ec cf 07 00 00 	cmpl   $0x7cf,-0x14(%rbp)
  1c0f05:	7e 07                	jle    1c0f0e <console_vprintf+0x34>
        cpos = 0;
  1c0f07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
    cp.cursor = console + cpos;
  1c0f0e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0f11:	48 98                	cltq
  1c0f13:	48 01 c0             	add    %rax,%rax
  1c0f16:	48 05 00 80 0b 00    	add    $0xb8000,%rax
  1c0f1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1c0f20:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  1c0f24:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  1c0f28:	8b 75 e8             	mov    -0x18(%rbp),%esi
  1c0f2b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  1c0f2f:	48 89 c7             	mov    %rax,%rdi
  1c0f32:	e8 f4 f4 ff ff       	call   1c042b <printer_vprintf>
    return cp.cursor - console;
  1c0f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0f3b:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1c0f41:	48 d1 f8             	sar    %rax
}
  1c0f44:	c9                   	leave
  1c0f45:	c3                   	ret

00000000001c0f46 <console_printf>:

int console_printf(int cpos, int color, const char* format, ...) {
  1c0f46:	55                   	push   %rbp
  1c0f47:	48 89 e5             	mov    %rsp,%rbp
  1c0f4a:	48 83 ec 60          	sub    $0x60,%rsp
  1c0f4e:	89 7d ac             	mov    %edi,-0x54(%rbp)
  1c0f51:	89 75 a8             	mov    %esi,-0x58(%rbp)
  1c0f54:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  1c0f58:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c0f5c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c0f60:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  1c0f64:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1c0f6b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c0f6f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c0f73:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c0f77:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1c0f7b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1c0f7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  1c0f83:	8b 75 a8             	mov    -0x58(%rbp),%esi
  1c0f86:	8b 45 ac             	mov    -0x54(%rbp),%eax
  1c0f89:	89 c7                	mov    %eax,%edi
  1c0f8b:	e8 4a ff ff ff       	call   1c0eda <console_vprintf>
  1c0f90:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
  1c0f93:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
  1c0f96:	c9                   	leave
  1c0f97:	c3                   	ret

00000000001c0f98 <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  1c0f98:	55                   	push   %rbp
  1c0f99:	48 89 e5             	mov    %rsp,%rbp
  1c0f9c:	48 83 ec 20          	sub    $0x20,%rsp
  1c0fa0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c0fa4:	89 f0                	mov    %esi,%eax
  1c0fa6:	89 55 e0             	mov    %edx,-0x20(%rbp)
  1c0fa9:	88 45 e4             	mov    %al,-0x1c(%rbp)
    string_printer* sp = (string_printer*) p;
  1c0fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0fb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (sp->s < sp->end) {
  1c0fb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0fb8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  1c0fbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0fc0:	48 8b 40 10          	mov    0x10(%rax),%rax
  1c0fc4:	48 39 c2             	cmp    %rax,%rdx
  1c0fc7:	73 1a                	jae    1c0fe3 <string_putc+0x4b>
        *sp->s++ = c;
  1c0fc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0fcd:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0fd1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  1c0fd5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  1c0fd9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0fdd:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
  1c0fe1:	88 10                	mov    %dl,(%rax)
    }
    (void) color;
}
  1c0fe3:	90                   	nop
  1c0fe4:	c9                   	leave
  1c0fe5:	c3                   	ret

00000000001c0fe6 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  1c0fe6:	55                   	push   %rbp
  1c0fe7:	48 89 e5             	mov    %rsp,%rbp
  1c0fea:	48 83 ec 40          	sub    $0x40,%rsp
  1c0fee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  1c0ff2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  1c0ff6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  1c0ffa:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    string_printer sp;
    sp.p.putc = string_putc;
  1c0ffe:	48 c7 45 e8 98 0f 1c 	movq   $0x1c0f98,-0x18(%rbp)
  1c1005:	00 
    sp.s = s;
  1c1006:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c100a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (size) {
  1c100e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  1c1013:	74 33                	je     1c1048 <vsnprintf+0x62>
        sp.end = s + size - 1;
  1c1015:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  1c1019:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  1c101d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c1021:	48 01 d0             	add    %rdx,%rax
  1c1024:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  1c1028:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  1c102c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  1c1030:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  1c1034:	be 00 00 00 00       	mov    $0x0,%esi
  1c1039:	48 89 c7             	mov    %rax,%rdi
  1c103c:	e8 ea f3 ff ff       	call   1c042b <printer_vprintf>
        *sp.s = 0;
  1c1041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c1045:	c6 00 00             	movb   $0x0,(%rax)
    }
    return sp.s - s;
  1c1048:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c104c:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
}
  1c1050:	c9                   	leave
  1c1051:	c3                   	ret

00000000001c1052 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  1c1052:	55                   	push   %rbp
  1c1053:	48 89 e5             	mov    %rsp,%rbp
  1c1056:	48 83 ec 70          	sub    $0x70,%rsp
  1c105a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  1c105e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  1c1062:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  1c1066:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c106a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c106e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  1c1072:	c7 45 b0 18 00 00 00 	movl   $0x18,-0x50(%rbp)
  1c1079:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c107d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  1c1081:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c1085:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    int n = vsnprintf(s, size, format, val);
  1c1089:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  1c108d:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  1c1091:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  1c1095:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1c1099:	48 89 c7             	mov    %rax,%rdi
  1c109c:	e8 45 ff ff ff       	call   1c0fe6 <vsnprintf>
  1c10a1:	89 45 cc             	mov    %eax,-0x34(%rbp)
    va_end(val);
    return n;
  1c10a4:	8b 45 cc             	mov    -0x34(%rbp),%eax
}
  1c10a7:	c9                   	leave
  1c10a8:	c3                   	ret

00000000001c10a9 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  1c10a9:	55                   	push   %rbp
  1c10aa:	48 89 e5             	mov    %rsp,%rbp
  1c10ad:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1c10b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  1c10b8:	eb 13                	jmp    1c10cd <console_clear+0x24>
        console[i] = ' ' | 0x0700;
  1c10ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  1c10bd:	48 98                	cltq
  1c10bf:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%rax,%rax,1)
  1c10c6:	00 20 07 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1c10c9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  1c10cd:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
  1c10d4:	7e e4                	jle    1c10ba <console_clear+0x11>
    }
    cursorpos = 0;
  1c10d6:	c7 05 1c 7f ef ff 00 	movl   $0x0,-0x1080e4(%rip)        # b8ffc <cursorpos>
  1c10dd:	00 00 00 
}
  1c10e0:	90                   	nop
  1c10e1:	c9                   	leave
  1c10e2:	c3                   	ret
