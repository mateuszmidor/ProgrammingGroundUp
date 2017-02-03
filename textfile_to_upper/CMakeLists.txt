# dont provide C bootstrap _start() function; we will provide our own written in assembly
set(CMAKE_EXE_LINKER_FLAGS " -nostartfiles -nostdlib ") 

# use gcc driver to compile assembly file and link the executable
add_executable(textfile_to_upper "textfile_to_upper.s")

# copy the source file to have sth to convert to upper case
configure_file("textfile_to_upper.s" "source.s" COPYONLY)