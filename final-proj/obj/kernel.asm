
obj/kernel.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000040000 <entry_from_boot>:
# The entry_from_boot routine sets the stack pointer to the top of the
# OS kernel stack, then jumps to the `kernel` routine.

.globl entry_from_boot
entry_from_boot:
        movq $0x80000, %rsp
   40000:	48 c7 c4 00 00 08 00 	mov    $0x80000,%rsp
        movq %rsp, %rbp
   40007:	48 89 e5             	mov    %rsp,%rbp
        pushq $0
   4000a:	6a 00                	push   $0x0
        popfq
   4000c:	9d                   	popf
        // Check for multiboot command line; if found pass it along.
        cmpl $0x2BADB002, %eax
   4000d:	3d 02 b0 ad 2b       	cmp    $0x2badb002,%eax
        jne 1f
   40012:	75 0d                	jne    40021 <entry_from_boot+0x21>
        testl $4, (%rbx)
   40014:	f7 03 04 00 00 00    	testl  $0x4,(%rbx)
        je 1f
   4001a:	74 05                	je     40021 <entry_from_boot+0x21>
        movl 16(%rbx), %edi
   4001c:	8b 7b 10             	mov    0x10(%rbx),%edi
        jmp 2f
   4001f:	eb 07                	jmp    40028 <entry_from_boot+0x28>
1:      movq $0, %rdi
   40021:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
2:      jmp kernel
   40028:	e9 3a 01 00 00       	jmp    40167 <kernel>
   4002d:	90                   	nop

000000000004002e <gpf_int_handler>:
# Interrupt handlers
.align 2

        .globl gpf_int_handler
gpf_int_handler:
        pushq $13               // trap number
   4002e:	6a 0d                	push   $0xd
        jmp generic_exception_handler
   40030:	eb 6e                	jmp    400a0 <generic_exception_handler>

0000000000040032 <pagefault_int_handler>:

        .globl pagefault_int_handler
pagefault_int_handler:
        pushq $14
   40032:	6a 0e                	push   $0xe
        jmp generic_exception_handler
   40034:	eb 6a                	jmp    400a0 <generic_exception_handler>

0000000000040036 <timer_int_handler>:

        .globl timer_int_handler
timer_int_handler:
        pushq $0                // error code
   40036:	6a 00                	push   $0x0
        pushq $32
   40038:	6a 20                	push   $0x20
        jmp generic_exception_handler
   4003a:	eb 64                	jmp    400a0 <generic_exception_handler>

000000000004003c <sys48_int_handler>:

sys48_int_handler:
        pushq $0
   4003c:	6a 00                	push   $0x0
        pushq $48
   4003e:	6a 30                	push   $0x30
        jmp generic_exception_handler
   40040:	eb 5e                	jmp    400a0 <generic_exception_handler>

0000000000040042 <sys49_int_handler>:

sys49_int_handler:
        pushq $0
   40042:	6a 00                	push   $0x0
        pushq $49
   40044:	6a 31                	push   $0x31
        jmp generic_exception_handler
   40046:	eb 58                	jmp    400a0 <generic_exception_handler>

0000000000040048 <sys50_int_handler>:

sys50_int_handler:
        pushq $0
   40048:	6a 00                	push   $0x0
        pushq $50
   4004a:	6a 32                	push   $0x32
        jmp generic_exception_handler
   4004c:	eb 52                	jmp    400a0 <generic_exception_handler>

000000000004004e <sys51_int_handler>:

sys51_int_handler:
        pushq $0
   4004e:	6a 00                	push   $0x0
        pushq $51
   40050:	6a 33                	push   $0x33
        jmp generic_exception_handler
   40052:	eb 4c                	jmp    400a0 <generic_exception_handler>

0000000000040054 <sys52_int_handler>:

sys52_int_handler:
        pushq $0
   40054:	6a 00                	push   $0x0
        pushq $52
   40056:	6a 34                	push   $0x34
        jmp generic_exception_handler
   40058:	eb 46                	jmp    400a0 <generic_exception_handler>

000000000004005a <sys53_int_handler>:

sys53_int_handler:
        pushq $0
   4005a:	6a 00                	push   $0x0
        pushq $53
   4005c:	6a 35                	push   $0x35
        jmp generic_exception_handler
   4005e:	eb 40                	jmp    400a0 <generic_exception_handler>

0000000000040060 <sys54_int_handler>:

sys54_int_handler:
        pushq $0
   40060:	6a 00                	push   $0x0
        pushq $54
   40062:	6a 36                	push   $0x36
        jmp generic_exception_handler
   40064:	eb 3a                	jmp    400a0 <generic_exception_handler>

0000000000040066 <sys55_int_handler>:

sys55_int_handler:
        pushq $0
   40066:	6a 00                	push   $0x0
        pushq $55
   40068:	6a 37                	push   $0x37
        jmp generic_exception_handler
   4006a:	eb 34                	jmp    400a0 <generic_exception_handler>

000000000004006c <sys56_int_handler>:

sys56_int_handler:
        pushq $0
   4006c:	6a 00                	push   $0x0
        pushq $56
   4006e:	6a 38                	push   $0x38
        jmp generic_exception_handler
   40070:	eb 2e                	jmp    400a0 <generic_exception_handler>

0000000000040072 <sys57_int_handler>:

sys57_int_handler:
        pushq $0
   40072:	6a 00                	push   $0x0
        pushq $57
   40074:	6a 39                	push   $0x39
        jmp generic_exception_handler
   40076:	eb 28                	jmp    400a0 <generic_exception_handler>

0000000000040078 <sys58_int_handler>:

sys58_int_handler:
        pushq $0
   40078:	6a 00                	push   $0x0
        pushq $58
   4007a:	6a 3a                	push   $0x3a
        jmp generic_exception_handler
   4007c:	eb 22                	jmp    400a0 <generic_exception_handler>

000000000004007e <sys59_int_handler>:

sys59_int_handler:
        pushq $0
   4007e:	6a 00                	push   $0x0
        pushq $59
   40080:	6a 3b                	push   $0x3b
        jmp generic_exception_handler
   40082:	eb 1c                	jmp    400a0 <generic_exception_handler>

0000000000040084 <sys60_int_handler>:

sys60_int_handler:
        pushq $0
   40084:	6a 00                	push   $0x0
        pushq $60
   40086:	6a 3c                	push   $0x3c
        jmp generic_exception_handler
   40088:	eb 16                	jmp    400a0 <generic_exception_handler>

000000000004008a <sys61_int_handler>:

sys61_int_handler:
        pushq $0
   4008a:	6a 00                	push   $0x0
        pushq $61
   4008c:	6a 3d                	push   $0x3d
        jmp generic_exception_handler
   4008e:	eb 10                	jmp    400a0 <generic_exception_handler>

0000000000040090 <sys62_int_handler>:

sys62_int_handler:
        pushq $0
   40090:	6a 00                	push   $0x0
        pushq $62
   40092:	6a 3e                	push   $0x3e
        jmp generic_exception_handler
   40094:	eb 0a                	jmp    400a0 <generic_exception_handler>

0000000000040096 <sys63_int_handler>:

sys63_int_handler:
        pushq $0
   40096:	6a 00                	push   $0x0
        pushq $63
   40098:	6a 3f                	push   $0x3f
        jmp generic_exception_handler
   4009a:	eb 04                	jmp    400a0 <generic_exception_handler>

000000000004009c <default_int_handler>:

        .globl default_int_handler
default_int_handler:
        pushq $0
   4009c:	6a 00                	push   $0x0
        jmp generic_exception_handler
   4009e:	eb 00                	jmp    400a0 <generic_exception_handler>

00000000000400a0 <generic_exception_handler>:


generic_exception_handler:
        pushq %gs
   400a0:	0f a8                	push   %gs
        pushq %fs
   400a2:	0f a0                	push   %fs
        pushq %r15
   400a4:	41 57                	push   %r15
        pushq %r14
   400a6:	41 56                	push   %r14
        pushq %r13
   400a8:	41 55                	push   %r13
        pushq %r12
   400aa:	41 54                	push   %r12
        pushq %r11
   400ac:	41 53                	push   %r11
        pushq %r10
   400ae:	41 52                	push   %r10
        pushq %r9
   400b0:	41 51                	push   %r9
        pushq %r8
   400b2:	41 50                	push   %r8
        pushq %rdi
   400b4:	57                   	push   %rdi
        pushq %rsi
   400b5:	56                   	push   %rsi
        pushq %rbp
   400b6:	55                   	push   %rbp
        pushq %rbx
   400b7:	53                   	push   %rbx
        pushq %rdx
   400b8:	52                   	push   %rdx
        pushq %rcx
   400b9:	51                   	push   %rcx
        pushq %rax
   400ba:	50                   	push   %rax
        movq %rsp, %rdi
   400bb:	48 89 e7             	mov    %rsp,%rdi
        call exception
   400be:	e8 6c 06 00 00       	call   4072f <exception>

00000000000400c3 <exception_return>:
        # `exception` should never return.


        .globl exception_return
exception_return:
        movq %rdi, %rsp
   400c3:	48 89 fc             	mov    %rdi,%rsp
        popq %rax
   400c6:	58                   	pop    %rax
        popq %rcx
   400c7:	59                   	pop    %rcx
        popq %rdx
   400c8:	5a                   	pop    %rdx
        popq %rbx
   400c9:	5b                   	pop    %rbx
        popq %rbp
   400ca:	5d                   	pop    %rbp
        popq %rsi
   400cb:	5e                   	pop    %rsi
        popq %rdi
   400cc:	5f                   	pop    %rdi
        popq %r8
   400cd:	41 58                	pop    %r8
        popq %r9
   400cf:	41 59                	pop    %r9
        popq %r10
   400d1:	41 5a                	pop    %r10
        popq %r11
   400d3:	41 5b                	pop    %r11
        popq %r12
   400d5:	41 5c                	pop    %r12
        popq %r13
   400d7:	41 5d                	pop    %r13
        popq %r14
   400d9:	41 5e                	pop    %r14
        popq %r15
   400db:	41 5f                	pop    %r15
        popq %fs
   400dd:	0f a1                	pop    %fs
        popq %gs
   400df:	0f a9                	pop    %gs
        addq $16, %rsp
   400e1:	48 83 c4 10          	add    $0x10,%rsp
        iretq
   400e5:	48 cf                	iretq

00000000000400e7 <sys_int_handlers>:
   400e7:	3c 00                	cmp    $0x0,%al
   400e9:	04 00                	add    $0x0,%al
   400eb:	00 00                	add    %al,(%rax)
   400ed:	00 00                	add    %al,(%rax)
   400ef:	42 00 04 00          	add    %al,(%rax,%r8,1)
   400f3:	00 00                	add    %al,(%rax)
   400f5:	00 00                	add    %al,(%rax)
   400f7:	48 00 04 00          	rex.W add %al,(%rax,%rax,1)
   400fb:	00 00                	add    %al,(%rax)
   400fd:	00 00                	add    %al,(%rax)
   400ff:	4e 00 04 00          	rex.WRX add %r8b,(%rax,%r8,1)
   40103:	00 00                	add    %al,(%rax)
   40105:	00 00                	add    %al,(%rax)
   40107:	54                   	push   %rsp
   40108:	00 04 00             	add    %al,(%rax,%rax,1)
   4010b:	00 00                	add    %al,(%rax)
   4010d:	00 00                	add    %al,(%rax)
   4010f:	5a                   	pop    %rdx
   40110:	00 04 00             	add    %al,(%rax,%rax,1)
   40113:	00 00                	add    %al,(%rax)
   40115:	00 00                	add    %al,(%rax)
   40117:	60                   	(bad)
   40118:	00 04 00             	add    %al,(%rax,%rax,1)
   4011b:	00 00                	add    %al,(%rax)
   4011d:	00 00                	add    %al,(%rax)
   4011f:	66 00 04 00          	data16 add %al,(%rax,%rax,1)
   40123:	00 00                	add    %al,(%rax)
   40125:	00 00                	add    %al,(%rax)
   40127:	6c                   	insb   (%dx),%es:(%rdi)
   40128:	00 04 00             	add    %al,(%rax,%rax,1)
   4012b:	00 00                	add    %al,(%rax)
   4012d:	00 00                	add    %al,(%rax)
   4012f:	72 00                	jb     40131 <sys_int_handlers+0x4a>
   40131:	04 00                	add    $0x0,%al
   40133:	00 00                	add    %al,(%rax)
   40135:	00 00                	add    %al,(%rax)
   40137:	78 00                	js     40139 <sys_int_handlers+0x52>
   40139:	04 00                	add    $0x0,%al
   4013b:	00 00                	add    %al,(%rax)
   4013d:	00 00                	add    %al,(%rax)
   4013f:	7e 00                	jle    40141 <sys_int_handlers+0x5a>
   40141:	04 00                	add    $0x0,%al
   40143:	00 00                	add    %al,(%rax)
   40145:	00 00                	add    %al,(%rax)
   40147:	84 00                	test   %al,(%rax)
   40149:	04 00                	add    $0x0,%al
   4014b:	00 00                	add    %al,(%rax)
   4014d:	00 00                	add    %al,(%rax)
   4014f:	8a 00                	mov    (%rax),%al
   40151:	04 00                	add    $0x0,%al
   40153:	00 00                	add    %al,(%rax)
   40155:	00 00                	add    %al,(%rax)
   40157:	90                   	nop
   40158:	00 04 00             	add    %al,(%rax,%rax,1)
   4015b:	00 00                	add    %al,(%rax)
   4015d:	00 00                	add    %al,(%rax)
   4015f:	96                   	xchg   %eax,%esi
   40160:	00 04 00             	add    %al,(%rax,%rax,1)
   40163:	00 00                	add    %al,(%rax)
	...

0000000000040167 <kernel>:

// kernel(command)
//    Initialize the hardware and processes and start running. The `command`
//    string is an optional string passed from the boot loader.

void kernel(const char* command) {
   40167:	55                   	push   %rbp
   40168:	48 89 e5             	mov    %rsp,%rbp
   4016b:	48 83 ec 20          	sub    $0x20,%rsp
   4016f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    hardware_init();
   40173:	e8 af 14 00 00       	call   41627 <hardware_init>
    pageinfo_init();
   40178:	e8 33 0b 00 00       	call   40cb0 <pageinfo_init>
    console_clear();
   4017d:	e8 36 4a 00 00       	call   44bb8 <console_clear>
    timer_init(HZ);
   40182:	bf 64 00 00 00       	mov    $0x64,%edi
   40187:	e8 87 19 00 00       	call   41b13 <timer_init>

    // Set up process descriptors
    memset(processes, 0, sizeof(processes));
   4018c:	ba 00 0f 00 00       	mov    $0xf00,%edx
   40191:	be 00 00 00 00       	mov    $0x0,%esi
   40196:	bf 00 e0 04 00       	mov    $0x4e000,%edi
   4019b:	e8 fe 3a 00 00       	call   43c9e <memset>
    for (pid_t i = 0; i < NPROC; i++) {
   401a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   401a7:	eb 44                	jmp    401ed <kernel+0x86>
        processes[i].p_pid = i;
   401a9:	8b 45 fc             	mov    -0x4(%rbp),%eax
   401ac:	48 63 d0             	movslq %eax,%rdx
   401af:	48 89 d0             	mov    %rdx,%rax
   401b2:	48 c1 e0 04          	shl    $0x4,%rax
   401b6:	48 29 d0             	sub    %rdx,%rax
   401b9:	48 c1 e0 04          	shl    $0x4,%rax
   401bd:	48 8d 90 00 e0 04 00 	lea    0x4e000(%rax),%rdx
   401c4:	8b 45 fc             	mov    -0x4(%rbp),%eax
   401c7:	89 02                	mov    %eax,(%rdx)
        processes[i].p_state = P_FREE;
   401c9:	8b 45 fc             	mov    -0x4(%rbp),%eax
   401cc:	48 63 d0             	movslq %eax,%rdx
   401cf:	48 89 d0             	mov    %rdx,%rax
   401d2:	48 c1 e0 04          	shl    $0x4,%rax
   401d6:	48 29 d0             	sub    %rdx,%rax
   401d9:	48 c1 e0 04          	shl    $0x4,%rax
   401dd:	48 05 d8 e0 04 00    	add    $0x4e0d8,%rax
   401e3:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    for (pid_t i = 0; i < NPROC; i++) {
   401e9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   401ed:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   401f1:	7e b6                	jle    401a9 <kernel+0x42>
    }

    if (command && strcmp(command, "malloc") == 0) {
   401f3:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   401f8:	74 29                	je     40223 <kernel+0xbc>
   401fa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   401fe:	be 26 4c 04 00       	mov    $0x44c26,%esi
   40203:	48 89 c7             	mov    %rax,%rdi
   40206:	e8 8c 3b 00 00       	call   43d97 <strcmp>
   4020b:	85 c0                	test   %eax,%eax
   4020d:	75 14                	jne    40223 <kernel+0xbc>
        process_setup(1, 1);
   4020f:	be 01 00 00 00       	mov    $0x1,%esi
   40214:	bf 01 00 00 00       	mov    $0x1,%edi
   40219:	e8 b8 00 00 00       	call   402d6 <process_setup>
   4021e:	e9 a9 00 00 00       	jmp    402cc <kernel+0x165>
    } else if (command && strcmp(command, "alloctests") == 0) {
   40223:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40228:	74 26                	je     40250 <kernel+0xe9>
   4022a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4022e:	be 2d 4c 04 00       	mov    $0x44c2d,%esi
   40233:	48 89 c7             	mov    %rax,%rdi
   40236:	e8 5c 3b 00 00       	call   43d97 <strcmp>
   4023b:	85 c0                	test   %eax,%eax
   4023d:	75 11                	jne    40250 <kernel+0xe9>
        process_setup(1, 2);
   4023f:	be 02 00 00 00       	mov    $0x2,%esi
   40244:	bf 01 00 00 00       	mov    $0x1,%edi
   40249:	e8 88 00 00 00       	call   402d6 <process_setup>
   4024e:	eb 7c                	jmp    402cc <kernel+0x165>
    } else if (command && strcmp(command, "test") == 0){
   40250:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40255:	74 26                	je     4027d <kernel+0x116>
   40257:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4025b:	be 38 4c 04 00       	mov    $0x44c38,%esi
   40260:	48 89 c7             	mov    %rax,%rdi
   40263:	e8 2f 3b 00 00       	call   43d97 <strcmp>
   40268:	85 c0                	test   %eax,%eax
   4026a:	75 11                	jne    4027d <kernel+0x116>
        process_setup(1, 3);
   4026c:	be 03 00 00 00       	mov    $0x3,%esi
   40271:	bf 01 00 00 00       	mov    $0x1,%edi
   40276:	e8 5b 00 00 00       	call   402d6 <process_setup>
   4027b:	eb 4f                	jmp    402cc <kernel+0x165>
    } else if (command && strcmp(command, "test2") == 0) {
   4027d:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40282:	74 39                	je     402bd <kernel+0x156>
   40284:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40288:	be 3d 4c 04 00       	mov    $0x44c3d,%esi
   4028d:	48 89 c7             	mov    %rax,%rdi
   40290:	e8 02 3b 00 00       	call   43d97 <strcmp>
   40295:	85 c0                	test   %eax,%eax
   40297:	75 24                	jne    402bd <kernel+0x156>
        for (pid_t i = 1; i <= 2; ++i) {
   40299:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
   402a0:	eb 13                	jmp    402b5 <kernel+0x14e>
            process_setup(i, 3);
   402a2:	8b 45 f8             	mov    -0x8(%rbp),%eax
   402a5:	be 03 00 00 00       	mov    $0x3,%esi
   402aa:	89 c7                	mov    %eax,%edi
   402ac:	e8 25 00 00 00       	call   402d6 <process_setup>
        for (pid_t i = 1; i <= 2; ++i) {
   402b1:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   402b5:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
   402b9:	7e e7                	jle    402a2 <kernel+0x13b>
   402bb:	eb 0f                	jmp    402cc <kernel+0x165>
        }
    } else {
        process_setup(1, 0);
   402bd:	be 00 00 00 00       	mov    $0x0,%esi
   402c2:	bf 01 00 00 00       	mov    $0x1,%edi
   402c7:	e8 0a 00 00 00       	call   402d6 <process_setup>
    }

    // Switch to the first process using run()
    run(&processes[1]);
   402cc:	bf f0 e0 04 00       	mov    $0x4e0f0,%edi
   402d1:	e8 49 09 00 00       	call   40c1f <run>

00000000000402d6 <process_setup>:
// process_setup(pid, program_number)
//    Load application program `program_number` as process number `pid`.
//    This loads the application's code and data into memory, sets its
//    %rip and %rsp, gives it a stack page, and marks it as runnable.

void process_setup(pid_t pid, int program_number) {
   402d6:	55                   	push   %rbp
   402d7:	48 89 e5             	mov    %rsp,%rbp
   402da:	48 83 ec 10          	sub    $0x10,%rsp
   402de:	89 7d fc             	mov    %edi,-0x4(%rbp)
   402e1:	89 75 f8             	mov    %esi,-0x8(%rbp)
    process_init(&processes[pid], 0);
   402e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
   402e7:	48 63 d0             	movslq %eax,%rdx
   402ea:	48 89 d0             	mov    %rdx,%rax
   402ed:	48 c1 e0 04          	shl    $0x4,%rax
   402f1:	48 29 d0             	sub    %rdx,%rax
   402f4:	48 c1 e0 04          	shl    $0x4,%rax
   402f8:	48 05 00 e0 04 00    	add    $0x4e000,%rax
   402fe:	be 00 00 00 00       	mov    $0x0,%esi
   40303:	48 89 c7             	mov    %rax,%rdi
   40306:	e8 99 1a 00 00       	call   41da4 <process_init>
    assert(process_config_tables(pid) == 0);
   4030b:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4030e:	89 c7                	mov    %eax,%edi
   40310:	e8 52 31 00 00       	call   43467 <process_config_tables>
   40315:	85 c0                	test   %eax,%eax
   40317:	74 14                	je     4032d <process_setup+0x57>
   40319:	ba 48 4c 04 00       	mov    $0x44c48,%edx
   4031e:	be 77 00 00 00       	mov    $0x77,%esi
   40323:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   40328:	e8 45 22 00 00       	call   42572 <assert_fail>

    /* Calls program_load in k-loader */
    assert(process_load(&processes[pid], program_number) >= 0);
   4032d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40330:	48 63 d0             	movslq %eax,%rdx
   40333:	48 89 d0             	mov    %rdx,%rax
   40336:	48 c1 e0 04          	shl    $0x4,%rax
   4033a:	48 29 d0             	sub    %rdx,%rax
   4033d:	48 c1 e0 04          	shl    $0x4,%rax
   40341:	48 8d 90 00 e0 04 00 	lea    0x4e000(%rax),%rdx
   40348:	8b 45 f8             	mov    -0x8(%rbp),%eax
   4034b:	89 c6                	mov    %eax,%esi
   4034d:	48 89 d7             	mov    %rdx,%rdi
   40350:	e8 60 34 00 00       	call   437b5 <process_load>
   40355:	85 c0                	test   %eax,%eax
   40357:	79 14                	jns    4036d <process_setup+0x97>
   40359:	ba 78 4c 04 00       	mov    $0x44c78,%edx
   4035e:	be 7a 00 00 00       	mov    $0x7a,%esi
   40363:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   40368:	e8 05 22 00 00       	call   42572 <assert_fail>

    process_setup_stack(&processes[pid]);
   4036d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40370:	48 63 d0             	movslq %eax,%rdx
   40373:	48 89 d0             	mov    %rdx,%rax
   40376:	48 c1 e0 04          	shl    $0x4,%rax
   4037a:	48 29 d0             	sub    %rdx,%rax
   4037d:	48 c1 e0 04          	shl    $0x4,%rax
   40381:	48 05 00 e0 04 00    	add    $0x4e000,%rax
   40387:	48 89 c7             	mov    %rax,%rdi
   4038a:	e8 5e 34 00 00       	call   437ed <process_setup_stack>

    processes[pid].p_state = P_RUNNABLE;
   4038f:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40392:	48 63 d0             	movslq %eax,%rdx
   40395:	48 89 d0             	mov    %rdx,%rax
   40398:	48 c1 e0 04          	shl    $0x4,%rax
   4039c:	48 29 d0             	sub    %rdx,%rax
   4039f:	48 c1 e0 04          	shl    $0x4,%rax
   403a3:	48 05 d8 e0 04 00    	add    $0x4e0d8,%rax
   403a9:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
}
   403af:	90                   	nop
   403b0:	c9                   	leave
   403b1:	c3                   	ret

00000000000403b2 <assign_physical_page>:
// assign_physical_page(addr, owner)
//    Allocates the page with physical address `addr` to the given owner.
//    Fails if physical page `addr` was already allocated. Returns 0 on
//    success and -1 on failure. Used by the program loader.

int assign_physical_page(uintptr_t addr, int8_t owner) {
   403b2:	55                   	push   %rbp
   403b3:	48 89 e5             	mov    %rsp,%rbp
   403b6:	48 83 ec 10          	sub    $0x10,%rsp
   403ba:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   403be:	89 f0                	mov    %esi,%eax
   403c0:	88 45 f4             	mov    %al,-0xc(%rbp)
    if ((addr & 0xFFF) != 0
   403c3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   403c7:	25 ff 0f 00 00       	and    $0xfff,%eax
   403cc:	48 85 c0             	test   %rax,%rax
   403cf:	75 20                	jne    403f1 <assign_physical_page+0x3f>
        || addr >= MEMSIZE_PHYSICAL
   403d1:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   403d8:	00 
   403d9:	77 16                	ja     403f1 <assign_physical_page+0x3f>
        || pageinfo[PAGENUMBER(addr)].refcount != 0) {
   403db:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   403df:	48 c1 e8 0c          	shr    $0xc,%rax
   403e3:	48 98                	cltq
   403e5:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   403ec:	00 
   403ed:	84 c0                	test   %al,%al
   403ef:	74 07                	je     403f8 <assign_physical_page+0x46>
        return -1;
   403f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   403f6:	eb 2c                	jmp    40424 <assign_physical_page+0x72>
    } else {
        pageinfo[PAGENUMBER(addr)].refcount = 1;
   403f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   403fc:	48 c1 e8 0c          	shr    $0xc,%rax
   40400:	48 98                	cltq
   40402:	c6 84 00 21 ef 04 00 	movb   $0x1,0x4ef21(%rax,%rax,1)
   40409:	01 
        pageinfo[PAGENUMBER(addr)].owner = owner;
   4040a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4040e:	48 c1 e8 0c          	shr    $0xc,%rax
   40412:	48 98                	cltq
   40414:	0f b6 55 f4          	movzbl -0xc(%rbp),%edx
   40418:	88 94 00 20 ef 04 00 	mov    %dl,0x4ef20(%rax,%rax,1)
        return 0;
   4041f:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
   40424:	c9                   	leave
   40425:	c3                   	ret

0000000000040426 <syscall_fork>:

pid_t syscall_fork() {
   40426:	55                   	push   %rbp
   40427:	48 89 e5             	mov    %rsp,%rbp
    return process_fork(current);
   4042a:	48 8b 05 cf ea 00 00 	mov    0xeacf(%rip),%rax        # 4ef00 <current>
   40431:	48 89 c7             	mov    %rax,%rdi
   40434:	e8 67 34 00 00       	call   438a0 <process_fork>
}
   40439:	5d                   	pop    %rbp
   4043a:	c3                   	ret

000000000004043b <syscall_exit>:


void syscall_exit() {
   4043b:	55                   	push   %rbp
   4043c:	48 89 e5             	mov    %rsp,%rbp
    process_free(current->p_pid);
   4043f:	48 8b 05 ba ea 00 00 	mov    0xeaba(%rip),%rax        # 4ef00 <current>
   40446:	8b 00                	mov    (%rax),%eax
   40448:	89 c7                	mov    %eax,%edi
   4044a:	e8 36 2d 00 00       	call   43185 <process_free>
}
   4044f:	90                   	nop
   40450:	5d                   	pop    %rbp
   40451:	c3                   	ret

0000000000040452 <syscall_page_alloc>:

int syscall_page_alloc(uintptr_t addr) {
   40452:	55                   	push   %rbp
   40453:	48 89 e5             	mov    %rsp,%rbp
   40456:	48 83 ec 10          	sub    $0x10,%rsp
   4045a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    return process_page_alloc(current, addr);
   4045e:	48 8b 05 9b ea 00 00 	mov    0xea9b(%rip),%rax        # 4ef00 <current>
   40465:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   40469:	48 89 d6             	mov    %rdx,%rsi
   4046c:	48 89 c7             	mov    %rax,%rdi
   4046f:	e8 be 36 00 00       	call   43b32 <process_page_alloc>
}
   40474:	c9                   	leave
   40475:	c3                   	ret

0000000000040476 <sbrk>:


uintptr_t sbrk(proc * p, intptr_t difference) {
   40476:	55                   	push   %rbp
   40477:	48 89 e5             	mov    %rsp,%rbp
   4047a:	48 83 ec 40          	sub    $0x40,%rsp
   4047e:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   40482:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
    // TODO : Your code here
    uintptr_t addr = p->program_break + difference;
   40486:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4048a:	48 8b 50 08          	mov    0x8(%rax),%rdx
   4048e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   40492:	48 01 d0             	add    %rdx,%rax
   40495:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (addr < p->original_break || (uintptr_t) addr >= MEMSIZE_VIRTUAL - PAGESIZE) {
   40499:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4049d:	48 8b 40 10          	mov    0x10(%rax),%rax
   404a1:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
   404a5:	72 0a                	jb     404b1 <sbrk+0x3b>
   404a7:	48 81 7d f0 ff ef 2f 	cmpq   $0x2fefff,-0x10(%rbp)
   404ae:	00 
   404af:	76 0c                	jbe    404bd <sbrk+0x47>
        return (uintptr_t)-1; // Address is invalid
   404b1:	48 c7 c2 ff ff ff ff 	mov    $0xffffffffffffffff,%rdx
   404b8:	e9 21 01 00 00       	jmp    405de <sbrk+0x168>
    }
    if (difference < 0) {
   404bd:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
   404c2:	0f 89 ff 00 00 00    	jns    405c7 <sbrk+0x151>
        uintptr_t oldpage = PTE_ADDR(p->program_break - 1);
   404c8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   404cc:	48 8b 40 08          	mov    0x8(%rax),%rax
   404d0:	48 83 e8 01          	sub    $0x1,%rax
   404d4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   404da:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        for (oldpage; oldpage >= p->program_break + difference; oldpage -= PAGESIZE) {
   404de:	e9 cb 00 00 00       	jmp    405ae <sbrk+0x138>
            vamapping virtual_map = virtual_memory_lookup(p->p_pagetable, oldpage);
   404e3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   404e7:	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx
   404ee:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
   404f2:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   404f6:	48 89 ce             	mov    %rcx,%rsi
   404f9:	48 89 c7             	mov    %rax,%rdi
   404fc:	e8 33 27 00 00       	call   42c34 <virtual_memory_lookup>
            if (virtual_map.pn == -1) {
   40501:	8b 45 d8             	mov    -0x28(%rbp),%eax
   40504:	83 f8 ff             	cmp    $0xffffffff,%eax
   40507:	0f 84 98 00 00 00    	je     405a5 <sbrk+0x12f>
                continue;
            } else if (pageinfo[virtual_map.pn].owner == p->p_pid) {
   4050d:	8b 45 d8             	mov    -0x28(%rbp),%eax
   40510:	48 98                	cltq
   40512:	0f b6 84 00 20 ef 04 	movzbl 0x4ef20(%rax,%rax,1),%eax
   40519:	00 
   4051a:	0f be d0             	movsbl %al,%edx
   4051d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40521:	8b 00                	mov    (%rax),%eax
   40523:	39 c2                	cmp    %eax,%edx
   40525:	75 42                	jne    40569 <sbrk+0xf3>
                virtual_memory_map(p->p_pagetable, oldpage, virtual_map.pa, PAGESIZE, 0);
   40527:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   4052b:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4052f:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   40536:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   4053a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
   40540:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40545:	48 89 c7             	mov    %rax,%rdi
   40548:	e8 24 23 00 00       	call   42871 <virtual_memory_map>
                pageinfo[virtual_map.pn].owner = PO_FREE;
   4054d:	8b 45 d8             	mov    -0x28(%rbp),%eax
   40550:	48 98                	cltq
   40552:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   40559:	00 
                pageinfo[virtual_map.pn].refcount = 0;
   4055a:	8b 45 d8             	mov    -0x28(%rbp),%eax
   4055d:	48 98                	cltq
   4055f:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   40566:	00 
   40567:	eb 3d                	jmp    405a6 <sbrk+0x130>
            } else if (!(virtual_map.perm & PTE_W) && pageinfo[virtual_map.pn].owner > 0) {
   40569:	8b 45 e8             	mov    -0x18(%rbp),%eax
   4056c:	48 98                	cltq
   4056e:	83 e0 02             	and    $0x2,%eax
   40571:	48 85 c0             	test   %rax,%rax
   40574:	75 30                	jne    405a6 <sbrk+0x130>
   40576:	8b 45 d8             	mov    -0x28(%rbp),%eax
   40579:	48 98                	cltq
   4057b:	0f b6 84 00 20 ef 04 	movzbl 0x4ef20(%rax,%rax,1),%eax
   40582:	00 
   40583:	84 c0                	test   %al,%al
   40585:	7e 1f                	jle    405a6 <sbrk+0x130>
                pageinfo[virtual_map.pn].refcount -= 1;
   40587:	8b 45 d8             	mov    -0x28(%rbp),%eax
   4058a:	48 98                	cltq
   4058c:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   40593:	00 
   40594:	8d 50 ff             	lea    -0x1(%rax),%edx
   40597:	8b 45 d8             	mov    -0x28(%rbp),%eax
   4059a:	48 98                	cltq
   4059c:	88 94 00 21 ef 04 00 	mov    %dl,0x4ef21(%rax,%rax,1)
   405a3:	eb 01                	jmp    405a6 <sbrk+0x130>
                continue;
   405a5:	90                   	nop
        for (oldpage; oldpage >= p->program_break + difference; oldpage -= PAGESIZE) {
   405a6:	48 81 6d f8 00 10 00 	subq   $0x1000,-0x8(%rbp)
   405ad:	00 
   405ae:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   405b2:	48 8b 50 08          	mov    0x8(%rax),%rdx
   405b6:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   405ba:	48 01 d0             	add    %rdx,%rax
   405bd:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   405c1:	0f 83 1c ff ff ff    	jae    404e3 <sbrk+0x6d>
            }
        }
    }
    p->program_break = addr;
   405c7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   405cb:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   405cf:	48 89 50 08          	mov    %rdx,0x8(%rax)
    return addr - difference;
   405d3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   405d7:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   405db:	48 29 c2             	sub    %rax,%rdx
}
   405de:	48 89 d0             	mov    %rdx,%rax
   405e1:	c9                   	leave
   405e2:	c3                   	ret

00000000000405e3 <syscall_mapping>:


void syscall_mapping(proc* p){
   405e3:	55                   	push   %rbp
   405e4:	48 89 e5             	mov    %rsp,%rbp
   405e7:	48 83 ec 70          	sub    $0x70,%rsp
   405eb:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)
    uintptr_t mapping_ptr = p->p_registers.reg_rdi;
   405ef:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   405f3:	48 8b 40 48          	mov    0x48(%rax),%rax
   405f7:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    uintptr_t ptr = p->p_registers.reg_rsi;
   405fb:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   405ff:	48 8b 40 40          	mov    0x40(%rax),%rax
   40603:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

    //convert to physical address so kernel can write to it
    vamapping map = virtual_memory_lookup(p->p_pagetable, mapping_ptr);
   40607:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   4060b:	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx
   40612:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   40616:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   4061a:	48 89 ce             	mov    %rcx,%rsi
   4061d:	48 89 c7             	mov    %rax,%rdi
   40620:	e8 0f 26 00 00       	call   42c34 <virtual_memory_lookup>

    // check for write access
    if((map.perm & (PTE_W|PTE_U)) != (PTE_W|PTE_U))
   40625:	8b 45 e0             	mov    -0x20(%rbp),%eax
   40628:	48 98                	cltq
   4062a:	83 e0 06             	and    $0x6,%eax
   4062d:	48 83 f8 06          	cmp    $0x6,%rax
   40631:	0f 85 89 00 00 00    	jne    406c0 <syscall_mapping+0xdd>
        return;
    uintptr_t endaddr = mapping_ptr + sizeof(vamapping) - 1;
   40637:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4063b:	48 83 c0 17          	add    $0x17,%rax
   4063f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    if (PAGENUMBER(endaddr) != PAGENUMBER(ptr)){
   40643:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40647:	48 c1 e8 0c          	shr    $0xc,%rax
   4064b:	89 c2                	mov    %eax,%edx
   4064d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   40651:	48 c1 e8 0c          	shr    $0xc,%rax
   40655:	39 c2                	cmp    %eax,%edx
   40657:	74 2c                	je     40685 <syscall_mapping+0xa2>
        vamapping end_map = virtual_memory_lookup(p->p_pagetable, endaddr);
   40659:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   4065d:	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx
   40664:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
   40668:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   4066c:	48 89 ce             	mov    %rcx,%rsi
   4066f:	48 89 c7             	mov    %rax,%rdi
   40672:	e8 bd 25 00 00       	call   42c34 <virtual_memory_lookup>
        // check for write access for end address
        if((end_map.perm & (PTE_W|PTE_P)) != (PTE_W|PTE_P))
   40677:	8b 45 b0             	mov    -0x50(%rbp),%eax
   4067a:	48 98                	cltq
   4067c:	83 e0 03             	and    $0x3,%eax
   4067f:	48 83 f8 03          	cmp    $0x3,%rax
   40683:	75 3e                	jne    406c3 <syscall_mapping+0xe0>
            return; 
    }
    // find the actual mapping now
    vamapping ptr_lookup = virtual_memory_lookup(p->p_pagetable, ptr);
   40685:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   40689:	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx
   40690:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
   40694:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40698:	48 89 ce             	mov    %rcx,%rsi
   4069b:	48 89 c7             	mov    %rax,%rdi
   4069e:	e8 91 25 00 00       	call   42c34 <virtual_memory_lookup>
    memcpy((void *)map.pa, &ptr_lookup, sizeof(vamapping));
   406a3:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   406a7:	48 89 c1             	mov    %rax,%rcx
   406aa:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
   406ae:	ba 18 00 00 00       	mov    $0x18,%edx
   406b3:	48 89 c6             	mov    %rax,%rsi
   406b6:	48 89 cf             	mov    %rcx,%rdi
   406b9:	e8 e2 34 00 00       	call   43ba0 <memcpy>
   406be:	eb 04                	jmp    406c4 <syscall_mapping+0xe1>
        return;
   406c0:	90                   	nop
   406c1:	eb 01                	jmp    406c4 <syscall_mapping+0xe1>
            return; 
   406c3:	90                   	nop
}
   406c4:	c9                   	leave
   406c5:	c3                   	ret

00000000000406c6 <syscall_mem_tog>:

void syscall_mem_tog(proc* process){
   406c6:	55                   	push   %rbp
   406c7:	48 89 e5             	mov    %rsp,%rbp
   406ca:	48 83 ec 18          	sub    $0x18,%rsp
   406ce:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

    pid_t p = process->p_registers.reg_rdi;
   406d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   406d6:	48 8b 40 48          	mov    0x48(%rax),%rax
   406da:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if(p == 0) {
   406dd:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   406e1:	75 14                	jne    406f7 <syscall_mem_tog+0x31>
        disp_global = !disp_global;
   406e3:	0f b6 05 16 59 00 00 	movzbl 0x5916(%rip),%eax        # 46000 <disp_global>
   406ea:	84 c0                	test   %al,%al
   406ec:	0f 94 c0             	sete   %al
   406ef:	88 05 0b 59 00 00    	mov    %al,0x590b(%rip)        # 46000 <disp_global>
   406f5:	eb 36                	jmp    4072d <syscall_mem_tog+0x67>
    }
    else {
        if(p < 0 || p > NPROC || p != process->p_pid)
   406f7:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   406fb:	78 2f                	js     4072c <syscall_mem_tog+0x66>
   406fd:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
   40701:	7f 29                	jg     4072c <syscall_mem_tog+0x66>
   40703:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40707:	8b 00                	mov    (%rax),%eax
   40709:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   4070c:	75 1e                	jne    4072c <syscall_mem_tog+0x66>
            return;
        process->display_status = !(process->display_status);
   4070e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40712:	0f b6 80 e8 00 00 00 	movzbl 0xe8(%rax),%eax
   40719:	84 c0                	test   %al,%al
   4071b:	0f 94 c0             	sete   %al
   4071e:	89 c2                	mov    %eax,%edx
   40720:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40724:	88 90 e8 00 00 00    	mov    %dl,0xe8(%rax)
   4072a:	eb 01                	jmp    4072d <syscall_mem_tog+0x67>
            return;
   4072c:	90                   	nop
    }
}
   4072d:	c9                   	leave
   4072e:	c3                   	ret

000000000004072f <exception>:
//    k-exception.S). That code saves more registers on the kernel's stack,
//    then calls exception().
//
//    Note that hardware interrupts are disabled whenever the kernel is running.

void exception(x86_64_registers* reg) {
   4072f:	55                   	push   %rbp
   40730:	48 89 e5             	mov    %rsp,%rbp
   40733:	53                   	push   %rbx
   40734:	48 81 ec 18 01 00 00 	sub    $0x118,%rsp
   4073b:	48 89 bd e8 fe ff ff 	mov    %rdi,-0x118(%rbp)
    // Copy the saved registers into the `current` process descriptor
    // and always use the kernel's page table.
    current->p_registers = *reg;
   40742:	48 8b 05 b7 e7 00 00 	mov    0xe7b7(%rip),%rax        # 4ef00 <current>
   40749:	48 8b 95 e8 fe ff ff 	mov    -0x118(%rbp),%rdx
   40750:	48 83 c0 18          	add    $0x18,%rax
   40754:	48 89 d6             	mov    %rdx,%rsi
   40757:	ba 18 00 00 00       	mov    $0x18,%edx
   4075c:	48 89 c7             	mov    %rax,%rdi
   4075f:	48 89 d1             	mov    %rdx,%rcx
   40762:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    set_pagetable(kernel_pagetable);
   40765:	48 8b 05 94 08 01 00 	mov    0x10894(%rip),%rax        # 51000 <kernel_pagetable>
   4076c:	48 89 c7             	mov    %rax,%rdi
   4076f:	e8 cc 1f 00 00       	call   42740 <set_pagetable>
    // Events logged this way are stored in the host's `log.txt` file.
    /*log_printf("proc %d: exception %d\n", current->p_pid, reg->reg_intno);*/

    // Show the current cursor location and memory state
    // (unless this is a kernel fault).
    console_show_cursor(cursorpos);
   40774:	8b 05 82 88 07 00    	mov    0x78882(%rip),%eax        # b8ffc <cursorpos>
   4077a:	89 c7                	mov    %eax,%edi
   4077c:	e8 ed 16 00 00       	call   41e6e <console_show_cursor>
    if ((reg->reg_intno != INT_PAGEFAULT
   40781:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   40788:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   4078f:	48 83 f8 0e          	cmp    $0xe,%rax
   40793:	74 14                	je     407a9 <exception+0x7a>
	    && reg->reg_intno != INT_GPF)
   40795:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   4079c:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   407a3:	48 83 f8 0d          	cmp    $0xd,%rax
   407a7:	75 16                	jne    407bf <exception+0x90>
            || (reg->reg_err & PFERR_USER)) {
   407a9:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   407b0:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   407b7:	83 e0 04             	and    $0x4,%eax
   407ba:	48 85 c0             	test   %rax,%rax
   407bd:	74 1a                	je     407d9 <exception+0xaa>
        check_virtual_memory();
   407bf:	e8 7b 08 00 00       	call   4103f <check_virtual_memory>
        if(disp_global){
   407c4:	0f b6 05 35 58 00 00 	movzbl 0x5835(%rip),%eax        # 46000 <disp_global>
   407cb:	84 c0                	test   %al,%al
   407cd:	74 0a                	je     407d9 <exception+0xaa>
            memshow_physical();
   407cf:	e8 e3 09 00 00       	call   411b7 <memshow_physical>
            memshow_virtual_animate();
   407d4:	e8 05 0d 00 00       	call   414de <memshow_virtual_animate>
        }
    }

    // If Control-C was typed, exit the virtual machine.
    check_keyboard();
   407d9:	e8 73 1b 00 00       	call   42351 <check_keyboard>


    // Actually handle the exception.
    switch (reg->reg_intno) {
   407de:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   407e5:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   407ec:	48 83 e8 0e          	sub    $0xe,%rax
   407f0:	48 83 f8 2c          	cmp    $0x2c,%rax
   407f4:	0f 87 72 03 00 00    	ja     40b6c <exception+0x43d>
   407fa:	48 8b 04 c5 38 4d 04 	mov    0x44d38(,%rax,8),%rax
   40801:	00 
   40802:	ff e0                	jmp    *%rax
        case INT_SYS_PANIC:
            {
                // rdi stores pointer for msg string
                {
                    char msg[160];
                    uintptr_t addr = current->p_registers.reg_rdi;
   40804:	48 8b 05 f5 e6 00 00 	mov    0xe6f5(%rip),%rax        # 4ef00 <current>
   4080b:	48 8b 40 48          	mov    0x48(%rax),%rax
   4080f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
                    if((void *)addr == NULL)
   40813:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   40818:	75 0f                	jne    40829 <exception+0xfa>
                        kernel_panic(NULL);
   4081a:	bf 00 00 00 00       	mov    $0x0,%edi
   4081f:	b8 00 00 00 00       	mov    $0x0,%eax
   40824:	e8 69 1c 00 00       	call   42492 <kernel_panic>
                    vamapping map = virtual_memory_lookup(current->p_pagetable, addr);
   40829:	48 8b 05 d0 e6 00 00 	mov    0xe6d0(%rip),%rax        # 4ef00 <current>
   40830:	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx
   40837:	48 8d 45 90          	lea    -0x70(%rbp),%rax
   4083b:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   4083f:	48 89 ce             	mov    %rcx,%rsi
   40842:	48 89 c7             	mov    %rax,%rdi
   40845:	e8 ea 23 00 00       	call   42c34 <virtual_memory_lookup>
                    memcpy(msg, (void *)map.pa, 160);
   4084a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   4084e:	48 89 c1             	mov    %rax,%rcx
   40851:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
   40858:	ba a0 00 00 00       	mov    $0xa0,%edx
   4085d:	48 89 ce             	mov    %rcx,%rsi
   40860:	48 89 c7             	mov    %rax,%rdi
   40863:	e8 38 33 00 00       	call   43ba0 <memcpy>
                    kernel_panic(msg);
   40868:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
   4086f:	48 89 c7             	mov    %rax,%rdi
   40872:	b8 00 00 00 00       	mov    $0x0,%eax
   40877:	e8 16 1c 00 00       	call   42492 <kernel_panic>
                kernel_panic(NULL);
                break;                  // will not be reached
            }
        case INT_SYS_GETPID:
            {
                current->p_registers.reg_rax = current->p_pid;
   4087c:	48 8b 05 7d e6 00 00 	mov    0xe67d(%rip),%rax        # 4ef00 <current>
   40883:	8b 10                	mov    (%rax),%edx
   40885:	48 8b 05 74 e6 00 00 	mov    0xe674(%rip),%rax        # 4ef00 <current>
   4088c:	48 63 d2             	movslq %edx,%rdx
   4088f:	48 89 50 18          	mov    %rdx,0x18(%rax)
                break;
   40893:	e9 e4 02 00 00       	jmp    40b7c <exception+0x44d>
            }
        case INT_SYS_FORK:
            {
                current->p_registers.reg_rax = syscall_fork();
   40898:	b8 00 00 00 00       	mov    $0x0,%eax
   4089d:	e8 84 fb ff ff       	call   40426 <syscall_fork>
   408a2:	89 c2                	mov    %eax,%edx
   408a4:	48 8b 05 55 e6 00 00 	mov    0xe655(%rip),%rax        # 4ef00 <current>
   408ab:	48 63 d2             	movslq %edx,%rdx
   408ae:	48 89 50 18          	mov    %rdx,0x18(%rax)
                break;
   408b2:	e9 c5 02 00 00       	jmp    40b7c <exception+0x44d>
            }
        case INT_SYS_MAPPING:
            {
                syscall_mapping(current);
   408b7:	48 8b 05 42 e6 00 00 	mov    0xe642(%rip),%rax        # 4ef00 <current>
   408be:	48 89 c7             	mov    %rax,%rdi
   408c1:	e8 1d fd ff ff       	call   405e3 <syscall_mapping>
                break;
   408c6:	e9 b1 02 00 00       	jmp    40b7c <exception+0x44d>
            }

        case INT_SYS_EXIT:
            {
                syscall_exit();
   408cb:	b8 00 00 00 00       	mov    $0x0,%eax
   408d0:	e8 66 fb ff ff       	call   4043b <syscall_exit>
                schedule();
   408d5:	e8 cf 02 00 00       	call   40ba9 <schedule>
                break;
   408da:	e9 9d 02 00 00       	jmp    40b7c <exception+0x44d>
            }

        case INT_SYS_YIELD:
            {
                schedule();
   408df:	e8 c5 02 00 00       	call   40ba9 <schedule>
                break;                  /* will not be reached */
   408e4:	e9 93 02 00 00       	jmp    40b7c <exception+0x44d>
            }

        case INT_SYS_BRK:
            {
                // TODO : Your code here 
                uintptr_t prog_break = sbrk(current, current->p_registers.reg_rdi - current->program_break);
   408e9:	48 8b 05 10 e6 00 00 	mov    0xe610(%rip),%rax        # 4ef00 <current>
   408f0:	48 8b 50 48          	mov    0x48(%rax),%rdx
   408f4:	48 8b 05 05 e6 00 00 	mov    0xe605(%rip),%rax        # 4ef00 <current>
   408fb:	48 8b 40 08          	mov    0x8(%rax),%rax
   408ff:	48 29 c2             	sub    %rax,%rdx
   40902:	48 8b 05 f7 e5 00 00 	mov    0xe5f7(%rip),%rax        # 4ef00 <current>
   40909:	48 89 d6             	mov    %rdx,%rsi
   4090c:	48 89 c7             	mov    %rax,%rdi
   4090f:	e8 62 fb ff ff       	call   40476 <sbrk>
   40914:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
                if (prog_break == (uintptr_t)-1) {
   40918:	48 83 7d e8 ff       	cmpq   $0xffffffffffffffff,-0x18(%rbp)
   4091d:	75 14                	jne    40933 <exception+0x204>
                    current->p_registers.reg_rax = -1;
   4091f:	48 8b 05 da e5 00 00 	mov    0xe5da(%rip),%rax        # 4ef00 <current>
   40926:	48 c7 40 18 ff ff ff 	movq   $0xffffffffffffffff,0x18(%rax)
   4092d:	ff 
                } else {
                    current->p_registers.reg_rax = 0;
                }
		        break; 
   4092e:	e9 49 02 00 00       	jmp    40b7c <exception+0x44d>
                    current->p_registers.reg_rax = 0;
   40933:	48 8b 05 c6 e5 00 00 	mov    0xe5c6(%rip),%rax        # 4ef00 <current>
   4093a:	48 c7 40 18 00 00 00 	movq   $0x0,0x18(%rax)
   40941:	00 
		        break; 
   40942:	e9 35 02 00 00       	jmp    40b7c <exception+0x44d>
            }

        case INT_SYS_SBRK:
            {
                // TODO : Your code here
                current->p_registers.reg_rax = (uint64_t) sbrk(current, current->p_registers.reg_rdi);
   40947:	48 8b 05 b2 e5 00 00 	mov    0xe5b2(%rip),%rax        # 4ef00 <current>
   4094e:	48 8b 40 48          	mov    0x48(%rax),%rax
   40952:	48 89 c2             	mov    %rax,%rdx
   40955:	48 8b 05 a4 e5 00 00 	mov    0xe5a4(%rip),%rax        # 4ef00 <current>
   4095c:	48 8b 1d 9d e5 00 00 	mov    0xe59d(%rip),%rbx        # 4ef00 <current>
   40963:	48 89 d6             	mov    %rdx,%rsi
   40966:	48 89 c7             	mov    %rax,%rdi
   40969:	e8 08 fb ff ff       	call   40476 <sbrk>
   4096e:	48 89 43 18          	mov    %rax,0x18(%rbx)
                break;
   40972:	e9 05 02 00 00       	jmp    40b7c <exception+0x44d>
            }
	case INT_SYS_PAGE_ALLOC:
	    {
		intptr_t addr = reg->reg_rdi;
   40977:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   4097e:	48 8b 40 30          	mov    0x30(%rax),%rax
   40982:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
		syscall_page_alloc(addr);
   40986:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4098a:	48 89 c7             	mov    %rax,%rdi
   4098d:	e8 c0 fa ff ff       	call   40452 <syscall_page_alloc>
		break;
   40992:	e9 e5 01 00 00       	jmp    40b7c <exception+0x44d>
	    }
        case INT_SYS_MEM_TOG:
            {
                syscall_mem_tog(current);
   40997:	48 8b 05 62 e5 00 00 	mov    0xe562(%rip),%rax        # 4ef00 <current>
   4099e:	48 89 c7             	mov    %rax,%rdi
   409a1:	e8 20 fd ff ff       	call   406c6 <syscall_mem_tog>
                break;
   409a6:	e9 d1 01 00 00       	jmp    40b7c <exception+0x44d>
            }

        case INT_TIMER:
            {
                ++ticks;
   409ab:	8b 05 6f e9 00 00    	mov    0xe96f(%rip),%eax        # 4f320 <ticks>
   409b1:	83 c0 01             	add    $0x1,%eax
   409b4:	89 05 66 e9 00 00    	mov    %eax,0xe966(%rip)        # 4f320 <ticks>
                schedule();
   409ba:	e8 ea 01 00 00       	call   40ba9 <schedule>
                break;                  /* will not be reached */
   409bf:	e9 b8 01 00 00       	jmp    40b7c <exception+0x44d>
    return val;
}

static inline uintptr_t rcr2(void) {
    uintptr_t val;
    asm volatile("movq %%cr2,%0" : "=r" (val));
   409c4:	0f 20 d0             	mov    %cr2,%rax
   409c7:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
    return val;
   409cb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
            }

        case INT_PAGEFAULT: 
            {
                // Analyze faulting address and access type.
                uintptr_t addr = rcr2();
   409cf:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
                const char* operation = reg->reg_err & PFERR_WRITE
   409d3:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   409da:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   409e1:	83 e0 02             	and    $0x2,%eax
                    ? "write" : "read";
   409e4:	48 85 c0             	test   %rax,%rax
   409e7:	74 07                	je     409f0 <exception+0x2c1>
   409e9:	b8 ab 4c 04 00       	mov    $0x44cab,%eax
   409ee:	eb 05                	jmp    409f5 <exception+0x2c6>
   409f0:	b8 b1 4c 04 00       	mov    $0x44cb1,%eax
                const char* operation = reg->reg_err & PFERR_WRITE
   409f5:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
                const char* problem = reg->reg_err & PFERR_PRESENT
   409f9:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   40a00:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40a07:	83 e0 01             	and    $0x1,%eax
                    ? "protection problem" : "missing page";
   40a0a:	48 85 c0             	test   %rax,%rax
   40a0d:	74 07                	je     40a16 <exception+0x2e7>
   40a0f:	b8 b6 4c 04 00       	mov    $0x44cb6,%eax
   40a14:	eb 05                	jmp    40a1b <exception+0x2ec>
   40a16:	b8 c9 4c 04 00       	mov    $0x44cc9,%eax
                const char* problem = reg->reg_err & PFERR_PRESENT
   40a1b:	48 89 45 c0          	mov    %rax,-0x40(%rbp)

                // Completed Part 1
                if (strcmp(problem, "missing page") == 0 && addr >= current->original_break && addr < current->program_break) {
   40a1f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   40a23:	be c9 4c 04 00       	mov    $0x44cc9,%esi
   40a28:	48 89 c7             	mov    %rax,%rdi
   40a2b:	e8 67 33 00 00       	call   43d97 <strcmp>
   40a30:	85 c0                	test   %eax,%eax
   40a32:	0f 85 88 00 00 00    	jne    40ac0 <exception+0x391>
   40a38:	48 8b 05 c1 e4 00 00 	mov    0xe4c1(%rip),%rax        # 4ef00 <current>
   40a3f:	48 8b 40 10          	mov    0x10(%rax),%rax
   40a43:	48 39 45 d0          	cmp    %rax,-0x30(%rbp)
   40a47:	72 77                	jb     40ac0 <exception+0x391>
   40a49:	48 8b 05 b0 e4 00 00 	mov    0xe4b0(%rip),%rax        # 4ef00 <current>
   40a50:	48 8b 40 08          	mov    0x8(%rax),%rax
   40a54:	48 39 45 d0          	cmp    %rax,-0x30(%rbp)
   40a58:	73 66                	jae    40ac0 <exception+0x391>
                    uintptr_t page_addr = addr & ~(PAGESIZE - 1);
   40a5a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   40a5e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   40a64:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
                    uintptr_t page = (uintptr_t) palloc(current->p_pid);
   40a68:	48 8b 05 91 e4 00 00 	mov    0xe491(%rip),%rax        # 4ef00 <current>
   40a6f:	8b 00                	mov    (%rax),%eax
   40a71:	89 c7                	mov    %eax,%edi
   40a73:	e8 f4 25 00 00       	call   4306c <palloc>
   40a78:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
                    if (page != (uintptr_t)NULL) {
   40a7c:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
   40a81:	74 2e                	je     40ab1 <exception+0x382>
                        // Map the new page into the process's page table
                        virtual_memory_map(current->p_pagetable, page_addr, page, PAGESIZE, PTE_W | PTE_P | PTE_U);
   40a83:	48 8b 05 76 e4 00 00 	mov    0xe476(%rip),%rax        # 4ef00 <current>
   40a8a:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   40a91:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
   40a95:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
   40a99:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   40a9f:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40aa4:	48 89 c7             	mov    %rax,%rdi
   40aa7:	e8 c5 1d 00 00       	call   42871 <virtual_memory_map>
                if (strcmp(problem, "missing page") == 0 && addr >= current->original_break && addr < current->program_break) {
   40aac:	e9 b9 00 00 00       	jmp    40b6a <exception+0x43b>
                    } else {
                        syscall_exit();
   40ab1:	b8 00 00 00 00       	mov    $0x0,%eax
   40ab6:	e8 80 f9 ff ff       	call   4043b <syscall_exit>
                if (strcmp(problem, "missing page") == 0 && addr >= current->original_break && addr < current->program_break) {
   40abb:	e9 aa 00 00 00       	jmp    40b6a <exception+0x43b>
                    }
                } else {
                    if (!(reg->reg_err & PFERR_USER)) {
   40ac0:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   40ac7:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40ace:	83 e0 04             	and    $0x4,%eax
   40ad1:	48 85 c0             	test   %rax,%rax
   40ad4:	75 2f                	jne    40b05 <exception+0x3d6>
                    kernel_panic("Kernel page fault for %p (%s %s, rip=%p)!\n",
   40ad6:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   40add:	48 8b b0 98 00 00 00 	mov    0x98(%rax),%rsi
   40ae4:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
   40ae8:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   40aec:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   40af0:	49 89 f0             	mov    %rsi,%r8
   40af3:	48 89 c6             	mov    %rax,%rsi
   40af6:	bf d8 4c 04 00       	mov    $0x44cd8,%edi
   40afb:	b8 00 00 00 00       	mov    $0x0,%eax
   40b00:	e8 8d 19 00 00       	call   42492 <kernel_panic>
                            addr, operation, problem, reg->reg_rip);
                    }
                    console_printf(CPOS(24, 0), 0x0C00,
   40b05:	48 8b 85 e8 fe ff ff 	mov    -0x118(%rbp),%rax
   40b0c:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
                            "Process %d page fault for %p (%s %s, rip=%p)!\n",
                            current->p_pid, addr, operation, problem, reg->reg_rip);
   40b13:	48 8b 05 e6 e3 00 00 	mov    0xe3e6(%rip),%rax        # 4ef00 <current>
                    console_printf(CPOS(24, 0), 0x0C00,
   40b1a:	8b 00                	mov    (%rax),%eax
   40b1c:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
   40b20:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
   40b24:	52                   	push   %rdx
   40b25:	ff 75 c0             	push   -0x40(%rbp)
   40b28:	49 89 f1             	mov    %rsi,%r9
   40b2b:	49 89 c8             	mov    %rcx,%r8
   40b2e:	89 c1                	mov    %eax,%ecx
   40b30:	ba 08 4d 04 00       	mov    $0x44d08,%edx
   40b35:	be 00 0c 00 00       	mov    $0xc00,%esi
   40b3a:	bf 80 07 00 00       	mov    $0x780,%edi
   40b3f:	b8 00 00 00 00       	mov    $0x0,%eax
   40b44:	e8 0c 3f 00 00       	call   44a55 <console_printf>
   40b49:	48 83 c4 10          	add    $0x10,%rsp
                    current->p_state = P_BROKEN;
   40b4d:	48 8b 05 ac e3 00 00 	mov    0xe3ac(%rip),%rax        # 4ef00 <current>
   40b54:	c7 80 d8 00 00 00 03 	movl   $0x3,0xd8(%rax)
   40b5b:	00 00 00 
                    syscall_exit();
   40b5e:	b8 00 00 00 00       	mov    $0x0,%eax
   40b63:	e8 d3 f8 ff ff       	call   4043b <syscall_exit>
                }  
                break;
   40b68:	eb 12                	jmp    40b7c <exception+0x44d>
   40b6a:	eb 10                	jmp    40b7c <exception+0x44d>
            }

        default:
            default_exception(current);
   40b6c:	48 8b 05 8d e3 00 00 	mov    0xe38d(%rip),%rax        # 4ef00 <current>
   40b73:	48 89 c7             	mov    %rax,%rdi
   40b76:	e8 27 1a 00 00       	call   425a2 <default_exception>
            break;                  /* will not be reached */
   40b7b:	90                   	nop

    }

    // Return to the current process (or run something else).
    if (current->p_state == P_RUNNABLE) {
   40b7c:	48 8b 05 7d e3 00 00 	mov    0xe37d(%rip),%rax        # 4ef00 <current>
   40b83:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
   40b89:	83 f8 01             	cmp    $0x1,%eax
   40b8c:	75 0f                	jne    40b9d <exception+0x46e>
        run(current);
   40b8e:	48 8b 05 6b e3 00 00 	mov    0xe36b(%rip),%rax        # 4ef00 <current>
   40b95:	48 89 c7             	mov    %rax,%rdi
   40b98:	e8 82 00 00 00       	call   40c1f <run>
    } else {
        schedule();
   40b9d:	e8 07 00 00 00       	call   40ba9 <schedule>
    }
}
   40ba2:	90                   	nop
   40ba3:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   40ba7:	c9                   	leave
   40ba8:	c3                   	ret

0000000000040ba9 <schedule>:

// schedule
//    Pick the next process to run and then run it.
//    If there are no runnable processes, spins forever.

void schedule(void) {
   40ba9:	55                   	push   %rbp
   40baa:	48 89 e5             	mov    %rsp,%rbp
   40bad:	48 83 ec 10          	sub    $0x10,%rsp
    pid_t pid = current->p_pid;
   40bb1:	48 8b 05 48 e3 00 00 	mov    0xe348(%rip),%rax        # 4ef00 <current>
   40bb8:	8b 00                	mov    (%rax),%eax
   40bba:	89 45 fc             	mov    %eax,-0x4(%rbp)
    while (1) {
        pid = (pid + 1) % NPROC;
   40bbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40bc0:	8d 50 01             	lea    0x1(%rax),%edx
   40bc3:	89 d0                	mov    %edx,%eax
   40bc5:	c1 f8 1f             	sar    $0x1f,%eax
   40bc8:	c1 e8 1c             	shr    $0x1c,%eax
   40bcb:	01 c2                	add    %eax,%edx
   40bcd:	83 e2 0f             	and    $0xf,%edx
   40bd0:	29 c2                	sub    %eax,%edx
   40bd2:	89 55 fc             	mov    %edx,-0x4(%rbp)
        if (processes[pid].p_state == P_RUNNABLE) {
   40bd5:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40bd8:	48 63 d0             	movslq %eax,%rdx
   40bdb:	48 89 d0             	mov    %rdx,%rax
   40bde:	48 c1 e0 04          	shl    $0x4,%rax
   40be2:	48 29 d0             	sub    %rdx,%rax
   40be5:	48 c1 e0 04          	shl    $0x4,%rax
   40be9:	48 05 d8 e0 04 00    	add    $0x4e0d8,%rax
   40bef:	8b 00                	mov    (%rax),%eax
   40bf1:	83 f8 01             	cmp    $0x1,%eax
   40bf4:	75 22                	jne    40c18 <schedule+0x6f>
            run(&processes[pid]);
   40bf6:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40bf9:	48 63 d0             	movslq %eax,%rdx
   40bfc:	48 89 d0             	mov    %rdx,%rax
   40bff:	48 c1 e0 04          	shl    $0x4,%rax
   40c03:	48 29 d0             	sub    %rdx,%rax
   40c06:	48 c1 e0 04          	shl    $0x4,%rax
   40c0a:	48 05 00 e0 04 00    	add    $0x4e000,%rax
   40c10:	48 89 c7             	mov    %rax,%rdi
   40c13:	e8 07 00 00 00       	call   40c1f <run>
        }
        // If Control-C was typed, exit the virtual machine.
        check_keyboard();
   40c18:	e8 34 17 00 00       	call   42351 <check_keyboard>
        pid = (pid + 1) % NPROC;
   40c1d:	eb 9e                	jmp    40bbd <schedule+0x14>

0000000000040c1f <run>:
//    Run process `p`. This means reloading all the registers from
//    `p->p_registers` using the `popal`, `popl`, and `iret` instructions.
//
//    As a side effect, sets `current = p`.

void run(proc* p) {
   40c1f:	55                   	push   %rbp
   40c20:	48 89 e5             	mov    %rsp,%rbp
   40c23:	48 83 ec 10          	sub    $0x10,%rsp
   40c27:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    assert(p->p_state == P_RUNNABLE);
   40c2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40c2f:	8b 80 d8 00 00 00    	mov    0xd8(%rax),%eax
   40c35:	83 f8 01             	cmp    $0x1,%eax
   40c38:	74 14                	je     40c4e <run+0x2f>
   40c3a:	ba a0 4e 04 00       	mov    $0x44ea0,%edx
   40c3f:	be a1 01 00 00       	mov    $0x1a1,%esi
   40c44:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   40c49:	e8 24 19 00 00       	call   42572 <assert_fail>
    current = p;
   40c4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40c52:	48 89 05 a7 e2 00 00 	mov    %rax,0xe2a7(%rip)        # 4ef00 <current>

    // display running process in CONSOLE last value
    console_printf(CPOS(24, 79),
   40c59:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40c5d:	8b 10                	mov    (%rax),%edx
            memstate_colors[p->p_pid - PO_KERNEL], "%d", p->p_pid);
   40c5f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40c63:	8b 00                	mov    (%rax),%eax
   40c65:	83 c0 02             	add    $0x2,%eax
   40c68:	48 98                	cltq
   40c6a:	0f b7 84 00 00 4c 04 	movzwl 0x44c00(%rax,%rax,1),%eax
   40c71:	00 
    console_printf(CPOS(24, 79),
   40c72:	0f b7 c0             	movzwl %ax,%eax
   40c75:	89 d1                	mov    %edx,%ecx
   40c77:	ba b9 4e 04 00       	mov    $0x44eb9,%edx
   40c7c:	89 c6                	mov    %eax,%esi
   40c7e:	bf cf 07 00 00       	mov    $0x7cf,%edi
   40c83:	b8 00 00 00 00       	mov    $0x0,%eax
   40c88:	e8 c8 3d 00 00       	call   44a55 <console_printf>

    // Load the process's current pagetable.
    set_pagetable(p->p_pagetable);
   40c8d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40c91:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   40c98:	48 89 c7             	mov    %rax,%rdi
   40c9b:	e8 a0 1a 00 00       	call   42740 <set_pagetable>

    // This function is defined in k-exception.S. It restores the process's
    // registers then jumps back to user mode.
    exception_return(&p->p_registers);
   40ca0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40ca4:	48 83 c0 18          	add    $0x18,%rax
   40ca8:	48 89 c7             	mov    %rax,%rdi
   40cab:	e8 13 f4 ff ff       	call   400c3 <exception_return>

0000000000040cb0 <pageinfo_init>:


// pageinfo_init
//    Initialize the `pageinfo[]` array.

void pageinfo_init(void) {
   40cb0:	55                   	push   %rbp
   40cb1:	48 89 e5             	mov    %rsp,%rbp
   40cb4:	48 83 ec 10          	sub    $0x10,%rsp
    extern char end[];

    for (uintptr_t addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) {
   40cb8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   40cbf:	00 
   40cc0:	e9 81 00 00 00       	jmp    40d46 <pageinfo_init+0x96>
        int owner;
        if (physical_memory_isreserved(addr)) {
   40cc5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40cc9:	48 89 c7             	mov    %rax,%rdi
   40ccc:	e8 0e 0f 00 00       	call   41bdf <physical_memory_isreserved>
   40cd1:	85 c0                	test   %eax,%eax
   40cd3:	74 09                	je     40cde <pageinfo_init+0x2e>
            owner = PO_RESERVED;
   40cd5:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%rbp)
   40cdc:	eb 2f                	jmp    40d0d <pageinfo_init+0x5d>
        } else if ((addr >= KERNEL_START_ADDR && addr < (uintptr_t) end)
   40cde:	48 81 7d f8 ff ff 03 	cmpq   $0x3ffff,-0x8(%rbp)
   40ce5:	00 
   40ce6:	76 0b                	jbe    40cf3 <pageinfo_init+0x43>
   40ce8:	b8 10 70 05 00       	mov    $0x57010,%eax
   40ced:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40cf1:	72 0a                	jb     40cfd <pageinfo_init+0x4d>
                   || addr == KERNEL_STACK_TOP - PAGESIZE) {
   40cf3:	48 81 7d f8 00 f0 07 	cmpq   $0x7f000,-0x8(%rbp)
   40cfa:	00 
   40cfb:	75 09                	jne    40d06 <pageinfo_init+0x56>
            owner = PO_KERNEL;
   40cfd:	c7 45 f4 fe ff ff ff 	movl   $0xfffffffe,-0xc(%rbp)
   40d04:	eb 07                	jmp    40d0d <pageinfo_init+0x5d>
        } else {
            owner = PO_FREE;
   40d06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
        }
        pageinfo[PAGENUMBER(addr)].owner = owner;
   40d0d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40d11:	48 c1 e8 0c          	shr    $0xc,%rax
   40d15:	89 c1                	mov    %eax,%ecx
   40d17:	8b 45 f4             	mov    -0xc(%rbp),%eax
   40d1a:	89 c2                	mov    %eax,%edx
   40d1c:	48 63 c1             	movslq %ecx,%rax
   40d1f:	88 94 00 20 ef 04 00 	mov    %dl,0x4ef20(%rax,%rax,1)
        pageinfo[PAGENUMBER(addr)].refcount = (owner != PO_FREE);
   40d26:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   40d2a:	0f 95 c2             	setne  %dl
   40d2d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40d31:	48 c1 e8 0c          	shr    $0xc,%rax
   40d35:	48 98                	cltq
   40d37:	88 94 00 21 ef 04 00 	mov    %dl,0x4ef21(%rax,%rax,1)
    for (uintptr_t addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) {
   40d3e:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   40d45:	00 
   40d46:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   40d4d:	00 
   40d4e:	0f 86 71 ff ff ff    	jbe    40cc5 <pageinfo_init+0x15>
    }
}
   40d54:	90                   	nop
   40d55:	90                   	nop
   40d56:	c9                   	leave
   40d57:	c3                   	ret

0000000000040d58 <check_page_table_mappings>:

// check_page_table_mappings
//    Check operating system invariants about kernel mappings for page
//    table `pt`. Panic if any of the invariants are false.

void check_page_table_mappings(x86_64_pagetable* pt) {
   40d58:	55                   	push   %rbp
   40d59:	48 89 e5             	mov    %rsp,%rbp
   40d5c:	48 83 ec 50          	sub    $0x50,%rsp
   40d60:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
    extern char start_data[], end[];
    assert(PTE_ADDR(pt) == (uintptr_t) pt);
   40d64:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40d68:	25 ff 0f 00 00       	and    $0xfff,%eax
   40d6d:	48 85 c0             	test   %rax,%rax
   40d70:	74 14                	je     40d86 <check_page_table_mappings+0x2e>
   40d72:	ba c0 4e 04 00       	mov    $0x44ec0,%edx
   40d77:	be cf 01 00 00       	mov    $0x1cf,%esi
   40d7c:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   40d81:	e8 ec 17 00 00       	call   42572 <assert_fail>

    // kernel memory is identity mapped; data is writable
    for (uintptr_t va = KERNEL_START_ADDR; va < (uintptr_t) end;
   40d86:	48 c7 45 f8 00 00 04 	movq   $0x40000,-0x8(%rbp)
   40d8d:	00 
   40d8e:	e9 9a 00 00 00       	jmp    40e2d <check_page_table_mappings+0xd5>
         va += PAGESIZE) {
        vamapping vam = virtual_memory_lookup(pt, va);
   40d93:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
   40d97:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   40d9b:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
   40d9f:	48 89 ce             	mov    %rcx,%rsi
   40da2:	48 89 c7             	mov    %rax,%rdi
   40da5:	e8 8a 1e 00 00       	call   42c34 <virtual_memory_lookup>
        if (vam.pa != va) {
   40daa:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40dae:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40db2:	74 27                	je     40ddb <check_page_table_mappings+0x83>
            console_printf(CPOS(22, 0), 0xC000, "%p vs %p\n", va, vam.pa);
   40db4:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   40db8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40dbc:	49 89 d0             	mov    %rdx,%r8
   40dbf:	48 89 c1             	mov    %rax,%rcx
   40dc2:	ba df 4e 04 00       	mov    $0x44edf,%edx
   40dc7:	be 00 c0 00 00       	mov    $0xc000,%esi
   40dcc:	bf e0 06 00 00       	mov    $0x6e0,%edi
   40dd1:	b8 00 00 00 00       	mov    $0x0,%eax
   40dd6:	e8 7a 3c 00 00       	call   44a55 <console_printf>
        }
        assert(vam.pa == va);
   40ddb:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40ddf:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40de3:	74 14                	je     40df9 <check_page_table_mappings+0xa1>
   40de5:	ba e9 4e 04 00       	mov    $0x44ee9,%edx
   40dea:	be d8 01 00 00       	mov    $0x1d8,%esi
   40def:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   40df4:	e8 79 17 00 00       	call   42572 <assert_fail>
        if (va >= (uintptr_t) start_data) {
   40df9:	b8 00 60 04 00       	mov    $0x46000,%eax
   40dfe:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40e02:	72 21                	jb     40e25 <check_page_table_mappings+0xcd>
            assert(vam.perm & PTE_W);
   40e04:	8b 45 d0             	mov    -0x30(%rbp),%eax
   40e07:	48 98                	cltq
   40e09:	83 e0 02             	and    $0x2,%eax
   40e0c:	48 85 c0             	test   %rax,%rax
   40e0f:	75 14                	jne    40e25 <check_page_table_mappings+0xcd>
   40e11:	ba f6 4e 04 00       	mov    $0x44ef6,%edx
   40e16:	be da 01 00 00       	mov    $0x1da,%esi
   40e1b:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   40e20:	e8 4d 17 00 00       	call   42572 <assert_fail>
         va += PAGESIZE) {
   40e25:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   40e2c:	00 
    for (uintptr_t va = KERNEL_START_ADDR; va < (uintptr_t) end;
   40e2d:	b8 10 70 05 00       	mov    $0x57010,%eax
   40e32:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   40e36:	0f 82 57 ff ff ff    	jb     40d93 <check_page_table_mappings+0x3b>
        }
    }

    // kernel stack is identity mapped and writable
    uintptr_t kstack = KERNEL_STACK_TOP - PAGESIZE;
   40e3c:	48 c7 45 f0 00 f0 07 	movq   $0x7f000,-0x10(%rbp)
   40e43:	00 
    vamapping vam = virtual_memory_lookup(pt, kstack);
   40e44:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
   40e48:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40e4c:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
   40e50:	48 89 ce             	mov    %rcx,%rsi
   40e53:	48 89 c7             	mov    %rax,%rdi
   40e56:	e8 d9 1d 00 00       	call   42c34 <virtual_memory_lookup>
    assert(vam.pa == kstack);
   40e5b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   40e5f:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
   40e63:	74 14                	je     40e79 <check_page_table_mappings+0x121>
   40e65:	ba 07 4f 04 00       	mov    $0x44f07,%edx
   40e6a:	be e1 01 00 00       	mov    $0x1e1,%esi
   40e6f:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   40e74:	e8 f9 16 00 00       	call   42572 <assert_fail>
    assert(vam.perm & PTE_W);
   40e79:	8b 45 e8             	mov    -0x18(%rbp),%eax
   40e7c:	48 98                	cltq
   40e7e:	83 e0 02             	and    $0x2,%eax
   40e81:	48 85 c0             	test   %rax,%rax
   40e84:	75 14                	jne    40e9a <check_page_table_mappings+0x142>
   40e86:	ba f6 4e 04 00       	mov    $0x44ef6,%edx
   40e8b:	be e2 01 00 00       	mov    $0x1e2,%esi
   40e90:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   40e95:	e8 d8 16 00 00       	call   42572 <assert_fail>
}
   40e9a:	90                   	nop
   40e9b:	c9                   	leave
   40e9c:	c3                   	ret

0000000000040e9d <check_page_table_ownership>:
//    counts for page table `pt`. Panic if any of the invariants are false.

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount);

void check_page_table_ownership(x86_64_pagetable* pt, pid_t pid) {
   40e9d:	55                   	push   %rbp
   40e9e:	48 89 e5             	mov    %rsp,%rbp
   40ea1:	48 83 ec 20          	sub    $0x20,%rsp
   40ea5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   40ea9:	89 75 e4             	mov    %esi,-0x1c(%rbp)
    // calculate expected reference count for page tables
    int owner = pid;
   40eac:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   40eaf:	89 45 fc             	mov    %eax,-0x4(%rbp)
    int expected_refcount = 1;
   40eb2:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
    if (pt == kernel_pagetable) {
   40eb9:	48 8b 05 40 01 01 00 	mov    0x10140(%rip),%rax        # 51000 <kernel_pagetable>
   40ec0:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
   40ec4:	75 67                	jne    40f2d <check_page_table_ownership+0x90>
        owner = PO_KERNEL;
   40ec6:	c7 45 fc fe ff ff ff 	movl   $0xfffffffe,-0x4(%rbp)
        for (int xpid = 0; xpid < NPROC; ++xpid) {
   40ecd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   40ed4:	eb 51                	jmp    40f27 <check_page_table_ownership+0x8a>
            if (processes[xpid].p_state != P_FREE
   40ed6:	8b 45 f4             	mov    -0xc(%rbp),%eax
   40ed9:	48 63 d0             	movslq %eax,%rdx
   40edc:	48 89 d0             	mov    %rdx,%rax
   40edf:	48 c1 e0 04          	shl    $0x4,%rax
   40ee3:	48 29 d0             	sub    %rdx,%rax
   40ee6:	48 c1 e0 04          	shl    $0x4,%rax
   40eea:	48 05 d8 e0 04 00    	add    $0x4e0d8,%rax
   40ef0:	8b 00                	mov    (%rax),%eax
   40ef2:	85 c0                	test   %eax,%eax
   40ef4:	74 2d                	je     40f23 <check_page_table_ownership+0x86>
                && processes[xpid].p_pagetable == kernel_pagetable) {
   40ef6:	8b 45 f4             	mov    -0xc(%rbp),%eax
   40ef9:	48 63 d0             	movslq %eax,%rdx
   40efc:	48 89 d0             	mov    %rdx,%rax
   40eff:	48 c1 e0 04          	shl    $0x4,%rax
   40f03:	48 29 d0             	sub    %rdx,%rax
   40f06:	48 c1 e0 04          	shl    $0x4,%rax
   40f0a:	48 05 e0 e0 04 00    	add    $0x4e0e0,%rax
   40f10:	48 8b 10             	mov    (%rax),%rdx
   40f13:	48 8b 05 e6 00 01 00 	mov    0x100e6(%rip),%rax        # 51000 <kernel_pagetable>
   40f1a:	48 39 c2             	cmp    %rax,%rdx
   40f1d:	75 04                	jne    40f23 <check_page_table_ownership+0x86>
                ++expected_refcount;
   40f1f:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
        for (int xpid = 0; xpid < NPROC; ++xpid) {
   40f23:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   40f27:	83 7d f4 0f          	cmpl   $0xf,-0xc(%rbp)
   40f2b:	7e a9                	jle    40ed6 <check_page_table_ownership+0x39>
            }
        }
    }
    check_page_table_ownership_level(pt, 0, owner, expected_refcount);
   40f2d:	8b 4d f8             	mov    -0x8(%rbp),%ecx
   40f30:	8b 55 fc             	mov    -0x4(%rbp),%edx
   40f33:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40f37:	be 00 00 00 00       	mov    $0x0,%esi
   40f3c:	48 89 c7             	mov    %rax,%rdi
   40f3f:	e8 03 00 00 00       	call   40f47 <check_page_table_ownership_level>
}
   40f44:	90                   	nop
   40f45:	c9                   	leave
   40f46:	c3                   	ret

0000000000040f47 <check_page_table_ownership_level>:

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount) {
   40f47:	55                   	push   %rbp
   40f48:	48 89 e5             	mov    %rsp,%rbp
   40f4b:	48 83 ec 30          	sub    $0x30,%rsp
   40f4f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   40f53:	89 75 e4             	mov    %esi,-0x1c(%rbp)
   40f56:	89 55 e0             	mov    %edx,-0x20(%rbp)
   40f59:	89 4d dc             	mov    %ecx,-0x24(%rbp)
    assert(PAGENUMBER(pt) < NPAGES);
   40f5c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40f60:	48 c1 e8 0c          	shr    $0xc,%rax
   40f64:	3d ff 01 00 00       	cmp    $0x1ff,%eax
   40f69:	7e 14                	jle    40f7f <check_page_table_ownership_level+0x38>
   40f6b:	ba 18 4f 04 00       	mov    $0x44f18,%edx
   40f70:	be ff 01 00 00       	mov    $0x1ff,%esi
   40f75:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   40f7a:	e8 f3 15 00 00       	call   42572 <assert_fail>
    assert(pageinfo[PAGENUMBER(pt)].owner == owner);
   40f7f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40f83:	48 c1 e8 0c          	shr    $0xc,%rax
   40f87:	48 98                	cltq
   40f89:	0f b6 84 00 20 ef 04 	movzbl 0x4ef20(%rax,%rax,1),%eax
   40f90:	00 
   40f91:	0f be c0             	movsbl %al,%eax
   40f94:	39 45 e0             	cmp    %eax,-0x20(%rbp)
   40f97:	74 14                	je     40fad <check_page_table_ownership_level+0x66>
   40f99:	ba 30 4f 04 00       	mov    $0x44f30,%edx
   40f9e:	be 00 02 00 00       	mov    $0x200,%esi
   40fa3:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   40fa8:	e8 c5 15 00 00       	call   42572 <assert_fail>
    assert(pageinfo[PAGENUMBER(pt)].refcount == refcount);
   40fad:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40fb1:	48 c1 e8 0c          	shr    $0xc,%rax
   40fb5:	48 98                	cltq
   40fb7:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   40fbe:	00 
   40fbf:	0f be c0             	movsbl %al,%eax
   40fc2:	39 45 dc             	cmp    %eax,-0x24(%rbp)
   40fc5:	74 14                	je     40fdb <check_page_table_ownership_level+0x94>
   40fc7:	ba 58 4f 04 00       	mov    $0x44f58,%edx
   40fcc:	be 01 02 00 00       	mov    $0x201,%esi
   40fd1:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   40fd6:	e8 97 15 00 00       	call   42572 <assert_fail>
    if (level < 3) {
   40fdb:	83 7d e4 02          	cmpl   $0x2,-0x1c(%rbp)
   40fdf:	7f 5b                	jg     4103c <check_page_table_ownership_level+0xf5>
        for (int index = 0; index < NPAGETABLEENTRIES; ++index) {
   40fe1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   40fe8:	eb 49                	jmp    41033 <check_page_table_ownership_level+0xec>
            if (pt->entry[index]) {
   40fea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40fee:	8b 55 fc             	mov    -0x4(%rbp),%edx
   40ff1:	48 63 d2             	movslq %edx,%rdx
   40ff4:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   40ff8:	48 85 c0             	test   %rax,%rax
   40ffb:	74 32                	je     4102f <check_page_table_ownership_level+0xe8>
                x86_64_pagetable* nextpt =
                    (x86_64_pagetable*) PTE_ADDR(pt->entry[index]);
   40ffd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41001:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41004:	48 63 d2             	movslq %edx,%rdx
   41007:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   4100b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
                x86_64_pagetable* nextpt =
   41011:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
                check_page_table_ownership_level(nextpt, level + 1, owner, 1);
   41015:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   41018:	8d 70 01             	lea    0x1(%rax),%esi
   4101b:	8b 55 e0             	mov    -0x20(%rbp),%edx
   4101e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   41022:	b9 01 00 00 00       	mov    $0x1,%ecx
   41027:	48 89 c7             	mov    %rax,%rdi
   4102a:	e8 18 ff ff ff       	call   40f47 <check_page_table_ownership_level>
        for (int index = 0; index < NPAGETABLEENTRIES; ++index) {
   4102f:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41033:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   4103a:	7e ae                	jle    40fea <check_page_table_ownership_level+0xa3>
            }
        }
    }
}
   4103c:	90                   	nop
   4103d:	c9                   	leave
   4103e:	c3                   	ret

000000000004103f <check_virtual_memory>:

// check_virtual_memory
//    Check operating system invariants about virtual memory. Panic if any
//    of the invariants are false.

void check_virtual_memory(void) {
   4103f:	55                   	push   %rbp
   41040:	48 89 e5             	mov    %rsp,%rbp
   41043:	48 83 ec 10          	sub    $0x10,%rsp
    // Process 0 must never be used.
    assert(processes[0].p_state == P_FREE);
   41047:	8b 05 8b d0 00 00    	mov    0xd08b(%rip),%eax        # 4e0d8 <processes+0xd8>
   4104d:	85 c0                	test   %eax,%eax
   4104f:	74 14                	je     41065 <check_virtual_memory+0x26>
   41051:	ba 88 4f 04 00       	mov    $0x44f88,%edx
   41056:	be 14 02 00 00       	mov    $0x214,%esi
   4105b:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   41060:	e8 0d 15 00 00       	call   42572 <assert_fail>
    // that don't have their own page tables.
    // Active processes have their own page tables. A process page table
    // should be owned by that process and have reference count 1.
    // All level-2-4 page tables must have reference count 1.

    check_page_table_mappings(kernel_pagetable);
   41065:	48 8b 05 94 ff 00 00 	mov    0xff94(%rip),%rax        # 51000 <kernel_pagetable>
   4106c:	48 89 c7             	mov    %rax,%rdi
   4106f:	e8 e4 fc ff ff       	call   40d58 <check_page_table_mappings>
    check_page_table_ownership(kernel_pagetable, -1);
   41074:	48 8b 05 85 ff 00 00 	mov    0xff85(%rip),%rax        # 51000 <kernel_pagetable>
   4107b:	be ff ff ff ff       	mov    $0xffffffff,%esi
   41080:	48 89 c7             	mov    %rax,%rdi
   41083:	e8 15 fe ff ff       	call   40e9d <check_page_table_ownership>

    for (int pid = 0; pid < NPROC; ++pid) {
   41088:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4108f:	e9 9c 00 00 00       	jmp    41130 <check_virtual_memory+0xf1>
        if (processes[pid].p_state != P_FREE
   41094:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41097:	48 63 d0             	movslq %eax,%rdx
   4109a:	48 89 d0             	mov    %rdx,%rax
   4109d:	48 c1 e0 04          	shl    $0x4,%rax
   410a1:	48 29 d0             	sub    %rdx,%rax
   410a4:	48 c1 e0 04          	shl    $0x4,%rax
   410a8:	48 05 d8 e0 04 00    	add    $0x4e0d8,%rax
   410ae:	8b 00                	mov    (%rax),%eax
   410b0:	85 c0                	test   %eax,%eax
   410b2:	74 78                	je     4112c <check_virtual_memory+0xed>
            && processes[pid].p_pagetable != kernel_pagetable) {
   410b4:	8b 45 fc             	mov    -0x4(%rbp),%eax
   410b7:	48 63 d0             	movslq %eax,%rdx
   410ba:	48 89 d0             	mov    %rdx,%rax
   410bd:	48 c1 e0 04          	shl    $0x4,%rax
   410c1:	48 29 d0             	sub    %rdx,%rax
   410c4:	48 c1 e0 04          	shl    $0x4,%rax
   410c8:	48 05 e0 e0 04 00    	add    $0x4e0e0,%rax
   410ce:	48 8b 10             	mov    (%rax),%rdx
   410d1:	48 8b 05 28 ff 00 00 	mov    0xff28(%rip),%rax        # 51000 <kernel_pagetable>
   410d8:	48 39 c2             	cmp    %rax,%rdx
   410db:	74 4f                	je     4112c <check_virtual_memory+0xed>
            check_page_table_mappings(processes[pid].p_pagetable);
   410dd:	8b 45 fc             	mov    -0x4(%rbp),%eax
   410e0:	48 63 d0             	movslq %eax,%rdx
   410e3:	48 89 d0             	mov    %rdx,%rax
   410e6:	48 c1 e0 04          	shl    $0x4,%rax
   410ea:	48 29 d0             	sub    %rdx,%rax
   410ed:	48 c1 e0 04          	shl    $0x4,%rax
   410f1:	48 05 e0 e0 04 00    	add    $0x4e0e0,%rax
   410f7:	48 8b 00             	mov    (%rax),%rax
   410fa:	48 89 c7             	mov    %rax,%rdi
   410fd:	e8 56 fc ff ff       	call   40d58 <check_page_table_mappings>
            check_page_table_ownership(processes[pid].p_pagetable, pid);
   41102:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41105:	48 63 d0             	movslq %eax,%rdx
   41108:	48 89 d0             	mov    %rdx,%rax
   4110b:	48 c1 e0 04          	shl    $0x4,%rax
   4110f:	48 29 d0             	sub    %rdx,%rax
   41112:	48 c1 e0 04          	shl    $0x4,%rax
   41116:	48 05 e0 e0 04 00    	add    $0x4e0e0,%rax
   4111c:	48 8b 00             	mov    (%rax),%rax
   4111f:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41122:	89 d6                	mov    %edx,%esi
   41124:	48 89 c7             	mov    %rax,%rdi
   41127:	e8 71 fd ff ff       	call   40e9d <check_page_table_ownership>
    for (int pid = 0; pid < NPROC; ++pid) {
   4112c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41130:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   41134:	0f 8e 5a ff ff ff    	jle    41094 <check_virtual_memory+0x55>
        }
    }

    // Check that all referenced pages refer to active processes
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   4113a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   41141:	eb 67                	jmp    411aa <check_virtual_memory+0x16b>
        if (pageinfo[pn].refcount > 0 && pageinfo[pn].owner >= 0) {
   41143:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41146:	48 98                	cltq
   41148:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   4114f:	00 
   41150:	84 c0                	test   %al,%al
   41152:	7e 52                	jle    411a6 <check_virtual_memory+0x167>
   41154:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41157:	48 98                	cltq
   41159:	0f b6 84 00 20 ef 04 	movzbl 0x4ef20(%rax,%rax,1),%eax
   41160:	00 
   41161:	84 c0                	test   %al,%al
   41163:	78 41                	js     411a6 <check_virtual_memory+0x167>
            assert(processes[pageinfo[pn].owner].p_state != P_FREE);
   41165:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41168:	48 98                	cltq
   4116a:	0f b6 84 00 20 ef 04 	movzbl 0x4ef20(%rax,%rax,1),%eax
   41171:	00 
   41172:	0f be c0             	movsbl %al,%eax
   41175:	48 63 d0             	movslq %eax,%rdx
   41178:	48 89 d0             	mov    %rdx,%rax
   4117b:	48 c1 e0 04          	shl    $0x4,%rax
   4117f:	48 29 d0             	sub    %rdx,%rax
   41182:	48 c1 e0 04          	shl    $0x4,%rax
   41186:	48 05 d8 e0 04 00    	add    $0x4e0d8,%rax
   4118c:	8b 00                	mov    (%rax),%eax
   4118e:	85 c0                	test   %eax,%eax
   41190:	75 14                	jne    411a6 <check_virtual_memory+0x167>
   41192:	ba a8 4f 04 00       	mov    $0x44fa8,%edx
   41197:	be 2b 02 00 00       	mov    $0x22b,%esi
   4119c:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   411a1:	e8 cc 13 00 00       	call   42572 <assert_fail>
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   411a6:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   411aa:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
   411b1:	7e 90                	jle    41143 <check_virtual_memory+0x104>
        }
    }
}
   411b3:	90                   	nop
   411b4:	90                   	nop
   411b5:	c9                   	leave
   411b6:	c3                   	ret

00000000000411b7 <memshow_physical>:
    'E' | 0x0E00, 'F' | 0x0F00, 'S'
};
#define SHARED_COLOR memstate_colors[18]
#define SHARED

void memshow_physical(void) {
   411b7:	55                   	push   %rbp
   411b8:	48 89 e5             	mov    %rsp,%rbp
   411bb:	48 83 ec 10          	sub    $0x10,%rsp
    console_printf(CPOS(0, 32), 0x0F00, "PHYSICAL MEMORY");
   411bf:	ba d8 4f 04 00       	mov    $0x44fd8,%edx
   411c4:	be 00 0f 00 00       	mov    $0xf00,%esi
   411c9:	bf 20 00 00 00       	mov    $0x20,%edi
   411ce:	b8 00 00 00 00       	mov    $0x0,%eax
   411d3:	e8 7d 38 00 00       	call   44a55 <console_printf>
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   411d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   411df:	e9 f8 00 00 00       	jmp    412dc <memshow_physical+0x125>
        if (pn % 64 == 0) {
   411e4:	8b 45 fc             	mov    -0x4(%rbp),%eax
   411e7:	83 e0 3f             	and    $0x3f,%eax
   411ea:	85 c0                	test   %eax,%eax
   411ec:	75 3c                	jne    4122a <memshow_physical+0x73>
            console_printf(CPOS(1 + pn / 64, 3), 0x0F00, "0x%06X ", pn << 12);
   411ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
   411f1:	c1 e0 0c             	shl    $0xc,%eax
   411f4:	89 c1                	mov    %eax,%ecx
   411f6:	8b 45 fc             	mov    -0x4(%rbp),%eax
   411f9:	8d 50 3f             	lea    0x3f(%rax),%edx
   411fc:	85 c0                	test   %eax,%eax
   411fe:	0f 48 c2             	cmovs  %edx,%eax
   41201:	c1 f8 06             	sar    $0x6,%eax
   41204:	8d 50 01             	lea    0x1(%rax),%edx
   41207:	89 d0                	mov    %edx,%eax
   41209:	c1 e0 02             	shl    $0x2,%eax
   4120c:	01 d0                	add    %edx,%eax
   4120e:	c1 e0 04             	shl    $0x4,%eax
   41211:	83 c0 03             	add    $0x3,%eax
   41214:	ba e8 4f 04 00       	mov    $0x44fe8,%edx
   41219:	be 00 0f 00 00       	mov    $0xf00,%esi
   4121e:	89 c7                	mov    %eax,%edi
   41220:	b8 00 00 00 00       	mov    $0x0,%eax
   41225:	e8 2b 38 00 00       	call   44a55 <console_printf>
        }

        int owner = pageinfo[pn].owner;
   4122a:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4122d:	48 98                	cltq
   4122f:	0f b6 84 00 20 ef 04 	movzbl 0x4ef20(%rax,%rax,1),%eax
   41236:	00 
   41237:	0f be c0             	movsbl %al,%eax
   4123a:	89 45 f8             	mov    %eax,-0x8(%rbp)
        if (pageinfo[pn].refcount == 0) {
   4123d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41240:	48 98                	cltq
   41242:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   41249:	00 
   4124a:	84 c0                	test   %al,%al
   4124c:	75 07                	jne    41255 <memshow_physical+0x9e>
            owner = PO_FREE;
   4124e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
        }
        uint16_t color = memstate_colors[owner - PO_KERNEL];
   41255:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41258:	83 c0 02             	add    $0x2,%eax
   4125b:	48 98                	cltq
   4125d:	0f b7 84 00 00 4c 04 	movzwl 0x44c00(%rax,%rax,1),%eax
   41264:	00 
   41265:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
        // darker color for shared pages
        if (pageinfo[pn].refcount > 1 && pn != PAGENUMBER(CONSOLE_ADDR)){
   41269:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4126c:	48 98                	cltq
   4126e:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   41275:	00 
   41276:	3c 01                	cmp    $0x1,%al
   41278:	7e 1a                	jle    41294 <memshow_physical+0xdd>
   4127a:	b8 00 80 0b 00       	mov    $0xb8000,%eax
   4127f:	48 c1 e8 0c          	shr    $0xc,%rax
   41283:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   41286:	74 0c                	je     41294 <memshow_physical+0xdd>
#ifdef SHARED
            color = SHARED_COLOR | 0x0F00;
   41288:	b8 53 00 00 00       	mov    $0x53,%eax
   4128d:	80 cc 0f             	or     $0xf,%ah
   41290:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
#else
	    color &= 0x77FF;
#endif
        }

        console[CPOS(1 + pn / 64, 12 + pn % 64)] = color;
   41294:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41297:	8d 50 3f             	lea    0x3f(%rax),%edx
   4129a:	85 c0                	test   %eax,%eax
   4129c:	0f 48 c2             	cmovs  %edx,%eax
   4129f:	c1 f8 06             	sar    $0x6,%eax
   412a2:	8d 50 01             	lea    0x1(%rax),%edx
   412a5:	89 d0                	mov    %edx,%eax
   412a7:	c1 e0 02             	shl    $0x2,%eax
   412aa:	01 d0                	add    %edx,%eax
   412ac:	c1 e0 04             	shl    $0x4,%eax
   412af:	89 c1                	mov    %eax,%ecx
   412b1:	8b 55 fc             	mov    -0x4(%rbp),%edx
   412b4:	89 d0                	mov    %edx,%eax
   412b6:	c1 f8 1f             	sar    $0x1f,%eax
   412b9:	c1 e8 1a             	shr    $0x1a,%eax
   412bc:	01 c2                	add    %eax,%edx
   412be:	83 e2 3f             	and    $0x3f,%edx
   412c1:	29 c2                	sub    %eax,%edx
   412c3:	89 d0                	mov    %edx,%eax
   412c5:	83 c0 0c             	add    $0xc,%eax
   412c8:	01 c8                	add    %ecx,%eax
   412ca:	48 98                	cltq
   412cc:	0f b7 55 f6          	movzwl -0xa(%rbp),%edx
   412d0:	66 89 94 00 00 80 0b 	mov    %dx,0xb8000(%rax,%rax,1)
   412d7:	00 
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   412d8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   412dc:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   412e3:	0f 8e fb fe ff ff    	jle    411e4 <memshow_physical+0x2d>
    }
}
   412e9:	90                   	nop
   412ea:	90                   	nop
   412eb:	c9                   	leave
   412ec:	c3                   	ret

00000000000412ed <memshow_virtual>:

// memshow_virtual(pagetable, name)
//    Draw a picture of the virtual memory map `pagetable` (named `name`) on
//    the CGA console.

void memshow_virtual(x86_64_pagetable* pagetable, const char* name) {
   412ed:	55                   	push   %rbp
   412ee:	48 89 e5             	mov    %rsp,%rbp
   412f1:	48 83 ec 40          	sub    $0x40,%rsp
   412f5:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   412f9:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
    assert((uintptr_t) pagetable == PTE_ADDR(pagetable));
   412fd:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   41301:	25 ff 0f 00 00       	and    $0xfff,%eax
   41306:	48 85 c0             	test   %rax,%rax
   41309:	74 14                	je     4131f <memshow_virtual+0x32>
   4130b:	ba f0 4f 04 00       	mov    $0x44ff0,%edx
   41310:	be 5c 02 00 00       	mov    $0x25c,%esi
   41315:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   4131a:	e8 53 12 00 00       	call   42572 <assert_fail>

    console_printf(CPOS(10, 26), 0x0F00, "VIRTUAL ADDRESS SPACE FOR %s", name);
   4131f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   41323:	48 89 c1             	mov    %rax,%rcx
   41326:	ba 1d 50 04 00       	mov    $0x4501d,%edx
   4132b:	be 00 0f 00 00       	mov    $0xf00,%esi
   41330:	bf 3a 03 00 00       	mov    $0x33a,%edi
   41335:	b8 00 00 00 00       	mov    $0x0,%eax
   4133a:	e8 16 37 00 00       	call   44a55 <console_printf>
    for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   4133f:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   41346:	00 
   41347:	e9 80 01 00 00       	jmp    414cc <memshow_virtual+0x1df>
        vamapping vam = virtual_memory_lookup(pagetable, va);
   4134c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   41350:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   41354:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   41358:	48 89 ce             	mov    %rcx,%rsi
   4135b:	48 89 c7             	mov    %rax,%rdi
   4135e:	e8 d1 18 00 00       	call   42c34 <virtual_memory_lookup>
        uint16_t color;
        if (vam.pn < 0) {
   41363:	8b 45 d0             	mov    -0x30(%rbp),%eax
   41366:	85 c0                	test   %eax,%eax
   41368:	79 0b                	jns    41375 <memshow_virtual+0x88>
            color = ' ';
   4136a:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%rbp)
   41370:	e9 d7 00 00 00       	jmp    4144c <memshow_virtual+0x15f>
        } else {
            assert(vam.pa < MEMSIZE_PHYSICAL);
   41375:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   41379:	48 3d ff ff 1f 00    	cmp    $0x1fffff,%rax
   4137f:	76 14                	jbe    41395 <memshow_virtual+0xa8>
   41381:	ba 3a 50 04 00       	mov    $0x4503a,%edx
   41386:	be 65 02 00 00       	mov    $0x265,%esi
   4138b:	bf 68 4c 04 00       	mov    $0x44c68,%edi
   41390:	e8 dd 11 00 00       	call   42572 <assert_fail>
            int owner = pageinfo[vam.pn].owner;
   41395:	8b 45 d0             	mov    -0x30(%rbp),%eax
   41398:	48 98                	cltq
   4139a:	0f b6 84 00 20 ef 04 	movzbl 0x4ef20(%rax,%rax,1),%eax
   413a1:	00 
   413a2:	0f be c0             	movsbl %al,%eax
   413a5:	89 45 f0             	mov    %eax,-0x10(%rbp)
            if (pageinfo[vam.pn].refcount == 0) {
   413a8:	8b 45 d0             	mov    -0x30(%rbp),%eax
   413ab:	48 98                	cltq
   413ad:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   413b4:	00 
   413b5:	84 c0                	test   %al,%al
   413b7:	75 07                	jne    413c0 <memshow_virtual+0xd3>
                owner = PO_FREE;
   413b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
            }
            color = memstate_colors[owner - PO_KERNEL];
   413c0:	8b 45 f0             	mov    -0x10(%rbp),%eax
   413c3:	83 c0 02             	add    $0x2,%eax
   413c6:	48 98                	cltq
   413c8:	0f b7 84 00 00 4c 04 	movzwl 0x44c00(%rax,%rax,1),%eax
   413cf:	00 
   413d0:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
            // reverse video for user-accessible pages
            if (vam.perm & PTE_U) {
   413d4:	8b 45 e0             	mov    -0x20(%rbp),%eax
   413d7:	48 98                	cltq
   413d9:	83 e0 04             	and    $0x4,%eax
   413dc:	48 85 c0             	test   %rax,%rax
   413df:	74 27                	je     41408 <memshow_virtual+0x11b>
                color = ((color & 0x0F00) << 4) | ((color & 0xF000) >> 4)
   413e1:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   413e5:	c1 e0 04             	shl    $0x4,%eax
   413e8:	66 25 00 f0          	and    $0xf000,%ax
   413ec:	89 c2                	mov    %eax,%edx
   413ee:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   413f2:	c1 f8 04             	sar    $0x4,%eax
   413f5:	66 25 00 0f          	and    $0xf00,%ax
   413f9:	09 c2                	or     %eax,%edx
                    | (color & 0x00FF);
   413fb:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   413ff:	0f b6 c0             	movzbl %al,%eax
   41402:	09 d0                	or     %edx,%eax
                color = ((color & 0x0F00) << 4) | ((color & 0xF000) >> 4)
   41404:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
            }
            // darker color for shared pages
            if (pageinfo[vam.pn].refcount > 1 && va != CONSOLE_ADDR) {
   41408:	8b 45 d0             	mov    -0x30(%rbp),%eax
   4140b:	48 98                	cltq
   4140d:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   41414:	00 
   41415:	3c 01                	cmp    $0x1,%al
   41417:	7e 33                	jle    4144c <memshow_virtual+0x15f>
   41419:	b8 00 80 0b 00       	mov    $0xb8000,%eax
   4141e:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   41422:	74 28                	je     4144c <memshow_virtual+0x15f>
#ifdef SHARED
                color = (SHARED_COLOR | (color & 0xF000));
   41424:	b8 53 00 00 00       	mov    $0x53,%eax
   41429:	89 c2                	mov    %eax,%edx
   4142b:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   4142f:	66 25 00 f0          	and    $0xf000,%ax
   41433:	09 d0                	or     %edx,%eax
   41435:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
                if(! (vam.perm & PTE_U))
   41439:	8b 45 e0             	mov    -0x20(%rbp),%eax
   4143c:	48 98                	cltq
   4143e:	83 e0 04             	and    $0x4,%eax
   41441:	48 85 c0             	test   %rax,%rax
   41444:	75 06                	jne    4144c <memshow_virtual+0x15f>
                    color = color | 0x0F00;
   41446:	66 81 4d f6 00 0f    	orw    $0xf00,-0xa(%rbp)
#else
		color &= 0x77FF;
#endif
            }
        }
        uint32_t pn = PAGENUMBER(va);
   4144c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41450:	48 c1 e8 0c          	shr    $0xc,%rax
   41454:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (pn % 64 == 0) {
   41457:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4145a:	83 e0 3f             	and    $0x3f,%eax
   4145d:	85 c0                	test   %eax,%eax
   4145f:	75 34                	jne    41495 <memshow_virtual+0x1a8>
            console_printf(CPOS(11 + pn / 64, 3), 0x0F00, "0x%06X ", va);
   41461:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41464:	c1 e8 06             	shr    $0x6,%eax
   41467:	89 c2                	mov    %eax,%edx
   41469:	89 d0                	mov    %edx,%eax
   4146b:	c1 e0 02             	shl    $0x2,%eax
   4146e:	01 d0                	add    %edx,%eax
   41470:	c1 e0 04             	shl    $0x4,%eax
   41473:	05 73 03 00 00       	add    $0x373,%eax
   41478:	89 c7                	mov    %eax,%edi
   4147a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4147e:	48 89 c1             	mov    %rax,%rcx
   41481:	ba e8 4f 04 00       	mov    $0x44fe8,%edx
   41486:	be 00 0f 00 00       	mov    $0xf00,%esi
   4148b:	b8 00 00 00 00       	mov    $0x0,%eax
   41490:	e8 c0 35 00 00       	call   44a55 <console_printf>
        }
        console[CPOS(11 + pn / 64, 12 + pn % 64)] = color;
   41495:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41498:	c1 e8 06             	shr    $0x6,%eax
   4149b:	89 c2                	mov    %eax,%edx
   4149d:	89 d0                	mov    %edx,%eax
   4149f:	c1 e0 02             	shl    $0x2,%eax
   414a2:	01 d0                	add    %edx,%eax
   414a4:	c1 e0 04             	shl    $0x4,%eax
   414a7:	89 c2                	mov    %eax,%edx
   414a9:	8b 45 ec             	mov    -0x14(%rbp),%eax
   414ac:	83 e0 3f             	and    $0x3f,%eax
   414af:	01 d0                	add    %edx,%eax
   414b1:	05 7c 03 00 00       	add    $0x37c,%eax
   414b6:	89 c2                	mov    %eax,%edx
   414b8:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   414bc:	66 89 84 12 00 80 0b 	mov    %ax,0xb8000(%rdx,%rdx,1)
   414c3:	00 
    for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   414c4:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   414cb:	00 
   414cc:	48 81 7d f8 ff ff 2f 	cmpq   $0x2fffff,-0x8(%rbp)
   414d3:	00 
   414d4:	0f 86 72 fe ff ff    	jbe    4134c <memshow_virtual+0x5f>
    }
}
   414da:	90                   	nop
   414db:	90                   	nop
   414dc:	c9                   	leave
   414dd:	c3                   	ret

00000000000414de <memshow_virtual_animate>:

// memshow_virtual_animate
//    Draw a picture of process virtual memory maps on the CGA console.
//    Starts with process 1, then switches to a new process every 0.25 sec.

void memshow_virtual_animate(void) {
   414de:	55                   	push   %rbp
   414df:	48 89 e5             	mov    %rsp,%rbp
   414e2:	48 83 ec 10          	sub    $0x10,%rsp
    static unsigned last_ticks = 0;
    static int showing = 1;

    // switch to a new process every 0.25 sec
    if (last_ticks == 0 || ticks - last_ticks >= HZ / 2) {
   414e6:	8b 05 38 de 00 00    	mov    0xde38(%rip),%eax        # 4f324 <last_ticks.1>
   414ec:	85 c0                	test   %eax,%eax
   414ee:	74 13                	je     41503 <memshow_virtual_animate+0x25>
   414f0:	8b 15 2a de 00 00    	mov    0xde2a(%rip),%edx        # 4f320 <ticks>
   414f6:	8b 05 28 de 00 00    	mov    0xde28(%rip),%eax        # 4f324 <last_ticks.1>
   414fc:	29 c2                	sub    %eax,%edx
   414fe:	83 fa 31             	cmp    $0x31,%edx
   41501:	76 2c                	jbe    4152f <memshow_virtual_animate+0x51>
        last_ticks = ticks;
   41503:	8b 05 17 de 00 00    	mov    0xde17(%rip),%eax        # 4f320 <ticks>
   41509:	89 05 15 de 00 00    	mov    %eax,0xde15(%rip)        # 4f324 <last_ticks.1>
        ++showing;
   4150f:	8b 05 ef 4a 00 00    	mov    0x4aef(%rip),%eax        # 46004 <showing.0>
   41515:	83 c0 01             	add    $0x1,%eax
   41518:	89 05 e6 4a 00 00    	mov    %eax,0x4ae6(%rip)        # 46004 <showing.0>
    }

    // the current process may have died -- don't display it if so
    while (showing <= 2*NPROC
   4151e:	eb 0f                	jmp    4152f <memshow_virtual_animate+0x51>
           && processes[showing % NPROC].p_state == P_FREE) {
        ++showing;
   41520:	8b 05 de 4a 00 00    	mov    0x4ade(%rip),%eax        # 46004 <showing.0>
   41526:	83 c0 01             	add    $0x1,%eax
   41529:	89 05 d5 4a 00 00    	mov    %eax,0x4ad5(%rip)        # 46004 <showing.0>
    while (showing <= 2*NPROC
   4152f:	8b 05 cf 4a 00 00    	mov    0x4acf(%rip),%eax        # 46004 <showing.0>
           && processes[showing % NPROC].p_state == P_FREE) {
   41535:	83 f8 20             	cmp    $0x20,%eax
   41538:	7f 34                	jg     4156e <memshow_virtual_animate+0x90>
   4153a:	8b 15 c4 4a 00 00    	mov    0x4ac4(%rip),%edx        # 46004 <showing.0>
   41540:	89 d0                	mov    %edx,%eax
   41542:	c1 f8 1f             	sar    $0x1f,%eax
   41545:	c1 e8 1c             	shr    $0x1c,%eax
   41548:	01 c2                	add    %eax,%edx
   4154a:	83 e2 0f             	and    $0xf,%edx
   4154d:	29 c2                	sub    %eax,%edx
   4154f:	89 d0                	mov    %edx,%eax
   41551:	48 63 d0             	movslq %eax,%rdx
   41554:	48 89 d0             	mov    %rdx,%rax
   41557:	48 c1 e0 04          	shl    $0x4,%rax
   4155b:	48 29 d0             	sub    %rdx,%rax
   4155e:	48 c1 e0 04          	shl    $0x4,%rax
   41562:	48 05 d8 e0 04 00    	add    $0x4e0d8,%rax
   41568:	8b 00                	mov    (%rax),%eax
   4156a:	85 c0                	test   %eax,%eax
   4156c:	74 b2                	je     41520 <memshow_virtual_animate+0x42>
    }
    showing = showing % NPROC;
   4156e:	8b 15 90 4a 00 00    	mov    0x4a90(%rip),%edx        # 46004 <showing.0>
   41574:	89 d0                	mov    %edx,%eax
   41576:	c1 f8 1f             	sar    $0x1f,%eax
   41579:	c1 e8 1c             	shr    $0x1c,%eax
   4157c:	01 c2                	add    %eax,%edx
   4157e:	83 e2 0f             	and    $0xf,%edx
   41581:	29 c2                	sub    %eax,%edx
   41583:	89 d0                	mov    %edx,%eax
   41585:	89 05 79 4a 00 00    	mov    %eax,0x4a79(%rip)        # 46004 <showing.0>

    if (processes[showing].p_state != P_FREE && processes[showing].display_status) {
   4158b:	8b 05 73 4a 00 00    	mov    0x4a73(%rip),%eax        # 46004 <showing.0>
   41591:	48 63 d0             	movslq %eax,%rdx
   41594:	48 89 d0             	mov    %rdx,%rax
   41597:	48 c1 e0 04          	shl    $0x4,%rax
   4159b:	48 29 d0             	sub    %rdx,%rax
   4159e:	48 c1 e0 04          	shl    $0x4,%rax
   415a2:	48 05 d8 e0 04 00    	add    $0x4e0d8,%rax
   415a8:	8b 00                	mov    (%rax),%eax
   415aa:	85 c0                	test   %eax,%eax
   415ac:	74 76                	je     41624 <memshow_virtual_animate+0x146>
   415ae:	8b 05 50 4a 00 00    	mov    0x4a50(%rip),%eax        # 46004 <showing.0>
   415b4:	48 63 d0             	movslq %eax,%rdx
   415b7:	48 89 d0             	mov    %rdx,%rax
   415ba:	48 c1 e0 04          	shl    $0x4,%rax
   415be:	48 29 d0             	sub    %rdx,%rax
   415c1:	48 c1 e0 04          	shl    $0x4,%rax
   415c5:	48 05 e8 e0 04 00    	add    $0x4e0e8,%rax
   415cb:	0f b6 00             	movzbl (%rax),%eax
   415ce:	84 c0                	test   %al,%al
   415d0:	74 52                	je     41624 <memshow_virtual_animate+0x146>
        char s[4];
        snprintf(s, 4, "%d ", showing);
   415d2:	8b 15 2c 4a 00 00    	mov    0x4a2c(%rip),%edx        # 46004 <showing.0>
   415d8:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
   415dc:	89 d1                	mov    %edx,%ecx
   415de:	ba 54 50 04 00       	mov    $0x45054,%edx
   415e3:	be 04 00 00 00       	mov    $0x4,%esi
   415e8:	48 89 c7             	mov    %rax,%rdi
   415eb:	b8 00 00 00 00       	mov    $0x0,%eax
   415f0:	e8 6c 35 00 00       	call   44b61 <snprintf>
        memshow_virtual(processes[showing].p_pagetable, s);
   415f5:	8b 05 09 4a 00 00    	mov    0x4a09(%rip),%eax        # 46004 <showing.0>
   415fb:	48 63 d0             	movslq %eax,%rdx
   415fe:	48 89 d0             	mov    %rdx,%rax
   41601:	48 c1 e0 04          	shl    $0x4,%rax
   41605:	48 29 d0             	sub    %rdx,%rax
   41608:	48 c1 e0 04          	shl    $0x4,%rax
   4160c:	48 05 e0 e0 04 00    	add    $0x4e0e0,%rax
   41612:	48 8b 00             	mov    (%rax),%rax
   41615:	48 8d 55 fc          	lea    -0x4(%rbp),%rdx
   41619:	48 89 d6             	mov    %rdx,%rsi
   4161c:	48 89 c7             	mov    %rax,%rdi
   4161f:	e8 c9 fc ff ff       	call   412ed <memshow_virtual>
    }
}
   41624:	90                   	nop
   41625:	c9                   	leave
   41626:	c3                   	ret

0000000000041627 <hardware_init>:

static void segments_init(void);
static void interrupt_init(void);
extern void virtual_memory_init(void);

void hardware_init(void) {
   41627:	55                   	push   %rbp
   41628:	48 89 e5             	mov    %rsp,%rbp
    segments_init();
   4162b:	e8 4f 01 00 00       	call   4177f <segments_init>
    interrupt_init();
   41630:	e8 d0 03 00 00       	call   41a05 <interrupt_init>
    virtual_memory_init();
   41635:	e8 f3 0f 00 00       	call   4262d <virtual_memory_init>
}
   4163a:	90                   	nop
   4163b:	5d                   	pop    %rbp
   4163c:	c3                   	ret

000000000004163d <set_app_segment>:
#define SEGSEL_TASKSTATE        0x28            // task state segment

// Segments
static uint64_t segments[7];

static void set_app_segment(uint64_t* segment, uint64_t type, int dpl) {
   4163d:	55                   	push   %rbp
   4163e:	48 89 e5             	mov    %rsp,%rbp
   41641:	48 83 ec 18          	sub    $0x18,%rsp
   41645:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41649:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   4164d:	89 55 ec             	mov    %edx,-0x14(%rbp)
    *segment = type
        | X86SEG_S                    // code/data segment
        | ((uint64_t) dpl << 45)
   41650:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41653:	48 98                	cltq
   41655:	48 c1 e0 2d          	shl    $0x2d,%rax
   41659:	48 0b 45 f0          	or     -0x10(%rbp),%rax
        | X86SEG_P;                   // segment present
   4165d:	48 ba 00 00 00 00 00 	movabs $0x900000000000,%rdx
   41664:	90 00 00 
   41667:	48 09 c2             	or     %rax,%rdx
    *segment = type
   4166a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4166e:	48 89 10             	mov    %rdx,(%rax)
}
   41671:	90                   	nop
   41672:	c9                   	leave
   41673:	c3                   	ret

0000000000041674 <set_sys_segment>:

static void set_sys_segment(uint64_t* segment, uint64_t type, int dpl,
                            uintptr_t addr, size_t size) {
   41674:	55                   	push   %rbp
   41675:	48 89 e5             	mov    %rsp,%rbp
   41678:	48 83 ec 28          	sub    $0x28,%rsp
   4167c:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41680:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41684:	89 55 ec             	mov    %edx,-0x14(%rbp)
   41687:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
   4168b:	4c 89 45 d8          	mov    %r8,-0x28(%rbp)
    segment[0] = ((addr & 0x0000000000FFFFFFUL) << 16)
   4168f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41693:	48 c1 e0 10          	shl    $0x10,%rax
   41697:	48 89 c2             	mov    %rax,%rdx
   4169a:	48 b8 00 00 ff ff ff 	movabs $0xffffff0000,%rax
   416a1:	00 00 00 
   416a4:	48 21 c2             	and    %rax,%rdx
        | ((addr & 0x00000000FF000000UL) << 32)
   416a7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   416ab:	48 c1 e0 20          	shl    $0x20,%rax
   416af:	48 89 c1             	mov    %rax,%rcx
   416b2:	48 b8 00 00 00 00 00 	movabs $0xff00000000000000,%rax
   416b9:	00 00 ff 
   416bc:	48 21 c8             	and    %rcx,%rax
   416bf:	48 09 c2             	or     %rax,%rdx
        | ((size - 1) & 0x0FFFFUL)
   416c2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   416c6:	48 83 e8 01          	sub    $0x1,%rax
   416ca:	0f b7 c0             	movzwl %ax,%eax
        | (((size - 1) & 0xF0000UL) << 48)
   416cd:	48 09 d0             	or     %rdx,%rax
        | type
   416d0:	48 0b 45 f0          	or     -0x10(%rbp),%rax
        | ((uint64_t) dpl << 45)
   416d4:	8b 55 ec             	mov    -0x14(%rbp),%edx
   416d7:	48 63 d2             	movslq %edx,%rdx
   416da:	48 c1 e2 2d          	shl    $0x2d,%rdx
   416de:	48 09 c2             	or     %rax,%rdx
        | X86SEG_P;                   // segment present
   416e1:	48 b8 00 00 00 00 00 	movabs $0x800000000000,%rax
   416e8:	80 00 00 
   416eb:	48 09 c2             	or     %rax,%rdx
    segment[0] = ((addr & 0x0000000000FFFFFFUL) << 16)
   416ee:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   416f2:	48 89 10             	mov    %rdx,(%rax)
    segment[1] = addr >> 32;
   416f5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   416f9:	48 83 c0 08          	add    $0x8,%rax
   416fd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   41701:	48 c1 ea 20          	shr    $0x20,%rdx
   41705:	48 89 10             	mov    %rdx,(%rax)
}
   41708:	90                   	nop
   41709:	c9                   	leave
   4170a:	c3                   	ret

000000000004170b <set_gate>:

// Processor state for taking an interrupt
static x86_64_taskstate kernel_task_descriptor;

static void set_gate(x86_64_gatedescriptor* gate, uint64_t type, int dpl,
                     uintptr_t function) {
   4170b:	55                   	push   %rbp
   4170c:	48 89 e5             	mov    %rsp,%rbp
   4170f:	48 83 ec 20          	sub    $0x20,%rsp
   41713:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41717:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   4171b:	89 55 ec             	mov    %edx,-0x14(%rbp)
   4171e:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
    gate->gd_low = (function & 0x000000000000FFFFUL)
   41722:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41726:	0f b7 c0             	movzwl %ax,%eax
        | (SEGSEL_KERN_CODE << 16)
        | type
   41729:	48 0b 45 f0          	or     -0x10(%rbp),%rax
        | ((uint64_t) dpl << 45)
   4172d:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41730:	48 63 d2             	movslq %edx,%rdx
   41733:	48 c1 e2 2d          	shl    $0x2d,%rdx
   41737:	48 09 c2             	or     %rax,%rdx
        | X86SEG_P
        | ((function & 0x00000000FFFF0000UL) << 32);
   4173a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4173e:	48 c1 e0 20          	shl    $0x20,%rax
   41742:	48 89 c1             	mov    %rax,%rcx
   41745:	48 b8 00 00 00 00 00 	movabs $0xffff000000000000,%rax
   4174c:	00 ff ff 
   4174f:	48 21 c8             	and    %rcx,%rax
   41752:	48 09 c2             	or     %rax,%rdx
   41755:	48 b8 00 00 08 00 00 	movabs $0x800000080000,%rax
   4175c:	80 00 00 
   4175f:	48 09 c2             	or     %rax,%rdx
    gate->gd_low = (function & 0x000000000000FFFFUL)
   41762:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41766:	48 89 10             	mov    %rdx,(%rax)
    gate->gd_high = function >> 32;
   41769:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4176d:	48 c1 e8 20          	shr    $0x20,%rax
   41771:	48 89 c2             	mov    %rax,%rdx
   41774:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41778:	48 89 50 08          	mov    %rdx,0x8(%rax)
}
   4177c:	90                   	nop
   4177d:	c9                   	leave
   4177e:	c3                   	ret

000000000004177f <segments_init>:
extern void default_int_handler(void);
extern void gpf_int_handler(void);
extern void pagefault_int_handler(void);
extern void timer_int_handler(void);

void segments_init(void) {
   4177f:	55                   	push   %rbp
   41780:	48 89 e5             	mov    %rsp,%rbp
   41783:	48 83 ec 40          	sub    $0x40,%rsp
    // Segments for kernel & user code & data
    // The privilege level, which can be 0 or 3, differentiates between
    // kernel and user code. (Data segments are unused in WeensyOS.)
    segments[0] = 0;
   41787:	48 c7 05 ae db 00 00 	movq   $0x0,0xdbae(%rip)        # 4f340 <segments>
   4178e:	00 00 00 00 
    set_app_segment(&segments[SEGSEL_KERN_CODE >> 3], X86SEG_X | X86SEG_L, 0);
   41792:	ba 00 00 00 00       	mov    $0x0,%edx
   41797:	48 b8 00 00 00 00 00 	movabs $0x20080000000000,%rax
   4179e:	08 20 00 
   417a1:	48 89 c6             	mov    %rax,%rsi
   417a4:	bf 48 f3 04 00       	mov    $0x4f348,%edi
   417a9:	e8 8f fe ff ff       	call   4163d <set_app_segment>
    set_app_segment(&segments[SEGSEL_APP_CODE >> 3], X86SEG_X | X86SEG_L, 3);
   417ae:	ba 03 00 00 00       	mov    $0x3,%edx
   417b3:	48 b8 00 00 00 00 00 	movabs $0x20080000000000,%rax
   417ba:	08 20 00 
   417bd:	48 89 c6             	mov    %rax,%rsi
   417c0:	bf 50 f3 04 00       	mov    $0x4f350,%edi
   417c5:	e8 73 fe ff ff       	call   4163d <set_app_segment>
    set_app_segment(&segments[SEGSEL_KERN_DATA >> 3], X86SEG_W, 0);
   417ca:	ba 00 00 00 00       	mov    $0x0,%edx
   417cf:	48 b8 00 00 00 00 00 	movabs $0x20000000000,%rax
   417d6:	02 00 00 
   417d9:	48 89 c6             	mov    %rax,%rsi
   417dc:	bf 58 f3 04 00       	mov    $0x4f358,%edi
   417e1:	e8 57 fe ff ff       	call   4163d <set_app_segment>
    set_app_segment(&segments[SEGSEL_APP_DATA >> 3], X86SEG_W, 3);
   417e6:	ba 03 00 00 00       	mov    $0x3,%edx
   417eb:	48 b8 00 00 00 00 00 	movabs $0x20000000000,%rax
   417f2:	02 00 00 
   417f5:	48 89 c6             	mov    %rax,%rsi
   417f8:	bf 60 f3 04 00       	mov    $0x4f360,%edi
   417fd:	e8 3b fe ff ff       	call   4163d <set_app_segment>
    set_sys_segment(&segments[SEGSEL_TASKSTATE >> 3], X86SEG_TSS, 0,
   41802:	b8 80 03 05 00       	mov    $0x50380,%eax
   41807:	41 b8 60 00 00 00    	mov    $0x60,%r8d
   4180d:	48 89 c1             	mov    %rax,%rcx
   41810:	ba 00 00 00 00       	mov    $0x0,%edx
   41815:	48 b8 00 00 00 00 00 	movabs $0x90000000000,%rax
   4181c:	09 00 00 
   4181f:	48 89 c6             	mov    %rax,%rsi
   41822:	bf 68 f3 04 00       	mov    $0x4f368,%edi
   41827:	e8 48 fe ff ff       	call   41674 <set_sys_segment>
                    (uintptr_t) &kernel_task_descriptor,
                    sizeof(kernel_task_descriptor));

    x86_64_pseudodescriptor gdt;
    gdt.pseudod_limit = sizeof(segments) - 1;
   4182c:	66 c7 45 d6 37 00    	movw   $0x37,-0x2a(%rbp)
    gdt.pseudod_base = (uint64_t) segments;
   41832:	b8 40 f3 04 00       	mov    $0x4f340,%eax
   41837:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

    // Kernel task descriptor lets us receive interrupts
    memset(&kernel_task_descriptor, 0, sizeof(kernel_task_descriptor));
   4183b:	ba 60 00 00 00       	mov    $0x60,%edx
   41840:	be 00 00 00 00       	mov    $0x0,%esi
   41845:	bf 80 03 05 00       	mov    $0x50380,%edi
   4184a:	e8 4f 24 00 00       	call   43c9e <memset>
    kernel_task_descriptor.ts_rsp[0] = KERNEL_STACK_TOP;
   4184f:	48 c7 05 2a eb 00 00 	movq   $0x80000,0xeb2a(%rip)        # 50384 <kernel_task_descriptor+0x4>
   41856:	00 00 08 00 

    // Interrupt handler; most interrupts are effectively ignored
    memset(interrupt_descriptors, 0, sizeof(interrupt_descriptors));
   4185a:	ba 00 10 00 00       	mov    $0x1000,%edx
   4185f:	be 00 00 00 00       	mov    $0x0,%esi
   41864:	bf 80 f3 04 00       	mov    $0x4f380,%edi
   41869:	e8 30 24 00 00       	call   43c9e <memset>
    for (unsigned i = 16; i < arraysize(interrupt_descriptors); ++i) {
   4186e:	c7 45 fc 10 00 00 00 	movl   $0x10,-0x4(%rbp)
   41875:	eb 30                	jmp    418a7 <segments_init+0x128>
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 0,
   41877:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   4187c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4187f:	48 c1 e0 04          	shl    $0x4,%rax
   41883:	48 05 80 f3 04 00    	add    $0x4f380,%rax
   41889:	48 89 d1             	mov    %rdx,%rcx
   4188c:	ba 00 00 00 00       	mov    $0x0,%edx
   41891:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41898:	0e 00 00 
   4189b:	48 89 c7             	mov    %rax,%rdi
   4189e:	e8 68 fe ff ff       	call   4170b <set_gate>
    for (unsigned i = 16; i < arraysize(interrupt_descriptors); ++i) {
   418a3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   418a7:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
   418ae:	76 c7                	jbe    41877 <segments_init+0xf8>
                 (uint64_t) default_int_handler);
    }

    // Timer interrupt
    set_gate(&interrupt_descriptors[INT_TIMER], X86GATE_INTERRUPT, 0,
   418b0:	b8 36 00 04 00       	mov    $0x40036,%eax
   418b5:	48 89 c1             	mov    %rax,%rcx
   418b8:	ba 00 00 00 00       	mov    $0x0,%edx
   418bd:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   418c4:	0e 00 00 
   418c7:	48 89 c6             	mov    %rax,%rsi
   418ca:	bf 80 f5 04 00       	mov    $0x4f580,%edi
   418cf:	e8 37 fe ff ff       	call   4170b <set_gate>
             (uint64_t) timer_int_handler);

    // GPF and page fault
    set_gate(&interrupt_descriptors[INT_GPF], X86GATE_INTERRUPT, 0,
   418d4:	b8 2e 00 04 00       	mov    $0x4002e,%eax
   418d9:	48 89 c1             	mov    %rax,%rcx
   418dc:	ba 00 00 00 00       	mov    $0x0,%edx
   418e1:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   418e8:	0e 00 00 
   418eb:	48 89 c6             	mov    %rax,%rsi
   418ee:	bf 50 f4 04 00       	mov    $0x4f450,%edi
   418f3:	e8 13 fe ff ff       	call   4170b <set_gate>
             (uint64_t) gpf_int_handler);
    set_gate(&interrupt_descriptors[INT_PAGEFAULT], X86GATE_INTERRUPT, 0,
   418f8:	b8 32 00 04 00       	mov    $0x40032,%eax
   418fd:	48 89 c1             	mov    %rax,%rcx
   41900:	ba 00 00 00 00       	mov    $0x0,%edx
   41905:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   4190c:	0e 00 00 
   4190f:	48 89 c6             	mov    %rax,%rsi
   41912:	bf 60 f4 04 00       	mov    $0x4f460,%edi
   41917:	e8 ef fd ff ff       	call   4170b <set_gate>
             (uint64_t) pagefault_int_handler);

    // System calls get special handling.
    // Note that the last argument is '3'.  This means that unprivileged
    // (level-3) applications may generate these interrupts.
    for (unsigned i = INT_SYS; i < INT_SYS + 16; ++i) {
   4191c:	c7 45 f8 30 00 00 00 	movl   $0x30,-0x8(%rbp)
   41923:	eb 3e                	jmp    41963 <segments_init+0x1e4>
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 3,
                 (uint64_t) sys_int_handlers[i - INT_SYS]);
   41925:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41928:	83 e8 30             	sub    $0x30,%eax
   4192b:	89 c0                	mov    %eax,%eax
   4192d:	48 8b 04 c5 e7 00 04 	mov    0x400e7(,%rax,8),%rax
   41934:	00 
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 3,
   41935:	48 89 c2             	mov    %rax,%rdx
   41938:	8b 45 f8             	mov    -0x8(%rbp),%eax
   4193b:	48 c1 e0 04          	shl    $0x4,%rax
   4193f:	48 05 80 f3 04 00    	add    $0x4f380,%rax
   41945:	48 89 d1             	mov    %rdx,%rcx
   41948:	ba 03 00 00 00       	mov    $0x3,%edx
   4194d:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41954:	0e 00 00 
   41957:	48 89 c7             	mov    %rax,%rdi
   4195a:	e8 ac fd ff ff       	call   4170b <set_gate>
    for (unsigned i = INT_SYS; i < INT_SYS + 16; ++i) {
   4195f:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   41963:	83 7d f8 3f          	cmpl   $0x3f,-0x8(%rbp)
   41967:	76 bc                	jbe    41925 <segments_init+0x1a6>
    }

    x86_64_pseudodescriptor idt;
    idt.pseudod_limit = sizeof(interrupt_descriptors) - 1;
   41969:	66 c7 45 cc ff 0f    	movw   $0xfff,-0x34(%rbp)
    idt.pseudod_base = (uint64_t) interrupt_descriptors;
   4196f:	b8 80 f3 04 00       	mov    $0x4f380,%eax
   41974:	48 89 45 ce          	mov    %rax,-0x32(%rbp)

    // Reload segment pointers
    asm volatile("lgdt %0\n\t"
   41978:	b8 28 00 00 00       	mov    $0x28,%eax
   4197d:	0f 01 55 d6          	lgdt   -0x2a(%rbp)
   41981:	0f 00 d8             	ltr    %ax
   41984:	0f 01 5d cc          	lidt   -0x34(%rbp)
    asm volatile("movq %%cr0,%0" : "=r" (val));
   41988:	0f 20 c0             	mov    %cr0,%rax
   4198b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    return val;
   4198f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
                     "r" ((uint16_t) SEGSEL_TASKSTATE),
                     "m" (idt)
                 : "memory");

    // Set up control registers: check alignment
    uint32_t cr0 = rcr0();
   41993:	89 45 f4             	mov    %eax,-0xc(%rbp)
    cr0 |= CR0_PE | CR0_PG | CR0_WP | CR0_AM | CR0_MP | CR0_NE;
   41996:	81 4d f4 23 00 05 80 	orl    $0x80050023,-0xc(%rbp)
   4199d:	8b 45 f4             	mov    -0xc(%rbp),%eax
   419a0:	89 45 f0             	mov    %eax,-0x10(%rbp)
    uint64_t xval = val;
   419a3:	8b 45 f0             	mov    -0x10(%rbp),%eax
   419a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    asm volatile("movq %0,%%cr0" : : "r" (xval));
   419aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   419ae:	0f 22 c0             	mov    %rax,%cr0
}
   419b1:	90                   	nop
    lcr0(cr0);
}
   419b2:	90                   	nop
   419b3:	c9                   	leave
   419b4:	c3                   	ret

00000000000419b5 <interrupt_mask>:
#define TIMER_FREQ      1193182
#define TIMER_DIV(x)    ((TIMER_FREQ+(x)/2)/(x))

static uint16_t interrupts_enabled;

static void interrupt_mask(void) {
   419b5:	55                   	push   %rbp
   419b6:	48 89 e5             	mov    %rsp,%rbp
   419b9:	48 83 ec 20          	sub    $0x20,%rsp
    uint16_t masked = ~interrupts_enabled;
   419bd:	0f b7 05 1c ea 00 00 	movzwl 0xea1c(%rip),%eax        # 503e0 <interrupts_enabled>
   419c4:	f7 d0                	not    %eax
   419c6:	66 89 45 fe          	mov    %ax,-0x2(%rbp)
    outb(IO_PIC1+1, masked & 0xFF);
   419ca:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
   419ce:	0f b6 c0             	movzbl %al,%eax
   419d1:	c7 45 f0 21 00 00 00 	movl   $0x21,-0x10(%rbp)
   419d8:	88 45 ef             	mov    %al,-0x11(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   419db:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   419df:	8b 55 f0             	mov    -0x10(%rbp),%edx
   419e2:	ee                   	out    %al,(%dx)
}
   419e3:	90                   	nop
    outb(IO_PIC2+1, (masked >> 8) & 0xFF);
   419e4:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
   419e8:	66 c1 e8 08          	shr    $0x8,%ax
   419ec:	0f b6 c0             	movzbl %al,%eax
   419ef:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%rbp)
   419f6:	88 45 f7             	mov    %al,-0x9(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   419f9:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
   419fd:	8b 55 f8             	mov    -0x8(%rbp),%edx
   41a00:	ee                   	out    %al,(%dx)
}
   41a01:	90                   	nop
}
   41a02:	90                   	nop
   41a03:	c9                   	leave
   41a04:	c3                   	ret

0000000000041a05 <interrupt_init>:

void interrupt_init(void) {
   41a05:	55                   	push   %rbp
   41a06:	48 89 e5             	mov    %rsp,%rbp
   41a09:	48 83 ec 60          	sub    $0x60,%rsp
    // mask all interrupts
    interrupts_enabled = 0;
   41a0d:	66 c7 05 ca e9 00 00 	movw   $0x0,0xe9ca(%rip)        # 503e0 <interrupts_enabled>
   41a14:	00 00 
    interrupt_mask();
   41a16:	e8 9a ff ff ff       	call   419b5 <interrupt_mask>
   41a1b:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%rbp)
   41a22:	c6 45 a3 11          	movb   $0x11,-0x5d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41a26:	0f b6 45 a3          	movzbl -0x5d(%rbp),%eax
   41a2a:	8b 55 a4             	mov    -0x5c(%rbp),%edx
   41a2d:	ee                   	out    %al,(%dx)
}
   41a2e:	90                   	nop
   41a2f:	c7 45 ac 21 00 00 00 	movl   $0x21,-0x54(%rbp)
   41a36:	c6 45 ab 20          	movb   $0x20,-0x55(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41a3a:	0f b6 45 ab          	movzbl -0x55(%rbp),%eax
   41a3e:	8b 55 ac             	mov    -0x54(%rbp),%edx
   41a41:	ee                   	out    %al,(%dx)
}
   41a42:	90                   	nop
   41a43:	c7 45 b4 21 00 00 00 	movl   $0x21,-0x4c(%rbp)
   41a4a:	c6 45 b3 04          	movb   $0x4,-0x4d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41a4e:	0f b6 45 b3          	movzbl -0x4d(%rbp),%eax
   41a52:	8b 55 b4             	mov    -0x4c(%rbp),%edx
   41a55:	ee                   	out    %al,(%dx)
}
   41a56:	90                   	nop
   41a57:	c7 45 bc 21 00 00 00 	movl   $0x21,-0x44(%rbp)
   41a5e:	c6 45 bb 03          	movb   $0x3,-0x45(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41a62:	0f b6 45 bb          	movzbl -0x45(%rbp),%eax
   41a66:	8b 55 bc             	mov    -0x44(%rbp),%edx
   41a69:	ee                   	out    %al,(%dx)
}
   41a6a:	90                   	nop
   41a6b:	c7 45 c4 a0 00 00 00 	movl   $0xa0,-0x3c(%rbp)
   41a72:	c6 45 c3 11          	movb   $0x11,-0x3d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41a76:	0f b6 45 c3          	movzbl -0x3d(%rbp),%eax
   41a7a:	8b 55 c4             	mov    -0x3c(%rbp),%edx
   41a7d:	ee                   	out    %al,(%dx)
}
   41a7e:	90                   	nop
   41a7f:	c7 45 cc a1 00 00 00 	movl   $0xa1,-0x34(%rbp)
   41a86:	c6 45 cb 28          	movb   $0x28,-0x35(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41a8a:	0f b6 45 cb          	movzbl -0x35(%rbp),%eax
   41a8e:	8b 55 cc             	mov    -0x34(%rbp),%edx
   41a91:	ee                   	out    %al,(%dx)
}
   41a92:	90                   	nop
   41a93:	c7 45 d4 a1 00 00 00 	movl   $0xa1,-0x2c(%rbp)
   41a9a:	c6 45 d3 02          	movb   $0x2,-0x2d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41a9e:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
   41aa2:	8b 55 d4             	mov    -0x2c(%rbp),%edx
   41aa5:	ee                   	out    %al,(%dx)
}
   41aa6:	90                   	nop
   41aa7:	c7 45 dc a1 00 00 00 	movl   $0xa1,-0x24(%rbp)
   41aae:	c6 45 db 01          	movb   $0x1,-0x25(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41ab2:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
   41ab6:	8b 55 dc             	mov    -0x24(%rbp),%edx
   41ab9:	ee                   	out    %al,(%dx)
}
   41aba:	90                   	nop
   41abb:	c7 45 e4 20 00 00 00 	movl   $0x20,-0x1c(%rbp)
   41ac2:	c6 45 e3 68          	movb   $0x68,-0x1d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41ac6:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
   41aca:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   41acd:	ee                   	out    %al,(%dx)
}
   41ace:	90                   	nop
   41acf:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%rbp)
   41ad6:	c6 45 eb 0a          	movb   $0xa,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41ada:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   41ade:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41ae1:	ee                   	out    %al,(%dx)
}
   41ae2:	90                   	nop
   41ae3:	c7 45 f4 a0 00 00 00 	movl   $0xa0,-0xc(%rbp)
   41aea:	c6 45 f3 68          	movb   $0x68,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41aee:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   41af2:	8b 55 f4             	mov    -0xc(%rbp),%edx
   41af5:	ee                   	out    %al,(%dx)
}
   41af6:	90                   	nop
   41af7:	c7 45 fc a0 00 00 00 	movl   $0xa0,-0x4(%rbp)
   41afe:	c6 45 fb 0a          	movb   $0xa,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41b02:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41b06:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41b09:	ee                   	out    %al,(%dx)
}
   41b0a:	90                   	nop

    outb(IO_PIC2, 0x68);               /* OCW3 */
    outb(IO_PIC2, 0x0a);               /* OCW3 */

    // re-disable interrupts
    interrupt_mask();
   41b0b:	e8 a5 fe ff ff       	call   419b5 <interrupt_mask>
}
   41b10:	90                   	nop
   41b11:	c9                   	leave
   41b12:	c3                   	ret

0000000000041b13 <timer_init>:

// timer_init(rate)
//    Set the timer interrupt to fire `rate` times a second. Disables the
//    timer interrupt if `rate <= 0`.

void timer_init(int rate) {
   41b13:	55                   	push   %rbp
   41b14:	48 89 e5             	mov    %rsp,%rbp
   41b17:	48 83 ec 28          	sub    $0x28,%rsp
   41b1b:	89 7d dc             	mov    %edi,-0x24(%rbp)
    if (rate > 0) {
   41b1e:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   41b22:	0f 8e 9e 00 00 00    	jle    41bc6 <timer_init+0xb3>
   41b28:	c7 45 ec 43 00 00 00 	movl   $0x43,-0x14(%rbp)
   41b2f:	c6 45 eb 34          	movb   $0x34,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41b33:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   41b37:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41b3a:	ee                   	out    %al,(%dx)
}
   41b3b:	90                   	nop
        outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
        outb(IO_TIMER1, TIMER_DIV(rate) % 256);
   41b3c:	8b 45 dc             	mov    -0x24(%rbp),%eax
   41b3f:	89 c2                	mov    %eax,%edx
   41b41:	c1 ea 1f             	shr    $0x1f,%edx
   41b44:	01 d0                	add    %edx,%eax
   41b46:	d1 f8                	sar    %eax
   41b48:	05 de 34 12 00       	add    $0x1234de,%eax
   41b4d:	99                   	cltd
   41b4e:	f7 7d dc             	idivl  -0x24(%rbp)
   41b51:	89 c2                	mov    %eax,%edx
   41b53:	89 d0                	mov    %edx,%eax
   41b55:	c1 f8 1f             	sar    $0x1f,%eax
   41b58:	c1 e8 18             	shr    $0x18,%eax
   41b5b:	01 c2                	add    %eax,%edx
   41b5d:	0f b6 d2             	movzbl %dl,%edx
   41b60:	29 c2                	sub    %eax,%edx
   41b62:	89 d0                	mov    %edx,%eax
   41b64:	0f b6 c0             	movzbl %al,%eax
   41b67:	c7 45 f4 40 00 00 00 	movl   $0x40,-0xc(%rbp)
   41b6e:	88 45 f3             	mov    %al,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41b71:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   41b75:	8b 55 f4             	mov    -0xc(%rbp),%edx
   41b78:	ee                   	out    %al,(%dx)
}
   41b79:	90                   	nop
        outb(IO_TIMER1, TIMER_DIV(rate) / 256);
   41b7a:	8b 45 dc             	mov    -0x24(%rbp),%eax
   41b7d:	89 c2                	mov    %eax,%edx
   41b7f:	c1 ea 1f             	shr    $0x1f,%edx
   41b82:	01 d0                	add    %edx,%eax
   41b84:	d1 f8                	sar    %eax
   41b86:	05 de 34 12 00       	add    $0x1234de,%eax
   41b8b:	99                   	cltd
   41b8c:	f7 7d dc             	idivl  -0x24(%rbp)
   41b8f:	8d 90 ff 00 00 00    	lea    0xff(%rax),%edx
   41b95:	85 c0                	test   %eax,%eax
   41b97:	0f 48 c2             	cmovs  %edx,%eax
   41b9a:	c1 f8 08             	sar    $0x8,%eax
   41b9d:	0f b6 c0             	movzbl %al,%eax
   41ba0:	c7 45 fc 40 00 00 00 	movl   $0x40,-0x4(%rbp)
   41ba7:	88 45 fb             	mov    %al,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41baa:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41bae:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41bb1:	ee                   	out    %al,(%dx)
}
   41bb2:	90                   	nop
        interrupts_enabled |= 1 << (INT_TIMER - INT_HARDWARE);
   41bb3:	0f b7 05 26 e8 00 00 	movzwl 0xe826(%rip),%eax        # 503e0 <interrupts_enabled>
   41bba:	83 c8 01             	or     $0x1,%eax
   41bbd:	66 89 05 1c e8 00 00 	mov    %ax,0xe81c(%rip)        # 503e0 <interrupts_enabled>
   41bc4:	eb 11                	jmp    41bd7 <timer_init+0xc4>
    } else {
        interrupts_enabled &= ~(1 << (INT_TIMER - INT_HARDWARE));
   41bc6:	0f b7 05 13 e8 00 00 	movzwl 0xe813(%rip),%eax        # 503e0 <interrupts_enabled>
   41bcd:	83 e0 fe             	and    $0xfffffffe,%eax
   41bd0:	66 89 05 09 e8 00 00 	mov    %ax,0xe809(%rip)        # 503e0 <interrupts_enabled>
    }
    interrupt_mask();
   41bd7:	e8 d9 fd ff ff       	call   419b5 <interrupt_mask>
}
   41bdc:	90                   	nop
   41bdd:	c9                   	leave
   41bde:	c3                   	ret

0000000000041bdf <physical_memory_isreserved>:
//    Returns non-zero iff `pa` is a reserved physical address.

#define IOPHYSMEM       0x000A0000
#define EXTPHYSMEM      0x00100000

int physical_memory_isreserved(uintptr_t pa) {
   41bdf:	55                   	push   %rbp
   41be0:	48 89 e5             	mov    %rsp,%rbp
   41be3:	48 83 ec 08          	sub    $0x8,%rsp
   41be7:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    return pa == 0 || (pa >= IOPHYSMEM && pa < EXTPHYSMEM);
   41beb:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   41bf0:	74 14                	je     41c06 <physical_memory_isreserved+0x27>
   41bf2:	48 81 7d f8 ff ff 09 	cmpq   $0x9ffff,-0x8(%rbp)
   41bf9:	00 
   41bfa:	76 11                	jbe    41c0d <physical_memory_isreserved+0x2e>
   41bfc:	48 81 7d f8 ff ff 0f 	cmpq   $0xfffff,-0x8(%rbp)
   41c03:	00 
   41c04:	77 07                	ja     41c0d <physical_memory_isreserved+0x2e>
   41c06:	b8 01 00 00 00       	mov    $0x1,%eax
   41c0b:	eb 05                	jmp    41c12 <physical_memory_isreserved+0x33>
   41c0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
   41c12:	c9                   	leave
   41c13:	c3                   	ret

0000000000041c14 <pci_make_configaddr>:


// pci_make_configaddr(bus, slot, func)
//    Construct a PCI configuration space address from parts.

static int pci_make_configaddr(int bus, int slot, int func) {
   41c14:	55                   	push   %rbp
   41c15:	48 89 e5             	mov    %rsp,%rbp
   41c18:	48 83 ec 10          	sub    $0x10,%rsp
   41c1c:	89 7d fc             	mov    %edi,-0x4(%rbp)
   41c1f:	89 75 f8             	mov    %esi,-0x8(%rbp)
   41c22:	89 55 f4             	mov    %edx,-0xc(%rbp)
    return (bus << 16) | (slot << 11) | (func << 8);
   41c25:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41c28:	c1 e0 10             	shl    $0x10,%eax
   41c2b:	89 c2                	mov    %eax,%edx
   41c2d:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41c30:	c1 e0 0b             	shl    $0xb,%eax
   41c33:	09 c2                	or     %eax,%edx
   41c35:	8b 45 f4             	mov    -0xc(%rbp),%eax
   41c38:	c1 e0 08             	shl    $0x8,%eax
   41c3b:	09 d0                	or     %edx,%eax
}
   41c3d:	c9                   	leave
   41c3e:	c3                   	ret

0000000000041c3f <pci_config_readl>:
//    Read a 32-bit word in PCI configuration space.

#define PCI_HOST_BRIDGE_CONFIG_ADDR 0xCF8
#define PCI_HOST_BRIDGE_CONFIG_DATA 0xCFC

static uint32_t pci_config_readl(int configaddr, int offset) {
   41c3f:	55                   	push   %rbp
   41c40:	48 89 e5             	mov    %rsp,%rbp
   41c43:	48 83 ec 18          	sub    $0x18,%rsp
   41c47:	89 7d ec             	mov    %edi,-0x14(%rbp)
   41c4a:	89 75 e8             	mov    %esi,-0x18(%rbp)
    outl(PCI_HOST_BRIDGE_CONFIG_ADDR, 0x80000000 | configaddr | offset);
   41c4d:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41c50:	8b 45 e8             	mov    -0x18(%rbp),%eax
   41c53:	09 d0                	or     %edx,%eax
   41c55:	0d 00 00 00 80       	or     $0x80000000,%eax
   41c5a:	c7 45 f4 f8 0c 00 00 	movl   $0xcf8,-0xc(%rbp)
   41c61:	89 45 f0             	mov    %eax,-0x10(%rbp)
    asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
   41c64:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41c67:	8b 55 f4             	mov    -0xc(%rbp),%edx
   41c6a:	ef                   	out    %eax,(%dx)
}
   41c6b:	90                   	nop
   41c6c:	c7 45 fc fc 0c 00 00 	movl   $0xcfc,-0x4(%rbp)
    asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
   41c73:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41c76:	89 c2                	mov    %eax,%edx
   41c78:	ed                   	in     (%dx),%eax
   41c79:	89 45 f8             	mov    %eax,-0x8(%rbp)
    return data;
   41c7c:	8b 45 f8             	mov    -0x8(%rbp),%eax
    return inl(PCI_HOST_BRIDGE_CONFIG_DATA);
}
   41c7f:	c9                   	leave
   41c80:	c3                   	ret

0000000000041c81 <pci_find_device>:

// pci_find_device
//    Search for a PCI device matching `vendor` and `device`. Return
//    the config base address or -1 if no device was found.

static int pci_find_device(int vendor, int device) {
   41c81:	55                   	push   %rbp
   41c82:	48 89 e5             	mov    %rsp,%rbp
   41c85:	48 83 ec 28          	sub    $0x28,%rsp
   41c89:	89 7d dc             	mov    %edi,-0x24(%rbp)
   41c8c:	89 75 d8             	mov    %esi,-0x28(%rbp)
    for (int bus = 0; bus != 256; ++bus) {
   41c8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   41c96:	eb 73                	jmp    41d0b <pci_find_device+0x8a>
        for (int slot = 0; slot != 32; ++slot) {
   41c98:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   41c9f:	eb 60                	jmp    41d01 <pci_find_device+0x80>
            for (int func = 0; func != 8; ++func) {
   41ca1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   41ca8:	eb 4a                	jmp    41cf4 <pci_find_device+0x73>
                int configaddr = pci_make_configaddr(bus, slot, func);
   41caa:	8b 55 f4             	mov    -0xc(%rbp),%edx
   41cad:	8b 4d f8             	mov    -0x8(%rbp),%ecx
   41cb0:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41cb3:	89 ce                	mov    %ecx,%esi
   41cb5:	89 c7                	mov    %eax,%edi
   41cb7:	e8 58 ff ff ff       	call   41c14 <pci_make_configaddr>
   41cbc:	89 45 f0             	mov    %eax,-0x10(%rbp)
                uint32_t vendor_device = pci_config_readl(configaddr, 0);
   41cbf:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41cc2:	be 00 00 00 00       	mov    $0x0,%esi
   41cc7:	89 c7                	mov    %eax,%edi
   41cc9:	e8 71 ff ff ff       	call   41c3f <pci_config_readl>
   41cce:	89 45 ec             	mov    %eax,-0x14(%rbp)
                if (vendor_device == (uint32_t) (vendor | (device << 16))) {
   41cd1:	8b 45 d8             	mov    -0x28(%rbp),%eax
   41cd4:	c1 e0 10             	shl    $0x10,%eax
   41cd7:	0b 45 dc             	or     -0x24(%rbp),%eax
   41cda:	39 45 ec             	cmp    %eax,-0x14(%rbp)
   41cdd:	75 05                	jne    41ce4 <pci_find_device+0x63>
                    return configaddr;
   41cdf:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41ce2:	eb 35                	jmp    41d19 <pci_find_device+0x98>
                } else if (vendor_device == (uint32_t) -1 && func == 0) {
   41ce4:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%rbp)
   41ce8:	75 06                	jne    41cf0 <pci_find_device+0x6f>
   41cea:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   41cee:	74 0c                	je     41cfc <pci_find_device+0x7b>
            for (int func = 0; func != 8; ++func) {
   41cf0:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   41cf4:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
   41cf8:	75 b0                	jne    41caa <pci_find_device+0x29>
   41cfa:	eb 01                	jmp    41cfd <pci_find_device+0x7c>
                    break;
   41cfc:	90                   	nop
        for (int slot = 0; slot != 32; ++slot) {
   41cfd:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   41d01:	83 7d f8 20          	cmpl   $0x20,-0x8(%rbp)
   41d05:	75 9a                	jne    41ca1 <pci_find_device+0x20>
    for (int bus = 0; bus != 256; ++bus) {
   41d07:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41d0b:	81 7d fc 00 01 00 00 	cmpl   $0x100,-0x4(%rbp)
   41d12:	75 84                	jne    41c98 <pci_find_device+0x17>
                }
            }
        }
    }
    return -1;
   41d14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
   41d19:	c9                   	leave
   41d1a:	c3                   	ret

0000000000041d1b <poweroff>:
//    that speaks ACPI; QEMU emulates a PIIX4 Power Management Controller.

#define PCI_VENDOR_ID_INTEL     0x8086
#define PCI_DEVICE_ID_PIIX4     0x7113

void poweroff(void) {
   41d1b:	55                   	push   %rbp
   41d1c:	48 89 e5             	mov    %rsp,%rbp
   41d1f:	48 83 ec 10          	sub    $0x10,%rsp
    int configaddr = pci_find_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PIIX4);
   41d23:	be 13 71 00 00       	mov    $0x7113,%esi
   41d28:	bf 86 80 00 00       	mov    $0x8086,%edi
   41d2d:	e8 4f ff ff ff       	call   41c81 <pci_find_device>
   41d32:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if (configaddr >= 0) {
   41d35:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   41d39:	78 30                	js     41d6b <poweroff+0x50>
        // Read I/O base register from controller's PCI configuration space.
        int pm_io_base = pci_config_readl(configaddr, 0x40) & 0xFFC0;
   41d3b:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41d3e:	be 40 00 00 00       	mov    $0x40,%esi
   41d43:	89 c7                	mov    %eax,%edi
   41d45:	e8 f5 fe ff ff       	call   41c3f <pci_config_readl>
   41d4a:	25 c0 ff 00 00       	and    $0xffc0,%eax
   41d4f:	89 45 f8             	mov    %eax,-0x8(%rbp)
        // Write `suspend enable` to the power management control register.
        outw(pm_io_base + 4, 0x2000);
   41d52:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41d55:	83 c0 04             	add    $0x4,%eax
   41d58:	89 45 f4             	mov    %eax,-0xc(%rbp)
   41d5b:	66 c7 45 f2 00 20    	movw   $0x2000,-0xe(%rbp)
    asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
   41d61:	0f b7 45 f2          	movzwl -0xe(%rbp),%eax
   41d65:	8b 55 f4             	mov    -0xc(%rbp),%edx
   41d68:	66 ef                	out    %ax,(%dx)
}
   41d6a:	90                   	nop
    }
    // No PIIX4; spin.
    console_printf(CPOS(24, 0), 0xC000, "Cannot power off!\n");
   41d6b:	ba 60 50 04 00       	mov    $0x45060,%edx
   41d70:	be 00 c0 00 00       	mov    $0xc000,%esi
   41d75:	bf 80 07 00 00       	mov    $0x780,%edi
   41d7a:	b8 00 00 00 00       	mov    $0x0,%eax
   41d7f:	e8 d1 2c 00 00       	call   44a55 <console_printf>
 spinloop: goto spinloop;
   41d84:	eb fe                	jmp    41d84 <poweroff+0x69>

0000000000041d86 <reboot>:


// reboot
//    Reboot the virtual machine.

void reboot(void) {
   41d86:	55                   	push   %rbp
   41d87:	48 89 e5             	mov    %rsp,%rbp
   41d8a:	48 83 ec 10          	sub    $0x10,%rsp
   41d8e:	c7 45 fc 92 00 00 00 	movl   $0x92,-0x4(%rbp)
   41d95:	c6 45 fb 03          	movb   $0x3,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41d99:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41d9d:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41da0:	ee                   	out    %al,(%dx)
}
   41da1:	90                   	nop
    outb(0x92, 3);
 spinloop: goto spinloop;
   41da2:	eb fe                	jmp    41da2 <reboot+0x1c>

0000000000041da4 <process_init>:


// process_init(p, flags)
//    Initialize special-purpose registers for process `p`.

void process_init(proc* p, int flags) {
   41da4:	55                   	push   %rbp
   41da5:	48 89 e5             	mov    %rsp,%rbp
   41da8:	48 83 ec 10          	sub    $0x10,%rsp
   41dac:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41db0:	89 75 f4             	mov    %esi,-0xc(%rbp)
    memset(&p->p_registers, 0, sizeof(p->p_registers));
   41db3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41db7:	48 83 c0 18          	add    $0x18,%rax
   41dbb:	ba c0 00 00 00       	mov    $0xc0,%edx
   41dc0:	be 00 00 00 00       	mov    $0x0,%esi
   41dc5:	48 89 c7             	mov    %rax,%rdi
   41dc8:	e8 d1 1e 00 00       	call   43c9e <memset>
    p->p_registers.reg_cs = SEGSEL_APP_CODE | 3;
   41dcd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41dd1:	66 c7 80 b8 00 00 00 	movw   $0x13,0xb8(%rax)
   41dd8:	13 00 
    p->p_registers.reg_fs = SEGSEL_APP_DATA | 3;
   41dda:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41dde:	48 c7 80 90 00 00 00 	movq   $0x23,0x90(%rax)
   41de5:	23 00 00 00 
    p->p_registers.reg_gs = SEGSEL_APP_DATA | 3;
   41de9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41ded:	48 c7 80 98 00 00 00 	movq   $0x23,0x98(%rax)
   41df4:	23 00 00 00 
    p->p_registers.reg_ss = SEGSEL_APP_DATA | 3;
   41df8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41dfc:	66 c7 80 d0 00 00 00 	movw   $0x23,0xd0(%rax)
   41e03:	23 00 
    p->p_registers.reg_rflags = EFLAGS_IF;
   41e05:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e09:	48 c7 80 c0 00 00 00 	movq   $0x200,0xc0(%rax)
   41e10:	00 02 00 00 

    if (flags & PROCINIT_ALLOW_PROGRAMMED_IO) {
   41e14:	8b 45 f4             	mov    -0xc(%rbp),%eax
   41e17:	83 e0 01             	and    $0x1,%eax
   41e1a:	85 c0                	test   %eax,%eax
   41e1c:	74 1c                	je     41e3a <process_init+0x96>
        p->p_registers.reg_rflags |= EFLAGS_IOPL_3;
   41e1e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e22:	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax
   41e29:	80 cc 30             	or     $0x30,%ah
   41e2c:	48 89 c2             	mov    %rax,%rdx
   41e2f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e33:	48 89 90 c0 00 00 00 	mov    %rdx,0xc0(%rax)
    }
    if (flags & PROCINIT_DISABLE_INTERRUPTS) {
   41e3a:	8b 45 f4             	mov    -0xc(%rbp),%eax
   41e3d:	83 e0 02             	and    $0x2,%eax
   41e40:	85 c0                	test   %eax,%eax
   41e42:	74 1c                	je     41e60 <process_init+0xbc>
        p->p_registers.reg_rflags &= ~EFLAGS_IF;
   41e44:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e48:	48 8b 80 c0 00 00 00 	mov    0xc0(%rax),%rax
   41e4f:	80 e4 fd             	and    $0xfd,%ah
   41e52:	48 89 c2             	mov    %rax,%rdx
   41e55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e59:	48 89 90 c0 00 00 00 	mov    %rdx,0xc0(%rax)
    }
    p->display_status = 1;
   41e60:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41e64:	c6 80 e8 00 00 00 01 	movb   $0x1,0xe8(%rax)
}
   41e6b:	90                   	nop
   41e6c:	c9                   	leave
   41e6d:	c3                   	ret

0000000000041e6e <console_show_cursor>:

// console_show_cursor(cpos)
//    Move the console cursor to position `cpos`, which should be between 0
//    and 80 * 25.

void console_show_cursor(int cpos) {
   41e6e:	55                   	push   %rbp
   41e6f:	48 89 e5             	mov    %rsp,%rbp
   41e72:	48 83 ec 28          	sub    $0x28,%rsp
   41e76:	89 7d dc             	mov    %edi,-0x24(%rbp)
    if (cpos < 0 || cpos > CONSOLE_ROWS * CONSOLE_COLUMNS) {
   41e79:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   41e7d:	78 09                	js     41e88 <console_show_cursor+0x1a>
   41e7f:	81 7d dc d0 07 00 00 	cmpl   $0x7d0,-0x24(%rbp)
   41e86:	7e 07                	jle    41e8f <console_show_cursor+0x21>
        cpos = 0;
   41e88:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
   41e8f:	c7 45 e4 d4 03 00 00 	movl   $0x3d4,-0x1c(%rbp)
   41e96:	c6 45 e3 0e          	movb   $0xe,-0x1d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41e9a:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
   41e9e:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   41ea1:	ee                   	out    %al,(%dx)
}
   41ea2:	90                   	nop
    }
    outb(0x3D4, 14);
    outb(0x3D5, cpos / 256);
   41ea3:	8b 45 dc             	mov    -0x24(%rbp),%eax
   41ea6:	8d 90 ff 00 00 00    	lea    0xff(%rax),%edx
   41eac:	85 c0                	test   %eax,%eax
   41eae:	0f 48 c2             	cmovs  %edx,%eax
   41eb1:	c1 f8 08             	sar    $0x8,%eax
   41eb4:	0f b6 c0             	movzbl %al,%eax
   41eb7:	c7 45 ec d5 03 00 00 	movl   $0x3d5,-0x14(%rbp)
   41ebe:	88 45 eb             	mov    %al,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41ec1:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   41ec5:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41ec8:	ee                   	out    %al,(%dx)
}
   41ec9:	90                   	nop
   41eca:	c7 45 f4 d4 03 00 00 	movl   $0x3d4,-0xc(%rbp)
   41ed1:	c6 45 f3 0f          	movb   $0xf,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41ed5:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   41ed9:	8b 55 f4             	mov    -0xc(%rbp),%edx
   41edc:	ee                   	out    %al,(%dx)
}
   41edd:	90                   	nop
    outb(0x3D4, 15);
    outb(0x3D5, cpos % 256);
   41ede:	8b 55 dc             	mov    -0x24(%rbp),%edx
   41ee1:	89 d0                	mov    %edx,%eax
   41ee3:	c1 f8 1f             	sar    $0x1f,%eax
   41ee6:	c1 e8 18             	shr    $0x18,%eax
   41ee9:	01 c2                	add    %eax,%edx
   41eeb:	0f b6 d2             	movzbl %dl,%edx
   41eee:	29 c2                	sub    %eax,%edx
   41ef0:	89 d0                	mov    %edx,%eax
   41ef2:	0f b6 c0             	movzbl %al,%eax
   41ef5:	c7 45 fc d5 03 00 00 	movl   $0x3d5,-0x4(%rbp)
   41efc:	88 45 fb             	mov    %al,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41eff:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41f03:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41f06:	ee                   	out    %al,(%dx)
}
   41f07:	90                   	nop
}
   41f08:	90                   	nop
   41f09:	c9                   	leave
   41f0a:	c3                   	ret

0000000000041f0b <keyboard_readc>:
    /*CKEY(16)*/ {{'\'', '"', 0, 0}},  /*CKEY(17)*/ {{'`', '~', 0, 0}},
    /*CKEY(18)*/ {{'\\', '|', 034, 0}},  /*CKEY(19)*/ {{',', '<', 0, 0}},
    /*CKEY(20)*/ {{'.', '>', 0, 0}},  /*CKEY(21)*/ {{'/', '?', 0, 0}}
};

int keyboard_readc(void) {
   41f0b:	55                   	push   %rbp
   41f0c:	48 89 e5             	mov    %rsp,%rbp
   41f0f:	48 83 ec 20          	sub    $0x20,%rsp
   41f13:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   41f1a:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41f1d:	89 c2                	mov    %eax,%edx
   41f1f:	ec                   	in     (%dx),%al
   41f20:	88 45 ef             	mov    %al,-0x11(%rbp)
    return data;
   41f23:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
    static uint8_t modifiers;
    static uint8_t last_escape;

    if ((inb(KEYBOARD_STATUSREG) & KEYBOARD_STATUS_READY) == 0) {
   41f27:	0f b6 c0             	movzbl %al,%eax
   41f2a:	83 e0 01             	and    $0x1,%eax
   41f2d:	85 c0                	test   %eax,%eax
   41f2f:	75 0a                	jne    41f3b <keyboard_readc+0x30>
        return -1;
   41f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   41f36:	e9 e7 01 00 00       	jmp    42122 <keyboard_readc+0x217>
   41f3b:	c7 45 e8 60 00 00 00 	movl   $0x60,-0x18(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   41f42:	8b 45 e8             	mov    -0x18(%rbp),%eax
   41f45:	89 c2                	mov    %eax,%edx
   41f47:	ec                   	in     (%dx),%al
   41f48:	88 45 e7             	mov    %al,-0x19(%rbp)
    return data;
   41f4b:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
    }

    uint8_t data = inb(KEYBOARD_DATAREG);
   41f4f:	88 45 fb             	mov    %al,-0x5(%rbp)
    uint8_t escape = last_escape;
   41f52:	0f b6 05 89 e4 00 00 	movzbl 0xe489(%rip),%eax        # 503e2 <last_escape.2>
   41f59:	88 45 fa             	mov    %al,-0x6(%rbp)
    last_escape = 0;
   41f5c:	c6 05 7f e4 00 00 00 	movb   $0x0,0xe47f(%rip)        # 503e2 <last_escape.2>

    if (data == 0xE0) {         // mode shift
   41f63:	80 7d fb e0          	cmpb   $0xe0,-0x5(%rbp)
   41f67:	75 11                	jne    41f7a <keyboard_readc+0x6f>
        last_escape = 0x80;
   41f69:	c6 05 72 e4 00 00 80 	movb   $0x80,0xe472(%rip)        # 503e2 <last_escape.2>
        return 0;
   41f70:	b8 00 00 00 00       	mov    $0x0,%eax
   41f75:	e9 a8 01 00 00       	jmp    42122 <keyboard_readc+0x217>
    } else if (data & 0x80) {   // key release: matters only for modifier keys
   41f7a:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41f7e:	84 c0                	test   %al,%al
   41f80:	79 60                	jns    41fe2 <keyboard_readc+0xd7>
        int ch = keymap[(data & 0x7F) | escape];
   41f82:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41f86:	83 e0 7f             	and    $0x7f,%eax
   41f89:	89 c2                	mov    %eax,%edx
   41f8b:	0f b6 45 fa          	movzbl -0x6(%rbp),%eax
   41f8f:	09 d0                	or     %edx,%eax
   41f91:	48 98                	cltq
   41f93:	0f b6 80 80 50 04 00 	movzbl 0x45080(%rax),%eax
   41f9a:	0f b6 c0             	movzbl %al,%eax
   41f9d:	89 45 f4             	mov    %eax,-0xc(%rbp)
        if (ch >= KEY_SHIFT && ch < KEY_CAPSLOCK) {
   41fa0:	81 7d f4 f9 00 00 00 	cmpl   $0xf9,-0xc(%rbp)
   41fa7:	7e 2f                	jle    41fd8 <keyboard_readc+0xcd>
   41fa9:	81 7d f4 fc 00 00 00 	cmpl   $0xfc,-0xc(%rbp)
   41fb0:	7f 26                	jg     41fd8 <keyboard_readc+0xcd>
            modifiers &= ~(1 << (ch - KEY_SHIFT));
   41fb2:	8b 45 f4             	mov    -0xc(%rbp),%eax
   41fb5:	2d fa 00 00 00       	sub    $0xfa,%eax
   41fba:	ba 01 00 00 00       	mov    $0x1,%edx
   41fbf:	89 c1                	mov    %eax,%ecx
   41fc1:	d3 e2                	shl    %cl,%edx
   41fc3:	89 d0                	mov    %edx,%eax
   41fc5:	f7 d0                	not    %eax
   41fc7:	89 c2                	mov    %eax,%edx
   41fc9:	0f b6 05 13 e4 00 00 	movzbl 0xe413(%rip),%eax        # 503e3 <modifiers.1>
   41fd0:	21 d0                	and    %edx,%eax
   41fd2:	88 05 0b e4 00 00    	mov    %al,0xe40b(%rip)        # 503e3 <modifiers.1>
        }
        return 0;
   41fd8:	b8 00 00 00 00       	mov    $0x0,%eax
   41fdd:	e9 40 01 00 00       	jmp    42122 <keyboard_readc+0x217>
    }

    int ch = (unsigned char) keymap[data | escape];
   41fe2:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41fe6:	0a 45 fa             	or     -0x6(%rbp),%al
   41fe9:	0f b6 c0             	movzbl %al,%eax
   41fec:	48 98                	cltq
   41fee:	0f b6 80 80 50 04 00 	movzbl 0x45080(%rax),%eax
   41ff5:	0f b6 c0             	movzbl %al,%eax
   41ff8:	89 45 fc             	mov    %eax,-0x4(%rbp)

    if (ch >= 'a' && ch <= 'z') {
   41ffb:	83 7d fc 60          	cmpl   $0x60,-0x4(%rbp)
   41fff:	7e 57                	jle    42058 <keyboard_readc+0x14d>
   42001:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%rbp)
   42005:	7f 51                	jg     42058 <keyboard_readc+0x14d>
        if (modifiers & MOD_CONTROL) {
   42007:	0f b6 05 d5 e3 00 00 	movzbl 0xe3d5(%rip),%eax        # 503e3 <modifiers.1>
   4200e:	0f b6 c0             	movzbl %al,%eax
   42011:	83 e0 02             	and    $0x2,%eax
   42014:	85 c0                	test   %eax,%eax
   42016:	74 09                	je     42021 <keyboard_readc+0x116>
            ch -= 0x60;
   42018:	83 6d fc 60          	subl   $0x60,-0x4(%rbp)
        if (modifiers & MOD_CONTROL) {
   4201c:	e9 fd 00 00 00       	jmp    4211e <keyboard_readc+0x213>
        } else if (!(modifiers & MOD_SHIFT) != !(modifiers & MOD_CAPSLOCK)) {
   42021:	0f b6 05 bb e3 00 00 	movzbl 0xe3bb(%rip),%eax        # 503e3 <modifiers.1>
   42028:	0f b6 c0             	movzbl %al,%eax
   4202b:	83 e0 01             	and    $0x1,%eax
   4202e:	85 c0                	test   %eax,%eax
   42030:	0f 94 c2             	sete   %dl
   42033:	0f b6 05 a9 e3 00 00 	movzbl 0xe3a9(%rip),%eax        # 503e3 <modifiers.1>
   4203a:	0f b6 c0             	movzbl %al,%eax
   4203d:	83 e0 08             	and    $0x8,%eax
   42040:	85 c0                	test   %eax,%eax
   42042:	0f 94 c0             	sete   %al
   42045:	31 d0                	xor    %edx,%eax
   42047:	84 c0                	test   %al,%al
   42049:	0f 84 cf 00 00 00    	je     4211e <keyboard_readc+0x213>
            ch -= 0x20;
   4204f:	83 6d fc 20          	subl   $0x20,-0x4(%rbp)
        if (modifiers & MOD_CONTROL) {
   42053:	e9 c6 00 00 00       	jmp    4211e <keyboard_readc+0x213>
        }
    } else if (ch >= KEY_CAPSLOCK) {
   42058:	81 7d fc fc 00 00 00 	cmpl   $0xfc,-0x4(%rbp)
   4205f:	7e 30                	jle    42091 <keyboard_readc+0x186>
        modifiers ^= 1 << (ch - KEY_SHIFT);
   42061:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42064:	2d fa 00 00 00       	sub    $0xfa,%eax
   42069:	ba 01 00 00 00       	mov    $0x1,%edx
   4206e:	89 c1                	mov    %eax,%ecx
   42070:	d3 e2                	shl    %cl,%edx
   42072:	89 d0                	mov    %edx,%eax
   42074:	89 c2                	mov    %eax,%edx
   42076:	0f b6 05 66 e3 00 00 	movzbl 0xe366(%rip),%eax        # 503e3 <modifiers.1>
   4207d:	31 d0                	xor    %edx,%eax
   4207f:	88 05 5e e3 00 00    	mov    %al,0xe35e(%rip)        # 503e3 <modifiers.1>
        ch = 0;
   42085:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4208c:	e9 8e 00 00 00       	jmp    4211f <keyboard_readc+0x214>
    } else if (ch >= KEY_SHIFT) {
   42091:	81 7d fc f9 00 00 00 	cmpl   $0xf9,-0x4(%rbp)
   42098:	7e 2d                	jle    420c7 <keyboard_readc+0x1bc>
        modifiers |= 1 << (ch - KEY_SHIFT);
   4209a:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4209d:	2d fa 00 00 00       	sub    $0xfa,%eax
   420a2:	ba 01 00 00 00       	mov    $0x1,%edx
   420a7:	89 c1                	mov    %eax,%ecx
   420a9:	d3 e2                	shl    %cl,%edx
   420ab:	89 d0                	mov    %edx,%eax
   420ad:	89 c2                	mov    %eax,%edx
   420af:	0f b6 05 2d e3 00 00 	movzbl 0xe32d(%rip),%eax        # 503e3 <modifiers.1>
   420b6:	09 d0                	or     %edx,%eax
   420b8:	88 05 25 e3 00 00    	mov    %al,0xe325(%rip)        # 503e3 <modifiers.1>
        ch = 0;
   420be:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   420c5:	eb 58                	jmp    4211f <keyboard_readc+0x214>
    } else if (ch >= CKEY(0) && ch <= CKEY(21)) {
   420c7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
   420cb:	7e 31                	jle    420fe <keyboard_readc+0x1f3>
   420cd:	81 7d fc 95 00 00 00 	cmpl   $0x95,-0x4(%rbp)
   420d4:	7f 28                	jg     420fe <keyboard_readc+0x1f3>
        ch = complex_keymap[ch - CKEY(0)].map[modifiers & 3];
   420d6:	8b 45 fc             	mov    -0x4(%rbp),%eax
   420d9:	8d 50 80             	lea    -0x80(%rax),%edx
   420dc:	0f b6 05 00 e3 00 00 	movzbl 0xe300(%rip),%eax        # 503e3 <modifiers.1>
   420e3:	0f b6 c0             	movzbl %al,%eax
   420e6:	83 e0 03             	and    $0x3,%eax
   420e9:	48 98                	cltq
   420eb:	48 63 d2             	movslq %edx,%rdx
   420ee:	0f b6 84 90 80 51 04 	movzbl 0x45180(%rax,%rdx,4),%eax
   420f5:	00 
   420f6:	0f b6 c0             	movzbl %al,%eax
   420f9:	89 45 fc             	mov    %eax,-0x4(%rbp)
   420fc:	eb 21                	jmp    4211f <keyboard_readc+0x214>
    } else if (ch < 0x80 && (modifiers & MOD_CONTROL)) {
   420fe:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
   42102:	7f 1b                	jg     4211f <keyboard_readc+0x214>
   42104:	0f b6 05 d8 e2 00 00 	movzbl 0xe2d8(%rip),%eax        # 503e3 <modifiers.1>
   4210b:	0f b6 c0             	movzbl %al,%eax
   4210e:	83 e0 02             	and    $0x2,%eax
   42111:	85 c0                	test   %eax,%eax
   42113:	74 0a                	je     4211f <keyboard_readc+0x214>
        ch = 0;
   42115:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4211c:	eb 01                	jmp    4211f <keyboard_readc+0x214>
        if (modifiers & MOD_CONTROL) {
   4211e:	90                   	nop
    }

    return ch;
   4211f:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
   42122:	c9                   	leave
   42123:	c3                   	ret

0000000000042124 <delay>:
#define IO_PARALLEL1_CONTROL    0x37A
# define IO_PARALLEL_CONTROL_SELECT     0x08
# define IO_PARALLEL_CONTROL_INIT       0x04
# define IO_PARALLEL_CONTROL_STROBE     0x01

static void delay(void) {
   42124:	55                   	push   %rbp
   42125:	48 89 e5             	mov    %rsp,%rbp
   42128:	48 83 ec 20          	sub    $0x20,%rsp
   4212c:	c7 45 e4 84 00 00 00 	movl   $0x84,-0x1c(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   42133:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   42136:	89 c2                	mov    %eax,%edx
   42138:	ec                   	in     (%dx),%al
   42139:	88 45 e3             	mov    %al,-0x1d(%rbp)
   4213c:	c7 45 ec 84 00 00 00 	movl   $0x84,-0x14(%rbp)
   42143:	8b 45 ec             	mov    -0x14(%rbp),%eax
   42146:	89 c2                	mov    %eax,%edx
   42148:	ec                   	in     (%dx),%al
   42149:	88 45 eb             	mov    %al,-0x15(%rbp)
   4214c:	c7 45 f4 84 00 00 00 	movl   $0x84,-0xc(%rbp)
   42153:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42156:	89 c2                	mov    %eax,%edx
   42158:	ec                   	in     (%dx),%al
   42159:	88 45 f3             	mov    %al,-0xd(%rbp)
   4215c:	c7 45 fc 84 00 00 00 	movl   $0x84,-0x4(%rbp)
   42163:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42166:	89 c2                	mov    %eax,%edx
   42168:	ec                   	in     (%dx),%al
   42169:	88 45 fb             	mov    %al,-0x5(%rbp)
    (void) inb(0x84);
    (void) inb(0x84);
    (void) inb(0x84);
    (void) inb(0x84);
}
   4216c:	90                   	nop
   4216d:	c9                   	leave
   4216e:	c3                   	ret

000000000004216f <parallel_port_putc>:

static void parallel_port_putc(printer* p, unsigned char c, int color) {
   4216f:	55                   	push   %rbp
   42170:	48 89 e5             	mov    %rsp,%rbp
   42173:	48 83 ec 40          	sub    $0x40,%rsp
   42177:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   4217b:	89 f0                	mov    %esi,%eax
   4217d:	89 55 c0             	mov    %edx,-0x40(%rbp)
   42180:	88 45 c4             	mov    %al,-0x3c(%rbp)
    static int initialized;
    (void) p, (void) color;
    if (!initialized) {
   42183:	8b 05 5b e2 00 00    	mov    0xe25b(%rip),%eax        # 503e4 <initialized.0>
   42189:	85 c0                	test   %eax,%eax
   4218b:	75 1e                	jne    421ab <parallel_port_putc+0x3c>
   4218d:	c7 45 f8 7a 03 00 00 	movl   $0x37a,-0x8(%rbp)
   42194:	c6 45 f7 00          	movb   $0x0,-0x9(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42198:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
   4219c:	8b 55 f8             	mov    -0x8(%rbp),%edx
   4219f:	ee                   	out    %al,(%dx)
}
   421a0:	90                   	nop
        outb(IO_PARALLEL1_CONTROL, 0);
        initialized = 1;
   421a1:	c7 05 39 e2 00 00 01 	movl   $0x1,0xe239(%rip)        # 503e4 <initialized.0>
   421a8:	00 00 00 
    }

    for (int i = 0;
   421ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   421b2:	eb 09                	jmp    421bd <parallel_port_putc+0x4e>
         i < 12800 && (inb(IO_PARALLEL1_STATUS) & IO_PARALLEL_STATUS_BUSY) == 0;
         ++i) {
        delay();
   421b4:	e8 6b ff ff ff       	call   42124 <delay>
         ++i) {
   421b9:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
         i < 12800 && (inb(IO_PARALLEL1_STATUS) & IO_PARALLEL_STATUS_BUSY) == 0;
   421bd:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%rbp)
   421c4:	7f 18                	jg     421de <parallel_port_putc+0x6f>
   421c6:	c7 45 f0 79 03 00 00 	movl   $0x379,-0x10(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   421cd:	8b 45 f0             	mov    -0x10(%rbp),%eax
   421d0:	89 c2                	mov    %eax,%edx
   421d2:	ec                   	in     (%dx),%al
   421d3:	88 45 ef             	mov    %al,-0x11(%rbp)
    return data;
   421d6:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   421da:	84 c0                	test   %al,%al
   421dc:	79 d6                	jns    421b4 <parallel_port_putc+0x45>
    }
    outb(IO_PARALLEL1_DATA, c);
   421de:	0f b6 45 c4          	movzbl -0x3c(%rbp),%eax
   421e2:	c7 45 d8 78 03 00 00 	movl   $0x378,-0x28(%rbp)
   421e9:	88 45 d7             	mov    %al,-0x29(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   421ec:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
   421f0:	8b 55 d8             	mov    -0x28(%rbp),%edx
   421f3:	ee                   	out    %al,(%dx)
}
   421f4:	90                   	nop
   421f5:	c7 45 e0 7a 03 00 00 	movl   $0x37a,-0x20(%rbp)
   421fc:	c6 45 df 0d          	movb   $0xd,-0x21(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42200:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
   42204:	8b 55 e0             	mov    -0x20(%rbp),%edx
   42207:	ee                   	out    %al,(%dx)
}
   42208:	90                   	nop
   42209:	c7 45 e8 7a 03 00 00 	movl   $0x37a,-0x18(%rbp)
   42210:	c6 45 e7 0c          	movb   $0xc,-0x19(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42214:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
   42218:	8b 55 e8             	mov    -0x18(%rbp),%edx
   4221b:	ee                   	out    %al,(%dx)
}
   4221c:	90                   	nop
    outb(IO_PARALLEL1_CONTROL, IO_PARALLEL_CONTROL_SELECT
         | IO_PARALLEL_CONTROL_INIT | IO_PARALLEL_CONTROL_STROBE);
    outb(IO_PARALLEL1_CONTROL, IO_PARALLEL_CONTROL_SELECT
         | IO_PARALLEL_CONTROL_INIT);
}
   4221d:	90                   	nop
   4221e:	c9                   	leave
   4221f:	c3                   	ret

0000000000042220 <log_vprintf>:

void log_vprintf(const char* format, va_list val) {
   42220:	55                   	push   %rbp
   42221:	48 89 e5             	mov    %rsp,%rbp
   42224:	48 83 ec 20          	sub    $0x20,%rsp
   42228:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   4222c:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    printer p;
    p.putc = parallel_port_putc;
   42230:	48 c7 45 f8 6f 21 04 	movq   $0x4216f,-0x8(%rbp)
   42237:	00 
    printer_vprintf(&p, 0, format, val);
   42238:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
   4223c:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   42240:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
   42244:	be 00 00 00 00       	mov    $0x0,%esi
   42249:	48 89 c7             	mov    %rax,%rdi
   4224c:	e8 e9 1c 00 00       	call   43f3a <printer_vprintf>
}
   42251:	90                   	nop
   42252:	c9                   	leave
   42253:	c3                   	ret

0000000000042254 <log_printf>:

void log_printf(const char* format, ...) {
   42254:	55                   	push   %rbp
   42255:	48 89 e5             	mov    %rsp,%rbp
   42258:	48 83 ec 60          	sub    $0x60,%rsp
   4225c:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   42260:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
   42264:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   42268:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   4226c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   42270:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   42274:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
   4227b:	48 8d 45 10          	lea    0x10(%rbp),%rax
   4227f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   42283:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   42287:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    log_vprintf(format, val);
   4228b:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
   4228f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   42293:	48 89 d6             	mov    %rdx,%rsi
   42296:	48 89 c7             	mov    %rax,%rdi
   42299:	e8 82 ff ff ff       	call   42220 <log_vprintf>
    va_end(val);
}
   4229e:	90                   	nop
   4229f:	c9                   	leave
   422a0:	c3                   	ret

00000000000422a1 <error_vprintf>:

// error_printf, error_vprintf
//    Print debugging messages to the console and to the host's
//    `log.txt` file via `log_printf`.

int error_vprintf(int cpos, int color, const char* format, va_list val) {
   422a1:	55                   	push   %rbp
   422a2:	48 89 e5             	mov    %rsp,%rbp
   422a5:	48 83 ec 40          	sub    $0x40,%rsp
   422a9:	89 7d dc             	mov    %edi,-0x24(%rbp)
   422ac:	89 75 d8             	mov    %esi,-0x28(%rbp)
   422af:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
   422b3:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
    va_list val2;
    __builtin_va_copy(val2, val);
   422b7:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
   422bb:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   422bf:	48 8b 0a             	mov    (%rdx),%rcx
   422c2:	48 89 08             	mov    %rcx,(%rax)
   422c5:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
   422c9:	48 89 48 08          	mov    %rcx,0x8(%rax)
   422cd:	48 8b 52 10          	mov    0x10(%rdx),%rdx
   422d1:	48 89 50 10          	mov    %rdx,0x10(%rax)
    log_vprintf(format, val2);
   422d5:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
   422d9:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   422dd:	48 89 d6             	mov    %rdx,%rsi
   422e0:	48 89 c7             	mov    %rax,%rdi
   422e3:	e8 38 ff ff ff       	call   42220 <log_vprintf>
    va_end(val2);
    return console_vprintf(cpos, color, format, val);
   422e8:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   422ec:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   422f0:	8b 75 d8             	mov    -0x28(%rbp),%esi
   422f3:	8b 45 dc             	mov    -0x24(%rbp),%eax
   422f6:	89 c7                	mov    %eax,%edi
   422f8:	e8 ec 26 00 00       	call   449e9 <console_vprintf>
}
   422fd:	c9                   	leave
   422fe:	c3                   	ret

00000000000422ff <error_printf>:

int error_printf(int cpos, int color, const char* format, ...) {
   422ff:	55                   	push   %rbp
   42300:	48 89 e5             	mov    %rsp,%rbp
   42303:	48 83 ec 60          	sub    $0x60,%rsp
   42307:	89 7d ac             	mov    %edi,-0x54(%rbp)
   4230a:	89 75 a8             	mov    %esi,-0x58(%rbp)
   4230d:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
   42311:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   42315:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   42319:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   4231d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   42324:	48 8d 45 10          	lea    0x10(%rbp),%rax
   42328:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   4232c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   42330:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = error_vprintf(cpos, color, format, val);
   42334:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   42338:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
   4233c:	8b 75 a8             	mov    -0x58(%rbp),%esi
   4233f:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42342:	89 c7                	mov    %eax,%edi
   42344:	e8 58 ff ff ff       	call   422a1 <error_vprintf>
   42349:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
   4234c:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
   4234f:	c9                   	leave
   42350:	c3                   	ret

0000000000042351 <check_keyboard>:
//    Check for the user typing a control key. 'a', 'm', and 'c' cause a soft
//    reboot where the kernel runs the allocator programs, "malloc", or
//    "alloctests", respectively. Control-C or 'q' exit the virtual machine.
//    Returns key typed or -1 for no key.

int check_keyboard(void) {
   42351:	55                   	push   %rbp
   42352:	48 89 e5             	mov    %rsp,%rbp
   42355:	53                   	push   %rbx
   42356:	48 83 ec 48          	sub    $0x48,%rsp
    int c = keyboard_readc();
   4235a:	e8 ac fb ff ff       	call   41f0b <keyboard_readc>
   4235f:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    if (c == 'a' || c == 'm' || c == 'c' || c == 't'|| c =='2') {
   42362:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
   42366:	74 1c                	je     42384 <check_keyboard+0x33>
   42368:	83 7d e4 6d          	cmpl   $0x6d,-0x1c(%rbp)
   4236c:	74 16                	je     42384 <check_keyboard+0x33>
   4236e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%rbp)
   42372:	74 10                	je     42384 <check_keyboard+0x33>
   42374:	83 7d e4 74          	cmpl   $0x74,-0x1c(%rbp)
   42378:	74 0a                	je     42384 <check_keyboard+0x33>
   4237a:	83 7d e4 32          	cmpl   $0x32,-0x1c(%rbp)
   4237e:	0f 85 e9 00 00 00    	jne    4246d <check_keyboard+0x11c>
        // Install a temporary page table to carry us through the
        // process of reinitializing memory. This replicates work the
        // bootloader does.
        x86_64_pagetable* pt = (x86_64_pagetable*) 0x8000;
   42384:	48 c7 45 d8 00 80 00 	movq   $0x8000,-0x28(%rbp)
   4238b:	00 
        memset(pt, 0, PAGESIZE * 3);
   4238c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42390:	ba 00 30 00 00       	mov    $0x3000,%edx
   42395:	be 00 00 00 00       	mov    $0x0,%esi
   4239a:	48 89 c7             	mov    %rax,%rdi
   4239d:	e8 fc 18 00 00       	call   43c9e <memset>
        pt[0].entry[0] = 0x9000 | PTE_P | PTE_W | PTE_U;
   423a2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   423a6:	48 c7 00 07 90 00 00 	movq   $0x9007,(%rax)
        pt[1].entry[0] = 0xA000 | PTE_P | PTE_W | PTE_U;
   423ad:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   423b1:	48 05 00 10 00 00    	add    $0x1000,%rax
   423b7:	48 c7 00 07 a0 00 00 	movq   $0xa007,(%rax)
        pt[2].entry[0] = PTE_P | PTE_W | PTE_U | PTE_PS;
   423be:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   423c2:	48 05 00 20 00 00    	add    $0x2000,%rax
   423c8:	48 c7 00 87 00 00 00 	movq   $0x87,(%rax)
        lcr3((uintptr_t) pt);
   423cf:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   423d3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
}

static inline void lcr3(uintptr_t val) {
    asm volatile("" : : : "memory");
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   423d7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   423db:	0f 22 d8             	mov    %rax,%cr3
}
   423de:	90                   	nop
        // The soft reboot process doesn't modify memory, so it's
        // safe to pass `multiboot_info` on the kernel stack, even
        // though it will get overwritten as the kernel runs.
        uint32_t multiboot_info[5];
        multiboot_info[0] = 4;
   423df:	c7 45 b4 04 00 00 00 	movl   $0x4,-0x4c(%rbp)
        const char* argument = "malloc";
   423e6:	48 c7 45 e8 d8 51 04 	movq   $0x451d8,-0x18(%rbp)
   423ed:	00 
        if (c == 'a') {
   423ee:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
   423f2:	75 0a                	jne    423fe <check_keyboard+0xad>
            argument = "allocator";
   423f4:	48 c7 45 e8 df 51 04 	movq   $0x451df,-0x18(%rbp)
   423fb:	00 
   423fc:	eb 2e                	jmp    4242c <check_keyboard+0xdb>
        } else if (c == 'c') {
   423fe:	83 7d e4 63          	cmpl   $0x63,-0x1c(%rbp)
   42402:	75 0a                	jne    4240e <check_keyboard+0xbd>
            argument = "alloctests";
   42404:	48 c7 45 e8 e9 51 04 	movq   $0x451e9,-0x18(%rbp)
   4240b:	00 
   4240c:	eb 1e                	jmp    4242c <check_keyboard+0xdb>
        } else if(c == 't'){
   4240e:	83 7d e4 74          	cmpl   $0x74,-0x1c(%rbp)
   42412:	75 0a                	jne    4241e <check_keyboard+0xcd>
            argument = "test";
   42414:	48 c7 45 e8 f4 51 04 	movq   $0x451f4,-0x18(%rbp)
   4241b:	00 
   4241c:	eb 0e                	jmp    4242c <check_keyboard+0xdb>
        }
        else if(c == '2'){
   4241e:	83 7d e4 32          	cmpl   $0x32,-0x1c(%rbp)
   42422:	75 08                	jne    4242c <check_keyboard+0xdb>
            argument = "test2";
   42424:	48 c7 45 e8 f9 51 04 	movq   $0x451f9,-0x18(%rbp)
   4242b:	00 
        }
        uintptr_t argument_ptr = (uintptr_t) argument;
   4242c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42430:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        assert(argument_ptr < 0x100000000L);
   42434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42439:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
   4243d:	73 14                	jae    42453 <check_keyboard+0x102>
   4243f:	ba ff 51 04 00       	mov    $0x451ff,%edx
   42444:	be 5c 02 00 00       	mov    $0x25c,%esi
   42449:	bf 1b 52 04 00       	mov    $0x4521b,%edi
   4244e:	e8 1f 01 00 00       	call   42572 <assert_fail>
        multiboot_info[4] = (uint32_t) argument_ptr;
   42453:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42457:	89 45 c4             	mov    %eax,-0x3c(%rbp)
        asm volatile("movl $0x2BADB002, %%eax; jmp entry_from_boot"
   4245a:	48 8d 45 b4          	lea    -0x4c(%rbp),%rax
   4245e:	48 89 c3             	mov    %rax,%rbx
   42461:	b8 02 b0 ad 2b       	mov    $0x2badb002,%eax
   42466:	e9 95 db ff ff       	jmp    40000 <entry_from_boot>
    if (c == 'a' || c == 'm' || c == 'c' || c == 't'|| c =='2') {
   4246b:	eb 11                	jmp    4247e <check_keyboard+0x12d>
                     : : "b" (multiboot_info) : "memory");
    } else if (c == 0x03 || c == 'q') {
   4246d:	83 7d e4 03          	cmpl   $0x3,-0x1c(%rbp)
   42471:	74 06                	je     42479 <check_keyboard+0x128>
   42473:	83 7d e4 71          	cmpl   $0x71,-0x1c(%rbp)
   42477:	75 05                	jne    4247e <check_keyboard+0x12d>
        poweroff();
   42479:	e8 9d f8 ff ff       	call   41d1b <poweroff>
    }
    return c;
   4247e:	8b 45 e4             	mov    -0x1c(%rbp),%eax
}
   42481:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   42485:	c9                   	leave
   42486:	c3                   	ret

0000000000042487 <fail>:

// fail
//    Loop until user presses Control-C, then poweroff.

static void fail(void) __attribute__((noreturn));
static void fail(void) {
   42487:	55                   	push   %rbp
   42488:	48 89 e5             	mov    %rsp,%rbp
    while (1) {
        check_keyboard();
   4248b:	e8 c1 fe ff ff       	call   42351 <check_keyboard>
   42490:	eb f9                	jmp    4248b <fail+0x4>

0000000000042492 <kernel_panic>:

// kernel_panic, assert_fail
//    Use console_printf() to print a failure message and then wait for
//    control-C. Also write the failure message to the log.

void kernel_panic(const char* format, ...) {
   42492:	55                   	push   %rbp
   42493:	48 89 e5             	mov    %rsp,%rbp
   42496:	48 83 ec 60          	sub    $0x60,%rsp
   4249a:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   4249e:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
   424a2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   424a6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   424aa:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   424ae:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   424b2:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%rbp)
   424b9:	48 8d 45 10          	lea    0x10(%rbp),%rax
   424bd:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
   424c1:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   424c5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)

    if (format) {
   424c9:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
   424ce:	0f 84 80 00 00 00    	je     42554 <kernel_panic+0xc2>
        // Print kernel_panic message to both the screen and the log
        int cpos = error_printf(CPOS(23, 0), 0xC000, "PANIC: ");
   424d4:	ba 2f 52 04 00       	mov    $0x4522f,%edx
   424d9:	be 00 c0 00 00       	mov    $0xc000,%esi
   424de:	bf 30 07 00 00       	mov    $0x730,%edi
   424e3:	b8 00 00 00 00       	mov    $0x0,%eax
   424e8:	e8 12 fe ff ff       	call   422ff <error_printf>
   424ed:	89 45 cc             	mov    %eax,-0x34(%rbp)
        cpos = error_vprintf(cpos, 0xC000, format, val);
   424f0:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
   424f4:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
   424f8:	8b 45 cc             	mov    -0x34(%rbp),%eax
   424fb:	be 00 c0 00 00       	mov    $0xc000,%esi
   42500:	89 c7                	mov    %eax,%edi
   42502:	e8 9a fd ff ff       	call   422a1 <error_vprintf>
   42507:	89 45 cc             	mov    %eax,-0x34(%rbp)
        if (CCOL(cpos)) {
   4250a:	8b 4d cc             	mov    -0x34(%rbp),%ecx
   4250d:	48 63 c1             	movslq %ecx,%rax
   42510:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
   42517:	48 c1 e8 20          	shr    $0x20,%rax
   4251b:	89 c2                	mov    %eax,%edx
   4251d:	c1 fa 05             	sar    $0x5,%edx
   42520:	89 c8                	mov    %ecx,%eax
   42522:	c1 f8 1f             	sar    $0x1f,%eax
   42525:	29 c2                	sub    %eax,%edx
   42527:	89 d0                	mov    %edx,%eax
   42529:	c1 e0 02             	shl    $0x2,%eax
   4252c:	01 d0                	add    %edx,%eax
   4252e:	c1 e0 04             	shl    $0x4,%eax
   42531:	29 c1                	sub    %eax,%ecx
   42533:	89 ca                	mov    %ecx,%edx
   42535:	85 d2                	test   %edx,%edx
   42537:	74 34                	je     4256d <kernel_panic+0xdb>
            error_printf(cpos, 0xC000, "\n");
   42539:	8b 45 cc             	mov    -0x34(%rbp),%eax
   4253c:	ba 37 52 04 00       	mov    $0x45237,%edx
   42541:	be 00 c0 00 00       	mov    $0xc000,%esi
   42546:	89 c7                	mov    %eax,%edi
   42548:	b8 00 00 00 00       	mov    $0x0,%eax
   4254d:	e8 ad fd ff ff       	call   422ff <error_printf>
   42552:	eb 19                	jmp    4256d <kernel_panic+0xdb>
        }
    } else {
        error_printf(CPOS(23, 0), 0xC000, "PANIC");
   42554:	ba 39 52 04 00       	mov    $0x45239,%edx
   42559:	be 00 c0 00 00       	mov    $0xc000,%esi
   4255e:	bf 30 07 00 00       	mov    $0x730,%edi
   42563:	b8 00 00 00 00       	mov    $0x0,%eax
   42568:	e8 92 fd ff ff       	call   422ff <error_printf>
    }

    va_end(val);
    fail();
   4256d:	e8 15 ff ff ff       	call   42487 <fail>

0000000000042572 <assert_fail>:
}

void assert_fail(const char* file, int line, const char* msg) {
   42572:	55                   	push   %rbp
   42573:	48 89 e5             	mov    %rsp,%rbp
   42576:	48 83 ec 20          	sub    $0x20,%rsp
   4257a:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   4257e:	89 75 f4             	mov    %esi,-0xc(%rbp)
   42581:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    kernel_panic("%s:%d: assertion '%s' failed\n", file, line, msg);
   42585:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
   42589:	8b 55 f4             	mov    -0xc(%rbp),%edx
   4258c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42590:	48 89 c6             	mov    %rax,%rsi
   42593:	bf 3f 52 04 00       	mov    $0x4523f,%edi
   42598:	b8 00 00 00 00       	mov    $0x0,%eax
   4259d:	e8 f0 fe ff ff       	call   42492 <kernel_panic>

00000000000425a2 <default_exception>:
}

void default_exception(proc* p){
   425a2:	55                   	push   %rbp
   425a3:	48 89 e5             	mov    %rsp,%rbp
   425a6:	48 83 ec 20          	sub    $0x20,%rsp
   425aa:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    x86_64_registers * reg = &(p->p_registers);
   425ae:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   425b2:	48 83 c0 18          	add    $0x18,%rax
   425b6:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    kernel_panic("Unexpected exception %d!\n", reg->reg_intno);
   425ba:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   425be:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   425c5:	48 89 c6             	mov    %rax,%rsi
   425c8:	bf 5d 52 04 00       	mov    $0x4525d,%edi
   425cd:	b8 00 00 00 00       	mov    $0x0,%eax
   425d2:	e8 bb fe ff ff       	call   42492 <kernel_panic>

00000000000425d7 <pageindex>:
static inline int pageindex(uintptr_t addr, int level) {
   425d7:	55                   	push   %rbp
   425d8:	48 89 e5             	mov    %rsp,%rbp
   425db:	48 83 ec 10          	sub    $0x10,%rsp
   425df:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   425e3:	89 75 f4             	mov    %esi,-0xc(%rbp)
    assert(level >= 0 && level <= 3);
   425e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   425ea:	78 06                	js     425f2 <pageindex+0x1b>
   425ec:	83 7d f4 03          	cmpl   $0x3,-0xc(%rbp)
   425f0:	7e 14                	jle    42606 <pageindex+0x2f>
   425f2:	ba 78 52 04 00       	mov    $0x45278,%edx
   425f7:	be 1e 00 00 00       	mov    $0x1e,%esi
   425fc:	bf 91 52 04 00       	mov    $0x45291,%edi
   42601:	e8 6c ff ff ff       	call   42572 <assert_fail>
    return (int) (addr >> (PAGEOFFBITS + (3 - level) * PAGEINDEXBITS)) & 0x1FF;
   42606:	b8 03 00 00 00       	mov    $0x3,%eax
   4260b:	2b 45 f4             	sub    -0xc(%rbp),%eax
   4260e:	89 c2                	mov    %eax,%edx
   42610:	89 d0                	mov    %edx,%eax
   42612:	c1 e0 03             	shl    $0x3,%eax
   42615:	01 d0                	add    %edx,%eax
   42617:	83 c0 0c             	add    $0xc,%eax
   4261a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   4261e:	89 c1                	mov    %eax,%ecx
   42620:	48 d3 ea             	shr    %cl,%rdx
   42623:	48 89 d0             	mov    %rdx,%rax
   42626:	25 ff 01 00 00       	and    $0x1ff,%eax
}
   4262b:	c9                   	leave
   4262c:	c3                   	ret

000000000004262d <virtual_memory_init>:

static x86_64_pagetable kernel_pagetables[5];
x86_64_pagetable* kernel_pagetable;


void virtual_memory_init(void) {
   4262d:	55                   	push   %rbp
   4262e:	48 89 e5             	mov    %rsp,%rbp
   42631:	48 83 ec 20          	sub    $0x20,%rsp
    kernel_pagetable = &kernel_pagetables[0];
   42635:	48 c7 05 c0 e9 00 00 	movq   $0x52000,0xe9c0(%rip)        # 51000 <kernel_pagetable>
   4263c:	00 20 05 00 
    memset(kernel_pagetables, 0, sizeof(kernel_pagetables));
   42640:	ba 00 50 00 00       	mov    $0x5000,%edx
   42645:	be 00 00 00 00       	mov    $0x0,%esi
   4264a:	bf 00 20 05 00       	mov    $0x52000,%edi
   4264f:	e8 4a 16 00 00       	call   43c9e <memset>

    // connect the pagetable pages
    kernel_pagetables[0].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[1] | PTE_P | PTE_W | PTE_U;
   42654:	b8 00 30 05 00       	mov    $0x53000,%eax
   42659:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[0].entry[0] =
   4265d:	48 89 05 9c f9 00 00 	mov    %rax,0xf99c(%rip)        # 52000 <kernel_pagetables>
    kernel_pagetables[1].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[2] | PTE_P | PTE_W | PTE_U;
   42664:	b8 00 40 05 00       	mov    $0x54000,%eax
   42669:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[1].entry[0] =
   4266d:	48 89 05 8c 09 01 00 	mov    %rax,0x1098c(%rip)        # 53000 <kernel_pagetables+0x1000>
    kernel_pagetables[2].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[3] | PTE_P | PTE_W | PTE_U;
   42674:	b8 00 50 05 00       	mov    $0x55000,%eax
   42679:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[2].entry[0] =
   4267d:	48 89 05 7c 19 01 00 	mov    %rax,0x1197c(%rip)        # 54000 <kernel_pagetables+0x2000>
    kernel_pagetables[2].entry[1] =
        (x86_64_pageentry_t) &kernel_pagetables[4] | PTE_P | PTE_W | PTE_U;
   42684:	b8 00 60 05 00       	mov    $0x56000,%eax
   42689:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[2].entry[1] =
   4268d:	48 89 05 74 19 01 00 	mov    %rax,0x11974(%rip)        # 54008 <kernel_pagetables+0x2008>

    // identity map the page table
    virtual_memory_map(kernel_pagetable, (uintptr_t) 0, (uintptr_t) 0,
   42694:	48 8b 05 65 e9 00 00 	mov    0xe965(%rip),%rax        # 51000 <kernel_pagetable>
   4269b:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   426a1:	b9 00 00 20 00       	mov    $0x200000,%ecx
   426a6:	ba 00 00 00 00       	mov    $0x0,%edx
   426ab:	be 00 00 00 00       	mov    $0x0,%esi
   426b0:	48 89 c7             	mov    %rax,%rdi
   426b3:	e8 b9 01 00 00       	call   42871 <virtual_memory_map>
                       MEMSIZE_PHYSICAL, PTE_P | PTE_W | PTE_U);

    // check if kernel is identity mapped
    for(uintptr_t addr = 0 ; addr < MEMSIZE_PHYSICAL ; addr += PAGESIZE){
   426b8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   426bf:	00 
   426c0:	eb 62                	jmp    42724 <virtual_memory_init+0xf7>
        vamapping vmap = virtual_memory_lookup(kernel_pagetable, addr);
   426c2:	48 8b 0d 37 e9 00 00 	mov    0xe937(%rip),%rcx        # 51000 <kernel_pagetable>
   426c9:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
   426cd:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   426d1:	48 89 ce             	mov    %rcx,%rsi
   426d4:	48 89 c7             	mov    %rax,%rdi
   426d7:	e8 58 05 00 00       	call   42c34 <virtual_memory_lookup>
        // this assert will probably fail initially!
        // have you implemented virtual_memory_map and lookup_l4pagetable ?
        assert(vmap.pa == addr);
   426dc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   426e0:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   426e4:	74 14                	je     426fa <virtual_memory_init+0xcd>
   426e6:	ba a5 52 04 00       	mov    $0x452a5,%edx
   426eb:	be 2d 00 00 00       	mov    $0x2d,%esi
   426f0:	bf b5 52 04 00       	mov    $0x452b5,%edi
   426f5:	e8 78 fe ff ff       	call   42572 <assert_fail>
        assert((vmap.perm & (PTE_P|PTE_W)) == (PTE_P|PTE_W));
   426fa:	8b 45 f0             	mov    -0x10(%rbp),%eax
   426fd:	48 98                	cltq
   426ff:	83 e0 03             	and    $0x3,%eax
   42702:	48 83 f8 03          	cmp    $0x3,%rax
   42706:	74 14                	je     4271c <virtual_memory_init+0xef>
   42708:	ba c8 52 04 00       	mov    $0x452c8,%edx
   4270d:	be 2e 00 00 00       	mov    $0x2e,%esi
   42712:	bf b5 52 04 00       	mov    $0x452b5,%edi
   42717:	e8 56 fe ff ff       	call   42572 <assert_fail>
    for(uintptr_t addr = 0 ; addr < MEMSIZE_PHYSICAL ; addr += PAGESIZE){
   4271c:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   42723:	00 
   42724:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   4272b:	00 
   4272c:	76 94                	jbe    426c2 <virtual_memory_init+0x95>
    }

    // set pointer to this pagetable in the CR3 register
    // set_pagetable also does several checks for a valid pagetable
    set_pagetable(kernel_pagetable);
   4272e:	48 8b 05 cb e8 00 00 	mov    0xe8cb(%rip),%rax        # 51000 <kernel_pagetable>
   42735:	48 89 c7             	mov    %rax,%rdi
   42738:	e8 03 00 00 00       	call   42740 <set_pagetable>
}
   4273d:	90                   	nop
   4273e:	c9                   	leave
   4273f:	c3                   	ret

0000000000042740 <set_pagetable>:
// set_pagetable
//    Change page directory. lcr3() is the hardware instruction;
//    set_pagetable() additionally checks that important kernel procedures are
//    mappable in `pagetable`, and calls kernel_panic() if they aren't.

void set_pagetable(x86_64_pagetable* pagetable) {
   42740:	55                   	push   %rbp
   42741:	48 89 e5             	mov    %rsp,%rbp
   42744:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
   42748:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
    assert(PAGEOFFSET(pagetable) == 0); // must be page aligned
   4274c:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   42750:	25 ff 0f 00 00       	and    $0xfff,%eax
   42755:	48 85 c0             	test   %rax,%rax
   42758:	74 14                	je     4276e <set_pagetable+0x2e>
   4275a:	ba f5 52 04 00       	mov    $0x452f5,%edx
   4275f:	be 3d 00 00 00       	mov    $0x3d,%esi
   42764:	bf b5 52 04 00       	mov    $0x452b5,%edi
   42769:	e8 04 fe ff ff       	call   42572 <assert_fail>
    // check for kernel space being mapped in pagetable
    assert(virtual_memory_lookup(pagetable, (uintptr_t) default_int_handler).pa
   4276e:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   42773:	48 8d 45 98          	lea    -0x68(%rbp),%rax
   42777:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   4277b:	48 89 ce             	mov    %rcx,%rsi
   4277e:	48 89 c7             	mov    %rax,%rdi
   42781:	e8 ae 04 00 00       	call   42c34 <virtual_memory_lookup>
   42786:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   4278a:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   4278f:	48 39 d0             	cmp    %rdx,%rax
   42792:	74 14                	je     427a8 <set_pagetable+0x68>
   42794:	ba 10 53 04 00       	mov    $0x45310,%edx
   42799:	be 3f 00 00 00       	mov    $0x3f,%esi
   4279e:	bf b5 52 04 00       	mov    $0x452b5,%edi
   427a3:	e8 ca fd ff ff       	call   42572 <assert_fail>
           == (uintptr_t) default_int_handler);
    assert(virtual_memory_lookup(kernel_pagetable, (uintptr_t) pagetable).pa
   427a8:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
   427ac:	48 8b 0d 4d e8 00 00 	mov    0xe84d(%rip),%rcx        # 51000 <kernel_pagetable>
   427b3:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
   427b7:	48 89 ce             	mov    %rcx,%rsi
   427ba:	48 89 c7             	mov    %rax,%rdi
   427bd:	e8 72 04 00 00       	call   42c34 <virtual_memory_lookup>
   427c2:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   427c6:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   427ca:	48 39 c2             	cmp    %rax,%rdx
   427cd:	74 14                	je     427e3 <set_pagetable+0xa3>
   427cf:	ba 78 53 04 00       	mov    $0x45378,%edx
   427d4:	be 41 00 00 00       	mov    $0x41,%esi
   427d9:	bf b5 52 04 00       	mov    $0x452b5,%edi
   427de:	e8 8f fd ff ff       	call   42572 <assert_fail>
           == (uintptr_t) pagetable);
    assert(virtual_memory_lookup(pagetable, (uintptr_t) kernel_pagetable).pa
   427e3:	48 8b 05 16 e8 00 00 	mov    0xe816(%rip),%rax        # 51000 <kernel_pagetable>
   427ea:	48 89 c2             	mov    %rax,%rdx
   427ed:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
   427f1:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   427f5:	48 89 ce             	mov    %rcx,%rsi
   427f8:	48 89 c7             	mov    %rax,%rdi
   427fb:	e8 34 04 00 00       	call   42c34 <virtual_memory_lookup>
   42800:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42804:	48 8b 15 f5 e7 00 00 	mov    0xe7f5(%rip),%rdx        # 51000 <kernel_pagetable>
   4280b:	48 39 d0             	cmp    %rdx,%rax
   4280e:	74 14                	je     42824 <set_pagetable+0xe4>
   42810:	ba d8 53 04 00       	mov    $0x453d8,%edx
   42815:	be 43 00 00 00       	mov    $0x43,%esi
   4281a:	bf b5 52 04 00       	mov    $0x452b5,%edi
   4281f:	e8 4e fd ff ff       	call   42572 <assert_fail>
           == (uintptr_t) kernel_pagetable);
    assert(virtual_memory_lookup(pagetable, (uintptr_t) virtual_memory_map).pa
   42824:	ba 71 28 04 00       	mov    $0x42871,%edx
   42829:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
   4282d:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42831:	48 89 ce             	mov    %rcx,%rsi
   42834:	48 89 c7             	mov    %rax,%rdi
   42837:	e8 f8 03 00 00       	call   42c34 <virtual_memory_lookup>
   4283c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42840:	ba 71 28 04 00       	mov    $0x42871,%edx
   42845:	48 39 d0             	cmp    %rdx,%rax
   42848:	74 14                	je     4285e <set_pagetable+0x11e>
   4284a:	ba 40 54 04 00       	mov    $0x45440,%edx
   4284f:	be 45 00 00 00       	mov    $0x45,%esi
   42854:	bf b5 52 04 00       	mov    $0x452b5,%edi
   42859:	e8 14 fd ff ff       	call   42572 <assert_fail>
           == (uintptr_t) virtual_memory_map);
    lcr3((uintptr_t) pagetable);
   4285e:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   42862:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   42866:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4286a:	0f 22 d8             	mov    %rax,%cr3
}
   4286d:	90                   	nop
}
   4286e:	90                   	nop
   4286f:	c9                   	leave
   42870:	c3                   	ret

0000000000042871 <virtual_memory_map>:
//    Returns NULL otherwise
static x86_64_pagetable* lookup_l4pagetable(x86_64_pagetable* pagetable,
                 uintptr_t va, int perm);

int virtual_memory_map(x86_64_pagetable* pagetable, uintptr_t va,
                       uintptr_t pa, size_t sz, int perm) {
   42871:	55                   	push   %rbp
   42872:	48 89 e5             	mov    %rsp,%rbp
   42875:	53                   	push   %rbx
   42876:	48 83 ec 58          	sub    $0x58,%rsp
   4287a:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   4287e:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
   42882:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
   42886:	48 89 4d b0          	mov    %rcx,-0x50(%rbp)
   4288a:	44 89 45 ac          	mov    %r8d,-0x54(%rbp)

    // sanity checks for virtual address, size, and permisions
    assert(va % PAGESIZE == 0); // virtual address is page-aligned
   4288e:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42892:	25 ff 0f 00 00       	and    $0xfff,%eax
   42897:	48 85 c0             	test   %rax,%rax
   4289a:	74 14                	je     428b0 <virtual_memory_map+0x3f>
   4289c:	ba a6 54 04 00       	mov    $0x454a6,%edx
   428a1:	be 66 00 00 00       	mov    $0x66,%esi
   428a6:	bf b5 52 04 00       	mov    $0x452b5,%edi
   428ab:	e8 c2 fc ff ff       	call   42572 <assert_fail>
    assert(sz % PAGESIZE == 0); // size is a multiple of PAGESIZE
   428b0:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   428b4:	25 ff 0f 00 00       	and    $0xfff,%eax
   428b9:	48 85 c0             	test   %rax,%rax
   428bc:	74 14                	je     428d2 <virtual_memory_map+0x61>
   428be:	ba b9 54 04 00       	mov    $0x454b9,%edx
   428c3:	be 67 00 00 00       	mov    $0x67,%esi
   428c8:	bf b5 52 04 00       	mov    $0x452b5,%edi
   428cd:	e8 a0 fc ff ff       	call   42572 <assert_fail>
    assert(va + sz >= va || va + sz == 0); // va range does not wrap
   428d2:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   428d6:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   428da:	48 01 d0             	add    %rdx,%rax
   428dd:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
   428e1:	73 24                	jae    42907 <virtual_memory_map+0x96>
   428e3:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   428e7:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   428eb:	48 01 d0             	add    %rdx,%rax
   428ee:	48 85 c0             	test   %rax,%rax
   428f1:	74 14                	je     42907 <virtual_memory_map+0x96>
   428f3:	ba cc 54 04 00       	mov    $0x454cc,%edx
   428f8:	be 68 00 00 00       	mov    $0x68,%esi
   428fd:	bf b5 52 04 00       	mov    $0x452b5,%edi
   42902:	e8 6b fc ff ff       	call   42572 <assert_fail>
    if (perm & PTE_P) {
   42907:	8b 45 ac             	mov    -0x54(%rbp),%eax
   4290a:	48 98                	cltq
   4290c:	83 e0 01             	and    $0x1,%eax
   4290f:	48 85 c0             	test   %rax,%rax
   42912:	74 6e                	je     42982 <virtual_memory_map+0x111>
        assert(pa % PAGESIZE == 0); // physical addr is page-aligned
   42914:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   42918:	25 ff 0f 00 00       	and    $0xfff,%eax
   4291d:	48 85 c0             	test   %rax,%rax
   42920:	74 14                	je     42936 <virtual_memory_map+0xc5>
   42922:	ba ea 54 04 00       	mov    $0x454ea,%edx
   42927:	be 6a 00 00 00       	mov    $0x6a,%esi
   4292c:	bf b5 52 04 00       	mov    $0x452b5,%edi
   42931:	e8 3c fc ff ff       	call   42572 <assert_fail>
        assert(pa + sz >= pa);      // physical address range does not wrap
   42936:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   4293a:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   4293e:	48 01 d0             	add    %rdx,%rax
   42941:	48 3b 45 b8          	cmp    -0x48(%rbp),%rax
   42945:	73 14                	jae    4295b <virtual_memory_map+0xea>
   42947:	ba fd 54 04 00       	mov    $0x454fd,%edx
   4294c:	be 6b 00 00 00       	mov    $0x6b,%esi
   42951:	bf b5 52 04 00       	mov    $0x452b5,%edi
   42956:	e8 17 fc ff ff       	call   42572 <assert_fail>
        assert(pa + sz <= MEMSIZE_PHYSICAL); // physical addresses exist
   4295b:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   4295f:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   42963:	48 01 d0             	add    %rdx,%rax
   42966:	48 3d 00 00 20 00    	cmp    $0x200000,%rax
   4296c:	76 14                	jbe    42982 <virtual_memory_map+0x111>
   4296e:	ba 0b 55 04 00       	mov    $0x4550b,%edx
   42973:	be 6c 00 00 00       	mov    $0x6c,%esi
   42978:	bf b5 52 04 00       	mov    $0x452b5,%edi
   4297d:	e8 f0 fb ff ff       	call   42572 <assert_fail>
    }
    assert(perm >= 0 && perm < 0x1000); // `perm` makes sense (perm can only be 12 bits)
   42982:	83 7d ac 00          	cmpl   $0x0,-0x54(%rbp)
   42986:	78 09                	js     42991 <virtual_memory_map+0x120>
   42988:	81 7d ac ff 0f 00 00 	cmpl   $0xfff,-0x54(%rbp)
   4298f:	7e 14                	jle    429a5 <virtual_memory_map+0x134>
   42991:	ba 27 55 04 00       	mov    $0x45527,%edx
   42996:	be 6e 00 00 00       	mov    $0x6e,%esi
   4299b:	bf b5 52 04 00       	mov    $0x452b5,%edi
   429a0:	e8 cd fb ff ff       	call   42572 <assert_fail>
    assert((uintptr_t) pagetable % PAGESIZE == 0); // `pagetable` page-aligned
   429a5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   429a9:	25 ff 0f 00 00       	and    $0xfff,%eax
   429ae:	48 85 c0             	test   %rax,%rax
   429b1:	74 14                	je     429c7 <virtual_memory_map+0x156>
   429b3:	ba 48 55 04 00       	mov    $0x45548,%edx
   429b8:	be 6f 00 00 00       	mov    $0x6f,%esi
   429bd:	bf b5 52 04 00       	mov    $0x452b5,%edi
   429c2:	e8 ab fb ff ff       	call   42572 <assert_fail>

    int last_index123 = -1;
   429c7:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%rbp)
    x86_64_pagetable* l4pagetable = NULL;
   429ce:	48 c7 45 e0 00 00 00 	movq   $0x0,-0x20(%rbp)
   429d5:	00 

    // for each page-aligned address, set the appropriate page entry
    for (; sz != 0; va += PAGESIZE, pa += PAGESIZE, sz -= PAGESIZE) {
   429d6:	e9 e1 00 00 00       	jmp    42abc <virtual_memory_map+0x24b>
        int cur_index123 = (va >> (PAGEOFFBITS + PAGEINDEXBITS));
   429db:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   429df:	48 c1 e8 15          	shr    $0x15,%rax
   429e3:	89 45 dc             	mov    %eax,-0x24(%rbp)
        if (cur_index123 != last_index123) {
   429e6:	8b 45 dc             	mov    -0x24(%rbp),%eax
   429e9:	3b 45 ec             	cmp    -0x14(%rbp),%eax
   429ec:	74 20                	je     42a0e <virtual_memory_map+0x19d>
            // find pointer to last level pagetable for current va
            l4pagetable = lookup_l4pagetable(pagetable, va, perm);
   429ee:	8b 55 ac             	mov    -0x54(%rbp),%edx
   429f1:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
   429f5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   429f9:	48 89 ce             	mov    %rcx,%rsi
   429fc:	48 89 c7             	mov    %rax,%rdi
   429ff:	e8 ce 00 00 00       	call   42ad2 <lookup_l4pagetable>
   42a04:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            last_index123 = cur_index123;
   42a08:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42a0b:	89 45 ec             	mov    %eax,-0x14(%rbp)
        }
        if ((perm & PTE_P) && l4pagetable) { // if page is marked present
   42a0e:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42a11:	48 98                	cltq
   42a13:	83 e0 01             	and    $0x1,%eax
   42a16:	48 85 c0             	test   %rax,%rax
   42a19:	74 34                	je     42a4f <virtual_memory_map+0x1de>
   42a1b:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   42a20:	74 2d                	je     42a4f <virtual_memory_map+0x1de>
            // set page table entry to pa and perm
            l4pagetable->entry[L4PAGEINDEX(va)] = pa | perm;
   42a22:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42a25:	48 63 d8             	movslq %eax,%rbx
   42a28:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42a2c:	be 03 00 00 00       	mov    $0x3,%esi
   42a31:	48 89 c7             	mov    %rax,%rdi
   42a34:	e8 9e fb ff ff       	call   425d7 <pageindex>
   42a39:	89 c2                	mov    %eax,%edx
   42a3b:	48 0b 5d b8          	or     -0x48(%rbp),%rbx
   42a3f:	48 89 d9             	mov    %rbx,%rcx
   42a42:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42a46:	48 63 d2             	movslq %edx,%rdx
   42a49:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
   42a4d:	eb 55                	jmp    42aa4 <virtual_memory_map+0x233>
        } else if (l4pagetable) { // if page is NOT marked present
   42a4f:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   42a54:	74 26                	je     42a7c <virtual_memory_map+0x20b>
            // set page table entry to just perm
            l4pagetable->entry[L4PAGEINDEX(va)] = perm;
   42a56:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42a5a:	be 03 00 00 00       	mov    $0x3,%esi
   42a5f:	48 89 c7             	mov    %rax,%rdi
   42a62:	e8 70 fb ff ff       	call   425d7 <pageindex>
   42a67:	89 c2                	mov    %eax,%edx
   42a69:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42a6c:	48 63 c8             	movslq %eax,%rcx
   42a6f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42a73:	48 63 d2             	movslq %edx,%rdx
   42a76:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
   42a7a:	eb 28                	jmp    42aa4 <virtual_memory_map+0x233>
        } else if (perm & PTE_P) {
   42a7c:	8b 45 ac             	mov    -0x54(%rbp),%eax
   42a7f:	48 98                	cltq
   42a81:	83 e0 01             	and    $0x1,%eax
   42a84:	48 85 c0             	test   %rax,%rax
   42a87:	74 1b                	je     42aa4 <virtual_memory_map+0x233>
            // error, no allocated l4 page found for va
            log_printf("[Kern Info] failed to find l4pagetable address at " __FILE__ ": %d\n", __LINE__);
   42a89:	be 84 00 00 00       	mov    $0x84,%esi
   42a8e:	bf 70 55 04 00       	mov    $0x45570,%edi
   42a93:	b8 00 00 00 00       	mov    $0x0,%eax
   42a98:	e8 b7 f7 ff ff       	call   42254 <log_printf>
            return -1;
   42a9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42aa2:	eb 28                	jmp    42acc <virtual_memory_map+0x25b>
    for (; sz != 0; va += PAGESIZE, pa += PAGESIZE, sz -= PAGESIZE) {
   42aa4:	48 81 45 c0 00 10 00 	addq   $0x1000,-0x40(%rbp)
   42aab:	00 
   42aac:	48 81 45 b8 00 10 00 	addq   $0x1000,-0x48(%rbp)
   42ab3:	00 
   42ab4:	48 81 6d b0 00 10 00 	subq   $0x1000,-0x50(%rbp)
   42abb:	00 
   42abc:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
   42ac1:	0f 85 14 ff ff ff    	jne    429db <virtual_memory_map+0x16a>
        }
    }
    return 0;
   42ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
   42acc:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   42ad0:	c9                   	leave
   42ad1:	c3                   	ret

0000000000042ad2 <lookup_l4pagetable>:
//
//    Returns an x86_64_pagetable pointer to the last level pagetable
//    if it exists and can be accessed with the given permissions
//    Returns NULL otherwise
static x86_64_pagetable* lookup_l4pagetable(x86_64_pagetable* pagetable,
                 uintptr_t va, int perm) {
   42ad2:	55                   	push   %rbp
   42ad3:	48 89 e5             	mov    %rsp,%rbp
   42ad6:	48 83 ec 40          	sub    $0x40,%rsp
   42ada:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   42ade:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
   42ae2:	89 55 cc             	mov    %edx,-0x34(%rbp)
    x86_64_pagetable* pt = pagetable;
   42ae5:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42ae9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    // 1. Find index to the next pagetable entry using the `va`
    // 2. Check if this entry has the appropriate requested permissions
    // 3. Repeat the steps till you reach the l4 pagetable (i.e thrice)
    // 4. return the pagetable address

    for (int i = 0; i <= 2; ++i) {
   42aed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   42af4:	e9 2b 01 00 00       	jmp    42c24 <lookup_l4pagetable+0x152>
        // find page entry by finding `ith` level index of va to index pagetable entries of `pt`
        // you should read x86-64.h to understand relevant structs and macros to make this part easier
        x86_64_pageentry_t pe = pt->entry[PAGEINDEX(va, i)];
   42af9:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42afc:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42b00:	89 d6                	mov    %edx,%esi
   42b02:	48 89 c7             	mov    %rax,%rdi
   42b05:	e8 cd fa ff ff       	call   425d7 <pageindex>
   42b0a:	89 c2                	mov    %eax,%edx
   42b0c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42b10:	48 63 d2             	movslq %edx,%rdx
   42b13:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   42b17:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

        if (!(pe & PTE_P)) { // address of next level should be present AND PTE_P should be set, error otherwise
   42b1b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42b1f:	83 e0 01             	and    $0x1,%eax
   42b22:	48 85 c0             	test   %rax,%rax
   42b25:	75 63                	jne    42b8a <lookup_l4pagetable+0xb8>
            log_printf("[Kern Info] Error looking up l4pagetable: Pagetable address: 0x%x perm: 0x%x."
   42b27:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42b2a:	8d 48 02             	lea    0x2(%rax),%ecx
   42b2d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42b31:	25 ff 0f 00 00       	and    $0xfff,%eax
   42b36:	48 89 c2             	mov    %rax,%rdx
   42b39:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42b3d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42b43:	48 89 c6             	mov    %rax,%rsi
   42b46:	bf b8 55 04 00       	mov    $0x455b8,%edi
   42b4b:	b8 00 00 00 00       	mov    $0x0,%eax
   42b50:	e8 ff f6 ff ff       	call   42254 <log_printf>
                    " Failed to get level (%d)\n",
                    PTE_ADDR(pe), PTE_FLAGS(pe), (i+2));
            if (!(perm & PTE_P)) {
   42b55:	8b 45 cc             	mov    -0x34(%rbp),%eax
   42b58:	48 98                	cltq
   42b5a:	83 e0 01             	and    $0x1,%eax
   42b5d:	48 85 c0             	test   %rax,%rax
   42b60:	75 0a                	jne    42b6c <lookup_l4pagetable+0x9a>
                return NULL;
   42b62:	b8 00 00 00 00       	mov    $0x0,%eax
   42b67:	e9 c6 00 00 00       	jmp    42c32 <lookup_l4pagetable+0x160>
            }
            log_printf("[Kern Info] failed to find pagetable address at " __FILE__ ": %d\n", __LINE__);
   42b6c:	be a7 00 00 00       	mov    $0xa7,%esi
   42b71:	bf 20 56 04 00       	mov    $0x45620,%edi
   42b76:	b8 00 00 00 00       	mov    $0x0,%eax
   42b7b:	e8 d4 f6 ff ff       	call   42254 <log_printf>
            return NULL;
   42b80:	b8 00 00 00 00       	mov    $0x0,%eax
   42b85:	e9 a8 00 00 00       	jmp    42c32 <lookup_l4pagetable+0x160>
        }

        // sanity-check page entry and permissions
        assert(PTE_ADDR(pe) < MEMSIZE_PHYSICAL); // at sensible address
   42b8a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42b8e:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42b94:	48 3d ff ff 1f 00    	cmp    $0x1fffff,%rax
   42b9a:	76 14                	jbe    42bb0 <lookup_l4pagetable+0xde>
   42b9c:	ba 68 56 04 00       	mov    $0x45668,%edx
   42ba1:	be ac 00 00 00       	mov    $0xac,%esi
   42ba6:	bf b5 52 04 00       	mov    $0x452b5,%edi
   42bab:	e8 c2 f9 ff ff       	call   42572 <assert_fail>
        if (perm & PTE_W) {       // if requester wants PTE_W,
   42bb0:	8b 45 cc             	mov    -0x34(%rbp),%eax
   42bb3:	48 98                	cltq
   42bb5:	83 e0 02             	and    $0x2,%eax
   42bb8:	48 85 c0             	test   %rax,%rax
   42bbb:	74 20                	je     42bdd <lookup_l4pagetable+0x10b>
            assert(pe & PTE_W);   //   entry must allow PTE_W
   42bbd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42bc1:	83 e0 02             	and    $0x2,%eax
   42bc4:	48 85 c0             	test   %rax,%rax
   42bc7:	75 14                	jne    42bdd <lookup_l4pagetable+0x10b>
   42bc9:	ba 88 56 04 00       	mov    $0x45688,%edx
   42bce:	be ae 00 00 00       	mov    $0xae,%esi
   42bd3:	bf b5 52 04 00       	mov    $0x452b5,%edi
   42bd8:	e8 95 f9 ff ff       	call   42572 <assert_fail>
        }
        if (perm & PTE_U) {       // if requester wants PTE_U,
   42bdd:	8b 45 cc             	mov    -0x34(%rbp),%eax
   42be0:	48 98                	cltq
   42be2:	83 e0 04             	and    $0x4,%eax
   42be5:	48 85 c0             	test   %rax,%rax
   42be8:	74 20                	je     42c0a <lookup_l4pagetable+0x138>
            assert(pe & PTE_U);   //   entry must allow PTE_U
   42bea:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42bee:	83 e0 04             	and    $0x4,%eax
   42bf1:	48 85 c0             	test   %rax,%rax
   42bf4:	75 14                	jne    42c0a <lookup_l4pagetable+0x138>
   42bf6:	ba 93 56 04 00       	mov    $0x45693,%edx
   42bfb:	be b1 00 00 00       	mov    $0xb1,%esi
   42c00:	bf b5 52 04 00       	mov    $0x452b5,%edi
   42c05:	e8 68 f9 ff ff       	call   42572 <assert_fail>
        }

        // set pt to physical address to next pagetable using `pe`
        pt = 0; // replace this
   42c0a:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   42c11:	00 
        pt = (x86_64_pagetable*) PTE_ADDR(pe);
   42c12:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42c16:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42c1c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 2; ++i) {
   42c20:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   42c24:	83 7d f4 02          	cmpl   $0x2,-0xc(%rbp)
   42c28:	0f 8e cb fe ff ff    	jle    42af9 <lookup_l4pagetable+0x27>
    }
    return pt;
   42c2e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
   42c32:	c9                   	leave
   42c33:	c3                   	ret

0000000000042c34 <virtual_memory_lookup>:

// virtual_memory_lookup(pagetable, va)
//    Returns information about the mapping of the virtual address `va` in
//    `pagetable`. The information is returned as a `vamapping` object.

vamapping virtual_memory_lookup(x86_64_pagetable* pagetable, uintptr_t va) {
   42c34:	55                   	push   %rbp
   42c35:	48 89 e5             	mov    %rsp,%rbp
   42c38:	48 83 ec 50          	sub    $0x50,%rsp
   42c3c:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   42c40:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
   42c44:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
    x86_64_pagetable* pt = pagetable;
   42c48:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42c4c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    x86_64_pageentry_t pe = PTE_W | PTE_U | PTE_P;
   42c50:	48 c7 45 f0 07 00 00 	movq   $0x7,-0x10(%rbp)
   42c57:	00 
    for (int i = 0; i <= 3 && (pe & PTE_P); ++i) {
   42c58:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
   42c5f:	eb 41                	jmp    42ca2 <virtual_memory_lookup+0x6e>
        pe = pt->entry[PAGEINDEX(va, i)] & ~(pe & (PTE_W | PTE_U));
   42c61:	8b 55 ec             	mov    -0x14(%rbp),%edx
   42c64:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   42c68:	89 d6                	mov    %edx,%esi
   42c6a:	48 89 c7             	mov    %rax,%rdi
   42c6d:	e8 65 f9 ff ff       	call   425d7 <pageindex>
   42c72:	89 c2                	mov    %eax,%edx
   42c74:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42c78:	48 63 d2             	movslq %edx,%rdx
   42c7b:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
   42c7f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42c83:	83 e0 06             	and    $0x6,%eax
   42c86:	48 f7 d0             	not    %rax
   42c89:	48 21 d0             	and    %rdx,%rax
   42c8c:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
        pt = (x86_64_pagetable*) PTE_ADDR(pe);
   42c90:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42c94:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42c9a:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 3 && (pe & PTE_P); ++i) {
   42c9e:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
   42ca2:	83 7d ec 03          	cmpl   $0x3,-0x14(%rbp)
   42ca6:	7f 0c                	jg     42cb4 <virtual_memory_lookup+0x80>
   42ca8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42cac:	83 e0 01             	and    $0x1,%eax
   42caf:	48 85 c0             	test   %rax,%rax
   42cb2:	75 ad                	jne    42c61 <virtual_memory_lookup+0x2d>
    }
    vamapping vam = { -1, (uintptr_t) -1, 0 };
   42cb4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%rbp)
   42cbb:	48 c7 45 d8 ff ff ff 	movq   $0xffffffffffffffff,-0x28(%rbp)
   42cc2:	ff 
   42cc3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
    if (pe & PTE_P) {
   42cca:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42cce:	83 e0 01             	and    $0x1,%eax
   42cd1:	48 85 c0             	test   %rax,%rax
   42cd4:	74 34                	je     42d0a <virtual_memory_lookup+0xd6>
        vam.pn = PAGENUMBER(pe);
   42cd6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42cda:	48 c1 e8 0c          	shr    $0xc,%rax
   42cde:	89 45 d0             	mov    %eax,-0x30(%rbp)
        vam.pa = PTE_ADDR(pe) + PAGEOFFSET(va);
   42ce1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42ce5:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   42ceb:	48 89 c2             	mov    %rax,%rdx
   42cee:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   42cf2:	25 ff 0f 00 00       	and    $0xfff,%eax
   42cf7:	48 09 d0             	or     %rdx,%rax
   42cfa:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
        vam.perm = PTE_FLAGS(pe);
   42cfe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42d02:	25 ff 0f 00 00       	and    $0xfff,%eax
   42d07:	89 45 e0             	mov    %eax,-0x20(%rbp)
    }
    return vam;
   42d0a:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   42d0e:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   42d12:	48 89 10             	mov    %rdx,(%rax)
   42d15:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   42d19:	48 89 50 08          	mov    %rdx,0x8(%rax)
   42d1d:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   42d21:	48 89 50 10          	mov    %rdx,0x10(%rax)
}
   42d25:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   42d29:	c9                   	leave
   42d2a:	c3                   	ret

0000000000042d2b <program_load>:
//    `assign_physical_page` to as required. Returns 0 on success and
//    -1 on failure (e.g. out-of-memory). `allocator` is passed to
//    `virtual_memory_map`.

int program_load(proc* p, int programnumber,
                 x86_64_pagetable* (*allocator)(void)) {
   42d2b:	55                   	push   %rbp
   42d2c:	48 89 e5             	mov    %rsp,%rbp
   42d2f:	48 83 ec 40          	sub    $0x40,%rsp
   42d33:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   42d37:	89 75 d4             	mov    %esi,-0x2c(%rbp)
   42d3a:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    // is this a valid program?
    int nprograms = sizeof(ramimages) / sizeof(ramimages[0]);
   42d3e:	c7 45 f8 04 00 00 00 	movl   $0x4,-0x8(%rbp)
    assert(programnumber >= 0 && programnumber < nprograms);
   42d45:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
   42d49:	78 08                	js     42d53 <program_load+0x28>
   42d4b:	8b 45 d4             	mov    -0x2c(%rbp),%eax
   42d4e:	3b 45 f8             	cmp    -0x8(%rbp),%eax
   42d51:	7c 14                	jl     42d67 <program_load+0x3c>
   42d53:	ba a0 56 04 00       	mov    $0x456a0,%edx
   42d58:	be 2e 00 00 00       	mov    $0x2e,%esi
   42d5d:	bf d0 56 04 00       	mov    $0x456d0,%edi
   42d62:	e8 0b f8 ff ff       	call   42572 <assert_fail>
    elf_header* eh = (elf_header*) ramimages[programnumber].begin;
   42d67:	8b 45 d4             	mov    -0x2c(%rbp),%eax
   42d6a:	48 98                	cltq
   42d6c:	48 c1 e0 04          	shl    $0x4,%rax
   42d70:	48 05 20 60 04 00    	add    $0x46020,%rax
   42d76:	48 8b 00             	mov    (%rax),%rax
   42d79:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    assert(eh->e_magic == ELF_MAGIC);
   42d7d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42d81:	8b 00                	mov    (%rax),%eax
   42d83:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
   42d88:	74 14                	je     42d9e <program_load+0x73>
   42d8a:	ba e2 56 04 00       	mov    $0x456e2,%edx
   42d8f:	be 30 00 00 00       	mov    $0x30,%esi
   42d94:	bf d0 56 04 00       	mov    $0x456d0,%edi
   42d99:	e8 d4 f7 ff ff       	call   42572 <assert_fail>

    // load each loadable program segment into memory
    elf_program* ph = (elf_program*) ((const uint8_t*) eh + eh->e_phoff);
   42d9e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42da2:	48 8b 50 20          	mov    0x20(%rax),%rdx
   42da6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42daa:	48 01 d0             	add    %rdx,%rax
   42dad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    for (int i = 0; i < eh->e_phnum; ++i) {
   42db1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42db8:	e9 94 00 00 00       	jmp    42e51 <program_load+0x126>
        if (ph[i].p_type == ELF_PTYPE_LOAD) {
   42dbd:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42dc0:	48 63 d0             	movslq %eax,%rdx
   42dc3:	48 89 d0             	mov    %rdx,%rax
   42dc6:	48 c1 e0 03          	shl    $0x3,%rax
   42dca:	48 29 d0             	sub    %rdx,%rax
   42dcd:	48 c1 e0 03          	shl    $0x3,%rax
   42dd1:	48 89 c2             	mov    %rax,%rdx
   42dd4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42dd8:	48 01 d0             	add    %rdx,%rax
   42ddb:	8b 00                	mov    (%rax),%eax
   42ddd:	83 f8 01             	cmp    $0x1,%eax
   42de0:	75 6b                	jne    42e4d <program_load+0x122>
            const uint8_t* pdata = (const uint8_t*) eh + ph[i].p_offset;
   42de2:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42de5:	48 63 d0             	movslq %eax,%rdx
   42de8:	48 89 d0             	mov    %rdx,%rax
   42deb:	48 c1 e0 03          	shl    $0x3,%rax
   42def:	48 29 d0             	sub    %rdx,%rax
   42df2:	48 c1 e0 03          	shl    $0x3,%rax
   42df6:	48 89 c2             	mov    %rax,%rdx
   42df9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42dfd:	48 01 d0             	add    %rdx,%rax
   42e00:	48 8b 50 08          	mov    0x8(%rax),%rdx
   42e04:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42e08:	48 01 d0             	add    %rdx,%rax
   42e0b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            if (program_load_segment(p, &ph[i], pdata, allocator) < 0) {
   42e0f:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42e12:	48 63 d0             	movslq %eax,%rdx
   42e15:	48 89 d0             	mov    %rdx,%rax
   42e18:	48 c1 e0 03          	shl    $0x3,%rax
   42e1c:	48 29 d0             	sub    %rdx,%rax
   42e1f:	48 c1 e0 03          	shl    $0x3,%rax
   42e23:	48 89 c2             	mov    %rax,%rdx
   42e26:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42e2a:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
   42e2e:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   42e32:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   42e36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42e3a:	48 89 c7             	mov    %rax,%rdi
   42e3d:	e8 3d 00 00 00       	call   42e7f <program_load_segment>
   42e42:	85 c0                	test   %eax,%eax
   42e44:	79 07                	jns    42e4d <program_load+0x122>
                return -1;
   42e46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42e4b:	eb 30                	jmp    42e7d <program_load+0x152>
    for (int i = 0; i < eh->e_phnum; ++i) {
   42e4d:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   42e51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42e55:	0f b7 40 38          	movzwl 0x38(%rax),%eax
   42e59:	0f b7 c0             	movzwl %ax,%eax
   42e5c:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   42e5f:	0f 8c 58 ff ff ff    	jl     42dbd <program_load+0x92>
            }
        }
    }

    // set the entry point from the ELF header
    p->p_registers.reg_rip = eh->e_entry;
   42e65:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42e69:	48 8b 50 18          	mov    0x18(%rax),%rdx
   42e6d:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42e71:	48 89 90 b0 00 00 00 	mov    %rdx,0xb0(%rax)
    return 0;
   42e78:	b8 00 00 00 00       	mov    $0x0,%eax
}
   42e7d:	c9                   	leave
   42e7e:	c3                   	ret

0000000000042e7f <program_load_segment>:
//    Calls `assign_physical_page` to allocate pages and `virtual_memory_map`
//    to map them in `p->p_pagetable`. Returns 0 on success and -1 on failure.

static int program_load_segment(proc* p, const elf_program* ph,
                                const uint8_t* src,
                                x86_64_pagetable* (*allocator)(void)) {
   42e7f:	55                   	push   %rbp
   42e80:	48 89 e5             	mov    %rsp,%rbp
   42e83:	48 83 ec 70          	sub    $0x70,%rsp
   42e87:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   42e8b:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
   42e8f:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
   42e93:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    uintptr_t va = (uintptr_t) ph->p_va;
   42e97:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   42e9b:	48 8b 40 10          	mov    0x10(%rax),%rax
   42e9f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    uintptr_t end_file = va + ph->p_filesz, end_mem = va + ph->p_memsz;
   42ea3:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   42ea7:	48 8b 50 20          	mov    0x20(%rax),%rdx
   42eab:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42eaf:	48 01 d0             	add    %rdx,%rax
   42eb2:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
   42eb6:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   42eba:	48 8b 50 28          	mov    0x28(%rax),%rdx
   42ebe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42ec2:	48 01 d0             	add    %rdx,%rax
   42ec5:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    va &= ~(PAGESIZE - 1);                // round to page boundary
   42ec9:	48 81 65 e8 00 f0 ff 	andq   $0xfffffffffffff000,-0x18(%rbp)
   42ed0:	ff 


    // allocate memory
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   42ed1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42ed5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   42ed9:	eb 7c                	jmp    42f57 <program_load_segment+0xd8>
        uintptr_t pa = (uintptr_t)palloc(p->p_pid);
   42edb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   42edf:	8b 00                	mov    (%rax),%eax
   42ee1:	89 c7                	mov    %eax,%edi
   42ee3:	e8 84 01 00 00       	call   4306c <palloc>
   42ee8:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        if(pa == (uintptr_t)NULL || virtual_memory_map(p->p_pagetable, addr, pa, PAGESIZE,
   42eec:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
   42ef1:	74 2a                	je     42f1d <program_load_segment+0x9e>
   42ef3:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   42ef7:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   42efe:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   42f02:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   42f06:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   42f0c:	b9 00 10 00 00       	mov    $0x1000,%ecx
   42f11:	48 89 c7             	mov    %rax,%rdi
   42f14:	e8 58 f9 ff ff       	call   42871 <virtual_memory_map>
   42f19:	85 c0                	test   %eax,%eax
   42f1b:	79 32                	jns    42f4f <program_load_segment+0xd0>
                    PTE_W | PTE_P | PTE_U) < 0) {
            console_printf(CPOS(22, 0), 0xC000,
   42f1d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   42f21:	8b 00                	mov    (%rax),%eax
   42f23:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   42f27:	49 89 d0             	mov    %rdx,%r8
   42f2a:	89 c1                	mov    %eax,%ecx
   42f2c:	ba 00 57 04 00       	mov    $0x45700,%edx
   42f31:	be 00 c0 00 00       	mov    $0xc000,%esi
   42f36:	bf e0 06 00 00       	mov    $0x6e0,%edi
   42f3b:	b8 00 00 00 00       	mov    $0x0,%eax
   42f40:	e8 10 1b 00 00       	call   44a55 <console_printf>
                    "program_load_segment(pid %d): can't assign address %p\n", p->p_pid, addr);
            return -1;
   42f45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42f4a:	e9 1b 01 00 00       	jmp    4306a <program_load_segment+0x1eb>
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   42f4f:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   42f56:	00 
   42f57:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42f5b:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
   42f5f:	0f 82 76 ff ff ff    	jb     42edb <program_load_segment+0x5c>
        }
    }

    // ensure new memory mappings are active
    set_pagetable(p->p_pagetable);
   42f65:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   42f69:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   42f70:	48 89 c7             	mov    %rax,%rdi
   42f73:	e8 c8 f7 ff ff       	call   42740 <set_pagetable>

    // copy data from executable image into process memory
    memcpy((uint8_t*) va, src, end_file - va);
   42f78:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42f7c:	48 2b 45 e8          	sub    -0x18(%rbp),%rax
   42f80:	48 89 c2             	mov    %rax,%rdx
   42f83:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42f87:	48 8b 4d 98          	mov    -0x68(%rbp),%rcx
   42f8b:	48 89 ce             	mov    %rcx,%rsi
   42f8e:	48 89 c7             	mov    %rax,%rdi
   42f91:	e8 0a 0c 00 00       	call   43ba0 <memcpy>
    memset((uint8_t*) end_file, 0, end_mem - end_file);
   42f96:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42f9a:	48 2b 45 e0          	sub    -0x20(%rbp),%rax
   42f9e:	48 89 c2             	mov    %rax,%rdx
   42fa1:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   42fa5:	be 00 00 00 00       	mov    $0x0,%esi
   42faa:	48 89 c7             	mov    %rax,%rdi
   42fad:	e8 ec 0c 00 00       	call   43c9e <memset>

    // restore kernel pagetable
    set_pagetable(kernel_pagetable);
   42fb2:	48 8b 05 47 e0 00 00 	mov    0xe047(%rip),%rax        # 51000 <kernel_pagetable>
   42fb9:	48 89 c7             	mov    %rax,%rdi
   42fbc:	e8 7f f7 ff ff       	call   42740 <set_pagetable>


    if((ph->p_flags & ELF_PFLAG_WRITE) == 0) {
   42fc1:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   42fc5:	8b 40 04             	mov    0x4(%rax),%eax
   42fc8:	83 e0 02             	and    $0x2,%eax
   42fcb:	85 c0                	test   %eax,%eax
   42fcd:	75 60                	jne    4302f <program_load_segment+0x1b0>
        for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   42fcf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42fd3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   42fd7:	eb 4c                	jmp    43025 <program_load_segment+0x1a6>
            vamapping mapping = virtual_memory_lookup(p->p_pagetable, addr);
   42fd9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   42fdd:	48 8b 88 e0 00 00 00 	mov    0xe0(%rax),%rcx
   42fe4:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
   42fe8:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   42fec:	48 89 ce             	mov    %rcx,%rsi
   42fef:	48 89 c7             	mov    %rax,%rdi
   42ff2:	e8 3d fc ff ff       	call   42c34 <virtual_memory_lookup>

            virtual_memory_map(p->p_pagetable, addr, mapping.pa, PAGESIZE,
   42ff7:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   42ffb:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   42fff:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   43006:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
   4300a:	41 b8 05 00 00 00    	mov    $0x5,%r8d
   43010:	b9 00 10 00 00       	mov    $0x1000,%ecx
   43015:	48 89 c7             	mov    %rax,%rdi
   43018:	e8 54 f8 ff ff       	call   42871 <virtual_memory_map>
        for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   4301d:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
   43024:	00 
   43025:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43029:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
   4302d:	72 aa                	jb     42fd9 <program_load_segment+0x15a>
                    PTE_P | PTE_U);
        }
    }
    // TODO : Add code here
    p->original_break = PTE_ADDR(end_mem + PAGESIZE - 1);
   4302f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43033:	48 05 ff 0f 00 00    	add    $0xfff,%rax
   43039:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   4303f:	48 89 c2             	mov    %rax,%rdx
   43042:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   43046:	48 89 50 10          	mov    %rdx,0x10(%rax)
    p->program_break = PTE_ADDR(end_mem + PAGESIZE - 1);
   4304a:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4304e:	48 05 ff 0f 00 00    	add    $0xfff,%rax
   43054:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   4305a:	48 89 c2             	mov    %rax,%rdx
   4305d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   43061:	48 89 50 08          	mov    %rdx,0x8(%rax)
    return 0;
   43065:	b8 00 00 00 00       	mov    $0x0,%eax
}
   4306a:	c9                   	leave
   4306b:	c3                   	ret

000000000004306c <palloc>:
   4306c:	55                   	push   %rbp
   4306d:	48 89 e5             	mov    %rsp,%rbp
   43070:	48 83 ec 20          	sub    $0x20,%rsp
   43074:	89 7d ec             	mov    %edi,-0x14(%rbp)
   43077:	48 c7 45 f8 00 10 00 	movq   $0x1000,-0x8(%rbp)
   4307e:	00 
   4307f:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43083:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   43087:	e9 95 00 00 00       	jmp    43121 <palloc+0xb5>
   4308c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43090:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   43094:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   4309b:	00 
   4309c:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   430a0:	48 c1 e8 0c          	shr    $0xc,%rax
   430a4:	48 98                	cltq
   430a6:	0f b6 84 00 20 ef 04 	movzbl 0x4ef20(%rax,%rax,1),%eax
   430ad:	00 
   430ae:	84 c0                	test   %al,%al
   430b0:	75 6f                	jne    43121 <palloc+0xb5>
   430b2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   430b6:	48 c1 e8 0c          	shr    $0xc,%rax
   430ba:	48 98                	cltq
   430bc:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   430c3:	00 
   430c4:	84 c0                	test   %al,%al
   430c6:	75 59                	jne    43121 <palloc+0xb5>
   430c8:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   430cc:	48 c1 e8 0c          	shr    $0xc,%rax
   430d0:	89 c2                	mov    %eax,%edx
   430d2:	48 63 c2             	movslq %edx,%rax
   430d5:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   430dc:	00 
   430dd:	83 c0 01             	add    $0x1,%eax
   430e0:	89 c1                	mov    %eax,%ecx
   430e2:	48 63 c2             	movslq %edx,%rax
   430e5:	88 8c 00 21 ef 04 00 	mov    %cl,0x4ef21(%rax,%rax,1)
   430ec:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   430f0:	48 c1 e8 0c          	shr    $0xc,%rax
   430f4:	89 c1                	mov    %eax,%ecx
   430f6:	8b 45 ec             	mov    -0x14(%rbp),%eax
   430f9:	89 c2                	mov    %eax,%edx
   430fb:	48 63 c1             	movslq %ecx,%rax
   430fe:	88 94 00 20 ef 04 00 	mov    %dl,0x4ef20(%rax,%rax,1)
   43105:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43109:	ba 00 10 00 00       	mov    $0x1000,%edx
   4310e:	be cc 00 00 00       	mov    $0xcc,%esi
   43113:	48 89 c7             	mov    %rax,%rdi
   43116:	e8 83 0b 00 00       	call   43c9e <memset>
   4311b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4311f:	eb 2c                	jmp    4314d <palloc+0xe1>
   43121:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   43128:	00 
   43129:	0f 86 5d ff ff ff    	jbe    4308c <palloc+0x20>
   4312f:	ba 38 57 04 00       	mov    $0x45738,%edx
   43134:	be 00 0c 00 00       	mov    $0xc00,%esi
   43139:	bf 80 07 00 00       	mov    $0x780,%edi
   4313e:	b8 00 00 00 00       	mov    $0x0,%eax
   43143:	e8 0d 19 00 00       	call   44a55 <console_printf>
   43148:	b8 00 00 00 00       	mov    $0x0,%eax
   4314d:	c9                   	leave
   4314e:	c3                   	ret

000000000004314f <palloc_target>:
   4314f:	55                   	push   %rbp
   43150:	48 89 e5             	mov    %rsp,%rbp
   43153:	48 8b 05 a6 3e 01 00 	mov    0x13ea6(%rip),%rax        # 57000 <palloc_target_proc>
   4315a:	48 85 c0             	test   %rax,%rax
   4315d:	75 14                	jne    43173 <palloc_target+0x24>
   4315f:	ba 51 57 04 00       	mov    $0x45751,%edx
   43164:	be 27 00 00 00       	mov    $0x27,%esi
   43169:	bf 6c 57 04 00       	mov    $0x4576c,%edi
   4316e:	e8 ff f3 ff ff       	call   42572 <assert_fail>
   43173:	48 8b 05 86 3e 01 00 	mov    0x13e86(%rip),%rax        # 57000 <palloc_target_proc>
   4317a:	8b 00                	mov    (%rax),%eax
   4317c:	89 c7                	mov    %eax,%edi
   4317e:	e8 e9 fe ff ff       	call   4306c <palloc>
   43183:	5d                   	pop    %rbp
   43184:	c3                   	ret

0000000000043185 <process_free>:
   43185:	55                   	push   %rbp
   43186:	48 89 e5             	mov    %rsp,%rbp
   43189:	48 83 ec 60          	sub    $0x60,%rsp
   4318d:	89 7d ac             	mov    %edi,-0x54(%rbp)
   43190:	8b 45 ac             	mov    -0x54(%rbp),%eax
   43193:	48 63 d0             	movslq %eax,%rdx
   43196:	48 89 d0             	mov    %rdx,%rax
   43199:	48 c1 e0 04          	shl    $0x4,%rax
   4319d:	48 29 d0             	sub    %rdx,%rax
   431a0:	48 c1 e0 04          	shl    $0x4,%rax
   431a4:	48 05 d8 e0 04 00    	add    $0x4e0d8,%rax
   431aa:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
   431b0:	48 c7 45 f8 00 00 10 	movq   $0x100000,-0x8(%rbp)
   431b7:	00 
   431b8:	e9 ad 00 00 00       	jmp    4326a <process_free+0xe5>
   431bd:	8b 45 ac             	mov    -0x54(%rbp),%eax
   431c0:	48 63 d0             	movslq %eax,%rdx
   431c3:	48 89 d0             	mov    %rdx,%rax
   431c6:	48 c1 e0 04          	shl    $0x4,%rax
   431ca:	48 29 d0             	sub    %rdx,%rax
   431cd:	48 c1 e0 04          	shl    $0x4,%rax
   431d1:	48 05 e0 e0 04 00    	add    $0x4e0e0,%rax
   431d7:	48 8b 08             	mov    (%rax),%rcx
   431da:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
   431de:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   431e2:	48 89 ce             	mov    %rcx,%rsi
   431e5:	48 89 c7             	mov    %rax,%rdi
   431e8:	e8 47 fa ff ff       	call   42c34 <virtual_memory_lookup>
   431ed:	8b 45 c8             	mov    -0x38(%rbp),%eax
   431f0:	48 98                	cltq
   431f2:	83 e0 01             	and    $0x1,%eax
   431f5:	48 85 c0             	test   %rax,%rax
   431f8:	74 68                	je     43262 <process_free+0xdd>
   431fa:	8b 45 b8             	mov    -0x48(%rbp),%eax
   431fd:	48 63 d0             	movslq %eax,%rdx
   43200:	0f b6 94 12 21 ef 04 	movzbl 0x4ef21(%rdx,%rdx,1),%edx
   43207:	00 
   43208:	83 ea 01             	sub    $0x1,%edx
   4320b:	48 98                	cltq
   4320d:	88 94 00 21 ef 04 00 	mov    %dl,0x4ef21(%rax,%rax,1)
   43214:	8b 45 b8             	mov    -0x48(%rbp),%eax
   43217:	48 98                	cltq
   43219:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   43220:	00 
   43221:	84 c0                	test   %al,%al
   43223:	75 0f                	jne    43234 <process_free+0xaf>
   43225:	8b 45 b8             	mov    -0x48(%rbp),%eax
   43228:	48 98                	cltq
   4322a:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   43231:	00 
   43232:	eb 2e                	jmp    43262 <process_free+0xdd>
   43234:	8b 45 b8             	mov    -0x48(%rbp),%eax
   43237:	48 98                	cltq
   43239:	0f b6 84 00 20 ef 04 	movzbl 0x4ef20(%rax,%rax,1),%eax
   43240:	00 
   43241:	0f be c0             	movsbl %al,%eax
   43244:	39 45 ac             	cmp    %eax,-0x54(%rbp)
   43247:	75 19                	jne    43262 <process_free+0xdd>
   43249:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   4324d:	8b 55 ac             	mov    -0x54(%rbp),%edx
   43250:	48 89 c6             	mov    %rax,%rsi
   43253:	bf 78 57 04 00       	mov    $0x45778,%edi
   43258:	b8 00 00 00 00       	mov    $0x0,%eax
   4325d:	e8 f2 ef ff ff       	call   42254 <log_printf>
   43262:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   43269:	00 
   4326a:	48 81 7d f8 ff ff 2f 	cmpq   $0x2fffff,-0x8(%rbp)
   43271:	00 
   43272:	0f 86 45 ff ff ff    	jbe    431bd <process_free+0x38>
   43278:	8b 45 ac             	mov    -0x54(%rbp),%eax
   4327b:	48 63 d0             	movslq %eax,%rdx
   4327e:	48 89 d0             	mov    %rdx,%rax
   43281:	48 c1 e0 04          	shl    $0x4,%rax
   43285:	48 29 d0             	sub    %rdx,%rax
   43288:	48 c1 e0 04          	shl    $0x4,%rax
   4328c:	48 05 e0 e0 04 00    	add    $0x4e0e0,%rax
   43292:	48 8b 00             	mov    (%rax),%rax
   43295:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   43299:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4329d:	48 8b 00             	mov    (%rax),%rax
   432a0:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   432a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
   432aa:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   432ae:	48 8b 00             	mov    (%rax),%rax
   432b1:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   432b7:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
   432bb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   432bf:	48 8b 00             	mov    (%rax),%rax
   432c2:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   432c8:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
   432cc:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   432d0:	48 8b 40 08          	mov    0x8(%rax),%rax
   432d4:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   432da:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
   432de:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   432e2:	48 c1 e8 0c          	shr    $0xc,%rax
   432e6:	48 98                	cltq
   432e8:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   432ef:	00 
   432f0:	3c 01                	cmp    $0x1,%al
   432f2:	74 14                	je     43308 <process_free+0x183>
   432f4:	ba b0 57 04 00       	mov    $0x457b0,%edx
   432f9:	be 4f 00 00 00       	mov    $0x4f,%esi
   432fe:	bf 6c 57 04 00       	mov    $0x4576c,%edi
   43303:	e8 6a f2 ff ff       	call   42572 <assert_fail>
   43308:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4330c:	48 c1 e8 0c          	shr    $0xc,%rax
   43310:	48 98                	cltq
   43312:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   43319:	00 
   4331a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4331e:	48 c1 e8 0c          	shr    $0xc,%rax
   43322:	48 98                	cltq
   43324:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   4332b:	00 
   4332c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43330:	48 c1 e8 0c          	shr    $0xc,%rax
   43334:	48 98                	cltq
   43336:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   4333d:	00 
   4333e:	3c 01                	cmp    $0x1,%al
   43340:	74 14                	je     43356 <process_free+0x1d1>
   43342:	ba d8 57 04 00       	mov    $0x457d8,%edx
   43347:	be 52 00 00 00       	mov    $0x52,%esi
   4334c:	bf 6c 57 04 00       	mov    $0x4576c,%edi
   43351:	e8 1c f2 ff ff       	call   42572 <assert_fail>
   43356:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4335a:	48 c1 e8 0c          	shr    $0xc,%rax
   4335e:	48 98                	cltq
   43360:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   43367:	00 
   43368:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4336c:	48 c1 e8 0c          	shr    $0xc,%rax
   43370:	48 98                	cltq
   43372:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   43379:	00 
   4337a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4337e:	48 c1 e8 0c          	shr    $0xc,%rax
   43382:	48 98                	cltq
   43384:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   4338b:	00 
   4338c:	3c 01                	cmp    $0x1,%al
   4338e:	74 14                	je     433a4 <process_free+0x21f>
   43390:	ba 00 58 04 00       	mov    $0x45800,%edx
   43395:	be 55 00 00 00       	mov    $0x55,%esi
   4339a:	bf 6c 57 04 00       	mov    $0x4576c,%edi
   4339f:	e8 ce f1 ff ff       	call   42572 <assert_fail>
   433a4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   433a8:	48 c1 e8 0c          	shr    $0xc,%rax
   433ac:	48 98                	cltq
   433ae:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   433b5:	00 
   433b6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   433ba:	48 c1 e8 0c          	shr    $0xc,%rax
   433be:	48 98                	cltq
   433c0:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   433c7:	00 
   433c8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   433cc:	48 c1 e8 0c          	shr    $0xc,%rax
   433d0:	48 98                	cltq
   433d2:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   433d9:	00 
   433da:	3c 01                	cmp    $0x1,%al
   433dc:	74 14                	je     433f2 <process_free+0x26d>
   433de:	ba 28 58 04 00       	mov    $0x45828,%edx
   433e3:	be 58 00 00 00       	mov    $0x58,%esi
   433e8:	bf 6c 57 04 00       	mov    $0x4576c,%edi
   433ed:	e8 80 f1 ff ff       	call   42572 <assert_fail>
   433f2:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   433f6:	48 c1 e8 0c          	shr    $0xc,%rax
   433fa:	48 98                	cltq
   433fc:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   43403:	00 
   43404:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43408:	48 c1 e8 0c          	shr    $0xc,%rax
   4340c:	48 98                	cltq
   4340e:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   43415:	00 
   43416:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   4341a:	48 c1 e8 0c          	shr    $0xc,%rax
   4341e:	48 98                	cltq
   43420:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   43427:	00 
   43428:	3c 01                	cmp    $0x1,%al
   4342a:	74 14                	je     43440 <process_free+0x2bb>
   4342c:	ba 50 58 04 00       	mov    $0x45850,%edx
   43431:	be 5b 00 00 00       	mov    $0x5b,%esi
   43436:	bf 6c 57 04 00       	mov    $0x4576c,%edi
   4343b:	e8 32 f1 ff ff       	call   42572 <assert_fail>
   43440:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   43444:	48 c1 e8 0c          	shr    $0xc,%rax
   43448:	48 98                	cltq
   4344a:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   43451:	00 
   43452:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   43456:	48 c1 e8 0c          	shr    $0xc,%rax
   4345a:	48 98                	cltq
   4345c:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   43463:	00 
   43464:	90                   	nop
   43465:	c9                   	leave
   43466:	c3                   	ret

0000000000043467 <process_config_tables>:
   43467:	55                   	push   %rbp
   43468:	48 89 e5             	mov    %rsp,%rbp
   4346b:	48 83 ec 40          	sub    $0x40,%rsp
   4346f:	89 7d cc             	mov    %edi,-0x34(%rbp)
   43472:	8b 45 cc             	mov    -0x34(%rbp),%eax
   43475:	89 c7                	mov    %eax,%edi
   43477:	e8 f0 fb ff ff       	call   4306c <palloc>
   4347c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   43480:	8b 45 cc             	mov    -0x34(%rbp),%eax
   43483:	89 c7                	mov    %eax,%edi
   43485:	e8 e2 fb ff ff       	call   4306c <palloc>
   4348a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   4348e:	8b 45 cc             	mov    -0x34(%rbp),%eax
   43491:	89 c7                	mov    %eax,%edi
   43493:	e8 d4 fb ff ff       	call   4306c <palloc>
   43498:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
   4349c:	8b 45 cc             	mov    -0x34(%rbp),%eax
   4349f:	89 c7                	mov    %eax,%edi
   434a1:	e8 c6 fb ff ff       	call   4306c <palloc>
   434a6:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
   434aa:	8b 45 cc             	mov    -0x34(%rbp),%eax
   434ad:	89 c7                	mov    %eax,%edi
   434af:	e8 b8 fb ff ff       	call   4306c <palloc>
   434b4:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
   434b8:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   434bd:	74 20                	je     434df <process_config_tables+0x78>
   434bf:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
   434c4:	74 19                	je     434df <process_config_tables+0x78>
   434c6:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   434cb:	74 12                	je     434df <process_config_tables+0x78>
   434cd:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   434d2:	74 0b                	je     434df <process_config_tables+0x78>
   434d4:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   434d9:	0f 85 e1 00 00 00    	jne    435c0 <process_config_tables+0x159>
   434df:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   434e4:	74 24                	je     4350a <process_config_tables+0xa3>
   434e6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   434ea:	48 c1 e8 0c          	shr    $0xc,%rax
   434ee:	48 98                	cltq
   434f0:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   434f7:	00 
   434f8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   434fc:	48 c1 e8 0c          	shr    $0xc,%rax
   43500:	48 98                	cltq
   43502:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   43509:	00 
   4350a:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
   4350f:	74 24                	je     43535 <process_config_tables+0xce>
   43511:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43515:	48 c1 e8 0c          	shr    $0xc,%rax
   43519:	48 98                	cltq
   4351b:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   43522:	00 
   43523:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43527:	48 c1 e8 0c          	shr    $0xc,%rax
   4352b:	48 98                	cltq
   4352d:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   43534:	00 
   43535:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   4353a:	74 24                	je     43560 <process_config_tables+0xf9>
   4353c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43540:	48 c1 e8 0c          	shr    $0xc,%rax
   43544:	48 98                	cltq
   43546:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   4354d:	00 
   4354e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43552:	48 c1 e8 0c          	shr    $0xc,%rax
   43556:	48 98                	cltq
   43558:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   4355f:	00 
   43560:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   43565:	74 24                	je     4358b <process_config_tables+0x124>
   43567:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4356b:	48 c1 e8 0c          	shr    $0xc,%rax
   4356f:	48 98                	cltq
   43571:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   43578:	00 
   43579:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4357d:	48 c1 e8 0c          	shr    $0xc,%rax
   43581:	48 98                	cltq
   43583:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   4358a:	00 
   4358b:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   43590:	74 24                	je     435b6 <process_config_tables+0x14f>
   43592:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43596:	48 c1 e8 0c          	shr    $0xc,%rax
   4359a:	48 98                	cltq
   4359c:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   435a3:	00 
   435a4:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   435a8:	48 c1 e8 0c          	shr    $0xc,%rax
   435ac:	48 98                	cltq
   435ae:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   435b5:	00 
   435b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   435bb:	e9 f3 01 00 00       	jmp    437b3 <process_config_tables+0x34c>
   435c0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   435c4:	ba 00 10 00 00       	mov    $0x1000,%edx
   435c9:	be 00 00 00 00       	mov    $0x0,%esi
   435ce:	48 89 c7             	mov    %rax,%rdi
   435d1:	e8 c8 06 00 00       	call   43c9e <memset>
   435d6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   435da:	ba 00 10 00 00       	mov    $0x1000,%edx
   435df:	be 00 00 00 00       	mov    $0x0,%esi
   435e4:	48 89 c7             	mov    %rax,%rdi
   435e7:	e8 b2 06 00 00       	call   43c9e <memset>
   435ec:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   435f0:	ba 00 10 00 00       	mov    $0x1000,%edx
   435f5:	be 00 00 00 00       	mov    $0x0,%esi
   435fa:	48 89 c7             	mov    %rax,%rdi
   435fd:	e8 9c 06 00 00       	call   43c9e <memset>
   43602:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43606:	ba 00 10 00 00       	mov    $0x1000,%edx
   4360b:	be 00 00 00 00       	mov    $0x0,%esi
   43610:	48 89 c7             	mov    %rax,%rdi
   43613:	e8 86 06 00 00       	call   43c9e <memset>
   43618:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4361c:	ba 00 10 00 00       	mov    $0x1000,%edx
   43621:	be 00 00 00 00       	mov    $0x0,%esi
   43626:	48 89 c7             	mov    %rax,%rdi
   43629:	e8 70 06 00 00       	call   43c9e <memset>
   4362e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43632:	48 83 c8 07          	or     $0x7,%rax
   43636:	48 89 c2             	mov    %rax,%rdx
   43639:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4363d:	48 89 10             	mov    %rdx,(%rax)
   43640:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43644:	48 83 c8 07          	or     $0x7,%rax
   43648:	48 89 c2             	mov    %rax,%rdx
   4364b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4364f:	48 89 10             	mov    %rdx,(%rax)
   43652:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43656:	48 83 c8 07          	or     $0x7,%rax
   4365a:	48 89 c2             	mov    %rax,%rdx
   4365d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43661:	48 89 10             	mov    %rdx,(%rax)
   43664:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43668:	48 83 c8 07          	or     $0x7,%rax
   4366c:	48 89 c2             	mov    %rax,%rdx
   4366f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43673:	48 89 50 08          	mov    %rdx,0x8(%rax)
   43677:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4367b:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   43681:	41 b8 03 00 00 00    	mov    $0x3,%r8d
   43687:	b9 00 00 10 00       	mov    $0x100000,%ecx
   4368c:	ba 00 00 00 00       	mov    $0x0,%edx
   43691:	be 00 00 00 00       	mov    $0x0,%esi
   43696:	48 89 c7             	mov    %rax,%rdi
   43699:	e8 d3 f1 ff ff       	call   42871 <virtual_memory_map>
   4369e:	85 c0                	test   %eax,%eax
   436a0:	75 2f                	jne    436d1 <process_config_tables+0x26a>
   436a2:	ba 00 80 0b 00       	mov    $0xb8000,%edx
   436a7:	be 00 80 0b 00       	mov    $0xb8000,%esi
   436ac:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   436b0:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   436b6:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   436bc:	b9 00 10 00 00       	mov    $0x1000,%ecx
   436c1:	48 89 c7             	mov    %rax,%rdi
   436c4:	e8 a8 f1 ff ff       	call   42871 <virtual_memory_map>
   436c9:	85 c0                	test   %eax,%eax
   436cb:	0f 84 bb 00 00 00    	je     4378c <process_config_tables+0x325>
   436d1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   436d5:	48 c1 e8 0c          	shr    $0xc,%rax
   436d9:	48 98                	cltq
   436db:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   436e2:	00 
   436e3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   436e7:	48 c1 e8 0c          	shr    $0xc,%rax
   436eb:	48 98                	cltq
   436ed:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   436f4:	00 
   436f5:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   436f9:	48 c1 e8 0c          	shr    $0xc,%rax
   436fd:	48 98                	cltq
   436ff:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   43706:	00 
   43707:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4370b:	48 c1 e8 0c          	shr    $0xc,%rax
   4370f:	48 98                	cltq
   43711:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   43718:	00 
   43719:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4371d:	48 c1 e8 0c          	shr    $0xc,%rax
   43721:	48 98                	cltq
   43723:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   4372a:	00 
   4372b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4372f:	48 c1 e8 0c          	shr    $0xc,%rax
   43733:	48 98                	cltq
   43735:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   4373c:	00 
   4373d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43741:	48 c1 e8 0c          	shr    $0xc,%rax
   43745:	48 98                	cltq
   43747:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   4374e:	00 
   4374f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43753:	48 c1 e8 0c          	shr    $0xc,%rax
   43757:	48 98                	cltq
   43759:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   43760:	00 
   43761:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43765:	48 c1 e8 0c          	shr    $0xc,%rax
   43769:	48 98                	cltq
   4376b:	c6 84 00 20 ef 04 00 	movb   $0x0,0x4ef20(%rax,%rax,1)
   43772:	00 
   43773:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43777:	48 c1 e8 0c          	shr    $0xc,%rax
   4377b:	48 98                	cltq
   4377d:	c6 84 00 21 ef 04 00 	movb   $0x0,0x4ef21(%rax,%rax,1)
   43784:	00 
   43785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   4378a:	eb 27                	jmp    437b3 <process_config_tables+0x34c>
   4378c:	8b 45 cc             	mov    -0x34(%rbp),%eax
   4378f:	48 63 d0             	movslq %eax,%rdx
   43792:	48 89 d0             	mov    %rdx,%rax
   43795:	48 c1 e0 04          	shl    $0x4,%rax
   43799:	48 29 d0             	sub    %rdx,%rax
   4379c:	48 c1 e0 04          	shl    $0x4,%rax
   437a0:	48 8d 90 e0 e0 04 00 	lea    0x4e0e0(%rax),%rdx
   437a7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   437ab:	48 89 02             	mov    %rax,(%rdx)
   437ae:	b8 00 00 00 00       	mov    $0x0,%eax
   437b3:	c9                   	leave
   437b4:	c3                   	ret

00000000000437b5 <process_load>:
   437b5:	55                   	push   %rbp
   437b6:	48 89 e5             	mov    %rsp,%rbp
   437b9:	48 83 ec 20          	sub    $0x20,%rsp
   437bd:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   437c1:	89 75 e4             	mov    %esi,-0x1c(%rbp)
   437c4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   437c8:	48 89 05 31 38 01 00 	mov    %rax,0x13831(%rip)        # 57000 <palloc_target_proc>
   437cf:	8b 4d e4             	mov    -0x1c(%rbp),%ecx
   437d2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   437d6:	ba 4f 31 04 00       	mov    $0x4314f,%edx
   437db:	89 ce                	mov    %ecx,%esi
   437dd:	48 89 c7             	mov    %rax,%rdi
   437e0:	e8 46 f5 ff ff       	call   42d2b <program_load>
   437e5:	89 45 fc             	mov    %eax,-0x4(%rbp)
   437e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
   437eb:	c9                   	leave
   437ec:	c3                   	ret

00000000000437ed <process_setup_stack>:
   437ed:	55                   	push   %rbp
   437ee:	48 89 e5             	mov    %rsp,%rbp
   437f1:	48 83 ec 20          	sub    $0x20,%rsp
   437f5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   437f9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   437fd:	8b 00                	mov    (%rax),%eax
   437ff:	89 c7                	mov    %eax,%edi
   43801:	e8 66 f8 ff ff       	call   4306c <palloc>
   43806:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   4380a:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4380e:	48 c7 80 c8 00 00 00 	movq   $0x300000,0xc8(%rax)
   43815:	00 00 30 00 
   43819:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4381d:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   43824:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   43828:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   4382e:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   43834:	b9 00 10 00 00       	mov    $0x1000,%ecx
   43839:	be 00 f0 2f 00       	mov    $0x2ff000,%esi
   4383e:	48 89 c7             	mov    %rax,%rdi
   43841:	e8 2b f0 ff ff       	call   42871 <virtual_memory_map>
   43846:	90                   	nop
   43847:	c9                   	leave
   43848:	c3                   	ret

0000000000043849 <find_free_pid>:
   43849:	55                   	push   %rbp
   4384a:	48 89 e5             	mov    %rsp,%rbp
   4384d:	48 83 ec 10          	sub    $0x10,%rsp
   43851:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   43858:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
   4385f:	eb 24                	jmp    43885 <find_free_pid+0x3c>
   43861:	8b 45 fc             	mov    -0x4(%rbp),%eax
   43864:	48 63 d0             	movslq %eax,%rdx
   43867:	48 89 d0             	mov    %rdx,%rax
   4386a:	48 c1 e0 04          	shl    $0x4,%rax
   4386e:	48 29 d0             	sub    %rdx,%rax
   43871:	48 c1 e0 04          	shl    $0x4,%rax
   43875:	48 05 d8 e0 04 00    	add    $0x4e0d8,%rax
   4387b:	8b 00                	mov    (%rax),%eax
   4387d:	85 c0                	test   %eax,%eax
   4387f:	74 0c                	je     4388d <find_free_pid+0x44>
   43881:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   43885:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   43889:	7e d6                	jle    43861 <find_free_pid+0x18>
   4388b:	eb 01                	jmp    4388e <find_free_pid+0x45>
   4388d:	90                   	nop
   4388e:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
   43892:	74 05                	je     43899 <find_free_pid+0x50>
   43894:	8b 45 fc             	mov    -0x4(%rbp),%eax
   43897:	eb 05                	jmp    4389e <find_free_pid+0x55>
   43899:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   4389e:	c9                   	leave
   4389f:	c3                   	ret

00000000000438a0 <process_fork>:
   438a0:	55                   	push   %rbp
   438a1:	48 89 e5             	mov    %rsp,%rbp
   438a4:	48 83 ec 40          	sub    $0x40,%rsp
   438a8:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   438ac:	b8 00 00 00 00       	mov    $0x0,%eax
   438b1:	e8 93 ff ff ff       	call   43849 <find_free_pid>
   438b6:	89 45 f4             	mov    %eax,-0xc(%rbp)
   438b9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%rbp)
   438bd:	75 0a                	jne    438c9 <process_fork+0x29>
   438bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   438c4:	e9 67 02 00 00       	jmp    43b30 <process_fork+0x290>
   438c9:	8b 45 f4             	mov    -0xc(%rbp),%eax
   438cc:	48 63 d0             	movslq %eax,%rdx
   438cf:	48 89 d0             	mov    %rdx,%rax
   438d2:	48 c1 e0 04          	shl    $0x4,%rax
   438d6:	48 29 d0             	sub    %rdx,%rax
   438d9:	48 c1 e0 04          	shl    $0x4,%rax
   438dd:	48 05 00 e0 04 00    	add    $0x4e000,%rax
   438e3:	be 00 00 00 00       	mov    $0x0,%esi
   438e8:	48 89 c7             	mov    %rax,%rdi
   438eb:	e8 b4 e4 ff ff       	call   41da4 <process_init>
   438f0:	8b 45 f4             	mov    -0xc(%rbp),%eax
   438f3:	89 c7                	mov    %eax,%edi
   438f5:	e8 6d fb ff ff       	call   43467 <process_config_tables>
   438fa:	83 f8 ff             	cmp    $0xffffffff,%eax
   438fd:	75 0a                	jne    43909 <process_fork+0x69>
   438ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   43904:	e9 27 02 00 00       	jmp    43b30 <process_fork+0x290>
   43909:	48 c7 45 f8 00 00 10 	movq   $0x100000,-0x8(%rbp)
   43910:	00 
   43911:	e9 79 01 00 00       	jmp    43a8f <process_fork+0x1ef>
   43916:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4391a:	8b 00                	mov    (%rax),%eax
   4391c:	48 63 d0             	movslq %eax,%rdx
   4391f:	48 89 d0             	mov    %rdx,%rax
   43922:	48 c1 e0 04          	shl    $0x4,%rax
   43926:	48 29 d0             	sub    %rdx,%rax
   43929:	48 c1 e0 04          	shl    $0x4,%rax
   4392d:	48 05 e0 e0 04 00    	add    $0x4e0e0,%rax
   43933:	48 8b 08             	mov    (%rax),%rcx
   43936:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   4393a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   4393e:	48 89 ce             	mov    %rcx,%rsi
   43941:	48 89 c7             	mov    %rax,%rdi
   43944:	e8 eb f2 ff ff       	call   42c34 <virtual_memory_lookup>
   43949:	8b 45 e0             	mov    -0x20(%rbp),%eax
   4394c:	48 98                	cltq
   4394e:	83 e0 07             	and    $0x7,%eax
   43951:	48 83 f8 07          	cmp    $0x7,%rax
   43955:	0f 85 a1 00 00 00    	jne    439fc <process_fork+0x15c>
   4395b:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4395e:	89 c7                	mov    %eax,%edi
   43960:	e8 07 f7 ff ff       	call   4306c <palloc>
   43965:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
   43969:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   4396e:	75 14                	jne    43984 <process_fork+0xe4>
   43970:	8b 45 f4             	mov    -0xc(%rbp),%eax
   43973:	89 c7                	mov    %eax,%edi
   43975:	e8 0b f8 ff ff       	call   43185 <process_free>
   4397a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   4397f:	e9 ac 01 00 00       	jmp    43b30 <process_fork+0x290>
   43984:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43988:	48 89 c1             	mov    %rax,%rcx
   4398b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4398f:	ba 00 10 00 00       	mov    $0x1000,%edx
   43994:	48 89 ce             	mov    %rcx,%rsi
   43997:	48 89 c7             	mov    %rax,%rdi
   4399a:	e8 01 02 00 00       	call   43ba0 <memcpy>
   4399f:	48 8b 7d e8          	mov    -0x18(%rbp),%rdi
   439a3:	8b 45 f4             	mov    -0xc(%rbp),%eax
   439a6:	48 63 d0             	movslq %eax,%rdx
   439a9:	48 89 d0             	mov    %rdx,%rax
   439ac:	48 c1 e0 04          	shl    $0x4,%rax
   439b0:	48 29 d0             	sub    %rdx,%rax
   439b3:	48 c1 e0 04          	shl    $0x4,%rax
   439b7:	48 05 e0 e0 04 00    	add    $0x4e0e0,%rax
   439bd:	48 8b 00             	mov    (%rax),%rax
   439c0:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   439c4:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   439ca:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   439d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
   439d5:	48 89 fa             	mov    %rdi,%rdx
   439d8:	48 89 c7             	mov    %rax,%rdi
   439db:	e8 91 ee ff ff       	call   42871 <virtual_memory_map>
   439e0:	85 c0                	test   %eax,%eax
   439e2:	0f 84 9f 00 00 00    	je     43a87 <process_fork+0x1e7>
   439e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
   439eb:	89 c7                	mov    %eax,%edi
   439ed:	e8 93 f7 ff ff       	call   43185 <process_free>
   439f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   439f7:	e9 34 01 00 00       	jmp    43b30 <process_fork+0x290>
   439fc:	8b 45 e0             	mov    -0x20(%rbp),%eax
   439ff:	48 98                	cltq
   43a01:	83 e0 05             	and    $0x5,%eax
   43a04:	48 83 f8 05          	cmp    $0x5,%rax
   43a08:	75 7d                	jne    43a87 <process_fork+0x1e7>
   43a0a:	48 8b 7d d8          	mov    -0x28(%rbp),%rdi
   43a0e:	8b 45 f4             	mov    -0xc(%rbp),%eax
   43a11:	48 63 d0             	movslq %eax,%rdx
   43a14:	48 89 d0             	mov    %rdx,%rax
   43a17:	48 c1 e0 04          	shl    $0x4,%rax
   43a1b:	48 29 d0             	sub    %rdx,%rax
   43a1e:	48 c1 e0 04          	shl    $0x4,%rax
   43a22:	48 05 e0 e0 04 00    	add    $0x4e0e0,%rax
   43a28:	48 8b 00             	mov    (%rax),%rax
   43a2b:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   43a2f:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   43a35:	41 b8 05 00 00 00    	mov    $0x5,%r8d
   43a3b:	b9 00 10 00 00       	mov    $0x1000,%ecx
   43a40:	48 89 fa             	mov    %rdi,%rdx
   43a43:	48 89 c7             	mov    %rax,%rdi
   43a46:	e8 26 ee ff ff       	call   42871 <virtual_memory_map>
   43a4b:	85 c0                	test   %eax,%eax
   43a4d:	74 14                	je     43a63 <process_fork+0x1c3>
   43a4f:	8b 45 f4             	mov    -0xc(%rbp),%eax
   43a52:	89 c7                	mov    %eax,%edi
   43a54:	e8 2c f7 ff ff       	call   43185 <process_free>
   43a59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   43a5e:	e9 cd 00 00 00       	jmp    43b30 <process_fork+0x290>
   43a63:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43a67:	48 c1 e8 0c          	shr    $0xc,%rax
   43a6b:	89 c2                	mov    %eax,%edx
   43a6d:	48 63 c2             	movslq %edx,%rax
   43a70:	0f b6 84 00 21 ef 04 	movzbl 0x4ef21(%rax,%rax,1),%eax
   43a77:	00 
   43a78:	83 c0 01             	add    $0x1,%eax
   43a7b:	89 c1                	mov    %eax,%ecx
   43a7d:	48 63 c2             	movslq %edx,%rax
   43a80:	88 8c 00 21 ef 04 00 	mov    %cl,0x4ef21(%rax,%rax,1)
   43a87:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   43a8e:	00 
   43a8f:	48 81 7d f8 ff ff 2f 	cmpq   $0x2fffff,-0x8(%rbp)
   43a96:	00 
   43a97:	0f 86 79 fe ff ff    	jbe    43916 <process_fork+0x76>
   43a9d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   43aa1:	8b 08                	mov    (%rax),%ecx
   43aa3:	8b 45 f4             	mov    -0xc(%rbp),%eax
   43aa6:	48 63 d0             	movslq %eax,%rdx
   43aa9:	48 89 d0             	mov    %rdx,%rax
   43aac:	48 c1 e0 04          	shl    $0x4,%rax
   43ab0:	48 29 d0             	sub    %rdx,%rax
   43ab3:	48 c1 e0 04          	shl    $0x4,%rax
   43ab7:	48 8d b0 10 e0 04 00 	lea    0x4e010(%rax),%rsi
   43abe:	48 63 d1             	movslq %ecx,%rdx
   43ac1:	48 89 d0             	mov    %rdx,%rax
   43ac4:	48 c1 e0 04          	shl    $0x4,%rax
   43ac8:	48 29 d0             	sub    %rdx,%rax
   43acb:	48 c1 e0 04          	shl    $0x4,%rax
   43acf:	48 8d 90 10 e0 04 00 	lea    0x4e010(%rax),%rdx
   43ad6:	48 8d 46 08          	lea    0x8(%rsi),%rax
   43ada:	48 83 c2 08          	add    $0x8,%rdx
   43ade:	b9 18 00 00 00       	mov    $0x18,%ecx
   43ae3:	48 89 c7             	mov    %rax,%rdi
   43ae6:	48 89 d6             	mov    %rdx,%rsi
   43ae9:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
   43aec:	8b 45 f4             	mov    -0xc(%rbp),%eax
   43aef:	48 63 d0             	movslq %eax,%rdx
   43af2:	48 89 d0             	mov    %rdx,%rax
   43af5:	48 c1 e0 04          	shl    $0x4,%rax
   43af9:	48 29 d0             	sub    %rdx,%rax
   43afc:	48 c1 e0 04          	shl    $0x4,%rax
   43b00:	48 05 18 e0 04 00    	add    $0x4e018,%rax
   43b06:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
   43b0d:	8b 45 f4             	mov    -0xc(%rbp),%eax
   43b10:	48 63 d0             	movslq %eax,%rdx
   43b13:	48 89 d0             	mov    %rdx,%rax
   43b16:	48 c1 e0 04          	shl    $0x4,%rax
   43b1a:	48 29 d0             	sub    %rdx,%rax
   43b1d:	48 c1 e0 04          	shl    $0x4,%rax
   43b21:	48 05 d8 e0 04 00    	add    $0x4e0d8,%rax
   43b27:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
   43b2d:	8b 45 f4             	mov    -0xc(%rbp),%eax
   43b30:	c9                   	leave
   43b31:	c3                   	ret

0000000000043b32 <process_page_alloc>:
   43b32:	55                   	push   %rbp
   43b33:	48 89 e5             	mov    %rsp,%rbp
   43b36:	48 83 ec 20          	sub    $0x20,%rsp
   43b3a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   43b3e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
   43b42:	48 81 7d e0 ff ff 0f 	cmpq   $0xfffff,-0x20(%rbp)
   43b49:	00 
   43b4a:	77 07                	ja     43b53 <process_page_alloc+0x21>
   43b4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   43b51:	eb 4b                	jmp    43b9e <process_page_alloc+0x6c>
   43b53:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43b57:	8b 00                	mov    (%rax),%eax
   43b59:	89 c7                	mov    %eax,%edi
   43b5b:	e8 0c f5 ff ff       	call   4306c <palloc>
   43b60:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   43b64:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   43b69:	74 2e                	je     43b99 <process_page_alloc+0x67>
   43b6b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   43b6f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43b73:	48 8b 80 e0 00 00 00 	mov    0xe0(%rax),%rax
   43b7a:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
   43b7e:	41 b9 00 00 00 00    	mov    $0x0,%r9d
   43b84:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   43b8a:	b9 00 10 00 00       	mov    $0x1000,%ecx
   43b8f:	48 89 c7             	mov    %rax,%rdi
   43b92:	e8 da ec ff ff       	call   42871 <virtual_memory_map>
   43b97:	eb 05                	jmp    43b9e <process_page_alloc+0x6c>
   43b99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   43b9e:	c9                   	leave
   43b9f:	c3                   	ret

0000000000043ba0 <memcpy>:


// memcpy, memmove, memset, strcmp, strlen, strnlen
//    We must provide our own implementations.

void* memcpy(void* dst, const void* src, size_t n) {
   43ba0:	55                   	push   %rbp
   43ba1:	48 89 e5             	mov    %rsp,%rbp
   43ba4:	48 83 ec 28          	sub    $0x28,%rsp
   43ba8:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   43bac:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
   43bb0:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
   43bb4:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43bb8:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
   43bbc:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43bc0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   43bc4:	eb 1c                	jmp    43be2 <memcpy+0x42>
        *d = *s;
   43bc6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43bca:	0f b6 10             	movzbl (%rax),%edx
   43bcd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43bd1:	88 10                	mov    %dl,(%rax)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
   43bd3:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
   43bd8:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
   43bdd:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
   43be2:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   43be7:	75 dd                	jne    43bc6 <memcpy+0x26>
    }
    return dst;
   43be9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
   43bed:	c9                   	leave
   43bee:	c3                   	ret

0000000000043bef <memmove>:

void* memmove(void* dst, const void* src, size_t n) {
   43bef:	55                   	push   %rbp
   43bf0:	48 89 e5             	mov    %rsp,%rbp
   43bf3:	48 83 ec 28          	sub    $0x28,%rsp
   43bf7:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   43bfb:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
   43bff:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
   43c03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43c07:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    char* d = (char*) dst;
   43c0b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43c0f:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (s < d && s + n > d) {
   43c13:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43c17:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
   43c1b:	73 6a                	jae    43c87 <memmove+0x98>
   43c1d:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   43c21:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43c25:	48 01 d0             	add    %rdx,%rax
   43c28:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
   43c2c:	73 59                	jae    43c87 <memmove+0x98>
        s += n, d += n;
   43c2e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43c32:	48 01 45 f8          	add    %rax,-0x8(%rbp)
   43c36:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43c3a:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        while (n-- > 0) {
   43c3e:	eb 17                	jmp    43c57 <memmove+0x68>
            *--d = *--s;
   43c40:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
   43c45:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
   43c4a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43c4e:	0f b6 10             	movzbl (%rax),%edx
   43c51:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43c55:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
   43c57:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43c5b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
   43c5f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
   43c63:	48 85 c0             	test   %rax,%rax
   43c66:	75 d8                	jne    43c40 <memmove+0x51>
    if (s < d && s + n > d) {
   43c68:	eb 2e                	jmp    43c98 <memmove+0xa9>
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
   43c6a:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   43c6e:	48 8d 42 01          	lea    0x1(%rdx),%rax
   43c72:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   43c76:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43c7a:	48 8d 48 01          	lea    0x1(%rax),%rcx
   43c7e:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
   43c82:	0f b6 12             	movzbl (%rdx),%edx
   43c85:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
   43c87:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43c8b:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
   43c8f:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
   43c93:	48 85 c0             	test   %rax,%rax
   43c96:	75 d2                	jne    43c6a <memmove+0x7b>
        }
    }
    return dst;
   43c98:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
   43c9c:	c9                   	leave
   43c9d:	c3                   	ret

0000000000043c9e <memset>:

void* memset(void* v, int c, size_t n) {
   43c9e:	55                   	push   %rbp
   43c9f:	48 89 e5             	mov    %rsp,%rbp
   43ca2:	48 83 ec 28          	sub    $0x28,%rsp
   43ca6:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   43caa:	89 75 e4             	mov    %esi,-0x1c(%rbp)
   43cad:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    for (char* p = (char*) v; n > 0; ++p, --n) {
   43cb1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43cb5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   43cb9:	eb 15                	jmp    43cd0 <memset+0x32>
        *p = c;
   43cbb:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   43cbe:	89 c2                	mov    %eax,%edx
   43cc0:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43cc4:	88 10                	mov    %dl,(%rax)
    for (char* p = (char*) v; n > 0; ++p, --n) {
   43cc6:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
   43ccb:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
   43cd0:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   43cd5:	75 e4                	jne    43cbb <memset+0x1d>
    }
    return v;
   43cd7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
   43cdb:	c9                   	leave
   43cdc:	c3                   	ret

0000000000043cdd <strlen>:

size_t strlen(const char* s) {
   43cdd:	55                   	push   %rbp
   43cde:	48 89 e5             	mov    %rsp,%rbp
   43ce1:	48 83 ec 18          	sub    $0x18,%rsp
   43ce5:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
   43ce9:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   43cf0:	00 
   43cf1:	eb 0a                	jmp    43cfd <strlen+0x20>
        ++n;
   43cf3:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; *s != '\0'; ++s) {
   43cf8:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
   43cfd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43d01:	0f b6 00             	movzbl (%rax),%eax
   43d04:	84 c0                	test   %al,%al
   43d06:	75 eb                	jne    43cf3 <strlen+0x16>
    }
    return n;
   43d08:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
   43d0c:	c9                   	leave
   43d0d:	c3                   	ret

0000000000043d0e <strnlen>:

size_t strnlen(const char* s, size_t maxlen) {
   43d0e:	55                   	push   %rbp
   43d0f:	48 89 e5             	mov    %rsp,%rbp
   43d12:	48 83 ec 20          	sub    $0x20,%rsp
   43d16:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   43d1a:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    size_t n;
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
   43d1e:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   43d25:	00 
   43d26:	eb 0a                	jmp    43d32 <strnlen+0x24>
        ++n;
   43d28:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
   43d2d:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
   43d32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43d36:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
   43d3a:	74 0b                	je     43d47 <strnlen+0x39>
   43d3c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43d40:	0f b6 00             	movzbl (%rax),%eax
   43d43:	84 c0                	test   %al,%al
   43d45:	75 e1                	jne    43d28 <strnlen+0x1a>
    }
    return n;
   43d47:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
   43d4b:	c9                   	leave
   43d4c:	c3                   	ret

0000000000043d4d <strcpy>:

char* strcpy(char* dst, const char* src) {
   43d4d:	55                   	push   %rbp
   43d4e:	48 89 e5             	mov    %rsp,%rbp
   43d51:	48 83 ec 20          	sub    $0x20,%rsp
   43d55:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   43d59:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    char* d = dst;
   43d5d:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43d61:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    do {
        *d++ = *src++;
   43d65:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   43d69:	48 8d 42 01          	lea    0x1(%rdx),%rax
   43d6d:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
   43d71:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43d75:	48 8d 48 01          	lea    0x1(%rax),%rcx
   43d79:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
   43d7d:	0f b6 12             	movzbl (%rdx),%edx
   43d80:	88 10                	mov    %dl,(%rax)
    } while (d[-1]);
   43d82:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43d86:	48 83 e8 01          	sub    $0x1,%rax
   43d8a:	0f b6 00             	movzbl (%rax),%eax
   43d8d:	84 c0                	test   %al,%al
   43d8f:	75 d4                	jne    43d65 <strcpy+0x18>
    return dst;
   43d91:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
   43d95:	c9                   	leave
   43d96:	c3                   	ret

0000000000043d97 <strcmp>:

int strcmp(const char* a, const char* b) {
   43d97:	55                   	push   %rbp
   43d98:	48 89 e5             	mov    %rsp,%rbp
   43d9b:	48 83 ec 10          	sub    $0x10,%rsp
   43d9f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   43da3:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    while (*a && *b && *a == *b) {
   43da7:	eb 0a                	jmp    43db3 <strcmp+0x1c>
        ++a, ++b;
   43da9:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
   43dae:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
    while (*a && *b && *a == *b) {
   43db3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43db7:	0f b6 00             	movzbl (%rax),%eax
   43dba:	84 c0                	test   %al,%al
   43dbc:	74 1d                	je     43ddb <strcmp+0x44>
   43dbe:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43dc2:	0f b6 00             	movzbl (%rax),%eax
   43dc5:	84 c0                	test   %al,%al
   43dc7:	74 12                	je     43ddb <strcmp+0x44>
   43dc9:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43dcd:	0f b6 10             	movzbl (%rax),%edx
   43dd0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43dd4:	0f b6 00             	movzbl (%rax),%eax
   43dd7:	38 c2                	cmp    %al,%dl
   43dd9:	74 ce                	je     43da9 <strcmp+0x12>
    }
    return ((unsigned char) *a > (unsigned char) *b)
   43ddb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43ddf:	0f b6 00             	movzbl (%rax),%eax
   43de2:	89 c2                	mov    %eax,%edx
   43de4:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43de8:	0f b6 00             	movzbl (%rax),%eax
   43deb:	38 d0                	cmp    %dl,%al
   43ded:	0f 92 c0             	setb   %al
   43df0:	0f b6 d0             	movzbl %al,%edx
        - ((unsigned char) *a < (unsigned char) *b);
   43df3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43df7:	0f b6 00             	movzbl (%rax),%eax
   43dfa:	89 c1                	mov    %eax,%ecx
   43dfc:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43e00:	0f b6 00             	movzbl (%rax),%eax
   43e03:	38 c1                	cmp    %al,%cl
   43e05:	0f 92 c0             	setb   %al
   43e08:	0f b6 c0             	movzbl %al,%eax
   43e0b:	29 c2                	sub    %eax,%edx
   43e0d:	89 d0                	mov    %edx,%eax
}
   43e0f:	c9                   	leave
   43e10:	c3                   	ret

0000000000043e11 <strchr>:

char* strchr(const char* s, int c) {
   43e11:	55                   	push   %rbp
   43e12:	48 89 e5             	mov    %rsp,%rbp
   43e15:	48 83 ec 10          	sub    $0x10,%rsp
   43e19:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   43e1d:	89 75 f4             	mov    %esi,-0xc(%rbp)
    while (*s && *s != (char) c) {
   43e20:	eb 05                	jmp    43e27 <strchr+0x16>
        ++s;
   43e22:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while (*s && *s != (char) c) {
   43e27:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43e2b:	0f b6 00             	movzbl (%rax),%eax
   43e2e:	84 c0                	test   %al,%al
   43e30:	74 0e                	je     43e40 <strchr+0x2f>
   43e32:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43e36:	0f b6 00             	movzbl (%rax),%eax
   43e39:	8b 55 f4             	mov    -0xc(%rbp),%edx
   43e3c:	38 d0                	cmp    %dl,%al
   43e3e:	75 e2                	jne    43e22 <strchr+0x11>
    }
    if (*s == (char) c) {
   43e40:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43e44:	0f b6 00             	movzbl (%rax),%eax
   43e47:	8b 55 f4             	mov    -0xc(%rbp),%edx
   43e4a:	38 d0                	cmp    %dl,%al
   43e4c:	75 06                	jne    43e54 <strchr+0x43>
        return (char*) s;
   43e4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43e52:	eb 05                	jmp    43e59 <strchr+0x48>
    } else {
        return NULL;
   43e54:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
   43e59:	c9                   	leave
   43e5a:	c3                   	ret

0000000000043e5b <rand>:
// rand, srand

static int rand_seed_set;
static unsigned rand_seed;

int rand(void) {
   43e5b:	55                   	push   %rbp
   43e5c:	48 89 e5             	mov    %rsp,%rbp
    if (!rand_seed_set) {
   43e5f:	8b 05 a3 31 01 00    	mov    0x131a3(%rip),%eax        # 57008 <rand_seed_set>
   43e65:	85 c0                	test   %eax,%eax
   43e67:	75 0a                	jne    43e73 <rand+0x18>
        srand(819234718U);
   43e69:	bf 9e 87 d4 30       	mov    $0x30d4879e,%edi
   43e6e:	e8 24 00 00 00       	call   43e97 <srand>
    }
    rand_seed = rand_seed * 1664525U + 1013904223U;
   43e73:	8b 05 93 31 01 00    	mov    0x13193(%rip),%eax        # 5700c <rand_seed>
   43e79:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
   43e7f:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
   43e84:	89 05 82 31 01 00    	mov    %eax,0x13182(%rip)        # 5700c <rand_seed>
    return rand_seed & RAND_MAX;
   43e8a:	8b 05 7c 31 01 00    	mov    0x1317c(%rip),%eax        # 5700c <rand_seed>
   43e90:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
   43e95:	5d                   	pop    %rbp
   43e96:	c3                   	ret

0000000000043e97 <srand>:

void srand(unsigned seed) {
   43e97:	55                   	push   %rbp
   43e98:	48 89 e5             	mov    %rsp,%rbp
   43e9b:	48 83 ec 08          	sub    $0x8,%rsp
   43e9f:	89 7d fc             	mov    %edi,-0x4(%rbp)
    rand_seed = seed;
   43ea2:	8b 45 fc             	mov    -0x4(%rbp),%eax
   43ea5:	89 05 61 31 01 00    	mov    %eax,0x13161(%rip)        # 5700c <rand_seed>
    rand_seed_set = 1;
   43eab:	c7 05 53 31 01 00 01 	movl   $0x1,0x13153(%rip)        # 57008 <rand_seed_set>
   43eb2:	00 00 00 
}
   43eb5:	90                   	nop
   43eb6:	c9                   	leave
   43eb7:	c3                   	ret

0000000000043eb8 <fill_numbuf>:
//    Print a message onto the console, starting at the given cursor position.

// snprintf, vsnprintf
//    Format a string into a buffer.

static char* fill_numbuf(char* numbuf_end, unsigned long val, int base) {
   43eb8:	55                   	push   %rbp
   43eb9:	48 89 e5             	mov    %rsp,%rbp
   43ebc:	48 83 ec 28          	sub    $0x28,%rsp
   43ec0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   43ec4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
   43ec8:	89 55 dc             	mov    %edx,-0x24(%rbp)
    static const char upper_digits[] = "0123456789ABCDEF";
    static const char lower_digits[] = "0123456789abcdef";

    const char* digits = upper_digits;
   43ecb:	48 c7 45 f8 60 5a 04 	movq   $0x45a60,-0x8(%rbp)
   43ed2:	00 
    if (base < 0) {
   43ed3:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   43ed7:	79 0b                	jns    43ee4 <fill_numbuf+0x2c>
        digits = lower_digits;
   43ed9:	48 c7 45 f8 80 5a 04 	movq   $0x45a80,-0x8(%rbp)
   43ee0:	00 
        base = -base;
   43ee1:	f7 5d dc             	negl   -0x24(%rbp)
    }

    *--numbuf_end = '\0';
   43ee4:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
   43ee9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43eed:	c6 00 00             	movb   $0x0,(%rax)
    do {
        *--numbuf_end = digits[val % base];
   43ef0:	8b 45 dc             	mov    -0x24(%rbp),%eax
   43ef3:	48 63 c8             	movslq %eax,%rcx
   43ef6:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43efa:	ba 00 00 00 00       	mov    $0x0,%edx
   43eff:	48 f7 f1             	div    %rcx
   43f02:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43f06:	48 01 d0             	add    %rdx,%rax
   43f09:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
   43f0e:	0f b6 10             	movzbl (%rax),%edx
   43f11:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43f15:	88 10                	mov    %dl,(%rax)
        val /= base;
   43f17:	8b 45 dc             	mov    -0x24(%rbp),%eax
   43f1a:	48 63 f0             	movslq %eax,%rsi
   43f1d:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43f21:	ba 00 00 00 00       	mov    $0x0,%edx
   43f26:	48 f7 f6             	div    %rsi
   43f29:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    } while (val != 0);
   43f2d:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   43f32:	75 bc                	jne    43ef0 <fill_numbuf+0x38>
    return numbuf_end;
   43f34:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
   43f38:	c9                   	leave
   43f39:	c3                   	ret

0000000000043f3a <printer_vprintf>:
#define FLAG_NUMERIC            (1<<5)
#define FLAG_SIGNED             (1<<6)
#define FLAG_NEGATIVE           (1<<7)
#define FLAG_ALT2               (1<<8)

void printer_vprintf(printer* p, int color, const char* format, va_list val) {
   43f3a:	55                   	push   %rbp
   43f3b:	48 89 e5             	mov    %rsp,%rbp
   43f3e:	53                   	push   %rbx
   43f3f:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
   43f46:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
   43f4d:	89 b5 74 ff ff ff    	mov    %esi,-0x8c(%rbp)
   43f53:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
   43f5a:	48 89 8d 60 ff ff ff 	mov    %rcx,-0xa0(%rbp)
#define NUMBUFSIZ 24
    char numbuf[NUMBUFSIZ];

    for (; *format; ++format) {
   43f61:	e9 8a 09 00 00       	jmp    448f0 <printer_vprintf+0x9b6>
        if (*format != '%') {
   43f66:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43f6d:	0f b6 00             	movzbl (%rax),%eax
   43f70:	3c 25                	cmp    $0x25,%al
   43f72:	74 31                	je     43fa5 <printer_vprintf+0x6b>
            p->putc(p, *format, color);
   43f74:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   43f7b:	4c 8b 00             	mov    (%rax),%r8
   43f7e:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43f85:	0f b6 00             	movzbl (%rax),%eax
   43f88:	0f b6 c8             	movzbl %al,%ecx
   43f8b:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
   43f91:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   43f98:	89 ce                	mov    %ecx,%esi
   43f9a:	48 89 c7             	mov    %rax,%rdi
   43f9d:	41 ff d0             	call   *%r8
            continue;
   43fa0:	e9 43 09 00 00       	jmp    448e8 <printer_vprintf+0x9ae>
        }

        // process flags
        int flags = 0;
   43fa5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        for (++format; *format; ++format) {
   43fac:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   43fb3:	01 
   43fb4:	eb 44                	jmp    43ffa <printer_vprintf+0xc0>
            const char* flagc = strchr(flag_chars, *format);
   43fb6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43fbd:	0f b6 00             	movzbl (%rax),%eax
   43fc0:	0f be c0             	movsbl %al,%eax
   43fc3:	89 c6                	mov    %eax,%esi
   43fc5:	bf 80 58 04 00       	mov    $0x45880,%edi
   43fca:	e8 42 fe ff ff       	call   43e11 <strchr>
   43fcf:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (flagc) {
   43fd3:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
   43fd8:	74 30                	je     4400a <printer_vprintf+0xd0>
                flags |= 1 << (flagc - flag_chars);
   43fda:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   43fde:	48 2d 80 58 04 00    	sub    $0x45880,%rax
   43fe4:	ba 01 00 00 00       	mov    $0x1,%edx
   43fe9:	89 c1                	mov    %eax,%ecx
   43feb:	d3 e2                	shl    %cl,%edx
   43fed:	89 d0                	mov    %edx,%eax
   43fef:	09 45 ec             	or     %eax,-0x14(%rbp)
        for (++format; *format; ++format) {
   43ff2:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   43ff9:	01 
   43ffa:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   44001:	0f b6 00             	movzbl (%rax),%eax
   44004:	84 c0                	test   %al,%al
   44006:	75 ae                	jne    43fb6 <printer_vprintf+0x7c>
   44008:	eb 01                	jmp    4400b <printer_vprintf+0xd1>
            } else {
                break;
   4400a:	90                   	nop
            }
        }

        // process width
        int width = -1;
   4400b:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
        if (*format >= '1' && *format <= '9') {
   44012:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   44019:	0f b6 00             	movzbl (%rax),%eax
   4401c:	3c 30                	cmp    $0x30,%al
   4401e:	7e 67                	jle    44087 <printer_vprintf+0x14d>
   44020:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   44027:	0f b6 00             	movzbl (%rax),%eax
   4402a:	3c 39                	cmp    $0x39,%al
   4402c:	7f 59                	jg     44087 <printer_vprintf+0x14d>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   4402e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
   44035:	eb 2e                	jmp    44065 <printer_vprintf+0x12b>
                width = 10 * width + *format++ - '0';
   44037:	8b 55 e8             	mov    -0x18(%rbp),%edx
   4403a:	89 d0                	mov    %edx,%eax
   4403c:	c1 e0 02             	shl    $0x2,%eax
   4403f:	01 d0                	add    %edx,%eax
   44041:	01 c0                	add    %eax,%eax
   44043:	89 c1                	mov    %eax,%ecx
   44045:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   4404c:	48 8d 50 01          	lea    0x1(%rax),%rdx
   44050:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
   44057:	0f b6 00             	movzbl (%rax),%eax
   4405a:	0f be c0             	movsbl %al,%eax
   4405d:	01 c8                	add    %ecx,%eax
   4405f:	83 e8 30             	sub    $0x30,%eax
   44062:	89 45 e8             	mov    %eax,-0x18(%rbp)
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   44065:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   4406c:	0f b6 00             	movzbl (%rax),%eax
   4406f:	3c 2f                	cmp    $0x2f,%al
   44071:	0f 8e 85 00 00 00    	jle    440fc <printer_vprintf+0x1c2>
   44077:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   4407e:	0f b6 00             	movzbl (%rax),%eax
   44081:	3c 39                	cmp    $0x39,%al
   44083:	7e b2                	jle    44037 <printer_vprintf+0xfd>
        if (*format >= '1' && *format <= '9') {
   44085:	eb 75                	jmp    440fc <printer_vprintf+0x1c2>
            }
        } else if (*format == '*') {
   44087:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   4408e:	0f b6 00             	movzbl (%rax),%eax
   44091:	3c 2a                	cmp    $0x2a,%al
   44093:	75 68                	jne    440fd <printer_vprintf+0x1c3>
            width = va_arg(val, int);
   44095:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   4409c:	8b 00                	mov    (%rax),%eax
   4409e:	83 f8 2f             	cmp    $0x2f,%eax
   440a1:	77 30                	ja     440d3 <printer_vprintf+0x199>
   440a3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   440aa:	48 8b 50 10          	mov    0x10(%rax),%rdx
   440ae:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   440b5:	8b 00                	mov    (%rax),%eax
   440b7:	89 c0                	mov    %eax,%eax
   440b9:	48 01 d0             	add    %rdx,%rax
   440bc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   440c3:	8b 12                	mov    (%rdx),%edx
   440c5:	8d 4a 08             	lea    0x8(%rdx),%ecx
   440c8:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   440cf:	89 0a                	mov    %ecx,(%rdx)
   440d1:	eb 1a                	jmp    440ed <printer_vprintf+0x1b3>
   440d3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   440da:	48 8b 40 08          	mov    0x8(%rax),%rax
   440de:	48 8d 48 08          	lea    0x8(%rax),%rcx
   440e2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   440e9:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   440ed:	8b 00                	mov    (%rax),%eax
   440ef:	89 45 e8             	mov    %eax,-0x18(%rbp)
            ++format;
   440f2:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   440f9:	01 
   440fa:	eb 01                	jmp    440fd <printer_vprintf+0x1c3>
        if (*format >= '1' && *format <= '9') {
   440fc:	90                   	nop
        }

        // process precision
        int precision = -1;
   440fd:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
        if (*format == '.') {
   44104:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   4410b:	0f b6 00             	movzbl (%rax),%eax
   4410e:	3c 2e                	cmp    $0x2e,%al
   44110:	0f 85 00 01 00 00    	jne    44216 <printer_vprintf+0x2dc>
            ++format;
   44116:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   4411d:	01 
            if (*format >= '0' && *format <= '9') {
   4411e:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   44125:	0f b6 00             	movzbl (%rax),%eax
   44128:	3c 2f                	cmp    $0x2f,%al
   4412a:	7e 67                	jle    44193 <printer_vprintf+0x259>
   4412c:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   44133:	0f b6 00             	movzbl (%rax),%eax
   44136:	3c 39                	cmp    $0x39,%al
   44138:	7f 59                	jg     44193 <printer_vprintf+0x259>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
   4413a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
   44141:	eb 2e                	jmp    44171 <printer_vprintf+0x237>
                    precision = 10 * precision + *format++ - '0';
   44143:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   44146:	89 d0                	mov    %edx,%eax
   44148:	c1 e0 02             	shl    $0x2,%eax
   4414b:	01 d0                	add    %edx,%eax
   4414d:	01 c0                	add    %eax,%eax
   4414f:	89 c1                	mov    %eax,%ecx
   44151:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   44158:	48 8d 50 01          	lea    0x1(%rax),%rdx
   4415c:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
   44163:	0f b6 00             	movzbl (%rax),%eax
   44166:	0f be c0             	movsbl %al,%eax
   44169:	01 c8                	add    %ecx,%eax
   4416b:	83 e8 30             	sub    $0x30,%eax
   4416e:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
   44171:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   44178:	0f b6 00             	movzbl (%rax),%eax
   4417b:	3c 2f                	cmp    $0x2f,%al
   4417d:	0f 8e 85 00 00 00    	jle    44208 <printer_vprintf+0x2ce>
   44183:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   4418a:	0f b6 00             	movzbl (%rax),%eax
   4418d:	3c 39                	cmp    $0x39,%al
   4418f:	7e b2                	jle    44143 <printer_vprintf+0x209>
            if (*format >= '0' && *format <= '9') {
   44191:	eb 75                	jmp    44208 <printer_vprintf+0x2ce>
                }
            } else if (*format == '*') {
   44193:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   4419a:	0f b6 00             	movzbl (%rax),%eax
   4419d:	3c 2a                	cmp    $0x2a,%al
   4419f:	75 68                	jne    44209 <printer_vprintf+0x2cf>
                precision = va_arg(val, int);
   441a1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   441a8:	8b 00                	mov    (%rax),%eax
   441aa:	83 f8 2f             	cmp    $0x2f,%eax
   441ad:	77 30                	ja     441df <printer_vprintf+0x2a5>
   441af:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   441b6:	48 8b 50 10          	mov    0x10(%rax),%rdx
   441ba:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   441c1:	8b 00                	mov    (%rax),%eax
   441c3:	89 c0                	mov    %eax,%eax
   441c5:	48 01 d0             	add    %rdx,%rax
   441c8:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   441cf:	8b 12                	mov    (%rdx),%edx
   441d1:	8d 4a 08             	lea    0x8(%rdx),%ecx
   441d4:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   441db:	89 0a                	mov    %ecx,(%rdx)
   441dd:	eb 1a                	jmp    441f9 <printer_vprintf+0x2bf>
   441df:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   441e6:	48 8b 40 08          	mov    0x8(%rax),%rax
   441ea:	48 8d 48 08          	lea    0x8(%rax),%rcx
   441ee:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   441f5:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   441f9:	8b 00                	mov    (%rax),%eax
   441fb:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                ++format;
   441fe:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   44205:	01 
   44206:	eb 01                	jmp    44209 <printer_vprintf+0x2cf>
            if (*format >= '0' && *format <= '9') {
   44208:	90                   	nop
            }
            if (precision < 0) {
   44209:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
   4420d:	79 07                	jns    44216 <printer_vprintf+0x2dc>
                precision = 0;
   4420f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
            }
        }

        // process main conversion character
        int base = 10;
   44216:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%rbp)
        unsigned long num = 0;
   4421d:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
   44224:	00 
        int length = 0;
   44225:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
        char* data = "";
   4422c:	48 c7 45 c8 86 58 04 	movq   $0x45886,-0x38(%rbp)
   44233:	00 
    again:
        switch (*format) {
   44234:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   4423b:	0f b6 00             	movzbl (%rax),%eax
   4423e:	0f be c0             	movsbl %al,%eax
   44241:	83 e8 43             	sub    $0x43,%eax
   44244:	83 f8 37             	cmp    $0x37,%eax
   44247:	0f 87 9f 03 00 00    	ja     445ec <printer_vprintf+0x6b2>
   4424d:	89 c0                	mov    %eax,%eax
   4424f:	48 8b 04 c5 98 58 04 	mov    0x45898(,%rax,8),%rax
   44256:	00 
   44257:	ff e0                	jmp    *%rax
        case 'l':
        case 'z':
            length = 1;
   44259:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
            ++format;
   44260:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   44267:	01 
            goto again;
   44268:	eb ca                	jmp    44234 <printer_vprintf+0x2fa>
        case 'd':
        case 'i': {
            long x = length ? va_arg(val, long) : va_arg(val, int);
   4426a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
   4426e:	74 5d                	je     442cd <printer_vprintf+0x393>
   44270:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   44277:	8b 00                	mov    (%rax),%eax
   44279:	83 f8 2f             	cmp    $0x2f,%eax
   4427c:	77 30                	ja     442ae <printer_vprintf+0x374>
   4427e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   44285:	48 8b 50 10          	mov    0x10(%rax),%rdx
   44289:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   44290:	8b 00                	mov    (%rax),%eax
   44292:	89 c0                	mov    %eax,%eax
   44294:	48 01 d0             	add    %rdx,%rax
   44297:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   4429e:	8b 12                	mov    (%rdx),%edx
   442a0:	8d 4a 08             	lea    0x8(%rdx),%ecx
   442a3:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   442aa:	89 0a                	mov    %ecx,(%rdx)
   442ac:	eb 1a                	jmp    442c8 <printer_vprintf+0x38e>
   442ae:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   442b5:	48 8b 40 08          	mov    0x8(%rax),%rax
   442b9:	48 8d 48 08          	lea    0x8(%rax),%rcx
   442bd:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   442c4:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   442c8:	48 8b 00             	mov    (%rax),%rax
   442cb:	eb 5c                	jmp    44329 <printer_vprintf+0x3ef>
   442cd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   442d4:	8b 00                	mov    (%rax),%eax
   442d6:	83 f8 2f             	cmp    $0x2f,%eax
   442d9:	77 30                	ja     4430b <printer_vprintf+0x3d1>
   442db:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   442e2:	48 8b 50 10          	mov    0x10(%rax),%rdx
   442e6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   442ed:	8b 00                	mov    (%rax),%eax
   442ef:	89 c0                	mov    %eax,%eax
   442f1:	48 01 d0             	add    %rdx,%rax
   442f4:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   442fb:	8b 12                	mov    (%rdx),%edx
   442fd:	8d 4a 08             	lea    0x8(%rdx),%ecx
   44300:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   44307:	89 0a                	mov    %ecx,(%rdx)
   44309:	eb 1a                	jmp    44325 <printer_vprintf+0x3eb>
   4430b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   44312:	48 8b 40 08          	mov    0x8(%rax),%rax
   44316:	48 8d 48 08          	lea    0x8(%rax),%rcx
   4431a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   44321:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   44325:	8b 00                	mov    (%rax),%eax
   44327:	48 98                	cltq
   44329:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
   4432d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   44331:	48 c1 f8 38          	sar    $0x38,%rax
   44335:	25 80 00 00 00       	and    $0x80,%eax
   4433a:	89 45 a4             	mov    %eax,-0x5c(%rbp)
            num = negative ? -x : x;
   4433d:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
   44341:	74 09                	je     4434c <printer_vprintf+0x412>
   44343:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   44347:	48 f7 d8             	neg    %rax
   4434a:	eb 04                	jmp    44350 <printer_vprintf+0x416>
   4434c:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   44350:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
   44354:	8b 45 a4             	mov    -0x5c(%rbp),%eax
   44357:	83 c8 60             	or     $0x60,%eax
   4435a:	09 45 ec             	or     %eax,-0x14(%rbp)
            break;
   4435d:	e9 cf 02 00 00       	jmp    44631 <printer_vprintf+0x6f7>
        }
        case 'u':
        format_unsigned:
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
   44362:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
   44366:	74 5d                	je     443c5 <printer_vprintf+0x48b>
   44368:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   4436f:	8b 00                	mov    (%rax),%eax
   44371:	83 f8 2f             	cmp    $0x2f,%eax
   44374:	77 30                	ja     443a6 <printer_vprintf+0x46c>
   44376:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   4437d:	48 8b 50 10          	mov    0x10(%rax),%rdx
   44381:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   44388:	8b 00                	mov    (%rax),%eax
   4438a:	89 c0                	mov    %eax,%eax
   4438c:	48 01 d0             	add    %rdx,%rax
   4438f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   44396:	8b 12                	mov    (%rdx),%edx
   44398:	8d 4a 08             	lea    0x8(%rdx),%ecx
   4439b:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   443a2:	89 0a                	mov    %ecx,(%rdx)
   443a4:	eb 1a                	jmp    443c0 <printer_vprintf+0x486>
   443a6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   443ad:	48 8b 40 08          	mov    0x8(%rax),%rax
   443b1:	48 8d 48 08          	lea    0x8(%rax),%rcx
   443b5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   443bc:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   443c0:	48 8b 00             	mov    (%rax),%rax
   443c3:	eb 5c                	jmp    44421 <printer_vprintf+0x4e7>
   443c5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   443cc:	8b 00                	mov    (%rax),%eax
   443ce:	83 f8 2f             	cmp    $0x2f,%eax
   443d1:	77 30                	ja     44403 <printer_vprintf+0x4c9>
   443d3:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   443da:	48 8b 50 10          	mov    0x10(%rax),%rdx
   443de:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   443e5:	8b 00                	mov    (%rax),%eax
   443e7:	89 c0                	mov    %eax,%eax
   443e9:	48 01 d0             	add    %rdx,%rax
   443ec:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   443f3:	8b 12                	mov    (%rdx),%edx
   443f5:	8d 4a 08             	lea    0x8(%rdx),%ecx
   443f8:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   443ff:	89 0a                	mov    %ecx,(%rdx)
   44401:	eb 1a                	jmp    4441d <printer_vprintf+0x4e3>
   44403:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   4440a:	48 8b 40 08          	mov    0x8(%rax),%rax
   4440e:	48 8d 48 08          	lea    0x8(%rax),%rcx
   44412:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   44419:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   4441d:	8b 00                	mov    (%rax),%eax
   4441f:	89 c0                	mov    %eax,%eax
   44421:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC;
   44425:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
            break;
   44429:	e9 03 02 00 00       	jmp    44631 <printer_vprintf+0x6f7>
        case 'x':
            base = -16;
   4442e:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            goto format_unsigned;
   44435:	e9 28 ff ff ff       	jmp    44362 <printer_vprintf+0x428>
        case 'X':
            base = 16;
   4443a:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%rbp)
            goto format_unsigned;
   44441:	e9 1c ff ff ff       	jmp    44362 <printer_vprintf+0x428>
        case 'p':
            num = (uintptr_t) va_arg(val, void*);
   44446:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   4444d:	8b 00                	mov    (%rax),%eax
   4444f:	83 f8 2f             	cmp    $0x2f,%eax
   44452:	77 30                	ja     44484 <printer_vprintf+0x54a>
   44454:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   4445b:	48 8b 50 10          	mov    0x10(%rax),%rdx
   4445f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   44466:	8b 00                	mov    (%rax),%eax
   44468:	89 c0                	mov    %eax,%eax
   4446a:	48 01 d0             	add    %rdx,%rax
   4446d:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   44474:	8b 12                	mov    (%rdx),%edx
   44476:	8d 4a 08             	lea    0x8(%rdx),%ecx
   44479:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   44480:	89 0a                	mov    %ecx,(%rdx)
   44482:	eb 1a                	jmp    4449e <printer_vprintf+0x564>
   44484:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   4448b:	48 8b 40 08          	mov    0x8(%rax),%rax
   4448f:	48 8d 48 08          	lea    0x8(%rax),%rcx
   44493:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   4449a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   4449e:	48 8b 00             	mov    (%rax),%rax
   444a1:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            base = -16;
   444a5:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
   444ac:	81 4d ec 21 01 00 00 	orl    $0x121,-0x14(%rbp)
            break;
   444b3:	e9 79 01 00 00       	jmp    44631 <printer_vprintf+0x6f7>
        case 's':
            data = va_arg(val, char*);
   444b8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   444bf:	8b 00                	mov    (%rax),%eax
   444c1:	83 f8 2f             	cmp    $0x2f,%eax
   444c4:	77 30                	ja     444f6 <printer_vprintf+0x5bc>
   444c6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   444cd:	48 8b 50 10          	mov    0x10(%rax),%rdx
   444d1:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   444d8:	8b 00                	mov    (%rax),%eax
   444da:	89 c0                	mov    %eax,%eax
   444dc:	48 01 d0             	add    %rdx,%rax
   444df:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   444e6:	8b 12                	mov    (%rdx),%edx
   444e8:	8d 4a 08             	lea    0x8(%rdx),%ecx
   444eb:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   444f2:	89 0a                	mov    %ecx,(%rdx)
   444f4:	eb 1a                	jmp    44510 <printer_vprintf+0x5d6>
   444f6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   444fd:	48 8b 40 08          	mov    0x8(%rax),%rax
   44501:	48 8d 48 08          	lea    0x8(%rax),%rcx
   44505:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   4450c:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   44510:	48 8b 00             	mov    (%rax),%rax
   44513:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            break;
   44517:	e9 15 01 00 00       	jmp    44631 <printer_vprintf+0x6f7>
        case 'C':
            color = va_arg(val, int);
   4451c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   44523:	8b 00                	mov    (%rax),%eax
   44525:	83 f8 2f             	cmp    $0x2f,%eax
   44528:	77 30                	ja     4455a <printer_vprintf+0x620>
   4452a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   44531:	48 8b 50 10          	mov    0x10(%rax),%rdx
   44535:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   4453c:	8b 00                	mov    (%rax),%eax
   4453e:	89 c0                	mov    %eax,%eax
   44540:	48 01 d0             	add    %rdx,%rax
   44543:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   4454a:	8b 12                	mov    (%rdx),%edx
   4454c:	8d 4a 08             	lea    0x8(%rdx),%ecx
   4454f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   44556:	89 0a                	mov    %ecx,(%rdx)
   44558:	eb 1a                	jmp    44574 <printer_vprintf+0x63a>
   4455a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   44561:	48 8b 40 08          	mov    0x8(%rax),%rax
   44565:	48 8d 48 08          	lea    0x8(%rax),%rcx
   44569:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   44570:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   44574:	8b 00                	mov    (%rax),%eax
   44576:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
            goto done;
   4457c:	e9 67 03 00 00       	jmp    448e8 <printer_vprintf+0x9ae>
        case 'c':
            data = numbuf;
   44581:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
   44585:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = va_arg(val, int);
   44589:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   44590:	8b 00                	mov    (%rax),%eax
   44592:	83 f8 2f             	cmp    $0x2f,%eax
   44595:	77 30                	ja     445c7 <printer_vprintf+0x68d>
   44597:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   4459e:	48 8b 50 10          	mov    0x10(%rax),%rdx
   445a2:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   445a9:	8b 00                	mov    (%rax),%eax
   445ab:	89 c0                	mov    %eax,%eax
   445ad:	48 01 d0             	add    %rdx,%rax
   445b0:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   445b7:	8b 12                	mov    (%rdx),%edx
   445b9:	8d 4a 08             	lea    0x8(%rdx),%ecx
   445bc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   445c3:	89 0a                	mov    %ecx,(%rdx)
   445c5:	eb 1a                	jmp    445e1 <printer_vprintf+0x6a7>
   445c7:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   445ce:	48 8b 40 08          	mov    0x8(%rax),%rax
   445d2:	48 8d 48 08          	lea    0x8(%rax),%rcx
   445d6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   445dd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   445e1:	8b 00                	mov    (%rax),%eax
   445e3:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
   445e6:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            break;
   445ea:	eb 45                	jmp    44631 <printer_vprintf+0x6f7>
        default:
            data = numbuf;
   445ec:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
   445f0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = (*format ? *format : '%');
   445f4:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   445fb:	0f b6 00             	movzbl (%rax),%eax
   445fe:	84 c0                	test   %al,%al
   44600:	74 0c                	je     4460e <printer_vprintf+0x6d4>
   44602:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   44609:	0f b6 00             	movzbl (%rax),%eax
   4460c:	eb 05                	jmp    44613 <printer_vprintf+0x6d9>
   4460e:	b8 25 00 00 00       	mov    $0x25,%eax
   44613:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
   44616:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            if (!*format) {
   4461a:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   44621:	0f b6 00             	movzbl (%rax),%eax
   44624:	84 c0                	test   %al,%al
   44626:	75 08                	jne    44630 <printer_vprintf+0x6f6>
                format--;
   44628:	48 83 ad 68 ff ff ff 	subq   $0x1,-0x98(%rbp)
   4462f:	01 
            }
            break;
   44630:	90                   	nop
        }

        if (flags & FLAG_NUMERIC) {
   44631:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44634:	83 e0 20             	and    $0x20,%eax
   44637:	85 c0                	test   %eax,%eax
   44639:	74 1e                	je     44659 <printer_vprintf+0x71f>
            data = fill_numbuf(numbuf + NUMBUFSIZ, num, base);
   4463b:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
   4463f:	48 83 c0 18          	add    $0x18,%rax
   44643:	8b 55 e0             	mov    -0x20(%rbp),%edx
   44646:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
   4464a:	48 89 ce             	mov    %rcx,%rsi
   4464d:	48 89 c7             	mov    %rax,%rdi
   44650:	e8 63 f8 ff ff       	call   43eb8 <fill_numbuf>
   44655:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        }

        const char* prefix = "";
   44659:	48 c7 45 c0 86 58 04 	movq   $0x45886,-0x40(%rbp)
   44660:	00 
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
   44661:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44664:	83 e0 20             	and    $0x20,%eax
   44667:	85 c0                	test   %eax,%eax
   44669:	74 48                	je     446b3 <printer_vprintf+0x779>
   4466b:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4466e:	83 e0 40             	and    $0x40,%eax
   44671:	85 c0                	test   %eax,%eax
   44673:	74 3e                	je     446b3 <printer_vprintf+0x779>
            if (flags & FLAG_NEGATIVE) {
   44675:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44678:	25 80 00 00 00       	and    $0x80,%eax
   4467d:	85 c0                	test   %eax,%eax
   4467f:	74 0a                	je     4468b <printer_vprintf+0x751>
                prefix = "-";
   44681:	48 c7 45 c0 87 58 04 	movq   $0x45887,-0x40(%rbp)
   44688:	00 
            if (flags & FLAG_NEGATIVE) {
   44689:	eb 73                	jmp    446fe <printer_vprintf+0x7c4>
            } else if (flags & FLAG_PLUSPOSITIVE) {
   4468b:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4468e:	83 e0 10             	and    $0x10,%eax
   44691:	85 c0                	test   %eax,%eax
   44693:	74 0a                	je     4469f <printer_vprintf+0x765>
                prefix = "+";
   44695:	48 c7 45 c0 89 58 04 	movq   $0x45889,-0x40(%rbp)
   4469c:	00 
            if (flags & FLAG_NEGATIVE) {
   4469d:	eb 5f                	jmp    446fe <printer_vprintf+0x7c4>
            } else if (flags & FLAG_SPACEPOSITIVE) {
   4469f:	8b 45 ec             	mov    -0x14(%rbp),%eax
   446a2:	83 e0 08             	and    $0x8,%eax
   446a5:	85 c0                	test   %eax,%eax
   446a7:	74 55                	je     446fe <printer_vprintf+0x7c4>
                prefix = " ";
   446a9:	48 c7 45 c0 8b 58 04 	movq   $0x4588b,-0x40(%rbp)
   446b0:	00 
            if (flags & FLAG_NEGATIVE) {
   446b1:	eb 4b                	jmp    446fe <printer_vprintf+0x7c4>
            }
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
   446b3:	8b 45 ec             	mov    -0x14(%rbp),%eax
   446b6:	83 e0 20             	and    $0x20,%eax
   446b9:	85 c0                	test   %eax,%eax
   446bb:	74 42                	je     446ff <printer_vprintf+0x7c5>
   446bd:	8b 45 ec             	mov    -0x14(%rbp),%eax
   446c0:	83 e0 01             	and    $0x1,%eax
   446c3:	85 c0                	test   %eax,%eax
   446c5:	74 38                	je     446ff <printer_vprintf+0x7c5>
                   && (base == 16 || base == -16)
   446c7:	83 7d e0 10          	cmpl   $0x10,-0x20(%rbp)
   446cb:	74 06                	je     446d3 <printer_vprintf+0x799>
   446cd:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
   446d1:	75 2c                	jne    446ff <printer_vprintf+0x7c5>
                   && (num || (flags & FLAG_ALT2))) {
   446d3:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   446d8:	75 0c                	jne    446e6 <printer_vprintf+0x7ac>
   446da:	8b 45 ec             	mov    -0x14(%rbp),%eax
   446dd:	25 00 01 00 00       	and    $0x100,%eax
   446e2:	85 c0                	test   %eax,%eax
   446e4:	74 19                	je     446ff <printer_vprintf+0x7c5>
            prefix = (base == -16 ? "0x" : "0X");
   446e6:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
   446ea:	75 07                	jne    446f3 <printer_vprintf+0x7b9>
   446ec:	b8 8d 58 04 00       	mov    $0x4588d,%eax
   446f1:	eb 05                	jmp    446f8 <printer_vprintf+0x7be>
   446f3:	b8 90 58 04 00       	mov    $0x45890,%eax
   446f8:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   446fc:	eb 01                	jmp    446ff <printer_vprintf+0x7c5>
            if (flags & FLAG_NEGATIVE) {
   446fe:	90                   	nop
        }

        int len;
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
   446ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
   44703:	78 24                	js     44729 <printer_vprintf+0x7ef>
   44705:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44708:	83 e0 20             	and    $0x20,%eax
   4470b:	85 c0                	test   %eax,%eax
   4470d:	75 1a                	jne    44729 <printer_vprintf+0x7ef>
            len = strnlen(data, precision);
   4470f:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   44712:	48 63 d0             	movslq %eax,%rdx
   44715:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   44719:	48 89 d6             	mov    %rdx,%rsi
   4471c:	48 89 c7             	mov    %rax,%rdi
   4471f:	e8 ea f5 ff ff       	call   43d0e <strnlen>
   44724:	89 45 bc             	mov    %eax,-0x44(%rbp)
   44727:	eb 0f                	jmp    44738 <printer_vprintf+0x7fe>
        } else {
            len = strlen(data);
   44729:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4472d:	48 89 c7             	mov    %rax,%rdi
   44730:	e8 a8 f5 ff ff       	call   43cdd <strlen>
   44735:	89 45 bc             	mov    %eax,-0x44(%rbp)
        }
        int zeros;
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
   44738:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4473b:	83 e0 20             	and    $0x20,%eax
   4473e:	85 c0                	test   %eax,%eax
   44740:	74 20                	je     44762 <printer_vprintf+0x828>
   44742:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
   44746:	78 1a                	js     44762 <printer_vprintf+0x828>
            zeros = precision > len ? precision - len : 0;
   44748:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   4474b:	3b 45 bc             	cmp    -0x44(%rbp),%eax
   4474e:	7e 08                	jle    44758 <printer_vprintf+0x81e>
   44750:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   44753:	2b 45 bc             	sub    -0x44(%rbp),%eax
   44756:	eb 05                	jmp    4475d <printer_vprintf+0x823>
   44758:	b8 00 00 00 00       	mov    $0x0,%eax
   4475d:	89 45 b8             	mov    %eax,-0x48(%rbp)
   44760:	eb 5c                	jmp    447be <printer_vprintf+0x884>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
   44762:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44765:	83 e0 20             	and    $0x20,%eax
   44768:	85 c0                	test   %eax,%eax
   4476a:	74 4b                	je     447b7 <printer_vprintf+0x87d>
   4476c:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4476f:	83 e0 02             	and    $0x2,%eax
   44772:	85 c0                	test   %eax,%eax
   44774:	74 41                	je     447b7 <printer_vprintf+0x87d>
                   && !(flags & FLAG_LEFTJUSTIFY)
   44776:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44779:	83 e0 04             	and    $0x4,%eax
   4477c:	85 c0                	test   %eax,%eax
   4477e:	75 37                	jne    447b7 <printer_vprintf+0x87d>
                   && len + (int) strlen(prefix) < width) {
   44780:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   44784:	48 89 c7             	mov    %rax,%rdi
   44787:	e8 51 f5 ff ff       	call   43cdd <strlen>
   4478c:	89 c2                	mov    %eax,%edx
   4478e:	8b 45 bc             	mov    -0x44(%rbp),%eax
   44791:	01 d0                	add    %edx,%eax
   44793:	39 45 e8             	cmp    %eax,-0x18(%rbp)
   44796:	7e 1f                	jle    447b7 <printer_vprintf+0x87d>
            zeros = width - len - strlen(prefix);
   44798:	8b 45 e8             	mov    -0x18(%rbp),%eax
   4479b:	2b 45 bc             	sub    -0x44(%rbp),%eax
   4479e:	89 c3                	mov    %eax,%ebx
   447a0:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   447a4:	48 89 c7             	mov    %rax,%rdi
   447a7:	e8 31 f5 ff ff       	call   43cdd <strlen>
   447ac:	89 c2                	mov    %eax,%edx
   447ae:	89 d8                	mov    %ebx,%eax
   447b0:	29 d0                	sub    %edx,%eax
   447b2:	89 45 b8             	mov    %eax,-0x48(%rbp)
   447b5:	eb 07                	jmp    447be <printer_vprintf+0x884>
        } else {
            zeros = 0;
   447b7:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
        }
        width -= len + zeros + strlen(prefix);
   447be:	8b 55 bc             	mov    -0x44(%rbp),%edx
   447c1:	8b 45 b8             	mov    -0x48(%rbp),%eax
   447c4:	01 d0                	add    %edx,%eax
   447c6:	48 63 d8             	movslq %eax,%rbx
   447c9:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   447cd:	48 89 c7             	mov    %rax,%rdi
   447d0:	e8 08 f5 ff ff       	call   43cdd <strlen>
   447d5:	48 8d 14 03          	lea    (%rbx,%rax,1),%rdx
   447d9:	8b 45 e8             	mov    -0x18(%rbp),%eax
   447dc:	29 d0                	sub    %edx,%eax
   447de:	89 45 e8             	mov    %eax,-0x18(%rbp)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
   447e1:	eb 25                	jmp    44808 <printer_vprintf+0x8ce>
            p->putc(p, ' ', color);
   447e3:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   447ea:	48 8b 08             	mov    (%rax),%rcx
   447ed:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
   447f3:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   447fa:	be 20 00 00 00       	mov    $0x20,%esi
   447ff:	48 89 c7             	mov    %rax,%rdi
   44802:	ff d1                	call   *%rcx
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
   44804:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
   44808:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4480b:	83 e0 04             	and    $0x4,%eax
   4480e:	85 c0                	test   %eax,%eax
   44810:	75 36                	jne    44848 <printer_vprintf+0x90e>
   44812:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
   44816:	7f cb                	jg     447e3 <printer_vprintf+0x8a9>
        }
        for (; *prefix; ++prefix) {
   44818:	eb 2e                	jmp    44848 <printer_vprintf+0x90e>
            p->putc(p, *prefix, color);
   4481a:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   44821:	4c 8b 00             	mov    (%rax),%r8
   44824:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   44828:	0f b6 00             	movzbl (%rax),%eax
   4482b:	0f b6 c8             	movzbl %al,%ecx
   4482e:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
   44834:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   4483b:	89 ce                	mov    %ecx,%esi
   4483d:	48 89 c7             	mov    %rax,%rdi
   44840:	41 ff d0             	call   *%r8
        for (; *prefix; ++prefix) {
   44843:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
   44848:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   4484c:	0f b6 00             	movzbl (%rax),%eax
   4484f:	84 c0                	test   %al,%al
   44851:	75 c7                	jne    4481a <printer_vprintf+0x8e0>
        }
        for (; zeros > 0; --zeros) {
   44853:	eb 25                	jmp    4487a <printer_vprintf+0x940>
            p->putc(p, '0', color);
   44855:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   4485c:	48 8b 08             	mov    (%rax),%rcx
   4485f:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
   44865:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   4486c:	be 30 00 00 00       	mov    $0x30,%esi
   44871:	48 89 c7             	mov    %rax,%rdi
   44874:	ff d1                	call   *%rcx
        for (; zeros > 0; --zeros) {
   44876:	83 6d b8 01          	subl   $0x1,-0x48(%rbp)
   4487a:	83 7d b8 00          	cmpl   $0x0,-0x48(%rbp)
   4487e:	7f d5                	jg     44855 <printer_vprintf+0x91b>
        }
        for (; len > 0; ++data, --len) {
   44880:	eb 32                	jmp    448b4 <printer_vprintf+0x97a>
            p->putc(p, *data, color);
   44882:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   44889:	4c 8b 00             	mov    (%rax),%r8
   4488c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   44890:	0f b6 00             	movzbl (%rax),%eax
   44893:	0f b6 c8             	movzbl %al,%ecx
   44896:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
   4489c:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   448a3:	89 ce                	mov    %ecx,%esi
   448a5:	48 89 c7             	mov    %rax,%rdi
   448a8:	41 ff d0             	call   *%r8
        for (; len > 0; ++data, --len) {
   448ab:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
   448b0:	83 6d bc 01          	subl   $0x1,-0x44(%rbp)
   448b4:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
   448b8:	7f c8                	jg     44882 <printer_vprintf+0x948>
        }
        for (; width > 0; --width) {
   448ba:	eb 25                	jmp    448e1 <printer_vprintf+0x9a7>
            p->putc(p, ' ', color);
   448bc:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   448c3:	48 8b 08             	mov    (%rax),%rcx
   448c6:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
   448cc:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   448d3:	be 20 00 00 00       	mov    $0x20,%esi
   448d8:	48 89 c7             	mov    %rax,%rdi
   448db:	ff d1                	call   *%rcx
        for (; width > 0; --width) {
   448dd:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
   448e1:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
   448e5:	7f d5                	jg     448bc <printer_vprintf+0x982>
        }
    done: ;
   448e7:	90                   	nop
    for (; *format; ++format) {
   448e8:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   448ef:	01 
   448f0:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   448f7:	0f b6 00             	movzbl (%rax),%eax
   448fa:	84 c0                	test   %al,%al
   448fc:	0f 85 64 f6 ff ff    	jne    43f66 <printer_vprintf+0x2c>
    }
}
   44902:	90                   	nop
   44903:	90                   	nop
   44904:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   44908:	c9                   	leave
   44909:	c3                   	ret

000000000004490a <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
   4490a:	55                   	push   %rbp
   4490b:	48 89 e5             	mov    %rsp,%rbp
   4490e:	48 83 ec 20          	sub    $0x20,%rsp
   44912:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   44916:	89 f0                	mov    %esi,%eax
   44918:	89 55 e0             	mov    %edx,-0x20(%rbp)
   4491b:	88 45 e4             	mov    %al,-0x1c(%rbp)
    console_printer* cp = (console_printer*) p;
   4491e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   44922:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
   44926:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4492a:	48 8b 40 08          	mov    0x8(%rax),%rax
   4492e:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
   44933:	48 39 d0             	cmp    %rdx,%rax
   44936:	72 0c                	jb     44944 <console_putc+0x3a>
        cp->cursor = console;
   44938:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4493c:	48 c7 40 08 00 80 0b 	movq   $0xb8000,0x8(%rax)
   44943:	00 
    }
    if (c == '\n') {
   44944:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%rbp)
   44948:	75 78                	jne    449c2 <console_putc+0xb8>
        int pos = (cp->cursor - console) % 80;
   4494a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4494e:	48 8b 40 08          	mov    0x8(%rax),%rax
   44952:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
   44958:	48 d1 f8             	sar    %rax
   4495b:	48 89 c1             	mov    %rax,%rcx
   4495e:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
   44965:	66 66 66 
   44968:	48 89 c8             	mov    %rcx,%rax
   4496b:	48 f7 ea             	imul   %rdx
   4496e:	48 c1 fa 05          	sar    $0x5,%rdx
   44972:	48 89 c8             	mov    %rcx,%rax
   44975:	48 c1 f8 3f          	sar    $0x3f,%rax
   44979:	48 29 c2             	sub    %rax,%rdx
   4497c:	48 89 d0             	mov    %rdx,%rax
   4497f:	48 c1 e0 02          	shl    $0x2,%rax
   44983:	48 01 d0             	add    %rdx,%rax
   44986:	48 c1 e0 04          	shl    $0x4,%rax
   4498a:	48 29 c1             	sub    %rax,%rcx
   4498d:	48 89 ca             	mov    %rcx,%rdx
   44990:	89 55 fc             	mov    %edx,-0x4(%rbp)
        for (; pos != 80; pos++) {
   44993:	eb 25                	jmp    449ba <console_putc+0xb0>
            *cp->cursor++ = ' ' | color;
   44995:	8b 45 e0             	mov    -0x20(%rbp),%eax
   44998:	83 c8 20             	or     $0x20,%eax
   4499b:	89 c6                	mov    %eax,%esi
   4499d:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   449a1:	48 8b 40 08          	mov    0x8(%rax),%rax
   449a5:	48 8d 48 02          	lea    0x2(%rax),%rcx
   449a9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   449ad:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   449b1:	89 f2                	mov    %esi,%edx
   449b3:	66 89 10             	mov    %dx,(%rax)
        for (; pos != 80; pos++) {
   449b6:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   449ba:	83 7d fc 50          	cmpl   $0x50,-0x4(%rbp)
   449be:	75 d5                	jne    44995 <console_putc+0x8b>
        }
    } else {
        *cp->cursor++ = c | color;
    }
}
   449c0:	eb 24                	jmp    449e6 <console_putc+0xdc>
        *cp->cursor++ = c | color;
   449c2:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
   449c6:	8b 55 e0             	mov    -0x20(%rbp),%edx
   449c9:	09 d0                	or     %edx,%eax
   449cb:	89 c6                	mov    %eax,%esi
   449cd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   449d1:	48 8b 40 08          	mov    0x8(%rax),%rax
   449d5:	48 8d 48 02          	lea    0x2(%rax),%rcx
   449d9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   449dd:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   449e1:	89 f2                	mov    %esi,%edx
   449e3:	66 89 10             	mov    %dx,(%rax)
}
   449e6:	90                   	nop
   449e7:	c9                   	leave
   449e8:	c3                   	ret

00000000000449e9 <console_vprintf>:

int console_vprintf(int cpos, int color, const char* format, va_list val) {
   449e9:	55                   	push   %rbp
   449ea:	48 89 e5             	mov    %rsp,%rbp
   449ed:	48 83 ec 30          	sub    $0x30,%rsp
   449f1:	89 7d ec             	mov    %edi,-0x14(%rbp)
   449f4:	89 75 e8             	mov    %esi,-0x18(%rbp)
   449f7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   449fb:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
    struct console_printer cp;
    cp.p.putc = console_putc;
   449ff:	48 c7 45 f0 0a 49 04 	movq   $0x4490a,-0x10(%rbp)
   44a06:	00 
    if (cpos < 0 || cpos >= CONSOLE_ROWS * CONSOLE_COLUMNS) {
   44a07:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
   44a0b:	78 09                	js     44a16 <console_vprintf+0x2d>
   44a0d:	81 7d ec cf 07 00 00 	cmpl   $0x7cf,-0x14(%rbp)
   44a14:	7e 07                	jle    44a1d <console_vprintf+0x34>
        cpos = 0;
   44a16:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
    cp.cursor = console + cpos;
   44a1d:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44a20:	48 98                	cltq
   44a22:	48 01 c0             	add    %rax,%rax
   44a25:	48 05 00 80 0b 00    	add    $0xb8000,%rax
   44a2b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
   44a2f:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
   44a33:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   44a37:	8b 75 e8             	mov    -0x18(%rbp),%esi
   44a3a:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
   44a3e:	48 89 c7             	mov    %rax,%rdi
   44a41:	e8 f4 f4 ff ff       	call   43f3a <printer_vprintf>
    return cp.cursor - console;
   44a46:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   44a4a:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
   44a50:	48 d1 f8             	sar    %rax
}
   44a53:	c9                   	leave
   44a54:	c3                   	ret

0000000000044a55 <console_printf>:

int console_printf(int cpos, int color, const char* format, ...) {
   44a55:	55                   	push   %rbp
   44a56:	48 89 e5             	mov    %rsp,%rbp
   44a59:	48 83 ec 60          	sub    $0x60,%rsp
   44a5d:	89 7d ac             	mov    %edi,-0x54(%rbp)
   44a60:	89 75 a8             	mov    %esi,-0x58(%rbp)
   44a63:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
   44a67:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   44a6b:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   44a6f:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   44a73:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   44a7a:	48 8d 45 10          	lea    0x10(%rbp),%rax
   44a7e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   44a82:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   44a86:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
   44a8a:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   44a8e:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
   44a92:	8b 75 a8             	mov    -0x58(%rbp),%esi
   44a95:	8b 45 ac             	mov    -0x54(%rbp),%eax
   44a98:	89 c7                	mov    %eax,%edi
   44a9a:	e8 4a ff ff ff       	call   449e9 <console_vprintf>
   44a9f:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
   44aa2:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
   44aa5:	c9                   	leave
   44aa6:	c3                   	ret

0000000000044aa7 <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
   44aa7:	55                   	push   %rbp
   44aa8:	48 89 e5             	mov    %rsp,%rbp
   44aab:	48 83 ec 20          	sub    $0x20,%rsp
   44aaf:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   44ab3:	89 f0                	mov    %esi,%eax
   44ab5:	89 55 e0             	mov    %edx,-0x20(%rbp)
   44ab8:	88 45 e4             	mov    %al,-0x1c(%rbp)
    string_printer* sp = (string_printer*) p;
   44abb:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   44abf:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (sp->s < sp->end) {
   44ac3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   44ac7:	48 8b 50 08          	mov    0x8(%rax),%rdx
   44acb:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   44acf:	48 8b 40 10          	mov    0x10(%rax),%rax
   44ad3:	48 39 c2             	cmp    %rax,%rdx
   44ad6:	73 1a                	jae    44af2 <string_putc+0x4b>
        *sp->s++ = c;
   44ad8:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   44adc:	48 8b 40 08          	mov    0x8(%rax),%rax
   44ae0:	48 8d 48 01          	lea    0x1(%rax),%rcx
   44ae4:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   44ae8:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   44aec:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
   44af0:	88 10                	mov    %dl,(%rax)
    }
    (void) color;
}
   44af2:	90                   	nop
   44af3:	c9                   	leave
   44af4:	c3                   	ret

0000000000044af5 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
   44af5:	55                   	push   %rbp
   44af6:	48 89 e5             	mov    %rsp,%rbp
   44af9:	48 83 ec 40          	sub    $0x40,%rsp
   44afd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   44b01:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
   44b05:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
   44b09:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    string_printer sp;
    sp.p.putc = string_putc;
   44b0d:	48 c7 45 e8 a7 4a 04 	movq   $0x44aa7,-0x18(%rbp)
   44b14:	00 
    sp.s = s;
   44b15:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   44b19:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (size) {
   44b1d:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
   44b22:	74 33                	je     44b57 <vsnprintf+0x62>
        sp.end = s + size - 1;
   44b24:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   44b28:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
   44b2c:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   44b30:	48 01 d0             	add    %rdx,%rax
   44b33:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
   44b37:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
   44b3b:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   44b3f:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
   44b43:	be 00 00 00 00       	mov    $0x0,%esi
   44b48:	48 89 c7             	mov    %rax,%rdi
   44b4b:	e8 ea f3 ff ff       	call   43f3a <printer_vprintf>
        *sp.s = 0;
   44b50:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   44b54:	c6 00 00             	movb   $0x0,(%rax)
    }
    return sp.s - s;
   44b57:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   44b5b:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
}
   44b5f:	c9                   	leave
   44b60:	c3                   	ret

0000000000044b61 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
   44b61:	55                   	push   %rbp
   44b62:	48 89 e5             	mov    %rsp,%rbp
   44b65:	48 83 ec 70          	sub    $0x70,%rsp
   44b69:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   44b6d:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
   44b71:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
   44b75:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   44b79:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   44b7d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   44b81:	c7 45 b0 18 00 00 00 	movl   $0x18,-0x50(%rbp)
   44b88:	48 8d 45 10          	lea    0x10(%rbp),%rax
   44b8c:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
   44b90:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   44b94:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    int n = vsnprintf(s, size, format, val);
   44b98:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
   44b9c:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
   44ba0:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
   44ba4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   44ba8:	48 89 c7             	mov    %rax,%rdi
   44bab:	e8 45 ff ff ff       	call   44af5 <vsnprintf>
   44bb0:	89 45 cc             	mov    %eax,-0x34(%rbp)
    va_end(val);
    return n;
   44bb3:	8b 45 cc             	mov    -0x34(%rbp),%eax
}
   44bb6:	c9                   	leave
   44bb7:	c3                   	ret

0000000000044bb8 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
   44bb8:	55                   	push   %rbp
   44bb9:	48 89 e5             	mov    %rsp,%rbp
   44bbc:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
   44bc0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   44bc7:	eb 13                	jmp    44bdc <console_clear+0x24>
        console[i] = ' ' | 0x0700;
   44bc9:	8b 45 fc             	mov    -0x4(%rbp),%eax
   44bcc:	48 98                	cltq
   44bce:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%rax,%rax,1)
   44bd5:	00 20 07 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
   44bd8:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   44bdc:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
   44be3:	7e e4                	jle    44bc9 <console_clear+0x11>
    }
    cursorpos = 0;
   44be5:	c7 05 0d 44 07 00 00 	movl   $0x0,0x7440d(%rip)        # b8ffc <cursorpos>
   44bec:	00 00 00 
}
   44bef:	90                   	nop
   44bf0:	c9                   	leave
   44bf1:	c3                   	ret
