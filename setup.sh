#!/bin/bash
# Setup script for Honor 50 SE (JLH-AN00) TWRP device tree

echo "=========================================="
echo "TWRP Setup for Honor 50 SE (JLH-AN00)"
echo "=========================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if in Android build environment
if [ ! -f "build/envsetup.sh" ]; then
    echo -e "${RED}Error: Not in Android source tree${NC}"
    echo "Please run this script from the root of your Android source tree"
    exit 1
fi

# Create device directory
DEVICE_DIR="device/honor/jlhs"
echo -e "${GREEN}Creating device directory...${NC}"
mkdir -p $DEVICE_DIR

# Copy files (if running from extracted location)
if [ -d "twrp_jlh_an00" ]; then
    echo -e "${GREEN}Copying device tree files...${NC}"
    cp -r twrp_jlh_an00/* $DEVICE_DIR/
    echo -e "${GREEN}Files copied to $DEVICE_DIR${NC}"
else
    echo -e "${YELLOW}Please copy the twrp_jlh_an00 directory contents to $DEVICE_DIR manually${NC}"
fi

# Create prebuilt directories
echo -e "${GREEN}Creating prebuilt directories...${NC}"
mkdir -p $DEVICE_DIR/prebuilt/dtb

# Check for prebuilt files
echo ""
echo -e "${YELLOW}Prebuilt files required:${NC}"
echo "  - $DEVICE_DIR/prebuilt/kernel (kernel Image.gz-dtb)"
echo "  - $DEVICE_DIR/prebuilt/dtb/mt6877-jlh-an00.dtb (device tree blob)"
echo ""
echo -e "${YELLOW}To extract prebuilt files from stock boot.img:${NC}"
echo "  1. Get stock boot.img from your device"
echo "  2. Use magiskboot to extract: magiskboot unpack boot.img"
echo "  3. Copy kernel to prebuilt/kernel"
echo "  4. Copy dtb to prebuilt/dtb/mt6877-jlh-an00.dtb"
echo ""

# Check if prebuilt files exist
if [ -f "$DEVICE_DIR/prebuilt/kernel" ]; then
    echo -e "${GREEN}✓ Kernel found${NC}"
else
    echo -e "${RED}✗ Kernel not found${NC}"
fi

if [ -f "$DEVICE_DIR/prebuilt/dtb/mt6877-jlh-an00.dtb" ]; then
    echo -e "${GREEN}✓ DTB found${NC}"
else
    echo -e "${RED}✗ DTB not found${NC}"
fi

echo ""
echo -e "${GREEN}Setup complete!${NC}"
echo ""
echo -e "${YELLOW}To build TWRP:${NC}"
echo "  source build/envsetup.sh"
echo "  lunch twrp_jlhs-eng"
echo "  mka recoveryimage"
echo ""
echo -e "${YELLOW}Output will be in:${NC}"
echo "  out/target/product/jlhs/recovery.img"