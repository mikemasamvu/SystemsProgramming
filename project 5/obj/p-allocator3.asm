
obj/p-allocator3.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000180000 <process_main>:
uint8_t* stack_bottom;

// Program that starts allocating page by page from its heap
// till it reaches stack OR runs out of memory

void process_main(void) {
  180000:	55                   	push   %rbp
  180001:	48 89 e5             	mov    %rsp,%rbp
  180004:	53                   	push   %rbx
  180005:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  180009:	cd 31                	int    $0x31
  18000b:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  18000d:	89 c7                	mov    %eax,%edi
  18000f:	e8 74 03 00 00       	call   180388 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  180014:	b8 17 30 18 00       	mov    $0x183017,%eax
  180019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  18001f:	48 89 05 e2 1f 00 00 	mov    %rax,0x1fe2(%rip)        # 182008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  180026:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  180029:	48 83 e8 01          	sub    $0x1,%rax
  18002d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  180033:	48 89 05 c6 1f 00 00 	mov    %rax,0x1fc6(%rip)        # 182000 <stack_bottom>
  18003a:	eb 02                	jmp    18003e <process_main+0x3e>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  18003c:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  18003e:	e8 09 03 00 00       	call   18034c <rand>
  180043:	48 63 d0             	movslq %eax,%rdx
  180046:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  18004d:	48 c1 fa 25          	sar    $0x25,%rdx
  180051:	89 c1                	mov    %eax,%ecx
  180053:	c1 f9 1f             	sar    $0x1f,%ecx
  180056:	29 ca                	sub    %ecx,%edx
  180058:	6b d2 64             	imul   $0x64,%edx,%edx
  18005b:	29 d0                	sub    %edx,%eax
  18005d:	39 d8                	cmp    %ebx,%eax
  18005f:	7d db                	jge    18003c <process_main+0x3c>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  180061:	48 8b 3d a0 1f 00 00 	mov    0x1fa0(%rip),%rdi        # 182008 <heap_top>
  180068:	48 3b 3d 91 1f 00 00 	cmp    0x1f91(%rip),%rdi        # 182000 <stack_bottom>
  18006f:	74 1c                	je     18008d <process_main+0x8d>
//    Allocate a page of memory at address `addr` and allow process to
//    write to it. `Addr` must be page-aligned (i.e., a multiple of
//    PAGESIZE == 4096). Returns 0 on success and -1 on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  180071:	cd 33                	int    $0x33
  180073:	85 c0                	test   %eax,%eax
  180075:	78 16                	js     18008d <process_main+0x8d>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  180077:	48 8b 05 8a 1f 00 00 	mov    0x1f8a(%rip),%rax        # 182008 <heap_top>
  18007e:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  180080:	48 81 05 7d 1f 00 00 	addq   $0x1000,0x1f7d(%rip)        # 182008 <heap_top>
  180087:	00 10 00 00 
  18008b:	eb af                	jmp    18003c <process_main+0x3c>
    asm volatile ("int %0" : /* no result */
  18008d:	cd 32                	int    $0x32
        }
        sys_yield();
    }

    // After running out of memory, do nothing forever
    while (1) {
  18008f:	eb fc                	jmp    18008d <process_main+0x8d>

0000000000180091 <memcpy>:


// memcpy, memmove, memset, strcmp, strlen, strnlen
//    We must provide our own implementations.

void* memcpy(void* dst, const void* src, size_t n) {
  180091:	55                   	push   %rbp
  180092:	48 89 e5             	mov    %rsp,%rbp
  180095:	48 83 ec 28          	sub    $0x28,%rsp
  180099:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  18009d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1800a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1800a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1800a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1800ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1800b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  1800b5:	eb 1c                	jmp    1800d3 <memcpy+0x42>
        *d = *s;
  1800b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1800bb:	0f b6 10             	movzbl (%rax),%edx
  1800be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1800c2:	88 10                	mov    %dl,(%rax)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1800c4:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  1800c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1800ce:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  1800d3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1800d8:	75 dd                	jne    1800b7 <memcpy+0x26>
    }
    return dst;
  1800da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1800de:	c9                   	leave
  1800df:	c3                   	ret

00000000001800e0 <memmove>:

void* memmove(void* dst, const void* src, size_t n) {
  1800e0:	55                   	push   %rbp
  1800e1:	48 89 e5             	mov    %rsp,%rbp
  1800e4:	48 83 ec 28          	sub    $0x28,%rsp
  1800e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1800ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1800f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1800f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1800f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    char* d = (char*) dst;
  1800fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  180100:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (s < d && s + n > d) {
  180104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  180108:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  18010c:	73 6a                	jae    180178 <memmove+0x98>
  18010e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  180112:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  180116:	48 01 d0             	add    %rdx,%rax
  180119:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
  18011d:	73 59                	jae    180178 <memmove+0x98>
        s += n, d += n;
  18011f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  180123:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  180127:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  18012b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        while (n-- > 0) {
  18012f:	eb 17                	jmp    180148 <memmove+0x68>
            *--d = *--s;
  180131:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  180136:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
  18013b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  18013f:	0f b6 10             	movzbl (%rax),%edx
  180142:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  180146:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  180148:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  18014c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  180150:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  180154:	48 85 c0             	test   %rax,%rax
  180157:	75 d8                	jne    180131 <memmove+0x51>
    if (s < d && s + n > d) {
  180159:	eb 2e                	jmp    180189 <memmove+0xa9>
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
  18015b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  18015f:	48 8d 42 01          	lea    0x1(%rdx),%rax
  180163:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  180167:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  18016b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  18016f:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  180173:	0f b6 12             	movzbl (%rdx),%edx
  180176:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  180178:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  18017c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  180180:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  180184:	48 85 c0             	test   %rax,%rax
  180187:	75 d2                	jne    18015b <memmove+0x7b>
        }
    }
    return dst;
  180189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  18018d:	c9                   	leave
  18018e:	c3                   	ret

000000000018018f <memset>:

void* memset(void* v, int c, size_t n) {
  18018f:	55                   	push   %rbp
  180190:	48 89 e5             	mov    %rsp,%rbp
  180193:	48 83 ec 28          	sub    $0x28,%rsp
  180197:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  18019b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  18019e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1801a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1801a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  1801aa:	eb 15                	jmp    1801c1 <memset+0x32>
        *p = c;
  1801ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1801af:	89 c2                	mov    %eax,%edx
  1801b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1801b5:	88 10                	mov    %dl,(%rax)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1801b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1801bc:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  1801c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1801c6:	75 e4                	jne    1801ac <memset+0x1d>
    }
    return v;
  1801c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1801cc:	c9                   	leave
  1801cd:	c3                   	ret

00000000001801ce <strlen>:

size_t strlen(const char* s) {
  1801ce:	55                   	push   %rbp
  1801cf:	48 89 e5             	mov    %rsp,%rbp
  1801d2:	48 83 ec 18          	sub    $0x18,%rsp
  1801d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
  1801da:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  1801e1:	00 
  1801e2:	eb 0a                	jmp    1801ee <strlen+0x20>
        ++n;
  1801e4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; *s != '\0'; ++s) {
  1801e9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  1801ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1801f2:	0f b6 00             	movzbl (%rax),%eax
  1801f5:	84 c0                	test   %al,%al
  1801f7:	75 eb                	jne    1801e4 <strlen+0x16>
    }
    return n;
  1801f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  1801fd:	c9                   	leave
  1801fe:	c3                   	ret

00000000001801ff <strnlen>:

size_t strnlen(const char* s, size_t maxlen) {
  1801ff:	55                   	push   %rbp
  180200:	48 89 e5             	mov    %rsp,%rbp
  180203:	48 83 ec 20          	sub    $0x20,%rsp
  180207:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  18020b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    size_t n;
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  18020f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  180216:	00 
  180217:	eb 0a                	jmp    180223 <strnlen+0x24>
        ++n;
  180219:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  18021e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  180223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  180227:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  18022b:	74 0b                	je     180238 <strnlen+0x39>
  18022d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  180231:	0f b6 00             	movzbl (%rax),%eax
  180234:	84 c0                	test   %al,%al
  180236:	75 e1                	jne    180219 <strnlen+0x1a>
    }
    return n;
  180238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  18023c:	c9                   	leave
  18023d:	c3                   	ret

000000000018023e <strcpy>:

char* strcpy(char* dst, const char* src) {
  18023e:	55                   	push   %rbp
  18023f:	48 89 e5             	mov    %rsp,%rbp
  180242:	48 83 ec 20          	sub    $0x20,%rsp
  180246:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  18024a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    char* d = dst;
  18024e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  180252:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    do {
        *d++ = *src++;
  180256:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  18025a:	48 8d 42 01          	lea    0x1(%rdx),%rax
  18025e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  180262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  180266:	48 8d 48 01          	lea    0x1(%rax),%rcx
  18026a:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
  18026e:	0f b6 12             	movzbl (%rdx),%edx
  180271:	88 10                	mov    %dl,(%rax)
    } while (d[-1]);
  180273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  180277:	48 83 e8 01          	sub    $0x1,%rax
  18027b:	0f b6 00             	movzbl (%rax),%eax
  18027e:	84 c0                	test   %al,%al
  180280:	75 d4                	jne    180256 <strcpy+0x18>
    return dst;
  180282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  180286:	c9                   	leave
  180287:	c3                   	ret

0000000000180288 <strcmp>:

int strcmp(const char* a, const char* b) {
  180288:	55                   	push   %rbp
  180289:	48 89 e5             	mov    %rsp,%rbp
  18028c:	48 83 ec 10          	sub    $0x10,%rsp
  180290:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  180294:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  180298:	eb 0a                	jmp    1802a4 <strcmp+0x1c>
        ++a, ++b;
  18029a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  18029f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  1802a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1802a8:	0f b6 00             	movzbl (%rax),%eax
  1802ab:	84 c0                	test   %al,%al
  1802ad:	74 1d                	je     1802cc <strcmp+0x44>
  1802af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1802b3:	0f b6 00             	movzbl (%rax),%eax
  1802b6:	84 c0                	test   %al,%al
  1802b8:	74 12                	je     1802cc <strcmp+0x44>
  1802ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1802be:	0f b6 10             	movzbl (%rax),%edx
  1802c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1802c5:	0f b6 00             	movzbl (%rax),%eax
  1802c8:	38 c2                	cmp    %al,%dl
  1802ca:	74 ce                	je     18029a <strcmp+0x12>
    }
    return ((unsigned char) *a > (unsigned char) *b)
  1802cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1802d0:	0f b6 00             	movzbl (%rax),%eax
  1802d3:	89 c2                	mov    %eax,%edx
  1802d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1802d9:	0f b6 00             	movzbl (%rax),%eax
  1802dc:	38 d0                	cmp    %dl,%al
  1802de:	0f 92 c0             	setb   %al
  1802e1:	0f b6 d0             	movzbl %al,%edx
        - ((unsigned char) *a < (unsigned char) *b);
  1802e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1802e8:	0f b6 00             	movzbl (%rax),%eax
  1802eb:	89 c1                	mov    %eax,%ecx
  1802ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1802f1:	0f b6 00             	movzbl (%rax),%eax
  1802f4:	38 c1                	cmp    %al,%cl
  1802f6:	0f 92 c0             	setb   %al
  1802f9:	0f b6 c0             	movzbl %al,%eax
  1802fc:	29 c2                	sub    %eax,%edx
  1802fe:	89 d0                	mov    %edx,%eax
}
  180300:	c9                   	leave
  180301:	c3                   	ret

0000000000180302 <strchr>:

char* strchr(const char* s, int c) {
  180302:	55                   	push   %rbp
  180303:	48 89 e5             	mov    %rsp,%rbp
  180306:	48 83 ec 10          	sub    $0x10,%rsp
  18030a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  18030e:	89 75 f4             	mov    %esi,-0xc(%rbp)
    while (*s && *s != (char) c) {
  180311:	eb 05                	jmp    180318 <strchr+0x16>
        ++s;
  180313:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while (*s && *s != (char) c) {
  180318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  18031c:	0f b6 00             	movzbl (%rax),%eax
  18031f:	84 c0                	test   %al,%al
  180321:	74 0e                	je     180331 <strchr+0x2f>
  180323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  180327:	0f b6 00             	movzbl (%rax),%eax
  18032a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  18032d:	38 d0                	cmp    %dl,%al
  18032f:	75 e2                	jne    180313 <strchr+0x11>
    }
    if (*s == (char) c) {
  180331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  180335:	0f b6 00             	movzbl (%rax),%eax
  180338:	8b 55 f4             	mov    -0xc(%rbp),%edx
  18033b:	38 d0                	cmp    %dl,%al
  18033d:	75 06                	jne    180345 <strchr+0x43>
        return (char*) s;
  18033f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  180343:	eb 05                	jmp    18034a <strchr+0x48>
    } else {
        return NULL;
  180345:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
  18034a:	c9                   	leave
  18034b:	c3                   	ret

000000000018034c <rand>:
// rand, srand

static int rand_seed_set;
static unsigned rand_seed;

int rand(void) {
  18034c:	55                   	push   %rbp
  18034d:	48 89 e5             	mov    %rsp,%rbp
    if (!rand_seed_set) {
  180350:	8b 05 ba 1c 00 00    	mov    0x1cba(%rip),%eax        # 182010 <rand_seed_set>
  180356:	85 c0                	test   %eax,%eax
  180358:	75 0a                	jne    180364 <rand+0x18>
        srand(819234718U);
  18035a:	bf 9e 87 d4 30       	mov    $0x30d4879e,%edi
  18035f:	e8 24 00 00 00       	call   180388 <srand>
    }
    rand_seed = rand_seed * 1664525U + 1013904223U;
  180364:	8b 05 aa 1c 00 00    	mov    0x1caa(%rip),%eax        # 182014 <rand_seed>
  18036a:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
  180370:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  180375:	89 05 99 1c 00 00    	mov    %eax,0x1c99(%rip)        # 182014 <rand_seed>
    return rand_seed & RAND_MAX;
  18037b:	8b 05 93 1c 00 00    	mov    0x1c93(%rip),%eax        # 182014 <rand_seed>
  180381:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  180386:	5d                   	pop    %rbp
  180387:	c3                   	ret

0000000000180388 <srand>:

void srand(unsigned seed) {
  180388:	55                   	push   %rbp
  180389:	48 89 e5             	mov    %rsp,%rbp
  18038c:	48 83 ec 08          	sub    $0x8,%rsp
  180390:	89 7d fc             	mov    %edi,-0x4(%rbp)
    rand_seed = seed;
  180393:	8b 45 fc             	mov    -0x4(%rbp),%eax
  180396:	89 05 78 1c 00 00    	mov    %eax,0x1c78(%rip)        # 182014 <rand_seed>
    rand_seed_set = 1;
  18039c:	c7 05 6a 1c 00 00 01 	movl   $0x1,0x1c6a(%rip)        # 182010 <rand_seed_set>
  1803a3:	00 00 00 
}
  1803a6:	90                   	nop
  1803a7:	c9                   	leave
  1803a8:	c3                   	ret

00000000001803a9 <fill_numbuf>:
//    Print a message onto the console, starting at the given cursor position.

// snprintf, vsnprintf
//    Format a string into a buffer.

static char* fill_numbuf(char* numbuf_end, unsigned long val, int base) {
  1803a9:	55                   	push   %rbp
  1803aa:	48 89 e5             	mov    %rsp,%rbp
  1803ad:	48 83 ec 28          	sub    $0x28,%rsp
  1803b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1803b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1803b9:	89 55 dc             	mov    %edx,-0x24(%rbp)
    static const char upper_digits[] = "0123456789ABCDEF";
    static const char lower_digits[] = "0123456789abcdef";

    const char* digits = upper_digits;
  1803bc:	48 c7 45 f8 d0 12 18 	movq   $0x1812d0,-0x8(%rbp)
  1803c3:	00 
    if (base < 0) {
  1803c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  1803c8:	79 0b                	jns    1803d5 <fill_numbuf+0x2c>
        digits = lower_digits;
  1803ca:	48 c7 45 f8 f0 12 18 	movq   $0x1812f0,-0x8(%rbp)
  1803d1:	00 
        base = -base;
  1803d2:	f7 5d dc             	negl   -0x24(%rbp)
    }

    *--numbuf_end = '\0';
  1803d5:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  1803da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1803de:	c6 00 00             	movb   $0x0,(%rax)
    do {
        *--numbuf_end = digits[val % base];
  1803e1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  1803e4:	48 63 c8             	movslq %eax,%rcx
  1803e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1803eb:	ba 00 00 00 00       	mov    $0x0,%edx
  1803f0:	48 f7 f1             	div    %rcx
  1803f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1803f7:	48 01 d0             	add    %rdx,%rax
  1803fa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  1803ff:	0f b6 10             	movzbl (%rax),%edx
  180402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  180406:	88 10                	mov    %dl,(%rax)
        val /= base;
  180408:	8b 45 dc             	mov    -0x24(%rbp),%eax
  18040b:	48 63 f0             	movslq %eax,%rsi
  18040e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  180412:	ba 00 00 00 00       	mov    $0x0,%edx
  180417:	48 f7 f6             	div    %rsi
  18041a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    } while (val != 0);
  18041e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  180423:	75 bc                	jne    1803e1 <fill_numbuf+0x38>
    return numbuf_end;
  180425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  180429:	c9                   	leave
  18042a:	c3                   	ret

000000000018042b <printer_vprintf>:
#define FLAG_NUMERIC            (1<<5)
#define FLAG_SIGNED             (1<<6)
#define FLAG_NEGATIVE           (1<<7)
#define FLAG_ALT2               (1<<8)

void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  18042b:	55                   	push   %rbp
  18042c:	48 89 e5             	mov    %rsp,%rbp
  18042f:	53                   	push   %rbx
  180430:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  180437:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
  18043e:	89 b5 74 ff ff ff    	mov    %esi,-0x8c(%rbp)
  180444:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  18044b:	48 89 8d 60 ff ff ff 	mov    %rcx,-0xa0(%rbp)
#define NUMBUFSIZ 24
    char numbuf[NUMBUFSIZ];

    for (; *format; ++format) {
  180452:	e9 8a 09 00 00       	jmp    180de1 <printer_vprintf+0x9b6>
        if (*format != '%') {
  180457:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  18045e:	0f b6 00             	movzbl (%rax),%eax
  180461:	3c 25                	cmp    $0x25,%al
  180463:	74 31                	je     180496 <printer_vprintf+0x6b>
            p->putc(p, *format, color);
  180465:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  18046c:	4c 8b 00             	mov    (%rax),%r8
  18046f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  180476:	0f b6 00             	movzbl (%rax),%eax
  180479:	0f b6 c8             	movzbl %al,%ecx
  18047c:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  180482:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  180489:	89 ce                	mov    %ecx,%esi
  18048b:	48 89 c7             	mov    %rax,%rdi
  18048e:	41 ff d0             	call   *%r8
            continue;
  180491:	e9 43 09 00 00       	jmp    180dd9 <printer_vprintf+0x9ae>
        }

        // process flags
        int flags = 0;
  180496:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        for (++format; *format; ++format) {
  18049d:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1804a4:	01 
  1804a5:	eb 44                	jmp    1804eb <printer_vprintf+0xc0>
            const char* flagc = strchr(flag_chars, *format);
  1804a7:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1804ae:	0f b6 00             	movzbl (%rax),%eax
  1804b1:	0f be c0             	movsbl %al,%eax
  1804b4:	89 c6                	mov    %eax,%esi
  1804b6:	bf f0 10 18 00       	mov    $0x1810f0,%edi
  1804bb:	e8 42 fe ff ff       	call   180302 <strchr>
  1804c0:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (flagc) {
  1804c4:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  1804c9:	74 30                	je     1804fb <printer_vprintf+0xd0>
                flags |= 1 << (flagc - flag_chars);
  1804cb:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  1804cf:	48 2d f0 10 18 00    	sub    $0x1810f0,%rax
  1804d5:	ba 01 00 00 00       	mov    $0x1,%edx
  1804da:	89 c1                	mov    %eax,%ecx
  1804dc:	d3 e2                	shl    %cl,%edx
  1804de:	89 d0                	mov    %edx,%eax
  1804e0:	09 45 ec             	or     %eax,-0x14(%rbp)
        for (++format; *format; ++format) {
  1804e3:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1804ea:	01 
  1804eb:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1804f2:	0f b6 00             	movzbl (%rax),%eax
  1804f5:	84 c0                	test   %al,%al
  1804f7:	75 ae                	jne    1804a7 <printer_vprintf+0x7c>
  1804f9:	eb 01                	jmp    1804fc <printer_vprintf+0xd1>
            } else {
                break;
  1804fb:	90                   	nop
            }
        }

        // process width
        int width = -1;
  1804fc:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
        if (*format >= '1' && *format <= '9') {
  180503:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  18050a:	0f b6 00             	movzbl (%rax),%eax
  18050d:	3c 30                	cmp    $0x30,%al
  18050f:	7e 67                	jle    180578 <printer_vprintf+0x14d>
  180511:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  180518:	0f b6 00             	movzbl (%rax),%eax
  18051b:	3c 39                	cmp    $0x39,%al
  18051d:	7f 59                	jg     180578 <printer_vprintf+0x14d>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  18051f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  180526:	eb 2e                	jmp    180556 <printer_vprintf+0x12b>
                width = 10 * width + *format++ - '0';
  180528:	8b 55 e8             	mov    -0x18(%rbp),%edx
  18052b:	89 d0                	mov    %edx,%eax
  18052d:	c1 e0 02             	shl    $0x2,%eax
  180530:	01 d0                	add    %edx,%eax
  180532:	01 c0                	add    %eax,%eax
  180534:	89 c1                	mov    %eax,%ecx
  180536:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  18053d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  180541:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  180548:	0f b6 00             	movzbl (%rax),%eax
  18054b:	0f be c0             	movsbl %al,%eax
  18054e:	01 c8                	add    %ecx,%eax
  180550:	83 e8 30             	sub    $0x30,%eax
  180553:	89 45 e8             	mov    %eax,-0x18(%rbp)
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  180556:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  18055d:	0f b6 00             	movzbl (%rax),%eax
  180560:	3c 2f                	cmp    $0x2f,%al
  180562:	0f 8e 85 00 00 00    	jle    1805ed <printer_vprintf+0x1c2>
  180568:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  18056f:	0f b6 00             	movzbl (%rax),%eax
  180572:	3c 39                	cmp    $0x39,%al
  180574:	7e b2                	jle    180528 <printer_vprintf+0xfd>
        if (*format >= '1' && *format <= '9') {
  180576:	eb 75                	jmp    1805ed <printer_vprintf+0x1c2>
            }
        } else if (*format == '*') {
  180578:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  18057f:	0f b6 00             	movzbl (%rax),%eax
  180582:	3c 2a                	cmp    $0x2a,%al
  180584:	75 68                	jne    1805ee <printer_vprintf+0x1c3>
            width = va_arg(val, int);
  180586:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  18058d:	8b 00                	mov    (%rax),%eax
  18058f:	83 f8 2f             	cmp    $0x2f,%eax
  180592:	77 30                	ja     1805c4 <printer_vprintf+0x199>
  180594:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  18059b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  18059f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1805a6:	8b 00                	mov    (%rax),%eax
  1805a8:	89 c0                	mov    %eax,%eax
  1805aa:	48 01 d0             	add    %rdx,%rax
  1805ad:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1805b4:	8b 12                	mov    (%rdx),%edx
  1805b6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1805b9:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1805c0:	89 0a                	mov    %ecx,(%rdx)
  1805c2:	eb 1a                	jmp    1805de <printer_vprintf+0x1b3>
  1805c4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1805cb:	48 8b 40 08          	mov    0x8(%rax),%rax
  1805cf:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1805d3:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1805da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1805de:	8b 00                	mov    (%rax),%eax
  1805e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
            ++format;
  1805e3:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1805ea:	01 
  1805eb:	eb 01                	jmp    1805ee <printer_vprintf+0x1c3>
        if (*format >= '1' && *format <= '9') {
  1805ed:	90                   	nop
        }

        // process precision
        int precision = -1;
  1805ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
        if (*format == '.') {
  1805f5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1805fc:	0f b6 00             	movzbl (%rax),%eax
  1805ff:	3c 2e                	cmp    $0x2e,%al
  180601:	0f 85 00 01 00 00    	jne    180707 <printer_vprintf+0x2dc>
            ++format;
  180607:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  18060e:	01 
            if (*format >= '0' && *format <= '9') {
  18060f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  180616:	0f b6 00             	movzbl (%rax),%eax
  180619:	3c 2f                	cmp    $0x2f,%al
  18061b:	7e 67                	jle    180684 <printer_vprintf+0x259>
  18061d:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  180624:	0f b6 00             	movzbl (%rax),%eax
  180627:	3c 39                	cmp    $0x39,%al
  180629:	7f 59                	jg     180684 <printer_vprintf+0x259>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  18062b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  180632:	eb 2e                	jmp    180662 <printer_vprintf+0x237>
                    precision = 10 * precision + *format++ - '0';
  180634:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  180637:	89 d0                	mov    %edx,%eax
  180639:	c1 e0 02             	shl    $0x2,%eax
  18063c:	01 d0                	add    %edx,%eax
  18063e:	01 c0                	add    %eax,%eax
  180640:	89 c1                	mov    %eax,%ecx
  180642:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  180649:	48 8d 50 01          	lea    0x1(%rax),%rdx
  18064d:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  180654:	0f b6 00             	movzbl (%rax),%eax
  180657:	0f be c0             	movsbl %al,%eax
  18065a:	01 c8                	add    %ecx,%eax
  18065c:	83 e8 30             	sub    $0x30,%eax
  18065f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  180662:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  180669:	0f b6 00             	movzbl (%rax),%eax
  18066c:	3c 2f                	cmp    $0x2f,%al
  18066e:	0f 8e 85 00 00 00    	jle    1806f9 <printer_vprintf+0x2ce>
  180674:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  18067b:	0f b6 00             	movzbl (%rax),%eax
  18067e:	3c 39                	cmp    $0x39,%al
  180680:	7e b2                	jle    180634 <printer_vprintf+0x209>
            if (*format >= '0' && *format <= '9') {
  180682:	eb 75                	jmp    1806f9 <printer_vprintf+0x2ce>
                }
            } else if (*format == '*') {
  180684:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  18068b:	0f b6 00             	movzbl (%rax),%eax
  18068e:	3c 2a                	cmp    $0x2a,%al
  180690:	75 68                	jne    1806fa <printer_vprintf+0x2cf>
                precision = va_arg(val, int);
  180692:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180699:	8b 00                	mov    (%rax),%eax
  18069b:	83 f8 2f             	cmp    $0x2f,%eax
  18069e:	77 30                	ja     1806d0 <printer_vprintf+0x2a5>
  1806a0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1806a7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1806ab:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1806b2:	8b 00                	mov    (%rax),%eax
  1806b4:	89 c0                	mov    %eax,%eax
  1806b6:	48 01 d0             	add    %rdx,%rax
  1806b9:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1806c0:	8b 12                	mov    (%rdx),%edx
  1806c2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1806c5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1806cc:	89 0a                	mov    %ecx,(%rdx)
  1806ce:	eb 1a                	jmp    1806ea <printer_vprintf+0x2bf>
  1806d0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1806d7:	48 8b 40 08          	mov    0x8(%rax),%rax
  1806db:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1806df:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1806e6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1806ea:	8b 00                	mov    (%rax),%eax
  1806ec:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                ++format;
  1806ef:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1806f6:	01 
  1806f7:	eb 01                	jmp    1806fa <printer_vprintf+0x2cf>
            if (*format >= '0' && *format <= '9') {
  1806f9:	90                   	nop
            }
            if (precision < 0) {
  1806fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  1806fe:	79 07                	jns    180707 <printer_vprintf+0x2dc>
                precision = 0;
  180700:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
            }
        }

        // process main conversion character
        int base = 10;
  180707:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%rbp)
        unsigned long num = 0;
  18070e:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  180715:	00 
        int length = 0;
  180716:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
        char* data = "";
  18071d:	48 c7 45 c8 f6 10 18 	movq   $0x1810f6,-0x38(%rbp)
  180724:	00 
    again:
        switch (*format) {
  180725:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  18072c:	0f b6 00             	movzbl (%rax),%eax
  18072f:	0f be c0             	movsbl %al,%eax
  180732:	83 e8 43             	sub    $0x43,%eax
  180735:	83 f8 37             	cmp    $0x37,%eax
  180738:	0f 87 9f 03 00 00    	ja     180add <printer_vprintf+0x6b2>
  18073e:	89 c0                	mov    %eax,%eax
  180740:	48 8b 04 c5 08 11 18 	mov    0x181108(,%rax,8),%rax
  180747:	00 
  180748:	ff e0                	jmp    *%rax
        case 'l':
        case 'z':
            length = 1;
  18074a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
            ++format;
  180751:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  180758:	01 
            goto again;
  180759:	eb ca                	jmp    180725 <printer_vprintf+0x2fa>
        case 'd':
        case 'i': {
            long x = length ? va_arg(val, long) : va_arg(val, int);
  18075b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  18075f:	74 5d                	je     1807be <printer_vprintf+0x393>
  180761:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180768:	8b 00                	mov    (%rax),%eax
  18076a:	83 f8 2f             	cmp    $0x2f,%eax
  18076d:	77 30                	ja     18079f <printer_vprintf+0x374>
  18076f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180776:	48 8b 50 10          	mov    0x10(%rax),%rdx
  18077a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180781:	8b 00                	mov    (%rax),%eax
  180783:	89 c0                	mov    %eax,%eax
  180785:	48 01 d0             	add    %rdx,%rax
  180788:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  18078f:	8b 12                	mov    (%rdx),%edx
  180791:	8d 4a 08             	lea    0x8(%rdx),%ecx
  180794:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  18079b:	89 0a                	mov    %ecx,(%rdx)
  18079d:	eb 1a                	jmp    1807b9 <printer_vprintf+0x38e>
  18079f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1807a6:	48 8b 40 08          	mov    0x8(%rax),%rax
  1807aa:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1807ae:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1807b5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1807b9:	48 8b 00             	mov    (%rax),%rax
  1807bc:	eb 5c                	jmp    18081a <printer_vprintf+0x3ef>
  1807be:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1807c5:	8b 00                	mov    (%rax),%eax
  1807c7:	83 f8 2f             	cmp    $0x2f,%eax
  1807ca:	77 30                	ja     1807fc <printer_vprintf+0x3d1>
  1807cc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1807d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1807d7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1807de:	8b 00                	mov    (%rax),%eax
  1807e0:	89 c0                	mov    %eax,%eax
  1807e2:	48 01 d0             	add    %rdx,%rax
  1807e5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1807ec:	8b 12                	mov    (%rdx),%edx
  1807ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1807f1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1807f8:	89 0a                	mov    %ecx,(%rdx)
  1807fa:	eb 1a                	jmp    180816 <printer_vprintf+0x3eb>
  1807fc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180803:	48 8b 40 08          	mov    0x8(%rax),%rax
  180807:	48 8d 48 08          	lea    0x8(%rax),%rcx
  18080b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  180812:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  180816:	8b 00                	mov    (%rax),%eax
  180818:	48 98                	cltq
  18081a:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  18081e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  180822:	48 c1 f8 38          	sar    $0x38,%rax
  180826:	25 80 00 00 00       	and    $0x80,%eax
  18082b:	89 45 a4             	mov    %eax,-0x5c(%rbp)
            num = negative ? -x : x;
  18082e:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  180832:	74 09                	je     18083d <printer_vprintf+0x412>
  180834:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  180838:	48 f7 d8             	neg    %rax
  18083b:	eb 04                	jmp    180841 <printer_vprintf+0x416>
  18083d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  180841:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  180845:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  180848:	83 c8 60             	or     $0x60,%eax
  18084b:	09 45 ec             	or     %eax,-0x14(%rbp)
            break;
  18084e:	e9 cf 02 00 00       	jmp    180b22 <printer_vprintf+0x6f7>
        }
        case 'u':
        format_unsigned:
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  180853:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  180857:	74 5d                	je     1808b6 <printer_vprintf+0x48b>
  180859:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180860:	8b 00                	mov    (%rax),%eax
  180862:	83 f8 2f             	cmp    $0x2f,%eax
  180865:	77 30                	ja     180897 <printer_vprintf+0x46c>
  180867:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  18086e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  180872:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180879:	8b 00                	mov    (%rax),%eax
  18087b:	89 c0                	mov    %eax,%eax
  18087d:	48 01 d0             	add    %rdx,%rax
  180880:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  180887:	8b 12                	mov    (%rdx),%edx
  180889:	8d 4a 08             	lea    0x8(%rdx),%ecx
  18088c:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  180893:	89 0a                	mov    %ecx,(%rdx)
  180895:	eb 1a                	jmp    1808b1 <printer_vprintf+0x486>
  180897:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  18089e:	48 8b 40 08          	mov    0x8(%rax),%rax
  1808a2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1808a6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1808ad:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1808b1:	48 8b 00             	mov    (%rax),%rax
  1808b4:	eb 5c                	jmp    180912 <printer_vprintf+0x4e7>
  1808b6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1808bd:	8b 00                	mov    (%rax),%eax
  1808bf:	83 f8 2f             	cmp    $0x2f,%eax
  1808c2:	77 30                	ja     1808f4 <printer_vprintf+0x4c9>
  1808c4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1808cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1808cf:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1808d6:	8b 00                	mov    (%rax),%eax
  1808d8:	89 c0                	mov    %eax,%eax
  1808da:	48 01 d0             	add    %rdx,%rax
  1808dd:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1808e4:	8b 12                	mov    (%rdx),%edx
  1808e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1808e9:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1808f0:	89 0a                	mov    %ecx,(%rdx)
  1808f2:	eb 1a                	jmp    18090e <printer_vprintf+0x4e3>
  1808f4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1808fb:	48 8b 40 08          	mov    0x8(%rax),%rax
  1808ff:	48 8d 48 08          	lea    0x8(%rax),%rcx
  180903:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  18090a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  18090e:	8b 00                	mov    (%rax),%eax
  180910:	89 c0                	mov    %eax,%eax
  180912:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC;
  180916:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
            break;
  18091a:	e9 03 02 00 00       	jmp    180b22 <printer_vprintf+0x6f7>
        case 'x':
            base = -16;
  18091f:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            goto format_unsigned;
  180926:	e9 28 ff ff ff       	jmp    180853 <printer_vprintf+0x428>
        case 'X':
            base = 16;
  18092b:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%rbp)
            goto format_unsigned;
  180932:	e9 1c ff ff ff       	jmp    180853 <printer_vprintf+0x428>
        case 'p':
            num = (uintptr_t) va_arg(val, void*);
  180937:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  18093e:	8b 00                	mov    (%rax),%eax
  180940:	83 f8 2f             	cmp    $0x2f,%eax
  180943:	77 30                	ja     180975 <printer_vprintf+0x54a>
  180945:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  18094c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  180950:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180957:	8b 00                	mov    (%rax),%eax
  180959:	89 c0                	mov    %eax,%eax
  18095b:	48 01 d0             	add    %rdx,%rax
  18095e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  180965:	8b 12                	mov    (%rdx),%edx
  180967:	8d 4a 08             	lea    0x8(%rdx),%ecx
  18096a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  180971:	89 0a                	mov    %ecx,(%rdx)
  180973:	eb 1a                	jmp    18098f <printer_vprintf+0x564>
  180975:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  18097c:	48 8b 40 08          	mov    0x8(%rax),%rax
  180980:	48 8d 48 08          	lea    0x8(%rax),%rcx
  180984:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  18098b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  18098f:	48 8b 00             	mov    (%rax),%rax
  180992:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            base = -16;
  180996:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  18099d:	81 4d ec 21 01 00 00 	orl    $0x121,-0x14(%rbp)
            break;
  1809a4:	e9 79 01 00 00       	jmp    180b22 <printer_vprintf+0x6f7>
        case 's':
            data = va_arg(val, char*);
  1809a9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1809b0:	8b 00                	mov    (%rax),%eax
  1809b2:	83 f8 2f             	cmp    $0x2f,%eax
  1809b5:	77 30                	ja     1809e7 <printer_vprintf+0x5bc>
  1809b7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1809be:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1809c2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1809c9:	8b 00                	mov    (%rax),%eax
  1809cb:	89 c0                	mov    %eax,%eax
  1809cd:	48 01 d0             	add    %rdx,%rax
  1809d0:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1809d7:	8b 12                	mov    (%rdx),%edx
  1809d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1809dc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1809e3:	89 0a                	mov    %ecx,(%rdx)
  1809e5:	eb 1a                	jmp    180a01 <printer_vprintf+0x5d6>
  1809e7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1809ee:	48 8b 40 08          	mov    0x8(%rax),%rax
  1809f2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1809f6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1809fd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  180a01:	48 8b 00             	mov    (%rax),%rax
  180a04:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            break;
  180a08:	e9 15 01 00 00       	jmp    180b22 <printer_vprintf+0x6f7>
        case 'C':
            color = va_arg(val, int);
  180a0d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180a14:	8b 00                	mov    (%rax),%eax
  180a16:	83 f8 2f             	cmp    $0x2f,%eax
  180a19:	77 30                	ja     180a4b <printer_vprintf+0x620>
  180a1b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180a22:	48 8b 50 10          	mov    0x10(%rax),%rdx
  180a26:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180a2d:	8b 00                	mov    (%rax),%eax
  180a2f:	89 c0                	mov    %eax,%eax
  180a31:	48 01 d0             	add    %rdx,%rax
  180a34:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  180a3b:	8b 12                	mov    (%rdx),%edx
  180a3d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  180a40:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  180a47:	89 0a                	mov    %ecx,(%rdx)
  180a49:	eb 1a                	jmp    180a65 <printer_vprintf+0x63a>
  180a4b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180a52:	48 8b 40 08          	mov    0x8(%rax),%rax
  180a56:	48 8d 48 08          	lea    0x8(%rax),%rcx
  180a5a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  180a61:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  180a65:	8b 00                	mov    (%rax),%eax
  180a67:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
            goto done;
  180a6d:	e9 67 03 00 00       	jmp    180dd9 <printer_vprintf+0x9ae>
        case 'c':
            data = numbuf;
  180a72:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  180a76:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = va_arg(val, int);
  180a7a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180a81:	8b 00                	mov    (%rax),%eax
  180a83:	83 f8 2f             	cmp    $0x2f,%eax
  180a86:	77 30                	ja     180ab8 <printer_vprintf+0x68d>
  180a88:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180a8f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  180a93:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180a9a:	8b 00                	mov    (%rax),%eax
  180a9c:	89 c0                	mov    %eax,%eax
  180a9e:	48 01 d0             	add    %rdx,%rax
  180aa1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  180aa8:	8b 12                	mov    (%rdx),%edx
  180aaa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  180aad:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  180ab4:	89 0a                	mov    %ecx,(%rdx)
  180ab6:	eb 1a                	jmp    180ad2 <printer_vprintf+0x6a7>
  180ab8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  180abf:	48 8b 40 08          	mov    0x8(%rax),%rax
  180ac3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  180ac7:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  180ace:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  180ad2:	8b 00                	mov    (%rax),%eax
  180ad4:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  180ad7:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            break;
  180adb:	eb 45                	jmp    180b22 <printer_vprintf+0x6f7>
        default:
            data = numbuf;
  180add:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  180ae1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = (*format ? *format : '%');
  180ae5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  180aec:	0f b6 00             	movzbl (%rax),%eax
  180aef:	84 c0                	test   %al,%al
  180af1:	74 0c                	je     180aff <printer_vprintf+0x6d4>
  180af3:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  180afa:	0f b6 00             	movzbl (%rax),%eax
  180afd:	eb 05                	jmp    180b04 <printer_vprintf+0x6d9>
  180aff:	b8 25 00 00 00       	mov    $0x25,%eax
  180b04:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  180b07:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            if (!*format) {
  180b0b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  180b12:	0f b6 00             	movzbl (%rax),%eax
  180b15:	84 c0                	test   %al,%al
  180b17:	75 08                	jne    180b21 <printer_vprintf+0x6f6>
                format--;
  180b19:	48 83 ad 68 ff ff ff 	subq   $0x1,-0x98(%rbp)
  180b20:	01 
            }
            break;
  180b21:	90                   	nop
        }

        if (flags & FLAG_NUMERIC) {
  180b22:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180b25:	83 e0 20             	and    $0x20,%eax
  180b28:	85 c0                	test   %eax,%eax
  180b2a:	74 1e                	je     180b4a <printer_vprintf+0x71f>
            data = fill_numbuf(numbuf + NUMBUFSIZ, num, base);
  180b2c:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  180b30:	48 83 c0 18          	add    $0x18,%rax
  180b34:	8b 55 e0             	mov    -0x20(%rbp),%edx
  180b37:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  180b3b:	48 89 ce             	mov    %rcx,%rsi
  180b3e:	48 89 c7             	mov    %rax,%rdi
  180b41:	e8 63 f8 ff ff       	call   1803a9 <fill_numbuf>
  180b46:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        }

        const char* prefix = "";
  180b4a:	48 c7 45 c0 f6 10 18 	movq   $0x1810f6,-0x40(%rbp)
  180b51:	00 
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  180b52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180b55:	83 e0 20             	and    $0x20,%eax
  180b58:	85 c0                	test   %eax,%eax
  180b5a:	74 48                	je     180ba4 <printer_vprintf+0x779>
  180b5c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180b5f:	83 e0 40             	and    $0x40,%eax
  180b62:	85 c0                	test   %eax,%eax
  180b64:	74 3e                	je     180ba4 <printer_vprintf+0x779>
            if (flags & FLAG_NEGATIVE) {
  180b66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180b69:	25 80 00 00 00       	and    $0x80,%eax
  180b6e:	85 c0                	test   %eax,%eax
  180b70:	74 0a                	je     180b7c <printer_vprintf+0x751>
                prefix = "-";
  180b72:	48 c7 45 c0 f7 10 18 	movq   $0x1810f7,-0x40(%rbp)
  180b79:	00 
            if (flags & FLAG_NEGATIVE) {
  180b7a:	eb 73                	jmp    180bef <printer_vprintf+0x7c4>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  180b7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180b7f:	83 e0 10             	and    $0x10,%eax
  180b82:	85 c0                	test   %eax,%eax
  180b84:	74 0a                	je     180b90 <printer_vprintf+0x765>
                prefix = "+";
  180b86:	48 c7 45 c0 f9 10 18 	movq   $0x1810f9,-0x40(%rbp)
  180b8d:	00 
            if (flags & FLAG_NEGATIVE) {
  180b8e:	eb 5f                	jmp    180bef <printer_vprintf+0x7c4>
            } else if (flags & FLAG_SPACEPOSITIVE) {
  180b90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180b93:	83 e0 08             	and    $0x8,%eax
  180b96:	85 c0                	test   %eax,%eax
  180b98:	74 55                	je     180bef <printer_vprintf+0x7c4>
                prefix = " ";
  180b9a:	48 c7 45 c0 fb 10 18 	movq   $0x1810fb,-0x40(%rbp)
  180ba1:	00 
            if (flags & FLAG_NEGATIVE) {
  180ba2:	eb 4b                	jmp    180bef <printer_vprintf+0x7c4>
            }
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  180ba4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180ba7:	83 e0 20             	and    $0x20,%eax
  180baa:	85 c0                	test   %eax,%eax
  180bac:	74 42                	je     180bf0 <printer_vprintf+0x7c5>
  180bae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180bb1:	83 e0 01             	and    $0x1,%eax
  180bb4:	85 c0                	test   %eax,%eax
  180bb6:	74 38                	je     180bf0 <printer_vprintf+0x7c5>
                   && (base == 16 || base == -16)
  180bb8:	83 7d e0 10          	cmpl   $0x10,-0x20(%rbp)
  180bbc:	74 06                	je     180bc4 <printer_vprintf+0x799>
  180bbe:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  180bc2:	75 2c                	jne    180bf0 <printer_vprintf+0x7c5>
                   && (num || (flags & FLAG_ALT2))) {
  180bc4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  180bc9:	75 0c                	jne    180bd7 <printer_vprintf+0x7ac>
  180bcb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180bce:	25 00 01 00 00       	and    $0x100,%eax
  180bd3:	85 c0                	test   %eax,%eax
  180bd5:	74 19                	je     180bf0 <printer_vprintf+0x7c5>
            prefix = (base == -16 ? "0x" : "0X");
  180bd7:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  180bdb:	75 07                	jne    180be4 <printer_vprintf+0x7b9>
  180bdd:	b8 fd 10 18 00       	mov    $0x1810fd,%eax
  180be2:	eb 05                	jmp    180be9 <printer_vprintf+0x7be>
  180be4:	b8 00 11 18 00       	mov    $0x181100,%eax
  180be9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  180bed:	eb 01                	jmp    180bf0 <printer_vprintf+0x7c5>
            if (flags & FLAG_NEGATIVE) {
  180bef:	90                   	nop
        }

        int len;
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  180bf0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  180bf4:	78 24                	js     180c1a <printer_vprintf+0x7ef>
  180bf6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180bf9:	83 e0 20             	and    $0x20,%eax
  180bfc:	85 c0                	test   %eax,%eax
  180bfe:	75 1a                	jne    180c1a <printer_vprintf+0x7ef>
            len = strnlen(data, precision);
  180c00:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  180c03:	48 63 d0             	movslq %eax,%rdx
  180c06:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  180c0a:	48 89 d6             	mov    %rdx,%rsi
  180c0d:	48 89 c7             	mov    %rax,%rdi
  180c10:	e8 ea f5 ff ff       	call   1801ff <strnlen>
  180c15:	89 45 bc             	mov    %eax,-0x44(%rbp)
  180c18:	eb 0f                	jmp    180c29 <printer_vprintf+0x7fe>
        } else {
            len = strlen(data);
  180c1a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  180c1e:	48 89 c7             	mov    %rax,%rdi
  180c21:	e8 a8 f5 ff ff       	call   1801ce <strlen>
  180c26:	89 45 bc             	mov    %eax,-0x44(%rbp)
        }
        int zeros;
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  180c29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180c2c:	83 e0 20             	and    $0x20,%eax
  180c2f:	85 c0                	test   %eax,%eax
  180c31:	74 20                	je     180c53 <printer_vprintf+0x828>
  180c33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  180c37:	78 1a                	js     180c53 <printer_vprintf+0x828>
            zeros = precision > len ? precision - len : 0;
  180c39:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  180c3c:	3b 45 bc             	cmp    -0x44(%rbp),%eax
  180c3f:	7e 08                	jle    180c49 <printer_vprintf+0x81e>
  180c41:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  180c44:	2b 45 bc             	sub    -0x44(%rbp),%eax
  180c47:	eb 05                	jmp    180c4e <printer_vprintf+0x823>
  180c49:	b8 00 00 00 00       	mov    $0x0,%eax
  180c4e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  180c51:	eb 5c                	jmp    180caf <printer_vprintf+0x884>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  180c53:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180c56:	83 e0 20             	and    $0x20,%eax
  180c59:	85 c0                	test   %eax,%eax
  180c5b:	74 4b                	je     180ca8 <printer_vprintf+0x87d>
  180c5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180c60:	83 e0 02             	and    $0x2,%eax
  180c63:	85 c0                	test   %eax,%eax
  180c65:	74 41                	je     180ca8 <printer_vprintf+0x87d>
                   && !(flags & FLAG_LEFTJUSTIFY)
  180c67:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180c6a:	83 e0 04             	and    $0x4,%eax
  180c6d:	85 c0                	test   %eax,%eax
  180c6f:	75 37                	jne    180ca8 <printer_vprintf+0x87d>
                   && len + (int) strlen(prefix) < width) {
  180c71:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  180c75:	48 89 c7             	mov    %rax,%rdi
  180c78:	e8 51 f5 ff ff       	call   1801ce <strlen>
  180c7d:	89 c2                	mov    %eax,%edx
  180c7f:	8b 45 bc             	mov    -0x44(%rbp),%eax
  180c82:	01 d0                	add    %edx,%eax
  180c84:	39 45 e8             	cmp    %eax,-0x18(%rbp)
  180c87:	7e 1f                	jle    180ca8 <printer_vprintf+0x87d>
            zeros = width - len - strlen(prefix);
  180c89:	8b 45 e8             	mov    -0x18(%rbp),%eax
  180c8c:	2b 45 bc             	sub    -0x44(%rbp),%eax
  180c8f:	89 c3                	mov    %eax,%ebx
  180c91:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  180c95:	48 89 c7             	mov    %rax,%rdi
  180c98:	e8 31 f5 ff ff       	call   1801ce <strlen>
  180c9d:	89 c2                	mov    %eax,%edx
  180c9f:	89 d8                	mov    %ebx,%eax
  180ca1:	29 d0                	sub    %edx,%eax
  180ca3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  180ca6:	eb 07                	jmp    180caf <printer_vprintf+0x884>
        } else {
            zeros = 0;
  180ca8:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
        }
        width -= len + zeros + strlen(prefix);
  180caf:	8b 55 bc             	mov    -0x44(%rbp),%edx
  180cb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  180cb5:	01 d0                	add    %edx,%eax
  180cb7:	48 63 d8             	movslq %eax,%rbx
  180cba:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  180cbe:	48 89 c7             	mov    %rax,%rdi
  180cc1:	e8 08 f5 ff ff       	call   1801ce <strlen>
  180cc6:	48 8d 14 03          	lea    (%rbx,%rax,1),%rdx
  180cca:	8b 45 e8             	mov    -0x18(%rbp),%eax
  180ccd:	29 d0                	sub    %edx,%eax
  180ccf:	89 45 e8             	mov    %eax,-0x18(%rbp)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  180cd2:	eb 25                	jmp    180cf9 <printer_vprintf+0x8ce>
            p->putc(p, ' ', color);
  180cd4:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  180cdb:	48 8b 08             	mov    (%rax),%rcx
  180cde:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  180ce4:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  180ceb:	be 20 00 00 00       	mov    $0x20,%esi
  180cf0:	48 89 c7             	mov    %rax,%rdi
  180cf3:	ff d1                	call   *%rcx
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  180cf5:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  180cf9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180cfc:	83 e0 04             	and    $0x4,%eax
  180cff:	85 c0                	test   %eax,%eax
  180d01:	75 36                	jne    180d39 <printer_vprintf+0x90e>
  180d03:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  180d07:	7f cb                	jg     180cd4 <printer_vprintf+0x8a9>
        }
        for (; *prefix; ++prefix) {
  180d09:	eb 2e                	jmp    180d39 <printer_vprintf+0x90e>
            p->putc(p, *prefix, color);
  180d0b:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  180d12:	4c 8b 00             	mov    (%rax),%r8
  180d15:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  180d19:	0f b6 00             	movzbl (%rax),%eax
  180d1c:	0f b6 c8             	movzbl %al,%ecx
  180d1f:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  180d25:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  180d2c:	89 ce                	mov    %ecx,%esi
  180d2e:	48 89 c7             	mov    %rax,%rdi
  180d31:	41 ff d0             	call   *%r8
        for (; *prefix; ++prefix) {
  180d34:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  180d39:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  180d3d:	0f b6 00             	movzbl (%rax),%eax
  180d40:	84 c0                	test   %al,%al
  180d42:	75 c7                	jne    180d0b <printer_vprintf+0x8e0>
        }
        for (; zeros > 0; --zeros) {
  180d44:	eb 25                	jmp    180d6b <printer_vprintf+0x940>
            p->putc(p, '0', color);
  180d46:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  180d4d:	48 8b 08             	mov    (%rax),%rcx
  180d50:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  180d56:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  180d5d:	be 30 00 00 00       	mov    $0x30,%esi
  180d62:	48 89 c7             	mov    %rax,%rdi
  180d65:	ff d1                	call   *%rcx
        for (; zeros > 0; --zeros) {
  180d67:	83 6d b8 01          	subl   $0x1,-0x48(%rbp)
  180d6b:	83 7d b8 00          	cmpl   $0x0,-0x48(%rbp)
  180d6f:	7f d5                	jg     180d46 <printer_vprintf+0x91b>
        }
        for (; len > 0; ++data, --len) {
  180d71:	eb 32                	jmp    180da5 <printer_vprintf+0x97a>
            p->putc(p, *data, color);
  180d73:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  180d7a:	4c 8b 00             	mov    (%rax),%r8
  180d7d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  180d81:	0f b6 00             	movzbl (%rax),%eax
  180d84:	0f b6 c8             	movzbl %al,%ecx
  180d87:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  180d8d:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  180d94:	89 ce                	mov    %ecx,%esi
  180d96:	48 89 c7             	mov    %rax,%rdi
  180d99:	41 ff d0             	call   *%r8
        for (; len > 0; ++data, --len) {
  180d9c:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  180da1:	83 6d bc 01          	subl   $0x1,-0x44(%rbp)
  180da5:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  180da9:	7f c8                	jg     180d73 <printer_vprintf+0x948>
        }
        for (; width > 0; --width) {
  180dab:	eb 25                	jmp    180dd2 <printer_vprintf+0x9a7>
            p->putc(p, ' ', color);
  180dad:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  180db4:	48 8b 08             	mov    (%rax),%rcx
  180db7:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  180dbd:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  180dc4:	be 20 00 00 00       	mov    $0x20,%esi
  180dc9:	48 89 c7             	mov    %rax,%rdi
  180dcc:	ff d1                	call   *%rcx
        for (; width > 0; --width) {
  180dce:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  180dd2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  180dd6:	7f d5                	jg     180dad <printer_vprintf+0x982>
        }
    done: ;
  180dd8:	90                   	nop
    for (; *format; ++format) {
  180dd9:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  180de0:	01 
  180de1:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  180de8:	0f b6 00             	movzbl (%rax),%eax
  180deb:	84 c0                	test   %al,%al
  180ded:	0f 85 64 f6 ff ff    	jne    180457 <printer_vprintf+0x2c>
    }
}
  180df3:	90                   	nop
  180df4:	90                   	nop
  180df5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  180df9:	c9                   	leave
  180dfa:	c3                   	ret

0000000000180dfb <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  180dfb:	55                   	push   %rbp
  180dfc:	48 89 e5             	mov    %rsp,%rbp
  180dff:	48 83 ec 20          	sub    $0x20,%rsp
  180e03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  180e07:	89 f0                	mov    %esi,%eax
  180e09:	89 55 e0             	mov    %edx,-0x20(%rbp)
  180e0c:	88 45 e4             	mov    %al,-0x1c(%rbp)
    console_printer* cp = (console_printer*) p;
  180e0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  180e13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  180e17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  180e1b:	48 8b 40 08          	mov    0x8(%rax),%rax
  180e1f:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
  180e24:	48 39 d0             	cmp    %rdx,%rax
  180e27:	72 0c                	jb     180e35 <console_putc+0x3a>
        cp->cursor = console;
  180e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  180e2d:	48 c7 40 08 00 80 0b 	movq   $0xb8000,0x8(%rax)
  180e34:	00 
    }
    if (c == '\n') {
  180e35:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%rbp)
  180e39:	75 78                	jne    180eb3 <console_putc+0xb8>
        int pos = (cp->cursor - console) % 80;
  180e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  180e3f:	48 8b 40 08          	mov    0x8(%rax),%rax
  180e43:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  180e49:	48 d1 f8             	sar    %rax
  180e4c:	48 89 c1             	mov    %rax,%rcx
  180e4f:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  180e56:	66 66 66 
  180e59:	48 89 c8             	mov    %rcx,%rax
  180e5c:	48 f7 ea             	imul   %rdx
  180e5f:	48 c1 fa 05          	sar    $0x5,%rdx
  180e63:	48 89 c8             	mov    %rcx,%rax
  180e66:	48 c1 f8 3f          	sar    $0x3f,%rax
  180e6a:	48 29 c2             	sub    %rax,%rdx
  180e6d:	48 89 d0             	mov    %rdx,%rax
  180e70:	48 c1 e0 02          	shl    $0x2,%rax
  180e74:	48 01 d0             	add    %rdx,%rax
  180e77:	48 c1 e0 04          	shl    $0x4,%rax
  180e7b:	48 29 c1             	sub    %rax,%rcx
  180e7e:	48 89 ca             	mov    %rcx,%rdx
  180e81:	89 55 fc             	mov    %edx,-0x4(%rbp)
        for (; pos != 80; pos++) {
  180e84:	eb 25                	jmp    180eab <console_putc+0xb0>
            *cp->cursor++ = ' ' | color;
  180e86:	8b 45 e0             	mov    -0x20(%rbp),%eax
  180e89:	83 c8 20             	or     $0x20,%eax
  180e8c:	89 c6                	mov    %eax,%esi
  180e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  180e92:	48 8b 40 08          	mov    0x8(%rax),%rax
  180e96:	48 8d 48 02          	lea    0x2(%rax),%rcx
  180e9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  180e9e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  180ea2:	89 f2                	mov    %esi,%edx
  180ea4:	66 89 10             	mov    %dx,(%rax)
        for (; pos != 80; pos++) {
  180ea7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  180eab:	83 7d fc 50          	cmpl   $0x50,-0x4(%rbp)
  180eaf:	75 d5                	jne    180e86 <console_putc+0x8b>
        }
    } else {
        *cp->cursor++ = c | color;
    }
}
  180eb1:	eb 24                	jmp    180ed7 <console_putc+0xdc>
        *cp->cursor++ = c | color;
  180eb3:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
  180eb7:	8b 55 e0             	mov    -0x20(%rbp),%edx
  180eba:	09 d0                	or     %edx,%eax
  180ebc:	89 c6                	mov    %eax,%esi
  180ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  180ec2:	48 8b 40 08          	mov    0x8(%rax),%rax
  180ec6:	48 8d 48 02          	lea    0x2(%rax),%rcx
  180eca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  180ece:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  180ed2:	89 f2                	mov    %esi,%edx
  180ed4:	66 89 10             	mov    %dx,(%rax)
}
  180ed7:	90                   	nop
  180ed8:	c9                   	leave
  180ed9:	c3                   	ret

0000000000180eda <console_vprintf>:

int console_vprintf(int cpos, int color, const char* format, va_list val) {
  180eda:	55                   	push   %rbp
  180edb:	48 89 e5             	mov    %rsp,%rbp
  180ede:	48 83 ec 30          	sub    $0x30,%rsp
  180ee2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  180ee5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  180ee8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  180eec:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
    struct console_printer cp;
    cp.p.putc = console_putc;
  180ef0:	48 c7 45 f0 fb 0d 18 	movq   $0x180dfb,-0x10(%rbp)
  180ef7:	00 
    if (cpos < 0 || cpos >= CONSOLE_ROWS * CONSOLE_COLUMNS) {
  180ef8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  180efc:	78 09                	js     180f07 <console_vprintf+0x2d>
  180efe:	81 7d ec cf 07 00 00 	cmpl   $0x7cf,-0x14(%rbp)
  180f05:	7e 07                	jle    180f0e <console_vprintf+0x34>
        cpos = 0;
  180f07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
    cp.cursor = console + cpos;
  180f0e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  180f11:	48 98                	cltq
  180f13:	48 01 c0             	add    %rax,%rax
  180f16:	48 05 00 80 0b 00    	add    $0xb8000,%rax
  180f1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  180f20:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  180f24:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  180f28:	8b 75 e8             	mov    -0x18(%rbp),%esi
  180f2b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  180f2f:	48 89 c7             	mov    %rax,%rdi
  180f32:	e8 f4 f4 ff ff       	call   18042b <printer_vprintf>
    return cp.cursor - console;
  180f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  180f3b:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  180f41:	48 d1 f8             	sar    %rax
}
  180f44:	c9                   	leave
  180f45:	c3                   	ret

0000000000180f46 <console_printf>:

int console_printf(int cpos, int color, const char* format, ...) {
  180f46:	55                   	push   %rbp
  180f47:	48 89 e5             	mov    %rsp,%rbp
  180f4a:	48 83 ec 60          	sub    $0x60,%rsp
  180f4e:	89 7d ac             	mov    %edi,-0x54(%rbp)
  180f51:	89 75 a8             	mov    %esi,-0x58(%rbp)
  180f54:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  180f58:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  180f5c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  180f60:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  180f64:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  180f6b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  180f6f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  180f73:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  180f77:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  180f7b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  180f7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  180f83:	8b 75 a8             	mov    -0x58(%rbp),%esi
  180f86:	8b 45 ac             	mov    -0x54(%rbp),%eax
  180f89:	89 c7                	mov    %eax,%edi
  180f8b:	e8 4a ff ff ff       	call   180eda <console_vprintf>
  180f90:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
  180f93:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
  180f96:	c9                   	leave
  180f97:	c3                   	ret

0000000000180f98 <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  180f98:	55                   	push   %rbp
  180f99:	48 89 e5             	mov    %rsp,%rbp
  180f9c:	48 83 ec 20          	sub    $0x20,%rsp
  180fa0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  180fa4:	89 f0                	mov    %esi,%eax
  180fa6:	89 55 e0             	mov    %edx,-0x20(%rbp)
  180fa9:	88 45 e4             	mov    %al,-0x1c(%rbp)
    string_printer* sp = (string_printer*) p;
  180fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  180fb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (sp->s < sp->end) {
  180fb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  180fb8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  180fbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  180fc0:	48 8b 40 10          	mov    0x10(%rax),%rax
  180fc4:	48 39 c2             	cmp    %rax,%rdx
  180fc7:	73 1a                	jae    180fe3 <string_putc+0x4b>
        *sp->s++ = c;
  180fc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  180fcd:	48 8b 40 08          	mov    0x8(%rax),%rax
  180fd1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  180fd5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  180fd9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  180fdd:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
  180fe1:	88 10                	mov    %dl,(%rax)
    }
    (void) color;
}
  180fe3:	90                   	nop
  180fe4:	c9                   	leave
  180fe5:	c3                   	ret

0000000000180fe6 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  180fe6:	55                   	push   %rbp
  180fe7:	48 89 e5             	mov    %rsp,%rbp
  180fea:	48 83 ec 40          	sub    $0x40,%rsp
  180fee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  180ff2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  180ff6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  180ffa:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    string_printer sp;
    sp.p.putc = string_putc;
  180ffe:	48 c7 45 e8 98 0f 18 	movq   $0x180f98,-0x18(%rbp)
  181005:	00 
    sp.s = s;
  181006:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  18100a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (size) {
  18100e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  181013:	74 33                	je     181048 <vsnprintf+0x62>
        sp.end = s + size - 1;
  181015:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  181019:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  18101d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  181021:	48 01 d0             	add    %rdx,%rax
  181024:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  181028:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  18102c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  181030:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  181034:	be 00 00 00 00       	mov    $0x0,%esi
  181039:	48 89 c7             	mov    %rax,%rdi
  18103c:	e8 ea f3 ff ff       	call   18042b <printer_vprintf>
        *sp.s = 0;
  181041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  181045:	c6 00 00             	movb   $0x0,(%rax)
    }
    return sp.s - s;
  181048:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  18104c:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
}
  181050:	c9                   	leave
  181051:	c3                   	ret

0000000000181052 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  181052:	55                   	push   %rbp
  181053:	48 89 e5             	mov    %rsp,%rbp
  181056:	48 83 ec 70          	sub    $0x70,%rsp
  18105a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  18105e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  181062:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  181066:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  18106a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  18106e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  181072:	c7 45 b0 18 00 00 00 	movl   $0x18,-0x50(%rbp)
  181079:	48 8d 45 10          	lea    0x10(%rbp),%rax
  18107d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  181081:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  181085:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    int n = vsnprintf(s, size, format, val);
  181089:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  18108d:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  181091:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  181095:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  181099:	48 89 c7             	mov    %rax,%rdi
  18109c:	e8 45 ff ff ff       	call   180fe6 <vsnprintf>
  1810a1:	89 45 cc             	mov    %eax,-0x34(%rbp)
    va_end(val);
    return n;
  1810a4:	8b 45 cc             	mov    -0x34(%rbp),%eax
}
  1810a7:	c9                   	leave
  1810a8:	c3                   	ret

00000000001810a9 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  1810a9:	55                   	push   %rbp
  1810aa:	48 89 e5             	mov    %rsp,%rbp
  1810ad:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1810b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  1810b8:	eb 13                	jmp    1810cd <console_clear+0x24>
        console[i] = ' ' | 0x0700;
  1810ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  1810bd:	48 98                	cltq
  1810bf:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%rax,%rax,1)
  1810c6:	00 20 07 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1810c9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  1810cd:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
  1810d4:	7e e4                	jle    1810ba <console_clear+0x11>
    }
    cursorpos = 0;
  1810d6:	c7 05 1c 7f f3 ff 00 	movl   $0x0,-0xc80e4(%rip)        # b8ffc <cursorpos>
  1810dd:	00 00 00 
}
  1810e0:	90                   	nop
  1810e1:	c9                   	leave
  1810e2:	c3                   	ret
