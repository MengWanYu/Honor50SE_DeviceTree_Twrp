#!/bin/bash
# Kernel extraction script for Honor 50 SE (JLH-AN00)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=========================================="
echo "Kernel Extraction for Honor 50 SE"
echo "=========================================="

# Check arguments
if [ $# -lt 1 ]; then
    echo -e "${YELLOW}Usage: $0 <path_to_boot.img>${NC}"
    echo ""
    echo "This script extracts kernel and DTB from boot.img"
    echo "and places them in the correct location for TWRP build."
    exit 1
fi

BOOT_IMG="$1"

if [ ! -f "$BOOT_IMG" ]; then
    echo -e "${RED}Error: Boot image not found: $BOOT_IMG${NC}"
    exit 1
fi

# Output directory
OUTPUT_DIR="device/honor/jlhs/prebuilt"
mkdir -p $OUTPUT_DIR/dtb

echo -e "${GREEN}Boot image found: $BOOT_IMG${NC}"
echo ""

# Check for magiskboot
if ! command -v magiskboot &> /dev/null; then
    echo -e "${YELLOW}magiskboot not found in PATH${NC}"
    echo -e "${YELLOW}Attempting to download...${NC}"
    curl -L -o magiskboot https://github.com/topjohnwu/Magisk/releases/latest/download/magiskboot
    chmod +x magiskboot
    if [ ! -f "magiskboot" ]; then
        echo -e "${RED}Failed to download magiskboot${NC}"
        echo -e "${YELLOW}Please install magiskboot manually${NC}"
        exit 1
    fi
    MAGISKBOOT="./magiskboot"
else
    MAGISKBOOT="magiskboot"
fi

# Extract boot image
echo -e "${GREEN}Extracting boot image...${NC}"
mkdir -p boot_extracted
cd boot_extracted

$MAGISKBOOT unpack ../$BOOT_IMG

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to extract boot image${NC}"
    cd ..
    rm -rf boot_extracted
    exit 1
fi

# Check for kernel
if [ -f "kernel" ]; then
    echo -e "${GREEN}✓ Kernel found${NC}"
    cp kernel ../$OUTPUT_DIR/kernel
else
    echo -e "${RED}✗ Kernel not found in boot.img${NC}"
    cd ..
    rm -rf boot_extracted
    exit 1
fi

# Check for DTB
if [ -f "dtb" ]; then
    echo -e "${GREEN}✓ DTB found${NC}"
    cp dtb ../$OUTPUT_DIR/dtb/mt6877-jlh-an00.dtb
elif [ -d "dtb" ]; then
    echo -e "${GREEN}✓ DTB directory found${NC}"
    # Check for device-specific DTB
    if [ -f "dtb/mt6877-jlh-an00.dtb" ]; then
        cp dtb/mt6877-jlh-an00.dtb ../$OUTPUT_DIR/dtb/mt6877-jlh-an00.dtb
    elif [ -f "dtb/mt6877-jlh.dtb" ]; then
        cp dtb/mt6877-jlh.dtb ../$OUTPUT_DIR/dtb/mt6877-jlh-an00.dtb
    else
        echo -e "${YELLOW}Multiple DTBs found, copying first one...${NC}"
        find dtb -name "*.dtb" -type f | head -1 | xargs -I {} cp {} ../$OUTPUT_DIR/dtb/mt6877-jlh-an00.dtb
    fi
else
    echo -e "${RED}✗ DTB not found in boot.img${NC}"
    echo -e "${YELLOW}DTB may be embedded in kernel${NC}"
fi

# Check for ramdisk
if [ -f "ramdisk.cpio" ]; then
    echo -e "${GREEN}✓ Ramdisk found${NC}"
    mkdir -p ramdisk
    cd ramdisk
    cpio -idm < ../ramdisk.cpio 2>/dev/null
    cd ..
else
    echo -e "${YELLOW}✗ Ramdisk not found${NC}"
fi

# Clean up
cd ..
rm -rf boot_extracted

echo ""
echo -e "${GREEN}Extraction complete!${NC}"
echo ""
echo -e "${YELLOW}Files extracted:${NC}"
ls -lh $OUTPUT_DIR/kernel 2>/dev/null && echo "  ✓ kernel"
ls -lh $OUTPUT_DIR/dtb/mt6877-jlh-an00.dtb 2>/dev/null && echo "  ✓ dtb"
echo ""
echo -e "${YELLOW}You can now build TWRP with:${NC}"
echo "  source build/envsetup.sh"
echo "  lunch twrp_jlhs-eng"
echo "  mka recoveryimage"