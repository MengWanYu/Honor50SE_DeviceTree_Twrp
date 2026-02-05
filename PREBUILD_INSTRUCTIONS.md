# Prebuilt Files Preparation Instructions for Honor 50 SE (JLH-AN00)

## Required Prebuilt Files

Before building TWRP or OrangeFox Recovery, you need to prepare the following prebuilt files:

```
prebuilt/
├── kernel          # Prebuilt kernel Image.gz-dtb
└── dtb/
    └── mt6877-jlh-an00.dtb  # Device tree blob
```

## Source Files Location

The source files are located in:
```
C:\Users\Administrator\Desktop\iflow\extracted_images\
```

## Files Available

From the extracted images, you have:
- `boot_a.img` - Boot kernel image (30MB)
- `recovery_a.img` - Recovery kernel image (45MB)
- `recovery_ramdisk_a.img` - Recovery ramdisk (32MB)
- `recovery_vendor_a.img` - Recovery vendor partition (24MB)
- `vendor_boot_a.img` - Vendor boot image (64MB)
- `ramdisk_a.img` - Ramdisk image (2MB)

## Extraction Instructions

### Option 1: Extract from boot_a.img (Recommended for TWRP)

1. **Install MagiskBoot**:
   ```bash
   # Download magiskboot from: https://github.com/topjohnwu/Magisk/releases
   # Place magiskboot.exe in the same directory as the images
   ```

2. **Extract kernel from boot_a.img**:
   ```bash
   cd C:\Users\Administrator\Desktop\iflow\extracted_images
   magiskboot.exe unpack boot_a.img

   # The extraction will create:
   # - kernel  -> Copy to twrp_jlh_an00/prebuilt/kernel
   # - dtb     -> Copy to twrp_jlh_an00/prebuilt/dtb/mt6877-jlh-an00.dtb
   ```

3. **Copy the extracted files**:
   ```bash
   copy kernel C:\Users\Administrator\Desktop\iflow\twrp_jlh_an00\prebuilt\kernel
   copy dtb C:\Users\Administrator\Desktop\iflow\twrp_jlh_an00\prebuilt\dtb\mt6877-jlh-an00.dtb
   ```

### Option 2: Extract from recovery_a.img (For OrangeFox)

1. **Extract kernel from recovery_a.img**:
   ```bash
   cd C:\Users\Administrator\Desktop\iflow\extracted_images
   magiskboot.exe unpack recovery_a.img

   # The extraction will create:
   # - kernel  -> Copy to twrp_jlh_an00/prebuilt/kernel
   # - dtb     -> Copy to twrp_jlh_an00/prebuilt/dtb/mt6877-jlh-an00.dtb
   # - ramdisk -> Contains recovery ramdisk
   ```

2. **Copy the extracted files**:
   ```bash
   copy kernel C:\Users\Administrator\Desktop\iflow\twrp_jlh_an00\prebuilt\kernel
   copy dtb C:\Users\Administrator\Desktop\iflow\twrp_jlh_an00\prebuilt\dtb\mt6877-jlh-an00.dtb
   ```

### Option 3: Extract from vendor_boot_a.img (Alternative)

1. **Extract from vendor_boot_a.img**:
   ```bash
   cd C:\Users\Administrator\Desktop\iflow\extracted_images
   magiskboot.exe unpack vendor_boot_a.img

   # Extract vendor dtb if present
   copy dtb C:\Users\Administrator\Desktop\iflow\twrp_jlh_an00\prebuilt\dtb\mt6877-jlh-an00.dtb
   ```

## Build from Kernel Source (Advanced)

If you want to build the kernel from source:

1. **Navigate to kernel source**:
   ```bash
   cd C:\Users\Administrator\Desktop\iflow\Code_Opensource\kernel
   ```

2. **Configure and build**:
   ```bash
   # Set architecture
   export ARCH=arm64
   export CROSS_COMPILE=aarch64-linux-android-

   # Use the defconfig for Honor 50 SE
   make k6877v1_64_defconfig

   # Build kernel
   make Image.gz-dtb -j8

   # Build device tree
   make dtbs

   # Copy the built files
   cp arch/arm64/boot/Image.gz C:\Users\Administrator\Desktop\iflow\twrp_jlh_an00\prebuilt\kernel
   cp arch/arm64/boot/dts/mediatek/mt6877-jlh-an00.dtb C:\Users\Administrator\Desktop\iflow\twrp_jlh_an00\prebuilt\dtb\mt6877-jlh-an00.dtb
   ```

## Verification

After extraction, verify the files:

```bash
# Check kernel file size (should be around 10-30MB)
dir C:\Users\Administrator\Desktop\iflow\twrp_jlh_an00\prebuilt\kernel

# Check DTB file size (should be around 100-500KB)
dir C:\Users\Administrator\Desktop\iflow\twrp_jlh_an00\prebuilt\dtb\mt6877-jlh-an00.dtb
```

## Build Commands

Once prebuilt files are ready, you can build:

### Build TWRP:
```bash
cd <android_source_root>
source build/envsetup.sh
lunch twrp_jlhs-eng
mka recoveryimage
```

### Build OrangeFox:
```bash
cd <android_source_root>
source build/envsetup.sh
lunch ofox_jlhs-eng
mka recoveryimage
```

## Output Location

The recovery images will be output to:
```
out/target/product/jlhs/recovery.img
```

## Troubleshooting

### Kernel not found:
- Ensure you extracted from the correct image (boot_a.img or recovery_a.img)
- Verify magiskboot is properly installed
- Check that the extraction was successful

### DTB not found:
- Some images have DTB embedded in the kernel
- Use magiskboot to verify contents: `magiskboot.exe unpack boot_a.img`
- If DTB is embedded, use `magiskboot.exe dtb boot_a.img` to extract

### Build fails:
- Verify all prebuilt files are present
- Check file permissions
- Ensure kernel architecture matches (arm64)

## Additional Resources

- MagiskBoot: https://github.com/topjohnwu/Magisk/releases
- TWRP Documentation: https://twrp.me/
- OrangeFox Documentation: https://orangefox.org/

## Notes

- Always backup your original images before extraction
- Use the kernel from the same Android version as your target recovery
- For Honor 50 SE, the recommended source is `boot_a.img` for TWRP and `recovery_a.img` for OrangeFox
- The device uses A/B partitions, ensure you use the _a partition files