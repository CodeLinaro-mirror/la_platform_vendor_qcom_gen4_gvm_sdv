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

# Inlined from device/qcom/gen4_gvm/gen4_gvm.mk (standalone - no longer inheriting)
TARGET_BOARD_PLATFORM := gen4
TARGET_BOOTLOADER_BOARD_NAME := gen4
TARGET_BOARD_TYPE := auto
TARGET_BOARD_SUFFIX := _gvm
ENABLE_AIDL_VHAL := true
ENABLE_AIDL_SENSOR := true
# U-BRINGUP disable display
TARGET_DISABLE_DISPLAY := false
TARGET_IS_HEADLESS := false
TARGET_DISABLE_CODEC2 := true
TARGET_DISABLE_VPP_FILTER := true
TARGET_DISABLE_HSI2S_DLKM := false
TARGET_DISABLE_DISPLAY_DLKM := false
TARGET_DISABLE_AIS_DLKM := true
TARGET_DISABLE_LIBVIRTDIAG := true

TARGET_ENABLE_AIS_CUST := false

TARGET_KERNEL_DLKM_AUDIO_OVERRIDE := true

AUDIO_USE_STUB_HAL := false
# Skip VINTF checks for kernel configs since we do not have kernel source
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false
PRODUCT_MANUFACTURER := Qualcomm

ifeq ($(TARGET_SINGLE_TREE), true)
  PRODUCT_ENFORCE_PRODUCT_PARTITION_INTERFACE := true

  # Enable debugfs restrictions
  PRODUCT_SET_DEBUGFS_RESTRICTIONS := true

  PRODUCT_SOONG_NAMESPACES += \
      frameworks/base/boot \
      cts/tests/signature/api-check \
      hardware/google/av \
      hardware/google/interfaces

  TARGET_USES_NEW_ION := true

  TARGET_USES_AOSP_FOR_AUDIO := false

  # Audio configuration file
  #-include $(TOPDIR)vendor/qcom/opensource/audio-hal/primary-hal/configs/qssi/qssi.mk
  #-include $(TOPDIR)vendor/qcom/opensource/commonsys/audio/configs/qssi/qssi.mk
  AUDIO_FEATURE_ENABLED_SVA_MULTI_STAGE := true
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.soc.manufacturer=$(PRODUCT_MANUFACTURER) \

# Enable support for APEX updates
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

SHIPPING_API_LEVEL := 36
PRODUCT_SHIPPING_API_LEVEL := $(SHIPPING_API_LEVEL)
ifeq (,$(filter $(TARGET_BOARD_DERIVATIVE_SUFFIX), _cv))
   BOARD_SHIPPING_API_LEVEL := 202504
endif

ALLOW_MISSING_DEPENDENCIES := true
ENABLE_AB ?= true
# Disable virtual-ab by default
ifeq ($(ENABLE_AB), true)
  ENABLE_VIRTUAL_AB ?= true
endif
ifeq ($(ENABLE_VIRTUAL_AB), true)
  ifeq ($(TARGET_SINGLE_TREE), true)
    $(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
  endif
  ifeq (true,$(call math_gt_or_eq,$(SHIPPING_API_LEVEL),34))
    # For OTA updates with shipping api level 34 and above.
    $(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
    $(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)
    PRODUCT_VENDOR_PROPERTIES += ro.virtual_ab.compression.threads=true
  else
    # For OTA updates with shipping api level 33 and below.
    $(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
    $(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/android_t_baseline.mk)
  endif
  PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4
endif
# Enable AVB 2.0
BOARD_AVB_ENABLE := true
BOARD_USES_QCNE := false
TARGET_BOARD_AUTO := true
TARGET_USES_AOSP := true
TARGET_USES_GAS := true
TARGET_USES_QCOM_BSP := false
TARGET_NO_TELEPHONY := true
TARGET_USES_QTIC := false
TARGET_USES_QTIC_EXTENSION := false
ENABLE_HYP := true
TARGET_CONSOLE_ENABLED ?= true
TARGET_NO_QTI_WFD := true
BOARD_HAVE_QCOM_FM := false
BOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET := false
EXCLUDE_LOCATION_FEATURES := true
TARGET_ENABLE_QC_AV_ENHANCEMENTS := false
TARGET_FWK_SUPPORTS_AV_VALUEADDS := true
#TARGET_FWK_SUPPORTS_FULL_VALUEADDS := false
TARGET_USES_AOSP_FOR_WLAN := true

ifneq ($(TARGET_BOARD_DERIVATIVE_SUFFIX),_qmaa)
BOARD_HAS_QCOM_WLAN := true
endif

ENABLE_CAR_POWER_MANAGER := true
VPP_TARGET_USES_SERVICE := NO
ENABLE_AUDIO_LEGACY_TECHPACK := false
TARGET_USES_QCOM_MM_AUDIO := true
TARGET_USES_DLOG := false
ifeq ($(TARGET_USES_DLOG), true)
PRODUCT_PACKAGES += dlog_service
endif

TARGET_GVMGH_SPECIFIC := false

# RRO configuration
TARGET_USES_RRO := true

#Install Fastadas test apps
INSTALL_FASTADS_TEST_APPS := true

#Enable Userspace Restart
$(call inherit-product, $(SRC_TARGET_DIR)/product/userspace_reboot.mk)

ifeq ($(filter $(TARGET_BOARD_DERIVATIVE_SUFFIX), _cdcsdv _microdroid _sdv),)
  TARGET_HAS_VIRTIO_RSM := true
  TARGET_HAS_VIRTIO_FASTRPC := true
  TARGET_HAS_HYBRID_FASTRPC := true
  TARGET_ENABLE_FASTRPC_TEST := true
endif

# Dynamic-partition enabled by default
BOARD_DYNAMIC_PARTITION_ENABLE := true
ifeq ($(strip $(BOARD_DYNAMIC_PARTITION_ENABLE)),true)
  PRODUCT_USE_DYNAMIC_PARTITIONS := true
  BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := false
  PRODUCT_BUILD_SUPER_PARTITION := false
  PRODUCT_BUILD_RAMDISK_IMAGE := true
  PRODUCT_PACKAGES += fastbootd

  # Mismatch in the uses-library tags between build system and the manifest leads
  # to soong APK manifest_check tool errors. Enable the flag to fix this.
  RELAX_USES_LIBRARY_CHECK := true

endif

PRODUCT_BUILD_SYSTEM_IMAGE := false
PRODUCT_BUILD_SYSTEM_OTHER_IMAGE := false
PRODUCT_BUILD_SYSTEM_EXT_IMAGE := false
#PRODUCT_BUILD_VENDOR_IMAGE := true
PRODUCT_BUILD_PRODUCT_IMAGE := false
PRODUCT_BUILD_PRODUCT_SERVICES_IMAGE := false
#PRODUCT_BUILD_ODM_IMAGE := true
PRODUCT_BUILD_CACHE_IMAGE := false
PRODUCT_BUILD_RAMDISK_IMAGE := true
PRODUCT_BUILD_USERDATA_IMAGE := true
PRODUCT_BUILD_VENDOR_BOOT_IMAGE := true
PRODUCT_BUILD_VENDOR_DLKM_IMAGE := true
PRODUCT_BUILD_SYSTEM_DLKM_IMAGE := true
TARGET_SKIP_OTA_PACKAGE := true

ifeq ($(TARGET_SINGLE_TREE), true)
  PRODUCT_BUILD_SYSTEM_IMAGE := true
  PRODUCT_BUILD_SYSTEM_EXT_IMAGE := true
  PRODUCT_BUILD_PRODUCT_IMAGE := true
  BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
  PRODUCT_BUILD_SUPER_PARTITION := true
  TARGET_SKIP_OTA_PACKAGE := false
endif

#Using sha256 for dm-verity partitions.
#system, system_other, system_ext and product.
BOARD_AVB_SYSTEM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_EXT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
ifeq ($(TARGET_SINGLE_TREE), true)
  BOARD_AVB_PRODUCT_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
endif
BOARD_AVB_VENDOR_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_SYSTEM_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256
BOARD_AVB_VENDOR_DLKM_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256

ifneq ("$(wildcard device/qcom/$(TARGET_BOARD_PLATFORM)-kernel/vendor_dlkm/system_dlkm.modules.blocklist)", "")
  PRODUCT_COPY_FILES += device/qcom/$(TARGET_BOARD_PLATFORM)-kernel/vendor_dlkm/system_dlkm.modules.blocklist:$(TARGET_COPY_OUT_VENDOR_DLKM)/lib/modules/system_dlkm.modules.blocklist
endif

TARGET_DEFINES_DALVIK_HEAP := true
# Disable 32bit App support.
# This value should be set before including device/qcom/common/common64.mk
DEVICE_SUPPORTS_64_BIT_APPS_ONLY := true
$(call inherit-product, device/qcom/common/common64.mk)
#Inherit all except heap growth limit from phone-xhdpi-2048-dalvik-heap.mk
PRODUCT_PROPERTY_OVERRIDES  += \
   dalvik.vm.heapstartsize=8m \
   dalvik.vm.heapsize=512m \
   dalvik.vm.heaptargetutilization=0.75 \
   dalvik.vm.heapminfree=512k \
   dalvik.vm.heapmaxfree=8m \
   vendor.gatekeeper.disable_spu = true #\


PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=enforce

PRODUCT_PROPERTY_OVERRIDES += ro.vendor.asymmetric_support=true


PRODUCT_NAME := gen4_gvm_sdv
PRODUCT_DEVICE := gen4_gvm_sdv
PRODUCT_BRAND := qti
PRODUCT_MODEL := gen4_gvm_sdv for arm64

PRODUCT_SOONG_NAMESPACES += hardware/qcom/wlan/qcwcn
###########
#QMAA flags starts
###########
#QMAA global flag for modular architecture
#true means QMAA is enabled for system
#false means QMAA is disabled for system

TARGET_USES_QMAA := true

#QMAA flag which is set to incorporate any generic dependencies
#required for the boot to UI flow in a QMAA enabled target.
#Set to false when all target level depenencies are met with
#actual full blown implementations.
TARGET_USES_QMAA_RECOMMENDED_BOOT_CONFIG := true

TARGET_USES_QMAA_OVERRIDE_ANDROID_CORE := true
TARGET_USES_QMAA_OVERRIDE_ANDROID_RECOVERY := true
TARGET_USES_QMAA_OVERRIDE_AUDIO   := true
TARGET_USES_QMAA_OVERRIDE_BIOMETRICS := true
TARGET_USES_QMAA_OVERRIDE_BLUETOOTH   := true
TARGET_USES_QMAA_OVERRIDE_CAMERA  := false
TARGET_USES_QMAA_OVERRIDE_CVP  := false
TARGET_USES_QMAA_OVERRIDE_DATA_NET := false
TARGET_USES_QMAA_OVERRIDE_DATA := false
TARGET_USES_QMAA_OVERRIDE_DIAG := false
TARGET_USES_QMAA_OVERRIDE_DISPLAY := true
TARGET_USES_QMAA_OVERRIDE_DPM  := false
TARGET_USES_QMAA_OVERRIDE_DRM  := true
TARGET_USES_QMAA_OVERRIDE_DRM_SMMU  := true
TARGET_USES_QMAA_OVERRIDE_EID := false
TARGET_USES_QMAA_OVERRIDE_FASTCV  := true
TARGET_USES_QMAA_OVERRIDE_FASTRPC := false
TARGET_USES_QMAA_OVERRIDE_FM  := true
TARGET_USES_QMAA_OVERRIDE_FTM := false
TARGET_USES_QMAA_OVERRIDE_GFX := true
TARGET_USES_QMAA_OVERRIDE_GPS := false
TARGET_USES_QMAA_OVERRIDE_GP := true
TARGET_USES_QMAA_OVERRIDE_GPT := false
TARGET_USES_QMAA_OVERRIDE_KERNEL_TESTS_INTERNAL := false
TARGET_USES_QMAA_OVERRIDE_KMGK := true
TARGET_USES_QMAA_OVERRIDE_MSMIRQBALANCE := true
TARGET_USES_QMAA_OVERRIDE_OPENVX  := true
TARGET_USES_QMAA_OVERRIDE_PERF := true
TARGET_USES_QMAA_OVERRIDE_REMOTE_EFS := false
TARGET_USES_QMAA_OVERRIDE_RPMB := true
TARGET_USES_QMAA_OVERRIDE_SCVE  := false
TARGET_USES_QMAA_OVERRIDE_SECUREMSM_TESTS := true
TARGET_USES_QMAA_OVERRIDE_SENSORS := true
TARGET_USES_QMAA_OVERRIDE_SMCINVOKE := false
TARGET_USES_QMAA_OVERRIDE_SOTER := false
TARGET_USES_QMAA_OVERRIDE_SPCOM_UTEST := false
TARGET_USES_QMAA_OVERRIDE_SYNX := false
TARGET_USES_QMAA_OVERRIDE_TFTP := false
TARGET_USES_QMAA_OVERRIDE_USB := true
TARGET_USES_QMAA_OVERRIDE_VIBRATOR := false
TARGET_USES_QMAA_OVERRIDE_VIDEO   := true
TARGET_USES_QMAA_OVERRIDE_VPP := true
TARGET_USES_QMAA_OVERRIDE_HEXLP := true
TARGET_USES_QMAA_OVERRIDE_WFD     := true
TARGET_USES_QMAA_OVERRIDE_WLAN    := true
TARGET_USES_QMAA_OVERRIDE_HSI2S := true

TARGET_KERNEL_DLKM_WLAN_OVERRIDE := true
TARGET_ENABLE_QSEECOM := true
#Full QMAA HAL List
QMAA_HAL_LIST := audio video camera display sensors gps

ifeq ($(TARGET_USES_QMAA), true)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.confqmaa=true
endif

###########
#QMAA flags ends

# Sensor conf files
PRODUCT_COPY_FILES += \
    device/qcom/gen4_gvm/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf \



#Initial bringup flags

#Default vendor image configuration
ifeq ($(ENABLE_VENDOR_IMAGE),)
  ENABLE_VENDOR_IMAGE := false
endif

TARGET_KERNEL_VERSION := 6.12
TARGET_HAS_GENERIC_KERNEL_HEADERS := true

#Enable llvm support for kernel
KERNEL_LLVM_SUPPORT := true

#Enable sd-llvm suppport for kernel
KERNEL_SD_LLVM_SUPPORT := false

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

BOARD_FRP_PARTITION_NAME := frp

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android

# diag-router
ifeq ($(strip $(TARGET_BUILD_VARIANT)),user)
  TARGET_HAS_DIAG_ROUTER := false
else
  TARGET_HAS_DIAG_ROUTER := true
endif

# Memtrack HAL deprecated. Replaced with AIDL for target-level >= 6.
ENABLE_MEMTRACK_AIDL_HAL := true

-include $(QCPATH)/common/config/qtic-config.mk


ifneq ($(TARGET_NO_TELEPHONY), true)
 PRODUCT_BOOT_JARS += telephony-ext
 PRODUCT_PACKAGES += telephony-ext
endif

TARGET_DISABLE_DASH := true
TARGET_DISABLE_QTI_VPP := false

ifneq ($(TARGET_DISABLE_DASH), true)
    PRODUCT_BOOT_JARS += qcmediaplayer
endif

# Ethernet configuration file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml

# Video codec configuration files
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += device/qcom/gen4/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml

PRODUCT_COPY_FILES += device/qcom/gen4/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml
PRODUCT_COPY_FILES += device/qcom/gen4/media_codecs_vendor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor.xml

PRODUCT_COPY_FILES += device/qcom/gen4/media_codecs_vendor_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor_audio.xml

PRODUCT_COPY_FILES += device/qcom/gen4/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml
endif #TARGET_ENABLE_QC_AV_ENHANCEMENTS

#PRODUCT_COPY_FILES += hardware/qcom/media/conf_files/gen4/system_properties.xml:$(TARGET_COPY_OUT_VENDOR)/etc/system_properties.xml

#Audio DLKM
AUDIO_DLKM := audio_apr.ko
AUDIO_DLKM += audio_snd_event.ko
AUDIO_DLKM += audio_q6_notifier.ko
AUDIO_DLKM += audio_adsp_loader.ko
AUDIO_DLKM += audio_q6.ko
AUDIO_DLKM += audio_platform.ko
AUDIO_DLKM += audio_hdmi.ko
AUDIO_DLKM += audio_stub.ko
AUDIO_DLKM += audio_native.ko
AUDIO_DLKM += audio_machine_gen4.ko
PRODUCT_PACKAGES += $(AUDIO_DLKM)


PRODUCT_PACKAGES += fs_config_files

#A/B related packages

ifeq ($(filter $(TARGET_BOARD_DERIVATIVE_SUFFIX), _cdcsdv _sdv),)
PRODUCT_PACKAGES += update_engine
endif

PRODUCT_PACKAGES += \
    update_engine_client \
    update_verifier \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery \

ifeq ($(TARGET_SINGLE_TREE), true)
PRODUCT_PACKAGES += android.hardware.boot@1.0-impl \
                    android.hardware.boot@1.0-service \
                    update_engine_sideload
endif

# drm_smmu property
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.drm.smmu=1

# bootctrl property
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.bootctrl.enable=true

PRODUCT_PACKAGES += fstab.postinstall \
                    cppreopts.sh \
                    preloads_copy.sh \
                    cppreopts.rc

PRODUCT_HOST_PACKAGES += \
	brillo_update_payload

#Healthd packages
PRODUCT_PACKAGES += \
    libhealthd.msm

DEVICE_MATRIX_FILE   := device/qcom/common/compatibility_matrix.xml
DEVICE_FRAMEWORK_MANIFEST_FILE := device/qcom/gen4_gvm/framework_manifest.xml
ifeq ($(TARGET_SINGLE_TREE), true)
  DEVICE_FRAMEWORK_MANIFEST_FILE := device/qcom/qssi_au/framework_manifest.xml
endif
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := vendor/qcom/opensource/core-utils/vendor_framework_compatibility_matrix.xml

# Enable Scoped Storage related
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# BroadcastRadio
PRODUCT_PACKAGES += \
    android.hardware.broadcastradio-service.default

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.broadcastradio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.broadcastradio.xml \

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml


# Kernel modules install path
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/$(TARGET_BOARD_PLATFORM)$(TARGET_BOARD_SUFFIX)$(TARGET_BOARD_DERIVATIVE_SUFFIX)/$(KERNEL_MODULES_INSTALL)/lib/modules

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

#Enable full treble flag
PRODUCT_FULL_TREBLE_OVERRIDE := true
PRODUCT_VENDOR_MOVE_ENABLED := true
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

# Enable flag to support slow devices
TARGET_PRESIL_SLOW_BOARD := true

ENABLE_VENDOR_RIL_SERVICE := true

#----------------------------------------------------------------------
# wlan specific
#----------------------------------------------------------------------
ifeq ($(strip $(BOARD_HAS_QCOM_WLAN)),true)
# Multiple chips
TARGET_WLAN_CHIP := qca6390 qca6490 kiwi_v2 qcn7605
include device/qcom/wlan/msmnile_au/wlan.mk
endif

TARGET_MOUNT_POINTS_SYMLINKS := false


PRODUCT_PROPERTY_OVERRIDES += vendor.usb.diag_mdm.inst.name=diag_mdm2
PRODUCT_PROPERTY_OVERRIDES += debug.sf.nobootanimation=1

#enable gptp
PRODUCT_PACKAGES += \
            libgptp \
            libgptp_test

#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl

#Enable fuzzers for userdebug builds
PRODUCT_PACKAGES_DEBUG += aidl_fuzzer_bootctrl
PRODUCT_PACKAGES_DEBUG += vhalserver_fuzzer

PRODUCT_PACKAGES += \
   update_engine_sideload

#PRODUCT_PACKAGES += android.hardware.automotive.audiocontrol@1.0-service

PRODUCT_PACKAGES += android.hardware.dumpstate-service.example \
                    android.hardware.thermal-service.example \
                    com.android.hardware.thermal

PRODUCT_PACKAGES += qcar-gsi.avbpubkey

#add vndservicemanager
PRODUCT_PACKAGES += vndservicemanager
PRODUCT_PACKAGES += fstab.gen4.qcom
PRODUCT_PACKAGES += fstab.gen4.7255.qcom
PRODUCT_PACKAGES += fstab.gen4.8255.qcom

PRODUCT_ENFORCE_RRO_TARGETS := framework-res

#add libnbaio for avenhancement
PRODUCT_PACKAGES += libnbaio

PRODUCT_PRODUCT_PROPERTIES += persist.adb.tcp.port=5555

ifeq ($(TARGET_SINGLE_TREE), true)
  # Context hub HAL
  PRODUCT_PACKAGES += \
    android.hardware.contexthub@1.0-impl.generic \
    android.hardware.contexthub@1.0-service

  # system prop for enabling QFS (QTI Fingerprint Solution)
  PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.qfp=true

  PRODUCT_SYSTEM_PROPERTIES += \
    persist.device_config.runtime_native_boot.iorap_perfetto_enable=true

  PRODUCT_SYSTEM_PROPERTIES += ro.android.car.audio.enableaudiopatch=true

  # USB default HAL
  #PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

  # copy system_ext specific whitelisted libraries to system_ext/etc
  PRODUCT_COPY_FILES += \
    device/qcom/qssi_au/public.libraries.system_ext-qti.txt:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/public.libraries-qti.txt

  PRODUCT_PACKAGES += android.frameworks.automotive.display@1.0-service

  TARGET_USES_MKE2FS := true

  PRODUCT_PROPERTY_OVERRIDES += \
    ro.crypto.volume.filenames_mode = "aes-256-cts" \
    ro.crypto.allow_encrypt_override = true

endif

# Network utils
PRODUCT_PACKAGES += ip_vendor \
                    libiprouteutil_vendor

# Set network mode to (T/L/G/W/1X/EVDO, T/L/G/W/1X/EVDO) for 7+7 mode device on DSDS mode
PRODUCT_VENDOR_PROPERTIES += ro.telephony.default_network=22,22 \
                            ro.radio.noril=true

#13631487 is decimal sum of supported codecs in AAL
#codecs:(PARSER_)AAC AC3 AMR_NB AMR_WB ASF AVI DTS FLV 3GP 3G2 MKV MP2PS MP2TS MP3 OGG QCP WAV FLAC AIFF APE DSD MOV XVID
PRODUCT_VENDOR_PROPERTIES += vendor.mm.enable.qcom_parser=63963135 \
                            persist.mm.enable.prefetch=true

# system props for the data modules
PRODUCT_VENDOR_PROPERTIES += ro.vendor.use_data_netmgrd=true \
                            persist.vendor.data.mode=concurrent

#system props for time-services
PRODUCT_VENDOR_PROPERTIES += persist.timed.enable=true

# system prop for opengles version
# 196608 is decimal for 0x30000 to report version 3
# 196609 is decimal for 0x30001 to report version 3.1
# 196610 is decimal for 0x30002 to report version 3.2
PRODUCT_VENDOR_PROPERTIES += ro.opengles.version=196610

# system prop to turn on CdmaLTEPhone always
PRODUCT_VENDOR_PROPERTIES += telephony.lteOnCdmaDevice=1

#Simulate sdcard on /data/media
PRODUCT_VENDOR_PROPERTIES += persist.fuse_sdcard=true

PRODUCT_VENDOR_PROPERTIES += persist.vendor.service.bdroid.sibs=false

# system prop for Hardware type Automotive
PRODUCT_VENDOR_PROPERTIES += ro.hardware.type=automotive

PRODUCT_VENDOR_PROPERTIES += ro.hardware.sensors=gen4.asm_auto

# snapdragon value add features
PRODUCT_VENDOR_PROPERTIES += ro.qc.sdk.audio.ssr=false

# fluencetype can be "fluence" or "fluencepro" or "none"
PRODUCT_VENDOR_PROPERTIES += ro.qc.sdk.audio.fluencetype=none \
                            persist.audio.fluence.voicecall=true \
                            persist.audio.fluence.voicerec=false \
                            persist.audio.fluence.speaker=true

# system prop for RmNet Data
PRODUCT_VENDOR_PROPERTIES += persist.rmnet.data.enable=true \
                            persist.data.wda.enable=true \
                            persist.data.df.dl_mode=5 \
                            persist.data.df.ul_mode=5 \
                            persist.data.df.agg.dl_pkt=10 \
                            persist.data.df.agg.dl_size=4096 \
                            persist.data.df.mux_count=8 \
                            persist.data.df.iwlan_mux=9 \
                            persist.data.df.dev_name=rmnet_usb0

ifeq ($(TARGET_SINGLE_TREE), true)
PRODUCT_SYSTEM_PROPERTIES += persist.debug.wfd.enable=1
endif

# property to choose between virtual/external wfd display
PRODUCT_VENDOR_PROPERTIES += persist.sys.wfd.virtual=0

# enable tunnel encoding for amrwb
PRODUCT_VENDOR_PROPERTIES += tunnel.audio.encode = true

#Buffer size in kbytes for compress offload playback
PRODUCT_VENDOR_PROPERTIES += audio.offload.buffer.size.kb=32

# Enable offload audio video playback by default
PRODUCT_VENDOR_PROPERTIES += av.offload.enable=true

# Enable voice path for PCM VoIP by default
PRODUCT_VENDOR_PROPERTIES += use.voice.path.for.pcm.voip=true

# system prop for NFC DT
PRODUCT_VENDOR_PROPERTIES += ro.nfc.port=I2C

# Enable dsp gapless mode by default
PRODUCT_VENDOR_PROPERTIES += audio.offload.gapless.enabled=true

# initialize QCA1530 detection
PRODUCT_VENDOR_PROPERTIES += sys.qca1530=detect

# Enable stm events
PRODUCT_VENDOR_PROPERTIES += persist.debug.coresight.config=stm-events

# hwui properties
PRODUCT_VENDOR_PROPERTIES += ro.hwui.texture_cache_size=72 \
                            ro.hwui.layer_cache_size=48 \
                            ro.hwui.r_buffer_cache_size=8 \
                            ro.hwui.path_cache_size=32 \
                            ro.hwui.gradient_cache_size=1 \
                            ro.hwui.drop_shadow_cache_size=6 \
                            ro.hwui.texture_cache_flushrate=0.4 \
                            ro.hwui.text_small_cache_width=1024 \
                            ro.hwui.text_small_cache_height=1024 \
                            ro.hwui.text_large_cache_width=2048 \
                            ro.hwui.text_large_cache_height=1024 \

ifeq ($(TARGET_SINGLE_TREE), true)
PRODUCT_SYSTEM_PROPERTIES += config.disable_rtt=true
endif

#Bringup properties
PRODUCT_VENDOR_PROPERTIES += persist.sys.force_sw_gles=1 \
                            persist.vendor.radio.atfwd.start=true \
                            ro.kernel.qemu.gles=0 \
                            qemu.hw.mainkeys=0

# Enable ZRAM
PRODUCT_VENDOR_PROPERTIES += ro.vendor.qti.config.zram=true

#IOP properties
PRODUCT_VENDOR_PROPERTIES += vendor.iop.enable_uxe=1 \
                            vendor.perf.iop_v3.enable=true

# Property to enable perf boosts from System Server
PRODUCT_VENDOR_PROPERTIES += vendor.perf.gestureflingboost.enable=true

#Enable ULMK properties
PRODUCT_VENDOR_PROPERTIES += ro.lmk.kill_heaviest_task=true \
                            ro.lmk.kill_timeout_ms=15 \
                            ro.lmk.enhance_batch_kill=true \
                            ro.lmk.enable_adaptive_lmk=true \
                            ro.lmk.vmpressure_file_min=80640 \

#Property to enable scroll pre-obtain view
PRODUCT_VENDOR_PROPERTIES += ro.vendor.scroll.preobtain.enable=true

#Display mirroring
PRODUCT_VENDOR_PROPERTIES += vendor.display.builtin_mirroring=true

#Display hwcId allocation
PRODUCT_VENDOR_PROPERTIES += vendor.display.builtin_baseid_and_size=5,3 \
                            vendor.display.pluggable_baseid_and_size=1,4 \
                            vendor.display.virtual_baseid_and_size=8,1 \

# Gralloc use dmabuf
PRODUCT_VENDOR_PROPERTIES += vendor.gralloc.use_dma_buf_heaps=1

# Enable CPMS for LPM
PRODUCT_VENDOR_PROPERTIES += persist.vendor.car.lpm=true

# default wifi country code
PRODUCT_VENDOR_PROPERTIES += ro.boot.wificountrycode=us

#Key derivation in vts kernel encryption tests use legacykdf
PRODUCT_VENDOR_PROPERTIES += ro.crypto.hw_wrapped_keys.kdf=legacykdf

# Native service to load modules
ifneq (,$(filter $(TARGET_BOARD_PLATFORM)$(TARGET_BOARD_SUFFIX), gen4_gvm))
PRODUCT_VENDOR_PROPERTIES += ro.vendor.qti.load_dlkm.service=native
PRODUCT_VENDOR_PROPERTIES += ro.vendor.qti.sysdep.modlist=btpower,btpower_new,ptp_qcom_tsc_vm,ptp_virtual
PRODUCT_VENDOR_PROPERTIES += ro.vendor.qti.sysdep.eth.modlist=stmmac,stmmac_platform,dwmac-qcom-eth,emac-mdio-fe
PRODUCT_VENDOR_PROPERTIES += ro.vendor.qti.sysdep.wlan.modlist=cfg80211,mac80211,qca_cld3_qca6390,qca_cld3_qca6490,qca_cld3_kiwi_v2,qca_cld3_qcn7605
endif

# Add gsi avb keys
PRODUCT_PACKAGES += qcar-gsi.avbpubkey

ifeq ($(TARGET_SINGLE_TREE), true)
  # Include mainline components and QSSI whitelist
  ifeq (true,$(call math_gt_or_eq,$(SHIPPING_API_LEVEL),29))
    #$(call inherit-product, device/qcom/qssi_au/qssi_au_whitelist.mk)
    #PRODUCT_ARTIFACT_PATH_REQUIREMENT_IGNORE_PATHS := /system/system_ext/
    PRODUCT_ENFORCE_ARTIFACT_PATH_REQUIREMENTS := false
  endif

  PRODUCT_PACKAGES += vendor.qti.qesdsys
endif

AB_OTA_POSTINSTALL_CONFIG += \
               RUN_POSTINSTALL_vendor=true \
               FILESYSTEM_TYPE_vendor=ext4 \
               POSTINSTALL_OPTIONAL_vendor=true


###################################################################################
# This is the End of inlined gen4_gvm content.
# Now, Pickup other split product.mk files:
###################################################################################
# TODO: Relocate the system product.mk files pickup into qssi lunch, once it is up.
ifeq ($(filter $(TARGET_BOARD_DERIVATIVE_SUFFIX), _qmaa _gy_qmaa),)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/*.mk)
$(call inherit-product-if-exists, vendor/qcom/defs/product-defs/vendor/*.mk)
endif
###################################################################################

LOCAL_PATH := $(call my-dir)

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


