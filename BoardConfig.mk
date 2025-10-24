# Include the BoardConfig.mk of base product
#TARGET_BOARD_DERIVATIVE_SUFFIX := _sdv

include device/qcom/gen4_gvm/BoardConfig.mk

#ifneq ($(PRODUCT_BUILD_PRODUCT_IMAGE), false)
#AB_OTA_PARTITIONS += product
#endif

#ifneq ($(PRODUCT_BUILD_SYSTEM_IMAGE), false)
#AB_OTA_PARTITIONS += system
#AB_OTA_PARTITIONS += system_dlkm
#endif

#ifneq ($(PRODUCT_BUILD_SYSTEM_EXT_IMAGE), false)
#AB_OTA_PARTITIONS += system_ext
#endif

#ifneq ($(PRODUCT_BUILD_VBMETA_IMAGE), false)
#AB_OTA_PARTITIONS += vbmeta
#endif

AB_OTA_PARTITIONS += system_dlkm

TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_2ND_ARCH :=
TARGET_2ND_ARCH_VARIANT :=
TARGET_2ND_CPU_ABI :=
TARGET_2ND_CPU_ABI2 :=
TARGET_2ND_CPU_VARIANT :=

BOARD_KERNEL_CMDLINE :=
BOARD_BOOTCONFIG :=

ifneq ( ,$(filter V VanillaIceCream 15 W Baklava 16,$(PLATFORM_VERSION)))
TARGET_ANDROID_BELOW_V15 := false
else
TARGET_ANDROID_BELOW_V15 := true
endif

BOARD_BOOTCONFIG := androidboot.hardware=qcom androidboot.selinux=permissive androidboot.memcg=1 androidboot.recover_usb=1
BOARD_KERNEL_CMDLINE := debug user_debug=31 loglevel=9 print-fatal-signals=1  init=/init swiotlb=4096  kpti=0 pcie_ports=compat firmware_class.path=/vendor/firmware_mnt/image

BOARD_KERNEL_CMDLINE += console=hvc0,115200
#BOARD_BOOTCONFIG += androidboot.console=hvc0
BOARD_BOOTCONFIG += androidboot.console=ttyAMA0 earlycon=pl011,0x1c090000

BOARD_BOOTCONFIG += androidboot.init_rc=$(LOCAL_ANDROIDBOOT_INIT_RC) \
                    kernel.vmw_vsock_virtio_transport_common.virtio_transport_max_vsock_pkt_buf_size=16384 \
                    androidboot.microdroid.debuggable=1 \
                    androidboot.sdv.rpc.interface=eth0 \
                    androidboot.adb.enabled=1

BOARD_KERNEL_CMDLINE +=  printk.devkmsg=on log_buf_len=4M  printk_ratelimit=0 printk_ratelimit_burst=0 \
                         audit=1 \
                         panic=-1 \
			 androidboot.console=ttyAMA0 earlycon=pl011,0x1c090000 debug loglevel=9 \
			 console=ttyAMA0 \
                         init_rc=$(LOCAL_ANDROIDBOOT_INIT_RC)

TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
TARGET_USERIMAGES_SPARSE_F2FS_DISABLED := false

#Overwrite required variables below this
# Base product BoardConfigVendor.mk will already be included. So, use below to set new variables or to override old ones

-include $(QCPATH)/common/gen4_gvm_sdv/BoardConfigVendor.mk

BOARD_VENDOR_SEPOLICY_DIRS += device/qcom/gen4_gvm_sdv/sepolicy
ENABLE_WIDEVINE_DRM := false

$(call add_soong_config_namespace,qti)
$(call soong_config_set,qti,qti_android_version_above_16,true)

#####################################################################################################################################
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS := device/google/sdv/sdv_base/sepolicy/system_ext/private \
                                    device/google/sdv/sdv_core_base/sepolicy/system_ext/private \
                                    device/google/sdv/sdv_cf/sepolicy/system_ext/private \
                                    device/google/sdv/sdv_base/vvmtruststore/sepolicy/vvmtruststore/private \
                                    device/qcom/sepolicy/generic/private

SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS :=  device/google/sdv/sdv_base/sepolicy/system_ext/public \
                                    device/google/sdv/sdv_core_base/sepolicy/system_ext/public \
                                    device/qcom/sepolicy/generic/public

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
                                    device/qcom/sepolicy/generic/product/public

$(warning FINAL SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS FOR $(TARGET_PRODUCT): $(SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS))
$(warning FINAL SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS FOR $(TARGET_PRODUCT): $(SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS))
$(warning FINAL PRODUCT_PUBLIC_SEPOLICY_DIRS FOR $(TARGET_PRODUCT): $(PRODUCT_PUBLIC_SEPOLICY_DIRS))
$(warning FINAL PRODUCT_PRIVATE_SEPOLICY_DIRS FOR $(TARGET_PRODUCT): $(PRODUCT_PRIVATE_SEPOLICY_DIRS))
#####################################################################################################################################
