LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),jlhs)
include $(call all-subdir-makefiles,$(LOCAL_PATH))
endif

# OrangeFox Recovery support
ifeq ($(FOX_BUILD),true)
include $(LOCAL_PATH)/ofox.mk
endif