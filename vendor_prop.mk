# Device properties - fill in as bring-up progresses.
# Values below are copied from the real stock build.prop as a reference
# starting point; verify each before relying on it.

PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.board=universal7870_go \
    ro.board.platform=exynos5 \
    ro.arch=exynos7870 \
    ro.config.low_ram=true \
    ro.hardware.keystore=mdfpp
