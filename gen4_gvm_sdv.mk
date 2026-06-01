TARGET_BOARD_DERIVATIVE_SUFFIX := _sdv
SDV_VM_LEVEL_PERMISSIONS_MODULE := com.oem.sdv.authz.allow_all.core
TARGET_SDV_ENABLED := true

SDV_OPEN_DICE_PROVIDER_PACKAGES := \
    init_open_dice \
    sample_dice_handover_file \

PRODUCT_PACKAGES += \
    sample_dice_handover_file \
    android.sdv.hardware.security.keymint-service.nonsecure

SDV_SOMEIP_BROKER_CONFIG := broker_config.json

PRODUCT_COPY_FILES += \
    device/google/sdv/sdv_base/init_open_dice_service.rc:system_ext/etc/init/init_open_dice_service.rc

PRODUCT_COPY_FILES += \
    device/qcom/gen4_gvm_sdv/init.target.rc:vendor/etc/init/hw/init.target.rc \

SDV_VEHICLE_POWER_STATE_MANAGER_MODULE := vepsm

include device/google/sdv/sdv_core_base/sdv_core_base.mk
include device/google/sdv/sdv_base/sdv_sample_ethernet_setup.mk
include device/google/sdv/sdv_base/vvmtruststore/vvmtruststore.mk
include device/google/sdv/sdv_base/sdv_samples_base_services.mk
include device/google/sdv/sdv_core_base/sdv_samples_all.mk
include device/google/sdv/sdv_core_base/sdv_samples_core_services.mk
include device/qcom/gen4_gvm/gen4_gvm.mk

LOCAL_PATH := $(call my-dir)

PRODUCT_NAME := gen4_gvm_sdv
PRODUCT_DEVICE := gen4_gvm_sdv
TARGET_USES_QMAA_OVERRIDE_KMGK := false

DEVICE_MANIFEST_FILE := device/qcom/gen4_gvm_sdv/manifest.xml

PRODUCT_COPY_FILES += device/qcom/gen4_gvm_sdv/fstab_AB_dynamic_partition_variant.gen4.sdv.qti:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.gen4.sdv.qcom
PRODUCT_PACKAGES += fstab.gen4.sdv.qcom

TARGET_FS_CONFIG_GEN += device/google/sdv/sdv_core_base/config.fs

PRODUCT_PACKAGES += \
    com.sdv.google.display_safety.services_bundle.apex \

# Add tools/utils
PRODUCT_PACKAGES += \
        harry_rpc_client \

PRODUCT_PACKAGES += \
    dice_handover_instance1 \
    dice_handover_instance2 \
    dice_handover_instance3 \
    sdv_provisioning_tool \
    sdv_dice_root_key_extraction_tool

PRODUCT_PACKAGES += sdv_multi_display_sample_rust \
    sdv_gl_gen_texture \
    null_platform_test \
    sdv_screencap \
    harry_app_prebuilt \

#include packages/services/display_safety/service/product/harry_apex/product.mk
include device/google/sdv_display_safety/sdv_harry_common.mk

KMGK_USE_QTI_SERVICE := false

#MAKEFILE_DIR := vendor/qcom/defs/product-defs/system
#EXCLUDE_MAKEFILES := $(MAKEFILE_DIR)/sensor_product.mk
#ALL_MAKEFILES := $(wildcard $(MAKEFILE_DIR)/*.mk)
#INCLUDE_MAKEFILES := $(filter-out $(EXCLUDE_MAKEFILES), $(ALL_MAKEFILES))

# Include the filtered makefiles
#$(foreach mk, $(INCLUDE_MAKEFILES), $(call inherit-product-if-exists, $(mk)))
#$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/vendor/*.mk)

# SDV provides its own non-secure KeyMint (sdv_keymint_nonsecure) that replaces the AOSP
# software keymint. Remove the AOSP packages to prevent VINTF manifest conflicts on
# android.hardware.security.{keymint,secureclock,sharedsecret}/default.
PRODUCT_PACKAGES := $(filter-out \
    android.hardware.security.keymint-service \
    android.hardware.security.keymint-service.rc \
    android.hardware.security.keymint-service.nonsecure \
    ,$(PRODUCT_PACKAGES))

DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    device/qcom/gen4_gvm_sdv/compatibility_matrix.xml

PRODUCT_PACKAGES += \
    init.environ.rc \

PRODUCT_PACKAGES += \
    com.android.runtime \
    com.android.adbd \
    mdnsd \

# Shell and utilities
PRODUCT_PACKAGES += \
    reboot \
    sh \
    strace \
    toolbox \
    toybox \
    toolbox_vendor \
    toybox_vendor \

# Test Binder RPC services
PRODUCT_PACKAGES += \
    minidroid_sd \
    server_minidroid \
    client_minidroid \
    client_minidroid_rust \

PRODUCT_PACKAGES += \
    init_second_stage \
    libbinder \
    libbinder_ndk \
    libstdc++ \
    secilc \
    libadbd_auth \
    libadbd_fs \
    heapprofd_client_api \
    libartpalette-system \
    apexd \
    atrace \
    debuggerd \
    linker \
    servicemanager \
    service \
    tombstoned \
    tombstone_transmit.microdroid \
    cgroups.json \
    task_profiles.json \
    public.libraries.android.txt \
    logcat \
    logd \
    fsck.f2fs \
    HarPalTest \

PRODUCT_PACKAGES_DEBUG += \
    logpersist.start \
    su \

LOCAL_ANDROIDBOOT_INIT_RC := /vendor/etc/init/hw/init.target.rc

PRODUCT_ENFORCE_VINTF_MANIFEST := false

PRODUCT_COPY_FILES += device/google/sdv/sdv_cf/ethernet/ethernet.sdv_cf.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/hw/ethernet.sdv_cf.rc

