include device/qcom/gen4_gvm/BoardConfig.mk
TARGET_ARCH := arm64
TARGET_2ND_ARCH := arm

BOARD_USERDATAIMAGE_PARTITION_SIZE := 10737418240
BOARD_BOOTCONFIG := androidboot.hardware=qcom androidboot.selinux=permissive androidboot.memcg=1 androidboot.recover_usb=1
BOARD_KERNEL_CMDLINE := user_debug=31 print-fatal-signals=1  init=/init swiotlb=4096  kpti=0 pcie_ports=compat firmware_class.path=/vendor/firmware_mnt/image loop.max_part=7 debug loglevel=9
BOARD_BOOTCONFIG += androidboot.console=ttyAMA0
BOARD_KERNEL_CMDLINE += printk.devkmsg=on log_buf_len=10M  printk_ratelimit=0 printk_ratelimit_burst=0 debug loglevel=9
BOARD_KERNEL_CMDLINE += earlycon=pl011,0x1c090000 console=ttyAMA0
BOARD_BOOTCONFIG += androidboot.sdv.instance_name=instance1 androidboot.sdv.boot_mode=unlocked androidboot.sdv.ignore_avb_state=true androidboot.sdv.vvmfactorytrust=c779a73d0595a6814ba0414a419e99ad4026ad0feb603f2ad80ee6a9e4d1adb7 androidboot.sdv.keymint.rpc.hbk=799da7577efd41d5b27810c5952fcec0291cbcfd687e77ac9a6cec8370651b1d
BOARD_BOOTCONFIG += androidboot.init_rc=$(LOCAL_ANDROIDBOOT_INIT_RC) \
                    kernel.vmw_vsock_virtio_transport_common.virtio_transport_max_vsock_pkt_buf_size=16384 \
                    androidboot.microdroid.debuggable=1 \
                    androidboot.sdv.rpc.interface=eth0 \
                    androidboot.adb.enabled=1

BOARD_KERNEL_CMDLINE +=  log_buf_len=4M \
                         audit=1 \
                         panic=-1 \
                         init_rc=$(LOCAL_ANDROIDBOOT_INIT_RC)

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
