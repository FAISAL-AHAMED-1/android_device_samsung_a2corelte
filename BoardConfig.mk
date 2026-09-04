#
# Copyright (C) 2019 The LineageOS Project
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

DEVICE_PATH := device/samsung/a2corelte

# Assert
# a2corelte = SM-A260F/DS base codename, a2coreltedd = dual-SIM build
# variant seen in the stock fingerprint (a2coreltedd/a2corelte). Confirm
# against real firmware for SM-A260G before flashing anything.
TARGET_OTA_ASSERT_DEVICE := a2corelte,a2coreltedd

# Bluetooth (Broadcom, not the Qualcomm stack a3y17lte uses)
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true

# Kernel
# TODO: verify this defconfig actually exists in
# android_kernel_samsung_exynos7870/arch/arm64/configs/ - it almost
# certainly does NOT yet for a2corelte and will need to be created.
TARGET_KERNEL_CONFIG := exynos7870-a2corelte_defconfig

# Low RAM device
TARGET_LOW_RAM := true

# HIDL
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/configs/manifest.xml

# Init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):libinit_a2corelte
TARGET_RECOVERY_DEVICE_MODULES := libinit_a2corelte

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := $(DEVICE_PATH)/releasetools

# Wifi (Broadcom bcm43436B0, confirmed from stock firmware blobs)
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_WLAN_DEVICE := bcmdhd
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
WIFI_DRIVER_FW_PATH_PARAM := "/sys/module/dhd/parameters/firmware_path"
WIFI_DRIVER_FW_PATH_AP := "/vendor/firmware/fw_bcm43436b0_apsta.bin"
WIFI_DRIVER_FW_PATH_STA := "/vendor/firmware/fw_bcm43436b0.bin"
WPA_SUPPLICANT_VERSION := VER_0_8_X
WPA_SUPPLICANT_USE_HIDL := true

# inherit from common
-include device/samsung/universal7870-common/BoardConfigCommon.mk

# inherit from the proprietary version
-include vendor/samsung/a2corelte/BoardConfigVendor.mk
