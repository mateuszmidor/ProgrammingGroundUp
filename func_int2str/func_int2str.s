.section .bss

# BUFFER FOR CONVERTING INT TO STRING
.equ BUFFER_SIZE, 20
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text
.global _start

_start:
    push $1234567890    # push number to be converted as input param
    push $BUFFER_DATA   # push buffer as output param
    call int2str
    add $16, %rsp        # take the 2 params off the stack

    movl $BUFFER_DATA, %edi # edi = buffer
    call puts           # puts(buffer)

    movl $1, %eax       # syscall exit
    movl $0, %ebx       # 0 as return code
    int $0x80           # exit(0)


# function  int2str
# usage     push number, push buffer, call int2str
.equ BUFFER_OFF, 16
.equ NUMBER_OFF, 24
.type int2str, @function
int2str:
    # begin function
    push %rbp
    mov %rsp, %rbp

    # initialize stuff
    mov BUFFER_OFF(%rbp), %rdi  # rdi = buffer pointer
    mov NUMBER_OFF(%rbp), %rax  # rax = number to be converted
    mov $0, %rcx                # curr digit index

# convert the number; output is digits in reverse order
conversion_loop:
    mov $0, %edx        # we calculate eax%edx = edx:eax mod ebx. stick with edx part 0 and eax containing the number
    mov $10, %ebx       # modulo 10 as converting from 10-base number

    div %ebx            # eax = quotient, edx = reminder; eax % ebx
    add $48, %dl        # dl = modulo remainder; convert digit to ascii char
    movb %dl, (%rdi, %rcx, 1)    # save char in buffer
    inc %rcx            # advance current character index
    cmp $0, %eax
    jg conversion_loop

    # reverse the digits to have correct order
    push %rcx           # push string len as input param
    push $BUFFER_DATA   # push buffer as input-output param
    call reverse_string
    add $16, %rsp       # take the 2 params off the stack


    # end function
    mov %rbp, %rsp
    pop %rbp
    mov $0, %rax
    ret


# function  reverse_string
# usage     push string_len, push buffer, call reverse_string
.equ BUFFER_OFF, 16
.equ LENGHT_OFF, 24
.type reverse_string, @function
reverse_string:
    # begin function
    push %rbp
    mov %rsp, %rbp

    # init string begin and string end pointers
    mov BUFFER_OFF(%rbp), %rsi  # rsi = string begin
    mov %rsi, %rdi              # rdi = string begin + num characters - null (1 character)
    add LENGHT_OFF(%rbp), %rdi
    dec %rdi

reversion_loop:
    # swap 2 characters
    movb (%rsi), %al
    movb (%rdi), %bl
    movb %al, (%rdi)
    movb %bl, (%rsi)

    # move pointers
    inc %rsi
    dec %rdi

    cmp %rsi, %rdi      # continue until the two pointers cross
    jg reversion_loop


    # end function
    mov %rbp, %rsp
    pop %rbp
    mov $0, %rax
    ret
