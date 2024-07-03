
obj/p-test.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:
uint8_t* stack_bottom;

// Parent: continuously forks/yields without exiting
// Child: continuously allocates in a row, then exits

void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	41 54                	push   %r12
  100006:	53                   	push   %rbx

// sys_getpid
//    Return current process ID.
static inline pid_t sys_getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  100007:	cd 31                	int    $0x31
  100009:	41 89 c4             	mov    %eax,%r12d

    pid_t parent = sys_getpid();
    app_printf(parent, "Parent pid is %d\n", parent);
  10000c:	89 c2                	mov    %eax,%edx
  10000e:	be 40 13 10 00       	mov    $0x101340,%esi
  100013:	89 c7                	mov    %eax,%edi
  100015:	b8 00 00 00 00       	mov    $0x0,%eax
  10001a:	e8 34 01 00 00       	call   100153 <app_printf>
// sys_fork()
//    Fork the current process. On success, return the child's process ID to
//    the parent, and return 0 to the child. On failure, return -1.
static inline pid_t sys_fork(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  10001f:	cd 34                	int    $0x34
    pid_t fork = sys_fork();
    assert(fork >= 0);
  100021:	85 c0                	test   %eax,%eax
  100023:	78 44                	js     100069 <process_main+0x69>
  100025:	89 c3                	mov    %eax,%ebx

    srand(parent);
  100027:	44 89 e7             	mov    %r12d,%edi
  10002a:	e8 a7 05 00 00       	call   1005d6 <srand>
    if(fork != 0){
  10002f:	85 db                	test   %ebx,%ebx
  100031:	75 4a                	jne    10007d <process_main+0x7d>
    asm volatile ("int %1" : "=a" (result)
  100033:	cd 31                	int    $0x31
  100035:	89 c3                	mov    %eax,%ebx
    }
    else
    {
child:;
        pid_t p = sys_getpid();
        srand(p);
  100037:	89 c7                	mov    %eax,%edi
  100039:	e8 98 05 00 00       	call   1005d6 <srand>

        // The heap starts on the page right after the 'end' symbol,
        // whose address is the first address not allocated to process code
        // or data.
        heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  10003e:	b8 17 30 10 00       	mov    $0x103017,%eax
  100043:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100049:	48 89 05 b8 1f 00 00 	mov    %rax,0x1fb8(%rip)        # 102008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  100050:	48 89 e0             	mov    %rsp,%rax

        // The bottom of the stack is the first address on the current
        // stack page (this process never needs more than one stack page).
        stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  100053:	48 83 e8 01          	sub    $0x1,%rax
  100057:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10005d:	48 89 05 9c 1f 00 00 	mov    %rax,0x1f9c(%rip)        # 102000 <stack_bottom>
  100064:	e9 94 00 00 00       	jmp    1000fd <process_main+0xfd>
    assert(fork >= 0);
  100069:	ba 52 13 10 00       	mov    $0x101352,%edx
  10006e:	be 13 00 00 00       	mov    $0x13,%esi
  100073:	bf 5c 13 10 00       	mov    $0x10135c,%edi
  100078:	e8 33 02 00 00       	call   1002b0 <assert_fail>
        app_printf(parent, "%dp\n", parent);
  10007d:	44 89 e2             	mov    %r12d,%edx
  100080:	be 6c 13 10 00       	mov    $0x10136c,%esi
  100085:	44 89 e7             	mov    %r12d,%edi
  100088:	b8 00 00 00 00       	mov    $0x0,%eax
  10008d:	e8 c1 00 00 00       	call   100153 <app_printf>
  100092:	eb 08                	jmp    10009c <process_main+0x9c>
    asm volatile ("int %1" : "=a" (result)
  100094:	cd 34                	int    $0x34
                if(fork_new == 0){
  100096:	85 c0                	test   %eax,%eax
  100098:	74 99                	je     100033 <process_main+0x33>
    asm volatile ("int %0" : /* no result */
  10009a:	cd 32                	int    $0x32
            if(rand() % ALLOC_SLOWDOWN == parent){
  10009c:	e8 f9 04 00 00       	call   10059a <rand>
  1000a1:	48 63 d0             	movslq %eax,%rdx
  1000a4:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  1000ab:	48 c1 fa 25          	sar    $0x25,%rdx
  1000af:	89 c1                	mov    %eax,%ecx
  1000b1:	c1 f9 1f             	sar    $0x1f,%ecx
  1000b4:	29 ca                	sub    %ecx,%edx
  1000b6:	6b d2 64             	imul   $0x64,%edx,%edx
  1000b9:	29 d0                	sub    %edx,%eax
  1000bb:	44 39 e0             	cmp    %r12d,%eax
  1000be:	74 d4                	je     100094 <process_main+0x94>
  1000c0:	cd 32                	int    $0x32
}
  1000c2:	eb d8                	jmp    10009c <process_main+0x9c>

        // Allocate heap pages until (1) hit the stack (out of address space)
        // or (2) allocation fails (out of physical memory).
        while (1) {
            if ((rand() % ALLOC_SLOWDOWN) < p) {
                assert(sys_getpid() != parent);
  1000c4:	ba 71 13 10 00       	mov    $0x101371,%edx
  1000c9:	be 39 00 00 00       	mov    $0x39,%esi
  1000ce:	bf 5c 13 10 00       	mov    $0x10135c,%edi
  1000d3:	e8 d8 01 00 00       	call   1002b0 <assert_fail>
void process_main(void) {
  1000d8:	b8 0a 00 00 00       	mov    $0xa,%eax
    asm volatile ("int %0" : /* no result */
  1000dd:	cd 32                	int    $0x32
            sys_yield();
        }

        // After running out of memory, make an exit after 10 yields
        int i = 10;
        while(i--){
  1000df:	83 e8 01             	sub    $0x1,%eax
  1000e2:	75 f9                	jne    1000dd <process_main+0xdd>
            sys_yield();
        }
        app_printf(p, "%d\n", p);
  1000e4:	89 da                	mov    %ebx,%edx
  1000e6:	be 4e 13 10 00       	mov    $0x10134e,%esi
  1000eb:	89 df                	mov    %ebx,%edi
  1000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  1000f2:	e8 5c 00 00 00       	call   100153 <app_printf>

// sys_exit()
//    Exit this process. Does not return.
static inline void sys_exit(void) __attribute__((noreturn));
static inline void sys_exit(void) {
    asm volatile ("int %0" : /* no result */
  1000f7:	cd 35                	int    $0x35
                  : "i" (INT_SYS_EXIT)
                  : "cc", "memory");
 spinloop: goto spinloop;       // should never get here
  1000f9:	eb fe                	jmp    1000f9 <process_main+0xf9>
    asm volatile ("int %0" : /* no result */
  1000fb:	cd 32                	int    $0x32
            if ((rand() % ALLOC_SLOWDOWN) < p) {
  1000fd:	e8 98 04 00 00       	call   10059a <rand>
  100102:	48 63 d0             	movslq %eax,%rdx
  100105:	48 69 d2 1f 85 eb 51 	imul   $0x51eb851f,%rdx,%rdx
  10010c:	48 c1 fa 25          	sar    $0x25,%rdx
  100110:	89 c1                	mov    %eax,%ecx
  100112:	c1 f9 1f             	sar    $0x1f,%ecx
  100115:	29 ca                	sub    %ecx,%edx
  100117:	6b d2 64             	imul   $0x64,%edx,%edx
  10011a:	29 d0                	sub    %edx,%eax
  10011c:	39 d8                	cmp    %ebx,%eax
  10011e:	7d db                	jge    1000fb <process_main+0xfb>
    asm volatile ("int %1" : "=a" (result)
  100120:	cd 31                	int    $0x31
                assert(sys_getpid() != parent);
  100122:	41 39 c4             	cmp    %eax,%r12d
  100125:	74 9d                	je     1000c4 <process_main+0xc4>
                if (heap_top == stack_bottom || sys_page_alloc(heap_top) < 0) {
  100127:	48 8b 3d da 1e 00 00 	mov    0x1eda(%rip),%rdi        # 102008 <heap_top>
  10012e:	48 3b 3d cb 1e 00 00 	cmp    0x1ecb(%rip),%rdi        # 102000 <stack_bottom>
  100135:	74 a1                	je     1000d8 <process_main+0xd8>
    asm volatile ("int %1" : "=a" (result)
  100137:	cd 33                	int    $0x33
  100139:	85 c0                	test   %eax,%eax
  10013b:	78 9b                	js     1000d8 <process_main+0xd8>
                *heap_top = p;      /* check we have write access to new page */
  10013d:	48 8b 05 c4 1e 00 00 	mov    0x1ec4(%rip),%rax        # 102008 <heap_top>
  100144:	88 18                	mov    %bl,(%rax)
                heap_top += PAGESIZE;
  100146:	48 81 05 b7 1e 00 00 	addq   $0x1000,0x1eb7(%rip)        # 102008 <heap_top>
  10014d:	00 10 00 00 
  100151:	eb a8                	jmp    1000fb <process_main+0xfb>

0000000000100153 <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  100153:	55                   	push   %rbp
  100154:	48 89 e5             	mov    %rsp,%rbp
  100157:	48 83 ec 50          	sub    $0x50,%rsp
  10015b:	49 89 f2             	mov    %rsi,%r10
  10015e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  100162:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100166:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  10016a:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  10016e:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  100173:	85 ff                	test   %edi,%edi
  100175:	78 2e                	js     1001a5 <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  100177:	48 63 ff             	movslq %edi,%rdi
  10017a:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  100181:	cc cc cc 
  100184:	48 89 f8             	mov    %rdi,%rax
  100187:	48 f7 e2             	mul    %rdx
  10018a:	48 89 d0             	mov    %rdx,%rax
  10018d:	48 c1 e8 02          	shr    $0x2,%rax
  100191:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  100195:	48 01 c2             	add    %rax,%rdx
  100198:	48 29 d7             	sub    %rdx,%rdi
  10019b:	0f b6 b7 bd 13 10 00 	movzbl 0x1013bd(%rdi),%esi
  1001a2:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  1001a5:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  1001ac:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1001b0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1001b4:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1001b8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  1001bc:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1001c0:	4c 89 d2             	mov    %r10,%rdx
  1001c3:	8b 3d 33 8e fb ff    	mov    -0x471cd(%rip),%edi        # b8ffc <cursorpos>
  1001c9:	e8 5a 0f 00 00       	call   101128 <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  1001ce:	3d 30 07 00 00       	cmp    $0x730,%eax
  1001d3:	ba 00 00 00 00       	mov    $0x0,%edx
  1001d8:	0f 4d c2             	cmovge %edx,%eax
  1001db:	89 05 1b 8e fb ff    	mov    %eax,-0x471e5(%rip)        # b8ffc <cursorpos>
    }
}
  1001e1:	c9                   	leave
  1001e2:	c3                   	ret

00000000001001e3 <panic>:


// panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void panic(const char* format, ...) {
  1001e3:	55                   	push   %rbp
  1001e4:	48 89 e5             	mov    %rsp,%rbp
  1001e7:	53                   	push   %rbx
  1001e8:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  1001ef:	48 89 fb             	mov    %rdi,%rbx
  1001f2:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  1001f6:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  1001fa:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  1001fe:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  100202:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  100206:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  10020d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100211:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  100215:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  100219:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  10021d:	ba 07 00 00 00       	mov    $0x7,%edx
  100222:	be 88 13 10 00       	mov    $0x101388,%esi
  100227:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  10022e:	e8 ac 00 00 00       	call   1002df <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  100233:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  100237:	48 89 da             	mov    %rbx,%rdx
  10023a:	be 99 00 00 00       	mov    $0x99,%esi
  10023f:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  100246:	e8 e9 0f 00 00       	call   101234 <vsnprintf>
  10024b:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  10024e:	85 d2                	test   %edx,%edx
  100250:	7e 0f                	jle    100261 <panic+0x7e>
  100252:	83 c0 06             	add    $0x6,%eax
  100255:	48 98                	cltq
  100257:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  10025e:	0a 
  10025f:	75 29                	jne    10028a <panic+0xa7>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  100261:	48 8d 8d 08 ff ff ff 	lea    -0xf8(%rbp),%rcx
  100268:	ba 90 13 10 00       	mov    $0x101390,%edx
  10026d:	be 00 c0 00 00       	mov    $0xc000,%esi
  100272:	bf 30 07 00 00       	mov    $0x730,%edi
  100277:	b8 00 00 00 00       	mov    $0x0,%eax
  10027c:	e8 13 0f 00 00       	call   101194 <console_printf>
}

// sys_panic(msg)
//    Panic.
static inline pid_t __attribute__((noreturn)) sys_panic(const char* msg) {
    asm volatile ("int %0" : /* no result */
  100281:	bf 00 00 00 00       	mov    $0x0,%edi
  100286:	cd 30                	int    $0x30
                  : "i" (INT_SYS_PANIC), "D" (msg)
                  : "cc", "memory");
 loop: goto loop;
  100288:	eb fe                	jmp    100288 <panic+0xa5>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  10028a:	48 63 c2             	movslq %edx,%rax
  10028d:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  100293:	0f 94 c2             	sete   %dl
  100296:	0f b6 d2             	movzbl %dl,%edx
  100299:	48 29 d0             	sub    %rdx,%rax
  10029c:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  1002a3:	ff 
  1002a4:	be 50 13 10 00       	mov    $0x101350,%esi
  1002a9:	e8 de 01 00 00       	call   10048c <strcpy>
  1002ae:	eb b1                	jmp    100261 <panic+0x7e>

00000000001002b0 <assert_fail>:
    sys_panic(NULL);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  1002b0:	55                   	push   %rbp
  1002b1:	48 89 e5             	mov    %rsp,%rbp
  1002b4:	48 89 f9             	mov    %rdi,%rcx
  1002b7:	41 89 f0             	mov    %esi,%r8d
  1002ba:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  1002bd:	ba 98 13 10 00       	mov    $0x101398,%edx
  1002c2:	be 00 c0 00 00       	mov    $0xc000,%esi
  1002c7:	bf 30 07 00 00       	mov    $0x730,%edi
  1002cc:	b8 00 00 00 00       	mov    $0x0,%eax
  1002d1:	e8 be 0e 00 00       	call   101194 <console_printf>
    asm volatile ("int %0" : /* no result */
  1002d6:	bf 00 00 00 00       	mov    $0x0,%edi
  1002db:	cd 30                	int    $0x30
 loop: goto loop;
  1002dd:	eb fe                	jmp    1002dd <assert_fail+0x2d>

00000000001002df <memcpy>:


// memcpy, memmove, memset, strcmp, strlen, strnlen
//    We must provide our own implementations.

void* memcpy(void* dst, const void* src, size_t n) {
  1002df:	55                   	push   %rbp
  1002e0:	48 89 e5             	mov    %rsp,%rbp
  1002e3:	48 83 ec 28          	sub    $0x28,%rsp
  1002e7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1002eb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1002ef:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1002f3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1002f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1002fb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1002ff:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  100303:	eb 1c                	jmp    100321 <memcpy+0x42>
        *d = *s;
  100305:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100309:	0f b6 10             	movzbl (%rax),%edx
  10030c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100310:	88 10                	mov    %dl,(%rax)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  100312:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  100317:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  10031c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  100321:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  100326:	75 dd                	jne    100305 <memcpy+0x26>
    }
    return dst;
  100328:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  10032c:	c9                   	leave
  10032d:	c3                   	ret

000000000010032e <memmove>:

void* memmove(void* dst, const void* src, size_t n) {
  10032e:	55                   	push   %rbp
  10032f:	48 89 e5             	mov    %rsp,%rbp
  100332:	48 83 ec 28          	sub    $0x28,%rsp
  100336:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  10033a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  10033e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  100342:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100346:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    char* d = (char*) dst;
  10034a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  10034e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (s < d && s + n > d) {
  100352:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100356:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  10035a:	73 6a                	jae    1003c6 <memmove+0x98>
  10035c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  100360:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  100364:	48 01 d0             	add    %rdx,%rax
  100367:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
  10036b:	73 59                	jae    1003c6 <memmove+0x98>
        s += n, d += n;
  10036d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  100371:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  100375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  100379:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        while (n-- > 0) {
  10037d:	eb 17                	jmp    100396 <memmove+0x68>
            *--d = *--s;
  10037f:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  100384:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
  100389:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10038d:	0f b6 10             	movzbl (%rax),%edx
  100390:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100394:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  100396:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  10039a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  10039e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  1003a2:	48 85 c0             	test   %rax,%rax
  1003a5:	75 d8                	jne    10037f <memmove+0x51>
    if (s < d && s + n > d) {
  1003a7:	eb 2e                	jmp    1003d7 <memmove+0xa9>
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
  1003a9:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  1003ad:	48 8d 42 01          	lea    0x1(%rdx),%rax
  1003b1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  1003b5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1003b9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  1003bd:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  1003c1:	0f b6 12             	movzbl (%rdx),%edx
  1003c4:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  1003c6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1003ca:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  1003ce:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  1003d2:	48 85 c0             	test   %rax,%rax
  1003d5:	75 d2                	jne    1003a9 <memmove+0x7b>
        }
    }
    return dst;
  1003d7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1003db:	c9                   	leave
  1003dc:	c3                   	ret

00000000001003dd <memset>:

void* memset(void* v, int c, size_t n) {
  1003dd:	55                   	push   %rbp
  1003de:	48 89 e5             	mov    %rsp,%rbp
  1003e1:	48 83 ec 28          	sub    $0x28,%rsp
  1003e5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1003e9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  1003ec:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1003f0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1003f4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  1003f8:	eb 15                	jmp    10040f <memset+0x32>
        *p = c;
  1003fa:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1003fd:	89 c2                	mov    %eax,%edx
  1003ff:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100403:	88 10                	mov    %dl,(%rax)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100405:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  10040a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  10040f:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  100414:	75 e4                	jne    1003fa <memset+0x1d>
    }
    return v;
  100416:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  10041a:	c9                   	leave
  10041b:	c3                   	ret

000000000010041c <strlen>:

size_t strlen(const char* s) {
  10041c:	55                   	push   %rbp
  10041d:	48 89 e5             	mov    %rsp,%rbp
  100420:	48 83 ec 18          	sub    $0x18,%rsp
  100424:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
  100428:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  10042f:	00 
  100430:	eb 0a                	jmp    10043c <strlen+0x20>
        ++n;
  100432:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; *s != '\0'; ++s) {
  100437:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  10043c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100440:	0f b6 00             	movzbl (%rax),%eax
  100443:	84 c0                	test   %al,%al
  100445:	75 eb                	jne    100432 <strlen+0x16>
    }
    return n;
  100447:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  10044b:	c9                   	leave
  10044c:	c3                   	ret

000000000010044d <strnlen>:

size_t strnlen(const char* s, size_t maxlen) {
  10044d:	55                   	push   %rbp
  10044e:	48 89 e5             	mov    %rsp,%rbp
  100451:	48 83 ec 20          	sub    $0x20,%rsp
  100455:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  100459:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    size_t n;
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  10045d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  100464:	00 
  100465:	eb 0a                	jmp    100471 <strnlen+0x24>
        ++n;
  100467:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  10046c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  100471:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100475:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  100479:	74 0b                	je     100486 <strnlen+0x39>
  10047b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  10047f:	0f b6 00             	movzbl (%rax),%eax
  100482:	84 c0                	test   %al,%al
  100484:	75 e1                	jne    100467 <strnlen+0x1a>
    }
    return n;
  100486:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  10048a:	c9                   	leave
  10048b:	c3                   	ret

000000000010048c <strcpy>:

char* strcpy(char* dst, const char* src) {
  10048c:	55                   	push   %rbp
  10048d:	48 89 e5             	mov    %rsp,%rbp
  100490:	48 83 ec 20          	sub    $0x20,%rsp
  100494:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  100498:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    char* d = dst;
  10049c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1004a0:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    do {
        *d++ = *src++;
  1004a4:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  1004a8:	48 8d 42 01          	lea    0x1(%rdx),%rax
  1004ac:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  1004b0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1004b4:	48 8d 48 01          	lea    0x1(%rax),%rcx
  1004b8:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
  1004bc:	0f b6 12             	movzbl (%rdx),%edx
  1004bf:	88 10                	mov    %dl,(%rax)
    } while (d[-1]);
  1004c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1004c5:	48 83 e8 01          	sub    $0x1,%rax
  1004c9:	0f b6 00             	movzbl (%rax),%eax
  1004cc:	84 c0                	test   %al,%al
  1004ce:	75 d4                	jne    1004a4 <strcpy+0x18>
    return dst;
  1004d0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1004d4:	c9                   	leave
  1004d5:	c3                   	ret

00000000001004d6 <strcmp>:

int strcmp(const char* a, const char* b) {
  1004d6:	55                   	push   %rbp
  1004d7:	48 89 e5             	mov    %rsp,%rbp
  1004da:	48 83 ec 10          	sub    $0x10,%rsp
  1004de:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  1004e2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  1004e6:	eb 0a                	jmp    1004f2 <strcmp+0x1c>
        ++a, ++b;
  1004e8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1004ed:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  1004f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1004f6:	0f b6 00             	movzbl (%rax),%eax
  1004f9:	84 c0                	test   %al,%al
  1004fb:	74 1d                	je     10051a <strcmp+0x44>
  1004fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100501:	0f b6 00             	movzbl (%rax),%eax
  100504:	84 c0                	test   %al,%al
  100506:	74 12                	je     10051a <strcmp+0x44>
  100508:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10050c:	0f b6 10             	movzbl (%rax),%edx
  10050f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100513:	0f b6 00             	movzbl (%rax),%eax
  100516:	38 c2                	cmp    %al,%dl
  100518:	74 ce                	je     1004e8 <strcmp+0x12>
    }
    return ((unsigned char) *a > (unsigned char) *b)
  10051a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10051e:	0f b6 00             	movzbl (%rax),%eax
  100521:	89 c2                	mov    %eax,%edx
  100523:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100527:	0f b6 00             	movzbl (%rax),%eax
  10052a:	38 d0                	cmp    %dl,%al
  10052c:	0f 92 c0             	setb   %al
  10052f:	0f b6 d0             	movzbl %al,%edx
        - ((unsigned char) *a < (unsigned char) *b);
  100532:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100536:	0f b6 00             	movzbl (%rax),%eax
  100539:	89 c1                	mov    %eax,%ecx
  10053b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10053f:	0f b6 00             	movzbl (%rax),%eax
  100542:	38 c1                	cmp    %al,%cl
  100544:	0f 92 c0             	setb   %al
  100547:	0f b6 c0             	movzbl %al,%eax
  10054a:	29 c2                	sub    %eax,%edx
  10054c:	89 d0                	mov    %edx,%eax
}
  10054e:	c9                   	leave
  10054f:	c3                   	ret

0000000000100550 <strchr>:

char* strchr(const char* s, int c) {
  100550:	55                   	push   %rbp
  100551:	48 89 e5             	mov    %rsp,%rbp
  100554:	48 83 ec 10          	sub    $0x10,%rsp
  100558:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  10055c:	89 75 f4             	mov    %esi,-0xc(%rbp)
    while (*s && *s != (char) c) {
  10055f:	eb 05                	jmp    100566 <strchr+0x16>
        ++s;
  100561:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while (*s && *s != (char) c) {
  100566:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10056a:	0f b6 00             	movzbl (%rax),%eax
  10056d:	84 c0                	test   %al,%al
  10056f:	74 0e                	je     10057f <strchr+0x2f>
  100571:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100575:	0f b6 00             	movzbl (%rax),%eax
  100578:	8b 55 f4             	mov    -0xc(%rbp),%edx
  10057b:	38 d0                	cmp    %dl,%al
  10057d:	75 e2                	jne    100561 <strchr+0x11>
    }
    if (*s == (char) c) {
  10057f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100583:	0f b6 00             	movzbl (%rax),%eax
  100586:	8b 55 f4             	mov    -0xc(%rbp),%edx
  100589:	38 d0                	cmp    %dl,%al
  10058b:	75 06                	jne    100593 <strchr+0x43>
        return (char*) s;
  10058d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100591:	eb 05                	jmp    100598 <strchr+0x48>
    } else {
        return NULL;
  100593:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
  100598:	c9                   	leave
  100599:	c3                   	ret

000000000010059a <rand>:
// rand, srand

static int rand_seed_set;
static unsigned rand_seed;

int rand(void) {
  10059a:	55                   	push   %rbp
  10059b:	48 89 e5             	mov    %rsp,%rbp
    if (!rand_seed_set) {
  10059e:	8b 05 6c 1a 00 00    	mov    0x1a6c(%rip),%eax        # 102010 <rand_seed_set>
  1005a4:	85 c0                	test   %eax,%eax
  1005a6:	75 0a                	jne    1005b2 <rand+0x18>
        srand(819234718U);
  1005a8:	bf 9e 87 d4 30       	mov    $0x30d4879e,%edi
  1005ad:	e8 24 00 00 00       	call   1005d6 <srand>
    }
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1005b2:	8b 05 5c 1a 00 00    	mov    0x1a5c(%rip),%eax        # 102014 <rand_seed>
  1005b8:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
  1005be:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  1005c3:	89 05 4b 1a 00 00    	mov    %eax,0x1a4b(%rip)        # 102014 <rand_seed>
    return rand_seed & RAND_MAX;
  1005c9:	8b 05 45 1a 00 00    	mov    0x1a45(%rip),%eax        # 102014 <rand_seed>
  1005cf:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  1005d4:	5d                   	pop    %rbp
  1005d5:	c3                   	ret

00000000001005d6 <srand>:

void srand(unsigned seed) {
  1005d6:	55                   	push   %rbp
  1005d7:	48 89 e5             	mov    %rsp,%rbp
  1005da:	48 83 ec 08          	sub    $0x8,%rsp
  1005de:	89 7d fc             	mov    %edi,-0x4(%rbp)
    rand_seed = seed;
  1005e1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  1005e4:	89 05 2a 1a 00 00    	mov    %eax,0x1a2a(%rip)        # 102014 <rand_seed>
    rand_seed_set = 1;
  1005ea:	c7 05 1c 1a 00 00 01 	movl   $0x1,0x1a1c(%rip)        # 102010 <rand_seed_set>
  1005f1:	00 00 00 
}
  1005f4:	90                   	nop
  1005f5:	c9                   	leave
  1005f6:	c3                   	ret

00000000001005f7 <fill_numbuf>:
//    Print a message onto the console, starting at the given cursor position.

// snprintf, vsnprintf
//    Format a string into a buffer.

static char* fill_numbuf(char* numbuf_end, unsigned long val, int base) {
  1005f7:	55                   	push   %rbp
  1005f8:	48 89 e5             	mov    %rsp,%rbp
  1005fb:	48 83 ec 28          	sub    $0x28,%rsp
  1005ff:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  100603:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  100607:	89 55 dc             	mov    %edx,-0x24(%rbp)
    static const char upper_digits[] = "0123456789ABCDEF";
    static const char lower_digits[] = "0123456789abcdef";

    const char* digits = upper_digits;
  10060a:	48 c7 45 f8 b0 15 10 	movq   $0x1015b0,-0x8(%rbp)
  100611:	00 
    if (base < 0) {
  100612:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  100616:	79 0b                	jns    100623 <fill_numbuf+0x2c>
        digits = lower_digits;
  100618:	48 c7 45 f8 d0 15 10 	movq   $0x1015d0,-0x8(%rbp)
  10061f:	00 
        base = -base;
  100620:	f7 5d dc             	negl   -0x24(%rbp)
    }

    *--numbuf_end = '\0';
  100623:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  100628:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  10062c:	c6 00 00             	movb   $0x0,(%rax)
    do {
        *--numbuf_end = digits[val % base];
  10062f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  100632:	48 63 c8             	movslq %eax,%rcx
  100635:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100639:	ba 00 00 00 00       	mov    $0x0,%edx
  10063e:	48 f7 f1             	div    %rcx
  100641:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100645:	48 01 d0             	add    %rdx,%rax
  100648:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  10064d:	0f b6 10             	movzbl (%rax),%edx
  100650:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100654:	88 10                	mov    %dl,(%rax)
        val /= base;
  100656:	8b 45 dc             	mov    -0x24(%rbp),%eax
  100659:	48 63 f0             	movslq %eax,%rsi
  10065c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100660:	ba 00 00 00 00       	mov    $0x0,%edx
  100665:	48 f7 f6             	div    %rsi
  100668:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    } while (val != 0);
  10066c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  100671:	75 bc                	jne    10062f <fill_numbuf+0x38>
    return numbuf_end;
  100673:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  100677:	c9                   	leave
  100678:	c3                   	ret

0000000000100679 <printer_vprintf>:
#define FLAG_NUMERIC            (1<<5)
#define FLAG_SIGNED             (1<<6)
#define FLAG_NEGATIVE           (1<<7)
#define FLAG_ALT2               (1<<8)

void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  100679:	55                   	push   %rbp
  10067a:	48 89 e5             	mov    %rsp,%rbp
  10067d:	53                   	push   %rbx
  10067e:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  100685:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
  10068c:	89 b5 74 ff ff ff    	mov    %esi,-0x8c(%rbp)
  100692:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  100699:	48 89 8d 60 ff ff ff 	mov    %rcx,-0xa0(%rbp)
#define NUMBUFSIZ 24
    char numbuf[NUMBUFSIZ];

    for (; *format; ++format) {
  1006a0:	e9 8a 09 00 00       	jmp    10102f <printer_vprintf+0x9b6>
        if (*format != '%') {
  1006a5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1006ac:	0f b6 00             	movzbl (%rax),%eax
  1006af:	3c 25                	cmp    $0x25,%al
  1006b1:	74 31                	je     1006e4 <printer_vprintf+0x6b>
            p->putc(p, *format, color);
  1006b3:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1006ba:	4c 8b 00             	mov    (%rax),%r8
  1006bd:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1006c4:	0f b6 00             	movzbl (%rax),%eax
  1006c7:	0f b6 c8             	movzbl %al,%ecx
  1006ca:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1006d0:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1006d7:	89 ce                	mov    %ecx,%esi
  1006d9:	48 89 c7             	mov    %rax,%rdi
  1006dc:	41 ff d0             	call   *%r8
            continue;
  1006df:	e9 43 09 00 00       	jmp    101027 <printer_vprintf+0x9ae>
        }

        // process flags
        int flags = 0;
  1006e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        for (++format; *format; ++format) {
  1006eb:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1006f2:	01 
  1006f3:	eb 44                	jmp    100739 <printer_vprintf+0xc0>
            const char* flagc = strchr(flag_chars, *format);
  1006f5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1006fc:	0f b6 00             	movzbl (%rax),%eax
  1006ff:	0f be c0             	movsbl %al,%eax
  100702:	89 c6                	mov    %eax,%esi
  100704:	bf d0 13 10 00       	mov    $0x1013d0,%edi
  100709:	e8 42 fe ff ff       	call   100550 <strchr>
  10070e:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (flagc) {
  100712:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  100717:	74 30                	je     100749 <printer_vprintf+0xd0>
                flags |= 1 << (flagc - flag_chars);
  100719:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  10071d:	48 2d d0 13 10 00    	sub    $0x1013d0,%rax
  100723:	ba 01 00 00 00       	mov    $0x1,%edx
  100728:	89 c1                	mov    %eax,%ecx
  10072a:	d3 e2                	shl    %cl,%edx
  10072c:	89 d0                	mov    %edx,%eax
  10072e:	09 45 ec             	or     %eax,-0x14(%rbp)
        for (++format; *format; ++format) {
  100731:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100738:	01 
  100739:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100740:	0f b6 00             	movzbl (%rax),%eax
  100743:	84 c0                	test   %al,%al
  100745:	75 ae                	jne    1006f5 <printer_vprintf+0x7c>
  100747:	eb 01                	jmp    10074a <printer_vprintf+0xd1>
            } else {
                break;
  100749:	90                   	nop
            }
        }

        // process width
        int width = -1;
  10074a:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
        if (*format >= '1' && *format <= '9') {
  100751:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100758:	0f b6 00             	movzbl (%rax),%eax
  10075b:	3c 30                	cmp    $0x30,%al
  10075d:	7e 67                	jle    1007c6 <printer_vprintf+0x14d>
  10075f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100766:	0f b6 00             	movzbl (%rax),%eax
  100769:	3c 39                	cmp    $0x39,%al
  10076b:	7f 59                	jg     1007c6 <printer_vprintf+0x14d>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  10076d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  100774:	eb 2e                	jmp    1007a4 <printer_vprintf+0x12b>
                width = 10 * width + *format++ - '0';
  100776:	8b 55 e8             	mov    -0x18(%rbp),%edx
  100779:	89 d0                	mov    %edx,%eax
  10077b:	c1 e0 02             	shl    $0x2,%eax
  10077e:	01 d0                	add    %edx,%eax
  100780:	01 c0                	add    %eax,%eax
  100782:	89 c1                	mov    %eax,%ecx
  100784:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10078b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  10078f:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  100796:	0f b6 00             	movzbl (%rax),%eax
  100799:	0f be c0             	movsbl %al,%eax
  10079c:	01 c8                	add    %ecx,%eax
  10079e:	83 e8 30             	sub    $0x30,%eax
  1007a1:	89 45 e8             	mov    %eax,-0x18(%rbp)
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1007a4:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1007ab:	0f b6 00             	movzbl (%rax),%eax
  1007ae:	3c 2f                	cmp    $0x2f,%al
  1007b0:	0f 8e 85 00 00 00    	jle    10083b <printer_vprintf+0x1c2>
  1007b6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1007bd:	0f b6 00             	movzbl (%rax),%eax
  1007c0:	3c 39                	cmp    $0x39,%al
  1007c2:	7e b2                	jle    100776 <printer_vprintf+0xfd>
        if (*format >= '1' && *format <= '9') {
  1007c4:	eb 75                	jmp    10083b <printer_vprintf+0x1c2>
            }
        } else if (*format == '*') {
  1007c6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1007cd:	0f b6 00             	movzbl (%rax),%eax
  1007d0:	3c 2a                	cmp    $0x2a,%al
  1007d2:	75 68                	jne    10083c <printer_vprintf+0x1c3>
            width = va_arg(val, int);
  1007d4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1007db:	8b 00                	mov    (%rax),%eax
  1007dd:	83 f8 2f             	cmp    $0x2f,%eax
  1007e0:	77 30                	ja     100812 <printer_vprintf+0x199>
  1007e2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1007e9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1007ed:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1007f4:	8b 00                	mov    (%rax),%eax
  1007f6:	89 c0                	mov    %eax,%eax
  1007f8:	48 01 d0             	add    %rdx,%rax
  1007fb:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100802:	8b 12                	mov    (%rdx),%edx
  100804:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100807:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10080e:	89 0a                	mov    %ecx,(%rdx)
  100810:	eb 1a                	jmp    10082c <printer_vprintf+0x1b3>
  100812:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100819:	48 8b 40 08          	mov    0x8(%rax),%rax
  10081d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100821:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100828:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  10082c:	8b 00                	mov    (%rax),%eax
  10082e:	89 45 e8             	mov    %eax,-0x18(%rbp)
            ++format;
  100831:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100838:	01 
  100839:	eb 01                	jmp    10083c <printer_vprintf+0x1c3>
        if (*format >= '1' && *format <= '9') {
  10083b:	90                   	nop
        }

        // process precision
        int precision = -1;
  10083c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
        if (*format == '.') {
  100843:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10084a:	0f b6 00             	movzbl (%rax),%eax
  10084d:	3c 2e                	cmp    $0x2e,%al
  10084f:	0f 85 00 01 00 00    	jne    100955 <printer_vprintf+0x2dc>
            ++format;
  100855:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  10085c:	01 
            if (*format >= '0' && *format <= '9') {
  10085d:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100864:	0f b6 00             	movzbl (%rax),%eax
  100867:	3c 2f                	cmp    $0x2f,%al
  100869:	7e 67                	jle    1008d2 <printer_vprintf+0x259>
  10086b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100872:	0f b6 00             	movzbl (%rax),%eax
  100875:	3c 39                	cmp    $0x39,%al
  100877:	7f 59                	jg     1008d2 <printer_vprintf+0x259>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100879:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  100880:	eb 2e                	jmp    1008b0 <printer_vprintf+0x237>
                    precision = 10 * precision + *format++ - '0';
  100882:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  100885:	89 d0                	mov    %edx,%eax
  100887:	c1 e0 02             	shl    $0x2,%eax
  10088a:	01 d0                	add    %edx,%eax
  10088c:	01 c0                	add    %eax,%eax
  10088e:	89 c1                	mov    %eax,%ecx
  100890:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100897:	48 8d 50 01          	lea    0x1(%rax),%rdx
  10089b:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  1008a2:	0f b6 00             	movzbl (%rax),%eax
  1008a5:	0f be c0             	movsbl %al,%eax
  1008a8:	01 c8                	add    %ecx,%eax
  1008aa:	83 e8 30             	sub    $0x30,%eax
  1008ad:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1008b0:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1008b7:	0f b6 00             	movzbl (%rax),%eax
  1008ba:	3c 2f                	cmp    $0x2f,%al
  1008bc:	0f 8e 85 00 00 00    	jle    100947 <printer_vprintf+0x2ce>
  1008c2:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1008c9:	0f b6 00             	movzbl (%rax),%eax
  1008cc:	3c 39                	cmp    $0x39,%al
  1008ce:	7e b2                	jle    100882 <printer_vprintf+0x209>
            if (*format >= '0' && *format <= '9') {
  1008d0:	eb 75                	jmp    100947 <printer_vprintf+0x2ce>
                }
            } else if (*format == '*') {
  1008d2:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1008d9:	0f b6 00             	movzbl (%rax),%eax
  1008dc:	3c 2a                	cmp    $0x2a,%al
  1008de:	75 68                	jne    100948 <printer_vprintf+0x2cf>
                precision = va_arg(val, int);
  1008e0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008e7:	8b 00                	mov    (%rax),%eax
  1008e9:	83 f8 2f             	cmp    $0x2f,%eax
  1008ec:	77 30                	ja     10091e <printer_vprintf+0x2a5>
  1008ee:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008f5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1008f9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100900:	8b 00                	mov    (%rax),%eax
  100902:	89 c0                	mov    %eax,%eax
  100904:	48 01 d0             	add    %rdx,%rax
  100907:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10090e:	8b 12                	mov    (%rdx),%edx
  100910:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100913:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10091a:	89 0a                	mov    %ecx,(%rdx)
  10091c:	eb 1a                	jmp    100938 <printer_vprintf+0x2bf>
  10091e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100925:	48 8b 40 08          	mov    0x8(%rax),%rax
  100929:	48 8d 48 08          	lea    0x8(%rax),%rcx
  10092d:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100934:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100938:	8b 00                	mov    (%rax),%eax
  10093a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                ++format;
  10093d:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100944:	01 
  100945:	eb 01                	jmp    100948 <printer_vprintf+0x2cf>
            if (*format >= '0' && *format <= '9') {
  100947:	90                   	nop
            }
            if (precision < 0) {
  100948:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  10094c:	79 07                	jns    100955 <printer_vprintf+0x2dc>
                precision = 0;
  10094e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
            }
        }

        // process main conversion character
        int base = 10;
  100955:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%rbp)
        unsigned long num = 0;
  10095c:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  100963:	00 
        int length = 0;
  100964:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
        char* data = "";
  10096b:	48 c7 45 c8 d6 13 10 	movq   $0x1013d6,-0x38(%rbp)
  100972:	00 
    again:
        switch (*format) {
  100973:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10097a:	0f b6 00             	movzbl (%rax),%eax
  10097d:	0f be c0             	movsbl %al,%eax
  100980:	83 e8 43             	sub    $0x43,%eax
  100983:	83 f8 37             	cmp    $0x37,%eax
  100986:	0f 87 9f 03 00 00    	ja     100d2b <printer_vprintf+0x6b2>
  10098c:	89 c0                	mov    %eax,%eax
  10098e:	48 8b 04 c5 e8 13 10 	mov    0x1013e8(,%rax,8),%rax
  100995:	00 
  100996:	ff e0                	jmp    *%rax
        case 'l':
        case 'z':
            length = 1;
  100998:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
            ++format;
  10099f:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1009a6:	01 
            goto again;
  1009a7:	eb ca                	jmp    100973 <printer_vprintf+0x2fa>
        case 'd':
        case 'i': {
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1009a9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  1009ad:	74 5d                	je     100a0c <printer_vprintf+0x393>
  1009af:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009b6:	8b 00                	mov    (%rax),%eax
  1009b8:	83 f8 2f             	cmp    $0x2f,%eax
  1009bb:	77 30                	ja     1009ed <printer_vprintf+0x374>
  1009bd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009c4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1009c8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009cf:	8b 00                	mov    (%rax),%eax
  1009d1:	89 c0                	mov    %eax,%eax
  1009d3:	48 01 d0             	add    %rdx,%rax
  1009d6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009dd:	8b 12                	mov    (%rdx),%edx
  1009df:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1009e2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009e9:	89 0a                	mov    %ecx,(%rdx)
  1009eb:	eb 1a                	jmp    100a07 <printer_vprintf+0x38e>
  1009ed:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009f4:	48 8b 40 08          	mov    0x8(%rax),%rax
  1009f8:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1009fc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a03:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100a07:	48 8b 00             	mov    (%rax),%rax
  100a0a:	eb 5c                	jmp    100a68 <printer_vprintf+0x3ef>
  100a0c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a13:	8b 00                	mov    (%rax),%eax
  100a15:	83 f8 2f             	cmp    $0x2f,%eax
  100a18:	77 30                	ja     100a4a <printer_vprintf+0x3d1>
  100a1a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a21:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100a25:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a2c:	8b 00                	mov    (%rax),%eax
  100a2e:	89 c0                	mov    %eax,%eax
  100a30:	48 01 d0             	add    %rdx,%rax
  100a33:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a3a:	8b 12                	mov    (%rdx),%edx
  100a3c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100a3f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a46:	89 0a                	mov    %ecx,(%rdx)
  100a48:	eb 1a                	jmp    100a64 <printer_vprintf+0x3eb>
  100a4a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a51:	48 8b 40 08          	mov    0x8(%rax),%rax
  100a55:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100a59:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a60:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100a64:	8b 00                	mov    (%rax),%eax
  100a66:	48 98                	cltq
  100a68:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  100a6c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100a70:	48 c1 f8 38          	sar    $0x38,%rax
  100a74:	25 80 00 00 00       	and    $0x80,%eax
  100a79:	89 45 a4             	mov    %eax,-0x5c(%rbp)
            num = negative ? -x : x;
  100a7c:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  100a80:	74 09                	je     100a8b <printer_vprintf+0x412>
  100a82:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100a86:	48 f7 d8             	neg    %rax
  100a89:	eb 04                	jmp    100a8f <printer_vprintf+0x416>
  100a8b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100a8f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  100a93:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  100a96:	83 c8 60             	or     $0x60,%eax
  100a99:	09 45 ec             	or     %eax,-0x14(%rbp)
            break;
  100a9c:	e9 cf 02 00 00       	jmp    100d70 <printer_vprintf+0x6f7>
        }
        case 'u':
        format_unsigned:
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100aa1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  100aa5:	74 5d                	je     100b04 <printer_vprintf+0x48b>
  100aa7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100aae:	8b 00                	mov    (%rax),%eax
  100ab0:	83 f8 2f             	cmp    $0x2f,%eax
  100ab3:	77 30                	ja     100ae5 <printer_vprintf+0x46c>
  100ab5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100abc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100ac0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ac7:	8b 00                	mov    (%rax),%eax
  100ac9:	89 c0                	mov    %eax,%eax
  100acb:	48 01 d0             	add    %rdx,%rax
  100ace:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100ad5:	8b 12                	mov    (%rdx),%edx
  100ad7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100ada:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100ae1:	89 0a                	mov    %ecx,(%rdx)
  100ae3:	eb 1a                	jmp    100aff <printer_vprintf+0x486>
  100ae5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100aec:	48 8b 40 08          	mov    0x8(%rax),%rax
  100af0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100af4:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100afb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100aff:	48 8b 00             	mov    (%rax),%rax
  100b02:	eb 5c                	jmp    100b60 <printer_vprintf+0x4e7>
  100b04:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b0b:	8b 00                	mov    (%rax),%eax
  100b0d:	83 f8 2f             	cmp    $0x2f,%eax
  100b10:	77 30                	ja     100b42 <printer_vprintf+0x4c9>
  100b12:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b19:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100b1d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b24:	8b 00                	mov    (%rax),%eax
  100b26:	89 c0                	mov    %eax,%eax
  100b28:	48 01 d0             	add    %rdx,%rax
  100b2b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b32:	8b 12                	mov    (%rdx),%edx
  100b34:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100b37:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b3e:	89 0a                	mov    %ecx,(%rdx)
  100b40:	eb 1a                	jmp    100b5c <printer_vprintf+0x4e3>
  100b42:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b49:	48 8b 40 08          	mov    0x8(%rax),%rax
  100b4d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100b51:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b58:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100b5c:	8b 00                	mov    (%rax),%eax
  100b5e:	89 c0                	mov    %eax,%eax
  100b60:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC;
  100b64:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
            break;
  100b68:	e9 03 02 00 00       	jmp    100d70 <printer_vprintf+0x6f7>
        case 'x':
            base = -16;
  100b6d:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            goto format_unsigned;
  100b74:	e9 28 ff ff ff       	jmp    100aa1 <printer_vprintf+0x428>
        case 'X':
            base = 16;
  100b79:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%rbp)
            goto format_unsigned;
  100b80:	e9 1c ff ff ff       	jmp    100aa1 <printer_vprintf+0x428>
        case 'p':
            num = (uintptr_t) va_arg(val, void*);
  100b85:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b8c:	8b 00                	mov    (%rax),%eax
  100b8e:	83 f8 2f             	cmp    $0x2f,%eax
  100b91:	77 30                	ja     100bc3 <printer_vprintf+0x54a>
  100b93:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b9a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100b9e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ba5:	8b 00                	mov    (%rax),%eax
  100ba7:	89 c0                	mov    %eax,%eax
  100ba9:	48 01 d0             	add    %rdx,%rax
  100bac:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100bb3:	8b 12                	mov    (%rdx),%edx
  100bb5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100bb8:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100bbf:	89 0a                	mov    %ecx,(%rdx)
  100bc1:	eb 1a                	jmp    100bdd <printer_vprintf+0x564>
  100bc3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100bca:	48 8b 40 08          	mov    0x8(%rax),%rax
  100bce:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100bd2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100bd9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100bdd:	48 8b 00             	mov    (%rax),%rax
  100be0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            base = -16;
  100be4:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  100beb:	81 4d ec 21 01 00 00 	orl    $0x121,-0x14(%rbp)
            break;
  100bf2:	e9 79 01 00 00       	jmp    100d70 <printer_vprintf+0x6f7>
        case 's':
            data = va_arg(val, char*);
  100bf7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100bfe:	8b 00                	mov    (%rax),%eax
  100c00:	83 f8 2f             	cmp    $0x2f,%eax
  100c03:	77 30                	ja     100c35 <printer_vprintf+0x5bc>
  100c05:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c0c:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100c10:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c17:	8b 00                	mov    (%rax),%eax
  100c19:	89 c0                	mov    %eax,%eax
  100c1b:	48 01 d0             	add    %rdx,%rax
  100c1e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c25:	8b 12                	mov    (%rdx),%edx
  100c27:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100c2a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c31:	89 0a                	mov    %ecx,(%rdx)
  100c33:	eb 1a                	jmp    100c4f <printer_vprintf+0x5d6>
  100c35:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c3c:	48 8b 40 08          	mov    0x8(%rax),%rax
  100c40:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100c44:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c4b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100c4f:	48 8b 00             	mov    (%rax),%rax
  100c52:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            break;
  100c56:	e9 15 01 00 00       	jmp    100d70 <printer_vprintf+0x6f7>
        case 'C':
            color = va_arg(val, int);
  100c5b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c62:	8b 00                	mov    (%rax),%eax
  100c64:	83 f8 2f             	cmp    $0x2f,%eax
  100c67:	77 30                	ja     100c99 <printer_vprintf+0x620>
  100c69:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c70:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100c74:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c7b:	8b 00                	mov    (%rax),%eax
  100c7d:	89 c0                	mov    %eax,%eax
  100c7f:	48 01 d0             	add    %rdx,%rax
  100c82:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c89:	8b 12                	mov    (%rdx),%edx
  100c8b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100c8e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c95:	89 0a                	mov    %ecx,(%rdx)
  100c97:	eb 1a                	jmp    100cb3 <printer_vprintf+0x63a>
  100c99:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ca0:	48 8b 40 08          	mov    0x8(%rax),%rax
  100ca4:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100ca8:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100caf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100cb3:	8b 00                	mov    (%rax),%eax
  100cb5:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
            goto done;
  100cbb:	e9 67 03 00 00       	jmp    101027 <printer_vprintf+0x9ae>
        case 'c':
            data = numbuf;
  100cc0:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100cc4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = va_arg(val, int);
  100cc8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ccf:	8b 00                	mov    (%rax),%eax
  100cd1:	83 f8 2f             	cmp    $0x2f,%eax
  100cd4:	77 30                	ja     100d06 <printer_vprintf+0x68d>
  100cd6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100cdd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100ce1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ce8:	8b 00                	mov    (%rax),%eax
  100cea:	89 c0                	mov    %eax,%eax
  100cec:	48 01 d0             	add    %rdx,%rax
  100cef:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100cf6:	8b 12                	mov    (%rdx),%edx
  100cf8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100cfb:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100d02:	89 0a                	mov    %ecx,(%rdx)
  100d04:	eb 1a                	jmp    100d20 <printer_vprintf+0x6a7>
  100d06:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100d0d:	48 8b 40 08          	mov    0x8(%rax),%rax
  100d11:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100d15:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100d1c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100d20:	8b 00                	mov    (%rax),%eax
  100d22:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  100d25:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            break;
  100d29:	eb 45                	jmp    100d70 <printer_vprintf+0x6f7>
        default:
            data = numbuf;
  100d2b:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100d2f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = (*format ? *format : '%');
  100d33:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100d3a:	0f b6 00             	movzbl (%rax),%eax
  100d3d:	84 c0                	test   %al,%al
  100d3f:	74 0c                	je     100d4d <printer_vprintf+0x6d4>
  100d41:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100d48:	0f b6 00             	movzbl (%rax),%eax
  100d4b:	eb 05                	jmp    100d52 <printer_vprintf+0x6d9>
  100d4d:	b8 25 00 00 00       	mov    $0x25,%eax
  100d52:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  100d55:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            if (!*format) {
  100d59:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100d60:	0f b6 00             	movzbl (%rax),%eax
  100d63:	84 c0                	test   %al,%al
  100d65:	75 08                	jne    100d6f <printer_vprintf+0x6f6>
                format--;
  100d67:	48 83 ad 68 ff ff ff 	subq   $0x1,-0x98(%rbp)
  100d6e:	01 
            }
            break;
  100d6f:	90                   	nop
        }

        if (flags & FLAG_NUMERIC) {
  100d70:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100d73:	83 e0 20             	and    $0x20,%eax
  100d76:	85 c0                	test   %eax,%eax
  100d78:	74 1e                	je     100d98 <printer_vprintf+0x71f>
            data = fill_numbuf(numbuf + NUMBUFSIZ, num, base);
  100d7a:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100d7e:	48 83 c0 18          	add    $0x18,%rax
  100d82:	8b 55 e0             	mov    -0x20(%rbp),%edx
  100d85:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  100d89:	48 89 ce             	mov    %rcx,%rsi
  100d8c:	48 89 c7             	mov    %rax,%rdi
  100d8f:	e8 63 f8 ff ff       	call   1005f7 <fill_numbuf>
  100d94:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        }

        const char* prefix = "";
  100d98:	48 c7 45 c0 d6 13 10 	movq   $0x1013d6,-0x40(%rbp)
  100d9f:	00 
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  100da0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100da3:	83 e0 20             	and    $0x20,%eax
  100da6:	85 c0                	test   %eax,%eax
  100da8:	74 48                	je     100df2 <printer_vprintf+0x779>
  100daa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100dad:	83 e0 40             	and    $0x40,%eax
  100db0:	85 c0                	test   %eax,%eax
  100db2:	74 3e                	je     100df2 <printer_vprintf+0x779>
            if (flags & FLAG_NEGATIVE) {
  100db4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100db7:	25 80 00 00 00       	and    $0x80,%eax
  100dbc:	85 c0                	test   %eax,%eax
  100dbe:	74 0a                	je     100dca <printer_vprintf+0x751>
                prefix = "-";
  100dc0:	48 c7 45 c0 d7 13 10 	movq   $0x1013d7,-0x40(%rbp)
  100dc7:	00 
            if (flags & FLAG_NEGATIVE) {
  100dc8:	eb 73                	jmp    100e3d <printer_vprintf+0x7c4>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100dca:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100dcd:	83 e0 10             	and    $0x10,%eax
  100dd0:	85 c0                	test   %eax,%eax
  100dd2:	74 0a                	je     100dde <printer_vprintf+0x765>
                prefix = "+";
  100dd4:	48 c7 45 c0 d9 13 10 	movq   $0x1013d9,-0x40(%rbp)
  100ddb:	00 
            if (flags & FLAG_NEGATIVE) {
  100ddc:	eb 5f                	jmp    100e3d <printer_vprintf+0x7c4>
            } else if (flags & FLAG_SPACEPOSITIVE) {
  100dde:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100de1:	83 e0 08             	and    $0x8,%eax
  100de4:	85 c0                	test   %eax,%eax
  100de6:	74 55                	je     100e3d <printer_vprintf+0x7c4>
                prefix = " ";
  100de8:	48 c7 45 c0 db 13 10 	movq   $0x1013db,-0x40(%rbp)
  100def:	00 
            if (flags & FLAG_NEGATIVE) {
  100df0:	eb 4b                	jmp    100e3d <printer_vprintf+0x7c4>
            }
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100df2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100df5:	83 e0 20             	and    $0x20,%eax
  100df8:	85 c0                	test   %eax,%eax
  100dfa:	74 42                	je     100e3e <printer_vprintf+0x7c5>
  100dfc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100dff:	83 e0 01             	and    $0x1,%eax
  100e02:	85 c0                	test   %eax,%eax
  100e04:	74 38                	je     100e3e <printer_vprintf+0x7c5>
                   && (base == 16 || base == -16)
  100e06:	83 7d e0 10          	cmpl   $0x10,-0x20(%rbp)
  100e0a:	74 06                	je     100e12 <printer_vprintf+0x799>
  100e0c:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  100e10:	75 2c                	jne    100e3e <printer_vprintf+0x7c5>
                   && (num || (flags & FLAG_ALT2))) {
  100e12:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  100e17:	75 0c                	jne    100e25 <printer_vprintf+0x7ac>
  100e19:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100e1c:	25 00 01 00 00       	and    $0x100,%eax
  100e21:	85 c0                	test   %eax,%eax
  100e23:	74 19                	je     100e3e <printer_vprintf+0x7c5>
            prefix = (base == -16 ? "0x" : "0X");
  100e25:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  100e29:	75 07                	jne    100e32 <printer_vprintf+0x7b9>
  100e2b:	b8 dd 13 10 00       	mov    $0x1013dd,%eax
  100e30:	eb 05                	jmp    100e37 <printer_vprintf+0x7be>
  100e32:	b8 e0 13 10 00       	mov    $0x1013e0,%eax
  100e37:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100e3b:	eb 01                	jmp    100e3e <printer_vprintf+0x7c5>
            if (flags & FLAG_NEGATIVE) {
  100e3d:	90                   	nop
        }

        int len;
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  100e3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  100e42:	78 24                	js     100e68 <printer_vprintf+0x7ef>
  100e44:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100e47:	83 e0 20             	and    $0x20,%eax
  100e4a:	85 c0                	test   %eax,%eax
  100e4c:	75 1a                	jne    100e68 <printer_vprintf+0x7ef>
            len = strnlen(data, precision);
  100e4e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100e51:	48 63 d0             	movslq %eax,%rdx
  100e54:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100e58:	48 89 d6             	mov    %rdx,%rsi
  100e5b:	48 89 c7             	mov    %rax,%rdi
  100e5e:	e8 ea f5 ff ff       	call   10044d <strnlen>
  100e63:	89 45 bc             	mov    %eax,-0x44(%rbp)
  100e66:	eb 0f                	jmp    100e77 <printer_vprintf+0x7fe>
        } else {
            len = strlen(data);
  100e68:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100e6c:	48 89 c7             	mov    %rax,%rdi
  100e6f:	e8 a8 f5 ff ff       	call   10041c <strlen>
  100e74:	89 45 bc             	mov    %eax,-0x44(%rbp)
        }
        int zeros;
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  100e77:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100e7a:	83 e0 20             	and    $0x20,%eax
  100e7d:	85 c0                	test   %eax,%eax
  100e7f:	74 20                	je     100ea1 <printer_vprintf+0x828>
  100e81:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  100e85:	78 1a                	js     100ea1 <printer_vprintf+0x828>
            zeros = precision > len ? precision - len : 0;
  100e87:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100e8a:	3b 45 bc             	cmp    -0x44(%rbp),%eax
  100e8d:	7e 08                	jle    100e97 <printer_vprintf+0x81e>
  100e8f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100e92:	2b 45 bc             	sub    -0x44(%rbp),%eax
  100e95:	eb 05                	jmp    100e9c <printer_vprintf+0x823>
  100e97:	b8 00 00 00 00       	mov    $0x0,%eax
  100e9c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  100e9f:	eb 5c                	jmp    100efd <printer_vprintf+0x884>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100ea1:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100ea4:	83 e0 20             	and    $0x20,%eax
  100ea7:	85 c0                	test   %eax,%eax
  100ea9:	74 4b                	je     100ef6 <printer_vprintf+0x87d>
  100eab:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100eae:	83 e0 02             	and    $0x2,%eax
  100eb1:	85 c0                	test   %eax,%eax
  100eb3:	74 41                	je     100ef6 <printer_vprintf+0x87d>
                   && !(flags & FLAG_LEFTJUSTIFY)
  100eb5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100eb8:	83 e0 04             	and    $0x4,%eax
  100ebb:	85 c0                	test   %eax,%eax
  100ebd:	75 37                	jne    100ef6 <printer_vprintf+0x87d>
                   && len + (int) strlen(prefix) < width) {
  100ebf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100ec3:	48 89 c7             	mov    %rax,%rdi
  100ec6:	e8 51 f5 ff ff       	call   10041c <strlen>
  100ecb:	89 c2                	mov    %eax,%edx
  100ecd:	8b 45 bc             	mov    -0x44(%rbp),%eax
  100ed0:	01 d0                	add    %edx,%eax
  100ed2:	39 45 e8             	cmp    %eax,-0x18(%rbp)
  100ed5:	7e 1f                	jle    100ef6 <printer_vprintf+0x87d>
            zeros = width - len - strlen(prefix);
  100ed7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  100eda:	2b 45 bc             	sub    -0x44(%rbp),%eax
  100edd:	89 c3                	mov    %eax,%ebx
  100edf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100ee3:	48 89 c7             	mov    %rax,%rdi
  100ee6:	e8 31 f5 ff ff       	call   10041c <strlen>
  100eeb:	89 c2                	mov    %eax,%edx
  100eed:	89 d8                	mov    %ebx,%eax
  100eef:	29 d0                	sub    %edx,%eax
  100ef1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  100ef4:	eb 07                	jmp    100efd <printer_vprintf+0x884>
        } else {
            zeros = 0;
  100ef6:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
        }
        width -= len + zeros + strlen(prefix);
  100efd:	8b 55 bc             	mov    -0x44(%rbp),%edx
  100f00:	8b 45 b8             	mov    -0x48(%rbp),%eax
  100f03:	01 d0                	add    %edx,%eax
  100f05:	48 63 d8             	movslq %eax,%rbx
  100f08:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100f0c:	48 89 c7             	mov    %rax,%rdi
  100f0f:	e8 08 f5 ff ff       	call   10041c <strlen>
  100f14:	48 8d 14 03          	lea    (%rbx,%rax,1),%rdx
  100f18:	8b 45 e8             	mov    -0x18(%rbp),%eax
  100f1b:	29 d0                	sub    %edx,%eax
  100f1d:	89 45 e8             	mov    %eax,-0x18(%rbp)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100f20:	eb 25                	jmp    100f47 <printer_vprintf+0x8ce>
            p->putc(p, ' ', color);
  100f22:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f29:	48 8b 08             	mov    (%rax),%rcx
  100f2c:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100f32:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f39:	be 20 00 00 00       	mov    $0x20,%esi
  100f3e:	48 89 c7             	mov    %rax,%rdi
  100f41:	ff d1                	call   *%rcx
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100f43:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  100f47:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100f4a:	83 e0 04             	and    $0x4,%eax
  100f4d:	85 c0                	test   %eax,%eax
  100f4f:	75 36                	jne    100f87 <printer_vprintf+0x90e>
  100f51:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  100f55:	7f cb                	jg     100f22 <printer_vprintf+0x8a9>
        }
        for (; *prefix; ++prefix) {
  100f57:	eb 2e                	jmp    100f87 <printer_vprintf+0x90e>
            p->putc(p, *prefix, color);
  100f59:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f60:	4c 8b 00             	mov    (%rax),%r8
  100f63:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100f67:	0f b6 00             	movzbl (%rax),%eax
  100f6a:	0f b6 c8             	movzbl %al,%ecx
  100f6d:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100f73:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f7a:	89 ce                	mov    %ecx,%esi
  100f7c:	48 89 c7             	mov    %rax,%rdi
  100f7f:	41 ff d0             	call   *%r8
        for (; *prefix; ++prefix) {
  100f82:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  100f87:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100f8b:	0f b6 00             	movzbl (%rax),%eax
  100f8e:	84 c0                	test   %al,%al
  100f90:	75 c7                	jne    100f59 <printer_vprintf+0x8e0>
        }
        for (; zeros > 0; --zeros) {
  100f92:	eb 25                	jmp    100fb9 <printer_vprintf+0x940>
            p->putc(p, '0', color);
  100f94:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f9b:	48 8b 08             	mov    (%rax),%rcx
  100f9e:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100fa4:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100fab:	be 30 00 00 00       	mov    $0x30,%esi
  100fb0:	48 89 c7             	mov    %rax,%rdi
  100fb3:	ff d1                	call   *%rcx
        for (; zeros > 0; --zeros) {
  100fb5:	83 6d b8 01          	subl   $0x1,-0x48(%rbp)
  100fb9:	83 7d b8 00          	cmpl   $0x0,-0x48(%rbp)
  100fbd:	7f d5                	jg     100f94 <printer_vprintf+0x91b>
        }
        for (; len > 0; ++data, --len) {
  100fbf:	eb 32                	jmp    100ff3 <printer_vprintf+0x97a>
            p->putc(p, *data, color);
  100fc1:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100fc8:	4c 8b 00             	mov    (%rax),%r8
  100fcb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100fcf:	0f b6 00             	movzbl (%rax),%eax
  100fd2:	0f b6 c8             	movzbl %al,%ecx
  100fd5:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100fdb:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100fe2:	89 ce                	mov    %ecx,%esi
  100fe4:	48 89 c7             	mov    %rax,%rdi
  100fe7:	41 ff d0             	call   *%r8
        for (; len > 0; ++data, --len) {
  100fea:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  100fef:	83 6d bc 01          	subl   $0x1,-0x44(%rbp)
  100ff3:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  100ff7:	7f c8                	jg     100fc1 <printer_vprintf+0x948>
        }
        for (; width > 0; --width) {
  100ff9:	eb 25                	jmp    101020 <printer_vprintf+0x9a7>
            p->putc(p, ' ', color);
  100ffb:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  101002:	48 8b 08             	mov    (%rax),%rcx
  101005:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  10100b:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  101012:	be 20 00 00 00       	mov    $0x20,%esi
  101017:	48 89 c7             	mov    %rax,%rdi
  10101a:	ff d1                	call   *%rcx
        for (; width > 0; --width) {
  10101c:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  101020:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  101024:	7f d5                	jg     100ffb <printer_vprintf+0x982>
        }
    done: ;
  101026:	90                   	nop
    for (; *format; ++format) {
  101027:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  10102e:	01 
  10102f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  101036:	0f b6 00             	movzbl (%rax),%eax
  101039:	84 c0                	test   %al,%al
  10103b:	0f 85 64 f6 ff ff    	jne    1006a5 <printer_vprintf+0x2c>
    }
}
  101041:	90                   	nop
  101042:	90                   	nop
  101043:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  101047:	c9                   	leave
  101048:	c3                   	ret

0000000000101049 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  101049:	55                   	push   %rbp
  10104a:	48 89 e5             	mov    %rsp,%rbp
  10104d:	48 83 ec 20          	sub    $0x20,%rsp
  101051:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  101055:	89 f0                	mov    %esi,%eax
  101057:	89 55 e0             	mov    %edx,-0x20(%rbp)
  10105a:	88 45 e4             	mov    %al,-0x1c(%rbp)
    console_printer* cp = (console_printer*) p;
  10105d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  101061:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  101065:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  101069:	48 8b 40 08          	mov    0x8(%rax),%rax
  10106d:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
  101072:	48 39 d0             	cmp    %rdx,%rax
  101075:	72 0c                	jb     101083 <console_putc+0x3a>
        cp->cursor = console;
  101077:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10107b:	48 c7 40 08 00 80 0b 	movq   $0xb8000,0x8(%rax)
  101082:	00 
    }
    if (c == '\n') {
  101083:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%rbp)
  101087:	75 78                	jne    101101 <console_putc+0xb8>
        int pos = (cp->cursor - console) % 80;
  101089:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10108d:	48 8b 40 08          	mov    0x8(%rax),%rax
  101091:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  101097:	48 d1 f8             	sar    %rax
  10109a:	48 89 c1             	mov    %rax,%rcx
  10109d:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1010a4:	66 66 66 
  1010a7:	48 89 c8             	mov    %rcx,%rax
  1010aa:	48 f7 ea             	imul   %rdx
  1010ad:	48 c1 fa 05          	sar    $0x5,%rdx
  1010b1:	48 89 c8             	mov    %rcx,%rax
  1010b4:	48 c1 f8 3f          	sar    $0x3f,%rax
  1010b8:	48 29 c2             	sub    %rax,%rdx
  1010bb:	48 89 d0             	mov    %rdx,%rax
  1010be:	48 c1 e0 02          	shl    $0x2,%rax
  1010c2:	48 01 d0             	add    %rdx,%rax
  1010c5:	48 c1 e0 04          	shl    $0x4,%rax
  1010c9:	48 29 c1             	sub    %rax,%rcx
  1010cc:	48 89 ca             	mov    %rcx,%rdx
  1010cf:	89 55 fc             	mov    %edx,-0x4(%rbp)
        for (; pos != 80; pos++) {
  1010d2:	eb 25                	jmp    1010f9 <console_putc+0xb0>
            *cp->cursor++ = ' ' | color;
  1010d4:	8b 45 e0             	mov    -0x20(%rbp),%eax
  1010d7:	83 c8 20             	or     $0x20,%eax
  1010da:	89 c6                	mov    %eax,%esi
  1010dc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1010e0:	48 8b 40 08          	mov    0x8(%rax),%rax
  1010e4:	48 8d 48 02          	lea    0x2(%rax),%rcx
  1010e8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  1010ec:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1010f0:	89 f2                	mov    %esi,%edx
  1010f2:	66 89 10             	mov    %dx,(%rax)
        for (; pos != 80; pos++) {
  1010f5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  1010f9:	83 7d fc 50          	cmpl   $0x50,-0x4(%rbp)
  1010fd:	75 d5                	jne    1010d4 <console_putc+0x8b>
        }
    } else {
        *cp->cursor++ = c | color;
    }
}
  1010ff:	eb 24                	jmp    101125 <console_putc+0xdc>
        *cp->cursor++ = c | color;
  101101:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
  101105:	8b 55 e0             	mov    -0x20(%rbp),%edx
  101108:	09 d0                	or     %edx,%eax
  10110a:	89 c6                	mov    %eax,%esi
  10110c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  101110:	48 8b 40 08          	mov    0x8(%rax),%rax
  101114:	48 8d 48 02          	lea    0x2(%rax),%rcx
  101118:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  10111c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  101120:	89 f2                	mov    %esi,%edx
  101122:	66 89 10             	mov    %dx,(%rax)
}
  101125:	90                   	nop
  101126:	c9                   	leave
  101127:	c3                   	ret

0000000000101128 <console_vprintf>:

int console_vprintf(int cpos, int color, const char* format, va_list val) {
  101128:	55                   	push   %rbp
  101129:	48 89 e5             	mov    %rsp,%rbp
  10112c:	48 83 ec 30          	sub    $0x30,%rsp
  101130:	89 7d ec             	mov    %edi,-0x14(%rbp)
  101133:	89 75 e8             	mov    %esi,-0x18(%rbp)
  101136:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  10113a:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
    struct console_printer cp;
    cp.p.putc = console_putc;
  10113e:	48 c7 45 f0 49 10 10 	movq   $0x101049,-0x10(%rbp)
  101145:	00 
    if (cpos < 0 || cpos >= CONSOLE_ROWS * CONSOLE_COLUMNS) {
  101146:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  10114a:	78 09                	js     101155 <console_vprintf+0x2d>
  10114c:	81 7d ec cf 07 00 00 	cmpl   $0x7cf,-0x14(%rbp)
  101153:	7e 07                	jle    10115c <console_vprintf+0x34>
        cpos = 0;
  101155:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
    cp.cursor = console + cpos;
  10115c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  10115f:	48 98                	cltq
  101161:	48 01 c0             	add    %rax,%rax
  101164:	48 05 00 80 0b 00    	add    $0xb8000,%rax
  10116a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  10116e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  101172:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  101176:	8b 75 e8             	mov    -0x18(%rbp),%esi
  101179:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  10117d:	48 89 c7             	mov    %rax,%rdi
  101180:	e8 f4 f4 ff ff       	call   100679 <printer_vprintf>
    return cp.cursor - console;
  101185:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  101189:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  10118f:	48 d1 f8             	sar    %rax
}
  101192:	c9                   	leave
  101193:	c3                   	ret

0000000000101194 <console_printf>:

int console_printf(int cpos, int color, const char* format, ...) {
  101194:	55                   	push   %rbp
  101195:	48 89 e5             	mov    %rsp,%rbp
  101198:	48 83 ec 60          	sub    $0x60,%rsp
  10119c:	89 7d ac             	mov    %edi,-0x54(%rbp)
  10119f:	89 75 a8             	mov    %esi,-0x58(%rbp)
  1011a2:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  1011a6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1011aa:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1011ae:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  1011b2:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1011b9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1011bd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1011c1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1011c5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1011c9:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1011cd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  1011d1:	8b 75 a8             	mov    -0x58(%rbp),%esi
  1011d4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  1011d7:	89 c7                	mov    %eax,%edi
  1011d9:	e8 4a ff ff ff       	call   101128 <console_vprintf>
  1011de:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
  1011e1:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
  1011e4:	c9                   	leave
  1011e5:	c3                   	ret

00000000001011e6 <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  1011e6:	55                   	push   %rbp
  1011e7:	48 89 e5             	mov    %rsp,%rbp
  1011ea:	48 83 ec 20          	sub    $0x20,%rsp
  1011ee:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1011f2:	89 f0                	mov    %esi,%eax
  1011f4:	89 55 e0             	mov    %edx,-0x20(%rbp)
  1011f7:	88 45 e4             	mov    %al,-0x1c(%rbp)
    string_printer* sp = (string_printer*) p;
  1011fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1011fe:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (sp->s < sp->end) {
  101202:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  101206:	48 8b 50 08          	mov    0x8(%rax),%rdx
  10120a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10120e:	48 8b 40 10          	mov    0x10(%rax),%rax
  101212:	48 39 c2             	cmp    %rax,%rdx
  101215:	73 1a                	jae    101231 <string_putc+0x4b>
        *sp->s++ = c;
  101217:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10121b:	48 8b 40 08          	mov    0x8(%rax),%rax
  10121f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  101223:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  101227:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  10122b:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
  10122f:	88 10                	mov    %dl,(%rax)
    }
    (void) color;
}
  101231:	90                   	nop
  101232:	c9                   	leave
  101233:	c3                   	ret

0000000000101234 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  101234:	55                   	push   %rbp
  101235:	48 89 e5             	mov    %rsp,%rbp
  101238:	48 83 ec 40          	sub    $0x40,%rsp
  10123c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  101240:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  101244:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  101248:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    string_printer sp;
    sp.p.putc = string_putc;
  10124c:	48 c7 45 e8 e6 11 10 	movq   $0x1011e6,-0x18(%rbp)
  101253:	00 
    sp.s = s;
  101254:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  101258:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (size) {
  10125c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  101261:	74 33                	je     101296 <vsnprintf+0x62>
        sp.end = s + size - 1;
  101263:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  101267:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  10126b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  10126f:	48 01 d0             	add    %rdx,%rax
  101272:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  101276:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  10127a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  10127e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  101282:	be 00 00 00 00       	mov    $0x0,%esi
  101287:	48 89 c7             	mov    %rax,%rdi
  10128a:	e8 ea f3 ff ff       	call   100679 <printer_vprintf>
        *sp.s = 0;
  10128f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  101293:	c6 00 00             	movb   $0x0,(%rax)
    }
    return sp.s - s;
  101296:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10129a:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
}
  10129e:	c9                   	leave
  10129f:	c3                   	ret

00000000001012a0 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  1012a0:	55                   	push   %rbp
  1012a1:	48 89 e5             	mov    %rsp,%rbp
  1012a4:	48 83 ec 70          	sub    $0x70,%rsp
  1012a8:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  1012ac:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  1012b0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  1012b4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1012b8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1012bc:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  1012c0:	c7 45 b0 18 00 00 00 	movl   $0x18,-0x50(%rbp)
  1012c7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1012cb:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  1012cf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1012d3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    int n = vsnprintf(s, size, format, val);
  1012d7:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  1012db:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  1012df:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  1012e3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1012e7:	48 89 c7             	mov    %rax,%rdi
  1012ea:	e8 45 ff ff ff       	call   101234 <vsnprintf>
  1012ef:	89 45 cc             	mov    %eax,-0x34(%rbp)
    va_end(val);
    return n;
  1012f2:	8b 45 cc             	mov    -0x34(%rbp),%eax
}
  1012f5:	c9                   	leave
  1012f6:	c3                   	ret

00000000001012f7 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  1012f7:	55                   	push   %rbp
  1012f8:	48 89 e5             	mov    %rsp,%rbp
  1012fb:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1012ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  101306:	eb 13                	jmp    10131b <console_clear+0x24>
        console[i] = ' ' | 0x0700;
  101308:	8b 45 fc             	mov    -0x4(%rbp),%eax
  10130b:	48 98                	cltq
  10130d:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%rax,%rax,1)
  101314:	00 20 07 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  101317:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  10131b:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
  101322:	7e e4                	jle    101308 <console_clear+0x11>
    }
    cursorpos = 0;
  101324:	c7 05 ce 7c fb ff 00 	movl   $0x0,-0x48332(%rip)        # b8ffc <cursorpos>
  10132b:	00 00 00 
}
  10132e:	90                   	nop
  10132f:	c9                   	leave
  101330:	c3                   	ret
