#!/bin/bash
#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=a2corelte
VENDOR=samsung

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitized source if no parameters
SRC="${1:-${ANDROID_ROOT}/prebuilts/extract-tools/${VENDOR}/${DEVICE}}"

# Initialize the helper for common device
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" true "${KEEP_DUMP}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KEEP_DUMP}"

"${MY_DIR}/setup-makefiles.sh"
