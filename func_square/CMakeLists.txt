# dont provide C bootstrap _start() function; we will provide our own written in assembly
set(CMAKE_EXE_LINKER_FLAGS " -nostartfiles -nostdlib") 

# use gcc driver to compile assembly file and link the executable
add_executable(func_square "func_square.s")
