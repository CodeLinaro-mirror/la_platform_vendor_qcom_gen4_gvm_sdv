#Configure derivative suffix for conditional compilation
TARGET_BOARD_DERIVATIVE_SUFFIX := _sdv
PRODUCT_MANUFACTURER := Qualcomm

SDV_SOMEIP_BROKER_CONFIG := broker_config.json
include device/google/sdv/sdv_core_base/sdv_core_base.mk

AOSP_KEYMINT_SERVICE = android.hardware.security.keymint-service
PRODUCT_HOST_PACKAGES := $(filter-out $(SDV_CORE_SERVICES_HOST_SAMPLES_PACKAGES), $(PRODUCT_HOST_PACKAGES))
PRODUCT_PACKAGES := $(filter-out $(AOSP_KEYMINT_SERVICE), $(PRODUCT_PACKAGES))

# Inherit from the base product
include device/qcom/gen4_gvm/gen4_gvm.mk

PRODUCT_BUILD_PRODUCT_IMAGE := false

PRODUCT_NAME := gen4_gvm_sdv
PRODUCT_DEVICE := gen4_gvm_sdv
PRODUCT_BRAND := qti
PRODUCT_MODEL := gen4_gvm_sdv for arm64

#CUSTOM_PATCHES_MODE := apply

TARGET_USES_STAGING_FEATURES := true

DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
                                              device/qcom/gen4_gvm_sdv/compatibility_matrix.xml

# CAN utils
PRODUCT_PACKAGES += candump \
                    cansend \
                    bcmserver \
                    can-calc-bit-timing \
                    canbusload \
                    canfdtest \
                    cangen \
                    cangw \
                    canlogserver \
                    canplayer \
                    cansniffer \
                    isotpdump \
                    isotprecv \
                    isotpsend \
                    isotpserver \
                    isotptun \
                    log2asc \
                    log2long \
                    slcan_attach \
                    slcand \
                    slcanpty

PRODUCT_PACKAGES += \
		    grpcserver \
		    grpcclient \
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
		    sh_vendor \
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
                    libhar-pal \
		    HarPalTest \

PRODUCT_PACKAGES += fstab.sdv

# Packages included only for eng or userdebug builds
# su needed for logpersist.* commands
PRODUCT_PACKAGES_DEBUG += \
			  logpersist.start \
			  su \
PRODUCT_COPY_FILES += $(LOCAL_PATH)/fstab.sdv:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.gen4.qcom

BOARD_VENDOR_SEPOLICY_DIRS += device/google/sdv/sdv_core_base/sepolicy
#BOARD_VENDOR_SEPOLICY_DIRS += device/google/sdv/sdv_media_base/sepolicy

# Kernel modules install path
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/$(TARGET_BOARD_PLATFORM)$(TARGET_BOARD_SUFFIX)$(TARGET_BOARD_DERIVATIVE_SUFFIX)/$(KERNEL_MODULES_INSTALL)/lib/modules
LOCAL_ANDROIDBOOT_INIT_RC := /vendor/etc/init/hw/init.target.rc

PRODUCT_ENFORCE_VINTF_MANIFEST := false
PRODUCT_COPY_FILES += \
		      device/qcom/gen4_gvm_sdv/init.target.rc:vendor/etc/init/hw/init.target.rc \

PRODUCT_COPY_FILES += \
    vendor/qcom/opensource/harry-pal/device_manager.xml:$(TARGET_COPY_OUT_VENDOR)/etc/device_manager.xml

# SOME/IP stack
PRODUCT_PACKAGES += \
                    qc_sdv_someip_stack_agent \
                    vsomeip_vlan1500.json \
                    vsomeip_vlan1510.json \
