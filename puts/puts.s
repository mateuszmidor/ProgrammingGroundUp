.section .data
msg:
.ascii "Halo!\0"

.section .text
.global _start

_start:
    movl $msg, %edi # edi = &msg[0]
    call puts       # puts(msg)

    movl $1, %eax
    movl $0, %ebx   # 0 as return code
    int $0x80       # exit(0)


