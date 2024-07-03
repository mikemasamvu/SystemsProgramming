
obj/p-forkexit.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:
// Parent program: keeps forking till infinity, never exits
// Child program: randomly forks and allocates memory
// till stack bottom is reached or runs out of memory
// after which it randomly exits or sleeps

void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	41 54                	push   %r12
  100006:	53                   	push   %rbx
  100007:	eb 02                	jmp    10000b <process_main+0xb>

// sys_yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void sys_yield(void) {
    asm volatile ("int %0" : /* no result */
  100009:	cd 32                	int    $0x32
    while (1) {
        if (rand() % ALLOC_SLOWDOWN == 0) {
  10000b:	e8 ec 03 00 00       	call   1003fc <rand>
  100010:	48 63 d0             	movslq %eax,%rdx
  100013:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  10001a:	48 c1 fa 25          	sar    $0x25,%rdx
  10001e:	89 c1                	mov    %eax,%ecx
  100020:	c1 f9 1f             	sar    $0x1f,%ecx
  100023:	29 ca                	sub    %ecx,%edx
  100025:	6b d2 64             	imul   $0x64,%edx,%edx
  100028:	39 d0                	cmp    %edx,%eax
  10002a:	75 dd                	jne    100009 <process_main+0x9>
// sys_fork()
//    Fork the current process. On success, return the child's process ID to
//    the parent, and return 0 to the child. On failure, return -1.
static inline pid_t sys_fork(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  10002c:	cd 34                	int    $0x34
            if (sys_fork() == 0) {
  10002e:	85 c0                	test   %eax,%eax
  100030:	75 d9                	jne    10000b <process_main+0xb>
    asm volatile ("int %1" : "=a" (result)
  100032:	cd 31                	int    $0x31
  100034:	89 c7                	mov    %eax,%edi
  100036:	89 c3                	mov    %eax,%ebx
            sys_yield();
        }
    }

    pid_t p = sys_getpid();
    srand(p);
  100038:	e8 fb 03 00 00       	call   100438 <srand>

    // The heap starts on the page right after the 'end' symbol,
    // whose address is the first address not allocated to process code
    // or data.
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  10003d:	b8 17 30 10 00       	mov    $0x103017,%eax
  100042:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100048:	48 89 05 b9 1f 00 00 	mov    %rax,0x1fb9(%rip)        # 102008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  10004f:	48 89 e0             	mov    %rsp,%rax

    // The bottom of the stack is the first address on the current
    // stack page (this process never needs more than one stack page).
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  100052:	48 83 e8 01          	sub    $0x1,%rax
  100056:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10005c:	48 89 05 9d 1f 00 00 	mov    %rax,0x1f9d(%rip)        # 102000 <stack_bottom>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
            heap_top += PAGESIZE;
            if (console[CPOS(24, 0)]) {
  100063:	41 bc 00 80 0b 00    	mov    $0xb8000,%r12d
  100069:	eb 13                	jmp    10007e <process_main+0x7e>
                /* clear "Out of physical memory" msg */
                console_printf(CPOS(24, 0), 0, "\n");
            }
        } else if (x == 8 * p) {
  10006b:	0f 84 8d 00 00 00    	je     1000fe <process_main+0xfe>
            if (sys_fork() == 0) {
                p = sys_getpid();
            }
        } else if (x == 8 * p + 1) {
  100071:	83 c0 01             	add    $0x1,%eax
  100074:	39 d0                	cmp    %edx,%eax
  100076:	0f 84 95 00 00 00    	je     100111 <process_main+0x111>
    asm volatile ("int %0" : /* no result */
  10007c:	cd 32                	int    $0x32
        int x = rand() % (8 * ALLOC_SLOWDOWN);
  10007e:	e8 79 03 00 00       	call   1003fc <rand>
  100083:	48 63 d0             	movslq %eax,%rdx
  100086:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  10008d:	48 c1 fa 28          	sar    $0x28,%rdx
  100091:	89 c1                	mov    %eax,%ecx
  100093:	c1 f9 1f             	sar    $0x1f,%ecx
  100096:	29 ca                	sub    %ecx,%edx
  100098:	69 ca 20 03 00 00    	imul   $0x320,%edx,%ecx
  10009e:	29 c8                	sub    %ecx,%eax
  1000a0:	89 c2                	mov    %eax,%edx
        if (x < 8 * p) {
  1000a2:	8d 04 dd 00 00 00 00 	lea    0x0(,%rbx,8),%eax
  1000a9:	39 d0                	cmp    %edx,%eax
  1000ab:	7e be                	jle    10006b <process_main+0x6b>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  1000ad:	48 8b 3d 54 1f 00 00 	mov    0x1f54(%rip),%rdi        # 102008 <heap_top>
  1000b4:	48 3b 3d 45 1f 00 00 	cmp    0x1f45(%rip),%rdi        # 102000 <stack_bottom>
  1000bb:	74 58                	je     100115 <process_main+0x115>
    asm volatile ("int %1" : "=a" (result)
  1000bd:	cd 33                	int    $0x33
  1000bf:	85 c0                	test   %eax,%eax
  1000c1:	78 52                	js     100115 <process_main+0x115>
            *heap_top = p;      /* check we have write access to new page */
  1000c3:	48 8b 05 3e 1f 00 00 	mov    0x1f3e(%rip),%rax        # 102008 <heap_top>
  1000ca:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  1000cc:	48 81 05 31 1f 00 00 	addq   $0x1000,0x1f31(%rip)        # 102008 <heap_top>
  1000d3:	00 10 00 00 
            if (console[CPOS(24, 0)]) {
  1000d7:	66 41 83 bc 24 00 0f 	cmpw   $0x0,0xf00(%r12)
  1000de:	00 00 00 
  1000e1:	74 9b                	je     10007e <process_main+0x7e>
                console_printf(CPOS(24, 0), 0, "\n");
  1000e3:	ba a0 11 10 00       	mov    $0x1011a0,%edx
  1000e8:	be 00 00 00 00       	mov    $0x0,%esi
  1000ed:	bf 80 07 00 00       	mov    $0x780,%edi
  1000f2:	b8 00 00 00 00       	mov    $0x0,%eax
  1000f7:	e8 fa 0e 00 00       	call   100ff6 <console_printf>
  1000fc:	eb 80                	jmp    10007e <process_main+0x7e>
    asm volatile ("int %1" : "=a" (result)
  1000fe:	cd 34                	int    $0x34
            if (sys_fork() == 0) {
  100100:	85 c0                	test   %eax,%eax
  100102:	0f 85 76 ff ff ff    	jne    10007e <process_main+0x7e>
    asm volatile ("int %1" : "=a" (result)
  100108:	cd 31                	int    $0x31
  10010a:	89 c3                	mov    %eax,%ebx
    return result;
  10010c:	e9 6d ff ff ff       	jmp    10007e <process_main+0x7e>

// sys_exit()
//    Exit this process. Does not return.
static inline void sys_exit(void) __attribute__((noreturn));
static inline void sys_exit(void) {
    asm volatile ("int %0" : /* no result */
  100111:	cd 35                	int    $0x35
                  : "i" (INT_SYS_EXIT)
                  : "cc", "memory");
 spinloop: goto spinloop;       // should never get here
  100113:	eb fe                	jmp    100113 <process_main+0x113>
        }
    }

    // After running out of memory
    while (1) {
        if (rand() % (2 * ALLOC_SLOWDOWN) == 0) {
  100115:	e8 e2 02 00 00       	call   1003fc <rand>
  10011a:	48 63 d0             	movslq %eax,%rdx
  10011d:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  100124:	48 c1 fa 26          	sar    $0x26,%rdx
  100128:	89 c1                	mov    %eax,%ecx
  10012a:	c1 f9 1f             	sar    $0x1f,%ecx
  10012d:	29 ca                	sub    %ecx,%edx
  10012f:	69 d2 c8 00 00 00    	imul   $0xc8,%edx,%edx
  100135:	39 d0                	cmp    %edx,%eax
  100137:	74 04                	je     10013d <process_main+0x13d>
    asm volatile ("int %0" : /* no result */
  100139:	cd 32                	int    $0x32
}
  10013b:	eb d8                	jmp    100115 <process_main+0x115>
    asm volatile ("int %0" : /* no result */
  10013d:	cd 35                	int    $0x35
 spinloop: goto spinloop;       // should never get here
  10013f:	eb fe                	jmp    10013f <process_main+0x13f>

0000000000100141 <memcpy>:


// memcpy, memmove, memset, strcmp, strlen, strnlen
//    We must provide our own implementations.

void* memcpy(void* dst, const void* src, size_t n) {
  100141:	55                   	push   %rbp
  100142:	48 89 e5             	mov    %rsp,%rbp
  100145:	48 83 ec 28          	sub    $0x28,%rsp
  100149:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  10014d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  100151:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  100155:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100159:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  10015d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100161:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  100165:	eb 1c                	jmp    100183 <memcpy+0x42>
        *d = *s;
  100167:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10016b:	0f b6 10             	movzbl (%rax),%edx
  10016e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100172:	88 10                	mov    %dl,(%rax)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  100174:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  100179:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  10017e:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  100183:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  100188:	75 dd                	jne    100167 <memcpy+0x26>
    }
    return dst;
  10018a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  10018e:	c9                   	leave
  10018f:	c3                   	ret

0000000000100190 <memmove>:

void* memmove(void* dst, const void* src, size_t n) {
  100190:	55                   	push   %rbp
  100191:	48 89 e5             	mov    %rsp,%rbp
  100194:	48 83 ec 28          	sub    $0x28,%rsp
  100198:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  10019c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1001a0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1001a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1001a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    char* d = (char*) dst;
  1001ac:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1001b0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (s < d && s + n > d) {
  1001b4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1001b8:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  1001bc:	73 6a                	jae    100228 <memmove+0x98>
  1001be:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  1001c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1001c6:	48 01 d0             	add    %rdx,%rax
  1001c9:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
  1001cd:	73 59                	jae    100228 <memmove+0x98>
        s += n, d += n;
  1001cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1001d3:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  1001d7:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1001db:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        while (n-- > 0) {
  1001df:	eb 17                	jmp    1001f8 <memmove+0x68>
            *--d = *--s;
  1001e1:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  1001e6:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
  1001eb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1001ef:	0f b6 10             	movzbl (%rax),%edx
  1001f2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1001f6:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  1001f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1001fc:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  100200:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  100204:	48 85 c0             	test   %rax,%rax
  100207:	75 d8                	jne    1001e1 <memmove+0x51>
    if (s < d && s + n > d) {
  100209:	eb 2e                	jmp    100239 <memmove+0xa9>
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
  10020b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  10020f:	48 8d 42 01          	lea    0x1(%rdx),%rax
  100213:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  100217:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10021b:	48 8d 48 01          	lea    0x1(%rax),%rcx
  10021f:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  100223:	0f b6 12             	movzbl (%rdx),%edx
  100226:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  100228:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  10022c:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  100230:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  100234:	48 85 c0             	test   %rax,%rax
  100237:	75 d2                	jne    10020b <memmove+0x7b>
        }
    }
    return dst;
  100239:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  10023d:	c9                   	leave
  10023e:	c3                   	ret

000000000010023f <memset>:

void* memset(void* v, int c, size_t n) {
  10023f:	55                   	push   %rbp
  100240:	48 89 e5             	mov    %rsp,%rbp
  100243:	48 83 ec 28          	sub    $0x28,%rsp
  100247:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  10024b:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  10024e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100252:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100256:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  10025a:	eb 15                	jmp    100271 <memset+0x32>
        *p = c;
  10025c:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  10025f:	89 c2                	mov    %eax,%edx
  100261:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100265:	88 10                	mov    %dl,(%rax)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100267:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  10026c:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  100271:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  100276:	75 e4                	jne    10025c <memset+0x1d>
    }
    return v;
  100278:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  10027c:	c9                   	leave
  10027d:	c3                   	ret

000000000010027e <strlen>:

size_t strlen(const char* s) {
  10027e:	55                   	push   %rbp
  10027f:	48 89 e5             	mov    %rsp,%rbp
  100282:	48 83 ec 18          	sub    $0x18,%rsp
  100286:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
  10028a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  100291:	00 
  100292:	eb 0a                	jmp    10029e <strlen+0x20>
        ++n;
  100294:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; *s != '\0'; ++s) {
  100299:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  10029e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1002a2:	0f b6 00             	movzbl (%rax),%eax
  1002a5:	84 c0                	test   %al,%al
  1002a7:	75 eb                	jne    100294 <strlen+0x16>
    }
    return n;
  1002a9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  1002ad:	c9                   	leave
  1002ae:	c3                   	ret

00000000001002af <strnlen>:

size_t strnlen(const char* s, size_t maxlen) {
  1002af:	55                   	push   %rbp
  1002b0:	48 89 e5             	mov    %rsp,%rbp
  1002b3:	48 83 ec 20          	sub    $0x20,%rsp
  1002b7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1002bb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    size_t n;
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1002bf:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  1002c6:	00 
  1002c7:	eb 0a                	jmp    1002d3 <strnlen+0x24>
        ++n;
  1002c9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1002ce:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  1002d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1002d7:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  1002db:	74 0b                	je     1002e8 <strnlen+0x39>
  1002dd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1002e1:	0f b6 00             	movzbl (%rax),%eax
  1002e4:	84 c0                	test   %al,%al
  1002e6:	75 e1                	jne    1002c9 <strnlen+0x1a>
    }
    return n;
  1002e8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  1002ec:	c9                   	leave
  1002ed:	c3                   	ret

00000000001002ee <strcpy>:

char* strcpy(char* dst, const char* src) {
  1002ee:	55                   	push   %rbp
  1002ef:	48 89 e5             	mov    %rsp,%rbp
  1002f2:	48 83 ec 20          	sub    $0x20,%rsp
  1002f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1002fa:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    char* d = dst;
  1002fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100302:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    do {
        *d++ = *src++;
  100306:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  10030a:	48 8d 42 01          	lea    0x1(%rdx),%rax
  10030e:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  100312:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100316:	48 8d 48 01          	lea    0x1(%rax),%rcx
  10031a:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
  10031e:	0f b6 12             	movzbl (%rdx),%edx
  100321:	88 10                	mov    %dl,(%rax)
    } while (d[-1]);
  100323:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100327:	48 83 e8 01          	sub    $0x1,%rax
  10032b:	0f b6 00             	movzbl (%rax),%eax
  10032e:	84 c0                	test   %al,%al
  100330:	75 d4                	jne    100306 <strcpy+0x18>
    return dst;
  100332:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  100336:	c9                   	leave
  100337:	c3                   	ret

0000000000100338 <strcmp>:

int strcmp(const char* a, const char* b) {
  100338:	55                   	push   %rbp
  100339:	48 89 e5             	mov    %rsp,%rbp
  10033c:	48 83 ec 10          	sub    $0x10,%rsp
  100340:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  100344:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  100348:	eb 0a                	jmp    100354 <strcmp+0x1c>
        ++a, ++b;
  10034a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  10034f:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  100354:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100358:	0f b6 00             	movzbl (%rax),%eax
  10035b:	84 c0                	test   %al,%al
  10035d:	74 1d                	je     10037c <strcmp+0x44>
  10035f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100363:	0f b6 00             	movzbl (%rax),%eax
  100366:	84 c0                	test   %al,%al
  100368:	74 12                	je     10037c <strcmp+0x44>
  10036a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10036e:	0f b6 10             	movzbl (%rax),%edx
  100371:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100375:	0f b6 00             	movzbl (%rax),%eax
  100378:	38 c2                	cmp    %al,%dl
  10037a:	74 ce                	je     10034a <strcmp+0x12>
    }
    return ((unsigned char) *a > (unsigned char) *b)
  10037c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100380:	0f b6 00             	movzbl (%rax),%eax
  100383:	89 c2                	mov    %eax,%edx
  100385:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100389:	0f b6 00             	movzbl (%rax),%eax
  10038c:	38 d0                	cmp    %dl,%al
  10038e:	0f 92 c0             	setb   %al
  100391:	0f b6 d0             	movzbl %al,%edx
        - ((unsigned char) *a < (unsigned char) *b);
  100394:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100398:	0f b6 00             	movzbl (%rax),%eax
  10039b:	89 c1                	mov    %eax,%ecx
  10039d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1003a1:	0f b6 00             	movzbl (%rax),%eax
  1003a4:	38 c1                	cmp    %al,%cl
  1003a6:	0f 92 c0             	setb   %al
  1003a9:	0f b6 c0             	movzbl %al,%eax
  1003ac:	29 c2                	sub    %eax,%edx
  1003ae:	89 d0                	mov    %edx,%eax
}
  1003b0:	c9                   	leave
  1003b1:	c3                   	ret

00000000001003b2 <strchr>:

char* strchr(const char* s, int c) {
  1003b2:	55                   	push   %rbp
  1003b3:	48 89 e5             	mov    %rsp,%rbp
  1003b6:	48 83 ec 10          	sub    $0x10,%rsp
  1003ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  1003be:	89 75 f4             	mov    %esi,-0xc(%rbp)
    while (*s && *s != (char) c) {
  1003c1:	eb 05                	jmp    1003c8 <strchr+0x16>
        ++s;
  1003c3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while (*s && *s != (char) c) {
  1003c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1003cc:	0f b6 00             	movzbl (%rax),%eax
  1003cf:	84 c0                	test   %al,%al
  1003d1:	74 0e                	je     1003e1 <strchr+0x2f>
  1003d3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1003d7:	0f b6 00             	movzbl (%rax),%eax
  1003da:	8b 55 f4             	mov    -0xc(%rbp),%edx
  1003dd:	38 d0                	cmp    %dl,%al
  1003df:	75 e2                	jne    1003c3 <strchr+0x11>
    }
    if (*s == (char) c) {
  1003e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1003e5:	0f b6 00             	movzbl (%rax),%eax
  1003e8:	8b 55 f4             	mov    -0xc(%rbp),%edx
  1003eb:	38 d0                	cmp    %dl,%al
  1003ed:	75 06                	jne    1003f5 <strchr+0x43>
        return (char*) s;
  1003ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1003f3:	eb 05                	jmp    1003fa <strchr+0x48>
    } else {
        return NULL;
  1003f5:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
  1003fa:	c9                   	leave
  1003fb:	c3                   	ret

00000000001003fc <rand>:
// rand, srand

static int rand_seed_set;
static unsigned rand_seed;

int rand(void) {
  1003fc:	55                   	push   %rbp
  1003fd:	48 89 e5             	mov    %rsp,%rbp
    if (!rand_seed_set) {
  100400:	8b 05 0a 1c 00 00    	mov    0x1c0a(%rip),%eax        # 102010 <rand_seed_set>
  100406:	85 c0                	test   %eax,%eax
  100408:	75 0a                	jne    100414 <rand+0x18>
        srand(819234718U);
  10040a:	bf 9e 87 d4 30       	mov    $0x30d4879e,%edi
  10040f:	e8 24 00 00 00       	call   100438 <srand>
    }
    rand_seed = rand_seed * 1664525U + 1013904223U;
  100414:	8b 05 fa 1b 00 00    	mov    0x1bfa(%rip),%eax        # 102014 <rand_seed>
  10041a:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
  100420:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  100425:	89 05 e9 1b 00 00    	mov    %eax,0x1be9(%rip)        # 102014 <rand_seed>
    return rand_seed & RAND_MAX;
  10042b:	8b 05 e3 1b 00 00    	mov    0x1be3(%rip),%eax        # 102014 <rand_seed>
  100431:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  100436:	5d                   	pop    %rbp
  100437:	c3                   	ret

0000000000100438 <srand>:

void srand(unsigned seed) {
  100438:	55                   	push   %rbp
  100439:	48 89 e5             	mov    %rsp,%rbp
  10043c:	48 83 ec 08          	sub    $0x8,%rsp
  100440:	89 7d fc             	mov    %edi,-0x4(%rbp)
    rand_seed = seed;
  100443:	8b 45 fc             	mov    -0x4(%rbp),%eax
  100446:	89 05 c8 1b 00 00    	mov    %eax,0x1bc8(%rip)        # 102014 <rand_seed>
    rand_seed_set = 1;
  10044c:	c7 05 ba 1b 00 00 01 	movl   $0x1,0x1bba(%rip)        # 102010 <rand_seed_set>
  100453:	00 00 00 
}
  100456:	90                   	nop
  100457:	c9                   	leave
  100458:	c3                   	ret

0000000000100459 <fill_numbuf>:
//    Print a message onto the console, starting at the given cursor position.

// snprintf, vsnprintf
//    Format a string into a buffer.

static char* fill_numbuf(char* numbuf_end, unsigned long val, int base) {
  100459:	55                   	push   %rbp
  10045a:	48 89 e5             	mov    %rsp,%rbp
  10045d:	48 83 ec 28          	sub    $0x28,%rsp
  100461:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  100465:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  100469:	89 55 dc             	mov    %edx,-0x24(%rbp)
    static const char upper_digits[] = "0123456789ABCDEF";
    static const char lower_digits[] = "0123456789abcdef";

    const char* digits = upper_digits;
  10046c:	48 c7 45 f8 90 13 10 	movq   $0x101390,-0x8(%rbp)
  100473:	00 
    if (base < 0) {
  100474:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  100478:	79 0b                	jns    100485 <fill_numbuf+0x2c>
        digits = lower_digits;
  10047a:	48 c7 45 f8 b0 13 10 	movq   $0x1013b0,-0x8(%rbp)
  100481:	00 
        base = -base;
  100482:	f7 5d dc             	negl   -0x24(%rbp)
    }

    *--numbuf_end = '\0';
  100485:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  10048a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  10048e:	c6 00 00             	movb   $0x0,(%rax)
    do {
        *--numbuf_end = digits[val % base];
  100491:	8b 45 dc             	mov    -0x24(%rbp),%eax
  100494:	48 63 c8             	movslq %eax,%rcx
  100497:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  10049b:	ba 00 00 00 00       	mov    $0x0,%edx
  1004a0:	48 f7 f1             	div    %rcx
  1004a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1004a7:	48 01 d0             	add    %rdx,%rax
  1004aa:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  1004af:	0f b6 10             	movzbl (%rax),%edx
  1004b2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1004b6:	88 10                	mov    %dl,(%rax)
        val /= base;
  1004b8:	8b 45 dc             	mov    -0x24(%rbp),%eax
  1004bb:	48 63 f0             	movslq %eax,%rsi
  1004be:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1004c2:	ba 00 00 00 00       	mov    $0x0,%edx
  1004c7:	48 f7 f6             	div    %rsi
  1004ca:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    } while (val != 0);
  1004ce:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  1004d3:	75 bc                	jne    100491 <fill_numbuf+0x38>
    return numbuf_end;
  1004d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1004d9:	c9                   	leave
  1004da:	c3                   	ret

00000000001004db <printer_vprintf>:
#define FLAG_NUMERIC            (1<<5)
#define FLAG_SIGNED             (1<<6)
#define FLAG_NEGATIVE           (1<<7)
#define FLAG_ALT2               (1<<8)

void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1004db:	55                   	push   %rbp
  1004dc:	48 89 e5             	mov    %rsp,%rbp
  1004df:	53                   	push   %rbx
  1004e0:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  1004e7:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
  1004ee:	89 b5 74 ff ff ff    	mov    %esi,-0x8c(%rbp)
  1004f4:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  1004fb:	48 89 8d 60 ff ff ff 	mov    %rcx,-0xa0(%rbp)
#define NUMBUFSIZ 24
    char numbuf[NUMBUFSIZ];

    for (; *format; ++format) {
  100502:	e9 8a 09 00 00       	jmp    100e91 <printer_vprintf+0x9b6>
        if (*format != '%') {
  100507:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10050e:	0f b6 00             	movzbl (%rax),%eax
  100511:	3c 25                	cmp    $0x25,%al
  100513:	74 31                	je     100546 <printer_vprintf+0x6b>
            p->putc(p, *format, color);
  100515:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  10051c:	4c 8b 00             	mov    (%rax),%r8
  10051f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100526:	0f b6 00             	movzbl (%rax),%eax
  100529:	0f b6 c8             	movzbl %al,%ecx
  10052c:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100532:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100539:	89 ce                	mov    %ecx,%esi
  10053b:	48 89 c7             	mov    %rax,%rdi
  10053e:	41 ff d0             	call   *%r8
            continue;
  100541:	e9 43 09 00 00       	jmp    100e89 <printer_vprintf+0x9ae>
        }

        // process flags
        int flags = 0;
  100546:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        for (++format; *format; ++format) {
  10054d:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100554:	01 
  100555:	eb 44                	jmp    10059b <printer_vprintf+0xc0>
            const char* flagc = strchr(flag_chars, *format);
  100557:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10055e:	0f b6 00             	movzbl (%rax),%eax
  100561:	0f be c0             	movsbl %al,%eax
  100564:	89 c6                	mov    %eax,%esi
  100566:	bf b0 11 10 00       	mov    $0x1011b0,%edi
  10056b:	e8 42 fe ff ff       	call   1003b2 <strchr>
  100570:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (flagc) {
  100574:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  100579:	74 30                	je     1005ab <printer_vprintf+0xd0>
                flags |= 1 << (flagc - flag_chars);
  10057b:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  10057f:	48 2d b0 11 10 00    	sub    $0x1011b0,%rax
  100585:	ba 01 00 00 00       	mov    $0x1,%edx
  10058a:	89 c1                	mov    %eax,%ecx
  10058c:	d3 e2                	shl    %cl,%edx
  10058e:	89 d0                	mov    %edx,%eax
  100590:	09 45 ec             	or     %eax,-0x14(%rbp)
        for (++format; *format; ++format) {
  100593:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  10059a:	01 
  10059b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1005a2:	0f b6 00             	movzbl (%rax),%eax
  1005a5:	84 c0                	test   %al,%al
  1005a7:	75 ae                	jne    100557 <printer_vprintf+0x7c>
  1005a9:	eb 01                	jmp    1005ac <printer_vprintf+0xd1>
            } else {
                break;
  1005ab:	90                   	nop
            }
        }

        // process width
        int width = -1;
  1005ac:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
        if (*format >= '1' && *format <= '9') {
  1005b3:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1005ba:	0f b6 00             	movzbl (%rax),%eax
  1005bd:	3c 30                	cmp    $0x30,%al
  1005bf:	7e 67                	jle    100628 <printer_vprintf+0x14d>
  1005c1:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1005c8:	0f b6 00             	movzbl (%rax),%eax
  1005cb:	3c 39                	cmp    $0x39,%al
  1005cd:	7f 59                	jg     100628 <printer_vprintf+0x14d>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1005cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  1005d6:	eb 2e                	jmp    100606 <printer_vprintf+0x12b>
                width = 10 * width + *format++ - '0';
  1005d8:	8b 55 e8             	mov    -0x18(%rbp),%edx
  1005db:	89 d0                	mov    %edx,%eax
  1005dd:	c1 e0 02             	shl    $0x2,%eax
  1005e0:	01 d0                	add    %edx,%eax
  1005e2:	01 c0                	add    %eax,%eax
  1005e4:	89 c1                	mov    %eax,%ecx
  1005e6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1005ed:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1005f1:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  1005f8:	0f b6 00             	movzbl (%rax),%eax
  1005fb:	0f be c0             	movsbl %al,%eax
  1005fe:	01 c8                	add    %ecx,%eax
  100600:	83 e8 30             	sub    $0x30,%eax
  100603:	89 45 e8             	mov    %eax,-0x18(%rbp)
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100606:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10060d:	0f b6 00             	movzbl (%rax),%eax
  100610:	3c 2f                	cmp    $0x2f,%al
  100612:	0f 8e 85 00 00 00    	jle    10069d <printer_vprintf+0x1c2>
  100618:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10061f:	0f b6 00             	movzbl (%rax),%eax
  100622:	3c 39                	cmp    $0x39,%al
  100624:	7e b2                	jle    1005d8 <printer_vprintf+0xfd>
        if (*format >= '1' && *format <= '9') {
  100626:	eb 75                	jmp    10069d <printer_vprintf+0x1c2>
            }
        } else if (*format == '*') {
  100628:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10062f:	0f b6 00             	movzbl (%rax),%eax
  100632:	3c 2a                	cmp    $0x2a,%al
  100634:	75 68                	jne    10069e <printer_vprintf+0x1c3>
            width = va_arg(val, int);
  100636:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10063d:	8b 00                	mov    (%rax),%eax
  10063f:	83 f8 2f             	cmp    $0x2f,%eax
  100642:	77 30                	ja     100674 <printer_vprintf+0x199>
  100644:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10064b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  10064f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100656:	8b 00                	mov    (%rax),%eax
  100658:	89 c0                	mov    %eax,%eax
  10065a:	48 01 d0             	add    %rdx,%rax
  10065d:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100664:	8b 12                	mov    (%rdx),%edx
  100666:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100669:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100670:	89 0a                	mov    %ecx,(%rdx)
  100672:	eb 1a                	jmp    10068e <printer_vprintf+0x1b3>
  100674:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10067b:	48 8b 40 08          	mov    0x8(%rax),%rax
  10067f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100683:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10068a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  10068e:	8b 00                	mov    (%rax),%eax
  100690:	89 45 e8             	mov    %eax,-0x18(%rbp)
            ++format;
  100693:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  10069a:	01 
  10069b:	eb 01                	jmp    10069e <printer_vprintf+0x1c3>
        if (*format >= '1' && *format <= '9') {
  10069d:	90                   	nop
        }

        // process precision
        int precision = -1;
  10069e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
        if (*format == '.') {
  1006a5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1006ac:	0f b6 00             	movzbl (%rax),%eax
  1006af:	3c 2e                	cmp    $0x2e,%al
  1006b1:	0f 85 00 01 00 00    	jne    1007b7 <printer_vprintf+0x2dc>
            ++format;
  1006b7:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1006be:	01 
            if (*format >= '0' && *format <= '9') {
  1006bf:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1006c6:	0f b6 00             	movzbl (%rax),%eax
  1006c9:	3c 2f                	cmp    $0x2f,%al
  1006cb:	7e 67                	jle    100734 <printer_vprintf+0x259>
  1006cd:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1006d4:	0f b6 00             	movzbl (%rax),%eax
  1006d7:	3c 39                	cmp    $0x39,%al
  1006d9:	7f 59                	jg     100734 <printer_vprintf+0x259>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1006db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  1006e2:	eb 2e                	jmp    100712 <printer_vprintf+0x237>
                    precision = 10 * precision + *format++ - '0';
  1006e4:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  1006e7:	89 d0                	mov    %edx,%eax
  1006e9:	c1 e0 02             	shl    $0x2,%eax
  1006ec:	01 d0                	add    %edx,%eax
  1006ee:	01 c0                	add    %eax,%eax
  1006f0:	89 c1                	mov    %eax,%ecx
  1006f2:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1006f9:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1006fd:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  100704:	0f b6 00             	movzbl (%rax),%eax
  100707:	0f be c0             	movsbl %al,%eax
  10070a:	01 c8                	add    %ecx,%eax
  10070c:	83 e8 30             	sub    $0x30,%eax
  10070f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100712:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100719:	0f b6 00             	movzbl (%rax),%eax
  10071c:	3c 2f                	cmp    $0x2f,%al
  10071e:	0f 8e 85 00 00 00    	jle    1007a9 <printer_vprintf+0x2ce>
  100724:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10072b:	0f b6 00             	movzbl (%rax),%eax
  10072e:	3c 39                	cmp    $0x39,%al
  100730:	7e b2                	jle    1006e4 <printer_vprintf+0x209>
            if (*format >= '0' && *format <= '9') {
  100732:	eb 75                	jmp    1007a9 <printer_vprintf+0x2ce>
                }
            } else if (*format == '*') {
  100734:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10073b:	0f b6 00             	movzbl (%rax),%eax
  10073e:	3c 2a                	cmp    $0x2a,%al
  100740:	75 68                	jne    1007aa <printer_vprintf+0x2cf>
                precision = va_arg(val, int);
  100742:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100749:	8b 00                	mov    (%rax),%eax
  10074b:	83 f8 2f             	cmp    $0x2f,%eax
  10074e:	77 30                	ja     100780 <printer_vprintf+0x2a5>
  100750:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100757:	48 8b 50 10          	mov    0x10(%rax),%rdx
  10075b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100762:	8b 00                	mov    (%rax),%eax
  100764:	89 c0                	mov    %eax,%eax
  100766:	48 01 d0             	add    %rdx,%rax
  100769:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100770:	8b 12                	mov    (%rdx),%edx
  100772:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100775:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10077c:	89 0a                	mov    %ecx,(%rdx)
  10077e:	eb 1a                	jmp    10079a <printer_vprintf+0x2bf>
  100780:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100787:	48 8b 40 08          	mov    0x8(%rax),%rax
  10078b:	48 8d 48 08          	lea    0x8(%rax),%rcx
  10078f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100796:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  10079a:	8b 00                	mov    (%rax),%eax
  10079c:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                ++format;
  10079f:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1007a6:	01 
  1007a7:	eb 01                	jmp    1007aa <printer_vprintf+0x2cf>
            if (*format >= '0' && *format <= '9') {
  1007a9:	90                   	nop
            }
            if (precision < 0) {
  1007aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  1007ae:	79 07                	jns    1007b7 <printer_vprintf+0x2dc>
                precision = 0;
  1007b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
            }
        }

        // process main conversion character
        int base = 10;
  1007b7:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%rbp)
        unsigned long num = 0;
  1007be:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  1007c5:	00 
        int length = 0;
  1007c6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
        char* data = "";
  1007cd:	48 c7 45 c8 b6 11 10 	movq   $0x1011b6,-0x38(%rbp)
  1007d4:	00 
    again:
        switch (*format) {
  1007d5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1007dc:	0f b6 00             	movzbl (%rax),%eax
  1007df:	0f be c0             	movsbl %al,%eax
  1007e2:	83 e8 43             	sub    $0x43,%eax
  1007e5:	83 f8 37             	cmp    $0x37,%eax
  1007e8:	0f 87 9f 03 00 00    	ja     100b8d <printer_vprintf+0x6b2>
  1007ee:	89 c0                	mov    %eax,%eax
  1007f0:	48 8b 04 c5 c8 11 10 	mov    0x1011c8(,%rax,8),%rax
  1007f7:	00 
  1007f8:	ff e0                	jmp    *%rax
        case 'l':
        case 'z':
            length = 1;
  1007fa:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
            ++format;
  100801:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100808:	01 
            goto again;
  100809:	eb ca                	jmp    1007d5 <printer_vprintf+0x2fa>
        case 'd':
        case 'i': {
            long x = length ? va_arg(val, long) : va_arg(val, int);
  10080b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  10080f:	74 5d                	je     10086e <printer_vprintf+0x393>
  100811:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100818:	8b 00                	mov    (%rax),%eax
  10081a:	83 f8 2f             	cmp    $0x2f,%eax
  10081d:	77 30                	ja     10084f <printer_vprintf+0x374>
  10081f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100826:	48 8b 50 10          	mov    0x10(%rax),%rdx
  10082a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100831:	8b 00                	mov    (%rax),%eax
  100833:	89 c0                	mov    %eax,%eax
  100835:	48 01 d0             	add    %rdx,%rax
  100838:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10083f:	8b 12                	mov    (%rdx),%edx
  100841:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100844:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10084b:	89 0a                	mov    %ecx,(%rdx)
  10084d:	eb 1a                	jmp    100869 <printer_vprintf+0x38e>
  10084f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100856:	48 8b 40 08          	mov    0x8(%rax),%rax
  10085a:	48 8d 48 08          	lea    0x8(%rax),%rcx
  10085e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100865:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100869:	48 8b 00             	mov    (%rax),%rax
  10086c:	eb 5c                	jmp    1008ca <printer_vprintf+0x3ef>
  10086e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100875:	8b 00                	mov    (%rax),%eax
  100877:	83 f8 2f             	cmp    $0x2f,%eax
  10087a:	77 30                	ja     1008ac <printer_vprintf+0x3d1>
  10087c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100883:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100887:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10088e:	8b 00                	mov    (%rax),%eax
  100890:	89 c0                	mov    %eax,%eax
  100892:	48 01 d0             	add    %rdx,%rax
  100895:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10089c:	8b 12                	mov    (%rdx),%edx
  10089e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1008a1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1008a8:	89 0a                	mov    %ecx,(%rdx)
  1008aa:	eb 1a                	jmp    1008c6 <printer_vprintf+0x3eb>
  1008ac:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008b3:	48 8b 40 08          	mov    0x8(%rax),%rax
  1008b7:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1008bb:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1008c2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1008c6:	8b 00                	mov    (%rax),%eax
  1008c8:	48 98                	cltq
  1008ca:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1008ce:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1008d2:	48 c1 f8 38          	sar    $0x38,%rax
  1008d6:	25 80 00 00 00       	and    $0x80,%eax
  1008db:	89 45 a4             	mov    %eax,-0x5c(%rbp)
            num = negative ? -x : x;
  1008de:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  1008e2:	74 09                	je     1008ed <printer_vprintf+0x412>
  1008e4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1008e8:	48 f7 d8             	neg    %rax
  1008eb:	eb 04                	jmp    1008f1 <printer_vprintf+0x416>
  1008ed:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1008f1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1008f5:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  1008f8:	83 c8 60             	or     $0x60,%eax
  1008fb:	09 45 ec             	or     %eax,-0x14(%rbp)
            break;
  1008fe:	e9 cf 02 00 00       	jmp    100bd2 <printer_vprintf+0x6f7>
        }
        case 'u':
        format_unsigned:
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100903:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  100907:	74 5d                	je     100966 <printer_vprintf+0x48b>
  100909:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100910:	8b 00                	mov    (%rax),%eax
  100912:	83 f8 2f             	cmp    $0x2f,%eax
  100915:	77 30                	ja     100947 <printer_vprintf+0x46c>
  100917:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10091e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100922:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100929:	8b 00                	mov    (%rax),%eax
  10092b:	89 c0                	mov    %eax,%eax
  10092d:	48 01 d0             	add    %rdx,%rax
  100930:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100937:	8b 12                	mov    (%rdx),%edx
  100939:	8d 4a 08             	lea    0x8(%rdx),%ecx
  10093c:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100943:	89 0a                	mov    %ecx,(%rdx)
  100945:	eb 1a                	jmp    100961 <printer_vprintf+0x486>
  100947:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10094e:	48 8b 40 08          	mov    0x8(%rax),%rax
  100952:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100956:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10095d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100961:	48 8b 00             	mov    (%rax),%rax
  100964:	eb 5c                	jmp    1009c2 <printer_vprintf+0x4e7>
  100966:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10096d:	8b 00                	mov    (%rax),%eax
  10096f:	83 f8 2f             	cmp    $0x2f,%eax
  100972:	77 30                	ja     1009a4 <printer_vprintf+0x4c9>
  100974:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10097b:	48 8b 50 10          	mov    0x10(%rax),%rdx
  10097f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100986:	8b 00                	mov    (%rax),%eax
  100988:	89 c0                	mov    %eax,%eax
  10098a:	48 01 d0             	add    %rdx,%rax
  10098d:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100994:	8b 12                	mov    (%rdx),%edx
  100996:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100999:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009a0:	89 0a                	mov    %ecx,(%rdx)
  1009a2:	eb 1a                	jmp    1009be <printer_vprintf+0x4e3>
  1009a4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009ab:	48 8b 40 08          	mov    0x8(%rax),%rax
  1009af:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1009b3:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009ba:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1009be:	8b 00                	mov    (%rax),%eax
  1009c0:	89 c0                	mov    %eax,%eax
  1009c2:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC;
  1009c6:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
            break;
  1009ca:	e9 03 02 00 00       	jmp    100bd2 <printer_vprintf+0x6f7>
        case 'x':
            base = -16;
  1009cf:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            goto format_unsigned;
  1009d6:	e9 28 ff ff ff       	jmp    100903 <printer_vprintf+0x428>
        case 'X':
            base = 16;
  1009db:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%rbp)
            goto format_unsigned;
  1009e2:	e9 1c ff ff ff       	jmp    100903 <printer_vprintf+0x428>
        case 'p':
            num = (uintptr_t) va_arg(val, void*);
  1009e7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009ee:	8b 00                	mov    (%rax),%eax
  1009f0:	83 f8 2f             	cmp    $0x2f,%eax
  1009f3:	77 30                	ja     100a25 <printer_vprintf+0x54a>
  1009f5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009fc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100a00:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a07:	8b 00                	mov    (%rax),%eax
  100a09:	89 c0                	mov    %eax,%eax
  100a0b:	48 01 d0             	add    %rdx,%rax
  100a0e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a15:	8b 12                	mov    (%rdx),%edx
  100a17:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100a1a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a21:	89 0a                	mov    %ecx,(%rdx)
  100a23:	eb 1a                	jmp    100a3f <printer_vprintf+0x564>
  100a25:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a2c:	48 8b 40 08          	mov    0x8(%rax),%rax
  100a30:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100a34:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a3b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100a3f:	48 8b 00             	mov    (%rax),%rax
  100a42:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            base = -16;
  100a46:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  100a4d:	81 4d ec 21 01 00 00 	orl    $0x121,-0x14(%rbp)
            break;
  100a54:	e9 79 01 00 00       	jmp    100bd2 <printer_vprintf+0x6f7>
        case 's':
            data = va_arg(val, char*);
  100a59:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a60:	8b 00                	mov    (%rax),%eax
  100a62:	83 f8 2f             	cmp    $0x2f,%eax
  100a65:	77 30                	ja     100a97 <printer_vprintf+0x5bc>
  100a67:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a6e:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100a72:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a79:	8b 00                	mov    (%rax),%eax
  100a7b:	89 c0                	mov    %eax,%eax
  100a7d:	48 01 d0             	add    %rdx,%rax
  100a80:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a87:	8b 12                	mov    (%rdx),%edx
  100a89:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100a8c:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a93:	89 0a                	mov    %ecx,(%rdx)
  100a95:	eb 1a                	jmp    100ab1 <printer_vprintf+0x5d6>
  100a97:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a9e:	48 8b 40 08          	mov    0x8(%rax),%rax
  100aa2:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100aa6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100aad:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100ab1:	48 8b 00             	mov    (%rax),%rax
  100ab4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            break;
  100ab8:	e9 15 01 00 00       	jmp    100bd2 <printer_vprintf+0x6f7>
        case 'C':
            color = va_arg(val, int);
  100abd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ac4:	8b 00                	mov    (%rax),%eax
  100ac6:	83 f8 2f             	cmp    $0x2f,%eax
  100ac9:	77 30                	ja     100afb <printer_vprintf+0x620>
  100acb:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ad2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100ad6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100add:	8b 00                	mov    (%rax),%eax
  100adf:	89 c0                	mov    %eax,%eax
  100ae1:	48 01 d0             	add    %rdx,%rax
  100ae4:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100aeb:	8b 12                	mov    (%rdx),%edx
  100aed:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100af0:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100af7:	89 0a                	mov    %ecx,(%rdx)
  100af9:	eb 1a                	jmp    100b15 <printer_vprintf+0x63a>
  100afb:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b02:	48 8b 40 08          	mov    0x8(%rax),%rax
  100b06:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100b0a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b11:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100b15:	8b 00                	mov    (%rax),%eax
  100b17:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
            goto done;
  100b1d:	e9 67 03 00 00       	jmp    100e89 <printer_vprintf+0x9ae>
        case 'c':
            data = numbuf;
  100b22:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100b26:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = va_arg(val, int);
  100b2a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b31:	8b 00                	mov    (%rax),%eax
  100b33:	83 f8 2f             	cmp    $0x2f,%eax
  100b36:	77 30                	ja     100b68 <printer_vprintf+0x68d>
  100b38:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b3f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100b43:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b4a:	8b 00                	mov    (%rax),%eax
  100b4c:	89 c0                	mov    %eax,%eax
  100b4e:	48 01 d0             	add    %rdx,%rax
  100b51:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b58:	8b 12                	mov    (%rdx),%edx
  100b5a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100b5d:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b64:	89 0a                	mov    %ecx,(%rdx)
  100b66:	eb 1a                	jmp    100b82 <printer_vprintf+0x6a7>
  100b68:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b6f:	48 8b 40 08          	mov    0x8(%rax),%rax
  100b73:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100b77:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b7e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100b82:	8b 00                	mov    (%rax),%eax
  100b84:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  100b87:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            break;
  100b8b:	eb 45                	jmp    100bd2 <printer_vprintf+0x6f7>
        default:
            data = numbuf;
  100b8d:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100b91:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = (*format ? *format : '%');
  100b95:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100b9c:	0f b6 00             	movzbl (%rax),%eax
  100b9f:	84 c0                	test   %al,%al
  100ba1:	74 0c                	je     100baf <printer_vprintf+0x6d4>
  100ba3:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100baa:	0f b6 00             	movzbl (%rax),%eax
  100bad:	eb 05                	jmp    100bb4 <printer_vprintf+0x6d9>
  100baf:	b8 25 00 00 00       	mov    $0x25,%eax
  100bb4:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  100bb7:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            if (!*format) {
  100bbb:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100bc2:	0f b6 00             	movzbl (%rax),%eax
  100bc5:	84 c0                	test   %al,%al
  100bc7:	75 08                	jne    100bd1 <printer_vprintf+0x6f6>
                format--;
  100bc9:	48 83 ad 68 ff ff ff 	subq   $0x1,-0x98(%rbp)
  100bd0:	01 
            }
            break;
  100bd1:	90                   	nop
        }

        if (flags & FLAG_NUMERIC) {
  100bd2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100bd5:	83 e0 20             	and    $0x20,%eax
  100bd8:	85 c0                	test   %eax,%eax
  100bda:	74 1e                	je     100bfa <printer_vprintf+0x71f>
            data = fill_numbuf(numbuf + NUMBUFSIZ, num, base);
  100bdc:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100be0:	48 83 c0 18          	add    $0x18,%rax
  100be4:	8b 55 e0             	mov    -0x20(%rbp),%edx
  100be7:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  100beb:	48 89 ce             	mov    %rcx,%rsi
  100bee:	48 89 c7             	mov    %rax,%rdi
  100bf1:	e8 63 f8 ff ff       	call   100459 <fill_numbuf>
  100bf6:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        }

        const char* prefix = "";
  100bfa:	48 c7 45 c0 b6 11 10 	movq   $0x1011b6,-0x40(%rbp)
  100c01:	00 
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  100c02:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100c05:	83 e0 20             	and    $0x20,%eax
  100c08:	85 c0                	test   %eax,%eax
  100c0a:	74 48                	je     100c54 <printer_vprintf+0x779>
  100c0c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100c0f:	83 e0 40             	and    $0x40,%eax
  100c12:	85 c0                	test   %eax,%eax
  100c14:	74 3e                	je     100c54 <printer_vprintf+0x779>
            if (flags & FLAG_NEGATIVE) {
  100c16:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100c19:	25 80 00 00 00       	and    $0x80,%eax
  100c1e:	85 c0                	test   %eax,%eax
  100c20:	74 0a                	je     100c2c <printer_vprintf+0x751>
                prefix = "-";
  100c22:	48 c7 45 c0 b7 11 10 	movq   $0x1011b7,-0x40(%rbp)
  100c29:	00 
            if (flags & FLAG_NEGATIVE) {
  100c2a:	eb 73                	jmp    100c9f <printer_vprintf+0x7c4>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100c2c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100c2f:	83 e0 10             	and    $0x10,%eax
  100c32:	85 c0                	test   %eax,%eax
  100c34:	74 0a                	je     100c40 <printer_vprintf+0x765>
                prefix = "+";
  100c36:	48 c7 45 c0 b9 11 10 	movq   $0x1011b9,-0x40(%rbp)
  100c3d:	00 
            if (flags & FLAG_NEGATIVE) {
  100c3e:	eb 5f                	jmp    100c9f <printer_vprintf+0x7c4>
            } else if (flags & FLAG_SPACEPOSITIVE) {
  100c40:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100c43:	83 e0 08             	and    $0x8,%eax
  100c46:	85 c0                	test   %eax,%eax
  100c48:	74 55                	je     100c9f <printer_vprintf+0x7c4>
                prefix = " ";
  100c4a:	48 c7 45 c0 bb 11 10 	movq   $0x1011bb,-0x40(%rbp)
  100c51:	00 
            if (flags & FLAG_NEGATIVE) {
  100c52:	eb 4b                	jmp    100c9f <printer_vprintf+0x7c4>
            }
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100c54:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100c57:	83 e0 20             	and    $0x20,%eax
  100c5a:	85 c0                	test   %eax,%eax
  100c5c:	74 42                	je     100ca0 <printer_vprintf+0x7c5>
  100c5e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100c61:	83 e0 01             	and    $0x1,%eax
  100c64:	85 c0                	test   %eax,%eax
  100c66:	74 38                	je     100ca0 <printer_vprintf+0x7c5>
                   && (base == 16 || base == -16)
  100c68:	83 7d e0 10          	cmpl   $0x10,-0x20(%rbp)
  100c6c:	74 06                	je     100c74 <printer_vprintf+0x799>
  100c6e:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  100c72:	75 2c                	jne    100ca0 <printer_vprintf+0x7c5>
                   && (num || (flags & FLAG_ALT2))) {
  100c74:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  100c79:	75 0c                	jne    100c87 <printer_vprintf+0x7ac>
  100c7b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100c7e:	25 00 01 00 00       	and    $0x100,%eax
  100c83:	85 c0                	test   %eax,%eax
  100c85:	74 19                	je     100ca0 <printer_vprintf+0x7c5>
            prefix = (base == -16 ? "0x" : "0X");
  100c87:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  100c8b:	75 07                	jne    100c94 <printer_vprintf+0x7b9>
  100c8d:	b8 bd 11 10 00       	mov    $0x1011bd,%eax
  100c92:	eb 05                	jmp    100c99 <printer_vprintf+0x7be>
  100c94:	b8 c0 11 10 00       	mov    $0x1011c0,%eax
  100c99:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100c9d:	eb 01                	jmp    100ca0 <printer_vprintf+0x7c5>
            if (flags & FLAG_NEGATIVE) {
  100c9f:	90                   	nop
        }

        int len;
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  100ca0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  100ca4:	78 24                	js     100cca <printer_vprintf+0x7ef>
  100ca6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100ca9:	83 e0 20             	and    $0x20,%eax
  100cac:	85 c0                	test   %eax,%eax
  100cae:	75 1a                	jne    100cca <printer_vprintf+0x7ef>
            len = strnlen(data, precision);
  100cb0:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100cb3:	48 63 d0             	movslq %eax,%rdx
  100cb6:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100cba:	48 89 d6             	mov    %rdx,%rsi
  100cbd:	48 89 c7             	mov    %rax,%rdi
  100cc0:	e8 ea f5 ff ff       	call   1002af <strnlen>
  100cc5:	89 45 bc             	mov    %eax,-0x44(%rbp)
  100cc8:	eb 0f                	jmp    100cd9 <printer_vprintf+0x7fe>
        } else {
            len = strlen(data);
  100cca:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100cce:	48 89 c7             	mov    %rax,%rdi
  100cd1:	e8 a8 f5 ff ff       	call   10027e <strlen>
  100cd6:	89 45 bc             	mov    %eax,-0x44(%rbp)
        }
        int zeros;
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  100cd9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100cdc:	83 e0 20             	and    $0x20,%eax
  100cdf:	85 c0                	test   %eax,%eax
  100ce1:	74 20                	je     100d03 <printer_vprintf+0x828>
  100ce3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  100ce7:	78 1a                	js     100d03 <printer_vprintf+0x828>
            zeros = precision > len ? precision - len : 0;
  100ce9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100cec:	3b 45 bc             	cmp    -0x44(%rbp),%eax
  100cef:	7e 08                	jle    100cf9 <printer_vprintf+0x81e>
  100cf1:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100cf4:	2b 45 bc             	sub    -0x44(%rbp),%eax
  100cf7:	eb 05                	jmp    100cfe <printer_vprintf+0x823>
  100cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  100cfe:	89 45 b8             	mov    %eax,-0x48(%rbp)
  100d01:	eb 5c                	jmp    100d5f <printer_vprintf+0x884>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100d03:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100d06:	83 e0 20             	and    $0x20,%eax
  100d09:	85 c0                	test   %eax,%eax
  100d0b:	74 4b                	je     100d58 <printer_vprintf+0x87d>
  100d0d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100d10:	83 e0 02             	and    $0x2,%eax
  100d13:	85 c0                	test   %eax,%eax
  100d15:	74 41                	je     100d58 <printer_vprintf+0x87d>
                   && !(flags & FLAG_LEFTJUSTIFY)
  100d17:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100d1a:	83 e0 04             	and    $0x4,%eax
  100d1d:	85 c0                	test   %eax,%eax
  100d1f:	75 37                	jne    100d58 <printer_vprintf+0x87d>
                   && len + (int) strlen(prefix) < width) {
  100d21:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100d25:	48 89 c7             	mov    %rax,%rdi
  100d28:	e8 51 f5 ff ff       	call   10027e <strlen>
  100d2d:	89 c2                	mov    %eax,%edx
  100d2f:	8b 45 bc             	mov    -0x44(%rbp),%eax
  100d32:	01 d0                	add    %edx,%eax
  100d34:	39 45 e8             	cmp    %eax,-0x18(%rbp)
  100d37:	7e 1f                	jle    100d58 <printer_vprintf+0x87d>
            zeros = width - len - strlen(prefix);
  100d39:	8b 45 e8             	mov    -0x18(%rbp),%eax
  100d3c:	2b 45 bc             	sub    -0x44(%rbp),%eax
  100d3f:	89 c3                	mov    %eax,%ebx
  100d41:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100d45:	48 89 c7             	mov    %rax,%rdi
  100d48:	e8 31 f5 ff ff       	call   10027e <strlen>
  100d4d:	89 c2                	mov    %eax,%edx
  100d4f:	89 d8                	mov    %ebx,%eax
  100d51:	29 d0                	sub    %edx,%eax
  100d53:	89 45 b8             	mov    %eax,-0x48(%rbp)
  100d56:	eb 07                	jmp    100d5f <printer_vprintf+0x884>
        } else {
            zeros = 0;
  100d58:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
        }
        width -= len + zeros + strlen(prefix);
  100d5f:	8b 55 bc             	mov    -0x44(%rbp),%edx
  100d62:	8b 45 b8             	mov    -0x48(%rbp),%eax
  100d65:	01 d0                	add    %edx,%eax
  100d67:	48 63 d8             	movslq %eax,%rbx
  100d6a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100d6e:	48 89 c7             	mov    %rax,%rdi
  100d71:	e8 08 f5 ff ff       	call   10027e <strlen>
  100d76:	48 8d 14 03          	lea    (%rbx,%rax,1),%rdx
  100d7a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  100d7d:	29 d0                	sub    %edx,%eax
  100d7f:	89 45 e8             	mov    %eax,-0x18(%rbp)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100d82:	eb 25                	jmp    100da9 <printer_vprintf+0x8ce>
            p->putc(p, ' ', color);
  100d84:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100d8b:	48 8b 08             	mov    (%rax),%rcx
  100d8e:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100d94:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100d9b:	be 20 00 00 00       	mov    $0x20,%esi
  100da0:	48 89 c7             	mov    %rax,%rdi
  100da3:	ff d1                	call   *%rcx
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100da5:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  100da9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100dac:	83 e0 04             	and    $0x4,%eax
  100daf:	85 c0                	test   %eax,%eax
  100db1:	75 36                	jne    100de9 <printer_vprintf+0x90e>
  100db3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  100db7:	7f cb                	jg     100d84 <printer_vprintf+0x8a9>
        }
        for (; *prefix; ++prefix) {
  100db9:	eb 2e                	jmp    100de9 <printer_vprintf+0x90e>
            p->putc(p, *prefix, color);
  100dbb:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100dc2:	4c 8b 00             	mov    (%rax),%r8
  100dc5:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100dc9:	0f b6 00             	movzbl (%rax),%eax
  100dcc:	0f b6 c8             	movzbl %al,%ecx
  100dcf:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100dd5:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100ddc:	89 ce                	mov    %ecx,%esi
  100dde:	48 89 c7             	mov    %rax,%rdi
  100de1:	41 ff d0             	call   *%r8
        for (; *prefix; ++prefix) {
  100de4:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  100de9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100ded:	0f b6 00             	movzbl (%rax),%eax
  100df0:	84 c0                	test   %al,%al
  100df2:	75 c7                	jne    100dbb <printer_vprintf+0x8e0>
        }
        for (; zeros > 0; --zeros) {
  100df4:	eb 25                	jmp    100e1b <printer_vprintf+0x940>
            p->putc(p, '0', color);
  100df6:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100dfd:	48 8b 08             	mov    (%rax),%rcx
  100e00:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100e06:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100e0d:	be 30 00 00 00       	mov    $0x30,%esi
  100e12:	48 89 c7             	mov    %rax,%rdi
  100e15:	ff d1                	call   *%rcx
        for (; zeros > 0; --zeros) {
  100e17:	83 6d b8 01          	subl   $0x1,-0x48(%rbp)
  100e1b:	83 7d b8 00          	cmpl   $0x0,-0x48(%rbp)
  100e1f:	7f d5                	jg     100df6 <printer_vprintf+0x91b>
        }
        for (; len > 0; ++data, --len) {
  100e21:	eb 32                	jmp    100e55 <printer_vprintf+0x97a>
            p->putc(p, *data, color);
  100e23:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100e2a:	4c 8b 00             	mov    (%rax),%r8
  100e2d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100e31:	0f b6 00             	movzbl (%rax),%eax
  100e34:	0f b6 c8             	movzbl %al,%ecx
  100e37:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100e3d:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100e44:	89 ce                	mov    %ecx,%esi
  100e46:	48 89 c7             	mov    %rax,%rdi
  100e49:	41 ff d0             	call   *%r8
        for (; len > 0; ++data, --len) {
  100e4c:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  100e51:	83 6d bc 01          	subl   $0x1,-0x44(%rbp)
  100e55:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  100e59:	7f c8                	jg     100e23 <printer_vprintf+0x948>
        }
        for (; width > 0; --width) {
  100e5b:	eb 25                	jmp    100e82 <printer_vprintf+0x9a7>
            p->putc(p, ' ', color);
  100e5d:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100e64:	48 8b 08             	mov    (%rax),%rcx
  100e67:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100e6d:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100e74:	be 20 00 00 00       	mov    $0x20,%esi
  100e79:	48 89 c7             	mov    %rax,%rdi
  100e7c:	ff d1                	call   *%rcx
        for (; width > 0; --width) {
  100e7e:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  100e82:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  100e86:	7f d5                	jg     100e5d <printer_vprintf+0x982>
        }
    done: ;
  100e88:	90                   	nop
    for (; *format; ++format) {
  100e89:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100e90:	01 
  100e91:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100e98:	0f b6 00             	movzbl (%rax),%eax
  100e9b:	84 c0                	test   %al,%al
  100e9d:	0f 85 64 f6 ff ff    	jne    100507 <printer_vprintf+0x2c>
    }
}
  100ea3:	90                   	nop
  100ea4:	90                   	nop
  100ea5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100ea9:	c9                   	leave
  100eaa:	c3                   	ret

0000000000100eab <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  100eab:	55                   	push   %rbp
  100eac:	48 89 e5             	mov    %rsp,%rbp
  100eaf:	48 83 ec 20          	sub    $0x20,%rsp
  100eb3:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  100eb7:	89 f0                	mov    %esi,%eax
  100eb9:	89 55 e0             	mov    %edx,-0x20(%rbp)
  100ebc:	88 45 e4             	mov    %al,-0x1c(%rbp)
    console_printer* cp = (console_printer*) p;
  100ebf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100ec3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  100ec7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100ecb:	48 8b 40 08          	mov    0x8(%rax),%rax
  100ecf:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
  100ed4:	48 39 d0             	cmp    %rdx,%rax
  100ed7:	72 0c                	jb     100ee5 <console_putc+0x3a>
        cp->cursor = console;
  100ed9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100edd:	48 c7 40 08 00 80 0b 	movq   $0xb8000,0x8(%rax)
  100ee4:	00 
    }
    if (c == '\n') {
  100ee5:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%rbp)
  100ee9:	75 78                	jne    100f63 <console_putc+0xb8>
        int pos = (cp->cursor - console) % 80;
  100eeb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100eef:	48 8b 40 08          	mov    0x8(%rax),%rax
  100ef3:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  100ef9:	48 d1 f8             	sar    %rax
  100efc:	48 89 c1             	mov    %rax,%rcx
  100eff:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  100f06:	66 66 66 
  100f09:	48 89 c8             	mov    %rcx,%rax
  100f0c:	48 f7 ea             	imul   %rdx
  100f0f:	48 c1 fa 05          	sar    $0x5,%rdx
  100f13:	48 89 c8             	mov    %rcx,%rax
  100f16:	48 c1 f8 3f          	sar    $0x3f,%rax
  100f1a:	48 29 c2             	sub    %rax,%rdx
  100f1d:	48 89 d0             	mov    %rdx,%rax
  100f20:	48 c1 e0 02          	shl    $0x2,%rax
  100f24:	48 01 d0             	add    %rdx,%rax
  100f27:	48 c1 e0 04          	shl    $0x4,%rax
  100f2b:	48 29 c1             	sub    %rax,%rcx
  100f2e:	48 89 ca             	mov    %rcx,%rdx
  100f31:	89 55 fc             	mov    %edx,-0x4(%rbp)
        for (; pos != 80; pos++) {
  100f34:	eb 25                	jmp    100f5b <console_putc+0xb0>
            *cp->cursor++ = ' ' | color;
  100f36:	8b 45 e0             	mov    -0x20(%rbp),%eax
  100f39:	83 c8 20             	or     $0x20,%eax
  100f3c:	89 c6                	mov    %eax,%esi
  100f3e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100f42:	48 8b 40 08          	mov    0x8(%rax),%rax
  100f46:	48 8d 48 02          	lea    0x2(%rax),%rcx
  100f4a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  100f4e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100f52:	89 f2                	mov    %esi,%edx
  100f54:	66 89 10             	mov    %dx,(%rax)
        for (; pos != 80; pos++) {
  100f57:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  100f5b:	83 7d fc 50          	cmpl   $0x50,-0x4(%rbp)
  100f5f:	75 d5                	jne    100f36 <console_putc+0x8b>
        }
    } else {
        *cp->cursor++ = c | color;
    }
}
  100f61:	eb 24                	jmp    100f87 <console_putc+0xdc>
        *cp->cursor++ = c | color;
  100f63:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
  100f67:	8b 55 e0             	mov    -0x20(%rbp),%edx
  100f6a:	09 d0                	or     %edx,%eax
  100f6c:	89 c6                	mov    %eax,%esi
  100f6e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100f72:	48 8b 40 08          	mov    0x8(%rax),%rax
  100f76:	48 8d 48 02          	lea    0x2(%rax),%rcx
  100f7a:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  100f7e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100f82:	89 f2                	mov    %esi,%edx
  100f84:	66 89 10             	mov    %dx,(%rax)
}
  100f87:	90                   	nop
  100f88:	c9                   	leave
  100f89:	c3                   	ret

0000000000100f8a <console_vprintf>:

int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100f8a:	55                   	push   %rbp
  100f8b:	48 89 e5             	mov    %rsp,%rbp
  100f8e:	48 83 ec 30          	sub    $0x30,%rsp
  100f92:	89 7d ec             	mov    %edi,-0x14(%rbp)
  100f95:	89 75 e8             	mov    %esi,-0x18(%rbp)
  100f98:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  100f9c:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
    struct console_printer cp;
    cp.p.putc = console_putc;
  100fa0:	48 c7 45 f0 ab 0e 10 	movq   $0x100eab,-0x10(%rbp)
  100fa7:	00 
    if (cpos < 0 || cpos >= CONSOLE_ROWS * CONSOLE_COLUMNS) {
  100fa8:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  100fac:	78 09                	js     100fb7 <console_vprintf+0x2d>
  100fae:	81 7d ec cf 07 00 00 	cmpl   $0x7cf,-0x14(%rbp)
  100fb5:	7e 07                	jle    100fbe <console_vprintf+0x34>
        cpos = 0;
  100fb7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
    cp.cursor = console + cpos;
  100fbe:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100fc1:	48 98                	cltq
  100fc3:	48 01 c0             	add    %rax,%rax
  100fc6:	48 05 00 80 0b 00    	add    $0xb8000,%rax
  100fcc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  100fd0:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  100fd4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  100fd8:	8b 75 e8             	mov    -0x18(%rbp),%esi
  100fdb:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  100fdf:	48 89 c7             	mov    %rax,%rdi
  100fe2:	e8 f4 f4 ff ff       	call   1004db <printer_vprintf>
    return cp.cursor - console;
  100fe7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100feb:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  100ff1:	48 d1 f8             	sar    %rax
}
  100ff4:	c9                   	leave
  100ff5:	c3                   	ret

0000000000100ff6 <console_printf>:

int console_printf(int cpos, int color, const char* format, ...) {
  100ff6:	55                   	push   %rbp
  100ff7:	48 89 e5             	mov    %rsp,%rbp
  100ffa:	48 83 ec 60          	sub    $0x60,%rsp
  100ffe:	89 7d ac             	mov    %edi,-0x54(%rbp)
  101001:	89 75 a8             	mov    %esi,-0x58(%rbp)
  101004:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  101008:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  10100c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  101010:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  101014:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  10101b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  10101f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  101023:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  101027:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  10102b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  10102f:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  101033:	8b 75 a8             	mov    -0x58(%rbp),%esi
  101036:	8b 45 ac             	mov    -0x54(%rbp),%eax
  101039:	89 c7                	mov    %eax,%edi
  10103b:	e8 4a ff ff ff       	call   100f8a <console_vprintf>
  101040:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
  101043:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
  101046:	c9                   	leave
  101047:	c3                   	ret

0000000000101048 <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  101048:	55                   	push   %rbp
  101049:	48 89 e5             	mov    %rsp,%rbp
  10104c:	48 83 ec 20          	sub    $0x20,%rsp
  101050:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  101054:	89 f0                	mov    %esi,%eax
  101056:	89 55 e0             	mov    %edx,-0x20(%rbp)
  101059:	88 45 e4             	mov    %al,-0x1c(%rbp)
    string_printer* sp = (string_printer*) p;
  10105c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  101060:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (sp->s < sp->end) {
  101064:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  101068:	48 8b 50 08          	mov    0x8(%rax),%rdx
  10106c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  101070:	48 8b 40 10          	mov    0x10(%rax),%rax
  101074:	48 39 c2             	cmp    %rax,%rdx
  101077:	73 1a                	jae    101093 <string_putc+0x4b>
        *sp->s++ = c;
  101079:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10107d:	48 8b 40 08          	mov    0x8(%rax),%rax
  101081:	48 8d 48 01          	lea    0x1(%rax),%rcx
  101085:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  101089:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  10108d:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
  101091:	88 10                	mov    %dl,(%rax)
    }
    (void) color;
}
  101093:	90                   	nop
  101094:	c9                   	leave
  101095:	c3                   	ret

0000000000101096 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  101096:	55                   	push   %rbp
  101097:	48 89 e5             	mov    %rsp,%rbp
  10109a:	48 83 ec 40          	sub    $0x40,%rsp
  10109e:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  1010a2:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  1010a6:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  1010aa:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    string_printer sp;
    sp.p.putc = string_putc;
  1010ae:	48 c7 45 e8 48 10 10 	movq   $0x101048,-0x18(%rbp)
  1010b5:	00 
    sp.s = s;
  1010b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1010ba:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (size) {
  1010be:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  1010c3:	74 33                	je     1010f8 <vsnprintf+0x62>
        sp.end = s + size - 1;
  1010c5:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  1010c9:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  1010cd:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1010d1:	48 01 d0             	add    %rdx,%rax
  1010d4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  1010d8:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  1010dc:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  1010e0:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  1010e4:	be 00 00 00 00       	mov    $0x0,%esi
  1010e9:	48 89 c7             	mov    %rax,%rdi
  1010ec:	e8 ea f3 ff ff       	call   1004db <printer_vprintf>
        *sp.s = 0;
  1010f1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1010f5:	c6 00 00             	movb   $0x0,(%rax)
    }
    return sp.s - s;
  1010f8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1010fc:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
}
  101100:	c9                   	leave
  101101:	c3                   	ret

0000000000101102 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  101102:	55                   	push   %rbp
  101103:	48 89 e5             	mov    %rsp,%rbp
  101106:	48 83 ec 70          	sub    $0x70,%rsp
  10110a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  10110e:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  101112:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  101116:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  10111a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  10111e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  101122:	c7 45 b0 18 00 00 00 	movl   $0x18,-0x50(%rbp)
  101129:	48 8d 45 10          	lea    0x10(%rbp),%rax
  10112d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  101131:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  101135:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    int n = vsnprintf(s, size, format, val);
  101139:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  10113d:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  101141:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  101145:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  101149:	48 89 c7             	mov    %rax,%rdi
  10114c:	e8 45 ff ff ff       	call   101096 <vsnprintf>
  101151:	89 45 cc             	mov    %eax,-0x34(%rbp)
    va_end(val);
    return n;
  101154:	8b 45 cc             	mov    -0x34(%rbp),%eax
}
  101157:	c9                   	leave
  101158:	c3                   	ret

0000000000101159 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  101159:	55                   	push   %rbp
  10115a:	48 89 e5             	mov    %rsp,%rbp
  10115d:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  101161:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  101168:	eb 13                	jmp    10117d <console_clear+0x24>
        console[i] = ' ' | 0x0700;
  10116a:	8b 45 fc             	mov    -0x4(%rbp),%eax
  10116d:	48 98                	cltq
  10116f:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%rax,%rax,1)
  101176:	00 20 07 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  101179:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  10117d:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
  101184:	7e e4                	jle    10116a <console_clear+0x11>
    }
    cursorpos = 0;
  101186:	c7 05 6c 7e fb ff 00 	movl   $0x0,-0x48194(%rip)        # b8ffc <cursorpos>
  10118d:	00 00 00 
}
  101190:	90                   	nop
  101191:	c9                   	leave
  101192:	c3                   	ret
