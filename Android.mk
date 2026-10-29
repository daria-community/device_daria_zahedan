#
# Copyright (C) 2023 LibreMobileOS Foundation
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifneq ($(filter zahedan, $(TARGET_DEVICE)),)
include $(call all-makefiles-under,$(LOCAL_PATH))

MT6877_LIBS_32 := \
    libaiselector.so libdpframework.so libhdrvideo.so libmml.so \
    libmtk_drvb.so libnir_neon_driver.so libpq_sec.so libpqparamparser.so libscltm.so

MT6877_LIBS_64 := \
    $(MT6877_LIBS_32) libmdla_ut.so libmmagent.so libmmlpqImpl.so \
    libneuron_adapter_mgvi.so libneuron_platform.vpu.so libneuron_runtime.5.so

VENDOR_SYMLINKS := \
    $(TARGET_OUT_VENDOR)/lib \
    $(TARGET_OUT_VENDOR)/lib64 \
    $(TARGET_OUT_VENDOR)/lib/hw \
    $(TARGET_OUT_VENDOR)/lib64/hw \
    $(TARGET_OUT_VENDOR)/etc/.vintf_cleaned_v2

$(VENDOR_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	$(hide) echo "Making vendor symlinks and cleaning stale VINTF manifests"
	@mkdir -p $(TARGET_OUT_VENDOR)/lib/hw $(TARGET_OUT_VENDOR)/lib/mt6877
	@mkdir -p $(TARGET_OUT_VENDOR)/lib64/hw $(TARGET_OUT_VENDOR)/lib64/mt6877
	@mkdir -p $(TARGET_OUT_VENDOR)/etc/vintf/manifest
	@rm -f $(TARGET_OUT_VENDOR)/etc/vintf/manifest/thermal-mediatek.xml
	@rm -f $(TARGET_OUT_VENDOR)/etc/vintf/manifest/power-mediatek.xml
	@ln -sf /vendor/lib/egl/libGLES_mali.so $(TARGET_OUT_VENDOR)/lib/hw/vulkan.$(TARGET_BOARD_PLATFORM).so
	@ln -sf /vendor/lib64/egl/libGLES_mali.so $(TARGET_OUT_VENDOR)/lib64/hw/vulkan.$(TARGET_BOARD_PLATFORM).so
	@ln -sf /vendor_dlkm/lib/modules $(TARGET_OUT_VENDOR)/lib/modules
	@$(foreach lib,$(MT6877_LIBS_32),ln -sf ../$(lib) $(TARGET_OUT_VENDOR)/lib/mt6877/$(lib);)
	@$(foreach lib,$(MT6877_LIBS_64),ln -sf ../$(lib) $(TARGET_OUT_VENDOR)/lib64/mt6877/$(lib);)
	$(hide) touch $@

ALL_DEFAULT_INSTALLED_MODULES += $(VENDOR_SYMLINKS)
endif
