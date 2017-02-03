# ############################################################################################################################
# THIS PROGRAM READS INPUT FILE "source.s" INTO BUFFER, CONVERTS TO UPPER-CASE AND WRITES TO OUTPUT FILE "source_upper.s"
# ############################################################################################################################
.include "to_upper.s"

.section .data

# INPUT AND OUTPUT FILENAME. THESE SHOULD BE TAKEN FROM main argv BUT open CANNOT ACCESS THIS MEMORY FOR SOME REASON
IN_FILE_NAME: .ascii "source.s\0"
OUT_FILE_NAME: .ascii "source_upper.s\0"


# ###########
# CONSTANTS
# ###########

# LINUX SYSTEM CALL NUMBERS
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

# FILE OPEN MODES
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

# STANDARD FILE DESCRIPTORS
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# SYSTEM CALL INTERRUPT
.equ LINUX_SYSCALL, 0x80

# OTHER CONSTANTS
.equ END_OF_FILE, 0
.equ NUMBER_ARGUMENTS, 2


# ZERO - INITIALIZED DATA SECTION
.section .bss

# BUFFER - HERE WE STORE AND PROCESS TEXT FROM FILE. SHOULD NEVER EXCEED 16000
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE


.section .text

.equ ST_SIZE_RESERVE, 16 # storage for 2 filedescriptors on stack
.equ ST_FD_IN, -8       # INPUT FILE DESCRIPTOR ON STACK
.equ ST_FD_OUT, -16     # OUTPUT FILE DESCRIPTOR ON STACK
.equ ST_ARGC, 0         # NUMBER OF ARGUMENTS, 8 bytes int
.equ ST_ARGV_0, 8       # PROGRAM NAME, 8 bytes pointer
.equ ST_ARGV_1, 16      # INPUT FILE NAME, 8 bytes pointer
.equ ST_ARGV_2, 24      # OUTPUT FILE NAME, 8 bytes pointer

.global _start
_start:
    mov %rsp, %rbp              # save stack pointer
    sub $ST_SIZE_RESERVE, %rsp  # allocate 2 stack variables for 2 file descriptors


open_files:
open_fd_in:
    # OPEN INPUT FILE
    mov $SYS_OPEN, %rax         # open syscall
    #mov ST_ARGV_2(%rbp), %rbx   # input filename address. BUT open call cant access this memory location for some reason
    mov $IN_FILE_NAME, %rbx
    mov $O_RDONLY, %rcx         # open mode = read only
    mov $0666, %rdx             # file mode, actually not relevant for reading
    int $LINUX_SYSCALL          # call open

store_fd_in:
    # STORE INPUT FILE DESCRIPTOR
    mov %rax, ST_FD_IN(%rbp)    # save input file descriptor to stack variable

open_fd_out:
    # OPEN OUTPUT FILE
    mov $SYS_OPEN, %rax         # open syscall
    #mov ST_ARGV_2(%rbp), %rbx   # output filename address. BUT open call cant access this memory location for some reason
    mov $OUT_FILE_NAME, %rbx
    mov $O_CREAT_WRONLY_TRUNC, %rcx # open mode = create + write only + truncate
    mov $0666, %rdx             # file mode = read/write for everyone
    int $LINUX_SYSCALL          # call open

store_fd_out:
    # STORE OUTPUT FILE DESCRIPTOR
    mov %rax, ST_FD_OUT(%rbp)   # save output file descriptor to stack variable


read_loop_begin:
    # BEGIN MAIN LOOP
    mov $SYS_READ, %rax         # read system call
    mov ST_FD_IN(%rbp), %rbx    # input file descriptor
    mov $BUFFER_DATA, %rcx      # buffer address
    mov $BUFFER_SIZE, %rdx      # buffer size
    int $LINUX_SYSCALL          # call read

    # EXIT IF WE REACHED END OF FILE OR READ ERROR OCCURED
    cmp $END_OF_FILE, %rax      # check if open returned end of file (0) or error (<0)
    jle end_loop

continue_read_loop:
    # CONVERT THE BLOCK TO UPPER CASE
    push $BUFFER_DATA       # buffer address
    push %rax               # buffer size
    call convert_to_upper
    pop %rax                # get buffer size back to rax
    add $8, %rsp            # take buffer_data off the stack

    # WRITE THE BLOCK TO THE OUTPUT FILE
    mov %rax, %rdx          # buffer size
    mov $SYS_WRITE, %rax    # call write
    mov ST_FD_OUT(%rbp), %rbx  # output file descriptor
    mov $BUFFER_DATA, %rcx  # buffer address
    int $LINUX_SYSCALL      # do the write

    # CONTINUE THE LOOP
    jmp read_loop_begin

end_loop:
    # CLOSE THE FILES
    mov $SYS_CLOSE, %rax
    mov ST_FD_OUT(%rbp), %rbx
    int $LINUX_SYSCALL

    mov $SYS_CLOSE, %rax
    mov ST_FD_IN(%rbp), %rbx
    int $LINUX_SYSCALL

    # EXIT
    mov $SYS_EXIT, %rax
    mov $0, %rbx
    int $LINUX_SYSCALL
