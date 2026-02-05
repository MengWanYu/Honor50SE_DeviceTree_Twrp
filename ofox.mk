# OrangeFox Recovery configuration for Honor 50 SE (JLH-AN00)
# Note: This file contains only OrangeFox specific configurations
# Android base configurations should be inherited in the product makefile

# OrangeFox specific properties
OF_MAINTAINER := "Community"
OF_FLASHLIGHT_ENABLE := true
OF_NO_TWRP_BUILD := true
OF_DONT_PATCH_ENCRYPTED_DEVICE := true
OF_OVERCLOCKS_PROCESSOR := false
OF_USE_GREEN_LED := false
OF_SKIP_FBE_METADATA_DECRYPT := false
OF_DISABLE_DM_VERITY := true
OF_USE_MAGISKBOOT := true
OF_USE_GREEN_LED := false
OF_USE_QCOM_BSP := false
OF_USE_LEGACY_KEYMASTER := false
OF_USE_F2FS := true
OF_USE_NTFS := true
OF_USE_EXFAT := true
OF_USE_HFSPLUS := true
OF_USE_F2FS := true
OF_USE_NTFS := true
OF_USE_EXFAT := true
OF_USE_HFSPLUS := true

# OrangeFox version info
OF_VERSION_MAJOR := 11
OF_VERSION_MINOR := 1
OF_VERSION_MAINTENANCE := 0

# OrangeFox GUI settings
OF_SCREEN_H := 2400
OF_SCREEN_W := 1080
OF_ALLOW_DISABLE_NAVBAR := true
OF_CLOCK_POS := 2
OF_STATUSBAR_POS := 2
OF_STATUSBAR_CLOCK_POS := 0
OF_STATUSBAR_LOGO := true
OF_STATUSBAR_CLOCK_COLOR := "#FFFFFF"
OF_STATUSBAR_BATTERY_COLOR := "#FFFFFF"
OF_STATUSBAR_BATTERY_PERCENT_COLOR := "#FFFFFF"
OF_STATUSBAR_BATTERY_PERCENT_POS := 1
OF_STATUSBAR_STORAGE_COLOR := "#FFFFFF"
OF_STATUSBAR_STORAGE_POS := 2
OF_STATUSBAR_USB_COLOR := "#FFFFFF"
OF_STATUSBAR_USB_POS := 3
OF_STATUSBAR_LTE_COLOR := "#FFFFFF"
OF_STATUSBAR_LTE_POS := 4
OF_STATUSBAR_LTE_TEXT := "4G"
OF_STATUSBAR_BAR_COLOR := "#00000000"
OF_NAVBAR_HIDE := false
OF_NAVBAR_SHOW := true
OF_NAVBAR_POS := 1
OF_MENU_LIST_STYLE := "list"
OF_STATUSBAR_STYLE := "default"
OF_MENU_LIST_STYLE := "list"
OF_FLASHLIGHT_ENABLE := true
OF_FLASHLIGHT_PATH := "/sys/class/leds/led:switch/flashlight"
OF_BRIGHTNESS_PATH := "/sys/class/backlight/panel/brightness"
OF_MAX_BRIGHTNESS := 2047
OF_DEFAULT_BRIGHTNESS := 1200

# OrangeFox specific packages
PRODUCT_PACKAGES += \
    ofox_decrypt \
    ofox_keymaster \
    ofox_qseecomd

# OrangeFox specific init scripts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/etc/ofox.rc:$(TARGET_RECOVERY_ROOT_OUT)/etc/init/ofox.rc

# OrangeFox specific properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.orangefox.version=$(OF_VERSION_MAJOR).$(OF_VERSION_MINOR).$(OF_VERSION_MAINTENANCE) \
    ro.orangefox.device=jlhs \
    ro.orangefox.display.name=Honor 50 SE \
    ro.orangefox.cpu=mt6877 \
    ro.orangefox.board=mt6877