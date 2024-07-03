
obj/p-allocator.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:
uint8_t* stack_bottom;

// Program that starts allocating page by page from its heap
// till it reaches stack OR runs out of memory

void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	53                   	push   %rbx
  100005:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  100009:	cd 31                	int    $0x31
  10000b:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  10000d:	89 c7                	mov    %eax,%edi
  10000f:	e8 74 03 00 00       	call   100388 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  100014:	b8 17 30 10 00       	mov    $0x103017,%eax
  100019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10001f:	48 89 05 e2 1f 00 00 	mov    %rax,0x1fe2(%rip)        # 102008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  100026:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  100029:	48 83 e8 01          	sub    $0x1,%rax
  10002d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100033:	48 89 05 c6 1f 00 00 	mov    %rax,0x1fc6(%rip)        # 102000 <stack_bottom>
  10003a:	eb 02                	jmp    10003e <process_main+0x3e>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  10003c:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  10003e:	e8 09 03 00 00       	call   10034c <rand>
  100043:	48 63 d0             	movslq %eax,%rdx
  100046:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  10004d:	48 c1 fa 25          	sar    $0x25,%rdx
  100051:	89 c1                	mov    %eax,%ecx
  100053:	c1 f9 1f             	sar    $0x1f,%ecx
  100056:	29 ca                	sub    %ecx,%edx
  100058:	6b d2 64             	imul   $0x64,%edx,%edx
  10005b:	29 d0                	sub    %edx,%eax
  10005d:	39 d8                	cmp    %ebx,%eax
  10005f:	7d db                	jge    10003c <process_main+0x3c>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  100061:	48 8b 3d a0 1f 00 00 	mov    0x1fa0(%rip),%rdi        # 102008 <heap_top>
  100068:	48 3b 3d 91 1f 00 00 	cmp    0x1f91(%rip),%rdi        # 102000 <stack_bottom>
  10006f:	74 1c                	je     10008d <process_main+0x8d>
//    Allocate a page of memory at address `addr` and allow process to
//    write to it. `Addr` must be page-aligned (i.e., a multiple of
//    PAGESIZE == 4096). Returns 0 on success and -1 on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  100071:	cd 33                	int    $0x33
  100073:	85 c0                	test   %eax,%eax
  100075:	78 16                	js     10008d <process_main+0x8d>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  100077:	48 8b 05 8a 1f 00 00 	mov    0x1f8a(%rip),%rax        # 102008 <heap_top>
  10007e:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  100080:	48 81 05 7d 1f 00 00 	addq   $0x1000,0x1f7d(%rip)        # 102008 <heap_top>
  100087:	00 10 00 00 
  10008b:	eb af                	jmp    10003c <process_main+0x3c>
    asm volatile ("int %0" : /* no result */
  10008d:	cd 32                	int    $0x32
        }
        sys_yield();
    }

    // After running out of memory, do nothing forever
    while (1) {
  10008f:	eb fc                	jmp    10008d <process_main+0x8d>

0000000000100091 <memcpy>:


// memcpy, memmove, memset, strcmp, strlen, strnlen
//    We must provide our own implementations.

void* memcpy(void* dst, const void* src, size_t n) {
  100091:	55                   	push   %rbp
  100092:	48 89 e5             	mov    %rsp,%rbp
  100095:	48 83 ec 28          	sub    $0x28,%rsp
  100099:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  10009d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1000a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1000a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1000a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1000ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1000b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  1000b5:	eb 1c                	jmp    1000d3 <memcpy+0x42>
        *d = *s;
  1000b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1000bb:	0f b6 10             	movzbl (%rax),%edx
  1000be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1000c2:	88 10                	mov    %dl,(%rax)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1000c4:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  1000c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1000ce:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  1000d3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1000d8:	75 dd                	jne    1000b7 <memcpy+0x26>
    }
    return dst;
  1000da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1000de:	c9                   	leave
  1000df:	c3                   	ret

00000000001000e0 <memmove>:

void* memmove(void* dst, const void* src, size_t n) {
  1000e0:	55                   	push   %rbp
  1000e1:	48 89 e5             	mov    %rsp,%rbp
  1000e4:	48 83 ec 28          	sub    $0x28,%rsp
  1000e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1000ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1000f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1000f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1000f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    char* d = (char*) dst;
  1000fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100100:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (s < d && s + n > d) {
  100104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100108:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  10010c:	73 6a                	jae    100178 <memmove+0x98>
  10010e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  100112:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  100116:	48 01 d0             	add    %rdx,%rax
  100119:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
  10011d:	73 59                	jae    100178 <memmove+0x98>
        s += n, d += n;
  10011f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  100123:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  100127:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  10012b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        while (n-- > 0) {
  10012f:	eb 17                	jmp    100148 <memmove+0x68>
            *--d = *--s;
  100131:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  100136:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
  10013b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10013f:	0f b6 10             	movzbl (%rax),%edx
  100142:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100146:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  100148:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  10014c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  100150:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  100154:	48 85 c0             	test   %rax,%rax
  100157:	75 d8                	jne    100131 <memmove+0x51>
    if (s < d && s + n > d) {
  100159:	eb 2e                	jmp    100189 <memmove+0xa9>
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
  10015b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  10015f:	48 8d 42 01          	lea    0x1(%rdx),%rax
  100163:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  100167:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10016b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  10016f:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  100173:	0f b6 12             	movzbl (%rdx),%edx
  100176:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  100178:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  10017c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  100180:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  100184:	48 85 c0             	test   %rax,%rax
  100187:	75 d2                	jne    10015b <memmove+0x7b>
        }
    }
    return dst;
  100189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  10018d:	c9                   	leave
  10018e:	c3                   	ret

000000000010018f <memset>:

void* memset(void* v, int c, size_t n) {
  10018f:	55                   	push   %rbp
  100190:	48 89 e5             	mov    %rsp,%rbp
  100193:	48 83 ec 28          	sub    $0x28,%rsp
  100197:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  10019b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  10019e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1001a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1001a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  1001aa:	eb 15                	jmp    1001c1 <memset+0x32>
        *p = c;
  1001ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1001af:	89 c2                	mov    %eax,%edx
  1001b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1001b5:	88 10                	mov    %dl,(%rax)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1001b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1001bc:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  1001c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1001c6:	75 e4                	jne    1001ac <memset+0x1d>
    }
    return v;
  1001c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1001cc:	c9                   	leave
  1001cd:	c3                   	ret

00000000001001ce <strlen>:

size_t strlen(const char* s) {
  1001ce:	55                   	push   %rbp
  1001cf:	48 89 e5             	mov    %rsp,%rbp
  1001d2:	48 83 ec 18          	sub    $0x18,%rsp
  1001d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
  1001da:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  1001e1:	00 
  1001e2:	eb 0a                	jmp    1001ee <strlen+0x20>
        ++n;
  1001e4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; *s != '\0'; ++s) {
  1001e9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  1001ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1001f2:	0f b6 00             	movzbl (%rax),%eax
  1001f5:	84 c0                	test   %al,%al
  1001f7:	75 eb                	jne    1001e4 <strlen+0x16>
    }
    return n;
  1001f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  1001fd:	c9                   	leave
  1001fe:	c3                   	ret

00000000001001ff <strnlen>:

size_t strnlen(const char* s, size_t maxlen) {
  1001ff:	55                   	push   %rbp
  100200:	48 89 e5             	mov    %rsp,%rbp
  100203:	48 83 ec 20          	sub    $0x20,%rsp
  100207:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  10020b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    size_t n;
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  10020f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  100216:	00 
  100217:	eb 0a                	jmp    100223 <strnlen+0x24>
        ++n;
  100219:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  10021e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  100223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100227:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  10022b:	74 0b                	je     100238 <strnlen+0x39>
  10022d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100231:	0f b6 00             	movzbl (%rax),%eax
  100234:	84 c0                	test   %al,%al
  100236:	75 e1                	jne    100219 <strnlen+0x1a>
    }
    return n;
  100238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  10023c:	c9                   	leave
  10023d:	c3                   	ret

000000000010023e <strcpy>:

char* strcpy(char* dst, const char* src) {
  10023e:	55                   	push   %rbp
  10023f:	48 89 e5             	mov    %rsp,%rbp
  100242:	48 83 ec 20          	sub    $0x20,%rsp
  100246:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  10024a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    char* d = dst;
  10024e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100252:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    do {
        *d++ = *src++;
  100256:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  10025a:	48 8d 42 01          	lea    0x1(%rdx),%rax
  10025e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  100262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100266:	48 8d 48 01          	lea    0x1(%rax),%rcx
  10026a:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
  10026e:	0f b6 12             	movzbl (%rdx),%edx
  100271:	88 10                	mov    %dl,(%rax)
    } while (d[-1]);
  100273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100277:	48 83 e8 01          	sub    $0x1,%rax
  10027b:	0f b6 00             	movzbl (%rax),%eax
  10027e:	84 c0                	test   %al,%al
  100280:	75 d4                	jne    100256 <strcpy+0x18>
    return dst;
  100282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  100286:	c9                   	leave
  100287:	c3                   	ret

0000000000100288 <strcmp>:

int strcmp(const char* a, const char* b) {
  100288:	55                   	push   %rbp
  100289:	48 89 e5             	mov    %rsp,%rbp
  10028c:	48 83 ec 10          	sub    $0x10,%rsp
  100290:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  100294:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  100298:	eb 0a                	jmp    1002a4 <strcmp+0x1c>
        ++a, ++b;
  10029a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  10029f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  1002a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1002a8:	0f b6 00             	movzbl (%rax),%eax
  1002ab:	84 c0                	test   %al,%al
  1002ad:	74 1d                	je     1002cc <strcmp+0x44>
  1002af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1002b3:	0f b6 00             	movzbl (%rax),%eax
  1002b6:	84 c0                	test   %al,%al
  1002b8:	74 12                	je     1002cc <strcmp+0x44>
  1002ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1002be:	0f b6 10             	movzbl (%rax),%edx
  1002c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1002c5:	0f b6 00             	movzbl (%rax),%eax
  1002c8:	38 c2                	cmp    %al,%dl
  1002ca:	74 ce                	je     10029a <strcmp+0x12>
    }
    return ((unsigned char) *a > (unsigned char) *b)
  1002cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1002d0:	0f b6 00             	movzbl (%rax),%eax
  1002d3:	89 c2                	mov    %eax,%edx
  1002d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1002d9:	0f b6 00             	movzbl (%rax),%eax
  1002dc:	38 d0                	cmp    %dl,%al
  1002de:	0f 92 c0             	setb   %al
  1002e1:	0f b6 d0             	movzbl %al,%edx
        - ((unsigned char) *a < (unsigned char) *b);
  1002e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1002e8:	0f b6 00             	movzbl (%rax),%eax
  1002eb:	89 c1                	mov    %eax,%ecx
  1002ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1002f1:	0f b6 00             	movzbl (%rax),%eax
  1002f4:	38 c1                	cmp    %al,%cl
  1002f6:	0f 92 c0             	setb   %al
  1002f9:	0f b6 c0             	movzbl %al,%eax
  1002fc:	29 c2                	sub    %eax,%edx
  1002fe:	89 d0                	mov    %edx,%eax
}
  100300:	c9                   	leave
  100301:	c3                   	ret

0000000000100302 <strchr>:

char* strchr(const char* s, int c) {
  100302:	55                   	push   %rbp
  100303:	48 89 e5             	mov    %rsp,%rbp
  100306:	48 83 ec 10          	sub    $0x10,%rsp
  10030a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  10030e:	89 75 f4             	mov    %esi,-0xc(%rbp)
    while (*s && *s != (char) c) {
  100311:	eb 05                	jmp    100318 <strchr+0x16>
        ++s;
  100313:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while (*s && *s != (char) c) {
  100318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10031c:	0f b6 00             	movzbl (%rax),%eax
  10031f:	84 c0                	test   %al,%al
  100321:	74 0e                	je     100331 <strchr+0x2f>
  100323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100327:	0f b6 00             	movzbl (%rax),%eax
  10032a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  10032d:	38 d0                	cmp    %dl,%al
  10032f:	75 e2                	jne    100313 <strchr+0x11>
    }
    if (*s == (char) c) {
  100331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100335:	0f b6 00             	movzbl (%rax),%eax
  100338:	8b 55 f4             	mov    -0xc(%rbp),%edx
  10033b:	38 d0                	cmp    %dl,%al
  10033d:	75 06                	jne    100345 <strchr+0x43>
        return (char*) s;
  10033f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100343:	eb 05                	jmp    10034a <strchr+0x48>
    } else {
        return NULL;
  100345:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
  10034a:	c9                   	leave
  10034b:	c3                   	ret

000000000010034c <rand>:
// rand, srand

static int rand_seed_set;
static unsigned rand_seed;

int rand(void) {
  10034c:	55                   	push   %rbp
  10034d:	48 89 e5             	mov    %rsp,%rbp
    if (!rand_seed_set) {
  100350:	8b 05 ba 1c 00 00    	mov    0x1cba(%rip),%eax        # 102010 <rand_seed_set>
  100356:	85 c0                	test   %eax,%eax
  100358:	75 0a                	jne    100364 <rand+0x18>
        srand(819234718U);
  10035a:	bf 9e 87 d4 30       	mov    $0x30d4879e,%edi
  10035f:	e8 24 00 00 00       	call   100388 <srand>
    }
    rand_seed = rand_seed * 1664525U + 1013904223U;
  100364:	8b 05 aa 1c 00 00    	mov    0x1caa(%rip),%eax        # 102014 <rand_seed>
  10036a:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
  100370:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  100375:	89 05 99 1c 00 00    	mov    %eax,0x1c99(%rip)        # 102014 <rand_seed>
    return rand_seed & RAND_MAX;
  10037b:	8b 05 93 1c 00 00    	mov    0x1c93(%rip),%eax        # 102014 <rand_seed>
  100381:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  100386:	5d                   	pop    %rbp
  100387:	c3                   	ret

0000000000100388 <srand>:

void srand(unsigned seed) {
  100388:	55                   	push   %rbp
  100389:	48 89 e5             	mov    %rsp,%rbp
  10038c:	48 83 ec 08          	sub    $0x8,%rsp
  100390:	89 7d fc             	mov    %edi,-0x4(%rbp)
    rand_seed = seed;
  100393:	8b 45 fc             	mov    -0x4(%rbp),%eax
  100396:	89 05 78 1c 00 00    	mov    %eax,0x1c78(%rip)        # 102014 <rand_seed>
    rand_seed_set = 1;
  10039c:	c7 05 6a 1c 00 00 01 	movl   $0x1,0x1c6a(%rip)        # 102010 <rand_seed_set>
  1003a3:	00 00 00 
}
  1003a6:	90                   	nop
  1003a7:	c9                   	leave
  1003a8:	c3                   	ret

00000000001003a9 <fill_numbuf>:
//    Print a message onto the console, starting at the given cursor position.

// snprintf, vsnprintf
//    Format a string into a buffer.

static char* fill_numbuf(char* numbuf_end, unsigned long val, int base) {
  1003a9:	55                   	push   %rbp
  1003aa:	48 89 e5             	mov    %rsp,%rbp
  1003ad:	48 83 ec 28          	sub    $0x28,%rsp
  1003b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1003b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1003b9:	89 55 dc             	mov    %edx,-0x24(%rbp)
    static const char upper_digits[] = "0123456789ABCDEF";
    static const char lower_digits[] = "0123456789abcdef";

    const char* digits = upper_digits;
  1003bc:	48 c7 45 f8 d0 12 10 	movq   $0x1012d0,-0x8(%rbp)
  1003c3:	00 
    if (base < 0) {
  1003c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  1003c8:	79 0b                	jns    1003d5 <fill_numbuf+0x2c>
        digits = lower_digits;
  1003ca:	48 c7 45 f8 f0 12 10 	movq   $0x1012f0,-0x8(%rbp)
  1003d1:	00 
        base = -base;
  1003d2:	f7 5d dc             	negl   -0x24(%rbp)
    }

    *--numbuf_end = '\0';
  1003d5:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  1003da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1003de:	c6 00 00             	movb   $0x0,(%rax)
    do {
        *--numbuf_end = digits[val % base];
  1003e1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  1003e4:	48 63 c8             	movslq %eax,%rcx
  1003e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1003eb:	ba 00 00 00 00       	mov    $0x0,%edx
  1003f0:	48 f7 f1             	div    %rcx
  1003f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1003f7:	48 01 d0             	add    %rdx,%rax
  1003fa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  1003ff:	0f b6 10             	movzbl (%rax),%edx
  100402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100406:	88 10                	mov    %dl,(%rax)
        val /= base;
  100408:	8b 45 dc             	mov    -0x24(%rbp),%eax
  10040b:	48 63 f0             	movslq %eax,%rsi
  10040e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100412:	ba 00 00 00 00       	mov    $0x0,%edx
  100417:	48 f7 f6             	div    %rsi
  10041a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    } while (val != 0);
  10041e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  100423:	75 bc                	jne    1003e1 <fill_numbuf+0x38>
    return numbuf_end;
  100425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  100429:	c9                   	leave
  10042a:	c3                   	ret

000000000010042b <printer_vprintf>:
#define FLAG_NUMERIC            (1<<5)
#define FLAG_SIGNED             (1<<6)
#define FLAG_NEGATIVE           (1<<7)
#define FLAG_ALT2               (1<<8)

void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  10042b:	55                   	push   %rbp
  10042c:	48 89 e5             	mov    %rsp,%rbp
  10042f:	53                   	push   %rbx
  100430:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  100437:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
  10043e:	89 b5 74 ff ff ff    	mov    %esi,-0x8c(%rbp)
  100444:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  10044b:	48 89 8d 60 ff ff ff 	mov    %rcx,-0xa0(%rbp)
#define NUMBUFSIZ 24
    char numbuf[NUMBUFSIZ];

    for (; *format; ++format) {
  100452:	e9 8a 09 00 00       	jmp    100de1 <printer_vprintf+0x9b6>
        if (*format != '%') {
  100457:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10045e:	0f b6 00             	movzbl (%rax),%eax
  100461:	3c 25                	cmp    $0x25,%al
  100463:	74 31                	je     100496 <printer_vprintf+0x6b>
            p->putc(p, *format, color);
  100465:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  10046c:	4c 8b 00             	mov    (%rax),%r8
  10046f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100476:	0f b6 00             	movzbl (%rax),%eax
  100479:	0f b6 c8             	movzbl %al,%ecx
  10047c:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100482:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100489:	89 ce                	mov    %ecx,%esi
  10048b:	48 89 c7             	mov    %rax,%rdi
  10048e:	41 ff d0             	call   *%r8
            continue;
  100491:	e9 43 09 00 00       	jmp    100dd9 <printer_vprintf+0x9ae>
        }

        // process flags
        int flags = 0;
  100496:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        for (++format; *format; ++format) {
  10049d:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1004a4:	01 
  1004a5:	eb 44                	jmp    1004eb <printer_vprintf+0xc0>
            const char* flagc = strchr(flag_chars, *format);
  1004a7:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1004ae:	0f b6 00             	movzbl (%rax),%eax
  1004b1:	0f be c0             	movsbl %al,%eax
  1004b4:	89 c6                	mov    %eax,%esi
  1004b6:	bf f0 10 10 00       	mov    $0x1010f0,%edi
  1004bb:	e8 42 fe ff ff       	call   100302 <strchr>
  1004c0:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (flagc) {
  1004c4:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  1004c9:	74 30                	je     1004fb <printer_vprintf+0xd0>
                flags |= 1 << (flagc - flag_chars);
  1004cb:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  1004cf:	48 2d f0 10 10 00    	sub    $0x1010f0,%rax
  1004d5:	ba 01 00 00 00       	mov    $0x1,%edx
  1004da:	89 c1                	mov    %eax,%ecx
  1004dc:	d3 e2                	shl    %cl,%edx
  1004de:	89 d0                	mov    %edx,%eax
  1004e0:	09 45 ec             	or     %eax,-0x14(%rbp)
        for (++format; *format; ++format) {
  1004e3:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1004ea:	01 
  1004eb:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1004f2:	0f b6 00             	movzbl (%rax),%eax
  1004f5:	84 c0                	test   %al,%al
  1004f7:	75 ae                	jne    1004a7 <printer_vprintf+0x7c>
  1004f9:	eb 01                	jmp    1004fc <printer_vprintf+0xd1>
            } else {
                break;
  1004fb:	90                   	nop
            }
        }

        // process width
        int width = -1;
  1004fc:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
        if (*format >= '1' && *format <= '9') {
  100503:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10050a:	0f b6 00             	movzbl (%rax),%eax
  10050d:	3c 30                	cmp    $0x30,%al
  10050f:	7e 67                	jle    100578 <printer_vprintf+0x14d>
  100511:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100518:	0f b6 00             	movzbl (%rax),%eax
  10051b:	3c 39                	cmp    $0x39,%al
  10051d:	7f 59                	jg     100578 <printer_vprintf+0x14d>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  10051f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  100526:	eb 2e                	jmp    100556 <printer_vprintf+0x12b>
                width = 10 * width + *format++ - '0';
  100528:	8b 55 e8             	mov    -0x18(%rbp),%edx
  10052b:	89 d0                	mov    %edx,%eax
  10052d:	c1 e0 02             	shl    $0x2,%eax
  100530:	01 d0                	add    %edx,%eax
  100532:	01 c0                	add    %eax,%eax
  100534:	89 c1                	mov    %eax,%ecx
  100536:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10053d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  100541:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  100548:	0f b6 00             	movzbl (%rax),%eax
  10054b:	0f be c0             	movsbl %al,%eax
  10054e:	01 c8                	add    %ecx,%eax
  100550:	83 e8 30             	sub    $0x30,%eax
  100553:	89 45 e8             	mov    %eax,-0x18(%rbp)
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100556:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10055d:	0f b6 00             	movzbl (%rax),%eax
  100560:	3c 2f                	cmp    $0x2f,%al
  100562:	0f 8e 85 00 00 00    	jle    1005ed <printer_vprintf+0x1c2>
  100568:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10056f:	0f b6 00             	movzbl (%rax),%eax
  100572:	3c 39                	cmp    $0x39,%al
  100574:	7e b2                	jle    100528 <printer_vprintf+0xfd>
        if (*format >= '1' && *format <= '9') {
  100576:	eb 75                	jmp    1005ed <printer_vprintf+0x1c2>
            }
        } else if (*format == '*') {
  100578:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10057f:	0f b6 00             	movzbl (%rax),%eax
  100582:	3c 2a                	cmp    $0x2a,%al
  100584:	75 68                	jne    1005ee <printer_vprintf+0x1c3>
            width = va_arg(val, int);
  100586:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10058d:	8b 00                	mov    (%rax),%eax
  10058f:	83 f8 2f             	cmp    $0x2f,%eax
  100592:	77 30                	ja     1005c4 <printer_vprintf+0x199>
  100594:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10059b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  10059f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1005a6:	8b 00                	mov    (%rax),%eax
  1005a8:	89 c0                	mov    %eax,%eax
  1005aa:	48 01 d0             	add    %rdx,%rax
  1005ad:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1005b4:	8b 12                	mov    (%rdx),%edx
  1005b6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1005b9:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1005c0:	89 0a                	mov    %ecx,(%rdx)
  1005c2:	eb 1a                	jmp    1005de <printer_vprintf+0x1b3>
  1005c4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1005cb:	48 8b 40 08          	mov    0x8(%rax),%rax
  1005cf:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1005d3:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1005da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1005de:	8b 00                	mov    (%rax),%eax
  1005e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
            ++format;
  1005e3:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1005ea:	01 
  1005eb:	eb 01                	jmp    1005ee <printer_vprintf+0x1c3>
        if (*format >= '1' && *format <= '9') {
  1005ed:	90                   	nop
        }

        // process precision
        int precision = -1;
  1005ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
        if (*format == '.') {
  1005f5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1005fc:	0f b6 00             	movzbl (%rax),%eax
  1005ff:	3c 2e                	cmp    $0x2e,%al
  100601:	0f 85 00 01 00 00    	jne    100707 <printer_vprintf+0x2dc>
            ++format;
  100607:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  10060e:	01 
            if (*format >= '0' && *format <= '9') {
  10060f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100616:	0f b6 00             	movzbl (%rax),%eax
  100619:	3c 2f                	cmp    $0x2f,%al
  10061b:	7e 67                	jle    100684 <printer_vprintf+0x259>
  10061d:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100624:	0f b6 00             	movzbl (%rax),%eax
  100627:	3c 39                	cmp    $0x39,%al
  100629:	7f 59                	jg     100684 <printer_vprintf+0x259>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  10062b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  100632:	eb 2e                	jmp    100662 <printer_vprintf+0x237>
                    precision = 10 * precision + *format++ - '0';
  100634:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  100637:	89 d0                	mov    %edx,%eax
  100639:	c1 e0 02             	shl    $0x2,%eax
  10063c:	01 d0                	add    %edx,%eax
  10063e:	01 c0                	add    %eax,%eax
  100640:	89 c1                	mov    %eax,%ecx
  100642:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100649:	48 8d 50 01          	lea    0x1(%rax),%rdx
  10064d:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  100654:	0f b6 00             	movzbl (%rax),%eax
  100657:	0f be c0             	movsbl %al,%eax
  10065a:	01 c8                	add    %ecx,%eax
  10065c:	83 e8 30             	sub    $0x30,%eax
  10065f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100662:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100669:	0f b6 00             	movzbl (%rax),%eax
  10066c:	3c 2f                	cmp    $0x2f,%al
  10066e:	0f 8e 85 00 00 00    	jle    1006f9 <printer_vprintf+0x2ce>
  100674:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10067b:	0f b6 00             	movzbl (%rax),%eax
  10067e:	3c 39                	cmp    $0x39,%al
  100680:	7e b2                	jle    100634 <printer_vprintf+0x209>
            if (*format >= '0' && *format <= '9') {
  100682:	eb 75                	jmp    1006f9 <printer_vprintf+0x2ce>
                }
            } else if (*format == '*') {
  100684:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10068b:	0f b6 00             	movzbl (%rax),%eax
  10068e:	3c 2a                	cmp    $0x2a,%al
  100690:	75 68                	jne    1006fa <printer_vprintf+0x2cf>
                precision = va_arg(val, int);
  100692:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100699:	8b 00                	mov    (%rax),%eax
  10069b:	83 f8 2f             	cmp    $0x2f,%eax
  10069e:	77 30                	ja     1006d0 <printer_vprintf+0x2a5>
  1006a0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1006a7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1006ab:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1006b2:	8b 00                	mov    (%rax),%eax
  1006b4:	89 c0                	mov    %eax,%eax
  1006b6:	48 01 d0             	add    %rdx,%rax
  1006b9:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1006c0:	8b 12                	mov    (%rdx),%edx
  1006c2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1006c5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1006cc:	89 0a                	mov    %ecx,(%rdx)
  1006ce:	eb 1a                	jmp    1006ea <printer_vprintf+0x2bf>
  1006d0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1006d7:	48 8b 40 08          	mov    0x8(%rax),%rax
  1006db:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1006df:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1006e6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1006ea:	8b 00                	mov    (%rax),%eax
  1006ec:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                ++format;
  1006ef:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1006f6:	01 
  1006f7:	eb 01                	jmp    1006fa <printer_vprintf+0x2cf>
            if (*format >= '0' && *format <= '9') {
  1006f9:	90                   	nop
            }
            if (precision < 0) {
  1006fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  1006fe:	79 07                	jns    100707 <printer_vprintf+0x2dc>
                precision = 0;
  100700:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
            }
        }

        // process main conversion character
        int base = 10;
  100707:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%rbp)
        unsigned long num = 0;
  10070e:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  100715:	00 
        int length = 0;
  100716:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
        char* data = "";
  10071d:	48 c7 45 c8 f6 10 10 	movq   $0x1010f6,-0x38(%rbp)
  100724:	00 
    again:
        switch (*format) {
  100725:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10072c:	0f b6 00             	movzbl (%rax),%eax
  10072f:	0f be c0             	movsbl %al,%eax
  100732:	83 e8 43             	sub    $0x43,%eax
  100735:	83 f8 37             	cmp    $0x37,%eax
  100738:	0f 87 9f 03 00 00    	ja     100add <printer_vprintf+0x6b2>
  10073e:	89 c0                	mov    %eax,%eax
  100740:	48 8b 04 c5 08 11 10 	mov    0x101108(,%rax,8),%rax
  100747:	00 
  100748:	ff e0                	jmp    *%rax
        case 'l':
        case 'z':
            length = 1;
  10074a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
            ++format;
  100751:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100758:	01 
            goto again;
  100759:	eb ca                	jmp    100725 <printer_vprintf+0x2fa>
        case 'd':
        case 'i': {
            long x = length ? va_arg(val, long) : va_arg(val, int);
  10075b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  10075f:	74 5d                	je     1007be <printer_vprintf+0x393>
  100761:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100768:	8b 00                	mov    (%rax),%eax
  10076a:	83 f8 2f             	cmp    $0x2f,%eax
  10076d:	77 30                	ja     10079f <printer_vprintf+0x374>
  10076f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100776:	48 8b 50 10          	mov    0x10(%rax),%rdx
  10077a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100781:	8b 00                	mov    (%rax),%eax
  100783:	89 c0                	mov    %eax,%eax
  100785:	48 01 d0             	add    %rdx,%rax
  100788:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10078f:	8b 12                	mov    (%rdx),%edx
  100791:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100794:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10079b:	89 0a                	mov    %ecx,(%rdx)
  10079d:	eb 1a                	jmp    1007b9 <printer_vprintf+0x38e>
  10079f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1007a6:	48 8b 40 08          	mov    0x8(%rax),%rax
  1007aa:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1007ae:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1007b5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1007b9:	48 8b 00             	mov    (%rax),%rax
  1007bc:	eb 5c                	jmp    10081a <printer_vprintf+0x3ef>
  1007be:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1007c5:	8b 00                	mov    (%rax),%eax
  1007c7:	83 f8 2f             	cmp    $0x2f,%eax
  1007ca:	77 30                	ja     1007fc <printer_vprintf+0x3d1>
  1007cc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1007d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1007d7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1007de:	8b 00                	mov    (%rax),%eax
  1007e0:	89 c0                	mov    %eax,%eax
  1007e2:	48 01 d0             	add    %rdx,%rax
  1007e5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1007ec:	8b 12                	mov    (%rdx),%edx
  1007ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1007f1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1007f8:	89 0a                	mov    %ecx,(%rdx)
  1007fa:	eb 1a                	jmp    100816 <printer_vprintf+0x3eb>
  1007fc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100803:	48 8b 40 08          	mov    0x8(%rax),%rax
  100807:	48 8d 48 08          	lea    0x8(%rax),%rcx
  10080b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100812:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100816:	8b 00                	mov    (%rax),%eax
  100818:	48 98                	cltq
  10081a:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  10081e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100822:	48 c1 f8 38          	sar    $0x38,%rax
  100826:	25 80 00 00 00       	and    $0x80,%eax
  10082b:	89 45 a4             	mov    %eax,-0x5c(%rbp)
            num = negative ? -x : x;
  10082e:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  100832:	74 09                	je     10083d <printer_vprintf+0x412>
  100834:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100838:	48 f7 d8             	neg    %rax
  10083b:	eb 04                	jmp    100841 <printer_vprintf+0x416>
  10083d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100841:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  100845:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  100848:	83 c8 60             	or     $0x60,%eax
  10084b:	09 45 ec             	or     %eax,-0x14(%rbp)
            break;
  10084e:	e9 cf 02 00 00       	jmp    100b22 <printer_vprintf+0x6f7>
        }
        case 'u':
        format_unsigned:
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100853:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  100857:	74 5d                	je     1008b6 <printer_vprintf+0x48b>
  100859:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100860:	8b 00                	mov    (%rax),%eax
  100862:	83 f8 2f             	cmp    $0x2f,%eax
  100865:	77 30                	ja     100897 <printer_vprintf+0x46c>
  100867:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10086e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100872:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100879:	8b 00                	mov    (%rax),%eax
  10087b:	89 c0                	mov    %eax,%eax
  10087d:	48 01 d0             	add    %rdx,%rax
  100880:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100887:	8b 12                	mov    (%rdx),%edx
  100889:	8d 4a 08             	lea    0x8(%rdx),%ecx
  10088c:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100893:	89 0a                	mov    %ecx,(%rdx)
  100895:	eb 1a                	jmp    1008b1 <printer_vprintf+0x486>
  100897:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10089e:	48 8b 40 08          	mov    0x8(%rax),%rax
  1008a2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1008a6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1008ad:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1008b1:	48 8b 00             	mov    (%rax),%rax
  1008b4:	eb 5c                	jmp    100912 <printer_vprintf+0x4e7>
  1008b6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008bd:	8b 00                	mov    (%rax),%eax
  1008bf:	83 f8 2f             	cmp    $0x2f,%eax
  1008c2:	77 30                	ja     1008f4 <printer_vprintf+0x4c9>
  1008c4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1008cf:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008d6:	8b 00                	mov    (%rax),%eax
  1008d8:	89 c0                	mov    %eax,%eax
  1008da:	48 01 d0             	add    %rdx,%rax
  1008dd:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1008e4:	8b 12                	mov    (%rdx),%edx
  1008e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1008e9:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1008f0:	89 0a                	mov    %ecx,(%rdx)
  1008f2:	eb 1a                	jmp    10090e <printer_vprintf+0x4e3>
  1008f4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008fb:	48 8b 40 08          	mov    0x8(%rax),%rax
  1008ff:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100903:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10090a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  10090e:	8b 00                	mov    (%rax),%eax
  100910:	89 c0                	mov    %eax,%eax
  100912:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC;
  100916:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
            break;
  10091a:	e9 03 02 00 00       	jmp    100b22 <printer_vprintf+0x6f7>
        case 'x':
            base = -16;
  10091f:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            goto format_unsigned;
  100926:	e9 28 ff ff ff       	jmp    100853 <printer_vprintf+0x428>
        case 'X':
            base = 16;
  10092b:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%rbp)
            goto format_unsigned;
  100932:	e9 1c ff ff ff       	jmp    100853 <printer_vprintf+0x428>
        case 'p':
            num = (uintptr_t) va_arg(val, void*);
  100937:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10093e:	8b 00                	mov    (%rax),%eax
  100940:	83 f8 2f             	cmp    $0x2f,%eax
  100943:	77 30                	ja     100975 <printer_vprintf+0x54a>
  100945:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10094c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100950:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100957:	8b 00                	mov    (%rax),%eax
  100959:	89 c0                	mov    %eax,%eax
  10095b:	48 01 d0             	add    %rdx,%rax
  10095e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100965:	8b 12                	mov    (%rdx),%edx
  100967:	8d 4a 08             	lea    0x8(%rdx),%ecx
  10096a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100971:	89 0a                	mov    %ecx,(%rdx)
  100973:	eb 1a                	jmp    10098f <printer_vprintf+0x564>
  100975:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10097c:	48 8b 40 08          	mov    0x8(%rax),%rax
  100980:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100984:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10098b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  10098f:	48 8b 00             	mov    (%rax),%rax
  100992:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            base = -16;
  100996:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  10099d:	81 4d ec 21 01 00 00 	orl    $0x121,-0x14(%rbp)
            break;
  1009a4:	e9 79 01 00 00       	jmp    100b22 <printer_vprintf+0x6f7>
        case 's':
            data = va_arg(val, char*);
  1009a9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009b0:	8b 00                	mov    (%rax),%eax
  1009b2:	83 f8 2f             	cmp    $0x2f,%eax
  1009b5:	77 30                	ja     1009e7 <printer_vprintf+0x5bc>
  1009b7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009be:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1009c2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009c9:	8b 00                	mov    (%rax),%eax
  1009cb:	89 c0                	mov    %eax,%eax
  1009cd:	48 01 d0             	add    %rdx,%rax
  1009d0:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009d7:	8b 12                	mov    (%rdx),%edx
  1009d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1009dc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009e3:	89 0a                	mov    %ecx,(%rdx)
  1009e5:	eb 1a                	jmp    100a01 <printer_vprintf+0x5d6>
  1009e7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009ee:	48 8b 40 08          	mov    0x8(%rax),%rax
  1009f2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1009f6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009fd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100a01:	48 8b 00             	mov    (%rax),%rax
  100a04:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            break;
  100a08:	e9 15 01 00 00       	jmp    100b22 <printer_vprintf+0x6f7>
        case 'C':
            color = va_arg(val, int);
  100a0d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a14:	8b 00                	mov    (%rax),%eax
  100a16:	83 f8 2f             	cmp    $0x2f,%eax
  100a19:	77 30                	ja     100a4b <printer_vprintf+0x620>
  100a1b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a22:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100a26:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a2d:	8b 00                	mov    (%rax),%eax
  100a2f:	89 c0                	mov    %eax,%eax
  100a31:	48 01 d0             	add    %rdx,%rax
  100a34:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a3b:	8b 12                	mov    (%rdx),%edx
  100a3d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100a40:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a47:	89 0a                	mov    %ecx,(%rdx)
  100a49:	eb 1a                	jmp    100a65 <printer_vprintf+0x63a>
  100a4b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a52:	48 8b 40 08          	mov    0x8(%rax),%rax
  100a56:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100a5a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a61:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100a65:	8b 00                	mov    (%rax),%eax
  100a67:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
            goto done;
  100a6d:	e9 67 03 00 00       	jmp    100dd9 <printer_vprintf+0x9ae>
        case 'c':
            data = numbuf;
  100a72:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100a76:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = va_arg(val, int);
  100a7a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a81:	8b 00                	mov    (%rax),%eax
  100a83:	83 f8 2f             	cmp    $0x2f,%eax
  100a86:	77 30                	ja     100ab8 <printer_vprintf+0x68d>
  100a88:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a8f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100a93:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a9a:	8b 00                	mov    (%rax),%eax
  100a9c:	89 c0                	mov    %eax,%eax
  100a9e:	48 01 d0             	add    %rdx,%rax
  100aa1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100aa8:	8b 12                	mov    (%rdx),%edx
  100aaa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100aad:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100ab4:	89 0a                	mov    %ecx,(%rdx)
  100ab6:	eb 1a                	jmp    100ad2 <printer_vprintf+0x6a7>
  100ab8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100abf:	48 8b 40 08          	mov    0x8(%rax),%rax
  100ac3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100ac7:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100ace:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100ad2:	8b 00                	mov    (%rax),%eax
  100ad4:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  100ad7:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            break;
  100adb:	eb 45                	jmp    100b22 <printer_vprintf+0x6f7>
        default:
            data = numbuf;
  100add:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100ae1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = (*format ? *format : '%');
  100ae5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100aec:	0f b6 00             	movzbl (%rax),%eax
  100aef:	84 c0                	test   %al,%al
  100af1:	74 0c                	je     100aff <printer_vprintf+0x6d4>
  100af3:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100afa:	0f b6 00             	movzbl (%rax),%eax
  100afd:	eb 05                	jmp    100b04 <printer_vprintf+0x6d9>
  100aff:	b8 25 00 00 00       	mov    $0x25,%eax
  100b04:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  100b07:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            if (!*format) {
  100b0b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100b12:	0f b6 00             	movzbl (%rax),%eax
  100b15:	84 c0                	test   %al,%al
  100b17:	75 08                	jne    100b21 <printer_vprintf+0x6f6>
                format--;
  100b19:	48 83 ad 68 ff ff ff 	subq   $0x1,-0x98(%rbp)
  100b20:	01 
            }
            break;
  100b21:	90                   	nop
        }

        if (flags & FLAG_NUMERIC) {
  100b22:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100b25:	83 e0 20             	and    $0x20,%eax
  100b28:	85 c0                	test   %eax,%eax
  100b2a:	74 1e                	je     100b4a <printer_vprintf+0x71f>
            data = fill_numbuf(numbuf + NUMBUFSIZ, num, base);
  100b2c:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100b30:	48 83 c0 18          	add    $0x18,%rax
  100b34:	8b 55 e0             	mov    -0x20(%rbp),%edx
  100b37:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  100b3b:	48 89 ce             	mov    %rcx,%rsi
  100b3e:	48 89 c7             	mov    %rax,%rdi
  100b41:	e8 63 f8 ff ff       	call   1003a9 <fill_numbuf>
  100b46:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        }

        const char* prefix = "";
  100b4a:	48 c7 45 c0 f6 10 10 	movq   $0x1010f6,-0x40(%rbp)
  100b51:	00 
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  100b52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100b55:	83 e0 20             	and    $0x20,%eax
  100b58:	85 c0                	test   %eax,%eax
  100b5a:	74 48                	je     100ba4 <printer_vprintf+0x779>
  100b5c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100b5f:	83 e0 40             	and    $0x40,%eax
  100b62:	85 c0                	test   %eax,%eax
  100b64:	74 3e                	je     100ba4 <printer_vprintf+0x779>
            if (flags & FLAG_NEGATIVE) {
  100b66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100b69:	25 80 00 00 00       	and    $0x80,%eax
  100b6e:	85 c0                	test   %eax,%eax
  100b70:	74 0a                	je     100b7c <printer_vprintf+0x751>
                prefix = "-";
  100b72:	48 c7 45 c0 f7 10 10 	movq   $0x1010f7,-0x40(%rbp)
  100b79:	00 
            if (flags & FLAG_NEGATIVE) {
  100b7a:	eb 73                	jmp    100bef <printer_vprintf+0x7c4>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100b7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100b7f:	83 e0 10             	and    $0x10,%eax
  100b82:	85 c0                	test   %eax,%eax
  100b84:	74 0a                	je     100b90 <printer_vprintf+0x765>
                prefix = "+";
  100b86:	48 c7 45 c0 f9 10 10 	movq   $0x1010f9,-0x40(%rbp)
  100b8d:	00 
            if (flags & FLAG_NEGATIVE) {
  100b8e:	eb 5f                	jmp    100bef <printer_vprintf+0x7c4>
            } else if (flags & FLAG_SPACEPOSITIVE) {
  100b90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100b93:	83 e0 08             	and    $0x8,%eax
  100b96:	85 c0                	test   %eax,%eax
  100b98:	74 55                	je     100bef <printer_vprintf+0x7c4>
                prefix = " ";
  100b9a:	48 c7 45 c0 fb 10 10 	movq   $0x1010fb,-0x40(%rbp)
  100ba1:	00 
            if (flags & FLAG_NEGATIVE) {
  100ba2:	eb 4b                	jmp    100bef <printer_vprintf+0x7c4>
            }
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100ba4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100ba7:	83 e0 20             	and    $0x20,%eax
  100baa:	85 c0                	test   %eax,%eax
  100bac:	74 42                	je     100bf0 <printer_vprintf+0x7c5>
  100bae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100bb1:	83 e0 01             	and    $0x1,%eax
  100bb4:	85 c0                	test   %eax,%eax
  100bb6:	74 38                	je     100bf0 <printer_vprintf+0x7c5>
                   && (base == 16 || base == -16)
  100bb8:	83 7d e0 10          	cmpl   $0x10,-0x20(%rbp)
  100bbc:	74 06                	je     100bc4 <printer_vprintf+0x799>
  100bbe:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  100bc2:	75 2c                	jne    100bf0 <printer_vprintf+0x7c5>
                   && (num || (flags & FLAG_ALT2))) {
  100bc4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  100bc9:	75 0c                	jne    100bd7 <printer_vprintf+0x7ac>
  100bcb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100bce:	25 00 01 00 00       	and    $0x100,%eax
  100bd3:	85 c0                	test   %eax,%eax
  100bd5:	74 19                	je     100bf0 <printer_vprintf+0x7c5>
            prefix = (base == -16 ? "0x" : "0X");
  100bd7:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  100bdb:	75 07                	jne    100be4 <printer_vprintf+0x7b9>
  100bdd:	b8 fd 10 10 00       	mov    $0x1010fd,%eax
  100be2:	eb 05                	jmp    100be9 <printer_vprintf+0x7be>
  100be4:	b8 00 11 10 00       	mov    $0x101100,%eax
  100be9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100bed:	eb 01                	jmp    100bf0 <printer_vprintf+0x7c5>
            if (flags & FLAG_NEGATIVE) {
  100bef:	90                   	nop
        }

        int len;
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  100bf0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  100bf4:	78 24                	js     100c1a <printer_vprintf+0x7ef>
  100bf6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100bf9:	83 e0 20             	and    $0x20,%eax
  100bfc:	85 c0                	test   %eax,%eax
  100bfe:	75 1a                	jne    100c1a <printer_vprintf+0x7ef>
            len = strnlen(data, precision);
  100c00:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100c03:	48 63 d0             	movslq %eax,%rdx
  100c06:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100c0a:	48 89 d6             	mov    %rdx,%rsi
  100c0d:	48 89 c7             	mov    %rax,%rdi
  100c10:	e8 ea f5 ff ff       	call   1001ff <strnlen>
  100c15:	89 45 bc             	mov    %eax,-0x44(%rbp)
  100c18:	eb 0f                	jmp    100c29 <printer_vprintf+0x7fe>
        } else {
            len = strlen(data);
  100c1a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100c1e:	48 89 c7             	mov    %rax,%rdi
  100c21:	e8 a8 f5 ff ff       	call   1001ce <strlen>
  100c26:	89 45 bc             	mov    %eax,-0x44(%rbp)
        }
        int zeros;
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  100c29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100c2c:	83 e0 20             	and    $0x20,%eax
  100c2f:	85 c0                	test   %eax,%eax
  100c31:	74 20                	je     100c53 <printer_vprintf+0x828>
  100c33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  100c37:	78 1a                	js     100c53 <printer_vprintf+0x828>
            zeros = precision > len ? precision - len : 0;
  100c39:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100c3c:	3b 45 bc             	cmp    -0x44(%rbp),%eax
  100c3f:	7e 08                	jle    100c49 <printer_vprintf+0x81e>
  100c41:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100c44:	2b 45 bc             	sub    -0x44(%rbp),%eax
  100c47:	eb 05                	jmp    100c4e <printer_vprintf+0x823>
  100c49:	b8 00 00 00 00       	mov    $0x0,%eax
  100c4e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  100c51:	eb 5c                	jmp    100caf <printer_vprintf+0x884>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100c53:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100c56:	83 e0 20             	and    $0x20,%eax
  100c59:	85 c0                	test   %eax,%eax
  100c5b:	74 4b                	je     100ca8 <printer_vprintf+0x87d>
  100c5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100c60:	83 e0 02             	and    $0x2,%eax
  100c63:	85 c0                	test   %eax,%eax
  100c65:	74 41                	je     100ca8 <printer_vprintf+0x87d>
                   && !(flags & FLAG_LEFTJUSTIFY)
  100c67:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100c6a:	83 e0 04             	and    $0x4,%eax
  100c6d:	85 c0                	test   %eax,%eax
  100c6f:	75 37                	jne    100ca8 <printer_vprintf+0x87d>
                   && len + (int) strlen(prefix) < width) {
  100c71:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100c75:	48 89 c7             	mov    %rax,%rdi
  100c78:	e8 51 f5 ff ff       	call   1001ce <strlen>
  100c7d:	89 c2                	mov    %eax,%edx
  100c7f:	8b 45 bc             	mov    -0x44(%rbp),%eax
  100c82:	01 d0                	add    %edx,%eax
  100c84:	39 45 e8             	cmp    %eax,-0x18(%rbp)
  100c87:	7e 1f                	jle    100ca8 <printer_vprintf+0x87d>
            zeros = width - len - strlen(prefix);
  100c89:	8b 45 e8             	mov    -0x18(%rbp),%eax
  100c8c:	2b 45 bc             	sub    -0x44(%rbp),%eax
  100c8f:	89 c3                	mov    %eax,%ebx
  100c91:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100c95:	48 89 c7             	mov    %rax,%rdi
  100c98:	e8 31 f5 ff ff       	call   1001ce <strlen>
  100c9d:	89 c2                	mov    %eax,%edx
  100c9f:	89 d8                	mov    %ebx,%eax
  100ca1:	29 d0                	sub    %edx,%eax
  100ca3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  100ca6:	eb 07                	jmp    100caf <printer_vprintf+0x884>
        } else {
            zeros = 0;
  100ca8:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
        }
        width -= len + zeros + strlen(prefix);
  100caf:	8b 55 bc             	mov    -0x44(%rbp),%edx
  100cb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  100cb5:	01 d0                	add    %edx,%eax
  100cb7:	48 63 d8             	movslq %eax,%rbx
  100cba:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100cbe:	48 89 c7             	mov    %rax,%rdi
  100cc1:	e8 08 f5 ff ff       	call   1001ce <strlen>
  100cc6:	48 8d 14 03          	lea    (%rbx,%rax,1),%rdx
  100cca:	8b 45 e8             	mov    -0x18(%rbp),%eax
  100ccd:	29 d0                	sub    %edx,%eax
  100ccf:	89 45 e8             	mov    %eax,-0x18(%rbp)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100cd2:	eb 25                	jmp    100cf9 <printer_vprintf+0x8ce>
            p->putc(p, ' ', color);
  100cd4:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100cdb:	48 8b 08             	mov    (%rax),%rcx
  100cde:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100ce4:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100ceb:	be 20 00 00 00       	mov    $0x20,%esi
  100cf0:	48 89 c7             	mov    %rax,%rdi
  100cf3:	ff d1                	call   *%rcx
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100cf5:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  100cf9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100cfc:	83 e0 04             	and    $0x4,%eax
  100cff:	85 c0                	test   %eax,%eax
  100d01:	75 36                	jne    100d39 <printer_vprintf+0x90e>
  100d03:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  100d07:	7f cb                	jg     100cd4 <printer_vprintf+0x8a9>
        }
        for (; *prefix; ++prefix) {
  100d09:	eb 2e                	jmp    100d39 <printer_vprintf+0x90e>
            p->putc(p, *prefix, color);
  100d0b:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100d12:	4c 8b 00             	mov    (%rax),%r8
  100d15:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100d19:	0f b6 00             	movzbl (%rax),%eax
  100d1c:	0f b6 c8             	movzbl %al,%ecx
  100d1f:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100d25:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100d2c:	89 ce                	mov    %ecx,%esi
  100d2e:	48 89 c7             	mov    %rax,%rdi
  100d31:	41 ff d0             	call   *%r8
        for (; *prefix; ++prefix) {
  100d34:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  100d39:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100d3d:	0f b6 00             	movzbl (%rax),%eax
  100d40:	84 c0                	test   %al,%al
  100d42:	75 c7                	jne    100d0b <printer_vprintf+0x8e0>
        }
        for (; zeros > 0; --zeros) {
  100d44:	eb 25                	jmp    100d6b <printer_vprintf+0x940>
            p->putc(p, '0', color);
  100d46:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100d4d:	48 8b 08             	mov    (%rax),%rcx
  100d50:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100d56:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100d5d:	be 30 00 00 00       	mov    $0x30,%esi
  100d62:	48 89 c7             	mov    %rax,%rdi
  100d65:	ff d1                	call   *%rcx
        for (; zeros > 0; --zeros) {
  100d67:	83 6d b8 01          	subl   $0x1,-0x48(%rbp)
  100d6b:	83 7d b8 00          	cmpl   $0x0,-0x48(%rbp)
  100d6f:	7f d5                	jg     100d46 <printer_vprintf+0x91b>
        }
        for (; len > 0; ++data, --len) {
  100d71:	eb 32                	jmp    100da5 <printer_vprintf+0x97a>
            p->putc(p, *data, color);
  100d73:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100d7a:	4c 8b 00             	mov    (%rax),%r8
  100d7d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100d81:	0f b6 00             	movzbl (%rax),%eax
  100d84:	0f b6 c8             	movzbl %al,%ecx
  100d87:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100d8d:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100d94:	89 ce                	mov    %ecx,%esi
  100d96:	48 89 c7             	mov    %rax,%rdi
  100d99:	41 ff d0             	call   *%r8
        for (; len > 0; ++data, --len) {
  100d9c:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  100da1:	83 6d bc 01          	subl   $0x1,-0x44(%rbp)
  100da5:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  100da9:	7f c8                	jg     100d73 <printer_vprintf+0x948>
        }
        for (; width > 0; --width) {
  100dab:	eb 25                	jmp    100dd2 <printer_vprintf+0x9a7>
            p->putc(p, ' ', color);
  100dad:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100db4:	48 8b 08             	mov    (%rax),%rcx
  100db7:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100dbd:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100dc4:	be 20 00 00 00       	mov    $0x20,%esi
  100dc9:	48 89 c7             	mov    %rax,%rdi
  100dcc:	ff d1                	call   *%rcx
        for (; width > 0; --width) {
  100dce:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  100dd2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  100dd6:	7f d5                	jg     100dad <printer_vprintf+0x982>
        }
    done: ;
  100dd8:	90                   	nop
    for (; *format; ++format) {
  100dd9:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100de0:	01 
  100de1:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100de8:	0f b6 00             	movzbl (%rax),%eax
  100deb:	84 c0                	test   %al,%al
  100ded:	0f 85 64 f6 ff ff    	jne    100457 <printer_vprintf+0x2c>
    }
}
  100df3:	90                   	nop
  100df4:	90                   	nop
  100df5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100df9:	c9                   	leave
  100dfa:	c3                   	ret

0000000000100dfb <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  100dfb:	55                   	push   %rbp
  100dfc:	48 89 e5             	mov    %rsp,%rbp
  100dff:	48 83 ec 20          	sub    $0x20,%rsp
  100e03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  100e07:	89 f0                	mov    %esi,%eax
  100e09:	89 55 e0             	mov    %edx,-0x20(%rbp)
  100e0c:	88 45 e4             	mov    %al,-0x1c(%rbp)
    console_printer* cp = (console_printer*) p;
  100e0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100e13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  100e17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100e1b:	48 8b 40 08          	mov    0x8(%rax),%rax
  100e1f:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
  100e24:	48 39 d0             	cmp    %rdx,%rax
  100e27:	72 0c                	jb     100e35 <console_putc+0x3a>
        cp->cursor = console;
  100e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100e2d:	48 c7 40 08 00 80 0b 	movq   $0xb8000,0x8(%rax)
  100e34:	00 
    }
    if (c == '\n') {
  100e35:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%rbp)
  100e39:	75 78                	jne    100eb3 <console_putc+0xb8>
        int pos = (cp->cursor - console) % 80;
  100e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100e3f:	48 8b 40 08          	mov    0x8(%rax),%rax
  100e43:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  100e49:	48 d1 f8             	sar    %rax
  100e4c:	48 89 c1             	mov    %rax,%rcx
  100e4f:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  100e56:	66 66 66 
  100e59:	48 89 c8             	mov    %rcx,%rax
  100e5c:	48 f7 ea             	imul   %rdx
  100e5f:	48 c1 fa 05          	sar    $0x5,%rdx
  100e63:	48 89 c8             	mov    %rcx,%rax
  100e66:	48 c1 f8 3f          	sar    $0x3f,%rax
  100e6a:	48 29 c2             	sub    %rax,%rdx
  100e6d:	48 89 d0             	mov    %rdx,%rax
  100e70:	48 c1 e0 02          	shl    $0x2,%rax
  100e74:	48 01 d0             	add    %rdx,%rax
  100e77:	48 c1 e0 04          	shl    $0x4,%rax
  100e7b:	48 29 c1             	sub    %rax,%rcx
  100e7e:	48 89 ca             	mov    %rcx,%rdx
  100e81:	89 55 fc             	mov    %edx,-0x4(%rbp)
        for (; pos != 80; pos++) {
  100e84:	eb 25                	jmp    100eab <console_putc+0xb0>
            *cp->cursor++ = ' ' | color;
  100e86:	8b 45 e0             	mov    -0x20(%rbp),%eax
  100e89:	83 c8 20             	or     $0x20,%eax
  100e8c:	89 c6                	mov    %eax,%esi
  100e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100e92:	48 8b 40 08          	mov    0x8(%rax),%rax
  100e96:	48 8d 48 02          	lea    0x2(%rax),%rcx
  100e9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  100e9e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100ea2:	89 f2                	mov    %esi,%edx
  100ea4:	66 89 10             	mov    %dx,(%rax)
        for (; pos != 80; pos++) {
  100ea7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  100eab:	83 7d fc 50          	cmpl   $0x50,-0x4(%rbp)
  100eaf:	75 d5                	jne    100e86 <console_putc+0x8b>
        }
    } else {
        *cp->cursor++ = c | color;
    }
}
  100eb1:	eb 24                	jmp    100ed7 <console_putc+0xdc>
        *cp->cursor++ = c | color;
  100eb3:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
  100eb7:	8b 55 e0             	mov    -0x20(%rbp),%edx
  100eba:	09 d0                	or     %edx,%eax
  100ebc:	89 c6                	mov    %eax,%esi
  100ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100ec2:	48 8b 40 08          	mov    0x8(%rax),%rax
  100ec6:	48 8d 48 02          	lea    0x2(%rax),%rcx
  100eca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  100ece:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100ed2:	89 f2                	mov    %esi,%edx
  100ed4:	66 89 10             	mov    %dx,(%rax)
}
  100ed7:	90                   	nop
  100ed8:	c9                   	leave
  100ed9:	c3                   	ret

0000000000100eda <console_vprintf>:

int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100eda:	55                   	push   %rbp
  100edb:	48 89 e5             	mov    %rsp,%rbp
  100ede:	48 83 ec 30          	sub    $0x30,%rsp
  100ee2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  100ee5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  100ee8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  100eec:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
    struct console_printer cp;
    cp.p.putc = console_putc;
  100ef0:	48 c7 45 f0 fb 0d 10 	movq   $0x100dfb,-0x10(%rbp)
  100ef7:	00 
    if (cpos < 0 || cpos >= CONSOLE_ROWS * CONSOLE_COLUMNS) {
  100ef8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  100efc:	78 09                	js     100f07 <console_vprintf+0x2d>
  100efe:	81 7d ec cf 07 00 00 	cmpl   $0x7cf,-0x14(%rbp)
  100f05:	7e 07                	jle    100f0e <console_vprintf+0x34>
        cpos = 0;
  100f07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
    cp.cursor = console + cpos;
  100f0e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100f11:	48 98                	cltq
  100f13:	48 01 c0             	add    %rax,%rax
  100f16:	48 05 00 80 0b 00    	add    $0xb8000,%rax
  100f1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  100f20:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  100f24:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  100f28:	8b 75 e8             	mov    -0x18(%rbp),%esi
  100f2b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  100f2f:	48 89 c7             	mov    %rax,%rdi
  100f32:	e8 f4 f4 ff ff       	call   10042b <printer_vprintf>
    return cp.cursor - console;
  100f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100f3b:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  100f41:	48 d1 f8             	sar    %rax
}
  100f44:	c9                   	leave
  100f45:	c3                   	ret

0000000000100f46 <console_printf>:

int console_printf(int cpos, int color, const char* format, ...) {
  100f46:	55                   	push   %rbp
  100f47:	48 89 e5             	mov    %rsp,%rbp
  100f4a:	48 83 ec 60          	sub    $0x60,%rsp
  100f4e:	89 7d ac             	mov    %edi,-0x54(%rbp)
  100f51:	89 75 a8             	mov    %esi,-0x58(%rbp)
  100f54:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  100f58:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100f5c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100f60:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100f64:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100f6b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100f6f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100f73:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100f77:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  100f7b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100f7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  100f83:	8b 75 a8             	mov    -0x58(%rbp),%esi
  100f86:	8b 45 ac             	mov    -0x54(%rbp),%eax
  100f89:	89 c7                	mov    %eax,%edi
  100f8b:	e8 4a ff ff ff       	call   100eda <console_vprintf>
  100f90:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
  100f93:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
  100f96:	c9                   	leave
  100f97:	c3                   	ret

0000000000100f98 <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  100f98:	55                   	push   %rbp
  100f99:	48 89 e5             	mov    %rsp,%rbp
  100f9c:	48 83 ec 20          	sub    $0x20,%rsp
  100fa0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  100fa4:	89 f0                	mov    %esi,%eax
  100fa6:	89 55 e0             	mov    %edx,-0x20(%rbp)
  100fa9:	88 45 e4             	mov    %al,-0x1c(%rbp)
    string_printer* sp = (string_printer*) p;
  100fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100fb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (sp->s < sp->end) {
  100fb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100fb8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  100fbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100fc0:	48 8b 40 10          	mov    0x10(%rax),%rax
  100fc4:	48 39 c2             	cmp    %rax,%rdx
  100fc7:	73 1a                	jae    100fe3 <string_putc+0x4b>
        *sp->s++ = c;
  100fc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100fcd:	48 8b 40 08          	mov    0x8(%rax),%rax
  100fd1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  100fd5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  100fd9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100fdd:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
  100fe1:	88 10                	mov    %dl,(%rax)
    }
    (void) color;
}
  100fe3:	90                   	nop
  100fe4:	c9                   	leave
  100fe5:	c3                   	ret

0000000000100fe6 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  100fe6:	55                   	push   %rbp
  100fe7:	48 89 e5             	mov    %rsp,%rbp
  100fea:	48 83 ec 40          	sub    $0x40,%rsp
  100fee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  100ff2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  100ff6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  100ffa:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    string_printer sp;
    sp.p.putc = string_putc;
  100ffe:	48 c7 45 e8 98 0f 10 	movq   $0x100f98,-0x18(%rbp)
  101005:	00 
    sp.s = s;
  101006:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  10100a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (size) {
  10100e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  101013:	74 33                	je     101048 <vsnprintf+0x62>
        sp.end = s + size - 1;
  101015:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  101019:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  10101d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  101021:	48 01 d0             	add    %rdx,%rax
  101024:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  101028:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  10102c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  101030:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  101034:	be 00 00 00 00       	mov    $0x0,%esi
  101039:	48 89 c7             	mov    %rax,%rdi
  10103c:	e8 ea f3 ff ff       	call   10042b <printer_vprintf>
        *sp.s = 0;
  101041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  101045:	c6 00 00             	movb   $0x0,(%rax)
    }
    return sp.s - s;
  101048:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10104c:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
}
  101050:	c9                   	leave
  101051:	c3                   	ret

0000000000101052 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  101052:	55                   	push   %rbp
  101053:	48 89 e5             	mov    %rsp,%rbp
  101056:	48 83 ec 70          	sub    $0x70,%rsp
  10105a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  10105e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  101062:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  101066:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  10106a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  10106e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  101072:	c7 45 b0 18 00 00 00 	movl   $0x18,-0x50(%rbp)
  101079:	48 8d 45 10          	lea    0x10(%rbp),%rax
  10107d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  101081:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  101085:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    int n = vsnprintf(s, size, format, val);
  101089:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  10108d:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  101091:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  101095:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  101099:	48 89 c7             	mov    %rax,%rdi
  10109c:	e8 45 ff ff ff       	call   100fe6 <vsnprintf>
  1010a1:	89 45 cc             	mov    %eax,-0x34(%rbp)
    va_end(val);
    return n;
  1010a4:	8b 45 cc             	mov    -0x34(%rbp),%eax
}
  1010a7:	c9                   	leave
  1010a8:	c3                   	ret

00000000001010a9 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  1010a9:	55                   	push   %rbp
  1010aa:	48 89 e5             	mov    %rsp,%rbp
  1010ad:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1010b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  1010b8:	eb 13                	jmp    1010cd <console_clear+0x24>
        console[i] = ' ' | 0x0700;
  1010ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  1010bd:	48 98                	cltq
  1010bf:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%rax,%rax,1)
  1010c6:	00 20 07 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1010c9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  1010cd:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
  1010d4:	7e e4                	jle    1010ba <console_clear+0x11>
    }
    cursorpos = 0;
  1010d6:	c7 05 1c 7f fb ff 00 	movl   $0x0,-0x480e4(%rip)        # b8ffc <cursorpos>
  1010dd:	00 00 00 
}
  1010e0:	90                   	nop
  1010e1:	c9                   	leave
  1010e2:	c3                   	ret
