# dont provide C bootstrap _start() function; we will provide our own written in assembly
# because we call stdlib "puts" function, we need to keep linking stdlib into the binary
set(CMAKE_EXE_LINKER_FLAGS " -nostartfiles") 

# use gcc driver to compile assembly file and link the executable
add_executable(func_int2str "func_int2str.s")