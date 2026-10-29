#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),zahedan)
include $(call all-makefiles-under,$(LOCAL_PATH))

include $(CLEAR_VARS)

# Clean up stale duplicate VINTF fragments from incremental out/ directory
VINTF_CLEAN_STAMP := $(TARGET_OUT_VENDOR)/etc/.vintf_cleaned_v2
$(VINTF_CLEAN_STAMP):
	@mkdir -p $(dir $@)
	@rm -f $(TARGET_OUT_VENDOR)/etc/vintf/manifest/thermal-mediatek.xml
	@rm -f $(TARGET_OUT_VENDOR)/etc/vintf/manifest/power-mediatek.xml
	@touch $@

ALL_DEFAULT_INSTALLED_MODULES += $(VINTF_CLEAN_STAMP)

endif
