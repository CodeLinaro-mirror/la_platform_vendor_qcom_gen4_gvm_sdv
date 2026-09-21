# Inlined from device/qcom/gen4_gvm/BoardConfig.mk (standalone - no longer inheriting)
# Boardconfig.mk
#
# Product-specific compile-time definitions.
#
TARGET_KERNEL_DLKM_DISABLE := false

ifeq ($(PLATFORM_VERSION), $(filter $(PLATFORM_VERSION),CinnamonBun 17))
# Bypass global flag to make source tree READ-ONLY
BUILD_BROKEN_SRC_DIR_IS_WRITABLE := true
endif

TARGET_SEPOLICY_DIR := gen4_gvm


TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic

BOARD_SECCOMP_POLICY := device/qcom/$(TARGET_BOARD_PLATFORM)/seccomp

TARGET_NO_BOOTLOADER := true
TARGET_USES_UEFI := true
TARGET_NO_KERNEL := false

TARGET_USES_IOPHAL := true
TARGET_SCREEN_DENSITY := 160

BUILD_BROKEN_DUP_RULES := true
BOARD_RAMDISK_USE_LZ4 := true

BOARD_INCLUDE_DTB_IN_BOOTIMG := true

-include $(QCPATH)/common/gen4_gvm/BoardConfigVendor.mk
FORCE_USE_ANDROIDMK_FOR_WPA_CONF := true

# Some framework code requires this to enable BT
BOARD_HAVE_BLUETOOTH := true
BOARD_USES_WIPOWER := false
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/qcom/common/automotive

USE_OPENGL_RENDERER := true
BOARD_USE_LEGACY_UI := true
# Set Header version for bootimage
BOARD_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_ARGS := --header_version $(BOARD_BOOT_HEADER_VERSION)

ifeq ($(TARGET_SINGLE_TREE), true)
    BOARD_SYSTEM_QCOM_GPS_LOC_API_HARDWARE := default
endif

ifeq ($(TARGET_NO_RECOVERY), true)
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
endif

# Specify init boot header version
BOARD_INIT_BOOT_HEADER_VERSION := 4
BOARD_MKBOOTIMG_INIT_ARGS += --header_version $(BOARD_INIT_BOOT_HEADER_VERSION)

### Dynamic partition Handling
ifneq ($(strip $(BOARD_DYNAMIC_PARTITION_ENABLE)),true)
  ifeq ($(ENABLE_VENDOR_IMAGE), true)
    BOARD_VENDORIMAGE_PARTITION_SIZE := 1073741824
  endif
  BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
  BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
  ifeq ($(ENABLE_AB), true)
      TARGET_NO_RECOVERY := true
      BOARD_USES_RECOVERY_AS_BOOT := false
  else
      BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x04000000
  endif
else
  # System_ext support
  TARGET_COPY_OUT_SYSTEM_EXT := system_ext
  BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4

 ifeq ($(TARGET_SINGLE_TREE), true)
    BOARD_USES_PRODUCTIMAGE := true
    TARGET_COPY_OUT_PRODUCT := product
    BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
 endif
 ifeq ($(TARGET_BOARD_DERIVATIVE_SUFFIX), _microdroid)
    BOARD_USES_PRODUCTIMAGE := true
    TARGET_COPY_OUT_PRODUCT := product
    BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
 endif

  # System DLKM dynamic Partition support
  BOARD_USES_SYSTEM_DLKMIMAGE := true
  TARGET_COPY_OUT_SYSTEM_DLKM := system_dlkm
  BOARD_SYSTEM_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4

  # Vendor DLKM dynamic partition support
  BOARD_USES_VENDOR_DLKMIMAGE := true
  BOARD_VENDOR_DLKMIMAGE_FILE_SYSTEM_TYPE := ext4
  TARGET_COPY_OUT_VENDOR_DLKM := vendor_dlkm

  # Define the Dynamic Partition sizes and groups.
  ifeq ($(ENABLE_AB), true)
    TARGET_NO_RECOVERY := true
    BOARD_USES_RECOVERY_AS_BOOT := false
    BOARD_SUPER_PARTITION_SIZE := 12884901888
  else
    BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
    BOARD_SUPER_PARTITION_SIZE := 6442450944 #6GB
  endif
  BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
  BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 6438256640 #(6GB - 4MB)
  ifeq ($(TARGET_SINGLE_TREE), true)
    BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := vendor vendor_dlkm system_dlkm system system_ext product
  else ifeq ($(TARGET_BOARD_DERIVATIVE_SUFFIX), _microdroid)
    BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := vendor vendor_dlkm system_dlkm system system_ext product
  else
    BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := vendor vendor_dlkm system_dlkm
  endif
  BOARD_EXT4_SHARE_DUP_BLOCKS := true
endif

#Generate DTBO image
BOARD_KERNEL_SEPARATED_DTBO := false

ifeq ($(BOARD_KERNEL_SEPARATED_DTBO),true)
    # Enable DTBO for recovery image
    BOARD_INCLUDE_RECOVERY_DTBO := true
endif

### Dynamic partition Handling

# Defines for enabling A/B builds
AB_OTA_UPDATER := true
ifeq ($(ENABLE_AB), true)
 # Full A/B partition update set
  ifneq ($(TARGET_USES_GY), true)
    ifeq ($(TARGET_SINGLE_TREE), true)
      AB_OTA_PARTITIONS ?= vendor vbmeta vendor_dlkm system_dlkm system system_ext product boot init_boot vendor_boot
    else ifeq ($(TARGET_BOARD_DERIVATIVE_SUFFIX), _microdroid)
      AB_OTA_PARTITIONS ?= vendor vbmeta vendor_dlkm system_dlkm system system_ext product boot init_boot vendor_boot
    else
      AB_OTA_PARTITIONS ?= vendor vbmeta vendor_dlkm system_dlkm boot init_boot vendor_boot
    endif
  else
     # For HGY the final OTA package A/B partitions is passed as part of the build.sh for single tree
     ifeq ($(TARGET_SINGLE_TREE), true)
      AB_OTA_PARTITIONS ?= vendor vbmeta vendor_dlkm system_dlkm system system_ext product boot init_boot vendor_boot dtbo
     else
     # For HGY the final OTA package A/B partitions is passed as part of the build.sh for split tree
      AB_OTA_PARTITIONS ?= vendor vbmeta vendor_dlkm system_dlkm boot init_boot vendor_boot dtbo
     endif
  endif #TARGET_USES_GY
else
  AB_OTA_PARTITIONS ?= boot system
  ifneq ($(BOARD_USES_RECOVERY_AS_BOOT), true)
    ifeq ($(BOARD_AVB_ENABLE), true)
      BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa4096.pem
      BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA4096
      BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
      BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1
    endif
  endif
endif
#Enable compilation of oem-extensions to recovery
#These need to be explicitly
ifneq ($(AB_OTA_UPDATER),true)
  TARGET_RECOVERY_UPDATER_LIBS += librecovery_updater_msm
endif

TARGET_RECOVERY_FSTAB := device/qcom/gen4_gvm/gen4_fstab_metadata_f2fs/fstab.gen4.qti

#Enable Metadata compilation and adding metadata related attributes
BOARD_USES_METADATA_PARTITION := true
BOARD_METADATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_METADATAIMAGE_PARTITION_SIZE := 67108864

TARGET_HW_DISK_ENCRYPTION := false
TARGET_HW_DISK_ENCRYPTION_PERF := false

#Enable split vendor image
ENABLE_VENDOR_IMAGE := true
ifeq ($(ENABLE_VENDOR_IMAGE), true)
  BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
  TARGET_COPY_OUT_VENDOR := vendor
  BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
endif

ifneq ( ,$(filter V VanillaIceCream 15 W Baklava 16, $(PLATFORM_VERSION)))
TARGET_ANDROID_BELOW_V15 := false
else
TARGET_ANDROID_BELOW_V15 := true
endif

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x04000000
BOARD_KERNEL-GKI_BOOTIMAGE_PARTITION_SIZE := $(BOARD_BOOTIMAGE_PARTITION_SIZE)
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := 0x04000000
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE := 0x00800000
BOARD_USERDATAIMAGE_PARTITION_SIZE := 26843545600
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_PREBUILT_DTBOIMAGE := out/target/product/gen4_gvm/prebuilt_dtbo.img
BOARD_DTBOIMG_PARTITION_SIZE := 0x0800000
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

#----------------------------------------------------------------------
# Compile Linux Kernel
#----------------------------------------------------------------------
ifeq ($(KERNEL_DEFCONFIG),)
    ifeq ($(TARGET_BUILD_VARIANT),user)
        KERNEL_DEFCONFIG := autogvm-qgki_defconfig
    else
        KERNEL_DEFCONFIG := autogvm-qgki-debug_defconfig
    endif
endif

BOARD_DO_NOT_STRIP_VENDOR_MODULES := false
TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_QCOM_BSP := false

BOARD_BOOTCONFIG := androidboot.hardware=qcom androidboot.selinux=enforcing androidboot.memcg=1 androidboot.recover_usb=1 androidboot.load_modules_parallel=true

BOARD_KERNEL_CMDLINE := user_debug=31 print-fatal-signals=1  init=/init swiotlb=4096  kpti=0 pcie_ports=compat firmware_class.path=/vendor/firmware_mnt/image loop.max_part=7
ifeq ($(TARGET_CONSOLE_ENABLED),true)
BOARD_KERNEL_CMDLINE += console=hvc0,115200 debug loglevel=9
BOARD_BOOTCONFIG += androidboot.console=hvc0
else ifeq ($(TARGET_CONSOLE_ENABLED),false)
BOARD_KERNEL_CMDLINE += qcom_geni_serial.con_enabled=0
endif

BOARD_EGL_CFG := device/qcom/$(TARGET_BOARD_PLATFORM)/egl.cfg

BOARD_KERNEL_BASE        := 0x00000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x01E00000
BOARD_RAMDISK_OFFSET     := 0x02000000

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_CROSS_COMPILE_PREFIX := $(shell pwd)/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-androidkernel-

KERN_CONF_PATH := kernel_platform/msm-kernel/arch/arm64/configs/vendor/
KERN_CONF_FILE := $(shell ls $(KERN_CONF_PATH) | grep sa8..._defconfig)
KERNEL_UNCOMPRESSED_DEFCONFIG := $(shell grep "CONFIG_BUILD_ARM64_UNCOMPRESSED_KERNEL=y" $(KERN_CONF_PATH)$(KERN_CONF_FILE))
ifeq ($(KERNEL_UNCOMPRESSED_DEFCONFIG),)
	TARGET_USES_UNCOMPRESSED_KERNEL := false
else
	TARGET_USES_UNCOMPRESSED_KERNEL := true
endif

MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024

BOARD_USES_GENERIC_AUDIO := true
BOARD_QTI_CAMERA_32BIT_ONLY := true
TARGET_NO_RPC := true

TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/
TARGET_INIT_VENDOR_LIB := libinit_msm

TARGET_KERNEL_APPEND_DTB := false
TARGET_COMPILE_WITH_MSM_KERNEL := false
TARGET_SIGNONLY_BOOTLOADER := true

#Enable PD locater/notifier
TARGET_PD_SERVICE_ENABLED := true

#Enable peripheral manager
TARGET_PER_MGR_ENABLED := true

# Enable dex pre-opt to speed up initial boot
ifeq ($(HOST_OS),linux)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
      WITH_DEXPREOPT_PIC := true
      ifneq ($(TARGET_BUILD_VARIANT),user)
        # Retain classes.dex in APK's for non-user builds
        DEX_PREOPT_DEFAULT := nostripping
      endif
    endif
endif

TARGET_USES_GRALLOC1 := true

# Enable sensor multi HAL
USE_SENSOR_MULTI_HAL := false

# Enable sensor Version V_1
USE_SENSOR_HAL_VER := 1.0
#Add non-hlos files to ota packages
ADD_RADIO_FILES := true

#Enable INTERACTION_BOOST
TARGET_USES_INTERACTION_BOOST := true

#Enable DRM plugins 64 bit compilation
TARGET_ENABLE_MEDIADRM_64 := true

#namespace definition for librecovery_updater
#differentiate legacy 'sg' or 'bsg' framework
SOONG_CONFIG_NAMESPACES += ufsbsg
SOONG_CONFIG_ufsbsg += ufsframework
SOONG_CONFIG_ufsbsg_ufsframework := bsg

SOONG_CONFIG_NAMESPACES += android_hardware_audio
SOONG_CONFIG_android_hardware_audio += run_64bit
SOONG_CONFIG_android_hardware_audio_run_64bit := true

#namespace definition for qtiwifi
#differentiate auto and non-auto target
SOONG_CONFIG_NAMESPACES += qtiwifi
SOONG_CONFIG_qtiwifi += automobile
SOONG_CONFIG_qtiwifi_automobile := true

#namespace definition for hexlp
#flag to compile hexlp code or not!
SOONG_CONFIG_NAMESPACES += hexlp_compilation
SOONG_CONFIG_hexlp_compilation += is_enabled
SOONG_CONFIG_hexlp_compilation_is_enabled := $(TARGET_USES_QMAA_OVERRIDE_HEXLP)

#----------------------------------------------------------------------
# namespace definition GPTP specific
#----------------------------------------------------------------------
SOONG_CONFIG_NAMESPACES += qtigptp
SOONG_CONFIG_qtigptp += gen5gvm gen4gvm cdccomm
SOONG_CONFIG_qtigptp_gen5gvm := false
SOONG_CONFIG_qtigptp_gen4gvm := true
SOONG_CONFIG_qtigptp_cdccomm := false

#----------------------------------------------------------------------
# wlan specific
#----------------------------------------------------------------------
ifeq ($(strip $(BOARD_HAS_QCOM_WLAN)),true)
include device/qcom/wlan/msmnile_au/BoardConfigWlan.mk
endif

#Flag to enable System SDK Requirements.
#All vendor APK will be compiled against system_current API set.
#BOARD_SYSTEMSDK_VERSIONS:= $(PRODUCT_SHIPPING_API_LEVEL)

#################################################################################
# This is the End of inlined gen4_gvm BoardConfig content.
# Now, Pickup other split Board.mk files:
#################################################################################
# TODO: Relocate the system Board.mk files pickup into qssi lunch, once it is up.
ifeq ($(filter $(TARGET_BOARD_DERIVATIVE_SUFFIX), _qmaa _gy_qmaa),)
 -include vendor/qcom/defs/board-defs/system/*.mk
 -include vendor/qcom/defs/board-defs/vendor/*.mk
endif
#################################################################################

include device/qcom/sepolicy_vndr/SEPolicy.mk

BUILD_BROKEN_NINJA_USES_ENV_VARS := SDCLANG_AE_CONFIG SDCLANG_CONFIG SDCLANG_SA_ENABLED SDCLANG_CONFIG_AOSP
BUILD_BROKEN_NINJA_USES_ENV_VARS += TEMPORARY_DISABLE_PATH_RESTRICTIONS
BUILD_BROKEN_PREBUILT_ELF_FILES := true
BUILD_BROKEN_USES_BUILD_HOST_SHARED_LIBRARY := true
BUILD_BROKEN_USES_BUILD_HOST_EXECUTABLE := true
BUILD_BROKEN_USES_BUILD_COPY_HEADERS := true
BUILD_BROKEN_USES_BUILD_HOST_STATIC_LIBRARY := true
BUILD_BROKEN_CLANG_PROPERTY := true
# BUILD_BROKEN_USES_SOONG_PYTHON2_MODULES := true
#Enable Camera2 APIs on automotive builds
ENABLE_CAMERA_SERVICE := true

$(call add_soong_config_namespace,qti)
$(call soong_config_set,qti,qti_android_version_above_16,true)

$(call add_soong_config_var,qti,IS_ANDROID_SHIPPING_W)
ifeq ($(SHIPPING_API_LEVEL),36)
    $(call soong_config_set,qti,IS_ANDROID_SHIPPING_W,true)
endif

ifneq (,$(filter cp2a next,$(strip $(TARGET_RELEASE_PLATFORM))))
#Namespace definition for Rust dependencies that come from Android for sec-userspace
SOONG_CONFIG_NAMESPACES += ssg_rustaceans
SOONG_CONFIG_ssg_rustaceans += android_shipping_level
SOONG_CONFIG_ssg_rustaceans_android_shipping_level := android17
endif
#We are sorting BOARD_VENDOR_KERNEL_MODULES due to BoardConfig.mk invoked twice
#   1. From vendor/qcom/proprietary/common/config/device-vendor.mk
#   2. From build/make/core/board_config.mk
#which impacts duplicates found in vendor_dlkm partition while building image
BOARD_VENDOR_KERNEL_MODULES := $(sort $(BOARD_VENDOR_KERNEL_MODULES))
BOARD_USERDATAIMAGE_PARTITION_SIZE := 10737418240
BOARD_BOOTCONFIG := androidboot.hardware=qcom androidboot.selinux=permissive androidboot.memcg=1 androidboot.recover_usb=1
BOARD_KERNEL_CMDLINE := user_debug=31 print-fatal-signals=1  init=/init swiotlb=4096 kpti=0 pcie_ports=compat firmware_class.path=/vendor/firmware_mnt/image loop.max_part=7 debug loglevel=9

BOARD_KERNEL_CMDLINE += printk.devkmsg=on printk_ratelimit=0 printk_ratelimit_burst=0

BOARD_BOOTCONFIG += androidboot.sdv.instance_name=instance1 androidboot.sdv.boot_mode=unlocked androidboot.sdv.ignore_avb_state=true androidboot.sdv.vvmfactorytrust=c779a73d0595a6814ba0414a419e99ad4026ad0feb603f2ad80ee6a9e4d1adb7 androidboot.sdv.keymint.rpc.hbk=799da7577efd41d5b27810c5952fcec0291cbcfd687e77ac9a6cec8370651b1d
BOARD_BOOTCONFIG += androidboot.init_rc=$(LOCAL_ANDROIDBOOT_INIT_RC) \
                    kernel.vmw_vsock_virtio_transport_common.virtio_transport_max_vsock_pkt_buf_size=16384 \
                    androidboot.microdroid.debuggable=1 \
                    androidboot.sdv.rpc.interface=eth0 \
                    androidboot.adb.enabled=1

BOARD_KERNEL_CMDLINE +=  log_buf_len=4M \
                         audit=1 \
                         panic=-1

TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
TARGET_USERIMAGES_SPARSE_F2FS_DISABLED := false

BOARD_VENDOR_SEPOLICY_DIRS += device/qcom/gen4_gvm_sdv/sepolicy \
                              device/google/sdv/sdv_core_cf/sepolicy/vendor \
                              device/google/sdv/sdv_core_base/sepolicy \
                              packages/services/display_safety/service/product/sepolicy/

ENABLE_WIDEVINE_DRM := false

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS := device/google/sdv/sdv_base/sepolicy/system_ext/private \
                                    device/google/sdv/sdv_core_base/sepolicy/system_ext/private \
                                    device/google/sdv/sdv_cf/sepolicy/system_ext/private \
                                    device/google/sdv/sdv_base/vvmtruststore/sepolicy/vvmtruststore/private \
                                    device/qcom/sepolicy/generic/private \
                                    device/qcom/gen4_gvm_sdv/sepolicy/private

SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS :=  device/google/sdv/sdv_base/sepolicy/system_ext/public \
                                    device/google/sdv/sdv_core_base/sepolicy/system_ext/public \
                                    device/qcom/sepolicy/generic/public \
                                    device/qcom/gen4_gvm_sdv/sepolicy/system_ext/public

PRODUCT_PRIVATE_SEPOLICY_DIRS :=    device/google/sdv/sdv_base/sepolicy/samples/product/private \
                                    device/google/sdv/sdv_core_base/sepolicy/product/private \
                                    device/google/sdv/sdv_base/sepolicy/samples/product/private \
                                    device/google/sdv/sdv_core_base/sepolicy/samples/product/private \
                                    packages/services/Car/car_product/sepolicy/private \
                                    packages/services/Car/cpp/watchdog/sepolicy/private \
                                    packages/services/Car/cpp/power/sepolicy/private \
                                    device/qcom/sepolicy/generic/product/private

PRODUCT_PUBLIC_SEPOLICY_DIRS :=     device/google/sdv/sdv_base/sepolicy/product/public \
                                    packages/services/Car/car_product/sepolicy/public \
                                    packages/services/Car/cpp/watchdog/sepolicy/public \
                                    packages/services/Car/cpp/power/sepolicy/public \
                                    device/qcom/sepolicy/generic/product/public \
                                    device/qcom/gen4_gvm_sdv/sepolicy/product/public

BOARD_PRODUCT_SEPOLICY_DIRS += \
    packages/services/display_safety/service/product/sepolicy \

# Allow HAR SDV Service Bundles to use sockets.
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += \
    packages/services/display_safety/service/product/har_sdv_service_bundle_apex/lifecycle/sepolicy/public \
    packages/services/display_safety/service/product/har_sdv_service_bundle_apex/lifecycle/sepolicy \

$(call soong_config_set,sdv_authz,acl_provider_type,sdv_acl_provider)

#######################Soong config for AOSAL###############################
AOSAL_BUILD_WITH_SOONG := true
$(call soong_config_namespace, qti_aosal)
$(call soong_config_set_bool, qti_aosal, AOSAL_BUILD_SOONG, true)
############################################################################
#######################Soong config for SDV################################
TARGET_DISPLAY_SAFETY_ENABLED := true
$(call soong_config_namespace, qti_sdv)
$(call soong_config_set_bool, qti_sdv, SDV_DISPLAY_SAFETY_ENABLED, true)
############################################################################

$(call add_soong_config_namespace, qti)
$(call soong_config_set, qti, TARGET_BOARD_DERIVATIVE_SUFFIX, $(TARGET_BOARD_DERIVATIVE_SUFFIX))

ifeq (true, $(call math_gt_or_eq, $(SHIPPING_API_LEVEL), 34))
$(call soong_config_set_bool, qti, ENABLE_UHAB_CDCSDV, true)
else
$(call soong_config_set_bool, qti, ENABLE_UHAB_CDCSDV, false)
endif #SHIPPING_API_LEVEL

# AUDIO_SDV_APEX_ENABLED gates SDV-specific _apex audio libs (libuhab_apex, libpdmapper_apex,pal,agm etc)
$(call soong_config_set,qti,AUDIO_SDV_APEX_ENABLED,true)
