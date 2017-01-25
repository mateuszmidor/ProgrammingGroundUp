cmake_minimum_required (VERSION 2.8)
project (ProgrammingGroundUp ASM)

set(PROJECT_MAJOR_VERSION 0)
set(PROJECT_MINOR_VERSION 1)
set(PROJECT_PATCH_LEVEL 0)

set(PROJECT_VERSION ${PROJECT_MAJOR_VERSION}.${PROJECT_MINOR_VERSION}.${PROJECT_PATCH_LEVEL})

# dont provide C bootstrap _start() function; we will provide our own written in assembly
set(CMAKE_EXE_LINKER_FLAGS " -nostartfiles -nostdlib") 

add_subdirectory(exit)