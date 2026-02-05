# 荣耀50 SE (JLH-AN00) Kernel 源码分析报告

## 设备信息

- **设备名称**: Honor 50 SE (JLH-AN00)
- **平台**: MediaTek MT6877 (Dimensity 900)
- **SoC**: MT6877
- **CPU**: 6x Cortex-A55 @ 2.0GHz + 2x Cortex-A76 @ 2.0GHz
- **GPU**: Mali-G57 (Valhall r25p0)
- **架构**: ARM64 (aarch64)

## 1. 内核配置分析

### 1.1 基本配置

**配置文件**: `arch/arm64/configs/k6877v1_64_defconfig`

**关键配置项**:

```makefile
# 架构和编译器
CONFIG_CROSS_COMPILE="aarch64-linux-android-"
CONFIG_ARCH_MTK_PROJECT="k6877v1_64"

# SoC支持
CONFIG_MACH_MT6877=y
CONFIG_MTK_PLATFORM="mt6853"

# CPU配置
CONFIG_NR_CPUS=8
CONFIG_PREEMPT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_HMP=y

# 内存管理
CONFIG_ZRAM=y
CONFIG_ION=y
CONFIG_MTK_ION=y
CONFIG_HYPERHOLD=y
```

### 1.2 启动参数

```bash
console=tty0 console=ttyMT3,921600n1 root=/dev/ram vmalloc=496M slub_max_order=0 slub_debug=O
```

## 2. 显示子系统分析

### 2.1 DRM 驱动

**位置**: `drivers/gpu/drm/mediatek/`

**支持的显示组件**:

| 组件 | 兼容字符串 | 说明 |
|------|-----------|------|
| OVL | mediatek,mt6877-disp-ovl | Overlay层 |
| RDMA | mediatek,mt6877-disp-rdma | DMA读取 |
| WDMA | mediatek,mt6877-disp-wdma | DMA写入 |
| COLOR | mediatek,mt6877-disp-color | 颜色处理 |
| AAL | mediatek,mt6877-disp-aal | 自适应环境光 |
| GAMMA | mediatek,mt6877-disp-gamma | Gamma校正 |
| C-CORR | mediatek,mt6877-disp-ccorr | 色彩校正 |
| DSI | mediatek,mt6877-dsi | MIPI DSI接口 |
| DPI | mediatek,mt6877-dpi | 并行接口 |
| MUTEX | mediatek,mt6877-disp-mutex | 显示互斥器 |
| MMSYS | mediatek,mt6877-mmsys | 内存管理系统 |

### 2.2 面板驱动

**位置**: `drivers/gpu/drm/panel/`

**荣耀50 SE使用的主要面板**:

1. **NT36672系列面板**:
   - `panel-jdi-nt36672c-cphy-vdo.c` - JDI NT36672C VDO模式
   - `panel-tianma-nt36672c-cphy-vdo.c` - 天马NT36672C VDO模式
   - `panel-alpha-jdi-nt36672c-cphy-vdo.c` - Alpha JDI NT36672C
   - `panel-alpha-tianma-nt36672c-cphy-vdo.c` - Alpha 天马NT36672C
   - `panel-sc-nt36672c-vdo-60hz.c` - SC 60Hz NT36672C
   - `panel-sc-nt36672c-vdo-90hz.c` - SC 90Hz NT36672C
   - `panel-sc-nt36672c-vdo-120hz.c` - SC 120Hz NT36672C

2. **TRULY面板**:
   - `panel-truly-nt35595-cmd.c` - Truly NT35595 CMD模式
   - `panel-truly-nt35595-vdo.c` - Truly NT35595 VDO模式
   - `panel-truly-td4330-cmd.c` - Truly TD4330 CMD模式
   - `panel-truly-td4330-vdo.c` - Truly TD4330 VDO模式

**设备树配置**:
```
&chosen {
    atag,videolfb-fps = <6000>;        // 60fps
    atag,videolfb-vramSize = <0x1be0000>; // VRAM大小
    atag,videolfb-lcmname = "nt35595_fhd_dsi_cmd_truly_nt50358_drv";
}
```

**显示规格**:
- 分辨率: 1080 x 2400 (FHD+)
- 刷新率: 60Hz/90Hz/120Hz
- 接口: MIPI DSI
- 面板类型: LCD

### 2.3 背光控制

**背光IC支持**:
- KTZ8864 (Kioxia)
- LM36274 (TI)
- RT4831 (Richtek)

**配置**:
```dts
&i2c6 {
    ktz,ktz8864@11 {
        compatible = "ktz,ktz8864";
        reg = <0x11>;
        ktz8864_bl_max_level = <2047>;
        ktz8864_hw_en_gpio = <107>;
    }
}
```

## 3. 触摸屏驱动分析

### 3.1 GT9896S 触摸屏

**位置**: `drivers/input/touchscreen/GT9896S/`

**主要文件**:
- `goodix_ts_core.c` - 核心驱动
- `goodix_ts_spi.c` - SPI接口
- `goodix_gtx8_update.c` - 固件更新
- `goodix_cfg_bin.c` - 配置二进制
- `goodix_ts_tools.c` - 测试工具

**驱动模块**:
```makefile
obj-y += goodix_ts_spi.o
obj-y += goodix_ts_core.o
obj-y += goodix_cfg_bin.o
obj-y += goodix_gtx8_update.o
```

**配置参数**:
```dts
touchscreen@0 {
    compatible = "custom_o,tp_noflash";
    spi-max-frequency = <4800000>;  // 4.8MHz
    irq-gpio = <&pio 14 0x2002>;
    touchpanel,max-num-support = <10>;
    touchpanel,tx-rx-num = <16 36>;
    touchpanel,panel-coords = <1080 2400>;
}
```

**支持的功能**:
- 触摸点数: 10点
- 黑屏手势
- 充电泵支持
- ESD处理
- 游戏模式
- 压力检测

### 3.2 NT36672C 触摸屏

**位置**: `drivers/input/touchscreen/NT36672C/`

**主要文件**:
- `nt36xxx.c` - 核心驱动
- `nt36xxx_fw_update.c` - 固件更新
- `nt36xxx_ext_proc.c` - 扩展处理
- `nt36xxx_mp_ctrlram.c` - 测试模式

**兼容字符串**:
```
"novatek,NVT-ts-spi"
```

## 4. 存储子系统分析

### 4.1 UFS 驱动

**位置**: `drivers/scsi/ufs/`

**主要文件**:
- `ufs-mtk.c` - MediaTek UFS控制器
- `ufs-mtk-block.c` - 块设备层
- `ufs-mtk-dbg.c` - 调试支持
- `ufshcd.c` - UFS主机控制器驱动
- `ufsfeature.c` - UFS特性
- `ufshpb.c` - UFS Host Performance Booster

**支持的特性**:
- UFS 3.1
- 硬件加密
- 热保存
- 写入缓存

**设备树配置**:
```dts
&ufshci {
    ufs-no-tw;  // 无写入提升
}
```

### 4.2 EMMC/SD卡

**配置**:
```dts
&msdc0 {
    host_function = <MSDC_EMMC>;
    bus-width = <8>;
    max-frequency = <200000000>;  // 200MHz
    mmc-hs400-1_8v;
    bootable;
}

&msdc1 {
    host_function = <MSDC_SD>;
    bus-width = <4>;
    max-frequency = <200000000>;
}
```

## 5. 内存配置

### 5.1 内存布局

**设备树配置**:
```dts
memory {
    device_type = "memory";
    reg = <0 0x40000000 0 0x3e605000>;  // 约1GB
}
```

### 5.2 保留内存

| 区域 | 大小 | 用途 |
|------|------|------|
| mcupm_share | 2MB/6MB | MCU电源管理共享 |
| sspm_share | 1MB/5MB | 安全系统电源管理 |
| scp_share | 1.5MB/3MB | 系统控制处理器 |
| adsp_share | 16MB | 音频DSP |
| consys | 7.5MB | 连接系统 |
| wifi_mem | 15.2MB | Wi-Fi内存 |
| gps | 1MB | GPS |

**保留内存总大小**: 约50-60MB

## 6. 电源管理

### 6.1 PMIC (电源管理IC)

**主PMIC**: MT6359P
**子PMIC**: MT6315
**充电芯片**: MT6360 PMU

**配置**:
```makefile
CONFIG_MTK_PMIC_COMMON=y
CONFIG_MTK_PMIC_CHIP_MT6359P=y
CONFIG_MFD_MT6358=y
CONFIG_REGULATOR_MT6359P=y
CONFIG_REGULATOR_MT6315=y
```

### 6.2 充电系统

**支持的充电芯片**:
- RT9466
- RT9471
- RT9759
- BQ25970
- LTC7820
- SM5450
- SC8545

**充电特性**:
- 快充支持 (FCP/SCP/PD)
- 双路充电
- 动态MIVR
- 温度保护
- JEITA温度管理

### 6.3 电池管理

**电池芯片**:
- BQ27Z561 (电量计)
- RT9426 (电量计)
- CW2217 (电量计)

**配置**:
```makefile
CONFIG_HUAWEI_BATTERY_SOH=y
CONFIG_HUAWEI_BATTERY_TEMP=y
CONFIG_HUAWEI_COUL=y
CONFIG_HUAWEI_BATTERY_CORE=y
```

## 7. 连接系统

### 7.1 Wi-Fi

**芯片**: MediaTek MT6877 Combo

**配置**:
```makefile
CONFIG_MTK_COMBO=y
CONFIG_MTK_COMBO_CHIP_CONSYS_6877=y
CONFIG_MTK_COMBO_WIFI=y
CONFIG_HUAWEI_WIFI=y
```

### 7.2 蓝牙

**配置**:
```makefile
CONFIG_MTK_COMBO_BT=y
CONFIG_BT=y
CONFIG_MTK_BTIF=y
```

### 7.3 GPS

**配置**:
```makefile
CONFIG_MTK_COMBO_GPS=y
CONFIG_MTK_GPS_SUPPORT=y
```

### 7.4 FM收音机

**配置**:
```makefile
CONFIG_MTK_FMRADIO=y
CONFIG_MTK_FM_CHIP="MT6635_FM"
```

## 8. 摄像头系统

### 8.1 支持的传感器

**配置**:
```makefile
CONFIG_CUSTOM_KERNEL_IMGSENSOR="imx586_mipi_raw imx576_mipi_raw s5k3m5sx_mipi_raw imx481_mipi_raw imx519_mipi_raw imx398_mipi_raw imx350_mipi_raw s5k2l7_mipi_raw imx386_mipi_raw imx386_mipi_mono s5k2t7sp_mipi_raw imx499_mipi_raw s5kjd1_mipi_raw"
```

### 8.2 ISP支持

**配置**:
```makefile
CONFIG_MTK_CAMERA_ISP_RSC_SUPPORT=y
CONFIG_MTK_CAMERA_ISP_DPE_SUPPORT=y
CONFIG_MTK_CAMERA_ISP_FD_SUPPORT=y
CONFIG_MTK_CAMERA_ISP_WPE_SUPPORT=y
CONFIG_MTK_CAMERA_ISP_MFB_SUPPORT=y
CONFIG_MTK_CAMERA_ISP_PDA_SUPPORT=y
```

## 9. 音频系统

### 9.1 音频架构

**位置**: `sound/soc/mediatek/`

**配置**:
```makefile
CONFIG_SND_SOC_MT6877_MT6359=y
CONFIG_SND_SOC_MTK_BTCVSD=y
CONFIG_SND_SOC_MTK_AUDIO_DSP=y
CONFIG_SND_SOC_RT5512=y
```

### 9.2 智能功放

**配置**:
```makefile
CONFIG_HUAWEI_SMARTPAKIT_AUDIO=y
CONFIG_SND_SOC_AW882XX=y
CONFIG_CS35LXX=y
CONFIG_CS35AXX=y
```

## 10. 传感器系统

### 10.1 支持的传感器

**配置**:
```makefile
CONFIG_CUSTOM_KERNEL_ACCELEROMETER=y
CONFIG_CUSTOM_KERNEL_ALSPS=y
CONFIG_CUSTOM_KERNEL_GYROSCOPE=y
CONFIG_CUSTOM_KERNEL_MAGNETOMETER=y
CONFIG_CUSTOM_KERNEL_BAROMETER=y
CONFIG_CUSTOM_KERNEL_STEP_COUNTER=y
CONFIG_CUSTOM_KERNEL_SENSORHUB=y
```

### 10.2 传感器架构

**配置**:
```makefile
CONFIG_MTK_SENSOR_SUPPORT=y
CONFIG_MTK_SENSOR_ARCHITECTURE="2.0"
CONFIG_HUAWEI_SENSORS_2_0=y
```

## 11. 指纹识别

**配置**:
```makefile
CONFIG_HONOR_FINGERPRINT_SUPPORT=y
```

**设备树位置**: `arch/arm64/boot/dts/mediatek/hihonor_fpkit/jlh/`

## 12. GPU配置

**GPU**: Mali-G57 Valhall r25p0

**配置**:
```makefile
CONFIG_MTK_GPU_SUPPORT=y
CONFIG_MTK_GPU_VERSION="mali valhall r25p0"
CONFIG_MTK_GPU_COMMON_DVFS_SUPPORT=y
CONFIG_MTK_GPU_SWPM_SUPPORT=y
```

**固件**:
```
valhall-1691526.wa
```

## 13. VPU/APU系统

**配置**:
```makefile
CONFIG_MTK_APUSYS_SUPPORT=y
CONFIG_MTK_APUSYS_MDLA_SUPPORT=y
CONFIG_MTK_VPU_SUPPORT=y
CONFIG_MTK_APU=y
```

## 14. 加密和安全

### 14.1 硬件加密

**配置**:
```makefile
CONFIG_MMC_CRYPTO=y
CONFIG_BLK_INLINE_ENCRYPTION=y
CONFIG_SCSI_UFS_CRYPTO=y
CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
```

### 14.2 TEE (可信执行环境)

**配置**:
```makefile
CONFIG_TZDRIVER=y
CONFIG_TEECD_AUTH=y
CONFIG_TEE_LOG_ACHIVE_PATH="/data/log/tee/last_teemsg"
CONFIG_MTK_ENABLE_GENIEZONE=y
```

### 14.3 模块签名

**配置**:
```makefile
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_SHA512=y
```

### 14.4 内核加固

**配置**:
```makefile
CONFIG_CFI=y
CONFIG_CFI_CLANG=y
CONFIG_SLUB_FREELIST_RANDOM=y
CONFIG_SLAB_FREELIST_RANDOM=y
```

## 15. 网络协议栈

**配置**:
```makefile
CONFIG_BRIDGE=y
CONFIG_VLAN_8021Q=y
CONFIG_PPP=y
CONFIG_PPPOE=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
```

**华为网络增强**:
```makefile
CONFIG_HUAWEI_BASTET_MTK=y
CONFIG_HUAWEI_EMCOM=y
CONFIG_HW_NETWORK_QOE=y
CONFIG_HW_BOOSTER=y
```

## 16. 文件系统

**配置**:
```makefile
CONFIG_STAGING_EXFAT_FS=y
CONFIG_EROFS_FS=y
CONFIG_F2FS_FS=y
CONFIG_EXT4_FS=y
CONFIG_CIFS=y
CONFIG_INCREMENTAL_FS=y
CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
```

## 17. 内核版本信息

**Linux内核版本**: 5.10.x (基于defconfig推断)

**Android版本**: Android 11/12

**编译器**: aarch64-linux-android-4.9

## 18. TWRP相关的关键配置

### 18.1 启动分区

**配置**:
```makefile
CONFIG_BUILD_ARM64_APPENDED_DTB_IMAGE=y
CONFIG_BUILD_ARM64_APPENDED_DTB_IMAGE_NAMES="mediatek/mt6877"
```

### 18.2 内存要求

- 内核代码: 约30-40MB
- 内存保留: 约50-60MB
- 可用内存: 约7GB+

### 18.3 TWRP需要的关键驱动

✅ **显示驱动**:
- DRM/KMS
- MIPI DSI
- 面板驱动 (NT36672/NT35595)
- 背光控制

✅ **触摸屏驱动**:
- GT9896S
- NT36672C

✅ **存储驱动**:
- UFS
- EMMC
- F2FS/EXT4
- 加密支持

✅ **USB驱动**:
- USB Gadget
- MTP/ADB

✅ **输入设备**:
- 键盘 (音量键)
- 振动

⚠️ **可能需要额外配置的**:
- 解密 (FBE)
- 安全启动绕过
- SELinux配置

## 19. 编译说明

### 19.1 工具链要求

```bash
CROSS_COMPILE=aarch64-linux-android-4.9
```

### 19.2 编译命令

```bash
# 配置
make ARCH=arm64 k6877v1_64_defconfig

# 编译
make ARCH=arm64 Image.gz -j8

# 输出文件
# arch/arm64/boot/Image.gz
# arch/arm64/boot/dts/mediatek/mt6877-jlh-an00.dtb
```

### 19.3 清理命令

```bash
make ARCH=arm64 distclean
```

## 20. 总结

荣耀50 SE (JLH-AN00) 的内核源码完整包含了所有必要的驱动和配置，支持TWRP的基本功能：

**优势**:
- ✅ 完整的DRM显示驱动
- ✅ 多种触摸屏驱动支持
- ✅ UFS/EMMC存储驱动
- ✅ 硬件加密支持
- ✅ USB gadget支持
- ✅ 完整的设备树配置

**挑战**:
- ⚠️ 需要正确处理FBE加密
- ⚠️ 安全启动可能需要绕过
- ⚠️ SELinux需要配置为permissive
- ⚠️ 部分专有驱动可能需要适配

**建议**:
1. 使用预编译的内核和DTB从stock ROM提取
2. 重点配置FBE解密
3. 测试显示和触摸屏驱动
4. 验证存储加密解密功能

## 附录

### A. 关键文件位置

- 设备树: `arch/arm64/boot/dts/mediatek/hihonor_mt6877_jlh_an00_va.dts`
- 内核配置: `arch/arm64/configs/k6877v1_64_defconfig`
- 显示驱动: `drivers/gpu/drm/mediatek/`
- 触摸驱动: `drivers/input/touchscreen/GT9896S/`
- UFS驱动: `drivers/scsi/ufs/`

### B. 参考链接

- TWRP: https://twrp.me/
- MediaTek平台: https://www.mediatek.com/
- Linux内核文档: Documentation/