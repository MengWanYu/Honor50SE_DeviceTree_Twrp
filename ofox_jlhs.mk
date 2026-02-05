# OrangeFox Recovery for Honor 50 SE (JLH-AN00)
# Platform: MediaTek MT6877 (Dimensity 900)

# Inherit from OrangeFox configuration
$(call inherit-product, device/honor/jlhs/ofox.mk)

# Device identifier
PRODUCT_DEVICE := jlhs
PRODUCT_NAME := ofox_jlhs
PRODUCT_BRAND := Honor
PRODUCT_MODEL := Honor 50 SE
PRODUCT_MANUFACTURER := HONOR

# OrangeFox specific properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.orangefox.version=11.1.0 \
    ro.orangefox.device=jlhs \
    ro.orangefox.display.name=Honor 50 SE \
    ro.orangefox.cpu=mt6877 \
    ro.orangefox.board=mt6877

# Enable OrangeFox build
FOX_BUILD := true

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)

# OEM Unlock reporting
PRODUCT_PROPERTY_OVERRIDES += \
    ro.oem_unlock_supported=1

# Init scripts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/init.recovery.jlhan00.rc:$(TARGET_RECOVERY_ROOT_OUT)/etc/init.recovery.jlhan00.rc \
    $(LOCAL_PATH)/recovery/root/init.recovery.jlhan00.usb.rc:$(TARGET_RECOVERY_ROOT_OUT)/etc/init.recovery.jlhan00.usb.rc \
    $(LOCAL_PATH)/recovery/root/etc/ofox.rc:$(TARGET_RECOVERY_ROOT_OUT)/etc/init/ofox.rc

# Additional binaries for OrangeFox
PRODUCT_PACKAGES += \
    qcom_decrypt \
    qcom_decrypt_fbe \
    ofox_decrypt \
    ofox_keymaster

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml