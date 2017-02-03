# dont provide C bootstrap _start() function; we will provide our own written in assembly
set(CMAKE_EXE_LINKER_FLAGS " -nostartfiles -nostdlib ") 

# use gcc driver to compile assembly file and link the executable
add_executable(textfile_to_upper "to_upper.s" "textfile_to_upper.s")
target_include_directories(textfile_to_upper PRIVATE ".")

# copy the source file to have sth to convert to upper case
configure_file("to_upper.s" "source.s" COPYONLY)