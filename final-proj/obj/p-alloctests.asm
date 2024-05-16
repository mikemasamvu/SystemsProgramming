
obj/p-alloctests.full:     file format elf64-x86-64


Disassembly of section .text:

00000000002c0000 <process_main>:
#include "time.h"
#include "malloc.h"

extern uint8_t end[];

void process_main(void) {
  2c0000:	55                   	push   %rbp
  2c0001:	48 89 e5             	mov    %rsp,%rbp
  2c0004:	41 56                	push   %r14
  2c0006:	41 55                	push   %r13
  2c0008:	41 54                	push   %r12
  2c000a:	53                   	push   %rbx
  2c000b:	48 83 ec 20          	sub    $0x20,%rsp

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  2c000f:	cd 31                	int    $0x31
  2c0011:	41 89 c4             	mov    %eax,%r12d
    
    pid_t p = getpid();
    srand(p);
  2c0014:	89 c7                	mov    %eax,%edi
  2c0016:	e8 c3 0a 00 00       	call   2c0ade <srand>

    // alloc int array of 10 elements
    int* array = (int *)malloc(sizeof(int) * 10);
  2c001b:	bf 28 00 00 00       	mov    $0x28,%edi
  2c0020:	e8 fb 02 00 00       	call   2c0320 <malloc>
  2c0025:	48 89 c7             	mov    %rax,%rdi
  2c0028:	ba 00 00 00 00       	mov    $0x0,%edx
    
    // set array elements
    for(int  i = 0 ; i < 10; i++){
	array[i] = i;
  2c002d:	89 14 97             	mov    %edx,(%rdi,%rdx,4)
    for(int  i = 0 ; i < 10; i++){
  2c0030:	48 83 c2 01          	add    $0x1,%rdx
  2c0034:	48 83 fa 0a          	cmp    $0xa,%rdx
  2c0038:	75 f3                	jne    2c002d <process_main+0x2d>
    }

    // realloc array to size 20
    array = (int*)realloc(array, sizeof(int) * 20);
  2c003a:	be 50 00 00 00       	mov    $0x50,%esi
  2c003f:	e8 4d 04 00 00       	call   2c0491 <realloc>
  2c0044:	49 89 c5             	mov    %rax,%r13
  2c0047:	b8 00 00 00 00       	mov    $0x0,%eax

    // check if contents are same
    for(int i = 0 ; i < 10 ; i++){
	assert(array[i] == i);
  2c004c:	41 39 44 85 00       	cmp    %eax,0x0(%r13,%rax,4)
  2c0051:	75 64                	jne    2c00b7 <process_main+0xb7>
    for(int i = 0 ; i < 10 ; i++){
  2c0053:	48 83 c0 01          	add    $0x1,%rax
  2c0057:	48 83 f8 0a          	cmp    $0xa,%rax
  2c005b:	75 ef                	jne    2c004c <process_main+0x4c>
    }

    // alloc int array of size 30 using calloc
    int * array2 = (int *)calloc(30, sizeof(int));
  2c005d:	be 04 00 00 00       	mov    $0x4,%esi
  2c0062:	bf 1e 00 00 00       	mov    $0x1e,%edi
  2c0067:	e8 cb 03 00 00       	call   2c0437 <calloc>
  2c006c:	49 89 c6             	mov    %rax,%r14

    // assert array[i] == 0
    for(int i = 0 ; i < 30; i++){
  2c006f:	48 8d 50 78          	lea    0x78(%rax),%rdx
	assert(array2[i] == 0);
  2c0073:	8b 18                	mov    (%rax),%ebx
  2c0075:	85 db                	test   %ebx,%ebx
  2c0077:	75 52                	jne    2c00cb <process_main+0xcb>
    for(int i = 0 ; i < 30; i++){
  2c0079:	48 83 c0 04          	add    $0x4,%rax
  2c007d:	48 39 d0             	cmp    %rdx,%rax
  2c0080:	75 f1                	jne    2c0073 <process_main+0x73>
    }
    
    heap_info_struct info;
    if(heap_info(&info) == 0){
  2c0082:	48 8d 7d c0          	lea    -0x40(%rbp),%rdi
  2c0086:	e8 fb 05 00 00       	call   2c0686 <heap_info>
  2c008b:	85 c0                	test   %eax,%eax
  2c008d:	75 64                	jne    2c00f3 <process_main+0xf3>
	// check if allocations are in sorted order
	for(int  i = 1 ; i < info.num_allocs; i++){
  2c008f:	8b 55 c0             	mov    -0x40(%rbp),%edx
  2c0092:	83 fa 01             	cmp    $0x1,%edx
  2c0095:	7e 70                	jle    2c0107 <process_main+0x107>
  2c0097:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  2c009b:	8d 52 fe             	lea    -0x2(%rdx),%edx
  2c009e:	48 8d 54 d0 08       	lea    0x8(%rax,%rdx,8),%rdx
	    assert(info.size_array[i] < info.size_array[i-1]);
  2c00a3:	48 8b 30             	mov    (%rax),%rsi
  2c00a6:	48 39 70 08          	cmp    %rsi,0x8(%rax)
  2c00aa:	7d 33                	jge    2c00df <process_main+0xdf>
	for(int  i = 1 ; i < info.num_allocs; i++){
  2c00ac:	48 83 c0 08          	add    $0x8,%rax
  2c00b0:	48 39 d0             	cmp    %rdx,%rax
  2c00b3:	75 ee                	jne    2c00a3 <process_main+0xa3>
  2c00b5:	eb 50                	jmp    2c0107 <process_main+0x107>
	assert(array[i] == i);
  2c00b7:	ba 40 18 2c 00       	mov    $0x2c1840,%edx
  2c00bc:	be 19 00 00 00       	mov    $0x19,%esi
  2c00c1:	bf 4e 18 2c 00       	mov    $0x2c184e,%edi
  2c00c6:	e8 13 02 00 00       	call   2c02de <assert_fail>
	assert(array2[i] == 0);
  2c00cb:	ba 64 18 2c 00       	mov    $0x2c1864,%edx
  2c00d0:	be 21 00 00 00       	mov    $0x21,%esi
  2c00d5:	bf 4e 18 2c 00       	mov    $0x2c184e,%edi
  2c00da:	e8 ff 01 00 00       	call   2c02de <assert_fail>
	    assert(info.size_array[i] < info.size_array[i-1]);
  2c00df:	ba 88 18 2c 00       	mov    $0x2c1888,%edx
  2c00e4:	be 28 00 00 00       	mov    $0x28,%esi
  2c00e9:	bf 4e 18 2c 00       	mov    $0x2c184e,%edi
  2c00ee:	e8 eb 01 00 00       	call   2c02de <assert_fail>
	}
    }
    else{
	app_printf(0, "heap_info failed\n");
  2c00f3:	be 73 18 2c 00       	mov    $0x2c1873,%esi
  2c00f8:	bf 00 00 00 00       	mov    $0x0,%edi
  2c00fd:	b8 00 00 00 00       	mov    $0x0,%eax
  2c0102:	e8 79 00 00 00       	call   2c0180 <app_printf>
    }
    
    // free array, array2
    free(array);
  2c0107:	4c 89 ef             	mov    %r13,%rdi
  2c010a:	e8 fe 01 00 00       	call   2c030d <free>
    free(array2);
  2c010f:	4c 89 f7             	mov    %r14,%rdi
  2c0112:	e8 f6 01 00 00       	call   2c030d <free>

    uint64_t total_time = 0;
  2c0117:	41 bd 00 00 00 00    	mov    $0x0,%r13d
/* rdtscp */
static uint64_t rdtsc(void) {
	uint64_t var;
	uint32_t hi, lo;

	__asm volatile
  2c011d:	0f 31                	rdtsc
	    ("rdtsc" : "=a" (lo), "=d" (hi));

	var = ((uint64_t)hi << 32) | lo;
  2c011f:	48 c1 e2 20          	shl    $0x20,%rdx
  2c0123:	89 c0                	mov    %eax,%eax
  2c0125:	48 09 c2             	or     %rax,%rdx
  2c0128:	49 89 d6             	mov    %rdx,%r14
    int total_pages = 0;
    
    // allocate pages till no more memory
    while (1) {
	uint64_t time = rdtsc();
	void * ptr = malloc(PAGESIZE);
  2c012b:	bf 00 10 00 00       	mov    $0x1000,%edi
  2c0130:	e8 eb 01 00 00       	call   2c0320 <malloc>
  2c0135:	48 89 c1             	mov    %rax,%rcx
	__asm volatile
  2c0138:	0f 31                	rdtsc
	var = ((uint64_t)hi << 32) | lo;
  2c013a:	48 c1 e2 20          	shl    $0x20,%rdx
  2c013e:	89 c0                	mov    %eax,%eax
  2c0140:	48 09 c2             	or     %rax,%rdx
	total_time += (rdtsc() - time);
  2c0143:	4c 29 f2             	sub    %r14,%rdx
  2c0146:	49 01 d5             	add    %rdx,%r13
	if(ptr == NULL)
  2c0149:	48 85 c9             	test   %rcx,%rcx
  2c014c:	74 08                	je     2c0156 <process_main+0x156>
	    break;
	total_pages++;
  2c014e:	83 c3 01             	add    $0x1,%ebx
	*((int *)ptr) = p; // check write access
  2c0151:	44 89 21             	mov    %r12d,(%rcx)
    while (1) {
  2c0154:	eb c7                	jmp    2c011d <process_main+0x11d>
    }

    app_printf(p, "Total_time taken to alloc: %d Average time: %d\n", total_time, total_time/total_pages);
  2c0156:	48 63 db             	movslq %ebx,%rbx
  2c0159:	4c 89 e8             	mov    %r13,%rax
  2c015c:	ba 00 00 00 00       	mov    $0x0,%edx
  2c0161:	48 f7 f3             	div    %rbx
  2c0164:	48 89 c1             	mov    %rax,%rcx
  2c0167:	4c 89 ea             	mov    %r13,%rdx
  2c016a:	be b8 18 2c 00       	mov    $0x2c18b8,%esi
  2c016f:	44 89 e7             	mov    %r12d,%edi
  2c0172:	b8 00 00 00 00       	mov    $0x0,%eax
  2c0177:	e8 04 00 00 00       	call   2c0180 <app_printf>

// yield
//    Yield control of the CPU to the kernel. The kernel will pick another
//    process to run, if possible.
static inline void yield(void) {
    asm volatile ("int %0" : /* no result */
  2c017c:	cd 32                	int    $0x32

    // After running out of memory
    while (1) {
  2c017e:	eb fc                	jmp    2c017c <process_main+0x17c>

00000000002c0180 <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  2c0180:	55                   	push   %rbp
  2c0181:	48 89 e5             	mov    %rsp,%rbp
  2c0184:	48 83 ec 50          	sub    $0x50,%rsp
  2c0188:	49 89 f2             	mov    %rsi,%r10
  2c018b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  2c018f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  2c0193:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  2c0197:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  2c019b:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  2c01a0:	85 ff                	test   %edi,%edi
  2c01a2:	78 2e                	js     2c01d2 <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  2c01a4:	48 63 ff             	movslq %edi,%rdi
  2c01a7:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  2c01ae:	cc cc cc 
  2c01b1:	48 89 f8             	mov    %rdi,%rax
  2c01b4:	48 f7 e2             	mul    %rdx
  2c01b7:	48 89 d0             	mov    %rdx,%rax
  2c01ba:	48 c1 e8 02          	shr    $0x2,%rax
  2c01be:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  2c01c2:	48 01 c2             	add    %rax,%rdx
  2c01c5:	48 29 d7             	sub    %rdx,%rdi
  2c01c8:	0f b6 b7 1d 19 2c 00 	movzbl 0x2c191d(%rdi),%esi
  2c01cf:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  2c01d2:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  2c01d9:	48 8d 45 10          	lea    0x10(%rbp),%rax
  2c01dd:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  2c01e1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  2c01e5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  2c01e9:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  2c01ed:	4c 89 d2             	mov    %r10,%rdx
  2c01f0:	8b 3d 06 8e df ff    	mov    -0x2071fa(%rip),%edi        # b8ffc <cursorpos>
  2c01f6:	e8 35 14 00 00       	call   2c1630 <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  2c01fb:	3d 30 07 00 00       	cmp    $0x730,%eax
  2c0200:	ba 00 00 00 00       	mov    $0x0,%edx
  2c0205:	0f 4d c2             	cmovge %edx,%eax
  2c0208:	89 05 ee 8d df ff    	mov    %eax,-0x207212(%rip)        # b8ffc <cursorpos>
    }
}
  2c020e:	c9                   	leave
  2c020f:	c3                   	ret

00000000002c0210 <kernel_panic>:


// kernel_panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void kernel_panic(const char* format, ...) {
  2c0210:	55                   	push   %rbp
  2c0211:	48 89 e5             	mov    %rsp,%rbp
  2c0214:	53                   	push   %rbx
  2c0215:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  2c021c:	48 89 fb             	mov    %rdi,%rbx
  2c021f:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  2c0223:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  2c0227:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  2c022b:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  2c022f:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  2c0233:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  2c023a:	48 8d 45 10          	lea    0x10(%rbp),%rax
  2c023e:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  2c0242:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  2c0246:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  2c024a:	ba 07 00 00 00       	mov    $0x7,%edx
  2c024f:	be e8 18 2c 00       	mov    $0x2c18e8,%esi
  2c0254:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  2c025b:	e8 87 05 00 00       	call   2c07e7 <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  2c0260:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  2c0264:	48 89 da             	mov    %rbx,%rdx
  2c0267:	be 99 00 00 00       	mov    $0x99,%esi
  2c026c:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  2c0273:	e8 c4 14 00 00       	call   2c173c <vsnprintf>
  2c0278:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  2c027b:	85 d2                	test   %edx,%edx
  2c027d:	7e 0f                	jle    2c028e <kernel_panic+0x7e>
  2c027f:	83 c0 06             	add    $0x6,%eax
  2c0282:	48 98                	cltq
  2c0284:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  2c028b:	0a 
  2c028c:	75 2a                	jne    2c02b8 <kernel_panic+0xa8>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  2c028e:	48 8d 9d 08 ff ff ff 	lea    -0xf8(%rbp),%rbx
  2c0295:	48 89 d9             	mov    %rbx,%rcx
  2c0298:	ba f0 18 2c 00       	mov    $0x2c18f0,%edx
  2c029d:	be 00 c0 00 00       	mov    $0xc000,%esi
  2c02a2:	bf 30 07 00 00       	mov    $0x730,%edi
  2c02a7:	b8 00 00 00 00       	mov    $0x0,%eax
  2c02ac:	e8 eb 13 00 00       	call   2c169c <console_printf>
}

// panic(msg)
//    Panic.
static inline pid_t __attribute__((noreturn)) panic(const char* msg) {
    asm volatile ("int %0" : /* no result */
  2c02b1:	48 89 df             	mov    %rbx,%rdi
  2c02b4:	cd 30                	int    $0x30
                  : "i" (INT_SYS_PANIC), "D" (msg)
                  : "cc", "memory");
 loop: goto loop;
  2c02b6:	eb fe                	jmp    2c02b6 <kernel_panic+0xa6>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  2c02b8:	48 63 c2             	movslq %edx,%rax
  2c02bb:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  2c02c1:	0f 94 c2             	sete   %dl
  2c02c4:	0f b6 d2             	movzbl %dl,%edx
  2c02c7:	48 29 d0             	sub    %rdx,%rax
  2c02ca:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  2c02d1:	ff 
  2c02d2:	be 83 18 2c 00       	mov    $0x2c1883,%esi
  2c02d7:	e8 b8 06 00 00       	call   2c0994 <strcpy>
  2c02dc:	eb b0                	jmp    2c028e <kernel_panic+0x7e>

00000000002c02de <assert_fail>:
    panic(buf);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  2c02de:	55                   	push   %rbp
  2c02df:	48 89 e5             	mov    %rsp,%rbp
  2c02e2:	48 89 f9             	mov    %rdi,%rcx
  2c02e5:	41 89 f0             	mov    %esi,%r8d
  2c02e8:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  2c02eb:	ba f8 18 2c 00       	mov    $0x2c18f8,%edx
  2c02f0:	be 00 c0 00 00       	mov    $0xc000,%esi
  2c02f5:	bf 30 07 00 00       	mov    $0x730,%edi
  2c02fa:	b8 00 00 00 00       	mov    $0x0,%eax
  2c02ff:	e8 98 13 00 00       	call   2c169c <console_printf>
    asm volatile ("int %0" : /* no result */
  2c0304:	bf 00 00 00 00       	mov    $0x0,%edi
  2c0309:	cd 30                	int    $0x30
 loop: goto loop;
  2c030b:	eb fe                	jmp    2c030b <assert_fail+0x2d>

00000000002c030d <free>:
static block_header* head = NULL;
static block_header* heap_start = NULL;
static block_header* heap_end = NULL;

void free(void *firstbyte) {
    if (firstbyte == NULL) {
  2c030d:	48 85 ff             	test   %rdi,%rdi
  2c0310:	74 0d                	je     2c031f <free+0x12>
        return; 
    }

    block_header *header = (block_header *)((char *)firstbyte - sizeof(block_header));
    
    if (header->is_free == 1) {
  2c0312:	83 7f f8 01          	cmpl   $0x1,-0x8(%rdi)
  2c0316:	74 07                	je     2c031f <free+0x12>
        return; 
    }
    header->is_free = 1;
  2c0318:	c7 47 f8 01 00 00 00 	movl   $0x1,-0x8(%rdi)
}
  2c031f:	c3                   	ret

00000000002c0320 <malloc>:

void *malloc(uint64_t numbytes) {
    if (numbytes == 0) {
  2c0320:	48 85 ff             	test   %rdi,%rdi
  2c0323:	0f 84 02 01 00 00    	je     2c042b <malloc+0x10b>
        return NULL;
    }

    numbytes = (numbytes + sizeof(block_header) + sizeof(block_footer) + 7) & ~7; 
  2c0329:	48 8d 4f 27          	lea    0x27(%rdi),%rcx
  2c032d:	48 83 e1 f8          	and    $0xfffffffffffffff8,%rcx

    if (heap_start == NULL) {
  2c0331:	48 83 3d d7 1c 00 00 	cmpq   $0x0,0x1cd7(%rip)        # 2c2010 <heap_start>
  2c0338:	00 
  2c0339:	74 1e                	je     2c0359 <malloc+0x39>
        heap_start = (block_header *)sbrk(0);
        heap_end = heap_start;
        head = heap_start; 
    }

    block_header *current = head; 
  2c033b:	48 8b 05 d6 1c 00 00 	mov    0x1cd6(%rip),%rax        # 2c2018 <head>
    block_header *prev = NULL;

    while (current != NULL && current < heap_end) {
  2c0342:	48 85 c0             	test   %rax,%rax
  2c0345:	0f 84 9c 00 00 00    	je     2c03e7 <malloc+0xc7>
  2c034b:	48 8b 3d b6 1c 00 00 	mov    0x1cb6(%rip),%rdi        # 2c2008 <heap_end>
    block_header *prev = NULL;
  2c0352:	be 00 00 00 00       	mov    $0x0,%esi
  2c0357:	eb 3d                	jmp    2c0396 <malloc+0x76>
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  2c0359:	bf 00 00 00 00       	mov    $0x0,%edi
  2c035e:	cd 3a                	int    $0x3a
  2c0360:	48 89 05 99 1c 00 00 	mov    %rax,0x1c99(%rip)        # 2c2000 <result.0>
        heap_start = (block_header *)sbrk(0);
  2c0367:	48 89 05 a2 1c 00 00 	mov    %rax,0x1ca2(%rip)        # 2c2010 <heap_start>
        heap_end = heap_start;
  2c036e:	48 89 05 93 1c 00 00 	mov    %rax,0x1c93(%rip)        # 2c2008 <heap_end>
        head = heap_start; 
  2c0375:	48 89 05 9c 1c 00 00 	mov    %rax,0x1c9c(%rip)        # 2c2018 <head>
  2c037c:	eb bd                	jmp    2c033b <malloc+0x1b>
                current->next = new_blk;

                block_footer *new_footer = (block_footer *)((char *)new_blk + new_blk->size - sizeof(block_footer));
                new_footer->size = new_blk->size;
            } else {
                current->is_free = 0; 
  2c037e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%rax)
  2c0385:	eb 53                	jmp    2c03da <malloc+0xba>
            footer->size = current->size;

            return (void *)((char *)current + sizeof(block_header));
        }
        prev = current;
        current = current->next;
  2c0387:	48 8b 50 08          	mov    0x8(%rax),%rdx
    while (current != NULL && current < heap_end) {
  2c038b:	48 89 c6             	mov    %rax,%rsi
  2c038e:	48 85 d2             	test   %rdx,%rdx
  2c0391:	74 57                	je     2c03ea <malloc+0xca>
  2c0393:	48 89 d0             	mov    %rdx,%rax
  2c0396:	48 39 f8             	cmp    %rdi,%rax
  2c0399:	73 4f                	jae    2c03ea <malloc+0xca>
        if (current->is_free && current->size >= numbytes) {
  2c039b:	83 78 10 00          	cmpl   $0x0,0x10(%rax)
  2c039f:	74 e6                	je     2c0387 <malloc+0x67>
  2c03a1:	48 8b 10             	mov    (%rax),%rdx
  2c03a4:	48 39 ca             	cmp    %rcx,%rdx
  2c03a7:	72 de                	jb     2c0387 <malloc+0x67>
            if (current->size >= numbytes + sizeof(block_header) + sizeof(block_footer) + 8) {
  2c03a9:	48 8d 71 28          	lea    0x28(%rcx),%rsi
  2c03ad:	48 39 f2             	cmp    %rsi,%rdx
  2c03b0:	72 cc                	jb     2c037e <malloc+0x5e>
                current->size = numbytes;
  2c03b2:	48 89 08             	mov    %rcx,(%rax)
                block_header *new_blk = (block_header *)((char *)current + numbytes);
  2c03b5:	48 8d 34 08          	lea    (%rax,%rcx,1),%rsi
                new_blk->size = original_size - numbytes;
  2c03b9:	48 29 ca             	sub    %rcx,%rdx
  2c03bc:	48 89 16             	mov    %rdx,(%rsi)
                new_blk->is_free = 1;
  2c03bf:	c7 46 10 01 00 00 00 	movl   $0x1,0x10(%rsi)
                new_blk->next = current->next;
  2c03c6:	48 8b 50 08          	mov    0x8(%rax),%rdx
  2c03ca:	48 89 56 08          	mov    %rdx,0x8(%rsi)
                current->next = new_blk;
  2c03ce:	48 89 70 08          	mov    %rsi,0x8(%rax)
                block_footer *new_footer = (block_footer *)((char *)new_blk + new_blk->size - sizeof(block_footer));
  2c03d2:	48 8b 16             	mov    (%rsi),%rdx
                new_footer->size = new_blk->size;
  2c03d5:	48 89 54 16 f8       	mov    %rdx,-0x8(%rsi,%rdx,1)
            block_footer *footer = (block_footer *)((char *)current + current->size - sizeof(block_footer));
  2c03da:	48 8b 10             	mov    (%rax),%rdx
            footer->size = current->size;
  2c03dd:	48 89 54 10 f8       	mov    %rdx,-0x8(%rax,%rdx,1)
            return (void *)((char *)current + sizeof(block_header));
  2c03e2:	48 83 c0 18          	add    $0x18,%rax
  2c03e6:	c3                   	ret
    block_header *prev = NULL;
  2c03e7:	48 89 c6             	mov    %rax,%rsi
  2c03ea:	48 89 cf             	mov    %rcx,%rdi
  2c03ed:	cd 3a                	int    $0x3a
  2c03ef:	48 89 05 0a 1c 00 00 	mov    %rax,0x1c0a(%rip)        # 2c2000 <result.0>
    }

    block_header *new_block = (block_header *)sbrk(numbytes);
    if (new_block == (void *)-1) {
  2c03f6:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  2c03fa:	74 35                	je     2c0431 <malloc+0x111>
        return NULL; 
    }
    new_block->size = numbytes;
  2c03fc:	48 89 08             	mov    %rcx,(%rax)
    new_block->is_free = 0;
  2c03ff:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%rax)
    new_block->next = NULL;
  2c0406:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
  2c040d:	00 

    if (prev) {
  2c040e:	48 85 f6             	test   %rsi,%rsi
  2c0411:	74 04                	je     2c0417 <malloc+0xf7>
        prev->next = new_block; 
  2c0413:	48 89 46 08          	mov    %rax,0x8(%rsi)
    }

    block_footer *footer = (block_footer *)((char *)new_block + numbytes - sizeof(block_footer));
    footer->size = numbytes;
  2c0417:	48 89 4c 01 f8       	mov    %rcx,-0x8(%rcx,%rax,1)
    heap_end = (block_header *)((char *)new_block + numbytes);
  2c041c:	48 01 c1             	add    %rax,%rcx
  2c041f:	48 89 0d e2 1b 00 00 	mov    %rcx,0x1be2(%rip)        # 2c2008 <heap_end>
    return (void *)((char *)new_block + sizeof(block_header));
  2c0426:	48 83 c0 18          	add    $0x18,%rax
  2c042a:	c3                   	ret
        return NULL;
  2c042b:	b8 00 00 00 00       	mov    $0x0,%eax
  2c0430:	c3                   	ret
        return NULL; 
  2c0431:	b8 00 00 00 00       	mov    $0x0,%eax
}
  2c0436:	c3                   	ret

00000000002c0437 <calloc>:

void *calloc(uint64_t num, uint64_t sz) {
  2c0437:	55                   	push   %rbp
  2c0438:	48 89 e5             	mov    %rsp,%rbp
  2c043b:	41 54                	push   %r12
  2c043d:	53                   	push   %rbx
    if (sz && num > UINT64_MAX / sz) {
  2c043e:	48 85 f6             	test   %rsi,%rsi
  2c0441:	74 3e                	je     2c0481 <calloc+0x4a>
  2c0443:	48 89 f0             	mov    %rsi,%rax
  2c0446:	48 f7 e7             	mul    %rdi
  2c0449:	70 3e                	jo     2c0489 <calloc+0x52>
        return NULL; 
    }

    uint64_t total_size = num * sz;
  2c044b:	48 89 c3             	mov    %rax,%rbx
    if (total_size == 0) {
        return NULL; 
  2c044e:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    if (total_size == 0) {
  2c0454:	48 85 c0             	test   %rax,%rax
  2c0457:	74 20                	je     2c0479 <calloc+0x42>
    }

    void *ptr = malloc(total_size);
  2c0459:	48 89 c7             	mov    %rax,%rdi
  2c045c:	e8 bf fe ff ff       	call   2c0320 <malloc>
  2c0461:	49 89 c4             	mov    %rax,%r12
    if (ptr == NULL) {
  2c0464:	48 85 c0             	test   %rax,%rax
  2c0467:	74 10                	je     2c0479 <calloc+0x42>
        return NULL;
    }

    memset(ptr, 0, total_size);
  2c0469:	48 89 da             	mov    %rbx,%rdx
  2c046c:	be 00 00 00 00       	mov    $0x0,%esi
  2c0471:	48 89 c7             	mov    %rax,%rdi
  2c0474:	e8 6c 04 00 00       	call   2c08e5 <memset>
    return ptr;
}
  2c0479:	4c 89 e0             	mov    %r12,%rax
  2c047c:	5b                   	pop    %rbx
  2c047d:	41 5c                	pop    %r12
  2c047f:	5d                   	pop    %rbp
  2c0480:	c3                   	ret
        return NULL; 
  2c0481:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  2c0487:	eb f0                	jmp    2c0479 <calloc+0x42>
        return NULL; 
  2c0489:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  2c048f:	eb e8                	jmp    2c0479 <calloc+0x42>

00000000002c0491 <realloc>:

void *realloc(void *ptr, uint64_t sz) {
  2c0491:	55                   	push   %rbp
  2c0492:	48 89 e5             	mov    %rsp,%rbp
  2c0495:	41 56                	push   %r14
  2c0497:	41 55                	push   %r13
  2c0499:	41 54                	push   %r12
  2c049b:	53                   	push   %rbx
  2c049c:	48 89 f3             	mov    %rsi,%rbx
    if (ptr == NULL) {
  2c049f:	48 85 ff             	test   %rdi,%rdi
  2c04a2:	74 51                	je     2c04f5 <realloc+0x64>
  2c04a4:	49 89 fc             	mov    %rdi,%r12
        return malloc(sz);
    }

    if (sz == 0) {
  2c04a7:	48 85 f6             	test   %rsi,%rsi
  2c04aa:	74 56                	je     2c0502 <realloc+0x71>
        free(ptr);
        return NULL;
    }

    block_header *header = (block_header *)((char *)ptr - sizeof(block_header));
    uint64_t current_size = header->size - sizeof(block_header) - sizeof(block_footer);
  2c04ac:	48 8b 47 e8          	mov    -0x18(%rdi),%rax
  2c04b0:	4c 8d 70 e0          	lea    -0x20(%rax),%r14

    if (sz == current_size) {
        return ptr;
  2c04b4:	49 89 fd             	mov    %rdi,%r13
    if (sz == current_size) {
  2c04b7:	4c 39 f6             	cmp    %r14,%rsi
  2c04ba:	74 2d                	je     2c04e9 <realloc+0x58>
    }

    void *new_ptr = malloc(sz);
  2c04bc:	48 89 f7             	mov    %rsi,%rdi
  2c04bf:	e8 5c fe ff ff       	call   2c0320 <malloc>
  2c04c4:	49 89 c5             	mov    %rax,%r13
    if (new_ptr == NULL) {
  2c04c7:	48 85 c0             	test   %rax,%rax
  2c04ca:	74 1d                	je     2c04e9 <realloc+0x58>
        return NULL; 
    }
    uint64_t size_to_copy = (current_size < sz) ? current_size : sz;
  2c04cc:	4c 39 f3             	cmp    %r14,%rbx
  2c04cf:	4c 89 f2             	mov    %r14,%rdx
  2c04d2:	48 0f 46 d3          	cmovbe %rbx,%rdx
    memcpy(new_ptr, ptr, size_to_copy);
  2c04d6:	4c 89 e6             	mov    %r12,%rsi
  2c04d9:	48 89 c7             	mov    %rax,%rdi
  2c04dc:	e8 06 03 00 00       	call   2c07e7 <memcpy>

    free(ptr); 
  2c04e1:	4c 89 e7             	mov    %r12,%rdi
  2c04e4:	e8 24 fe ff ff       	call   2c030d <free>
    return new_ptr;
}
  2c04e9:	4c 89 e8             	mov    %r13,%rax
  2c04ec:	5b                   	pop    %rbx
  2c04ed:	41 5c                	pop    %r12
  2c04ef:	41 5d                	pop    %r13
  2c04f1:	41 5e                	pop    %r14
  2c04f3:	5d                   	pop    %rbp
  2c04f4:	c3                   	ret
        return malloc(sz);
  2c04f5:	48 89 f7             	mov    %rsi,%rdi
  2c04f8:	e8 23 fe ff ff       	call   2c0320 <malloc>
  2c04fd:	49 89 c5             	mov    %rax,%r13
  2c0500:	eb e7                	jmp    2c04e9 <realloc+0x58>
        free(ptr);
  2c0502:	e8 06 fe ff ff       	call   2c030d <free>
        return NULL;
  2c0507:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  2c050d:	eb da                	jmp    2c04e9 <realloc+0x58>

00000000002c050f <defrag>:

void defrag() {
    if (head == NULL || head->next == NULL) {
  2c050f:	48 8b 05 02 1b 00 00 	mov    0x1b02(%rip),%rax        # 2c2018 <head>
  2c0516:	48 85 c0             	test   %rax,%rax
  2c0519:	74 3b                	je     2c0556 <defrag+0x47>
  2c051b:	48 83 78 08 00       	cmpq   $0x0,0x8(%rax)
  2c0520:	75 04                	jne    2c0526 <defrag+0x17>
  2c0522:	c3                   	ret
        if (current->is_free && next->is_free) {
            current->size += next->size; 
            current->next = next->next; 
            block_footer *footer = (block_footer *)((char *)current + current->size - sizeof(block_footer));
            footer->size = current->size;
            continue; 
  2c0523:	48 89 d0             	mov    %rdx,%rax
    while (current != NULL && current->next != NULL) {
  2c0526:	48 8b 50 08          	mov    0x8(%rax),%rdx
  2c052a:	48 85 d2             	test   %rdx,%rdx
  2c052d:	74 27                	je     2c0556 <defrag+0x47>
        if (current->is_free && next->is_free) {
  2c052f:	83 78 10 00          	cmpl   $0x0,0x10(%rax)
  2c0533:	74 ee                	je     2c0523 <defrag+0x14>
  2c0535:	83 7a 10 00          	cmpl   $0x0,0x10(%rdx)
  2c0539:	74 e8                	je     2c0523 <defrag+0x14>
            current->size += next->size; 
  2c053b:	48 8b 0a             	mov    (%rdx),%rcx
  2c053e:	48 03 08             	add    (%rax),%rcx
  2c0541:	48 89 08             	mov    %rcx,(%rax)
            current->next = next->next; 
  2c0544:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  2c0548:	48 89 50 08          	mov    %rdx,0x8(%rax)
            footer->size = current->size;
  2c054c:	48 89 4c 08 f8       	mov    %rcx,-0x8(%rax,%rcx,1)
            continue; 
  2c0551:	48 89 c2             	mov    %rax,%rdx
  2c0554:	eb cd                	jmp    2c0523 <defrag+0x14>
        }

        prev = current;
        current = next;
    }
}
  2c0556:	c3                   	ret

00000000002c0557 <quickSort>:
    info->largest_free_chunk = largest_free_chunk;
    return 0;
}

void quickSort(long *size_array, void **ptr_array, int left, int right) {
    if (left >= right) return; 
  2c0557:	39 ca                	cmp    %ecx,%edx
  2c0559:	0f 8d 13 01 00 00    	jge    2c0672 <quickSort+0x11b>
void quickSort(long *size_array, void **ptr_array, int left, int right) {
  2c055f:	55                   	push   %rbp
  2c0560:	48 89 e5             	mov    %rsp,%rbp
  2c0563:	41 57                	push   %r15
  2c0565:	41 56                	push   %r14
  2c0567:	41 55                	push   %r13
  2c0569:	41 54                	push   %r12
  2c056b:	53                   	push   %rbx
  2c056c:	48 83 ec 08          	sub    $0x8,%rsp
  2c0570:	48 89 fb             	mov    %rdi,%rbx
  2c0573:	49 89 f5             	mov    %rsi,%r13
  2c0576:	41 89 d2             	mov    %edx,%r10d
  2c0579:	41 89 cc             	mov    %ecx,%r12d

    // Partition step
    long pivot = size_array[(left + right) / 2];
  2c057c:	8d 14 0a             	lea    (%rdx,%rcx,1),%edx
  2c057f:	89 d0                	mov    %edx,%eax
  2c0581:	c1 e8 1f             	shr    $0x1f,%eax
  2c0584:	01 d0                	add    %edx,%eax
  2c0586:	d1 f8                	sar    %eax
  2c0588:	48 98                	cltq
  2c058a:	48 8b 0c c7          	mov    (%rdi,%rax,8),%rcx
    int i = left;
    int j = right;
  2c058e:	44 89 e2             	mov    %r12d,%edx
    int i = left;
  2c0591:	45 89 d6             	mov    %r10d,%r14d
    while (i <= j) {
  2c0594:	eb 6d                	jmp    2c0603 <quickSort+0xac>
  2c0596:	41 83 c6 01          	add    $0x1,%r14d
  2c059a:	4d 63 f6             	movslq %r14d,%r14
  2c059d:	4a 8d 44 03 08       	lea    0x8(%rbx,%r8,1),%rax
        while (size_array[i] > pivot) i++;  
  2c05a2:	49 89 c3             	mov    %rax,%r11
  2c05a5:	48 8b 30             	mov    (%rax),%rsi
  2c05a8:	4d 89 f0             	mov    %r14,%r8
  2c05ab:	49 83 c6 01          	add    $0x1,%r14
  2c05af:	48 83 c0 08          	add    $0x8,%rax
  2c05b3:	48 39 ce             	cmp    %rcx,%rsi
  2c05b6:	7f ea                	jg     2c05a2 <quickSort+0x4b>
  2c05b8:	45 89 c6             	mov    %r8d,%r14d
  2c05bb:	49 c1 e0 03          	shl    $0x3,%r8
        while (size_array[j] < pivot) j--;  
  2c05bf:	48 63 c2             	movslq %edx,%rax
  2c05c2:	4c 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%r9
  2c05c9:	00 
  2c05ca:	4e 8d 3c 0b          	lea    (%rbx,%r9,1),%r15
  2c05ce:	49 8b 3f             	mov    (%r15),%rdi
  2c05d1:	48 39 f9             	cmp    %rdi,%rcx
  2c05d4:	7e 28                	jle    2c05fe <quickSort+0xa7>
  2c05d6:	83 ea 01             	sub    $0x1,%edx
  2c05d9:	48 63 d2             	movslq %edx,%rdx
  2c05dc:	48 8d 44 c3 f8       	lea    -0x8(%rbx,%rax,8),%rax
  2c05e1:	49 89 c7             	mov    %rax,%r15
  2c05e4:	48 8b 38             	mov    (%rax),%rdi
  2c05e7:	49 89 d1             	mov    %rdx,%r9
  2c05ea:	48 83 ea 01          	sub    $0x1,%rdx
  2c05ee:	48 83 e8 08          	sub    $0x8,%rax
  2c05f2:	48 39 cf             	cmp    %rcx,%rdi
  2c05f5:	7c ea                	jl     2c05e1 <quickSort+0x8a>
  2c05f7:	44 89 ca             	mov    %r9d,%edx
  2c05fa:	49 c1 e1 03          	shl    $0x3,%r9
        if (i <= j) {
  2c05fe:	41 39 d6             	cmp    %edx,%r14d
  2c0601:	7e 1e                	jle    2c0621 <quickSort+0xca>
    while (i <= j) {
  2c0603:	41 39 d6             	cmp    %edx,%r14d
  2c0606:	7f 3a                	jg     2c0642 <quickSort+0xeb>
        while (size_array[i] > pivot) i++;  
  2c0608:	4d 63 c6             	movslq %r14d,%r8
  2c060b:	49 c1 e0 03          	shl    $0x3,%r8
  2c060f:	4e 8d 1c 03          	lea    (%rbx,%r8,1),%r11
  2c0613:	49 8b 33             	mov    (%r11),%rsi
  2c0616:	48 39 f1             	cmp    %rsi,%rcx
  2c0619:	0f 8c 77 ff ff ff    	jl     2c0596 <quickSort+0x3f>
  2c061f:	eb 9e                	jmp    2c05bf <quickSort+0x68>
            long tempSize = size_array[i];
            void* tempPtr = ptr_array[i];
  2c0621:	4d 01 e8             	add    %r13,%r8
  2c0624:	49 8b 00             	mov    (%r8),%rax
            size_array[i] = size_array[j];
  2c0627:	49 89 3b             	mov    %rdi,(%r11)
            ptr_array[i] = ptr_array[j];
  2c062a:	4d 01 e9             	add    %r13,%r9
  2c062d:	49 8b 39             	mov    (%r9),%rdi
  2c0630:	49 89 38             	mov    %rdi,(%r8)
            size_array[j] = tempSize;
  2c0633:	49 89 37             	mov    %rsi,(%r15)
            ptr_array[j] = tempPtr;
  2c0636:	49 89 01             	mov    %rax,(%r9)
            i++;
  2c0639:	41 83 c6 01          	add    $0x1,%r14d
            j--;
  2c063d:	83 ea 01             	sub    $0x1,%edx
  2c0640:	eb c1                	jmp    2c0603 <quickSort+0xac>
        }
    }

    // Recursive step
    quickSort(size_array, ptr_array, left, j);
  2c0642:	89 d1                	mov    %edx,%ecx
  2c0644:	44 89 d2             	mov    %r10d,%edx
  2c0647:	4c 89 ee             	mov    %r13,%rsi
  2c064a:	48 89 df             	mov    %rbx,%rdi
  2c064d:	e8 05 ff ff ff       	call   2c0557 <quickSort>
    quickSort(size_array, ptr_array, i, right);
  2c0652:	44 89 e1             	mov    %r12d,%ecx
  2c0655:	44 89 f2             	mov    %r14d,%edx
  2c0658:	4c 89 ee             	mov    %r13,%rsi
  2c065b:	48 89 df             	mov    %rbx,%rdi
  2c065e:	e8 f4 fe ff ff       	call   2c0557 <quickSort>
}
  2c0663:	48 83 c4 08          	add    $0x8,%rsp
  2c0667:	5b                   	pop    %rbx
  2c0668:	41 5c                	pop    %r12
  2c066a:	41 5d                	pop    %r13
  2c066c:	41 5e                	pop    %r14
  2c066e:	41 5f                	pop    %r15
  2c0670:	5d                   	pop    %rbp
  2c0671:	c3                   	ret
  2c0672:	c3                   	ret

00000000002c0673 <quickSortStart>:

// Function to start the quicksort
void quickSortStart(long *size_array, void **ptr_array, int n) {
  2c0673:	55                   	push   %rbp
  2c0674:	48 89 e5             	mov    %rsp,%rbp
    quickSort(size_array, ptr_array, 0, n - 1);
  2c0677:	8d 4a ff             	lea    -0x1(%rdx),%ecx
  2c067a:	ba 00 00 00 00       	mov    $0x0,%edx
  2c067f:	e8 d3 fe ff ff       	call   2c0557 <quickSort>
}
  2c0684:	5d                   	pop    %rbp
  2c0685:	c3                   	ret

00000000002c0686 <heap_info>:
    if (info == NULL) return -1;
  2c0686:	48 85 ff             	test   %rdi,%rdi
  2c0689:	0f 84 52 01 00 00    	je     2c07e1 <heap_info+0x15b>
int heap_info(heap_info_struct *info) {
  2c068f:	55                   	push   %rbp
  2c0690:	48 89 e5             	mov    %rsp,%rbp
  2c0693:	41 57                	push   %r15
  2c0695:	41 56                	push   %r14
  2c0697:	41 55                	push   %r13
  2c0699:	41 54                	push   %r12
  2c069b:	53                   	push   %rbx
  2c069c:	48 83 ec 18          	sub    $0x18,%rsp
  2c06a0:	49 89 fe             	mov    %rdi,%r14
    block_header *current = head; 
  2c06a3:	48 8b 05 6e 19 00 00 	mov    0x196e(%rip),%rax        # 2c2018 <head>
    while (current != NULL) {  
  2c06aa:	48 85 c0             	test   %rax,%rax
  2c06ad:	74 7e                	je     2c072d <heap_info+0xa7>
    uint64_t largest_free_chunk = 0;
  2c06af:	bb 00 00 00 00       	mov    $0x0,%ebx
    int total_free_space = 0;
  2c06b4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    int alloc_count = 0;
  2c06ba:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  2c06c0:	eb 0d                	jmp    2c06cf <heap_info+0x49>
            alloc_count++;
  2c06c2:	41 83 c4 01          	add    $0x1,%r12d
        current = current->next; 
  2c06c6:	48 8b 40 08          	mov    0x8(%rax),%rax
    while (current != NULL) {  
  2c06ca:	48 85 c0             	test   %rax,%rax
  2c06cd:	74 15                	je     2c06e4 <heap_info+0x5e>
        if (current->is_free) {
  2c06cf:	83 78 10 00          	cmpl   $0x0,0x10(%rax)
  2c06d3:	74 ed                	je     2c06c2 <heap_info+0x3c>
            total_free_space += current->size;
  2c06d5:	48 8b 10             	mov    (%rax),%rdx
  2c06d8:	41 01 d5             	add    %edx,%r13d
            if (current->size > largest_free_chunk) {
  2c06db:	48 39 d3             	cmp    %rdx,%rbx
  2c06de:	48 0f 42 da          	cmovb  %rdx,%rbx
  2c06e2:	eb e2                	jmp    2c06c6 <heap_info+0x40>
    if (alloc_count == 0) {
  2c06e4:	45 85 e4             	test   %r12d,%r12d
  2c06e7:	74 4f                	je     2c0738 <heap_info+0xb2>
    long *size_array = (long *)malloc(alloc_count * sizeof(long));
  2c06e9:	49 63 c4             	movslq %r12d,%rax
  2c06ec:	48 c1 e0 03          	shl    $0x3,%rax
  2c06f0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  2c06f4:	48 89 c7             	mov    %rax,%rdi
  2c06f7:	e8 24 fc ff ff       	call   2c0320 <malloc>
  2c06fc:	49 89 c7             	mov    %rax,%r15
    void **ptr_array = (void **)malloc(alloc_count * sizeof(void *));
  2c06ff:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  2c0703:	e8 18 fc ff ff       	call   2c0320 <malloc>
  2c0708:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    if (size_array == NULL || ptr_array == NULL) {
  2c070c:	4d 85 ff             	test   %r15,%r15
  2c070f:	74 5a                	je     2c076b <heap_info+0xe5>
  2c0711:	48 85 c0             	test   %rax,%rax
  2c0714:	74 55                	je     2c076b <heap_info+0xe5>
    current = head; 
  2c0716:	48 8b 05 fb 18 00 00 	mov    0x18fb(%rip),%rax        # 2c2018 <head>
    while (current != NULL) { 
  2c071d:	48 85 c0             	test   %rax,%rax
  2c0720:	0f 84 8b 00 00 00    	je     2c07b1 <heap_info+0x12b>
    int index = 0;
  2c0726:	b9 00 00 00 00       	mov    $0x0,%ecx
  2c072b:	eb 5f                	jmp    2c078c <heap_info+0x106>
    uint64_t largest_free_chunk = 0;
  2c072d:	bb 00 00 00 00       	mov    $0x0,%ebx
    int total_free_space = 0;
  2c0732:	41 bd 00 00 00 00    	mov    $0x0,%r13d
        info->num_allocs = 0;
  2c0738:	41 c7 06 00 00 00 00 	movl   $0x0,(%r14)
        info->size_array = NULL;
  2c073f:	49 c7 46 08 00 00 00 	movq   $0x0,0x8(%r14)
  2c0746:	00 
        info->ptr_array = NULL;
  2c0747:	49 c7 46 10 00 00 00 	movq   $0x0,0x10(%r14)
  2c074e:	00 
        info->free_space = total_free_space;
  2c074f:	45 89 6e 18          	mov    %r13d,0x18(%r14)
        info->largest_free_chunk = largest_free_chunk;
  2c0753:	41 89 5e 1c          	mov    %ebx,0x1c(%r14)
        return 0;
  2c0757:	b8 00 00 00 00       	mov    $0x0,%eax
}
  2c075c:	48 83 c4 18          	add    $0x18,%rsp
  2c0760:	5b                   	pop    %rbx
  2c0761:	41 5c                	pop    %r12
  2c0763:	41 5d                	pop    %r13
  2c0765:	41 5e                	pop    %r14
  2c0767:	41 5f                	pop    %r15
  2c0769:	5d                   	pop    %rbp
  2c076a:	c3                   	ret
        free(size_array);  
  2c076b:	4c 89 ff             	mov    %r15,%rdi
  2c076e:	e8 9a fb ff ff       	call   2c030d <free>
        free(ptr_array);
  2c0773:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  2c0777:	e8 91 fb ff ff       	call   2c030d <free>
        return -1;
  2c077c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  2c0781:	eb d9                	jmp    2c075c <heap_info+0xd6>
        current = current->next;
  2c0783:	48 8b 40 08          	mov    0x8(%rax),%rax
    while (current != NULL) { 
  2c0787:	48 85 c0             	test   %rax,%rax
  2c078a:	74 25                	je     2c07b1 <heap_info+0x12b>
        if (!current->is_free) {
  2c078c:	83 78 10 00          	cmpl   $0x0,0x10(%rax)
  2c0790:	75 f1                	jne    2c0783 <heap_info+0xfd>
            size_array[index] = current->size - sizeof(block_header) - sizeof(block_footer);
  2c0792:	48 63 f1             	movslq %ecx,%rsi
  2c0795:	48 8b 38             	mov    (%rax),%rdi
  2c0798:	48 8d 57 e0          	lea    -0x20(%rdi),%rdx
  2c079c:	49 89 14 f7          	mov    %rdx,(%r15,%rsi,8)
            ptr_array[index] = (void *)((char *)current + sizeof(block_header));
  2c07a0:	48 8d 50 18          	lea    0x18(%rax),%rdx
  2c07a4:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  2c07a8:	48 89 14 f7          	mov    %rdx,(%rdi,%rsi,8)
            index++;
  2c07ac:	83 c1 01             	add    $0x1,%ecx
  2c07af:	eb d2                	jmp    2c0783 <heap_info+0xfd>
    quickSortStart(size_array, ptr_array, alloc_count);
  2c07b1:	44 89 e2             	mov    %r12d,%edx
  2c07b4:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  2c07b8:	4c 89 ff             	mov    %r15,%rdi
  2c07bb:	e8 b3 fe ff ff       	call   2c0673 <quickSortStart>
    info->num_allocs = alloc_count;
  2c07c0:	45 89 26             	mov    %r12d,(%r14)
    info->size_array = size_array;
  2c07c3:	4d 89 7e 08          	mov    %r15,0x8(%r14)
    info->ptr_array = ptr_array;
  2c07c7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  2c07cb:	49 89 46 10          	mov    %rax,0x10(%r14)
    info->free_space = total_free_space;
  2c07cf:	45 89 6e 18          	mov    %r13d,0x18(%r14)
    info->largest_free_chunk = largest_free_chunk;
  2c07d3:	41 89 5e 1c          	mov    %ebx,0x1c(%r14)
    return 0;
  2c07d7:	b8 00 00 00 00       	mov    $0x0,%eax
  2c07dc:	e9 7b ff ff ff       	jmp    2c075c <heap_info+0xd6>
    if (info == NULL) return -1;
  2c07e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
  2c07e6:	c3                   	ret

00000000002c07e7 <memcpy>:


// memcpy, memmove, memset, strcmp, strlen, strnlen
//    We must provide our own implementations.

void* memcpy(void* dst, const void* src, size_t n) {
  2c07e7:	55                   	push   %rbp
  2c07e8:	48 89 e5             	mov    %rsp,%rbp
  2c07eb:	48 83 ec 28          	sub    $0x28,%rsp
  2c07ef:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  2c07f3:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  2c07f7:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  2c07fb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  2c07ff:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  2c0803:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  2c0807:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
  2c080b:	eb 1c                	jmp    2c0829 <memcpy+0x42>
        *d = *s;
  2c080d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c0811:	0f b6 10             	movzbl (%rax),%edx
  2c0814:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c0818:	88 10                	mov    %dl,(%rax)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  2c081a:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  2c081f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  2c0824:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
  2c0829:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  2c082e:	75 dd                	jne    2c080d <memcpy+0x26>
    }
    return dst;
  2c0830:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  2c0834:	c9                   	leave
  2c0835:	c3                   	ret

00000000002c0836 <memmove>:

void* memmove(void* dst, const void* src, size_t n) {
  2c0836:	55                   	push   %rbp
  2c0837:	48 89 e5             	mov    %rsp,%rbp
  2c083a:	48 83 ec 28          	sub    $0x28,%rsp
  2c083e:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  2c0842:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  2c0846:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
  2c084a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  2c084e:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    char* d = (char*) dst;
  2c0852:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  2c0856:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (s < d && s + n > d) {
  2c085a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c085e:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
  2c0862:	73 6a                	jae    2c08ce <memmove+0x98>
  2c0864:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  2c0868:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  2c086c:	48 01 d0             	add    %rdx,%rax
  2c086f:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
  2c0873:	73 59                	jae    2c08ce <memmove+0x98>
        s += n, d += n;
  2c0875:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  2c0879:	48 01 45 f8          	add    %rax,-0x8(%rbp)
  2c087d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  2c0881:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        while (n-- > 0) {
  2c0885:	eb 17                	jmp    2c089e <memmove+0x68>
            *--d = *--s;
  2c0887:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
  2c088c:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
  2c0891:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c0895:	0f b6 10             	movzbl (%rax),%edx
  2c0898:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c089c:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  2c089e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  2c08a2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  2c08a6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  2c08aa:	48 85 c0             	test   %rax,%rax
  2c08ad:	75 d8                	jne    2c0887 <memmove+0x51>
    if (s < d && s + n > d) {
  2c08af:	eb 2e                	jmp    2c08df <memmove+0xa9>
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
  2c08b1:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  2c08b5:	48 8d 42 01          	lea    0x1(%rdx),%rax
  2c08b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  2c08bd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c08c1:	48 8d 48 01          	lea    0x1(%rax),%rcx
  2c08c5:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
  2c08c9:	0f b6 12             	movzbl (%rdx),%edx
  2c08cc:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
  2c08ce:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  2c08d2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  2c08d6:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
  2c08da:	48 85 c0             	test   %rax,%rax
  2c08dd:	75 d2                	jne    2c08b1 <memmove+0x7b>
        }
    }
    return dst;
  2c08df:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  2c08e3:	c9                   	leave
  2c08e4:	c3                   	ret

00000000002c08e5 <memset>:

void* memset(void* v, int c, size_t n) {
  2c08e5:	55                   	push   %rbp
  2c08e6:	48 89 e5             	mov    %rsp,%rbp
  2c08e9:	48 83 ec 28          	sub    $0x28,%rsp
  2c08ed:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  2c08f1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
  2c08f4:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  2c08f8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  2c08fc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
  2c0900:	eb 15                	jmp    2c0917 <memset+0x32>
        *p = c;
  2c0902:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  2c0905:	89 c2                	mov    %eax,%edx
  2c0907:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c090b:	88 10                	mov    %dl,(%rax)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  2c090d:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  2c0912:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
  2c0917:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  2c091c:	75 e4                	jne    2c0902 <memset+0x1d>
    }
    return v;
  2c091e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  2c0922:	c9                   	leave
  2c0923:	c3                   	ret

00000000002c0924 <strlen>:

size_t strlen(const char* s) {
  2c0924:	55                   	push   %rbp
  2c0925:	48 89 e5             	mov    %rsp,%rbp
  2c0928:	48 83 ec 18          	sub    $0x18,%rsp
  2c092c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
  2c0930:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  2c0937:	00 
  2c0938:	eb 0a                	jmp    2c0944 <strlen+0x20>
        ++n;
  2c093a:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; *s != '\0'; ++s) {
  2c093f:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  2c0944:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  2c0948:	0f b6 00             	movzbl (%rax),%eax
  2c094b:	84 c0                	test   %al,%al
  2c094d:	75 eb                	jne    2c093a <strlen+0x16>
    }
    return n;
  2c094f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  2c0953:	c9                   	leave
  2c0954:	c3                   	ret

00000000002c0955 <strnlen>:

size_t strnlen(const char* s, size_t maxlen) {
  2c0955:	55                   	push   %rbp
  2c0956:	48 89 e5             	mov    %rsp,%rbp
  2c0959:	48 83 ec 20          	sub    $0x20,%rsp
  2c095d:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  2c0961:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    size_t n;
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  2c0965:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
  2c096c:	00 
  2c096d:	eb 0a                	jmp    2c0979 <strnlen+0x24>
        ++n;
  2c096f:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  2c0974:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
  2c0979:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c097d:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
  2c0981:	74 0b                	je     2c098e <strnlen+0x39>
  2c0983:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  2c0987:	0f b6 00             	movzbl (%rax),%eax
  2c098a:	84 c0                	test   %al,%al
  2c098c:	75 e1                	jne    2c096f <strnlen+0x1a>
    }
    return n;
  2c098e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
  2c0992:	c9                   	leave
  2c0993:	c3                   	ret

00000000002c0994 <strcpy>:

char* strcpy(char* dst, const char* src) {
  2c0994:	55                   	push   %rbp
  2c0995:	48 89 e5             	mov    %rsp,%rbp
  2c0998:	48 83 ec 20          	sub    $0x20,%rsp
  2c099c:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  2c09a0:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    char* d = dst;
  2c09a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  2c09a8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    do {
        *d++ = *src++;
  2c09ac:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  2c09b0:	48 8d 42 01          	lea    0x1(%rdx),%rax
  2c09b4:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
  2c09b8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c09bc:	48 8d 48 01          	lea    0x1(%rax),%rcx
  2c09c0:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
  2c09c4:	0f b6 12             	movzbl (%rdx),%edx
  2c09c7:	88 10                	mov    %dl,(%rax)
    } while (d[-1]);
  2c09c9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c09cd:	48 83 e8 01          	sub    $0x1,%rax
  2c09d1:	0f b6 00             	movzbl (%rax),%eax
  2c09d4:	84 c0                	test   %al,%al
  2c09d6:	75 d4                	jne    2c09ac <strcpy+0x18>
    return dst;
  2c09d8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  2c09dc:	c9                   	leave
  2c09dd:	c3                   	ret

00000000002c09de <strcmp>:

int strcmp(const char* a, const char* b) {
  2c09de:	55                   	push   %rbp
  2c09df:	48 89 e5             	mov    %rsp,%rbp
  2c09e2:	48 83 ec 10          	sub    $0x10,%rsp
  2c09e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  2c09ea:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  2c09ee:	eb 0a                	jmp    2c09fa <strcmp+0x1c>
        ++a, ++b;
  2c09f0:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
  2c09f5:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
    while (*a && *b && *a == *b) {
  2c09fa:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c09fe:	0f b6 00             	movzbl (%rax),%eax
  2c0a01:	84 c0                	test   %al,%al
  2c0a03:	74 1d                	je     2c0a22 <strcmp+0x44>
  2c0a05:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c0a09:	0f b6 00             	movzbl (%rax),%eax
  2c0a0c:	84 c0                	test   %al,%al
  2c0a0e:	74 12                	je     2c0a22 <strcmp+0x44>
  2c0a10:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c0a14:	0f b6 10             	movzbl (%rax),%edx
  2c0a17:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c0a1b:	0f b6 00             	movzbl (%rax),%eax
  2c0a1e:	38 c2                	cmp    %al,%dl
  2c0a20:	74 ce                	je     2c09f0 <strcmp+0x12>
    }
    return ((unsigned char) *a > (unsigned char) *b)
  2c0a22:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c0a26:	0f b6 00             	movzbl (%rax),%eax
  2c0a29:	89 c2                	mov    %eax,%edx
  2c0a2b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c0a2f:	0f b6 00             	movzbl (%rax),%eax
  2c0a32:	38 d0                	cmp    %dl,%al
  2c0a34:	0f 92 c0             	setb   %al
  2c0a37:	0f b6 d0             	movzbl %al,%edx
        - ((unsigned char) *a < (unsigned char) *b);
  2c0a3a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c0a3e:	0f b6 00             	movzbl (%rax),%eax
  2c0a41:	89 c1                	mov    %eax,%ecx
  2c0a43:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c0a47:	0f b6 00             	movzbl (%rax),%eax
  2c0a4a:	38 c1                	cmp    %al,%cl
  2c0a4c:	0f 92 c0             	setb   %al
  2c0a4f:	0f b6 c0             	movzbl %al,%eax
  2c0a52:	29 c2                	sub    %eax,%edx
  2c0a54:	89 d0                	mov    %edx,%eax
}
  2c0a56:	c9                   	leave
  2c0a57:	c3                   	ret

00000000002c0a58 <strchr>:

char* strchr(const char* s, int c) {
  2c0a58:	55                   	push   %rbp
  2c0a59:	48 89 e5             	mov    %rsp,%rbp
  2c0a5c:	48 83 ec 10          	sub    $0x10,%rsp
  2c0a60:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
  2c0a64:	89 75 f4             	mov    %esi,-0xc(%rbp)
    while (*s && *s != (char) c) {
  2c0a67:	eb 05                	jmp    2c0a6e <strchr+0x16>
        ++s;
  2c0a69:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while (*s && *s != (char) c) {
  2c0a6e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c0a72:	0f b6 00             	movzbl (%rax),%eax
  2c0a75:	84 c0                	test   %al,%al
  2c0a77:	74 0e                	je     2c0a87 <strchr+0x2f>
  2c0a79:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c0a7d:	0f b6 00             	movzbl (%rax),%eax
  2c0a80:	8b 55 f4             	mov    -0xc(%rbp),%edx
  2c0a83:	38 d0                	cmp    %dl,%al
  2c0a85:	75 e2                	jne    2c0a69 <strchr+0x11>
    }
    if (*s == (char) c) {
  2c0a87:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c0a8b:	0f b6 00             	movzbl (%rax),%eax
  2c0a8e:	8b 55 f4             	mov    -0xc(%rbp),%edx
  2c0a91:	38 d0                	cmp    %dl,%al
  2c0a93:	75 06                	jne    2c0a9b <strchr+0x43>
        return (char*) s;
  2c0a95:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c0a99:	eb 05                	jmp    2c0aa0 <strchr+0x48>
    } else {
        return NULL;
  2c0a9b:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
  2c0aa0:	c9                   	leave
  2c0aa1:	c3                   	ret

00000000002c0aa2 <rand>:
// rand, srand

static int rand_seed_set;
static unsigned rand_seed;

int rand(void) {
  2c0aa2:	55                   	push   %rbp
  2c0aa3:	48 89 e5             	mov    %rsp,%rbp
    if (!rand_seed_set) {
  2c0aa6:	8b 05 74 15 00 00    	mov    0x1574(%rip),%eax        # 2c2020 <rand_seed_set>
  2c0aac:	85 c0                	test   %eax,%eax
  2c0aae:	75 0a                	jne    2c0aba <rand+0x18>
        srand(819234718U);
  2c0ab0:	bf 9e 87 d4 30       	mov    $0x30d4879e,%edi
  2c0ab5:	e8 24 00 00 00       	call   2c0ade <srand>
    }
    rand_seed = rand_seed * 1664525U + 1013904223U;
  2c0aba:	8b 05 64 15 00 00    	mov    0x1564(%rip),%eax        # 2c2024 <rand_seed>
  2c0ac0:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
  2c0ac6:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  2c0acb:	89 05 53 15 00 00    	mov    %eax,0x1553(%rip)        # 2c2024 <rand_seed>
    return rand_seed & RAND_MAX;
  2c0ad1:	8b 05 4d 15 00 00    	mov    0x154d(%rip),%eax        # 2c2024 <rand_seed>
  2c0ad7:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  2c0adc:	5d                   	pop    %rbp
  2c0add:	c3                   	ret

00000000002c0ade <srand>:

void srand(unsigned seed) {
  2c0ade:	55                   	push   %rbp
  2c0adf:	48 89 e5             	mov    %rsp,%rbp
  2c0ae2:	48 83 ec 08          	sub    $0x8,%rsp
  2c0ae6:	89 7d fc             	mov    %edi,-0x4(%rbp)
    rand_seed = seed;
  2c0ae9:	8b 45 fc             	mov    -0x4(%rbp),%eax
  2c0aec:	89 05 32 15 00 00    	mov    %eax,0x1532(%rip)        # 2c2024 <rand_seed>
    rand_seed_set = 1;
  2c0af2:	c7 05 24 15 00 00 01 	movl   $0x1,0x1524(%rip)        # 2c2020 <rand_seed_set>
  2c0af9:	00 00 00 
}
  2c0afc:	90                   	nop
  2c0afd:	c9                   	leave
  2c0afe:	c3                   	ret

00000000002c0aff <fill_numbuf>:
//    Print a message onto the console, starting at the given cursor position.

// snprintf, vsnprintf
//    Format a string into a buffer.

static char* fill_numbuf(char* numbuf_end, unsigned long val, int base) {
  2c0aff:	55                   	push   %rbp
  2c0b00:	48 89 e5             	mov    %rsp,%rbp
  2c0b03:	48 83 ec 28          	sub    $0x28,%rsp
  2c0b07:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  2c0b0b:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
  2c0b0f:	89 55 dc             	mov    %edx,-0x24(%rbp)
    static const char upper_digits[] = "0123456789ABCDEF";
    static const char lower_digits[] = "0123456789abcdef";

    const char* digits = upper_digits;
  2c0b12:	48 c7 45 f8 10 1b 2c 	movq   $0x2c1b10,-0x8(%rbp)
  2c0b19:	00 
    if (base < 0) {
  2c0b1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
  2c0b1e:	79 0b                	jns    2c0b2b <fill_numbuf+0x2c>
        digits = lower_digits;
  2c0b20:	48 c7 45 f8 30 1b 2c 	movq   $0x2c1b30,-0x8(%rbp)
  2c0b27:	00 
        base = -base;
  2c0b28:	f7 5d dc             	negl   -0x24(%rbp)
    }

    *--numbuf_end = '\0';
  2c0b2b:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  2c0b30:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  2c0b34:	c6 00 00             	movb   $0x0,(%rax)
    do {
        *--numbuf_end = digits[val % base];
  2c0b37:	8b 45 dc             	mov    -0x24(%rbp),%eax
  2c0b3a:	48 63 c8             	movslq %eax,%rcx
  2c0b3d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  2c0b41:	ba 00 00 00 00       	mov    $0x0,%edx
  2c0b46:	48 f7 f1             	div    %rcx
  2c0b49:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c0b4d:	48 01 d0             	add    %rdx,%rax
  2c0b50:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
  2c0b55:	0f b6 10             	movzbl (%rax),%edx
  2c0b58:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  2c0b5c:	88 10                	mov    %dl,(%rax)
        val /= base;
  2c0b5e:	8b 45 dc             	mov    -0x24(%rbp),%eax
  2c0b61:	48 63 f0             	movslq %eax,%rsi
  2c0b64:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  2c0b68:	ba 00 00 00 00       	mov    $0x0,%edx
  2c0b6d:	48 f7 f6             	div    %rsi
  2c0b70:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    } while (val != 0);
  2c0b74:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
  2c0b79:	75 bc                	jne    2c0b37 <fill_numbuf+0x38>
    return numbuf_end;
  2c0b7b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
  2c0b7f:	c9                   	leave
  2c0b80:	c3                   	ret

00000000002c0b81 <printer_vprintf>:
#define FLAG_NUMERIC            (1<<5)
#define FLAG_SIGNED             (1<<6)
#define FLAG_NEGATIVE           (1<<7)
#define FLAG_ALT2               (1<<8)

void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  2c0b81:	55                   	push   %rbp
  2c0b82:	48 89 e5             	mov    %rsp,%rbp
  2c0b85:	53                   	push   %rbx
  2c0b86:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  2c0b8d:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
  2c0b94:	89 b5 74 ff ff ff    	mov    %esi,-0x8c(%rbp)
  2c0b9a:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  2c0ba1:	48 89 8d 60 ff ff ff 	mov    %rcx,-0xa0(%rbp)
#define NUMBUFSIZ 24
    char numbuf[NUMBUFSIZ];

    for (; *format; ++format) {
  2c0ba8:	e9 8a 09 00 00       	jmp    2c1537 <printer_vprintf+0x9b6>
        if (*format != '%') {
  2c0bad:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0bb4:	0f b6 00             	movzbl (%rax),%eax
  2c0bb7:	3c 25                	cmp    $0x25,%al
  2c0bb9:	74 31                	je     2c0bec <printer_vprintf+0x6b>
            p->putc(p, *format, color);
  2c0bbb:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  2c0bc2:	4c 8b 00             	mov    (%rax),%r8
  2c0bc5:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0bcc:	0f b6 00             	movzbl (%rax),%eax
  2c0bcf:	0f b6 c8             	movzbl %al,%ecx
  2c0bd2:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  2c0bd8:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  2c0bdf:	89 ce                	mov    %ecx,%esi
  2c0be1:	48 89 c7             	mov    %rax,%rdi
  2c0be4:	41 ff d0             	call   *%r8
            continue;
  2c0be7:	e9 43 09 00 00       	jmp    2c152f <printer_vprintf+0x9ae>
        }

        // process flags
        int flags = 0;
  2c0bec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        for (++format; *format; ++format) {
  2c0bf3:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  2c0bfa:	01 
  2c0bfb:	eb 44                	jmp    2c0c41 <printer_vprintf+0xc0>
            const char* flagc = strchr(flag_chars, *format);
  2c0bfd:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0c04:	0f b6 00             	movzbl (%rax),%eax
  2c0c07:	0f be c0             	movsbl %al,%eax
  2c0c0a:	89 c6                	mov    %eax,%esi
  2c0c0c:	bf 30 19 2c 00       	mov    $0x2c1930,%edi
  2c0c11:	e8 42 fe ff ff       	call   2c0a58 <strchr>
  2c0c16:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (flagc) {
  2c0c1a:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
  2c0c1f:	74 30                	je     2c0c51 <printer_vprintf+0xd0>
                flags |= 1 << (flagc - flag_chars);
  2c0c21:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
  2c0c25:	48 2d 30 19 2c 00    	sub    $0x2c1930,%rax
  2c0c2b:	ba 01 00 00 00       	mov    $0x1,%edx
  2c0c30:	89 c1                	mov    %eax,%ecx
  2c0c32:	d3 e2                	shl    %cl,%edx
  2c0c34:	89 d0                	mov    %edx,%eax
  2c0c36:	09 45 ec             	or     %eax,-0x14(%rbp)
        for (++format; *format; ++format) {
  2c0c39:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  2c0c40:	01 
  2c0c41:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0c48:	0f b6 00             	movzbl (%rax),%eax
  2c0c4b:	84 c0                	test   %al,%al
  2c0c4d:	75 ae                	jne    2c0bfd <printer_vprintf+0x7c>
  2c0c4f:	eb 01                	jmp    2c0c52 <printer_vprintf+0xd1>
            } else {
                break;
  2c0c51:	90                   	nop
            }
        }

        // process width
        int width = -1;
  2c0c52:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
        if (*format >= '1' && *format <= '9') {
  2c0c59:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0c60:	0f b6 00             	movzbl (%rax),%eax
  2c0c63:	3c 30                	cmp    $0x30,%al
  2c0c65:	7e 67                	jle    2c0cce <printer_vprintf+0x14d>
  2c0c67:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0c6e:	0f b6 00             	movzbl (%rax),%eax
  2c0c71:	3c 39                	cmp    $0x39,%al
  2c0c73:	7f 59                	jg     2c0cce <printer_vprintf+0x14d>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  2c0c75:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  2c0c7c:	eb 2e                	jmp    2c0cac <printer_vprintf+0x12b>
                width = 10 * width + *format++ - '0';
  2c0c7e:	8b 55 e8             	mov    -0x18(%rbp),%edx
  2c0c81:	89 d0                	mov    %edx,%eax
  2c0c83:	c1 e0 02             	shl    $0x2,%eax
  2c0c86:	01 d0                	add    %edx,%eax
  2c0c88:	01 c0                	add    %eax,%eax
  2c0c8a:	89 c1                	mov    %eax,%ecx
  2c0c8c:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0c93:	48 8d 50 01          	lea    0x1(%rax),%rdx
  2c0c97:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  2c0c9e:	0f b6 00             	movzbl (%rax),%eax
  2c0ca1:	0f be c0             	movsbl %al,%eax
  2c0ca4:	01 c8                	add    %ecx,%eax
  2c0ca6:	83 e8 30             	sub    $0x30,%eax
  2c0ca9:	89 45 e8             	mov    %eax,-0x18(%rbp)
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  2c0cac:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0cb3:	0f b6 00             	movzbl (%rax),%eax
  2c0cb6:	3c 2f                	cmp    $0x2f,%al
  2c0cb8:	0f 8e 85 00 00 00    	jle    2c0d43 <printer_vprintf+0x1c2>
  2c0cbe:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0cc5:	0f b6 00             	movzbl (%rax),%eax
  2c0cc8:	3c 39                	cmp    $0x39,%al
  2c0cca:	7e b2                	jle    2c0c7e <printer_vprintf+0xfd>
        if (*format >= '1' && *format <= '9') {
  2c0ccc:	eb 75                	jmp    2c0d43 <printer_vprintf+0x1c2>
            }
        } else if (*format == '*') {
  2c0cce:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0cd5:	0f b6 00             	movzbl (%rax),%eax
  2c0cd8:	3c 2a                	cmp    $0x2a,%al
  2c0cda:	75 68                	jne    2c0d44 <printer_vprintf+0x1c3>
            width = va_arg(val, int);
  2c0cdc:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0ce3:	8b 00                	mov    (%rax),%eax
  2c0ce5:	83 f8 2f             	cmp    $0x2f,%eax
  2c0ce8:	77 30                	ja     2c0d1a <printer_vprintf+0x199>
  2c0cea:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0cf1:	48 8b 50 10          	mov    0x10(%rax),%rdx
  2c0cf5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0cfc:	8b 00                	mov    (%rax),%eax
  2c0cfe:	89 c0                	mov    %eax,%eax
  2c0d00:	48 01 d0             	add    %rdx,%rax
  2c0d03:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0d0a:	8b 12                	mov    (%rdx),%edx
  2c0d0c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  2c0d0f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0d16:	89 0a                	mov    %ecx,(%rdx)
  2c0d18:	eb 1a                	jmp    2c0d34 <printer_vprintf+0x1b3>
  2c0d1a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0d21:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c0d25:	48 8d 48 08          	lea    0x8(%rax),%rcx
  2c0d29:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0d30:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  2c0d34:	8b 00                	mov    (%rax),%eax
  2c0d36:	89 45 e8             	mov    %eax,-0x18(%rbp)
            ++format;
  2c0d39:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  2c0d40:	01 
  2c0d41:	eb 01                	jmp    2c0d44 <printer_vprintf+0x1c3>
        if (*format >= '1' && *format <= '9') {
  2c0d43:	90                   	nop
        }

        // process precision
        int precision = -1;
  2c0d44:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
        if (*format == '.') {
  2c0d4b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0d52:	0f b6 00             	movzbl (%rax),%eax
  2c0d55:	3c 2e                	cmp    $0x2e,%al
  2c0d57:	0f 85 00 01 00 00    	jne    2c0e5d <printer_vprintf+0x2dc>
            ++format;
  2c0d5d:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  2c0d64:	01 
            if (*format >= '0' && *format <= '9') {
  2c0d65:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0d6c:	0f b6 00             	movzbl (%rax),%eax
  2c0d6f:	3c 2f                	cmp    $0x2f,%al
  2c0d71:	7e 67                	jle    2c0dda <printer_vprintf+0x259>
  2c0d73:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0d7a:	0f b6 00             	movzbl (%rax),%eax
  2c0d7d:	3c 39                	cmp    $0x39,%al
  2c0d7f:	7f 59                	jg     2c0dda <printer_vprintf+0x259>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  2c0d81:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
  2c0d88:	eb 2e                	jmp    2c0db8 <printer_vprintf+0x237>
                    precision = 10 * precision + *format++ - '0';
  2c0d8a:	8b 55 e4             	mov    -0x1c(%rbp),%edx
  2c0d8d:	89 d0                	mov    %edx,%eax
  2c0d8f:	c1 e0 02             	shl    $0x2,%eax
  2c0d92:	01 d0                	add    %edx,%eax
  2c0d94:	01 c0                	add    %eax,%eax
  2c0d96:	89 c1                	mov    %eax,%ecx
  2c0d98:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0d9f:	48 8d 50 01          	lea    0x1(%rax),%rdx
  2c0da3:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
  2c0daa:	0f b6 00             	movzbl (%rax),%eax
  2c0dad:	0f be c0             	movsbl %al,%eax
  2c0db0:	01 c8                	add    %ecx,%eax
  2c0db2:	83 e8 30             	sub    $0x30,%eax
  2c0db5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  2c0db8:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0dbf:	0f b6 00             	movzbl (%rax),%eax
  2c0dc2:	3c 2f                	cmp    $0x2f,%al
  2c0dc4:	0f 8e 85 00 00 00    	jle    2c0e4f <printer_vprintf+0x2ce>
  2c0dca:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0dd1:	0f b6 00             	movzbl (%rax),%eax
  2c0dd4:	3c 39                	cmp    $0x39,%al
  2c0dd6:	7e b2                	jle    2c0d8a <printer_vprintf+0x209>
            if (*format >= '0' && *format <= '9') {
  2c0dd8:	eb 75                	jmp    2c0e4f <printer_vprintf+0x2ce>
                }
            } else if (*format == '*') {
  2c0dda:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0de1:	0f b6 00             	movzbl (%rax),%eax
  2c0de4:	3c 2a                	cmp    $0x2a,%al
  2c0de6:	75 68                	jne    2c0e50 <printer_vprintf+0x2cf>
                precision = va_arg(val, int);
  2c0de8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0def:	8b 00                	mov    (%rax),%eax
  2c0df1:	83 f8 2f             	cmp    $0x2f,%eax
  2c0df4:	77 30                	ja     2c0e26 <printer_vprintf+0x2a5>
  2c0df6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0dfd:	48 8b 50 10          	mov    0x10(%rax),%rdx
  2c0e01:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0e08:	8b 00                	mov    (%rax),%eax
  2c0e0a:	89 c0                	mov    %eax,%eax
  2c0e0c:	48 01 d0             	add    %rdx,%rax
  2c0e0f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0e16:	8b 12                	mov    (%rdx),%edx
  2c0e18:	8d 4a 08             	lea    0x8(%rdx),%ecx
  2c0e1b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0e22:	89 0a                	mov    %ecx,(%rdx)
  2c0e24:	eb 1a                	jmp    2c0e40 <printer_vprintf+0x2bf>
  2c0e26:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0e2d:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c0e31:	48 8d 48 08          	lea    0x8(%rax),%rcx
  2c0e35:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0e3c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  2c0e40:	8b 00                	mov    (%rax),%eax
  2c0e42:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                ++format;
  2c0e45:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  2c0e4c:	01 
  2c0e4d:	eb 01                	jmp    2c0e50 <printer_vprintf+0x2cf>
            if (*format >= '0' && *format <= '9') {
  2c0e4f:	90                   	nop
            }
            if (precision < 0) {
  2c0e50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  2c0e54:	79 07                	jns    2c0e5d <printer_vprintf+0x2dc>
                precision = 0;
  2c0e56:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
            }
        }

        // process main conversion character
        int base = 10;
  2c0e5d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%rbp)
        unsigned long num = 0;
  2c0e64:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
  2c0e6b:	00 
        int length = 0;
  2c0e6c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
        char* data = "";
  2c0e73:	48 c7 45 c8 36 19 2c 	movq   $0x2c1936,-0x38(%rbp)
  2c0e7a:	00 
    again:
        switch (*format) {
  2c0e7b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c0e82:	0f b6 00             	movzbl (%rax),%eax
  2c0e85:	0f be c0             	movsbl %al,%eax
  2c0e88:	83 e8 43             	sub    $0x43,%eax
  2c0e8b:	83 f8 37             	cmp    $0x37,%eax
  2c0e8e:	0f 87 9f 03 00 00    	ja     2c1233 <printer_vprintf+0x6b2>
  2c0e94:	89 c0                	mov    %eax,%eax
  2c0e96:	48 8b 04 c5 48 19 2c 	mov    0x2c1948(,%rax,8),%rax
  2c0e9d:	00 
  2c0e9e:	ff e0                	jmp    *%rax
        case 'l':
        case 'z':
            length = 1;
  2c0ea0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
            ++format;
  2c0ea7:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  2c0eae:	01 
            goto again;
  2c0eaf:	eb ca                	jmp    2c0e7b <printer_vprintf+0x2fa>
        case 'd':
        case 'i': {
            long x = length ? va_arg(val, long) : va_arg(val, int);
  2c0eb1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  2c0eb5:	74 5d                	je     2c0f14 <printer_vprintf+0x393>
  2c0eb7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0ebe:	8b 00                	mov    (%rax),%eax
  2c0ec0:	83 f8 2f             	cmp    $0x2f,%eax
  2c0ec3:	77 30                	ja     2c0ef5 <printer_vprintf+0x374>
  2c0ec5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0ecc:	48 8b 50 10          	mov    0x10(%rax),%rdx
  2c0ed0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0ed7:	8b 00                	mov    (%rax),%eax
  2c0ed9:	89 c0                	mov    %eax,%eax
  2c0edb:	48 01 d0             	add    %rdx,%rax
  2c0ede:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0ee5:	8b 12                	mov    (%rdx),%edx
  2c0ee7:	8d 4a 08             	lea    0x8(%rdx),%ecx
  2c0eea:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0ef1:	89 0a                	mov    %ecx,(%rdx)
  2c0ef3:	eb 1a                	jmp    2c0f0f <printer_vprintf+0x38e>
  2c0ef5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0efc:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c0f00:	48 8d 48 08          	lea    0x8(%rax),%rcx
  2c0f04:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0f0b:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  2c0f0f:	48 8b 00             	mov    (%rax),%rax
  2c0f12:	eb 5c                	jmp    2c0f70 <printer_vprintf+0x3ef>
  2c0f14:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0f1b:	8b 00                	mov    (%rax),%eax
  2c0f1d:	83 f8 2f             	cmp    $0x2f,%eax
  2c0f20:	77 30                	ja     2c0f52 <printer_vprintf+0x3d1>
  2c0f22:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0f29:	48 8b 50 10          	mov    0x10(%rax),%rdx
  2c0f2d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0f34:	8b 00                	mov    (%rax),%eax
  2c0f36:	89 c0                	mov    %eax,%eax
  2c0f38:	48 01 d0             	add    %rdx,%rax
  2c0f3b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0f42:	8b 12                	mov    (%rdx),%edx
  2c0f44:	8d 4a 08             	lea    0x8(%rdx),%ecx
  2c0f47:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0f4e:	89 0a                	mov    %ecx,(%rdx)
  2c0f50:	eb 1a                	jmp    2c0f6c <printer_vprintf+0x3eb>
  2c0f52:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0f59:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c0f5d:	48 8d 48 08          	lea    0x8(%rax),%rcx
  2c0f61:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0f68:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  2c0f6c:	8b 00                	mov    (%rax),%eax
  2c0f6e:	48 98                	cltq
  2c0f70:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  2c0f74:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  2c0f78:	48 c1 f8 38          	sar    $0x38,%rax
  2c0f7c:	25 80 00 00 00       	and    $0x80,%eax
  2c0f81:	89 45 a4             	mov    %eax,-0x5c(%rbp)
            num = negative ? -x : x;
  2c0f84:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
  2c0f88:	74 09                	je     2c0f93 <printer_vprintf+0x412>
  2c0f8a:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  2c0f8e:	48 f7 d8             	neg    %rax
  2c0f91:	eb 04                	jmp    2c0f97 <printer_vprintf+0x416>
  2c0f93:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  2c0f97:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  2c0f9b:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  2c0f9e:	83 c8 60             	or     $0x60,%eax
  2c0fa1:	09 45 ec             	or     %eax,-0x14(%rbp)
            break;
  2c0fa4:	e9 cf 02 00 00       	jmp    2c1278 <printer_vprintf+0x6f7>
        }
        case 'u':
        format_unsigned:
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  2c0fa9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
  2c0fad:	74 5d                	je     2c100c <printer_vprintf+0x48b>
  2c0faf:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0fb6:	8b 00                	mov    (%rax),%eax
  2c0fb8:	83 f8 2f             	cmp    $0x2f,%eax
  2c0fbb:	77 30                	ja     2c0fed <printer_vprintf+0x46c>
  2c0fbd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0fc4:	48 8b 50 10          	mov    0x10(%rax),%rdx
  2c0fc8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0fcf:	8b 00                	mov    (%rax),%eax
  2c0fd1:	89 c0                	mov    %eax,%eax
  2c0fd3:	48 01 d0             	add    %rdx,%rax
  2c0fd6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0fdd:	8b 12                	mov    (%rdx),%edx
  2c0fdf:	8d 4a 08             	lea    0x8(%rdx),%ecx
  2c0fe2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c0fe9:	89 0a                	mov    %ecx,(%rdx)
  2c0feb:	eb 1a                	jmp    2c1007 <printer_vprintf+0x486>
  2c0fed:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c0ff4:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c0ff8:	48 8d 48 08          	lea    0x8(%rax),%rcx
  2c0ffc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c1003:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  2c1007:	48 8b 00             	mov    (%rax),%rax
  2c100a:	eb 5c                	jmp    2c1068 <printer_vprintf+0x4e7>
  2c100c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c1013:	8b 00                	mov    (%rax),%eax
  2c1015:	83 f8 2f             	cmp    $0x2f,%eax
  2c1018:	77 30                	ja     2c104a <printer_vprintf+0x4c9>
  2c101a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c1021:	48 8b 50 10          	mov    0x10(%rax),%rdx
  2c1025:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c102c:	8b 00                	mov    (%rax),%eax
  2c102e:	89 c0                	mov    %eax,%eax
  2c1030:	48 01 d0             	add    %rdx,%rax
  2c1033:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c103a:	8b 12                	mov    (%rdx),%edx
  2c103c:	8d 4a 08             	lea    0x8(%rdx),%ecx
  2c103f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c1046:	89 0a                	mov    %ecx,(%rdx)
  2c1048:	eb 1a                	jmp    2c1064 <printer_vprintf+0x4e3>
  2c104a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c1051:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c1055:	48 8d 48 08          	lea    0x8(%rax),%rcx
  2c1059:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c1060:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  2c1064:	8b 00                	mov    (%rax),%eax
  2c1066:	89 c0                	mov    %eax,%eax
  2c1068:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC;
  2c106c:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
            break;
  2c1070:	e9 03 02 00 00       	jmp    2c1278 <printer_vprintf+0x6f7>
        case 'x':
            base = -16;
  2c1075:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            goto format_unsigned;
  2c107c:	e9 28 ff ff ff       	jmp    2c0fa9 <printer_vprintf+0x428>
        case 'X':
            base = 16;
  2c1081:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%rbp)
            goto format_unsigned;
  2c1088:	e9 1c ff ff ff       	jmp    2c0fa9 <printer_vprintf+0x428>
        case 'p':
            num = (uintptr_t) va_arg(val, void*);
  2c108d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c1094:	8b 00                	mov    (%rax),%eax
  2c1096:	83 f8 2f             	cmp    $0x2f,%eax
  2c1099:	77 30                	ja     2c10cb <printer_vprintf+0x54a>
  2c109b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c10a2:	48 8b 50 10          	mov    0x10(%rax),%rdx
  2c10a6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c10ad:	8b 00                	mov    (%rax),%eax
  2c10af:	89 c0                	mov    %eax,%eax
  2c10b1:	48 01 d0             	add    %rdx,%rax
  2c10b4:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c10bb:	8b 12                	mov    (%rdx),%edx
  2c10bd:	8d 4a 08             	lea    0x8(%rdx),%ecx
  2c10c0:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c10c7:	89 0a                	mov    %ecx,(%rdx)
  2c10c9:	eb 1a                	jmp    2c10e5 <printer_vprintf+0x564>
  2c10cb:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c10d2:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c10d6:	48 8d 48 08          	lea    0x8(%rax),%rcx
  2c10da:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c10e1:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  2c10e5:	48 8b 00             	mov    (%rax),%rax
  2c10e8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            base = -16;
  2c10ec:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  2c10f3:	81 4d ec 21 01 00 00 	orl    $0x121,-0x14(%rbp)
            break;
  2c10fa:	e9 79 01 00 00       	jmp    2c1278 <printer_vprintf+0x6f7>
        case 's':
            data = va_arg(val, char*);
  2c10ff:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c1106:	8b 00                	mov    (%rax),%eax
  2c1108:	83 f8 2f             	cmp    $0x2f,%eax
  2c110b:	77 30                	ja     2c113d <printer_vprintf+0x5bc>
  2c110d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c1114:	48 8b 50 10          	mov    0x10(%rax),%rdx
  2c1118:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c111f:	8b 00                	mov    (%rax),%eax
  2c1121:	89 c0                	mov    %eax,%eax
  2c1123:	48 01 d0             	add    %rdx,%rax
  2c1126:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c112d:	8b 12                	mov    (%rdx),%edx
  2c112f:	8d 4a 08             	lea    0x8(%rdx),%ecx
  2c1132:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c1139:	89 0a                	mov    %ecx,(%rdx)
  2c113b:	eb 1a                	jmp    2c1157 <printer_vprintf+0x5d6>
  2c113d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c1144:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c1148:	48 8d 48 08          	lea    0x8(%rax),%rcx
  2c114c:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c1153:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  2c1157:	48 8b 00             	mov    (%rax),%rax
  2c115a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            break;
  2c115e:	e9 15 01 00 00       	jmp    2c1278 <printer_vprintf+0x6f7>
        case 'C':
            color = va_arg(val, int);
  2c1163:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c116a:	8b 00                	mov    (%rax),%eax
  2c116c:	83 f8 2f             	cmp    $0x2f,%eax
  2c116f:	77 30                	ja     2c11a1 <printer_vprintf+0x620>
  2c1171:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c1178:	48 8b 50 10          	mov    0x10(%rax),%rdx
  2c117c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c1183:	8b 00                	mov    (%rax),%eax
  2c1185:	89 c0                	mov    %eax,%eax
  2c1187:	48 01 d0             	add    %rdx,%rax
  2c118a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c1191:	8b 12                	mov    (%rdx),%edx
  2c1193:	8d 4a 08             	lea    0x8(%rdx),%ecx
  2c1196:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c119d:	89 0a                	mov    %ecx,(%rdx)
  2c119f:	eb 1a                	jmp    2c11bb <printer_vprintf+0x63a>
  2c11a1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c11a8:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c11ac:	48 8d 48 08          	lea    0x8(%rax),%rcx
  2c11b0:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c11b7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  2c11bb:	8b 00                	mov    (%rax),%eax
  2c11bd:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
            goto done;
  2c11c3:	e9 67 03 00 00       	jmp    2c152f <printer_vprintf+0x9ae>
        case 'c':
            data = numbuf;
  2c11c8:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  2c11cc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = va_arg(val, int);
  2c11d0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c11d7:	8b 00                	mov    (%rax),%eax
  2c11d9:	83 f8 2f             	cmp    $0x2f,%eax
  2c11dc:	77 30                	ja     2c120e <printer_vprintf+0x68d>
  2c11de:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c11e5:	48 8b 50 10          	mov    0x10(%rax),%rdx
  2c11e9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c11f0:	8b 00                	mov    (%rax),%eax
  2c11f2:	89 c0                	mov    %eax,%eax
  2c11f4:	48 01 d0             	add    %rdx,%rax
  2c11f7:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c11fe:	8b 12                	mov    (%rdx),%edx
  2c1200:	8d 4a 08             	lea    0x8(%rdx),%ecx
  2c1203:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c120a:	89 0a                	mov    %ecx,(%rdx)
  2c120c:	eb 1a                	jmp    2c1228 <printer_vprintf+0x6a7>
  2c120e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
  2c1215:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c1219:	48 8d 48 08          	lea    0x8(%rax),%rcx
  2c121d:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
  2c1224:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  2c1228:	8b 00                	mov    (%rax),%eax
  2c122a:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  2c122d:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            break;
  2c1231:	eb 45                	jmp    2c1278 <printer_vprintf+0x6f7>
        default:
            data = numbuf;
  2c1233:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  2c1237:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = (*format ? *format : '%');
  2c123b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c1242:	0f b6 00             	movzbl (%rax),%eax
  2c1245:	84 c0                	test   %al,%al
  2c1247:	74 0c                	je     2c1255 <printer_vprintf+0x6d4>
  2c1249:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c1250:	0f b6 00             	movzbl (%rax),%eax
  2c1253:	eb 05                	jmp    2c125a <printer_vprintf+0x6d9>
  2c1255:	b8 25 00 00 00       	mov    $0x25,%eax
  2c125a:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
  2c125d:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            if (!*format) {
  2c1261:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c1268:	0f b6 00             	movzbl (%rax),%eax
  2c126b:	84 c0                	test   %al,%al
  2c126d:	75 08                	jne    2c1277 <printer_vprintf+0x6f6>
                format--;
  2c126f:	48 83 ad 68 ff ff ff 	subq   $0x1,-0x98(%rbp)
  2c1276:	01 
            }
            break;
  2c1277:	90                   	nop
        }

        if (flags & FLAG_NUMERIC) {
  2c1278:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c127b:	83 e0 20             	and    $0x20,%eax
  2c127e:	85 c0                	test   %eax,%eax
  2c1280:	74 1e                	je     2c12a0 <printer_vprintf+0x71f>
            data = fill_numbuf(numbuf + NUMBUFSIZ, num, base);
  2c1282:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
  2c1286:	48 83 c0 18          	add    $0x18,%rax
  2c128a:	8b 55 e0             	mov    -0x20(%rbp),%edx
  2c128d:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  2c1291:	48 89 ce             	mov    %rcx,%rsi
  2c1294:	48 89 c7             	mov    %rax,%rdi
  2c1297:	e8 63 f8 ff ff       	call   2c0aff <fill_numbuf>
  2c129c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        }

        const char* prefix = "";
  2c12a0:	48 c7 45 c0 36 19 2c 	movq   $0x2c1936,-0x40(%rbp)
  2c12a7:	00 
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  2c12a8:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c12ab:	83 e0 20             	and    $0x20,%eax
  2c12ae:	85 c0                	test   %eax,%eax
  2c12b0:	74 48                	je     2c12fa <printer_vprintf+0x779>
  2c12b2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c12b5:	83 e0 40             	and    $0x40,%eax
  2c12b8:	85 c0                	test   %eax,%eax
  2c12ba:	74 3e                	je     2c12fa <printer_vprintf+0x779>
            if (flags & FLAG_NEGATIVE) {
  2c12bc:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c12bf:	25 80 00 00 00       	and    $0x80,%eax
  2c12c4:	85 c0                	test   %eax,%eax
  2c12c6:	74 0a                	je     2c12d2 <printer_vprintf+0x751>
                prefix = "-";
  2c12c8:	48 c7 45 c0 37 19 2c 	movq   $0x2c1937,-0x40(%rbp)
  2c12cf:	00 
            if (flags & FLAG_NEGATIVE) {
  2c12d0:	eb 73                	jmp    2c1345 <printer_vprintf+0x7c4>
            } else if (flags & FLAG_PLUSPOSITIVE) {
  2c12d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c12d5:	83 e0 10             	and    $0x10,%eax
  2c12d8:	85 c0                	test   %eax,%eax
  2c12da:	74 0a                	je     2c12e6 <printer_vprintf+0x765>
                prefix = "+";
  2c12dc:	48 c7 45 c0 39 19 2c 	movq   $0x2c1939,-0x40(%rbp)
  2c12e3:	00 
            if (flags & FLAG_NEGATIVE) {
  2c12e4:	eb 5f                	jmp    2c1345 <printer_vprintf+0x7c4>
            } else if (flags & FLAG_SPACEPOSITIVE) {
  2c12e6:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c12e9:	83 e0 08             	and    $0x8,%eax
  2c12ec:	85 c0                	test   %eax,%eax
  2c12ee:	74 55                	je     2c1345 <printer_vprintf+0x7c4>
                prefix = " ";
  2c12f0:	48 c7 45 c0 3b 19 2c 	movq   $0x2c193b,-0x40(%rbp)
  2c12f7:	00 
            if (flags & FLAG_NEGATIVE) {
  2c12f8:	eb 4b                	jmp    2c1345 <printer_vprintf+0x7c4>
            }
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  2c12fa:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c12fd:	83 e0 20             	and    $0x20,%eax
  2c1300:	85 c0                	test   %eax,%eax
  2c1302:	74 42                	je     2c1346 <printer_vprintf+0x7c5>
  2c1304:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c1307:	83 e0 01             	and    $0x1,%eax
  2c130a:	85 c0                	test   %eax,%eax
  2c130c:	74 38                	je     2c1346 <printer_vprintf+0x7c5>
                   && (base == 16 || base == -16)
  2c130e:	83 7d e0 10          	cmpl   $0x10,-0x20(%rbp)
  2c1312:	74 06                	je     2c131a <printer_vprintf+0x799>
  2c1314:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  2c1318:	75 2c                	jne    2c1346 <printer_vprintf+0x7c5>
                   && (num || (flags & FLAG_ALT2))) {
  2c131a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
  2c131f:	75 0c                	jne    2c132d <printer_vprintf+0x7ac>
  2c1321:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c1324:	25 00 01 00 00       	and    $0x100,%eax
  2c1329:	85 c0                	test   %eax,%eax
  2c132b:	74 19                	je     2c1346 <printer_vprintf+0x7c5>
            prefix = (base == -16 ? "0x" : "0X");
  2c132d:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
  2c1331:	75 07                	jne    2c133a <printer_vprintf+0x7b9>
  2c1333:	b8 3d 19 2c 00       	mov    $0x2c193d,%eax
  2c1338:	eb 05                	jmp    2c133f <printer_vprintf+0x7be>
  2c133a:	b8 40 19 2c 00       	mov    $0x2c1940,%eax
  2c133f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  2c1343:	eb 01                	jmp    2c1346 <printer_vprintf+0x7c5>
            if (flags & FLAG_NEGATIVE) {
  2c1345:	90                   	nop
        }

        int len;
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  2c1346:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  2c134a:	78 24                	js     2c1370 <printer_vprintf+0x7ef>
  2c134c:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c134f:	83 e0 20             	and    $0x20,%eax
  2c1352:	85 c0                	test   %eax,%eax
  2c1354:	75 1a                	jne    2c1370 <printer_vprintf+0x7ef>
            len = strnlen(data, precision);
  2c1356:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  2c1359:	48 63 d0             	movslq %eax,%rdx
  2c135c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  2c1360:	48 89 d6             	mov    %rdx,%rsi
  2c1363:	48 89 c7             	mov    %rax,%rdi
  2c1366:	e8 ea f5 ff ff       	call   2c0955 <strnlen>
  2c136b:	89 45 bc             	mov    %eax,-0x44(%rbp)
  2c136e:	eb 0f                	jmp    2c137f <printer_vprintf+0x7fe>
        } else {
            len = strlen(data);
  2c1370:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  2c1374:	48 89 c7             	mov    %rax,%rdi
  2c1377:	e8 a8 f5 ff ff       	call   2c0924 <strlen>
  2c137c:	89 45 bc             	mov    %eax,-0x44(%rbp)
        }
        int zeros;
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  2c137f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c1382:	83 e0 20             	and    $0x20,%eax
  2c1385:	85 c0                	test   %eax,%eax
  2c1387:	74 20                	je     2c13a9 <printer_vprintf+0x828>
  2c1389:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
  2c138d:	78 1a                	js     2c13a9 <printer_vprintf+0x828>
            zeros = precision > len ? precision - len : 0;
  2c138f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  2c1392:	3b 45 bc             	cmp    -0x44(%rbp),%eax
  2c1395:	7e 08                	jle    2c139f <printer_vprintf+0x81e>
  2c1397:	8b 45 e4             	mov    -0x1c(%rbp),%eax
  2c139a:	2b 45 bc             	sub    -0x44(%rbp),%eax
  2c139d:	eb 05                	jmp    2c13a4 <printer_vprintf+0x823>
  2c139f:	b8 00 00 00 00       	mov    $0x0,%eax
  2c13a4:	89 45 b8             	mov    %eax,-0x48(%rbp)
  2c13a7:	eb 5c                	jmp    2c1405 <printer_vprintf+0x884>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  2c13a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c13ac:	83 e0 20             	and    $0x20,%eax
  2c13af:	85 c0                	test   %eax,%eax
  2c13b1:	74 4b                	je     2c13fe <printer_vprintf+0x87d>
  2c13b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c13b6:	83 e0 02             	and    $0x2,%eax
  2c13b9:	85 c0                	test   %eax,%eax
  2c13bb:	74 41                	je     2c13fe <printer_vprintf+0x87d>
                   && !(flags & FLAG_LEFTJUSTIFY)
  2c13bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c13c0:	83 e0 04             	and    $0x4,%eax
  2c13c3:	85 c0                	test   %eax,%eax
  2c13c5:	75 37                	jne    2c13fe <printer_vprintf+0x87d>
                   && len + (int) strlen(prefix) < width) {
  2c13c7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  2c13cb:	48 89 c7             	mov    %rax,%rdi
  2c13ce:	e8 51 f5 ff ff       	call   2c0924 <strlen>
  2c13d3:	89 c2                	mov    %eax,%edx
  2c13d5:	8b 45 bc             	mov    -0x44(%rbp),%eax
  2c13d8:	01 d0                	add    %edx,%eax
  2c13da:	39 45 e8             	cmp    %eax,-0x18(%rbp)
  2c13dd:	7e 1f                	jle    2c13fe <printer_vprintf+0x87d>
            zeros = width - len - strlen(prefix);
  2c13df:	8b 45 e8             	mov    -0x18(%rbp),%eax
  2c13e2:	2b 45 bc             	sub    -0x44(%rbp),%eax
  2c13e5:	89 c3                	mov    %eax,%ebx
  2c13e7:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  2c13eb:	48 89 c7             	mov    %rax,%rdi
  2c13ee:	e8 31 f5 ff ff       	call   2c0924 <strlen>
  2c13f3:	89 c2                	mov    %eax,%edx
  2c13f5:	89 d8                	mov    %ebx,%eax
  2c13f7:	29 d0                	sub    %edx,%eax
  2c13f9:	89 45 b8             	mov    %eax,-0x48(%rbp)
  2c13fc:	eb 07                	jmp    2c1405 <printer_vprintf+0x884>
        } else {
            zeros = 0;
  2c13fe:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
        }
        width -= len + zeros + strlen(prefix);
  2c1405:	8b 55 bc             	mov    -0x44(%rbp),%edx
  2c1408:	8b 45 b8             	mov    -0x48(%rbp),%eax
  2c140b:	01 d0                	add    %edx,%eax
  2c140d:	48 63 d8             	movslq %eax,%rbx
  2c1410:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  2c1414:	48 89 c7             	mov    %rax,%rdi
  2c1417:	e8 08 f5 ff ff       	call   2c0924 <strlen>
  2c141c:	48 8d 14 03          	lea    (%rbx,%rax,1),%rdx
  2c1420:	8b 45 e8             	mov    -0x18(%rbp),%eax
  2c1423:	29 d0                	sub    %edx,%eax
  2c1425:	89 45 e8             	mov    %eax,-0x18(%rbp)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  2c1428:	eb 25                	jmp    2c144f <printer_vprintf+0x8ce>
            p->putc(p, ' ', color);
  2c142a:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  2c1431:	48 8b 08             	mov    (%rax),%rcx
  2c1434:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  2c143a:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  2c1441:	be 20 00 00 00       	mov    $0x20,%esi
  2c1446:	48 89 c7             	mov    %rax,%rdi
  2c1449:	ff d1                	call   *%rcx
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  2c144b:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  2c144f:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c1452:	83 e0 04             	and    $0x4,%eax
  2c1455:	85 c0                	test   %eax,%eax
  2c1457:	75 36                	jne    2c148f <printer_vprintf+0x90e>
  2c1459:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  2c145d:	7f cb                	jg     2c142a <printer_vprintf+0x8a9>
        }
        for (; *prefix; ++prefix) {
  2c145f:	eb 2e                	jmp    2c148f <printer_vprintf+0x90e>
            p->putc(p, *prefix, color);
  2c1461:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  2c1468:	4c 8b 00             	mov    (%rax),%r8
  2c146b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  2c146f:	0f b6 00             	movzbl (%rax),%eax
  2c1472:	0f b6 c8             	movzbl %al,%ecx
  2c1475:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  2c147b:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  2c1482:	89 ce                	mov    %ecx,%esi
  2c1484:	48 89 c7             	mov    %rax,%rdi
  2c1487:	41 ff d0             	call   *%r8
        for (; *prefix; ++prefix) {
  2c148a:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
  2c148f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  2c1493:	0f b6 00             	movzbl (%rax),%eax
  2c1496:	84 c0                	test   %al,%al
  2c1498:	75 c7                	jne    2c1461 <printer_vprintf+0x8e0>
        }
        for (; zeros > 0; --zeros) {
  2c149a:	eb 25                	jmp    2c14c1 <printer_vprintf+0x940>
            p->putc(p, '0', color);
  2c149c:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  2c14a3:	48 8b 08             	mov    (%rax),%rcx
  2c14a6:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  2c14ac:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  2c14b3:	be 30 00 00 00       	mov    $0x30,%esi
  2c14b8:	48 89 c7             	mov    %rax,%rdi
  2c14bb:	ff d1                	call   *%rcx
        for (; zeros > 0; --zeros) {
  2c14bd:	83 6d b8 01          	subl   $0x1,-0x48(%rbp)
  2c14c1:	83 7d b8 00          	cmpl   $0x0,-0x48(%rbp)
  2c14c5:	7f d5                	jg     2c149c <printer_vprintf+0x91b>
        }
        for (; len > 0; ++data, --len) {
  2c14c7:	eb 32                	jmp    2c14fb <printer_vprintf+0x97a>
            p->putc(p, *data, color);
  2c14c9:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  2c14d0:	4c 8b 00             	mov    (%rax),%r8
  2c14d3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  2c14d7:	0f b6 00             	movzbl (%rax),%eax
  2c14da:	0f b6 c8             	movzbl %al,%ecx
  2c14dd:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  2c14e3:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  2c14ea:	89 ce                	mov    %ecx,%esi
  2c14ec:	48 89 c7             	mov    %rax,%rdi
  2c14ef:	41 ff d0             	call   *%r8
        for (; len > 0; ++data, --len) {
  2c14f2:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
  2c14f7:	83 6d bc 01          	subl   $0x1,-0x44(%rbp)
  2c14fb:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
  2c14ff:	7f c8                	jg     2c14c9 <printer_vprintf+0x948>
        }
        for (; width > 0; --width) {
  2c1501:	eb 25                	jmp    2c1528 <printer_vprintf+0x9a7>
            p->putc(p, ' ', color);
  2c1503:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  2c150a:	48 8b 08             	mov    (%rax),%rcx
  2c150d:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
  2c1513:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
  2c151a:	be 20 00 00 00       	mov    $0x20,%esi
  2c151f:	48 89 c7             	mov    %rax,%rdi
  2c1522:	ff d1                	call   *%rcx
        for (; width > 0; --width) {
  2c1524:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
  2c1528:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
  2c152c:	7f d5                	jg     2c1503 <printer_vprintf+0x982>
        }
    done: ;
  2c152e:	90                   	nop
    for (; *format; ++format) {
  2c152f:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
  2c1536:	01 
  2c1537:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
  2c153e:	0f b6 00             	movzbl (%rax),%eax
  2c1541:	84 c0                	test   %al,%al
  2c1543:	0f 85 64 f6 ff ff    	jne    2c0bad <printer_vprintf+0x2c>
    }
}
  2c1549:	90                   	nop
  2c154a:	90                   	nop
  2c154b:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  2c154f:	c9                   	leave
  2c1550:	c3                   	ret

00000000002c1551 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  2c1551:	55                   	push   %rbp
  2c1552:	48 89 e5             	mov    %rsp,%rbp
  2c1555:	48 83 ec 20          	sub    $0x20,%rsp
  2c1559:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  2c155d:	89 f0                	mov    %esi,%eax
  2c155f:	89 55 e0             	mov    %edx,-0x20(%rbp)
  2c1562:	88 45 e4             	mov    %al,-0x1c(%rbp)
    console_printer* cp = (console_printer*) p;
  2c1565:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  2c1569:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  2c156d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c1571:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c1575:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
  2c157a:	48 39 d0             	cmp    %rdx,%rax
  2c157d:	72 0c                	jb     2c158b <console_putc+0x3a>
        cp->cursor = console;
  2c157f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c1583:	48 c7 40 08 00 80 0b 	movq   $0xb8000,0x8(%rax)
  2c158a:	00 
    }
    if (c == '\n') {
  2c158b:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%rbp)
  2c158f:	75 78                	jne    2c1609 <console_putc+0xb8>
        int pos = (cp->cursor - console) % 80;
  2c1591:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c1595:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c1599:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  2c159f:	48 d1 f8             	sar    %rax
  2c15a2:	48 89 c1             	mov    %rax,%rcx
  2c15a5:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  2c15ac:	66 66 66 
  2c15af:	48 89 c8             	mov    %rcx,%rax
  2c15b2:	48 f7 ea             	imul   %rdx
  2c15b5:	48 c1 fa 05          	sar    $0x5,%rdx
  2c15b9:	48 89 c8             	mov    %rcx,%rax
  2c15bc:	48 c1 f8 3f          	sar    $0x3f,%rax
  2c15c0:	48 29 c2             	sub    %rax,%rdx
  2c15c3:	48 89 d0             	mov    %rdx,%rax
  2c15c6:	48 c1 e0 02          	shl    $0x2,%rax
  2c15ca:	48 01 d0             	add    %rdx,%rax
  2c15cd:	48 c1 e0 04          	shl    $0x4,%rax
  2c15d1:	48 29 c1             	sub    %rax,%rcx
  2c15d4:	48 89 ca             	mov    %rcx,%rdx
  2c15d7:	89 55 fc             	mov    %edx,-0x4(%rbp)
        for (; pos != 80; pos++) {
  2c15da:	eb 25                	jmp    2c1601 <console_putc+0xb0>
            *cp->cursor++ = ' ' | color;
  2c15dc:	8b 45 e0             	mov    -0x20(%rbp),%eax
  2c15df:	83 c8 20             	or     $0x20,%eax
  2c15e2:	89 c6                	mov    %eax,%esi
  2c15e4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c15e8:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c15ec:	48 8d 48 02          	lea    0x2(%rax),%rcx
  2c15f0:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  2c15f4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  2c15f8:	89 f2                	mov    %esi,%edx
  2c15fa:	66 89 10             	mov    %dx,(%rax)
        for (; pos != 80; pos++) {
  2c15fd:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  2c1601:	83 7d fc 50          	cmpl   $0x50,-0x4(%rbp)
  2c1605:	75 d5                	jne    2c15dc <console_putc+0x8b>
        }
    } else {
        *cp->cursor++ = c | color;
    }
}
  2c1607:	eb 24                	jmp    2c162d <console_putc+0xdc>
        *cp->cursor++ = c | color;
  2c1609:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
  2c160d:	8b 55 e0             	mov    -0x20(%rbp),%edx
  2c1610:	09 d0                	or     %edx,%eax
  2c1612:	89 c6                	mov    %eax,%esi
  2c1614:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c1618:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c161c:	48 8d 48 02          	lea    0x2(%rax),%rcx
  2c1620:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
  2c1624:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  2c1628:	89 f2                	mov    %esi,%edx
  2c162a:	66 89 10             	mov    %dx,(%rax)
}
  2c162d:	90                   	nop
  2c162e:	c9                   	leave
  2c162f:	c3                   	ret

00000000002c1630 <console_vprintf>:

int console_vprintf(int cpos, int color, const char* format, va_list val) {
  2c1630:	55                   	push   %rbp
  2c1631:	48 89 e5             	mov    %rsp,%rbp
  2c1634:	48 83 ec 30          	sub    $0x30,%rsp
  2c1638:	89 7d ec             	mov    %edi,-0x14(%rbp)
  2c163b:	89 75 e8             	mov    %esi,-0x18(%rbp)
  2c163e:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  2c1642:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
    struct console_printer cp;
    cp.p.putc = console_putc;
  2c1646:	48 c7 45 f0 51 15 2c 	movq   $0x2c1551,-0x10(%rbp)
  2c164d:	00 
    if (cpos < 0 || cpos >= CONSOLE_ROWS * CONSOLE_COLUMNS) {
  2c164e:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
  2c1652:	78 09                	js     2c165d <console_vprintf+0x2d>
  2c1654:	81 7d ec cf 07 00 00 	cmpl   $0x7cf,-0x14(%rbp)
  2c165b:	7e 07                	jle    2c1664 <console_vprintf+0x34>
        cpos = 0;
  2c165d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
    cp.cursor = console + cpos;
  2c1664:	8b 45 ec             	mov    -0x14(%rbp),%eax
  2c1667:	48 98                	cltq
  2c1669:	48 01 c0             	add    %rax,%rax
  2c166c:	48 05 00 80 0b 00    	add    $0xb8000,%rax
  2c1672:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  2c1676:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
  2c167a:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
  2c167e:	8b 75 e8             	mov    -0x18(%rbp),%esi
  2c1681:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
  2c1685:	48 89 c7             	mov    %rax,%rdi
  2c1688:	e8 f4 f4 ff ff       	call   2c0b81 <printer_vprintf>
    return cp.cursor - console;
  2c168d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c1691:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  2c1697:	48 d1 f8             	sar    %rax
}
  2c169a:	c9                   	leave
  2c169b:	c3                   	ret

00000000002c169c <console_printf>:

int console_printf(int cpos, int color, const char* format, ...) {
  2c169c:	55                   	push   %rbp
  2c169d:	48 89 e5             	mov    %rsp,%rbp
  2c16a0:	48 83 ec 60          	sub    $0x60,%rsp
  2c16a4:	89 7d ac             	mov    %edi,-0x54(%rbp)
  2c16a7:	89 75 a8             	mov    %esi,-0x58(%rbp)
  2c16aa:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
  2c16ae:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  2c16b2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  2c16b6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  2c16ba:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  2c16c1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  2c16c5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  2c16c9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  2c16cd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  2c16d1:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  2c16d5:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
  2c16d9:	8b 75 a8             	mov    -0x58(%rbp),%esi
  2c16dc:	8b 45 ac             	mov    -0x54(%rbp),%eax
  2c16df:	89 c7                	mov    %eax,%edi
  2c16e1:	e8 4a ff ff ff       	call   2c1630 <console_vprintf>
  2c16e6:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
  2c16e9:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
  2c16ec:	c9                   	leave
  2c16ed:	c3                   	ret

00000000002c16ee <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
  2c16ee:	55                   	push   %rbp
  2c16ef:	48 89 e5             	mov    %rsp,%rbp
  2c16f2:	48 83 ec 20          	sub    $0x20,%rsp
  2c16f6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
  2c16fa:	89 f0                	mov    %esi,%eax
  2c16fc:	89 55 e0             	mov    %edx,-0x20(%rbp)
  2c16ff:	88 45 e4             	mov    %al,-0x1c(%rbp)
    string_printer* sp = (string_printer*) p;
  2c1702:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
  2c1706:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (sp->s < sp->end) {
  2c170a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c170e:	48 8b 50 08          	mov    0x8(%rax),%rdx
  2c1712:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c1716:	48 8b 40 10          	mov    0x10(%rax),%rax
  2c171a:	48 39 c2             	cmp    %rax,%rdx
  2c171d:	73 1a                	jae    2c1739 <string_putc+0x4b>
        *sp->s++ = c;
  2c171f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  2c1723:	48 8b 40 08          	mov    0x8(%rax),%rax
  2c1727:	48 8d 48 01          	lea    0x1(%rax),%rcx
  2c172b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
  2c172f:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
  2c1733:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
  2c1737:	88 10                	mov    %dl,(%rax)
    }
    (void) color;
}
  2c1739:	90                   	nop
  2c173a:	c9                   	leave
  2c173b:	c3                   	ret

00000000002c173c <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  2c173c:	55                   	push   %rbp
  2c173d:	48 89 e5             	mov    %rsp,%rbp
  2c1740:	48 83 ec 40          	sub    $0x40,%rsp
  2c1744:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
  2c1748:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
  2c174c:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
  2c1750:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    string_printer sp;
    sp.p.putc = string_putc;
  2c1754:	48 c7 45 e8 ee 16 2c 	movq   $0x2c16ee,-0x18(%rbp)
  2c175b:	00 
    sp.s = s;
  2c175c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  2c1760:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (size) {
  2c1764:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
  2c1769:	74 33                	je     2c179e <vsnprintf+0x62>
        sp.end = s + size - 1;
  2c176b:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
  2c176f:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
  2c1773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
  2c1777:	48 01 d0             	add    %rdx,%rax
  2c177a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  2c177e:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
  2c1782:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
  2c1786:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
  2c178a:	be 00 00 00 00       	mov    $0x0,%esi
  2c178f:	48 89 c7             	mov    %rax,%rdi
  2c1792:	e8 ea f3 ff ff       	call   2c0b81 <printer_vprintf>
        *sp.s = 0;
  2c1797:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c179b:	c6 00 00             	movb   $0x0,(%rax)
    }
    return sp.s - s;
  2c179e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
  2c17a2:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
}
  2c17a6:	c9                   	leave
  2c17a7:	c3                   	ret

00000000002c17a8 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  2c17a8:	55                   	push   %rbp
  2c17a9:	48 89 e5             	mov    %rsp,%rbp
  2c17ac:	48 83 ec 70          	sub    $0x70,%rsp
  2c17b0:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
  2c17b4:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
  2c17b8:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
  2c17bc:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  2c17c0:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  2c17c4:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  2c17c8:	c7 45 b0 18 00 00 00 	movl   $0x18,-0x50(%rbp)
  2c17cf:	48 8d 45 10          	lea    0x10(%rbp),%rax
  2c17d3:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
  2c17d7:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  2c17db:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    int n = vsnprintf(s, size, format, val);
  2c17df:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
  2c17e3:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
  2c17e7:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
  2c17eb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
  2c17ef:	48 89 c7             	mov    %rax,%rdi
  2c17f2:	e8 45 ff ff ff       	call   2c173c <vsnprintf>
  2c17f7:	89 45 cc             	mov    %eax,-0x34(%rbp)
    va_end(val);
    return n;
  2c17fa:	8b 45 cc             	mov    -0x34(%rbp),%eax
}
  2c17fd:	c9                   	leave
  2c17fe:	c3                   	ret

00000000002c17ff <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
  2c17ff:	55                   	push   %rbp
  2c1800:	48 89 e5             	mov    %rsp,%rbp
  2c1803:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  2c1807:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  2c180e:	eb 13                	jmp    2c1823 <console_clear+0x24>
        console[i] = ' ' | 0x0700;
  2c1810:	8b 45 fc             	mov    -0x4(%rbp),%eax
  2c1813:	48 98                	cltq
  2c1815:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%rax,%rax,1)
  2c181c:	00 20 07 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  2c181f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
  2c1823:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
  2c182a:	7e e4                	jle    2c1810 <console_clear+0x11>
    }
    cursorpos = 0;
  2c182c:	c7 05 c6 77 df ff 00 	movl   $0x0,-0x20883a(%rip)        # b8ffc <cursorpos>
  2c1833:	00 00 00 
}
  2c1836:	90                   	nop
  2c1837:	c9                   	leave
  2c1838:	c3                   	ret
