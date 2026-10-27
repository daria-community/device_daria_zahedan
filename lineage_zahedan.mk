#
# Copyright (C) 2023 LibreMobileOS Foundation
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from device makefile.
$(call inherit-product, device/daria/zahedan/device.mk)

PRODUCT_PACKAGES += \
    SettingsProviderOverlayZahedan

# Inherit some common lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_zahedan
PRODUCT_DEVICE := zahedan
PRODUCT_MANUFACTURER := Daria
PRODUCT_BRAND := Daria
PRODUCT_MODEL := DM-B50104

PRODUCT_SYSTEM_NAME := zahedan

BUILD_FINGERPRINT := Daria/zahedan/zahedan:15/AP3A.241105.008/V6.7.2.0.BOND:user/release-keys

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="zahedan-user 15 AP3A.241105.008 V6.7.2.0.BOND release-keys" \
    BuildFingerprint=$(BUILD_FINGERPRINT) \

PRODUCT_GMS_CLIENTID_BASE := android-jimi
