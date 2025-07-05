# ===============================
# libopencm3 + CMake Makefile
# ===============================

# Default configuration
CONFIG ?= Debug

ifeq ($(CONFIG),Debug)
BUILD_DIR := $(CURDIR)/build
else
BUILD_DIR := $(CURDIR)/build/$(CONFIG)
endif

SOURCE_DIR := $(CURDIR)

TOOLCHAIN_FILE := $(SOURCE_DIR)/cmake/gcc-arm-none-eabi.cmake

BIN_FILE   := $(BUILD_DIR)/stm32_firmware.bin
FLASH_ADDR := 0x08008000
SERIAL     := /dev/ttyUSB0
BAUD       := 115200

# Default target
all: build

# Configure the project
configure:
	cmake -S $(SOURCE_DIR) -B $(BUILD_DIR) \
		-G Ninja \
		-DCMAKE_TOOLCHAIN_FILE=$(TOOLCHAIN_FILE) \
		-DCMAKE_BUILD_TYPE=$(CONFIG)


# Build the project
build: configure
	cmake --build $(BUILD_DIR)

# Remove build directory
clean:
	rm -rf $(BUILD_DIR)

# Clean and rebuild
rebuild: clean build

size:
	arm-none-eabi-size -A $(BUILD_DIR)/stm32_firmware.elf

# Flash via DFU
flash: $(BIN_FILE)
	@echo "Flashing with dfu-util..."
	@sudo dfu-util -a 0 -s $(FLASH_ADDR):leave -D $(BIN_FILE)

# Open serial monitor
serial:
	@echo "Starting serial monitor on $(SERIAL) at $(BAUD) baud..."
	@stdbuf -oL pyserial-miniterm $(SERIAL) $(BAUD) --raw 2>/dev/null | \
        awk '{ printf "\033[32m[%s]\033[0m %s\n", strftime("%H:%M:%S"), $$0; fflush(); }'

# Help message
help:
	@echo "Usage:"
	@echo "  make build     # Build"
	@echo "  make clean     # Clean build folder"
	@echo "  make rebuild   # Clean and rebuild"
	@echo "  make size      # Show firmware size"
	@echo "  make flash     # Flash firmware via DFU"
	@echo "  make serial    # Open serial monitor"

.PHONY: all configure build clean rebuild size flash serial help
