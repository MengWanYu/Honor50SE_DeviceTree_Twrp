# Device: Honor 50 SE (JLH-AN00)
# Platform: MediaTek MT6877 (Dimensity 900)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from our custom product configuration
$(call inherit-product, vendor/twrp/twrp-common/common.mk)

# Device identifier
PRODUCT_DEVICE := jlhs
PRODUCT_NAME := twrp_jlhs
PRODUCT_BRAND := Honor
PRODUCT_MODEL := Honor 50 SE
PRODUCT_MANUFACTURER := HONOR

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# A/B support
AB_OTA_UPDATER := false

# Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)

# OEM Unlock reporting
PRODUCT_PROPERTY_OVERRIDES += \
    ro.oem_unlock_supported=1

# Properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.egl=mali \
    ro.hardware.vulkan=mali \
    debug.sf.nobootanimation=1 \
    persist.sys.disable_rescue=true

# Init scripts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/root/init.recovery.jlhan00.rc:$(TARGET_RECOVERY_ROOT_OUT)/etc/init.recovery.jlhan00.rc

# Additional binaries
PRODUCT_PACKAGES += \
    qcom_decrypt \
    qcom_decrypt_fbe

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml