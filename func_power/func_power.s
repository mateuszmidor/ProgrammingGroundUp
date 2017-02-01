.section .data

.section .text
.global _start
_start:
    push $6         # push second argument
    push $2         # push first argument; it makes 2^6
    call power      # call means : push return_address and jmp power
    add $16, %rsp   # take the 2 function arguments off the stack
    movl %eax, %ebx # move function result to ebx

    movl $1, %eax
    int $0x80       # exit(result)


.type power, @function
power:
    push %rbp           # save base pointer
    mov %rsp, %rbp      # save stack pointer
    sub $8, %rsp        # allocate one word on stack
                        # (%rbp) = old rbp
                        # 8(%rbp) = return address
    mov 16(%rbp), %rbx  # first argument -> ebx
    mov 24(%rbp), %rcx  # second argument -> ecx
    mov %ebx, -8(%rbp)  # store current result

    power_loop_start:
        cmp $1, %rcx
        jle end_power
        mov -8(%rbp), %rax     # eax = current result
        imul %rbx, %rax        # eax = eax * ebx
        mov %rax, -8(%rbp)     # store current result
        dec %rcx               # decrement counter
        jmp power_loop_start    # loop again
    end_power:
        mov -8(%rbp), %rax     # eax = result
        mov %rbp, %rsp         # restore stack pointer
        pop %rbp
    ret                        # pop return_address and jmp return_address
