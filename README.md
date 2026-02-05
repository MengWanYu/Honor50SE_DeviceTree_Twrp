# TWRP Device Tree for Honor 50 SE (JLH-AN00)

## Device Information

- **Device Name**: Honor 50 SE
- **Model**: JLH-AN00
- **Platform**: MediaTek MT6877 (Dimensity 900)
- **CPU**: 6x Cortex-A55 @ 2.0GHz + 2x Cortex-A76 @ 2.0GHz
- **GPU**: Mali-G57
- **Display**: 6.67" FHD+ (2400x1080) 120Hz LCD
- **Storage**: UFS
- **RAM**: 8GB
- **Battery**: 4000mAh

## Features

- Basic TWRP support
- Touchscreen support (NT36672)
- Display support (DSI LCD)
- USB debugging (MTP/ADB)
- Backup/restore functionality
- FBE (File-Based Encryption) support
- F2FS filesystem support

## Prebuilt Files Required

Before building, you need to place the following prebuilt files:

```
prebuilt/
├── kernel          # Prebuilt kernel Image.gz-dtb
└── dtb/
    └── mt6877-jlh-an00.dtb  # Device tree blob
```

### Getting Prebuilt Files

1. **Extract from stock boot.img**:
   - Use `magiskboot` or similar tools to extract from stock ROM
   - Extract kernel and dtb from boot.img

2. **Build from source**:
   - Use the provided kernel source from Honor
   - Compile with `jhld` defconfig

## Building

### Prerequisites

- Android 11+ source tree
- TWRP source tree
- Proper build environment

### Build Steps

1. Clone TWRP source:
   ```bash
   git clone https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-11
   cd platform_manifest_twrp_aosp
   repo sync
   ```

2. Copy device tree:
   ```bash
   cp -r twrp_jlh_an00 device/honor/jlhs
   ```

3. Place prebuilt files:
   ```bash
   mkdir -p device/honor/jlhs/prebuilt/dtb
   # Copy your prebuilt kernel and dtb here
   ```

4. Build:
   ```bash
   source build/envsetup.sh
   lunch twrp_jlhs-eng
   mka recoveryimage
   ```

5. Output:
   - Recovery image: `out/target/product/jlhs/recovery.img`

## Flashing

### Method 1: Fastboot (if bootloader unlocked)

```bash
fastboot flash recovery recovery.img
fastboot reboot recovery
```

### Method 2: SP Flash Tool (if bootloader locked)

1. Download SP Flash Tool
2. Load scatter file from stock ROM
3. Load recovery.img to recovery partition
4. Flash

## Partition Layout

```
/dev/block/by-name/boot        (64MB)   - Boot kernel
/dev/block/by-name/recovery    (64MB)   - Recovery kernel
/dev/block/by-name/dtbo        (4MB)    - Device tree overlay
/dev/block/by-name/super       (8.5GB)  - Super partition (dynamic partitions)
/dev/block/by-name/userdata    (110GB+) - User data
/dev/block/by-name/metadata    (16MB)   - Metadata for FBE
/dev/block/by-name/persist     (8MB)    - Persistent data
/dev/block/by-name/nvdata      (32MB)   - Calibration data
```

## Known Issues

- [ ] SELinux may not be enforcing (set to permissive)
- [ ] Some TWRP features may not work properly
- [ ] OTA updates may fail
- [ ] Decryption may not work for all variants

## Troubleshooting

### Bootloop

- Check kernel configuration
- Verify DTB matches device variant
- Check ramdisk files

### Touchscreen not working

- Verify touchscreen driver is included
- Check GPIO and interrupt configurations
- Ensure proper DTB bindings

### Display issues

- Check display resolution in BoardConfig.mk
- Verify framebuffer pixel format
- Check DSI configuration

### Decryption fails

- Ensure proper keymaster version
- Check FBE configuration
- Verify security patch level

## Source Reference

This device tree is based on:
- Honor 50 SE (JLH-AN00) kernel source
- MediaTek MT6877 reference design
- Common TWRP MediaTek device trees

## Credits

- Honor for releasing kernel source
- TWRP Team for recovery implementation
- MediaTek for platform documentation

## License

This device tree is provided as-is for educational purposes.
Use at your own risk. No warranty is provided.

## Support

For issues and questions:
- Check XDA Developers forum
- Review kernel logs (dmesg)
- Verify partition layout with `cat /proc/partitions`

## Notes

- This is a basic device tree - additional features may require further development
- Bootloader unlocking is required for fastboot flashing
- Always backup your data before flashing recovery
- Stock recovery flashing may cause boot issues if not done correctly