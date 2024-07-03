
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
   400be:	e8 54 08 00 00       	call   40917 <exception>

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
//    Initialize the hardware and processes and start running. The `command`
//    string is an optional string passed from the boot loader.

static void process_setup(pid_t pid, int program_number);

void kernel(const char* command) {
   40167:	55                   	push   %rbp
   40168:	48 89 e5             	mov    %rsp,%rbp
   4016b:	48 83 ec 20          	sub    $0x20,%rsp
   4016f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    hardware_init();
   40173:	e8 78 19 00 00       	call   41af0 <hardware_init>
    pageinfo_init();
   40178:	e8 e7 0f 00 00       	call   41164 <pageinfo_init>
    console_clear();
   4017d:	e8 00 44 00 00       	call   44582 <console_clear>
    timer_init(HZ);
   40182:	bf 64 00 00 00       	mov    $0x64,%edi
   40187:	e8 50 1e 00 00       	call   41fdc <timer_init>

    virtual_memory_map(kernel_pagetable, (uintptr_t) 0, (uintptr_t) 0, PROC_START_ADDR, PTE_P|PTE_W);
   4018c:	48 8b 05 6d 4e 01 00 	mov    0x14e6d(%rip),%rax        # 55000 <kernel_pagetable>
   40193:	41 b8 03 00 00 00    	mov    $0x3,%r8d
   40199:	b9 00 00 10 00       	mov    $0x100000,%ecx
   4019e:	ba 00 00 00 00       	mov    $0x0,%edx
   401a3:	be 00 00 00 00       	mov    $0x0,%esi
   401a8:	48 89 c7             	mov    %rax,%rdi
   401ab:	e8 ae 2b 00 00       	call   42d5e <virtual_memory_map>
    virtual_memory_map(kernel_pagetable, CONSOLE_ADDR, CONSOLE_ADDR, PAGESIZE, PTE_P|PTE_W|PTE_U);
   401b0:	ba 00 80 0b 00       	mov    $0xb8000,%edx
   401b5:	be 00 80 0b 00       	mov    $0xb8000,%esi
   401ba:	48 8b 05 3f 4e 01 00 	mov    0x14e3f(%rip),%rax        # 55000 <kernel_pagetable>
   401c1:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   401c7:	b9 00 10 00 00       	mov    $0x1000,%ecx
   401cc:	48 89 c7             	mov    %rax,%rdi
   401cf:	e8 8a 2b 00 00       	call   42d5e <virtual_memory_map>

    // Set up process descriptors
    memset(processes, 0, sizeof(processes)); 
   401d4:	ba 00 0e 00 00       	mov    $0xe00,%edx
   401d9:	be 00 00 00 00       	mov    $0x0,%esi
   401de:	bf 20 20 05 00       	mov    $0x52020,%edi
   401e3:	e8 80 34 00 00       	call   43668 <memset>
    for (pid_t i = 0; i < NPROC; i++) { 
   401e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   401ef:	eb 44                	jmp    40235 <kernel+0xce>
        processes[i].p_pid = i;
   401f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
   401f4:	48 63 d0             	movslq %eax,%rdx
   401f7:	48 89 d0             	mov    %rdx,%rax
   401fa:	48 c1 e0 03          	shl    $0x3,%rax
   401fe:	48 29 d0             	sub    %rdx,%rax
   40201:	48 c1 e0 05          	shl    $0x5,%rax
   40205:	48 8d 90 20 20 05 00 	lea    0x52020(%rax),%rdx
   4020c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4020f:	89 02                	mov    %eax,(%rdx)
        processes[i].p_state = P_FREE;
   40211:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40214:	48 63 d0             	movslq %eax,%rdx
   40217:	48 89 d0             	mov    %rdx,%rax
   4021a:	48 c1 e0 03          	shl    $0x3,%rax
   4021e:	48 29 d0             	sub    %rdx,%rax
   40221:	48 c1 e0 05          	shl    $0x5,%rax
   40225:	48 05 e8 20 05 00    	add    $0x520e8,%rax
   4022b:	c7 00 00 00 00 00    	movl   $0x0,(%rax)
    for (pid_t i = 0; i < NPROC; i++) { 
   40231:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   40235:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   40239:	7e b6                	jle    401f1 <kernel+0x8a>
    }

    if (command && strcmp(command, "fork") == 0) {
   4023b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40240:	74 29                	je     4026b <kernel+0x104>
   40242:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40246:	be c0 45 04 00       	mov    $0x445c0,%esi
   4024b:	48 89 c7             	mov    %rax,%rdi
   4024e:	e8 0e 35 00 00       	call   43761 <strcmp>
   40253:	85 c0                	test   %eax,%eax
   40255:	75 14                	jne    4026b <kernel+0x104>
        process_setup(1, 4);
   40257:	be 04 00 00 00       	mov    $0x4,%esi
   4025c:	bf 01 00 00 00       	mov    $0x1,%edi
   40261:	e8 43 01 00 00       	call   403a9 <process_setup>
   40266:	e9 c2 00 00 00       	jmp    4032d <kernel+0x1c6>
    } else if (command && strcmp(command, "forkexit") == 0) {
   4026b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   40270:	74 29                	je     4029b <kernel+0x134>
   40272:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40276:	be c5 45 04 00       	mov    $0x445c5,%esi
   4027b:	48 89 c7             	mov    %rax,%rdi
   4027e:	e8 de 34 00 00       	call   43761 <strcmp>
   40283:	85 c0                	test   %eax,%eax
   40285:	75 14                	jne    4029b <kernel+0x134>
        process_setup(1, 5);
   40287:	be 05 00 00 00       	mov    $0x5,%esi
   4028c:	bf 01 00 00 00       	mov    $0x1,%edi
   40291:	e8 13 01 00 00       	call   403a9 <process_setup>
   40296:	e9 92 00 00 00       	jmp    4032d <kernel+0x1c6>
    } else if (command && strcmp(command, "test") == 0) {
   4029b:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   402a0:	74 26                	je     402c8 <kernel+0x161>
   402a2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   402a6:	be ce 45 04 00       	mov    $0x445ce,%esi
   402ab:	48 89 c7             	mov    %rax,%rdi
   402ae:	e8 ae 34 00 00       	call   43761 <strcmp>
   402b3:	85 c0                	test   %eax,%eax
   402b5:	75 11                	jne    402c8 <kernel+0x161>
        process_setup(1, 6);
   402b7:	be 06 00 00 00       	mov    $0x6,%esi
   402bc:	bf 01 00 00 00       	mov    $0x1,%edi
   402c1:	e8 e3 00 00 00       	call   403a9 <process_setup>
   402c6:	eb 65                	jmp    4032d <kernel+0x1c6>
    } else if (command && strcmp(command, "test2") == 0) {
   402c8:	48 83 7d e8 00       	cmpq   $0x0,-0x18(%rbp)
   402cd:	74 39                	je     40308 <kernel+0x1a1>
   402cf:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   402d3:	be d3 45 04 00       	mov    $0x445d3,%esi
   402d8:	48 89 c7             	mov    %rax,%rdi
   402db:	e8 81 34 00 00       	call   43761 <strcmp>
   402e0:	85 c0                	test   %eax,%eax
   402e2:	75 24                	jne    40308 <kernel+0x1a1>
        for (pid_t i = 1; i <= 2; ++i) {
   402e4:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
   402eb:	eb 13                	jmp    40300 <kernel+0x199>
            process_setup(i, 6);
   402ed:	8b 45 f8             	mov    -0x8(%rbp),%eax
   402f0:	be 06 00 00 00       	mov    $0x6,%esi
   402f5:	89 c7                	mov    %eax,%edi
   402f7:	e8 ad 00 00 00       	call   403a9 <process_setup>
        for (pid_t i = 1; i <= 2; ++i) {
   402fc:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   40300:	83 7d f8 02          	cmpl   $0x2,-0x8(%rbp)
   40304:	7e e7                	jle    402ed <kernel+0x186>
   40306:	eb 25                	jmp    4032d <kernel+0x1c6>
        }
    } else {
        for (pid_t i = 1; i <= 4; ++i) {
   40308:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
   4030f:	eb 16                	jmp    40327 <kernel+0x1c0>
            process_setup(i, i - 1);
   40311:	8b 45 f4             	mov    -0xc(%rbp),%eax
   40314:	8d 50 ff             	lea    -0x1(%rax),%edx
   40317:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4031a:	89 d6                	mov    %edx,%esi
   4031c:	89 c7                	mov    %eax,%edi
   4031e:	e8 86 00 00 00       	call   403a9 <process_setup>
        for (pid_t i = 1; i <= 4; ++i) {
   40323:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   40327:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
   4032b:	7e e4                	jle    40311 <kernel+0x1aa>
        }
    }

    // Switch to the first process using run()
    run(&processes[1]);
   4032d:	bf 00 21 05 00       	mov    $0x52100,%edi
   40332:	e8 d0 0d 00 00       	call   41107 <run>

0000000000040337 <allocatePhysicalPage>:
}

// ch: Helper function to assign pages
uintptr_t allocatePhysicalPage(pid_t processID) {
   40337:	55                   	push   %rbp
   40338:	48 89 e5             	mov    %rsp,%rbp
   4033b:	48 83 ec 20          	sub    $0x20,%rsp
   4033f:	89 7d ec             	mov    %edi,-0x14(%rbp)
    for (int pageIndex = 0; pageIndex < PAGENUMBER(MEMSIZE_PHYSICAL); pageIndex++) {
   40342:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   40349:	eb 4c                	jmp    40397 <allocatePhysicalPage+0x60>
        if (pageinfo[pageIndex].owner == PO_FREE) {
   4034b:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4034e:	48 98                	cltq
   40350:	0f b6 84 00 40 2e 05 	movzbl 0x52e40(%rax,%rax,1),%eax
   40357:	00 
   40358:	84 c0                	test   %al,%al
   4035a:	75 37                	jne    40393 <allocatePhysicalPage+0x5c>
            int assignmentResult = assign_physical_page(PAGEADDRESS(pageIndex), processID);
   4035c:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4035f:	0f be c0             	movsbl %al,%eax
   40362:	8b 55 fc             	mov    -0x4(%rbp),%edx
   40365:	48 63 d2             	movslq %edx,%rdx
   40368:	48 c1 e2 0c          	shl    $0xc,%rdx
   4036c:	89 c6                	mov    %eax,%esi
   4036e:	48 89 d7             	mov    %rdx,%rdi
   40371:	e8 68 02 00 00       	call   405de <assign_physical_page>
   40376:	89 45 f8             	mov    %eax,-0x8(%rbp)
            if (assignmentResult == -1) {
   40379:	83 7d f8 ff          	cmpl   $0xffffffff,-0x8(%rbp)
   4037d:	75 09                	jne    40388 <allocatePhysicalPage+0x51>
                return -1;
   4037f:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
   40386:	eb 1f                	jmp    403a7 <allocatePhysicalPage+0x70>
            }
            return PAGEADDRESS(pageIndex); 
   40388:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4038b:	48 98                	cltq
   4038d:	48 c1 e0 0c          	shl    $0xc,%rax
   40391:	eb 14                	jmp    403a7 <allocatePhysicalPage+0x70>
    for (int pageIndex = 0; pageIndex < PAGENUMBER(MEMSIZE_PHYSICAL); pageIndex++) {
   40393:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   40397:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   4039e:	7e ab                	jle    4034b <allocatePhysicalPage+0x14>
        }
    }
    return -1;
   403a0:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
}
   403a7:	c9                   	leave
   403a8:	c3                   	ret

00000000000403a9 <process_setup>:
// process_setup(pid, program_number)
//    Load application program `program_number` as process number `pid`.
//    This loads the application's code and data into memory, sets its
//    %rip and %rsp, gives it a stack page, and marks it as runnable.

void process_setup(pid_t pid, int program_number) {
   403a9:	55                   	push   %rbp
   403aa:	48 89 e5             	mov    %rsp,%rbp
   403ad:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
   403b1:	89 7d 8c             	mov    %edi,-0x74(%rbp)
   403b4:	89 75 88             	mov    %esi,-0x78(%rbp)
    process_init(&processes[pid], 0);
   403b7:	8b 45 8c             	mov    -0x74(%rbp),%eax
   403ba:	48 63 d0             	movslq %eax,%rdx
   403bd:	48 89 d0             	mov    %rdx,%rax
   403c0:	48 c1 e0 03          	shl    $0x3,%rax
   403c4:	48 29 d0             	sub    %rdx,%rax
   403c7:	48 c1 e0 05          	shl    $0x5,%rax
   403cb:	48 05 20 20 05 00    	add    $0x52020,%rax
   403d1:	be 00 00 00 00       	mov    $0x0,%esi
   403d6:	48 89 c7             	mov    %rax,%rdi
   403d9:	e8 8f 1e 00 00       	call   4226d <process_init>

    x86_64_pagetable *kernel_pagetables[5];

    for (int i = 0; i < 5; i++) {
   403de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   403e5:	eb 37                	jmp    4041e <process_setup+0x75>
        kernel_pagetables[i] = (x86_64_pagetable *) allocatePhysicalPage(pid);
   403e7:	8b 45 8c             	mov    -0x74(%rbp),%eax
   403ea:	89 c7                	mov    %eax,%edi
   403ec:	e8 46 ff ff ff       	call   40337 <allocatePhysicalPage>
   403f1:	48 89 c2             	mov    %rax,%rdx
   403f4:	8b 45 fc             	mov    -0x4(%rbp),%eax
   403f7:	48 98                	cltq
   403f9:	48 89 54 c5 b0       	mov    %rdx,-0x50(%rbp,%rax,8)
        memset(kernel_pagetables[i], 0, PAGESIZE);
   403fe:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40401:	48 98                	cltq
   40403:	48 8b 44 c5 b0       	mov    -0x50(%rbp,%rax,8),%rax
   40408:	ba 00 10 00 00       	mov    $0x1000,%edx
   4040d:	be 00 00 00 00       	mov    $0x0,%esi
   40412:	48 89 c7             	mov    %rax,%rdi
   40415:	e8 4e 32 00 00       	call   43668 <memset>
    for (int i = 0; i < 5; i++) {
   4041a:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   4041e:	83 7d fc 04          	cmpl   $0x4,-0x4(%rbp)
   40422:	7e c3                	jle    403e7 <process_setup+0x3e>
    }

    kernel_pagetables[0]->entry[0] =
        (x86_64_pageentry_t)kernel_pagetables[1] | PTE_P | PTE_W | PTE_U;
   40424:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40428:	48 89 c2             	mov    %rax,%rdx
    kernel_pagetables[0]->entry[0] =
   4042b:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
        (x86_64_pageentry_t)kernel_pagetables[1] | PTE_P | PTE_W | PTE_U;
   4042f:	48 83 ca 07          	or     $0x7,%rdx
    kernel_pagetables[0]->entry[0] =
   40433:	48 89 10             	mov    %rdx,(%rax)
    kernel_pagetables[1]->entry[0] =
        (x86_64_pageentry_t)kernel_pagetables[2] | PTE_P | PTE_W | PTE_U;
   40436:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   4043a:	48 89 c2             	mov    %rax,%rdx
    kernel_pagetables[1]->entry[0] =
   4043d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
        (x86_64_pageentry_t)kernel_pagetables[2] | PTE_P | PTE_W | PTE_U;
   40441:	48 83 ca 07          	or     $0x7,%rdx
    kernel_pagetables[1]->entry[0] =
   40445:	48 89 10             	mov    %rdx,(%rax)
    kernel_pagetables[2]->entry[0] =
        (x86_64_pageentry_t)kernel_pagetables[3] | PTE_P | PTE_W | PTE_U;
   40448:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4044c:	48 89 c2             	mov    %rax,%rdx
    kernel_pagetables[2]->entry[0] =
   4044f:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
        (x86_64_pageentry_t)kernel_pagetables[3] | PTE_P | PTE_W | PTE_U;
   40453:	48 83 ca 07          	or     $0x7,%rdx
    kernel_pagetables[2]->entry[0] =
   40457:	48 89 10             	mov    %rdx,(%rax)
    kernel_pagetables[2]->entry[1] =
        (x86_64_pageentry_t)kernel_pagetables[4] | PTE_P | PTE_W | PTE_U;
   4045a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   4045e:	48 89 c2             	mov    %rax,%rdx
    kernel_pagetables[2]->entry[1] =
   40461:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
        (x86_64_pageentry_t)kernel_pagetables[4] | PTE_P | PTE_W | PTE_U;
   40465:	48 83 ca 07          	or     $0x7,%rdx
    kernel_pagetables[2]->entry[1] =
   40469:	48 89 50 08          	mov    %rdx,0x8(%rax)


    for (uintptr_t addr = 0; addr < PROC_START_ADDR; addr += PAGESIZE) {
   4046d:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
   40474:	00 
   40475:	eb 41                	jmp    404b8 <process_setup+0x10f>
        vamapping map = virtual_memory_lookup(kernel_pagetable, addr);
   40477:	48 8b 0d 82 4b 01 00 	mov    0x14b82(%rip),%rcx        # 55000 <kernel_pagetable>
   4047e:	48 8d 45 98          	lea    -0x68(%rbp),%rax
   40482:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   40486:	48 89 ce             	mov    %rcx,%rsi
   40489:	48 89 c7             	mov    %rax,%rdi
   4048c:	e8 9c 2c 00 00       	call   4312d <virtual_memory_lookup>
        virtual_memory_map(kernel_pagetables[0], addr, map.pa, PAGESIZE, map.perm);
   40491:	8b 4d a8             	mov    -0x58(%rbp),%ecx
   40494:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
   40498:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   4049c:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
   404a0:	41 89 c8             	mov    %ecx,%r8d
   404a3:	b9 00 10 00 00       	mov    $0x1000,%ecx
   404a8:	48 89 c7             	mov    %rax,%rdi
   404ab:	e8 ae 28 00 00       	call   42d5e <virtual_memory_map>
    for (uintptr_t addr = 0; addr < PROC_START_ADDR; addr += PAGESIZE) {
   404b0:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
   404b7:	00 
   404b8:	48 81 7d f0 ff ff 0f 	cmpq   $0xfffff,-0x10(%rbp)
   404bf:	00 
   404c0:	76 b5                	jbe    40477 <process_setup+0xce>
    }
    processes[pid].p_pagetable = kernel_pagetables[0];
   404c2:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
   404c6:	8b 45 8c             	mov    -0x74(%rbp),%eax
   404c9:	48 63 d0             	movslq %eax,%rdx
   404cc:	48 89 d0             	mov    %rdx,%rax
   404cf:	48 c1 e0 03          	shl    $0x3,%rax
   404d3:	48 29 d0             	sub    %rdx,%rax
   404d6:	48 c1 e0 05          	shl    $0x5,%rax
   404da:	48 05 f0 20 05 00    	add    $0x520f0,%rax
   404e0:	48 89 08             	mov    %rcx,(%rax)

    int r = program_load(&processes[pid], program_number, NULL);
   404e3:	8b 45 8c             	mov    -0x74(%rbp),%eax
   404e6:	48 63 d0             	movslq %eax,%rdx
   404e9:	48 89 d0             	mov    %rdx,%rax
   404ec:	48 c1 e0 03          	shl    $0x3,%rax
   404f0:	48 29 d0             	sub    %rdx,%rax
   404f3:	48 c1 e0 05          	shl    $0x5,%rax
   404f7:	48 8d 88 20 20 05 00 	lea    0x52020(%rax),%rcx
   404fe:	8b 45 88             	mov    -0x78(%rbp),%eax
   40501:	ba 00 00 00 00       	mov    $0x0,%edx
   40506:	89 c6                	mov    %eax,%esi
   40508:	48 89 cf             	mov    %rcx,%rdi
   4050b:	e8 14 2d 00 00       	call   43224 <program_load>
   40510:	89 45 ec             	mov    %eax,-0x14(%rbp)
    assert(r >= 0);
   40513:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
   40517:	79 14                	jns    4052d <process_setup+0x184>
   40519:	ba d9 45 04 00       	mov    $0x445d9,%edx
   4051e:	be a7 00 00 00       	mov    $0xa7,%esi
   40523:	bf e0 45 04 00       	mov    $0x445e0,%edi
   40528:	e8 0e 25 00 00       	call   42a3b <assert_fail>

    processes[pid].p_registers.reg_rsp = MEMSIZE_VIRTUAL;
   4052d:	8b 45 8c             	mov    -0x74(%rbp),%eax
   40530:	48 63 d0             	movslq %eax,%rdx
   40533:	48 89 d0             	mov    %rdx,%rax
   40536:	48 c1 e0 03          	shl    $0x3,%rax
   4053a:	48 29 d0             	sub    %rdx,%rax
   4053d:	48 c1 e0 05          	shl    $0x5,%rax
   40541:	48 05 d8 20 05 00    	add    $0x520d8,%rax
   40547:	48 c7 00 00 00 30 00 	movq   $0x300000,(%rax)
    uintptr_t stack_page = processes[pid].p_registers.reg_rsp - PAGESIZE;
   4054e:	8b 45 8c             	mov    -0x74(%rbp),%eax
   40551:	48 63 d0             	movslq %eax,%rdx
   40554:	48 89 d0             	mov    %rdx,%rax
   40557:	48 c1 e0 03          	shl    $0x3,%rax
   4055b:	48 29 d0             	sub    %rdx,%rax
   4055e:	48 c1 e0 05          	shl    $0x5,%rax
   40562:	48 05 d8 20 05 00    	add    $0x520d8,%rax
   40568:	48 8b 00             	mov    (%rax),%rax
   4056b:	48 2d 00 10 00 00    	sub    $0x1000,%rax
   40571:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    uintptr_t physical_stack = allocatePhysicalPage(pid);
   40575:	8b 45 8c             	mov    -0x74(%rbp),%eax
   40578:	89 c7                	mov    %eax,%edi
   4057a:	e8 b8 fd ff ff       	call   40337 <allocatePhysicalPage>
   4057f:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    virtual_memory_map(processes[pid].p_pagetable, stack_page, physical_stack,
   40583:	8b 45 8c             	mov    -0x74(%rbp),%eax
   40586:	48 63 d0             	movslq %eax,%rdx
   40589:	48 89 d0             	mov    %rdx,%rax
   4058c:	48 c1 e0 03          	shl    $0x3,%rax
   40590:	48 29 d0             	sub    %rdx,%rax
   40593:	48 c1 e0 05          	shl    $0x5,%rax
   40597:	48 05 f0 20 05 00    	add    $0x520f0,%rax
   4059d:	48 8b 00             	mov    (%rax),%rax
   405a0:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   405a4:	48 8b 75 e0          	mov    -0x20(%rbp),%rsi
   405a8:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   405ae:	b9 00 10 00 00       	mov    $0x1000,%ecx
   405b3:	48 89 c7             	mov    %rax,%rdi
   405b6:	e8 a3 27 00 00       	call   42d5e <virtual_memory_map>
                       PAGESIZE, PTE_P | PTE_W | PTE_U);
    processes[pid].p_state = P_RUNNABLE;
   405bb:	8b 45 8c             	mov    -0x74(%rbp),%eax
   405be:	48 63 d0             	movslq %eax,%rdx
   405c1:	48 89 d0             	mov    %rdx,%rax
   405c4:	48 c1 e0 03          	shl    $0x3,%rax
   405c8:	48 29 d0             	sub    %rdx,%rax
   405cb:	48 c1 e0 05          	shl    $0x5,%rax
   405cf:	48 05 e8 20 05 00    	add    $0x520e8,%rax
   405d5:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
}
   405db:	90                   	nop
   405dc:	c9                   	leave
   405dd:	c3                   	ret

00000000000405de <assign_physical_page>:
// assign_physical_page(addr, owner)
//    Allocates the page with physical address `addr` to the given owner.
//    Fails if physical page `addr` was already allocated. Returns 0 on
//    success and -1 on failure. Used by the program loader.

int assign_physical_page(uintptr_t addr, int8_t owner) {
   405de:	55                   	push   %rbp
   405df:	48 89 e5             	mov    %rsp,%rbp
   405e2:	48 83 ec 10          	sub    $0x10,%rsp
   405e6:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   405ea:	89 f0                	mov    %esi,%eax
   405ec:	88 45 f4             	mov    %al,-0xc(%rbp)
    if ((addr & 0xFFF) != 0
   405ef:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   405f3:	25 ff 0f 00 00       	and    $0xfff,%eax
   405f8:	48 85 c0             	test   %rax,%rax
   405fb:	75 20                	jne    4061d <assign_physical_page+0x3f>
        || addr >= MEMSIZE_PHYSICAL
   405fd:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   40604:	00 
   40605:	77 16                	ja     4061d <assign_physical_page+0x3f>
        || pageinfo[PAGENUMBER(addr)].refcount != 0) {
   40607:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4060b:	48 c1 e8 0c          	shr    $0xc,%rax
   4060f:	48 98                	cltq
   40611:	0f b6 84 00 41 2e 05 	movzbl 0x52e41(%rax,%rax,1),%eax
   40618:	00 
   40619:	84 c0                	test   %al,%al
   4061b:	74 07                	je     40624 <assign_physical_page+0x46>
        return -1;
   4061d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   40622:	eb 2c                	jmp    40650 <assign_physical_page+0x72>
    } else {
        pageinfo[PAGENUMBER(addr)].refcount = 1;
   40624:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   40628:	48 c1 e8 0c          	shr    $0xc,%rax
   4062c:	48 98                	cltq
   4062e:	c6 84 00 41 2e 05 00 	movb   $0x1,0x52e41(%rax,%rax,1)
   40635:	01 
        pageinfo[PAGENUMBER(addr)].owner = owner;
   40636:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4063a:	48 c1 e8 0c          	shr    $0xc,%rax
   4063e:	48 98                	cltq
   40640:	0f b6 55 f4          	movzbl -0xc(%rbp),%edx
   40644:	88 94 00 40 2e 05 00 	mov    %dl,0x52e40(%rax,%rax,1)
        return 0;
   4064b:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
   40650:	c9                   	leave
   40651:	c3                   	ret

0000000000040652 <syscall_mapping>:

void syscall_mapping(proc* p) {
   40652:	55                   	push   %rbp
   40653:	48 89 e5             	mov    %rsp,%rbp
   40656:	48 83 ec 70          	sub    $0x70,%rsp
   4065a:	48 89 7d 98          	mov    %rdi,-0x68(%rbp)

    uintptr_t mapping_ptr = p->p_registers.reg_rdi;
   4065e:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   40662:	48 8b 40 38          	mov    0x38(%rax),%rax
   40666:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    uintptr_t ptr = p->p_registers.reg_rsi;
   4066a:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   4066e:	48 8b 40 30          	mov    0x30(%rax),%rax
   40672:	48 89 45 f0          	mov    %rax,-0x10(%rbp)

    //convert to physical address so kernel can write to it
    vamapping map = virtual_memory_lookup(p->p_pagetable, mapping_ptr);
   40676:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   4067a:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   40681:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   40685:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   40689:	48 89 ce             	mov    %rcx,%rsi
   4068c:	48 89 c7             	mov    %rax,%rdi
   4068f:	e8 99 2a 00 00       	call   4312d <virtual_memory_lookup>

    // check for write access
    if((map.perm & (PTE_W|PTE_U)) != (PTE_W|PTE_U))
   40694:	8b 45 e0             	mov    -0x20(%rbp),%eax
   40697:	48 98                	cltq
   40699:	83 e0 06             	and    $0x6,%eax
   4069c:	48 83 f8 06          	cmp    $0x6,%rax
   406a0:	75 73                	jne    40715 <syscall_mapping+0xc3>
        return;
    uintptr_t endaddr = mapping_ptr + sizeof(vamapping) - 1;
   406a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   406a6:	48 83 c0 17          	add    $0x17,%rax
   406aa:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    // check for write access for end address
    vamapping end_map = virtual_memory_lookup(p->p_pagetable, endaddr);
   406ae:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   406b2:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   406b9:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
   406bd:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   406c1:	48 89 ce             	mov    %rcx,%rsi
   406c4:	48 89 c7             	mov    %rax,%rdi
   406c7:	e8 61 2a 00 00       	call   4312d <virtual_memory_lookup>
    if((end_map.perm & (PTE_W|PTE_P)) != (PTE_W|PTE_P))
   406cc:	8b 45 c8             	mov    -0x38(%rbp),%eax
   406cf:	48 98                	cltq
   406d1:	83 e0 03             	and    $0x3,%eax
   406d4:	48 83 f8 03          	cmp    $0x3,%rax
   406d8:	75 3e                	jne    40718 <syscall_mapping+0xc6>
        return;
    // find the actual mapping now
    vamapping ptr_lookup = virtual_memory_lookup(p->p_pagetable, ptr);
   406da:	48 8b 45 98          	mov    -0x68(%rbp),%rax
   406de:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   406e5:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
   406e9:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   406ed:	48 89 ce             	mov    %rcx,%rsi
   406f0:	48 89 c7             	mov    %rax,%rdi
   406f3:	e8 35 2a 00 00       	call   4312d <virtual_memory_lookup>
    memcpy((void *)map.pa, &ptr_lookup, sizeof(vamapping));
   406f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   406fc:	48 89 c1             	mov    %rax,%rcx
   406ff:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
   40703:	ba 18 00 00 00       	mov    $0x18,%edx
   40708:	48 89 c6             	mov    %rax,%rsi
   4070b:	48 89 cf             	mov    %rcx,%rdi
   4070e:	e8 57 2e 00 00       	call   4356a <memcpy>
   40713:	eb 04                	jmp    40719 <syscall_mapping+0xc7>
        return;
   40715:	90                   	nop
   40716:	eb 01                	jmp    40719 <syscall_mapping+0xc7>
        return;
   40718:	90                   	nop
}
   40719:	c9                   	leave
   4071a:	c3                   	ret

000000000004071b <syscall_mem_tog>:

void syscall_mem_tog(proc* process){
   4071b:	55                   	push   %rbp
   4071c:	48 89 e5             	mov    %rsp,%rbp
   4071f:	48 83 ec 18          	sub    $0x18,%rsp
   40723:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)

    pid_t p = process->p_registers.reg_rdi;
   40727:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4072b:	48 8b 40 38          	mov    0x38(%rax),%rax
   4072f:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if(p == 0) {
   40732:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   40736:	75 14                	jne    4074c <syscall_mem_tog+0x31>
        disp_global = !disp_global;
   40738:	0f b6 05 c1 58 00 00 	movzbl 0x58c1(%rip),%eax        # 46000 <disp_global>
   4073f:	84 c0                	test   %al,%al
   40741:	0f 94 c0             	sete   %al
   40744:	88 05 b6 58 00 00    	mov    %al,0x58b6(%rip)        # 46000 <disp_global>
   4074a:	eb 36                	jmp    40782 <syscall_mem_tog+0x67>
    }
    else {
        if(p < 0 || p > NPROC || p != process->p_pid)
   4074c:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   40750:	78 2f                	js     40781 <syscall_mem_tog+0x66>
   40752:	83 7d fc 10          	cmpl   $0x10,-0x4(%rbp)
   40756:	7f 29                	jg     40781 <syscall_mem_tog+0x66>
   40758:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4075c:	8b 00                	mov    (%rax),%eax
   4075e:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   40761:	75 1e                	jne    40781 <syscall_mem_tog+0x66>
            return;
        process->display_status = !(process->display_status);
   40763:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40767:	0f b6 80 d8 00 00 00 	movzbl 0xd8(%rax),%eax
   4076e:	84 c0                	test   %al,%al
   40770:	0f 94 c0             	sete   %al
   40773:	89 c2                	mov    %eax,%edx
   40775:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   40779:	88 90 d8 00 00 00    	mov    %dl,0xd8(%rax)
   4077f:	eb 01                	jmp    40782 <syscall_mem_tog+0x67>
            return;
   40781:	90                   	nop
    }
}
   40782:	c9                   	leave
   40783:	c3                   	ret

0000000000040784 <assign_free_process>:

int assign_free_process() {
   40784:	55                   	push   %rbp
   40785:	48 89 e5             	mov    %rsp,%rbp
   40788:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 1; i < NPROC; i++) {
   4078c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
   40793:	eb 29                	jmp    407be <assign_free_process+0x3a>
        if (processes[i].p_state == P_FREE) {
   40795:	8b 45 fc             	mov    -0x4(%rbp),%eax
   40798:	48 63 d0             	movslq %eax,%rdx
   4079b:	48 89 d0             	mov    %rdx,%rax
   4079e:	48 c1 e0 03          	shl    $0x3,%rax
   407a2:	48 29 d0             	sub    %rdx,%rax
   407a5:	48 c1 e0 05          	shl    $0x5,%rax
   407a9:	48 05 e8 20 05 00    	add    $0x520e8,%rax
   407af:	8b 00                	mov    (%rax),%eax
   407b1:	85 c0                	test   %eax,%eax
   407b3:	75 05                	jne    407ba <assign_free_process+0x36>
            return i;
   407b5:	8b 45 fc             	mov    -0x4(%rbp),%eax
   407b8:	eb 0f                	jmp    407c9 <assign_free_process+0x45>
    for (int i = 1; i < NPROC; i++) {
   407ba:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   407be:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   407c2:	7e d1                	jle    40795 <assign_free_process+0x11>
        }
    }
    return -1;
   407c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
   407c9:	c9                   	leave
   407ca:	c3                   	ret

00000000000407cb <process_exit>:

void process_exit(pid_t process, x86_64_pagetable *mike) {
   407cb:	55                   	push   %rbp
   407cc:	48 89 e5             	mov    %rsp,%rbp
   407cf:	48 83 ec 60          	sub    $0x60,%rsp
   407d3:	89 7d ac             	mov    %edi,-0x54(%rbp)
   407d6:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
    // vamapping map;
    for (uintptr_t addr = PROC_START_ADDR; addr < MEMSIZE_VIRTUAL; addr += PAGESIZE) {
   407da:	48 c7 45 f8 00 00 10 	movq   $0x100000,-0x8(%rbp)
   407e1:	00 
   407e2:	eb 76                	jmp    4085a <process_exit+0x8f>
        vamapping map = virtual_memory_lookup(mike, addr);
   407e4:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
   407e8:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   407ec:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
   407f0:	48 89 ce             	mov    %rcx,%rsi
   407f3:	48 89 c7             	mov    %rax,%rdi
   407f6:	e8 32 29 00 00       	call   4312d <virtual_memory_lookup>
        if (pageinfo[map.pn].owner == process && map.pa != (uintptr_t) -1) {
   407fb:	8b 45 b0             	mov    -0x50(%rbp),%eax
   407fe:	48 98                	cltq
   40800:	0f b6 84 00 40 2e 05 	movzbl 0x52e40(%rax,%rax,1),%eax
   40807:	00 
   40808:	0f be c0             	movsbl %al,%eax
   4080b:	39 45 ac             	cmp    %eax,-0x54(%rbp)
   4080e:	75 42                	jne    40852 <process_exit+0x87>
   40810:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40814:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
   40818:	74 38                	je     40852 <process_exit+0x87>
            pageinfo[map.pn].refcount--;
   4081a:	8b 45 b0             	mov    -0x50(%rbp),%eax
   4081d:	48 63 d0             	movslq %eax,%rdx
   40820:	0f b6 94 12 41 2e 05 	movzbl 0x52e41(%rdx,%rdx,1),%edx
   40827:	00 
   40828:	83 ea 01             	sub    $0x1,%edx
   4082b:	48 98                	cltq
   4082d:	88 94 00 41 2e 05 00 	mov    %dl,0x52e41(%rax,%rax,1)
            if (pageinfo[map.pn].refcount == 0)
   40834:	8b 45 b0             	mov    -0x50(%rbp),%eax
   40837:	48 98                	cltq
   40839:	0f b6 84 00 41 2e 05 	movzbl 0x52e41(%rax,%rax,1),%eax
   40840:	00 
   40841:	84 c0                	test   %al,%al
   40843:	75 0d                	jne    40852 <process_exit+0x87>
            {
                pageinfo[map.pn].owner = PO_FREE;
   40845:	8b 45 b0             	mov    -0x50(%rbp),%eax
   40848:	48 98                	cltq
   4084a:	c6 84 00 40 2e 05 00 	movb   $0x0,0x52e40(%rax,%rax,1)
   40851:	00 
    for (uintptr_t addr = PROC_START_ADDR; addr < MEMSIZE_VIRTUAL; addr += PAGESIZE) {
   40852:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   40859:	00 
   4085a:	48 81 7d f8 ff ff 2f 	cmpq   $0x2fffff,-0x8(%rbp)
   40861:	00 
   40862:	76 80                	jbe    407e4 <process_exit+0x19>
            }
        }
    }

    x86_64_pagetable *kernel_pagetables[5];
    kernel_pagetables[0] = mike;
   40864:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   40868:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    kernel_pagetables[1] = (x86_64_pagetable *)PTE_ADDR(kernel_pagetables[0]->entry[0]);
   4086c:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40870:	48 8b 00             	mov    (%rax),%rax
   40873:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   40879:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
    kernel_pagetables[2] = (x86_64_pagetable *)PTE_ADDR(kernel_pagetables[1]->entry[0]);
   4087d:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   40881:	48 8b 00             	mov    (%rax),%rax
   40884:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   4088a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    kernel_pagetables[3] = (x86_64_pagetable *)PTE_ADDR(kernel_pagetables[2]->entry[0]);
   4088e:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   40892:	48 8b 00             	mov    (%rax),%rax
   40895:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   4089b:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    kernel_pagetables[4] = (x86_64_pagetable *)PTE_ADDR(kernel_pagetables[2]->entry[1]);
   4089f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   408a3:	48 8b 40 08          	mov    0x8(%rax),%rax
   408a7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   408ad:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

    for (int i = 0; i < 5; i++)
   408b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   408b8:	eb 34                	jmp    408ee <process_exit+0x123>
    {
        pageinfo[PAGENUMBER(kernel_pagetables[i])].refcount = 0;
   408ba:	8b 45 f4             	mov    -0xc(%rbp),%eax
   408bd:	48 98                	cltq
   408bf:	48 8b 44 c5 c8       	mov    -0x38(%rbp,%rax,8),%rax
   408c4:	48 c1 e8 0c          	shr    $0xc,%rax
   408c8:	48 98                	cltq
   408ca:	c6 84 00 41 2e 05 00 	movb   $0x0,0x52e41(%rax,%rax,1)
   408d1:	00 
        pageinfo[PAGENUMBER(kernel_pagetables[i])].owner = PO_FREE;
   408d2:	8b 45 f4             	mov    -0xc(%rbp),%eax
   408d5:	48 98                	cltq
   408d7:	48 8b 44 c5 c8       	mov    -0x38(%rbp,%rax,8),%rax
   408dc:	48 c1 e8 0c          	shr    $0xc,%rax
   408e0:	48 98                	cltq
   408e2:	c6 84 00 40 2e 05 00 	movb   $0x0,0x52e40(%rax,%rax,1)
   408e9:	00 
    for (int i = 0; i < 5; i++)
   408ea:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   408ee:	83 7d f4 04          	cmpl   $0x4,-0xc(%rbp)
   408f2:	7e c6                	jle    408ba <process_exit+0xef>
    }
    processes[process].p_state = P_FREE;
   408f4:	8b 45 ac             	mov    -0x54(%rbp),%eax
   408f7:	48 63 d0             	movslq %eax,%rdx
   408fa:	48 89 d0             	mov    %rdx,%rax
   408fd:	48 c1 e0 03          	shl    $0x3,%rax
   40901:	48 29 d0             	sub    %rdx,%rax
   40904:	48 c1 e0 05          	shl    $0x5,%rax
   40908:	48 05 e8 20 05 00    	add    $0x520e8,%rax
   4090e:	c7 00 00 00 00 00    	movl   $0x0,(%rax)

    return;
   40914:	90                   	nop

}
   40915:	c9                   	leave
   40916:	c3                   	ret

0000000000040917 <exception>:
//    k-exception.S). That code saves more registers on the kernel's stack,
//    then calls exception().
//
//    Note that hardware interrupts are disabled whenever the kernel is running.

void exception(x86_64_registers* reg) {
   40917:	55                   	push   %rbp
   40918:	48 89 e5             	mov    %rsp,%rbp
   4091b:	48 81 ec 70 01 00 00 	sub    $0x170,%rsp
   40922:	48 89 bd 98 fe ff ff 	mov    %rdi,-0x168(%rbp)
    // Copy the saved registers into the `current` process descriptor
    // and always use the kernel's page table.
    current->p_registers = *reg;
   40929:	48 8b 05 d0 16 01 00 	mov    0x116d0(%rip),%rax        # 52000 <current>
   40930:	48 8b 95 98 fe ff ff 	mov    -0x168(%rbp),%rdx
   40937:	48 83 c0 08          	add    $0x8,%rax
   4093b:	48 89 d6             	mov    %rdx,%rsi
   4093e:	ba 18 00 00 00       	mov    $0x18,%edx
   40943:	48 89 c7             	mov    %rax,%rdi
   40946:	48 89 d1             	mov    %rdx,%rcx
   40949:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
    set_pagetable(kernel_pagetable);
   4094c:	48 8b 05 ad 46 01 00 	mov    0x146ad(%rip),%rax        # 55000 <kernel_pagetable>
   40953:	48 89 c7             	mov    %rax,%rdi
   40956:	e8 d2 22 00 00       	call   42c2d <set_pagetable>
    // Events logged this way are stored in the host's `log.txt` file.
    /*log_printf("proc %d: exception %d\n", current->p_pid, reg->reg_intno);*/

    // Show the current cursor location and memory state
    // (unless this is a kernel fault).
    console_show_cursor(cursorpos);
   4095b:	8b 05 9b 86 07 00    	mov    0x7869b(%rip),%eax        # b8ffc <cursorpos>
   40961:	89 c7                	mov    %eax,%edi
   40963:	e8 cf 19 00 00       	call   42337 <console_show_cursor>
    if ((reg->reg_intno != INT_PAGEFAULT && reg->reg_intno != INT_GPF) // no error due to pagefault or general fault
   40968:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   4096f:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   40976:	48 83 f8 0e          	cmp    $0xe,%rax
   4097a:	74 14                	je     40990 <exception+0x79>
   4097c:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40983:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   4098a:	48 83 f8 0d          	cmp    $0xd,%rax
   4098e:	75 16                	jne    409a6 <exception+0x8f>
            || (reg->reg_err & PFERR_USER)) // pagefault error in user mode 
   40990:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40997:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   4099e:	83 e0 04             	and    $0x4,%eax
   409a1:	48 85 c0             	test   %rax,%rax
   409a4:	74 1a                	je     409c0 <exception+0xa9>
    {
        check_virtual_memory();
   409a6:	e8 48 0b 00 00       	call   414f3 <check_virtual_memory>
        if(disp_global){
   409ab:	0f b6 05 4e 56 00 00 	movzbl 0x564e(%rip),%eax        # 46000 <disp_global>
   409b2:	84 c0                	test   %al,%al
   409b4:	74 0a                	je     409c0 <exception+0xa9>
            memshow_physical();
   409b6:	e8 b0 0c 00 00       	call   4166b <memshow_physical>
            memshow_virtual_animate();
   409bb:	e8 d2 0f 00 00       	call   41992 <memshow_virtual_animate>
        }
    }

    // If Control-C was typed, exit the virtual machine.
    check_keyboard();
   409c0:	e8 55 1e 00 00       	call   4281a <check_keyboard>


    // Actually handle the exception.
    switch (reg->reg_intno) {
   409c5:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   409cc:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   409d3:	48 83 e8 0e          	sub    $0xe,%rax
   409d7:	48 83 f8 2a          	cmp    $0x2a,%rax
   409db:	0f 87 75 06 00 00    	ja     41056 <exception+0x73f>
   409e1:	48 8b 04 c5 80 46 04 	mov    0x44680(,%rax,8),%rax
   409e8:	00 
   409e9:	ff e0                	jmp    *%rax

    case INT_SYS_PANIC:
	    // rdi stores pointer for msg string
	    {
		char msg[160];
		uintptr_t addr = current->p_registers.reg_rdi;
   409eb:	48 8b 05 0e 16 01 00 	mov    0x1160e(%rip),%rax        # 52000 <current>
   409f2:	48 8b 40 38          	mov    0x38(%rax),%rax
   409f6:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
		if((void *)addr == NULL)
   409fa:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
   409ff:	75 0f                	jne    40a10 <exception+0xf9>
		    panic(NULL);
   40a01:	bf 00 00 00 00       	mov    $0x0,%edi
   40a06:	b8 00 00 00 00       	mov    $0x0,%eax
   40a0b:	e8 4b 1f 00 00       	call   4295b <panic>
		vamapping map = virtual_memory_lookup(current->p_pagetable, addr);
   40a10:	48 8b 05 e9 15 01 00 	mov    0x115e9(%rip),%rax        # 52000 <current>
   40a17:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   40a1e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
   40a25:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
   40a29:	48 89 ce             	mov    %rcx,%rsi
   40a2c:	48 89 c7             	mov    %rax,%rdi
   40a2f:	e8 f9 26 00 00       	call   4312d <virtual_memory_lookup>
		memcpy(msg, (void *)map.pa, 160);
   40a34:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   40a3b:	48 89 c1             	mov    %rax,%rcx
   40a3e:	48 8d 85 a0 fe ff ff 	lea    -0x160(%rbp),%rax
   40a45:	ba a0 00 00 00       	mov    $0xa0,%edx
   40a4a:	48 89 ce             	mov    %rcx,%rsi
   40a4d:	48 89 c7             	mov    %rax,%rdi
   40a50:	e8 15 2b 00 00       	call   4356a <memcpy>
		panic(msg);
   40a55:	48 8d 85 a0 fe ff ff 	lea    -0x160(%rbp),%rax
   40a5c:	48 89 c7             	mov    %rax,%rdi
   40a5f:	b8 00 00 00 00       	mov    $0x0,%eax
   40a64:	e8 f2 1e 00 00       	call   4295b <panic>
	    }
	    panic(NULL);
	    break;                  // will not be reached

    case INT_SYS_GETPID:
        current->p_registers.reg_rax = current->p_pid;
   40a69:	48 8b 05 90 15 01 00 	mov    0x11590(%rip),%rax        # 52000 <current>
   40a70:	8b 10                	mov    (%rax),%edx
   40a72:	48 8b 05 87 15 01 00 	mov    0x11587(%rip),%rax        # 52000 <current>
   40a79:	48 63 d2             	movslq %edx,%rdx
   40a7c:	48 89 50 08          	mov    %rdx,0x8(%rax)
        break;
   40a80:	e9 e3 05 00 00       	jmp    41068 <exception+0x751>

    case INT_SYS_YIELD:
        schedule();
   40a85:	e8 07 06 00 00       	call   41091 <schedule>
        break;                  /* will not be reached */
   40a8a:	e9 d9 05 00 00       	jmp    41068 <exception+0x751>

    case INT_SYS_PAGE_ALLOC: {
        uintptr_t addr = current->p_registers.reg_rdi;
   40a8f:	48 8b 05 6a 15 01 00 	mov    0x1156a(%rip),%rax        # 52000 <current>
   40a96:	48 8b 40 38          	mov    0x38(%rax),%rax
   40a9a:	48 89 45 b8          	mov    %rax,-0x48(%rbp)

        // ch: Ensure the address is page-aligned and within the user-accessible range
        if (addr % PAGESIZE != 0 || addr < PROC_START_ADDR || addr >= MEMSIZE_VIRTUAL) {
   40a9e:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   40aa2:	25 ff 0f 00 00       	and    $0xfff,%eax
   40aa7:	48 85 c0             	test   %rax,%rax
   40aaa:	75 14                	jne    40ac0 <exception+0x1a9>
   40aac:	48 81 7d b8 ff ff 0f 	cmpq   $0xfffff,-0x48(%rbp)
   40ab3:	00 
   40ab4:	76 0a                	jbe    40ac0 <exception+0x1a9>
   40ab6:	48 81 7d b8 ff ff 2f 	cmpq   $0x2fffff,-0x48(%rbp)
   40abd:	00 
   40abe:	76 14                	jbe    40ad4 <exception+0x1bd>
            current->p_registers.reg_rax = -1; 
   40ac0:	48 8b 05 39 15 01 00 	mov    0x11539(%rip),%rax        # 52000 <current>
   40ac7:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   40ace:	ff 
                current->p_registers.reg_rax = 0; 
            } else {
                current->p_registers.reg_rax = -1;
            }
        }
        break;
   40acf:	e9 94 05 00 00       	jmp    41068 <exception+0x751>
            uintptr_t r = allocatePhysicalPage(current->p_pid);
   40ad4:	48 8b 05 25 15 01 00 	mov    0x11525(%rip),%rax        # 52000 <current>
   40adb:	8b 00                	mov    (%rax),%eax
   40add:	89 c7                	mov    %eax,%edi
   40adf:	e8 53 f8 ff ff       	call   40337 <allocatePhysicalPage>
   40ae4:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (r != (uintptr_t) -1) {
   40ae8:	48 83 7d b0 ff       	cmpq   $0xffffffffffffffff,-0x50(%rbp)
   40aed:	74 3d                	je     40b2c <exception+0x215>
                virtual_memory_map(current->p_pagetable, addr, r, PAGESIZE, PTE_P | PTE_W | PTE_U);
   40aef:	48 8b 05 0a 15 01 00 	mov    0x1150a(%rip),%rax        # 52000 <current>
   40af6:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   40afd:	48 8b 55 b0          	mov    -0x50(%rbp),%rdx
   40b01:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
   40b05:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   40b0b:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40b10:	48 89 c7             	mov    %rax,%rdi
   40b13:	e8 46 22 00 00       	call   42d5e <virtual_memory_map>
                current->p_registers.reg_rax = 0; 
   40b18:	48 8b 05 e1 14 01 00 	mov    0x114e1(%rip),%rax        # 52000 <current>
   40b1f:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
   40b26:	00 
        break;
   40b27:	e9 3c 05 00 00       	jmp    41068 <exception+0x751>
                current->p_registers.reg_rax = -1;
   40b2c:	48 8b 05 cd 14 01 00 	mov    0x114cd(%rip),%rax        # 52000 <current>
   40b33:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   40b3a:	ff 
        break;
   40b3b:	e9 28 05 00 00       	jmp    41068 <exception+0x751>
    }

    case INT_SYS_MAPPING:
    {
	    syscall_mapping(current);
   40b40:	48 8b 05 b9 14 01 00 	mov    0x114b9(%rip),%rax        # 52000 <current>
   40b47:	48 89 c7             	mov    %rax,%rdi
   40b4a:	e8 03 fb ff ff       	call   40652 <syscall_mapping>
            break;
   40b4f:	e9 14 05 00 00       	jmp    41068 <exception+0x751>
    }

    case INT_SYS_MEM_TOG:
	{
	    syscall_mem_tog(current);
   40b54:	48 8b 05 a5 14 01 00 	mov    0x114a5(%rip),%rax        # 52000 <current>
   40b5b:	48 89 c7             	mov    %rax,%rdi
   40b5e:	e8 b8 fb ff ff       	call   4071b <syscall_mem_tog>
	    break;
   40b63:	e9 00 05 00 00       	jmp    41068 <exception+0x751>
	}

    case INT_TIMER:
        ++ticks;
   40b68:	8b 05 b2 22 01 00    	mov    0x122b2(%rip),%eax        # 52e20 <ticks>
   40b6e:	83 c0 01             	add    $0x1,%eax
   40b71:	89 05 a9 22 01 00    	mov    %eax,0x122a9(%rip)        # 52e20 <ticks>
        schedule();
   40b77:	e8 15 05 00 00       	call   41091 <schedule>
        break;                  /* will not be reached */
   40b7c:	e9 e7 04 00 00       	jmp    41068 <exception+0x751>
    return val;
}

static inline uintptr_t rcr2(void) {
    uintptr_t val;
    asm volatile("movq %%cr2,%0" : "=r" (val));
   40b81:	0f 20 d0             	mov    %cr2,%rax
   40b84:	48 89 45 88          	mov    %rax,-0x78(%rbp)
    return val;
   40b88:	48 8b 45 88          	mov    -0x78(%rbp),%rax

    case INT_PAGEFAULT: {
        // Analyze faulting address and access type.
        uintptr_t addr = rcr2();
   40b8c:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
        const char* operation = reg->reg_err & PFERR_WRITE
   40b90:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40b97:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40b9e:	83 e0 02             	and    $0x2,%eax
                ? "write" : "read";
   40ba1:	48 85 c0             	test   %rax,%rax
   40ba4:	74 07                	je     40bad <exception+0x296>
   40ba6:	b8 f0 45 04 00       	mov    $0x445f0,%eax
   40bab:	eb 05                	jmp    40bb2 <exception+0x29b>
   40bad:	b8 f6 45 04 00       	mov    $0x445f6,%eax
        const char* operation = reg->reg_err & PFERR_WRITE
   40bb2:	48 89 45 98          	mov    %rax,-0x68(%rbp)
        const char* problem = reg->reg_err & PFERR_PRESENT
   40bb6:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40bbd:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40bc4:	83 e0 01             	and    $0x1,%eax
                ? "protection problem" : "missing page";
   40bc7:	48 85 c0             	test   %rax,%rax
   40bca:	74 07                	je     40bd3 <exception+0x2bc>
   40bcc:	b8 fb 45 04 00       	mov    $0x445fb,%eax
   40bd1:	eb 05                	jmp    40bd8 <exception+0x2c1>
   40bd3:	b8 0e 46 04 00       	mov    $0x4460e,%eax
        const char* problem = reg->reg_err & PFERR_PRESENT
   40bd8:	48 89 45 90          	mov    %rax,-0x70(%rbp)

        if (!(reg->reg_err & PFERR_USER)) {
   40bdc:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40be3:	48 8b 80 90 00 00 00 	mov    0x90(%rax),%rax
   40bea:	83 e0 04             	and    $0x4,%eax
   40bed:	48 85 c0             	test   %rax,%rax
   40bf0:	75 2f                	jne    40c21 <exception+0x30a>
            panic("Kernel page fault for %p (%s %s, rip=%p)!\n",
   40bf2:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40bf9:	48 8b b0 98 00 00 00 	mov    0x98(%rax),%rsi
   40c00:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
   40c04:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
   40c08:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   40c0c:	49 89 f0             	mov    %rsi,%r8
   40c0f:	48 89 c6             	mov    %rax,%rsi
   40c12:	bf 20 46 04 00       	mov    $0x44620,%edi
   40c17:	b8 00 00 00 00       	mov    $0x0,%eax
   40c1c:	e8 3a 1d 00 00       	call   4295b <panic>
                  addr, operation, problem, reg->reg_rip);
        }
        console_printf(CPOS(24, 0), 0x0C00,
   40c21:	48 8b 85 98 fe ff ff 	mov    -0x168(%rbp),%rax
   40c28:	48 8b 90 98 00 00 00 	mov    0x98(%rax),%rdx
                       "Process %d page fault for %p (%s %s, rip=%p)!\n",
                       current->p_pid, addr, operation, problem, reg->reg_rip);
   40c2f:	48 8b 05 ca 13 01 00 	mov    0x113ca(%rip),%rax        # 52000 <current>
        console_printf(CPOS(24, 0), 0x0C00,
   40c36:	8b 00                	mov    (%rax),%eax
   40c38:	48 8b 75 98          	mov    -0x68(%rbp),%rsi
   40c3c:	48 8b 4d a0          	mov    -0x60(%rbp),%rcx
   40c40:	52                   	push   %rdx
   40c41:	ff 75 90             	push   -0x70(%rbp)
   40c44:	49 89 f1             	mov    %rsi,%r9
   40c47:	49 89 c8             	mov    %rcx,%r8
   40c4a:	89 c1                	mov    %eax,%ecx
   40c4c:	ba 50 46 04 00       	mov    $0x44650,%edx
   40c51:	be 00 0c 00 00       	mov    $0xc00,%esi
   40c56:	bf 80 07 00 00       	mov    $0x780,%edi
   40c5b:	b8 00 00 00 00       	mov    $0x0,%eax
   40c60:	e8 ba 37 00 00       	call   4441f <console_printf>
   40c65:	48 83 c4 10          	add    $0x10,%rsp
        current->p_state = P_BROKEN;
   40c69:	48 8b 05 90 13 01 00 	mov    0x11390(%rip),%rax        # 52000 <current>
   40c70:	c7 80 c8 00 00 00 03 	movl   $0x3,0xc8(%rax)
   40c77:	00 00 00 
        break;
   40c7a:	e9 e9 03 00 00       	jmp    41068 <exception+0x751>
    }

    case INT_SYS_FORK: {
        int child_pid = assign_free_process();
   40c7f:	b8 00 00 00 00       	mov    $0x0,%eax
   40c84:	e8 fb fa ff ff       	call   40784 <assign_free_process>
   40c89:	89 45 d4             	mov    %eax,-0x2c(%rbp)

        if (child_pid == -1) {
   40c8c:	83 7d d4 ff          	cmpl   $0xffffffff,-0x2c(%rbp)
   40c90:	75 14                	jne    40ca6 <exception+0x38f>
            current->p_registers.reg_rax = -1;
   40c92:	48 8b 05 67 13 01 00 	mov    0x11367(%rip),%rax        # 52000 <current>
   40c99:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   40ca0:	ff 
            break;
   40ca1:	e9 c2 03 00 00       	jmp    41068 <exception+0x751>
        }

        proc *child = &processes[child_pid];
   40ca6:	8b 45 d4             	mov    -0x2c(%rbp),%eax
   40ca9:	48 63 d0             	movslq %eax,%rdx
   40cac:	48 89 d0             	mov    %rdx,%rax
   40caf:	48 c1 e0 03          	shl    $0x3,%rax
   40cb3:	48 29 d0             	sub    %rdx,%rax
   40cb6:	48 c1 e0 05          	shl    $0x5,%rax
   40cba:	48 05 20 20 05 00    	add    $0x52020,%rax
   40cc0:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        x86_64_pagetable *kernel_pagetables[5];

        int f = 0;
   40cc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)

        for (int i = 0; i < 5; i++) {
   40ccb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   40cd2:	e9 a7 00 00 00       	jmp    40d7e <exception+0x467>
            kernel_pagetables[i] = (x86_64_pagetable *) allocatePhysicalPage(child->p_pid);
   40cd7:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40cdb:	8b 00                	mov    (%rax),%eax
   40cdd:	89 c7                	mov    %eax,%edi
   40cdf:	e8 53 f6 ff ff       	call   40337 <allocatePhysicalPage>
   40ce4:	48 89 c2             	mov    %rax,%rdx
   40ce7:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40cea:	48 98                	cltq
   40cec:	48 89 94 c5 a0 fe ff 	mov    %rdx,-0x160(%rbp,%rax,8)
   40cf3:	ff 
            if (kernel_pagetables[i] == (x86_64_pagetable *) -1) {
   40cf4:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40cf7:	48 98                	cltq
   40cf9:	48 8b 84 c5 a0 fe ff 	mov    -0x160(%rbp,%rax,8),%rax
   40d00:	ff 
   40d01:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
   40d05:	75 54                	jne    40d5b <exception+0x444>
                for (int j = i - 1; j >= 0; j--) {
   40d07:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40d0a:	83 e8 01             	sub    $0x1,%eax
   40d0d:	89 45 f4             	mov    %eax,-0xc(%rbp)
   40d10:	eb 3a                	jmp    40d4c <exception+0x435>
                    pageinfo[PAGENUMBER(kernel_pagetables[j])].refcount = 0;
   40d12:	8b 45 f4             	mov    -0xc(%rbp),%eax
   40d15:	48 98                	cltq
   40d17:	48 8b 84 c5 a0 fe ff 	mov    -0x160(%rbp,%rax,8),%rax
   40d1e:	ff 
   40d1f:	48 c1 e8 0c          	shr    $0xc,%rax
   40d23:	48 98                	cltq
   40d25:	c6 84 00 41 2e 05 00 	movb   $0x0,0x52e41(%rax,%rax,1)
   40d2c:	00 
                    pageinfo[PAGENUMBER(kernel_pagetables[j])].owner = PO_FREE;
   40d2d:	8b 45 f4             	mov    -0xc(%rbp),%eax
   40d30:	48 98                	cltq
   40d32:	48 8b 84 c5 a0 fe ff 	mov    -0x160(%rbp,%rax,8),%rax
   40d39:	ff 
   40d3a:	48 c1 e8 0c          	shr    $0xc,%rax
   40d3e:	48 98                	cltq
   40d40:	c6 84 00 40 2e 05 00 	movb   $0x0,0x52e40(%rax,%rax,1)
   40d47:	00 
                for (int j = i - 1; j >= 0; j--) {
   40d48:	83 6d f4 01          	subl   $0x1,-0xc(%rbp)
   40d4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   40d50:	79 c0                	jns    40d12 <exception+0x3fb>
                }
                f = 1;
   40d52:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
                break;
   40d59:	eb 2d                	jmp    40d88 <exception+0x471>
            }
            memset(kernel_pagetables[i], 0, PAGESIZE);
   40d5b:	8b 45 f8             	mov    -0x8(%rbp),%eax
   40d5e:	48 98                	cltq
   40d60:	48 8b 84 c5 a0 fe ff 	mov    -0x160(%rbp,%rax,8),%rax
   40d67:	ff 
   40d68:	ba 00 10 00 00       	mov    $0x1000,%edx
   40d6d:	be 00 00 00 00       	mov    $0x0,%esi
   40d72:	48 89 c7             	mov    %rax,%rdi
   40d75:	e8 ee 28 00 00       	call   43668 <memset>
        for (int i = 0; i < 5; i++) {
   40d7a:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   40d7e:	83 7d f8 04          	cmpl   $0x4,-0x8(%rbp)
   40d82:	0f 8e 4f ff ff ff    	jle    40cd7 <exception+0x3c0>
        }

        if (f == 1) {
   40d88:	83 7d fc 01          	cmpl   $0x1,-0x4(%rbp)
   40d8c:	75 14                	jne    40da2 <exception+0x48b>
            current->p_registers.reg_rax = -1;
   40d8e:	48 8b 05 6b 12 01 00 	mov    0x1126b(%rip),%rax        # 52000 <current>
   40d95:	48 c7 40 08 ff ff ff 	movq   $0xffffffffffffffff,0x8(%rax)
   40d9c:	ff 
            break;
   40d9d:	e9 c6 02 00 00       	jmp    41068 <exception+0x751>
        }

        kernel_pagetables[0]->entry[0] =
            (x86_64_pageentry_t)kernel_pagetables[1] | PTE_P | PTE_W | PTE_U;
   40da2:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
   40da9:	48 89 c2             	mov    %rax,%rdx
        kernel_pagetables[0]->entry[0] =
   40dac:	48 8b 85 a0 fe ff ff 	mov    -0x160(%rbp),%rax
            (x86_64_pageentry_t)kernel_pagetables[1] | PTE_P | PTE_W | PTE_U;
   40db3:	48 83 ca 07          	or     $0x7,%rdx
        kernel_pagetables[0]->entry[0] =
   40db7:	48 89 10             	mov    %rdx,(%rax)
        kernel_pagetables[1]->entry[0] =
            (x86_64_pageentry_t)kernel_pagetables[2] | PTE_P | PTE_W | PTE_U;
   40dba:	48 8b 85 b0 fe ff ff 	mov    -0x150(%rbp),%rax
   40dc1:	48 89 c2             	mov    %rax,%rdx
        kernel_pagetables[1]->entry[0] =
   40dc4:	48 8b 85 a8 fe ff ff 	mov    -0x158(%rbp),%rax
            (x86_64_pageentry_t)kernel_pagetables[2] | PTE_P | PTE_W | PTE_U;
   40dcb:	48 83 ca 07          	or     $0x7,%rdx
        kernel_pagetables[1]->entry[0] =
   40dcf:	48 89 10             	mov    %rdx,(%rax)
        kernel_pagetables[2]->entry[0] =
            (x86_64_pageentry_t)kernel_pagetables[3] | PTE_P | PTE_W | PTE_U;
   40dd2:	48 8b 85 b8 fe ff ff 	mov    -0x148(%rbp),%rax
   40dd9:	48 89 c2             	mov    %rax,%rdx
        kernel_pagetables[2]->entry[0] =
   40ddc:	48 8b 85 b0 fe ff ff 	mov    -0x150(%rbp),%rax
            (x86_64_pageentry_t)kernel_pagetables[3] | PTE_P | PTE_W | PTE_U;
   40de3:	48 83 ca 07          	or     $0x7,%rdx
        kernel_pagetables[2]->entry[0] =
   40de7:	48 89 10             	mov    %rdx,(%rax)
        kernel_pagetables[2]->entry[1] =
            (x86_64_pageentry_t)kernel_pagetables[4] | PTE_P | PTE_W | PTE_U;
   40dea:	48 8b 85 c0 fe ff ff 	mov    -0x140(%rbp),%rax
   40df1:	48 89 c2             	mov    %rax,%rdx
        kernel_pagetables[2]->entry[1] =
   40df4:	48 8b 85 b0 fe ff ff 	mov    -0x150(%rbp),%rax
            (x86_64_pageentry_t)kernel_pagetables[4] | PTE_P | PTE_W | PTE_U;
   40dfb:	48 83 ca 07          	or     $0x7,%rdx
        kernel_pagetables[2]->entry[1] =
   40dff:	48 89 50 08          	mov    %rdx,0x8(%rax)

        for (uintptr_t addr = 0; addr < MEMSIZE_VIRTUAL; addr += PAGESIZE) {
   40e03:	48 c7 45 e8 00 00 00 	movq   $0x0,-0x18(%rbp)
   40e0a:	00 
   40e0b:	eb 62                	jmp    40e6f <exception+0x558>
            vamapping map = virtual_memory_lookup(current->p_pagetable, addr);
   40e0d:	48 8b 05 ec 11 01 00 	mov    0x111ec(%rip),%rax        # 52000 <current>
   40e14:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   40e1b:	48 8d 85 58 ff ff ff 	lea    -0xa8(%rbp),%rax
   40e22:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   40e26:	48 89 ce             	mov    %rcx,%rsi
   40e29:	48 89 c7             	mov    %rax,%rdi
   40e2c:	e8 fc 22 00 00       	call   4312d <virtual_memory_lookup>
            if (map.pn == -1) {
   40e31:	8b 85 58 ff ff ff    	mov    -0xa8(%rbp),%eax
   40e37:	83 f8 ff             	cmp    $0xffffffff,%eax
   40e3a:	74 2a                	je     40e66 <exception+0x54f>
                continue;
            }
            virtual_memory_map(kernel_pagetables[0], addr, map.pa, PAGESIZE, map.perm);
   40e3c:	8b 8d 68 ff ff ff    	mov    -0x98(%rbp),%ecx
   40e42:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   40e49:	48 8b 85 a0 fe ff ff 	mov    -0x160(%rbp),%rax
   40e50:	48 8b 75 e8          	mov    -0x18(%rbp),%rsi
   40e54:	41 89 c8             	mov    %ecx,%r8d
   40e57:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40e5c:	48 89 c7             	mov    %rax,%rdi
   40e5f:	e8 fa 1e 00 00       	call   42d5e <virtual_memory_map>
   40e64:	eb 01                	jmp    40e67 <exception+0x550>
                continue;
   40e66:	90                   	nop
        for (uintptr_t addr = 0; addr < MEMSIZE_VIRTUAL; addr += PAGESIZE) {
   40e67:	48 81 45 e8 00 10 00 	addq   $0x1000,-0x18(%rbp)
   40e6e:	00 
   40e6f:	48 81 7d e8 ff ff 2f 	cmpq   $0x2fffff,-0x18(%rbp)
   40e76:	00 
   40e77:	76 94                	jbe    40e0d <exception+0x4f6>
        }

        x86_64_pageentry_t *page;
        int flag = 0;
   40e79:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
        for (uintptr_t addr = PROC_START_ADDR; addr < MEMSIZE_VIRTUAL; addr += PAGESIZE) {
   40e80:	48 c7 45 d8 00 00 10 	movq   $0x100000,-0x28(%rbp)
   40e87:	00 
   40e88:	e9 20 01 00 00       	jmp    40fad <exception+0x696>
            vamapping map = virtual_memory_lookup(current->p_pagetable, addr);
   40e8d:	48 8b 05 6c 11 01 00 	mov    0x1116c(%rip),%rax        # 52000 <current>
   40e94:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   40e9b:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
   40ea2:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   40ea6:	48 89 ce             	mov    %rcx,%rsi
   40ea9:	48 89 c7             	mov    %rax,%rdi
   40eac:	e8 7c 22 00 00       	call   4312d <virtual_memory_lookup>
            if ((int)map.pa == -1 || map.pn == -1) {
   40eb1:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
   40eb8:	83 f8 ff             	cmp    $0xffffffff,%eax
   40ebb:	0f 84 e3 00 00 00    	je     40fa4 <exception+0x68d>
   40ec1:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   40ec7:	83 f8 ff             	cmp    $0xffffffff,%eax
   40eca:	0f 84 d4 00 00 00    	je     40fa4 <exception+0x68d>
                continue;
            } else if (!(map.perm & PTE_W)) {
   40ed0:	8b 85 50 ff ff ff    	mov    -0xb0(%rbp),%eax
   40ed6:	48 98                	cltq
   40ed8:	83 e0 02             	and    $0x2,%eax
   40edb:	48 85 c0             	test   %rax,%rax
   40ede:	75 47                	jne    40f27 <exception+0x610>
                virtual_memory_map(kernel_pagetables[0], addr, (uintptr_t)map.pa, PAGESIZE, map.perm);
   40ee0:	8b 8d 50 ff ff ff    	mov    -0xb0(%rbp),%ecx
   40ee6:	48 8b 95 48 ff ff ff 	mov    -0xb8(%rbp),%rdx
   40eed:	48 8b 85 a0 fe ff ff 	mov    -0x160(%rbp),%rax
   40ef4:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
   40ef8:	41 89 c8             	mov    %ecx,%r8d
   40efb:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40f00:	48 89 c7             	mov    %rax,%rdi
   40f03:	e8 56 1e 00 00       	call   42d5e <virtual_memory_map>
                pageinfo[map.pn].refcount++;
   40f08:	8b 85 40 ff ff ff    	mov    -0xc0(%rbp),%eax
   40f0e:	48 63 d0             	movslq %eax,%rdx
   40f11:	0f b6 94 12 41 2e 05 	movzbl 0x52e41(%rdx,%rdx,1),%edx
   40f18:	00 
   40f19:	83 c2 01             	add    $0x1,%edx
   40f1c:	48 98                	cltq
   40f1e:	88 94 00 41 2e 05 00 	mov    %dl,0x52e41(%rax,%rax,1)
   40f25:	eb 7e                	jmp    40fa5 <exception+0x68e>
            } else {
                page = (x86_64_pageentry_t *) allocatePhysicalPage(child->p_pid);
   40f27:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40f2b:	8b 00                	mov    (%rax),%eax
   40f2d:	89 c7                	mov    %eax,%edi
   40f2f:	e8 03 f4 ff ff       	call   40337 <allocatePhysicalPage>
   40f34:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
                if (page == (x86_64_pageentry_t *)-1) {
   40f38:	48 83 7d c0 ff       	cmpq   $0xffffffffffffffff,-0x40(%rbp)
   40f3d:	75 20                	jne    40f5f <exception+0x648>
                    process_exit(child->p_pid, kernel_pagetables[0]);
   40f3f:	48 8b 95 a0 fe ff ff 	mov    -0x160(%rbp),%rdx
   40f46:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40f4a:	8b 00                	mov    (%rax),%eax
   40f4c:	48 89 d6             	mov    %rdx,%rsi
   40f4f:	89 c7                	mov    %eax,%edi
   40f51:	e8 75 f8 ff ff       	call   407cb <process_exit>
                    flag = 1;
   40f56:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%rbp)
   40f5d:	eb 5c                	jmp    40fbb <exception+0x6a4>
                    break;
                } else {
                    memcpy((void *)page, (void *)map.pa, PAGESIZE);
   40f5f:	48 8b 85 48 ff ff ff 	mov    -0xb8(%rbp),%rax
   40f66:	48 89 c1             	mov    %rax,%rcx
   40f69:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   40f6d:	ba 00 10 00 00       	mov    $0x1000,%edx
   40f72:	48 89 ce             	mov    %rcx,%rsi
   40f75:	48 89 c7             	mov    %rax,%rdi
   40f78:	e8 ed 25 00 00       	call   4356a <memcpy>
                    virtual_memory_map(kernel_pagetables[0], addr, (uintptr_t)page, PAGESIZE, map.perm);
   40f7d:	8b 8d 50 ff ff ff    	mov    -0xb0(%rbp),%ecx
   40f83:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   40f87:	48 8b 85 a0 fe ff ff 	mov    -0x160(%rbp),%rax
   40f8e:	48 8b 75 d8          	mov    -0x28(%rbp),%rsi
   40f92:	41 89 c8             	mov    %ecx,%r8d
   40f95:	b9 00 10 00 00       	mov    $0x1000,%ecx
   40f9a:	48 89 c7             	mov    %rax,%rdi
   40f9d:	e8 bc 1d 00 00       	call   42d5e <virtual_memory_map>
   40fa2:	eb 01                	jmp    40fa5 <exception+0x68e>
                continue;
   40fa4:	90                   	nop
        for (uintptr_t addr = PROC_START_ADDR; addr < MEMSIZE_VIRTUAL; addr += PAGESIZE) {
   40fa5:	48 81 45 d8 00 10 00 	addq   $0x1000,-0x28(%rbp)
   40fac:	00 
   40fad:	48 81 7d d8 ff ff 2f 	cmpq   $0x2fffff,-0x28(%rbp)
   40fb4:	00 
   40fb5:	0f 86 d2 fe ff ff    	jbe    40e8d <exception+0x576>
                }
            }
        }

        if (flag == 1) {
   40fbb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%rbp)
   40fbf:	0f 84 a2 00 00 00    	je     41067 <exception+0x750>
            break;
        }

        child->p_state = P_RUNNABLE;
   40fc5:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40fc9:	c7 80 c8 00 00 00 01 	movl   $0x1,0xc8(%rax)
   40fd0:	00 00 00 
        child->p_pagetable = kernel_pagetables[0];
   40fd3:	48 8b 95 a0 fe ff ff 	mov    -0x160(%rbp),%rdx
   40fda:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40fde:	48 89 90 d0 00 00 00 	mov    %rdx,0xd0(%rax)
        child->p_registers = current->p_registers;
   40fe5:	48 8b 15 14 10 01 00 	mov    0x11014(%rip),%rdx        # 52000 <current>
   40fec:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   40ff0:	48 83 c0 08          	add    $0x8,%rax
   40ff4:	48 83 c2 08          	add    $0x8,%rdx
   40ff8:	b9 18 00 00 00       	mov    $0x18,%ecx
   40ffd:	48 89 c7             	mov    %rax,%rdi
   41000:	48 89 d6             	mov    %rdx,%rsi
   41003:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
        child->display_status = 1;
   41006:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4100a:	c6 80 d8 00 00 00 01 	movb   $0x1,0xd8(%rax)
        child->p_registers.reg_rax = 0;
   41011:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   41015:	48 c7 40 08 00 00 00 	movq   $0x0,0x8(%rax)
   4101c:	00 
        current->p_registers.reg_rax = child->p_pid;
   4101d:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   41021:	8b 10                	mov    (%rax),%edx
   41023:	48 8b 05 d6 0f 01 00 	mov    0x10fd6(%rip),%rax        # 52000 <current>
   4102a:	48 63 d2             	movslq %edx,%rdx
   4102d:	48 89 50 08          	mov    %rdx,0x8(%rax)
        break;
   41031:	eb 35                	jmp    41068 <exception+0x751>
    }

    case INT_SYS_EXIT: {
        process_exit(current->p_pid, current->p_pagetable);
   41033:	48 8b 05 c6 0f 01 00 	mov    0x10fc6(%rip),%rax        # 52000 <current>
   4103a:	48 8b 90 d0 00 00 00 	mov    0xd0(%rax),%rdx
   41041:	48 8b 05 b8 0f 01 00 	mov    0x10fb8(%rip),%rax        # 52000 <current>
   41048:	8b 00                	mov    (%rax),%eax
   4104a:	48 89 d6             	mov    %rdx,%rsi
   4104d:	89 c7                	mov    %eax,%edi
   4104f:	e8 77 f7 ff ff       	call   407cb <process_exit>
        break;
   41054:	eb 12                	jmp    41068 <exception+0x751>
    }

    default:
        default_exception(current);
   41056:	48 8b 05 a3 0f 01 00 	mov    0x10fa3(%rip),%rax        # 52000 <current>
   4105d:	48 89 c7             	mov    %rax,%rdi
   41060:	e8 06 1a 00 00       	call   42a6b <default_exception>
        break;                  /* will not be reached */
   41065:	eb 01                	jmp    41068 <exception+0x751>
            break;
   41067:	90                   	nop

    }


    // Return to the current process (or run something else).
    if (current->p_state == P_RUNNABLE) {
   41068:	48 8b 05 91 0f 01 00 	mov    0x10f91(%rip),%rax        # 52000 <current>
   4106f:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
   41075:	83 f8 01             	cmp    $0x1,%eax
   41078:	75 0f                	jne    41089 <exception+0x772>
        run(current);
   4107a:	48 8b 05 7f 0f 01 00 	mov    0x10f7f(%rip),%rax        # 52000 <current>
   41081:	48 89 c7             	mov    %rax,%rdi
   41084:	e8 7e 00 00 00       	call   41107 <run>
    } else {
        schedule();
   41089:	e8 03 00 00 00       	call   41091 <schedule>
    }
}
   4108e:	90                   	nop
   4108f:	c9                   	leave
   41090:	c3                   	ret

0000000000041091 <schedule>:

// schedule
//    Pick the next process to run and then run it.
//    If there are no runnable processes, spins forever.

void schedule(void) {
   41091:	55                   	push   %rbp
   41092:	48 89 e5             	mov    %rsp,%rbp
   41095:	48 83 ec 10          	sub    $0x10,%rsp
    pid_t pid = current->p_pid;
   41099:	48 8b 05 60 0f 01 00 	mov    0x10f60(%rip),%rax        # 52000 <current>
   410a0:	8b 00                	mov    (%rax),%eax
   410a2:	89 45 fc             	mov    %eax,-0x4(%rbp)
    while (1) {
        pid = (pid + 1) % NPROC;
   410a5:	8b 45 fc             	mov    -0x4(%rbp),%eax
   410a8:	8d 50 01             	lea    0x1(%rax),%edx
   410ab:	89 d0                	mov    %edx,%eax
   410ad:	c1 f8 1f             	sar    $0x1f,%eax
   410b0:	c1 e8 1c             	shr    $0x1c,%eax
   410b3:	01 c2                	add    %eax,%edx
   410b5:	83 e2 0f             	and    $0xf,%edx
   410b8:	29 c2                	sub    %eax,%edx
   410ba:	89 55 fc             	mov    %edx,-0x4(%rbp)
        if (processes[pid].p_state == P_RUNNABLE) {
   410bd:	8b 45 fc             	mov    -0x4(%rbp),%eax
   410c0:	48 63 d0             	movslq %eax,%rdx
   410c3:	48 89 d0             	mov    %rdx,%rax
   410c6:	48 c1 e0 03          	shl    $0x3,%rax
   410ca:	48 29 d0             	sub    %rdx,%rax
   410cd:	48 c1 e0 05          	shl    $0x5,%rax
   410d1:	48 05 e8 20 05 00    	add    $0x520e8,%rax
   410d7:	8b 00                	mov    (%rax),%eax
   410d9:	83 f8 01             	cmp    $0x1,%eax
   410dc:	75 22                	jne    41100 <schedule+0x6f>
            run(&processes[pid]);
   410de:	8b 45 fc             	mov    -0x4(%rbp),%eax
   410e1:	48 63 d0             	movslq %eax,%rdx
   410e4:	48 89 d0             	mov    %rdx,%rax
   410e7:	48 c1 e0 03          	shl    $0x3,%rax
   410eb:	48 29 d0             	sub    %rdx,%rax
   410ee:	48 c1 e0 05          	shl    $0x5,%rax
   410f2:	48 05 20 20 05 00    	add    $0x52020,%rax
   410f8:	48 89 c7             	mov    %rax,%rdi
   410fb:	e8 07 00 00 00       	call   41107 <run>
        }
        // If Control-C was typed, exit the virtual machine.
        check_keyboard();
   41100:	e8 15 17 00 00       	call   4281a <check_keyboard>
        pid = (pid + 1) % NPROC;
   41105:	eb 9e                	jmp    410a5 <schedule+0x14>

0000000000041107 <run>:
//    Run process `p`. This means reloading all the registers from
//    `p->p_registers` using the `popal`, `popl`, and `iret` instructions.
//
//    As a side effect, sets `current = p`.

void run(proc* p) {
   41107:	55                   	push   %rbp
   41108:	48 89 e5             	mov    %rsp,%rbp
   4110b:	48 83 ec 10          	sub    $0x10,%rsp
   4110f:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    assert(p->p_state == P_RUNNABLE);
   41113:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41117:	8b 80 c8 00 00 00    	mov    0xc8(%rax),%eax
   4111d:	83 f8 01             	cmp    $0x1,%eax
   41120:	74 14                	je     41136 <run+0x2f>
   41122:	ba d8 47 04 00       	mov    $0x447d8,%edx
   41127:	be 02 02 00 00       	mov    $0x202,%esi
   4112c:	bf e0 45 04 00       	mov    $0x445e0,%edi
   41131:	e8 05 19 00 00       	call   42a3b <assert_fail>
    current = p;
   41136:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4113a:	48 89 05 bf 0e 01 00 	mov    %rax,0x10ebf(%rip)        # 52000 <current>

    // Load the process's current pagetable.
    set_pagetable(p->p_pagetable);
   41141:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41145:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   4114c:	48 89 c7             	mov    %rax,%rdi
   4114f:	e8 d9 1a 00 00       	call   42c2d <set_pagetable>

    // This function is defined in k-exception.S. It restores the process's
    // registers then jumps back to user mode.
    exception_return(&p->p_registers);
   41154:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41158:	48 83 c0 08          	add    $0x8,%rax
   4115c:	48 89 c7             	mov    %rax,%rdi
   4115f:	e8 5f ef ff ff       	call   400c3 <exception_return>

0000000000041164 <pageinfo_init>:


// pageinfo_init
//    Initialize the `pageinfo[]` array.

void pageinfo_init(void) {
   41164:	55                   	push   %rbp
   41165:	48 89 e5             	mov    %rsp,%rbp
   41168:	48 83 ec 10          	sub    $0x10,%rsp
    extern char end[];

    for (uintptr_t addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) {
   4116c:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   41173:	00 
   41174:	e9 81 00 00 00       	jmp    411fa <pageinfo_init+0x96>
        int owner;
        if (physical_memory_isreserved(addr)) {
   41179:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4117d:	48 89 c7             	mov    %rax,%rdi
   41180:	e8 23 0f 00 00       	call   420a8 <physical_memory_isreserved>
   41185:	85 c0                	test   %eax,%eax
   41187:	74 09                	je     41192 <pageinfo_init+0x2e>
            owner = PO_RESERVED;
   41189:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%rbp)
   41190:	eb 2f                	jmp    411c1 <pageinfo_init+0x5d>
        } else if ((addr >= KERNEL_START_ADDR && addr < (uintptr_t) end)
   41192:	48 81 7d f8 ff ff 03 	cmpq   $0x3ffff,-0x8(%rbp)
   41199:	00 
   4119a:	76 0b                	jbe    411a7 <pageinfo_init+0x43>
   4119c:	b8 08 b0 05 00       	mov    $0x5b008,%eax
   411a1:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   411a5:	72 0a                	jb     411b1 <pageinfo_init+0x4d>
                   || addr == KERNEL_STACK_TOP - PAGESIZE) {
   411a7:	48 81 7d f8 00 f0 07 	cmpq   $0x7f000,-0x8(%rbp)
   411ae:	00 
   411af:	75 09                	jne    411ba <pageinfo_init+0x56>
            owner = PO_KERNEL;
   411b1:	c7 45 f4 fe ff ff ff 	movl   $0xfffffffe,-0xc(%rbp)
   411b8:	eb 07                	jmp    411c1 <pageinfo_init+0x5d>
        } else {
            owner = PO_FREE;
   411ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
        }
        pageinfo[PAGENUMBER(addr)].owner = owner;
   411c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   411c5:	48 c1 e8 0c          	shr    $0xc,%rax
   411c9:	89 c1                	mov    %eax,%ecx
   411cb:	8b 45 f4             	mov    -0xc(%rbp),%eax
   411ce:	89 c2                	mov    %eax,%edx
   411d0:	48 63 c1             	movslq %ecx,%rax
   411d3:	88 94 00 40 2e 05 00 	mov    %dl,0x52e40(%rax,%rax,1)
        pageinfo[PAGENUMBER(addr)].refcount = (owner != PO_FREE);
   411da:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   411de:	0f 95 c2             	setne  %dl
   411e1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   411e5:	48 c1 e8 0c          	shr    $0xc,%rax
   411e9:	48 98                	cltq
   411eb:	88 94 00 41 2e 05 00 	mov    %dl,0x52e41(%rax,%rax,1)
    for (uintptr_t addr = 0; addr < MEMSIZE_PHYSICAL; addr += PAGESIZE) {
   411f2:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   411f9:	00 
   411fa:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   41201:	00 
   41202:	0f 86 71 ff ff ff    	jbe    41179 <pageinfo_init+0x15>
    }
}
   41208:	90                   	nop
   41209:	90                   	nop
   4120a:	c9                   	leave
   4120b:	c3                   	ret

000000000004120c <check_page_table_mappings>:

// check_page_table_mappings
//    Check operating system invariants about kernel mappings for page
//    table `pt`. Panic if any of the invariants are false.

void check_page_table_mappings(x86_64_pagetable* pt) {
   4120c:	55                   	push   %rbp
   4120d:	48 89 e5             	mov    %rsp,%rbp
   41210:	48 83 ec 50          	sub    $0x50,%rsp
   41214:	48 89 7d b8          	mov    %rdi,-0x48(%rbp)
    extern char start_data[], end[];
    assert(PTE_ADDR(pt) == (uintptr_t) pt);
   41218:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   4121c:	25 ff 0f 00 00       	and    $0xfff,%eax
   41221:	48 85 c0             	test   %rax,%rax
   41224:	74 14                	je     4123a <check_page_table_mappings+0x2e>
   41226:	ba f8 47 04 00       	mov    $0x447f8,%edx
   4122b:	be 2c 02 00 00       	mov    $0x22c,%esi
   41230:	bf e0 45 04 00       	mov    $0x445e0,%edi
   41235:	e8 01 18 00 00       	call   42a3b <assert_fail>

    // kernel memory is identity mapped; data is writable
    for (uintptr_t va = KERNEL_START_ADDR; va < (uintptr_t) end;
   4123a:	48 c7 45 f8 00 00 04 	movq   $0x40000,-0x8(%rbp)
   41241:	00 
   41242:	e9 9a 00 00 00       	jmp    412e1 <check_page_table_mappings+0xd5>
         va += PAGESIZE) {
        vamapping vam = virtual_memory_lookup(pt, va);
   41247:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
   4124b:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   4124f:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
   41253:	48 89 ce             	mov    %rcx,%rsi
   41256:	48 89 c7             	mov    %rax,%rdi
   41259:	e8 cf 1e 00 00       	call   4312d <virtual_memory_lookup>
        if (vam.pa != va) {
   4125e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   41262:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   41266:	74 27                	je     4128f <check_page_table_mappings+0x83>
            console_printf(CPOS(22, 0), 0xC000, "%p vs %p\n", va, vam.pa);
   41268:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   4126c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41270:	49 89 d0             	mov    %rdx,%r8
   41273:	48 89 c1             	mov    %rax,%rcx
   41276:	ba 17 48 04 00       	mov    $0x44817,%edx
   4127b:	be 00 c0 00 00       	mov    $0xc000,%esi
   41280:	bf e0 06 00 00       	mov    $0x6e0,%edi
   41285:	b8 00 00 00 00       	mov    $0x0,%eax
   4128a:	e8 90 31 00 00       	call   4441f <console_printf>
        }
        assert(vam.pa == va);
   4128f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   41293:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   41297:	74 14                	je     412ad <check_page_table_mappings+0xa1>
   41299:	ba 21 48 04 00       	mov    $0x44821,%edx
   4129e:	be 35 02 00 00       	mov    $0x235,%esi
   412a3:	bf e0 45 04 00       	mov    $0x445e0,%edi
   412a8:	e8 8e 17 00 00       	call   42a3b <assert_fail>
        if (va >= (uintptr_t) start_data) {
   412ad:	b8 00 60 04 00       	mov    $0x46000,%eax
   412b2:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   412b6:	72 21                	jb     412d9 <check_page_table_mappings+0xcd>
            assert(vam.perm & PTE_W);
   412b8:	8b 45 d0             	mov    -0x30(%rbp),%eax
   412bb:	48 98                	cltq
   412bd:	83 e0 02             	and    $0x2,%eax
   412c0:	48 85 c0             	test   %rax,%rax
   412c3:	75 14                	jne    412d9 <check_page_table_mappings+0xcd>
   412c5:	ba 2e 48 04 00       	mov    $0x4482e,%edx
   412ca:	be 37 02 00 00       	mov    $0x237,%esi
   412cf:	bf e0 45 04 00       	mov    $0x445e0,%edi
   412d4:	e8 62 17 00 00       	call   42a3b <assert_fail>
         va += PAGESIZE) {
   412d9:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   412e0:	00 
    for (uintptr_t va = KERNEL_START_ADDR; va < (uintptr_t) end;
   412e1:	b8 08 b0 05 00       	mov    $0x5b008,%eax
   412e6:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   412ea:	0f 82 57 ff ff ff    	jb     41247 <check_page_table_mappings+0x3b>
        }
    }

    // kernel stack is identity mapped and writable
    uintptr_t kstack = KERNEL_STACK_TOP - PAGESIZE;
   412f0:	48 c7 45 f0 00 f0 07 	movq   $0x7f000,-0x10(%rbp)
   412f7:	00 
    vamapping vam = virtual_memory_lookup(pt, kstack);
   412f8:	48 8d 45 d8          	lea    -0x28(%rbp),%rax
   412fc:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   41300:	48 8b 4d b8          	mov    -0x48(%rbp),%rcx
   41304:	48 89 ce             	mov    %rcx,%rsi
   41307:	48 89 c7             	mov    %rax,%rdi
   4130a:	e8 1e 1e 00 00       	call   4312d <virtual_memory_lookup>
    assert(vam.pa == kstack);
   4130f:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41313:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
   41317:	74 14                	je     4132d <check_page_table_mappings+0x121>
   41319:	ba 3f 48 04 00       	mov    $0x4483f,%edx
   4131e:	be 3e 02 00 00       	mov    $0x23e,%esi
   41323:	bf e0 45 04 00       	mov    $0x445e0,%edi
   41328:	e8 0e 17 00 00       	call   42a3b <assert_fail>
    assert(vam.perm & PTE_W);
   4132d:	8b 45 e8             	mov    -0x18(%rbp),%eax
   41330:	48 98                	cltq
   41332:	83 e0 02             	and    $0x2,%eax
   41335:	48 85 c0             	test   %rax,%rax
   41338:	75 14                	jne    4134e <check_page_table_mappings+0x142>
   4133a:	ba 2e 48 04 00       	mov    $0x4482e,%edx
   4133f:	be 3f 02 00 00       	mov    $0x23f,%esi
   41344:	bf e0 45 04 00       	mov    $0x445e0,%edi
   41349:	e8 ed 16 00 00       	call   42a3b <assert_fail>
}
   4134e:	90                   	nop
   4134f:	c9                   	leave
   41350:	c3                   	ret

0000000000041351 <check_page_table_ownership>:
//    counts for page table `pt`. Panic if any of the invariants are false.

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount);

void check_page_table_ownership(x86_64_pagetable* pt, pid_t pid) {
   41351:	55                   	push   %rbp
   41352:	48 89 e5             	mov    %rsp,%rbp
   41355:	48 83 ec 20          	sub    $0x20,%rsp
   41359:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   4135d:	89 75 e4             	mov    %esi,-0x1c(%rbp)
    // calculate expected reference count for page tables
    int owner = pid;
   41360:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   41363:	89 45 fc             	mov    %eax,-0x4(%rbp)
    int expected_refcount = 1;
   41366:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
    if (pt == kernel_pagetable) {
   4136d:	48 8b 05 8c 3c 01 00 	mov    0x13c8c(%rip),%rax        # 55000 <kernel_pagetable>
   41374:	48 39 45 e8          	cmp    %rax,-0x18(%rbp)
   41378:	75 67                	jne    413e1 <check_page_table_ownership+0x90>
        owner = PO_KERNEL;
   4137a:	c7 45 fc fe ff ff ff 	movl   $0xfffffffe,-0x4(%rbp)
        for (int xpid = 0; xpid < NPROC; ++xpid) {
   41381:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   41388:	eb 51                	jmp    413db <check_page_table_ownership+0x8a>
            if (processes[xpid].p_state != P_FREE
   4138a:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4138d:	48 63 d0             	movslq %eax,%rdx
   41390:	48 89 d0             	mov    %rdx,%rax
   41393:	48 c1 e0 03          	shl    $0x3,%rax
   41397:	48 29 d0             	sub    %rdx,%rax
   4139a:	48 c1 e0 05          	shl    $0x5,%rax
   4139e:	48 05 e8 20 05 00    	add    $0x520e8,%rax
   413a4:	8b 00                	mov    (%rax),%eax
   413a6:	85 c0                	test   %eax,%eax
   413a8:	74 2d                	je     413d7 <check_page_table_ownership+0x86>
                && processes[xpid].p_pagetable == kernel_pagetable) {
   413aa:	8b 45 f4             	mov    -0xc(%rbp),%eax
   413ad:	48 63 d0             	movslq %eax,%rdx
   413b0:	48 89 d0             	mov    %rdx,%rax
   413b3:	48 c1 e0 03          	shl    $0x3,%rax
   413b7:	48 29 d0             	sub    %rdx,%rax
   413ba:	48 c1 e0 05          	shl    $0x5,%rax
   413be:	48 05 f0 20 05 00    	add    $0x520f0,%rax
   413c4:	48 8b 10             	mov    (%rax),%rdx
   413c7:	48 8b 05 32 3c 01 00 	mov    0x13c32(%rip),%rax        # 55000 <kernel_pagetable>
   413ce:	48 39 c2             	cmp    %rax,%rdx
   413d1:	75 04                	jne    413d7 <check_page_table_ownership+0x86>
                ++expected_refcount;
   413d3:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
        for (int xpid = 0; xpid < NPROC; ++xpid) {
   413d7:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   413db:	83 7d f4 0f          	cmpl   $0xf,-0xc(%rbp)
   413df:	7e a9                	jle    4138a <check_page_table_ownership+0x39>
            }
        }
    }
    check_page_table_ownership_level(pt, 0, owner, expected_refcount);
   413e1:	8b 4d f8             	mov    -0x8(%rbp),%ecx
   413e4:	8b 55 fc             	mov    -0x4(%rbp),%edx
   413e7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   413eb:	be 00 00 00 00       	mov    $0x0,%esi
   413f0:	48 89 c7             	mov    %rax,%rdi
   413f3:	e8 03 00 00 00       	call   413fb <check_page_table_ownership_level>
}
   413f8:	90                   	nop
   413f9:	c9                   	leave
   413fa:	c3                   	ret

00000000000413fb <check_page_table_ownership_level>:

static void check_page_table_ownership_level(x86_64_pagetable* pt, int level,
                                             int owner, int refcount) {
   413fb:	55                   	push   %rbp
   413fc:	48 89 e5             	mov    %rsp,%rbp
   413ff:	48 83 ec 30          	sub    $0x30,%rsp
   41403:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   41407:	89 75 e4             	mov    %esi,-0x1c(%rbp)
   4140a:	89 55 e0             	mov    %edx,-0x20(%rbp)
   4140d:	89 4d dc             	mov    %ecx,-0x24(%rbp)
    assert(PAGENUMBER(pt) < NPAGES);
   41410:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41414:	48 c1 e8 0c          	shr    $0xc,%rax
   41418:	3d ff 01 00 00       	cmp    $0x1ff,%eax
   4141d:	7e 14                	jle    41433 <check_page_table_ownership_level+0x38>
   4141f:	ba 50 48 04 00       	mov    $0x44850,%edx
   41424:	be 5c 02 00 00       	mov    $0x25c,%esi
   41429:	bf e0 45 04 00       	mov    $0x445e0,%edi
   4142e:	e8 08 16 00 00       	call   42a3b <assert_fail>
    assert(pageinfo[PAGENUMBER(pt)].owner == owner);
   41433:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41437:	48 c1 e8 0c          	shr    $0xc,%rax
   4143b:	48 98                	cltq
   4143d:	0f b6 84 00 40 2e 05 	movzbl 0x52e40(%rax,%rax,1),%eax
   41444:	00 
   41445:	0f be c0             	movsbl %al,%eax
   41448:	39 45 e0             	cmp    %eax,-0x20(%rbp)
   4144b:	74 14                	je     41461 <check_page_table_ownership_level+0x66>
   4144d:	ba 68 48 04 00       	mov    $0x44868,%edx
   41452:	be 5d 02 00 00       	mov    $0x25d,%esi
   41457:	bf e0 45 04 00       	mov    $0x445e0,%edi
   4145c:	e8 da 15 00 00       	call   42a3b <assert_fail>
    assert(pageinfo[PAGENUMBER(pt)].refcount == refcount);
   41461:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41465:	48 c1 e8 0c          	shr    $0xc,%rax
   41469:	48 98                	cltq
   4146b:	0f b6 84 00 41 2e 05 	movzbl 0x52e41(%rax,%rax,1),%eax
   41472:	00 
   41473:	0f be c0             	movsbl %al,%eax
   41476:	39 45 dc             	cmp    %eax,-0x24(%rbp)
   41479:	74 14                	je     4148f <check_page_table_ownership_level+0x94>
   4147b:	ba 90 48 04 00       	mov    $0x44890,%edx
   41480:	be 5e 02 00 00       	mov    $0x25e,%esi
   41485:	bf e0 45 04 00       	mov    $0x445e0,%edi
   4148a:	e8 ac 15 00 00       	call   42a3b <assert_fail>
    if (level < 3) {
   4148f:	83 7d e4 02          	cmpl   $0x2,-0x1c(%rbp)
   41493:	7f 5b                	jg     414f0 <check_page_table_ownership_level+0xf5>
        for (int index = 0; index < NPAGETABLEENTRIES; ++index) {
   41495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4149c:	eb 49                	jmp    414e7 <check_page_table_ownership_level+0xec>
            if (pt->entry[index]) {
   4149e:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   414a2:	8b 55 fc             	mov    -0x4(%rbp),%edx
   414a5:	48 63 d2             	movslq %edx,%rdx
   414a8:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   414ac:	48 85 c0             	test   %rax,%rax
   414af:	74 32                	je     414e3 <check_page_table_ownership_level+0xe8>
                x86_64_pagetable* nextpt =
                    (x86_64_pagetable*) PTE_ADDR(pt->entry[index]);
   414b1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   414b5:	8b 55 fc             	mov    -0x4(%rbp),%edx
   414b8:	48 63 d2             	movslq %edx,%rdx
   414bb:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   414bf:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
                x86_64_pagetable* nextpt =
   414c5:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
                check_page_table_ownership_level(nextpt, level + 1, owner, 1);
   414c9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   414cc:	8d 70 01             	lea    0x1(%rax),%esi
   414cf:	8b 55 e0             	mov    -0x20(%rbp),%edx
   414d2:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   414d6:	b9 01 00 00 00       	mov    $0x1,%ecx
   414db:	48 89 c7             	mov    %rax,%rdi
   414de:	e8 18 ff ff ff       	call   413fb <check_page_table_ownership_level>
        for (int index = 0; index < NPAGETABLEENTRIES; ++index) {
   414e3:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   414e7:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   414ee:	7e ae                	jle    4149e <check_page_table_ownership_level+0xa3>
            }
        }
    }
}
   414f0:	90                   	nop
   414f1:	c9                   	leave
   414f2:	c3                   	ret

00000000000414f3 <check_virtual_memory>:

// check_virtual_memory
//    Check operating system invariants about virtual memory. Panic if any
//    of the invariants are false.

void check_virtual_memory(void) {
   414f3:	55                   	push   %rbp
   414f4:	48 89 e5             	mov    %rsp,%rbp
   414f7:	48 83 ec 10          	sub    $0x10,%rsp
    // Process 0 must never be used.
    assert(processes[0].p_state == P_FREE);
   414fb:	8b 05 e7 0b 01 00    	mov    0x10be7(%rip),%eax        # 520e8 <processes+0xc8>
   41501:	85 c0                	test   %eax,%eax
   41503:	74 14                	je     41519 <check_virtual_memory+0x26>
   41505:	ba c0 48 04 00       	mov    $0x448c0,%edx
   4150a:	be 71 02 00 00       	mov    $0x271,%esi
   4150f:	bf e0 45 04 00       	mov    $0x445e0,%edi
   41514:	e8 22 15 00 00       	call   42a3b <assert_fail>
    // that don't have their own page tables.
    // Active processes have their own page tables. A process page table
    // should be owned by that process and have reference count 1.
    // All level-2-4 page tables must have reference count 1.

    check_page_table_mappings(kernel_pagetable);
   41519:	48 8b 05 e0 3a 01 00 	mov    0x13ae0(%rip),%rax        # 55000 <kernel_pagetable>
   41520:	48 89 c7             	mov    %rax,%rdi
   41523:	e8 e4 fc ff ff       	call   4120c <check_page_table_mappings>
    check_page_table_ownership(kernel_pagetable, -1);
   41528:	48 8b 05 d1 3a 01 00 	mov    0x13ad1(%rip),%rax        # 55000 <kernel_pagetable>
   4152f:	be ff ff ff ff       	mov    $0xffffffff,%esi
   41534:	48 89 c7             	mov    %rax,%rdi
   41537:	e8 15 fe ff ff       	call   41351 <check_page_table_ownership>

    for (int pid = 0; pid < NPROC; ++pid) {
   4153c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   41543:	e9 9c 00 00 00       	jmp    415e4 <check_virtual_memory+0xf1>
        if (processes[pid].p_state != P_FREE
   41548:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4154b:	48 63 d0             	movslq %eax,%rdx
   4154e:	48 89 d0             	mov    %rdx,%rax
   41551:	48 c1 e0 03          	shl    $0x3,%rax
   41555:	48 29 d0             	sub    %rdx,%rax
   41558:	48 c1 e0 05          	shl    $0x5,%rax
   4155c:	48 05 e8 20 05 00    	add    $0x520e8,%rax
   41562:	8b 00                	mov    (%rax),%eax
   41564:	85 c0                	test   %eax,%eax
   41566:	74 78                	je     415e0 <check_virtual_memory+0xed>
            && processes[pid].p_pagetable != kernel_pagetable) {
   41568:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4156b:	48 63 d0             	movslq %eax,%rdx
   4156e:	48 89 d0             	mov    %rdx,%rax
   41571:	48 c1 e0 03          	shl    $0x3,%rax
   41575:	48 29 d0             	sub    %rdx,%rax
   41578:	48 c1 e0 05          	shl    $0x5,%rax
   4157c:	48 05 f0 20 05 00    	add    $0x520f0,%rax
   41582:	48 8b 10             	mov    (%rax),%rdx
   41585:	48 8b 05 74 3a 01 00 	mov    0x13a74(%rip),%rax        # 55000 <kernel_pagetable>
   4158c:	48 39 c2             	cmp    %rax,%rdx
   4158f:	74 4f                	je     415e0 <check_virtual_memory+0xed>
            check_page_table_mappings(processes[pid].p_pagetable);
   41591:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41594:	48 63 d0             	movslq %eax,%rdx
   41597:	48 89 d0             	mov    %rdx,%rax
   4159a:	48 c1 e0 03          	shl    $0x3,%rax
   4159e:	48 29 d0             	sub    %rdx,%rax
   415a1:	48 c1 e0 05          	shl    $0x5,%rax
   415a5:	48 05 f0 20 05 00    	add    $0x520f0,%rax
   415ab:	48 8b 00             	mov    (%rax),%rax
   415ae:	48 89 c7             	mov    %rax,%rdi
   415b1:	e8 56 fc ff ff       	call   4120c <check_page_table_mappings>
            check_page_table_ownership(processes[pid].p_pagetable, pid);
   415b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
   415b9:	48 63 d0             	movslq %eax,%rdx
   415bc:	48 89 d0             	mov    %rdx,%rax
   415bf:	48 c1 e0 03          	shl    $0x3,%rax
   415c3:	48 29 d0             	sub    %rdx,%rax
   415c6:	48 c1 e0 05          	shl    $0x5,%rax
   415ca:	48 05 f0 20 05 00    	add    $0x520f0,%rax
   415d0:	48 8b 00             	mov    (%rax),%rax
   415d3:	8b 55 fc             	mov    -0x4(%rbp),%edx
   415d6:	89 d6                	mov    %edx,%esi
   415d8:	48 89 c7             	mov    %rax,%rdi
   415db:	e8 71 fd ff ff       	call   41351 <check_page_table_ownership>
    for (int pid = 0; pid < NPROC; ++pid) {
   415e0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   415e4:	83 7d fc 0f          	cmpl   $0xf,-0x4(%rbp)
   415e8:	0f 8e 5a ff ff ff    	jle    41548 <check_virtual_memory+0x55>
        }
    }

    // Check that all referenced pages refer to active processes
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   415ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   415f5:	eb 67                	jmp    4165e <check_virtual_memory+0x16b>
        if (pageinfo[pn].refcount > 0 && pageinfo[pn].owner >= 0) {
   415f7:	8b 45 f8             	mov    -0x8(%rbp),%eax
   415fa:	48 98                	cltq
   415fc:	0f b6 84 00 41 2e 05 	movzbl 0x52e41(%rax,%rax,1),%eax
   41603:	00 
   41604:	84 c0                	test   %al,%al
   41606:	7e 52                	jle    4165a <check_virtual_memory+0x167>
   41608:	8b 45 f8             	mov    -0x8(%rbp),%eax
   4160b:	48 98                	cltq
   4160d:	0f b6 84 00 40 2e 05 	movzbl 0x52e40(%rax,%rax,1),%eax
   41614:	00 
   41615:	84 c0                	test   %al,%al
   41617:	78 41                	js     4165a <check_virtual_memory+0x167>
            assert(processes[pageinfo[pn].owner].p_state != P_FREE);
   41619:	8b 45 f8             	mov    -0x8(%rbp),%eax
   4161c:	48 98                	cltq
   4161e:	0f b6 84 00 40 2e 05 	movzbl 0x52e40(%rax,%rax,1),%eax
   41625:	00 
   41626:	0f be c0             	movsbl %al,%eax
   41629:	48 63 d0             	movslq %eax,%rdx
   4162c:	48 89 d0             	mov    %rdx,%rax
   4162f:	48 c1 e0 03          	shl    $0x3,%rax
   41633:	48 29 d0             	sub    %rdx,%rax
   41636:	48 c1 e0 05          	shl    $0x5,%rax
   4163a:	48 05 e8 20 05 00    	add    $0x520e8,%rax
   41640:	8b 00                	mov    (%rax),%eax
   41642:	85 c0                	test   %eax,%eax
   41644:	75 14                	jne    4165a <check_virtual_memory+0x167>
   41646:	ba e0 48 04 00       	mov    $0x448e0,%edx
   4164b:	be 88 02 00 00       	mov    $0x288,%esi
   41650:	bf e0 45 04 00       	mov    $0x445e0,%edi
   41655:	e8 e1 13 00 00       	call   42a3b <assert_fail>
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   4165a:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   4165e:	81 7d f8 ff 01 00 00 	cmpl   $0x1ff,-0x8(%rbp)
   41665:	7e 90                	jle    415f7 <check_virtual_memory+0x104>
        }
    }
}
   41667:	90                   	nop
   41668:	90                   	nop
   41669:	c9                   	leave
   4166a:	c3                   	ret

000000000004166b <memshow_physical>:
    'E' | 0x0E00, 'F' | 0x0F00, 'S'
};
#define SHARED_COLOR memstate_colors[18]
#define SHARED

void memshow_physical(void) {
   4166b:	55                   	push   %rbp
   4166c:	48 89 e5             	mov    %rsp,%rbp
   4166f:	48 83 ec 10          	sub    $0x10,%rsp
    console_printf(CPOS(0, 32), 0x0F00, "PHYSICAL MEMORY");
   41673:	ba 46 49 04 00       	mov    $0x44946,%edx
   41678:	be 00 0f 00 00       	mov    $0xf00,%esi
   4167d:	bf 20 00 00 00       	mov    $0x20,%edi
   41682:	b8 00 00 00 00       	mov    $0x0,%eax
   41687:	e8 93 2d 00 00       	call   4441f <console_printf>
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   4168c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   41693:	e9 f8 00 00 00       	jmp    41790 <memshow_physical+0x125>
        if (pn % 64 == 0) {
   41698:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4169b:	83 e0 3f             	and    $0x3f,%eax
   4169e:	85 c0                	test   %eax,%eax
   416a0:	75 3c                	jne    416de <memshow_physical+0x73>
            console_printf(CPOS(1 + pn / 64, 3), 0x0F00, "0x%06X ", pn << 12);
   416a2:	8b 45 fc             	mov    -0x4(%rbp),%eax
   416a5:	c1 e0 0c             	shl    $0xc,%eax
   416a8:	89 c1                	mov    %eax,%ecx
   416aa:	8b 45 fc             	mov    -0x4(%rbp),%eax
   416ad:	8d 50 3f             	lea    0x3f(%rax),%edx
   416b0:	85 c0                	test   %eax,%eax
   416b2:	0f 48 c2             	cmovs  %edx,%eax
   416b5:	c1 f8 06             	sar    $0x6,%eax
   416b8:	8d 50 01             	lea    0x1(%rax),%edx
   416bb:	89 d0                	mov    %edx,%eax
   416bd:	c1 e0 02             	shl    $0x2,%eax
   416c0:	01 d0                	add    %edx,%eax
   416c2:	c1 e0 04             	shl    $0x4,%eax
   416c5:	83 c0 03             	add    $0x3,%eax
   416c8:	ba 56 49 04 00       	mov    $0x44956,%edx
   416cd:	be 00 0f 00 00       	mov    $0xf00,%esi
   416d2:	89 c7                	mov    %eax,%edi
   416d4:	b8 00 00 00 00       	mov    $0x0,%eax
   416d9:	e8 41 2d 00 00       	call   4441f <console_printf>
        }

        int owner = pageinfo[pn].owner;
   416de:	8b 45 fc             	mov    -0x4(%rbp),%eax
   416e1:	48 98                	cltq
   416e3:	0f b6 84 00 40 2e 05 	movzbl 0x52e40(%rax,%rax,1),%eax
   416ea:	00 
   416eb:	0f be c0             	movsbl %al,%eax
   416ee:	89 45 f8             	mov    %eax,-0x8(%rbp)
        if (pageinfo[pn].refcount == 0) {
   416f1:	8b 45 fc             	mov    -0x4(%rbp),%eax
   416f4:	48 98                	cltq
   416f6:	0f b6 84 00 41 2e 05 	movzbl 0x52e41(%rax,%rax,1),%eax
   416fd:	00 
   416fe:	84 c0                	test   %al,%al
   41700:	75 07                	jne    41709 <memshow_physical+0x9e>
            owner = PO_FREE;
   41702:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
        }
        uint16_t color = memstate_colors[owner - PO_KERNEL];
   41709:	8b 45 f8             	mov    -0x8(%rbp),%eax
   4170c:	83 c0 02             	add    $0x2,%eax
   4170f:	48 98                	cltq
   41711:	0f b7 84 00 20 49 04 	movzwl 0x44920(%rax,%rax,1),%eax
   41718:	00 
   41719:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
        // darker color for shared pages
        if (pageinfo[pn].refcount > 1 && pn != PAGENUMBER(CONSOLE_ADDR)){
   4171d:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41720:	48 98                	cltq
   41722:	0f b6 84 00 41 2e 05 	movzbl 0x52e41(%rax,%rax,1),%eax
   41729:	00 
   4172a:	3c 01                	cmp    $0x1,%al
   4172c:	7e 1a                	jle    41748 <memshow_physical+0xdd>
   4172e:	b8 00 80 0b 00       	mov    $0xb8000,%eax
   41733:	48 c1 e8 0c          	shr    $0xc,%rax
   41737:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   4173a:	74 0c                	je     41748 <memshow_physical+0xdd>
#ifdef SHARED
            color = SHARED_COLOR | 0x0F00;
   4173c:	b8 53 00 00 00       	mov    $0x53,%eax
   41741:	80 cc 0f             	or     $0xf,%ah
   41744:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
#else
	    color &= 0x77FF;
#endif
        }

        console[CPOS(1 + pn / 64, 12 + pn % 64)] = color;
   41748:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4174b:	8d 50 3f             	lea    0x3f(%rax),%edx
   4174e:	85 c0                	test   %eax,%eax
   41750:	0f 48 c2             	cmovs  %edx,%eax
   41753:	c1 f8 06             	sar    $0x6,%eax
   41756:	8d 50 01             	lea    0x1(%rax),%edx
   41759:	89 d0                	mov    %edx,%eax
   4175b:	c1 e0 02             	shl    $0x2,%eax
   4175e:	01 d0                	add    %edx,%eax
   41760:	c1 e0 04             	shl    $0x4,%eax
   41763:	89 c1                	mov    %eax,%ecx
   41765:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41768:	89 d0                	mov    %edx,%eax
   4176a:	c1 f8 1f             	sar    $0x1f,%eax
   4176d:	c1 e8 1a             	shr    $0x1a,%eax
   41770:	01 c2                	add    %eax,%edx
   41772:	83 e2 3f             	and    $0x3f,%edx
   41775:	29 c2                	sub    %eax,%edx
   41777:	89 d0                	mov    %edx,%eax
   41779:	83 c0 0c             	add    $0xc,%eax
   4177c:	01 c8                	add    %ecx,%eax
   4177e:	48 98                	cltq
   41780:	0f b7 55 f6          	movzwl -0xa(%rbp),%edx
   41784:	66 89 94 00 00 80 0b 	mov    %dx,0xb8000(%rax,%rax,1)
   4178b:	00 
    for (int pn = 0; pn < PAGENUMBER(MEMSIZE_PHYSICAL); ++pn) {
   4178c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41790:	81 7d fc ff 01 00 00 	cmpl   $0x1ff,-0x4(%rbp)
   41797:	0f 8e fb fe ff ff    	jle    41698 <memshow_physical+0x2d>
    }
}
   4179d:	90                   	nop
   4179e:	90                   	nop
   4179f:	c9                   	leave
   417a0:	c3                   	ret

00000000000417a1 <memshow_virtual>:

// memshow_virtual(pagetable, name)
//    Draw a picture of the virtual memory map `pagetable` (named `name`) on
//    the CGA console.

void memshow_virtual(x86_64_pagetable* pagetable, const char* name) {
   417a1:	55                   	push   %rbp
   417a2:	48 89 e5             	mov    %rsp,%rbp
   417a5:	48 83 ec 40          	sub    $0x40,%rsp
   417a9:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   417ad:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
    assert((uintptr_t) pagetable == PTE_ADDR(pagetable));
   417b1:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   417b5:	25 ff 0f 00 00       	and    $0xfff,%eax
   417ba:	48 85 c0             	test   %rax,%rax
   417bd:	74 14                	je     417d3 <memshow_virtual+0x32>
   417bf:	ba 60 49 04 00       	mov    $0x44960,%edx
   417c4:	be b9 02 00 00       	mov    $0x2b9,%esi
   417c9:	bf e0 45 04 00       	mov    $0x445e0,%edi
   417ce:	e8 68 12 00 00       	call   42a3b <assert_fail>

    console_printf(CPOS(10, 26), 0x0F00, "VIRTUAL ADDRESS SPACE FOR %s", name);
   417d3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   417d7:	48 89 c1             	mov    %rax,%rcx
   417da:	ba 8d 49 04 00       	mov    $0x4498d,%edx
   417df:	be 00 0f 00 00       	mov    $0xf00,%esi
   417e4:	bf 3a 03 00 00       	mov    $0x33a,%edi
   417e9:	b8 00 00 00 00       	mov    $0x0,%eax
   417ee:	e8 2c 2c 00 00       	call   4441f <console_printf>
    for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   417f3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   417fa:	00 
   417fb:	e9 80 01 00 00       	jmp    41980 <memshow_virtual+0x1df>
        vamapping vam = virtual_memory_lookup(pagetable, va);
   41800:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   41804:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   41808:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   4180c:	48 89 ce             	mov    %rcx,%rsi
   4180f:	48 89 c7             	mov    %rax,%rdi
   41812:	e8 16 19 00 00       	call   4312d <virtual_memory_lookup>
        uint16_t color;
        if (vam.pn < 0) {
   41817:	8b 45 d0             	mov    -0x30(%rbp),%eax
   4181a:	85 c0                	test   %eax,%eax
   4181c:	79 0b                	jns    41829 <memshow_virtual+0x88>
            color = ' ';
   4181e:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%rbp)
   41824:	e9 d7 00 00 00       	jmp    41900 <memshow_virtual+0x15f>
        } else {
            assert(vam.pa < MEMSIZE_PHYSICAL);
   41829:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4182d:	48 3d ff ff 1f 00    	cmp    $0x1fffff,%rax
   41833:	76 14                	jbe    41849 <memshow_virtual+0xa8>
   41835:	ba aa 49 04 00       	mov    $0x449aa,%edx
   4183a:	be c2 02 00 00       	mov    $0x2c2,%esi
   4183f:	bf e0 45 04 00       	mov    $0x445e0,%edi
   41844:	e8 f2 11 00 00       	call   42a3b <assert_fail>
            int owner = pageinfo[vam.pn].owner;
   41849:	8b 45 d0             	mov    -0x30(%rbp),%eax
   4184c:	48 98                	cltq
   4184e:	0f b6 84 00 40 2e 05 	movzbl 0x52e40(%rax,%rax,1),%eax
   41855:	00 
   41856:	0f be c0             	movsbl %al,%eax
   41859:	89 45 f0             	mov    %eax,-0x10(%rbp)
            if (pageinfo[vam.pn].refcount == 0) {
   4185c:	8b 45 d0             	mov    -0x30(%rbp),%eax
   4185f:	48 98                	cltq
   41861:	0f b6 84 00 41 2e 05 	movzbl 0x52e41(%rax,%rax,1),%eax
   41868:	00 
   41869:	84 c0                	test   %al,%al
   4186b:	75 07                	jne    41874 <memshow_virtual+0xd3>
                owner = PO_FREE;
   4186d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%rbp)
            }
            color = memstate_colors[owner - PO_KERNEL];
   41874:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41877:	83 c0 02             	add    $0x2,%eax
   4187a:	48 98                	cltq
   4187c:	0f b7 84 00 20 49 04 	movzwl 0x44920(%rax,%rax,1),%eax
   41883:	00 
   41884:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
            // reverse video for user-accessible pages
            if (vam.perm & PTE_U) {
   41888:	8b 45 e0             	mov    -0x20(%rbp),%eax
   4188b:	48 98                	cltq
   4188d:	83 e0 04             	and    $0x4,%eax
   41890:	48 85 c0             	test   %rax,%rax
   41893:	74 27                	je     418bc <memshow_virtual+0x11b>
                color = ((color & 0x0F00) << 4) | ((color & 0xF000) >> 4)
   41895:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   41899:	c1 e0 04             	shl    $0x4,%eax
   4189c:	66 25 00 f0          	and    $0xf000,%ax
   418a0:	89 c2                	mov    %eax,%edx
   418a2:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   418a6:	c1 f8 04             	sar    $0x4,%eax
   418a9:	66 25 00 0f          	and    $0xf00,%ax
   418ad:	09 c2                	or     %eax,%edx
                    | (color & 0x00FF);
   418af:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   418b3:	0f b6 c0             	movzbl %al,%eax
   418b6:	09 d0                	or     %edx,%eax
                color = ((color & 0x0F00) << 4) | ((color & 0xF000) >> 4)
   418b8:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
            }
            // darker color for shared pages
            if (pageinfo[vam.pn].refcount > 1 && va != CONSOLE_ADDR) {
   418bc:	8b 45 d0             	mov    -0x30(%rbp),%eax
   418bf:	48 98                	cltq
   418c1:	0f b6 84 00 41 2e 05 	movzbl 0x52e41(%rax,%rax,1),%eax
   418c8:	00 
   418c9:	3c 01                	cmp    $0x1,%al
   418cb:	7e 33                	jle    41900 <memshow_virtual+0x15f>
   418cd:	b8 00 80 0b 00       	mov    $0xb8000,%eax
   418d2:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   418d6:	74 28                	je     41900 <memshow_virtual+0x15f>
#ifdef SHARED
                color = (SHARED_COLOR | (color & 0xF000));
   418d8:	b8 53 00 00 00       	mov    $0x53,%eax
   418dd:	89 c2                	mov    %eax,%edx
   418df:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   418e3:	66 25 00 f0          	and    $0xf000,%ax
   418e7:	09 d0                	or     %edx,%eax
   418e9:	66 89 45 f6          	mov    %ax,-0xa(%rbp)
                if(! (vam.perm & PTE_U))
   418ed:	8b 45 e0             	mov    -0x20(%rbp),%eax
   418f0:	48 98                	cltq
   418f2:	83 e0 04             	and    $0x4,%eax
   418f5:	48 85 c0             	test   %rax,%rax
   418f8:	75 06                	jne    41900 <memshow_virtual+0x15f>
                    color = color | 0x0F00;
   418fa:	66 81 4d f6 00 0f    	orw    $0xf00,-0xa(%rbp)
#else
		color &= 0x77FF;
#endif
            }
        }
        uint32_t pn = PAGENUMBER(va);
   41900:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41904:	48 c1 e8 0c          	shr    $0xc,%rax
   41908:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (pn % 64 == 0) {
   4190b:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4190e:	83 e0 3f             	and    $0x3f,%eax
   41911:	85 c0                	test   %eax,%eax
   41913:	75 34                	jne    41949 <memshow_virtual+0x1a8>
            console_printf(CPOS(11 + pn / 64, 3), 0x0F00, "0x%06X ", va);
   41915:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41918:	c1 e8 06             	shr    $0x6,%eax
   4191b:	89 c2                	mov    %eax,%edx
   4191d:	89 d0                	mov    %edx,%eax
   4191f:	c1 e0 02             	shl    $0x2,%eax
   41922:	01 d0                	add    %edx,%eax
   41924:	c1 e0 04             	shl    $0x4,%eax
   41927:	05 73 03 00 00       	add    $0x373,%eax
   4192c:	89 c7                	mov    %eax,%edi
   4192e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41932:	48 89 c1             	mov    %rax,%rcx
   41935:	ba 56 49 04 00       	mov    $0x44956,%edx
   4193a:	be 00 0f 00 00       	mov    $0xf00,%esi
   4193f:	b8 00 00 00 00       	mov    $0x0,%eax
   41944:	e8 d6 2a 00 00       	call   4441f <console_printf>
        }
        console[CPOS(11 + pn / 64, 12 + pn % 64)] = color;
   41949:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4194c:	c1 e8 06             	shr    $0x6,%eax
   4194f:	89 c2                	mov    %eax,%edx
   41951:	89 d0                	mov    %edx,%eax
   41953:	c1 e0 02             	shl    $0x2,%eax
   41956:	01 d0                	add    %edx,%eax
   41958:	c1 e0 04             	shl    $0x4,%eax
   4195b:	89 c2                	mov    %eax,%edx
   4195d:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41960:	83 e0 3f             	and    $0x3f,%eax
   41963:	01 d0                	add    %edx,%eax
   41965:	05 7c 03 00 00       	add    $0x37c,%eax
   4196a:	89 c2                	mov    %eax,%edx
   4196c:	0f b7 45 f6          	movzwl -0xa(%rbp),%eax
   41970:	66 89 84 12 00 80 0b 	mov    %ax,0xb8000(%rdx,%rdx,1)
   41977:	00 
    for (uintptr_t va = 0; va < MEMSIZE_VIRTUAL; va += PAGESIZE) {
   41978:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   4197f:	00 
   41980:	48 81 7d f8 ff ff 2f 	cmpq   $0x2fffff,-0x8(%rbp)
   41987:	00 
   41988:	0f 86 72 fe ff ff    	jbe    41800 <memshow_virtual+0x5f>
    }
}
   4198e:	90                   	nop
   4198f:	90                   	nop
   41990:	c9                   	leave
   41991:	c3                   	ret

0000000000041992 <memshow_virtual_animate>:

// memshow_virtual_animate
//    Draw a picture of process virtual memory maps on the CGA console.
//    Starts with process 1, then switches to a new process every 0.25 sec.

void memshow_virtual_animate(void) {
   41992:	55                   	push   %rbp
   41993:	48 89 e5             	mov    %rsp,%rbp
   41996:	48 83 ec 10          	sub    $0x10,%rsp
    static unsigned last_ticks = 0;
    static int showing = 1;

    // switch to a new process every 0.25 sec
    if (last_ticks == 0 || ticks - last_ticks >= HZ / 2) {
   4199a:	8b 05 a0 18 01 00    	mov    0x118a0(%rip),%eax        # 53240 <last_ticks.1>
   419a0:	85 c0                	test   %eax,%eax
   419a2:	74 13                	je     419b7 <memshow_virtual_animate+0x25>
   419a4:	8b 15 76 14 01 00    	mov    0x11476(%rip),%edx        # 52e20 <ticks>
   419aa:	8b 05 90 18 01 00    	mov    0x11890(%rip),%eax        # 53240 <last_ticks.1>
   419b0:	29 c2                	sub    %eax,%edx
   419b2:	83 fa 31             	cmp    $0x31,%edx
   419b5:	76 2c                	jbe    419e3 <memshow_virtual_animate+0x51>
        last_ticks = ticks;
   419b7:	8b 05 63 14 01 00    	mov    0x11463(%rip),%eax        # 52e20 <ticks>
   419bd:	89 05 7d 18 01 00    	mov    %eax,0x1187d(%rip)        # 53240 <last_ticks.1>
        ++showing;
   419c3:	8b 05 3b 46 00 00    	mov    0x463b(%rip),%eax        # 46004 <showing.0>
   419c9:	83 c0 01             	add    $0x1,%eax
   419cc:	89 05 32 46 00 00    	mov    %eax,0x4632(%rip)        # 46004 <showing.0>
    }

    // the current process may have died -- don't display it if so
    while (showing <= 2*NPROC
   419d2:	eb 0f                	jmp    419e3 <memshow_virtual_animate+0x51>
           && (processes[showing % NPROC].p_state == P_FREE || processes[showing % NPROC].display_status == 0)) {
        ++showing;
   419d4:	8b 05 2a 46 00 00    	mov    0x462a(%rip),%eax        # 46004 <showing.0>
   419da:	83 c0 01             	add    $0x1,%eax
   419dd:	89 05 21 46 00 00    	mov    %eax,0x4621(%rip)        # 46004 <showing.0>
    while (showing <= 2*NPROC
   419e3:	8b 05 1b 46 00 00    	mov    0x461b(%rip),%eax        # 46004 <showing.0>
           && (processes[showing % NPROC].p_state == P_FREE || processes[showing % NPROC].display_status == 0)) {
   419e9:	83 f8 20             	cmp    $0x20,%eax
   419ec:	7f 6d                	jg     41a5b <memshow_virtual_animate+0xc9>
   419ee:	8b 15 10 46 00 00    	mov    0x4610(%rip),%edx        # 46004 <showing.0>
   419f4:	89 d0                	mov    %edx,%eax
   419f6:	c1 f8 1f             	sar    $0x1f,%eax
   419f9:	c1 e8 1c             	shr    $0x1c,%eax
   419fc:	01 c2                	add    %eax,%edx
   419fe:	83 e2 0f             	and    $0xf,%edx
   41a01:	29 c2                	sub    %eax,%edx
   41a03:	89 d0                	mov    %edx,%eax
   41a05:	48 63 d0             	movslq %eax,%rdx
   41a08:	48 89 d0             	mov    %rdx,%rax
   41a0b:	48 c1 e0 03          	shl    $0x3,%rax
   41a0f:	48 29 d0             	sub    %rdx,%rax
   41a12:	48 c1 e0 05          	shl    $0x5,%rax
   41a16:	48 05 e8 20 05 00    	add    $0x520e8,%rax
   41a1c:	8b 00                	mov    (%rax),%eax
   41a1e:	85 c0                	test   %eax,%eax
   41a20:	74 b2                	je     419d4 <memshow_virtual_animate+0x42>
   41a22:	8b 15 dc 45 00 00    	mov    0x45dc(%rip),%edx        # 46004 <showing.0>
   41a28:	89 d0                	mov    %edx,%eax
   41a2a:	c1 f8 1f             	sar    $0x1f,%eax
   41a2d:	c1 e8 1c             	shr    $0x1c,%eax
   41a30:	01 c2                	add    %eax,%edx
   41a32:	83 e2 0f             	and    $0xf,%edx
   41a35:	29 c2                	sub    %eax,%edx
   41a37:	89 d0                	mov    %edx,%eax
   41a39:	48 63 d0             	movslq %eax,%rdx
   41a3c:	48 89 d0             	mov    %rdx,%rax
   41a3f:	48 c1 e0 03          	shl    $0x3,%rax
   41a43:	48 29 d0             	sub    %rdx,%rax
   41a46:	48 c1 e0 05          	shl    $0x5,%rax
   41a4a:	48 05 f8 20 05 00    	add    $0x520f8,%rax
   41a50:	0f b6 00             	movzbl (%rax),%eax
   41a53:	84 c0                	test   %al,%al
   41a55:	0f 84 79 ff ff ff    	je     419d4 <memshow_virtual_animate+0x42>
    }
    showing = showing % NPROC;
   41a5b:	8b 15 a3 45 00 00    	mov    0x45a3(%rip),%edx        # 46004 <showing.0>
   41a61:	89 d0                	mov    %edx,%eax
   41a63:	c1 f8 1f             	sar    $0x1f,%eax
   41a66:	c1 e8 1c             	shr    $0x1c,%eax
   41a69:	01 c2                	add    %eax,%edx
   41a6b:	83 e2 0f             	and    $0xf,%edx
   41a6e:	29 c2                	sub    %eax,%edx
   41a70:	89 d0                	mov    %edx,%eax
   41a72:	89 05 8c 45 00 00    	mov    %eax,0x458c(%rip)        # 46004 <showing.0>

    if (processes[showing].p_state != P_FREE) {
   41a78:	8b 05 86 45 00 00    	mov    0x4586(%rip),%eax        # 46004 <showing.0>
   41a7e:	48 63 d0             	movslq %eax,%rdx
   41a81:	48 89 d0             	mov    %rdx,%rax
   41a84:	48 c1 e0 03          	shl    $0x3,%rax
   41a88:	48 29 d0             	sub    %rdx,%rax
   41a8b:	48 c1 e0 05          	shl    $0x5,%rax
   41a8f:	48 05 e8 20 05 00    	add    $0x520e8,%rax
   41a95:	8b 00                	mov    (%rax),%eax
   41a97:	85 c0                	test   %eax,%eax
   41a99:	74 52                	je     41aed <memshow_virtual_animate+0x15b>
        char s[4];
        snprintf(s, 4, "%d ", showing);
   41a9b:	8b 15 63 45 00 00    	mov    0x4563(%rip),%edx        # 46004 <showing.0>
   41aa1:	48 8d 45 fc          	lea    -0x4(%rbp),%rax
   41aa5:	89 d1                	mov    %edx,%ecx
   41aa7:	ba c4 49 04 00       	mov    $0x449c4,%edx
   41aac:	be 04 00 00 00       	mov    $0x4,%esi
   41ab1:	48 89 c7             	mov    %rax,%rdi
   41ab4:	b8 00 00 00 00       	mov    $0x0,%eax
   41ab9:	e8 6d 2a 00 00       	call   4452b <snprintf>
        memshow_virtual(processes[showing].p_pagetable, s);
   41abe:	8b 05 40 45 00 00    	mov    0x4540(%rip),%eax        # 46004 <showing.0>
   41ac4:	48 63 d0             	movslq %eax,%rdx
   41ac7:	48 89 d0             	mov    %rdx,%rax
   41aca:	48 c1 e0 03          	shl    $0x3,%rax
   41ace:	48 29 d0             	sub    %rdx,%rax
   41ad1:	48 c1 e0 05          	shl    $0x5,%rax
   41ad5:	48 05 f0 20 05 00    	add    $0x520f0,%rax
   41adb:	48 8b 00             	mov    (%rax),%rax
   41ade:	48 8d 55 fc          	lea    -0x4(%rbp),%rdx
   41ae2:	48 89 d6             	mov    %rdx,%rsi
   41ae5:	48 89 c7             	mov    %rax,%rdi
   41ae8:	e8 b4 fc ff ff       	call   417a1 <memshow_virtual>
    }
}
   41aed:	90                   	nop
   41aee:	c9                   	leave
   41aef:	c3                   	ret

0000000000041af0 <hardware_init>:

static void segments_init(void);
static void interrupt_init(void);
extern void virtual_memory_init(void);

void hardware_init(void) {
   41af0:	55                   	push   %rbp
   41af1:	48 89 e5             	mov    %rsp,%rbp
    segments_init();
   41af4:	e8 4f 01 00 00       	call   41c48 <segments_init>
    interrupt_init();
   41af9:	e8 d0 03 00 00       	call   41ece <interrupt_init>
    virtual_memory_init();
   41afe:	e8 f3 0f 00 00       	call   42af6 <virtual_memory_init>
}
   41b03:	90                   	nop
   41b04:	5d                   	pop    %rbp
   41b05:	c3                   	ret

0000000000041b06 <set_app_segment>:
#define SEGSEL_TASKSTATE        0x28            // task state segment

// Segments
static uint64_t segments[7];

static void set_app_segment(uint64_t* segment, uint64_t type, int dpl) {
   41b06:	55                   	push   %rbp
   41b07:	48 89 e5             	mov    %rsp,%rbp
   41b0a:	48 83 ec 18          	sub    $0x18,%rsp
   41b0e:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41b12:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41b16:	89 55 ec             	mov    %edx,-0x14(%rbp)
    *segment = type
        | X86SEG_S                    // code/data segment
        | ((uint64_t) dpl << 45)
   41b19:	8b 45 ec             	mov    -0x14(%rbp),%eax
   41b1c:	48 98                	cltq
   41b1e:	48 c1 e0 2d          	shl    $0x2d,%rax
   41b22:	48 0b 45 f0          	or     -0x10(%rbp),%rax
        | X86SEG_P;                   // segment present
   41b26:	48 ba 00 00 00 00 00 	movabs $0x900000000000,%rdx
   41b2d:	90 00 00 
   41b30:	48 09 c2             	or     %rax,%rdx
    *segment = type
   41b33:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41b37:	48 89 10             	mov    %rdx,(%rax)
}
   41b3a:	90                   	nop
   41b3b:	c9                   	leave
   41b3c:	c3                   	ret

0000000000041b3d <set_sys_segment>:

static void set_sys_segment(uint64_t* segment, uint64_t type, int dpl,
                            uintptr_t addr, size_t size) {
   41b3d:	55                   	push   %rbp
   41b3e:	48 89 e5             	mov    %rsp,%rbp
   41b41:	48 83 ec 28          	sub    $0x28,%rsp
   41b45:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41b49:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41b4d:	89 55 ec             	mov    %edx,-0x14(%rbp)
   41b50:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
   41b54:	4c 89 45 d8          	mov    %r8,-0x28(%rbp)
    segment[0] = ((addr & 0x0000000000FFFFFFUL) << 16)
   41b58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41b5c:	48 c1 e0 10          	shl    $0x10,%rax
   41b60:	48 89 c2             	mov    %rax,%rdx
   41b63:	48 b8 00 00 ff ff ff 	movabs $0xffffff0000,%rax
   41b6a:	00 00 00 
   41b6d:	48 21 c2             	and    %rax,%rdx
        | ((addr & 0x00000000FF000000UL) << 32)
   41b70:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41b74:	48 c1 e0 20          	shl    $0x20,%rax
   41b78:	48 89 c1             	mov    %rax,%rcx
   41b7b:	48 b8 00 00 00 00 00 	movabs $0xff00000000000000,%rax
   41b82:	00 00 ff 
   41b85:	48 21 c8             	and    %rcx,%rax
   41b88:	48 09 c2             	or     %rax,%rdx
        | ((size - 1) & 0x0FFFFUL)
   41b8b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   41b8f:	48 83 e8 01          	sub    $0x1,%rax
   41b93:	0f b7 c0             	movzwl %ax,%eax
        | (((size - 1) & 0xF0000UL) << 48)
   41b96:	48 09 d0             	or     %rdx,%rax
        | type
   41b99:	48 0b 45 f0          	or     -0x10(%rbp),%rax
        | ((uint64_t) dpl << 45)
   41b9d:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41ba0:	48 63 d2             	movslq %edx,%rdx
   41ba3:	48 c1 e2 2d          	shl    $0x2d,%rdx
   41ba7:	48 09 c2             	or     %rax,%rdx
        | X86SEG_P;                   // segment present
   41baa:	48 b8 00 00 00 00 00 	movabs $0x800000000000,%rax
   41bb1:	80 00 00 
   41bb4:	48 09 c2             	or     %rax,%rdx
    segment[0] = ((addr & 0x0000000000FFFFFFUL) << 16)
   41bb7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41bbb:	48 89 10             	mov    %rdx,(%rax)
    segment[1] = addr >> 32;
   41bbe:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41bc2:	48 83 c0 08          	add    $0x8,%rax
   41bc6:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   41bca:	48 c1 ea 20          	shr    $0x20,%rdx
   41bce:	48 89 10             	mov    %rdx,(%rax)
}
   41bd1:	90                   	nop
   41bd2:	c9                   	leave
   41bd3:	c3                   	ret

0000000000041bd4 <set_gate>:

// Processor state for taking an interrupt
static x86_64_taskstate kernel_task_descriptor;

static void set_gate(x86_64_gatedescriptor* gate, uint64_t type, int dpl,
                     uintptr_t function) {
   41bd4:	55                   	push   %rbp
   41bd5:	48 89 e5             	mov    %rsp,%rbp
   41bd8:	48 83 ec 20          	sub    $0x20,%rsp
   41bdc:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   41be0:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
   41be4:	89 55 ec             	mov    %edx,-0x14(%rbp)
   41be7:	48 89 4d e0          	mov    %rcx,-0x20(%rbp)
    gate->gd_low = (function & 0x000000000000FFFFUL)
   41beb:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41bef:	0f b7 c0             	movzwl %ax,%eax
        | (SEGSEL_KERN_CODE << 16)
        | type
   41bf2:	48 0b 45 f0          	or     -0x10(%rbp),%rax
        | ((uint64_t) dpl << 45)
   41bf6:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41bf9:	48 63 d2             	movslq %edx,%rdx
   41bfc:	48 c1 e2 2d          	shl    $0x2d,%rdx
   41c00:	48 09 c2             	or     %rax,%rdx
        | X86SEG_P
        | ((function & 0x00000000FFFF0000UL) << 32);
   41c03:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41c07:	48 c1 e0 20          	shl    $0x20,%rax
   41c0b:	48 89 c1             	mov    %rax,%rcx
   41c0e:	48 b8 00 00 00 00 00 	movabs $0xffff000000000000,%rax
   41c15:	00 ff ff 
   41c18:	48 21 c8             	and    %rcx,%rax
   41c1b:	48 09 c2             	or     %rax,%rdx
   41c1e:	48 b8 00 00 08 00 00 	movabs $0x800000080000,%rax
   41c25:	80 00 00 
   41c28:	48 09 c2             	or     %rax,%rdx
    gate->gd_low = (function & 0x000000000000FFFFUL)
   41c2b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41c2f:	48 89 10             	mov    %rdx,(%rax)
    gate->gd_high = function >> 32;
   41c32:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   41c36:	48 c1 e8 20          	shr    $0x20,%rax
   41c3a:	48 89 c2             	mov    %rax,%rdx
   41c3d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   41c41:	48 89 50 08          	mov    %rdx,0x8(%rax)
}
   41c45:	90                   	nop
   41c46:	c9                   	leave
   41c47:	c3                   	ret

0000000000041c48 <segments_init>:
extern void default_int_handler(void);
extern void gpf_int_handler(void);
extern void pagefault_int_handler(void);
extern void timer_int_handler(void);

void segments_init(void) {
   41c48:	55                   	push   %rbp
   41c49:	48 89 e5             	mov    %rsp,%rbp
   41c4c:	48 83 ec 40          	sub    $0x40,%rsp
    // Segments for kernel & user code & data
    // The privilege level, which can be 0 or 3, differentiates between
    // kernel and user code. (Data segments are unused in WeensyOS.)
    segments[0] = 0;
   41c50:	48 c7 05 05 16 01 00 	movq   $0x0,0x11605(%rip)        # 53260 <segments>
   41c57:	00 00 00 00 
    set_app_segment(&segments[SEGSEL_KERN_CODE >> 3], X86SEG_X | X86SEG_L, 0);
   41c5b:	ba 00 00 00 00       	mov    $0x0,%edx
   41c60:	48 b8 00 00 00 00 00 	movabs $0x20080000000000,%rax
   41c67:	08 20 00 
   41c6a:	48 89 c6             	mov    %rax,%rsi
   41c6d:	bf 68 32 05 00       	mov    $0x53268,%edi
   41c72:	e8 8f fe ff ff       	call   41b06 <set_app_segment>
    set_app_segment(&segments[SEGSEL_APP_CODE >> 3], X86SEG_X | X86SEG_L, 3);
   41c77:	ba 03 00 00 00       	mov    $0x3,%edx
   41c7c:	48 b8 00 00 00 00 00 	movabs $0x20080000000000,%rax
   41c83:	08 20 00 
   41c86:	48 89 c6             	mov    %rax,%rsi
   41c89:	bf 70 32 05 00       	mov    $0x53270,%edi
   41c8e:	e8 73 fe ff ff       	call   41b06 <set_app_segment>
    set_app_segment(&segments[SEGSEL_KERN_DATA >> 3], X86SEG_W, 0);
   41c93:	ba 00 00 00 00       	mov    $0x0,%edx
   41c98:	48 b8 00 00 00 00 00 	movabs $0x20000000000,%rax
   41c9f:	02 00 00 
   41ca2:	48 89 c6             	mov    %rax,%rsi
   41ca5:	bf 78 32 05 00       	mov    $0x53278,%edi
   41caa:	e8 57 fe ff ff       	call   41b06 <set_app_segment>
    set_app_segment(&segments[SEGSEL_APP_DATA >> 3], X86SEG_W, 3);
   41caf:	ba 03 00 00 00       	mov    $0x3,%edx
   41cb4:	48 b8 00 00 00 00 00 	movabs $0x20000000000,%rax
   41cbb:	02 00 00 
   41cbe:	48 89 c6             	mov    %rax,%rsi
   41cc1:	bf 80 32 05 00       	mov    $0x53280,%edi
   41cc6:	e8 3b fe ff ff       	call   41b06 <set_app_segment>
    set_sys_segment(&segments[SEGSEL_TASKSTATE >> 3], X86SEG_TSS, 0,
   41ccb:	b8 a0 42 05 00       	mov    $0x542a0,%eax
   41cd0:	41 b8 60 00 00 00    	mov    $0x60,%r8d
   41cd6:	48 89 c1             	mov    %rax,%rcx
   41cd9:	ba 00 00 00 00       	mov    $0x0,%edx
   41cde:	48 b8 00 00 00 00 00 	movabs $0x90000000000,%rax
   41ce5:	09 00 00 
   41ce8:	48 89 c6             	mov    %rax,%rsi
   41ceb:	bf 88 32 05 00       	mov    $0x53288,%edi
   41cf0:	e8 48 fe ff ff       	call   41b3d <set_sys_segment>
                    (uintptr_t) &kernel_task_descriptor,
                    sizeof(kernel_task_descriptor));

    x86_64_pseudodescriptor gdt;
    gdt.pseudod_limit = sizeof(segments) - 1;
   41cf5:	66 c7 45 d6 37 00    	movw   $0x37,-0x2a(%rbp)
    gdt.pseudod_base = (uint64_t) segments;
   41cfb:	b8 60 32 05 00       	mov    $0x53260,%eax
   41d00:	48 89 45 d8          	mov    %rax,-0x28(%rbp)

    // Kernel task descriptor lets us receive interrupts
    memset(&kernel_task_descriptor, 0, sizeof(kernel_task_descriptor));
   41d04:	ba 60 00 00 00       	mov    $0x60,%edx
   41d09:	be 00 00 00 00       	mov    $0x0,%esi
   41d0e:	bf a0 42 05 00       	mov    $0x542a0,%edi
   41d13:	e8 50 19 00 00       	call   43668 <memset>
    kernel_task_descriptor.ts_rsp[0] = KERNEL_STACK_TOP;
   41d18:	48 c7 05 81 25 01 00 	movq   $0x80000,0x12581(%rip)        # 542a4 <kernel_task_descriptor+0x4>
   41d1f:	00 00 08 00 

    // Interrupt handler; most interrupts are effectively ignored
    memset(interrupt_descriptors, 0, sizeof(interrupt_descriptors));
   41d23:	ba 00 10 00 00       	mov    $0x1000,%edx
   41d28:	be 00 00 00 00       	mov    $0x0,%esi
   41d2d:	bf a0 32 05 00       	mov    $0x532a0,%edi
   41d32:	e8 31 19 00 00       	call   43668 <memset>
    for (unsigned i = 16; i < arraysize(interrupt_descriptors); ++i) {
   41d37:	c7 45 fc 10 00 00 00 	movl   $0x10,-0x4(%rbp)
   41d3e:	eb 30                	jmp    41d70 <segments_init+0x128>
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 0,
   41d40:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   41d45:	8b 45 fc             	mov    -0x4(%rbp),%eax
   41d48:	48 c1 e0 04          	shl    $0x4,%rax
   41d4c:	48 05 a0 32 05 00    	add    $0x532a0,%rax
   41d52:	48 89 d1             	mov    %rdx,%rcx
   41d55:	ba 00 00 00 00       	mov    $0x0,%edx
   41d5a:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41d61:	0e 00 00 
   41d64:	48 89 c7             	mov    %rax,%rdi
   41d67:	e8 68 fe ff ff       	call   41bd4 <set_gate>
    for (unsigned i = 16; i < arraysize(interrupt_descriptors); ++i) {
   41d6c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   41d70:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%rbp)
   41d77:	76 c7                	jbe    41d40 <segments_init+0xf8>
                 (uint64_t) default_int_handler);
    }

    // Timer interrupt
    set_gate(&interrupt_descriptors[INT_TIMER], X86GATE_INTERRUPT, 0,
   41d79:	b8 36 00 04 00       	mov    $0x40036,%eax
   41d7e:	48 89 c1             	mov    %rax,%rcx
   41d81:	ba 00 00 00 00       	mov    $0x0,%edx
   41d86:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   41d8d:	0e 00 00 
   41d90:	48 89 c6             	mov    %rax,%rsi
   41d93:	bf a0 34 05 00       	mov    $0x534a0,%edi
   41d98:	e8 37 fe ff ff       	call   41bd4 <set_gate>
             (uint64_t) timer_int_handler);

    // GPF and page fault
    set_gate(&interrupt_descriptors[INT_GPF], X86GATE_INTERRUPT, 0,
   41d9d:	b8 2e 00 04 00       	mov    $0x4002e,%eax
   41da2:	48 89 c1             	mov    %rax,%rcx
   41da5:	ba 00 00 00 00       	mov    $0x0,%edx
   41daa:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   41db1:	0e 00 00 
   41db4:	48 89 c6             	mov    %rax,%rsi
   41db7:	bf 70 33 05 00       	mov    $0x53370,%edi
   41dbc:	e8 13 fe ff ff       	call   41bd4 <set_gate>
             (uint64_t) gpf_int_handler);
    set_gate(&interrupt_descriptors[INT_PAGEFAULT], X86GATE_INTERRUPT, 0,
   41dc1:	b8 32 00 04 00       	mov    $0x40032,%eax
   41dc6:	48 89 c1             	mov    %rax,%rcx
   41dc9:	ba 00 00 00 00       	mov    $0x0,%edx
   41dce:	48 b8 00 00 00 00 00 	movabs $0xe0000000000,%rax
   41dd5:	0e 00 00 
   41dd8:	48 89 c6             	mov    %rax,%rsi
   41ddb:	bf 80 33 05 00       	mov    $0x53380,%edi
   41de0:	e8 ef fd ff ff       	call   41bd4 <set_gate>
             (uint64_t) pagefault_int_handler);

    // System calls get special handling.
    // Note that the last argument is '3'.  This means that unprivileged
    // (level-3) applications may generate these interrupts.
    for (unsigned i = INT_SYS; i < INT_SYS + 16; ++i) {
   41de5:	c7 45 f8 30 00 00 00 	movl   $0x30,-0x8(%rbp)
   41dec:	eb 3e                	jmp    41e2c <segments_init+0x1e4>
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 3,
                 (uint64_t) sys_int_handlers[i - INT_SYS]);
   41dee:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41df1:	83 e8 30             	sub    $0x30,%eax
   41df4:	89 c0                	mov    %eax,%eax
   41df6:	48 8b 04 c5 e7 00 04 	mov    0x400e7(,%rax,8),%rax
   41dfd:	00 
        set_gate(&interrupt_descriptors[i], X86GATE_INTERRUPT, 3,
   41dfe:	48 89 c2             	mov    %rax,%rdx
   41e01:	8b 45 f8             	mov    -0x8(%rbp),%eax
   41e04:	48 c1 e0 04          	shl    $0x4,%rax
   41e08:	48 05 a0 32 05 00    	add    $0x532a0,%rax
   41e0e:	48 89 d1             	mov    %rdx,%rcx
   41e11:	ba 03 00 00 00       	mov    $0x3,%edx
   41e16:	48 be 00 00 00 00 00 	movabs $0xe0000000000,%rsi
   41e1d:	0e 00 00 
   41e20:	48 89 c7             	mov    %rax,%rdi
   41e23:	e8 ac fd ff ff       	call   41bd4 <set_gate>
    for (unsigned i = INT_SYS; i < INT_SYS + 16; ++i) {
   41e28:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   41e2c:	83 7d f8 3f          	cmpl   $0x3f,-0x8(%rbp)
   41e30:	76 bc                	jbe    41dee <segments_init+0x1a6>
    }

    x86_64_pseudodescriptor idt;
    idt.pseudod_limit = sizeof(interrupt_descriptors) - 1;
   41e32:	66 c7 45 cc ff 0f    	movw   $0xfff,-0x34(%rbp)
    idt.pseudod_base = (uint64_t) interrupt_descriptors;
   41e38:	b8 a0 32 05 00       	mov    $0x532a0,%eax
   41e3d:	48 89 45 ce          	mov    %rax,-0x32(%rbp)

    // Reload segment pointers
    asm volatile("lgdt %0\n\t"
   41e41:	b8 28 00 00 00       	mov    $0x28,%eax
   41e46:	0f 01 55 d6          	lgdt   -0x2a(%rbp)
   41e4a:	0f 00 d8             	ltr    %ax
   41e4d:	0f 01 5d cc          	lidt   -0x34(%rbp)
    asm volatile("movq %%cr0,%0" : "=r" (val));
   41e51:	0f 20 c0             	mov    %cr0,%rax
   41e54:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    return val;
   41e58:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
                     "r" ((uint16_t) SEGSEL_TASKSTATE),
                     "m" (idt)
                 : "memory");

    // Set up control registers: check alignment
    uint32_t cr0 = rcr0();
   41e5c:	89 45 f4             	mov    %eax,-0xc(%rbp)
    cr0 |= CR0_PE | CR0_PG | CR0_WP | CR0_AM | CR0_MP | CR0_NE;
   41e5f:	81 4d f4 23 00 05 80 	orl    $0x80050023,-0xc(%rbp)
   41e66:	8b 45 f4             	mov    -0xc(%rbp),%eax
   41e69:	89 45 f0             	mov    %eax,-0x10(%rbp)
    uint64_t xval = val;
   41e6c:	8b 45 f0             	mov    -0x10(%rbp),%eax
   41e6f:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    asm volatile("movq %0,%%cr0" : : "r" (xval));
   41e73:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   41e77:	0f 22 c0             	mov    %rax,%cr0
}
   41e7a:	90                   	nop
    lcr0(cr0);
}
   41e7b:	90                   	nop
   41e7c:	c9                   	leave
   41e7d:	c3                   	ret

0000000000041e7e <interrupt_mask>:
#define TIMER_FREQ      1193182
#define TIMER_DIV(x)    ((TIMER_FREQ+(x)/2)/(x))

static uint16_t interrupts_enabled;

static void interrupt_mask(void) {
   41e7e:	55                   	push   %rbp
   41e7f:	48 89 e5             	mov    %rsp,%rbp
   41e82:	48 83 ec 20          	sub    $0x20,%rsp
    uint16_t masked = ~interrupts_enabled;
   41e86:	0f b7 05 73 24 01 00 	movzwl 0x12473(%rip),%eax        # 54300 <interrupts_enabled>
   41e8d:	f7 d0                	not    %eax
   41e8f:	66 89 45 fe          	mov    %ax,-0x2(%rbp)
    outb(IO_PIC1+1, masked & 0xFF);
   41e93:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
   41e97:	0f b6 c0             	movzbl %al,%eax
   41e9a:	c7 45 f0 21 00 00 00 	movl   $0x21,-0x10(%rbp)
   41ea1:	88 45 ef             	mov    %al,-0x11(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41ea4:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   41ea8:	8b 55 f0             	mov    -0x10(%rbp),%edx
   41eab:	ee                   	out    %al,(%dx)
}
   41eac:	90                   	nop
    outb(IO_PIC2+1, (masked >> 8) & 0xFF);
   41ead:	0f b7 45 fe          	movzwl -0x2(%rbp),%eax
   41eb1:	66 c1 e8 08          	shr    $0x8,%ax
   41eb5:	0f b6 c0             	movzbl %al,%eax
   41eb8:	c7 45 f8 a1 00 00 00 	movl   $0xa1,-0x8(%rbp)
   41ebf:	88 45 f7             	mov    %al,-0x9(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41ec2:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
   41ec6:	8b 55 f8             	mov    -0x8(%rbp),%edx
   41ec9:	ee                   	out    %al,(%dx)
}
   41eca:	90                   	nop
}
   41ecb:	90                   	nop
   41ecc:	c9                   	leave
   41ecd:	c3                   	ret

0000000000041ece <interrupt_init>:

void interrupt_init(void) {
   41ece:	55                   	push   %rbp
   41ecf:	48 89 e5             	mov    %rsp,%rbp
   41ed2:	48 83 ec 60          	sub    $0x60,%rsp
    // mask all interrupts
    interrupts_enabled = 0;
   41ed6:	66 c7 05 21 24 01 00 	movw   $0x0,0x12421(%rip)        # 54300 <interrupts_enabled>
   41edd:	00 00 
    interrupt_mask();
   41edf:	e8 9a ff ff ff       	call   41e7e <interrupt_mask>
   41ee4:	c7 45 a4 20 00 00 00 	movl   $0x20,-0x5c(%rbp)
   41eeb:	c6 45 a3 11          	movb   $0x11,-0x5d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41eef:	0f b6 45 a3          	movzbl -0x5d(%rbp),%eax
   41ef3:	8b 55 a4             	mov    -0x5c(%rbp),%edx
   41ef6:	ee                   	out    %al,(%dx)
}
   41ef7:	90                   	nop
   41ef8:	c7 45 ac 21 00 00 00 	movl   $0x21,-0x54(%rbp)
   41eff:	c6 45 ab 20          	movb   $0x20,-0x55(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41f03:	0f b6 45 ab          	movzbl -0x55(%rbp),%eax
   41f07:	8b 55 ac             	mov    -0x54(%rbp),%edx
   41f0a:	ee                   	out    %al,(%dx)
}
   41f0b:	90                   	nop
   41f0c:	c7 45 b4 21 00 00 00 	movl   $0x21,-0x4c(%rbp)
   41f13:	c6 45 b3 04          	movb   $0x4,-0x4d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41f17:	0f b6 45 b3          	movzbl -0x4d(%rbp),%eax
   41f1b:	8b 55 b4             	mov    -0x4c(%rbp),%edx
   41f1e:	ee                   	out    %al,(%dx)
}
   41f1f:	90                   	nop
   41f20:	c7 45 bc 21 00 00 00 	movl   $0x21,-0x44(%rbp)
   41f27:	c6 45 bb 03          	movb   $0x3,-0x45(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41f2b:	0f b6 45 bb          	movzbl -0x45(%rbp),%eax
   41f2f:	8b 55 bc             	mov    -0x44(%rbp),%edx
   41f32:	ee                   	out    %al,(%dx)
}
   41f33:	90                   	nop
   41f34:	c7 45 c4 a0 00 00 00 	movl   $0xa0,-0x3c(%rbp)
   41f3b:	c6 45 c3 11          	movb   $0x11,-0x3d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41f3f:	0f b6 45 c3          	movzbl -0x3d(%rbp),%eax
   41f43:	8b 55 c4             	mov    -0x3c(%rbp),%edx
   41f46:	ee                   	out    %al,(%dx)
}
   41f47:	90                   	nop
   41f48:	c7 45 cc a1 00 00 00 	movl   $0xa1,-0x34(%rbp)
   41f4f:	c6 45 cb 28          	movb   $0x28,-0x35(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41f53:	0f b6 45 cb          	movzbl -0x35(%rbp),%eax
   41f57:	8b 55 cc             	mov    -0x34(%rbp),%edx
   41f5a:	ee                   	out    %al,(%dx)
}
   41f5b:	90                   	nop
   41f5c:	c7 45 d4 a1 00 00 00 	movl   $0xa1,-0x2c(%rbp)
   41f63:	c6 45 d3 02          	movb   $0x2,-0x2d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41f67:	0f b6 45 d3          	movzbl -0x2d(%rbp),%eax
   41f6b:	8b 55 d4             	mov    -0x2c(%rbp),%edx
   41f6e:	ee                   	out    %al,(%dx)
}
   41f6f:	90                   	nop
   41f70:	c7 45 dc a1 00 00 00 	movl   $0xa1,-0x24(%rbp)
   41f77:	c6 45 db 01          	movb   $0x1,-0x25(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41f7b:	0f b6 45 db          	movzbl -0x25(%rbp),%eax
   41f7f:	8b 55 dc             	mov    -0x24(%rbp),%edx
   41f82:	ee                   	out    %al,(%dx)
}
   41f83:	90                   	nop
   41f84:	c7 45 e4 20 00 00 00 	movl   $0x20,-0x1c(%rbp)
   41f8b:	c6 45 e3 68          	movb   $0x68,-0x1d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41f8f:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
   41f93:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   41f96:	ee                   	out    %al,(%dx)
}
   41f97:	90                   	nop
   41f98:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%rbp)
   41f9f:	c6 45 eb 0a          	movb   $0xa,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41fa3:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   41fa7:	8b 55 ec             	mov    -0x14(%rbp),%edx
   41faa:	ee                   	out    %al,(%dx)
}
   41fab:	90                   	nop
   41fac:	c7 45 f4 a0 00 00 00 	movl   $0xa0,-0xc(%rbp)
   41fb3:	c6 45 f3 68          	movb   $0x68,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41fb7:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   41fbb:	8b 55 f4             	mov    -0xc(%rbp),%edx
   41fbe:	ee                   	out    %al,(%dx)
}
   41fbf:	90                   	nop
   41fc0:	c7 45 fc a0 00 00 00 	movl   $0xa0,-0x4(%rbp)
   41fc7:	c6 45 fb 0a          	movb   $0xa,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41fcb:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   41fcf:	8b 55 fc             	mov    -0x4(%rbp),%edx
   41fd2:	ee                   	out    %al,(%dx)
}
   41fd3:	90                   	nop

    outb(IO_PIC2, 0x68);               /* OCW3 */
    outb(IO_PIC2, 0x0a);               /* OCW3 */

    // re-disable interrupts
    interrupt_mask();
   41fd4:	e8 a5 fe ff ff       	call   41e7e <interrupt_mask>
}
   41fd9:	90                   	nop
   41fda:	c9                   	leave
   41fdb:	c3                   	ret

0000000000041fdc <timer_init>:

// timer_init(rate)
//    Set the timer interrupt to fire `rate` times a second. Disables the
//    timer interrupt if `rate <= 0`.

void timer_init(int rate) {
   41fdc:	55                   	push   %rbp
   41fdd:	48 89 e5             	mov    %rsp,%rbp
   41fe0:	48 83 ec 28          	sub    $0x28,%rsp
   41fe4:	89 7d dc             	mov    %edi,-0x24(%rbp)
    if (rate > 0) {
   41fe7:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   41feb:	0f 8e 9e 00 00 00    	jle    4208f <timer_init+0xb3>
   41ff1:	c7 45 ec 43 00 00 00 	movl   $0x43,-0x14(%rbp)
   41ff8:	c6 45 eb 34          	movb   $0x34,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   41ffc:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   42000:	8b 55 ec             	mov    -0x14(%rbp),%edx
   42003:	ee                   	out    %al,(%dx)
}
   42004:	90                   	nop
        outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
        outb(IO_TIMER1, TIMER_DIV(rate) % 256);
   42005:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42008:	89 c2                	mov    %eax,%edx
   4200a:	c1 ea 1f             	shr    $0x1f,%edx
   4200d:	01 d0                	add    %edx,%eax
   4200f:	d1 f8                	sar    %eax
   42011:	05 de 34 12 00       	add    $0x1234de,%eax
   42016:	99                   	cltd
   42017:	f7 7d dc             	idivl  -0x24(%rbp)
   4201a:	89 c2                	mov    %eax,%edx
   4201c:	89 d0                	mov    %edx,%eax
   4201e:	c1 f8 1f             	sar    $0x1f,%eax
   42021:	c1 e8 18             	shr    $0x18,%eax
   42024:	01 c2                	add    %eax,%edx
   42026:	0f b6 d2             	movzbl %dl,%edx
   42029:	29 c2                	sub    %eax,%edx
   4202b:	89 d0                	mov    %edx,%eax
   4202d:	0f b6 c0             	movzbl %al,%eax
   42030:	c7 45 f4 40 00 00 00 	movl   $0x40,-0xc(%rbp)
   42037:	88 45 f3             	mov    %al,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4203a:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   4203e:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42041:	ee                   	out    %al,(%dx)
}
   42042:	90                   	nop
        outb(IO_TIMER1, TIMER_DIV(rate) / 256);
   42043:	8b 45 dc             	mov    -0x24(%rbp),%eax
   42046:	89 c2                	mov    %eax,%edx
   42048:	c1 ea 1f             	shr    $0x1f,%edx
   4204b:	01 d0                	add    %edx,%eax
   4204d:	d1 f8                	sar    %eax
   4204f:	05 de 34 12 00       	add    $0x1234de,%eax
   42054:	99                   	cltd
   42055:	f7 7d dc             	idivl  -0x24(%rbp)
   42058:	8d 90 ff 00 00 00    	lea    0xff(%rax),%edx
   4205e:	85 c0                	test   %eax,%eax
   42060:	0f 48 c2             	cmovs  %edx,%eax
   42063:	c1 f8 08             	sar    $0x8,%eax
   42066:	0f b6 c0             	movzbl %al,%eax
   42069:	c7 45 fc 40 00 00 00 	movl   $0x40,-0x4(%rbp)
   42070:	88 45 fb             	mov    %al,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42073:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42077:	8b 55 fc             	mov    -0x4(%rbp),%edx
   4207a:	ee                   	out    %al,(%dx)
}
   4207b:	90                   	nop
        interrupts_enabled |= 1 << (INT_TIMER - INT_HARDWARE);
   4207c:	0f b7 05 7d 22 01 00 	movzwl 0x1227d(%rip),%eax        # 54300 <interrupts_enabled>
   42083:	83 c8 01             	or     $0x1,%eax
   42086:	66 89 05 73 22 01 00 	mov    %ax,0x12273(%rip)        # 54300 <interrupts_enabled>
   4208d:	eb 11                	jmp    420a0 <timer_init+0xc4>
    } else {
        interrupts_enabled &= ~(1 << (INT_TIMER - INT_HARDWARE));
   4208f:	0f b7 05 6a 22 01 00 	movzwl 0x1226a(%rip),%eax        # 54300 <interrupts_enabled>
   42096:	83 e0 fe             	and    $0xfffffffe,%eax
   42099:	66 89 05 60 22 01 00 	mov    %ax,0x12260(%rip)        # 54300 <interrupts_enabled>
    }
    interrupt_mask();
   420a0:	e8 d9 fd ff ff       	call   41e7e <interrupt_mask>
}
   420a5:	90                   	nop
   420a6:	c9                   	leave
   420a7:	c3                   	ret

00000000000420a8 <physical_memory_isreserved>:
//    Returns non-zero iff `pa` is a reserved physical address.

#define IOPHYSMEM       0x000A0000
#define EXTPHYSMEM      0x00100000

int physical_memory_isreserved(uintptr_t pa) {
   420a8:	55                   	push   %rbp
   420a9:	48 89 e5             	mov    %rsp,%rbp
   420ac:	48 83 ec 08          	sub    $0x8,%rsp
   420b0:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
    return pa == 0 || (pa >= IOPHYSMEM && pa < EXTPHYSMEM);
   420b4:	48 83 7d f8 00       	cmpq   $0x0,-0x8(%rbp)
   420b9:	74 14                	je     420cf <physical_memory_isreserved+0x27>
   420bb:	48 81 7d f8 ff ff 09 	cmpq   $0x9ffff,-0x8(%rbp)
   420c2:	00 
   420c3:	76 11                	jbe    420d6 <physical_memory_isreserved+0x2e>
   420c5:	48 81 7d f8 ff ff 0f 	cmpq   $0xfffff,-0x8(%rbp)
   420cc:	00 
   420cd:	77 07                	ja     420d6 <physical_memory_isreserved+0x2e>
   420cf:	b8 01 00 00 00       	mov    $0x1,%eax
   420d4:	eb 05                	jmp    420db <physical_memory_isreserved+0x33>
   420d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
   420db:	c9                   	leave
   420dc:	c3                   	ret

00000000000420dd <pci_make_configaddr>:


// pci_make_configaddr(bus, slot, func)
//    Construct a PCI configuration space address from parts.

static int pci_make_configaddr(int bus, int slot, int func) {
   420dd:	55                   	push   %rbp
   420de:	48 89 e5             	mov    %rsp,%rbp
   420e1:	48 83 ec 10          	sub    $0x10,%rsp
   420e5:	89 7d fc             	mov    %edi,-0x4(%rbp)
   420e8:	89 75 f8             	mov    %esi,-0x8(%rbp)
   420eb:	89 55 f4             	mov    %edx,-0xc(%rbp)
    return (bus << 16) | (slot << 11) | (func << 8);
   420ee:	8b 45 fc             	mov    -0x4(%rbp),%eax
   420f1:	c1 e0 10             	shl    $0x10,%eax
   420f4:	89 c2                	mov    %eax,%edx
   420f6:	8b 45 f8             	mov    -0x8(%rbp),%eax
   420f9:	c1 e0 0b             	shl    $0xb,%eax
   420fc:	09 c2                	or     %eax,%edx
   420fe:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42101:	c1 e0 08             	shl    $0x8,%eax
   42104:	09 d0                	or     %edx,%eax
}
   42106:	c9                   	leave
   42107:	c3                   	ret

0000000000042108 <pci_config_readl>:
//    Read a 32-bit word in PCI configuration space.

#define PCI_HOST_BRIDGE_CONFIG_ADDR 0xCF8
#define PCI_HOST_BRIDGE_CONFIG_DATA 0xCFC

static uint32_t pci_config_readl(int configaddr, int offset) {
   42108:	55                   	push   %rbp
   42109:	48 89 e5             	mov    %rsp,%rbp
   4210c:	48 83 ec 18          	sub    $0x18,%rsp
   42110:	89 7d ec             	mov    %edi,-0x14(%rbp)
   42113:	89 75 e8             	mov    %esi,-0x18(%rbp)
    outl(PCI_HOST_BRIDGE_CONFIG_ADDR, 0x80000000 | configaddr | offset);
   42116:	8b 55 ec             	mov    -0x14(%rbp),%edx
   42119:	8b 45 e8             	mov    -0x18(%rbp),%eax
   4211c:	09 d0                	or     %edx,%eax
   4211e:	0d 00 00 00 80       	or     $0x80000000,%eax
   42123:	c7 45 f4 f8 0c 00 00 	movl   $0xcf8,-0xc(%rbp)
   4212a:	89 45 f0             	mov    %eax,-0x10(%rbp)
    asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
   4212d:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42130:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42133:	ef                   	out    %eax,(%dx)
}
   42134:	90                   	nop
   42135:	c7 45 fc fc 0c 00 00 	movl   $0xcfc,-0x4(%rbp)
    asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
   4213c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4213f:	89 c2                	mov    %eax,%edx
   42141:	ed                   	in     (%dx),%eax
   42142:	89 45 f8             	mov    %eax,-0x8(%rbp)
    return data;
   42145:	8b 45 f8             	mov    -0x8(%rbp),%eax
    return inl(PCI_HOST_BRIDGE_CONFIG_DATA);
}
   42148:	c9                   	leave
   42149:	c3                   	ret

000000000004214a <pci_find_device>:

// pci_find_device
//    Search for a PCI device matching `vendor` and `device`. Return
//    the config base address or -1 if no device was found.

static int pci_find_device(int vendor, int device) {
   4214a:	55                   	push   %rbp
   4214b:	48 89 e5             	mov    %rsp,%rbp
   4214e:	48 83 ec 28          	sub    $0x28,%rsp
   42152:	89 7d dc             	mov    %edi,-0x24(%rbp)
   42155:	89 75 d8             	mov    %esi,-0x28(%rbp)
    for (int bus = 0; bus != 256; ++bus) {
   42158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4215f:	eb 73                	jmp    421d4 <pci_find_device+0x8a>
        for (int slot = 0; slot != 32; ++slot) {
   42161:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
   42168:	eb 60                	jmp    421ca <pci_find_device+0x80>
            for (int func = 0; func != 8; ++func) {
   4216a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   42171:	eb 4a                	jmp    421bd <pci_find_device+0x73>
                int configaddr = pci_make_configaddr(bus, slot, func);
   42173:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42176:	8b 4d f8             	mov    -0x8(%rbp),%ecx
   42179:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4217c:	89 ce                	mov    %ecx,%esi
   4217e:	89 c7                	mov    %eax,%edi
   42180:	e8 58 ff ff ff       	call   420dd <pci_make_configaddr>
   42185:	89 45 f0             	mov    %eax,-0x10(%rbp)
                uint32_t vendor_device = pci_config_readl(configaddr, 0);
   42188:	8b 45 f0             	mov    -0x10(%rbp),%eax
   4218b:	be 00 00 00 00       	mov    $0x0,%esi
   42190:	89 c7                	mov    %eax,%edi
   42192:	e8 71 ff ff ff       	call   42108 <pci_config_readl>
   42197:	89 45 ec             	mov    %eax,-0x14(%rbp)
                if (vendor_device == (uint32_t) (vendor | (device << 16))) {
   4219a:	8b 45 d8             	mov    -0x28(%rbp),%eax
   4219d:	c1 e0 10             	shl    $0x10,%eax
   421a0:	0b 45 dc             	or     -0x24(%rbp),%eax
   421a3:	39 45 ec             	cmp    %eax,-0x14(%rbp)
   421a6:	75 05                	jne    421ad <pci_find_device+0x63>
                    return configaddr;
   421a8:	8b 45 f0             	mov    -0x10(%rbp),%eax
   421ab:	eb 35                	jmp    421e2 <pci_find_device+0x98>
                } else if (vendor_device == (uint32_t) -1 && func == 0) {
   421ad:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%rbp)
   421b1:	75 06                	jne    421b9 <pci_find_device+0x6f>
   421b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   421b7:	74 0c                	je     421c5 <pci_find_device+0x7b>
            for (int func = 0; func != 8; ++func) {
   421b9:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   421bd:	83 7d f4 08          	cmpl   $0x8,-0xc(%rbp)
   421c1:	75 b0                	jne    42173 <pci_find_device+0x29>
   421c3:	eb 01                	jmp    421c6 <pci_find_device+0x7c>
                    break;
   421c5:	90                   	nop
        for (int slot = 0; slot != 32; ++slot) {
   421c6:	83 45 f8 01          	addl   $0x1,-0x8(%rbp)
   421ca:	83 7d f8 20          	cmpl   $0x20,-0x8(%rbp)
   421ce:	75 9a                	jne    4216a <pci_find_device+0x20>
    for (int bus = 0; bus != 256; ++bus) {
   421d0:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   421d4:	81 7d fc 00 01 00 00 	cmpl   $0x100,-0x4(%rbp)
   421db:	75 84                	jne    42161 <pci_find_device+0x17>
                }
            }
        }
    }
    return -1;
   421dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
   421e2:	c9                   	leave
   421e3:	c3                   	ret

00000000000421e4 <poweroff>:
//    that speaks ACPI; QEMU emulates a PIIX4 Power Management Controller.

#define PCI_VENDOR_ID_INTEL     0x8086
#define PCI_DEVICE_ID_PIIX4     0x7113

void poweroff(void) {
   421e4:	55                   	push   %rbp
   421e5:	48 89 e5             	mov    %rsp,%rbp
   421e8:	48 83 ec 10          	sub    $0x10,%rsp
    int configaddr = pci_find_device(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_PIIX4);
   421ec:	be 13 71 00 00       	mov    $0x7113,%esi
   421f1:	bf 86 80 00 00       	mov    $0x8086,%edi
   421f6:	e8 4f ff ff ff       	call   4214a <pci_find_device>
   421fb:	89 45 fc             	mov    %eax,-0x4(%rbp)
    if (configaddr >= 0) {
   421fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%rbp)
   42202:	78 30                	js     42234 <poweroff+0x50>
        // Read I/O base register from controller's PCI configuration space.
        int pm_io_base = pci_config_readl(configaddr, 0x40) & 0xFFC0;
   42204:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42207:	be 40 00 00 00       	mov    $0x40,%esi
   4220c:	89 c7                	mov    %eax,%edi
   4220e:	e8 f5 fe ff ff       	call   42108 <pci_config_readl>
   42213:	25 c0 ff 00 00       	and    $0xffc0,%eax
   42218:	89 45 f8             	mov    %eax,-0x8(%rbp)
        // Write `suspend enable` to the power management control register.
        outw(pm_io_base + 4, 0x2000);
   4221b:	8b 45 f8             	mov    -0x8(%rbp),%eax
   4221e:	83 c0 04             	add    $0x4,%eax
   42221:	89 45 f4             	mov    %eax,-0xc(%rbp)
   42224:	66 c7 45 f2 00 20    	movw   $0x2000,-0xe(%rbp)
    asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
   4222a:	0f b7 45 f2          	movzwl -0xe(%rbp),%eax
   4222e:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42231:	66 ef                	out    %ax,(%dx)
}
   42233:	90                   	nop
    }
    // No PIIX4; spin.
    console_printf(CPOS(24, 0), 0xC000, "Cannot power off!\n");
   42234:	ba e0 49 04 00       	mov    $0x449e0,%edx
   42239:	be 00 c0 00 00       	mov    $0xc000,%esi
   4223e:	bf 80 07 00 00       	mov    $0x780,%edi
   42243:	b8 00 00 00 00       	mov    $0x0,%eax
   42248:	e8 d2 21 00 00       	call   4441f <console_printf>
 spinloop: goto spinloop;
   4224d:	eb fe                	jmp    4224d <poweroff+0x69>

000000000004224f <reboot>:


// reboot
//    Reboot the virtual machine.

void reboot(void) {
   4224f:	55                   	push   %rbp
   42250:	48 89 e5             	mov    %rsp,%rbp
   42253:	48 83 ec 10          	sub    $0x10,%rsp
   42257:	c7 45 fc 92 00 00 00 	movl   $0x92,-0x4(%rbp)
   4225e:	c6 45 fb 03          	movb   $0x3,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42262:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42266:	8b 55 fc             	mov    -0x4(%rbp),%edx
   42269:	ee                   	out    %al,(%dx)
}
   4226a:	90                   	nop
    outb(0x92, 3);
 spinloop: goto spinloop;
   4226b:	eb fe                	jmp    4226b <reboot+0x1c>

000000000004226d <process_init>:


// process_init(p, flags)
//    Initialize special-purpose registers for process `p`.

void process_init(proc* p, int flags) {
   4226d:	55                   	push   %rbp
   4226e:	48 89 e5             	mov    %rsp,%rbp
   42271:	48 83 ec 10          	sub    $0x10,%rsp
   42275:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   42279:	89 75 f4             	mov    %esi,-0xc(%rbp)
    memset(&p->p_registers, 0, sizeof(p->p_registers));
   4227c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42280:	48 83 c0 08          	add    $0x8,%rax
   42284:	ba c0 00 00 00       	mov    $0xc0,%edx
   42289:	be 00 00 00 00       	mov    $0x0,%esi
   4228e:	48 89 c7             	mov    %rax,%rdi
   42291:	e8 d2 13 00 00       	call   43668 <memset>
    p->p_registers.reg_cs = SEGSEL_APP_CODE | 3;
   42296:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4229a:	66 c7 80 a8 00 00 00 	movw   $0x13,0xa8(%rax)
   422a1:	13 00 
    p->p_registers.reg_fs = SEGSEL_APP_DATA | 3;
   422a3:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   422a7:	48 c7 80 80 00 00 00 	movq   $0x23,0x80(%rax)
   422ae:	23 00 00 00 
    p->p_registers.reg_gs = SEGSEL_APP_DATA | 3;
   422b2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   422b6:	48 c7 80 88 00 00 00 	movq   $0x23,0x88(%rax)
   422bd:	23 00 00 00 
    p->p_registers.reg_ss = SEGSEL_APP_DATA | 3;
   422c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   422c5:	66 c7 80 c0 00 00 00 	movw   $0x23,0xc0(%rax)
   422cc:	23 00 
    p->p_registers.reg_rflags = EFLAGS_IF;
   422ce:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   422d2:	48 c7 80 b0 00 00 00 	movq   $0x200,0xb0(%rax)
   422d9:	00 02 00 00 
    p->display_status = 1;
   422dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   422e1:	c6 80 d8 00 00 00 01 	movb   $0x1,0xd8(%rax)

    if (flags & PROCINIT_ALLOW_PROGRAMMED_IO) {
   422e8:	8b 45 f4             	mov    -0xc(%rbp),%eax
   422eb:	83 e0 01             	and    $0x1,%eax
   422ee:	85 c0                	test   %eax,%eax
   422f0:	74 1c                	je     4230e <process_init+0xa1>
        p->p_registers.reg_rflags |= EFLAGS_IOPL_3;
   422f2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   422f6:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
   422fd:	80 cc 30             	or     $0x30,%ah
   42300:	48 89 c2             	mov    %rax,%rdx
   42303:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42307:	48 89 90 b0 00 00 00 	mov    %rdx,0xb0(%rax)
    }
    if (flags & PROCINIT_DISABLE_INTERRUPTS) {
   4230e:	8b 45 f4             	mov    -0xc(%rbp),%eax
   42311:	83 e0 02             	and    $0x2,%eax
   42314:	85 c0                	test   %eax,%eax
   42316:	74 1c                	je     42334 <process_init+0xc7>
        p->p_registers.reg_rflags &= ~EFLAGS_IF;
   42318:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4231c:	48 8b 80 b0 00 00 00 	mov    0xb0(%rax),%rax
   42323:	80 e4 fd             	and    $0xfd,%ah
   42326:	48 89 c2             	mov    %rax,%rdx
   42329:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4232d:	48 89 90 b0 00 00 00 	mov    %rdx,0xb0(%rax)
    }
}
   42334:	90                   	nop
   42335:	c9                   	leave
   42336:	c3                   	ret

0000000000042337 <console_show_cursor>:

// console_show_cursor(cpos)
//    Move the console cursor to position `cpos`, which should be between 0
//    and 80 * 25.

void console_show_cursor(int cpos) {
   42337:	55                   	push   %rbp
   42338:	48 89 e5             	mov    %rsp,%rbp
   4233b:	48 83 ec 28          	sub    $0x28,%rsp
   4233f:	89 7d dc             	mov    %edi,-0x24(%rbp)
    if (cpos < 0 || cpos > CONSOLE_ROWS * CONSOLE_COLUMNS) {
   42342:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   42346:	78 09                	js     42351 <console_show_cursor+0x1a>
   42348:	81 7d dc d0 07 00 00 	cmpl   $0x7d0,-0x24(%rbp)
   4234f:	7e 07                	jle    42358 <console_show_cursor+0x21>
        cpos = 0;
   42351:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%rbp)
   42358:	c7 45 e4 d4 03 00 00 	movl   $0x3d4,-0x1c(%rbp)
   4235f:	c6 45 e3 0e          	movb   $0xe,-0x1d(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42363:	0f b6 45 e3          	movzbl -0x1d(%rbp),%eax
   42367:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   4236a:	ee                   	out    %al,(%dx)
}
   4236b:	90                   	nop
    }
    outb(0x3D4, 14);
    outb(0x3D5, cpos / 256);
   4236c:	8b 45 dc             	mov    -0x24(%rbp),%eax
   4236f:	8d 90 ff 00 00 00    	lea    0xff(%rax),%edx
   42375:	85 c0                	test   %eax,%eax
   42377:	0f 48 c2             	cmovs  %edx,%eax
   4237a:	c1 f8 08             	sar    $0x8,%eax
   4237d:	0f b6 c0             	movzbl %al,%eax
   42380:	c7 45 ec d5 03 00 00 	movl   $0x3d5,-0x14(%rbp)
   42387:	88 45 eb             	mov    %al,-0x15(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4238a:	0f b6 45 eb          	movzbl -0x15(%rbp),%eax
   4238e:	8b 55 ec             	mov    -0x14(%rbp),%edx
   42391:	ee                   	out    %al,(%dx)
}
   42392:	90                   	nop
   42393:	c7 45 f4 d4 03 00 00 	movl   $0x3d4,-0xc(%rbp)
   4239a:	c6 45 f3 0f          	movb   $0xf,-0xd(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   4239e:	0f b6 45 f3          	movzbl -0xd(%rbp),%eax
   423a2:	8b 55 f4             	mov    -0xc(%rbp),%edx
   423a5:	ee                   	out    %al,(%dx)
}
   423a6:	90                   	nop
    outb(0x3D4, 15);
    outb(0x3D5, cpos % 256);
   423a7:	8b 55 dc             	mov    -0x24(%rbp),%edx
   423aa:	89 d0                	mov    %edx,%eax
   423ac:	c1 f8 1f             	sar    $0x1f,%eax
   423af:	c1 e8 18             	shr    $0x18,%eax
   423b2:	01 c2                	add    %eax,%edx
   423b4:	0f b6 d2             	movzbl %dl,%edx
   423b7:	29 c2                	sub    %eax,%edx
   423b9:	89 d0                	mov    %edx,%eax
   423bb:	0f b6 c0             	movzbl %al,%eax
   423be:	c7 45 fc d5 03 00 00 	movl   $0x3d5,-0x4(%rbp)
   423c5:	88 45 fb             	mov    %al,-0x5(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   423c8:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   423cc:	8b 55 fc             	mov    -0x4(%rbp),%edx
   423cf:	ee                   	out    %al,(%dx)
}
   423d0:	90                   	nop
}
   423d1:	90                   	nop
   423d2:	c9                   	leave
   423d3:	c3                   	ret

00000000000423d4 <keyboard_readc>:
    /*CKEY(16)*/ {{'\'', '"', 0, 0}},  /*CKEY(17)*/ {{'`', '~', 0, 0}},
    /*CKEY(18)*/ {{'\\', '|', 034, 0}},  /*CKEY(19)*/ {{',', '<', 0, 0}},
    /*CKEY(20)*/ {{'.', '>', 0, 0}},  /*CKEY(21)*/ {{'/', '?', 0, 0}}
};

int keyboard_readc(void) {
   423d4:	55                   	push   %rbp
   423d5:	48 89 e5             	mov    %rsp,%rbp
   423d8:	48 83 ec 20          	sub    $0x20,%rsp
   423dc:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   423e3:	8b 45 f0             	mov    -0x10(%rbp),%eax
   423e6:	89 c2                	mov    %eax,%edx
   423e8:	ec                   	in     (%dx),%al
   423e9:	88 45 ef             	mov    %al,-0x11(%rbp)
    return data;
   423ec:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
    static uint8_t modifiers;
    static uint8_t last_escape;

    if ((inb(KEYBOARD_STATUSREG) & KEYBOARD_STATUS_READY) == 0) {
   423f0:	0f b6 c0             	movzbl %al,%eax
   423f3:	83 e0 01             	and    $0x1,%eax
   423f6:	85 c0                	test   %eax,%eax
   423f8:	75 0a                	jne    42404 <keyboard_readc+0x30>
        return -1;
   423fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   423ff:	e9 e7 01 00 00       	jmp    425eb <keyboard_readc+0x217>
   42404:	c7 45 e8 60 00 00 00 	movl   $0x60,-0x18(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   4240b:	8b 45 e8             	mov    -0x18(%rbp),%eax
   4240e:	89 c2                	mov    %eax,%edx
   42410:	ec                   	in     (%dx),%al
   42411:	88 45 e7             	mov    %al,-0x19(%rbp)
    return data;
   42414:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
    }

    uint8_t data = inb(KEYBOARD_DATAREG);
   42418:	88 45 fb             	mov    %al,-0x5(%rbp)
    uint8_t escape = last_escape;
   4241b:	0f b6 05 e0 1e 01 00 	movzbl 0x11ee0(%rip),%eax        # 54302 <last_escape.2>
   42422:	88 45 fa             	mov    %al,-0x6(%rbp)
    last_escape = 0;
   42425:	c6 05 d6 1e 01 00 00 	movb   $0x0,0x11ed6(%rip)        # 54302 <last_escape.2>

    if (data == 0xE0) {         // mode shift
   4242c:	80 7d fb e0          	cmpb   $0xe0,-0x5(%rbp)
   42430:	75 11                	jne    42443 <keyboard_readc+0x6f>
        last_escape = 0x80;
   42432:	c6 05 c9 1e 01 00 80 	movb   $0x80,0x11ec9(%rip)        # 54302 <last_escape.2>
        return 0;
   42439:	b8 00 00 00 00       	mov    $0x0,%eax
   4243e:	e9 a8 01 00 00       	jmp    425eb <keyboard_readc+0x217>
    } else if (data & 0x80) {   // key release: matters only for modifier keys
   42443:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   42447:	84 c0                	test   %al,%al
   42449:	79 60                	jns    424ab <keyboard_readc+0xd7>
        int ch = keymap[(data & 0x7F) | escape];
   4244b:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   4244f:	83 e0 7f             	and    $0x7f,%eax
   42452:	89 c2                	mov    %eax,%edx
   42454:	0f b6 45 fa          	movzbl -0x6(%rbp),%eax
   42458:	09 d0                	or     %edx,%eax
   4245a:	48 98                	cltq
   4245c:	0f b6 80 00 4a 04 00 	movzbl 0x44a00(%rax),%eax
   42463:	0f b6 c0             	movzbl %al,%eax
   42466:	89 45 f4             	mov    %eax,-0xc(%rbp)
        if (ch >= KEY_SHIFT && ch < KEY_CAPSLOCK) {
   42469:	81 7d f4 f9 00 00 00 	cmpl   $0xf9,-0xc(%rbp)
   42470:	7e 2f                	jle    424a1 <keyboard_readc+0xcd>
   42472:	81 7d f4 fc 00 00 00 	cmpl   $0xfc,-0xc(%rbp)
   42479:	7f 26                	jg     424a1 <keyboard_readc+0xcd>
            modifiers &= ~(1 << (ch - KEY_SHIFT));
   4247b:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4247e:	2d fa 00 00 00       	sub    $0xfa,%eax
   42483:	ba 01 00 00 00       	mov    $0x1,%edx
   42488:	89 c1                	mov    %eax,%ecx
   4248a:	d3 e2                	shl    %cl,%edx
   4248c:	89 d0                	mov    %edx,%eax
   4248e:	f7 d0                	not    %eax
   42490:	89 c2                	mov    %eax,%edx
   42492:	0f b6 05 6a 1e 01 00 	movzbl 0x11e6a(%rip),%eax        # 54303 <modifiers.1>
   42499:	21 d0                	and    %edx,%eax
   4249b:	88 05 62 1e 01 00    	mov    %al,0x11e62(%rip)        # 54303 <modifiers.1>
        }
        return 0;
   424a1:	b8 00 00 00 00       	mov    $0x0,%eax
   424a6:	e9 40 01 00 00       	jmp    425eb <keyboard_readc+0x217>
    }

    int ch = (unsigned char) keymap[data | escape];
   424ab:	0f b6 45 fb          	movzbl -0x5(%rbp),%eax
   424af:	0a 45 fa             	or     -0x6(%rbp),%al
   424b2:	0f b6 c0             	movzbl %al,%eax
   424b5:	48 98                	cltq
   424b7:	0f b6 80 00 4a 04 00 	movzbl 0x44a00(%rax),%eax
   424be:	0f b6 c0             	movzbl %al,%eax
   424c1:	89 45 fc             	mov    %eax,-0x4(%rbp)

    if (ch >= 'a' && ch <= 'z') {
   424c4:	83 7d fc 60          	cmpl   $0x60,-0x4(%rbp)
   424c8:	7e 57                	jle    42521 <keyboard_readc+0x14d>
   424ca:	83 7d fc 7a          	cmpl   $0x7a,-0x4(%rbp)
   424ce:	7f 51                	jg     42521 <keyboard_readc+0x14d>
        if (modifiers & MOD_CONTROL) {
   424d0:	0f b6 05 2c 1e 01 00 	movzbl 0x11e2c(%rip),%eax        # 54303 <modifiers.1>
   424d7:	0f b6 c0             	movzbl %al,%eax
   424da:	83 e0 02             	and    $0x2,%eax
   424dd:	85 c0                	test   %eax,%eax
   424df:	74 09                	je     424ea <keyboard_readc+0x116>
            ch -= 0x60;
   424e1:	83 6d fc 60          	subl   $0x60,-0x4(%rbp)
        if (modifiers & MOD_CONTROL) {
   424e5:	e9 fd 00 00 00       	jmp    425e7 <keyboard_readc+0x213>
        } else if (!(modifiers & MOD_SHIFT) != !(modifiers & MOD_CAPSLOCK)) {
   424ea:	0f b6 05 12 1e 01 00 	movzbl 0x11e12(%rip),%eax        # 54303 <modifiers.1>
   424f1:	0f b6 c0             	movzbl %al,%eax
   424f4:	83 e0 01             	and    $0x1,%eax
   424f7:	85 c0                	test   %eax,%eax
   424f9:	0f 94 c2             	sete   %dl
   424fc:	0f b6 05 00 1e 01 00 	movzbl 0x11e00(%rip),%eax        # 54303 <modifiers.1>
   42503:	0f b6 c0             	movzbl %al,%eax
   42506:	83 e0 08             	and    $0x8,%eax
   42509:	85 c0                	test   %eax,%eax
   4250b:	0f 94 c0             	sete   %al
   4250e:	31 d0                	xor    %edx,%eax
   42510:	84 c0                	test   %al,%al
   42512:	0f 84 cf 00 00 00    	je     425e7 <keyboard_readc+0x213>
            ch -= 0x20;
   42518:	83 6d fc 20          	subl   $0x20,-0x4(%rbp)
        if (modifiers & MOD_CONTROL) {
   4251c:	e9 c6 00 00 00       	jmp    425e7 <keyboard_readc+0x213>
        }
    } else if (ch >= KEY_CAPSLOCK) {
   42521:	81 7d fc fc 00 00 00 	cmpl   $0xfc,-0x4(%rbp)
   42528:	7e 30                	jle    4255a <keyboard_readc+0x186>
        modifiers ^= 1 << (ch - KEY_SHIFT);
   4252a:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4252d:	2d fa 00 00 00       	sub    $0xfa,%eax
   42532:	ba 01 00 00 00       	mov    $0x1,%edx
   42537:	89 c1                	mov    %eax,%ecx
   42539:	d3 e2                	shl    %cl,%edx
   4253b:	89 d0                	mov    %edx,%eax
   4253d:	89 c2                	mov    %eax,%edx
   4253f:	0f b6 05 bd 1d 01 00 	movzbl 0x11dbd(%rip),%eax        # 54303 <modifiers.1>
   42546:	31 d0                	xor    %edx,%eax
   42548:	88 05 b5 1d 01 00    	mov    %al,0x11db5(%rip)        # 54303 <modifiers.1>
        ch = 0;
   4254e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   42555:	e9 8e 00 00 00       	jmp    425e8 <keyboard_readc+0x214>
    } else if (ch >= KEY_SHIFT) {
   4255a:	81 7d fc f9 00 00 00 	cmpl   $0xf9,-0x4(%rbp)
   42561:	7e 2d                	jle    42590 <keyboard_readc+0x1bc>
        modifiers |= 1 << (ch - KEY_SHIFT);
   42563:	8b 45 fc             	mov    -0x4(%rbp),%eax
   42566:	2d fa 00 00 00       	sub    $0xfa,%eax
   4256b:	ba 01 00 00 00       	mov    $0x1,%edx
   42570:	89 c1                	mov    %eax,%ecx
   42572:	d3 e2                	shl    %cl,%edx
   42574:	89 d0                	mov    %edx,%eax
   42576:	89 c2                	mov    %eax,%edx
   42578:	0f b6 05 84 1d 01 00 	movzbl 0x11d84(%rip),%eax        # 54303 <modifiers.1>
   4257f:	09 d0                	or     %edx,%eax
   42581:	88 05 7c 1d 01 00    	mov    %al,0x11d7c(%rip)        # 54303 <modifiers.1>
        ch = 0;
   42587:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4258e:	eb 58                	jmp    425e8 <keyboard_readc+0x214>
    } else if (ch >= CKEY(0) && ch <= CKEY(21)) {
   42590:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
   42594:	7e 31                	jle    425c7 <keyboard_readc+0x1f3>
   42596:	81 7d fc 95 00 00 00 	cmpl   $0x95,-0x4(%rbp)
   4259d:	7f 28                	jg     425c7 <keyboard_readc+0x1f3>
        ch = complex_keymap[ch - CKEY(0)].map[modifiers & 3];
   4259f:	8b 45 fc             	mov    -0x4(%rbp),%eax
   425a2:	8d 50 80             	lea    -0x80(%rax),%edx
   425a5:	0f b6 05 57 1d 01 00 	movzbl 0x11d57(%rip),%eax        # 54303 <modifiers.1>
   425ac:	0f b6 c0             	movzbl %al,%eax
   425af:	83 e0 03             	and    $0x3,%eax
   425b2:	48 98                	cltq
   425b4:	48 63 d2             	movslq %edx,%rdx
   425b7:	0f b6 84 90 00 4b 04 	movzbl 0x44b00(%rax,%rdx,4),%eax
   425be:	00 
   425bf:	0f b6 c0             	movzbl %al,%eax
   425c2:	89 45 fc             	mov    %eax,-0x4(%rbp)
   425c5:	eb 21                	jmp    425e8 <keyboard_readc+0x214>
    } else if (ch < 0x80 && (modifiers & MOD_CONTROL)) {
   425c7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%rbp)
   425cb:	7f 1b                	jg     425e8 <keyboard_readc+0x214>
   425cd:	0f b6 05 2f 1d 01 00 	movzbl 0x11d2f(%rip),%eax        # 54303 <modifiers.1>
   425d4:	0f b6 c0             	movzbl %al,%eax
   425d7:	83 e0 02             	and    $0x2,%eax
   425da:	85 c0                	test   %eax,%eax
   425dc:	74 0a                	je     425e8 <keyboard_readc+0x214>
        ch = 0;
   425de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   425e5:	eb 01                	jmp    425e8 <keyboard_readc+0x214>
        if (modifiers & MOD_CONTROL) {
   425e7:	90                   	nop
    }

    return ch;
   425e8:	8b 45 fc             	mov    -0x4(%rbp),%eax
}
   425eb:	c9                   	leave
   425ec:	c3                   	ret

00000000000425ed <delay>:
#define IO_PARALLEL1_CONTROL    0x37A
# define IO_PARALLEL_CONTROL_SELECT     0x08
# define IO_PARALLEL_CONTROL_INIT       0x04
# define IO_PARALLEL_CONTROL_STROBE     0x01

static void delay(void) {
   425ed:	55                   	push   %rbp
   425ee:	48 89 e5             	mov    %rsp,%rbp
   425f1:	48 83 ec 20          	sub    $0x20,%rsp
   425f5:	c7 45 e4 84 00 00 00 	movl   $0x84,-0x1c(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   425fc:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   425ff:	89 c2                	mov    %eax,%edx
   42601:	ec                   	in     (%dx),%al
   42602:	88 45 e3             	mov    %al,-0x1d(%rbp)
   42605:	c7 45 ec 84 00 00 00 	movl   $0x84,-0x14(%rbp)
   4260c:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4260f:	89 c2                	mov    %eax,%edx
   42611:	ec                   	in     (%dx),%al
   42612:	88 45 eb             	mov    %al,-0x15(%rbp)
   42615:	c7 45 f4 84 00 00 00 	movl   $0x84,-0xc(%rbp)
   4261c:	8b 45 f4             	mov    -0xc(%rbp),%eax
   4261f:	89 c2                	mov    %eax,%edx
   42621:	ec                   	in     (%dx),%al
   42622:	88 45 f3             	mov    %al,-0xd(%rbp)
   42625:	c7 45 fc 84 00 00 00 	movl   $0x84,-0x4(%rbp)
   4262c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4262f:	89 c2                	mov    %eax,%edx
   42631:	ec                   	in     (%dx),%al
   42632:	88 45 fb             	mov    %al,-0x5(%rbp)
    (void) inb(0x84);
    (void) inb(0x84);
    (void) inb(0x84);
    (void) inb(0x84);
}
   42635:	90                   	nop
   42636:	c9                   	leave
   42637:	c3                   	ret

0000000000042638 <parallel_port_putc>:

static void parallel_port_putc(printer* p, unsigned char c, int color) {
   42638:	55                   	push   %rbp
   42639:	48 89 e5             	mov    %rsp,%rbp
   4263c:	48 83 ec 40          	sub    $0x40,%rsp
   42640:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   42644:	89 f0                	mov    %esi,%eax
   42646:	89 55 c0             	mov    %edx,-0x40(%rbp)
   42649:	88 45 c4             	mov    %al,-0x3c(%rbp)
    static int initialized;
    (void) p, (void) color;
    if (!initialized) {
   4264c:	8b 05 b2 1c 01 00    	mov    0x11cb2(%rip),%eax        # 54304 <initialized.0>
   42652:	85 c0                	test   %eax,%eax
   42654:	75 1e                	jne    42674 <parallel_port_putc+0x3c>
   42656:	c7 45 f8 7a 03 00 00 	movl   $0x37a,-0x8(%rbp)
   4265d:	c6 45 f7 00          	movb   $0x0,-0x9(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   42661:	0f b6 45 f7          	movzbl -0x9(%rbp),%eax
   42665:	8b 55 f8             	mov    -0x8(%rbp),%edx
   42668:	ee                   	out    %al,(%dx)
}
   42669:	90                   	nop
        outb(IO_PARALLEL1_CONTROL, 0);
        initialized = 1;
   4266a:	c7 05 90 1c 01 00 01 	movl   $0x1,0x11c90(%rip)        # 54304 <initialized.0>
   42671:	00 00 00 
    }

    for (int i = 0;
   42674:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   4267b:	eb 09                	jmp    42686 <parallel_port_putc+0x4e>
         i < 12800 && (inb(IO_PARALLEL1_STATUS) & IO_PARALLEL_STATUS_BUSY) == 0;
         ++i) {
        delay();
   4267d:	e8 6b ff ff ff       	call   425ed <delay>
         ++i) {
   42682:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
         i < 12800 && (inb(IO_PARALLEL1_STATUS) & IO_PARALLEL_STATUS_BUSY) == 0;
   42686:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%rbp)
   4268d:	7f 18                	jg     426a7 <parallel_port_putc+0x6f>
   4268f:	c7 45 f0 79 03 00 00 	movl   $0x379,-0x10(%rbp)
    asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
   42696:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42699:	89 c2                	mov    %eax,%edx
   4269b:	ec                   	in     (%dx),%al
   4269c:	88 45 ef             	mov    %al,-0x11(%rbp)
    return data;
   4269f:	0f b6 45 ef          	movzbl -0x11(%rbp),%eax
   426a3:	84 c0                	test   %al,%al
   426a5:	79 d6                	jns    4267d <parallel_port_putc+0x45>
    }
    outb(IO_PARALLEL1_DATA, c);
   426a7:	0f b6 45 c4          	movzbl -0x3c(%rbp),%eax
   426ab:	c7 45 d8 78 03 00 00 	movl   $0x378,-0x28(%rbp)
   426b2:	88 45 d7             	mov    %al,-0x29(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   426b5:	0f b6 45 d7          	movzbl -0x29(%rbp),%eax
   426b9:	8b 55 d8             	mov    -0x28(%rbp),%edx
   426bc:	ee                   	out    %al,(%dx)
}
   426bd:	90                   	nop
   426be:	c7 45 e0 7a 03 00 00 	movl   $0x37a,-0x20(%rbp)
   426c5:	c6 45 df 0d          	movb   $0xd,-0x21(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   426c9:	0f b6 45 df          	movzbl -0x21(%rbp),%eax
   426cd:	8b 55 e0             	mov    -0x20(%rbp),%edx
   426d0:	ee                   	out    %al,(%dx)
}
   426d1:	90                   	nop
   426d2:	c7 45 e8 7a 03 00 00 	movl   $0x37a,-0x18(%rbp)
   426d9:	c6 45 e7 0c          	movb   $0xc,-0x19(%rbp)
    asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
   426dd:	0f b6 45 e7          	movzbl -0x19(%rbp),%eax
   426e1:	8b 55 e8             	mov    -0x18(%rbp),%edx
   426e4:	ee                   	out    %al,(%dx)
}
   426e5:	90                   	nop
    outb(IO_PARALLEL1_CONTROL, IO_PARALLEL_CONTROL_SELECT
         | IO_PARALLEL_CONTROL_INIT | IO_PARALLEL_CONTROL_STROBE);
    outb(IO_PARALLEL1_CONTROL, IO_PARALLEL_CONTROL_SELECT
         | IO_PARALLEL_CONTROL_INIT);
}
   426e6:	90                   	nop
   426e7:	c9                   	leave
   426e8:	c3                   	ret

00000000000426e9 <log_vprintf>:

void log_vprintf(const char* format, va_list val) {
   426e9:	55                   	push   %rbp
   426ea:	48 89 e5             	mov    %rsp,%rbp
   426ed:	48 83 ec 20          	sub    $0x20,%rsp
   426f1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   426f5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    printer p;
    p.putc = parallel_port_putc;
   426f9:	48 c7 45 f8 38 26 04 	movq   $0x42638,-0x8(%rbp)
   42700:	00 
    printer_vprintf(&p, 0, format, val);
   42701:	48 8b 4d e0          	mov    -0x20(%rbp),%rcx
   42705:	48 8b 55 e8          	mov    -0x18(%rbp),%rdx
   42709:	48 8d 45 f8          	lea    -0x8(%rbp),%rax
   4270d:	be 00 00 00 00       	mov    $0x0,%esi
   42712:	48 89 c7             	mov    %rax,%rdi
   42715:	e8 ea 11 00 00       	call   43904 <printer_vprintf>
}
   4271a:	90                   	nop
   4271b:	c9                   	leave
   4271c:	c3                   	ret

000000000004271d <log_printf>:

void log_printf(const char* format, ...) {
   4271d:	55                   	push   %rbp
   4271e:	48 89 e5             	mov    %rsp,%rbp
   42721:	48 83 ec 60          	sub    $0x60,%rsp
   42725:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   42729:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
   4272d:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   42731:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   42735:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   42739:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   4273d:	c7 45 b8 08 00 00 00 	movl   $0x8,-0x48(%rbp)
   42744:	48 8d 45 10          	lea    0x10(%rbp),%rax
   42748:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   4274c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   42750:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    log_vprintf(format, val);
   42754:	48 8d 55 b8          	lea    -0x48(%rbp),%rdx
   42758:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   4275c:	48 89 d6             	mov    %rdx,%rsi
   4275f:	48 89 c7             	mov    %rax,%rdi
   42762:	e8 82 ff ff ff       	call   426e9 <log_vprintf>
    va_end(val);
}
   42767:	90                   	nop
   42768:	c9                   	leave
   42769:	c3                   	ret

000000000004276a <error_vprintf>:

// error_printf, error_vprintf
//    Print debugging messages to the console and to the host's
//    `log.txt` file via `log_printf`.

int error_vprintf(int cpos, int color, const char* format, va_list val) {
   4276a:	55                   	push   %rbp
   4276b:	48 89 e5             	mov    %rsp,%rbp
   4276e:	48 83 ec 40          	sub    $0x40,%rsp
   42772:	89 7d dc             	mov    %edi,-0x24(%rbp)
   42775:	89 75 d8             	mov    %esi,-0x28(%rbp)
   42778:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
   4277c:	48 89 4d c8          	mov    %rcx,-0x38(%rbp)
    va_list val2;
    __builtin_va_copy(val2, val);
   42780:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
   42784:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   42788:	48 8b 0a             	mov    (%rdx),%rcx
   4278b:	48 89 08             	mov    %rcx,(%rax)
   4278e:	48 8b 4a 08          	mov    0x8(%rdx),%rcx
   42792:	48 89 48 08          	mov    %rcx,0x8(%rax)
   42796:	48 8b 52 10          	mov    0x10(%rdx),%rdx
   4279a:	48 89 50 10          	mov    %rdx,0x10(%rax)
    log_vprintf(format, val2);
   4279e:	48 8d 55 e8          	lea    -0x18(%rbp),%rdx
   427a2:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   427a6:	48 89 d6             	mov    %rdx,%rsi
   427a9:	48 89 c7             	mov    %rax,%rdi
   427ac:	e8 38 ff ff ff       	call   426e9 <log_vprintf>
    va_end(val2);
    return console_vprintf(cpos, color, format, val);
   427b1:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   427b5:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   427b9:	8b 75 d8             	mov    -0x28(%rbp),%esi
   427bc:	8b 45 dc             	mov    -0x24(%rbp),%eax
   427bf:	89 c7                	mov    %eax,%edi
   427c1:	e8 ed 1b 00 00       	call   443b3 <console_vprintf>
}
   427c6:	c9                   	leave
   427c7:	c3                   	ret

00000000000427c8 <error_printf>:

int error_printf(int cpos, int color, const char* format, ...) {
   427c8:	55                   	push   %rbp
   427c9:	48 89 e5             	mov    %rsp,%rbp
   427cc:	48 83 ec 60          	sub    $0x60,%rsp
   427d0:	89 7d ac             	mov    %edi,-0x54(%rbp)
   427d3:	89 75 a8             	mov    %esi,-0x58(%rbp)
   427d6:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
   427da:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   427de:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   427e2:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   427e6:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   427ed:	48 8d 45 10          	lea    0x10(%rbp),%rax
   427f1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   427f5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   427f9:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = error_vprintf(cpos, color, format, val);
   427fd:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   42801:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
   42805:	8b 75 a8             	mov    -0x58(%rbp),%esi
   42808:	8b 45 ac             	mov    -0x54(%rbp),%eax
   4280b:	89 c7                	mov    %eax,%edi
   4280d:	e8 58 ff ff ff       	call   4276a <error_vprintf>
   42812:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
   42815:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
   42818:	c9                   	leave
   42819:	c3                   	ret

000000000004281a <check_keyboard>:
//    Check for the user typing a control key. 'a', 'f', and 'e' cause a soft
//    reboot where the kernel runs the allocator programs, "fork", or
//    "forkexit", respectively. Control-C or 'q' exit the virtual machine.
//    Returns key typed or -1 for no key.

int check_keyboard(void) {
   4281a:	55                   	push   %rbp
   4281b:	48 89 e5             	mov    %rsp,%rbp
   4281e:	53                   	push   %rbx
   4281f:	48 83 ec 48          	sub    $0x48,%rsp
    int c = keyboard_readc();
   42823:	e8 ac fb ff ff       	call   423d4 <keyboard_readc>
   42828:	89 45 e4             	mov    %eax,-0x1c(%rbp)
    if (c == 'a' || c == 'f' || c == 'e' || c == 't' || c =='2') {
   4282b:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
   4282f:	74 1c                	je     4284d <check_keyboard+0x33>
   42831:	83 7d e4 66          	cmpl   $0x66,-0x1c(%rbp)
   42835:	74 16                	je     4284d <check_keyboard+0x33>
   42837:	83 7d e4 65          	cmpl   $0x65,-0x1c(%rbp)
   4283b:	74 10                	je     4284d <check_keyboard+0x33>
   4283d:	83 7d e4 74          	cmpl   $0x74,-0x1c(%rbp)
   42841:	74 0a                	je     4284d <check_keyboard+0x33>
   42843:	83 7d e4 32          	cmpl   $0x32,-0x1c(%rbp)
   42847:	0f 85 e9 00 00 00    	jne    42936 <check_keyboard+0x11c>
        // Install a temporary page table to carry us through the
        // process of reinitializing memory. This replicates work the
        // bootloader does.
        x86_64_pagetable* pt = (x86_64_pagetable*) 0x8000;
   4284d:	48 c7 45 d8 00 80 00 	movq   $0x8000,-0x28(%rbp)
   42854:	00 
        memset(pt, 0, PAGESIZE * 3);
   42855:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42859:	ba 00 30 00 00       	mov    $0x3000,%edx
   4285e:	be 00 00 00 00       	mov    $0x0,%esi
   42863:	48 89 c7             	mov    %rax,%rdi
   42866:	e8 fd 0d 00 00       	call   43668 <memset>
        pt[0].entry[0] = 0x9000 | PTE_P | PTE_W | PTE_U;
   4286b:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4286f:	48 c7 00 07 90 00 00 	movq   $0x9007,(%rax)
        pt[1].entry[0] = 0xA000 | PTE_P | PTE_W | PTE_U;
   42876:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4287a:	48 05 00 10 00 00    	add    $0x1000,%rax
   42880:	48 c7 00 07 a0 00 00 	movq   $0xa007,(%rax)
        pt[2].entry[0] = PTE_P | PTE_W | PTE_U | PTE_PS;
   42887:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4288b:	48 05 00 20 00 00    	add    $0x2000,%rax
   42891:	48 c7 00 87 00 00 00 	movq   $0x87,(%rax)
        lcr3((uintptr_t) pt);
   42898:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4289c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
}

static inline void lcr3(uintptr_t val) {
    asm volatile("" : : : "memory");
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   428a0:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   428a4:	0f 22 d8             	mov    %rax,%cr3
}
   428a7:	90                   	nop
        // The soft reboot process doesn't modify memory, so it's
        // safe to pass `multiboot_info` on the kernel stack, even
        // though it will get overwritten as the kernel runs.
        uint32_t multiboot_info[5];
        multiboot_info[0] = 4;
   428a8:	c7 45 b4 04 00 00 00 	movl   $0x4,-0x4c(%rbp)
        const char* argument = "fork";
   428af:	48 c7 45 e8 58 4b 04 	movq   $0x44b58,-0x18(%rbp)
   428b6:	00 
        if (c == 'a') {
   428b7:	83 7d e4 61          	cmpl   $0x61,-0x1c(%rbp)
   428bb:	75 0a                	jne    428c7 <check_keyboard+0xad>
            argument = "allocator";
   428bd:	48 c7 45 e8 5d 4b 04 	movq   $0x44b5d,-0x18(%rbp)
   428c4:	00 
   428c5:	eb 2e                	jmp    428f5 <check_keyboard+0xdb>
        } else if (c == 'e') {
   428c7:	83 7d e4 65          	cmpl   $0x65,-0x1c(%rbp)
   428cb:	75 0a                	jne    428d7 <check_keyboard+0xbd>
            argument = "forkexit";
   428cd:	48 c7 45 e8 67 4b 04 	movq   $0x44b67,-0x18(%rbp)
   428d4:	00 
   428d5:	eb 1e                	jmp    428f5 <check_keyboard+0xdb>
        }
        else if (c == 't'){
   428d7:	83 7d e4 74          	cmpl   $0x74,-0x1c(%rbp)
   428db:	75 0a                	jne    428e7 <check_keyboard+0xcd>
            argument = "test";
   428dd:	48 c7 45 e8 70 4b 04 	movq   $0x44b70,-0x18(%rbp)
   428e4:	00 
   428e5:	eb 0e                	jmp    428f5 <check_keyboard+0xdb>
        }
        else if(c == '2'){
   428e7:	83 7d e4 32          	cmpl   $0x32,-0x1c(%rbp)
   428eb:	75 08                	jne    428f5 <check_keyboard+0xdb>
            argument = "test2";
   428ed:	48 c7 45 e8 75 4b 04 	movq   $0x44b75,-0x18(%rbp)
   428f4:	00 
        }
        uintptr_t argument_ptr = (uintptr_t) argument;
   428f5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   428f9:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        assert(argument_ptr < 0x100000000L);
   428fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42902:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
   42906:	73 14                	jae    4291c <check_keyboard+0x102>
   42908:	ba 7b 4b 04 00       	mov    $0x44b7b,%edx
   4290d:	be 5d 02 00 00       	mov    $0x25d,%esi
   42912:	bf 97 4b 04 00       	mov    $0x44b97,%edi
   42917:	e8 1f 01 00 00       	call   42a3b <assert_fail>
        multiboot_info[4] = (uint32_t) argument_ptr;
   4291c:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42920:	89 45 c4             	mov    %eax,-0x3c(%rbp)
        asm volatile("movl $0x2BADB002, %%eax; jmp entry_from_boot"
   42923:	48 8d 45 b4          	lea    -0x4c(%rbp),%rax
   42927:	48 89 c3             	mov    %rax,%rbx
   4292a:	b8 02 b0 ad 2b       	mov    $0x2badb002,%eax
   4292f:	e9 cc d6 ff ff       	jmp    40000 <entry_from_boot>
    if (c == 'a' || c == 'f' || c == 'e' || c == 't' || c =='2') {
   42934:	eb 11                	jmp    42947 <check_keyboard+0x12d>
                     : : "b" (multiboot_info) : "memory");
    } else if (c == 0x03 || c == 'q') {
   42936:	83 7d e4 03          	cmpl   $0x3,-0x1c(%rbp)
   4293a:	74 06                	je     42942 <check_keyboard+0x128>
   4293c:	83 7d e4 71          	cmpl   $0x71,-0x1c(%rbp)
   42940:	75 05                	jne    42947 <check_keyboard+0x12d>
        poweroff();
   42942:	e8 9d f8 ff ff       	call   421e4 <poweroff>
    }
    return c;
   42947:	8b 45 e4             	mov    -0x1c(%rbp),%eax
}
   4294a:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   4294e:	c9                   	leave
   4294f:	c3                   	ret

0000000000042950 <fail>:

// fail
//    Loop until user presses Control-C, then poweroff.

static void fail(void) __attribute__((noreturn));
static void fail(void) {
   42950:	55                   	push   %rbp
   42951:	48 89 e5             	mov    %rsp,%rbp
    while (1) {
        check_keyboard();
   42954:	e8 c1 fe ff ff       	call   4281a <check_keyboard>
   42959:	eb f9                	jmp    42954 <fail+0x4>

000000000004295b <panic>:

// panic, assert_fail
//    Use console_printf() to print a failure message and then wait for
//    control-C. Also write the failure message to the log.

void panic(const char* format, ...) {
   4295b:	55                   	push   %rbp
   4295c:	48 89 e5             	mov    %rsp,%rbp
   4295f:	48 83 ec 60          	sub    $0x60,%rsp
   42963:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   42967:	48 89 75 d8          	mov    %rsi,-0x28(%rbp)
   4296b:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   4296f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   42973:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   42977:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   4297b:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%rbp)
   42982:	48 8d 45 10          	lea    0x10(%rbp),%rax
   42986:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
   4298a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   4298e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)

    if (format) {
   42992:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
   42997:	0f 84 80 00 00 00    	je     42a1d <panic+0xc2>
        // Print panic message to both the screen and the log
        int cpos = error_printf(CPOS(23, 0), 0xC000, "PANIC: ");
   4299d:	ba ab 4b 04 00       	mov    $0x44bab,%edx
   429a2:	be 00 c0 00 00       	mov    $0xc000,%esi
   429a7:	bf 30 07 00 00       	mov    $0x730,%edi
   429ac:	b8 00 00 00 00       	mov    $0x0,%eax
   429b1:	e8 12 fe ff ff       	call   427c8 <error_printf>
   429b6:	89 45 cc             	mov    %eax,-0x34(%rbp)
        cpos = error_vprintf(cpos, 0xC000, format, val);
   429b9:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
   429bd:	48 8b 55 a8          	mov    -0x58(%rbp),%rdx
   429c1:	8b 45 cc             	mov    -0x34(%rbp),%eax
   429c4:	be 00 c0 00 00       	mov    $0xc000,%esi
   429c9:	89 c7                	mov    %eax,%edi
   429cb:	e8 9a fd ff ff       	call   4276a <error_vprintf>
   429d0:	89 45 cc             	mov    %eax,-0x34(%rbp)
        if (CCOL(cpos)) {
   429d3:	8b 4d cc             	mov    -0x34(%rbp),%ecx
   429d6:	48 63 c1             	movslq %ecx,%rax
   429d9:	48 69 c0 67 66 66 66 	imul   $0x66666667,%rax,%rax
   429e0:	48 c1 e8 20          	shr    $0x20,%rax
   429e4:	89 c2                	mov    %eax,%edx
   429e6:	c1 fa 05             	sar    $0x5,%edx
   429e9:	89 c8                	mov    %ecx,%eax
   429eb:	c1 f8 1f             	sar    $0x1f,%eax
   429ee:	29 c2                	sub    %eax,%edx
   429f0:	89 d0                	mov    %edx,%eax
   429f2:	c1 e0 02             	shl    $0x2,%eax
   429f5:	01 d0                	add    %edx,%eax
   429f7:	c1 e0 04             	shl    $0x4,%eax
   429fa:	29 c1                	sub    %eax,%ecx
   429fc:	89 ca                	mov    %ecx,%edx
   429fe:	85 d2                	test   %edx,%edx
   42a00:	74 34                	je     42a36 <panic+0xdb>
            error_printf(cpos, 0xC000, "\n");
   42a02:	8b 45 cc             	mov    -0x34(%rbp),%eax
   42a05:	ba b3 4b 04 00       	mov    $0x44bb3,%edx
   42a0a:	be 00 c0 00 00       	mov    $0xc000,%esi
   42a0f:	89 c7                	mov    %eax,%edi
   42a11:	b8 00 00 00 00       	mov    $0x0,%eax
   42a16:	e8 ad fd ff ff       	call   427c8 <error_printf>
   42a1b:	eb 19                	jmp    42a36 <panic+0xdb>
        }
    } else {
        error_printf(CPOS(23, 0), 0xC000, "PANIC");
   42a1d:	ba b5 4b 04 00       	mov    $0x44bb5,%edx
   42a22:	be 00 c0 00 00       	mov    $0xc000,%esi
   42a27:	bf 30 07 00 00       	mov    $0x730,%edi
   42a2c:	b8 00 00 00 00       	mov    $0x0,%eax
   42a31:	e8 92 fd ff ff       	call   427c8 <error_printf>
    }

    va_end(val);
    fail();
   42a36:	e8 15 ff ff ff       	call   42950 <fail>

0000000000042a3b <assert_fail>:
}

void assert_fail(const char* file, int line, const char* msg) {
   42a3b:	55                   	push   %rbp
   42a3c:	48 89 e5             	mov    %rsp,%rbp
   42a3f:	48 83 ec 20          	sub    $0x20,%rsp
   42a43:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   42a47:	89 75 f4             	mov    %esi,-0xc(%rbp)
   42a4a:	48 89 55 e8          	mov    %rdx,-0x18(%rbp)
    panic("%s:%d: assertion '%s' failed\n", file, line, msg);
   42a4e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
   42a52:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42a55:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42a59:	48 89 c6             	mov    %rax,%rsi
   42a5c:	bf bb 4b 04 00       	mov    $0x44bbb,%edi
   42a61:	b8 00 00 00 00       	mov    $0x0,%eax
   42a66:	e8 f0 fe ff ff       	call   4295b <panic>

0000000000042a6b <default_exception>:
}

void default_exception(proc* p){
   42a6b:	55                   	push   %rbp
   42a6c:	48 89 e5             	mov    %rsp,%rbp
   42a6f:	48 83 ec 20          	sub    $0x20,%rsp
   42a73:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    x86_64_registers * reg = &(p->p_registers);
   42a77:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42a7b:	48 83 c0 08          	add    $0x8,%rax
   42a7f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    panic("Unexpected exception %d!\n", reg->reg_intno);
   42a83:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42a87:	48 8b 80 88 00 00 00 	mov    0x88(%rax),%rax
   42a8e:	48 89 c6             	mov    %rax,%rsi
   42a91:	bf d9 4b 04 00       	mov    $0x44bd9,%edi
   42a96:	b8 00 00 00 00       	mov    $0x0,%eax
   42a9b:	e8 bb fe ff ff       	call   4295b <panic>

0000000000042aa0 <pageindex>:
static inline int pageindex(uintptr_t addr, int level) {
   42aa0:	55                   	push   %rbp
   42aa1:	48 89 e5             	mov    %rsp,%rbp
   42aa4:	48 83 ec 10          	sub    $0x10,%rsp
   42aa8:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   42aac:	89 75 f4             	mov    %esi,-0xc(%rbp)
    assert(level >= 0 && level <= 3);
   42aaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%rbp)
   42ab3:	78 06                	js     42abb <pageindex+0x1b>
   42ab5:	83 7d f4 03          	cmpl   $0x3,-0xc(%rbp)
   42ab9:	7e 14                	jle    42acf <pageindex+0x2f>
   42abb:	ba f8 4b 04 00       	mov    $0x44bf8,%edx
   42ac0:	be 1e 00 00 00       	mov    $0x1e,%esi
   42ac5:	bf 11 4c 04 00       	mov    $0x44c11,%edi
   42aca:	e8 6c ff ff ff       	call   42a3b <assert_fail>
    return (int) (addr >> (PAGEOFFBITS + (3 - level) * PAGEINDEXBITS)) & 0x1FF;
   42acf:	b8 03 00 00 00       	mov    $0x3,%eax
   42ad4:	2b 45 f4             	sub    -0xc(%rbp),%eax
   42ad7:	89 c2                	mov    %eax,%edx
   42ad9:	89 d0                	mov    %edx,%eax
   42adb:	c1 e0 03             	shl    $0x3,%eax
   42ade:	01 d0                	add    %edx,%eax
   42ae0:	83 c0 0c             	add    $0xc,%eax
   42ae3:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   42ae7:	89 c1                	mov    %eax,%ecx
   42ae9:	48 d3 ea             	shr    %cl,%rdx
   42aec:	48 89 d0             	mov    %rdx,%rax
   42aef:	25 ff 01 00 00       	and    $0x1ff,%eax
}
   42af4:	c9                   	leave
   42af5:	c3                   	ret

0000000000042af6 <virtual_memory_init>:

static x86_64_pagetable kernel_pagetables[5];
x86_64_pagetable* kernel_pagetable;


void virtual_memory_init(void) {
   42af6:	55                   	push   %rbp
   42af7:	48 89 e5             	mov    %rsp,%rbp
   42afa:	48 83 ec 20          	sub    $0x20,%rsp
    kernel_pagetable = &kernel_pagetables[0];
   42afe:	48 c7 05 f7 24 01 00 	movq   $0x56000,0x124f7(%rip)        # 55000 <kernel_pagetable>
   42b05:	00 60 05 00 
    memset(kernel_pagetables, 0, sizeof(kernel_pagetables));
   42b09:	ba 00 50 00 00       	mov    $0x5000,%edx
   42b0e:	be 00 00 00 00       	mov    $0x0,%esi
   42b13:	bf 00 60 05 00       	mov    $0x56000,%edi
   42b18:	e8 4b 0b 00 00       	call   43668 <memset>

    // connect the pagetable pages
    kernel_pagetables[0].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[1] | PTE_P | PTE_W | PTE_U;
   42b1d:	b8 00 70 05 00       	mov    $0x57000,%eax
   42b22:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[0].entry[0] =
   42b26:	48 89 05 d3 34 01 00 	mov    %rax,0x134d3(%rip)        # 56000 <kernel_pagetables>
    kernel_pagetables[1].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[2] | PTE_P | PTE_W | PTE_U;
   42b2d:	b8 00 80 05 00       	mov    $0x58000,%eax
   42b32:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[1].entry[0] =
   42b36:	48 89 05 c3 44 01 00 	mov    %rax,0x144c3(%rip)        # 57000 <kernel_pagetables+0x1000>
    kernel_pagetables[2].entry[0] =
        (x86_64_pageentry_t) &kernel_pagetables[3] | PTE_P | PTE_W | PTE_U;
   42b3d:	b8 00 90 05 00       	mov    $0x59000,%eax
   42b42:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[2].entry[0] =
   42b46:	48 89 05 b3 54 01 00 	mov    %rax,0x154b3(%rip)        # 58000 <kernel_pagetables+0x2000>
    kernel_pagetables[2].entry[1] =
        (x86_64_pageentry_t) &kernel_pagetables[4] | PTE_P | PTE_W | PTE_U;
   42b4d:	b8 00 a0 05 00       	mov    $0x5a000,%eax
   42b52:	48 83 c8 07          	or     $0x7,%rax
    kernel_pagetables[2].entry[1] =
   42b56:	48 89 05 ab 54 01 00 	mov    %rax,0x154ab(%rip)        # 58008 <kernel_pagetables+0x2008>

    // identity map the page table
    virtual_memory_map(kernel_pagetable, (uintptr_t) 0, (uintptr_t) 0,
   42b5d:	48 8b 05 9c 24 01 00 	mov    0x1249c(%rip),%rax        # 55000 <kernel_pagetable>
   42b64:	41 b8 03 00 00 00    	mov    $0x3,%r8d
   42b6a:	b9 00 00 20 00       	mov    $0x200000,%ecx
   42b6f:	ba 00 00 00 00       	mov    $0x0,%edx
   42b74:	be 00 00 00 00       	mov    $0x0,%esi
   42b79:	48 89 c7             	mov    %rax,%rdi
   42b7c:	e8 dd 01 00 00       	call   42d5e <virtual_memory_map>
                       MEMSIZE_PHYSICAL, PTE_P | PTE_W);
    virtual_memory_map(kernel_pagetable, (uintptr_t) CONSOLE_ADDR, (uintptr_t) CONSOLE_ADDR,
   42b81:	ba 00 80 0b 00       	mov    $0xb8000,%edx
   42b86:	be 00 80 0b 00       	mov    $0xb8000,%esi
   42b8b:	48 8b 05 6e 24 01 00 	mov    0x1246e(%rip),%rax        # 55000 <kernel_pagetable>
   42b92:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   42b98:	b9 00 10 00 00       	mov    $0x1000,%ecx
   42b9d:	48 89 c7             	mov    %rax,%rdi
   42ba0:	e8 b9 01 00 00       	call   42d5e <virtual_memory_map>
                       PAGESIZE, PTE_P | PTE_W | PTE_U);
    // check if kernel is identity mapped
    for(uintptr_t addr = 0 ; addr < MEMSIZE_PHYSICAL ; addr += PAGESIZE){
   42ba5:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   42bac:	00 
   42bad:	eb 62                	jmp    42c11 <virtual_memory_init+0x11b>
        vamapping vmap = virtual_memory_lookup(kernel_pagetable, addr);
   42baf:	48 8b 0d 4a 24 01 00 	mov    0x1244a(%rip),%rcx        # 55000 <kernel_pagetable>
   42bb6:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
   42bba:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   42bbe:	48 89 ce             	mov    %rcx,%rsi
   42bc1:	48 89 c7             	mov    %rax,%rdi
   42bc4:	e8 64 05 00 00       	call   4312d <virtual_memory_lookup>
        // this assert will probably fail initially!
        // have you implemented virtual_memory_map and lookup_l1pagetable ?
        assert(vmap.pa == addr);
   42bc9:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42bcd:	48 39 45 f8          	cmp    %rax,-0x8(%rbp)
   42bd1:	74 14                	je     42be7 <virtual_memory_init+0xf1>
   42bd3:	ba 25 4c 04 00       	mov    $0x44c25,%edx
   42bd8:	be 2e 00 00 00       	mov    $0x2e,%esi
   42bdd:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42be2:	e8 54 fe ff ff       	call   42a3b <assert_fail>
        assert((vmap.perm & (PTE_P|PTE_W)) == (PTE_P|PTE_W));
   42be7:	8b 45 f0             	mov    -0x10(%rbp),%eax
   42bea:	48 98                	cltq
   42bec:	83 e0 03             	and    $0x3,%eax
   42bef:	48 83 f8 03          	cmp    $0x3,%rax
   42bf3:	74 14                	je     42c09 <virtual_memory_init+0x113>
   42bf5:	ba 48 4c 04 00       	mov    $0x44c48,%edx
   42bfa:	be 2f 00 00 00       	mov    $0x2f,%esi
   42bff:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42c04:	e8 32 fe ff ff       	call   42a3b <assert_fail>
    for(uintptr_t addr = 0 ; addr < MEMSIZE_PHYSICAL ; addr += PAGESIZE){
   42c09:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   42c10:	00 
   42c11:	48 81 7d f8 ff ff 1f 	cmpq   $0x1fffff,-0x8(%rbp)
   42c18:	00 
   42c19:	76 94                	jbe    42baf <virtual_memory_init+0xb9>
    }

    // set pointer to this pagetable in the CR3 register
    // set_pagetable also does several checks for a valid pagetable
    set_pagetable(kernel_pagetable);
   42c1b:	48 8b 05 de 23 01 00 	mov    0x123de(%rip),%rax        # 55000 <kernel_pagetable>
   42c22:	48 89 c7             	mov    %rax,%rdi
   42c25:	e8 03 00 00 00       	call   42c2d <set_pagetable>
}
   42c2a:	90                   	nop
   42c2b:	c9                   	leave
   42c2c:	c3                   	ret

0000000000042c2d <set_pagetable>:
// set_pagetable
//    Change page directory. lcr3() is the hardware instruction;
//    set_pagetable() additionally checks that important kernel procedures are
//    mappable in `pagetable`, and calls panic() if they aren't.

void set_pagetable(x86_64_pagetable* pagetable) {
   42c2d:	55                   	push   %rbp
   42c2e:	48 89 e5             	mov    %rsp,%rbp
   42c31:	48 83 c4 80          	add    $0xffffffffffffff80,%rsp
   42c35:	48 89 7d 88          	mov    %rdi,-0x78(%rbp)
    assert(PAGEOFFSET(pagetable) == 0); // must be page aligned
   42c39:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   42c3d:	25 ff 0f 00 00       	and    $0xfff,%eax
   42c42:	48 85 c0             	test   %rax,%rax
   42c45:	74 14                	je     42c5b <set_pagetable+0x2e>
   42c47:	ba 75 4c 04 00       	mov    $0x44c75,%edx
   42c4c:	be 3e 00 00 00       	mov    $0x3e,%esi
   42c51:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42c56:	e8 e0 fd ff ff       	call   42a3b <assert_fail>
    // check for kernel space being mapped in pagetable
    assert(virtual_memory_lookup(pagetable, (uintptr_t) default_int_handler).pa
   42c5b:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   42c60:	48 8d 45 98          	lea    -0x68(%rbp),%rax
   42c64:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42c68:	48 89 ce             	mov    %rcx,%rsi
   42c6b:	48 89 c7             	mov    %rax,%rdi
   42c6e:	e8 ba 04 00 00       	call   4312d <virtual_memory_lookup>
   42c73:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   42c77:	ba 9c 00 04 00       	mov    $0x4009c,%edx
   42c7c:	48 39 d0             	cmp    %rdx,%rax
   42c7f:	74 14                	je     42c95 <set_pagetable+0x68>
   42c81:	ba 90 4c 04 00       	mov    $0x44c90,%edx
   42c86:	be 40 00 00 00       	mov    $0x40,%esi
   42c8b:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42c90:	e8 a6 fd ff ff       	call   42a3b <assert_fail>
           == (uintptr_t) default_int_handler);
    assert(virtual_memory_lookup(kernel_pagetable, (uintptr_t) pagetable).pa
   42c95:	48 8b 55 88          	mov    -0x78(%rbp),%rdx
   42c99:	48 8b 0d 60 23 01 00 	mov    0x12360(%rip),%rcx        # 55000 <kernel_pagetable>
   42ca0:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
   42ca4:	48 89 ce             	mov    %rcx,%rsi
   42ca7:	48 89 c7             	mov    %rax,%rdi
   42caa:	e8 7e 04 00 00       	call   4312d <virtual_memory_lookup>
   42caf:	48 8b 55 b8          	mov    -0x48(%rbp),%rdx
   42cb3:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   42cb7:	48 39 c2             	cmp    %rax,%rdx
   42cba:	74 14                	je     42cd0 <set_pagetable+0xa3>
   42cbc:	ba f8 4c 04 00       	mov    $0x44cf8,%edx
   42cc1:	be 42 00 00 00       	mov    $0x42,%esi
   42cc6:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42ccb:	e8 6b fd ff ff       	call   42a3b <assert_fail>
           == (uintptr_t) pagetable);
    assert(virtual_memory_lookup(pagetable, (uintptr_t) kernel_pagetable).pa
   42cd0:	48 8b 05 29 23 01 00 	mov    0x12329(%rip),%rax        # 55000 <kernel_pagetable>
   42cd7:	48 89 c2             	mov    %rax,%rdx
   42cda:	48 8d 45 c8          	lea    -0x38(%rbp),%rax
   42cde:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42ce2:	48 89 ce             	mov    %rcx,%rsi
   42ce5:	48 89 c7             	mov    %rax,%rdi
   42ce8:	e8 40 04 00 00       	call   4312d <virtual_memory_lookup>
   42ced:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42cf1:	48 8b 15 08 23 01 00 	mov    0x12308(%rip),%rdx        # 55000 <kernel_pagetable>
   42cf8:	48 39 d0             	cmp    %rdx,%rax
   42cfb:	74 14                	je     42d11 <set_pagetable+0xe4>
   42cfd:	ba 58 4d 04 00       	mov    $0x44d58,%edx
   42d02:	be 44 00 00 00       	mov    $0x44,%esi
   42d07:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42d0c:	e8 2a fd ff ff       	call   42a3b <assert_fail>
           == (uintptr_t) kernel_pagetable);
    assert(virtual_memory_lookup(pagetable, (uintptr_t) virtual_memory_map).pa
   42d11:	ba 5e 2d 04 00       	mov    $0x42d5e,%edx
   42d16:	48 8d 45 e0          	lea    -0x20(%rbp),%rax
   42d1a:	48 8b 4d 88          	mov    -0x78(%rbp),%rcx
   42d1e:	48 89 ce             	mov    %rcx,%rsi
   42d21:	48 89 c7             	mov    %rax,%rdi
   42d24:	e8 04 04 00 00       	call   4312d <virtual_memory_lookup>
   42d29:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   42d2d:	ba 5e 2d 04 00       	mov    $0x42d5e,%edx
   42d32:	48 39 d0             	cmp    %rdx,%rax
   42d35:	74 14                	je     42d4b <set_pagetable+0x11e>
   42d37:	ba c0 4d 04 00       	mov    $0x44dc0,%edx
   42d3c:	be 46 00 00 00       	mov    $0x46,%esi
   42d41:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42d46:	e8 f0 fc ff ff       	call   42a3b <assert_fail>
           == (uintptr_t) virtual_memory_map);
    lcr3((uintptr_t) pagetable);
   42d4b:	48 8b 45 88          	mov    -0x78(%rbp),%rax
   42d4f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    asm volatile("movq %0,%%cr3" : : "r" (val) : "memory");
   42d53:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   42d57:	0f 22 d8             	mov    %rax,%cr3
}
   42d5a:	90                   	nop
}
   42d5b:	90                   	nop
   42d5c:	c9                   	leave
   42d5d:	c3                   	ret

0000000000042d5e <virtual_memory_map>:
//    Returns NULL otherwise
static x86_64_pagetable* lookup_l1pagetable(x86_64_pagetable* pagetable,
                 uintptr_t va, int perm);

int virtual_memory_map(x86_64_pagetable* pagetable, uintptr_t va,
                       uintptr_t pa, size_t sz, int perm) {
   42d5e:	55                   	push   %rbp
   42d5f:	48 89 e5             	mov    %rsp,%rbp
   42d62:	48 83 ec 50          	sub    $0x50,%rsp
   42d66:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   42d6a:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
   42d6e:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
   42d72:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
   42d76:	44 89 45 bc          	mov    %r8d,-0x44(%rbp)

    // sanity checks for virtual address, size, and permisions
    assert(va % PAGESIZE == 0); // virtual address is page-aligned
   42d7a:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42d7e:	25 ff 0f 00 00       	and    $0xfff,%eax
   42d83:	48 85 c0             	test   %rax,%rax
   42d86:	74 14                	je     42d9c <virtual_memory_map+0x3e>
   42d88:	ba 26 4e 04 00       	mov    $0x44e26,%edx
   42d8d:	be 67 00 00 00       	mov    $0x67,%esi
   42d92:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42d97:	e8 9f fc ff ff       	call   42a3b <assert_fail>
    assert(sz % PAGESIZE == 0); // size is a multiple of PAGESIZE
   42d9c:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42da0:	25 ff 0f 00 00       	and    $0xfff,%eax
   42da5:	48 85 c0             	test   %rax,%rax
   42da8:	74 14                	je     42dbe <virtual_memory_map+0x60>
   42daa:	ba 39 4e 04 00       	mov    $0x44e39,%edx
   42daf:	be 68 00 00 00       	mov    $0x68,%esi
   42db4:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42db9:	e8 7d fc ff ff       	call   42a3b <assert_fail>
    assert(va + sz >= va || va + sz == 0); // va range does not wrap
   42dbe:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   42dc2:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42dc6:	48 01 d0             	add    %rdx,%rax
   42dc9:	48 3b 45 d0          	cmp    -0x30(%rbp),%rax
   42dcd:	73 24                	jae    42df3 <virtual_memory_map+0x95>
   42dcf:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   42dd3:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42dd7:	48 01 d0             	add    %rdx,%rax
   42dda:	48 85 c0             	test   %rax,%rax
   42ddd:	74 14                	je     42df3 <virtual_memory_map+0x95>
   42ddf:	ba 4c 4e 04 00       	mov    $0x44e4c,%edx
   42de4:	be 69 00 00 00       	mov    $0x69,%esi
   42de9:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42dee:	e8 48 fc ff ff       	call   42a3b <assert_fail>
    if (perm & PTE_P) {
   42df3:	8b 45 bc             	mov    -0x44(%rbp),%eax
   42df6:	48 98                	cltq
   42df8:	83 e0 01             	and    $0x1,%eax
   42dfb:	48 85 c0             	test   %rax,%rax
   42dfe:	74 6e                	je     42e6e <virtual_memory_map+0x110>
        assert(pa % PAGESIZE == 0); // physical addr is page-aligned
   42e00:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   42e04:	25 ff 0f 00 00       	and    $0xfff,%eax
   42e09:	48 85 c0             	test   %rax,%rax
   42e0c:	74 14                	je     42e22 <virtual_memory_map+0xc4>
   42e0e:	ba 6a 4e 04 00       	mov    $0x44e6a,%edx
   42e13:	be 6b 00 00 00       	mov    $0x6b,%esi
   42e18:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42e1d:	e8 19 fc ff ff       	call   42a3b <assert_fail>
        assert(pa + sz >= pa);      // physical address range does not wrap
   42e22:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   42e26:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42e2a:	48 01 d0             	add    %rdx,%rax
   42e2d:	48 3b 45 c8          	cmp    -0x38(%rbp),%rax
   42e31:	73 14                	jae    42e47 <virtual_memory_map+0xe9>
   42e33:	ba 7d 4e 04 00       	mov    $0x44e7d,%edx
   42e38:	be 6c 00 00 00       	mov    $0x6c,%esi
   42e3d:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42e42:	e8 f4 fb ff ff       	call   42a3b <assert_fail>
        assert(pa + sz <= MEMSIZE_PHYSICAL); // physical addresses exist
   42e47:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   42e4b:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   42e4f:	48 01 d0             	add    %rdx,%rax
   42e52:	48 3d 00 00 20 00    	cmp    $0x200000,%rax
   42e58:	76 14                	jbe    42e6e <virtual_memory_map+0x110>
   42e5a:	ba 8b 4e 04 00       	mov    $0x44e8b,%edx
   42e5f:	be 6d 00 00 00       	mov    $0x6d,%esi
   42e64:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42e69:	e8 cd fb ff ff       	call   42a3b <assert_fail>
    }
    assert(perm >= 0 && perm < 0x1000); // `perm` makes sense (perm can only be 12 bits)
   42e6e:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
   42e72:	78 09                	js     42e7d <virtual_memory_map+0x11f>
   42e74:	81 7d bc ff 0f 00 00 	cmpl   $0xfff,-0x44(%rbp)
   42e7b:	7e 14                	jle    42e91 <virtual_memory_map+0x133>
   42e7d:	ba a7 4e 04 00       	mov    $0x44ea7,%edx
   42e82:	be 6f 00 00 00       	mov    $0x6f,%esi
   42e87:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42e8c:	e8 aa fb ff ff       	call   42a3b <assert_fail>
    assert((uintptr_t) pagetable % PAGESIZE == 0); // `pagetable` page-aligned
   42e91:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42e95:	25 ff 0f 00 00       	and    $0xfff,%eax
   42e9a:	48 85 c0             	test   %rax,%rax
   42e9d:	74 14                	je     42eb3 <virtual_memory_map+0x155>
   42e9f:	ba c8 4e 04 00       	mov    $0x44ec8,%edx
   42ea4:	be 70 00 00 00       	mov    $0x70,%esi
   42ea9:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   42eae:	e8 88 fb ff ff       	call   42a3b <assert_fail>

    int last_index123 = -1;
   42eb3:	c7 45 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%rbp)
    x86_64_pagetable* l1pagetable = NULL;
   42eba:	48 c7 45 f0 00 00 00 	movq   $0x0,-0x10(%rbp)
   42ec1:	00 

    // for each page-aligned address, set the appropriate page entry
    for (; sz != 0; va += PAGESIZE, pa += PAGESIZE, sz -= PAGESIZE) {
   42ec2:	e9 ec 00 00 00       	jmp    42fb3 <virtual_memory_map+0x255>
        int cur_index123 = (va >> (PAGEOFFBITS + PAGEINDEXBITS));
   42ec7:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42ecb:	48 c1 e8 15          	shr    $0x15,%rax
   42ecf:	89 45 ec             	mov    %eax,-0x14(%rbp)
        if (cur_index123 != last_index123) {
   42ed2:	8b 45 ec             	mov    -0x14(%rbp),%eax
   42ed5:	3b 45 fc             	cmp    -0x4(%rbp),%eax
   42ed8:	74 20                	je     42efa <virtual_memory_map+0x19c>
            l1pagetable = lookup_l1pagetable(pagetable, va, perm);
   42eda:	8b 55 bc             	mov    -0x44(%rbp),%edx
   42edd:	48 8b 4d d0          	mov    -0x30(%rbp),%rcx
   42ee1:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42ee5:	48 89 ce             	mov    %rcx,%rsi
   42ee8:	48 89 c7             	mov    %rax,%rdi
   42eeb:	e8 d5 00 00 00       	call   42fc5 <lookup_l1pagetable>
   42ef0:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
            last_index123 = cur_index123;
   42ef4:	8b 45 ec             	mov    -0x14(%rbp),%eax
   42ef7:	89 45 fc             	mov    %eax,-0x4(%rbp)
        }
        if ((perm & PTE_P) && l1pagetable) { 
   42efa:	8b 45 bc             	mov    -0x44(%rbp),%eax
   42efd:	48 98                	cltq
   42eff:	83 e0 01             	and    $0x1,%eax
   42f02:	48 85 c0             	test   %rax,%rax
   42f05:	74 3b                	je     42f42 <virtual_memory_map+0x1e4>
   42f07:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
   42f0c:	74 34                	je     42f42 <virtual_memory_map+0x1e4>
            int index = L1PAGEINDEX(va);
   42f0e:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42f12:	be 03 00 00 00       	mov    $0x3,%esi
   42f17:	48 89 c7             	mov    %rax,%rdi
   42f1a:	e8 81 fb ff ff       	call   42aa0 <pageindex>
   42f1f:	89 45 e8             	mov    %eax,-0x18(%rbp)
            l1pagetable->entry[index] = pa | perm | PTE_P;
   42f22:	8b 45 bc             	mov    -0x44(%rbp),%eax
   42f25:	48 98                	cltq
   42f27:	48 0b 45 c8          	or     -0x38(%rbp),%rax
   42f2b:	48 83 c8 01          	or     $0x1,%rax
   42f2f:	48 89 c1             	mov    %rax,%rcx
   42f32:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42f36:	8b 55 e8             	mov    -0x18(%rbp),%edx
   42f39:	48 63 d2             	movslq %edx,%rdx
   42f3c:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
        if ((perm & PTE_P) && l1pagetable) { 
   42f40:	eb 59                	jmp    42f9b <virtual_memory_map+0x23d>
        } else if (l1pagetable) { 
   42f42:	48 83 7d f0 00       	cmpq   $0x0,-0x10(%rbp)
   42f47:	74 2a                	je     42f73 <virtual_memory_map+0x215>
            int index = L1PAGEINDEX(va);
   42f49:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42f4d:	be 03 00 00 00       	mov    $0x3,%esi
   42f52:	48 89 c7             	mov    %rax,%rdi
   42f55:	e8 46 fb ff ff       	call   42aa0 <pageindex>
   42f5a:	89 45 e4             	mov    %eax,-0x1c(%rbp)
            l1pagetable->entry[index] = perm;
   42f5d:	8b 45 bc             	mov    -0x44(%rbp),%eax
   42f60:	48 63 c8             	movslq %eax,%rcx
   42f63:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   42f67:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   42f6a:	48 63 d2             	movslq %edx,%rdx
   42f6d:	48 89 0c d0          	mov    %rcx,(%rax,%rdx,8)
   42f71:	eb 28                	jmp    42f9b <virtual_memory_map+0x23d>
        } else if (perm & PTE_P) {
   42f73:	8b 45 bc             	mov    -0x44(%rbp),%eax
   42f76:	48 98                	cltq
   42f78:	83 e0 01             	and    $0x1,%eax
   42f7b:	48 85 c0             	test   %rax,%rax
   42f7e:	74 1b                	je     42f9b <virtual_memory_map+0x23d>
            // error, no allocated l1 page found for va
            log_printf("[Kern Info] failed to find l1pagetable address at " __FILE__ ": %d\n", __LINE__);
   42f80:	be 84 00 00 00       	mov    $0x84,%esi
   42f85:	bf f0 4e 04 00       	mov    $0x44ef0,%edi
   42f8a:	b8 00 00 00 00       	mov    $0x0,%eax
   42f8f:	e8 89 f7 ff ff       	call   4271d <log_printf>
            return -1;
   42f94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   42f99:	eb 28                	jmp    42fc3 <virtual_memory_map+0x265>
    for (; sz != 0; va += PAGESIZE, pa += PAGESIZE, sz -= PAGESIZE) {
   42f9b:	48 81 45 d0 00 10 00 	addq   $0x1000,-0x30(%rbp)
   42fa2:	00 
   42fa3:	48 81 45 c8 00 10 00 	addq   $0x1000,-0x38(%rbp)
   42faa:	00 
   42fab:	48 81 6d c0 00 10 00 	subq   $0x1000,-0x40(%rbp)
   42fb2:	00 
   42fb3:	48 83 7d c0 00       	cmpq   $0x0,-0x40(%rbp)
   42fb8:	0f 85 09 ff ff ff    	jne    42ec7 <virtual_memory_map+0x169>
        }
    }
    return 0;
   42fbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
   42fc3:	c9                   	leave
   42fc4:	c3                   	ret

0000000000042fc5 <lookup_l1pagetable>:
//
//    Returns an x86_64_pagetable pointer to the last level pagetable
//    if it exists and can be accessed with the given permissions
//    Returns NULL otherwise
static x86_64_pagetable* lookup_l1pagetable(x86_64_pagetable* pagetable,
                 uintptr_t va, int perm) {
   42fc5:	55                   	push   %rbp
   42fc6:	48 89 e5             	mov    %rsp,%rbp
   42fc9:	48 83 ec 40          	sub    $0x40,%rsp
   42fcd:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   42fd1:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
   42fd5:	89 55 cc             	mov    %edx,-0x34(%rbp)
    x86_64_pagetable* pt = pagetable;
   42fd8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   42fdc:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    // 1. Find index to the next pagetable entry using the `va`
    // 2. Check if this entry has the appropriate requested permissions
    // 3. Repeat the steps till you reach the l1 pagetable (i.e thrice)
    // 4. return the pagetable address

    for (int i = 0; i <= 2; ++i) {
   42fe0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
   42fe7:	e9 31 01 00 00       	jmp    4311d <lookup_l1pagetable+0x158>
        // find page entry by finding `ith` level index of va to index pagetable entries of `pt`
        // you should read x86-64.h to understand relevant structs and macros to make this part easier
        int index = PAGEINDEX(va, i);
   42fec:	8b 55 f4             	mov    -0xc(%rbp),%edx
   42fef:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   42ff3:	89 d6                	mov    %edx,%esi
   42ff5:	48 89 c7             	mov    %rax,%rdi
   42ff8:	e8 a3 fa ff ff       	call   42aa0 <pageindex>
   42ffd:	89 45 f0             	mov    %eax,-0x10(%rbp)
        x86_64_pageentry_t pe = pt->entry[index];
   43000:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43004:	8b 55 f0             	mov    -0x10(%rbp),%edx
   43007:	48 63 d2             	movslq %edx,%rdx
   4300a:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   4300e:	48 89 45 e8          	mov    %rax,-0x18(%rbp)

        if (!(pe & PTE_P)) { // address of next level should be present AND PTE_P should be set, error otherwise
   43012:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43016:	83 e0 01             	and    $0x1,%eax
   43019:	48 85 c0             	test   %rax,%rax
   4301c:	75 63                	jne    43081 <lookup_l1pagetable+0xbc>
            log_printf("[Kern Info] Error looking up l1pagetable: Pagetable address: 0x%x perm: 0x%x."
   4301e:	8b 45 f4             	mov    -0xc(%rbp),%eax
   43021:	8d 48 02             	lea    0x2(%rax),%ecx
   43024:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43028:	25 ff 0f 00 00       	and    $0xfff,%eax
   4302d:	48 89 c2             	mov    %rax,%rdx
   43030:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43034:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   4303a:	48 89 c6             	mov    %rax,%rsi
   4303d:	bf 38 4f 04 00       	mov    $0x44f38,%edi
   43042:	b8 00 00 00 00       	mov    $0x0,%eax
   43047:	e8 d1 f6 ff ff       	call   4271d <log_printf>
                    " Failed to get level (%d)\n",
                    PTE_ADDR(pe), PTE_FLAGS(pe), (i+2));
            if (!(perm & PTE_P)) {
   4304c:	8b 45 cc             	mov    -0x34(%rbp),%eax
   4304f:	48 98                	cltq
   43051:	83 e0 01             	and    $0x1,%eax
   43054:	48 85 c0             	test   %rax,%rax
   43057:	75 0a                	jne    43063 <lookup_l1pagetable+0x9e>
                return NULL;
   43059:	b8 00 00 00 00       	mov    $0x0,%eax
   4305e:	e9 c8 00 00 00       	jmp    4312b <lookup_l1pagetable+0x166>
            }
            log_printf("[Kern Info] failed to find pagetable address at " __FILE__ ": %d\n", __LINE__);
   43063:	be a8 00 00 00       	mov    $0xa8,%esi
   43068:	bf a0 4f 04 00       	mov    $0x44fa0,%edi
   4306d:	b8 00 00 00 00       	mov    $0x0,%eax
   43072:	e8 a6 f6 ff ff       	call   4271d <log_printf>
            return NULL;
   43077:	b8 00 00 00 00       	mov    $0x0,%eax
   4307c:	e9 aa 00 00 00       	jmp    4312b <lookup_l1pagetable+0x166>
        }

        // sanity-check page entry and permissions
        assert(PTE_ADDR(pe) < MEMSIZE_PHYSICAL); // at sensible address
   43081:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43085:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   4308b:	48 3d ff ff 1f 00    	cmp    $0x1fffff,%rax
   43091:	76 14                	jbe    430a7 <lookup_l1pagetable+0xe2>
   43093:	ba e8 4f 04 00       	mov    $0x44fe8,%edx
   43098:	be ad 00 00 00       	mov    $0xad,%esi
   4309d:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   430a2:	e8 94 f9 ff ff       	call   42a3b <assert_fail>
        if (perm & PTE_W) {       // if requester wants PTE_W,
   430a7:	8b 45 cc             	mov    -0x34(%rbp),%eax
   430aa:	48 98                	cltq
   430ac:	83 e0 02             	and    $0x2,%eax
   430af:	48 85 c0             	test   %rax,%rax
   430b2:	74 20                	je     430d4 <lookup_l1pagetable+0x10f>
            assert(pe & PTE_W);   //   entry must allow PTE_W
   430b4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   430b8:	83 e0 02             	and    $0x2,%eax
   430bb:	48 85 c0             	test   %rax,%rax
   430be:	75 14                	jne    430d4 <lookup_l1pagetable+0x10f>
   430c0:	ba 08 50 04 00       	mov    $0x45008,%edx
   430c5:	be af 00 00 00       	mov    $0xaf,%esi
   430ca:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   430cf:	e8 67 f9 ff ff       	call   42a3b <assert_fail>
        }
        if (perm & PTE_U) {       // if requester wants PTE_U,
   430d4:	8b 45 cc             	mov    -0x34(%rbp),%eax
   430d7:	48 98                	cltq
   430d9:	83 e0 04             	and    $0x4,%eax
   430dc:	48 85 c0             	test   %rax,%rax
   430df:	74 20                	je     43101 <lookup_l1pagetable+0x13c>
            assert(pe & PTE_U);   //   entry must allow PTE_U
   430e1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   430e5:	83 e0 04             	and    $0x4,%eax
   430e8:	48 85 c0             	test   %rax,%rax
   430eb:	75 14                	jne    43101 <lookup_l1pagetable+0x13c>
   430ed:	ba 13 50 04 00       	mov    $0x45013,%edx
   430f2:	be b2 00 00 00       	mov    $0xb2,%esi
   430f7:	bf 35 4c 04 00       	mov    $0x44c35,%edi
   430fc:	e8 3a f9 ff ff       	call   42a3b <assert_fail>
        }
        // set pt to physical address to next pagetable using `pe`
        pt = (x86_64_pagetable*) PTE_ADDR(pt->entry[index]);
   43101:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43105:	8b 55 f0             	mov    -0x10(%rbp),%edx
   43108:	48 63 d2             	movslq %edx,%rdx
   4310b:	48 8b 04 d0          	mov    (%rax,%rdx,8),%rax
   4310f:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   43115:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 2; ++i) {
   43119:	83 45 f4 01          	addl   $0x1,-0xc(%rbp)
   4311d:	83 7d f4 02          	cmpl   $0x2,-0xc(%rbp)
   43121:	0f 8e c5 fe ff ff    	jle    42fec <lookup_l1pagetable+0x27>
    }
    return pt;
   43127:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
   4312b:	c9                   	leave
   4312c:	c3                   	ret

000000000004312d <virtual_memory_lookup>:

// virtual_memory_lookup(pagetable, va)
//    Returns information about the mapping of the virtual address `va` in
//    `pagetable`. The information is returned as a `vamapping` object.

vamapping virtual_memory_lookup(x86_64_pagetable* pagetable, uintptr_t va) {
   4312d:	55                   	push   %rbp
   4312e:	48 89 e5             	mov    %rsp,%rbp
   43131:	48 83 ec 50          	sub    $0x50,%rsp
   43135:	48 89 7d c8          	mov    %rdi,-0x38(%rbp)
   43139:	48 89 75 c0          	mov    %rsi,-0x40(%rbp)
   4313d:	48 89 55 b8          	mov    %rdx,-0x48(%rbp)
    x86_64_pagetable* pt = pagetable;
   43141:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   43145:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    x86_64_pageentry_t pe = PTE_W | PTE_U | PTE_P;
   43149:	48 c7 45 f0 07 00 00 	movq   $0x7,-0x10(%rbp)
   43150:	00 
    for (int i = 0; i <= 3 && (pe & PTE_P); ++i) {
   43151:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
   43158:	eb 41                	jmp    4319b <virtual_memory_lookup+0x6e>
        pe = pt->entry[PAGEINDEX(va, i)] & ~(pe & (PTE_W | PTE_U));
   4315a:	8b 55 ec             	mov    -0x14(%rbp),%edx
   4315d:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   43161:	89 d6                	mov    %edx,%esi
   43163:	48 89 c7             	mov    %rax,%rdi
   43166:	e8 35 f9 ff ff       	call   42aa0 <pageindex>
   4316b:	89 c2                	mov    %eax,%edx
   4316d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43171:	48 63 d2             	movslq %edx,%rdx
   43174:	48 8b 14 d0          	mov    (%rax,%rdx,8),%rdx
   43178:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4317c:	83 e0 06             	and    $0x6,%eax
   4317f:	48 f7 d0             	not    %rax
   43182:	48 21 d0             	and    %rdx,%rax
   43185:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
        pt = (x86_64_pagetable*) PTE_ADDR(pe);
   43189:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4318d:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   43193:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (int i = 0; i <= 3 && (pe & PTE_P); ++i) {
   43197:	83 45 ec 01          	addl   $0x1,-0x14(%rbp)
   4319b:	83 7d ec 03          	cmpl   $0x3,-0x14(%rbp)
   4319f:	7f 0c                	jg     431ad <virtual_memory_lookup+0x80>
   431a1:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   431a5:	83 e0 01             	and    $0x1,%eax
   431a8:	48 85 c0             	test   %rax,%rax
   431ab:	75 ad                	jne    4315a <virtual_memory_lookup+0x2d>
    }
    vamapping vam = { -1, (uintptr_t) -1, 0 };
   431ad:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%rbp)
   431b4:	48 c7 45 d8 ff ff ff 	movq   $0xffffffffffffffff,-0x28(%rbp)
   431bb:	ff 
   431bc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%rbp)
    if (pe & PTE_P) {
   431c3:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   431c7:	83 e0 01             	and    $0x1,%eax
   431ca:	48 85 c0             	test   %rax,%rax
   431cd:	74 34                	je     43203 <virtual_memory_lookup+0xd6>
        vam.pn = PAGENUMBER(pe);
   431cf:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   431d3:	48 c1 e8 0c          	shr    $0xc,%rax
   431d7:	89 45 d0             	mov    %eax,-0x30(%rbp)
        vam.pa = PTE_ADDR(pe) + PAGEOFFSET(va);
   431da:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   431de:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
   431e4:	48 89 c2             	mov    %rax,%rdx
   431e7:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
   431eb:	25 ff 0f 00 00       	and    $0xfff,%eax
   431f0:	48 09 d0             	or     %rdx,%rax
   431f3:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
        vam.perm = PTE_FLAGS(pe);
   431f7:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   431fb:	25 ff 0f 00 00       	and    $0xfff,%eax
   43200:	89 45 e0             	mov    %eax,-0x20(%rbp)
    }
    return vam;
   43203:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   43207:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   4320b:	48 89 10             	mov    %rdx,(%rax)
   4320e:	48 8b 55 d8          	mov    -0x28(%rbp),%rdx
   43212:	48 89 50 08          	mov    %rdx,0x8(%rax)
   43216:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   4321a:	48 89 50 10          	mov    %rdx,0x10(%rax)
}
   4321e:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   43222:	c9                   	leave
   43223:	c3                   	ret

0000000000043224 <program_load>:
//    `assign_physical_page` to as required. Returns 0 on success and
//    -1 on failure (e.g. out-of-memory). `allocator` is passed to
//    `virtual_memory_map`.

int program_load(proc* p, int programnumber,
                 x86_64_pagetable* (*allocator)(void)) {
   43224:	55                   	push   %rbp
   43225:	48 89 e5             	mov    %rsp,%rbp
   43228:	48 83 ec 40          	sub    $0x40,%rsp
   4322c:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   43230:	89 75 d4             	mov    %esi,-0x2c(%rbp)
   43233:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
    // is this a valid program?
    int nprograms = sizeof(ramimages) / sizeof(ramimages[0]);
   43237:	c7 45 f8 07 00 00 00 	movl   $0x7,-0x8(%rbp)
    assert(programnumber >= 0 && programnumber < nprograms);
   4323e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
   43242:	78 08                	js     4324c <program_load+0x28>
   43244:	8b 45 d4             	mov    -0x2c(%rbp),%eax
   43247:	3b 45 f8             	cmp    -0x8(%rbp),%eax
   4324a:	7c 14                	jl     43260 <program_load+0x3c>
   4324c:	ba 20 50 04 00       	mov    $0x45020,%edx
   43251:	be 39 00 00 00       	mov    $0x39,%esi
   43256:	bf 50 50 04 00       	mov    $0x45050,%edi
   4325b:	e8 db f7 ff ff       	call   42a3b <assert_fail>
    elf_header* eh = (elf_header*) ramimages[programnumber].begin;
   43260:	8b 45 d4             	mov    -0x2c(%rbp),%eax
   43263:	48 98                	cltq
   43265:	48 c1 e0 04          	shl    $0x4,%rax
   43269:	48 05 20 60 04 00    	add    $0x46020,%rax
   4326f:	48 8b 00             	mov    (%rax),%rax
   43272:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    assert(eh->e_magic == ELF_MAGIC);
   43276:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4327a:	8b 00                	mov    (%rax),%eax
   4327c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
   43281:	74 14                	je     43297 <program_load+0x73>
   43283:	ba 62 50 04 00       	mov    $0x45062,%edx
   43288:	be 3b 00 00 00       	mov    $0x3b,%esi
   4328d:	bf 50 50 04 00       	mov    $0x45050,%edi
   43292:	e8 a4 f7 ff ff       	call   42a3b <assert_fail>

    // load each loadable program segment into memory
    elf_program* ph = (elf_program*) ((const uint8_t*) eh + eh->e_phoff);
   43297:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4329b:	48 8b 50 20          	mov    0x20(%rax),%rdx
   4329f:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   432a3:	48 01 d0             	add    %rdx,%rax
   432a6:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    for (int i = 0; i < eh->e_phnum; ++i) {
   432aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   432b1:	e9 94 00 00 00       	jmp    4334a <program_load+0x126>
        if (ph[i].p_type == ELF_PTYPE_LOAD) {
   432b6:	8b 45 fc             	mov    -0x4(%rbp),%eax
   432b9:	48 63 d0             	movslq %eax,%rdx
   432bc:	48 89 d0             	mov    %rdx,%rax
   432bf:	48 c1 e0 03          	shl    $0x3,%rax
   432c3:	48 29 d0             	sub    %rdx,%rax
   432c6:	48 c1 e0 03          	shl    $0x3,%rax
   432ca:	48 89 c2             	mov    %rax,%rdx
   432cd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   432d1:	48 01 d0             	add    %rdx,%rax
   432d4:	8b 00                	mov    (%rax),%eax
   432d6:	83 f8 01             	cmp    $0x1,%eax
   432d9:	75 6b                	jne    43346 <program_load+0x122>
            const uint8_t* pdata = (const uint8_t*) eh + ph[i].p_offset;
   432db:	8b 45 fc             	mov    -0x4(%rbp),%eax
   432de:	48 63 d0             	movslq %eax,%rdx
   432e1:	48 89 d0             	mov    %rdx,%rax
   432e4:	48 c1 e0 03          	shl    $0x3,%rax
   432e8:	48 29 d0             	sub    %rdx,%rax
   432eb:	48 c1 e0 03          	shl    $0x3,%rax
   432ef:	48 89 c2             	mov    %rax,%rdx
   432f2:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   432f6:	48 01 d0             	add    %rdx,%rax
   432f9:	48 8b 50 08          	mov    0x8(%rax),%rdx
   432fd:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43301:	48 01 d0             	add    %rdx,%rax
   43304:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
            if (program_load_segment(p, &ph[i], pdata, allocator) < 0) {
   43308:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4330b:	48 63 d0             	movslq %eax,%rdx
   4330e:	48 89 d0             	mov    %rdx,%rax
   43311:	48 c1 e0 03          	shl    $0x3,%rax
   43315:	48 29 d0             	sub    %rdx,%rax
   43318:	48 c1 e0 03          	shl    $0x3,%rax
   4331c:	48 89 c2             	mov    %rax,%rdx
   4331f:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43323:	48 8d 34 02          	lea    (%rdx,%rax,1),%rsi
   43327:	48 8b 4d c8          	mov    -0x38(%rbp),%rcx
   4332b:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   4332f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43333:	48 89 c7             	mov    %rax,%rdi
   43336:	e8 3d 00 00 00       	call   43378 <program_load_segment>
   4333b:	85 c0                	test   %eax,%eax
   4333d:	79 07                	jns    43346 <program_load+0x122>
                return -1;
   4333f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   43344:	eb 30                	jmp    43376 <program_load+0x152>
    for (int i = 0; i < eh->e_phnum; ++i) {
   43346:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   4334a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4334e:	0f b7 40 38          	movzwl 0x38(%rax),%eax
   43352:	0f b7 c0             	movzwl %ax,%eax
   43355:	39 45 fc             	cmp    %eax,-0x4(%rbp)
   43358:	0f 8c 58 ff ff ff    	jl     432b6 <program_load+0x92>
            }
        }
    }

    // set the entry point from the ELF header
    p->p_registers.reg_rip = eh->e_entry;
   4335e:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43362:	48 8b 50 18          	mov    0x18(%rax),%rdx
   43366:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   4336a:	48 89 90 a0 00 00 00 	mov    %rdx,0xa0(%rax)
    return 0;
   43371:	b8 00 00 00 00       	mov    $0x0,%eax
}
   43376:	c9                   	leave
   43377:	c3                   	ret

0000000000043378 <program_load_segment>:
//    Calls `assign_physical_page` to allocate pages and `virtual_memory_map`
//    to map them in `p->p_pagetable`. Returns 0 on success and -1 on failure.

static int program_load_segment(proc* p, const elf_program* ph,
                                const uint8_t* src,
                                x86_64_pagetable* (*allocator)(void)) {
   43378:	55                   	push   %rbp
   43379:	48 89 e5             	mov    %rsp,%rbp
   4337c:	48 83 ec 70          	sub    $0x70,%rsp
   43380:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   43384:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
   43388:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
   4338c:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    uintptr_t va = (uintptr_t) ph->p_va;
   43390:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   43394:	48 8b 40 10          	mov    0x10(%rax),%rax
   43398:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
    uintptr_t end_file = va + ph->p_filesz, end_mem = va + ph->p_memsz;
   4339c:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   433a0:	48 8b 50 20          	mov    0x20(%rax),%rdx
   433a4:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   433a8:	48 01 d0             	add    %rdx,%rax
   433ab:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
   433af:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   433b3:	48 8b 50 28          	mov    0x28(%rax),%rdx
   433b7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   433bb:	48 01 d0             	add    %rdx,%rax
   433be:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
    va &= ~(PAGESIZE - 1);                // round to page boundary
   433c2:	48 81 65 e8 00 f0 ff 	andq   $0xfffffffffffff000,-0x18(%rbp)
   433c9:	ff 

    // allocate memory
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   433ca:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   433ce:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   433d2:	eb 7c                	jmp    43450 <program_load_segment+0xd8>
        uintptr_t page = allocatePhysicalPage(p->p_pid);
   433d4:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   433d8:	8b 00                	mov    (%rax),%eax
   433da:	89 c7                	mov    %eax,%edi
   433dc:	e8 56 cf ff ff       	call   40337 <allocatePhysicalPage>
   433e1:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
        if ((uintptr_t) page == (uintptr_t) -1
   433e5:	48 83 7d d0 ff       	cmpq   $0xffffffffffffffff,-0x30(%rbp)
   433ea:	74 2a                	je     43416 <program_load_segment+0x9e>
            || virtual_memory_map(p->p_pagetable, addr, page, PAGESIZE,
   433ec:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   433f0:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   433f7:	48 8b 55 d0          	mov    -0x30(%rbp),%rdx
   433fb:	48 8b 75 f8          	mov    -0x8(%rbp),%rsi
   433ff:	41 b8 07 00 00 00    	mov    $0x7,%r8d
   43405:	b9 00 10 00 00       	mov    $0x1000,%ecx
   4340a:	48 89 c7             	mov    %rax,%rdi
   4340d:	e8 4c f9 ff ff       	call   42d5e <virtual_memory_map>
   43412:	85 c0                	test   %eax,%eax
   43414:	79 32                	jns    43448 <program_load_segment+0xd0>
                                  PTE_P | PTE_W | PTE_U) < 0) {
            console_printf(CPOS(22, 0), 0xC000, "program_load_segment(pid %d): can't assign address %p\n", p->p_pid, addr);
   43416:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   4341a:	8b 00                	mov    (%rax),%eax
   4341c:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   43420:	49 89 d0             	mov    %rdx,%r8
   43423:	89 c1                	mov    %eax,%ecx
   43425:	ba 80 50 04 00       	mov    $0x45080,%edx
   4342a:	be 00 c0 00 00       	mov    $0xc000,%esi
   4342f:	bf e0 06 00 00       	mov    $0x6e0,%edi
   43434:	b8 00 00 00 00       	mov    $0x0,%eax
   43439:	e8 e1 0f 00 00       	call   4441f <console_printf>
            return -1;
   4343e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   43443:	e9 20 01 00 00       	jmp    43568 <program_load_segment+0x1f0>
    for (uintptr_t addr = va; addr < end_mem; addr += PAGESIZE) {
   43448:	48 81 45 f8 00 10 00 	addq   $0x1000,-0x8(%rbp)
   4344f:	00 
   43450:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43454:	48 3b 45 d8          	cmp    -0x28(%rbp),%rax
   43458:	0f 82 76 ff ff ff    	jb     433d4 <program_load_segment+0x5c>
        }
    }

    // ensure new memory mappings are active
    set_pagetable(p->p_pagetable);
   4345e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   43462:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   43469:	48 89 c7             	mov    %rax,%rdi
   4346c:	e8 bc f7 ff ff       	call   42c2d <set_pagetable>

    // copy data from executable image into process memory
    memcpy((uint8_t*) va, src, end_file - va);
   43471:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43475:	48 2b 45 e8          	sub    -0x18(%rbp),%rax
   43479:	48 89 c2             	mov    %rax,%rdx
   4347c:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   43480:	48 8b 4d 98          	mov    -0x68(%rbp),%rcx
   43484:	48 89 ce             	mov    %rcx,%rsi
   43487:	48 89 c7             	mov    %rax,%rdi
   4348a:	e8 db 00 00 00       	call   4356a <memcpy>
    memset((uint8_t*) end_file, 0, end_mem - end_file);
   4348f:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43493:	48 2b 45 e0          	sub    -0x20(%rbp),%rax
   43497:	48 89 c2             	mov    %rax,%rdx
   4349a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   4349e:	be 00 00 00 00       	mov    $0x0,%esi
   434a3:	48 89 c7             	mov    %rax,%rdi
   434a6:	e8 bd 01 00 00       	call   43668 <memset>

    if ((ph->p_flags & ELF_PFLAG_WRITE) == 0) {
   434ab:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
   434af:	8b 40 04             	mov    0x4(%rax),%eax
   434b2:	83 e0 02             	and    $0x2,%eax
   434b5:	85 c0                	test   %eax,%eax
   434b7:	0f 85 97 00 00 00    	jne    43554 <program_load_segment+0x1dc>
        for (uintptr_t addr = va; addr < end_file; addr += PAGESIZE) {
   434bd:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   434c1:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   434c5:	eb 7f                	jmp    43546 <program_load_segment+0x1ce>
            vamapping vmap = virtual_memory_lookup(p->p_pagetable, addr);
   434c7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   434cb:	48 8b 88 d0 00 00 00 	mov    0xd0(%rax),%rcx
   434d2:	48 8d 45 b8          	lea    -0x48(%rbp),%rax
   434d6:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   434da:	48 89 ce             	mov    %rcx,%rsi
   434dd:	48 89 c7             	mov    %rax,%rdi
   434e0:	e8 48 fc ff ff       	call   4312d <virtual_memory_lookup>
            if (virtual_memory_map(p->p_pagetable, addr, vmap.pa, PAGESIZE, PTE_P | PTE_U) < 0) {
   434e5:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
   434e9:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   434ed:	48 8b 80 d0 00 00 00 	mov    0xd0(%rax),%rax
   434f4:	48 8b 75 f0          	mov    -0x10(%rbp),%rsi
   434f8:	41 b8 05 00 00 00    	mov    $0x5,%r8d
   434fe:	b9 00 10 00 00       	mov    $0x1000,%ecx
   43503:	48 89 c7             	mov    %rax,%rdi
   43506:	e8 53 f8 ff ff       	call   42d5e <virtual_memory_map>
   4350b:	85 c0                	test   %eax,%eax
   4350d:	79 2f                	jns    4353e <program_load_segment+0x1c6>
                console_printf(CPOS(22, 0), 0xC000, "program_load_segment(pid %d): can't assign address %p\n", p->p_pid, addr);
   4350f:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   43513:	8b 00                	mov    (%rax),%eax
   43515:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   43519:	49 89 d0             	mov    %rdx,%r8
   4351c:	89 c1                	mov    %eax,%ecx
   4351e:	ba 80 50 04 00       	mov    $0x45080,%edx
   43523:	be 00 c0 00 00       	mov    $0xc000,%esi
   43528:	bf e0 06 00 00       	mov    $0x6e0,%edi
   4352d:	b8 00 00 00 00       	mov    $0x0,%eax
   43532:	e8 e8 0e 00 00       	call   4441f <console_printf>
                return -1;
   43537:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
   4353c:	eb 2a                	jmp    43568 <program_load_segment+0x1f0>
        for (uintptr_t addr = va; addr < end_file; addr += PAGESIZE) {
   4353e:	48 81 45 f0 00 10 00 	addq   $0x1000,-0x10(%rbp)
   43545:	00 
   43546:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4354a:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
   4354e:	0f 82 73 ff ff ff    	jb     434c7 <program_load_segment+0x14f>
            }
        }
    }

    // restore kernel pagetable
    set_pagetable(kernel_pagetable);
   43554:	48 8b 05 a5 1a 01 00 	mov    0x11aa5(%rip),%rax        # 55000 <kernel_pagetable>
   4355b:	48 89 c7             	mov    %rax,%rdi
   4355e:	e8 ca f6 ff ff       	call   42c2d <set_pagetable>
    return 0;
   43563:	b8 00 00 00 00       	mov    $0x0,%eax
}
   43568:	c9                   	leave
   43569:	c3                   	ret

000000000004356a <memcpy>:


// memcpy, memmove, memset, strcmp, strlen, strnlen
//    We must provide our own implementations.

void* memcpy(void* dst, const void* src, size_t n) {
   4356a:	55                   	push   %rbp
   4356b:	48 89 e5             	mov    %rsp,%rbp
   4356e:	48 83 ec 28          	sub    $0x28,%rsp
   43572:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   43576:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
   4357a:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
   4357e:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   43582:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
   43586:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4358a:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
   4358e:	eb 1c                	jmp    435ac <memcpy+0x42>
        *d = *s;
   43590:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43594:	0f b6 10             	movzbl (%rax),%edx
   43597:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4359b:	88 10                	mov    %dl,(%rax)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
   4359d:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
   435a2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
   435a7:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
   435ac:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   435b1:	75 dd                	jne    43590 <memcpy+0x26>
    }
    return dst;
   435b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
   435b7:	c9                   	leave
   435b8:	c3                   	ret

00000000000435b9 <memmove>:

void* memmove(void* dst, const void* src, size_t n) {
   435b9:	55                   	push   %rbp
   435ba:	48 89 e5             	mov    %rsp,%rbp
   435bd:	48 83 ec 28          	sub    $0x28,%rsp
   435c1:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   435c5:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
   435c9:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    const char* s = (const char*) src;
   435cd:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   435d1:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    char* d = (char*) dst;
   435d5:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   435d9:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (s < d && s + n > d) {
   435dd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   435e1:	48 3b 45 f0          	cmp    -0x10(%rbp),%rax
   435e5:	73 6a                	jae    43651 <memmove+0x98>
   435e7:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   435eb:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   435ef:	48 01 d0             	add    %rdx,%rax
   435f2:	48 39 45 f0          	cmp    %rax,-0x10(%rbp)
   435f6:	73 59                	jae    43651 <memmove+0x98>
        s += n, d += n;
   435f8:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   435fc:	48 01 45 f8          	add    %rax,-0x8(%rbp)
   43600:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43604:	48 01 45 f0          	add    %rax,-0x10(%rbp)
        while (n-- > 0) {
   43608:	eb 17                	jmp    43621 <memmove+0x68>
            *--d = *--s;
   4360a:	48 83 6d f8 01       	subq   $0x1,-0x8(%rbp)
   4360f:	48 83 6d f0 01       	subq   $0x1,-0x10(%rbp)
   43614:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43618:	0f b6 10             	movzbl (%rax),%edx
   4361b:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4361f:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
   43621:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43625:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
   43629:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
   4362d:	48 85 c0             	test   %rax,%rax
   43630:	75 d8                	jne    4360a <memmove+0x51>
    if (s < d && s + n > d) {
   43632:	eb 2e                	jmp    43662 <memmove+0xa9>
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
   43634:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   43638:	48 8d 42 01          	lea    0x1(%rdx),%rax
   4363c:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   43640:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   43644:	48 8d 48 01          	lea    0x1(%rax),%rcx
   43648:	48 89 4d f0          	mov    %rcx,-0x10(%rbp)
   4364c:	0f b6 12             	movzbl (%rdx),%edx
   4364f:	88 10                	mov    %dl,(%rax)
        while (n-- > 0) {
   43651:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   43655:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
   43659:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
   4365d:	48 85 c0             	test   %rax,%rax
   43660:	75 d2                	jne    43634 <memmove+0x7b>
        }
    }
    return dst;
   43662:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
   43666:	c9                   	leave
   43667:	c3                   	ret

0000000000043668 <memset>:

void* memset(void* v, int c, size_t n) {
   43668:	55                   	push   %rbp
   43669:	48 89 e5             	mov    %rsp,%rbp
   4366c:	48 83 ec 28          	sub    $0x28,%rsp
   43670:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   43674:	89 75 e4             	mov    %esi,-0x1c(%rbp)
   43677:	48 89 55 d8          	mov    %rdx,-0x28(%rbp)
    for (char* p = (char*) v; n > 0; ++p, --n) {
   4367b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4367f:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
   43683:	eb 15                	jmp    4369a <memset+0x32>
        *p = c;
   43685:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   43688:	89 c2                	mov    %eax,%edx
   4368a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4368e:	88 10                	mov    %dl,(%rax)
    for (char* p = (char*) v; n > 0; ++p, --n) {
   43690:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
   43695:	48 83 6d d8 01       	subq   $0x1,-0x28(%rbp)
   4369a:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   4369f:	75 e4                	jne    43685 <memset+0x1d>
    }
    return v;
   436a1:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
   436a5:	c9                   	leave
   436a6:	c3                   	ret

00000000000436a7 <strlen>:

size_t strlen(const char* s) {
   436a7:	55                   	push   %rbp
   436a8:	48 89 e5             	mov    %rsp,%rbp
   436ab:	48 83 ec 18          	sub    $0x18,%rsp
   436af:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
   436b3:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   436ba:	00 
   436bb:	eb 0a                	jmp    436c7 <strlen+0x20>
        ++n;
   436bd:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; *s != '\0'; ++s) {
   436c2:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
   436c7:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   436cb:	0f b6 00             	movzbl (%rax),%eax
   436ce:	84 c0                	test   %al,%al
   436d0:	75 eb                	jne    436bd <strlen+0x16>
    }
    return n;
   436d2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
   436d6:	c9                   	leave
   436d7:	c3                   	ret

00000000000436d8 <strnlen>:

size_t strnlen(const char* s, size_t maxlen) {
   436d8:	55                   	push   %rbp
   436d9:	48 89 e5             	mov    %rsp,%rbp
   436dc:	48 83 ec 20          	sub    $0x20,%rsp
   436e0:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   436e4:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    size_t n;
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
   436e8:	48 c7 45 f8 00 00 00 	movq   $0x0,-0x8(%rbp)
   436ef:	00 
   436f0:	eb 0a                	jmp    436fc <strnlen+0x24>
        ++n;
   436f2:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
   436f7:	48 83 45 e8 01       	addq   $0x1,-0x18(%rbp)
   436fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43700:	48 3b 45 e0          	cmp    -0x20(%rbp),%rax
   43704:	74 0b                	je     43711 <strnlen+0x39>
   43706:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4370a:	0f b6 00             	movzbl (%rax),%eax
   4370d:	84 c0                	test   %al,%al
   4370f:	75 e1                	jne    436f2 <strnlen+0x1a>
    }
    return n;
   43711:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
}
   43715:	c9                   	leave
   43716:	c3                   	ret

0000000000043717 <strcpy>:

char* strcpy(char* dst, const char* src) {
   43717:	55                   	push   %rbp
   43718:	48 89 e5             	mov    %rsp,%rbp
   4371b:	48 83 ec 20          	sub    $0x20,%rsp
   4371f:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   43723:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
    char* d = dst;
   43727:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   4372b:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    do {
        *d++ = *src++;
   4372f:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   43733:	48 8d 42 01          	lea    0x1(%rdx),%rax
   43737:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
   4373b:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4373f:	48 8d 48 01          	lea    0x1(%rax),%rcx
   43743:	48 89 4d f8          	mov    %rcx,-0x8(%rbp)
   43747:	0f b6 12             	movzbl (%rdx),%edx
   4374a:	88 10                	mov    %dl,(%rax)
    } while (d[-1]);
   4374c:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43750:	48 83 e8 01          	sub    $0x1,%rax
   43754:	0f b6 00             	movzbl (%rax),%eax
   43757:	84 c0                	test   %al,%al
   43759:	75 d4                	jne    4372f <strcpy+0x18>
    return dst;
   4375b:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
   4375f:	c9                   	leave
   43760:	c3                   	ret

0000000000043761 <strcmp>:

int strcmp(const char* a, const char* b) {
   43761:	55                   	push   %rbp
   43762:	48 89 e5             	mov    %rsp,%rbp
   43765:	48 83 ec 10          	sub    $0x10,%rsp
   43769:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   4376d:	48 89 75 f0          	mov    %rsi,-0x10(%rbp)
    while (*a && *b && *a == *b) {
   43771:	eb 0a                	jmp    4377d <strcmp+0x1c>
        ++a, ++b;
   43773:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
   43778:	48 83 45 f0 01       	addq   $0x1,-0x10(%rbp)
    while (*a && *b && *a == *b) {
   4377d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43781:	0f b6 00             	movzbl (%rax),%eax
   43784:	84 c0                	test   %al,%al
   43786:	74 1d                	je     437a5 <strcmp+0x44>
   43788:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4378c:	0f b6 00             	movzbl (%rax),%eax
   4378f:	84 c0                	test   %al,%al
   43791:	74 12                	je     437a5 <strcmp+0x44>
   43793:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43797:	0f b6 10             	movzbl (%rax),%edx
   4379a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4379e:	0f b6 00             	movzbl (%rax),%eax
   437a1:	38 c2                	cmp    %al,%dl
   437a3:	74 ce                	je     43773 <strcmp+0x12>
    }
    return ((unsigned char) *a > (unsigned char) *b)
   437a5:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   437a9:	0f b6 00             	movzbl (%rax),%eax
   437ac:	89 c2                	mov    %eax,%edx
   437ae:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   437b2:	0f b6 00             	movzbl (%rax),%eax
   437b5:	38 d0                	cmp    %dl,%al
   437b7:	0f 92 c0             	setb   %al
   437ba:	0f b6 d0             	movzbl %al,%edx
        - ((unsigned char) *a < (unsigned char) *b);
   437bd:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   437c1:	0f b6 00             	movzbl (%rax),%eax
   437c4:	89 c1                	mov    %eax,%ecx
   437c6:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   437ca:	0f b6 00             	movzbl (%rax),%eax
   437cd:	38 c1                	cmp    %al,%cl
   437cf:	0f 92 c0             	setb   %al
   437d2:	0f b6 c0             	movzbl %al,%eax
   437d5:	29 c2                	sub    %eax,%edx
   437d7:	89 d0                	mov    %edx,%eax
}
   437d9:	c9                   	leave
   437da:	c3                   	ret

00000000000437db <strchr>:

char* strchr(const char* s, int c) {
   437db:	55                   	push   %rbp
   437dc:	48 89 e5             	mov    %rsp,%rbp
   437df:	48 83 ec 10          	sub    $0x10,%rsp
   437e3:	48 89 7d f8          	mov    %rdi,-0x8(%rbp)
   437e7:	89 75 f4             	mov    %esi,-0xc(%rbp)
    while (*s && *s != (char) c) {
   437ea:	eb 05                	jmp    437f1 <strchr+0x16>
        ++s;
   437ec:	48 83 45 f8 01       	addq   $0x1,-0x8(%rbp)
    while (*s && *s != (char) c) {
   437f1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   437f5:	0f b6 00             	movzbl (%rax),%eax
   437f8:	84 c0                	test   %al,%al
   437fa:	74 0e                	je     4380a <strchr+0x2f>
   437fc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   43800:	0f b6 00             	movzbl (%rax),%eax
   43803:	8b 55 f4             	mov    -0xc(%rbp),%edx
   43806:	38 d0                	cmp    %dl,%al
   43808:	75 e2                	jne    437ec <strchr+0x11>
    }
    if (*s == (char) c) {
   4380a:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4380e:	0f b6 00             	movzbl (%rax),%eax
   43811:	8b 55 f4             	mov    -0xc(%rbp),%edx
   43814:	38 d0                	cmp    %dl,%al
   43816:	75 06                	jne    4381e <strchr+0x43>
        return (char*) s;
   43818:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   4381c:	eb 05                	jmp    43823 <strchr+0x48>
    } else {
        return NULL;
   4381e:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
   43823:	c9                   	leave
   43824:	c3                   	ret

0000000000043825 <rand>:
// rand, srand

static int rand_seed_set;
static unsigned rand_seed;

int rand(void) {
   43825:	55                   	push   %rbp
   43826:	48 89 e5             	mov    %rsp,%rbp
    if (!rand_seed_set) {
   43829:	8b 05 d1 77 01 00    	mov    0x177d1(%rip),%eax        # 5b000 <rand_seed_set>
   4382f:	85 c0                	test   %eax,%eax
   43831:	75 0a                	jne    4383d <rand+0x18>
        srand(819234718U);
   43833:	bf 9e 87 d4 30       	mov    $0x30d4879e,%edi
   43838:	e8 24 00 00 00       	call   43861 <srand>
    }
    rand_seed = rand_seed * 1664525U + 1013904223U;
   4383d:	8b 05 c1 77 01 00    	mov    0x177c1(%rip),%eax        # 5b004 <rand_seed>
   43843:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
   43849:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
   4384e:	89 05 b0 77 01 00    	mov    %eax,0x177b0(%rip)        # 5b004 <rand_seed>
    return rand_seed & RAND_MAX;
   43854:	8b 05 aa 77 01 00    	mov    0x177aa(%rip),%eax        # 5b004 <rand_seed>
   4385a:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
   4385f:	5d                   	pop    %rbp
   43860:	c3                   	ret

0000000000043861 <srand>:

void srand(unsigned seed) {
   43861:	55                   	push   %rbp
   43862:	48 89 e5             	mov    %rsp,%rbp
   43865:	48 83 ec 08          	sub    $0x8,%rsp
   43869:	89 7d fc             	mov    %edi,-0x4(%rbp)
    rand_seed = seed;
   4386c:	8b 45 fc             	mov    -0x4(%rbp),%eax
   4386f:	89 05 8f 77 01 00    	mov    %eax,0x1778f(%rip)        # 5b004 <rand_seed>
    rand_seed_set = 1;
   43875:	c7 05 81 77 01 00 01 	movl   $0x1,0x17781(%rip)        # 5b000 <rand_seed_set>
   4387c:	00 00 00 
}
   4387f:	90                   	nop
   43880:	c9                   	leave
   43881:	c3                   	ret

0000000000043882 <fill_numbuf>:
//    Print a message onto the console, starting at the given cursor position.

// snprintf, vsnprintf
//    Format a string into a buffer.

static char* fill_numbuf(char* numbuf_end, unsigned long val, int base) {
   43882:	55                   	push   %rbp
   43883:	48 89 e5             	mov    %rsp,%rbp
   43886:	48 83 ec 28          	sub    $0x28,%rsp
   4388a:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   4388e:	48 89 75 e0          	mov    %rsi,-0x20(%rbp)
   43892:	89 55 dc             	mov    %edx,-0x24(%rbp)
    static const char upper_digits[] = "0123456789ABCDEF";
    static const char lower_digits[] = "0123456789abcdef";

    const char* digits = upper_digits;
   43895:	48 c7 45 f8 a0 52 04 	movq   $0x452a0,-0x8(%rbp)
   4389c:	00 
    if (base < 0) {
   4389d:	83 7d dc 00          	cmpl   $0x0,-0x24(%rbp)
   438a1:	79 0b                	jns    438ae <fill_numbuf+0x2c>
        digits = lower_digits;
   438a3:	48 c7 45 f8 c0 52 04 	movq   $0x452c0,-0x8(%rbp)
   438aa:	00 
        base = -base;
   438ab:	f7 5d dc             	negl   -0x24(%rbp)
    }

    *--numbuf_end = '\0';
   438ae:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
   438b3:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   438b7:	c6 00 00             	movb   $0x0,(%rax)
    do {
        *--numbuf_end = digits[val % base];
   438ba:	8b 45 dc             	mov    -0x24(%rbp),%eax
   438bd:	48 63 c8             	movslq %eax,%rcx
   438c0:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   438c4:	ba 00 00 00 00       	mov    $0x0,%edx
   438c9:	48 f7 f1             	div    %rcx
   438cc:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   438d0:	48 01 d0             	add    %rdx,%rax
   438d3:	48 83 6d e8 01       	subq   $0x1,-0x18(%rbp)
   438d8:	0f b6 10             	movzbl (%rax),%edx
   438db:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   438df:	88 10                	mov    %dl,(%rax)
        val /= base;
   438e1:	8b 45 dc             	mov    -0x24(%rbp),%eax
   438e4:	48 63 f0             	movslq %eax,%rsi
   438e7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
   438eb:	ba 00 00 00 00       	mov    $0x0,%edx
   438f0:	48 f7 f6             	div    %rsi
   438f3:	48 89 45 e0          	mov    %rax,-0x20(%rbp)
    } while (val != 0);
   438f7:	48 83 7d e0 00       	cmpq   $0x0,-0x20(%rbp)
   438fc:	75 bc                	jne    438ba <fill_numbuf+0x38>
    return numbuf_end;
   438fe:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
}
   43902:	c9                   	leave
   43903:	c3                   	ret

0000000000043904 <printer_vprintf>:
#define FLAG_NUMERIC            (1<<5)
#define FLAG_SIGNED             (1<<6)
#define FLAG_NEGATIVE           (1<<7)
#define FLAG_ALT2               (1<<8)

void printer_vprintf(printer* p, int color, const char* format, va_list val) {
   43904:	55                   	push   %rbp
   43905:	48 89 e5             	mov    %rsp,%rbp
   43908:	53                   	push   %rbx
   43909:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
   43910:	48 89 bd 78 ff ff ff 	mov    %rdi,-0x88(%rbp)
   43917:	89 b5 74 ff ff ff    	mov    %esi,-0x8c(%rbp)
   4391d:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
   43924:	48 89 8d 60 ff ff ff 	mov    %rcx,-0xa0(%rbp)
#define NUMBUFSIZ 24
    char numbuf[NUMBUFSIZ];

    for (; *format; ++format) {
   4392b:	e9 8a 09 00 00       	jmp    442ba <printer_vprintf+0x9b6>
        if (*format != '%') {
   43930:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43937:	0f b6 00             	movzbl (%rax),%eax
   4393a:	3c 25                	cmp    $0x25,%al
   4393c:	74 31                	je     4396f <printer_vprintf+0x6b>
            p->putc(p, *format, color);
   4393e:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   43945:	4c 8b 00             	mov    (%rax),%r8
   43948:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   4394f:	0f b6 00             	movzbl (%rax),%eax
   43952:	0f b6 c8             	movzbl %al,%ecx
   43955:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
   4395b:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   43962:	89 ce                	mov    %ecx,%esi
   43964:	48 89 c7             	mov    %rax,%rdi
   43967:	41 ff d0             	call   *%r8
            continue;
   4396a:	e9 43 09 00 00       	jmp    442b2 <printer_vprintf+0x9ae>
        }

        // process flags
        int flags = 0;
   4396f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
        for (++format; *format; ++format) {
   43976:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   4397d:	01 
   4397e:	eb 44                	jmp    439c4 <printer_vprintf+0xc0>
            const char* flagc = strchr(flag_chars, *format);
   43980:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43987:	0f b6 00             	movzbl (%rax),%eax
   4398a:	0f be c0             	movsbl %al,%eax
   4398d:	89 c6                	mov    %eax,%esi
   4398f:	bf c0 50 04 00       	mov    $0x450c0,%edi
   43994:	e8 42 fe ff ff       	call   437db <strchr>
   43999:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
            if (flagc) {
   4399d:	48 83 7d b0 00       	cmpq   $0x0,-0x50(%rbp)
   439a2:	74 30                	je     439d4 <printer_vprintf+0xd0>
                flags |= 1 << (flagc - flag_chars);
   439a4:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
   439a8:	48 2d c0 50 04 00    	sub    $0x450c0,%rax
   439ae:	ba 01 00 00 00       	mov    $0x1,%edx
   439b3:	89 c1                	mov    %eax,%ecx
   439b5:	d3 e2                	shl    %cl,%edx
   439b7:	89 d0                	mov    %edx,%eax
   439b9:	09 45 ec             	or     %eax,-0x14(%rbp)
        for (++format; *format; ++format) {
   439bc:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   439c3:	01 
   439c4:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   439cb:	0f b6 00             	movzbl (%rax),%eax
   439ce:	84 c0                	test   %al,%al
   439d0:	75 ae                	jne    43980 <printer_vprintf+0x7c>
   439d2:	eb 01                	jmp    439d5 <printer_vprintf+0xd1>
            } else {
                break;
   439d4:	90                   	nop
            }
        }

        // process width
        int width = -1;
   439d5:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%rbp)
        if (*format >= '1' && *format <= '9') {
   439dc:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   439e3:	0f b6 00             	movzbl (%rax),%eax
   439e6:	3c 30                	cmp    $0x30,%al
   439e8:	7e 67                	jle    43a51 <printer_vprintf+0x14d>
   439ea:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   439f1:	0f b6 00             	movzbl (%rax),%eax
   439f4:	3c 39                	cmp    $0x39,%al
   439f6:	7f 59                	jg     43a51 <printer_vprintf+0x14d>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   439f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
   439ff:	eb 2e                	jmp    43a2f <printer_vprintf+0x12b>
                width = 10 * width + *format++ - '0';
   43a01:	8b 55 e8             	mov    -0x18(%rbp),%edx
   43a04:	89 d0                	mov    %edx,%eax
   43a06:	c1 e0 02             	shl    $0x2,%eax
   43a09:	01 d0                	add    %edx,%eax
   43a0b:	01 c0                	add    %eax,%eax
   43a0d:	89 c1                	mov    %eax,%ecx
   43a0f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43a16:	48 8d 50 01          	lea    0x1(%rax),%rdx
   43a1a:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
   43a21:	0f b6 00             	movzbl (%rax),%eax
   43a24:	0f be c0             	movsbl %al,%eax
   43a27:	01 c8                	add    %ecx,%eax
   43a29:	83 e8 30             	sub    $0x30,%eax
   43a2c:	89 45 e8             	mov    %eax,-0x18(%rbp)
            for (width = 0; *format >= '0' && *format <= '9'; ) {
   43a2f:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43a36:	0f b6 00             	movzbl (%rax),%eax
   43a39:	3c 2f                	cmp    $0x2f,%al
   43a3b:	0f 8e 85 00 00 00    	jle    43ac6 <printer_vprintf+0x1c2>
   43a41:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43a48:	0f b6 00             	movzbl (%rax),%eax
   43a4b:	3c 39                	cmp    $0x39,%al
   43a4d:	7e b2                	jle    43a01 <printer_vprintf+0xfd>
        if (*format >= '1' && *format <= '9') {
   43a4f:	eb 75                	jmp    43ac6 <printer_vprintf+0x1c2>
            }
        } else if (*format == '*') {
   43a51:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43a58:	0f b6 00             	movzbl (%rax),%eax
   43a5b:	3c 2a                	cmp    $0x2a,%al
   43a5d:	75 68                	jne    43ac7 <printer_vprintf+0x1c3>
            width = va_arg(val, int);
   43a5f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43a66:	8b 00                	mov    (%rax),%eax
   43a68:	83 f8 2f             	cmp    $0x2f,%eax
   43a6b:	77 30                	ja     43a9d <printer_vprintf+0x199>
   43a6d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43a74:	48 8b 50 10          	mov    0x10(%rax),%rdx
   43a78:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43a7f:	8b 00                	mov    (%rax),%eax
   43a81:	89 c0                	mov    %eax,%eax
   43a83:	48 01 d0             	add    %rdx,%rax
   43a86:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43a8d:	8b 12                	mov    (%rdx),%edx
   43a8f:	8d 4a 08             	lea    0x8(%rdx),%ecx
   43a92:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43a99:	89 0a                	mov    %ecx,(%rdx)
   43a9b:	eb 1a                	jmp    43ab7 <printer_vprintf+0x1b3>
   43a9d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43aa4:	48 8b 40 08          	mov    0x8(%rax),%rax
   43aa8:	48 8d 48 08          	lea    0x8(%rax),%rcx
   43aac:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43ab3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   43ab7:	8b 00                	mov    (%rax),%eax
   43ab9:	89 45 e8             	mov    %eax,-0x18(%rbp)
            ++format;
   43abc:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   43ac3:	01 
   43ac4:	eb 01                	jmp    43ac7 <printer_vprintf+0x1c3>
        if (*format >= '1' && *format <= '9') {
   43ac6:	90                   	nop
        }

        // process precision
        int precision = -1;
   43ac7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%rbp)
        if (*format == '.') {
   43ace:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43ad5:	0f b6 00             	movzbl (%rax),%eax
   43ad8:	3c 2e                	cmp    $0x2e,%al
   43ada:	0f 85 00 01 00 00    	jne    43be0 <printer_vprintf+0x2dc>
            ++format;
   43ae0:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   43ae7:	01 
            if (*format >= '0' && *format <= '9') {
   43ae8:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43aef:	0f b6 00             	movzbl (%rax),%eax
   43af2:	3c 2f                	cmp    $0x2f,%al
   43af4:	7e 67                	jle    43b5d <printer_vprintf+0x259>
   43af6:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43afd:	0f b6 00             	movzbl (%rax),%eax
   43b00:	3c 39                	cmp    $0x39,%al
   43b02:	7f 59                	jg     43b5d <printer_vprintf+0x259>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
   43b04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
   43b0b:	eb 2e                	jmp    43b3b <printer_vprintf+0x237>
                    precision = 10 * precision + *format++ - '0';
   43b0d:	8b 55 e4             	mov    -0x1c(%rbp),%edx
   43b10:	89 d0                	mov    %edx,%eax
   43b12:	c1 e0 02             	shl    $0x2,%eax
   43b15:	01 d0                	add    %edx,%eax
   43b17:	01 c0                	add    %eax,%eax
   43b19:	89 c1                	mov    %eax,%ecx
   43b1b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43b22:	48 8d 50 01          	lea    0x1(%rax),%rdx
   43b26:	48 89 95 68 ff ff ff 	mov    %rdx,-0x98(%rbp)
   43b2d:	0f b6 00             	movzbl (%rax),%eax
   43b30:	0f be c0             	movsbl %al,%eax
   43b33:	01 c8                	add    %ecx,%eax
   43b35:	83 e8 30             	sub    $0x30,%eax
   43b38:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
   43b3b:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43b42:	0f b6 00             	movzbl (%rax),%eax
   43b45:	3c 2f                	cmp    $0x2f,%al
   43b47:	0f 8e 85 00 00 00    	jle    43bd2 <printer_vprintf+0x2ce>
   43b4d:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43b54:	0f b6 00             	movzbl (%rax),%eax
   43b57:	3c 39                	cmp    $0x39,%al
   43b59:	7e b2                	jle    43b0d <printer_vprintf+0x209>
            if (*format >= '0' && *format <= '9') {
   43b5b:	eb 75                	jmp    43bd2 <printer_vprintf+0x2ce>
                }
            } else if (*format == '*') {
   43b5d:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43b64:	0f b6 00             	movzbl (%rax),%eax
   43b67:	3c 2a                	cmp    $0x2a,%al
   43b69:	75 68                	jne    43bd3 <printer_vprintf+0x2cf>
                precision = va_arg(val, int);
   43b6b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43b72:	8b 00                	mov    (%rax),%eax
   43b74:	83 f8 2f             	cmp    $0x2f,%eax
   43b77:	77 30                	ja     43ba9 <printer_vprintf+0x2a5>
   43b79:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43b80:	48 8b 50 10          	mov    0x10(%rax),%rdx
   43b84:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43b8b:	8b 00                	mov    (%rax),%eax
   43b8d:	89 c0                	mov    %eax,%eax
   43b8f:	48 01 d0             	add    %rdx,%rax
   43b92:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43b99:	8b 12                	mov    (%rdx),%edx
   43b9b:	8d 4a 08             	lea    0x8(%rdx),%ecx
   43b9e:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43ba5:	89 0a                	mov    %ecx,(%rdx)
   43ba7:	eb 1a                	jmp    43bc3 <printer_vprintf+0x2bf>
   43ba9:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43bb0:	48 8b 40 08          	mov    0x8(%rax),%rax
   43bb4:	48 8d 48 08          	lea    0x8(%rax),%rcx
   43bb8:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43bbf:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   43bc3:	8b 00                	mov    (%rax),%eax
   43bc5:	89 45 e4             	mov    %eax,-0x1c(%rbp)
                ++format;
   43bc8:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   43bcf:	01 
   43bd0:	eb 01                	jmp    43bd3 <printer_vprintf+0x2cf>
            if (*format >= '0' && *format <= '9') {
   43bd2:	90                   	nop
            }
            if (precision < 0) {
   43bd3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
   43bd7:	79 07                	jns    43be0 <printer_vprintf+0x2dc>
                precision = 0;
   43bd9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%rbp)
            }
        }

        // process main conversion character
        int base = 10;
   43be0:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%rbp)
        unsigned long num = 0;
   43be7:	48 c7 45 d8 00 00 00 	movq   $0x0,-0x28(%rbp)
   43bee:	00 
        int length = 0;
   43bef:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%rbp)
        char* data = "";
   43bf6:	48 c7 45 c8 c6 50 04 	movq   $0x450c6,-0x38(%rbp)
   43bfd:	00 
    again:
        switch (*format) {
   43bfe:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43c05:	0f b6 00             	movzbl (%rax),%eax
   43c08:	0f be c0             	movsbl %al,%eax
   43c0b:	83 e8 43             	sub    $0x43,%eax
   43c0e:	83 f8 37             	cmp    $0x37,%eax
   43c11:	0f 87 9f 03 00 00    	ja     43fb6 <printer_vprintf+0x6b2>
   43c17:	89 c0                	mov    %eax,%eax
   43c19:	48 8b 04 c5 d8 50 04 	mov    0x450d8(,%rax,8),%rax
   43c20:	00 
   43c21:	ff e0                	jmp    *%rax
        case 'l':
        case 'z':
            length = 1;
   43c23:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%rbp)
            ++format;
   43c2a:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   43c31:	01 
            goto again;
   43c32:	eb ca                	jmp    43bfe <printer_vprintf+0x2fa>
        case 'd':
        case 'i': {
            long x = length ? va_arg(val, long) : va_arg(val, int);
   43c34:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
   43c38:	74 5d                	je     43c97 <printer_vprintf+0x393>
   43c3a:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43c41:	8b 00                	mov    (%rax),%eax
   43c43:	83 f8 2f             	cmp    $0x2f,%eax
   43c46:	77 30                	ja     43c78 <printer_vprintf+0x374>
   43c48:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43c4f:	48 8b 50 10          	mov    0x10(%rax),%rdx
   43c53:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43c5a:	8b 00                	mov    (%rax),%eax
   43c5c:	89 c0                	mov    %eax,%eax
   43c5e:	48 01 d0             	add    %rdx,%rax
   43c61:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43c68:	8b 12                	mov    (%rdx),%edx
   43c6a:	8d 4a 08             	lea    0x8(%rdx),%ecx
   43c6d:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43c74:	89 0a                	mov    %ecx,(%rdx)
   43c76:	eb 1a                	jmp    43c92 <printer_vprintf+0x38e>
   43c78:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43c7f:	48 8b 40 08          	mov    0x8(%rax),%rax
   43c83:	48 8d 48 08          	lea    0x8(%rax),%rcx
   43c87:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43c8e:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   43c92:	48 8b 00             	mov    (%rax),%rax
   43c95:	eb 5c                	jmp    43cf3 <printer_vprintf+0x3ef>
   43c97:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43c9e:	8b 00                	mov    (%rax),%eax
   43ca0:	83 f8 2f             	cmp    $0x2f,%eax
   43ca3:	77 30                	ja     43cd5 <printer_vprintf+0x3d1>
   43ca5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43cac:	48 8b 50 10          	mov    0x10(%rax),%rdx
   43cb0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43cb7:	8b 00                	mov    (%rax),%eax
   43cb9:	89 c0                	mov    %eax,%eax
   43cbb:	48 01 d0             	add    %rdx,%rax
   43cbe:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43cc5:	8b 12                	mov    (%rdx),%edx
   43cc7:	8d 4a 08             	lea    0x8(%rdx),%ecx
   43cca:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43cd1:	89 0a                	mov    %ecx,(%rdx)
   43cd3:	eb 1a                	jmp    43cef <printer_vprintf+0x3eb>
   43cd5:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43cdc:	48 8b 40 08          	mov    0x8(%rax),%rax
   43ce0:	48 8d 48 08          	lea    0x8(%rax),%rcx
   43ce4:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43ceb:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   43cef:	8b 00                	mov    (%rax),%eax
   43cf1:	48 98                	cltq
   43cf3:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
   43cf7:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   43cfb:	48 c1 f8 38          	sar    $0x38,%rax
   43cff:	25 80 00 00 00       	and    $0x80,%eax
   43d04:	89 45 a4             	mov    %eax,-0x5c(%rbp)
            num = negative ? -x : x;
   43d07:	83 7d a4 00          	cmpl   $0x0,-0x5c(%rbp)
   43d0b:	74 09                	je     43d16 <printer_vprintf+0x412>
   43d0d:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   43d11:	48 f7 d8             	neg    %rax
   43d14:	eb 04                	jmp    43d1a <printer_vprintf+0x416>
   43d16:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   43d1a:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
   43d1e:	8b 45 a4             	mov    -0x5c(%rbp),%eax
   43d21:	83 c8 60             	or     $0x60,%eax
   43d24:	09 45 ec             	or     %eax,-0x14(%rbp)
            break;
   43d27:	e9 cf 02 00 00       	jmp    43ffb <printer_vprintf+0x6f7>
        }
        case 'u':
        format_unsigned:
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
   43d2c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%rbp)
   43d30:	74 5d                	je     43d8f <printer_vprintf+0x48b>
   43d32:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43d39:	8b 00                	mov    (%rax),%eax
   43d3b:	83 f8 2f             	cmp    $0x2f,%eax
   43d3e:	77 30                	ja     43d70 <printer_vprintf+0x46c>
   43d40:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43d47:	48 8b 50 10          	mov    0x10(%rax),%rdx
   43d4b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43d52:	8b 00                	mov    (%rax),%eax
   43d54:	89 c0                	mov    %eax,%eax
   43d56:	48 01 d0             	add    %rdx,%rax
   43d59:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43d60:	8b 12                	mov    (%rdx),%edx
   43d62:	8d 4a 08             	lea    0x8(%rdx),%ecx
   43d65:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43d6c:	89 0a                	mov    %ecx,(%rdx)
   43d6e:	eb 1a                	jmp    43d8a <printer_vprintf+0x486>
   43d70:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43d77:	48 8b 40 08          	mov    0x8(%rax),%rax
   43d7b:	48 8d 48 08          	lea    0x8(%rax),%rcx
   43d7f:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43d86:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   43d8a:	48 8b 00             	mov    (%rax),%rax
   43d8d:	eb 5c                	jmp    43deb <printer_vprintf+0x4e7>
   43d8f:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43d96:	8b 00                	mov    (%rax),%eax
   43d98:	83 f8 2f             	cmp    $0x2f,%eax
   43d9b:	77 30                	ja     43dcd <printer_vprintf+0x4c9>
   43d9d:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43da4:	48 8b 50 10          	mov    0x10(%rax),%rdx
   43da8:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43daf:	8b 00                	mov    (%rax),%eax
   43db1:	89 c0                	mov    %eax,%eax
   43db3:	48 01 d0             	add    %rdx,%rax
   43db6:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43dbd:	8b 12                	mov    (%rdx),%edx
   43dbf:	8d 4a 08             	lea    0x8(%rdx),%ecx
   43dc2:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43dc9:	89 0a                	mov    %ecx,(%rdx)
   43dcb:	eb 1a                	jmp    43de7 <printer_vprintf+0x4e3>
   43dcd:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43dd4:	48 8b 40 08          	mov    0x8(%rax),%rax
   43dd8:	48 8d 48 08          	lea    0x8(%rax),%rcx
   43ddc:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43de3:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   43de7:	8b 00                	mov    (%rax),%eax
   43de9:	89 c0                	mov    %eax,%eax
   43deb:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            flags |= FLAG_NUMERIC;
   43def:	83 4d ec 20          	orl    $0x20,-0x14(%rbp)
            break;
   43df3:	e9 03 02 00 00       	jmp    43ffb <printer_vprintf+0x6f7>
        case 'x':
            base = -16;
   43df8:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            goto format_unsigned;
   43dff:	e9 28 ff ff ff       	jmp    43d2c <printer_vprintf+0x428>
        case 'X':
            base = 16;
   43e04:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%rbp)
            goto format_unsigned;
   43e0b:	e9 1c ff ff ff       	jmp    43d2c <printer_vprintf+0x428>
        case 'p':
            num = (uintptr_t) va_arg(val, void*);
   43e10:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43e17:	8b 00                	mov    (%rax),%eax
   43e19:	83 f8 2f             	cmp    $0x2f,%eax
   43e1c:	77 30                	ja     43e4e <printer_vprintf+0x54a>
   43e1e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43e25:	48 8b 50 10          	mov    0x10(%rax),%rdx
   43e29:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43e30:	8b 00                	mov    (%rax),%eax
   43e32:	89 c0                	mov    %eax,%eax
   43e34:	48 01 d0             	add    %rdx,%rax
   43e37:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43e3e:	8b 12                	mov    (%rdx),%edx
   43e40:	8d 4a 08             	lea    0x8(%rdx),%ecx
   43e43:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43e4a:	89 0a                	mov    %ecx,(%rdx)
   43e4c:	eb 1a                	jmp    43e68 <printer_vprintf+0x564>
   43e4e:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43e55:	48 8b 40 08          	mov    0x8(%rax),%rax
   43e59:	48 8d 48 08          	lea    0x8(%rax),%rcx
   43e5d:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43e64:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   43e68:	48 8b 00             	mov    (%rax),%rax
   43e6b:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
            base = -16;
   43e6f:	c7 45 e0 f0 ff ff ff 	movl   $0xfffffff0,-0x20(%rbp)
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
   43e76:	81 4d ec 21 01 00 00 	orl    $0x121,-0x14(%rbp)
            break;
   43e7d:	e9 79 01 00 00       	jmp    43ffb <printer_vprintf+0x6f7>
        case 's':
            data = va_arg(val, char*);
   43e82:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43e89:	8b 00                	mov    (%rax),%eax
   43e8b:	83 f8 2f             	cmp    $0x2f,%eax
   43e8e:	77 30                	ja     43ec0 <printer_vprintf+0x5bc>
   43e90:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43e97:	48 8b 50 10          	mov    0x10(%rax),%rdx
   43e9b:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43ea2:	8b 00                	mov    (%rax),%eax
   43ea4:	89 c0                	mov    %eax,%eax
   43ea6:	48 01 d0             	add    %rdx,%rax
   43ea9:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43eb0:	8b 12                	mov    (%rdx),%edx
   43eb2:	8d 4a 08             	lea    0x8(%rdx),%ecx
   43eb5:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43ebc:	89 0a                	mov    %ecx,(%rdx)
   43ebe:	eb 1a                	jmp    43eda <printer_vprintf+0x5d6>
   43ec0:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43ec7:	48 8b 40 08          	mov    0x8(%rax),%rax
   43ecb:	48 8d 48 08          	lea    0x8(%rax),%rcx
   43ecf:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43ed6:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   43eda:	48 8b 00             	mov    (%rax),%rax
   43edd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            break;
   43ee1:	e9 15 01 00 00       	jmp    43ffb <printer_vprintf+0x6f7>
        case 'C':
            color = va_arg(val, int);
   43ee6:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43eed:	8b 00                	mov    (%rax),%eax
   43eef:	83 f8 2f             	cmp    $0x2f,%eax
   43ef2:	77 30                	ja     43f24 <printer_vprintf+0x620>
   43ef4:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43efb:	48 8b 50 10          	mov    0x10(%rax),%rdx
   43eff:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43f06:	8b 00                	mov    (%rax),%eax
   43f08:	89 c0                	mov    %eax,%eax
   43f0a:	48 01 d0             	add    %rdx,%rax
   43f0d:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43f14:	8b 12                	mov    (%rdx),%edx
   43f16:	8d 4a 08             	lea    0x8(%rdx),%ecx
   43f19:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43f20:	89 0a                	mov    %ecx,(%rdx)
   43f22:	eb 1a                	jmp    43f3e <printer_vprintf+0x63a>
   43f24:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43f2b:	48 8b 40 08          	mov    0x8(%rax),%rax
   43f2f:	48 8d 48 08          	lea    0x8(%rax),%rcx
   43f33:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43f3a:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   43f3e:	8b 00                	mov    (%rax),%eax
   43f40:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%rbp)
            goto done;
   43f46:	e9 67 03 00 00       	jmp    442b2 <printer_vprintf+0x9ae>
        case 'c':
            data = numbuf;
   43f4b:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
   43f4f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = va_arg(val, int);
   43f53:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43f5a:	8b 00                	mov    (%rax),%eax
   43f5c:	83 f8 2f             	cmp    $0x2f,%eax
   43f5f:	77 30                	ja     43f91 <printer_vprintf+0x68d>
   43f61:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43f68:	48 8b 50 10          	mov    0x10(%rax),%rdx
   43f6c:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43f73:	8b 00                	mov    (%rax),%eax
   43f75:	89 c0                	mov    %eax,%eax
   43f77:	48 01 d0             	add    %rdx,%rax
   43f7a:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43f81:	8b 12                	mov    (%rdx),%edx
   43f83:	8d 4a 08             	lea    0x8(%rdx),%ecx
   43f86:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43f8d:	89 0a                	mov    %ecx,(%rdx)
   43f8f:	eb 1a                	jmp    43fab <printer_vprintf+0x6a7>
   43f91:	48 8b 85 60 ff ff ff 	mov    -0xa0(%rbp),%rax
   43f98:	48 8b 40 08          	mov    0x8(%rax),%rax
   43f9c:	48 8d 48 08          	lea    0x8(%rax),%rcx
   43fa0:	48 8b 95 60 ff ff ff 	mov    -0xa0(%rbp),%rdx
   43fa7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   43fab:	8b 00                	mov    (%rax),%eax
   43fad:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
   43fb0:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            break;
   43fb4:	eb 45                	jmp    43ffb <printer_vprintf+0x6f7>
        default:
            data = numbuf;
   43fb6:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
   43fba:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
            numbuf[0] = (*format ? *format : '%');
   43fbe:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43fc5:	0f b6 00             	movzbl (%rax),%eax
   43fc8:	84 c0                	test   %al,%al
   43fca:	74 0c                	je     43fd8 <printer_vprintf+0x6d4>
   43fcc:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43fd3:	0f b6 00             	movzbl (%rax),%eax
   43fd6:	eb 05                	jmp    43fdd <printer_vprintf+0x6d9>
   43fd8:	b8 25 00 00 00       	mov    $0x25,%eax
   43fdd:	88 45 8c             	mov    %al,-0x74(%rbp)
            numbuf[1] = '\0';
   43fe0:	c6 45 8d 00          	movb   $0x0,-0x73(%rbp)
            if (!*format) {
   43fe4:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   43feb:	0f b6 00             	movzbl (%rax),%eax
   43fee:	84 c0                	test   %al,%al
   43ff0:	75 08                	jne    43ffa <printer_vprintf+0x6f6>
                format--;
   43ff2:	48 83 ad 68 ff ff ff 	subq   $0x1,-0x98(%rbp)
   43ff9:	01 
            }
            break;
   43ffa:	90                   	nop
        }

        if (flags & FLAG_NUMERIC) {
   43ffb:	8b 45 ec             	mov    -0x14(%rbp),%eax
   43ffe:	83 e0 20             	and    $0x20,%eax
   44001:	85 c0                	test   %eax,%eax
   44003:	74 1e                	je     44023 <printer_vprintf+0x71f>
            data = fill_numbuf(numbuf + NUMBUFSIZ, num, base);
   44005:	48 8d 45 8c          	lea    -0x74(%rbp),%rax
   44009:	48 83 c0 18          	add    $0x18,%rax
   4400d:	8b 55 e0             	mov    -0x20(%rbp),%edx
   44010:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
   44014:	48 89 ce             	mov    %rcx,%rsi
   44017:	48 89 c7             	mov    %rax,%rdi
   4401a:	e8 63 f8 ff ff       	call   43882 <fill_numbuf>
   4401f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        }

        const char* prefix = "";
   44023:	48 c7 45 c0 c6 50 04 	movq   $0x450c6,-0x40(%rbp)
   4402a:	00 
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
   4402b:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4402e:	83 e0 20             	and    $0x20,%eax
   44031:	85 c0                	test   %eax,%eax
   44033:	74 48                	je     4407d <printer_vprintf+0x779>
   44035:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44038:	83 e0 40             	and    $0x40,%eax
   4403b:	85 c0                	test   %eax,%eax
   4403d:	74 3e                	je     4407d <printer_vprintf+0x779>
            if (flags & FLAG_NEGATIVE) {
   4403f:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44042:	25 80 00 00 00       	and    $0x80,%eax
   44047:	85 c0                	test   %eax,%eax
   44049:	74 0a                	je     44055 <printer_vprintf+0x751>
                prefix = "-";
   4404b:	48 c7 45 c0 c7 50 04 	movq   $0x450c7,-0x40(%rbp)
   44052:	00 
            if (flags & FLAG_NEGATIVE) {
   44053:	eb 73                	jmp    440c8 <printer_vprintf+0x7c4>
            } else if (flags & FLAG_PLUSPOSITIVE) {
   44055:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44058:	83 e0 10             	and    $0x10,%eax
   4405b:	85 c0                	test   %eax,%eax
   4405d:	74 0a                	je     44069 <printer_vprintf+0x765>
                prefix = "+";
   4405f:	48 c7 45 c0 c9 50 04 	movq   $0x450c9,-0x40(%rbp)
   44066:	00 
            if (flags & FLAG_NEGATIVE) {
   44067:	eb 5f                	jmp    440c8 <printer_vprintf+0x7c4>
            } else if (flags & FLAG_SPACEPOSITIVE) {
   44069:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4406c:	83 e0 08             	and    $0x8,%eax
   4406f:	85 c0                	test   %eax,%eax
   44071:	74 55                	je     440c8 <printer_vprintf+0x7c4>
                prefix = " ";
   44073:	48 c7 45 c0 cb 50 04 	movq   $0x450cb,-0x40(%rbp)
   4407a:	00 
            if (flags & FLAG_NEGATIVE) {
   4407b:	eb 4b                	jmp    440c8 <printer_vprintf+0x7c4>
            }
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
   4407d:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44080:	83 e0 20             	and    $0x20,%eax
   44083:	85 c0                	test   %eax,%eax
   44085:	74 42                	je     440c9 <printer_vprintf+0x7c5>
   44087:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4408a:	83 e0 01             	and    $0x1,%eax
   4408d:	85 c0                	test   %eax,%eax
   4408f:	74 38                	je     440c9 <printer_vprintf+0x7c5>
                   && (base == 16 || base == -16)
   44091:	83 7d e0 10          	cmpl   $0x10,-0x20(%rbp)
   44095:	74 06                	je     4409d <printer_vprintf+0x799>
   44097:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
   4409b:	75 2c                	jne    440c9 <printer_vprintf+0x7c5>
                   && (num || (flags & FLAG_ALT2))) {
   4409d:	48 83 7d d8 00       	cmpq   $0x0,-0x28(%rbp)
   440a2:	75 0c                	jne    440b0 <printer_vprintf+0x7ac>
   440a4:	8b 45 ec             	mov    -0x14(%rbp),%eax
   440a7:	25 00 01 00 00       	and    $0x100,%eax
   440ac:	85 c0                	test   %eax,%eax
   440ae:	74 19                	je     440c9 <printer_vprintf+0x7c5>
            prefix = (base == -16 ? "0x" : "0X");
   440b0:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%rbp)
   440b4:	75 07                	jne    440bd <printer_vprintf+0x7b9>
   440b6:	b8 cd 50 04 00       	mov    $0x450cd,%eax
   440bb:	eb 05                	jmp    440c2 <printer_vprintf+0x7be>
   440bd:	b8 d0 50 04 00       	mov    $0x450d0,%eax
   440c2:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   440c6:	eb 01                	jmp    440c9 <printer_vprintf+0x7c5>
            if (flags & FLAG_NEGATIVE) {
   440c8:	90                   	nop
        }

        int len;
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
   440c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
   440cd:	78 24                	js     440f3 <printer_vprintf+0x7ef>
   440cf:	8b 45 ec             	mov    -0x14(%rbp),%eax
   440d2:	83 e0 20             	and    $0x20,%eax
   440d5:	85 c0                	test   %eax,%eax
   440d7:	75 1a                	jne    440f3 <printer_vprintf+0x7ef>
            len = strnlen(data, precision);
   440d9:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   440dc:	48 63 d0             	movslq %eax,%rdx
   440df:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   440e3:	48 89 d6             	mov    %rdx,%rsi
   440e6:	48 89 c7             	mov    %rax,%rdi
   440e9:	e8 ea f5 ff ff       	call   436d8 <strnlen>
   440ee:	89 45 bc             	mov    %eax,-0x44(%rbp)
   440f1:	eb 0f                	jmp    44102 <printer_vprintf+0x7fe>
        } else {
            len = strlen(data);
   440f3:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   440f7:	48 89 c7             	mov    %rax,%rdi
   440fa:	e8 a8 f5 ff ff       	call   436a7 <strlen>
   440ff:	89 45 bc             	mov    %eax,-0x44(%rbp)
        }
        int zeros;
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
   44102:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44105:	83 e0 20             	and    $0x20,%eax
   44108:	85 c0                	test   %eax,%eax
   4410a:	74 20                	je     4412c <printer_vprintf+0x828>
   4410c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%rbp)
   44110:	78 1a                	js     4412c <printer_vprintf+0x828>
            zeros = precision > len ? precision - len : 0;
   44112:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   44115:	3b 45 bc             	cmp    -0x44(%rbp),%eax
   44118:	7e 08                	jle    44122 <printer_vprintf+0x81e>
   4411a:	8b 45 e4             	mov    -0x1c(%rbp),%eax
   4411d:	2b 45 bc             	sub    -0x44(%rbp),%eax
   44120:	eb 05                	jmp    44127 <printer_vprintf+0x823>
   44122:	b8 00 00 00 00       	mov    $0x0,%eax
   44127:	89 45 b8             	mov    %eax,-0x48(%rbp)
   4412a:	eb 5c                	jmp    44188 <printer_vprintf+0x884>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
   4412c:	8b 45 ec             	mov    -0x14(%rbp),%eax
   4412f:	83 e0 20             	and    $0x20,%eax
   44132:	85 c0                	test   %eax,%eax
   44134:	74 4b                	je     44181 <printer_vprintf+0x87d>
   44136:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44139:	83 e0 02             	and    $0x2,%eax
   4413c:	85 c0                	test   %eax,%eax
   4413e:	74 41                	je     44181 <printer_vprintf+0x87d>
                   && !(flags & FLAG_LEFTJUSTIFY)
   44140:	8b 45 ec             	mov    -0x14(%rbp),%eax
   44143:	83 e0 04             	and    $0x4,%eax
   44146:	85 c0                	test   %eax,%eax
   44148:	75 37                	jne    44181 <printer_vprintf+0x87d>
                   && len + (int) strlen(prefix) < width) {
   4414a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   4414e:	48 89 c7             	mov    %rax,%rdi
   44151:	e8 51 f5 ff ff       	call   436a7 <strlen>
   44156:	89 c2                	mov    %eax,%edx
   44158:	8b 45 bc             	mov    -0x44(%rbp),%eax
   4415b:	01 d0                	add    %edx,%eax
   4415d:	39 45 e8             	cmp    %eax,-0x18(%rbp)
   44160:	7e 1f                	jle    44181 <printer_vprintf+0x87d>
            zeros = width - len - strlen(prefix);
   44162:	8b 45 e8             	mov    -0x18(%rbp),%eax
   44165:	2b 45 bc             	sub    -0x44(%rbp),%eax
   44168:	89 c3                	mov    %eax,%ebx
   4416a:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   4416e:	48 89 c7             	mov    %rax,%rdi
   44171:	e8 31 f5 ff ff       	call   436a7 <strlen>
   44176:	89 c2                	mov    %eax,%edx
   44178:	89 d8                	mov    %ebx,%eax
   4417a:	29 d0                	sub    %edx,%eax
   4417c:	89 45 b8             	mov    %eax,-0x48(%rbp)
   4417f:	eb 07                	jmp    44188 <printer_vprintf+0x884>
        } else {
            zeros = 0;
   44181:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%rbp)
        }
        width -= len + zeros + strlen(prefix);
   44188:	8b 55 bc             	mov    -0x44(%rbp),%edx
   4418b:	8b 45 b8             	mov    -0x48(%rbp),%eax
   4418e:	01 d0                	add    %edx,%eax
   44190:	48 63 d8             	movslq %eax,%rbx
   44193:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   44197:	48 89 c7             	mov    %rax,%rdi
   4419a:	e8 08 f5 ff ff       	call   436a7 <strlen>
   4419f:	48 8d 14 03          	lea    (%rbx,%rax,1),%rdx
   441a3:	8b 45 e8             	mov    -0x18(%rbp),%eax
   441a6:	29 d0                	sub    %edx,%eax
   441a8:	89 45 e8             	mov    %eax,-0x18(%rbp)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
   441ab:	eb 25                	jmp    441d2 <printer_vprintf+0x8ce>
            p->putc(p, ' ', color);
   441ad:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   441b4:	48 8b 08             	mov    (%rax),%rcx
   441b7:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
   441bd:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   441c4:	be 20 00 00 00       	mov    $0x20,%esi
   441c9:	48 89 c7             	mov    %rax,%rdi
   441cc:	ff d1                	call   *%rcx
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
   441ce:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
   441d2:	8b 45 ec             	mov    -0x14(%rbp),%eax
   441d5:	83 e0 04             	and    $0x4,%eax
   441d8:	85 c0                	test   %eax,%eax
   441da:	75 36                	jne    44212 <printer_vprintf+0x90e>
   441dc:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
   441e0:	7f cb                	jg     441ad <printer_vprintf+0x8a9>
        }
        for (; *prefix; ++prefix) {
   441e2:	eb 2e                	jmp    44212 <printer_vprintf+0x90e>
            p->putc(p, *prefix, color);
   441e4:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   441eb:	4c 8b 00             	mov    (%rax),%r8
   441ee:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   441f2:	0f b6 00             	movzbl (%rax),%eax
   441f5:	0f b6 c8             	movzbl %al,%ecx
   441f8:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
   441fe:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   44205:	89 ce                	mov    %ecx,%esi
   44207:	48 89 c7             	mov    %rax,%rdi
   4420a:	41 ff d0             	call   *%r8
        for (; *prefix; ++prefix) {
   4420d:	48 83 45 c0 01       	addq   $0x1,-0x40(%rbp)
   44212:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
   44216:	0f b6 00             	movzbl (%rax),%eax
   44219:	84 c0                	test   %al,%al
   4421b:	75 c7                	jne    441e4 <printer_vprintf+0x8e0>
        }
        for (; zeros > 0; --zeros) {
   4421d:	eb 25                	jmp    44244 <printer_vprintf+0x940>
            p->putc(p, '0', color);
   4421f:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   44226:	48 8b 08             	mov    (%rax),%rcx
   44229:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
   4422f:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   44236:	be 30 00 00 00       	mov    $0x30,%esi
   4423b:	48 89 c7             	mov    %rax,%rdi
   4423e:	ff d1                	call   *%rcx
        for (; zeros > 0; --zeros) {
   44240:	83 6d b8 01          	subl   $0x1,-0x48(%rbp)
   44244:	83 7d b8 00          	cmpl   $0x0,-0x48(%rbp)
   44248:	7f d5                	jg     4421f <printer_vprintf+0x91b>
        }
        for (; len > 0; ++data, --len) {
   4424a:	eb 32                	jmp    4427e <printer_vprintf+0x97a>
            p->putc(p, *data, color);
   4424c:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   44253:	4c 8b 00             	mov    (%rax),%r8
   44256:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
   4425a:	0f b6 00             	movzbl (%rax),%eax
   4425d:	0f b6 c8             	movzbl %al,%ecx
   44260:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
   44266:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   4426d:	89 ce                	mov    %ecx,%esi
   4426f:	48 89 c7             	mov    %rax,%rdi
   44272:	41 ff d0             	call   *%r8
        for (; len > 0; ++data, --len) {
   44275:	48 83 45 c8 01       	addq   $0x1,-0x38(%rbp)
   4427a:	83 6d bc 01          	subl   $0x1,-0x44(%rbp)
   4427e:	83 7d bc 00          	cmpl   $0x0,-0x44(%rbp)
   44282:	7f c8                	jg     4424c <printer_vprintf+0x948>
        }
        for (; width > 0; --width) {
   44284:	eb 25                	jmp    442ab <printer_vprintf+0x9a7>
            p->putc(p, ' ', color);
   44286:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   4428d:	48 8b 08             	mov    (%rax),%rcx
   44290:	8b 95 74 ff ff ff    	mov    -0x8c(%rbp),%edx
   44296:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
   4429d:	be 20 00 00 00       	mov    $0x20,%esi
   442a2:	48 89 c7             	mov    %rax,%rdi
   442a5:	ff d1                	call   *%rcx
        for (; width > 0; --width) {
   442a7:	83 6d e8 01          	subl   $0x1,-0x18(%rbp)
   442ab:	83 7d e8 00          	cmpl   $0x0,-0x18(%rbp)
   442af:	7f d5                	jg     44286 <printer_vprintf+0x982>
        }
    done: ;
   442b1:	90                   	nop
    for (; *format; ++format) {
   442b2:	48 83 85 68 ff ff ff 	addq   $0x1,-0x98(%rbp)
   442b9:	01 
   442ba:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
   442c1:	0f b6 00             	movzbl (%rax),%eax
   442c4:	84 c0                	test   %al,%al
   442c6:	0f 85 64 f6 ff ff    	jne    43930 <printer_vprintf+0x2c>
    }
}
   442cc:	90                   	nop
   442cd:	90                   	nop
   442ce:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
   442d2:	c9                   	leave
   442d3:	c3                   	ret

00000000000442d4 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
   442d4:	55                   	push   %rbp
   442d5:	48 89 e5             	mov    %rsp,%rbp
   442d8:	48 83 ec 20          	sub    $0x20,%rsp
   442dc:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   442e0:	89 f0                	mov    %esi,%eax
   442e2:	89 55 e0             	mov    %edx,-0x20(%rbp)
   442e5:	88 45 e4             	mov    %al,-0x1c(%rbp)
    console_printer* cp = (console_printer*) p;
   442e8:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   442ec:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
   442f0:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   442f4:	48 8b 40 08          	mov    0x8(%rax),%rax
   442f8:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
   442fd:	48 39 d0             	cmp    %rdx,%rax
   44300:	72 0c                	jb     4430e <console_putc+0x3a>
        cp->cursor = console;
   44302:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   44306:	48 c7 40 08 00 80 0b 	movq   $0xb8000,0x8(%rax)
   4430d:	00 
    }
    if (c == '\n') {
   4430e:	80 7d e4 0a          	cmpb   $0xa,-0x1c(%rbp)
   44312:	75 78                	jne    4438c <console_putc+0xb8>
        int pos = (cp->cursor - console) % 80;
   44314:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   44318:	48 8b 40 08          	mov    0x8(%rax),%rax
   4431c:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
   44322:	48 d1 f8             	sar    %rax
   44325:	48 89 c1             	mov    %rax,%rcx
   44328:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
   4432f:	66 66 66 
   44332:	48 89 c8             	mov    %rcx,%rax
   44335:	48 f7 ea             	imul   %rdx
   44338:	48 c1 fa 05          	sar    $0x5,%rdx
   4433c:	48 89 c8             	mov    %rcx,%rax
   4433f:	48 c1 f8 3f          	sar    $0x3f,%rax
   44343:	48 29 c2             	sub    %rax,%rdx
   44346:	48 89 d0             	mov    %rdx,%rax
   44349:	48 c1 e0 02          	shl    $0x2,%rax
   4434d:	48 01 d0             	add    %rdx,%rax
   44350:	48 c1 e0 04          	shl    $0x4,%rax
   44354:	48 29 c1             	sub    %rax,%rcx
   44357:	48 89 ca             	mov    %rcx,%rdx
   4435a:	89 55 fc             	mov    %edx,-0x4(%rbp)
        for (; pos != 80; pos++) {
   4435d:	eb 25                	jmp    44384 <console_putc+0xb0>
            *cp->cursor++ = ' ' | color;
   4435f:	8b 45 e0             	mov    -0x20(%rbp),%eax
   44362:	83 c8 20             	or     $0x20,%eax
   44365:	89 c6                	mov    %eax,%esi
   44367:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4436b:	48 8b 40 08          	mov    0x8(%rax),%rax
   4436f:	48 8d 48 02          	lea    0x2(%rax),%rcx
   44373:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   44377:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   4437b:	89 f2                	mov    %esi,%edx
   4437d:	66 89 10             	mov    %dx,(%rax)
        for (; pos != 80; pos++) {
   44380:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   44384:	83 7d fc 50          	cmpl   $0x50,-0x4(%rbp)
   44388:	75 d5                	jne    4435f <console_putc+0x8b>
        }
    } else {
        *cp->cursor++ = c | color;
    }
}
   4438a:	eb 24                	jmp    443b0 <console_putc+0xdc>
        *cp->cursor++ = c | color;
   4438c:	0f b6 45 e4          	movzbl -0x1c(%rbp),%eax
   44390:	8b 55 e0             	mov    -0x20(%rbp),%edx
   44393:	09 d0                	or     %edx,%eax
   44395:	89 c6                	mov    %eax,%esi
   44397:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4439b:	48 8b 40 08          	mov    0x8(%rax),%rax
   4439f:	48 8d 48 02          	lea    0x2(%rax),%rcx
   443a3:	48 8b 55 f0          	mov    -0x10(%rbp),%rdx
   443a7:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   443ab:	89 f2                	mov    %esi,%edx
   443ad:	66 89 10             	mov    %dx,(%rax)
}
   443b0:	90                   	nop
   443b1:	c9                   	leave
   443b2:	c3                   	ret

00000000000443b3 <console_vprintf>:

int console_vprintf(int cpos, int color, const char* format, va_list val) {
   443b3:	55                   	push   %rbp
   443b4:	48 89 e5             	mov    %rsp,%rbp
   443b7:	48 83 ec 30          	sub    $0x30,%rsp
   443bb:	89 7d ec             	mov    %edi,-0x14(%rbp)
   443be:	89 75 e8             	mov    %esi,-0x18(%rbp)
   443c1:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
   443c5:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
    struct console_printer cp;
    cp.p.putc = console_putc;
   443c9:	48 c7 45 f0 d4 42 04 	movq   $0x442d4,-0x10(%rbp)
   443d0:	00 
    if (cpos < 0 || cpos >= CONSOLE_ROWS * CONSOLE_COLUMNS) {
   443d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%rbp)
   443d5:	78 09                	js     443e0 <console_vprintf+0x2d>
   443d7:	81 7d ec cf 07 00 00 	cmpl   $0x7cf,-0x14(%rbp)
   443de:	7e 07                	jle    443e7 <console_vprintf+0x34>
        cpos = 0;
   443e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%rbp)
    }
    cp.cursor = console + cpos;
   443e7:	8b 45 ec             	mov    -0x14(%rbp),%eax
   443ea:	48 98                	cltq
   443ec:	48 01 c0             	add    %rax,%rax
   443ef:	48 05 00 80 0b 00    	add    $0xb8000,%rax
   443f5:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
   443f9:	48 8b 4d d8          	mov    -0x28(%rbp),%rcx
   443fd:	48 8b 55 e0          	mov    -0x20(%rbp),%rdx
   44401:	8b 75 e8             	mov    -0x18(%rbp),%esi
   44404:	48 8d 45 f0          	lea    -0x10(%rbp),%rax
   44408:	48 89 c7             	mov    %rax,%rdi
   4440b:	e8 f4 f4 ff ff       	call   43904 <printer_vprintf>
    return cp.cursor - console;
   44410:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   44414:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
   4441a:	48 d1 f8             	sar    %rax
}
   4441d:	c9                   	leave
   4441e:	c3                   	ret

000000000004441f <console_printf>:

int console_printf(int cpos, int color, const char* format, ...) {
   4441f:	55                   	push   %rbp
   44420:	48 89 e5             	mov    %rsp,%rbp
   44423:	48 83 ec 60          	sub    $0x60,%rsp
   44427:	89 7d ac             	mov    %edi,-0x54(%rbp)
   4442a:	89 75 a8             	mov    %esi,-0x58(%rbp)
   4442d:	48 89 55 a0          	mov    %rdx,-0x60(%rbp)
   44431:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   44435:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   44439:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   4443d:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
   44444:	48 8d 45 10          	lea    0x10(%rbp),%rax
   44448:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
   4444c:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   44450:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
   44454:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
   44458:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
   4445c:	8b 75 a8             	mov    -0x58(%rbp),%esi
   4445f:	8b 45 ac             	mov    -0x54(%rbp),%eax
   44462:	89 c7                	mov    %eax,%edi
   44464:	e8 4a ff ff ff       	call   443b3 <console_vprintf>
   44469:	89 45 ac             	mov    %eax,-0x54(%rbp)
    va_end(val);
    return cpos;
   4446c:	8b 45 ac             	mov    -0x54(%rbp),%eax
}
   4446f:	c9                   	leave
   44470:	c3                   	ret

0000000000044471 <string_putc>:
    printer p;
    char* s;
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
   44471:	55                   	push   %rbp
   44472:	48 89 e5             	mov    %rsp,%rbp
   44475:	48 83 ec 20          	sub    $0x20,%rsp
   44479:	48 89 7d e8          	mov    %rdi,-0x18(%rbp)
   4447d:	89 f0                	mov    %esi,%eax
   4447f:	89 55 e0             	mov    %edx,-0x20(%rbp)
   44482:	88 45 e4             	mov    %al,-0x1c(%rbp)
    string_printer* sp = (string_printer*) p;
   44485:	48 8b 45 e8          	mov    -0x18(%rbp),%rax
   44489:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    if (sp->s < sp->end) {
   4448d:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   44491:	48 8b 50 08          	mov    0x8(%rax),%rdx
   44495:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   44499:	48 8b 40 10          	mov    0x10(%rax),%rax
   4449d:	48 39 c2             	cmp    %rax,%rdx
   444a0:	73 1a                	jae    444bc <string_putc+0x4b>
        *sp->s++ = c;
   444a2:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
   444a6:	48 8b 40 08          	mov    0x8(%rax),%rax
   444aa:	48 8d 48 01          	lea    0x1(%rax),%rcx
   444ae:	48 8b 55 f8          	mov    -0x8(%rbp),%rdx
   444b2:	48 89 4a 08          	mov    %rcx,0x8(%rdx)
   444b6:	0f b6 55 e4          	movzbl -0x1c(%rbp),%edx
   444ba:	88 10                	mov    %dl,(%rax)
    }
    (void) color;
}
   444bc:	90                   	nop
   444bd:	c9                   	leave
   444be:	c3                   	ret

00000000000444bf <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
   444bf:	55                   	push   %rbp
   444c0:	48 89 e5             	mov    %rsp,%rbp
   444c3:	48 83 ec 40          	sub    $0x40,%rsp
   444c7:	48 89 7d d8          	mov    %rdi,-0x28(%rbp)
   444cb:	48 89 75 d0          	mov    %rsi,-0x30(%rbp)
   444cf:	48 89 55 c8          	mov    %rdx,-0x38(%rbp)
   444d3:	48 89 4d c0          	mov    %rcx,-0x40(%rbp)
    string_printer sp;
    sp.p.putc = string_putc;
   444d7:	48 c7 45 e8 71 44 04 	movq   $0x44471,-0x18(%rbp)
   444de:	00 
    sp.s = s;
   444df:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   444e3:	48 89 45 f0          	mov    %rax,-0x10(%rbp)
    if (size) {
   444e7:	48 83 7d d0 00       	cmpq   $0x0,-0x30(%rbp)
   444ec:	74 33                	je     44521 <vsnprintf+0x62>
        sp.end = s + size - 1;
   444ee:	48 8b 45 d0          	mov    -0x30(%rbp),%rax
   444f2:	48 8d 50 ff          	lea    -0x1(%rax),%rdx
   444f6:	48 8b 45 d8          	mov    -0x28(%rbp),%rax
   444fa:	48 01 d0             	add    %rdx,%rax
   444fd:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
   44501:	48 8b 4d c0          	mov    -0x40(%rbp),%rcx
   44505:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
   44509:	48 8d 45 e8          	lea    -0x18(%rbp),%rax
   4450d:	be 00 00 00 00       	mov    $0x0,%esi
   44512:	48 89 c7             	mov    %rax,%rdi
   44515:	e8 ea f3 ff ff       	call   43904 <printer_vprintf>
        *sp.s = 0;
   4451a:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   4451e:	c6 00 00             	movb   $0x0,(%rax)
    }
    return sp.s - s;
   44521:	48 8b 45 f0          	mov    -0x10(%rbp),%rax
   44525:	48 2b 45 d8          	sub    -0x28(%rbp),%rax
}
   44529:	c9                   	leave
   4452a:	c3                   	ret

000000000004452b <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
   4452b:	55                   	push   %rbp
   4452c:	48 89 e5             	mov    %rsp,%rbp
   4452f:	48 83 ec 70          	sub    $0x70,%rsp
   44533:	48 89 7d a8          	mov    %rdi,-0x58(%rbp)
   44537:	48 89 75 a0          	mov    %rsi,-0x60(%rbp)
   4453b:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
   4453f:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
   44543:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
   44547:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
   4454b:	c7 45 b0 18 00 00 00 	movl   $0x18,-0x50(%rbp)
   44552:	48 8d 45 10          	lea    0x10(%rbp),%rax
   44556:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
   4455a:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
   4455e:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    int n = vsnprintf(s, size, format, val);
   44562:	48 8d 4d b0          	lea    -0x50(%rbp),%rcx
   44566:	48 8b 55 98          	mov    -0x68(%rbp),%rdx
   4456a:	48 8b 75 a0          	mov    -0x60(%rbp),%rsi
   4456e:	48 8b 45 a8          	mov    -0x58(%rbp),%rax
   44572:	48 89 c7             	mov    %rax,%rdi
   44575:	e8 45 ff ff ff       	call   444bf <vsnprintf>
   4457a:	89 45 cc             	mov    %eax,-0x34(%rbp)
    va_end(val);
    return n;
   4457d:	8b 45 cc             	mov    -0x34(%rbp),%eax
}
   44580:	c9                   	leave
   44581:	c3                   	ret

0000000000044582 <console_clear>:


// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
   44582:	55                   	push   %rbp
   44583:	48 89 e5             	mov    %rsp,%rbp
   44586:	48 83 ec 10          	sub    $0x10,%rsp
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
   4458a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
   44591:	eb 13                	jmp    445a6 <console_clear+0x24>
        console[i] = ' ' | 0x0700;
   44593:	8b 45 fc             	mov    -0x4(%rbp),%eax
   44596:	48 98                	cltq
   44598:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%rax,%rax,1)
   4459f:	00 20 07 
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
   445a2:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
   445a6:	81 7d fc cf 07 00 00 	cmpl   $0x7cf,-0x4(%rbp)
   445ad:	7e e4                	jle    44593 <console_clear+0x11>
    }
    cursorpos = 0;
   445af:	c7 05 43 4a 07 00 00 	movl   $0x0,0x74a43(%rip)        # b8ffc <cursorpos>
   445b6:	00 00 00 
}
   445b9:	90                   	nop
   445ba:	c9                   	leave
   445bb:	c3                   	ret
