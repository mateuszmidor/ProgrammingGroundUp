.section .data

.section .text
.global _start
_start:
    push $13            # 13 as square argument
    call square
    add $8, %rsp        # take the argument off the stack

    mov %rax, %rbx      # rbx = result
    mov $1, %rax        # 1 = syscall "exit"
    int $0x80           # syscall

square:
    push %rbp
    mov %rsp, %rbp

    mov 16(%rbp), %rax  # rax = value to be squared
    imul %rax, %rax     # rax = rax * rax

    mov %rbp, %rsp
    pop %rbp
    ret
