.section .data
data_items_begin:
    .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0,250
data_items_end: # this is our list end sentinel


.section .text

# eax   Current data item
# ebx   Maximum data item found
# edi   Current data item ptr

.global _start
_start:
    movl $data_items_begin, %edi    # ptr = &data_items_begin[0]
    movl (%edi), %eax               # current = *ptr
    movl %eax, %ebx                 # max = current

start_loop:
    cmpl $data_items_end, %edi      # if (ptr >= sentinel) break
    jge loop_exit

    addl $4, %edi                   # ptr += 4 bytes
    movl (%edi), %eax               # current = *ptr
    cmpl %ebx, %eax                 # if (current <= max) continue
    jle start_loop

    movl %eax, %ebx                 # max = current
    jmp start_loop                  # repeat the loop

loop_exit:
    movl $1, %eax   # "exit" system call
    int $0x80       # do exit, max number carried on ebx as exit code
