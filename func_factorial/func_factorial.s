.section .data

.section .text
.global _start
_start:
    push $4             # push function parameter of 4
    call factorial
    add $8, %rsp        # take function parameter off the stack
    mov %rax, %rbx      # rbx = factorial result

    mov $1, %rax
    int $0x80

.type factorial, @function  # define symbol "factorial" as function
factorial:
    push %rbp           # save rbp
    mov %rsp, %rbp      # save rsp

    mov 16(%rbp), %rax  # rax = factorial argument
    cmp $1, %rax        # if factorial of 1, then return 1
    je end_factorial

    dec %rax            # dec factorial
    push %rax           # then push it as next factorial call param
    call factorial
    mov 16(%rbp), %rbx  # rbx = factorial call result
    imul %rbx, %rax     # rax = rax * rbx

end_factorial:

    mov %rbp, %rsp      # restore rsp
    pop %rbp            # restore rbp
    ret
