
obj/p-allocator.full:     file format elf64-x86-64


Disassembly of section .text:

00000000001c0000 <process_main>:
uint8_t *heap_bottom;
uint8_t *stack_bottom;



void process_main(void) {
  1c0000:	55                   	push   %rbp
  1c0001:	48 89 e5             	mov    %rsp,%rbp
  1c0004:	53                   	push   %rbx
  1c0005:	48 83 ec 08          	sub    $0x8,%rsp

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  1c0009:	cd 31                	int    $0x31
  1c000b:	89 c3                	mov    %eax,%ebx
    pid_t p = getpid();
    srand(p);
  1c000d:	89 c7                	mov    %eax,%edi
  1c000f:	e8 06 05 00 00       	call   1c051a <srand>
    heap_bottom = heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  1c0014:	b8 27 30 1c 00       	mov    $0x1c3027,%eax
  1c0019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  1c001f:	48 89 05 ea 1f 00 00 	mov    %rax,0x1fea(%rip)        # 1c2010 <heap_top>
  1c0026:	48 89 05 db 1f 00 00 	mov    %rax,0x1fdb(%rip)        # 1c2008 <heap_bottom>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  1c002d:	48 89 e2             	mov    %rsp,%rdx
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  1c0030:	48 83 ea 01          	sub    $0x1,%rdx
  1c0034:	48 81 e2 00 f0 ff ff 	and    $0xfffffffffffff000,%rdx
  1c003b:	48 89 15 be 1f 00 00 	mov    %rdx,0x1fbe(%rip)        # 1c2000 <stack_bottom>

    while(heap_top + PAGESIZE < stack_bottom) {
  1c0042:	48 05 00 10 00 00    	add    $0x1000,%rax
  1c0048:	48 39 d0             	cmp    %rdx,%rax
  1c004b:	73 3a                	jae    1c0087 <process_main+0x87>
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  1c004d:	bf 00 10 00 00       	mov    $0x1000,%edi
  1c0052:	cd 3a                	int    $0x3a
  1c0054:	48 89 05 bd 1f 00 00 	mov    %rax,0x1fbd(%rip)        # 1c2018 <result.0>
        void * ret = sbrk(PAGESIZE);
        if(ret == (void *) -1) break;
  1c005b:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  1c005f:	74 26                	je     1c0087 <process_main+0x87>

        *heap_top = p;      /* check we have write access to new page */
  1c0061:	48 8b 15 a8 1f 00 00 	mov    0x1fa8(%rip),%rdx        # 1c2010 <heap_top>
  1c0068:	88 1a                	mov    %bl,(%rdx)
        heap_top = (uint8_t *)ret + PAGESIZE;
  1c006a:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
  1c0071:	48 89 15 98 1f 00 00 	mov    %rdx,0x1f98(%rip)        # 1c2010 <heap_top>
    while(heap_top + PAGESIZE < stack_bottom) {
  1c0078:	48 05 00 20 00 00    	add    $0x2000,%rax
  1c007e:	48 3b 05 7b 1f 00 00 	cmp    0x1f7b(%rip),%rax        # 1c2000 <stack_bottom>
  1c0085:	72 cb                	jb     1c0052 <process_main+0x52>
    }
    TEST_PASS();
  1c0087:	bf 80 12 1c 00       	mov    $0x1c1280,%edi
  1c008c:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0091:	e8 90 00 00 00       	call   1c0126 <kernel_panic>

00000000001c0096 <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  1c0096:	55                   	push   %rbp
  1c0097:	48 89 e5             	mov    %rsp,%rbp
  1c009a:	48 83 ec 50          	sub    $0x50,%rsp
  1c009e:	49 89 f2             	mov    %rsi,%r10
  1c00a1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  1c00a5:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c00a9:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c00ad:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  1c00b1:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  1c00b6:	85 ff                	test   %edi,%edi
  1c00b8:	78 2e                	js     1c00e8 <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  1c00ba:	48 63 ff             	movslq %edi,%rdi
  1c00bd:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  1c00c4:	cc cc cc 
  1c00c7:	48 89 f8             	mov    %rdi,%rax
  1c00ca:	48 f7 e2             	mul    %rdx
  1c00cd:	48 89 d0             	mov    %rdx,%rax
  1c00d0:	48 c1 e8 02          	shr    $0x2,%rax
  1c00d4:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  1c00d8:	48 01 c2             	add    %rax,%rdx
  1c00db:	48 29 d7             	sub    %rdx,%rdi
  1c00de:	0f b6 b7 d5 12 1c 00 	movzbl 0x1c12d5(%rdi),%esi
  1c00e5:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  1c00e8:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  1c00ef:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c00f3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c00f7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c00fb:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  1c00ff:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1c0103:	4c 89 d2             	mov    %r10,%rdx
  1c0106:	8b 3d f0 8e ef ff    	mov    -0x107110(%rip),%edi        # b8ffc <cursorpos>
  1c010c:	e8 5b 0f 00 00       	call   1c106c <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  1c0111:	3d 30 07 00 00       	cmp    $0x730,%eax
  1c0116:	ba 00 00 00 00       	mov    $0x0,%edx
  1c011b:	0f 4d c2             	cmovge %edx,%eax
  1c011e:	89 05 d8 8e ef ff    	mov    %eax,-0x107128(%rip)        # b8ffc <cursorpos>
    }
}
  1c0124:	c9                   	leave
  1c0125:	c3                   	ret

00000000001c0126 <kernel_panic>:


// kernel_panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void kernel_panic(const char* format, ...) {
  1c0126:	55                   	push   %rbp
  1c0127:	48 89 e5             	mov    %rsp,%rbp
  1c012a:	53                   	push   %rbx
  1c012b:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  1c0132:	48 89 fb             	mov    %rdi,%rbx
  1c0135:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  1c0139:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  1c013d:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  1c0141:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  1c0145:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  1c0149:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  1c0150:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c0154:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  1c0158:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  1c015c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  1c0160:	ba 07 00 00 00       	mov    $0x7,%edx
  1c0165:	be a0 12 1c 00       	mov    $0x1c12a0,%esi
  1c016a:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  1c0171:	e8 ad 00 00 00       	call   1c0223 <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  1c0176:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  1c017a:	48 89 da             	mov    %rbx,%rdx
  1c017d:	be 99 00 00 00       	mov    $0x99,%esi
  1c0182:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  1c0189:	e8 ea 0f 00 00       	call   1c1178 <vsnprintf>
  1c018e:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  1c0191:	85 d2                	test   %edx,%edx
  1c0193:	7e 0f                	jle    1c01a4 <kernel_panic+0x7e>
  1c0195:	83 c0 06             	add    $0x6,%eax
  1c0198:	48 98                	cltq
  1c019a:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  1c01a1:	0a 
  1c01a2:	75 2a                	jne    1c01ce <kernel_panic+0xa8>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  1c01a4:	48 8d 9d 08 ff ff ff 	lea    -0xf8(%rbp),%rbx
  1c01ab:	48 89 d9             	mov    %rbx,%rcx
  1c01ae:	ba aa 12 1c 00       	mov    $0x1c12aa,%edx
  1c01b3:	be 00 c0 00 00       	mov    $0xc000,%esi
  1c01b8:	bf 30 07 00 00       	mov    $0x730,%edi
  1c01bd:	b8 00 00 00 00       	mov    $0x0,%eax
  1c01c2:	e8 11 0f 00 00       	call   1c10d8 <console_printf>
    asm volatile ("int %0" : /* no result */
  1c01c7:	48 89 df             	mov    %rbx,%rdi
  1c01ca:	cd 30                	int    $0x30
 loop: goto loop;
  1c01cc:	eb fe                	jmp    1c01cc <kernel_panic+0xa6>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  1c01ce:	48 63 c2             	movslq %edx,%rax
  1c01d1:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  1c01d7:	0f 94 c2             	sete   %dl
  1c01da:	0f b6 d2             	movzbl %dl,%edx
  1c01dd:	48 29 d0             	sub    %rdx,%rax
  1c01e0:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  1c01e7:	ff 
  1c01e8:	be a8 12 1c 00       	mov    $0x1c12a8,%esi
  1c01ed:	e8 de 01 00 00       	call   1c03d0 <strcpy>
  1c01f2:	eb b0                	jmp    1c01a4 <kernel_panic+0x7e>

00000000001c01f4 <assert_fail>:
    panic(buf);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  1c01f4:	55                   	push   %rbp
  1c01f5:	48 89 e5             	mov    %rsp,%rbp
  1c01f8:	48 89 f9             	mov    %rdi,%rcx
  1c01fb:	41 89 f0             	mov    %esi,%r8d
  1c01fe:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  1c0201:	ba b0 12 1c 00       	mov    $0x1c12b0,%edx
  1c0206:	be 00 c0 00 00       	mov    $0xc000,%esi
  1c020b:	bf 30 07 00 00       	mov    $0x730,%edi
  1c0210:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0215:	e8 be 0e 00 00       	call   1c10d8 <console_printf>
    asm volatile ("int %0" : /* no result */
  1c021a:	bf 00 00 00 00       	mov    $0x0,%edi
  1c021f:	cd 30                	int    $0x30
 loop: goto loop;
  1c0221:	eb fe                	jmp    1c0221 <assert_fail+0x2d>

00000000001c0223 <memcpy>:


// memcpy, memmove, memset, strcmp, strlen, strnlen
//    We must provide our own implementations.

void* memcpy(void* dst, const void* src, size_t n) {
  1c0223:	55                   	push   %rbp
  1c0224:	48 89 e5             	mov    %rsp,%rbp
  1c0227:	48 83 ec 28          	sub    $0x28,%rsp
  1c022b:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c022f:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1c0233:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1c0237:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1c023b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1c023f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0243:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  1c0247:	eb 1c                	jmp    1c0265 <memcpy+0x42>
        *d = *s;
  1c0249:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c024d:	0f b6 10             	movzbl (%rax),%edx
  1c0250:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c0254:	88 10                	mov    %dl,(%rax)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1c0256:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  1c025b:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1c0260:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  1c0265:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1c026a:	75 dd                	jne    1c0249 <memcpy+0x26>
    }
    return dst;
  1c026c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1c0270:	c9                   	leave
  1c0271:	c3                   	ret

00000000001c0272 <memmove>:

void* memmove(void* dst, const void* src, size_t n) {
  1c0272:	55                   	push   %rbp
  1c0273:	48 89 e5             	mov    %rsp,%rbp
  1c0276:	48 83 ec 28          	sub    $0x28,%rsp
  1c027a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c027e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1c0282:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  1c0286:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1c028a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    char* d = (char*) dst;
  1c028e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0292:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (s < d && s + n > d) {
  1c0296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c029a:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  1c029e:	73 6a                	jae    1c030a <memmove+0x98>
  1c02a0:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  1c02a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c02a8:	48 01 d0             	add    %rdx,%rax
  1c02ab:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
  1c02af:	73 59                	jae    1c030a <memmove+0x98>
        s += n, d += n;
  1c02b1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c02b5:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  1c02b9:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c02bd:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        while (n-- > 0) {
  1c02c1:	eb 17                	jmp    1c02da <memmove+0x68>
            *--d = *--s;
  1c02c3:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  1c02c8:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
  1c02cd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c02d1:	0f b6 10             	movzbl (%rax),%edx
  1c02d4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c02d8:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  1c02da:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c02de:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  1c02e2:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  1c02e6:	48 85 c0             	test   %rax,%rax
  1c02e9:	75 d8                	jne    1c02c3 <memmove+0x51>
    if (s < d && s + n > d) {
  1c02eb:	eb 2e                	jmp    1c031b <memmove+0xa9>
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
  1c02ed:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  1c02f1:	48 8d 42 01          	lea    0x1(%rdx),%rax
  1c02f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  1c02f9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c02fd:	48 8d 48 01          	lea    0x1(%rax),%rcx
  1c0301:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  1c0305:	0f b6 12             	movzbl (%rdx),%edx
  1c0308:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  1c030a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c030e:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  1c0312:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  1c0316:	48 85 c0             	test   %rax,%rax
  1c0319:	75 d2                	jne    1c02ed <memmove+0x7b>
        }
    }
    return dst;
  1c031b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1c031f:	c9                   	leave
  1c0320:	c3                   	ret

00000000001c0321 <memset>:

void* memset(void* v, int c, size_t n) {
  1c0321:	55                   	push   %rbp
  1c0322:	48 89 e5             	mov    %rsp,%rbp
  1c0325:	48 83 ec 28          	sub    $0x28,%rsp
  1c0329:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c032d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  1c0330:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1c0334:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0338:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  1c033c:	eb 15                	jmp    1c0353 <memset+0x32>
        *p = c;
  1c033e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1c0341:	89 c2                	mov    %eax,%edx
  1c0343:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0347:	88 10                	mov    %dl,(%rax)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1c0349:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1c034e:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  1c0353:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1c0358:	75 e4                	jne    1c033e <memset+0x1d>
    }
    return v;
  1c035a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1c035e:	c9                   	leave
  1c035f:	c3                   	ret

00000000001c0360 <strlen>:

size_t strlen(const char* s) {
  1c0360:	55                   	push   %rbp
  1c0361:	48 89 e5             	mov    %rsp,%rbp
  1c0364:	48 83 ec 18          	sub    $0x18,%rsp
  1c0368:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
  1c036c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  1c0373:	00 
  1c0374:	eb 0a                	jmp    1c0380 <strlen+0x20>
        ++n;
  1c0376:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; *s != '\0'; ++s) {
  1c037b:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  1c0380:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0384:	0f b6 00             	movzbl (%rax),%eax
  1c0387:	84 c0                	test   %al,%al
  1c0389:	75 eb                	jne    1c0376 <strlen+0x16>
    }
    return n;
  1c038b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  1c038f:	c9                   	leave
  1c0390:	c3                   	ret

00000000001c0391 <strnlen>:

size_t strnlen(const char* s, size_t maxlen) {
  1c0391:	55                   	push   %rbp
  1c0392:	48 89 e5             	mov    %rsp,%rbp
  1c0395:	48 83 ec 20          	sub    $0x20,%rsp
  1c0399:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c039d:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    size_t n;
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1c03a1:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  1c03a8:	00 
  1c03a9:	eb 0a                	jmp    1c03b5 <strnlen+0x24>
        ++n;
  1c03ab:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1c03b0:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  1c03b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c03b9:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  1c03bd:	74 0b                	je     1c03ca <strnlen+0x39>
  1c03bf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c03c3:	0f b6 00             	movzbl (%rax),%eax
  1c03c6:	84 c0                	test   %al,%al
  1c03c8:	75 e1                	jne    1c03ab <strnlen+0x1a>
    }
    return n;
  1c03ca:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  1c03ce:	c9                   	leave
  1c03cf:	c3                   	ret

00000000001c03d0 <strcpy>:

char* strcpy(char* dst, const char* src) {
  1c03d0:	55                   	push   %rbp
  1c03d1:	48 89 e5             	mov    %rsp,%rbp
  1c03d4:	48 83 ec 20          	sub    $0x20,%rsp
  1c03d8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c03dc:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    char* d = dst;
  1c03e0:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c03e4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    do {
        *d++ = *src++;
  1c03e8:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  1c03ec:	48 8d 42 01          	lea    0x1(%rdx),%rax
  1c03f0:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  1c03f4:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c03f8:	48 8d 48 01          	lea    0x1(%rax),%rcx
  1c03fc:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
  1c0400:	0f b6 12             	movzbl (%rdx),%edx
  1c0403:	88 10                	mov    %dl,(%rax)
    } while (d[-1]);
  1c0405:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0409:	48 83 e8 01          	sub    $0x1,%rax
  1c040d:	0f b6 00             	movzbl (%rax),%eax
  1c0410:	84 c0                	test   %al,%al
  1c0412:	75 d4                	jne    1c03e8 <strcpy+0x18>
    return dst;
  1c0414:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1c0418:	c9                   	leave
  1c0419:	c3                   	ret

00000000001c041a <strcmp>:

int strcmp(const char* a, const char* b) {
  1c041a:	55                   	push   %rbp
  1c041b:	48 89 e5             	mov    %rsp,%rbp
  1c041e:	48 83 ec 10          	sub    $0x10,%rsp
  1c0422:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  1c0426:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  1c042a:	eb 0a                	jmp    1c0436 <strcmp+0x1c>
        ++a, ++b;
  1c042c:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  1c0431:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  1c0436:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c043a:	0f b6 00             	movzbl (%rax),%eax
  1c043d:	84 c0                	test   %al,%al
  1c043f:	74 1d                	je     1c045e <strcmp+0x44>
  1c0441:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c0445:	0f b6 00             	movzbl (%rax),%eax
  1c0448:	84 c0                	test   %al,%al
  1c044a:	74 12                	je     1c045e <strcmp+0x44>
  1c044c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0450:	0f b6 10             	movzbl (%rax),%edx
  1c0453:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c0457:	0f b6 00             	movzbl (%rax),%eax
  1c045a:	38 c2                	cmp    %al,%dl
  1c045c:	74 ce                	je     1c042c <strcmp+0x12>
    }
    return ((unsigned char) *a > (unsigned char) *b)
  1c045e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0462:	0f b6 00             	movzbl (%rax),%eax
  1c0465:	89 c2                	mov    %eax,%edx
  1c0467:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c046b:	0f b6 00             	movzbl (%rax),%eax
  1c046e:	38 d0                	cmp    %dl,%al
  1c0470:	0f 92 c0             	setb   %al
  1c0473:	0f b6 d0             	movzbl %al,%edx
        - ((unsigned char) *a < (unsigned char) *b);
  1c0476:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c047a:	0f b6 00             	movzbl (%rax),%eax
  1c047d:	89 c1                	mov    %eax,%ecx
  1c047f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c0483:	0f b6 00             	movzbl (%rax),%eax
  1c0486:	38 c1                	cmp    %al,%cl
  1c0488:	0f 92 c0             	setb   %al
  1c048b:	0f b6 c0             	movzbl %al,%eax
  1c048e:	29 c2                	sub    %eax,%edx
  1c0490:	89 d0                	mov    %edx,%eax
}
  1c0492:	c9                   	leave
  1c0493:	c3                   	ret

00000000001c0494 <strchr>:

char* strchr(const char* s, int c) {
  1c0494:	55                   	push   %rbp
  1c0495:	48 89 e5             	mov    %rsp,%rbp
  1c0498:	48 83 ec 10          	sub    $0x10,%rsp
  1c049c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  1c04a0:	89 75 f4             	mov    %esi,-0xc(%rbp)
    while (*s && *s != (char) c) {
  1c04a3:	eb 05                	jmp    1c04aa <strchr+0x16>
        ++s;
  1c04a5:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while (*s && *s != (char) c) {
  1c04aa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c04ae:	0f b6 00             	movzbl (%rax),%eax
  1c04b1:	84 c0                	test   %al,%al
  1c04b3:	74 0e                	je     1c04c3 <strchr+0x2f>
  1c04b5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c04b9:	0f b6 00             	movzbl (%rax),%eax
  1c04bc:	8b 55 f4             	mov    -0xc(%rbp),%edx
  1c04bf:	38 d0                	cmp    %dl,%al
  1c04c1:	75 e2                	jne    1c04a5 <strchr+0x11>
    }
    if (*s == (char) c) {
  1c04c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c04c7:	0f b6 00             	movzbl (%rax),%eax
  1c04ca:	8b 55 f4             	mov    -0xc(%rbp),%edx
  1c04cd:	38 d0                	cmp    %dl,%al
  1c04cf:	75 06                	jne    1c04d7 <strchr+0x43>
        return (char*) s;
  1c04d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c04d5:	eb 05                	jmp    1c04dc <strchr+0x48>
    } else {
        return NULL;
  1c04d7:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
  1c04dc:	c9                   	leave
  1c04dd:	c3                   	ret

00000000001c04de <rand>:
// rand, srand

static int rand_seed_set;
static unsigned rand_seed;

int rand(void) {
  1c04de:	55                   	push   %rbp
  1c04df:	48 89 e5             	mov    %rsp,%rbp
    if (!rand_seed_set) {
  1c04e2:	8b 05 38 1b 00 00    	mov    0x1b38(%rip),%eax        # 1c2020 <rand_seed_set>
  1c04e8:	85 c0                	test   %eax,%eax
  1c04ea:	75 0a                	jne    1c04f6 <rand+0x18>
        srand(819234718U);
  1c04ec:	bf 9e 87 d4 30       	mov    $0x30d4879e,%edi
  1c04f1:	e8 24 00 00 00       	call   1c051a <srand>
    }
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1c04f6:	8b 05 28 1b 00 00    	mov    0x1b28(%rip),%eax        # 1c2024 <rand_seed>
  1c04fc:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
  1c0502:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  1c0507:	89 05 17 1b 00 00    	mov    %eax,0x1b17(%rip)        # 1c2024 <rand_seed>
    return rand_seed & RAND_MAX;
  1c050d:	8b 05 11 1b 00 00    	mov    0x1b11(%rip),%eax        # 1c2024 <rand_seed>
  1c0513:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  1c0518:	5d                   	pop    %rbp
  1c0519:	c3                   	ret

00000000001c051a <srand>:

void srand(unsigned seed) {
  1c051a:	55                   	push   %rbp
  1c051b:	48 89 e5             	mov    %rsp,%rbp
  1c051e:	48 83 ec 08          	sub    $0x8,%rsp
  1c0522:	89 7d fc             	mov    %edi,-0x4(%rbp)
    rand_seed = seed;
  1c0525:	8b 45 fc             	mov    -0x4(%rbp),%eax
  1c0528:	89 05 f6 1a 00 00    	mov    %eax,0x1af6(%rip)        # 1c2024 <rand_seed>
    rand_seed_set = 1;
  1c052e:	c7 05 e8 1a 00 00 01 	movl   $0x1,0x1ae8(%rip)        # 1c2020 <rand_seed_set>
  1c0535:	00 00 00 
}
  1c0538:	90                   	nop
  1c0539:	c9                   	leave
  1c053a:	c3                   	ret

00000000001c053b <fill_numbuf>:
//    Print a message onto the console, starting at the given cursor position.

// snprintf, vsnprintf
//    Format a string into a buffer.

static char* fill_numbuf(char* numbuf_end, unsigned long val, int base) {
  1c053b:	55                   	push   %rbp
  1c053c:	48 89 e5             	mov    %rsp,%rbp
  1c053f:	48 83 ec 28          	sub    $0x28,%rsp
  1c0543:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c0547:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  1c054b:	89 55 dc             	mov    %edx,-0x24(%rbp)
    static const char upper_digits[] = "0123456789ABCDEF";
    static const char lower_digits[] = "0123456789abcdef";

    const char* digits = upper_digits;
  1c054e:	48 c7 45 f8 c0 14 1c 	movq   $0x1c14c0,-0x8(%rbp)
  1c0555:	00 
    if (base < 0) {
  1c0556:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  1c055a:	79 0b                	jns    1c0567 <fill_numbuf+0x2c>
        digits = lower_digits;
  1c055c:	48 c7 45 f8 e0 14 1c 	movq   $0x1c14e0,-0x8(%rbp)
  1c0563:	00 
        base = -base;
  1c0564:	f7 5d dc             	negl   -0x24(%rbp)
    }

    *--numbuf_end = '\0';
  1c0567:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  1c056c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0570:	c6 00 00             	movb   $0x0,(%rax)
    do {
        *--numbuf_end = digits[val % base];
  1c0573:	8b 45 dc             	mov    -0x24(%rbp),%eax
  1c0576:	48 63 c8             	movslq %eax,%rcx
  1c0579:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1c057d:	ba 00 00 00 00       	mov    $0x0,%edx
  1c0582:	48 f7 f1             	div    %rcx
  1c0585:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c0589:	48 01 d0             	add    %rdx,%rax
  1c058c:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  1c0591:	0f b6 10             	movzbl (%rax),%edx
  1c0594:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0598:	88 10                	mov    %dl,(%rax)
        val /= base;
  1c059a:	8b 45 dc             	mov    -0x24(%rbp),%eax
  1c059d:	48 63 f0             	movslq %eax,%rsi
  1c05a0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1c05a4:	ba 00 00 00 00       	mov    $0x0,%edx
  1c05a9:	48 f7 f6             	div    %rsi
  1c05ac:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    } while (val != 0);
  1c05b0:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  1c05b5:	75 bc                	jne    1c0573 <fill_numbuf+0x38>
    return numbuf_end;
  1c05b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  1c05bb:	c9                   	leave
  1c05bc:	c3                   	ret

00000000001c05bd <printer_vprintf>:
#define FLAG_NUMERIC            (1<<5)
#define FLAG_SIGNED             (1<<6)
#define FLAG_NEGATIVE           (1<<7)
#define FLAG_ALT2               (1<<8)

void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1c05bd:	55                   	push   %rbp
  1c05be:	48 89 e5             	mov    %rsp,%rbp
  1c05c1:	53                   	push   %rbx
  1c05c2:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  1c05c9:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
  1c05d0:	89 b5 74 ff ff ff    	mov    %esi,-0x8c(%rbp)
  1c05d6:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  1c05dd:	48 89 8d 60 ff ff ff 	mov    %rcx,-0xa0(%rbp)
#define NUMBUFSIZ 24
    char numbuf[NUMBUFSIZ];

    for (; *format; ++format) {
  1c05e4:	e9 8a 09 00 00       	jmp    1c0f73 <printer_vprintf+0x9b6>
        if (*format != '%') {
  1c05e9:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c05f0:	0f b6 00             	movzbl (%rax),%eax
  1c05f3:	3c 25                	cmp    $0x25,%al
  1c05f5:	74 31                	je     1c0628 <printer_vprintf+0x6b>
            p->putc(p, *format, color);
  1c05f7:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c05fe:	4c 8b 00             	mov    (%rax),%r8
  1c0601:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0608:	0f b6 00             	movzbl (%rax),%eax
  1c060b:	0f b6 c8             	movzbl %al,%ecx
  1c060e:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1c0614:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c061b:	89 ce                	mov    %ecx,%esi
  1c061d:	48 89 c7             	mov    %rax,%rdi
  1c0620:	41 ff d0             	call   *%r8
            continue;
  1c0623:	e9 43 09 00 00       	jmp    1c0f6b <printer_vprintf+0x9ae>
        }

        // process flags
        int flags = 0;
  1c0628:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        for (++format; *format; ++format) {
  1c062f:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c0636:	01 
  1c0637:	eb 44                	jmp    1c067d <printer_vprintf+0xc0>
            const char* flagc = strchr(flag_chars, *format);
  1c0639:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0640:	0f b6 00             	movzbl (%rax),%eax
  1c0643:	0f be c0             	movsbl %al,%eax
  1c0646:	89 c6                	mov    %eax,%esi
  1c0648:	bf e0 12 1c 00       	mov    $0x1c12e0,%edi
  1c064d:	e8 42 fe ff ff       	call   1c0494 <strchr>
  1c0652:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (flagc) {
  1c0656:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  1c065b:	74 30                	je     1c068d <printer_vprintf+0xd0>
                flags |= 1 << (flagc - flag_chars);
  1c065d:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  1c0661:	48 2d e0 12 1c 00    	sub    $0x1c12e0,%rax
  1c0667:	ba 01 00 00 00       	mov    $0x1,%edx
  1c066c:	89 c1                	mov    %eax,%ecx
  1c066e:	d3 e2                	shl    %cl,%edx
  1c0670:	89 d0                	mov    %edx,%eax
  1c0672:	09 45 ec             	or     %eax,-0x14(%rbp)
        for (++format; *format; ++format) {
  1c0675:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c067c:	01 
  1c067d:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0684:	0f b6 00             	movzbl (%rax),%eax
  1c0687:	84 c0                	test   %al,%al
  1c0689:	75 ae                	jne    1c0639 <printer_vprintf+0x7c>
  1c068b:	eb 01                	jmp    1c068e <printer_vprintf+0xd1>
            } else {
                break;
  1c068d:	90                   	nop
            }
        }

        // process width
        int width = -1;
  1c068e:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
        if (*format >= '1' && *format <= '9') {
  1c0695:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c069c:	0f b6 00             	movzbl (%rax),%eax
  1c069f:	3c 30                	cmp    $0x30,%al
  1c06a1:	7e 67                	jle    1c070a <printer_vprintf+0x14d>
  1c06a3:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c06aa:	0f b6 00             	movzbl (%rax),%eax
  1c06ad:	3c 39                	cmp    $0x39,%al
  1c06af:	7f 59                	jg     1c070a <printer_vprintf+0x14d>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c06b1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  1c06b8:	eb 2e                	jmp    1c06e8 <printer_vprintf+0x12b>
                width = 10 * width + *format++ - '0';
  1c06ba:	8b 55 e8             	mov    -0x18(%rbp),%edx
  1c06bd:	89 d0                	mov    %edx,%eax
  1c06bf:	c1 e0 02             	shl    $0x2,%eax
  1c06c2:	01 d0                	add    %edx,%eax
  1c06c4:	01 c0                	add    %eax,%eax
  1c06c6:	89 c1                	mov    %eax,%ecx
  1c06c8:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c06cf:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1c06d3:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  1c06da:	0f b6 00             	movzbl (%rax),%eax
  1c06dd:	0f be c0             	movsbl %al,%eax
  1c06e0:	01 c8                	add    %ecx,%eax
  1c06e2:	83 e8 30             	sub    $0x30,%eax
  1c06e5:	89 45 e8             	mov    %eax,-0x18(%rbp)
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1c06e8:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c06ef:	0f b6 00             	movzbl (%rax),%eax
  1c06f2:	3c 2f                	cmp    $0x2f,%al
  1c06f4:	0f 8e 85 00 00 00    	jle    1c077f <printer_vprintf+0x1c2>
  1c06fa:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0701:	0f b6 00             	movzbl (%rax),%eax
  1c0704:	3c 39                	cmp    $0x39,%al
  1c0706:	7e b2                	jle    1c06ba <printer_vprintf+0xfd>
        if (*format >= '1' && *format <= '9') {
  1c0708:	eb 75                	jmp    1c077f <printer_vprintf+0x1c2>
            }
        } else if (*format == '*') {
  1c070a:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0711:	0f b6 00             	movzbl (%rax),%eax
  1c0714:	3c 2a                	cmp    $0x2a,%al
  1c0716:	75 68                	jne    1c0780 <printer_vprintf+0x1c3>
            width = va_arg(val, int);
  1c0718:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c071f:	8b 00                	mov    (%rax),%eax
  1c0721:	83 f8 2f             	cmp    $0x2f,%eax
  1c0724:	77 30                	ja     1c0756 <printer_vprintf+0x199>
  1c0726:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c072d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c0731:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0738:	8b 00                	mov    (%rax),%eax
  1c073a:	89 c0                	mov    %eax,%eax
  1c073c:	48 01 d0             	add    %rdx,%rax
  1c073f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0746:	8b 12                	mov    (%rdx),%edx
  1c0748:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c074b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0752:	89 0a                	mov    %ecx,(%rdx)
  1c0754:	eb 1a                	jmp    1c0770 <printer_vprintf+0x1b3>
  1c0756:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c075d:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0761:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c0765:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c076c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0770:	8b 00                	mov    (%rax),%eax
  1c0772:	89 45 e8             	mov    %eax,-0x18(%rbp)
            ++format;
  1c0775:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c077c:	01 
  1c077d:	eb 01                	jmp    1c0780 <printer_vprintf+0x1c3>
        if (*format >= '1' && *format <= '9') {
  1c077f:	90                   	nop
        }

        // process precision
        int precision = -1;
  1c0780:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
        if (*format == '.') {
  1c0787:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c078e:	0f b6 00             	movzbl (%rax),%eax
  1c0791:	3c 2e                	cmp    $0x2e,%al
  1c0793:	0f 85 00 01 00 00    	jne    1c0899 <printer_vprintf+0x2dc>
            ++format;
  1c0799:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c07a0:	01 
            if (*format >= '0' && *format <= '9') {
  1c07a1:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c07a8:	0f b6 00             	movzbl (%rax),%eax
  1c07ab:	3c 2f                	cmp    $0x2f,%al
  1c07ad:	7e 67                	jle    1c0816 <printer_vprintf+0x259>
  1c07af:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c07b6:	0f b6 00             	movzbl (%rax),%eax
  1c07b9:	3c 39                	cmp    $0x39,%al
  1c07bb:	7f 59                	jg     1c0816 <printer_vprintf+0x259>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1c07bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  1c07c4:	eb 2e                	jmp    1c07f4 <printer_vprintf+0x237>
                    precision = 10 * precision + *format++ - '0';
  1c07c6:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  1c07c9:	89 d0                	mov    %edx,%eax
  1c07cb:	c1 e0 02             	shl    $0x2,%eax
  1c07ce:	01 d0                	add    %edx,%eax
  1c07d0:	01 c0                	add    %eax,%eax
  1c07d2:	89 c1                	mov    %eax,%ecx
  1c07d4:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c07db:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1c07df:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  1c07e6:	0f b6 00             	movzbl (%rax),%eax
  1c07e9:	0f be c0             	movsbl %al,%eax
  1c07ec:	01 c8                	add    %ecx,%eax
  1c07ee:	83 e8 30             	sub    $0x30,%eax
  1c07f1:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1c07f4:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c07fb:	0f b6 00             	movzbl (%rax),%eax
  1c07fe:	3c 2f                	cmp    $0x2f,%al
  1c0800:	0f 8e 85 00 00 00    	jle    1c088b <printer_vprintf+0x2ce>
  1c0806:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c080d:	0f b6 00             	movzbl (%rax),%eax
  1c0810:	3c 39                	cmp    $0x39,%al
  1c0812:	7e b2                	jle    1c07c6 <printer_vprintf+0x209>
            if (*format >= '0' && *format <= '9') {
  1c0814:	eb 75                	jmp    1c088b <printer_vprintf+0x2ce>
                }
            } else if (*format == '*') {
  1c0816:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c081d:	0f b6 00             	movzbl (%rax),%eax
  1c0820:	3c 2a                	cmp    $0x2a,%al
  1c0822:	75 68                	jne    1c088c <printer_vprintf+0x2cf>
                precision = va_arg(val, int);
  1c0824:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c082b:	8b 00                	mov    (%rax),%eax
  1c082d:	83 f8 2f             	cmp    $0x2f,%eax
  1c0830:	77 30                	ja     1c0862 <printer_vprintf+0x2a5>
  1c0832:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0839:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c083d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0844:	8b 00                	mov    (%rax),%eax
  1c0846:	89 c0                	mov    %eax,%eax
  1c0848:	48 01 d0             	add    %rdx,%rax
  1c084b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0852:	8b 12                	mov    (%rdx),%edx
  1c0854:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c0857:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c085e:	89 0a                	mov    %ecx,(%rdx)
  1c0860:	eb 1a                	jmp    1c087c <printer_vprintf+0x2bf>
  1c0862:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0869:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c086d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c0871:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0878:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c087c:	8b 00                	mov    (%rax),%eax
  1c087e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                ++format;
  1c0881:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c0888:	01 
  1c0889:	eb 01                	jmp    1c088c <printer_vprintf+0x2cf>
            if (*format >= '0' && *format <= '9') {
  1c088b:	90                   	nop
            }
            if (precision < 0) {
  1c088c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  1c0890:	79 07                	jns    1c0899 <printer_vprintf+0x2dc>
                precision = 0;
  1c0892:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
            }
        }

        // process main conversion character
        int base = 10;
  1c0899:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%rbp)
        unsigned long num = 0;
  1c08a0:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  1c08a7:	00 
        int length = 0;
  1c08a8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
        char* data = "";
  1c08af:	48 c7 45 c8 e6 12 1c 	movq   $0x1c12e6,-0x38(%rbp)
  1c08b6:	00 
    again:
        switch (*format) {
  1c08b7:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c08be:	0f b6 00             	movzbl (%rax),%eax
  1c08c1:	0f be c0             	movsbl %al,%eax
  1c08c4:	83 e8 43             	sub    $0x43,%eax
  1c08c7:	83 f8 37             	cmp    $0x37,%eax
  1c08ca:	0f 87 9f 03 00 00    	ja     1c0c6f <printer_vprintf+0x6b2>
  1c08d0:	89 c0                	mov    %eax,%eax
  1c08d2:	48 8b 04 c5 f8 12 1c 	mov    0x1c12f8(,%rax,8),%rax
  1c08d9:	00 
  1c08da:	ff e0                	jmp    *%rax
        case 'l':
        case 'z':
            length = 1;
  1c08dc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
            ++format;
  1c08e3:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c08ea:	01 
            goto again;
  1c08eb:	eb ca                	jmp    1c08b7 <printer_vprintf+0x2fa>
        case 'd':
        case 'i': {
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1c08ed:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  1c08f1:	74 5d                	je     1c0950 <printer_vprintf+0x393>
  1c08f3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c08fa:	8b 00                	mov    (%rax),%eax
  1c08fc:	83 f8 2f             	cmp    $0x2f,%eax
  1c08ff:	77 30                	ja     1c0931 <printer_vprintf+0x374>
  1c0901:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0908:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c090c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0913:	8b 00                	mov    (%rax),%eax
  1c0915:	89 c0                	mov    %eax,%eax
  1c0917:	48 01 d0             	add    %rdx,%rax
  1c091a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0921:	8b 12                	mov    (%rdx),%edx
  1c0923:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c0926:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c092d:	89 0a                	mov    %ecx,(%rdx)
  1c092f:	eb 1a                	jmp    1c094b <printer_vprintf+0x38e>
  1c0931:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0938:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c093c:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c0940:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0947:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c094b:	48 8b 00             	mov    (%rax),%rax
  1c094e:	eb 5c                	jmp    1c09ac <printer_vprintf+0x3ef>
  1c0950:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0957:	8b 00                	mov    (%rax),%eax
  1c0959:	83 f8 2f             	cmp    $0x2f,%eax
  1c095c:	77 30                	ja     1c098e <printer_vprintf+0x3d1>
  1c095e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0965:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c0969:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0970:	8b 00                	mov    (%rax),%eax
  1c0972:	89 c0                	mov    %eax,%eax
  1c0974:	48 01 d0             	add    %rdx,%rax
  1c0977:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c097e:	8b 12                	mov    (%rdx),%edx
  1c0980:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c0983:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c098a:	89 0a                	mov    %ecx,(%rdx)
  1c098c:	eb 1a                	jmp    1c09a8 <printer_vprintf+0x3eb>
  1c098e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0995:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0999:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c099d:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c09a4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c09a8:	8b 00                	mov    (%rax),%eax
  1c09aa:	48 98                	cltq
  1c09ac:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1c09b0:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1c09b4:	48 c1 f8 38          	sar    $0x38,%rax
  1c09b8:	25 80 00 00 00       	and    $0x80,%eax
  1c09bd:	89 45 a4             	mov    %eax,-0x5c(%rbp)
            num = negative ? -x : x;
  1c09c0:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  1c09c4:	74 09                	je     1c09cf <printer_vprintf+0x412>
  1c09c6:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1c09ca:	48 f7 d8             	neg    %rax
  1c09cd:	eb 04                	jmp    1c09d3 <printer_vprintf+0x416>
  1c09cf:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1c09d3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1c09d7:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  1c09da:	83 c8 60             	or     $0x60,%eax
  1c09dd:	09 45 ec             	or     %eax,-0x14(%rbp)
            break;
  1c09e0:	e9 cf 02 00 00       	jmp    1c0cb4 <printer_vprintf+0x6f7>
        }
        case 'u':
        format_unsigned:
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1c09e5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  1c09e9:	74 5d                	je     1c0a48 <printer_vprintf+0x48b>
  1c09eb:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c09f2:	8b 00                	mov    (%rax),%eax
  1c09f4:	83 f8 2f             	cmp    $0x2f,%eax
  1c09f7:	77 30                	ja     1c0a29 <printer_vprintf+0x46c>
  1c09f9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a00:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c0a04:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a0b:	8b 00                	mov    (%rax),%eax
  1c0a0d:	89 c0                	mov    %eax,%eax
  1c0a0f:	48 01 d0             	add    %rdx,%rax
  1c0a12:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0a19:	8b 12                	mov    (%rdx),%edx
  1c0a1b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c0a1e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0a25:	89 0a                	mov    %ecx,(%rdx)
  1c0a27:	eb 1a                	jmp    1c0a43 <printer_vprintf+0x486>
  1c0a29:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a30:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0a34:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c0a38:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0a3f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0a43:	48 8b 00             	mov    (%rax),%rax
  1c0a46:	eb 5c                	jmp    1c0aa4 <printer_vprintf+0x4e7>
  1c0a48:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a4f:	8b 00                	mov    (%rax),%eax
  1c0a51:	83 f8 2f             	cmp    $0x2f,%eax
  1c0a54:	77 30                	ja     1c0a86 <printer_vprintf+0x4c9>
  1c0a56:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a5d:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c0a61:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a68:	8b 00                	mov    (%rax),%eax
  1c0a6a:	89 c0                	mov    %eax,%eax
  1c0a6c:	48 01 d0             	add    %rdx,%rax
  1c0a6f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0a76:	8b 12                	mov    (%rdx),%edx
  1c0a78:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c0a7b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0a82:	89 0a                	mov    %ecx,(%rdx)
  1c0a84:	eb 1a                	jmp    1c0aa0 <printer_vprintf+0x4e3>
  1c0a86:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0a8d:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0a91:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c0a95:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0a9c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0aa0:	8b 00                	mov    (%rax),%eax
  1c0aa2:	89 c0                	mov    %eax,%eax
  1c0aa4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC;
  1c0aa8:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
            break;
  1c0aac:	e9 03 02 00 00       	jmp    1c0cb4 <printer_vprintf+0x6f7>
        case 'x':
            base = -16;
  1c0ab1:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            goto format_unsigned;
  1c0ab8:	e9 28 ff ff ff       	jmp    1c09e5 <printer_vprintf+0x428>
        case 'X':
            base = 16;
  1c0abd:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%rbp)
            goto format_unsigned;
  1c0ac4:	e9 1c ff ff ff       	jmp    1c09e5 <printer_vprintf+0x428>
        case 'p':
            num = (uintptr_t) va_arg(val, void*);
  1c0ac9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0ad0:	8b 00                	mov    (%rax),%eax
  1c0ad2:	83 f8 2f             	cmp    $0x2f,%eax
  1c0ad5:	77 30                	ja     1c0b07 <printer_vprintf+0x54a>
  1c0ad7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0ade:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c0ae2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0ae9:	8b 00                	mov    (%rax),%eax
  1c0aeb:	89 c0                	mov    %eax,%eax
  1c0aed:	48 01 d0             	add    %rdx,%rax
  1c0af0:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0af7:	8b 12                	mov    (%rdx),%edx
  1c0af9:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c0afc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0b03:	89 0a                	mov    %ecx,(%rdx)
  1c0b05:	eb 1a                	jmp    1c0b21 <printer_vprintf+0x564>
  1c0b07:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0b0e:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0b12:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c0b16:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0b1d:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0b21:	48 8b 00             	mov    (%rax),%rax
  1c0b24:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            base = -16;
  1c0b28:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1c0b2f:	81 4d ec 21 01 00 00 	orl    $0x121,-0x14(%rbp)
            break;
  1c0b36:	e9 79 01 00 00       	jmp    1c0cb4 <printer_vprintf+0x6f7>
        case 's':
            data = va_arg(val, char*);
  1c0b3b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0b42:	8b 00                	mov    (%rax),%eax
  1c0b44:	83 f8 2f             	cmp    $0x2f,%eax
  1c0b47:	77 30                	ja     1c0b79 <printer_vprintf+0x5bc>
  1c0b49:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0b50:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c0b54:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0b5b:	8b 00                	mov    (%rax),%eax
  1c0b5d:	89 c0                	mov    %eax,%eax
  1c0b5f:	48 01 d0             	add    %rdx,%rax
  1c0b62:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0b69:	8b 12                	mov    (%rdx),%edx
  1c0b6b:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c0b6e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0b75:	89 0a                	mov    %ecx,(%rdx)
  1c0b77:	eb 1a                	jmp    1c0b93 <printer_vprintf+0x5d6>
  1c0b79:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0b80:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0b84:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c0b88:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0b8f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0b93:	48 8b 00             	mov    (%rax),%rax
  1c0b96:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            break;
  1c0b9a:	e9 15 01 00 00       	jmp    1c0cb4 <printer_vprintf+0x6f7>
        case 'C':
            color = va_arg(val, int);
  1c0b9f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0ba6:	8b 00                	mov    (%rax),%eax
  1c0ba8:	83 f8 2f             	cmp    $0x2f,%eax
  1c0bab:	77 30                	ja     1c0bdd <printer_vprintf+0x620>
  1c0bad:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0bb4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c0bb8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0bbf:	8b 00                	mov    (%rax),%eax
  1c0bc1:	89 c0                	mov    %eax,%eax
  1c0bc3:	48 01 d0             	add    %rdx,%rax
  1c0bc6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0bcd:	8b 12                	mov    (%rdx),%edx
  1c0bcf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c0bd2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0bd9:	89 0a                	mov    %ecx,(%rdx)
  1c0bdb:	eb 1a                	jmp    1c0bf7 <printer_vprintf+0x63a>
  1c0bdd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0be4:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0be8:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c0bec:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0bf3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0bf7:	8b 00                	mov    (%rax),%eax
  1c0bf9:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
            goto done;
  1c0bff:	e9 67 03 00 00       	jmp    1c0f6b <printer_vprintf+0x9ae>
        case 'c':
            data = numbuf;
  1c0c04:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  1c0c08:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = va_arg(val, int);
  1c0c0c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0c13:	8b 00                	mov    (%rax),%eax
  1c0c15:	83 f8 2f             	cmp    $0x2f,%eax
  1c0c18:	77 30                	ja     1c0c4a <printer_vprintf+0x68d>
  1c0c1a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0c21:	48 8b 50 10          	mov    0x10(%rax),%rdx
  1c0c25:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0c2c:	8b 00                	mov    (%rax),%eax
  1c0c2e:	89 c0                	mov    %eax,%eax
  1c0c30:	48 01 d0             	add    %rdx,%rax
  1c0c33:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0c3a:	8b 12                	mov    (%rdx),%edx
  1c0c3c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  1c0c3f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0c46:	89 0a                	mov    %ecx,(%rdx)
  1c0c48:	eb 1a                	jmp    1c0c64 <printer_vprintf+0x6a7>
  1c0c4a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  1c0c51:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0c55:	48 8d 48 08          	lea    0x8(%rax),%rcx
  1c0c59:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  1c0c60:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c0c64:	8b 00                	mov    (%rax),%eax
  1c0c66:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  1c0c69:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            break;
  1c0c6d:	eb 45                	jmp    1c0cb4 <printer_vprintf+0x6f7>
        default:
            data = numbuf;
  1c0c6f:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  1c0c73:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = (*format ? *format : '%');
  1c0c77:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0c7e:	0f b6 00             	movzbl (%rax),%eax
  1c0c81:	84 c0                	test   %al,%al
  1c0c83:	74 0c                	je     1c0c91 <printer_vprintf+0x6d4>
  1c0c85:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0c8c:	0f b6 00             	movzbl (%rax),%eax
  1c0c8f:	eb 05                	jmp    1c0c96 <printer_vprintf+0x6d9>
  1c0c91:	b8 25 00 00 00       	mov    $0x25,%eax
  1c0c96:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  1c0c99:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            if (!*format) {
  1c0c9d:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0ca4:	0f b6 00             	movzbl (%rax),%eax
  1c0ca7:	84 c0                	test   %al,%al
  1c0ca9:	75 08                	jne    1c0cb3 <printer_vprintf+0x6f6>
                format--;
  1c0cab:	48 83 ad 68 ff ff ff 	subq   $0x1,-0x98(%rbp)
  1c0cb2:	01 
            }
            break;
  1c0cb3:	90                   	nop
        }

        if (flags & FLAG_NUMERIC) {
  1c0cb4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0cb7:	83 e0 20             	and    $0x20,%eax
  1c0cba:	85 c0                	test   %eax,%eax
  1c0cbc:	74 1e                	je     1c0cdc <printer_vprintf+0x71f>
            data = fill_numbuf(numbuf + NUMBUFSIZ, num, base);
  1c0cbe:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  1c0cc2:	48 83 c0 18          	add    $0x18,%rax
  1c0cc6:	8b 55 e0             	mov    -0x20(%rbp),%edx
  1c0cc9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  1c0ccd:	48 89 ce             	mov    %rcx,%rsi
  1c0cd0:	48 89 c7             	mov    %rax,%rdi
  1c0cd3:	e8 63 f8 ff ff       	call   1c053b <fill_numbuf>
  1c0cd8:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        }

        const char* prefix = "";
  1c0cdc:	48 c7 45 c0 e6 12 1c 	movq   $0x1c12e6,-0x40(%rbp)
  1c0ce3:	00 
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  1c0ce4:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0ce7:	83 e0 20             	and    $0x20,%eax
  1c0cea:	85 c0                	test   %eax,%eax
  1c0cec:	74 48                	je     1c0d36 <printer_vprintf+0x779>
  1c0cee:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0cf1:	83 e0 40             	and    $0x40,%eax
  1c0cf4:	85 c0                	test   %eax,%eax
  1c0cf6:	74 3e                	je     1c0d36 <printer_vprintf+0x779>
            if (flags & FLAG_NEGATIVE) {
  1c0cf8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0cfb:	25 80 00 00 00       	and    $0x80,%eax
  1c0d00:	85 c0                	test   %eax,%eax
  1c0d02:	74 0a                	je     1c0d0e <printer_vprintf+0x751>
                prefix = "-";
  1c0d04:	48 c7 45 c0 e7 12 1c 	movq   $0x1c12e7,-0x40(%rbp)
  1c0d0b:	00 
            if (flags & FLAG_NEGATIVE) {
  1c0d0c:	eb 73                	jmp    1c0d81 <printer_vprintf+0x7c4>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  1c0d0e:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0d11:	83 e0 10             	and    $0x10,%eax
  1c0d14:	85 c0                	test   %eax,%eax
  1c0d16:	74 0a                	je     1c0d22 <printer_vprintf+0x765>
                prefix = "+";
  1c0d18:	48 c7 45 c0 e9 12 1c 	movq   $0x1c12e9,-0x40(%rbp)
  1c0d1f:	00 
            if (flags & FLAG_NEGATIVE) {
  1c0d20:	eb 5f                	jmp    1c0d81 <printer_vprintf+0x7c4>
            } else if (flags & FLAG_SPACEPOSITIVE) {
  1c0d22:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0d25:	83 e0 08             	and    $0x8,%eax
  1c0d28:	85 c0                	test   %eax,%eax
  1c0d2a:	74 55                	je     1c0d81 <printer_vprintf+0x7c4>
                prefix = " ";
  1c0d2c:	48 c7 45 c0 eb 12 1c 	movq   $0x1c12eb,-0x40(%rbp)
  1c0d33:	00 
            if (flags & FLAG_NEGATIVE) {
  1c0d34:	eb 4b                	jmp    1c0d81 <printer_vprintf+0x7c4>
            }
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1c0d36:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0d39:	83 e0 20             	and    $0x20,%eax
  1c0d3c:	85 c0                	test   %eax,%eax
  1c0d3e:	74 42                	je     1c0d82 <printer_vprintf+0x7c5>
  1c0d40:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0d43:	83 e0 01             	and    $0x1,%eax
  1c0d46:	85 c0                	test   %eax,%eax
  1c0d48:	74 38                	je     1c0d82 <printer_vprintf+0x7c5>
                   && (base == 16 || base == -16)
  1c0d4a:	83 7d e0 10          	cmpl   $0x10,-0x20(%rbp)
  1c0d4e:	74 06                	je     1c0d56 <printer_vprintf+0x799>
  1c0d50:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  1c0d54:	75 2c                	jne    1c0d82 <printer_vprintf+0x7c5>
                   && (num || (flags & FLAG_ALT2))) {
  1c0d56:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  1c0d5b:	75 0c                	jne    1c0d69 <printer_vprintf+0x7ac>
  1c0d5d:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0d60:	25 00 01 00 00       	and    $0x100,%eax
  1c0d65:	85 c0                	test   %eax,%eax
  1c0d67:	74 19                	je     1c0d82 <printer_vprintf+0x7c5>
            prefix = (base == -16 ? "0x" : "0X");
  1c0d69:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  1c0d6d:	75 07                	jne    1c0d76 <printer_vprintf+0x7b9>
  1c0d6f:	b8 ed 12 1c 00       	mov    $0x1c12ed,%eax
  1c0d74:	eb 05                	jmp    1c0d7b <printer_vprintf+0x7be>
  1c0d76:	b8 f0 12 1c 00       	mov    $0x1c12f0,%eax
  1c0d7b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c0d7f:	eb 01                	jmp    1c0d82 <printer_vprintf+0x7c5>
            if (flags & FLAG_NEGATIVE) {
  1c0d81:	90                   	nop
        }

        int len;
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  1c0d82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  1c0d86:	78 24                	js     1c0dac <printer_vprintf+0x7ef>
  1c0d88:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0d8b:	83 e0 20             	and    $0x20,%eax
  1c0d8e:	85 c0                	test   %eax,%eax
  1c0d90:	75 1a                	jne    1c0dac <printer_vprintf+0x7ef>
            len = strnlen(data, precision);
  1c0d92:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1c0d95:	48 63 d0             	movslq %eax,%rdx
  1c0d98:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  1c0d9c:	48 89 d6             	mov    %rdx,%rsi
  1c0d9f:	48 89 c7             	mov    %rax,%rdi
  1c0da2:	e8 ea f5 ff ff       	call   1c0391 <strnlen>
  1c0da7:	89 45 bc             	mov    %eax,-0x44(%rbp)
  1c0daa:	eb 0f                	jmp    1c0dbb <printer_vprintf+0x7fe>
        } else {
            len = strlen(data);
  1c0dac:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  1c0db0:	48 89 c7             	mov    %rax,%rdi
  1c0db3:	e8 a8 f5 ff ff       	call   1c0360 <strlen>
  1c0db8:	89 45 bc             	mov    %eax,-0x44(%rbp)
        }
        int zeros;
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  1c0dbb:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0dbe:	83 e0 20             	and    $0x20,%eax
  1c0dc1:	85 c0                	test   %eax,%eax
  1c0dc3:	74 20                	je     1c0de5 <printer_vprintf+0x828>
  1c0dc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  1c0dc9:	78 1a                	js     1c0de5 <printer_vprintf+0x828>
            zeros = precision > len ? precision - len : 0;
  1c0dcb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1c0dce:	3b 45 bc             	cmp    -0x44(%rbp),%eax
  1c0dd1:	7e 08                	jle    1c0ddb <printer_vprintf+0x81e>
  1c0dd3:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  1c0dd6:	2b 45 bc             	sub    -0x44(%rbp),%eax
  1c0dd9:	eb 05                	jmp    1c0de0 <printer_vprintf+0x823>
  1c0ddb:	b8 00 00 00 00       	mov    $0x0,%eax
  1c0de0:	89 45 b8             	mov    %eax,-0x48(%rbp)
  1c0de3:	eb 5c                	jmp    1c0e41 <printer_vprintf+0x884>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  1c0de5:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0de8:	83 e0 20             	and    $0x20,%eax
  1c0deb:	85 c0                	test   %eax,%eax
  1c0ded:	74 4b                	je     1c0e3a <printer_vprintf+0x87d>
  1c0def:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0df2:	83 e0 02             	and    $0x2,%eax
  1c0df5:	85 c0                	test   %eax,%eax
  1c0df7:	74 41                	je     1c0e3a <printer_vprintf+0x87d>
                   && !(flags & FLAG_LEFTJUSTIFY)
  1c0df9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0dfc:	83 e0 04             	and    $0x4,%eax
  1c0dff:	85 c0                	test   %eax,%eax
  1c0e01:	75 37                	jne    1c0e3a <printer_vprintf+0x87d>
                   && len + (int) strlen(prefix) < width) {
  1c0e03:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  1c0e07:	48 89 c7             	mov    %rax,%rdi
  1c0e0a:	e8 51 f5 ff ff       	call   1c0360 <strlen>
  1c0e0f:	89 c2                	mov    %eax,%edx
  1c0e11:	8b 45 bc             	mov    -0x44(%rbp),%eax
  1c0e14:	01 d0                	add    %edx,%eax
  1c0e16:	39 45 e8             	cmp    %eax,-0x18(%rbp)
  1c0e19:	7e 1f                	jle    1c0e3a <printer_vprintf+0x87d>
            zeros = width - len - strlen(prefix);
  1c0e1b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  1c0e1e:	2b 45 bc             	sub    -0x44(%rbp),%eax
  1c0e21:	89 c3                	mov    %eax,%ebx
  1c0e23:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  1c0e27:	48 89 c7             	mov    %rax,%rdi
  1c0e2a:	e8 31 f5 ff ff       	call   1c0360 <strlen>
  1c0e2f:	89 c2                	mov    %eax,%edx
  1c0e31:	89 d8                	mov    %ebx,%eax
  1c0e33:	29 d0                	sub    %edx,%eax
  1c0e35:	89 45 b8             	mov    %eax,-0x48(%rbp)
  1c0e38:	eb 07                	jmp    1c0e41 <printer_vprintf+0x884>
        } else {
            zeros = 0;
  1c0e3a:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
        }
        width -= len + zeros + strlen(prefix);
  1c0e41:	8b 55 bc             	mov    -0x44(%rbp),%edx
  1c0e44:	8b 45 b8             	mov    -0x48(%rbp),%eax
  1c0e47:	01 d0                	add    %edx,%eax
  1c0e49:	48 63 d8             	movslq %eax,%rbx
  1c0e4c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  1c0e50:	48 89 c7             	mov    %rax,%rdi
  1c0e53:	e8 08 f5 ff ff       	call   1c0360 <strlen>
  1c0e58:	48 8d 14 03          	lea    (%rbx,%rax,1),%rdx
  1c0e5c:	8b 45 e8             	mov    -0x18(%rbp),%eax
  1c0e5f:	29 d0                	sub    %edx,%eax
  1c0e61:	89 45 e8             	mov    %eax,-0x18(%rbp)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1c0e64:	eb 25                	jmp    1c0e8b <printer_vprintf+0x8ce>
            p->putc(p, ' ', color);
  1c0e66:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0e6d:	48 8b 08             	mov    (%rax),%rcx
  1c0e70:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1c0e76:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0e7d:	be 20 00 00 00       	mov    $0x20,%esi
  1c0e82:	48 89 c7             	mov    %rax,%rdi
  1c0e85:	ff d1                	call   *%rcx
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1c0e87:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  1c0e8b:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c0e8e:	83 e0 04             	and    $0x4,%eax
  1c0e91:	85 c0                	test   %eax,%eax
  1c0e93:	75 36                	jne    1c0ecb <printer_vprintf+0x90e>
  1c0e95:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  1c0e99:	7f cb                	jg     1c0e66 <printer_vprintf+0x8a9>
        }
        for (; *prefix; ++prefix) {
  1c0e9b:	eb 2e                	jmp    1c0ecb <printer_vprintf+0x90e>
            p->putc(p, *prefix, color);
  1c0e9d:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0ea4:	4c 8b 00             	mov    (%rax),%r8
  1c0ea7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  1c0eab:	0f b6 00             	movzbl (%rax),%eax
  1c0eae:	0f b6 c8             	movzbl %al,%ecx
  1c0eb1:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1c0eb7:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0ebe:	89 ce                	mov    %ecx,%esi
  1c0ec0:	48 89 c7             	mov    %rax,%rdi
  1c0ec3:	41 ff d0             	call   *%r8
        for (; *prefix; ++prefix) {
  1c0ec6:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  1c0ecb:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  1c0ecf:	0f b6 00             	movzbl (%rax),%eax
  1c0ed2:	84 c0                	test   %al,%al
  1c0ed4:	75 c7                	jne    1c0e9d <printer_vprintf+0x8e0>
        }
        for (; zeros > 0; --zeros) {
  1c0ed6:	eb 25                	jmp    1c0efd <printer_vprintf+0x940>
            p->putc(p, '0', color);
  1c0ed8:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0edf:	48 8b 08             	mov    (%rax),%rcx
  1c0ee2:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1c0ee8:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0eef:	be 30 00 00 00       	mov    $0x30,%esi
  1c0ef4:	48 89 c7             	mov    %rax,%rdi
  1c0ef7:	ff d1                	call   *%rcx
        for (; zeros > 0; --zeros) {
  1c0ef9:	83 6d b8 01          	subl   $0x1,-0x48(%rbp)
  1c0efd:	83 7d b8 00          	cmpl   $0x0,-0x48(%rbp)
  1c0f01:	7f d5                	jg     1c0ed8 <printer_vprintf+0x91b>
        }
        for (; len > 0; ++data, --len) {
  1c0f03:	eb 32                	jmp    1c0f37 <printer_vprintf+0x97a>
            p->putc(p, *data, color);
  1c0f05:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0f0c:	4c 8b 00             	mov    (%rax),%r8
  1c0f0f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  1c0f13:	0f b6 00             	movzbl (%rax),%eax
  1c0f16:	0f b6 c8             	movzbl %al,%ecx
  1c0f19:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1c0f1f:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0f26:	89 ce                	mov    %ecx,%esi
  1c0f28:	48 89 c7             	mov    %rax,%rdi
  1c0f2b:	41 ff d0             	call   *%r8
        for (; len > 0; ++data, --len) {
  1c0f2e:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  1c0f33:	83 6d bc 01          	subl   $0x1,-0x44(%rbp)
  1c0f37:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  1c0f3b:	7f c8                	jg     1c0f05 <printer_vprintf+0x948>
        }
        for (; width > 0; --width) {
  1c0f3d:	eb 25                	jmp    1c0f64 <printer_vprintf+0x9a7>
            p->putc(p, ' ', color);
  1c0f3f:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0f46:	48 8b 08             	mov    (%rax),%rcx
  1c0f49:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  1c0f4f:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  1c0f56:	be 20 00 00 00       	mov    $0x20,%esi
  1c0f5b:	48 89 c7             	mov    %rax,%rdi
  1c0f5e:	ff d1                	call   *%rcx
        for (; width > 0; --width) {
  1c0f60:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  1c0f64:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  1c0f68:	7f d5                	jg     1c0f3f <printer_vprintf+0x982>
        }
    done: ;
  1c0f6a:	90                   	nop
    for (; *format; ++format) {
  1c0f6b:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  1c0f72:	01 
  1c0f73:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  1c0f7a:	0f b6 00             	movzbl (%rax),%eax
  1c0f7d:	84 c0                	test   %al,%al
  1c0f7f:	0f 85 64 f6 ff ff    	jne    1c05e9 <printer_vprintf+0x2c>
    }
}
  1c0f85:	90                   	nop
  1c0f86:	90                   	nop
  1c0f87:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  1c0f8b:	c9                   	leave
  1c0f8c:	c3                   	ret

00000000001c0f8d <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  1c0f8d:	55                   	push   %rbp
  1c0f8e:	48 89 e5             	mov    %rsp,%rbp
  1c0f91:	48 83 ec 20          	sub    $0x20,%rsp
  1c0f95:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c0f99:	89 f0                	mov    %esi,%eax
  1c0f9b:	89 55 e0             	mov    %edx,-0x20(%rbp)
  1c0f9e:	88 45 e4             	mov    %al,-0x1c(%rbp)
    console_printer* cp = (console_printer*) p;
  1c0fa1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c0fa5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1c0fa9:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c0fad:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0fb1:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
  1c0fb6:	48 39 d0             	cmp    %rdx,%rax
  1c0fb9:	72 0c                	jb     1c0fc7 <console_putc+0x3a>
        cp->cursor = console;
  1c0fbb:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c0fbf:	48 c7 40 08 00 80 0b 	movq   $0xb8000,0x8(%rax)
  1c0fc6:	00 
    }
    if (c == '\n') {
  1c0fc7:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%rbp)
  1c0fcb:	75 78                	jne    1c1045 <console_putc+0xb8>
        int pos = (cp->cursor - console) % 80;
  1c0fcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c0fd1:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c0fd5:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1c0fdb:	48 d1 f8             	sar    %rax
  1c0fde:	48 89 c1             	mov    %rax,%rcx
  1c0fe1:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1c0fe8:	66 66 66 
  1c0feb:	48 89 c8             	mov    %rcx,%rax
  1c0fee:	48 f7 ea             	imul   %rdx
  1c0ff1:	48 c1 fa 05          	sar    $0x5,%rdx
  1c0ff5:	48 89 c8             	mov    %rcx,%rax
  1c0ff8:	48 c1 f8 3f          	sar    $0x3f,%rax
  1c0ffc:	48 29 c2             	sub    %rax,%rdx
  1c0fff:	48 89 d0             	mov    %rdx,%rax
  1c1002:	48 c1 e0 02          	shl    $0x2,%rax
  1c1006:	48 01 d0             	add    %rdx,%rax
  1c1009:	48 c1 e0 04          	shl    $0x4,%rax
  1c100d:	48 29 c1             	sub    %rax,%rcx
  1c1010:	48 89 ca             	mov    %rcx,%rdx
  1c1013:	89 55 fc             	mov    %edx,-0x4(%rbp)
        for (; pos != 80; pos++) {
  1c1016:	eb 25                	jmp    1c103d <console_putc+0xb0>
            *cp->cursor++ = ' ' | color;
  1c1018:	8b 45 e0             	mov    -0x20(%rbp),%eax
  1c101b:	83 c8 20             	or     $0x20,%eax
  1c101e:	89 c6                	mov    %eax,%esi
  1c1020:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c1024:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c1028:	48 8d 48 02          	lea    0x2(%rax),%rcx
  1c102c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  1c1030:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c1034:	89 f2                	mov    %esi,%edx
  1c1036:	66 89 10             	mov    %dx,(%rax)
        for (; pos != 80; pos++) {
  1c1039:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  1c103d:	83 7d fc 50          	cmpl   $0x50,-0x4(%rbp)
  1c1041:	75 d5                	jne    1c1018 <console_putc+0x8b>
        }
    } else {
        *cp->cursor++ = c | color;
    }
}
  1c1043:	eb 24                	jmp    1c1069 <console_putc+0xdc>
        *cp->cursor++ = c | color;
  1c1045:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
  1c1049:	8b 55 e0             	mov    -0x20(%rbp),%edx
  1c104c:	09 d0                	or     %edx,%eax
  1c104e:	89 c6                	mov    %eax,%esi
  1c1050:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c1054:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c1058:	48 8d 48 02          	lea    0x2(%rax),%rcx
  1c105c:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  1c1060:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c1064:	89 f2                	mov    %esi,%edx
  1c1066:	66 89 10             	mov    %dx,(%rax)
}
  1c1069:	90                   	nop
  1c106a:	c9                   	leave
  1c106b:	c3                   	ret

00000000001c106c <console_vprintf>:

int console_vprintf(int cpos, int color, const char* format, va_list val) {
  1c106c:	55                   	push   %rbp
  1c106d:	48 89 e5             	mov    %rsp,%rbp
  1c1070:	48 83 ec 30          	sub    $0x30,%rsp
  1c1074:	89 7d ec             	mov    %edi,-0x14(%rbp)
  1c1077:	89 75 e8             	mov    %esi,-0x18(%rbp)
  1c107a:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  1c107e:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
    struct console_printer cp;
    cp.p.putc = console_putc;
  1c1082:	48 c7 45 f0 8d 0f 1c 	movq   $0x1c0f8d,-0x10(%rbp)
  1c1089:	00 
    if (cpos < 0 || cpos >= CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1c108a:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  1c108e:	78 09                	js     1c1099 <console_vprintf+0x2d>
  1c1090:	81 7d ec cf 07 00 00 	cmpl   $0x7cf,-0x14(%rbp)
  1c1097:	7e 07                	jle    1c10a0 <console_vprintf+0x34>
        cpos = 0;
  1c1099:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
    cp.cursor = console + cpos;
  1c10a0:	8b 45 ec             	mov    -0x14(%rbp),%eax
  1c10a3:	48 98                	cltq
  1c10a5:	48 01 c0             	add    %rax,%rax
  1c10a8:	48 05 00 80 0b 00    	add    $0xb8000,%rax
  1c10ae:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1c10b2:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  1c10b6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  1c10ba:	8b 75 e8             	mov    -0x18(%rbp),%esi
  1c10bd:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  1c10c1:	48 89 c7             	mov    %rax,%rdi
  1c10c4:	e8 f4 f4 ff ff       	call   1c05bd <printer_vprintf>
    return cp.cursor - console;
  1c10c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c10cd:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1c10d3:	48 d1 f8             	sar    %rax
}
  1c10d6:	c9                   	leave
  1c10d7:	c3                   	ret

00000000001c10d8 <console_printf>:

int console_printf(int cpos, int color, const char* format, ...) {
  1c10d8:	55                   	push   %rbp
  1c10d9:	48 89 e5             	mov    %rsp,%rbp
  1c10dc:	48 83 ec 60          	sub    $0x60,%rsp
  1c10e0:	89 7d ac             	mov    %edi,-0x54(%rbp)
  1c10e3:	89 75 a8             	mov    %esi,-0x58(%rbp)
  1c10e6:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  1c10ea:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c10ee:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c10f2:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  1c10f6:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1c10fd:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c1101:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1c1105:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c1109:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1c110d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1c1111:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  1c1115:	8b 75 a8             	mov    -0x58(%rbp),%esi
  1c1118:	8b 45 ac             	mov    -0x54(%rbp),%eax
  1c111b:	89 c7                	mov    %eax,%edi
  1c111d:	e8 4a ff ff ff       	call   1c106c <console_vprintf>
  1c1122:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
  1c1125:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
  1c1128:	c9                   	leave
  1c1129:	c3                   	ret

00000000001c112a <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  1c112a:	55                   	push   %rbp
  1c112b:	48 89 e5             	mov    %rsp,%rbp
  1c112e:	48 83 ec 20          	sub    $0x20,%rsp
  1c1132:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  1c1136:	89 f0                	mov    %esi,%eax
  1c1138:	89 55 e0             	mov    %edx,-0x20(%rbp)
  1c113b:	88 45 e4             	mov    %al,-0x1c(%rbp)
    string_printer* sp = (string_printer*) p;
  1c113e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  1c1142:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (sp->s < sp->end) {
  1c1146:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c114a:	48 8b 50 08          	mov    0x8(%rax),%rdx
  1c114e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c1152:	48 8b 40 10          	mov    0x10(%rax),%rax
  1c1156:	48 39 c2             	cmp    %rax,%rdx
  1c1159:	73 1a                	jae    1c1175 <string_putc+0x4b>
        *sp->s++ = c;
  1c115b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1c115f:	48 8b 40 08          	mov    0x8(%rax),%rax
  1c1163:	48 8d 48 01          	lea    0x1(%rax),%rcx
  1c1167:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  1c116b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  1c116f:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
  1c1173:	88 10                	mov    %dl,(%rax)
    }
    (void) color;
}
  1c1175:	90                   	nop
  1c1176:	c9                   	leave
  1c1177:	c3                   	ret

00000000001c1178 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  1c1178:	55                   	push   %rbp
  1c1179:	48 89 e5             	mov    %rsp,%rbp
  1c117c:	48 83 ec 40          	sub    $0x40,%rsp
  1c1180:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  1c1184:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  1c1188:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  1c118c:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    string_printer sp;
    sp.p.putc = string_putc;
  1c1190:	48 c7 45 e8 2a 11 1c 	movq   $0x1c112a,-0x18(%rbp)
  1c1197:	00 
    sp.s = s;
  1c1198:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c119c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (size) {
  1c11a0:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  1c11a5:	74 33                	je     1c11da <vsnprintf+0x62>
        sp.end = s + size - 1;
  1c11a7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  1c11ab:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  1c11af:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  1c11b3:	48 01 d0             	add    %rdx,%rax
  1c11b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  1c11ba:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  1c11be:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  1c11c2:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  1c11c6:	be 00 00 00 00       	mov    $0x0,%esi
  1c11cb:	48 89 c7             	mov    %rax,%rdi
  1c11ce:	e8 ea f3 ff ff       	call   1c05bd <printer_vprintf>
        *sp.s = 0;
  1c11d3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c11d7:	c6 00 00             	movb   $0x0,(%rax)
    }
    return sp.s - s;
  1c11da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  1c11de:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
}
  1c11e2:	c9                   	leave
  1c11e3:	c3                   	ret

00000000001c11e4 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  1c11e4:	55                   	push   %rbp
  1c11e5:	48 89 e5             	mov    %rsp,%rbp
  1c11e8:	48 83 ec 70          	sub    $0x70,%rsp
  1c11ec:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  1c11f0:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  1c11f4:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  1c11f8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1c11fc:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1c1200:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  1c1204:	c7 45 b0 18 00 00 00 	movl   $0x18,-0x50(%rbp)
  1c120b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1c120f:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  1c1213:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1c1217:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    int n = vsnprintf(s, size, format, val);
  1c121b:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  1c121f:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  1c1223:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  1c1227:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  1c122b:	48 89 c7             	mov    %rax,%rdi
  1c122e:	e8 45 ff ff ff       	call   1c1178 <vsnprintf>
  1c1233:	89 45 cc             	mov    %eax,-0x34(%rbp)
    va_end(val);
    return n;
  1c1236:	8b 45 cc             	mov    -0x34(%rbp),%eax
}
  1c1239:	c9                   	leave
  1c123a:	c3                   	ret

00000000001c123b <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  1c123b:	55                   	push   %rbp
  1c123c:	48 89 e5             	mov    %rsp,%rbp
  1c123f:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1c1243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  1c124a:	eb 13                	jmp    1c125f <console_clear+0x24>
        console[i] = ' ' | 0x0700;
  1c124c:	8b 45 fc             	mov    -0x4(%rbp),%eax
  1c124f:	48 98                	cltq
  1c1251:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%rax,%rax,1)
  1c1258:	00 20 07 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  1c125b:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  1c125f:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
  1c1266:	7e e4                	jle    1c124c <console_clear+0x11>
    }
    cursorpos = 0;
  1c1268:	c7 05 8a 7d ef ff 00 	movl   $0x0,-0x108276(%rip)        # b8ffc <cursorpos>
  1c126f:	00 00 00 
}
  1c1272:	90                   	nop
  1c1273:	c9                   	leave
  1c1274:	c3                   	ret
