.section .data
item_list: .long 1,2,3,150,120,90,40,50,60,0

.section .text
.global _start
_start:
    push $item_list     # push list address as function param
    call find_max       # call the find_max function
    sub $8, %esp        # take the function param off the stack

    mov %rax, %rbx      # rbx = result
    mov $1, %rax        # syscall exit
    int $0x80           # syscall

# function  find_max
# param1    address of 4-byte long elements terminated with 0
# eax       max value found so far
# ebx       currently examined item value
.type find_max, @function
find_max:
    push %rbp
    mov %rsp, %rbp

    mov 16(%rbp), %rdi  # rdi = &item_list[0]
    movl (%rdi), %ebx   # ebx = current item
    movl %ebx, %eax     # max = current

loop_begin:
    cmpl $0, %ebx       # if current = 0, finish the function with result 0
    je find_max_end

    add $4, %rdi        # move on to the next item
    movl (%rdi), %ebx   # ebx = current item value
    cmpl %ebx, %eax     # max > current item, repeat the loop
    jg loop_begin

    movl %ebx, %eax     # new max found; remember it in eax
    jmp loop_begin      # repeat the loop


find_max_end:
    mov %rbp, %rsp
    pop %rbp
    ret
