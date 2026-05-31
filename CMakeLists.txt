cmake_minimum_required(VERSION 3.13)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

set(PICO_BOARD pico)
add_compile_definitions(NDEBUG)

include(pico_sdk_import.cmake)

project(FlexGPIO_ram C CXX ASM)

pico_sdk_init()

add_executable(FlexGPIO_ram
    src/custom_startup.S
    src/main.cpp
    src/i2c_flexigpio.cpp
)

target_include_directories(FlexGPIO_ram PRIVATE
    src
    ${PICO_SDK_PATH}/src/common/pico_base_headers/include
    ${PICO_SDK_PATH}/src/common/pico_stdlib_headers/include
    ${PICO_SDK_PATH}/src/rp2040/hardware_regs/include
    ${PICO_SDK_PATH}/src/rp2040/hardware_structs/include
    ${PICO_SDK_PATH}/src/rp2040/pico_platform/include
    ${PICO_SDK_PATH}/src/rp2_common/hardware_gpio/include
    ${PICO_SDK_PATH}/src/rp2_common/hardware_i2c/include
    ${PICO_SDK_PATH}/src/rp2_common/hardware_irq/include
    ${PICO_SDK_PATH}/src/rp2_common/hardware_timer/include
    ${PICO_SDK_PATH}/src/rp2_common/hardware_watchdog/include
    ${PICO_SDK_PATH}/src/rp2_common/hardware_sync/include
    ${PICO_SDK_PATH}/src/rp2_common/hardware_resets/include
    ${PICO_SDK_PATH}/src/rp2_common/hardware_clocks/include
    ${PICO_SDK_PATH}/src/rp2_common/hardware_flash/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_platform/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_platform_sections/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_i2c_slave/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_time/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_runtime/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_runtime_init/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_sync/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_util/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_stdio/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_standard_binary_info/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_clib_interface/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_bootrom/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_printf/include
    ${PICO_SDK_PATH}/src/common/pico_sync/include
    ${PICO_SDK_PATH}/src/common/pico_time/include
    ${PICO_SDK_PATH}/src/common/pico_util/include
    ${PICO_SDK_PATH}/src/common/hardware_claim/include
    ${PICO_SDK_PATH}/src/rp2_common/pico_standard_link/include
)

target_compile_options(FlexGPIO_ram PRIVATE -ffunction-sections -fdata-sections)

target_link_libraries(FlexGPIO_ram PRIVATE
    hardware_gpio
    hardware_i2c
    hardware_irq
    hardware_timer
    hardware_watchdog
    hardware_sync
    hardware_resets
    hardware_clocks
    hardware_flash
    pico_i2c_slave
    pico_time
    pico_platform
    pico_sync
    pico_util
    pico_bootrom
    pico_clib_interface
    hardware_claim
)

pico_set_linker_script(FlexGPIO_ram ${CMAKE_CURRENT_SOURCE_DIR}/src/memmap_ram.ld)
target_link_options(FlexGPIO_ram PRIVATE "-T${CMAKE_CURRENT_SOURCE_DIR}/src/memmap_ram.ld" -Wl,--gc-sections)

add_custom_command(TARGET FlexGPIO_ram POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:FlexGPIO_ram> $<TARGET_FILE_DIR:FlexGPIO_ram>/FlexGPIO_ram.bin
    COMMENT "Generating FlexGPIO_ram.bin"
)
