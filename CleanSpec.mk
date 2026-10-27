#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/vendor/etc/vintf/manifest/thermal-mediatek.xml)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/vendor/etc/init/thermal-mediatek.rc)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/PACKAGING/check_vintf_all_intermediates)
