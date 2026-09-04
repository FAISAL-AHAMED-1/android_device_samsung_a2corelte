# Samsung Galaxy A2 Core (a2corelte)

Device tree skeleton for the Samsung Galaxy A2 Core, following the same
layout as this org's other Exynos 7870 device trees
(`android_device_samsung_a3y17lte`, `_a6lte`, `_j6lte`, `_j7xelte`), so it
can share `device/samsung/universal7870-common` and
`android_kernel_samsung_exynos7870` instead of being built from zero.

**Status: skeleton only, unbuilt, untested.** Nothing here has booted.
Every value below was pulled from an actual stock_vendor.img + boot.img
dump of an SM-A260G, not guessed.

## Device specifications

| | |
|---|---|
| Codename | `a2corelte` / `a2coreltedd` |
| Models | SM-A260F, SM-A260G |
| SoC | Exynos 7870 (`universal7870_go`), 8x Cortex-A53 @1.6GHz |
| GPU | Mali-T830 MP1 |
| RAM | 1GB (`ro.config.low_ram=true`) |
| Display | 540x960 qHD |
| Wi-Fi/BT | Broadcom combo (firmware `bcm43436B0`) |
| Camera sensors | gc5035, "5e9" |
| TEE | Trustonic (`mcRegistry`) |
| Shipped | Android 8.1.0 Oreo Go Edition, build A260GDDSCAUJ1, Oct 2021 |
| Stock fingerprint | `samsung/a2coreltedd/a2corelte:8.1.0/OPR6/A260GDDSCAUJ1:user/release-keys` |

## Findings from the stock vendor partition (important — read before porting)

- **No `/vendor/lib64`.** Every HAL implementation shipped is 32-bit only.
  There is no existing arm64 vendor code to reuse — arm64 GSI support means
  building lib64 HAL binaries from source, not copying/patching existing ones.
- **`compatibility_matrix.xml` declares `<vndk><version>0.0.0</version></vndk>`.**
  This is Samsung's "HIDL-wrapped legacy HAL" scheme used on some Go-edition
  Oreo devices, not a real Treble/VNDK-versioned vendor. There's no existing
  VINTF compliance to build on top of — the manifest below has to be written
  fresh, matching whatever Android version the device tree targets.
- **Graphics HAL is the old "exynos5" generation** (`gralloc.exynos5.so`,
  `hwcomposer.exynos5.so`, HWC 2.1 / gralloc 2.0), not the newer gralloc1/HWC2
  stack some later Exynos7870 device trees in this org assume. This is
  usually the hardest single piece of any Treble/GSI bring-up — expect this
  to be where most of the debugging time goes.
- **Wi-Fi/BT is Broadcom**, not the Qualcomm WCNSS stack used by
  `a3y17lte`'s `device.mk` — the wifi section below has been adapted for
  that, but it's untested.
- `ro.config.low_ram=true`, 1GB total RAM. Realistic expectation: modern
  (Android 12+) GSIs will likely be unusable or fail to boot outright.
  Android 9/10-era arm32 GSIs are the more realistic target, at least for
  a first working boot.
- sepolicy version 27.0, `ro.product.first_api_level=27`.

## Full HAL surface (from stock manifest.xml)

Everything below is HIDL, hwbinder transport, declared in the stock
manifest — this is the real list `configs/manifest.xml` needs to account for,
not a guess:

android.hardware.audio(.effect), android.hardware.bluetooth,
android.hardware.camera.provider (+ vendor.samsung.hardware.camera.provider),
android.hardware.configstore, android.hardware.drm, android.hardware.gatekeeper,
android.hardware.gnss (+ vendor.samsung.hardware.gnss), android.hardware.graphics.allocator,
android.hardware.graphics.composer (+ vendor.samsung_slsi.hardware.ExynosHWCServiceTW),
android.hardware.graphics.mapper, android.hardware.health, android.hardware.keymaster
(+ vendor.samsung.security.skeymaster), android.hardware.light, android.hardware.media.omx,
android.hardware.power, android.hardware.radio(.deprecated) (+ vendor.samsung.hardware.radio,
.channel, .secoemhook), android.hardware.sensors, android.hardware.vibrator,
android.hardware.wifi(.supplicant) (+ vendor.samsung.hardware.wifi.sec_hostapd)

## What's actually in this skeleton

- `Android.mk`, `AndroidProducts.mk` — boilerplate, same as every other
  device tree in this org
- `BoardConfig.mk` — inherits `universal7870-common`; **`TARGET_KERNEL_CONFIG`
  is a placeholder** — check `android_kernel_samsung_exynos7870/arch/arm64/configs/`
  for an existing `a2corelte_defconfig`; if none exists, one needs to be
  built (diff a sibling Go-edition defconfig against this device's
  `/proc/config.gz` or Samsung's opensource release for A260G)
- `device.mk` — permissions, Broadcom wifi copy files (paths are guesses —
  verify against the real firmware layout), overlay hookup
- `proprietary-files.txt` — seeded from the real vendor.img directory
  listing (this README's HAL/bin/firmware findings), **not** run through
  `extract-files.sh` yet — treat as a starting point to verify, not a
  finished list
- `extract-files.sh` — standard LineageOS extract-utils invocation
- `configs/manifest.xml` — adapted from the actual stock manifest.xml,
  with `<vndk>` version left as a TODO — needs to match whatever VNDK the
  target build actually is

## Suggested next steps

1. Confirm whether `android_kernel_samsung_exynos7870` already has an
   a2corelte/a2core-family defconfig; if not, that's the first real blocker
2. Get `device/samsung/universal7870-common` and check what its
   `BoardConfigCommon.mk` / `device-common.mk` already assume that
   might not hold for a 1GB low_ram device
3. Run `extract-files.sh` against a full stock firmware dump (not just
   vendor.img) to get a real, complete `proprietary-files.txt`
4. First build target: get the kernel booting with a generic ramdisk
   before touching GSI/vendor work at all
5. Graphics HAL (exynos5-generation gralloc/hwcomposer) is very likely the
   long pole — budget the most time there
