# Target platform
set(CMAKE_SYSTEM_NAME       Generic)
set(CMAKE_SYSTEM_PROCESSOR  arm)

# Toolchain prefix
set(TOOLCHAIN_PREFIX arm-none-eabi-)

# Toolchain binaries
set(CMAKE_C_COMPILER        ${TOOLCHAIN_PREFIX}gcc)
set(CMAKE_ASM_COMPILER      ${CMAKE_C_COMPILER})
set(CMAKE_LINKER            ${CMAKE_C_COMPILER})
set(CMAKE_OBJCOPY           ${TOOLCHAIN_PREFIX}objcopy)
set(CMAKE_SIZE              ${TOOLCHAIN_PREFIX}size)

# Avoid compiling test binaries for host
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Executable suffix
set(CMAKE_EXECUTABLE_SUFFIX_C   ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_ASM ".elf")

# CPU flags
set(TARGET_FLAGS "-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb")

# Compiler flags
set(CMAKE_C_FLAGS_INIT "${TARGET_FLAGS} -Wall -Wextra -Wpedantic -fdata-sections -ffunction-sections")
set(CMAKE_ASM_FLAGS_INIT "${TARGET_FLAGS} -x assembler-with-cpp -MMD -MP")

# Debug/release options
set(CMAKE_C_FLAGS_DEBUG   "-O0 -g3")
set(CMAKE_C_FLAGS_RELEASE "-Os -g0")

# Linker flags (set in project file instead)
