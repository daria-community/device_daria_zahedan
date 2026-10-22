#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (  # pyright: ignore
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.main import (  # pyright: ignore
    ExtractUtils,
    ExtractUtilsModule,
)

blob_fixups: blob_fixups_user_type = {
    'vendor/lib64/hw/hwcomposer.mt6877.so': blob_fixup().binary_regex_replace(
        b'OnScreenFingerprintDimLayer', b'UdfpsControllerOverlay\x00\x00\x00\x00\x00'
    ),
}

module = ExtractUtilsModule(
    'zahedan',
    'daria',
    blob_fixups=blob_fixups,
    check_elf=False,
    add_firmware_proprietary_file=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
