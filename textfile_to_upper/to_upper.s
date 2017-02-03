# ############################################################################################################################
# THIS MODULE EXPORTS "convert_to_upper" function
# ############################################################################################################################
.section .text

# FUNCTION convert_to_upper

# CONSTANTS
.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPERCASE_CONVERSION, 'A' - 'a'

# STACK
.equ ST_BUFFER_LEN, 16  # BUFFER LENGTH ARGUMENT POSITION RELATIVE TO EBP
.equ ST_BUFFER, 24      # ACTUAL BUFFER ADDRESS RELATIVE TO EBP

# FUNCTION: convert_to_upper
# USAGE:
# push BUFFER_ADDRESS
# push BUFFER_SIZE
# call convert_to_upper
.type  convert_to_upper, @function
convert_to_upper:
    push %rbp
    mov %rsp, %rbp

    # SETUP VARIABLES
    mov ST_BUFFER(%rbp), %rax
    mov ST_BUFFER_LEN(%rbp), %rbx
    mov $0, %rdi
    cmp $0, %rbx
    je end_convert_loop     # end the loop in case of 0-lenght buffer

convert_loop:
    movb (%rax, %rdi, 1), %cl    # get current character

    # GO TO NEXT CHARACTER IF CURRENT IS NOT LOWERCASE
    cmpb $LOWERCASE_A, %cl
    jl next_byte
    cmpb $LOWERCASE_Z, %cl
    jg next_byte

    # OTHERWISE CONVERT CHARACTER TO UPPERCASE
    addb $UPPERCASE_CONVERSION, %cl
    movb %cl, (%rax, %rdi, 1)

next_byte:
    inc %rdi            # go to next character unless we reached the end
    cmp %rdi, %rbx
    jne convert_loop

end_convert_loop:
    # NO RETURN, JUST LEAVE
    mov %rbp, %rsp
    pop %rbp
    ret
