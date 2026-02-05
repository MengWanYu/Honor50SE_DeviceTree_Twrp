# Makefile for Honor 50 SE (JLH-AN00) TWRP

.PHONY: all setup extract build clean help

DEVICE := jlhs
DEVICE_NAME := Honor 50 SE
DEVICE_DIR := device/honor/$(DEVICE)
OUTPUT := out/target/product/$(DEVICE)/recovery.img

all: help

help:
	@echo "=========================================="
	@echo "TWRP Build System for $(DEVICE_NAME)"
	@echo "=========================================="
	@echo ""
	@echo "Available targets:"
	@echo "  make setup      - Setup device tree"
	@echo "  make extract    - Extract kernel from boot.img"
	@echo "  make build      - Build TWRP recovery"
	@echo "  make clean      - Clean build output"
	@echo "  make help       - Show this help message"
	@echo ""
	@echo "Usage:"
	@echo "  make extract BOOT_IMG=/path/to/boot.img"
	@echo "  make build"

setup:
	@echo "Setting up device tree..."
	@mkdir -p $(DEVICE_DIR)
	@cp -r twrp_jlh_an00/* $(DEVICE_DIR)/
	@mkdir -p $(DEVICE_DIR)/prebuilt/dtb
	@echo "Device tree setup complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Extract kernel: make extract BOOT_IMG=/path/to/boot.img"
	@echo "  2. Build TWRP: make build"

extract:
ifndef BOOT_IMG
	@echo "Error: BOOT_IMG not specified"
	@echo "Usage: make extract BOOT_IMG=/path/to/boot.img"
	@exit 1
endif
	@echo "Extracting kernel from $(BOOT_IMG)..."
	@bash extract_kernel.sh $(BOOT_IMG)

build:
	@echo "Building TWRP for $(DEVICE_NAME)..."
	@source build/envsetup.sh && lunch twrp_$(DEVICE)-eng && mka recoveryimage
	@echo ""
	@echo "Build complete!"
	@echo "Output: $(OUTPUT)"

clean:
	@echo "Cleaning build output..."
	@rm -rf out/target/product/$(DEVICE)
	@echo "Clean complete!"

install:
ifndef OUTPUT_DIR
	@echo "Error: OUTPUT_DIR not specified"
	@echo "Usage: make install OUTPUT_DIR=/path/to/output"
	@exit 1
endif
	@echo "Installing recovery image to $(OUTPUT_DIR)..."
	@mkdir -p $(OUTPUT_DIR)
	@cp $(OUTPUT) $(OUTPUT_DIR)/
	@echo "Install complete!"
	@echo "Output: $(OUTPUT_DIR)/$(notdir $(OUTPUT))"