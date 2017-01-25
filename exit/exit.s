.section .data
.section .text

.global _start

_start:
movl $1, %eax   # "exit" system call
movl $4, %ebx   # 4 as return code
int $0x80       # exit(4)
