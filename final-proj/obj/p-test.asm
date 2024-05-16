
obj/p-test.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:

uint8_t * heap_top;
uint8_t * heap_bottom;
uint8_t * stack_bottom;

void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	48 83 ec 20          	sub    $0x20,%rsp

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  100008:	cd 31                	int    $0x31
  10000a:	89 c7                	mov    %eax,%edi
    pid_t p = getpid();
    srand(p);
  10000c:	e8 b5 05 00 00       	call   1005c6 <srand>
    heap_bottom = heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  100011:	b8 27 30 10 00       	mov    $0x103027,%eax
  100016:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10001c:	48 89 05 ed 1f 00 00 	mov    %rax,0x1fed(%rip)        # 102010 <heap_top>
  100023:	48 89 05 de 1f 00 00 	mov    %rax,0x1fde(%rip)        # 102008 <heap_bottom>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  10002a:	48 89 e0             	mov    %rsp,%rax
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  10002d:	48 83 e8 01          	sub    $0x1,%rax
  100031:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100037:	48 89 05 c2 1f 00 00 	mov    %rax,0x1fc2(%rip)        # 102000 <stack_bottom>
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  10003e:	bf 00 54 00 00       	mov    $0x5400,%edi
  100043:	cd 3a                	int    $0x3a
  100045:	48 89 05 cc 1f 00 00 	mov    %rax,0x1fcc(%rip)        # 102018 <result.0>

    /* move the break forward by 21KB -> ~5 pages */
    assert(sbrk(1024*21) == heap_bottom);
  10004c:	48 39 05 b5 1f 00 00 	cmp    %rax,0x1fb5(%rip)        # 102008 <heap_bottom>
  100053:	74 14                	je     100069 <process_main+0x69>
  100055:	ba 30 13 10 00       	mov    $0x101330,%edx
  10005a:	be 14 00 00 00       	mov    $0x14,%esi
  10005f:	bf 4d 13 10 00       	mov    $0x10134d,%edi
  100064:	e8 37 02 00 00       	call   1002a0 <assert_fail>
  100069:	bf 00 00 00 00       	mov    $0x0,%edi
  10006e:	cd 3a                	int    $0x3a
  100070:	48 89 05 a1 1f 00 00 	mov    %rax,0x1fa1(%rip)        # 102018 <result.0>

    /* get the new break */
    heap_top = (uint8_t *)sbrk(0);
  100077:	48 89 05 92 1f 00 00 	mov    %rax,0x1f92(%rip)        # 102010 <heap_top>

    /* force the pages to be allocated */
    for(size_t i = 0; i < (uintptr_t)(heap_top - heap_bottom); ++i) {
  10007e:	48 8b 15 83 1f 00 00 	mov    0x1f83(%rip),%rdx        # 102008 <heap_bottom>
  100085:	48 39 d0             	cmp    %rdx,%rax
  100088:	74 29                	je     1000b3 <process_main+0xb3>
  10008a:	b8 00 00 00 00       	mov    $0x0,%eax
        heap_bottom[i] = 'A';
  10008f:	c6 04 02 41          	movb   $0x41,(%rdx,%rax,1)
        assert(heap_bottom[i] == 'A');
  100093:	48 8b 15 6e 1f 00 00 	mov    0x1f6e(%rip),%rdx        # 102008 <heap_bottom>
  10009a:	80 3c 02 41          	cmpb   $0x41,(%rdx,%rax,1)
  10009e:	75 43                	jne    1000e3 <process_main+0xe3>
    for(size_t i = 0; i < (uintptr_t)(heap_top - heap_bottom); ++i) {
  1000a0:	48 83 c0 01          	add    $0x1,%rax
  1000a4:	48 8b 0d 65 1f 00 00 	mov    0x1f65(%rip),%rcx        # 102010 <heap_top>
  1000ab:	48 29 d1             	sub    %rdx,%rcx
  1000ae:	48 39 c8             	cmp    %rcx,%rax
  1000b1:	72 dc                	jb     10008f <process_main+0x8f>
  1000b3:	48 c7 c7 00 ac ff ff 	mov    $0xffffffffffffac00,%rdi
  1000ba:	cd 3a                	int    $0x3a
  1000bc:	48 89 05 55 1f 00 00 	mov    %rax,0x1f55(%rip)        # 102018 <result.0>
    }

    /* Break unmodied after optimistic allocation, move it back 21KB. */
    assert(sbrk(-1024*21) == heap_top);
  1000c3:	48 8b 15 46 1f 00 00 	mov    0x1f46(%rip),%rdx        # 102010 <heap_top>
  1000ca:	48 39 c2             	cmp    %rax,%rdx
  1000cd:	74 28                	je     1000f7 <process_main+0xf7>
  1000cf:	ba 73 13 10 00       	mov    $0x101373,%edx
  1000d4:	be 20 00 00 00       	mov    $0x20,%esi
  1000d9:	bf 4d 13 10 00       	mov    $0x10134d,%edi
  1000de:	e8 bd 01 00 00       	call   1002a0 <assert_fail>
        assert(heap_bottom[i] == 'A');
  1000e3:	ba 5d 13 10 00       	mov    $0x10135d,%edx
  1000e8:	be 1c 00 00 00       	mov    $0x1c,%esi
  1000ed:	bf 4d 13 10 00       	mov    $0x10134d,%edi
  1000f2:	e8 a9 01 00 00       	call   1002a0 <assert_fail>

    /* check that pages were deallocated */
    for(uintptr_t va = (uintptr_t)heap_bottom; va < (uintptr_t)heap_top; va += 4096) {
  1000f7:	48 8b 35 0a 1f 00 00 	mov    0x1f0a(%rip),%rsi        # 102008 <heap_bottom>
  1000fe:	48 39 d6             	cmp    %rdx,%rsi
  100101:	73 1c                	jae    10011f <process_main+0x11f>
    asm volatile ("int %0" : /* no result */
  100103:	48 8d 7d e8          	lea    -0x18(%rbp),%rdi
  100107:	cd 36                	int    $0x36
        vamapping map;
        mapping(va, &map);
	assert(!(map.perm & PTE_P));
  100109:	f6 45 f8 01          	testb  $0x1,-0x8(%rbp)
  10010d:	75 1f                	jne    10012e <process_main+0x12e>
    for(uintptr_t va = (uintptr_t)heap_bottom; va < (uintptr_t)heap_top; va += 4096) {
  10010f:	48 81 c6 00 10 00 00 	add    $0x1000,%rsi
  100116:	48 3b 35 f3 1e 00 00 	cmp    0x1ef3(%rip),%rsi        # 102010 <heap_top>
  10011d:	72 e8                	jb     100107 <process_main+0x107>
    }

    TEST_PASS();
  10011f:	bf a2 13 10 00       	mov    $0x1013a2,%edi
  100124:	b8 00 00 00 00       	mov    $0x0,%eax
  100129:	e8 a4 00 00 00       	call   1001d2 <kernel_panic>
	assert(!(map.perm & PTE_P));
  10012e:	ba 8e 13 10 00       	mov    $0x10138e,%edx
  100133:	be 26 00 00 00       	mov    $0x26,%esi
  100138:	bf 4d 13 10 00       	mov    $0x10134d,%edi
  10013d:	e8 5e 01 00 00       	call   1002a0 <assert_fail>

0000000000100142 <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  100142:	55                   	push   %rbp
  100143:	48 89 e5             	mov    %rsp,%rbp
  100146:	48 83 ec 50          	sub    $0x50,%rsp
  10014a:	49 89 f2             	mov    %rsi,%r10
  10014d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  100151:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100155:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100159:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  10015d:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  100162:	85 ff                	test   %edi,%edi
  100164:	78 2e                	js     100194 <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  100166:	48 63 ff             	movslq %edi,%rdi
  100169:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  100170:	cc cc cc 
  100173:	48 89 f8             	mov    %rdi,%rax
  100176:	48 f7 e2             	mul    %rdx
  100179:	48 89 d0             	mov    %rdx,%rax
  10017c:	48 c1 e8 02          	shr    $0x2,%rax
  100180:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  100184:	48 01 c2             	add    %rax,%rdx
  100187:	48 29 d7             	sub    %rdx,%rdi
  10018a:	0f b6 b7 f5 13 10 00 	movzbl 0x1013f5(%rdi),%esi
  100191:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  100194:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  10019b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  10019f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1001a3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1001a7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  1001ab:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1001af:	4c 89 d2             	mov    %r10,%rdx
  1001b2:	8b 3d 44 8e fb ff    	mov    -0x471bc(%rip),%edi        # b8ffc <cursorpos>
  1001b8:	e8 5b 0f 00 00       	call   101118 <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  1001bd:	3d 30 07 00 00       	cmp    $0x730,%eax
  1001c2:	ba 00 00 00 00       	mov    $0x0,%edx
  1001c7:	0f 4d c2             	cmovge %edx,%eax
  1001ca:	89 05 2c 8e fb ff    	mov    %eax,-0x471d4(%rip)        # b8ffc <cursorpos>
    }
}
  1001d0:	c9                   	leave
  1001d1:	c3                   	ret

00000000001001d2 <kernel_panic>:


// kernel_panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void kernel_panic(const char* format, ...) {
  1001d2:	55                   	push   %rbp
  1001d3:	48 89 e5             	mov    %rsp,%rbp
  1001d6:	53                   	push   %rbx
  1001d7:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  1001de:	48 89 fb             	mov    %rdi,%rbx
  1001e1:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  1001e5:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  1001e9:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  1001ed:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  1001f1:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  1001f5:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  1001fc:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100200:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  100204:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  100208:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  10020c:	ba 07 00 00 00       	mov    $0x7,%edx
  100211:	be bd 13 10 00       	mov    $0x1013bd,%esi
  100216:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  10021d:	e8 ad 00 00 00       	call   1002cf <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  100222:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  100226:	48 89 da             	mov    %rbx,%rdx
  100229:	be 99 00 00 00       	mov    $0x99,%esi
  10022e:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  100235:	e8 ea 0f 00 00       	call   101224 <vsnprintf>
  10023a:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  10023d:	85 d2                	test   %edx,%edx
  10023f:	7e 0f                	jle    100250 <kernel_panic+0x7e>
  100241:	83 c0 06             	add    $0x6,%eax
  100244:	48 98                	cltq
  100246:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  10024d:	0a 
  10024e:	75 2a                	jne    10027a <kernel_panic+0xa8>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  100250:	48 8d 9d 08 ff ff ff 	lea    -0xf8(%rbp),%rbx
  100257:	48 89 d9             	mov    %rbx,%rcx
  10025a:	ba c7 13 10 00       	mov    $0x1013c7,%edx
  10025f:	be 00 c0 00 00       	mov    $0xc000,%esi
  100264:	bf 30 07 00 00       	mov    $0x730,%edi
  100269:	b8 00 00 00 00       	mov    $0x0,%eax
  10026e:	e8 11 0f 00 00       	call   101184 <console_printf>
    asm volatile ("int %0" : /* no result */
  100273:	48 89 df             	mov    %rbx,%rdi
  100276:	cd 30                	int    $0x30
 loop: goto loop;
  100278:	eb fe                	jmp    100278 <kernel_panic+0xa6>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  10027a:	48 63 c2             	movslq %edx,%rax
  10027d:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  100283:	0f 94 c2             	sete   %dl
  100286:	0f b6 d2             	movzbl %dl,%edx
  100289:	48 29 d0             	sub    %rdx,%rax
  10028c:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  100293:	ff 
  100294:	be c5 13 10 00       	mov    $0x1013c5,%esi
  100299:	e8 de 01 00 00       	call   10047c <strcpy>
  10029e:	eb b0                	jmp    100250 <kernel_panic+0x7e>

00000000001002a0 <assert_fail>:
    panic(buf);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  1002a0:	55                   	push   %rbp
  1002a1:	48 89 e5             	mov    %rsp,%rbp
  1002a4:	48 89 f9             	mov    %rdi,%rcx
  1002a7:	41 89 f0             	mov    %esi,%r8d
  1002aa:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  1002ad:	ba d0 13 10 00       	mov    $0x1013d0,%edx
  1002b2:	be 00 c0 00 00       	mov    $0xc000,%esi
  1002b7:	bf 30 07 00 00       	mov    $0x730,%edi
  1002bc:	b8 00 00 00 00       	mov    $0x0,%eax
  1002c1:	e8 be 0e 00 00       	call   101184 <console_printf>
    asm volatile ("int %0" : /* no result */
  1002c6:	bf 00 00 00 00       	mov    $0x0,%edi
  1002cb:	cd 30                	int    $0x30
 loop: goto loop;
  1002cd:	eb fe                	jmp    1002cd <assert_fail+0x2d>

00000000001002cf <memcpy>:


// memcpy, memmove, memset, strcmp, strlen, strnlen
//    We must provide our own implementations.

void* memcpy(void* dst, const void* src, size_t n) {
  1002cf:	55                   	push   %rbp
  1002d0:	48 89 e5             	mov    %rsp,%rbp
  1002d3:	48 83 ec 28          	sub    $0x28,%rsp
  1002d7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1002db:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1002df:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1002e3:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1002e7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1002eb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1002ef:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  1002f3:	eb 1c                	jmp    100311 <memcpy+0x42>
        *d = *s;
  1002f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1002f9:	0f b6 10             	movzbl (%rax),%edx
  1002fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100300:	88 10                	mov    %dl,(%rax)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  100302:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  100307:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  10030c:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  100311:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  100316:	75 dd                	jne    1002f5 <memcpy+0x26>
    }
    return dst;
  100318:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  10031c:	c9                   	leave
  10031d:	c3                   	ret

000000000010031e <memmove>:

void* memmove(void* dst, const void* src, size_t n) {
  10031e:	55                   	push   %rbp
  10031f:	48 89 e5             	mov    %rsp,%rbp
  100322:	48 83 ec 28          	sub    $0x28,%rsp
  100326:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  10032a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  10032e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  100332:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100336:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    char* d = (char*) dst;
  10033a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  10033e:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (s < d && s + n > d) {
  100342:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100346:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  10034a:	73 6a                	jae    1003b6 <memmove+0x98>
  10034c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  100350:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  100354:	48 01 d0             	add    %rdx,%rax
  100357:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
  10035b:	73 59                	jae    1003b6 <memmove+0x98>
        s += n, d += n;
  10035d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  100361:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  100365:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  100369:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        while (n-- > 0) {
  10036d:	eb 17                	jmp    100386 <memmove+0x68>
            *--d = *--s;
  10036f:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  100374:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
  100379:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10037d:	0f b6 10             	movzbl (%rax),%edx
  100380:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100384:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  100386:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  10038a:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  10038e:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  100392:	48 85 c0             	test   %rax,%rax
  100395:	75 d8                	jne    10036f <memmove+0x51>
    if (s < d && s + n > d) {
  100397:	eb 2e                	jmp    1003c7 <memmove+0xa9>
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
  100399:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  10039d:	48 8d 42 01          	lea    0x1(%rdx),%rax
  1003a1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  1003a5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1003a9:	48 8d 48 01          	lea    0x1(%rax),%rcx
  1003ad:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  1003b1:	0f b6 12             	movzbl (%rdx),%edx
  1003b4:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  1003b6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1003ba:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  1003be:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  1003c2:	48 85 c0             	test   %rax,%rax
  1003c5:	75 d2                	jne    100399 <memmove+0x7b>
        }
    }
    return dst;
  1003c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1003cb:	c9                   	leave
  1003cc:	c3                   	ret

00000000001003cd <memset>:

void* memset(void* v, int c, size_t n) {
  1003cd:	55                   	push   %rbp
  1003ce:	48 89 e5             	mov    %rsp,%rbp
  1003d1:	48 83 ec 28          	sub    $0x28,%rsp
  1003d5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1003d9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  1003dc:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1003e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1003e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  1003e8:	eb 15                	jmp    1003ff <memset+0x32>
        *p = c;
  1003ea:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1003ed:	89 c2                	mov    %eax,%edx
  1003ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1003f3:	88 10                	mov    %dl,(%rax)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1003f5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1003fa:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  1003ff:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  100404:	75 e4                	jne    1003ea <memset+0x1d>
    }
    return v;
  100406:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  10040a:	c9                   	leave
  10040b:	c3                   	ret

000000000010040c <strlen>:

size_t strlen(const char* s) {
  10040c:	55                   	push   %rbp
  10040d:	48 89 e5             	mov    %rsp,%rbp
  100410:	48 83 ec 18          	sub    $0x18,%rsp
  100414:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
  100418:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  10041f:	00 
  100420:	eb 0a                	jmp    10042c <strlen+0x20>
        ++n;
  100422:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; *s != '\0'; ++s) {
  100427:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  10042c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100430:	0f b6 00             	movzbl (%rax),%eax
  100433:	84 c0                	test   %al,%al
  100435:	75 eb                	jne    100422 <strlen+0x16>
    }
    return n;
  100437:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  10043b:	c9                   	leave
  10043c:	c3                   	ret

000000000010043d <strnlen>:

size_t strnlen(const char* s, size_t maxlen) {
  10043d:	55                   	push   %rbp
  10043e:	48 89 e5             	mov    %rsp,%rbp
  100441:	48 83 ec 20          	sub    $0x20,%rsp
  100445:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  100449:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    size_t n;
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  10044d:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  100454:	00 
  100455:	eb 0a                	jmp    100461 <strnlen+0x24>
        ++n;
  100457:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  10045c:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  100461:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100465:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  100469:	74 0b                	je     100476 <strnlen+0x39>
  10046b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  10046f:	0f b6 00             	movzbl (%rax),%eax
  100472:	84 c0                	test   %al,%al
  100474:	75 e1                	jne    100457 <strnlen+0x1a>
    }
    return n;
  100476:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  10047a:	c9                   	leave
  10047b:	c3                   	ret

000000000010047c <strcpy>:

char* strcpy(char* dst, const char* src) {
  10047c:	55                   	push   %rbp
  10047d:	48 89 e5             	mov    %rsp,%rbp
  100480:	48 83 ec 20          	sub    $0x20,%rsp
  100484:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  100488:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    char* d = dst;
  10048c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100490:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    do {
        *d++ = *src++;
  100494:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  100498:	48 8d 42 01          	lea    0x1(%rdx),%rax
  10049c:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  1004a0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1004a4:	48 8d 48 01          	lea    0x1(%rax),%rcx
  1004a8:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
  1004ac:	0f b6 12             	movzbl (%rdx),%edx
  1004af:	88 10                	mov    %dl,(%rax)
    } while (d[-1]);
  1004b1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1004b5:	48 83 e8 01          	sub    $0x1,%rax
  1004b9:	0f b6 00             	movzbl (%rax),%eax
  1004bc:	84 c0                	test   %al,%al
  1004be:	75 d4                	jne    100494 <strcpy+0x18>
    return dst;
  1004c0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1004c4:	c9                   	leave
  1004c5:	c3                   	ret

00000000001004c6 <strcmp>:

int strcmp(const char* a, const char* b) {
  1004c6:	55                   	push   %rbp
  1004c7:	48 89 e5             	mov    %rsp,%rbp
  1004ca:	48 83 ec 10          	sub    $0x10,%rsp
  1004ce:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  1004d2:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  1004d6:	eb 0a                	jmp    1004e2 <strcmp+0x1c>
        ++a, ++b;
  1004d8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1004dd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  1004e2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1004e6:	0f b6 00             	movzbl (%rax),%eax
  1004e9:	84 c0                	test   %al,%al
  1004eb:	74 1d                	je     10050a <strcmp+0x44>
  1004ed:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1004f1:	0f b6 00             	movzbl (%rax),%eax
  1004f4:	84 c0                	test   %al,%al
  1004f6:	74 12                	je     10050a <strcmp+0x44>
  1004f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1004fc:	0f b6 10             	movzbl (%rax),%edx
  1004ff:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100503:	0f b6 00             	movzbl (%rax),%eax
  100506:	38 c2                	cmp    %al,%dl
  100508:	74 ce                	je     1004d8 <strcmp+0x12>
    }
    return ((unsigned char) *a > (unsigned char) *b)
  10050a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10050e:	0f b6 00             	movzbl (%rax),%eax
  100511:	89 c2                	mov    %eax,%edx
  100513:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  100517:	0f b6 00             	movzbl (%rax),%eax
  10051a:	38 d0                	cmp    %dl,%al
  10051c:	0f 92 c0             	setb   %al
  10051f:	0f b6 d0             	movzbl %al,%edx
        - ((unsigned char) *a < (unsigned char) *b);
  100522:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100526:	0f b6 00             	movzbl (%rax),%eax
  100529:	89 c1                	mov    %eax,%ecx
  10052b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10052f:	0f b6 00             	movzbl (%rax),%eax
  100532:	38 c1                	cmp    %al,%cl
  100534:	0f 92 c0             	setb   %al
  100537:	0f b6 c0             	movzbl %al,%eax
  10053a:	29 c2                	sub    %eax,%edx
  10053c:	89 d0                	mov    %edx,%eax
}
  10053e:	c9                   	leave
  10053f:	c3                   	ret

0000000000100540 <strchr>:

char* strchr(const char* s, int c) {
  100540:	55                   	push   %rbp
  100541:	48 89 e5             	mov    %rsp,%rbp
  100544:	48 83 ec 10          	sub    $0x10,%rsp
  100548:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  10054c:	89 75 f4             	mov    %esi,-0xc(%rbp)
    while (*s && *s != (char) c) {
  10054f:	eb 05                	jmp    100556 <strchr+0x16>
        ++s;
  100551:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while (*s && *s != (char) c) {
  100556:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10055a:	0f b6 00             	movzbl (%rax),%eax
  10055d:	84 c0                	test   %al,%al
  10055f:	74 0e                	je     10056f <strchr+0x2f>
  100561:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100565:	0f b6 00             	movzbl (%rax),%eax
  100568:	8b 55 f4             	mov    -0xc(%rbp),%edx
  10056b:	38 d0                	cmp    %dl,%al
  10056d:	75 e2                	jne    100551 <strchr+0x11>
    }
    if (*s == (char) c) {
  10056f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100573:	0f b6 00             	movzbl (%rax),%eax
  100576:	8b 55 f4             	mov    -0xc(%rbp),%edx
  100579:	38 d0                	cmp    %dl,%al
  10057b:	75 06                	jne    100583 <strchr+0x43>
        return (char*) s;
  10057d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100581:	eb 05                	jmp    100588 <strchr+0x48>
    } else {
        return NULL;
  100583:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
  100588:	c9                   	leave
  100589:	c3                   	ret

000000000010058a <rand>:
// rand, srand

static int rand_seed_set;
static unsigned rand_seed;

int rand(void) {
  10058a:	55                   	push   %rbp
  10058b:	48 89 e5             	mov    %rsp,%rbp
    if (!rand_seed_set) {
  10058e:	8b 05 8c 1a 00 00    	mov    0x1a8c(%rip),%eax        # 102020 <rand_seed_set>
  100594:	85 c0                	test   %eax,%eax
  100596:	75 0a                	jne    1005a2 <rand+0x18>
        srand(819234718U);
  100598:	bf 9e 87 d4 30       	mov    $0x30d4879e,%edi
  10059d:	e8 24 00 00 00       	call   1005c6 <srand>
    }
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1005a2:	8b 05 7c 1a 00 00    	mov    0x1a7c(%rip),%eax        # 102024 <rand_seed>
  1005a8:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
  1005ae:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  1005b3:	89 05 6b 1a 00 00    	mov    %eax,0x1a6b(%rip)        # 102024 <rand_seed>
    return rand_seed & RAND_MAX;
  1005b9:	8b 05 65 1a 00 00    	mov    0x1a65(%rip),%eax        # 102024 <rand_seed>
  1005bf:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  1005c4:	5d                   	pop    %rbp
  1005c5:	c3                   	ret

00000000001005c6 <srand>:

void srand(unsigned seed) {
  1005c6:	55                   	push   %rbp
  1005c7:	48 89 e5             	mov    %rsp,%rbp
  1005ca:	48 83 ec 08          	sub    $0x8,%rsp
  1005ce:	89 7d fc             	mov    %edi,-0x4(%rbp)
    rand_seed = seed;
  1005d1:	8b 45 fc             	mov    -0x4(%rbp),%eax
  1005d4:	89 05 4a 1a 00 00    	mov    %eax,0x1a4a(%rip)        # 102024 <rand_seed>
    rand_seed_set = 1;
  1005da:	c7 05 3c 1a 00 00 01 	movl   $0x1,0x1a3c(%rip)        # 102020 <rand_seed_set>
  1005e1:	00 00 00 
}
  1005e4:	90                   	nop
  1005e5:	c9                   	leave
  1005e6:	c3                   	ret

00000000001005e7 <fill_numbuf>:
//    Print a message onto the console, starting at the given cursor position.

// snprintf, vsnprintf
//    Format a string into a buffer.

static char* fill_numbuf(char* numbuf_end, unsigned long val, int base) {
  1005e7:	55                   	push   %rbp
  1005e8:	48 89 e5             	mov    %rsp,%rbp
  1005eb:	48 83 ec 28          	sub    $0x28,%rsp
  1005ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1005f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1005f7:	89 55 dc             	mov    %edx,-0x24(%rbp)
    static const char upper_digits[] = "0123456789ABCDEF";
    static const char lower_digits[] = "0123456789abcdef";

    const char* digits = upper_digits;
  1005fa:	48 c7 45 f8 e0 15 10 	movq   $0x1015e0,-0x8(%rbp)
  100601:	00 
    if (base < 0) {
  100602:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  100606:	79 0b                	jns    100613 <fill_numbuf+0x2c>
        digits = lower_digits;
  100608:	48 c7 45 f8 00 16 10 	movq   $0x101600,-0x8(%rbp)
  10060f:	00 
        base = -base;
  100610:	f7 5d dc             	negl   -0x24(%rbp)
    }

    *--numbuf_end = '\0';
  100613:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  100618:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  10061c:	c6 00 00             	movb   $0x0,(%rax)
    do {
        *--numbuf_end = digits[val % base];
  10061f:	8b 45 dc             	mov    -0x24(%rbp),%eax
  100622:	48 63 c8             	movslq %eax,%rcx
  100625:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100629:	ba 00 00 00 00       	mov    $0x0,%edx
  10062e:	48 f7 f1             	div    %rcx
  100631:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100635:	48 01 d0             	add    %rdx,%rax
  100638:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  10063d:	0f b6 10             	movzbl (%rax),%edx
  100640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  100644:	88 10                	mov    %dl,(%rax)
        val /= base;
  100646:	8b 45 dc             	mov    -0x24(%rbp),%eax
  100649:	48 63 f0             	movslq %eax,%rsi
  10064c:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100650:	ba 00 00 00 00       	mov    $0x0,%edx
  100655:	48 f7 f6             	div    %rsi
  100658:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    } while (val != 0);
  10065c:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  100661:	75 bc                	jne    10061f <fill_numbuf+0x38>
    return numbuf_end;
  100663:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  100667:	c9                   	leave
  100668:	c3                   	ret

0000000000100669 <printer_vprintf>:
#define FLAG_NUMERIC            (1<<5)
#define FLAG_SIGNED             (1<<6)
#define FLAG_NEGATIVE           (1<<7)
#define FLAG_ALT2               (1<<8)

void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  100669:	55                   	push   %rbp
  10066a:	48 89 e5             	mov    %rsp,%rbp
  10066d:	53                   	push   %rbx
  10066e:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  100675:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
  10067c:	89 b5 74 ff ff ff    	mov    %esi,-0x8c(%rbp)
  100682:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  100689:	48 89 8d 60 ff ff ff 	mov    %rcx,-0xa0(%rbp)
#define NUMBUFSIZ 24
    char numbuf[NUMBUFSIZ];

    for (; *format; ++format) {
  100690:	e9 8a 09 00 00       	jmp    10101f <printer_vprintf+0x9b6>
        if (*format != '%') {
  100695:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10069c:	0f b6 00             	movzbl (%rax),%eax
  10069f:	3c 25                	cmp    $0x25,%al
  1006a1:	74 31                	je     1006d4 <printer_vprintf+0x6b>
            p->putc(p, *format, color);
  1006a3:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1006aa:	4c 8b 00             	mov    (%rax),%r8
  1006ad:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1006b4:	0f b6 00             	movzbl (%rax),%eax
  1006b7:	0f b6 c8             	movzbl %al,%ecx
  1006ba:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1006c0:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1006c7:	89 ce                	mov    %ecx,%esi
  1006c9:	48 89 c7             	mov    %rax,%rdi
  1006cc:	41 ff d0             	call   *%r8
            continue;
  1006cf:	e9 43 09 00 00       	jmp    101017 <printer_vprintf+0x9ae>
        }

        // process flags
        int flags = 0;
  1006d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        for (++format; *format; ++format) {
  1006db:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1006e2:	01 
  1006e3:	eb 44                	jmp    100729 <printer_vprintf+0xc0>
            const char* flagc = strchr(flag_chars, *format);
  1006e5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1006ec:	0f b6 00             	movzbl (%rax),%eax
  1006ef:	0f be c0             	movsbl %al,%eax
  1006f2:	89 c6                	mov    %eax,%esi
  1006f4:	bf 00 14 10 00       	mov    $0x101400,%edi
  1006f9:	e8 42 fe ff ff       	call   100540 <strchr>
  1006fe:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (flagc) {
  100702:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  100707:	74 30                	je     100739 <printer_vprintf+0xd0>
                flags |= 1 << (flagc - flag_chars);
  100709:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  10070d:	48 2d 00 14 10 00    	sub    $0x101400,%rax
  100713:	ba 01 00 00 00       	mov    $0x1,%edx
  100718:	89 c1                	mov    %eax,%ecx
  10071a:	d3 e2                	shl    %cl,%edx
  10071c:	89 d0                	mov    %edx,%eax
  10071e:	09 45 ec             	or     %eax,-0x14(%rbp)
        for (++format; *format; ++format) {
  100721:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100728:	01 
  100729:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100730:	0f b6 00             	movzbl (%rax),%eax
  100733:	84 c0                	test   %al,%al
  100735:	75 ae                	jne    1006e5 <printer_vprintf+0x7c>
  100737:	eb 01                	jmp    10073a <printer_vprintf+0xd1>
            } else {
                break;
  100739:	90                   	nop
            }
        }

        // process width
        int width = -1;
  10073a:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
        if (*format >= '1' && *format <= '9') {
  100741:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100748:	0f b6 00             	movzbl (%rax),%eax
  10074b:	3c 30                	cmp    $0x30,%al
  10074d:	7e 67                	jle    1007b6 <printer_vprintf+0x14d>
  10074f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100756:	0f b6 00             	movzbl (%rax),%eax
  100759:	3c 39                	cmp    $0x39,%al
  10075b:	7f 59                	jg     1007b6 <printer_vprintf+0x14d>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  10075d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  100764:	eb 2e                	jmp    100794 <printer_vprintf+0x12b>
                width = 10 * width + *format++ - '0';
  100766:	8b 55 e8             	mov    -0x18(%rbp),%edx
  100769:	89 d0                	mov    %edx,%eax
  10076b:	c1 e0 02             	shl    $0x2,%eax
  10076e:	01 d0                	add    %edx,%eax
  100770:	01 c0                	add    %eax,%eax
  100772:	89 c1                	mov    %eax,%ecx
  100774:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10077b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  10077f:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  100786:	0f b6 00             	movzbl (%rax),%eax
  100789:	0f be c0             	movsbl %al,%eax
  10078c:	01 c8                	add    %ecx,%eax
  10078e:	83 e8 30             	sub    $0x30,%eax
  100791:	89 45 e8             	mov    %eax,-0x18(%rbp)
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100794:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10079b:	0f b6 00             	movzbl (%rax),%eax
  10079e:	3c 2f                	cmp    $0x2f,%al
  1007a0:	0f 8e 85 00 00 00    	jle    10082b <printer_vprintf+0x1c2>
  1007a6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1007ad:	0f b6 00             	movzbl (%rax),%eax
  1007b0:	3c 39                	cmp    $0x39,%al
  1007b2:	7e b2                	jle    100766 <printer_vprintf+0xfd>
        if (*format >= '1' && *format <= '9') {
  1007b4:	eb 75                	jmp    10082b <printer_vprintf+0x1c2>
            }
        } else if (*format == '*') {
  1007b6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1007bd:	0f b6 00             	movzbl (%rax),%eax
  1007c0:	3c 2a                	cmp    $0x2a,%al
  1007c2:	75 68                	jne    10082c <printer_vprintf+0x1c3>
            width = va_arg(val, int);
  1007c4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1007cb:	8b 00                	mov    (%rax),%eax
  1007cd:	83 f8 2f             	cmp    $0x2f,%eax
  1007d0:	77 30                	ja     100802 <printer_vprintf+0x199>
  1007d2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1007d9:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1007dd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1007e4:	8b 00                	mov    (%rax),%eax
  1007e6:	89 c0                	mov    %eax,%eax
  1007e8:	48 01 d0             	add    %rdx,%rax
  1007eb:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1007f2:	8b 12                	mov    (%rdx),%edx
  1007f4:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1007f7:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1007fe:	89 0a                	mov    %ecx,(%rdx)
  100800:	eb 1a                	jmp    10081c <printer_vprintf+0x1b3>
  100802:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100809:	48 8b 40 08          	mov    0x8(%rax),%rax
  10080d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100811:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100818:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  10081c:	8b 00                	mov    (%rax),%eax
  10081e:	89 45 e8             	mov    %eax,-0x18(%rbp)
            ++format;
  100821:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100828:	01 
  100829:	eb 01                	jmp    10082c <printer_vprintf+0x1c3>
        if (*format >= '1' && *format <= '9') {
  10082b:	90                   	nop
        }

        // process precision
        int precision = -1;
  10082c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
        if (*format == '.') {
  100833:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10083a:	0f b6 00             	movzbl (%rax),%eax
  10083d:	3c 2e                	cmp    $0x2e,%al
  10083f:	0f 85 00 01 00 00    	jne    100945 <printer_vprintf+0x2dc>
            ++format;
  100845:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  10084c:	01 
            if (*format >= '0' && *format <= '9') {
  10084d:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100854:	0f b6 00             	movzbl (%rax),%eax
  100857:	3c 2f                	cmp    $0x2f,%al
  100859:	7e 67                	jle    1008c2 <printer_vprintf+0x259>
  10085b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100862:	0f b6 00             	movzbl (%rax),%eax
  100865:	3c 39                	cmp    $0x39,%al
  100867:	7f 59                	jg     1008c2 <printer_vprintf+0x259>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100869:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  100870:	eb 2e                	jmp    1008a0 <printer_vprintf+0x237>
                    precision = 10 * precision + *format++ - '0';
  100872:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  100875:	89 d0                	mov    %edx,%eax
  100877:	c1 e0 02             	shl    $0x2,%eax
  10087a:	01 d0                	add    %edx,%eax
  10087c:	01 c0                	add    %eax,%eax
  10087e:	89 c1                	mov    %eax,%ecx
  100880:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100887:	48 8d 50 01          	lea    0x1(%rax),%rdx
  10088b:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  100892:	0f b6 00             	movzbl (%rax),%eax
  100895:	0f be c0             	movsbl %al,%eax
  100898:	01 c8                	add    %ecx,%eax
  10089a:	83 e8 30             	sub    $0x30,%eax
  10089d:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1008a0:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1008a7:	0f b6 00             	movzbl (%rax),%eax
  1008aa:	3c 2f                	cmp    $0x2f,%al
  1008ac:	0f 8e 85 00 00 00    	jle    100937 <printer_vprintf+0x2ce>
  1008b2:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1008b9:	0f b6 00             	movzbl (%rax),%eax
  1008bc:	3c 39                	cmp    $0x39,%al
  1008be:	7e b2                	jle    100872 <printer_vprintf+0x209>
            if (*format >= '0' && *format <= '9') {
  1008c0:	eb 75                	jmp    100937 <printer_vprintf+0x2ce>
                }
            } else if (*format == '*') {
  1008c2:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1008c9:	0f b6 00             	movzbl (%rax),%eax
  1008cc:	3c 2a                	cmp    $0x2a,%al
  1008ce:	75 68                	jne    100938 <printer_vprintf+0x2cf>
                precision = va_arg(val, int);
  1008d0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008d7:	8b 00                	mov    (%rax),%eax
  1008d9:	83 f8 2f             	cmp    $0x2f,%eax
  1008dc:	77 30                	ja     10090e <printer_vprintf+0x2a5>
  1008de:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008e5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1008e9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1008f0:	8b 00                	mov    (%rax),%eax
  1008f2:	89 c0                	mov    %eax,%eax
  1008f4:	48 01 d0             	add    %rdx,%rax
  1008f7:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1008fe:	8b 12                	mov    (%rdx),%edx
  100900:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100903:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  10090a:	89 0a                	mov    %ecx,(%rdx)
  10090c:	eb 1a                	jmp    100928 <printer_vprintf+0x2bf>
  10090e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100915:	48 8b 40 08          	mov    0x8(%rax),%rax
  100919:	48 8d 48 08          	lea    0x8(%rax),%rcx
  10091d:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100924:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100928:	8b 00                	mov    (%rax),%eax
  10092a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                ++format;
  10092d:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100934:	01 
  100935:	eb 01                	jmp    100938 <printer_vprintf+0x2cf>
            if (*format >= '0' && *format <= '9') {
  100937:	90                   	nop
            }
            if (precision < 0) {
  100938:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  10093c:	79 07                	jns    100945 <printer_vprintf+0x2dc>
                precision = 0;
  10093e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
            }
        }

        // process main conversion character
        int base = 10;
  100945:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%rbp)
        unsigned long num = 0;
  10094c:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  100953:	00 
        int length = 0;
  100954:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
        char* data = "";
  10095b:	48 c7 45 c8 06 14 10 	movq   $0x101406,-0x38(%rbp)
  100962:	00 
    again:
        switch (*format) {
  100963:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  10096a:	0f b6 00             	movzbl (%rax),%eax
  10096d:	0f be c0             	movsbl %al,%eax
  100970:	83 e8 43             	sub    $0x43,%eax
  100973:	83 f8 37             	cmp    $0x37,%eax
  100976:	0f 87 9f 03 00 00    	ja     100d1b <printer_vprintf+0x6b2>
  10097c:	89 c0                	mov    %eax,%eax
  10097e:	48 8b 04 c5 18 14 10 	mov    0x101418(,%rax,8),%rax
  100985:	00 
  100986:	ff e0                	jmp    *%rax
        case 'l':
        case 'z':
            length = 1;
  100988:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
            ++format;
  10098f:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  100996:	01 
            goto again;
  100997:	eb ca                	jmp    100963 <printer_vprintf+0x2fa>
        case 'd':
        case 'i': {
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100999:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  10099d:	74 5d                	je     1009fc <printer_vprintf+0x393>
  10099f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009a6:	8b 00                	mov    (%rax),%eax
  1009a8:	83 f8 2f             	cmp    $0x2f,%eax
  1009ab:	77 30                	ja     1009dd <printer_vprintf+0x374>
  1009ad:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009b4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1009b8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009bf:	8b 00                	mov    (%rax),%eax
  1009c1:	89 c0                	mov    %eax,%eax
  1009c3:	48 01 d0             	add    %rdx,%rax
  1009c6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009cd:	8b 12                	mov    (%rdx),%edx
  1009cf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1009d2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009d9:	89 0a                	mov    %ecx,(%rdx)
  1009db:	eb 1a                	jmp    1009f7 <printer_vprintf+0x38e>
  1009dd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1009e4:	48 8b 40 08          	mov    0x8(%rax),%rax
  1009e8:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1009ec:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1009f3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1009f7:	48 8b 00             	mov    (%rax),%rax
  1009fa:	eb 5c                	jmp    100a58 <printer_vprintf+0x3ef>
  1009fc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a03:	8b 00                	mov    (%rax),%eax
  100a05:	83 f8 2f             	cmp    $0x2f,%eax
  100a08:	77 30                	ja     100a3a <printer_vprintf+0x3d1>
  100a0a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a11:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100a15:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a1c:	8b 00                	mov    (%rax),%eax
  100a1e:	89 c0                	mov    %eax,%eax
  100a20:	48 01 d0             	add    %rdx,%rax
  100a23:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a2a:	8b 12                	mov    (%rdx),%edx
  100a2c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100a2f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a36:	89 0a                	mov    %ecx,(%rdx)
  100a38:	eb 1a                	jmp    100a54 <printer_vprintf+0x3eb>
  100a3a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a41:	48 8b 40 08          	mov    0x8(%rax),%rax
  100a45:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100a49:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100a50:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100a54:	8b 00                	mov    (%rax),%eax
  100a56:	48 98                	cltq
  100a58:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  100a5c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100a60:	48 c1 f8 38          	sar    $0x38,%rax
  100a64:	25 80 00 00 00       	and    $0x80,%eax
  100a69:	89 45 a4             	mov    %eax,-0x5c(%rbp)
            num = negative ? -x : x;
  100a6c:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  100a70:	74 09                	je     100a7b <printer_vprintf+0x412>
  100a72:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100a76:	48 f7 d8             	neg    %rax
  100a79:	eb 04                	jmp    100a7f <printer_vprintf+0x416>
  100a7b:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  100a7f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  100a83:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  100a86:	83 c8 60             	or     $0x60,%eax
  100a89:	09 45 ec             	or     %eax,-0x14(%rbp)
            break;
  100a8c:	e9 cf 02 00 00       	jmp    100d60 <printer_vprintf+0x6f7>
        }
        case 'u':
        format_unsigned:
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100a91:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  100a95:	74 5d                	je     100af4 <printer_vprintf+0x48b>
  100a97:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100a9e:	8b 00                	mov    (%rax),%eax
  100aa0:	83 f8 2f             	cmp    $0x2f,%eax
  100aa3:	77 30                	ja     100ad5 <printer_vprintf+0x46c>
  100aa5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100aac:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100ab0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ab7:	8b 00                	mov    (%rax),%eax
  100ab9:	89 c0                	mov    %eax,%eax
  100abb:	48 01 d0             	add    %rdx,%rax
  100abe:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100ac5:	8b 12                	mov    (%rdx),%edx
  100ac7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100aca:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100ad1:	89 0a                	mov    %ecx,(%rdx)
  100ad3:	eb 1a                	jmp    100aef <printer_vprintf+0x486>
  100ad5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100adc:	48 8b 40 08          	mov    0x8(%rax),%rax
  100ae0:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100ae4:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100aeb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100aef:	48 8b 00             	mov    (%rax),%rax
  100af2:	eb 5c                	jmp    100b50 <printer_vprintf+0x4e7>
  100af4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100afb:	8b 00                	mov    (%rax),%eax
  100afd:	83 f8 2f             	cmp    $0x2f,%eax
  100b00:	77 30                	ja     100b32 <printer_vprintf+0x4c9>
  100b02:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b09:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100b0d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b14:	8b 00                	mov    (%rax),%eax
  100b16:	89 c0                	mov    %eax,%eax
  100b18:	48 01 d0             	add    %rdx,%rax
  100b1b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b22:	8b 12                	mov    (%rdx),%edx
  100b24:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100b27:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b2e:	89 0a                	mov    %ecx,(%rdx)
  100b30:	eb 1a                	jmp    100b4c <printer_vprintf+0x4e3>
  100b32:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b39:	48 8b 40 08          	mov    0x8(%rax),%rax
  100b3d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100b41:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100b48:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100b4c:	8b 00                	mov    (%rax),%eax
  100b4e:	89 c0                	mov    %eax,%eax
  100b50:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC;
  100b54:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
            break;
  100b58:	e9 03 02 00 00       	jmp    100d60 <printer_vprintf+0x6f7>
        case 'x':
            base = -16;
  100b5d:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            goto format_unsigned;
  100b64:	e9 28 ff ff ff       	jmp    100a91 <printer_vprintf+0x428>
        case 'X':
            base = 16;
  100b69:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%rbp)
            goto format_unsigned;
  100b70:	e9 1c ff ff ff       	jmp    100a91 <printer_vprintf+0x428>
        case 'p':
            num = (uintptr_t) va_arg(val, void*);
  100b75:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b7c:	8b 00                	mov    (%rax),%eax
  100b7e:	83 f8 2f             	cmp    $0x2f,%eax
  100b81:	77 30                	ja     100bb3 <printer_vprintf+0x54a>
  100b83:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b8a:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100b8e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100b95:	8b 00                	mov    (%rax),%eax
  100b97:	89 c0                	mov    %eax,%eax
  100b99:	48 01 d0             	add    %rdx,%rax
  100b9c:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100ba3:	8b 12                	mov    (%rdx),%edx
  100ba5:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100ba8:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100baf:	89 0a                	mov    %ecx,(%rdx)
  100bb1:	eb 1a                	jmp    100bcd <printer_vprintf+0x564>
  100bb3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100bba:	48 8b 40 08          	mov    0x8(%rax),%rax
  100bbe:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100bc2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100bc9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100bcd:	48 8b 00             	mov    (%rax),%rax
  100bd0:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            base = -16;
  100bd4:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  100bdb:	81 4d ec 21 01 00 00 	orl    $0x121,-0x14(%rbp)
            break;
  100be2:	e9 79 01 00 00       	jmp    100d60 <printer_vprintf+0x6f7>
        case 's':
            data = va_arg(val, char*);
  100be7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100bee:	8b 00                	mov    (%rax),%eax
  100bf0:	83 f8 2f             	cmp    $0x2f,%eax
  100bf3:	77 30                	ja     100c25 <printer_vprintf+0x5bc>
  100bf5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100bfc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100c00:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c07:	8b 00                	mov    (%rax),%eax
  100c09:	89 c0                	mov    %eax,%eax
  100c0b:	48 01 d0             	add    %rdx,%rax
  100c0e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c15:	8b 12                	mov    (%rdx),%edx
  100c17:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100c1a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c21:	89 0a                	mov    %ecx,(%rdx)
  100c23:	eb 1a                	jmp    100c3f <printer_vprintf+0x5d6>
  100c25:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c2c:	48 8b 40 08          	mov    0x8(%rax),%rax
  100c30:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100c34:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c3b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100c3f:	48 8b 00             	mov    (%rax),%rax
  100c42:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            break;
  100c46:	e9 15 01 00 00       	jmp    100d60 <printer_vprintf+0x6f7>
        case 'C':
            color = va_arg(val, int);
  100c4b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c52:	8b 00                	mov    (%rax),%eax
  100c54:	83 f8 2f             	cmp    $0x2f,%eax
  100c57:	77 30                	ja     100c89 <printer_vprintf+0x620>
  100c59:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c60:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100c64:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c6b:	8b 00                	mov    (%rax),%eax
  100c6d:	89 c0                	mov    %eax,%eax
  100c6f:	48 01 d0             	add    %rdx,%rax
  100c72:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c79:	8b 12                	mov    (%rdx),%edx
  100c7b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100c7e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c85:	89 0a                	mov    %ecx,(%rdx)
  100c87:	eb 1a                	jmp    100ca3 <printer_vprintf+0x63a>
  100c89:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100c90:	48 8b 40 08          	mov    0x8(%rax),%rax
  100c94:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100c98:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100c9f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100ca3:	8b 00                	mov    (%rax),%eax
  100ca5:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
            goto done;
  100cab:	e9 67 03 00 00       	jmp    101017 <printer_vprintf+0x9ae>
        case 'c':
            data = numbuf;
  100cb0:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100cb4:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = va_arg(val, int);
  100cb8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100cbf:	8b 00                	mov    (%rax),%eax
  100cc1:	83 f8 2f             	cmp    $0x2f,%eax
  100cc4:	77 30                	ja     100cf6 <printer_vprintf+0x68d>
  100cc6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100ccd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  100cd1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100cd8:	8b 00                	mov    (%rax),%eax
  100cda:	89 c0                	mov    %eax,%eax
  100cdc:	48 01 d0             	add    %rdx,%rax
  100cdf:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100ce6:	8b 12                	mov    (%rdx),%edx
  100ce8:	8d 4a 08             	lea    0x8(%rdx),%ecx
  100ceb:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100cf2:	89 0a                	mov    %ecx,(%rdx)
  100cf4:	eb 1a                	jmp    100d10 <printer_vprintf+0x6a7>
  100cf6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  100cfd:	48 8b 40 08          	mov    0x8(%rax),%rax
  100d01:	48 8d 48 08          	lea    0x8(%rax),%rcx
  100d05:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  100d0c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  100d10:	8b 00                	mov    (%rax),%eax
  100d12:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  100d15:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            break;
  100d19:	eb 45                	jmp    100d60 <printer_vprintf+0x6f7>
        default:
            data = numbuf;
  100d1b:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100d1f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = (*format ? *format : '%');
  100d23:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100d2a:	0f b6 00             	movzbl (%rax),%eax
  100d2d:	84 c0                	test   %al,%al
  100d2f:	74 0c                	je     100d3d <printer_vprintf+0x6d4>
  100d31:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100d38:	0f b6 00             	movzbl (%rax),%eax
  100d3b:	eb 05                	jmp    100d42 <printer_vprintf+0x6d9>
  100d3d:	b8 25 00 00 00       	mov    $0x25,%eax
  100d42:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  100d45:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            if (!*format) {
  100d49:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  100d50:	0f b6 00             	movzbl (%rax),%eax
  100d53:	84 c0                	test   %al,%al
  100d55:	75 08                	jne    100d5f <printer_vprintf+0x6f6>
                format--;
  100d57:	48 83 ad 68 ff ff ff 	subq   $0x1,-0x98(%rbp)
  100d5e:	01 
            }
            break;
  100d5f:	90                   	nop
        }

        if (flags & FLAG_NUMERIC) {
  100d60:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100d63:	83 e0 20             	and    $0x20,%eax
  100d66:	85 c0                	test   %eax,%eax
  100d68:	74 1e                	je     100d88 <printer_vprintf+0x71f>
            data = fill_numbuf(numbuf + NUMBUFSIZ, num, base);
  100d6a:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  100d6e:	48 83 c0 18          	add    $0x18,%rax
  100d72:	8b 55 e0             	mov    -0x20(%rbp),%edx
  100d75:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  100d79:	48 89 ce             	mov    %rcx,%rsi
  100d7c:	48 89 c7             	mov    %rax,%rdi
  100d7f:	e8 63 f8 ff ff       	call   1005e7 <fill_numbuf>
  100d84:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        }

        const char* prefix = "";
  100d88:	48 c7 45 c0 06 14 10 	movq   $0x101406,-0x40(%rbp)
  100d8f:	00 
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  100d90:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100d93:	83 e0 20             	and    $0x20,%eax
  100d96:	85 c0                	test   %eax,%eax
  100d98:	74 48                	je     100de2 <printer_vprintf+0x779>
  100d9a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100d9d:	83 e0 40             	and    $0x40,%eax
  100da0:	85 c0                	test   %eax,%eax
  100da2:	74 3e                	je     100de2 <printer_vprintf+0x779>
            if (flags & FLAG_NEGATIVE) {
  100da4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100da7:	25 80 00 00 00       	and    $0x80,%eax
  100dac:	85 c0                	test   %eax,%eax
  100dae:	74 0a                	je     100dba <printer_vprintf+0x751>
                prefix = "-";
  100db0:	48 c7 45 c0 07 14 10 	movq   $0x101407,-0x40(%rbp)
  100db7:	00 
            if (flags & FLAG_NEGATIVE) {
  100db8:	eb 73                	jmp    100e2d <printer_vprintf+0x7c4>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100dba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100dbd:	83 e0 10             	and    $0x10,%eax
  100dc0:	85 c0                	test   %eax,%eax
  100dc2:	74 0a                	je     100dce <printer_vprintf+0x765>
                prefix = "+";
  100dc4:	48 c7 45 c0 09 14 10 	movq   $0x101409,-0x40(%rbp)
  100dcb:	00 
            if (flags & FLAG_NEGATIVE) {
  100dcc:	eb 5f                	jmp    100e2d <printer_vprintf+0x7c4>
            } else if (flags & FLAG_SPACEPOSITIVE) {
  100dce:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100dd1:	83 e0 08             	and    $0x8,%eax
  100dd4:	85 c0                	test   %eax,%eax
  100dd6:	74 55                	je     100e2d <printer_vprintf+0x7c4>
                prefix = " ";
  100dd8:	48 c7 45 c0 0b 14 10 	movq   $0x10140b,-0x40(%rbp)
  100ddf:	00 
            if (flags & FLAG_NEGATIVE) {
  100de0:	eb 4b                	jmp    100e2d <printer_vprintf+0x7c4>
            }
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100de2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100de5:	83 e0 20             	and    $0x20,%eax
  100de8:	85 c0                	test   %eax,%eax
  100dea:	74 42                	je     100e2e <printer_vprintf+0x7c5>
  100dec:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100def:	83 e0 01             	and    $0x1,%eax
  100df2:	85 c0                	test   %eax,%eax
  100df4:	74 38                	je     100e2e <printer_vprintf+0x7c5>
                   && (base == 16 || base == -16)
  100df6:	83 7d e0 10          	cmpl   $0x10,-0x20(%rbp)
  100dfa:	74 06                	je     100e02 <printer_vprintf+0x799>
  100dfc:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  100e00:	75 2c                	jne    100e2e <printer_vprintf+0x7c5>
                   && (num || (flags & FLAG_ALT2))) {
  100e02:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  100e07:	75 0c                	jne    100e15 <printer_vprintf+0x7ac>
  100e09:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100e0c:	25 00 01 00 00       	and    $0x100,%eax
  100e11:	85 c0                	test   %eax,%eax
  100e13:	74 19                	je     100e2e <printer_vprintf+0x7c5>
            prefix = (base == -16 ? "0x" : "0X");
  100e15:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  100e19:	75 07                	jne    100e22 <printer_vprintf+0x7b9>
  100e1b:	b8 0d 14 10 00       	mov    $0x10140d,%eax
  100e20:	eb 05                	jmp    100e27 <printer_vprintf+0x7be>
  100e22:	b8 10 14 10 00       	mov    $0x101410,%eax
  100e27:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100e2b:	eb 01                	jmp    100e2e <printer_vprintf+0x7c5>
            if (flags & FLAG_NEGATIVE) {
  100e2d:	90                   	nop
        }

        int len;
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  100e2e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  100e32:	78 24                	js     100e58 <printer_vprintf+0x7ef>
  100e34:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100e37:	83 e0 20             	and    $0x20,%eax
  100e3a:	85 c0                	test   %eax,%eax
  100e3c:	75 1a                	jne    100e58 <printer_vprintf+0x7ef>
            len = strnlen(data, precision);
  100e3e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100e41:	48 63 d0             	movslq %eax,%rdx
  100e44:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100e48:	48 89 d6             	mov    %rdx,%rsi
  100e4b:	48 89 c7             	mov    %rax,%rdi
  100e4e:	e8 ea f5 ff ff       	call   10043d <strnlen>
  100e53:	89 45 bc             	mov    %eax,-0x44(%rbp)
  100e56:	eb 0f                	jmp    100e67 <printer_vprintf+0x7fe>
        } else {
            len = strlen(data);
  100e58:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100e5c:	48 89 c7             	mov    %rax,%rdi
  100e5f:	e8 a8 f5 ff ff       	call   10040c <strlen>
  100e64:	89 45 bc             	mov    %eax,-0x44(%rbp)
        }
        int zeros;
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  100e67:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100e6a:	83 e0 20             	and    $0x20,%eax
  100e6d:	85 c0                	test   %eax,%eax
  100e6f:	74 20                	je     100e91 <printer_vprintf+0x828>
  100e71:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  100e75:	78 1a                	js     100e91 <printer_vprintf+0x828>
            zeros = precision > len ? precision - len : 0;
  100e77:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100e7a:	3b 45 bc             	cmp    -0x44(%rbp),%eax
  100e7d:	7e 08                	jle    100e87 <printer_vprintf+0x81e>
  100e7f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  100e82:	2b 45 bc             	sub    -0x44(%rbp),%eax
  100e85:	eb 05                	jmp    100e8c <printer_vprintf+0x823>
  100e87:	b8 00 00 00 00       	mov    $0x0,%eax
  100e8c:	89 45 b8             	mov    %eax,-0x48(%rbp)
  100e8f:	eb 5c                	jmp    100eed <printer_vprintf+0x884>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100e91:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100e94:	83 e0 20             	and    $0x20,%eax
  100e97:	85 c0                	test   %eax,%eax
  100e99:	74 4b                	je     100ee6 <printer_vprintf+0x87d>
  100e9b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100e9e:	83 e0 02             	and    $0x2,%eax
  100ea1:	85 c0                	test   %eax,%eax
  100ea3:	74 41                	je     100ee6 <printer_vprintf+0x87d>
                   && !(flags & FLAG_LEFTJUSTIFY)
  100ea5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100ea8:	83 e0 04             	and    $0x4,%eax
  100eab:	85 c0                	test   %eax,%eax
  100ead:	75 37                	jne    100ee6 <printer_vprintf+0x87d>
                   && len + (int) strlen(prefix) < width) {
  100eaf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100eb3:	48 89 c7             	mov    %rax,%rdi
  100eb6:	e8 51 f5 ff ff       	call   10040c <strlen>
  100ebb:	89 c2                	mov    %eax,%edx
  100ebd:	8b 45 bc             	mov    -0x44(%rbp),%eax
  100ec0:	01 d0                	add    %edx,%eax
  100ec2:	39 45 e8             	cmp    %eax,-0x18(%rbp)
  100ec5:	7e 1f                	jle    100ee6 <printer_vprintf+0x87d>
            zeros = width - len - strlen(prefix);
  100ec7:	8b 45 e8             	mov    -0x18(%rbp),%eax
  100eca:	2b 45 bc             	sub    -0x44(%rbp),%eax
  100ecd:	89 c3                	mov    %eax,%ebx
  100ecf:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100ed3:	48 89 c7             	mov    %rax,%rdi
  100ed6:	e8 31 f5 ff ff       	call   10040c <strlen>
  100edb:	89 c2                	mov    %eax,%edx
  100edd:	89 d8                	mov    %ebx,%eax
  100edf:	29 d0                	sub    %edx,%eax
  100ee1:	89 45 b8             	mov    %eax,-0x48(%rbp)
  100ee4:	eb 07                	jmp    100eed <printer_vprintf+0x884>
        } else {
            zeros = 0;
  100ee6:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
        }
        width -= len + zeros + strlen(prefix);
  100eed:	8b 55 bc             	mov    -0x44(%rbp),%edx
  100ef0:	8b 45 b8             	mov    -0x48(%rbp),%eax
  100ef3:	01 d0                	add    %edx,%eax
  100ef5:	48 63 d8             	movslq %eax,%rbx
  100ef8:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100efc:	48 89 c7             	mov    %rax,%rdi
  100eff:	e8 08 f5 ff ff       	call   10040c <strlen>
  100f04:	48 8d 14 03          	lea    (%rbx,%rax,1),%rdx
  100f08:	8b 45 e8             	mov    -0x18(%rbp),%eax
  100f0b:	29 d0                	sub    %edx,%eax
  100f0d:	89 45 e8             	mov    %eax,-0x18(%rbp)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100f10:	eb 25                	jmp    100f37 <printer_vprintf+0x8ce>
            p->putc(p, ' ', color);
  100f12:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f19:	48 8b 08             	mov    (%rax),%rcx
  100f1c:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100f22:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f29:	be 20 00 00 00       	mov    $0x20,%esi
  100f2e:	48 89 c7             	mov    %rax,%rdi
  100f31:	ff d1                	call   *%rcx
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100f33:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  100f37:	8b 45 ec             	mov    -0x14(%rbp),%eax
  100f3a:	83 e0 04             	and    $0x4,%eax
  100f3d:	85 c0                	test   %eax,%eax
  100f3f:	75 36                	jne    100f77 <printer_vprintf+0x90e>
  100f41:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  100f45:	7f cb                	jg     100f12 <printer_vprintf+0x8a9>
        }
        for (; *prefix; ++prefix) {
  100f47:	eb 2e                	jmp    100f77 <printer_vprintf+0x90e>
            p->putc(p, *prefix, color);
  100f49:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f50:	4c 8b 00             	mov    (%rax),%r8
  100f53:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100f57:	0f b6 00             	movzbl (%rax),%eax
  100f5a:	0f b6 c8             	movzbl %al,%ecx
  100f5d:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100f63:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f6a:	89 ce                	mov    %ecx,%esi
  100f6c:	48 89 c7             	mov    %rax,%rdi
  100f6f:	41 ff d0             	call   *%r8
        for (; *prefix; ++prefix) {
  100f72:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  100f77:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  100f7b:	0f b6 00             	movzbl (%rax),%eax
  100f7e:	84 c0                	test   %al,%al
  100f80:	75 c7                	jne    100f49 <printer_vprintf+0x8e0>
        }
        for (; zeros > 0; --zeros) {
  100f82:	eb 25                	jmp    100fa9 <printer_vprintf+0x940>
            p->putc(p, '0', color);
  100f84:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f8b:	48 8b 08             	mov    (%rax),%rcx
  100f8e:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100f94:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100f9b:	be 30 00 00 00       	mov    $0x30,%esi
  100fa0:	48 89 c7             	mov    %rax,%rdi
  100fa3:	ff d1                	call   *%rcx
        for (; zeros > 0; --zeros) {
  100fa5:	83 6d b8 01          	subl   $0x1,-0x48(%rbp)
  100fa9:	83 7d b8 00          	cmpl   $0x0,-0x48(%rbp)
  100fad:	7f d5                	jg     100f84 <printer_vprintf+0x91b>
        }
        for (; len > 0; ++data, --len) {
  100faf:	eb 32                	jmp    100fe3 <printer_vprintf+0x97a>
            p->putc(p, *data, color);
  100fb1:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100fb8:	4c 8b 00             	mov    (%rax),%r8
  100fbb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  100fbf:	0f b6 00             	movzbl (%rax),%eax
  100fc2:	0f b6 c8             	movzbl %al,%ecx
  100fc5:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100fcb:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100fd2:	89 ce                	mov    %ecx,%esi
  100fd4:	48 89 c7             	mov    %rax,%rdi
  100fd7:	41 ff d0             	call   *%r8
        for (; len > 0; ++data, --len) {
  100fda:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  100fdf:	83 6d bc 01          	subl   $0x1,-0x44(%rbp)
  100fe3:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  100fe7:	7f c8                	jg     100fb1 <printer_vprintf+0x948>
        }
        for (; width > 0; --width) {
  100fe9:	eb 25                	jmp    101010 <printer_vprintf+0x9a7>
            p->putc(p, ' ', color);
  100feb:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  100ff2:	48 8b 08             	mov    (%rax),%rcx
  100ff5:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  100ffb:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  101002:	be 20 00 00 00       	mov    $0x20,%esi
  101007:	48 89 c7             	mov    %rax,%rdi
  10100a:	ff d1                	call   *%rcx
        for (; width > 0; --width) {
  10100c:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  101010:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  101014:	7f d5                	jg     100feb <printer_vprintf+0x982>
        }
    done: ;
  101016:	90                   	nop
    for (; *format; ++format) {
  101017:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  10101e:	01 
  10101f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  101026:	0f b6 00             	movzbl (%rax),%eax
  101029:	84 c0                	test   %al,%al
  10102b:	0f 85 64 f6 ff ff    	jne    100695 <printer_vprintf+0x2c>
    }
}
  101031:	90                   	nop
  101032:	90                   	nop
  101033:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  101037:	c9                   	leave
  101038:	c3                   	ret

0000000000101039 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  101039:	55                   	push   %rbp
  10103a:	48 89 e5             	mov    %rsp,%rbp
  10103d:	48 83 ec 20          	sub    $0x20,%rsp
  101041:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  101045:	89 f0                	mov    %esi,%eax
  101047:	89 55 e0             	mov    %edx,-0x20(%rbp)
  10104a:	88 45 e4             	mov    %al,-0x1c(%rbp)
    console_printer* cp = (console_printer*) p;
  10104d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  101051:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  101055:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  101059:	48 8b 40 08          	mov    0x8(%rax),%rax
  10105d:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
  101062:	48 39 d0             	cmp    %rdx,%rax
  101065:	72 0c                	jb     101073 <console_putc+0x3a>
        cp->cursor = console;
  101067:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10106b:	48 c7 40 08 00 80 0b 	movq   $0xb8000,0x8(%rax)
  101072:	00 
    }
    if (c == '\n') {
  101073:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%rbp)
  101077:	75 78                	jne    1010f1 <console_putc+0xb8>
        int pos = (cp->cursor - console) % 80;
  101079:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10107d:	48 8b 40 08          	mov    0x8(%rax),%rax
  101081:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  101087:	48 d1 f8             	sar    %rax
  10108a:	48 89 c1             	mov    %rax,%rcx
  10108d:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  101094:	66 66 66 
  101097:	48 89 c8             	mov    %rcx,%rax
  10109a:	48 f7 ea             	imul   %rdx
  10109d:	48 c1 fa 05          	sar    $0x5,%rdx
  1010a1:	48 89 c8             	mov    %rcx,%rax
  1010a4:	48 c1 f8 3f          	sar    $0x3f,%rax
  1010a8:	48 29 c2             	sub    %rax,%rdx
  1010ab:	48 89 d0             	mov    %rdx,%rax
  1010ae:	48 c1 e0 02          	shl    $0x2,%rax
  1010b2:	48 01 d0             	add    %rdx,%rax
  1010b5:	48 c1 e0 04          	shl    $0x4,%rax
  1010b9:	48 29 c1             	sub    %rax,%rcx
  1010bc:	48 89 ca             	mov    %rcx,%rdx
  1010bf:	89 55 fc             	mov    %edx,-0x4(%rbp)
        for (; pos != 80; pos++) {
  1010c2:	eb 25                	jmp    1010e9 <console_putc+0xb0>
            *cp->cursor++ = ' ' | color;
  1010c4:	8b 45 e0             	mov    -0x20(%rbp),%eax
  1010c7:	83 c8 20             	or     $0x20,%eax
  1010ca:	89 c6                	mov    %eax,%esi
  1010cc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1010d0:	48 8b 40 08          	mov    0x8(%rax),%rax
  1010d4:	48 8d 48 02          	lea    0x2(%rax),%rcx
  1010d8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  1010dc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1010e0:	89 f2                	mov    %esi,%edx
  1010e2:	66 89 10             	mov    %dx,(%rax)
        for (; pos != 80; pos++) {
  1010e5:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  1010e9:	83 7d fc 50          	cmpl   $0x50,-0x4(%rbp)
  1010ed:	75 d5                	jne    1010c4 <console_putc+0x8b>
        }
    } else {
        *cp->cursor++ = c | color;
    }
}
  1010ef:	eb 24                	jmp    101115 <console_putc+0xdc>
        *cp->cursor++ = c | color;
  1010f1:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
  1010f5:	8b 55 e0             	mov    -0x20(%rbp),%edx
  1010f8:	09 d0                	or     %edx,%eax
  1010fa:	89 c6                	mov    %eax,%esi
  1010fc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  101100:	48 8b 40 08          	mov    0x8(%rax),%rax
  101104:	48 8d 48 02          	lea    0x2(%rax),%rcx
  101108:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  10110c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  101110:	89 f2                	mov    %esi,%edx
  101112:	66 89 10             	mov    %dx,(%rax)
}
  101115:	90                   	nop
  101116:	c9                   	leave
  101117:	c3                   	ret

0000000000101118 <console_vprintf>:

int console_vprintf(int cpos, int color, const char* format, va_list val) {
  101118:	55                   	push   %rbp
  101119:	48 89 e5             	mov    %rsp,%rbp
  10111c:	48 83 ec 30          	sub    $0x30,%rsp
  101120:	89 7d ec             	mov    %edi,-0x14(%rbp)
  101123:	89 75 e8             	mov    %esi,-0x18(%rbp)
  101126:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  10112a:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
    struct console_printer cp;
    cp.p.putc = console_putc;
  10112e:	48 c7 45 f0 39 10 10 	movq   $0x101039,-0x10(%rbp)
  101135:	00 
    if (cpos < 0 || cpos >= CONSOLE_ROWS * CONSOLE_COLUMNS) {
  101136:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  10113a:	78 09                	js     101145 <console_vprintf+0x2d>
  10113c:	81 7d ec cf 07 00 00 	cmpl   $0x7cf,-0x14(%rbp)
  101143:	7e 07                	jle    10114c <console_vprintf+0x34>
        cpos = 0;
  101145:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
    cp.cursor = console + cpos;
  10114c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  10114f:	48 98                	cltq
  101151:	48 01 c0             	add    %rax,%rax
  101154:	48 05 00 80 0b 00    	add    $0xb8000,%rax
  10115a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  10115e:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  101162:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  101166:	8b 75 e8             	mov    -0x18(%rbp),%esi
  101169:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  10116d:	48 89 c7             	mov    %rax,%rdi
  101170:	e8 f4 f4 ff ff       	call   100669 <printer_vprintf>
    return cp.cursor - console;
  101175:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  101179:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  10117f:	48 d1 f8             	sar    %rax
}
  101182:	c9                   	leave
  101183:	c3                   	ret

0000000000101184 <console_printf>:

int console_printf(int cpos, int color, const char* format, ...) {
  101184:	55                   	push   %rbp
  101185:	48 89 e5             	mov    %rsp,%rbp
  101188:	48 83 ec 60          	sub    $0x60,%rsp
  10118c:	89 7d ac             	mov    %edi,-0x54(%rbp)
  10118f:	89 75 a8             	mov    %esi,-0x58(%rbp)
  101192:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  101196:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  10119a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  10119e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  1011a2:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1011a9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1011ad:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1011b1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1011b5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1011b9:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1011bd:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  1011c1:	8b 75 a8             	mov    -0x58(%rbp),%esi
  1011c4:	8b 45 ac             	mov    -0x54(%rbp),%eax
  1011c7:	89 c7                	mov    %eax,%edi
  1011c9:	e8 4a ff ff ff       	call   101118 <console_vprintf>
  1011ce:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
  1011d1:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
  1011d4:	c9                   	leave
  1011d5:	c3                   	ret

00000000001011d6 <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  1011d6:	55                   	push   %rbp
  1011d7:	48 89 e5             	mov    %rsp,%rbp
  1011da:	48 83 ec 20          	sub    $0x20,%rsp
  1011de:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1011e2:	89 f0                	mov    %esi,%eax
  1011e4:	89 55 e0             	mov    %edx,-0x20(%rbp)
  1011e7:	88 45 e4             	mov    %al,-0x1c(%rbp)
    string_printer* sp = (string_printer*) p;
  1011ea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1011ee:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (sp->s < sp->end) {
  1011f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1011f6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  1011fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1011fe:	48 8b 40 10          	mov    0x10(%rax),%rax
  101202:	48 39 c2             	cmp    %rax,%rdx
  101205:	73 1a                	jae    101221 <string_putc+0x4b>
        *sp->s++ = c;
  101207:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  10120b:	48 8b 40 08          	mov    0x8(%rax),%rax
  10120f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  101213:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  101217:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  10121b:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
  10121f:	88 10                	mov    %dl,(%rax)
    }
    (void) color;
}
  101221:	90                   	nop
  101222:	c9                   	leave
  101223:	c3                   	ret

0000000000101224 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  101224:	55                   	push   %rbp
  101225:	48 89 e5             	mov    %rsp,%rbp
  101228:	48 83 ec 40          	sub    $0x40,%rsp
  10122c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  101230:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  101234:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  101238:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    string_printer sp;
    sp.p.putc = string_putc;
  10123c:	48 c7 45 e8 d6 11 10 	movq   $0x1011d6,-0x18(%rbp)
  101243:	00 
    sp.s = s;
  101244:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  101248:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (size) {
  10124c:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  101251:	74 33                	je     101286 <vsnprintf+0x62>
        sp.end = s + size - 1;
  101253:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  101257:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  10125b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  10125f:	48 01 d0             	add    %rdx,%rax
  101262:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  101266:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  10126a:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  10126e:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  101272:	be 00 00 00 00       	mov    $0x0,%esi
  101277:	48 89 c7             	mov    %rax,%rdi
  10127a:	e8 ea f3 ff ff       	call   100669 <printer_vprintf>
        *sp.s = 0;
  10127f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  101283:	c6 00 00             	movb   $0x0,(%rax)
    }
    return sp.s - s;
  101286:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  10128a:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
}
  10128e:	c9                   	leave
  10128f:	c3                   	ret

0000000000101290 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  101290:	55                   	push   %rbp
  101291:	48 89 e5             	mov    %rsp,%rbp
  101294:	48 83 ec 70          	sub    $0x70,%rsp
  101298:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  10129c:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  1012a0:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  1012a4:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1012a8:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1012ac:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  1012b0:	c7 45 b0 18 00 00 00 	movl   $0x18,-0x50(%rbp)
  1012b7:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1012bb:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  1012bf:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1012c3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    int n = vsnprintf(s, size, format, val);
  1012c7:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  1012cb:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  1012cf:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  1012d3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1012d7:	48 89 c7             	mov    %rax,%rdi
  1012da:	e8 45 ff ff ff       	call   101224 <vsnprintf>
  1012df:	89 45 cc             	mov    %eax,-0x34(%rbp)
    va_end(val);
    return n;
  1012e2:	8b 45 cc             	mov    -0x34(%rbp),%eax
}
  1012e5:	c9                   	leave
  1012e6:	c3                   	ret

00000000001012e7 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  1012e7:	55                   	push   %rbp
  1012e8:	48 89 e5             	mov    %rsp,%rbp
  1012eb:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1012ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  1012f6:	eb 13                	jmp    10130b <console_clear+0x24>
        console[i] = ' ' | 0x0700;
  1012f8:	8b 45 fc             	mov    -0x4(%rbp),%eax
  1012fb:	48 98                	cltq
  1012fd:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%rax,%rax,1)
  101304:	00 20 07 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  101307:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  10130b:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
  101312:	7e e4                	jle    1012f8 <console_clear+0x11>
    }
    cursorpos = 0;
  101314:	c7 05 de 7c fb ff 00 	movl   $0x0,-0x48322(%rip)        # b8ffc <cursorpos>
  10131b:	00 00 00 
}
  10131e:	90                   	nop
  10131f:	c9                   	leave
  101320:	c3                   	ret
