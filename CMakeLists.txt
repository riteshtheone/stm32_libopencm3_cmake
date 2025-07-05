cmake_minimum_required(VERSION 3.15)
project(stm32_firmware C ASM)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# -----------------------------------------------------------------------------
# Toolchain and libopencm3 paths
# -----------------------------------------------------------------------------
set(LIBOPENCM3_DIR ${CMAKE_SOURCE_DIR}/libopencm3)
set(LIBOPENCM3_LIB ${LIBOPENCM3_DIR}/lib/libopencm3_stm32f4.a)
set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/stm32f411xx.ld)

# -----------------------------------------------------------------------------
# Ensure libopencm3 is built with GNU Make, regardless of top-level generator
# -----------------------------------------------------------------------------
find_program(MAKE_EXE make REQUIRED)

add_custom_command(
    OUTPUT ${LIBOPENCM3_LIB}
    COMMAND ${MAKE_EXE} TARGETS=stm32/f4
    WORKING_DIRECTORY ${LIBOPENCM3_DIR}
    COMMENT "Building libopencm3 using GNU Make"
)

add_custom_target(libopencm3_build ALL
    DEPENDS ${LIBOPENCM3_LIB}
)

# -----------------------------------------------------------------------------
# Firmware sources and target
# -----------------------------------------------------------------------------
set(SRC_FILES
    src/main.c
)

add_executable(${PROJECT_NAME} ${SRC_FILES})
add_dependencies(${PROJECT_NAME} libopencm3_build)

# -----------------------------------------------------------------------------
# Include directories
# -----------------------------------------------------------------------------
target_compile_definitions(${PROJECT_NAME} PRIVATE STM32F4)

target_include_directories(${PROJECT_NAME} PRIVATE
    ${LIBOPENCM3_DIR}/include
)

# -----------------------------------------------------------------------------
# Linker and libraries
# -----------------------------------------------------------------------------
target_link_libraries(${PROJECT_NAME} PRIVATE
    ${LIBOPENCM3_LIB}
)

target_link_options(${PROJECT_NAME} PRIVATE
    -nostartfiles
    -nostdlib
    -T${LINKER_SCRIPT}
    -Wl,-Map=${PROJECT_NAME}.map
    -Wl,--gc-sections
    -Wl,--start-group
        ${LIBOPENCM3_LIB}
        -lc -lm
    -Wl,--end-group
    -Wl,--print-memory-usage
)

# -----------------------------------------------------------------------------
# Post-build: generate .hex, .bin, and print size
# -----------------------------------------------------------------------------
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin
    COMMAND ${CMAKE_SIZE} ${PROJECT_NAME}.elf
    COMMENT "Generating HEX/BIN and printing size"
)
