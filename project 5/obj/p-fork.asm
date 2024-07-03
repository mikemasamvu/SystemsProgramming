
obj/p-fork.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:
// Program that forks thrice to produce a total of 4 processes
// Each process keeps allocating memory till stack bottom is reached
// OR system is out of memory
// after that, each process loops forever

void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	53                   	push   %rbx
  100005:	48 83 ec 08          	sub    $0x8,%rsp
// sys_fork()
//    Fork the current process. On success, return the child's process ID to
//    the parent, and return 0 to the child. On failure, return -1.
static inline pid_t sys_fork(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  100009:	cd 34                	int    $0x34
    // Fork a total of three new copies.
    pid_t p1 = sys_fork();
    assert(p1 >= 0);
  10000b:	85 c0                	test   %eax,%eax
  10000d:	78 50                	js     10005f <process_main+0x5f>
  10000f:	89 c2                	mov    %eax,%edx
  100011:	cd 34                	int    $0x34
  100013:	89 c1                	mov    %eax,%ecx
    pid_t p2 = sys_fork();
    assert(p2 >= 0);
  100015:	85 c0                	test   %eax,%eax
  100017:	78 5a                	js     100073 <process_main+0x73>
    asm volatile ("int %1" : "=a" (result)
  100019:	cd 31                	int    $0x31

    // Check fork return values: fork should return 0 to child.
    if (sys_getpid() == 1) {
  10001b:	83 f8 01             	cmp    $0x1,%eax
  10001e:	74 67                	je     100087 <process_main+0x87>
        assert(p1 != 0 && p2 != 0 && p1 != p2);
    } else {
        assert(p1 == 0 || p2 == 0);
  100020:	85 d2                	test   %edx,%edx
  100022:	74 08                	je     10002c <process_main+0x2c>
  100024:	85 c9                	test   %ecx,%ecx
  100026:	0f 85 81 00 00 00    	jne    1000ad <process_main+0xad>
  10002c:	cd 31                	int    $0x31
  10002e:	89 c3                	mov    %eax,%ebx
    }

    // The rest of this code is like p-allocator.c.

    pid_t p = sys_getpid();
    srand(p);
  100030:	89 c7                	mov    %eax,%edi
  100032:	e8 62 05 00 00       	call   100599 <srand>

    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  100037:	b8 17 30 10 00       	mov    $0x103017,%eax
  10003c:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100042:	48 89 05 bf 1f 00 00 	mov    %rax,0x1fbf(%rip)        # 102008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  100049:	48 89 e0             	mov    %rsp,%rax
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  10004c:	48 83 e8 01          	sub    $0x1,%rax
  100050:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100056:	48 89 05 a3 1f 00 00 	mov    %rax,0x1fa3(%rip)        # 102000 <stack_bottom>
  10005d:	eb 64                	jmp    1000c3 <process_main+0xc3>
    assert(p1 >= 0);
  10005f:	ba 00 13 10 00       	mov    $0x101300,%edx
  100064:	be 12 00 00 00       	mov    $0x12,%esi
  100069:	bf 08 13 10 00       	mov    $0x101308,%edi
  10006e:	e8 00 02 00 00       	call   100273 <assert_fail>
    assert(p2 >= 0);
  100073:	ba 18 13 10 00       	mov    $0x101318,%edx
  100078:	be 14 00 00 00       	mov    $0x14,%esi
  10007d:	bf 08 13 10 00       	mov    $0x101308,%edi
  100082:	e8 ec 01 00 00       	call   100273 <assert_fail>
        assert(p1 != 0 && p2 != 0 && p1 != p2);
  100087:	85 c9                	test   %ecx,%ecx
  100089:	0f 94 c0             	sete   %al
  10008c:	39 ca                	cmp    %ecx,%edx
  10008e:	0f 94 c1             	sete   %cl
  100091:	08 c8                	or     %cl,%al
  100093:	75 04                	jne    100099 <process_main+0x99>
  100095:	85 d2                	test   %edx,%edx
  100097:	75 93                	jne    10002c <process_main+0x2c>
  100099:	ba 38 13 10 00       	mov    $0x101338,%edx
  10009e:	be 18 00 00 00       	mov    $0x18,%esi
  1000a3:	bf 08 13 10 00       	mov    $0x101308,%edi
  1000a8:	e8 c6 01 00 00       	call   100273 <assert_fail>
        assert(p1 == 0 || p2 == 0);
  1000ad:	ba 20 13 10 00       	mov    $0x101320,%edx
  1000b2:	be 1a 00 00 00       	mov    $0x1a,%esi
  1000b7:	bf 08 13 10 00       	mov    $0x101308,%edi
  1000bc:	e8 b2 01 00 00       	call   100273 <assert_fail>
    asm volatile ("int %0" : /* no result */
  1000c1:	cd 32                	int    $0x32

    while (1) {
        if ((rand() % ALLOC_SLOWDOWN) < p) {
  1000c3:	e8 95 04 00 00       	call   10055d <rand>
  1000c8:	48 63 d0             	movslq %eax,%rdx
  1000cb:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  1000d2:	48 c1 fa 25          	sar    $0x25,%rdx
  1000d6:	89 c1                	mov    %eax,%ecx
  1000d8:	c1 f9 1f             	sar    $0x1f,%ecx
  1000db:	29 ca                	sub    %ecx,%edx
  1000dd:	6b d2 64             	imul   $0x64,%edx,%edx
  1000e0:	29 d0                	sub    %edx,%eax
  1000e2:	39 d8                	cmp    %ebx,%eax
  1000e4:	7d db                	jge    1000c1 <process_main+0xc1>
            if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  1000e6:	48 8b 3d 1b 1f 00 00 	mov    0x1f1b(%rip),%rdi        # 102008 <heap_top>
  1000ed:	48 3b 3d 0c 1f 00 00 	cmp    0x1f0c(%rip),%rdi        # 102000 <stack_bottom>
  1000f4:	74 1c                	je     100112 <process_main+0x112>
    asm volatile ("int %1" : "=a" (result)
  1000f6:	cd 33                	int    $0x33
  1000f8:	85 c0                	test   %eax,%eax
  1000fa:	78 16                	js     100112 <process_main+0x112>
                break;
            }
            *heap_top = p;      /* check we have write access to new page */
  1000fc:	48 8b 05 05 1f 00 00 	mov    0x1f05(%rip),%rax        # 102008 <heap_top>
  100103:	88 18                	mov    %bl,(%rax)
            heap_top += PAGESIZE;
  100105:	48 81 05 f8 1e 00 00 	addq   $0x1000,0x1ef8(%rip)        # 102008 <heap_top>
  10010c:	00 10 00 00 
  100110:	eb af                	jmp    1000c1 <process_main+0xc1>
    asm volatile ("int %0" : /* no result */
  100112:	cd 32                	int    $0x32
        }
        sys_yield();
    }

    // After running out of memory, do nothing forever
    while (1) {
  100114:	eb fc                	jmp    100112 <process_main+0x112>

0000000000100116 <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  100116:	55                   	push   %rbp
  100117:	48 89 e5             	mov    %rsp,%rbp
  10011a:	48 83 ec 50          	sub    $0x50,%rsp
  10011e:	49 89 f2             	mov    %rsi,%r10
  100121:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  100125:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100129:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  10012d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  100131:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  100136:	85 ff                	test   %edi,%edi
  100138:	78 2e                	js     100168 <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  10013a:	48 63 ff             	movslq %edi,%rdi
  10013d:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  100144:	cc cc cc 
  100147:	48 89 f8             	mov    %rdi,%rax
  10014a:	48 f7 e2             	mul    %rdx
  10014d:	48 89 d0             	mov    %rdx,%rax
  100150:	48 c1 e8 02          	shr    $0x2,%rax
  100154:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  100158:	48 01 c2             	add    %rax,%rdx
  10015b:	48 29 d7             	sub    %rdx,%rdi
  10015e:	0f b6 b7 8d 13 10 00 	movzbl 0x10138d(%rdi),%esi
  100165:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  100168:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  10016f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100173:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100177:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  10017b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  10017f:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100183:	4c 89 d2             	mov    %r10,%rdx
  100186:	8b 3d 70 8e fb ff    	mov    -0x47190(%rip),%edi        # b8ffc <cursorpos>
  10018c:	e8 5a 0f 00 00       	call   1010eb <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  100191:	3d 30 07 00 00       	cmp    $0x730,%eax
  100196:	ba 00 00 00 00       	mov    $0x0,%edx
  10019b:	0f 4d c2             	cmovge %edx,%eax
  10019e:	89 05 58 8e fb ff    	mov    %eax,-0x471a8(%rip)        # b8ffc <cursorpos>
    }
}
  1001a4:	c9                   	leave
  1001a5:	c3                   	ret

00000000001001a6 <panic>:


// panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void panic(const char* format, ...) {
  1001a6:	55                   	push   %rbp
  1001a7:	48 89 e5             	mov    %rsp,%rbp
  1001aa:	53                   	push   %rbx
  1001ab:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  1001b2:	48 89 fb             	mov    %rdi,%rbx
  1001b5:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  1001b9:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  1001bd:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  1001c1:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  1001c5:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  1001c9:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  1001d0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1001d4:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  1001d8:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  1001dc:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  1001e0:	ba 07 00 00 00       	mov    $0x7,%edx
  1001e5:	be 57 13 10 00       	mov    $0x101357,%esi
  1001ea:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  1001f1:	e8 ac 00 00 00       	call   1002a2 <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  1001f6:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  1001fa:	48 89 da             	mov    %rbx,%rdx
  1001fd:	be 99 00 00 00       	mov    $0x99,%esi
  100202:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  100209:	e8 e9 0f 00 00       	call   1011f7 <vsnprintf>
  10020e:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  100211:	85 d2                	test   %edx,%edx
  100213:	7e 0f                	jle    100224 <panic+0x7e>
  100215:	83 c0 06             	add    $0x6,%eax
  100218:	48 98                	cltq
  10021a:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  100221:	0a 
  100222:	75 29                	jne    10024d <panic+0xa7>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  100224:	48 8d 8d 08 ff ff ff 	lea    -0xf8(%rbp),%rcx
  10022b:	ba 61 13 10 00       	mov    $0x101361,%edx
  100230:	be 00 c0 00 00       	mov    $0xc000,%esi
  100235:	bf 30 07 00 00       	mov    $0x730,%edi
  10023a:	b8 00 00 00 00       	mov    $0x0,%eax
  10023f:	e8 13 0f 00 00       	call   101157 <console_printf>
}

// sys_panic(msg)
//    Panic.
static inline pid_t __attribute__((noreturn)) sys_panic(const char* msg) {
    asm volatile ("int %0" : /* no result */
  100244:	bf 00 00 00 00       	mov    $0x0,%edi
  100249:	cd 30                	int    $0x30
                  : "i" (INT_SYS_PANIC), "D" (msg)
                  : "cc", "memory");
 loop: goto loop;
  10024b:	eb fe                	jmp    10024b <panic+0xa5>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  10024d:	48 63 c2             	movslq %edx,%rax
  100250:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  100256:	0f 94 c2             	sete   %dl
  100259:	0f b6 d2             	movzbl %dl,%edx
  10025c:	48 29 d0             	sub    %rdx,%rax
  10025f:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  100266:	ff 
  100267:	be 5f 13 10 00       	mov    $0x10135f,%esi
  10026c:	e8 de 01 00 00       	call   10044f <strcpy>
  100271:	eb b1                	jmp    100224 <panic+0x7e>

0000000000100273 <assert_fail>:
    sys_panic(NULL);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  100273:	55                   	push   %rbp
  100274:	48 89 e5             	mov    %rsp,%rbp
  100277:	48 89 f9             	mov    %rdi,%rcx
  10027a:	41 89 f0             	mov    %esi,%r8d
  10027d:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  100280:	ba 68 13 10 00       	mov    $0x101368,%edx
  100285:	be 00 c0 00 00       	mov    $0xc000,%esi
  10028a:	bf 30 07 00 00       	mov    $0x730,%edi
  10028f:	b8 00 00 00 00       	mov    $0x0,%eax
  100294:	e8 be 0e 00 00       	call   101157 <console_printf>
    asm volatile ("int %0" : /* no result */
  100299:	bf 00 00 00 00       	mov    $0x0,%edi
  10029e:	cd 30                	int    $0x30
 loop: goto loop;
  1002a0:	eb fe                	jmp    1002a0 <assert_fail+0x2d>

00000000001002a2 <memcpy>:


// memcpy, memmove, memset, strcmp, strlen, strnlen
//    We must provide our own implementations.

void* memcpy(void* dst, const void* src, size_t n) {
  1002a2:	55                   	push   %rbp
  1002a3:	48 89 e5             	mov    %rsp,%rbp
  1002a6:	48 83 ec 28          	sub    $0x28,%rsp
  1002aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1002ae:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1002b2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1002b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1002ba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1002be:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1002c2:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  1002c6:	eb 1c                	jmp    1002e4 <memcpy+0x42>
        *d = *s;
  1002c8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1002cc:	0f b6 10             	movzbl (%rax),%edx
  1002cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1002d3:	88 10                	mov    %dl,(%rax)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1002d5:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  1002da:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1002df:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  1002e4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1002e9:	75 dd                	jne    1002c8 <memcpy+0x26>
    }
    return dst;
  1002eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1002ef:	c9                   	leave
  1002f0:	c3                   	ret

00000000001002f1 <memmove>:

void* memmove(void* dst, const void* src, size_t n) {
  1002f1:	55                   	push   %rbp
  1002f2:	48 89 e5             	mov    %rsp,%rbp
  1002f5:	48 83 ec 28          	sub    $0x28,%rsp
  1002f9:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1002fd:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  100301:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  100305:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100309:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    char* d = (char*) dst;
  10030d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100311:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (s < d && s + n > d) {
  100315:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100319:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  10031d:	73 6a                	jae    100389 <memmove+0x98>
  10031f:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  100323:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  100327:	48 01 d0             	add    %rdx,%rax
  10032a:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
  10032e:	73 59                	jae    100389 <memmove+0x98>
        s += n, d += n;
  100330:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  100334:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  100338:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  10033c:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        while (n-- > 0) {
  100340:	eb 17                	jmp    100359 <memmove+0x68>
            *--d = *--s;
  100342:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  100347:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
  10034c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100350:	0f b6 10             	movzbl (%rax),%edx
  100353:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100357:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  100359:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  10035d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  100361:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  100365:	48 85 c0             	test   %rax,%rax
  100368:	75 d8                	jne    100342 <memmove+0x51>
    if (s < d && s + n > d) {
  10036a:	eb 2e                	jmp    10039a <memmove+0xa9>
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
  10036c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  100370:	48 8d 42 01          	lea    0x1(%rdx),%rax
  100374:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  100378:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10037c:	48 8d 48 01          	lea    0x1(%rax),%rcx
  100380:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  100384:	0f b6 12             	movzbl (%rdx),%edx
  100387:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  100389:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  10038d:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  100391:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  100395:	48 85 c0             	test   %rax,%rax
  100398:	75 d2                	jne    10036c <memmove+0x7b>
        }
    }
    return dst;
  10039a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  10039e:	c9                   	leave
  10039f:	c3                   	ret

00000000001003a0 <memset>:

void* memset(void* v, int c, size_t n) {
  1003a0:	55                   	push   %rbp
  1003a1:	48 89 e5             	mov    %rsp,%rbp
  1003a4:	48 83 ec 28          	sub    $0x28,%rsp
  1003a8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1003ac:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  1003af:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1003b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1003b7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  1003bb:	eb 15                	jmp    1003d2 <memset+0x32>
        *p = c;
  1003bd:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1003c0:	89 c2                	mov    %eax,%edx
  1003c2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1003c6:	88 10                	mov    %dl,(%rax)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1003c8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1003cd:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  1003d2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1003d7:	75 e4                	jne    1003bd <memset+0x1d>
    }
    return v;
  1003d9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1003dd:	c9                   	leave
  1003de:	c3                   	ret

00000000001003df <strlen>:

size_t strlen(const char* s) {
  1003df:	55                   	push   %rbp
  1003e0:	48 89 e5             	mov    %rsp,%rbp
  1003e3:	48 83 ec 18          	sub    $0x18,%rsp
  1003e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
  1003eb:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  1003f2:	00 
  1003f3:	eb 0a                	jmp    1003ff <strlen+0x20>
        ++n;
  1003f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; *s != '\0'; ++s) {
  1003fa:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  1003ff:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100403:	0f b6 00             	movzbl (%rax),%eax
  100406:	84 c0                	test   %al,%al
  100408:	75 eb                	jne    1003f5 <strlen+0x16>
    }
    return n;
  10040a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  10040e:	c9                   	leave
  10040f:	c3                   	ret

0000000000100410 <strnlen>:

size_t strnlen(const char* s, size_t maxlen) {
  100410:	55                   	push   %rbp
  100411:	48 89 e5             	mov    %rsp,%rbp
  100414:	48 83 ec 20          	sub    $0x20,%rsp
  100418:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  10041c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    size_t n;
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  100420:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  100427:	00 
  100428:	eb 0a                	jmp    100434 <strnlen+0x24>
        ++n;
  10042a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  10042f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  100434:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100438:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  10043c:	74 0b                	je     100449 <strnlen+0x39>
  10043e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100442:	0f b6 00             	movzbl (%rax),%eax
  100445:	84 c0                	test   %al,%al
  100447:	75 e1                	jne    10042a <strnlen+0x1a>
    }
    return n;
  100449:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  10044d:	c9                   	leave
  10044e:	c3                   	ret

000000000010044f <strcpy>:

char* strcpy(char* dst, const char* src) {
  10044f:	55                   	push   %rbp
  100450:	48 89 e5             	mov    %rsp,%rbp
  100453:	48 83 ec 20          	sub    $0x20,%rsp
  100457:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  10045b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    char* d = dst;
  10045f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100463:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    do {
        *d++ = *src++;
  100467:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  10046b:	48 8d 42 01          	lea    0x1(%rdx),%rax
  10046f:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  100473:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100477:	48 8d 48 01          	lea    0x1(%rax),%rcx
  10047b:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
  10047f:	0f b6 12             	movzbl (%rdx),%edx
  100482:	88 10                	mov    %dl,(%rax)
    } while (d[-1]);
  100484:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100488:	48 83 e8 01          	sub    $0x1,%rax
  10048c:	0f b6 00             	movzbl (%rax),%eax
  10048f:	84 c0                	test   %al,%al
  100491:	75 d4                	jne    100467 <strcpy+0x18>
    return dst;
  100493:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  100497:	c9                   	leave
  100498:	c3                   	ret

0000000000100499 <strcmp>:

int strcmp(const char* a, const char* b) {
  100499:	55                   	push   %rbp
  10049a:	48 89 e5             	mov    %rsp,%rbp
  10049d:	48 83 ec 10          	sub    $0x10,%rsp
  1004a1:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  1004a5:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  1004a9:	eb 0a                	jmp    1004b5 <strcmp+0x1c>
        ++a, ++b;
  1004ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1004b0:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  1004b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1004b9:	0f b6 00             	movzbl (%rax),%eax
  1004bc:	84 c0                	test   %al,%al
  1004be:	74 1d                	je     1004dd <strcmp+0x44>
  1004c0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1004c4:	0f b6 00             	movzbl (%rax),%eax
  1004c7:	84 c0                	test   %al,%al
  1004c9:	74 12                	je     1004dd <strcmp+0x44>
  1004cb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1004cf:	0f b6 10             	movzbl (%rax),%edx
  1004d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1004d6:	0f b6 00             	movzbl (%rax),%eax
  1004d9:	38 c2                	cmp    %al,%dl
  1004db:	74 ce                	je     1004ab <strcmp+0x12>
    }
    return ((unsigned char) *a > (unsigned char) *b)
  1004dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1004e1:	0f b6 00             	movzbl (%rax),%eax
  1004e4:	89 c2                	mov    %eax,%edx
  1004e6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1004ea:	0f b6 00             	movzbl (%rax),%eax
  1004ed:	38 d0                	cmp    %dl,%al
  1004ef:	0f 92 c0             	setb   %al
  1004f2:	0f b6 d0             	movzbl %al,%edx
        - ((unsigned char) *a < (unsigned char) *b);
  1004f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1004f9:	0f b6 00             	movzbl (%rax),%eax
  1004fc:	89 c1                	mov    %eax,%ecx
  1004fe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100502:	0f b6 00             	movzbl (%rax),%eax
  100505:	38 c1                	cmp    %al,%cl
  100507:	0f 92 c0             	setb   %al
  10050a:	0f b6 c0             	movzbl %al,%eax
  10050d:	29 c2                	sub    %eax,%edx
  10050f:	89 d0                	mov    %edx,%eax
}
  100511:	c9                   	leave
  100512:	c3                   	ret

0000000000100513 <strchr>:

char* strchr(const char* s, int c) {
  100513:	55                   	push   %rbp
  100514:	48 89 e5             	mov    %rsp,%rbp
  100517:	48 83 ec 10          	sub    $0x10,%rsp
  10051b:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  10051f:	89 75 f4             	mov    %esi,-0xc(%rbp)
    while (*s && *s != (char) c) {
  100522:	eb 05                	jmp    100529 <strchr+0x16>
        ++s;
  100524:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while (*s && *s != (char) c) {
  100529:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10052d:	0f b6 00             	movzbl (%rax),%eax
  100530:	84 c0                	test   %al,%al
  100532:	74 0e                	je     100542 <strchr+0x2f>
  100534:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100538:	0f b6 00             	movzbl (%rax),%eax
  10053b:	8b 55 f4             	mov    -0xc(%rbp),%edx
  10053e:	38 d0                	cmp    %dl,%al
  100540:	75 e2                	jne    100524 <strchr+0x11>
    }
    if (*s == (char) c) {
  100542:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100546:	0f b6 00             	movzbl (%rax),%eax
  100549:	8b 55 f4             	mov    -0xc(%rbp),%edx
  10054c:	38 d0                	cmp    %dl,%al
  10054e:	75 06                	jne    100556 <strchr+0x43>
        return (char*) s;
  100550:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100554:	eb 05                	jmp    10055b <strchr+0x48>
    } else {
        return NULL;
  100556:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
  10055b:	c9                   	leave
  10055c:	c3                   	ret

000000000010055d <rand>:
// rand, srand

static int rand_seed_set;
static unsigned rand_seed;

int rand(void) {
  10055d:	55                   	push   %rbp
  10055e:	48 89 e5             	mov    %rsp,%rbp
    if (!rand_seed_set) {
  100561:	8b 05 a9 1a 00 00    	mov    0x1aa9(%rip),%eax        # 102010 <rand_seed_set>
  100567:	85 c0                	test   %eax,%eax
  100569:	75 0a                	jne    100575 <rand+0x18>
        srand(819234718U);
  10056b:	bf 9e 87 d4 30       	mov    $0x30d4879e,%edi
  100570:	e8 24 00 00 00       	call   100599 <srand>
    }
    rand_seed = rand_seed * 1664525U + 1013904223U;
  100575:	8b 05 99 1a 00 00    	mov    0x1a99(%rip),%eax        # 102014 <rand_seed>
  10057b:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
  100581:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  100586:	89 05 88 1a 00 00    	mov    %eax,0x1a88(%rip)        # 102014 <rand_seed>
    return rand_seed & RAND_MAX;
  10058c:	8b 05 82 1a 00 00    	mov    0x1a82(%rip),%eax        # 102014 <rand_seed>
  100592:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  100597:	5d                   	pop    %rbp
  100598:	c3                   	ret

0000000000100599 <srand>:

void srand(unsigned seed) {
  100599:	55                   	push   %rbp
  10059a:	48 89 e5             	mov    %rsp,%rbp
  10059d:	48 83 ec 08          	sub    $0x8,%rsp
  1005a1:	89 7d fc             	mov    %edi,-0x4(%rbp)
    rand_seed = seed;
  1005a4:	8b 45 fc             	mov    -0x4(%rbp),%eax
  1005a7:	89 05 67 1a 00 00    	mov    %eax,0x1a67(%rip)        # 102014 <rand_seed>
    rand_seed_set = 1;
  1005ad:	c7 05 59 1a 00 00 01 	movl   $0x1,0x1a59(%rip)        # 102010 <rand_seed_set>
  1005b4:	00 00 00 
}
  1005b7:	90                   	nop
  1005b8:	c9                   	leave
  1005b9:	c3                   	ret

00000000001005ba <fill_numbuf>:
//    Print a message onto the console, starting at the given cursor position.

// snprintf, vsnprintf
//    Format a string into a buffer.

static char* fill_numbuf(char* numbuf_end, unsigned long val, int base) {
  1005ba:	55                   	push   %rbp
  1005bb:	48 89 e5             	mov    %rsp,%rbp
  1005be:	48 83 ec 28          	sub    $0x28,%rsp
  1005c2:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1005c6:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1005ca:	89 55 dc             	mov    %edx,-0x24(%rbp)
    static const char upper_digits[] = "0123456789ABCDEF";
    static const char lower_digits[] = "0123456789abcdef";

    const char* digits = upper_digits;
  1005cd:	48 c7 45 f8 80 15 10 	movq   $0x101580,-0x8(%rbp)
  1005d4:	00 
    if (base < 0) {
  1005d5:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  1005d9:	79 0b                	jns    1005e6 <fill_numbuf+0x2c>
        digits = lower_digits;
  1005db:	48 c7 45 f8 a0 15 10 	movq   $0x1015a0,-0x8(%rbp)
  1005e2:	00 
        base = -base;
  1005e3:	f7 5d dc             	negl   -0x24(%rbp)
    }

    *--numbuf_end = '\0';
  1005e6:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  1005eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1005ef:	c6 00 00             	movb   $0x0,(%rax)
    do {
        *--numbuf_end = digits[val % base];
  1005f2:	8b 45 dc             	mov    -0x24(%rbp),%eax
  1005f5:	48 63 c8             	movslq %eax,%rcx
  1005f8:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1005fc:	ba 00 00 00 00       	mov    $0x0,%edx
  100601:	48 f7 f1             	div    %rcx
  100604:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100608:	48 01 d0             	add    %rdx,%rax
  10060b:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  100610:	0f b6 10             	movzbl (%rax),%edx
  100613:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100617:	88 10                	mov    %dl,(%rax)
        val /= base;
  100619:	8b 45 dc             	mov    -0x24(%rbp),%eax
  10061c:	48 63 f0             	movslq %eax,%rsi
  10061f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100623:	ba 00 00 00 00       	mov    $0x0,%edx
  100628:	48 f7 f6             	div    %rsi
  10062b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    } while (val != 0);
  10062f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  100634:	75 bc                	jne    1005f2 <fill_numbuf+0x38>
    return numbuf_end;
  100636:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  10063a:	c9                   	leave
  10063b:	c3                   	ret

000000000010063c <printer_vprintf>:
#define FLAG_NUMERIC            (1<<5)
#define FLAG_SIGNED             (1<<6)
#define FLAG_NEGATIVE           (1<<7)
#define FLAG_ALT2               (1<<8)

void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  10063c:	55                   	push   %rbp
  10063d:	48 89 e5             	mov    %rsp,%rbp
  100640:	53                   	push   %rbx
  100641:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  100648:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
  10064f:	89 b5 74 ff ff ff    	mov    %esi,-0x8c(%rbp)
  100655:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  10065c:	48 89 8d 60 ff ff ff 	mov    %rcx,-0xa0(%rbp)
#define NUMBUFSIZ 24
    char numbuf[NUMBUFSIZ];

    for (; *format; ++format) {
  100663:	e9 8a 09 00 00       	jmp    100ff2 <printer_vprintf+0x9b6>
        if (*format != '%') {
  100668:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10066f:	0f b6 00             	movzbl (%rax),%eax
  100672:	3c 25                	cmp    $0x25,%al
  100674:	74 31                	je     1006a7 <printer_vprintf+0x6b>
            p->putc(p, *format, color);
  100676:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  10067d:	4c 8b 00             	mov    (%rax),%r8
  100680:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100687:	0f b6 00             	movzbl (%rax),%eax
  10068a:	0f b6 c8             	movzbl %al,%ecx
  10068d:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100693:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  10069a:	89 ce                	mov    %ecx,%esi
  10069c:	48 89 c7             	mov    %rax,%rdi
  10069f:	41 ff d0             	call   *%r8
            continue;
  1006a2:	e9 43 09 00 00       	jmp    100fea <printer_vprintf+0x9ae>
        }

        // process flags
        int flags = 0;
  1006a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        for (++format; *format; ++format) {
  1006ae:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1006b5:	01 
  1006b6:	eb 44                	jmp    1006fc <printer_vprintf+0xc0>
            const char* flagc = strchr(flag_chars, *format);
  1006b8:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1006bf:	0f b6 00             	movzbl (%rax),%eax
  1006c2:	0f be c0             	movsbl %al,%eax
  1006c5:	89 c6                	mov    %eax,%esi
  1006c7:	bf a0 13 10 00       	mov    $0x1013a0,%edi
  1006cc:	e8 42 fe ff ff       	call   100513 <strchr>
  1006d1:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (flagc) {
  1006d5:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  1006da:	74 30                	je     10070c <printer_vprintf+0xd0>
                flags |= 1 << (flagc - flag_chars);
  1006dc:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  1006e0:	48 2d a0 13 10 00    	sub    $0x1013a0,%rax
  1006e6:	ba 01 00 00 00       	mov    $0x1,%edx
  1006eb:	89 c1                	mov    %eax,%ecx
  1006ed:	d3 e2                	shl    %cl,%edx
  1006ef:	89 d0                	mov    %edx,%eax
  1006f1:	09 45 ec             	or     %eax,-0x14(%rbp)
        for (++format; *format; ++format) {
  1006f4:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1006fb:	01 
  1006fc:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100703:	0f b6 00             	movzbl (%rax),%eax
  100706:	84 c0                	test   %al,%al
  100708:	75 ae                	jne    1006b8 <printer_vprintf+0x7c>
  10070a:	eb 01                	jmp    10070d <printer_vprintf+0xd1>
            } else {
                break;
  10070c:	90                   	nop
            }
        }

        // process width
        int width = -1;
  10070d:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
        if (*format >= '1' && *format <= '9') {
  100714:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10071b:	0f b6 00             	movzbl (%rax),%eax
  10071e:	3c 30                	cmp    $0x30,%al
  100720:	7e 67                	jle    100789 <printer_vprintf+0x14d>
  100722:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100729:	0f b6 00             	movzbl (%rax),%eax
  10072c:	3c 39                	cmp    $0x39,%al
  10072e:	7f 59                	jg     100789 <printer_vprintf+0x14d>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100730:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  100737:	eb 2e                	jmp    100767 <printer_vprintf+0x12b>
                width = 10 * width + *format++ - '0';
  100739:	8b 55 e8             	mov    -0x18(%rbp),%edx
  10073c:	89 d0                	mov    %edx,%eax
  10073e:	c1 e0 02             	shl    $0x2,%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	01 c0                	add    %eax,%eax
  100745:	89 c1                	mov    %eax,%ecx
  100747:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10074e:	48 8d 50 01          	lea    0x1(%rax),%rdx
  100752:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  100759:	0f b6 00             	movzbl (%rax),%eax
  10075c:	0f be c0             	movsbl %al,%eax
  10075f:	01 c8                	add    %ecx,%eax
  100761:	83 e8 30             	sub    $0x30,%eax
  100764:	89 45 e8             	mov    %eax,-0x18(%rbp)
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100767:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10076e:	0f b6 00             	movzbl (%rax),%eax
  100771:	3c 2f                	cmp    $0x2f,%al
  100773:	0f 8e 85 00 00 00    	jle    1007fe <printer_vprintf+0x1c2>
  100779:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100780:	0f b6 00             	movzbl (%rax),%eax
  100783:	3c 39                	cmp    $0x39,%al
  100785:	7e b2                	jle    100739 <printer_vprintf+0xfd>
        if (*format >= '1' && *format <= '9') {
  100787:	eb 75                	jmp    1007fe <printer_vprintf+0x1c2>
            }
        } else if (*format == '*') {
  100789:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100790:	0f b6 00             	movzbl (%rax),%eax
  100793:	3c 2a                	cmp    $0x2a,%al
  100795:	75 68                	jne    1007ff <printer_vprintf+0x1c3>
            width = va_arg(val, int);
  100797:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  10079e:	8b 00                	mov    (%rax),%eax
  1007a0:	83 f8 2f             	cmp    $0x2f,%eax
  1007a3:	77 30                	ja     1007d5 <printer_vprintf+0x199>
  1007a5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1007ac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1007b0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1007b7:	8b 00                	mov    (%rax),%eax
  1007b9:	89 c0                	mov    %eax,%eax
  1007bb:	48 01 d0             	add    %rdx,%rax
  1007be:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1007c5:	8b 12                	mov    (%rdx),%edx
  1007c7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1007ca:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1007d1:	89 0a                	mov    %ecx,(%rdx)
  1007d3:	eb 1a                	jmp    1007ef <printer_vprintf+0x1b3>
  1007d5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1007dc:	48 8b 40 08          	mov    0x8(%rax),%rax
  1007e0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1007e4:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1007eb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1007ef:	8b 00                	mov    (%rax),%eax
  1007f1:	89 45 e8             	mov    %eax,-0x18(%rbp)
            ++format;
  1007f4:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1007fb:	01 
  1007fc:	eb 01                	jmp    1007ff <printer_vprintf+0x1c3>
        if (*format >= '1' && *format <= '9') {
  1007fe:	90                   	nop
        }

        // process precision
        int precision = -1;
  1007ff:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
        if (*format == '.') {
  100806:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10080d:	0f b6 00             	movzbl (%rax),%eax
  100810:	3c 2e                	cmp    $0x2e,%al
  100812:	0f 85 00 01 00 00    	jne    100918 <printer_vprintf+0x2dc>
            ++format;
  100818:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  10081f:	01 
            if (*format >= '0' && *format <= '9') {
  100820:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100827:	0f b6 00             	movzbl (%rax),%eax
  10082a:	3c 2f                	cmp    $0x2f,%al
  10082c:	7e 67                	jle    100895 <printer_vprintf+0x259>
  10082e:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100835:	0f b6 00             	movzbl (%rax),%eax
  100838:	3c 39                	cmp    $0x39,%al
  10083a:	7f 59                	jg     100895 <printer_vprintf+0x259>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  10083c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  100843:	eb 2e                	jmp    100873 <printer_vprintf+0x237>
                    precision = 10 * precision + *format++ - '0';
  100845:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  100848:	89 d0                	mov    %edx,%eax
  10084a:	c1 e0 02             	shl    $0x2,%eax
  10084d:	01 d0                	add    %edx,%eax
  10084f:	01 c0                	add    %eax,%eax
  100851:	89 c1                	mov    %eax,%ecx
  100853:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10085a:	48 8d 50 01          	lea    0x1(%rax),%rdx
  10085e:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  100865:	0f b6 00             	movzbl (%rax),%eax
  100868:	0f be c0             	movsbl %al,%eax
  10086b:	01 c8                	add    %ecx,%eax
  10086d:	83 e8 30             	sub    $0x30,%eax
  100870:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100873:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10087a:	0f b6 00             	movzbl (%rax),%eax
  10087d:	3c 2f                	cmp    $0x2f,%al
  10087f:	0f 8e 85 00 00 00    	jle    10090a <printer_vprintf+0x2ce>
  100885:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10088c:	0f b6 00             	movzbl (%rax),%eax
  10088f:	3c 39                	cmp    $0x39,%al
  100891:	7e b2                	jle    100845 <printer_vprintf+0x209>
            if (*format >= '0' && *format <= '9') {
  100893:	eb 75                	jmp    10090a <printer_vprintf+0x2ce>
                }
            } else if (*format == '*') {
  100895:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10089c:	0f b6 00             	movzbl (%rax),%eax
  10089f:	3c 2a                	cmp    $0x2a,%al
  1008a1:	75 68                	jne    10090b <printer_vprintf+0x2cf>
                precision = va_arg(val, int);
  1008a3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008aa:	8b 00                	mov    (%rax),%eax
  1008ac:	83 f8 2f             	cmp    $0x2f,%eax
  1008af:	77 30                	ja     1008e1 <printer_vprintf+0x2a5>
  1008b1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008b8:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1008bc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008c3:	8b 00                	mov    (%rax),%eax
  1008c5:	89 c0                	mov    %eax,%eax
  1008c7:	48 01 d0             	add    %rdx,%rax
  1008ca:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1008d1:	8b 12                	mov    (%rdx),%edx
  1008d3:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1008d6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1008dd:	89 0a                	mov    %ecx,(%rdx)
  1008df:	eb 1a                	jmp    1008fb <printer_vprintf+0x2bf>
  1008e1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008e8:	48 8b 40 08          	mov    0x8(%rax),%rax
  1008ec:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1008f0:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1008f7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1008fb:	8b 00                	mov    (%rax),%eax
  1008fd:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                ++format;
  100900:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100907:	01 
  100908:	eb 01                	jmp    10090b <printer_vprintf+0x2cf>
            if (*format >= '0' && *format <= '9') {
  10090a:	90                   	nop
            }
            if (precision < 0) {
  10090b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  10090f:	79 07                	jns    100918 <printer_vprintf+0x2dc>
                precision = 0;
  100911:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
            }
        }

        // process main conversion character
        int base = 10;
  100918:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%rbp)
        unsigned long num = 0;
  10091f:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  100926:	00 
        int length = 0;
  100927:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
        char* data = "";
  10092e:	48 c7 45 c8 a6 13 10 	movq   $0x1013a6,-0x38(%rbp)
  100935:	00 
    again:
        switch (*format) {
  100936:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10093d:	0f b6 00             	movzbl (%rax),%eax
  100940:	0f be c0             	movsbl %al,%eax
  100943:	83 e8 43             	sub    $0x43,%eax
  100946:	83 f8 37             	cmp    $0x37,%eax
  100949:	0f 87 9f 03 00 00    	ja     100cee <printer_vprintf+0x6b2>
  10094f:	89 c0                	mov    %eax,%eax
  100951:	48 8b 04 c5 b8 13 10 	mov    0x1013b8(,%rax,8),%rax
  100958:	00 
  100959:	ff e0                	jmp    *%rax
        case 'l':
        case 'z':
            length = 1;
  10095b:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
            ++format;
  100962:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100969:	01 
            goto again;
  10096a:	eb ca                	jmp    100936 <printer_vprintf+0x2fa>
        case 'd':
        case 'i': {
            long x = length ? va_arg(val, long) : va_arg(val, int);
  10096c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  100970:	74 5d                	je     1009cf <printer_vprintf+0x393>
  100972:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100979:	8b 00                	mov    (%rax),%eax
  10097b:	83 f8 2f             	cmp    $0x2f,%eax
  10097e:	77 30                	ja     1009b0 <printer_vprintf+0x374>
  100980:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100987:	48 8b 50 10          	mov    0x10(%rax),%rdx
  10098b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100992:	8b 00                	mov    (%rax),%eax
  100994:	89 c0                	mov    %eax,%eax
  100996:	48 01 d0             	add    %rdx,%rax
  100999:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009a0:	8b 12                	mov    (%rdx),%edx
  1009a2:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1009a5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009ac:	89 0a                	mov    %ecx,(%rdx)
  1009ae:	eb 1a                	jmp    1009ca <printer_vprintf+0x38e>
  1009b0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009b7:	48 8b 40 08          	mov    0x8(%rax),%rax
  1009bb:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1009bf:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009c6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1009ca:	48 8b 00             	mov    (%rax),%rax
  1009cd:	eb 5c                	jmp    100a2b <printer_vprintf+0x3ef>
  1009cf:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009d6:	8b 00                	mov    (%rax),%eax
  1009d8:	83 f8 2f             	cmp    $0x2f,%eax
  1009db:	77 30                	ja     100a0d <printer_vprintf+0x3d1>
  1009dd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009e4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1009e8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009ef:	8b 00                	mov    (%rax),%eax
  1009f1:	89 c0                	mov    %eax,%eax
  1009f3:	48 01 d0             	add    %rdx,%rax
  1009f6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009fd:	8b 12                	mov    (%rdx),%edx
  1009ff:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100a02:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a09:	89 0a                	mov    %ecx,(%rdx)
  100a0b:	eb 1a                	jmp    100a27 <printer_vprintf+0x3eb>
  100a0d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a14:	48 8b 40 08          	mov    0x8(%rax),%rax
  100a18:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100a1c:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a23:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100a27:	8b 00                	mov    (%rax),%eax
  100a29:	48 98                	cltq
  100a2b:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  100a2f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100a33:	48 c1 f8 38          	sar    $0x38,%rax
  100a37:	25 80 00 00 00       	and    $0x80,%eax
  100a3c:	89 45 a4             	mov    %eax,-0x5c(%rbp)
            num = negative ? -x : x;
  100a3f:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  100a43:	74 09                	je     100a4e <printer_vprintf+0x412>
  100a45:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100a49:	48 f7 d8             	neg    %rax
  100a4c:	eb 04                	jmp    100a52 <printer_vprintf+0x416>
  100a4e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100a52:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  100a56:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  100a59:	83 c8 60             	or     $0x60,%eax
  100a5c:	09 45 ec             	or     %eax,-0x14(%rbp)
            break;
  100a5f:	e9 cf 02 00 00       	jmp    100d33 <printer_vprintf+0x6f7>
        }
        case 'u':
        format_unsigned:
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100a64:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  100a68:	74 5d                	je     100ac7 <printer_vprintf+0x48b>
  100a6a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a71:	8b 00                	mov    (%rax),%eax
  100a73:	83 f8 2f             	cmp    $0x2f,%eax
  100a76:	77 30                	ja     100aa8 <printer_vprintf+0x46c>
  100a78:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a7f:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100a83:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a8a:	8b 00                	mov    (%rax),%eax
  100a8c:	89 c0                	mov    %eax,%eax
  100a8e:	48 01 d0             	add    %rdx,%rax
  100a91:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a98:	8b 12                	mov    (%rdx),%edx
  100a9a:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100a9d:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100aa4:	89 0a                	mov    %ecx,(%rdx)
  100aa6:	eb 1a                	jmp    100ac2 <printer_vprintf+0x486>
  100aa8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100aaf:	48 8b 40 08          	mov    0x8(%rax),%rax
  100ab3:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100ab7:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100abe:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100ac2:	48 8b 00             	mov    (%rax),%rax
  100ac5:	eb 5c                	jmp    100b23 <printer_vprintf+0x4e7>
  100ac7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ace:	8b 00                	mov    (%rax),%eax
  100ad0:	83 f8 2f             	cmp    $0x2f,%eax
  100ad3:	77 30                	ja     100b05 <printer_vprintf+0x4c9>
  100ad5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100adc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100ae0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ae7:	8b 00                	mov    (%rax),%eax
  100ae9:	89 c0                	mov    %eax,%eax
  100aeb:	48 01 d0             	add    %rdx,%rax
  100aee:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100af5:	8b 12                	mov    (%rdx),%edx
  100af7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100afa:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b01:	89 0a                	mov    %ecx,(%rdx)
  100b03:	eb 1a                	jmp    100b1f <printer_vprintf+0x4e3>
  100b05:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b0c:	48 8b 40 08          	mov    0x8(%rax),%rax
  100b10:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100b14:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b1b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100b1f:	8b 00                	mov    (%rax),%eax
  100b21:	89 c0                	mov    %eax,%eax
  100b23:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC;
  100b27:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
            break;
  100b2b:	e9 03 02 00 00       	jmp    100d33 <printer_vprintf+0x6f7>
        case 'x':
            base = -16;
  100b30:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            goto format_unsigned;
  100b37:	e9 28 ff ff ff       	jmp    100a64 <printer_vprintf+0x428>
        case 'X':
            base = 16;
  100b3c:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%rbp)
            goto format_unsigned;
  100b43:	e9 1c ff ff ff       	jmp    100a64 <printer_vprintf+0x428>
        case 'p':
            num = (uintptr_t) va_arg(val, void*);
  100b48:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b4f:	8b 00                	mov    (%rax),%eax
  100b51:	83 f8 2f             	cmp    $0x2f,%eax
  100b54:	77 30                	ja     100b86 <printer_vprintf+0x54a>
  100b56:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b5d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100b61:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b68:	8b 00                	mov    (%rax),%eax
  100b6a:	89 c0                	mov    %eax,%eax
  100b6c:	48 01 d0             	add    %rdx,%rax
  100b6f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b76:	8b 12                	mov    (%rdx),%edx
  100b78:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100b7b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b82:	89 0a                	mov    %ecx,(%rdx)
  100b84:	eb 1a                	jmp    100ba0 <printer_vprintf+0x564>
  100b86:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b8d:	48 8b 40 08          	mov    0x8(%rax),%rax
  100b91:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100b95:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b9c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100ba0:	48 8b 00             	mov    (%rax),%rax
  100ba3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            base = -16;
  100ba7:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  100bae:	81 4d ec 21 01 00 00 	orl    $0x121,-0x14(%rbp)
            break;
  100bb5:	e9 79 01 00 00       	jmp    100d33 <printer_vprintf+0x6f7>
        case 's':
            data = va_arg(val, char*);
  100bba:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100bc1:	8b 00                	mov    (%rax),%eax
  100bc3:	83 f8 2f             	cmp    $0x2f,%eax
  100bc6:	77 30                	ja     100bf8 <printer_vprintf+0x5bc>
  100bc8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100bcf:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100bd3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100bda:	8b 00                	mov    (%rax),%eax
  100bdc:	89 c0                	mov    %eax,%eax
  100bde:	48 01 d0             	add    %rdx,%rax
  100be1:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100be8:	8b 12                	mov    (%rdx),%edx
  100bea:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100bed:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100bf4:	89 0a                	mov    %ecx,(%rdx)
  100bf6:	eb 1a                	jmp    100c12 <printer_vprintf+0x5d6>
  100bf8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100bff:	48 8b 40 08          	mov    0x8(%rax),%rax
  100c03:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100c07:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c0e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100c12:	48 8b 00             	mov    (%rax),%rax
  100c15:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            break;
  100c19:	e9 15 01 00 00       	jmp    100d33 <printer_vprintf+0x6f7>
        case 'C':
            color = va_arg(val, int);
  100c1e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c25:	8b 00                	mov    (%rax),%eax
  100c27:	83 f8 2f             	cmp    $0x2f,%eax
  100c2a:	77 30                	ja     100c5c <printer_vprintf+0x620>
  100c2c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c33:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100c37:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c3e:	8b 00                	mov    (%rax),%eax
  100c40:	89 c0                	mov    %eax,%eax
  100c42:	48 01 d0             	add    %rdx,%rax
  100c45:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c4c:	8b 12                	mov    (%rdx),%edx
  100c4e:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100c51:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c58:	89 0a                	mov    %ecx,(%rdx)
  100c5a:	eb 1a                	jmp    100c76 <printer_vprintf+0x63a>
  100c5c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c63:	48 8b 40 08          	mov    0x8(%rax),%rax
  100c67:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100c6b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c72:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100c76:	8b 00                	mov    (%rax),%eax
  100c78:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
            goto done;
  100c7e:	e9 67 03 00 00       	jmp    100fea <printer_vprintf+0x9ae>
        case 'c':
            data = numbuf;
  100c83:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100c87:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = va_arg(val, int);
  100c8b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c92:	8b 00                	mov    (%rax),%eax
  100c94:	83 f8 2f             	cmp    $0x2f,%eax
  100c97:	77 30                	ja     100cc9 <printer_vprintf+0x68d>
  100c99:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ca0:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100ca4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100cab:	8b 00                	mov    (%rax),%eax
  100cad:	89 c0                	mov    %eax,%eax
  100caf:	48 01 d0             	add    %rdx,%rax
  100cb2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100cb9:	8b 12                	mov    (%rdx),%edx
  100cbb:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100cbe:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100cc5:	89 0a                	mov    %ecx,(%rdx)
  100cc7:	eb 1a                	jmp    100ce3 <printer_vprintf+0x6a7>
  100cc9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100cd0:	48 8b 40 08          	mov    0x8(%rax),%rax
  100cd4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100cd8:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100cdf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100ce3:	8b 00                	mov    (%rax),%eax
  100ce5:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  100ce8:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            break;
  100cec:	eb 45                	jmp    100d33 <printer_vprintf+0x6f7>
        default:
            data = numbuf;
  100cee:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100cf2:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = (*format ? *format : '%');
  100cf6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100cfd:	0f b6 00             	movzbl (%rax),%eax
  100d00:	84 c0                	test   %al,%al
  100d02:	74 0c                	je     100d10 <printer_vprintf+0x6d4>
  100d04:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100d0b:	0f b6 00             	movzbl (%rax),%eax
  100d0e:	eb 05                	jmp    100d15 <printer_vprintf+0x6d9>
  100d10:	b8 25 00 00 00       	mov    $0x25,%eax
  100d15:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  100d18:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            if (!*format) {
  100d1c:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100d23:	0f b6 00             	movzbl (%rax),%eax
  100d26:	84 c0                	test   %al,%al
  100d28:	75 08                	jne    100d32 <printer_vprintf+0x6f6>
                format--;
  100d2a:	48 83 ad 68 ff ff ff 	subq   $0x1,-0x98(%rbp)
  100d31:	01 
            }
            break;
  100d32:	90                   	nop
        }

        if (flags & FLAG_NUMERIC) {
  100d33:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100d36:	83 e0 20             	and    $0x20,%eax
  100d39:	85 c0                	test   %eax,%eax
  100d3b:	74 1e                	je     100d5b <printer_vprintf+0x71f>
            data = fill_numbuf(numbuf + NUMBUFSIZ, num, base);
  100d3d:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100d41:	48 83 c0 18          	add    $0x18,%rax
  100d45:	8b 55 e0             	mov    -0x20(%rbp),%edx
  100d48:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  100d4c:	48 89 ce             	mov    %rcx,%rsi
  100d4f:	48 89 c7             	mov    %rax,%rdi
  100d52:	e8 63 f8 ff ff       	call   1005ba <fill_numbuf>
  100d57:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        }

        const char* prefix = "";
  100d5b:	48 c7 45 c0 a6 13 10 	movq   $0x1013a6,-0x40(%rbp)
  100d62:	00 
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  100d63:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100d66:	83 e0 20             	and    $0x20,%eax
  100d69:	85 c0                	test   %eax,%eax
  100d6b:	74 48                	je     100db5 <printer_vprintf+0x779>
  100d6d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100d70:	83 e0 40             	and    $0x40,%eax
  100d73:	85 c0                	test   %eax,%eax
  100d75:	74 3e                	je     100db5 <printer_vprintf+0x779>
            if (flags & FLAG_NEGATIVE) {
  100d77:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100d7a:	25 80 00 00 00       	and    $0x80,%eax
  100d7f:	85 c0                	test   %eax,%eax
  100d81:	74 0a                	je     100d8d <printer_vprintf+0x751>
                prefix = "-";
  100d83:	48 c7 45 c0 a7 13 10 	movq   $0x1013a7,-0x40(%rbp)
  100d8a:	00 
            if (flags & FLAG_NEGATIVE) {
  100d8b:	eb 73                	jmp    100e00 <printer_vprintf+0x7c4>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100d8d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100d90:	83 e0 10             	and    $0x10,%eax
  100d93:	85 c0                	test   %eax,%eax
  100d95:	74 0a                	je     100da1 <printer_vprintf+0x765>
                prefix = "+";
  100d97:	48 c7 45 c0 a9 13 10 	movq   $0x1013a9,-0x40(%rbp)
  100d9e:	00 
            if (flags & FLAG_NEGATIVE) {
  100d9f:	eb 5f                	jmp    100e00 <printer_vprintf+0x7c4>
            } else if (flags & FLAG_SPACEPOSITIVE) {
  100da1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100da4:	83 e0 08             	and    $0x8,%eax
  100da7:	85 c0                	test   %eax,%eax
  100da9:	74 55                	je     100e00 <printer_vprintf+0x7c4>
                prefix = " ";
  100dab:	48 c7 45 c0 ab 13 10 	movq   $0x1013ab,-0x40(%rbp)
  100db2:	00 
            if (flags & FLAG_NEGATIVE) {
  100db3:	eb 4b                	jmp    100e00 <printer_vprintf+0x7c4>
            }
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100db5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100db8:	83 e0 20             	and    $0x20,%eax
  100dbb:	85 c0                	test   %eax,%eax
  100dbd:	74 42                	je     100e01 <printer_vprintf+0x7c5>
  100dbf:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100dc2:	83 e0 01             	and    $0x1,%eax
  100dc5:	85 c0                	test   %eax,%eax
  100dc7:	74 38                	je     100e01 <printer_vprintf+0x7c5>
                   && (base == 16 || base == -16)
  100dc9:	83 7d e0 10          	cmpl   $0x10,-0x20(%rbp)
  100dcd:	74 06                	je     100dd5 <printer_vprintf+0x799>
  100dcf:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  100dd3:	75 2c                	jne    100e01 <printer_vprintf+0x7c5>
                   && (num || (flags & FLAG_ALT2))) {
  100dd5:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  100dda:	75 0c                	jne    100de8 <printer_vprintf+0x7ac>
  100ddc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100ddf:	25 00 01 00 00       	and    $0x100,%eax
  100de4:	85 c0                	test   %eax,%eax
  100de6:	74 19                	je     100e01 <printer_vprintf+0x7c5>
            prefix = (base == -16 ? "0x" : "0X");
  100de8:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  100dec:	75 07                	jne    100df5 <printer_vprintf+0x7b9>
  100dee:	b8 ad 13 10 00       	mov    $0x1013ad,%eax
  100df3:	eb 05                	jmp    100dfa <printer_vprintf+0x7be>
  100df5:	b8 b0 13 10 00       	mov    $0x1013b0,%eax
  100dfa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100dfe:	eb 01                	jmp    100e01 <printer_vprintf+0x7c5>
            if (flags & FLAG_NEGATIVE) {
  100e00:	90                   	nop
        }

        int len;
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  100e01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  100e05:	78 24                	js     100e2b <printer_vprintf+0x7ef>
  100e07:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100e0a:	83 e0 20             	and    $0x20,%eax
  100e0d:	85 c0                	test   %eax,%eax
  100e0f:	75 1a                	jne    100e2b <printer_vprintf+0x7ef>
            len = strnlen(data, precision);
  100e11:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100e14:	48 63 d0             	movslq %eax,%rdx
  100e17:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100e1b:	48 89 d6             	mov    %rdx,%rsi
  100e1e:	48 89 c7             	mov    %rax,%rdi
  100e21:	e8 ea f5 ff ff       	call   100410 <strnlen>
  100e26:	89 45 bc             	mov    %eax,-0x44(%rbp)
  100e29:	eb 0f                	jmp    100e3a <printer_vprintf+0x7fe>
        } else {
            len = strlen(data);
  100e2b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100e2f:	48 89 c7             	mov    %rax,%rdi
  100e32:	e8 a8 f5 ff ff       	call   1003df <strlen>
  100e37:	89 45 bc             	mov    %eax,-0x44(%rbp)
        }
        int zeros;
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  100e3a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100e3d:	83 e0 20             	and    $0x20,%eax
  100e40:	85 c0                	test   %eax,%eax
  100e42:	74 20                	je     100e64 <printer_vprintf+0x828>
  100e44:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  100e48:	78 1a                	js     100e64 <printer_vprintf+0x828>
            zeros = precision > len ? precision - len : 0;
  100e4a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100e4d:	3b 45 bc             	cmp    -0x44(%rbp),%eax
  100e50:	7e 08                	jle    100e5a <printer_vprintf+0x81e>
  100e52:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100e55:	2b 45 bc             	sub    -0x44(%rbp),%eax
  100e58:	eb 05                	jmp    100e5f <printer_vprintf+0x823>
  100e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  100e5f:	89 45 b8             	mov    %eax,-0x48(%rbp)
  100e62:	eb 5c                	jmp    100ec0 <printer_vprintf+0x884>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100e64:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100e67:	83 e0 20             	and    $0x20,%eax
  100e6a:	85 c0                	test   %eax,%eax
  100e6c:	74 4b                	je     100eb9 <printer_vprintf+0x87d>
  100e6e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100e71:	83 e0 02             	and    $0x2,%eax
  100e74:	85 c0                	test   %eax,%eax
  100e76:	74 41                	je     100eb9 <printer_vprintf+0x87d>
                   && !(flags & FLAG_LEFTJUSTIFY)
  100e78:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100e7b:	83 e0 04             	and    $0x4,%eax
  100e7e:	85 c0                	test   %eax,%eax
  100e80:	75 37                	jne    100eb9 <printer_vprintf+0x87d>
                   && len + (int) strlen(prefix) < width) {
  100e82:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100e86:	48 89 c7             	mov    %rax,%rdi
  100e89:	e8 51 f5 ff ff       	call   1003df <strlen>
  100e8e:	89 c2                	mov    %eax,%edx
  100e90:	8b 45 bc             	mov    -0x44(%rbp),%eax
  100e93:	01 d0                	add    %edx,%eax
  100e95:	39 45 e8             	cmp    %eax,-0x18(%rbp)
  100e98:	7e 1f                	jle    100eb9 <printer_vprintf+0x87d>
            zeros = width - len - strlen(prefix);
  100e9a:	8b 45 e8             	mov    -0x18(%rbp),%eax
  100e9d:	2b 45 bc             	sub    -0x44(%rbp),%eax
  100ea0:	89 c3                	mov    %eax,%ebx
  100ea2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100ea6:	48 89 c7             	mov    %rax,%rdi
  100ea9:	e8 31 f5 ff ff       	call   1003df <strlen>
  100eae:	89 c2                	mov    %eax,%edx
  100eb0:	89 d8                	mov    %ebx,%eax
  100eb2:	29 d0                	sub    %edx,%eax
  100eb4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  100eb7:	eb 07                	jmp    100ec0 <printer_vprintf+0x884>
        } else {
            zeros = 0;
  100eb9:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
        }
        width -= len + zeros + strlen(prefix);
  100ec0:	8b 55 bc             	mov    -0x44(%rbp),%edx
  100ec3:	8b 45 b8             	mov    -0x48(%rbp),%eax
  100ec6:	01 d0                	add    %edx,%eax
  100ec8:	48 63 d8             	movslq %eax,%rbx
  100ecb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100ecf:	48 89 c7             	mov    %rax,%rdi
  100ed2:	e8 08 f5 ff ff       	call   1003df <strlen>
  100ed7:	48 8d 14 03          	lea    (%rbx,%rax,1),%rdx
  100edb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  100ede:	29 d0                	sub    %edx,%eax
  100ee0:	89 45 e8             	mov    %eax,-0x18(%rbp)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100ee3:	eb 25                	jmp    100f0a <printer_vprintf+0x8ce>
            p->putc(p, ' ', color);
  100ee5:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100eec:	48 8b 08             	mov    (%rax),%rcx
  100eef:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100ef5:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100efc:	be 20 00 00 00       	mov    $0x20,%esi
  100f01:	48 89 c7             	mov    %rax,%rdi
  100f04:	ff d1                	call   *%rcx
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100f06:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  100f0a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100f0d:	83 e0 04             	and    $0x4,%eax
  100f10:	85 c0                	test   %eax,%eax
  100f12:	75 36                	jne    100f4a <printer_vprintf+0x90e>
  100f14:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  100f18:	7f cb                	jg     100ee5 <printer_vprintf+0x8a9>
        }
        for (; *prefix; ++prefix) {
  100f1a:	eb 2e                	jmp    100f4a <printer_vprintf+0x90e>
            p->putc(p, *prefix, color);
  100f1c:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f23:	4c 8b 00             	mov    (%rax),%r8
  100f26:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100f2a:	0f b6 00             	movzbl (%rax),%eax
  100f2d:	0f b6 c8             	movzbl %al,%ecx
  100f30:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100f36:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f3d:	89 ce                	mov    %ecx,%esi
  100f3f:	48 89 c7             	mov    %rax,%rdi
  100f42:	41 ff d0             	call   *%r8
        for (; *prefix; ++prefix) {
  100f45:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  100f4a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100f4e:	0f b6 00             	movzbl (%rax),%eax
  100f51:	84 c0                	test   %al,%al
  100f53:	75 c7                	jne    100f1c <printer_vprintf+0x8e0>
        }
        for (; zeros > 0; --zeros) {
  100f55:	eb 25                	jmp    100f7c <printer_vprintf+0x940>
            p->putc(p, '0', color);
  100f57:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f5e:	48 8b 08             	mov    (%rax),%rcx
  100f61:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100f67:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f6e:	be 30 00 00 00       	mov    $0x30,%esi
  100f73:	48 89 c7             	mov    %rax,%rdi
  100f76:	ff d1                	call   *%rcx
        for (; zeros > 0; --zeros) {
  100f78:	83 6d b8 01          	subl   $0x1,-0x48(%rbp)
  100f7c:	83 7d b8 00          	cmpl   $0x0,-0x48(%rbp)
  100f80:	7f d5                	jg     100f57 <printer_vprintf+0x91b>
        }
        for (; len > 0; ++data, --len) {
  100f82:	eb 32                	jmp    100fb6 <printer_vprintf+0x97a>
            p->putc(p, *data, color);
  100f84:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f8b:	4c 8b 00             	mov    (%rax),%r8
  100f8e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100f92:	0f b6 00             	movzbl (%rax),%eax
  100f95:	0f b6 c8             	movzbl %al,%ecx
  100f98:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100f9e:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100fa5:	89 ce                	mov    %ecx,%esi
  100fa7:	48 89 c7             	mov    %rax,%rdi
  100faa:	41 ff d0             	call   *%r8
        for (; len > 0; ++data, --len) {
  100fad:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  100fb2:	83 6d bc 01          	subl   $0x1,-0x44(%rbp)
  100fb6:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  100fba:	7f c8                	jg     100f84 <printer_vprintf+0x948>
        }
        for (; width > 0; --width) {
  100fbc:	eb 25                	jmp    100fe3 <printer_vprintf+0x9a7>
            p->putc(p, ' ', color);
  100fbe:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100fc5:	48 8b 08             	mov    (%rax),%rcx
  100fc8:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100fce:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100fd5:	be 20 00 00 00       	mov    $0x20,%esi
  100fda:	48 89 c7             	mov    %rax,%rdi
  100fdd:	ff d1                	call   *%rcx
        for (; width > 0; --width) {
  100fdf:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  100fe3:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  100fe7:	7f d5                	jg     100fbe <printer_vprintf+0x982>
        }
    done: ;
  100fe9:	90                   	nop
    for (; *format; ++format) {
  100fea:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100ff1:	01 
  100ff2:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100ff9:	0f b6 00             	movzbl (%rax),%eax
  100ffc:	84 c0                	test   %al,%al
  100ffe:	0f 85 64 f6 ff ff    	jne    100668 <printer_vprintf+0x2c>
    }
}
  101004:	90                   	nop
  101005:	90                   	nop
  101006:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  10100a:	c9                   	leave
  10100b:	c3                   	ret

000000000010100c <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  10100c:	55                   	push   %rbp
  10100d:	48 89 e5             	mov    %rsp,%rbp
  101010:	48 83 ec 20          	sub    $0x20,%rsp
  101014:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  101018:	89 f0                	mov    %esi,%eax
  10101a:	89 55 e0             	mov    %edx,-0x20(%rbp)
  10101d:	88 45 e4             	mov    %al,-0x1c(%rbp)
    console_printer* cp = (console_printer*) p;
  101020:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  101024:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  101028:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10102c:	48 8b 40 08          	mov    0x8(%rax),%rax
  101030:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
  101035:	48 39 d0             	cmp    %rdx,%rax
  101038:	72 0c                	jb     101046 <console_putc+0x3a>
        cp->cursor = console;
  10103a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10103e:	48 c7 40 08 00 80 0b 	movq   $0xb8000,0x8(%rax)
  101045:	00 
    }
    if (c == '\n') {
  101046:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%rbp)
  10104a:	75 78                	jne    1010c4 <console_putc+0xb8>
        int pos = (cp->cursor - console) % 80;
  10104c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  101050:	48 8b 40 08          	mov    0x8(%rax),%rax
  101054:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  10105a:	48 d1 f8             	sar    %rax
  10105d:	48 89 c1             	mov    %rax,%rcx
  101060:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  101067:	66 66 66 
  10106a:	48 89 c8             	mov    %rcx,%rax
  10106d:	48 f7 ea             	imul   %rdx
  101070:	48 c1 fa 05          	sar    $0x5,%rdx
  101074:	48 89 c8             	mov    %rcx,%rax
  101077:	48 c1 f8 3f          	sar    $0x3f,%rax
  10107b:	48 29 c2             	sub    %rax,%rdx
  10107e:	48 89 d0             	mov    %rdx,%rax
  101081:	48 c1 e0 02          	shl    $0x2,%rax
  101085:	48 01 d0             	add    %rdx,%rax
  101088:	48 c1 e0 04          	shl    $0x4,%rax
  10108c:	48 29 c1             	sub    %rax,%rcx
  10108f:	48 89 ca             	mov    %rcx,%rdx
  101092:	89 55 fc             	mov    %edx,-0x4(%rbp)
        for (; pos != 80; pos++) {
  101095:	eb 25                	jmp    1010bc <console_putc+0xb0>
            *cp->cursor++ = ' ' | color;
  101097:	8b 45 e0             	mov    -0x20(%rbp),%eax
  10109a:	83 c8 20             	or     $0x20,%eax
  10109d:	89 c6                	mov    %eax,%esi
  10109f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1010a3:	48 8b 40 08          	mov    0x8(%rax),%rax
  1010a7:	48 8d 48 02          	lea    0x2(%rax),%rcx
  1010ab:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  1010af:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1010b3:	89 f2                	mov    %esi,%edx
  1010b5:	66 89 10             	mov    %dx,(%rax)
        for (; pos != 80; pos++) {
  1010b8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  1010bc:	83 7d fc 50          	cmpl   $0x50,-0x4(%rbp)
  1010c0:	75 d5                	jne    101097 <console_putc+0x8b>
        }
    } else {
        *cp->cursor++ = c | color;
    }
}
  1010c2:	eb 24                	jmp    1010e8 <console_putc+0xdc>
        *cp->cursor++ = c | color;
  1010c4:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
  1010c8:	8b 55 e0             	mov    -0x20(%rbp),%edx
  1010cb:	09 d0                	or     %edx,%eax
  1010cd:	89 c6                	mov    %eax,%esi
  1010cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1010d3:	48 8b 40 08          	mov    0x8(%rax),%rax
  1010d7:	48 8d 48 02          	lea    0x2(%rax),%rcx
  1010db:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  1010df:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1010e3:	89 f2                	mov    %esi,%edx
  1010e5:	66 89 10             	mov    %dx,(%rax)
}
  1010e8:	90                   	nop
  1010e9:	c9                   	leave
  1010ea:	c3                   	ret

00000000001010eb <console_vprintf>:

int console_vprintf(int cpos, int color, const char* format, va_list val) {
  1010eb:	55                   	push   %rbp
  1010ec:	48 89 e5             	mov    %rsp,%rbp
  1010ef:	48 83 ec 30          	sub    $0x30,%rsp
  1010f3:	89 7d ec             	mov    %edi,-0x14(%rbp)
  1010f6:	89 75 e8             	mov    %esi,-0x18(%rbp)
  1010f9:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  1010fd:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
    struct console_printer cp;
    cp.p.putc = console_putc;
  101101:	48 c7 45 f0 0c 10 10 	movq   $0x10100c,-0x10(%rbp)
  101108:	00 
    if (cpos < 0 || cpos >= CONSOLE_ROWS * CONSOLE_COLUMNS) {
  101109:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  10110d:	78 09                	js     101118 <console_vprintf+0x2d>
  10110f:	81 7d ec cf 07 00 00 	cmpl   $0x7cf,-0x14(%rbp)
  101116:	7e 07                	jle    10111f <console_vprintf+0x34>
        cpos = 0;
  101118:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
    cp.cursor = console + cpos;
  10111f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  101122:	48 98                	cltq
  101124:	48 01 c0             	add    %rax,%rax
  101127:	48 05 00 80 0b 00    	add    $0xb8000,%rax
  10112d:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  101131:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  101135:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  101139:	8b 75 e8             	mov    -0x18(%rbp),%esi
  10113c:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  101140:	48 89 c7             	mov    %rax,%rdi
  101143:	e8 f4 f4 ff ff       	call   10063c <printer_vprintf>
    return cp.cursor - console;
  101148:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10114c:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  101152:	48 d1 f8             	sar    %rax
}
  101155:	c9                   	leave
  101156:	c3                   	ret

0000000000101157 <console_printf>:

int console_printf(int cpos, int color, const char* format, ...) {
  101157:	55                   	push   %rbp
  101158:	48 89 e5             	mov    %rsp,%rbp
  10115b:	48 83 ec 60          	sub    $0x60,%rsp
  10115f:	89 7d ac             	mov    %edi,-0x54(%rbp)
  101162:	89 75 a8             	mov    %esi,-0x58(%rbp)
  101165:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  101169:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  10116d:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  101171:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  101175:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  10117c:	48 8d 45 10          	lea    0x10(%rbp),%rax
  101180:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  101184:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  101188:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  10118c:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  101190:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  101194:	8b 75 a8             	mov    -0x58(%rbp),%esi
  101197:	8b 45 ac             	mov    -0x54(%rbp),%eax
  10119a:	89 c7                	mov    %eax,%edi
  10119c:	e8 4a ff ff ff       	call   1010eb <console_vprintf>
  1011a1:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
  1011a4:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
  1011a7:	c9                   	leave
  1011a8:	c3                   	ret

00000000001011a9 <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  1011a9:	55                   	push   %rbp
  1011aa:	48 89 e5             	mov    %rsp,%rbp
  1011ad:	48 83 ec 20          	sub    $0x20,%rsp
  1011b1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1011b5:	89 f0                	mov    %esi,%eax
  1011b7:	89 55 e0             	mov    %edx,-0x20(%rbp)
  1011ba:	88 45 e4             	mov    %al,-0x1c(%rbp)
    string_printer* sp = (string_printer*) p;
  1011bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1011c1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (sp->s < sp->end) {
  1011c5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1011c9:	48 8b 50 08          	mov    0x8(%rax),%rdx
  1011cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1011d1:	48 8b 40 10          	mov    0x10(%rax),%rax
  1011d5:	48 39 c2             	cmp    %rax,%rdx
  1011d8:	73 1a                	jae    1011f4 <string_putc+0x4b>
        *sp->s++ = c;
  1011da:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1011de:	48 8b 40 08          	mov    0x8(%rax),%rax
  1011e2:	48 8d 48 01          	lea    0x1(%rax),%rcx
  1011e6:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  1011ea:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1011ee:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
  1011f2:	88 10                	mov    %dl,(%rax)
    }
    (void) color;
}
  1011f4:	90                   	nop
  1011f5:	c9                   	leave
  1011f6:	c3                   	ret

00000000001011f7 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  1011f7:	55                   	push   %rbp
  1011f8:	48 89 e5             	mov    %rsp,%rbp
  1011fb:	48 83 ec 40          	sub    $0x40,%rsp
  1011ff:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  101203:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  101207:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  10120b:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    string_printer sp;
    sp.p.putc = string_putc;
  10120f:	48 c7 45 e8 a9 11 10 	movq   $0x1011a9,-0x18(%rbp)
  101216:	00 
    sp.s = s;
  101217:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  10121b:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (size) {
  10121f:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  101224:	74 33                	je     101259 <vsnprintf+0x62>
        sp.end = s + size - 1;
  101226:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  10122a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  10122e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  101232:	48 01 d0             	add    %rdx,%rax
  101235:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  101239:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  10123d:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  101241:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  101245:	be 00 00 00 00       	mov    $0x0,%esi
  10124a:	48 89 c7             	mov    %rax,%rdi
  10124d:	e8 ea f3 ff ff       	call   10063c <printer_vprintf>
        *sp.s = 0;
  101252:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  101256:	c6 00 00             	movb   $0x0,(%rax)
    }
    return sp.s - s;
  101259:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10125d:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
}
  101261:	c9                   	leave
  101262:	c3                   	ret

0000000000101263 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  101263:	55                   	push   %rbp
  101264:	48 89 e5             	mov    %rsp,%rbp
  101267:	48 83 ec 70          	sub    $0x70,%rsp
  10126b:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  10126f:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  101273:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  101277:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  10127b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  10127f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  101283:	c7 45 b0 18 00 00 00 	movl   $0x18,-0x50(%rbp)
  10128a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  10128e:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  101292:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  101296:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    int n = vsnprintf(s, size, format, val);
  10129a:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  10129e:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  1012a2:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  1012a6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1012aa:	48 89 c7             	mov    %rax,%rdi
  1012ad:	e8 45 ff ff ff       	call   1011f7 <vsnprintf>
  1012b2:	89 45 cc             	mov    %eax,-0x34(%rbp)
    va_end(val);
    return n;
  1012b5:	8b 45 cc             	mov    -0x34(%rbp),%eax
}
  1012b8:	c9                   	leave
  1012b9:	c3                   	ret

00000000001012ba <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  1012ba:	55                   	push   %rbp
  1012bb:	48 89 e5             	mov    %rsp,%rbp
  1012be:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1012c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  1012c9:	eb 13                	jmp    1012de <console_clear+0x24>
        console[i] = ' ' | 0x0700;
  1012cb:	8b 45 fc             	mov    -0x4(%rbp),%eax
  1012ce:	48 98                	cltq
  1012d0:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%rax,%rax,1)
  1012d7:	00 20 07 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1012da:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  1012de:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
  1012e5:	7e e4                	jle    1012cb <console_clear+0x11>
    }
    cursorpos = 0;
  1012e7:	c7 05 0b 7d fb ff 00 	movl   $0x0,-0x482f5(%rip)        # b8ffc <cursorpos>
  1012ee:	00 00 00 
}
  1012f1:	90                   	nop
  1012f2:	c9                   	leave
  1012f3:	c3                   	ret
