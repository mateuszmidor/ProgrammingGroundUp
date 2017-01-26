.section .data
data_items:
.long 3,67,34,222,45,75,54,34,44,33,22,11,66,0 # 0 is the list sentinel

.section .text

# eax   Current data item
# ebx   Maximum data item found
# edi   Current index of data item being examined

.global _start
_start:
    movl $0, %edi                   # index = 0
    movl data_items(,%edi, 4), %eax # current = data_items[0]
    movl %eax, %ebx                 # max = current

start_loop:
    cmpl $0, %eax                   # if (current == 0) break
    je loop_exit

    incl %edi                       # index++
    movl data_items(,%edi, 4), %eax # current = data_items[index]
    cmpl %ebx, %eax                 # if (current <= max) continue
    jle start_loop

    movl %eax, %ebx                 # max = current
    jmp start_loop                  # repeat the loop

loop_exit:
    movl $1, %eax   # "exit" system call
    int $0x80       # do exit, max number carried on ebx as exit code
