# STM32F411CEU6 Firmware (Black Pill) with CMake + libopencm3

This project provides a minimal and modern firmware setup for the **STM32F411CEU6** (Black Pill) development board using:

* ✅ [libopencm3](https://github.com/libopencm3/libopencm3)
* ✅ CMake-based build system
* ✅ ARM GCC toolchain (`arm-none-eabi-gcc`)
* ✅ Neovim + clangd-compatible (`compile_commands.json`)

---

## 🔧 Requirements

To build and flash this project, install the following tools:

* [ARM GNU Toolchain](https://developer.arm.com/downloads/-/gnu-rm)

  * `arm-none-eabi-gcc`
  * `arm-none-eabi-objcopy`
  * `arm-none-eabi-size`
* `cmake >= 3.15`
* `make` (GNU Make, required by libopencm3 build system)
* [libopencm3](https://github.com/libopencm3/libopencm3) (included as a submodule or manually cloned)
* Optional: `pyserial` (for serial monitor)

---

## 📁 Project Structure

```txt
stm32_firmware/
├── build/                      # CMake build output
│   └── compile_commands.json   # For clangd, Neovim LSP
├── cmake/                      # CMake toolchain file
│   └── gcc-arm-none-eabi.cmake
├── libopencm3/                 # libopencm3 source (submodule or copied)
├── src/                        # Source files
│   └── main.c                  # Main application
├── CMakeLists.txt              # Main CMake configuration
├── stm32f411xx.ld              # Linker script for STM32F411CEU6
└── Makefile                    # Optional: wrapper for build flash serial...
```

---

## 🛠️ Build Instructions

### 1. Clone with Submodules

```bash
git clone --recurse-submodules https://github.com/libopencm3/libopencm3.git
```

### 2. Build the Project

```bash
mkdir -p build && cd build
cmake ..
make
```

**This will:**

* Build `libopencm3` using GNU Make
* Compile your firmware sources
* Generate `.elf`, `.hex`, and `.bin` output files
* Print the memory usage summary

---

## 🔄 Flashing the Firmware

### Option 1: Using ST-Link

```bash
st-flash write stm32_firmware.bin 0x8000000
```

### Option 2: Using USB DFU Mode

```bash
dfu-util -a 0 -s 0x08000000:leave -D stm32_firmware.bin
```

> 💡 Make sure BOOT0 is set high to enter DFU mode on reset.

---

## 🖨️ Serial Monitor

```bash
make serial
```

Ensure the `Makefile` contains the correct device and baud rate:

```makefile
SERIAL := /dev/ttyUSB0
BAUD := 115200
```

> ✅ Output includes real-time green timestamps for easier debugging.

---

## 💡 Features

* Minimal C + libopencm3 firmware for STM32F411CEU6
* Blinky example using onboard PC13 LED
* Clean CMake integration with external libopencm3 build
* Neovim + clangd ready via `compile_commands.json`
* Optional serial logging with timestamped output

---

## ✅ Example: `main.c`

```c
#include <libopencm3/stm32/gpio.h>
#include <libopencm3/stm32/rcc.h>

int main(void) {
    // Enable GPIOC peripheral clock
    rcc_periph_clock_enable(RCC_GPIOC);

    // Configure PC13 as output push-pull
    gpio_mode_setup(GPIOC, GPIO_MODE_OUTPUT, GPIO_PUPD_NONE, GPIO13);

    while (1) {
        gpio_toggle(GPIOC, GPIO13); // Toggle LED
        for (int i = 0; i < 1000000; i++) __asm__("nop"); // Simple delay
    }
}
```

---

## 🧠 Development Tips

* Use `target_compile_definitions()` in CMake to define macros like `STM32F4`:

```cmake
target_compile_definitions(stm32_firmware PRIVATE STM32F4)
```

* Use `compile_commands.json` for better LSP support (e.g. with Neovim or VSCode)
* To use DFU bootloader: Hold BOOT0 high during reset to enter USB DFU mode

---

## 📜 License

MIT unless otherwise noted. libopencm3 is licensed under its own terms.

---

## 🙌 Credits

* [libopencm3](https://github.com/libopencm3/libopencm3)
* [STM32F411CEU6 Black Pill - STM32 Base](https://stm32-base.org/boards/blackpill-f411ce.html)

---

## 💬 Need Help?

Open issues or discussions on the GitHub repository:  
👉 [https://github.com/riteshtheone/stm32f411ceu6_dfu_bootloader_application](https://github.com/riteshtheone/stm32f411ceu6_dfu_bootloader_application)

---
