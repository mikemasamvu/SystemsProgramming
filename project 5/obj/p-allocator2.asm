
obj/p-allocator2.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000140000 <process_main>:
uint8_t* stack_bottom;

// Program that starts allocating page by page from its heap
// till it reaches stack OR runs out of memory

void process_main(void) {
  140000:	55                   	push   %rbp
  140001:	48 89 e5             	mov    %rsp,%rbp
  140004:	53                   	push   %rbx
  140005:	48 83 ec 08          	sub    $0x8,%rsp

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  140009:	cd 31                	int    $0x31
  14000b:	89 c3                	mov    %eax,%ebx
    pid_t p = sys_getpid();
    srand(p);
  14000d:	89 c7                	mov    %eax,%edi
  14000f:	e8 74 03 00 00       	call   140388 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  140014:	b8 17 30 14 00       	mov    $0x143017,%eax
  140019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  14001f:	48 89 05 e2 1f 00 00 	mov    %rax,0x1fe2(%rip)        # 142008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  140026:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  140029:	48 83 e8 01          	sub    $0x1,%rax
  14002d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  140033:	48 89 05 c6 1f 00 00 	mov    %rax,0x1fc6(%rip)        # 142000 <stack_bottom>
  14003a:	eb 02                	jmp    14003e <process_main+0x3e>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  14003c:	cd 32                	int    $0x32

    // Allocate heap pages until (1) hit the stack (out of address space)
    // or (2) allocation fails (out of physical memory).
    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  14003e:	e8 09 03 00 00       	call   14034c <rand>
  140043:	48 63 d0             	movslq %eax,%rdx
  140046:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  14004d:	48 c1 fa 25          	sar    $0x25,%rdx
  140051:	89 c1                	mov    %eax,%ecx
  140053:	c1 f9 1f             	sar    $0x1f,%ecx
  140056:	29 ca                	sub    %ecx,%edx
  140058:	6b d2 64             	imul   $0x64,%edx,%edx
  14005b:	29 d0                	sub    %edx,%eax
  14005d:	39 d8                	cmp    %ebx,%eax
  14005f:	7d db                	jge    14003c <process_main+0x3c>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  140061:	48 8b 3d a0 1f 00 00 	mov    0x1fa0(%rip),%rdi        # 142008 <heap_top>
  140068:	48 3b 3d 91 1f 00 00 	cmp    0x1f91(%rip),%rdi        # 142000 <stack_bottom>
  14006f:	74 1c                	je     14008d <process_main+0x8d>
//    Allocate a page of memory at address `addr` and allow process to
//    write to it. `Addr` must be page-aligned (i.e., a multiple of
//    PAGESIZE == 4096). Returns 0 on success and -1 on failure.
static inline int sys_page_alloc(void* addr) {
    int result;
    asm volatile ("int %1" : "=a" (result)
  140071:	cd 33                	int    $0x33
  140073:	85 c0                	test   %eax,%eax
  140075:	78 16                	js     14008d <process_main+0x8d>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  140077:	48 8b 05 8a 1f 00 00 	mov    0x1f8a(%rip),%rax        # 142008 <heap_top>
  14007e:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  140080:	48 81 05 7d 1f 00 00 	addq   $0x1000,0x1f7d(%rip)        # 142008 <heap_top>
  140087:	00 10 00 00 
  14008b:	eb af                	jmp    14003c <process_main+0x3c>
    asm volatile ("int %0" : /* no result */
  14008d:	cd 32                	int    $0x32
        }
        sys_yield();
    }

    // After running out of memory, do nothing forever
    while (1) {
  14008f:	eb fc                	jmp    14008d <process_main+0x8d>

0000000000140091 <memcpy>:


// memcpy, memmove, memset, strcmp, strlen, strnlen
//    We must provide our own implementations.

void* memcpy(void* dst, const void* src, size_t n) {
  140091:	55                   	push   %rbp
  140092:	48 89 e5             	mov    %rsp,%rbp
  140095:	48 83 ec 28          	sub    $0x28,%rsp
  140099:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  14009d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1400a1:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1400a5:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1400a9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1400ad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1400b1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  1400b5:	eb 1c                	jmp    1400d3 <memcpy+0x42>
        *d = *s;
  1400b7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1400bb:	0f b6 10             	movzbl (%rax),%edx
  1400be:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1400c2:	88 10                	mov    %dl,(%rax)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1400c4:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  1400c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1400ce:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  1400d3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1400d8:	75 dd                	jne    1400b7 <memcpy+0x26>
    }
    return dst;
  1400da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1400de:	c9                   	leave
  1400df:	c3                   	ret

00000000001400e0 <memmove>:

void* memmove(void* dst, const void* src, size_t n) {
  1400e0:	55                   	push   %rbp
  1400e1:	48 89 e5             	mov    %rsp,%rbp
  1400e4:	48 83 ec 28          	sub    $0x28,%rsp
  1400e8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1400ec:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1400f0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1400f4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1400f8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    char* d = (char*) dst;
  1400fc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  140100:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (s < d && s + n > d) {
  140104:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  140108:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  14010c:	73 6a                	jae    140178 <memmove+0x98>
  14010e:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  140112:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  140116:	48 01 d0             	add    %rdx,%rax
  140119:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
  14011d:	73 59                	jae    140178 <memmove+0x98>
        s += n, d += n;
  14011f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  140123:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  140127:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  14012b:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        while (n-- > 0) {
  14012f:	eb 17                	jmp    140148 <memmove+0x68>
            *--d = *--s;
  140131:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  140136:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
  14013b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  14013f:	0f b6 10             	movzbl (%rax),%edx
  140142:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  140146:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  140148:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  14014c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  140150:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  140154:	48 85 c0             	test   %rax,%rax
  140157:	75 d8                	jne    140131 <memmove+0x51>
    if (s < d && s + n > d) {
  140159:	eb 2e                	jmp    140189 <memmove+0xa9>
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
  14015b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  14015f:	48 8d 42 01          	lea    0x1(%rdx),%rax
  140163:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  140167:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  14016b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  14016f:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  140173:	0f b6 12             	movzbl (%rdx),%edx
  140176:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  140178:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  14017c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  140180:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  140184:	48 85 c0             	test   %rax,%rax
  140187:	75 d2                	jne    14015b <memmove+0x7b>
        }
    }
    return dst;
  140189:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  14018d:	c9                   	leave
  14018e:	c3                   	ret

000000000014018f <memset>:

void* memset(void* v, int c, size_t n) {
  14018f:	55                   	push   %rbp
  140190:	48 89 e5             	mov    %rsp,%rbp
  140193:	48 83 ec 28          	sub    $0x28,%rsp
  140197:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  14019b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  14019e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1401a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1401a6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  1401aa:	eb 15                	jmp    1401c1 <memset+0x32>
        *p = c;
  1401ac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1401af:	89 c2                	mov    %eax,%edx
  1401b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1401b5:	88 10                	mov    %dl,(%rax)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1401b7:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1401bc:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  1401c1:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1401c6:	75 e4                	jne    1401ac <memset+0x1d>
    }
    return v;
  1401c8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1401cc:	c9                   	leave
  1401cd:	c3                   	ret

00000000001401ce <strlen>:

size_t strlen(const char* s) {
  1401ce:	55                   	push   %rbp
  1401cf:	48 89 e5             	mov    %rsp,%rbp
  1401d2:	48 83 ec 18          	sub    $0x18,%rsp
  1401d6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
  1401da:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  1401e1:	00 
  1401e2:	eb 0a                	jmp    1401ee <strlen+0x20>
        ++n;
  1401e4:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; *s != '\0'; ++s) {
  1401e9:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  1401ee:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1401f2:	0f b6 00             	movzbl (%rax),%eax
  1401f5:	84 c0                	test   %al,%al
  1401f7:	75 eb                	jne    1401e4 <strlen+0x16>
    }
    return n;
  1401f9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  1401fd:	c9                   	leave
  1401fe:	c3                   	ret

00000000001401ff <strnlen>:

size_t strnlen(const char* s, size_t maxlen) {
  1401ff:	55                   	push   %rbp
  140200:	48 89 e5             	mov    %rsp,%rbp
  140203:	48 83 ec 20          	sub    $0x20,%rsp
  140207:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  14020b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    size_t n;
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  14020f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  140216:	00 
  140217:	eb 0a                	jmp    140223 <strnlen+0x24>
        ++n;
  140219:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  14021e:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  140223:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  140227:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  14022b:	74 0b                	je     140238 <strnlen+0x39>
  14022d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  140231:	0f b6 00             	movzbl (%rax),%eax
  140234:	84 c0                	test   %al,%al
  140236:	75 e1                	jne    140219 <strnlen+0x1a>
    }
    return n;
  140238:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  14023c:	c9                   	leave
  14023d:	c3                   	ret

000000000014023e <strcpy>:

char* strcpy(char* dst, const char* src) {
  14023e:	55                   	push   %rbp
  14023f:	48 89 e5             	mov    %rsp,%rbp
  140242:	48 83 ec 20          	sub    $0x20,%rsp
  140246:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  14024a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    char* d = dst;
  14024e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  140252:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    do {
        *d++ = *src++;
  140256:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  14025a:	48 8d 42 01          	lea    0x1(%rdx),%rax
  14025e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  140262:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  140266:	48 8d 48 01          	lea    0x1(%rax),%rcx
  14026a:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
  14026e:	0f b6 12             	movzbl (%rdx),%edx
  140271:	88 10                	mov    %dl,(%rax)
    } while (d[-1]);
  140273:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  140277:	48 83 e8 01          	sub    $0x1,%rax
  14027b:	0f b6 00             	movzbl (%rax),%eax
  14027e:	84 c0                	test   %al,%al
  140280:	75 d4                	jne    140256 <strcpy+0x18>
    return dst;
  140282:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  140286:	c9                   	leave
  140287:	c3                   	ret

0000000000140288 <strcmp>:

int strcmp(const char* a, const char* b) {
  140288:	55                   	push   %rbp
  140289:	48 89 e5             	mov    %rsp,%rbp
  14028c:	48 83 ec 10          	sub    $0x10,%rsp
  140290:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  140294:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  140298:	eb 0a                	jmp    1402a4 <strcmp+0x1c>
        ++a, ++b;
  14029a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  14029f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  1402a4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1402a8:	0f b6 00             	movzbl (%rax),%eax
  1402ab:	84 c0                	test   %al,%al
  1402ad:	74 1d                	je     1402cc <strcmp+0x44>
  1402af:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1402b3:	0f b6 00             	movzbl (%rax),%eax
  1402b6:	84 c0                	test   %al,%al
  1402b8:	74 12                	je     1402cc <strcmp+0x44>
  1402ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1402be:	0f b6 10             	movzbl (%rax),%edx
  1402c1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1402c5:	0f b6 00             	movzbl (%rax),%eax
  1402c8:	38 c2                	cmp    %al,%dl
  1402ca:	74 ce                	je     14029a <strcmp+0x12>
    }
    return ((unsigned char) *a > (unsigned char) *b)
  1402cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1402d0:	0f b6 00             	movzbl (%rax),%eax
  1402d3:	89 c2                	mov    %eax,%edx
  1402d5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1402d9:	0f b6 00             	movzbl (%rax),%eax
  1402dc:	38 d0                	cmp    %dl,%al
  1402de:	0f 92 c0             	setb   %al
  1402e1:	0f b6 d0             	movzbl %al,%edx
        - ((unsigned char) *a < (unsigned char) *b);
  1402e4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1402e8:	0f b6 00             	movzbl (%rax),%eax
  1402eb:	89 c1                	mov    %eax,%ecx
  1402ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1402f1:	0f b6 00             	movzbl (%rax),%eax
  1402f4:	38 c1                	cmp    %al,%cl
  1402f6:	0f 92 c0             	setb   %al
  1402f9:	0f b6 c0             	movzbl %al,%eax
  1402fc:	29 c2                	sub    %eax,%edx
  1402fe:	89 d0                	mov    %edx,%eax
}
  140300:	c9                   	leave
  140301:	c3                   	ret

0000000000140302 <strchr>:

char* strchr(const char* s, int c) {
  140302:	55                   	push   %rbp
  140303:	48 89 e5             	mov    %rsp,%rbp
  140306:	48 83 ec 10          	sub    $0x10,%rsp
  14030a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  14030e:	89 75 f4             	mov    %esi,-0xc(%rbp)
    while (*s && *s != (char) c) {
  140311:	eb 05                	jmp    140318 <strchr+0x16>
        ++s;
  140313:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while (*s && *s != (char) c) {
  140318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  14031c:	0f b6 00             	movzbl (%rax),%eax
  14031f:	84 c0                	test   %al,%al
  140321:	74 0e                	je     140331 <strchr+0x2f>
  140323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  140327:	0f b6 00             	movzbl (%rax),%eax
  14032a:	8b 55 f4             	mov    -0xc(%rbp),%edx
  14032d:	38 d0                	cmp    %dl,%al
  14032f:	75 e2                	jne    140313 <strchr+0x11>
    }
    if (*s == (char) c) {
  140331:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  140335:	0f b6 00             	movzbl (%rax),%eax
  140338:	8b 55 f4             	mov    -0xc(%rbp),%edx
  14033b:	38 d0                	cmp    %dl,%al
  14033d:	75 06                	jne    140345 <strchr+0x43>
        return (char*) s;
  14033f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  140343:	eb 05                	jmp    14034a <strchr+0x48>
    } else {
        return NULL;
  140345:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
  14034a:	c9                   	leave
  14034b:	c3                   	ret

000000000014034c <rand>:
// rand, srand

static int rand_seed_set;
static unsigned rand_seed;

int rand(void) {
  14034c:	55                   	push   %rbp
  14034d:	48 89 e5             	mov    %rsp,%rbp
    if (!rand_seed_set) {
  140350:	8b 05 ba 1c 00 00    	mov    0x1cba(%rip),%eax        # 142010 <rand_seed_set>
  140356:	85 c0                	test   %eax,%eax
  140358:	75 0a                	jne    140364 <rand+0x18>
        srand(819234718U);
  14035a:	bf 9e 87 d4 30       	mov    $0x30d4879e,%edi
  14035f:	e8 24 00 00 00       	call   140388 <srand>
    }
    rand_seed = rand_seed * 1664525U + 1013904223U;
  140364:	8b 05 aa 1c 00 00    	mov    0x1caa(%rip),%eax        # 142014 <rand_seed>
  14036a:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
  140370:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  140375:	89 05 99 1c 00 00    	mov    %eax,0x1c99(%rip)        # 142014 <rand_seed>
    return rand_seed & RAND_MAX;
  14037b:	8b 05 93 1c 00 00    	mov    0x1c93(%rip),%eax        # 142014 <rand_seed>
  140381:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  140386:	5d                   	pop    %rbp
  140387:	c3                   	ret

0000000000140388 <srand>:

void srand(unsigned seed) {
  140388:	55                   	push   %rbp
  140389:	48 89 e5             	mov    %rsp,%rbp
  14038c:	48 83 ec 08          	sub    $0x8,%rsp
  140390:	89 7d fc             	mov    %edi,-0x4(%rbp)
    rand_seed = seed;
  140393:	8b 45 fc             	mov    -0x4(%rbp),%eax
  140396:	89 05 78 1c 00 00    	mov    %eax,0x1c78(%rip)        # 142014 <rand_seed>
    rand_seed_set = 1;
  14039c:	c7 05 6a 1c 00 00 01 	movl   $0x1,0x1c6a(%rip)        # 142010 <rand_seed_set>
  1403a3:	00 00 00 
}
  1403a6:	90                   	nop
  1403a7:	c9                   	leave
  1403a8:	c3                   	ret

00000000001403a9 <fill_numbuf>:
//    Print a message onto the console, starting at the given cursor position.

// snprintf, vsnprintf
//    Format a string into a buffer.

static char* fill_numbuf(char* numbuf_end, unsigned long val, int base) {
  1403a9:	55                   	push   %rbp
  1403aa:	48 89 e5             	mov    %rsp,%rbp
  1403ad:	48 83 ec 28          	sub    $0x28,%rsp
  1403b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1403b5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1403b9:	89 55 dc             	mov    %edx,-0x24(%rbp)
    static const char upper_digits[] = "0123456789ABCDEF";
    static const char lower_digits[] = "0123456789abcdef";

    const char* digits = upper_digits;
  1403bc:	48 c7 45 f8 d0 12 14 	movq   $0x1412d0,-0x8(%rbp)
  1403c3:	00 
    if (base < 0) {
  1403c4:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  1403c8:	79 0b                	jns    1403d5 <fill_numbuf+0x2c>
        digits = lower_digits;
  1403ca:	48 c7 45 f8 f0 12 14 	movq   $0x1412f0,-0x8(%rbp)
  1403d1:	00 
        base = -base;
  1403d2:	f7 5d dc             	negl   -0x24(%rbp)
    }

    *--numbuf_end = '\0';
  1403d5:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  1403da:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1403de:	c6 00 00             	movb   $0x0,(%rax)
    do {
        *--numbuf_end = digits[val % base];
  1403e1:	8b 45 dc             	mov    -0x24(%rbp),%eax
  1403e4:	48 63 c8             	movslq %eax,%rcx
  1403e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1403eb:	ba 00 00 00 00       	mov    $0x0,%edx
  1403f0:	48 f7 f1             	div    %rcx
  1403f3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1403f7:	48 01 d0             	add    %rdx,%rax
  1403fa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  1403ff:	0f b6 10             	movzbl (%rax),%edx
  140402:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  140406:	88 10                	mov    %dl,(%rax)
        val /= base;
  140408:	8b 45 dc             	mov    -0x24(%rbp),%eax
  14040b:	48 63 f0             	movslq %eax,%rsi
  14040e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  140412:	ba 00 00 00 00       	mov    $0x0,%edx
  140417:	48 f7 f6             	div    %rsi
  14041a:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    } while (val != 0);
  14041e:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  140423:	75 bc                	jne    1403e1 <fill_numbuf+0x38>
    return numbuf_end;
  140425:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  140429:	c9                   	leave
  14042a:	c3                   	ret

000000000014042b <printer_vprintf>:
#define FLAG_NUMERIC            (1<<5)
#define FLAG_SIGNED             (1<<6)
#define FLAG_NEGATIVE           (1<<7)
#define FLAG_ALT2               (1<<8)

void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  14042b:	55                   	push   %rbp
  14042c:	48 89 e5             	mov    %rsp,%rbp
  14042f:	53                   	push   %rbx
  140430:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  140437:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
  14043e:	89 b5 74 ff ff ff    	mov    %esi,-0x8c(%rbp)
  140444:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  14044b:	48 89 8d 60 ff ff ff 	mov    %rcx,-0xa0(%rbp)
#define NUMBUFSIZ 24
    char numbuf[NUMBUFSIZ];

    for (; *format; ++format) {
  140452:	e9 8a 09 00 00       	jmp    140de1 <printer_vprintf+0x9b6>
        if (*format != '%') {
  140457:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  14045e:	0f b6 00             	movzbl (%rax),%eax
  140461:	3c 25                	cmp    $0x25,%al
  140463:	74 31                	je     140496 <printer_vprintf+0x6b>
            p->putc(p, *format, color);
  140465:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  14046c:	4c 8b 00             	mov    (%rax),%r8
  14046f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  140476:	0f b6 00             	movzbl (%rax),%eax
  140479:	0f b6 c8             	movzbl %al,%ecx
  14047c:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  140482:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  140489:	89 ce                	mov    %ecx,%esi
  14048b:	48 89 c7             	mov    %rax,%rdi
  14048e:	41 ff d0             	call   *%r8
            continue;
  140491:	e9 43 09 00 00       	jmp    140dd9 <printer_vprintf+0x9ae>
        }

        // process flags
        int flags = 0;
  140496:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        for (++format; *format; ++format) {
  14049d:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1404a4:	01 
  1404a5:	eb 44                	jmp    1404eb <printer_vprintf+0xc0>
            const char* flagc = strchr(flag_chars, *format);
  1404a7:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1404ae:	0f b6 00             	movzbl (%rax),%eax
  1404b1:	0f be c0             	movsbl %al,%eax
  1404b4:	89 c6                	mov    %eax,%esi
  1404b6:	bf f0 10 14 00       	mov    $0x1410f0,%edi
  1404bb:	e8 42 fe ff ff       	call   140302 <strchr>
  1404c0:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (flagc) {
  1404c4:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  1404c9:	74 30                	je     1404fb <printer_vprintf+0xd0>
                flags |= 1 << (flagc - flag_chars);
  1404cb:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  1404cf:	48 2d f0 10 14 00    	sub    $0x1410f0,%rax
  1404d5:	ba 01 00 00 00       	mov    $0x1,%edx
  1404da:	89 c1                	mov    %eax,%ecx
  1404dc:	d3 e2                	shl    %cl,%edx
  1404de:	89 d0                	mov    %edx,%eax
  1404e0:	09 45 ec             	or     %eax,-0x14(%rbp)
        for (++format; *format; ++format) {
  1404e3:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1404ea:	01 
  1404eb:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1404f2:	0f b6 00             	movzbl (%rax),%eax
  1404f5:	84 c0                	test   %al,%al
  1404f7:	75 ae                	jne    1404a7 <printer_vprintf+0x7c>
  1404f9:	eb 01                	jmp    1404fc <printer_vprintf+0xd1>
            } else {
                break;
  1404fb:	90                   	nop
            }
        }

        // process width
        int width = -1;
  1404fc:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
        if (*format >= '1' && *format <= '9') {
  140503:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  14050a:	0f b6 00             	movzbl (%rax),%eax
  14050d:	3c 30                	cmp    $0x30,%al
  14050f:	7e 67                	jle    140578 <printer_vprintf+0x14d>
  140511:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  140518:	0f b6 00             	movzbl (%rax),%eax
  14051b:	3c 39                	cmp    $0x39,%al
  14051d:	7f 59                	jg     140578 <printer_vprintf+0x14d>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  14051f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  140526:	eb 2e                	jmp    140556 <printer_vprintf+0x12b>
                width = 10 * width + *format++ - '0';
  140528:	8b 55 e8             	mov    -0x18(%rbp),%edx
  14052b:	89 d0                	mov    %edx,%eax
  14052d:	c1 e0 02             	shl    $0x2,%eax
  140530:	01 d0                	add    %edx,%eax
  140532:	01 c0                	add    %eax,%eax
  140534:	89 c1                	mov    %eax,%ecx
  140536:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  14053d:	48 8d 50 01          	lea    0x1(%rax),%rdx
  140541:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  140548:	0f b6 00             	movzbl (%rax),%eax
  14054b:	0f be c0             	movsbl %al,%eax
  14054e:	01 c8                	add    %ecx,%eax
  140550:	83 e8 30             	sub    $0x30,%eax
  140553:	89 45 e8             	mov    %eax,-0x18(%rbp)
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  140556:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  14055d:	0f b6 00             	movzbl (%rax),%eax
  140560:	3c 2f                	cmp    $0x2f,%al
  140562:	0f 8e 85 00 00 00    	jle    1405ed <printer_vprintf+0x1c2>
  140568:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  14056f:	0f b6 00             	movzbl (%rax),%eax
  140572:	3c 39                	cmp    $0x39,%al
  140574:	7e b2                	jle    140528 <printer_vprintf+0xfd>
        if (*format >= '1' && *format <= '9') {
  140576:	eb 75                	jmp    1405ed <printer_vprintf+0x1c2>
            }
        } else if (*format == '*') {
  140578:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  14057f:	0f b6 00             	movzbl (%rax),%eax
  140582:	3c 2a                	cmp    $0x2a,%al
  140584:	75 68                	jne    1405ee <printer_vprintf+0x1c3>
            width = va_arg(val, int);
  140586:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  14058d:	8b 00                	mov    (%rax),%eax
  14058f:	83 f8 2f             	cmp    $0x2f,%eax
  140592:	77 30                	ja     1405c4 <printer_vprintf+0x199>
  140594:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  14059b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  14059f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1405a6:	8b 00                	mov    (%rax),%eax
  1405a8:	89 c0                	mov    %eax,%eax
  1405aa:	48 01 d0             	add    %rdx,%rax
  1405ad:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1405b4:	8b 12                	mov    (%rdx),%edx
  1405b6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1405b9:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1405c0:	89 0a                	mov    %ecx,(%rdx)
  1405c2:	eb 1a                	jmp    1405de <printer_vprintf+0x1b3>
  1405c4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1405cb:	48 8b 40 08          	mov    0x8(%rax),%rax
  1405cf:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1405d3:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1405da:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1405de:	8b 00                	mov    (%rax),%eax
  1405e0:	89 45 e8             	mov    %eax,-0x18(%rbp)
            ++format;
  1405e3:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1405ea:	01 
  1405eb:	eb 01                	jmp    1405ee <printer_vprintf+0x1c3>
        if (*format >= '1' && *format <= '9') {
  1405ed:	90                   	nop
        }

        // process precision
        int precision = -1;
  1405ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
        if (*format == '.') {
  1405f5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1405fc:	0f b6 00             	movzbl (%rax),%eax
  1405ff:	3c 2e                	cmp    $0x2e,%al
  140601:	0f 85 00 01 00 00    	jne    140707 <printer_vprintf+0x2dc>
            ++format;
  140607:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  14060e:	01 
            if (*format >= '0' && *format <= '9') {
  14060f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  140616:	0f b6 00             	movzbl (%rax),%eax
  140619:	3c 2f                	cmp    $0x2f,%al
  14061b:	7e 67                	jle    140684 <printer_vprintf+0x259>
  14061d:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  140624:	0f b6 00             	movzbl (%rax),%eax
  140627:	3c 39                	cmp    $0x39,%al
  140629:	7f 59                	jg     140684 <printer_vprintf+0x259>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  14062b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  140632:	eb 2e                	jmp    140662 <printer_vprintf+0x237>
                    precision = 10 * precision + *format++ - '0';
  140634:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  140637:	89 d0                	mov    %edx,%eax
  140639:	c1 e0 02             	shl    $0x2,%eax
  14063c:	01 d0                	add    %edx,%eax
  14063e:	01 c0                	add    %eax,%eax
  140640:	89 c1                	mov    %eax,%ecx
  140642:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  140649:	48 8d 50 01          	lea    0x1(%rax),%rdx
  14064d:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  140654:	0f b6 00             	movzbl (%rax),%eax
  140657:	0f be c0             	movsbl %al,%eax
  14065a:	01 c8                	add    %ecx,%eax
  14065c:	83 e8 30             	sub    $0x30,%eax
  14065f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  140662:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  140669:	0f b6 00             	movzbl (%rax),%eax
  14066c:	3c 2f                	cmp    $0x2f,%al
  14066e:	0f 8e 85 00 00 00    	jle    1406f9 <printer_vprintf+0x2ce>
  140674:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  14067b:	0f b6 00             	movzbl (%rax),%eax
  14067e:	3c 39                	cmp    $0x39,%al
  140680:	7e b2                	jle    140634 <printer_vprintf+0x209>
            if (*format >= '0' && *format <= '9') {
  140682:	eb 75                	jmp    1406f9 <printer_vprintf+0x2ce>
                }
            } else if (*format == '*') {
  140684:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  14068b:	0f b6 00             	movzbl (%rax),%eax
  14068e:	3c 2a                	cmp    $0x2a,%al
  140690:	75 68                	jne    1406fa <printer_vprintf+0x2cf>
                precision = va_arg(val, int);
  140692:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140699:	8b 00                	mov    (%rax),%eax
  14069b:	83 f8 2f             	cmp    $0x2f,%eax
  14069e:	77 30                	ja     1406d0 <printer_vprintf+0x2a5>
  1406a0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1406a7:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1406ab:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1406b2:	8b 00                	mov    (%rax),%eax
  1406b4:	89 c0                	mov    %eax,%eax
  1406b6:	48 01 d0             	add    %rdx,%rax
  1406b9:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1406c0:	8b 12                	mov    (%rdx),%edx
  1406c2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1406c5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1406cc:	89 0a                	mov    %ecx,(%rdx)
  1406ce:	eb 1a                	jmp    1406ea <printer_vprintf+0x2bf>
  1406d0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1406d7:	48 8b 40 08          	mov    0x8(%rax),%rax
  1406db:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1406df:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1406e6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1406ea:	8b 00                	mov    (%rax),%eax
  1406ec:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                ++format;
  1406ef:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1406f6:	01 
  1406f7:	eb 01                	jmp    1406fa <printer_vprintf+0x2cf>
            if (*format >= '0' && *format <= '9') {
  1406f9:	90                   	nop
            }
            if (precision < 0) {
  1406fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  1406fe:	79 07                	jns    140707 <printer_vprintf+0x2dc>
                precision = 0;
  140700:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
            }
        }

        // process main conversion character
        int base = 10;
  140707:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%rbp)
        unsigned long num = 0;
  14070e:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  140715:	00 
        int length = 0;
  140716:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
        char* data = "";
  14071d:	48 c7 45 c8 f6 10 14 	movq   $0x1410f6,-0x38(%rbp)
  140724:	00 
    again:
        switch (*format) {
  140725:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  14072c:	0f b6 00             	movzbl (%rax),%eax
  14072f:	0f be c0             	movsbl %al,%eax
  140732:	83 e8 43             	sub    $0x43,%eax
  140735:	83 f8 37             	cmp    $0x37,%eax
  140738:	0f 87 9f 03 00 00    	ja     140add <printer_vprintf+0x6b2>
  14073e:	89 c0                	mov    %eax,%eax
  140740:	48 8b 04 c5 08 11 14 	mov    0x141108(,%rax,8),%rax
  140747:	00 
  140748:	ff e0                	jmp    *%rax
        case 'l':
        case 'z':
            length = 1;
  14074a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
            ++format;
  140751:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  140758:	01 
            goto again;
  140759:	eb ca                	jmp    140725 <printer_vprintf+0x2fa>
        case 'd':
        case 'i': {
            long x = length ? va_arg(val, long) : va_arg(val, int);
  14075b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  14075f:	74 5d                	je     1407be <printer_vprintf+0x393>
  140761:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140768:	8b 00                	mov    (%rax),%eax
  14076a:	83 f8 2f             	cmp    $0x2f,%eax
  14076d:	77 30                	ja     14079f <printer_vprintf+0x374>
  14076f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140776:	48 8b 50 10          	mov    0x10(%rax),%rdx
  14077a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140781:	8b 00                	mov    (%rax),%eax
  140783:	89 c0                	mov    %eax,%eax
  140785:	48 01 d0             	add    %rdx,%rax
  140788:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  14078f:	8b 12                	mov    (%rdx),%edx
  140791:	8d 4a 08             	lea    0x8(%rdx),%ecx
  140794:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  14079b:	89 0a                	mov    %ecx,(%rdx)
  14079d:	eb 1a                	jmp    1407b9 <printer_vprintf+0x38e>
  14079f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1407a6:	48 8b 40 08          	mov    0x8(%rax),%rax
  1407aa:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1407ae:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1407b5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1407b9:	48 8b 00             	mov    (%rax),%rax
  1407bc:	eb 5c                	jmp    14081a <printer_vprintf+0x3ef>
  1407be:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1407c5:	8b 00                	mov    (%rax),%eax
  1407c7:	83 f8 2f             	cmp    $0x2f,%eax
  1407ca:	77 30                	ja     1407fc <printer_vprintf+0x3d1>
  1407cc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1407d3:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1407d7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1407de:	8b 00                	mov    (%rax),%eax
  1407e0:	89 c0                	mov    %eax,%eax
  1407e2:	48 01 d0             	add    %rdx,%rax
  1407e5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1407ec:	8b 12                	mov    (%rdx),%edx
  1407ee:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1407f1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1407f8:	89 0a                	mov    %ecx,(%rdx)
  1407fa:	eb 1a                	jmp    140816 <printer_vprintf+0x3eb>
  1407fc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140803:	48 8b 40 08          	mov    0x8(%rax),%rax
  140807:	48 8d 48 08          	lea    0x8(%rax),%rcx
  14080b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  140812:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  140816:	8b 00                	mov    (%rax),%eax
  140818:	48 98                	cltq
  14081a:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  14081e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  140822:	48 c1 f8 38          	sar    $0x38,%rax
  140826:	25 80 00 00 00       	and    $0x80,%eax
  14082b:	89 45 a4             	mov    %eax,-0x5c(%rbp)
            num = negative ? -x : x;
  14082e:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  140832:	74 09                	je     14083d <printer_vprintf+0x412>
  140834:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  140838:	48 f7 d8             	neg    %rax
  14083b:	eb 04                	jmp    140841 <printer_vprintf+0x416>
  14083d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  140841:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  140845:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  140848:	83 c8 60             	or     $0x60,%eax
  14084b:	09 45 ec             	or     %eax,-0x14(%rbp)
            break;
  14084e:	e9 cf 02 00 00       	jmp    140b22 <printer_vprintf+0x6f7>
        }
        case 'u':
        format_unsigned:
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  140853:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  140857:	74 5d                	je     1408b6 <printer_vprintf+0x48b>
  140859:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140860:	8b 00                	mov    (%rax),%eax
  140862:	83 f8 2f             	cmp    $0x2f,%eax
  140865:	77 30                	ja     140897 <printer_vprintf+0x46c>
  140867:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  14086e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  140872:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140879:	8b 00                	mov    (%rax),%eax
  14087b:	89 c0                	mov    %eax,%eax
  14087d:	48 01 d0             	add    %rdx,%rax
  140880:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  140887:	8b 12                	mov    (%rdx),%edx
  140889:	8d 4a 08             	lea    0x8(%rdx),%ecx
  14088c:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  140893:	89 0a                	mov    %ecx,(%rdx)
  140895:	eb 1a                	jmp    1408b1 <printer_vprintf+0x486>
  140897:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  14089e:	48 8b 40 08          	mov    0x8(%rax),%rax
  1408a2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1408a6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1408ad:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1408b1:	48 8b 00             	mov    (%rax),%rax
  1408b4:	eb 5c                	jmp    140912 <printer_vprintf+0x4e7>
  1408b6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1408bd:	8b 00                	mov    (%rax),%eax
  1408bf:	83 f8 2f             	cmp    $0x2f,%eax
  1408c2:	77 30                	ja     1408f4 <printer_vprintf+0x4c9>
  1408c4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1408cb:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1408cf:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1408d6:	8b 00                	mov    (%rax),%eax
  1408d8:	89 c0                	mov    %eax,%eax
  1408da:	48 01 d0             	add    %rdx,%rax
  1408dd:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1408e4:	8b 12                	mov    (%rdx),%edx
  1408e6:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1408e9:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1408f0:	89 0a                	mov    %ecx,(%rdx)
  1408f2:	eb 1a                	jmp    14090e <printer_vprintf+0x4e3>
  1408f4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1408fb:	48 8b 40 08          	mov    0x8(%rax),%rax
  1408ff:	48 8d 48 08          	lea    0x8(%rax),%rcx
  140903:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  14090a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  14090e:	8b 00                	mov    (%rax),%eax
  140910:	89 c0                	mov    %eax,%eax
  140912:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC;
  140916:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
            break;
  14091a:	e9 03 02 00 00       	jmp    140b22 <printer_vprintf+0x6f7>
        case 'x':
            base = -16;
  14091f:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            goto format_unsigned;
  140926:	e9 28 ff ff ff       	jmp    140853 <printer_vprintf+0x428>
        case 'X':
            base = 16;
  14092b:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%rbp)
            goto format_unsigned;
  140932:	e9 1c ff ff ff       	jmp    140853 <printer_vprintf+0x428>
        case 'p':
            num = (uintptr_t) va_arg(val, void*);
  140937:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  14093e:	8b 00                	mov    (%rax),%eax
  140940:	83 f8 2f             	cmp    $0x2f,%eax
  140943:	77 30                	ja     140975 <printer_vprintf+0x54a>
  140945:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  14094c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  140950:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140957:	8b 00                	mov    (%rax),%eax
  140959:	89 c0                	mov    %eax,%eax
  14095b:	48 01 d0             	add    %rdx,%rax
  14095e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  140965:	8b 12                	mov    (%rdx),%edx
  140967:	8d 4a 08             	lea    0x8(%rdx),%ecx
  14096a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  140971:	89 0a                	mov    %ecx,(%rdx)
  140973:	eb 1a                	jmp    14098f <printer_vprintf+0x564>
  140975:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  14097c:	48 8b 40 08          	mov    0x8(%rax),%rax
  140980:	48 8d 48 08          	lea    0x8(%rax),%rcx
  140984:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  14098b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  14098f:	48 8b 00             	mov    (%rax),%rax
  140992:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            base = -16;
  140996:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  14099d:	81 4d ec 21 01 00 00 	orl    $0x121,-0x14(%rbp)
            break;
  1409a4:	e9 79 01 00 00       	jmp    140b22 <printer_vprintf+0x6f7>
        case 's':
            data = va_arg(val, char*);
  1409a9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1409b0:	8b 00                	mov    (%rax),%eax
  1409b2:	83 f8 2f             	cmp    $0x2f,%eax
  1409b5:	77 30                	ja     1409e7 <printer_vprintf+0x5bc>
  1409b7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1409be:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1409c2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1409c9:	8b 00                	mov    (%rax),%eax
  1409cb:	89 c0                	mov    %eax,%eax
  1409cd:	48 01 d0             	add    %rdx,%rax
  1409d0:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1409d7:	8b 12                	mov    (%rdx),%edx
  1409d9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1409dc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1409e3:	89 0a                	mov    %ecx,(%rdx)
  1409e5:	eb 1a                	jmp    140a01 <printer_vprintf+0x5d6>
  1409e7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1409ee:	48 8b 40 08          	mov    0x8(%rax),%rax
  1409f2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1409f6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1409fd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  140a01:	48 8b 00             	mov    (%rax),%rax
  140a04:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            break;
  140a08:	e9 15 01 00 00       	jmp    140b22 <printer_vprintf+0x6f7>
        case 'C':
            color = va_arg(val, int);
  140a0d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140a14:	8b 00                	mov    (%rax),%eax
  140a16:	83 f8 2f             	cmp    $0x2f,%eax
  140a19:	77 30                	ja     140a4b <printer_vprintf+0x620>
  140a1b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140a22:	48 8b 50 10          	mov    0x10(%rax),%rdx
  140a26:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140a2d:	8b 00                	mov    (%rax),%eax
  140a2f:	89 c0                	mov    %eax,%eax
  140a31:	48 01 d0             	add    %rdx,%rax
  140a34:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  140a3b:	8b 12                	mov    (%rdx),%edx
  140a3d:	8d 4a 08             	lea    0x8(%rdx),%ecx
  140a40:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  140a47:	89 0a                	mov    %ecx,(%rdx)
  140a49:	eb 1a                	jmp    140a65 <printer_vprintf+0x63a>
  140a4b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140a52:	48 8b 40 08          	mov    0x8(%rax),%rax
  140a56:	48 8d 48 08          	lea    0x8(%rax),%rcx
  140a5a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  140a61:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  140a65:	8b 00                	mov    (%rax),%eax
  140a67:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
            goto done;
  140a6d:	e9 67 03 00 00       	jmp    140dd9 <printer_vprintf+0x9ae>
        case 'c':
            data = numbuf;
  140a72:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  140a76:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = va_arg(val, int);
  140a7a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140a81:	8b 00                	mov    (%rax),%eax
  140a83:	83 f8 2f             	cmp    $0x2f,%eax
  140a86:	77 30                	ja     140ab8 <printer_vprintf+0x68d>
  140a88:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140a8f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  140a93:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140a9a:	8b 00                	mov    (%rax),%eax
  140a9c:	89 c0                	mov    %eax,%eax
  140a9e:	48 01 d0             	add    %rdx,%rax
  140aa1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  140aa8:	8b 12                	mov    (%rdx),%edx
  140aaa:	8d 4a 08             	lea    0x8(%rdx),%ecx
  140aad:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  140ab4:	89 0a                	mov    %ecx,(%rdx)
  140ab6:	eb 1a                	jmp    140ad2 <printer_vprintf+0x6a7>
  140ab8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  140abf:	48 8b 40 08          	mov    0x8(%rax),%rax
  140ac3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  140ac7:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  140ace:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  140ad2:	8b 00                	mov    (%rax),%eax
  140ad4:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  140ad7:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            break;
  140adb:	eb 45                	jmp    140b22 <printer_vprintf+0x6f7>
        default:
            data = numbuf;
  140add:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  140ae1:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = (*format ? *format : '%');
  140ae5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  140aec:	0f b6 00             	movzbl (%rax),%eax
  140aef:	84 c0                	test   %al,%al
  140af1:	74 0c                	je     140aff <printer_vprintf+0x6d4>
  140af3:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  140afa:	0f b6 00             	movzbl (%rax),%eax
  140afd:	eb 05                	jmp    140b04 <printer_vprintf+0x6d9>
  140aff:	b8 25 00 00 00       	mov    $0x25,%eax
  140b04:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  140b07:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            if (!*format) {
  140b0b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  140b12:	0f b6 00             	movzbl (%rax),%eax
  140b15:	84 c0                	test   %al,%al
  140b17:	75 08                	jne    140b21 <printer_vprintf+0x6f6>
                format--;
  140b19:	48 83 ad 68 ff ff ff 	subq   $0x1,-0x98(%rbp)
  140b20:	01 
            }
            break;
  140b21:	90                   	nop
        }

        if (flags & FLAG_NUMERIC) {
  140b22:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140b25:	83 e0 20             	and    $0x20,%eax
  140b28:	85 c0                	test   %eax,%eax
  140b2a:	74 1e                	je     140b4a <printer_vprintf+0x71f>
            data = fill_numbuf(numbuf + NUMBUFSIZ, num, base);
  140b2c:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  140b30:	48 83 c0 18          	add    $0x18,%rax
  140b34:	8b 55 e0             	mov    -0x20(%rbp),%edx
  140b37:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  140b3b:	48 89 ce             	mov    %rcx,%rsi
  140b3e:	48 89 c7             	mov    %rax,%rdi
  140b41:	e8 63 f8 ff ff       	call   1403a9 <fill_numbuf>
  140b46:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        }

        const char* prefix = "";
  140b4a:	48 c7 45 c0 f6 10 14 	movq   $0x1410f6,-0x40(%rbp)
  140b51:	00 
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  140b52:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140b55:	83 e0 20             	and    $0x20,%eax
  140b58:	85 c0                	test   %eax,%eax
  140b5a:	74 48                	je     140ba4 <printer_vprintf+0x779>
  140b5c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140b5f:	83 e0 40             	and    $0x40,%eax
  140b62:	85 c0                	test   %eax,%eax
  140b64:	74 3e                	je     140ba4 <printer_vprintf+0x779>
            if (flags & FLAG_NEGATIVE) {
  140b66:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140b69:	25 80 00 00 00       	and    $0x80,%eax
  140b6e:	85 c0                	test   %eax,%eax
  140b70:	74 0a                	je     140b7c <printer_vprintf+0x751>
                prefix = "-";
  140b72:	48 c7 45 c0 f7 10 14 	movq   $0x1410f7,-0x40(%rbp)
  140b79:	00 
            if (flags & FLAG_NEGATIVE) {
  140b7a:	eb 73                	jmp    140bef <printer_vprintf+0x7c4>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  140b7c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140b7f:	83 e0 10             	and    $0x10,%eax
  140b82:	85 c0                	test   %eax,%eax
  140b84:	74 0a                	je     140b90 <printer_vprintf+0x765>
                prefix = "+";
  140b86:	48 c7 45 c0 f9 10 14 	movq   $0x1410f9,-0x40(%rbp)
  140b8d:	00 
            if (flags & FLAG_NEGATIVE) {
  140b8e:	eb 5f                	jmp    140bef <printer_vprintf+0x7c4>
            } else if (flags & FLAG_SPACEPOSITIVE) {
  140b90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140b93:	83 e0 08             	and    $0x8,%eax
  140b96:	85 c0                	test   %eax,%eax
  140b98:	74 55                	je     140bef <printer_vprintf+0x7c4>
                prefix = " ";
  140b9a:	48 c7 45 c0 fb 10 14 	movq   $0x1410fb,-0x40(%rbp)
  140ba1:	00 
            if (flags & FLAG_NEGATIVE) {
  140ba2:	eb 4b                	jmp    140bef <printer_vprintf+0x7c4>
            }
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  140ba4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140ba7:	83 e0 20             	and    $0x20,%eax
  140baa:	85 c0                	test   %eax,%eax
  140bac:	74 42                	je     140bf0 <printer_vprintf+0x7c5>
  140bae:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140bb1:	83 e0 01             	and    $0x1,%eax
  140bb4:	85 c0                	test   %eax,%eax
  140bb6:	74 38                	je     140bf0 <printer_vprintf+0x7c5>
                   && (base == 16 || base == -16)
  140bb8:	83 7d e0 10          	cmpl   $0x10,-0x20(%rbp)
  140bbc:	74 06                	je     140bc4 <printer_vprintf+0x799>
  140bbe:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  140bc2:	75 2c                	jne    140bf0 <printer_vprintf+0x7c5>
                   && (num || (flags & FLAG_ALT2))) {
  140bc4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  140bc9:	75 0c                	jne    140bd7 <printer_vprintf+0x7ac>
  140bcb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140bce:	25 00 01 00 00       	and    $0x100,%eax
  140bd3:	85 c0                	test   %eax,%eax
  140bd5:	74 19                	je     140bf0 <printer_vprintf+0x7c5>
            prefix = (base == -16 ? "0x" : "0X");
  140bd7:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  140bdb:	75 07                	jne    140be4 <printer_vprintf+0x7b9>
  140bdd:	b8 fd 10 14 00       	mov    $0x1410fd,%eax
  140be2:	eb 05                	jmp    140be9 <printer_vprintf+0x7be>
  140be4:	b8 00 11 14 00       	mov    $0x141100,%eax
  140be9:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  140bed:	eb 01                	jmp    140bf0 <printer_vprintf+0x7c5>
            if (flags & FLAG_NEGATIVE) {
  140bef:	90                   	nop
        }

        int len;
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  140bf0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  140bf4:	78 24                	js     140c1a <printer_vprintf+0x7ef>
  140bf6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140bf9:	83 e0 20             	and    $0x20,%eax
  140bfc:	85 c0                	test   %eax,%eax
  140bfe:	75 1a                	jne    140c1a <printer_vprintf+0x7ef>
            len = strnlen(data, precision);
  140c00:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  140c03:	48 63 d0             	movslq %eax,%rdx
  140c06:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  140c0a:	48 89 d6             	mov    %rdx,%rsi
  140c0d:	48 89 c7             	mov    %rax,%rdi
  140c10:	e8 ea f5 ff ff       	call   1401ff <strnlen>
  140c15:	89 45 bc             	mov    %eax,-0x44(%rbp)
  140c18:	eb 0f                	jmp    140c29 <printer_vprintf+0x7fe>
        } else {
            len = strlen(data);
  140c1a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  140c1e:	48 89 c7             	mov    %rax,%rdi
  140c21:	e8 a8 f5 ff ff       	call   1401ce <strlen>
  140c26:	89 45 bc             	mov    %eax,-0x44(%rbp)
        }
        int zeros;
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  140c29:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140c2c:	83 e0 20             	and    $0x20,%eax
  140c2f:	85 c0                	test   %eax,%eax
  140c31:	74 20                	je     140c53 <printer_vprintf+0x828>
  140c33:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  140c37:	78 1a                	js     140c53 <printer_vprintf+0x828>
            zeros = precision > len ? precision - len : 0;
  140c39:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  140c3c:	3b 45 bc             	cmp    -0x44(%rbp),%eax
  140c3f:	7e 08                	jle    140c49 <printer_vprintf+0x81e>
  140c41:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  140c44:	2b 45 bc             	sub    -0x44(%rbp),%eax
  140c47:	eb 05                	jmp    140c4e <printer_vprintf+0x823>
  140c49:	b8 00 00 00 00       	mov    $0x0,%eax
  140c4e:	89 45 b8             	mov    %eax,-0x48(%rbp)
  140c51:	eb 5c                	jmp    140caf <printer_vprintf+0x884>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  140c53:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140c56:	83 e0 20             	and    $0x20,%eax
  140c59:	85 c0                	test   %eax,%eax
  140c5b:	74 4b                	je     140ca8 <printer_vprintf+0x87d>
  140c5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140c60:	83 e0 02             	and    $0x2,%eax
  140c63:	85 c0                	test   %eax,%eax
  140c65:	74 41                	je     140ca8 <printer_vprintf+0x87d>
                   && !(flags & FLAG_LEFTJUSTIFY)
  140c67:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140c6a:	83 e0 04             	and    $0x4,%eax
  140c6d:	85 c0                	test   %eax,%eax
  140c6f:	75 37                	jne    140ca8 <printer_vprintf+0x87d>
                   && len + (int) strlen(prefix) < width) {
  140c71:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  140c75:	48 89 c7             	mov    %rax,%rdi
  140c78:	e8 51 f5 ff ff       	call   1401ce <strlen>
  140c7d:	89 c2                	mov    %eax,%edx
  140c7f:	8b 45 bc             	mov    -0x44(%rbp),%eax
  140c82:	01 d0                	add    %edx,%eax
  140c84:	39 45 e8             	cmp    %eax,-0x18(%rbp)
  140c87:	7e 1f                	jle    140ca8 <printer_vprintf+0x87d>
            zeros = width - len - strlen(prefix);
  140c89:	8b 45 e8             	mov    -0x18(%rbp),%eax
  140c8c:	2b 45 bc             	sub    -0x44(%rbp),%eax
  140c8f:	89 c3                	mov    %eax,%ebx
  140c91:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  140c95:	48 89 c7             	mov    %rax,%rdi
  140c98:	e8 31 f5 ff ff       	call   1401ce <strlen>
  140c9d:	89 c2                	mov    %eax,%edx
  140c9f:	89 d8                	mov    %ebx,%eax
  140ca1:	29 d0                	sub    %edx,%eax
  140ca3:	89 45 b8             	mov    %eax,-0x48(%rbp)
  140ca6:	eb 07                	jmp    140caf <printer_vprintf+0x884>
        } else {
            zeros = 0;
  140ca8:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
        }
        width -= len + zeros + strlen(prefix);
  140caf:	8b 55 bc             	mov    -0x44(%rbp),%edx
  140cb2:	8b 45 b8             	mov    -0x48(%rbp),%eax
  140cb5:	01 d0                	add    %edx,%eax
  140cb7:	48 63 d8             	movslq %eax,%rbx
  140cba:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  140cbe:	48 89 c7             	mov    %rax,%rdi
  140cc1:	e8 08 f5 ff ff       	call   1401ce <strlen>
  140cc6:	48 8d 14 03          	lea    (%rbx,%rax,1),%rdx
  140cca:	8b 45 e8             	mov    -0x18(%rbp),%eax
  140ccd:	29 d0                	sub    %edx,%eax
  140ccf:	89 45 e8             	mov    %eax,-0x18(%rbp)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  140cd2:	eb 25                	jmp    140cf9 <printer_vprintf+0x8ce>
            p->putc(p, ' ', color);
  140cd4:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  140cdb:	48 8b 08             	mov    (%rax),%rcx
  140cde:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  140ce4:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  140ceb:	be 20 00 00 00       	mov    $0x20,%esi
  140cf0:	48 89 c7             	mov    %rax,%rdi
  140cf3:	ff d1                	call   *%rcx
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  140cf5:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  140cf9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140cfc:	83 e0 04             	and    $0x4,%eax
  140cff:	85 c0                	test   %eax,%eax
  140d01:	75 36                	jne    140d39 <printer_vprintf+0x90e>
  140d03:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  140d07:	7f cb                	jg     140cd4 <printer_vprintf+0x8a9>
        }
        for (; *prefix; ++prefix) {
  140d09:	eb 2e                	jmp    140d39 <printer_vprintf+0x90e>
            p->putc(p, *prefix, color);
  140d0b:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  140d12:	4c 8b 00             	mov    (%rax),%r8
  140d15:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  140d19:	0f b6 00             	movzbl (%rax),%eax
  140d1c:	0f b6 c8             	movzbl %al,%ecx
  140d1f:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  140d25:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  140d2c:	89 ce                	mov    %ecx,%esi
  140d2e:	48 89 c7             	mov    %rax,%rdi
  140d31:	41 ff d0             	call   *%r8
        for (; *prefix; ++prefix) {
  140d34:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  140d39:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  140d3d:	0f b6 00             	movzbl (%rax),%eax
  140d40:	84 c0                	test   %al,%al
  140d42:	75 c7                	jne    140d0b <printer_vprintf+0x8e0>
        }
        for (; zeros > 0; --zeros) {
  140d44:	eb 25                	jmp    140d6b <printer_vprintf+0x940>
            p->putc(p, '0', color);
  140d46:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  140d4d:	48 8b 08             	mov    (%rax),%rcx
  140d50:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  140d56:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  140d5d:	be 30 00 00 00       	mov    $0x30,%esi
  140d62:	48 89 c7             	mov    %rax,%rdi
  140d65:	ff d1                	call   *%rcx
        for (; zeros > 0; --zeros) {
  140d67:	83 6d b8 01          	subl   $0x1,-0x48(%rbp)
  140d6b:	83 7d b8 00          	cmpl   $0x0,-0x48(%rbp)
  140d6f:	7f d5                	jg     140d46 <printer_vprintf+0x91b>
        }
        for (; len > 0; ++data, --len) {
  140d71:	eb 32                	jmp    140da5 <printer_vprintf+0x97a>
            p->putc(p, *data, color);
  140d73:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  140d7a:	4c 8b 00             	mov    (%rax),%r8
  140d7d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  140d81:	0f b6 00             	movzbl (%rax),%eax
  140d84:	0f b6 c8             	movzbl %al,%ecx
  140d87:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  140d8d:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  140d94:	89 ce                	mov    %ecx,%esi
  140d96:	48 89 c7             	mov    %rax,%rdi
  140d99:	41 ff d0             	call   *%r8
        for (; len > 0; ++data, --len) {
  140d9c:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  140da1:	83 6d bc 01          	subl   $0x1,-0x44(%rbp)
  140da5:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  140da9:	7f c8                	jg     140d73 <printer_vprintf+0x948>
        }
        for (; width > 0; --width) {
  140dab:	eb 25                	jmp    140dd2 <printer_vprintf+0x9a7>
            p->putc(p, ' ', color);
  140dad:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  140db4:	48 8b 08             	mov    (%rax),%rcx
  140db7:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  140dbd:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  140dc4:	be 20 00 00 00       	mov    $0x20,%esi
  140dc9:	48 89 c7             	mov    %rax,%rdi
  140dcc:	ff d1                	call   *%rcx
        for (; width > 0; --width) {
  140dce:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  140dd2:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  140dd6:	7f d5                	jg     140dad <printer_vprintf+0x982>
        }
    done: ;
  140dd8:	90                   	nop
    for (; *format; ++format) {
  140dd9:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  140de0:	01 
  140de1:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  140de8:	0f b6 00             	movzbl (%rax),%eax
  140deb:	84 c0                	test   %al,%al
  140ded:	0f 85 64 f6 ff ff    	jne    140457 <printer_vprintf+0x2c>
    }
}
  140df3:	90                   	nop
  140df4:	90                   	nop
  140df5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  140df9:	c9                   	leave
  140dfa:	c3                   	ret

0000000000140dfb <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  140dfb:	55                   	push   %rbp
  140dfc:	48 89 e5             	mov    %rsp,%rbp
  140dff:	48 83 ec 20          	sub    $0x20,%rsp
  140e03:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  140e07:	89 f0                	mov    %esi,%eax
  140e09:	89 55 e0             	mov    %edx,-0x20(%rbp)
  140e0c:	88 45 e4             	mov    %al,-0x1c(%rbp)
    console_printer* cp = (console_printer*) p;
  140e0f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  140e13:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  140e17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  140e1b:	48 8b 40 08          	mov    0x8(%rax),%rax
  140e1f:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
  140e24:	48 39 d0             	cmp    %rdx,%rax
  140e27:	72 0c                	jb     140e35 <console_putc+0x3a>
        cp->cursor = console;
  140e29:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  140e2d:	48 c7 40 08 00 80 0b 	movq   $0xb8000,0x8(%rax)
  140e34:	00 
    }
    if (c == '\n') {
  140e35:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%rbp)
  140e39:	75 78                	jne    140eb3 <console_putc+0xb8>
        int pos = (cp->cursor - console) % 80;
  140e3b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  140e3f:	48 8b 40 08          	mov    0x8(%rax),%rax
  140e43:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  140e49:	48 d1 f8             	sar    %rax
  140e4c:	48 89 c1             	mov    %rax,%rcx
  140e4f:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  140e56:	66 66 66 
  140e59:	48 89 c8             	mov    %rcx,%rax
  140e5c:	48 f7 ea             	imul   %rdx
  140e5f:	48 c1 fa 05          	sar    $0x5,%rdx
  140e63:	48 89 c8             	mov    %rcx,%rax
  140e66:	48 c1 f8 3f          	sar    $0x3f,%rax
  140e6a:	48 29 c2             	sub    %rax,%rdx
  140e6d:	48 89 d0             	mov    %rdx,%rax
  140e70:	48 c1 e0 02          	shl    $0x2,%rax
  140e74:	48 01 d0             	add    %rdx,%rax
  140e77:	48 c1 e0 04          	shl    $0x4,%rax
  140e7b:	48 29 c1             	sub    %rax,%rcx
  140e7e:	48 89 ca             	mov    %rcx,%rdx
  140e81:	89 55 fc             	mov    %edx,-0x4(%rbp)
        for (; pos != 80; pos++) {
  140e84:	eb 25                	jmp    140eab <console_putc+0xb0>
            *cp->cursor++ = ' ' | color;
  140e86:	8b 45 e0             	mov    -0x20(%rbp),%eax
  140e89:	83 c8 20             	or     $0x20,%eax
  140e8c:	89 c6                	mov    %eax,%esi
  140e8e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  140e92:	48 8b 40 08          	mov    0x8(%rax),%rax
  140e96:	48 8d 48 02          	lea    0x2(%rax),%rcx
  140e9a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  140e9e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  140ea2:	89 f2                	mov    %esi,%edx
  140ea4:	66 89 10             	mov    %dx,(%rax)
        for (; pos != 80; pos++) {
  140ea7:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  140eab:	83 7d fc 50          	cmpl   $0x50,-0x4(%rbp)
  140eaf:	75 d5                	jne    140e86 <console_putc+0x8b>
        }
    } else {
        *cp->cursor++ = c | color;
    }
}
  140eb1:	eb 24                	jmp    140ed7 <console_putc+0xdc>
        *cp->cursor++ = c | color;
  140eb3:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
  140eb7:	8b 55 e0             	mov    -0x20(%rbp),%edx
  140eba:	09 d0                	or     %edx,%eax
  140ebc:	89 c6                	mov    %eax,%esi
  140ebe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  140ec2:	48 8b 40 08          	mov    0x8(%rax),%rax
  140ec6:	48 8d 48 02          	lea    0x2(%rax),%rcx
  140eca:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  140ece:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  140ed2:	89 f2                	mov    %esi,%edx
  140ed4:	66 89 10             	mov    %dx,(%rax)
}
  140ed7:	90                   	nop
  140ed8:	c9                   	leave
  140ed9:	c3                   	ret

0000000000140eda <console_vprintf>:

int console_vprintf(int cpos, int color, const char* format, va_list val) {
  140eda:	55                   	push   %rbp
  140edb:	48 89 e5             	mov    %rsp,%rbp
  140ede:	48 83 ec 30          	sub    $0x30,%rsp
  140ee2:	89 7d ec             	mov    %edi,-0x14(%rbp)
  140ee5:	89 75 e8             	mov    %esi,-0x18(%rbp)
  140ee8:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  140eec:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
    struct console_printer cp;
    cp.p.putc = console_putc;
  140ef0:	48 c7 45 f0 fb 0d 14 	movq   $0x140dfb,-0x10(%rbp)
  140ef7:	00 
    if (cpos < 0 || cpos >= CONSOLE_ROWS * CONSOLE_COLUMNS) {
  140ef8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  140efc:	78 09                	js     140f07 <console_vprintf+0x2d>
  140efe:	81 7d ec cf 07 00 00 	cmpl   $0x7cf,-0x14(%rbp)
  140f05:	7e 07                	jle    140f0e <console_vprintf+0x34>
        cpos = 0;
  140f07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
    cp.cursor = console + cpos;
  140f0e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  140f11:	48 98                	cltq
  140f13:	48 01 c0             	add    %rax,%rax
  140f16:	48 05 00 80 0b 00    	add    $0xb8000,%rax
  140f1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  140f20:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  140f24:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  140f28:	8b 75 e8             	mov    -0x18(%rbp),%esi
  140f2b:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  140f2f:	48 89 c7             	mov    %rax,%rdi
  140f32:	e8 f4 f4 ff ff       	call   14042b <printer_vprintf>
    return cp.cursor - console;
  140f37:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  140f3b:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  140f41:	48 d1 f8             	sar    %rax
}
  140f44:	c9                   	leave
  140f45:	c3                   	ret

0000000000140f46 <console_printf>:

int console_printf(int cpos, int color, const char* format, ...) {
  140f46:	55                   	push   %rbp
  140f47:	48 89 e5             	mov    %rsp,%rbp
  140f4a:	48 83 ec 60          	sub    $0x60,%rsp
  140f4e:	89 7d ac             	mov    %edi,-0x54(%rbp)
  140f51:	89 75 a8             	mov    %esi,-0x58(%rbp)
  140f54:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  140f58:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  140f5c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  140f60:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  140f64:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  140f6b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  140f6f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  140f73:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  140f77:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  140f7b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  140f7f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  140f83:	8b 75 a8             	mov    -0x58(%rbp),%esi
  140f86:	8b 45 ac             	mov    -0x54(%rbp),%eax
  140f89:	89 c7                	mov    %eax,%edi
  140f8b:	e8 4a ff ff ff       	call   140eda <console_vprintf>
  140f90:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
  140f93:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
  140f96:	c9                   	leave
  140f97:	c3                   	ret

0000000000140f98 <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  140f98:	55                   	push   %rbp
  140f99:	48 89 e5             	mov    %rsp,%rbp
  140f9c:	48 83 ec 20          	sub    $0x20,%rsp
  140fa0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  140fa4:	89 f0                	mov    %esi,%eax
  140fa6:	89 55 e0             	mov    %edx,-0x20(%rbp)
  140fa9:	88 45 e4             	mov    %al,-0x1c(%rbp)
    string_printer* sp = (string_printer*) p;
  140fac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  140fb0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (sp->s < sp->end) {
  140fb4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  140fb8:	48 8b 50 08          	mov    0x8(%rax),%rdx
  140fbc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  140fc0:	48 8b 40 10          	mov    0x10(%rax),%rax
  140fc4:	48 39 c2             	cmp    %rax,%rdx
  140fc7:	73 1a                	jae    140fe3 <string_putc+0x4b>
        *sp->s++ = c;
  140fc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  140fcd:	48 8b 40 08          	mov    0x8(%rax),%rax
  140fd1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  140fd5:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  140fd9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  140fdd:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
  140fe1:	88 10                	mov    %dl,(%rax)
    }
    (void) color;
}
  140fe3:	90                   	nop
  140fe4:	c9                   	leave
  140fe5:	c3                   	ret

0000000000140fe6 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  140fe6:	55                   	push   %rbp
  140fe7:	48 89 e5             	mov    %rsp,%rbp
  140fea:	48 83 ec 40          	sub    $0x40,%rsp
  140fee:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  140ff2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  140ff6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  140ffa:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    string_printer sp;
    sp.p.putc = string_putc;
  140ffe:	48 c7 45 e8 98 0f 14 	movq   $0x140f98,-0x18(%rbp)
  141005:	00 
    sp.s = s;
  141006:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  14100a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (size) {
  14100e:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  141013:	74 33                	je     141048 <vsnprintf+0x62>
        sp.end = s + size - 1;
  141015:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  141019:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  14101d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  141021:	48 01 d0             	add    %rdx,%rax
  141024:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  141028:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  14102c:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  141030:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  141034:	be 00 00 00 00       	mov    $0x0,%esi
  141039:	48 89 c7             	mov    %rax,%rdi
  14103c:	e8 ea f3 ff ff       	call   14042b <printer_vprintf>
        *sp.s = 0;
  141041:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  141045:	c6 00 00             	movb   $0x0,(%rax)
    }
    return sp.s - s;
  141048:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  14104c:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
}
  141050:	c9                   	leave
  141051:	c3                   	ret

0000000000141052 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  141052:	55                   	push   %rbp
  141053:	48 89 e5             	mov    %rsp,%rbp
  141056:	48 83 ec 70          	sub    $0x70,%rsp
  14105a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  14105e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  141062:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  141066:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  14106a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  14106e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  141072:	c7 45 b0 18 00 00 00 	movl   $0x18,-0x50(%rbp)
  141079:	48 8d 45 10          	lea    0x10(%rbp),%rax
  14107d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  141081:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  141085:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    int n = vsnprintf(s, size, format, val);
  141089:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  14108d:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  141091:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  141095:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  141099:	48 89 c7             	mov    %rax,%rdi
  14109c:	e8 45 ff ff ff       	call   140fe6 <vsnprintf>
  1410a1:	89 45 cc             	mov    %eax,-0x34(%rbp)
    va_end(val);
    return n;
  1410a4:	8b 45 cc             	mov    -0x34(%rbp),%eax
}
  1410a7:	c9                   	leave
  1410a8:	c3                   	ret

00000000001410a9 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  1410a9:	55                   	push   %rbp
  1410aa:	48 89 e5             	mov    %rsp,%rbp
  1410ad:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1410b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  1410b8:	eb 13                	jmp    1410cd <console_clear+0x24>
        console[i] = ' ' | 0x0700;
  1410ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  1410bd:	48 98                	cltq
  1410bf:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%rax,%rax,1)
  1410c6:	00 20 07 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1410c9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  1410cd:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
  1410d4:	7e e4                	jle    1410ba <console_clear+0x11>
    }
    cursorpos = 0;
  1410d6:	c7 05 1c 7f f7 ff 00 	movl   $0x0,-0x880e4(%rip)        # b8ffc <cursorpos>
  1410dd:	00 00 00 
}
  1410e0:	90                   	nop
  1410e1:	c9                   	leave
  1410e2:	c3                   	ret
