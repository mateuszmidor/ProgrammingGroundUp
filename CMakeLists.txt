cmake_minimum_required (VERSION 2.8)

# "ASM" below indicates to CMAKE that this is assembly language based project (.s source files)
project (ProgrammingGroundUp ASM)

set(PROJECT_MAJOR_VERSION 0)
set(PROJECT_MINOR_VERSION 1)
set(PROJECT_PATCH_LEVEL 0)

set(PROJECT_VERSION ${PROJECT_MAJOR_VERSION}.${PROJECT_MINOR_VERSION}.${PROJECT_PATCH_LEVEL})

add_subdirectory(exit)
add_subdirectory(find_max)
add_subdirectory(puts)
add_subdirectory(func_power)
add_subdirectory(func_factorial)
add_subdirectory(func_square)
add_subdirectory(func_find_max)
add_subdirectory(textfile_to_upper)
add_subdirectory(func_int2str)