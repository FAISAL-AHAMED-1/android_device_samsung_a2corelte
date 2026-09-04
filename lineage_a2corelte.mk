#
# Copyright (C) 2026 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# NOTE: illustrative only - the right base product inheritance depends on
# which build target this actually needs to be:
#   - a full from-source ROM per device (what this org's a3y17lte etc.
#     trees actually do) -> inherit a full system product makefile here
#   - a Treble vendor-only build so any matching-VNDK GSI can be flashed
#     onto system separately (closer to what "arm64/arm32 GSI support"
#     usually means in practice) -> inherit a vendor-only/core product
#     makefile instead, and make sure BOARD_VNDK_VERSION + the Treble
#     linker namespace options are actually set (they are not yet, above)
# These are two different build outputs from mostly the same tree - decide
# which one is the actual goal before relying on this file.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from a2corelte device
$(call inherit-product, device/samsung/a2corelte/device.mk)

PRODUCT_DEVICE := a2corelte
PRODUCT_NAME := lineage_a2corelte
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-A260G
PRODUCT_MANUFACTURER := samsung
