# this is platform common device config
# you should migrate turnkey alps/build/target/product/common.mk to this file in correct way

# TARGET_PREBUILT_KERNEL should be assigned by central building system
#ifeq ($(TARGET_PREBUILT_KERNEL),)
#LOCAL_KERNEL := device/mediatek/common/kernel
#else
#LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
#endif

#PRODUCT_COPY_FILES += $(LOCAL_KERNEL):kernel

# MediaTek framework base modules
PRODUCT_PACKAGES += \
    mediatek-common \
    mediatek-framework \
    CustomPropInterface \
    mediatek-telephony-common \
    FwkPlugin

ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
# Override the PRODUCT_BOOT_JARS to include the MediaTek system base modules for global access
PRODUCT_BOOT_JARS += \
    mediatek-common \
    mediatek-framework \

ifneq ($(strip $(MTK_BSP_PACKAGE)), yes)
PRODUCT_BOOT_JARS += \
    mediatek-telephony-common
endif

PRODUCT_COPY_FILES += vendor/mediatek/proprietary/frameworks/opt/GeoCoding/geocoding.db:system/etc/geocoding.db
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/frameworks/opt/GeoCoding/NumberHeadWithIDToByte:system/etc/NumberHeadWithIDToByte
endif

#sunhuihui@wind-mobi.com begin Feature#100649
ifeq ($(strip $(WIND_DEF_ASUS_SETTINGS)),yes)
    PRODUCT_PACKAGES += AsusSettings
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.asussettings=1
    $(call inherit-product-if-exists, packages/apps/AsusRes/asus_res.mk)
endif
#sunhuihui@wind-mobi.com end Feature#100649

#sunhuihui@wind-mobi.com begin Feature#102973
ifeq ($(strip $(WIND_DEF_ASUS_BLUELIGHT)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.asus_bluelight=1
    PRODUCT_COPY_FILES += device/mediatek/common/blue_Light_Filter/feature/asus.hardware.display.splendid.reading_mode.xml:system/etc/permissions/asus.hardware.display.splendid.reading_mode.xml
    PRODUCT_COPY_FILES += device/mediatek/common/blue_Light_Filter/feature/asus.hardware.display.splendid.xml:system/etc/permissions/asus.hardware.display.splendid.xml

    PRODUCT_COPY_FILES += device/mediatek/common/blue_Light_Filter/library/GammaSetting:system/bin/GammaSetting
    PRODUCT_COPY_FILES += device/mediatek/common/blue_Light_Filter/library/HSVSetting:system/bin/HSVSetting
endif
#sunhuihui@wind-mobi.com end Feature#102973

# Telephony
#modify by xulinchao@wind-mobi.com 2016.03.17 start
#PRODUCT_COPY_FILES += device/mediatek/common/apns-conf.xml:system/etc/apns-conf.xml
#PRODUCT_COPY_FILES += device/mediatek/common/spn-conf.xml:system/etc/spn-conf.xml
ifeq ($(WIND_APN_CONF), )
PRODUCT_COPY_FILES += device/mediatek/common/apns-conf.xml:system/etc/apns-conf.xml
else
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/frameworks/base/telephony/etc/$(WIND_APN_CONF):system/etc/apns-conf.xml
endif

ifeq ($(WIND_SPN_CONF), )
PRODUCT_COPY_FILES += device/mediatek/common/spn-conf.xml:system/etc/spn-conf.xml
else
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/frameworks/base/telephony/etc/$(WIND_SPN_CONF):system/etc/spn-conf.xml
endif

ifneq ($(WIND_VOICEMAIL_CONF), )
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/frameworks/base/telephony/etc/$(WIND_VOICEMAIL_CONF):system/etc/voicemail-conf.xml
endif
#modify by xulinchao@wind-mobi.com 2016.03.17 end

# Audio
PRODUCT_COPY_FILES += $(LOCAL_PATH)/audio_em.xml:system/etc/audio_em.xml

# For C2K CDMA feature file
ifeq ($(strip $(MTK_C2K_SUPPORT)), yes)
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml
endif

#MTB
PRODUCT_PACKAGES += mtk_setprop

#MMS
ifeq ($(strip $(MTK_BASIC_PACKAGE)), yes)
    ifndef MTK_TB_WIFI_3G_MODE
        PRODUCT_PACKAGES += messaging
    else
        ifeq ($(strip $(MTK_TB_WIFI_3G_MODE)), 3GDATA_SMS)
            PRODUCT_PACKAGES += messaging
        endif
    endif
endif

ifeq ($(strip $(MTK_BSP_PACKAGE)), yes)
    ifndef MTK_TB_WIFI_3G_MODE
        PRODUCT_PACKAGES += messaging
    else
        ifeq ($(strip $(MTK_TB_WIFI_3G_MODE)), 3GDATA_SMS)
            PRODUCT_PACKAGES += messaging
        endif
    endif
endif

ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
    ifneq ($(strip $(MTK_BSP_PACKAGE)), yes)
        ifneq ($(strip $(MTK_A1_FEATURE)), yes)
            ifndef MTK_TB_WIFI_3G_MODE
                PRODUCT_PACKAGES += MtkMms
            else
                ifeq ($(strip $(MTK_TB_WIFI_3G_MODE)), 3GDATA_SMS)
                    PRODUCT_PACKAGES += MtkMms
                endif
            endif
        endif
    endif
endif

ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
    ifneq ($(strip $(MTK_BSP_PACKAGE)), yes)
        PRODUCT_PACKAGES += MtkCalendar
        PRODUCT_PACKAGES += MtkBrowser
        PRODUCT_PACKAGES += MtkQuickSearchBox
    endif
endif

# Telephony begin
PRODUCT_PACKAGES += muxreport
PRODUCT_PACKAGES += mtkrild
PRODUCT_PACKAGES += mtk-ril
PRODUCT_PACKAGES += libutilrilmtk
PRODUCT_PACKAGES += gsm0710muxd
PRODUCT_PACKAGES += mtkrildmd2
PRODUCT_PACKAGES += mtk-rilmd2
PRODUCT_PACKAGES += librilmtkmd2
PRODUCT_PACKAGES += gsm0710muxdmd2
PRODUCT_PACKAGES += md_minilog_util
PRODUCT_PACKAGES += BSPTelephonyDevTool
PRODUCT_PACKAGES += ppl_agent
#A:WOS WOSFP3 liaoyuhuan@wind-mobi.com 060622 begin
ifeq ($(WOS_APP_FP3),yes)
    PRODUCT_PACKAGES += WOSAppLock
#    PRODUCT_PACKAGES += WOSFingerStart
    PRODUCT_PROPERTY_OVERRIDES += ro.wos_app_fp3=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wos_app_fp3=0
endif
#A:WOS WOSFP3 liaoyuhuan@wind-mobi.com 060622 end


ifeq ($(strip $(MTK_C2K_SUPPORT)), yes)
#For C2K RIL
PRODUCT_PACKAGES += \
          viarild \
          libc2kril \
          libviatelecom-withuim-ril \
          viaradiooptions \
          librpcril \
          ctclient

#Set CT6M_SUPPORT
ifeq ($(strip $(CT6M_SUPPORT)), yes)
PRODUCT_PACKAGES += CdmaSystemInfo
PRODUCT_PROPERTY_OVERRIDES += ro.ct6m_support=1
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/frameworks/base/telephony/etc/spn-conf-op09.xml:system/etc/spn-conf-op09.xml
endif

#For PPPD
PRODUCT_PACKAGES += \
          ip-up-cdma \
          ipv6-up-cdma \
          link-down-cdma \
          pppd_via

#For C2K control modules
PRODUCT_PACKAGES += \
          libc2kutils \
          flashlessd \
          statusd

#For C2K GPS
PRODUCT_PACKAGES += \
          libviagpsrpc \
          librpc
endif

# MAL shared library
PRODUCT_PACKAGES += libmdfx
PRODUCT_PACKAGES += libmal_mdmngr
PRODUCT_PACKAGES += libmal_nwmngr
PRODUCT_PACKAGES += libmal_rilproxy
PRODUCT_PACKAGES += libmal_simmngr
PRODUCT_PACKAGES += libmal_datamngr
PRODUCT_PACKAGES += libmal_rds
PRODUCT_PACKAGES += libmal_epdga
PRODUCT_PACKAGES += libmal_imsmngr
PRODUCT_PACKAGES += libmal

PRODUCT_PACKAGES += volte_imsm
PRODUCT_PACKAGES += volte_imspa

# VoLTE Process
ifeq ($(strip $(MTK_IMS_SUPPORT)),yes)
PRODUCT_PACKAGES += Gba
PRODUCT_PACKAGES += volte_xdmc
PRODUCT_PACKAGES += volte_core
PRODUCT_PACKAGES += volte_ua
PRODUCT_PACKAGES += volte_stack
PRODUCT_PACKAGES += volte_imcb
PRODUCT_PACKAGES += libipsec_ims

# MAL Process
PRODUCT_PACKAGES += mtkmal
# MAL init script
PRODUCT_COPY_FILES += device/mediatek/common/init.mal.rc:root/init.mal.rc

else
    ifeq ($(strip $(MTK_EPDG_SUPPORT)),yes) # EPDG without IMS

    # MAL Process
    PRODUCT_PACKAGES += mtkmal
    # MAL init script
    PRODUCT_COPY_FILES += device/mediatek/common/init.mal.rc:root/init.mal.rc
 
    endif
endif

# include init.volte.rc
ifeq ($(MTK_IMS_SUPPORT),yes)
    ifneq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/init.volte.rc),)
        PRODUCT_COPY_FILES += $(MTK_TARGET_PROJECT_FOLDER)/init.volte.rc:root/init.volte.rc
    else
        ifneq ($(wildcard $(MTK_PROJECT_FOLDER)/init.volte.rc),)
            PRODUCT_COPY_FILES += $(MTK_PROJECT_FOLDER)/init.volte.rc:root/init.volte.rc
        else
            PRODUCT_COPY_FILES += device/mediatek/common/init.volte.rc:root/init.volte.rc
        endif
    endif
endif

PRODUCT_PACKAGES += llibmtk_vt_swip
PRODUCT_PACKAGES += libmtk_vt_utils
PRODUCT_PACKAGES += libmtk_vt_wrapper
PRODUCT_PACKAGES += libmtk_vt_service
PRODUCT_PACKAGES += vtservice

# WFCA Process
ifeq ($(strip $(MTK_WFC_SUPPORT)),yes)
  PRODUCT_PACKAGES += wfca
  PRODUCT_COPY_FILES += device/mediatek/$(shell echo $(MTK_PLATFORM) | tr '[A-Z]' '[a-z]')/init.wfca.rc:root/init.wfca.rc
endif


# Hwui program binary service
PRODUCT_PACKAGES += program_binary_service

ifeq ($(strip $(MTK_RCS_SUPPORT)),yes)
PRODUCT_PACKAGES += Gba
PRODUCT_PACKAGES += libjni_mds
endif

ifeq ($(strip $(MTK_PRIVACY_PROTECTION_LOCK)),yes)
  PRODUCT_PACKAGES += PrivacyProtectionLock
endif

ifeq ($(strip $(MTK_USB_CBA_SUPPORT)),yes)
#xiongshigui@wind-mobi.com 20160514 mod begin	
ifneq ($(TARGET_BUILD_VARIANT),eng)	
  PRODUCT_PACKAGES += UsbChecker
endif
#xiongshigui@wind-mobi.com 20160514 mod end
endif

ifeq ($(strip $(GOOGLE_RELEASE_RIL)), yes)
    PRODUCT_PACKAGES += libril
else
    PRODUCT_PACKAGES += librilmtk
endif
# Telephony end

# For MTK Camera
PRODUCT_PACKAGES += Camera

ifeq ($(strip $(MTK_HEART_RATE_MONITOR_SUPPORT)),yes)
PRODUCT_PACKAGES += HeartRate
endif

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += camera.disable_zsl_mode=1

PRODUCT_PACKAGES += libBnMtkCodec
PRODUCT_PACKAGES += MtkCodecService
PRODUCT_PACKAGES += autokd
RODUCT_PACKAGES += \
    dhcp6c \
    dhcp6ctl \
    dhcp6c.conf \
    dhcp6cDNS.conf \
    dhcp6s \
    dhcp6s.conf \
    dhcp6c.script \
    dhcp6cctlkey \
    libifaddrs

# meta tool
ifeq ($(MTK_INTERNAL),yes)
ifneq ($(wildcard vendor/mediatek/proprietary/buildinfo/label.ini),)
  include vendor/mediatek/proprietary/buildinfo/label.ini
  ifeq ($(MTK_BUILD_VERNO),ALPS.W10.24.p0)
    MTK_BUILD_VERNO := $(MTK_INTERNAL_BUILD_VERNO)
  endif
  ifeq ($(MTK_WEEK_NO),W10.24)
    MTK_WEEK_NO := $(MTK_INTERNAL_WEEK_NO)
  endif
endif
endif
$(call inherit-product-if-exists, vendor/mediatek/proprietary/buildinfo/branch.mk)
PRODUCT_PROPERTY_OVERRIDES += ro.mediatek.version.release=$(strip $(MTK_BUILD_VERNO))
PRODUCT_PROPERTY_OVERRIDES += ro.mediatek.version.sdk=4

# To specify customer's releasekey
ifeq ($(MTK_INTERNAL),yes)
  PRODUCT_DEFAULT_DEV_CERTIFICATE := device/mediatek/common/security/releasekey
else
  ifeq ($(MTK_SIGNATURE_CUSTOMIZATION),yes)
    ifeq ($(wildcard device/mediatek/common/security/$(strip $(MTK_TARGET_PROJECT))),)
      $(error Please create device/mediatek/common/security/$(strip $(MTK_TARGET_PROJECT))/ and put your releasekey there!!)
    else
      PRODUCT_DEFAULT_DEV_CERTIFICATE := device/mediatek/common/security/$(strip $(MTK_TARGET_PROJECT))/releasekey
    endif
  else
#   Not specify PRODUCT_DEFAULT_DEV_CERTIFICATE and the default testkey will be used.
  endif
endif

# Handheld core hardware
PRODUCT_COPY_FILES += frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml

# Bluetooth Low Energy Capability
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

# Customer configurations
ifneq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/custom.conf),)
PRODUCT_COPY_FILES += $(MTK_TARGET_PROJECT_FOLDER)/custom.conf:system/etc/custom.conf
else
ifdef OPTR_SPEC_SEG_DEF
    ifneq ($(strip $(OPTR_SPEC_SEG_DEF)),NONE)
        OPTR := $(word 1,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
        SPEC := $(word 2,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
        SEG  := $(word 3,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
        ifneq ($(wildcard vendor/mediatek/proprietary/operator/$(OPTR)/$(SPEC)/$(SEG)/custom.conf),)
        PRODUCT_COPY_FILES += vendor/mediatek/proprietary/operator/$(OPTR)/$(SPEC)/$(SEG)/custom.conf:system/etc/custom.conf
        else
        PRODUCT_COPY_FILES += device/mediatek/common/custom.conf:system/etc/custom.conf
        endif
    else
        PRODUCT_COPY_FILES += device/mediatek/common/custom.conf:system/etc/custom.conf
    endif
else
    PRODUCT_COPY_FILES += device/mediatek/common/custom.conf:system/etc/custom.conf
endif
endif

# Recovery
PRODUCT_COPY_FILES += $(MTK_PROJECT_FOLDER)/recovery.fstab:system/etc/recovery.fstab

ifndef MTK_PLATFORM_DIR
  ifneq ($(wildcard device/mediatek/$(MTK_PLATFORM)),)
    MTK_PLATFORM_DIR = $(MTK_PLATFORM)
  else
    MTK_PLATFORM_DIR = $(shell echo $(MTK_PLATFORM) | tr '[A-Z]' '[a-z]')
  endif
endif

ifeq ($(wildcard device/mediatek/$(MTK_PLATFORM_DIR)),)
  $(error the platform dir changed, expected: device/mediatek/$(MTK_PLATFORM_DIR), please check manually)
endif

#qiancheng@wind-mobi.com 20160511 add start
# GMS interface
#ifdef BUILD_GMS
#ifeq ($(strip $(BUILD_GMS)), yes)
#$(call inherit-product-if-exists, vendor/asus-prebuilt-E281L/T552TLC/google/products/gms.mk)

#PRODUCT_PROPERTY_OVERRIDES += \
#      ro.com.google.clientidbase=alps-$(TARGET_PRODUCT)-{country} \
#      ro.com.google.clientidbase.ms=alps-$(TARGET_PRODUCT)-{country} \
#      ro.com.google.clientidbase.yt=alps-$(TARGET_PRODUCT)-{country} \
#      ro.com.google.clientidbase.am=alps-$(TARGET_PRODUCT)-{country} \
#      ro.com.google.clientidbase.gmm=alps-$(TARGET_PRODUCT)-{country}
#endif
#endif
#qiancheng@wind-mobi.com 20160511 add end

# prebuilt interface
$(call inherit-product-if-exists, vendor/mediatek/common/device-vendor.mk)
# SIP VoIP
$(call inherit-product-if-exists, vendor/mediatek/proprietary/external/sip/sip.mk)

# AEE Config
ifeq ($(HAVE_AEE_FEATURE),yes)
  ifneq ($(MTK_CHIPTEST_INT),yes)
    ifneq ($(wildcard vendor/mediatek/proprietary/external/aee_config_internal/init.aee.mtk.rc),)
$(call inherit-product-if-exists, vendor/mediatek/proprietary/external/aee_config_internal/aee.mk)
    else
$(call inherit-product-if-exists, vendor/mediatek/proprietary/external/aee/config_external/aee.mk)
    endif
  else
$(call inherit-product-if-exists, vendor/mediatek/proprietary/external/aee/config_external/aee.mk)
  endif
endif

# mtklog config
ifeq ($(strip $(MTK_BASIC_PACKAGE)), yes)
ifeq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_COPY_FILES += device/mediatek/common/mtklog/mtklog-config-basic-eng.prop:system/etc/mtklog-config.prop
else
PRODUCT_COPY_FILES += device/mediatek/common/mtklog/mtklog-config-basic-user.prop:system/etc/mtklog-config.prop
endif
else
ifeq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_COPY_FILES += device/mediatek/common/mtklog/mtklog-config-bsp-eng.prop:system/etc/mtklog-config.prop
else
PRODUCT_COPY_FILES += device/mediatek/common/mtklog/mtklog-config-bsp-user.prop:system/etc/mtklog-config.prop
endif
endif

# ECC List Customization
$(call inherit-product-if-exists, vendor/mediatek/proprietary/external/EccList/EccList.mk)

#fonts
$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
$(call inherit-product-if-exists, external/naver-fonts/fonts.mk)
$(call inherit-product-if-exists, external/noto-fonts/fonts.mk)
$(call inherit-product-if-exists, external/roboto-fonts/fonts.mk)
$(call inherit-product-if-exists, frameworks/base/data/fonts/openfont/fonts.mk)

#3Dwidget
$(call inherit-product-if-exists, vendor/mediatek/proprietary/frameworks/base/3dwidget/appwidget.mk)

# AAPT Config
$(call inherit-product-if-exists, device/mediatek/common/aapt/aapt_config.mk)

#
# MediaTek Operator features configuration
#

ifdef OPTR_SPEC_SEG_DEF
  ifneq ($(strip $(OPTR_SPEC_SEG_DEF)),NONE)
    OPTR := $(word 1,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
    SPEC := $(word 2,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
    SEG  := $(word 3,$(subst _,$(space),$(OPTR_SPEC_SEG_DEF)))
    $(call inherit-product-if-exists, vendor/mediatek/proprietary/operator/$(OPTR)/$(SPEC)/$(SEG)/optr_apk_config.mk)

    PRODUCT_PROPERTY_OVERRIDES += \
      ro.operator.optr=$(OPTR) \
      ro.operator.spec=$(SPEC) \
      ro.operator.seg=$(SEG)
  endif
endif

# add for ATCI JAVA layer service
PRODUCT_PACKAGES += AtciService

PRODUCT_PACKAGES += DataTransfer

# add for OMA DM, common module used by MediatekDM & red bend DM
PRODUCT_PACKAGES += dm_agent_binder

# red bend DM config files & lib
ifeq ($(strip $(MTK_DM_APP)),yes)
    PRODUCT_PACKAGES += reminder.xml
    PRODUCT_PACKAGES += tree.xml
    PRODUCT_PACKAGES += DmApnInfo.xml
    PRODUCT_PACKAGES += vdmconfig.xml
    PRODUCT_PACKAGES += libvdmengine.so
    PRODUCT_PACKAGES += libvdmfumo.so
    PRODUCT_PACKAGES += libvdmlawmo.so
    PRODUCT_PACKAGES += libvdmscinv.so
    PRODUCT_PACKAGES += libvdmscomo.so
    PRODUCT_PACKAGES += dm
endif

# MediatekDM package & lib
ifeq ($(strip $(MTK_MDM_APP)),yes)
    PRODUCT_PACKAGES += MediatekDM
    PRODUCT_PACKAGES += libjni_mdm
endif

# SmsReg package
ifeq ($(strip $(MTK_SMSREG_APP)),yes)
    PRODUCT_PACKAGES += SmsReg
endif

ifeq ($(strip $(MTK_CMCC_FT_PRECHECK_SUPPORT)),yes)
  PRODUCT_PACKAGES += FTPreCheck
endif

ifeq ($(strip $(OPTR_SPEC_SEG_DEF)),OP09_SPEC0212_SEGDEFAULT)
    PRODUCT_PACKAGES += ConfigureCheck
else
    ifeq ($(strip $(CT6M_SUPPORT)), yes)
        PRODUCT_PACKAGES += ConfigureCheck
    endif
endif

$(call inherit-product-if-exists, vendor/mediatek/proprietary/frameworks/base/voicecommand/cfg/voicecommand.mk)

ifeq ($(strip $(MTK_VOICE_UNLOCK_SUPPORT)),yes)
    PRODUCT_PACKAGES += VoiceCommand
else
    ifeq ($(strip $(MTK_VOICE_UI_SUPPORT)),yes)
        PRODUCT_PACKAGES += VoiceCommand
    else
        ifeq ($(strip $(MTK_VOICE_CONTACT_SEARCH_SUPPORT)),yes)
            PRODUCT_PACKAGES += VoiceCommand
        else
            ifeq ($(strip $(MTK_VOW_SUPPORT)),yes)
                PRODUCT_PACKAGES += VoiceCommand
            endif
        endif
    endif
endif

ifeq ($(strip $(MTK_VOICE_UNLOCK_SUPPORT)),yes)
    PRODUCT_PACKAGES += VoiceUnlock
else
    ifeq ($(strip $(MTK_VOW_SUPPORT)),yes)
        PRODUCT_PACKAGES += VoiceUnlock
    endif
endif

ifeq ($(strip $(MTK_REGIONALPHONE_SUPPORT)), yes)
  PRODUCT_PACKAGES += RegionalPhoneManager
endif

ifeq ($(strip $(MTK_MDLOGGER_SUPPORT)),yes)
  PRODUCT_PACKAGES += \
    libmdloggerrecycle \
    libmemoryDumpEncoder \
    mdlogger
ifeq ($(strip $(MTK_ENABLE_MD1)), yes)
  PRODUCT_PACKAGES += emdlogger1
endif
ifeq ($(strip $(MTK_ENABLE_MD2)), yes)
  PRODUCT_PACKAGES += emdlogger2
endif
ifeq ($(strip $(MTK_ENABLE_MD5)), yes)
  PRODUCT_PACKAGES += emdlogger5
endif
#  $(call inherit-product-if-exists, vendor/mediatek/proprietary/protect-app/external/emdlogger/usb_port.mk)
  ifneq ($(wildcard device/mediatek/$(shell echo $(MTK_PLATFORM) | tr '[A-Z]' '[a-z]')/emdlogger_usb_config.prop),)
   PRODUCT_COPY_FILES += device/mediatek/$(shell echo $(MTK_PLATFORM) | tr '[A-Z]' '[a-z]')/emdlogger_usb_config.prop:system/etc/emdlogger_usb_config.prop
  endif
endif

ifeq ($(strip $(MTK_C2K_SUPPORT)), yes)
    PRODUCT_PACKAGES += cmddumper
    PRODUCT_PACKAGES += c2k-ril-prop
endif

ifeq ($(strip $(MTK_FW_UPGRADE)), yes)
PRODUCT_PACKAGES += FWUpgrade \
                    FWUpgradeProvider
PRODUCT_COPY_FILES += vendor/mediatek/proprietary/packages/apps/FWUpgrade/fotabinder:system/bin/fotabinder
endif

ifeq ($(strip $(MTK_USB_CBA_SUPPORT)), yes)
#xiongshigui@wind-mobi.com 20160514 mod begin   
ifneq ($(TARGET_BUILD_VARIANT),eng)
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_usb_cba_support=1
endif	
#xiongshigui@wind-mobi.com 20160514 mod end
endif

ifeq ($(strip $(MTK_FOTA_SUPPORT)), yes)
   PRODUCT_PACKAGES += fota1
endif

ifeq ($(strip $(GEMINI)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_gemini_support=1
  PRODUCT_PROPERTY_OVERRIDES += persist.radio.gemini_support=1
endif

ifeq ($(strip $(MTK_SHARE_MODEM_CURRENT)),1)
  PRODUCT_PROPERTY_OVERRIDES += ril.current.share_modem=1
endif
ifeq ($(strip $(MTK_SHARE_MODEM_CURRENT)),2)
  PRODUCT_PROPERTY_OVERRIDES += ril.current.share_modem=2
endif
ifeq ($(strip $(MTK_SHARE_MODEM_CURRENT)),3)
  PRODUCT_PROPERTY_OVERRIDES += ril.current.share_modem=3
endif
ifeq ($(strip $(MTK_SHARE_MODEM_CURRENT)),4)
  PRODUCT_PROPERTY_OVERRIDES += ril.current.share_modem=4
endif


ifeq ($(strip $(MTK_AUDIO_PROFILES)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_audio_profiles=1
endif

ifeq ($(strip $(MTK_AUDENH_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_audenh_support=1
endif

# MTK_LOSSLESS_BT
ifeq ($(strip $(MTK_LOSSLESS_BT_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_lossless_bt_audio=1
endif

# MTK_LOUNDNESS
ifeq ($(strip $(MTK_BESLOUDNESS_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_besloudness_support=1
endif

# MTK_BESSURROUND
ifeq ($(strip $(MTK_BESSURROUND_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_bessurround_support=1
endif

ifeq ($(strip $(MTK_MEMORY_COMPRESSION_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mem_comp_support=1
endif

ifeq ($(strip $(MTK_WAPI_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wapi_support=1
endif

ifeq ($(strip $(MTK_BT_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_bt_support=1
endif

ifeq ($(strip $(MTK_WAPPUSH_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wappush_support=1
endif

ifeq ($(strip $(MTK_AGPS_APP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_agps_app=1
endif

ifeq ($(strip $(MTK_FM_TX_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_fm_tx_support=1
endif

ifeq ($(strip $(MTK_VT3G324M_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_vt3g324m_support=1
endif

ifeq ($(strip $(MTK_VOICE_UI_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_voice_ui_support=1
endif

ifeq ($(strip $(MTK_VOICE_UNLOCK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_voice_unlock_support=1
endif

ifeq ($(strip $(MTK_VOICE_CONTACT_SEARCH_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_voice_contact_support=1
endif

ifneq ($(MTK_AUDIO_TUNING_TOOL_VERSION),)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_audio_tuning_tool_ver=$(strip $(MTK_AUDIO_TUNING_TOOL_VERSION)) 
else
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_audio_tuning_tool_ver=V1
endif

ifeq ($(strip $(MTK_DM_APP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_dm_app=1
endif

ifeq ($(strip $(MTK_MATV_ANALOG_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_matv_analog_support=1
endif

ifeq ($(strip $(MTK_WLAN_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wlan_support=1
  PRODUCT_PACKAGES += halutil
endif

ifeq ($(strip $(MTK_IPO_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_ipo_support=1
endif

ifeq ($(strip $(MTK_GPS_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_gps_support=1
endif

ifeq ($(strip $(MTK_OMACP_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_omacp_support=1
endif

ifeq ($(strip $(HAVE_MATV_FEATURE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.have_matv_feature=1
endif

ifeq ($(strip $(MTK_BT_FM_OVER_BT_VIA_CONTROLLER)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_bt_fm_over_bt=1
endif

ifeq ($(strip $(MTK_SEARCH_DB_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_search_db_support=1
endif

ifeq ($(strip $(MTK_DIALER_SEARCH_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_dialer_search_support=1
endif

ifeq ($(strip $(MTK_DHCPV6C_WIFI)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_dhcpv6c_wifi=1
endif

ifeq ($(strip $(MTK_FM_SHORT_ANTENNA_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_fm_short_antenna_support=1
endif

ifeq ($(strip $(HAVE_AACENCODE_FEATURE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.have_aacencode_feature=1
endif

ifeq ($(strip $(MTK_CTA_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cta_support=1
endif

ifeq ($(strip $(MTK_CLEARMOTION_SUPPORT)),yes)
  PRODUCT_PACKAGES += libMJCjni
    ifeq ($(strip $(OPTR_SPEC_SEG_DEF)),OP01_SPEC0200_SEGC)
        PRODUCT_PROPERTY_OVERRIDES += \
          persist.sys.display.clearMotion=0
    else
        PRODUCT_PROPERTY_OVERRIDES += \
          persist.sys.display.clearMotion=1
    endif
  PRODUCT_PROPERTY_OVERRIDES += \
    persist.clearMotion.fblevel.nrm=255
  PRODUCT_PROPERTY_OVERRIDES += \
    persist.clearMotion.fblevel.bdr=255
endif

ifeq ($(strip $(MTK_PHONE_VT_VOICE_ANSWER)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_phone_vt_voice_answer=1
endif

ifeq ($(strip $(MTK_PHONE_VOICE_RECORDING)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_phone_voice_recording=1
endif

ifeq ($(strip $(MTK_POWER_SAVING_SWITCH_UI_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_pwr_save_switch=1
endif

ifeq ($(strip $(MTK_FD_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_fd_support=1
endif

ifeq ($(strip $(MTK_CC33_SUPPORT)), yes)
# Only support the format: 0: turn off / 1: turn on
    PRODUCT_PROPERTY_OVERRIDES += persist.data.cc33.support=1
endif

#DRM part
ifeq ($(strip $(MTK_DRM_APP)), yes)
  #OMA DRM
  ifeq ($(strip $(MTK_OMADRM_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_oma_drm_support=1
  endif
  #CTA DRM
  ifeq ($(strip $(MTK_CTA_SET)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cta_drm_support=1
  endif
endif

#Widevine DRM
ifeq ($(strip $(MTK_WVDRM_SUPPORT)), yes)
  #PRODUCT_PROPERTY_OVERRIDES += ro.mtk_widevine_drm_support=1
  ifeq ($(strip $(MTK_WVDRM_L1_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_widevine_drm_l1_support=1
  else
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_widevine_drm_l3_support=1
  endif
endif

#Playready DRM
ifeq ($(strip $(MTK_PLAYREADY_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_playready_drm_support=1
endif

########
ifeq ($(strip $(MTK_DISABLE_CAPABILITY_SWITCH)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_disable_cap_switch=1
endif

ifeq ($(strip $(MTK_EAP_SIM_AKA)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_eap_sim_aka=1
endif

ifeq ($(strip $(MTK_LOG2SERVER_APP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_log2server_app=1
endif

ifeq ($(strip $(MTK_FM_RECORDING_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_fm_recording_support=1
endif

ifeq ($(strip $(MTK_AUDIO_APE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_audio_ape_support=1
endif

ifeq ($(strip $(MTK_FLV_PLAYBACK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_flv_playback_support=1
endif

ifeq ($(strip $(MTK_FD_FORCE_REL_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_fd_force_rel_support=1
endif

ifeq ($(strip $(MTK_BRAZIL_CUSTOMIZATION_CLARO)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.brazil_cust_claro=1
endif

ifeq ($(strip $(MTK_BRAZIL_CUSTOMIZATION_VIVO)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.brazil_cust_vivo=1
endif

ifeq ($(strip $(MTK_WMV_PLAYBACK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wmv_playback_support=1
endif

ifeq ($(strip $(MTK_HDMI_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_hdmi_support=1
endif

ifeq ($(strip $(MTK_FOTA_ENTRY)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_fota_entry=1
endif

ifeq ($(strip $(MTK_SCOMO_ENTRY)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_scomo_entry=1
endif

ifeq ($(strip $(MTK_MTKPS_PLAYBACK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mtkps_playback_support=1
endif

ifeq ($(strip $(MTK_SEND_RR_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_send_rr_support=1
endif

ifeq ($(strip $(MTK_RAT_WCDMA_PREFERRED)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_rat_wcdma_preferred=1
endif

ifeq ($(strip $(OPTR_SPEC_SEG_DEF)),OP09_SPEC0212_SEGDEFAULT)
  PRODUCT_PACKAGES += DeviceRegister
  PRODUCT_PACKAGES += SelfRegister
else

  ifeq ($(strip $(CT6M_SUPPORT)), yes)
    PRODUCT_PACKAGES += DeviceRegister
    PRODUCT_PACKAGES += SelfRegister
  else

    ifeq ($(strip $(MTK_DEVREG_APP)),yes)
  	  PRODUCT_PACKAGES += DeviceRegister
    endif

    ifeq ($(strip $(MTK_CT4GREG_APP)),yes)
      PRODUCT_PACKAGES += SelfRegister
    endif

  endif
endif

ifeq ($(strip $(MTK_ESN_TRACK_APP)),yes)
  PRODUCT_PACKAGES += EsnTrack
endif

ifeq ($(strip $(MTK_ESN_TRACK_APP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += persist.sys.esn_track_switch=0
endif

ifeq ($(strip $(MTK_SMSREG_APP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_smsreg_app=1
endif

ifeq ($(strip $(MTK_DEFAULT_DATA_OFF)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_default_data_off=1
endif

ifeq ($(strip $(MTK_TB_APP_CALL_FORCE_SPEAKER_ON)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_tb_call_speaker_on=1
endif

ifeq ($(strip $(MTK_EMMC_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_emmc_support=1
endif

ifeq ($(strip $(MTK_FM_50KHZ_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_fm_50khz_support=1
endif

ifeq ($(strip $(MTK_BSP_PACKAGE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_bsp_package=1
endif

ifeq ($(strip $(MTK_TETHERINGIPV6_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_tetheringipv6_support=1
endif

ifeq ($(strip $(MTK_PHONE_NUMBER_GEODESCRIPTION)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_phone_number_geo=1
endif

ifeq ($(strip $(MTK_DT_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_dt_support=1
endif

ifeq ($(strip $(MTK_C2K_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_c2k_support=1
  PRODUCT_PROPERTY_OVERRIDES += persist.radio.flashless.fsm=0
  PRODUCT_PROPERTY_OVERRIDES += persist.radio.flashless.fsm_cst=0
  PRODUCT_PROPERTY_OVERRIDES += persist.radio.flashless.fsm_rw=0

  PRODUCT_PROPERTY_OVERRIDES += ro.cdma.cfu.enable=*72
  PRODUCT_PROPERTY_OVERRIDES += ro.cdma.cfu.disable=*720
  PRODUCT_PROPERTY_OVERRIDES += ro.cdma.cfb.enable=*90
  PRODUCT_PROPERTY_OVERRIDES += ro.cdma.cfb.disable=*900
  PRODUCT_PROPERTY_OVERRIDES += ro.cdma.cfnr.enable=*92
  PRODUCT_PROPERTY_OVERRIDES += ro.cdma.cfnr.disable=*920
  PRODUCT_PROPERTY_OVERRIDES += ro.cdma.cfdf.enable=*68
  PRODUCT_PROPERTY_OVERRIDES += ro.cdma.cfdf.disable=*680
  PRODUCT_PROPERTY_OVERRIDES += ro.cdma.cfall.disable=*730

  # callWaiting
  PRODUCT_PROPERTY_OVERRIDES += ro.cdma.cw.enable=*74
  PRODUCT_PROPERTY_OVERRIDES += ro.cdma.cw.disable=*740

  # network property
ifeq ($(strip $(GEMINI)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.telephony.default_network=4,0
  else
   PRODUCT_PROPERTY_OVERRIDES += ro.telephony.default_network=4
endif
endif

ifeq ($(strip $(EVDO_DT_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.evdo_dt_support=1
endif

ifeq ($(strip $(EVDO_DT_VIA_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.evdo_dt_via_support=1
endif

ifeq ($(strip $(MTK_SVLTE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_svlte_support=1
  PRODUCT_PROPERTY_OVERRIDES += mtk.md1.status=stop
  PRODUCT_PROPERTY_OVERRIDES += mtk.md3.status=stop
endif

ifeq ($(strip $(MTK_SRLTE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_srlte_support=1
  PRODUCT_PROPERTY_OVERRIDES += mtk.md1.status=stop
  PRODUCT_PROPERTY_OVERRIDES += mtk.md3.status=stop
endif

ifeq ($(strip $(MTK_SVLTE_LCG_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_svlte_lcg_support=1
endif

ifeq ($(strip $(MTK_IRAT_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.c2k.irat.support=1
endif

ifeq ($(strip $(MTK_C2K_SLOT2_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk.c2k.slot2.support=1
endif

ifeq ($(strip $(MTK_SHARED_SDCARD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_shared_sdcard=1
endif

ifeq ($(strip $(MTK_2SDCARD_SWAP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_2sdcard_swap=1
endif

ifeq ($(strip $(MTK_RAT_BALANCING)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_rat_balancing=1
endif

ifeq ($(strip $(WIFI_WEP_KEY_ID_SET)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.wifi_wep_key_id_set=1
endif

ifeq ($(strip $(OP01_COMPATIBLE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.op01_compatible=1
endif

ifeq ($(strip $(MTK_ENABLE_MD1)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_enable_md1=1
endif

ifeq ($(strip $(MTK_ENABLE_MD2)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_enable_md2=1
endif

ifeq ($(strip $(MTK_ENABLE_MD3)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_enable_md3=1
endif

ifeq ($(strip $(MTK_ANDROID_FOR_WORK_SUPPORT)), yes)
    PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.device_admin.xml:system/etc/permissions/android.software.device_admin.xml
    PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.managed_users.xml:system/etc/permissions/android.software.managed_users.xml
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_afw_support=1
endif

#For SOTER
ifeq ($(strip $(MTK_SOTER_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_soter_support=1
endif

ifeq ($(strip $(MTK_NETWORK_TYPE_ALWAYS_ON)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_network_type_always_on=1
endif

ifeq ($(strip $(MTK_NFC_ADDON_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_nfc_addon_support=1
endif

ifeq ($(strip $(MTK_BENCHMARK_BOOST_TP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_benchmark_boost_tp=1
endif

ifeq ($(strip $(MTK_FLIGHT_MODE_POWER_OFF_MD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_flight_mode_power_off_md=1
endif

ifeq ($(strip $(MTK_BT_BLE_MANAGER_SUPPORT)), yes)
  PRODUCT_PACKAGES += BluetoothLe \
                      BLEManager
endif

#For GattProfile
PRODUCT_PACKAGES += GattProfile

ifeq ($(strip $(MTK_AAL_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_aal_support=1
endif

ifeq ($(strip $(MTK_ULTRA_DIMMING_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_ultra_dimming_support=1
endif

ifneq ($(strip $(MTK_PQ_SUPPORT)), no)
    ifeq ($(strip $(MTK_PQ_SUPPORT)), PQ_HW_VER_2)
      PRODUCT_PROPERTY_OVERRIDES += ro.mtk_pq_support=2
    else
        ifeq ($(strip $(MTK_PQ_SUPPORT)), PQ_HW_VER_3)
          PRODUCT_PROPERTY_OVERRIDES += ro.mtk_pq_support=3
        endif
    endif
endif

ifeq ($(strip $(MTK_MIRAVISION_SETTING_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_miravision_support=1
endif

ifeq ($(strip $(MTK_MIRAVISION_SETTING_SUPPORT)), yes)
  PRODUCT_PACKAGES += MiraVision
endif

ifeq ($(strip $(MTK_MIRAVISION_IMAGE_DC_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_miravision_image_dc=1
endif

ifeq ($(strip $(MTK_TETHERING_EEM_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_tethering_eem_support=1
endif

ifeq ($(strip $(MTK_WFD_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wfd_support=1
endif

ifeq ($(strip $(MTK_WFD_SINK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wfd_sink_support=1
endif

ifeq ($(strip $(MTK_WFD_SINK_UIBC_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wfd_sink_uibc_support=1
endif

ifeq ($(strip $(MTK_WIFI_MCC_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wifi_mcc_support=1
endif

ifeq ($(strip $(MTK_BEAM_PLUS_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_beam_plus_support=1
endif

ifeq ($(strip $(MTK_MT8193_HDMI_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mt8193_hdmi_support=1
endif

ifeq ($(strip $(MTK_GEMINI_3SIM_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_gemini_3sim_support=1
endif

ifeq ($(strip $(MTK_GEMINI_4SIM_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_gemini_4sim_support=1
endif

ifeq ($(strip $(MTK_SYSTEM_UPDATE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_system_update_support=1
endif

ifeq ($(strip $(MTK_SIM_HOT_SWAP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_sim_hot_swap=1
endif

ifeq ($(strip $(MTK_VIDEO_THUMBNAIL_PLAY_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_thumbnail_play_support=1
endif

ifeq ($(strip $(MTK_RADIOOFF_POWER_OFF_MD)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_radiooff_power_off_md=1
endif

ifeq ($(strip $(MTK_BIP_SCWS)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_bip_scws=1
endif

ifeq (OP09,$(word 1,$(subst _, ,$(OPTR_SPEC_SEG_DEF))))
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_ctpppoe_support=1
endif

ifeq ($(strip $(MTK_IPV6_TETHER_PD_MODE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_ipv6_tether_pd_mode=1
endif

ifeq ($(strip $(MTK_CACHE_MERGE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cache_merge_support=1
endif

ifeq ($(strip $(MTK_FAT_ON_NAND)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_fat_on_nand=1
endif

ifeq ($(strip $(MTK_GMO_RAM_OPTIMIZE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_gmo_ram_optimize=1
endif

ifeq ($(strip $(MTK_GMO_ROM_OPTIMIZE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_gmo_rom_optimize=1
endif

ifeq ($(strip $(MTK_CMCC_FT_PRECHECK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cmcc_ft_precheck_support=1
endif

ifeq ($(strip $(MTK_MDM_APP)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mdm_app=1
endif

ifeq ($(strip $(MTK_MDM_LAWMO)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mdm_lawmo=1
endif

ifeq ($(strip $(MTK_MDM_FUMO)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mdm_fumo=1
endif

ifeq ($(strip $(MTK_MDM_SCOMO)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mdm_scomo=1
endif

ifeq ($(strip $(MTK_MULTISIM_RINGTONE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_multisim_ringtone=1
endif

ifeq ($(strip $(MTK_MT8193_HDCP_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mt8193_hdcp_support=1
endif

ifeq ($(strip $(PURE_AP_USE_EXTERNAL_MODEM)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.pure_ap_use_external_modem=1
endif

ifeq ($(strip $(MTK_WFD_HDCP_TX_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wfd_hdcp_tx_support=1
endif

ifeq ($(strip $(MTK_WFD_HDCP_RX_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wfd_hdcp_rx_support=1
endif

ifeq ($(strip $(MTK_WORLD_PHONE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_world_phone=1
endif

ifeq ($(strip $(MTK_WORLD_PHONE_POLICY)), 1)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_world_phone_policy=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_world_phone_policy=0
endif

ifeq ($(strip $(MTK_WORLD_PHONE)), yes)
  ifeq ($(strip $(MTK_MD1_SUPPORT)), 8)
    PRODUCT_PROPERTY_OVERRIDES +=ro.mtk_md_world_mode_support=1
  else
    ifeq ($(strip $(MTK_MD1_SUPPORT)), 9)
      PRODUCT_PROPERTY_OVERRIDES +=ro.mtk_md_world_mode_support=1
    else
      ifeq ($(strip $(MTK_MD1_SUPPORT)), 10)
        PRODUCT_PROPERTY_OVERRIDES +=ro.mtk_md_world_mode_support=1
      else
        ifeq ($(strip $(MTK_MD1_SUPPORT)), 11)
          PRODUCT_PROPERTY_OVERRIDES +=ro.mtk_md_world_mode_support=1
        else
          ifeq ($(strip $(MTK_MD1_SUPPORT)), 12)
            PRODUCT_PROPERTY_OVERRIDES +=ro.mtk_md_world_mode_support=1
          else
            ifeq ($(strip $(MTK_MD1_SUPPORT)), 13)
              PRODUCT_PROPERTY_OVERRIDES +=ro.mtk_md_world_mode_support=1
            else
              ifeq ($(strip $(MTK_MD1_SUPPORT)), 14)
                PRODUCT_PROPERTY_OVERRIDES +=ro.mtk_md_world_mode_support=1
              else
                PRODUCT_PROPERTY_OVERRIDES +=ro.mtk_md_world_mode_support=0
              endif
            endif
          endif
        endif
      endif
    endif
  endif
endif

ifeq ($(strip $(MTK_PERFSERVICE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_perfservice_support=1
endif

ifeq ($(strip $(MTK_HW_KEY_REMAPPING)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_hw_key_remapping=1
endif

ifeq ($(strip $(MTK_AUDIO_CHANGE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_audio_change_support=1
endif

ifeq ($(strip $(MTK_LOW_BAND_TRAN_ANIM)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_low_band_tran_anim=1
endif

ifeq ($(strip $(MTK_HDMI_HDCP_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_hdmi_hdcp_support=1
endif

ifeq ($(strip $(MTK_INTERNAL_HDMI_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_internal_hdmi_support=1
endif

ifeq ($(strip $(MTK_INTERNAL_MHL_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_internal_mhl_support=1
endif

ifeq ($(strip $(MTK_OWNER_SDCARD_ONLY_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_owner_sdcard_support=1
endif

ifeq ($(strip $(MTK_ONLY_OWNER_SIM_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_owner_sim_support=1
endif

ifeq ($(strip $(MTK_SIM_HOT_SWAP_COMMON_SLOT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_sim_hot_swap_common_slot=1
endif

ifeq ($(strip $(MTK_CTA_SET)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cta_set=1
endif

ifeq ($(strip $(MTK_CTSC_MTBF_INTERNAL_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_ctsc_mtbf_intersup=1
endif

ifeq ($(strip $(MTK_3GDONGLE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_3gdongle_support=1
endif

ifeq ($(strip $(OPTR_SPEC_SEG_DEF)),OP09_SPEC0212_SEGDEFAULT)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_devreg_app=1
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_ct4greg_app=1
else

  ifeq ($(strip $(CT6M_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_devreg_app=1
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_ct4greg_app=1
  else

    ifeq ($(strip $(MTK_DEVREG_APP)),yes)
      PRODUCT_PROPERTY_OVERRIDES += ro.mtk_devreg_app=1
    endif

    ifeq ($(strip $(MTK_CT4GREG_APP)),yes)
      PRODUCT_PROPERTY_OVERRIDES += ro.mtk_ct4greg_app=1
    endif

  endif
endif

ifeq ($(strip $(EVDO_IR_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.evdo_ir_support=1
endif

ifeq ($(strip $(MTK_MULTI_PARTITION_MOUNT_ONLY_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_multi_patition=1
endif

ifeq ($(strip $(MTK_WIFI_CALLING_RIL_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wifi_calling_ril_support=1
endif

ifeq ($(strip $(MTK_DRM_KEY_MNG_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_drm_key_mng_support=1
endif

ifeq ($(strip $(MTK_DOLBY_DAP_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_dolby_dap_support=1
endif

ifeq ($(strip $(MTK_MOBILE_MANAGEMENT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_mobile_management=1
endif

ifeq ($(strip $(MTK_RUNTIME_PERMISSION_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_runtime_permission=1
endif

ifneq ($(strip $(MTK_ANTIBRICKING_LEVEL)), 0)
  ifeq ($(strip $(MTK_ANTIBRICKING_LEVEL)), 2)
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_antibricking_level=2
  else
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_antibricking_level=1
  endif
endif

# enable zsd+hdr
ifeq ($(strip $(MTK_CAM_ZSDHDR_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_zsdhdr_support=1
endif

# default MFLL support level, [0~4]= off, mfll, ais, both, debug
ifeq ($(strip $(MTK_CAM_MFB_SUPPORT)), 0)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_mfb_support=0
endif
ifeq ($(strip $(MTK_CAM_MFB_SUPPORT)), 1)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_mfb_support=1
endif
ifeq ($(strip $(MTK_CAM_MFB_SUPPORT)), 2)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_mfb_support=2
endif
ifeq ($(strip $(MTK_CAM_MFB_SUPPORT)), 3)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_mfb_support=3
endif
ifeq ($(strip $(MTK_CAM_MFB_SUPPORT)), 4)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_mfb_support=4
endif

ifeq ($(strip $(MTK_CLEARMOTION_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_clearmotion_support=1
endif

ifeq ($(strip $(MTK_SLOW_MOTION_VIDEO_SUPPORT)), yes)
	PRODUCT_PROPERTY_OVERRIDES += ro.mtk_slow_motion_support=1
	PRODUCT_PACKAGES += libMtkVideoSpeedEffect
	PRODUCT_PACKAGES += libjni_slow_motion
endif

ifeq ($(strip $(MTK_CAM_LOMO_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_lomo_support=1
endif

ifeq ($(strip $(MTK_CAM_IMAGE_REFOCUS_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_img_refocus_support=1
endif

ifeq ($(strip $(MTK_16X_SLOWMOTION_VIDEO_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_16x_slowmotion_support=1
endif

ifeq ($(strip $(MTK_LTE_DC_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_lte_dc_support=1
endif

ifeq ($(strip $(MTK_LTE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_lte_support=1
endif

ifeq ($(strip $(MTK_ENABLE_MD5)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_enable_md5=1
endif

ifeq ($(strip $(MTK_FEMTO_CELL_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_femto_cell_support=1
endif

ifeq ($(strip $(MTK_SAFEMEDIA_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_safemedia_support=1
endif

ifeq ($(strip $(MTK_UMTS_TDD128_MODE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_umts_tdd128_mode=1
endif

ifeq ($(strip $(MTK_SINGLE_IMEI)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_single_imei=1
endif

ifeq ($(strip $(MTK_SINGLE_3DSHOT_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_single_3Dshot_support=1
endif

ifeq ($(strip $(MTK_CAM_MAV_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_mav_support=1
endif

ifeq ($(strip $(MTK_CAM_VIDEO_FACEBEAUTY_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_cam_vfb=1
endif

ifeq ($(strip $(MTK_RILD_READ_IMSI)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_rild_read_imsi=1
endif

ifeq ($(strip $(SIM_REFRESH_RESET_BY_MODEM)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.sim_refresh_reset_by_modem=1
endif

ifeq ($(strip $(MTK_EXTERNAL_SIM_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_external_sim_support=1
endif

ifeq ($(strip $(MTK_SUBTITLE_SUPPORT)), yes)
  PRODUCT_PACKAGES += libvobsub_jni
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_subtitle_support=1
endif

ifeq ($(strip $(MTK_DFO_RESOLUTION_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_dfo_resolution_support=1
endif

ifeq ($(strip $(MTK_SMARTBOOK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_smartbook_support=1
endif

ifeq ($(strip $(MTK_DX_HDCP_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_dx_hdcp_support=1
endif

ifeq ($(strip $(MTK_LIVE_PHOTO_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_live_photo_support=1
endif

ifeq ($(strip $(MTK_MOTION_TRACK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_motion_track_support=1
endif

ifeq ($(strip $(MTK_SLIDEVIDEO_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_slidevideo_support=1
endif

ifeq ($(strip $(MTK_HOTKNOT_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_hotknot_support=1
endif

ifeq ($(strip $(MTK_PASSPOINT_R1_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_passpoint_r1_support=1
endif

ifeq ($(strip $(MTK_PASSPOINT_R2_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_passpoint_r2_support=1
endif

ifeq ($(strip $(MTK_PRIVACY_PROTECTION_LOCK)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_privacy_protection_lock=1
endif

ifeq ($(strip $(MTK_BG_POWER_SAVING_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_bg_power_saving_support=1
endif

ifeq ($(strip $(MTK_BG_POWER_SAVING_UI_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_bg_power_saving_ui=1
endif

ifeq ($(strip $(MTK_WIFIWPSP2P_NFC_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wifiwpsp2p_nfc_support=1
endif

ifeq ($(strip $(MTK_TC1_FEATURE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_tc1_feature=1
endif

ifeq ($(strip $(MTK_A1_FEATURE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_a1_feature=1
endif

ifeq ($(strip $(HAVE_AEE_FEATURE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.have_aee_feature=1
  PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/aee/binary/bin/debuggerd:system/bin/debuggerd
  ifeq ($(MTK_K64_SUPPORT), yes)
    PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/aee/binary/bin/debuggerd64:system/bin/debuggerd64
  endif
endif

ifneq ($(strip $(SIM_ME_LOCK_MODE)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.sim_me_lock_mode=$(strip $(SIM_ME_LOCK_MODE))
else
  PRODUCT_PROPERTY_OVERRIDES += ro.sim_me_lock_mode=0
endif

ifeq ($(strip $(MTK_DUAL_MIC_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_dual_mic_support=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_dual_mic_support=0
endif

ifeq ($(strip $(MTK_VOICE_UNLOCK_USE_TAB_LIB)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_is_tablet=1
else
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_is_tablet=0
endif

ifeq ($(strip $(MTK_EXTERNAL_MODEM_SLOT)), 1)
  PRODUCT_PROPERTY_OVERRIDES += ril.external.md=1
endif
ifeq ($(strip $(MTK_EXTERNAL_MODEM_SLOT)), 2)
  PRODUCT_PROPERTY_OVERRIDES += ril.external.md=2
endif

# serial port open or not
ifeq ($(strip $(MTK_SERIAL_PORT_DEFAULT_ON)),yes)
ADDITIONAL_DEFAULT_PROPERTIES += persist.service.acm.enable=1
else
ADDITIONAL_DEFAULT_PROPERTIES += persist.service.acm.enable=0
endif

# for pppoe
ifeq (OP09,$(word 1,$(subst _, ,$(OPTR_SPEC_SEG_DEF))))
  PRODUCT_PACKAGES += ip-up \
                      ip-down \
                      pppoe \
                      pppoe-server \
                      launchpppoe
  PRODUCT_PROPERTY_OVERRIDES += ro.config.pppoe_enable=1
endif

# for 3rd party app
#modify by xulinchao@wind-mobi.com 2016.03.23 start
ifeq ($(filter $(WIND_PROJECT_NAME_CUSTOM),E281L_WW E281L_ID),)
ifneq ($(strip $(WIND_DEF_ASUS_APKS)),yes)
ifeq ($(strip $(OPTR_SPEC_SEG_DEF)),NONE)
  ifneq ($(strip $(MTK_BSP_PACKAGE)), yes)
    ifneq ($(strip $(MTK_A1_FEATURE)), yes)
      PRODUCT_PACKAGES += TouchPal
      PRODUCT_PACKAGES += YahooNewsWidget
    endif
  endif
endif
endif
endif
#modify by xulinchao@wind-mobi.com 2016.03.23 end

#For 3rd party NLP provider
#modify by xulinchao@wind-mobi.com 2016.03.22 start
#PRODUCT_PACKAGES += Baidu_Location
ifeq ($(filter $(WIND_PROJECT_NAME_CUSTOM),E281L_WW E281L_ID),)
ifneq ($(strip $(WIND_DEF_ASUS_APKS)),yes)
PRODUCT_PACKAGES += Baidu_Location
endif
endif
#modify by xulinchao@wind-mobi.com 2016.03.22 end
# open TouchPal in OP02
ifeq (OP02,$(word 1,$(subst _, ,$(OPTR_SPEC_SEG_DEF))))
  ifneq ($(strip $(MTK_BSP_PACKAGE)), yes)
     PRODUCT_PACKAGES += TouchPal
  endif
endif
# open TouchPal in OP09
ifeq (OP09,$(word 1,$(subst _, ,$(OPTR_SPEC_SEG_DEF))))
  ifneq ($(strip $(MTK_BSP_PACKAGE)), yes)
     PRODUCT_PACKAGES += TouchPal
  endif
endif
# default IME
ifeq (OP01,$(word 1,$(subst _, ,$(OPTR_SPEC_SEG_DEF))))
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_default_ime =com.iflytek.inputmethod.FlyIME
endif

# Data usage overview
ifeq ($(strip $(MTK_DATAUSAGE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_datausage_support=1
endif

# wifi offload service common library
ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
    ifneq ($(strip $(MTK_BSP_PACKAGE)), yes)
        PRODUCT_PACKAGES += wfo-common
        ifeq ($(filter $(MTK_EPDG_SUPPORT) $(MTK_IMS_SUPPORT),yes),yes)
            PRODUCT_PACKAGES += WfoService libwfo_jni
        endif
    endif
endif

# IMS and VoLTE feature
ifeq ($(strip $(MTK_IMS_SUPPORT)), yes)
    ifneq ($(strip $(MTK_BASIC_PACKAGE)), yes)
        ifneq ($(strip $(MTK_BSP_PACKAGE)), yes)
            PRODUCT_PACKAGES += ImsService
        endif
    endif
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_ims_support=1
endif

#WFC feature
ifeq ($(strip $(MTK_WFC_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_wfc_support=1
endif

ifeq ($(strip $(MTK_VOLTE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_volte_support=1
  PRODUCT_PROPERTY_OVERRIDES += persist.mtk.volte.enable=1
endif

ifeq ($(strip $(MTK_VILTE_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_vilte_support=1
  #PRODUCT_PROPERTY_OVERRIDES += ro.mtk_vilte_ut_support=1
endif

# Add for Dynamic-SBP
ifeq ($(strip $(MTK_DYNAMIC_SBP_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += persist.radio.mtk_dsbp_support=1
  PRODUCT_PROPERTY_OVERRIDES += persist.mtk_dynamic_ims_switch=0
endif

# DTAG DUAL APN
ifeq ($(strip $(MTK_DTAG_DUAL_APN_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_dtag_dual_apn_support=1
endif

# Telstra PDP retry
ifeq ($(strip $(MTK_TELSTRA_PDP_RETRY_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_fallback_retry_support=1
endif

# sbc security
ifeq ($(strip $(MTK_SECURITY_SW_SUPPORT)), yes)
  PRODUCT_PACKAGES += libsec
  PRODUCT_PACKAGES += sbchk
  PRODUCT_PACKAGES += S_ANDRO_SFL.ini
  PRODUCT_PACKAGES += S_SECRO_SFL.ini
  PRODUCT_PACKAGES += sec_chk.sh
  PRODUCT_PACKAGES += AC_REGION
endif

ifeq ($(strip $(MTK_USER_ROOT_SWITCH)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_user_root_switch=1
endif

ifeq ($(strip $(MTK_DOLBY_DAP_SUPPORT)), yes)
PRODUCT_COPY_FILES += frameworks/av/media/libeffects/data/audio_effects_dolby.conf:system/etc/audio_effects.conf
PRODUCT_COPY_FILES += $(MTK_PROJECT_FOLDER)/dolby/ds1-default.xml:system/etc/ds1-default.xml
else
PRODUCT_COPY_FILES += frameworks/av/media/libeffects/data/audio_effects.conf:system/etc/audio_effects.conf
endif
ifeq ($(strip $(HAVE_SRSAUDIOEFFECT_FEATURE)),yes)
  PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/SRS_AudioEffect/srs_processing/license/dts.lic:system/data/dts.lic
  PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/SRS_AudioEffect/srs_processing/srs_processing.cfg:system/data/srs_processing.cfg
endif

ifeq ($(strip $(MTK_PERMISSION_CONTROL)), yes)
  PRODUCT_PACKAGES += PermissionControl
endif

ifeq ($(strip $(MTK_NFC_SUPPORT)), yes)
    ifeq ($(strip $(MTK_NFC_PACKAGE)), 1)
        $(call inherit-product-if-exists, vendor/mediatek/proprietary/hardware/nfc/mtknfc.mk)
    else
        PRODUCT_PACKAGES += nfcstackp
        PRODUCT_PACKAGES += DeviceTestApp
        PRODUCT_PACKAGES += libdta_mt6605_jni
        PRODUCT_PACKAGES += libmtknfc_dynamic_load_jni
        PRODUCT_PACKAGES += libnfc_mt6605_jni
        $(call inherit-product-if-exists, vendor/mediatek/proprietary/packages/apps/DeviceTestApp/DeviceTestApp.mk)
        $(call inherit-product-if-exists, vendor/mediatek/proprietary/external/mtknfc/mtknfc.mk)
    endif
endif

ifeq ($(strip $(MTK_NFC_SUPPORT)), yes)
    ifeq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/nfcse.cfg),)
        ifeq ($(strip $(MTK_BSP_PACKAGE)), yes)
            PRODUCT_COPY_FILES += packages/apps/Nfc/mtk-nfc/nfcsebsp.cfg:system/etc/nfcse.cfg
        else
            PRODUCT_COPY_FILES += packages/apps/Nfc/mtk-nfc/nfcsetk.cfg:system/etc/nfcse.cfg
        endif
    else
        PRODUCT_COPY_FILES += $(MTK_TARGET_PROJECT_FOLDER)/nfcse.cfg:system/etc/nfcse.cfg
    endif
endif

ifeq (yes,$(strip $(MTK_NFC_SUPPORT)))

  PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,frameworks/native/data/etc/android.hardware.nfc.xml:system/etc/permissions/android.hardware.nfc.xml)

  ifneq ($(MTK_BSP_PACKAGE), yes)
    PRODUCT_COPY_FILES +=$(call add-to-product-copy-files-if-exists,frameworks/base/nfc-extras/com.android.nfc_extras.xml:system/etc/permissions/com.android.nfc_extras.xml)
    PRODUCT_COPY_FILES +=$(call add-to-product-copy-files-if-exists,packages/apps/Nfc/etc/nfcee_access.xml:system/etc/nfcee_access.xml)
    ifeq ($(MTK_NFC_GSMA_SUPPORT), yes)
        PRODUCT_PACKAGES += com.android.nfcgsma_extras
        PRODUCT_PACKAGES += com.gsma.services.nfc
        PRODUCT_COPY_FILES +=$(call add-to-product-copy-files-if-exists,frameworks/base/gsma-extras/com.android.nfcgsma_extras.xml:system/etc/permissions/com.android.nfcgsma_extras.xml)
        PRODUCT_COPY_FILES +=$(call add-to-product-copy-files-if-exists,packages/apps/Nfc/gsma/jar/com.gsma.services.nfc.xml:system/etc/permissions/com.gsma.services.nfc.xml)
        PRODUCT_COPY_FILES +=$(call add-to-product-copy-files-if-exists,packages/apps/Nfc/gsma/jar/com.gsma.services.nfc.jar:system/framework/com.gsma.services.nfc.jar)

        ifeq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/gsma.cfg),)
            PRODUCT_COPY_FILES += packages/apps/Nfc/gsma/gsma.cfg:system/etc/gsma.cfg
        else
            PRODUCT_COPY_FILES += $(MTK_TARGET_PROJECT_FOLDER)/gsma.cfg:system/etc/gsma.cfg
  endif

        PRODUCT_PROPERTY_OVERRIDES += ro.mtk_nfc_gsma_support=1
    endif
  endif

  PRODUCT_PACKAGES += Nfc
  PRODUCT_PACKAGES += Tag
  PRODUCT_PACKAGES += nfcc.default
  PRODUCT_PROPERTY_OVERRIDES +=  ro.nfc.port=I2C

  ifeq (yes,$(strip $(MTK_NFC_HCE_SUPPORT)))
    PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,frameworks/native/data/etc/android.hardware.nfc.hce.xml:system/etc/permissions/android.hardware.nfc.hce.xml)
  endif

endif


ifeq ($(strip $(MTK_NFC_OMAAC_SUPPORT)),yes)
  PRODUCT_PACKAGES += SmartcardService
  PRODUCT_PACKAGES += org.simalliance.openmobileapi.jar
  PRODUCT_PACKAGES += org.simalliance.openmobileapi.xml
  PRODUCT_PACKAGES += eSETerminal
  PRODUCT_PACKAGES += Uicc1Terminal
  PRODUCT_PACKAGES += Uicc2Terminal
endif

# IR-Learning Core
ifeq ($(strip $(MTK_IR_LEARNING_SUPPORT)),yes)
  PRODUCT_PACKAGES += ConsumerIrExtraService
  PRODUCT_PACKAGES += com.mediatek.consumerir
  PRODUCT_PACKAGES += com.mediatek.consumerirextra.xml
  PRODUCT_PACKAGES += libconsumerir
  PRODUCT_PACKAGES += libconsumerir_vendor
endif

# IR-Learning Test Package
ifeq ($(strip $(MTK_IR_LEARNING_SUPPORT)),yes)
  PRODUCT_PACKAGES += ConsumerIrValidator
  PRODUCT_PACKAGES += ConsumerIrPermissionValidator
endif


# IRTX 3rd-party Test Packages
ifeq (yes,$(strip $(MTK_IRTX_SUPPORT)))
    PRODUCT_PACKAGES += IR_UeiRemoteControl
    PRODUCT_PACKAGES += IR_UeiSdkIrManager
    PRODUCT_PACKAGES += IR_UeiSdkSampleTest
endif
ifeq (yes,$(strip $(MTK_IRTX_PWM_SUPPORT)))
    PRODUCT_PACKAGES += IR_UeiRemoteControl
    PRODUCT_PACKAGES += IR_UeiSdkIrManager
    PRODUCT_PACKAGES += IR_UeiSdkSampleTest
endif


ifeq ($(strip $(MTK_HOTKNOT_SUPPORT)), yes)
  PRODUCT_PACKAGES += libhotknot
  PRODUCT_PACKAGES += libhotknot_GT1XX
  PRODUCT_PACKAGES += libhotknot_GT9XX
  PRODUCT_PROPERTY_OVERRIDES += ro.mediatek.hotknot.module=$(CUSTOM_KERNEL_TOUCHPANEL)
endif

ifeq ($(strip $(MTK_HOTKNOT_SUPPORT)), yes)
  PRODUCT_PACKAGES += HotKnot
  PRODUCT_PACKAGES += HotKnotBeam
  PRODUCT_PACKAGES += HotKnotCommonUI
  PRODUCT_PACKAGES += HotKnotConnectivity

    ifeq ($(wildcard $(MTK_TARGET_PROJECT_FOLDER)/hotknot.cfg),)
        PRODUCT_COPY_FILES += vendor/mediatek/proprietary/packages/apps/HotKnot/hotknot.cfg:system/etc/hotknot.cfg
    else
        PRODUCT_COPY_FILES += $(MTK_TARGET_PROJECT_FOLDER)/hotknot.cfg:system/etc/hotknot.cfg
    endif
endif

ifeq ($(TARGET_BUILD_VARIANT), eng)
  PRODUCT_PACKAGES += WiFiTest
endif

$(call inherit-product-if-exists, frameworks/base/data/videos/FrameworkResource.mk)
ifeq ($(strip $(MTK_LIVE_PHOTO_SUPPORT)), yes)
  PRODUCT_PACKAGES += com.mediatek.effect
  PRODUCT_PACKAGES += com.mediatek.effect.xml
endif

ifeq ($(strip $(MTK_MULTICORE_OBSERVER_APP)), yes)
  PRODUCT_PACKAGES += MultiCoreObserver
endif

# for Search, ApplicationsProvider provides apps search
PRODUCT_PACKAGES += ApplicationsProvider

# Live wallpaper configurations
# #workaround: disable it directly since device.mk can't get the value of TARGET_BUILD_PDK
PRODUCT_COPY_FILES += packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml

# for JPE
PRODUCT_PACKAGES += jpe_tool

# for mmsdk
PRODUCT_PACKAGES += mmsdk.$(shell echo $(MTK_PLATFORM) | tr '[A-Z]' '[a-z]')
ifeq ($(shell echo $(MTK_PLATFORM) | tr '[A-Z]' '[a-z]'),mt6735)
# If it is mt6753, must assign mmsdk.mt6753 to build
    PRODUCT_PACKAGES += mmsdk.mt6753
endif

ifneq ($(strip $(MTK_PLATFORM)),)
  PRODUCT_PACKAGES += libnativecheck-jni
endif

# for mediatek-res
PRODUCT_PACKAGES += mediatek-res

# for TER service
PRODUCT_PACKAGES += terservice
PRODUCT_PACKAGES += tertestclient
ifeq ($(strip $(MTK_TER_SERVICE)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ter.service.enable=1
endif

#SDK: Voice Interface Extension
ifeq ($(strip $(MTK_VOICE_INTERFACE_EXTENSION_SUPPORT)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.mtk_voice_extension_support=1
endif

#SDK: Voice Interface Extension
ifeq ($(strip $(MTK_VOICE_INTERFACE_EXTENSION_SUPPORT)),yes)
$(call inherit-product-if-exists, vendor/mediatek/proprietary/frameworks/base/voiceextension/cfg/voiceextension.mk)
PRODUCT_PACKAGES += VoiceExtension
endif
PRODUCT_PACKAGES += libvie
PRODUCT_PACKAGES += libvie_jni

# For Native downloader
PRODUCT_PACKAGES += downloader
ifeq ($(strip $(MTK_DT_SUPPORT)), yes)
  $(call inherit-product-if-exists, vendor/mediatek/proprietary/external/downloader/downloader.mk)
endif

# for RecoveryManagerService
PRODUCT_PACKAGES += \
    recovery \
    recovery.xml

PRODUCT_PROPERTY_OVERRIDES += wfd.dummy.enable=1

PRODUCT_PROPERTY_OVERRIDES += ro.mediatek.project.path=$(shell find device/* -maxdepth 1 -name $(subst full_,,$(TARGET_PRODUCT)))


ifeq ($(strip $(MTK_C2K_SUPPORT)), yes)
   PRODUCT_PACKAGES += Utk
  PRODUCT_PACKAGES += Bypass
  PRODUCT_PACKAGES += bypass
endif

ifeq ($(strip $(EVDO_IR_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += \
    ril.evdo.irsupport=1
endif

ifeq ($(strip $(EVDO_DT_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += \
    ril.evdo.dtsupport=1
endif

# for libudf
ifeq ($(strip $(MTK_USER_SPACE_DEBUG_FW)),yes)
PRODUCT_PACKAGES += libudf
endif

PRODUCT_COPY_FILES += $(MTK_TARGET_PROJECT_FOLDER)/ProjectConfig.mk:system/data/misc/ProjectConfig.mk

ifeq ($(strip $(MTK_BICR_SUPPORT)), yes)
PRODUCT_COPY_FILES += device/mediatek/common/iAmCdRom.iso:system/etc/iAmCdRom.iso
endif

#modify by xulinchao@wind-mobi.com 2016.03.17 start
#PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/base/telephony/etc/virtual-spn-conf-by-efgid1.xml:system/etc/virtual-spn-conf-by-efgid1.xml)
#PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/base/telephony/etc/virtual-spn-conf-by-efpnn.xml:system/etc/virtual-spn-conf-by-efpnn.xml)
#PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/base/telephony/etc/virtual-spn-conf-by-efspn.xml:system/etc/virtual-spn-conf-by-efspn.xml)
#PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/base/telephony/etc/virtual-spn-conf-by-imsi.xml:system/etc/virtual-spn-conf-by-imsi.xml)
ifeq ($(WIND_VSPN_CONF_BY_GIDL), )
    PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/base/telephony/etc/virtual-spn-conf-by-efgid1.xml:system/etc/virtual-spn-conf-by-efgid1.xml)
else
    PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/base/telephony/etc/$(WIND_VSPN_CONF_BY_GIDL):system/etc/virtual-spn-conf-by-efgid1.xml)
endif

ifeq ($(WIND_VSPN_CONF_BY_PNN), )
    PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/base/telephony/etc/virtual-spn-conf-by-efpnn.xml:system/etc/virtual-spn-conf-by-efpnn.xml)
else
    PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/base/telephony/etc/$(WIND_VSPN_CONF_BY_PNN):system/etc/virtual-spn-conf-by-efpnn.xml)
endif

ifeq ($(WIND_VSPN_CONF_BY_SPN), )
    PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/base/telephony/etc/virtual-spn-conf-by-efspn.xml:system/etc/virtual-spn-conf-by-efspn.xml)
else
    PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/base/telephony/etc/$(WIND_VSPN_CONF_BY_SPN):system/etc/virtual-spn-conf-by-efspn.xml)
endif

ifeq ($(WIND_VSPN_CONF_BY_IMSI), )
    PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/base/telephony/etc/virtual-spn-conf-by-imsi.xml:system/etc/virtual-spn-conf-by-imsi.xml)
else
    PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,vendor/mediatek/proprietary/frameworks/base/telephony/etc/$(WIND_VSPN_CONF_BY_IMSI):system/etc/virtual-spn-conf-by-imsi.xml)
endif
#modify by xulinchao@wind-mobi.com 2016.03.17 end

ifeq ($(strip $(MTK_AUDIO_ALAC_SUPPORT)), yes)
  PRODUCT_PACKAGES += libMtkOmxAlacDec
endif

ifeq ($(strip $(TRUSTONIC_TEE_SUPPORT)), yes)
  PRODUCT_PACKAGES += libMcClient
  PRODUCT_PACKAGES += libMcRegistry
  PRODUCT_PACKAGES += mcDriverDaemon
  PRODUCT_PACKAGES += libsec_mem
  PRODUCT_PACKAGES += libMcTeeKeymaster
  PRODUCT_PACKAGES += libMtkH264SecVencTLCLib
  PRODUCT_PACKAGES += libMtkH264SecVdecTLCLib
  PRODUCT_PACKAGES += libtlcWidevineModularDrm
  PRODUCT_PACKAGES += libtlcWidevineClassicDrm
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_trustonic_tee_support=1
endif

ifeq ($(strip $(MTK_GOOGLE_TRUSTY_SUPPORT)), yes)
  PRODUCT_PACKAGES += gatekeeper.trusty
  PRODUCT_PACKAGES += keystore.trusty
  PRODUCT_PACKAGES += libtrusty
endif

ifeq ($(strip $(MICROTRUST_TEE_SUPPORT)), yes)
  PRODUCT_PACKAGES += teei_daemon
  PRODUCT_PACKAGES += init_thh
#  PRODUCT_PACKAGES += libteei_fp
#  PRODUCT_PACKAGES += libfingerprint_tac
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_microtrust_tee_support=1
endif

ifeq ($(strip $(MTK_SEC_VIDEO_PATH_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_sec_video_path_support=1
  ifeq ($(strip $(MTK_IN_HOUSE_TEE_SUPPORT) $(MTK_GOOGLE_TRUSTY_SUPPORT)),yes)
  PRODUCT_PACKAGES += lib_uree_mtk_video_secure_al
  endif
endif
ifeq ($(strip $(MTK_COMBO_SUPPORT)), yes)
  $(call inherit-product-if-exists, vendor/mediatek/proprietary/hardware/connectivity/combo_tool/product_package.mk)
endif

$(call inherit-product-if-exists, vendor/mediatek/proprietary/hardware/spm/product_package.mk)

ifeq ($(strip $(MTK_SENSOR_HUB_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_sensorhub_support=1
  PRODUCT_PACKAGES += libhwsensorhub \
                      libsensorhub \
                      libsensorhub_jni \
                      sensorhubservice \
                      libsensorhubservice
endif

ifeq ($(strip $(MTK_TC7_FEATURE)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_tc7_feature=1
endif

PRODUCT_PACKAGES += Launcher3

#Add for CCCI Lib
PRODUCT_PACKAGES += libccci_util

ifeq ($(strip $(MTK_WMA_PLAYBACK_SUPPORT)), yes)
  PRODUCT_PACKAGES += libMtkOmxWmaDec
endif

ifeq ($(strip $(MTK_WMA_PLAYBACK_SUPPORT))_$(strip $(MTK_SWIP_WMAPRO)), yes_yes)
  PRODUCT_PACKAGES += libMtkOmxWmaProDec
endif

# ePDG
PRODUCT_PACKAGES += epdg_wod

# IKEv2
ifeq ($(strip $(MTK_EPDG_SUPPORT)), yes)
  PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/strongswan/epdg_conf/ipsec.conf:system/etc/ipsec/ipsec.conf
  PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/strongswan/epdg_conf/strongswan.conf:system/etc/ipsec/strongswan.conf
  PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/strongswan/epdg_conf/updown_script:system/etc/ipsec/updown_script
  PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/strongswan/epdg_conf/openssl.cnf:system/etc/ipsec/ssl/openssl.cnf

  ifeq ($(strip $(MTK_CIP_SUPPORT)), no)
    PRODUCT_PROPERTY_OVERRIDES += ro.mtk_epdg_support=1
    PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/strongswan/epdg_conf/Entrust.net_Certification_Authority_2048.cer:system/etc/ipsec/ipsec.d/cacerts/CA1.cer
    PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/strongswan/epdg_conf/test2_ca.crt:system/etc/ipsec/ipsec.d/cacerts/CA1L1.crt
  endif  

  PRODUCT_PACKAGES += charon \
                    libcharon \
                    libhydra \
                    libstrongswan \
                    libsimaka \
                    starter \
                    stroke \
                    ipsec

  PRODUCT_COPY_FILES += device/mediatek/$(shell echo $(MTK_PLATFORM) | tr '[A-Z]' '[a-z]')/init.epdg.rc:root/init.epdg.rc
endif

PRODUCT_PROPERTY_OVERRIDES += ro.com.android.mobiledata=false
PRODUCT_PROPERTY_OVERRIDES += persist.radio.mobile.data=0,0
#for meta mode dump data
PRODUCT_PROPERTY_OVERRIDES += persist.meta.dumpdata=0

ifneq ($(MTK_AUDIO_TUNING_TOOL_VERSION),)
  ifneq ($(strip $(MTK_AUDIO_TUNING_TOOL_VERSION)),V1)
    PRODUCT_PACKAGES += libaudio_param_parser
    $(eval INSTALL_AUDIO_PARAM_DIR_LIST := $(LOCAL_PATH)/audio_param $(INSTALL_AUDIO_PARAM_DIR_LIST))
    #$(eval INSTALL_AUDIO_PARAM_FILE_LIST := $(LOCAL_PATH)/default.audio_param $(INSTALL_AUDIO_PARAM_FILE_LIST))
  endif
endif

ifeq ($(strip $(MTK_NTFS_OPENSOURCE_SUPPORT)), yes)
  PRODUCT_PACKAGES += ntfs-3g
  PRODUCT_PACKAGES += ntfsfix
endif

# Add for HetComm feature
ifeq ($(strip $(MTK_HETCOMM_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_hetcomm_support=1
  PRODUCT_PACKAGES += HetComm
endif

ifeq ($(strip $(MTK_DEINTERLACE_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_deinterlace_support=1
endif

ifeq ($(strip $(MTK_GPS_SUPPORT)), yes)
  PRODUCT_PACKAGES += NlpService
endif

ifeq ($(strip $(MTK_DOLBY_DAP_SUPPORT)),yes)

DOLBY_DAX_VERSION            := 1
DOLBY_DAP                    := true
DOLBY_DAP2                   := false
DOLBY_DAP_SW                 := true
DOLBY_DAP_HW                 := false
DOLBY_DAP_PREGAIN            := true
DOLBY_DAP_HW_QDSP_HAL_API    := false
DOLBY_DAP_MOVE_EFFECT        := true
DOLBY_DAP_BYPASS_SOUND_TYPES := false
DOLBY_CONSUMER_APP           := true
DOLBY_UDC                    := true
DOLBY_UDC_VIRTUALIZE_AUDIO   := false
DOLBY_MONO_SPEAKER           := true

include vendor/dolby/ds/dolby-buildspec.mk
$(call inherit-product, vendor/dolby/ds/dolby-product.mk)

PRODUCT_COPY_FILES := \
    vendor/dolby/device/mediatek_sw/audio_effects.conf:system/vendor/etc/audio_effects.conf:dolby \
    vendor/dolby/device/mediatek_sw/ds1-default.xml:system/vendor/etc/dolby/ds1-default.xml:dolby \
    $(PRODUCT_COPY_FILES)

PRODUCT_RESTRICT_VENDOR_FILES := false
endif

#Fix me: specific enable for build error workaround
SKIP_BOOT_JARS_CHECK := true

ifeq ($(strip $(MTK_SWITCH_ANTENNA_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_switch_antenna=1
endif

# Add for C2K OM MODE
ifeq ($(strip $(MTK_C2K_OM_MODE)), CLLWTG)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk.c2k.om.mode=cllwtg
endif
ifeq ($(strip $(MTK_C2K_OM_MODE)), CLLWG)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk.c2k.om.mode=cllwg
endif
ifeq ($(strip $(MTK_C2K_OM_MODE)), CLLG)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk.c2k.om.mode=cllg
endif
ifeq ($(strip $(MTK_C2K_OM_MODE)), CWG)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk.c2k.om.mode=cwg
endif

ifneq ($(strip $(MTK_MD_SBP_CUSTOM_VALUE)),)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_md_sbp_custom_value=$(strip $(MTK_MD_SBP_CUSTOM_VALUE))
endif

# Add for C2K OM Network Selection Type
ifeq ($(strip $(MTK_C2K_OM_NW_SEL_TYPE)), 0)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_c2k_om_nw_sel_type=0
endif
ifeq ($(strip $(MTK_C2K_OM_NW_SEL_TYPE)), 1)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_c2k_om_nw_sel_type=1
endif

# Add for Automatic Setting for heapgrowthlimit & heapsize
RESOLUTION_HXW=$(shell expr $(LCM_HEIGHT) \* $(LCM_WIDTH))

ifeq ($(shell test $(RESOLUTION_HXW) -ge 0 && test $(RESOLUTION_HXW) -lt 1000000 && echo true), true)
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapgrowthlimit=128m
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapsize=256m
endif

ifeq ($(shell test $(RESOLUTION_HXW) -ge 1000000 && test $(RESOLUTION_HXW) -lt 3500000 && echo true), true)
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapgrowthlimit=192m
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapsize=384m
endif

ifeq ($(shell test $(RESOLUTION_HXW) -ge 3500000 && echo true), true)
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapgrowthlimit=384m
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.heapsize=768m
endif

#Add for BSP package SIP VoIP handle
ifeq ($(MTK_BSP_PACKAGE),yes)
ifeq ($(MTK_SIP_SUPPORT),yes)
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.sip.xml:system/etc/permissions/android.software.sip.xml
  PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml
endif
endif

# Add for Hardware Fused Location Related Modules
PRODUCT_PACKAGES += slpd
ifneq ($(TARGET_BUILD_VARIANT), user)
  PRODUCT_PACKAGES += FlpEM2
endif
PRODUCT_COPY_FILES += device/mediatek/common/slp/slp_conf:system/etc/slp_conf

PRODUCT_PACKAGES += CarrierConfig

ifeq ($(strip $(OPTR_SPEC_SEG_DEF)),OP09_SPEC0212_SEGDEFAULT)
  PRODUCT_COPY_FILES += vendor/mediatek/proprietary/frameworks/base/telephony/etc/spn-conf-op09.xml:system/etc/spn-conf-op09.xml
endif

# Add for ANT+
ifeq ($(strip $(MTK_ANT_SUPPORT)), yes)
      PRODUCT_PACKAGES += com.dsi.ant.antradio_library \
                          AntHalService \
                          libantradio \
                          antradio_app \
                          ANTRadioService \
                          ANTPlusPlugins \
                          ANTPlusDemo \
                          ANTPlusPluginSampler \
                          ANTValidationTester \
                          ANT_RAM_CODE_E1.BIN \
                          ANT_RAM_CODE_E2.BIN

      PRODUCT_COPY_FILES += vendor/mediatek/proprietary/external/ant-wireless/antradio-library/com.dsi.ant.antradio_library.xml:system/etc/permissions/com.dsi.ant.antradio_library.xml
endif

# Add for common service initialization
PRODUCT_COPY_FILES += device/mediatek/common/init.common_svc.rc:root/init.common_svc.rc

# Add for multi-window
ifeq ($(strip $(MTK_MULTI_WINDOW_SUPPORT)), yes)
  PRODUCT_PACKAGES += MultiWindowService
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_multiwindow=1
endif

# Add for BRM superset
ifeq ($(strip $(RELEASE_BRM)), yes)
  include device/mediatek/common/releaseBRM.mk
endif

ifeq (yes,$(strip $(MTK_BG_POWER_SAVING_SUPPORT)))
    ifeq (true,$(strip $(MTK_ALARM_AWARE_UPLINK_SUPPORT)))
        PRODUCT_PROPERTY_OVERRIDES += persist.mtk.datashaping.support=1
        PRODUCT_PROPERTY_OVERRIDES += persist.datashaping.alarmgroup=1
    endif
endif

# Add for ModemMonitor(MDM) framework
ifeq ($(strip $(MTK_MODEM_MONITOR_SUPPORT)),yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_modem_monitor_support=1
  PRODUCT_PACKAGES += \
    md_monitor \
    md_monitor_ctrl \
    MDMLSample
endif
#add by pengfugen@wind-mobi.com 20160321 start
ifeq ($(WIND_ASUS_CONTACTS),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind_asus_contacts=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind_asus_contacts=0
endif
#add by pengfugen@wind-mobi.com 20160321 end

#liyong01@wind-mobi.com add for Feature 100663 begin
ifeq ($(strip $(WIND_DEF_OPTR_PLAY_TO)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.optr.play.to=1
endif
#liyong01@wind-mobi.com add for Feature 100663 end

#add by huangyouzhong@wind-mobi.com 20160321 for #100655 -s
ifeq ($(WIND_ASUS_INCALLUI),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind_asus_incallui=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind_asus_incallui=0
endif
#add by huangyouzhong@wind-mobi.com 20160321 for #100655 -e
ifeq ($(strip $(WIND_GESTURES_SUPPORTED)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind_gestures_supported=1
endif
ifeq ($(strip $(MTK_VIBSPK_SUPPORT)), yes)
  PRODUCT_PROPERTY_OVERRIDES += ro.mtk_vibspk_support=1
endif

#Add for video codec customization
PRODUCT_PROPERTY_OVERRIDES += mtk.vdec.waitkeyframeforplay=1

# Add for CMCC Light Customization Support
ifeq ($(strip $(CMCC_LIGHT_CUST_SUPPORT)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.cmcc_light_cust_support=1
endif

# wangyan@wind-mobi.com add -start
##Feature #100625
ifeq ($(strip $(WOS_APP_WINDPOWERSAVER)), yes)
PRODUCT_PACKAGES += WOSPowerSaver
PRODUCT_PROPERTY_OVERRIDES += ro.wind_os_app_powersaver=1
endif

##Feature #100658
ifeq ($(strip $(WIND_ASUS_BACKUP)), yes)
PRODUCT_PROPERTY_OVERRIDES += ro.wind_asus_backup=1
endif

##Feature #100658
ifeq ($(strip $(WIND_DEF_ASUS_NOT_DISTURB)), yes)
PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.asus.notdisturb=1
endif

##Feature#110122
ifeq ($(strip $(WIND_DEF_ASUS_FLIPCOVER)), yes)
PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.asus.flipcover=1
endif

##Feature #110161
ifeq ($(strip $(WIND_DEF_ASUS_HARDWARE)), yes)
PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.asus.hardware=1
endif

##Feature #110135 
ifeq ($(strip $(WIND_DEF_ASUS_POWERSAVER)), yes)
PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.asus.powersaver=1
endif

##Feature #110195
ifeq ($(strip $(WIND_DEF_ASUS_GESTURES)), yes)
PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.asus.gestures=1
endif
# wangyan@wind-mobi.com add -end


# wangyan@wind-mobi.com add -start
##Feature#110122
ifeq ($(strip $(WIND_DEF_ASUS_FLIPCOVER)), yes)
    PRODUCT_COPY_FILES += \
        vendor/mediatek/proprietary/binary/3rd-party/E281L/hardware_feature_xml/asus.hardware.hall_sensor.xml:system/etc/permissions/asus.hardware.hall_sensor.xml \
        vendor/mediatek/proprietary/binary/3rd-party/E281L/hardware_feature_xml/asus.hardware.transcover.xml:system/etc/permissions/asus.hardware.transcover.xml \
        vendor/mediatek/proprietary/binary/3rd-party/E281L/hardware_feature_xml/asus.hardware.transcover_info.xml:system/etc/permissions/asus.hardware.transcover_info.xml \
        vendor/mediatek/proprietary/binary/3rd-party/E281L/hardware_feature_xml/asus.hardware.transcover_version3.xml:system/etc/permissions/asus.hardware.transcover_version3.xml \
        vendor/mediatek/proprietary/binary/3rd-party/E281L/hardware_feature_xml/asus.software.cover3_feature_0.xml:system/etc/permissions/asus.software.cover3_feature_0.xml
endif

##Feature #110195
ifeq ($(strip $(WIND_DEF_ASUS_GESTURES)), yes)
    PRODUCT_COPY_FILES += \
        vendor/mediatek/proprietary/binary/3rd-party/E281L/hardware_feature_xml/asus.hardware.touchgesture.double_tap.xml:system/etc/permissions/asus.hardware.touchgesture.double_tap.xml \
        vendor/mediatek/proprietary/binary/3rd-party/E281L/hardware_feature_xml/asus.hardware.touchgesture.launch_app.xml:system/etc/permissions/asus.hardware.touchgesture.launch_app.xml \
        vendor/mediatek/proprietary/binary/3rd-party/E281L/hardware_feature_xml/asus.hardware.touchgesture.swipe_up.xml:system/etc/permissions/asus.hardware.touchgesture.swipe_up.xml
endif
# wangyan@wind-mobi.com add -end




#qiancheng@wind-mobi.com 20160321 add start
ifeq ($(WIND_DEF_PRO_E280L),yes)
PRODUCT_PROPERTY_OVERRIDES += \
      ro.com.google.clientidbase=android-asus \
      ro.com.google.clientidbase.ms=android-asus \
      ro.com.google.clientidbase.yt=android-asus \
      ro.com.google.clientidbase.am=android-asus \
      ro.com.google.clientidbase.gmm=android-asus
endif
#qiancheng@wind-mobi.com 20160321 add end
#qiancheng@wind-mobi.com 20160511 add start
ifeq ($(strip $(BUILD_GMS)), yes)
ifneq ($(filter $(WIND_PROJECT_NAME_CUSTOM),E281L_WW E281L_ID),)
PRODUCT_PROPERTY_OVERRIDES += \
      ro.com.google.clientidbase=android-asus \
      ro.com.google.clientidbase.ms=android-asus \
      ro.com.google.clientidbase.yt=android-asus \
      ro.com.google.clientidbase.am=android-asus \
      ro.com.google.clientidbase.gmm=android-asus
endif
endif
#qiancheng@wind-mobi.com 20160511 add start

#lizusheng@wind-mobi.com 20160321 start
ifeq (yes,$(strip $(WIND_DEF_EMODE_DIALERPAD)))
			PRODUCT_PACKAGES += EmodeDialpad
endif
#lizusheng@wind-mobi.com 20160321 end

#lifeifei@wind-mobi.com add 20160421 for flipfone cn begin
ifeq ($(strip $(WIND_DEF_FLIPFONT_CN)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.flipfont.cn=1
PRODUCT_PACKAGES += \
    MFinancePRCBold \
    MYingHei_18030-M \
    MYuppyMedium-SC
endif
#lifeifei@wind-mobi.com add 20160421 for flipfone cn end
#lifeifei@wind-mobi.com add 20160511 for flipfone ww begin
ifeq ($(strip $(WIND_DEF_FLIPFONT_WW)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.flipfont.ww=1
PRODUCT_PACKAGES += \
    Felbridge \
    Syndor \
    FlipCover
endif
#lifeifei@wind-mobi.com add 20160511 for flipfone ww end
#lifeifei@wind-mobi.com add 20160425 for asus camera begin
ifeq ($(strip $(WIND_DEF_ASUS_CAMERA)),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.asus.camera=1
endif
#lifeifei@wind-mobi.com add 20160425 for asus camera end
#pengfugen@wind-mobi.com 2016.03.24 start
ifeq ($(strip $(WIND_DEF_MOTION_GESTURE)),yes)
PRODUCT_COPY_FILES += device/mediatek/common/asus_motion_gesture/asus.software.sensor_service.eartouch.xml:system/etc/permissions/asus.software.sensor_service.eartouch.xml
PRODUCT_COPY_FILES += device/mediatek/common/asus_motion_gesture/asus.software.sensor_service.instantactivity.xml:system/etc/permissions/asus.software.sensor_service.instantactivity.xml
PRODUCT_COPY_FILES += device/mediatek/common/asus_motion_gesture/asus.software.sensor_service.terminal.xml:system/etc/permissions/asus.software.sensor_service.terminal.xml
PRODUCT_COPY_FILES += device/mediatek/common/asus_motion_gesture/asus.software.sensor_service.xml:system/etc/permissions/asus.software.sensor_service.xml
endif
#pengfugen@wind-mobi.com 2016.03.24 start
#pengfugen@wind-mobi.com 2016.05.26 start
ifeq ($(strip $(WIND_DEF_RM_MOTION_GESTURE)),yes)
    PRODUCT_COPY_FILES += device/mediatek/common/asus_motion_gesture/asus.software.sensor_service.xml:system/etc/permissions/asus.software.sensor_service.xml
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.rm_mo_gesture=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.rm_mo_gesture=0
endif
#pengfugen@wind-mobi.com 2016.05.26 end
#pengfugen@wind-mobi.com 2016.03.24 start
ifeq ($(strip $(WIND_DEF_ONE_HAND_CONTROL)),yes)
    PRODUCT_COPY_FILES += vendor/data/etc/features/asus.software.whole_system_onehand.xml:system/etc/permissions/asus.software.whole_system_onehand.xml
    PRODUCT_COPY_FILES += vendor/data/versions/amax.system.whole_system_onehand.xml:system/etc/versions/amax.system.whole_system_onehand.xml
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.one.hand.control=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.one.hand.control=0
endif
DEVICE_PACKAGE_OVERLAYS += vendor/overlay
#zhangyanbin@wind-mobi.com 2016.03.25 add begin
ifeq ($(WIND_ASUS_SIGNAL),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind_asus_signal=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind_asus_signal=0
endif
ifeq ($(WIND_ASUS_FOTA),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind_asus_fota=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind_asus_fota=0
endif
#zhangyanbin@wind-mobi.com 2016.03.25 add end
#lizusheng@wind-mobi.com 20160323 end
#add by youxiaoyan for SystemUI 20160309 -s
ifeq ($(strip $(WIND_DEF_ASUS_SYSTEMUI)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.asus.systemui=1
    #mod by youxiaoyan -s
    ifeq ($(strip $(WIND_DEF_ASUS_VLIFE_LOCKSCREEN)),yes)
        PRODUCT_PACKAGES += \
           AsusLockScreen \
           vlife

    PRODUCT_COPY_FILES += \
       vendor/asus-prebuilt/T552TLC/amax-prebuilt/CNAsusSystemUI-1.5/sku/res-CN/arm64-v8a/libvlife_media.so:/system/lib64/libvlife_media.so \
       vendor/asus-prebuilt/T552TLC/amax-prebuilt/CNAsusSystemUI-1.5/sku/res-CN/arm64-v8a/libvlife_openglutil.so:/system/lib64/libvlife_openglutil.so \
       vendor/asus-prebuilt/T552TLC/amax-prebuilt/CNAsusSystemUI-1.5/sku/res-CN/arm64-v8a/libvlife_render.so:/system/lib64/libvlife_render.so \
       vendor/asus-prebuilt/T552TLC/amax-prebuilt/CNAsusSystemUI-1.5/device/res-T520TL/customization.xml:/system/etc/AsusSystemUIRes/customization.xml
	 
    #add by liangfeng@wind-mobi.com 2016.06.23 start for setup wizard don't show keyguard	
    PRODUCT_PROPERTY_OVERRIDES += keyguard.no_require_sim=true	   
    #add by liangfeng@wind-mobi.com 2016.06.23 end for setup wizard don't show keyguard	  
	
    endif
    #mod by youxiaoyan -e
endif
#add by youxiaoyan for SystemUI 20160309 -e
#add by xulinchao@wind-mobi.com 2016.03.24 start
ifeq ($(WIND_DEF_DATA_CONNECTION),yes)
PRODUCT_PROPERTY_OVERRIDES += ro.wind_def_data_connection=1
endif
#add by xulinchao@wind-mobi.com 2016.03.24 end

#lizusheng@wind-mobi.com 20160303 start
ifeq (yes,$(strip $(WIND_FINGERPRINT_ENABLE)))
			PRODUCT_PACKAGES += fingerprintd
			PRODUCT_PACKAGES += FingerPrintTest
			PRODUCT_COPY_FILES += device/mediatek/mt6735/gf/gx_fpd:system/bin/gx_fpd
			PRODUCT_COPY_FILES += device/mediatek/mt6735/gf/libfp_client.so:system/lib64/libfp_client.so
			PRODUCT_COPY_FILES += device/mediatek/mt6735/gf/libfpalgorithm.so:system/lib64/libfpalgorithm.so
			PRODUCT_COPY_FILES += device/mediatek/mt6735/gf/libfphal.so:system/lib64/libfphal.so
			PRODUCT_COPY_FILES += device/mediatek/mt6735/gf/libfpservice.so:system/lib64/libfpservice.so
			PRODUCT_COPY_FILES += device/mediatek/mt6735/gf/libgxFpTest.so:system/lib64/libgxFpTest.so
			PRODUCT_COPY_FILES += device/mediatek/mt6735/gf/hw/fingerprint.default.so:system/lib64/hw/fingerprint.gf318.so
			PRODUCT_PROPERTY_OVERRIDES += ro.wind_fingerprint_enable=1
else
			PRODUCT_PROPERTY_OVERRIDES += ro.wind_fingerprint_enable=0
endif
#lizusheng@wind-mobi.com 20160303 end
#zhenglihong@wind-mobi.com 20160509 start yutao@wind-mobi.com  20160616 modify x.xo to d.so 
ifeq (yes,$(strip $(AFS121_FINGERPRINT_ENABLE)))
			PRODUCT_PACKAGES += fingerprintd
			PRODUCT_COPY_FILES += device/mediatek/mt6735/afs121/libfprint-d64.so:system/lib64/libfprint-d64.so
			PRODUCT_COPY_FILES += device/mediatek/mt6735/afs121/hw/fingerprint.default.so:system/lib64/hw/fingerprint.default.so
			PRODUCT_PROPERTY_OVERRIDES += ro.wind_fingerprint_enable=1
else 
			PRODUCT_PROPERTY_OVERRIDES += ro.wind_fingerprint_enable=0
endif
#zhenglihong@wind-mobi.com 20160509 end

#zhenglihong@wind-mobi.com 20160525 begin
PRODUCT_COPY_FILES += device/mediatek/mt6735/style/style.cng:system/bin/
#zhenglihong@wind-mobi.com 20160525 end

#add by lizusheng@wind-mobi.com 20160317 start
ifeq ($(strip $(WIND_DEF_RUNTIME_TEST_APP)), yes)
	PRODUCT_PACKAGES += WindRuntimeTest
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.runtime_test_app=1	
endif
#add by lizusheng@wind-mobi.com 20160317 end
#add by lizusheng@wind-mobi.com 20160413 start
PRODUCT_PACKAGES += HimaxMPAP
#add by lizusheng@wind-mobi.com 20160413 end

#sunhuihui@wind-mobi.com Feature#100649 begin
ifeq ($(strip $(WIND_DEF_STORAGE_DETAIL)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.asus_storage=1
endif
#sunhuihui@wind-mobi.com Feature#100649 end
#sunhuihui@wind-mobi.com begin Feature#100675
ifeq ($(strip $(WIND_DEF_SMARTLAUNCHER)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.smart_launcher=1
endif
#sunhuihui@wind-mobi.com end Feature#100675
#sunhuihui@wind-mobi.com begin Feature#100777
ifeq ($(strip $(WIND_DEF_ASUS_PRELOADED)),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.asus_preloaded=1
endif
#sunhuihui@wind-mobi.com end Feature#100777

#Add by yinlili@wind-mobi.com for feature#100673 -s
ifeq ($(strip $(WIND_DEF_ASUS_SAVELOG)),yes)
PRODUCT_COPY_FILES += device/mediatek/common/savelogs.sh:system/etc/savelogs.sh
PRODUCT_COPY_FILES += device/mediatek/common/init.asus.checklogsize.sh:system/etc/init.asus.checklogsize.sh
PRODUCT_PROPERTY_OVERRIDES += persist.asus.mupload.enable=1 \
		persist.asus.autoupload.enable=1 \
		persist.asus.logtool.pug=0 \
		persist.asus.checklogsize = 1
PRODUCT_PACKAGES += \
    UtsBspLogCheck \
    LogUploader
endif
#Add by yinlili@wind-mobi.com for feature#100673 -e
#Add by yinlili@wind-mobi.com for ShutOffAnimation -s
ifeq ($(WIND_SHUT_OFF_ANIMATION),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind_shut_off_animation=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind_shut_off_animation=0
endif
#Add by yinlili@wind-mobi.com for ShutOffAnimation -e

#lizusheng@wind-mobi.com 20160303 start
ifeq (yes,$(strip $(WIND_DUAL_IMEI_SINGLE_MEID)))
			PRODUCT_PROPERTY_OVERRIDES += ro.wind_dual_imei_single_meid=1
else
			PRODUCT_PROPERTY_OVERRIDES += ro.wind_dual_imei_single_meid=0
endif
#lizusheng@wind-mobi.com 20160303 end
#pengfugen@wind-mobi.com 2016/05/09 add start
ifeq ($(WIND_ASUS_MOBI_MANAGER_ENABLE),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.mobi_man.enable=1
	PRODUCT_PROPERTY_OVERRIDES += persist.sys.autostart.enable=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.mobi_man.enable=0
	PRODUCT_PROPERTY_OVERRIDES += persist.sys.autostart.enable=0
endif
#pengfugen@wind-mobi.com 2016/05/09 add end
#pengfugen@wind-mobi.com 2016/05/25 add for 110177 start
ifeq ($(WIND_DEF_RM_ZENMOTION_HANDUP),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.rm.zen_handup=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.rm.zen_handup=0
endif
#pengfugen@wind-mobi.com 2016/05/25 add end
#pengfugen@wind-mobi.com 2016/05/25 add for 110177 start
ifeq ($(WIND_DEF_MOTION_GESTURE),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.motion_support=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.motion_support=0
endif
#pengfugen@wind-mobi.com 2016/05/25 add end

# pengfugen@wind-mobi add for 110145 start
ifeq ($(WIND_DEF_CALL_DO_IT_LATER),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.call_do_later=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.call_do_later=0
endif
# pengfugen@wind-mobi add for 110145 end

#xuyi@wind-mobi.com 20160510 add for KidsMode begin
ifeq ($(strip $(WIND_DEF_KIDS_MODE)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.kids.mode = 1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.kids.mode = 0
endif
#xuyi@wind-mobi.com 20160510 add for KidsMode end
#pengfugen@wind-mobi.com 20160512 add for #110920 begin
ifeq ($(strip $(WIND_DEF_CUSTOM_DEFAULT_VOLUME)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.custom.def.vol = 1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.custom.def.vol = 0
endif
#pengfugen@wind-mobi.com 20160510 add for #110920 end
#sunxiaolong@wind-mobi.com 2016/05/11 add start
ifeq ($(WIND_DEF_ASUS_CHANGE_THEME),yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.asus.theme.enable=1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.asus.theme.enable=0
endif
#sunxiaolong@wind-mobi.com 2016/05/11 add end

#lizusheng@wind-mobi.com 20160504 start
ifeq (yes,$(strip $(WIND_FINGERPRINT_SILEAD_ENABLE)))
###both|64|empty
SL_LIB_COMBO:=both
###64|empty
SL_BIN_COMBO:=64
###both|64|empty
SL_TST_COMBO:=both
#tbase gp 
#SL_TZ_COMBO:=tbase
include vendor/silead/prebuiltlibs/slfpinstall.mk
PRODUCT_PACKAGES += \
    fp \
    libslfpjni \
    libsileadinc_factorytest \
    fingerprint.default \
    checksilead  \
    fingerprintd \
	FactoryTest
	PRODUCT_PROPERTY_OVERRIDES += ro.wind_fingerprint_silead=1
else
	PRODUCT_PROPERTY_OVERRIDES += ro.wind_fingerprint_silead=0
endif
#lizusheng@wind-mobi.com 20160504 end

#xuyi@wind-mobi.com 20160518 add for CM_weather begin
ifeq ($(strip $(WIND_DEF_CM_WEATHER)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.cm.weather = 1
	PRODUCT_COPY_FILES += \
        vendor/data/etc/features/asus.software.lockscreen.cmweather.xml:system/etc/permissions/asus.software.lockscreen.cmweather.xml
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.cm.weather = 0
endif
#xuyi@wind-mobi.com 20160518 add for CM_weather end

#lizusheng@wind-mobi.com 20160519 start
ifeq (yes,$(strip $(WIND_DEF_SMMI_APP)))
	PRODUCT_PACKAGES += SMMI
endif
#lizusheng@wind-mobi.com 20160519 end

#xuyi@wind-mobi.com 20160519 add for RAM_optimize begin
ifeq ($(strip $(WIND_DEF_RAM_OPTIMIZE)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.ram.optimize = 1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.ram.optimize = 0
endif
#xuyi@wind-mobi.com 20160519 add for RAM_optimize end

#lizusheng@wind-mobi.com add 20160523 start
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fp.navigation = 1
#lizusheng@wind-mobi.com add 20160523 end
#add by sunxiaolong@wind-mobi.com for otg reverse charging 20160603 start 
ifeq ($(strip $(WIND_OTG_REVERSE_CHARGING)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.otg.reverse.charging = 1
else
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.otg.reverse.charging = 0
endif
#add by sunxiaolong@wind-mobi.com for otg reverse charging 20160603 end 

#xiongshigui@wind-mobi.com 20160604 add begin
ifeq ($(strip $(WIND_DEF_ADAPT_FOR_ASUS_APK_CN)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.adapt_asus_apk_cn = 1
endif

ifeq ($(strip $(WIND_DEF_ADAPT_FOR_ASUS_APK_WW)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.adapt_asus_apk_ww = 1
endif
#xiongshigui@wind-mobi.com 20160604 add end

#xiongshigui@wind-mobi.com 20160607 add begin
ifeq ($(strip $(WIND_DEF_ASUS_VLIFE_LOCKSCREEN)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.def.vlife.lockscreen = 1
endif
#xiongshigui@wind-mobi.com 20160607 add end
#xiongshigui@wind-mobi.com 20160608 add begin
ifeq ($(strip $(WIND_DEF_ENABLE_ADB_USER_BUILD)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.enable_adb_user_build = 1
endif
#xiongshigui@wind-mobi.com 20160608 add end
#xiongshigui@wind-mobi.com 20160609 add begin
ifeq ($(strip $(WIND_DEF_GOOGLE_VOUCHER_KEY)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.google_voucher_key = 1
endif
ifeq ($(strip $(WIND_DEF_ASUS_DEMOAPP)), yes)
    PRODUCT_PROPERTY_OVERRIDES += ro.wind.asus_demo_app = 1
	PRODUCT_COPY_FILES += \
        device/mediatek/common/mount_apd.sh:system/bin/mount_apd.sh \
        device/mediatek/common/umount_apd.sh:system/bin/umount_apd.sh
endif
#xiongshigui@wind-mobi.com 20160609 add end
#lizusheng@wind-mobi.com 20160524 start
ifeq (yes,$(strip $(WIND_FINGERPRINT_TEE_ENABLE)))
			PRODUCT_PACKAGES += fingerprintd
			PRODUCT_COPY_FILES += device/mediatek/mt6735/fingerprint_tee/libgf_ca.so:system/lib64/libgf_ca.so
			PRODUCT_COPY_FILES += device/mediatek/mt6735/fingerprint_tee/libgf_hal.so:system/lib64/libgf_hal.so
			PRODUCT_COPY_FILES += device/mediatek/mt6735/fingerprint_tee/libgf_algo.so:system/lib64/libgf_algo.so
			PRODUCT_COPY_FILES += device/mediatek/mt6735/fingerprint_tee/libgoodixfingerprintd_binder.so:system/lib64/libgoodixfingerprintd_binder.so
			PRODUCT_COPY_FILES += device/mediatek/mt6735/fingerprint_tee/goodixfingerprintd:system/bin/goodixfingerprintd
			PRODUCT_COPY_FILES += device/mediatek/mt6735/fingerprint_tee/libfingerprint.default.so:system/lib64/hw/fingerprint.default.so
			PRODUCT_COPY_FILES += device/mediatek/mt6735/fingerprint_tee/7b30b820-a9ea-11e5-b1780002a5d5c51b.ta:system/lib/nutlet_armtz/7b30b820-a9ea-11e5-b1780002a5d5c51b.ta
			PRODUCT_COPY_FILES += device/mediatek/mt6735/fingerprint_tee/b657ba17-b3b3-47f5-b3896b53f30c0baf.ta:system/lib/nutlet_armtz/b657ba17-b3b3-47f5-b3896b53f30c0baf.ta
			PRODUCT_COPY_FILES += device/mediatek/mt6735/fingerprint_tee/08010203-0000-0000-0000000000000000.ta:system/lib/nutlet_armtz/08010203-0000-0000-0000000000000000.ta
			PRODUCT_COPY_FILES += device/mediatek/mt6735/fingerprint_tee/libteec.so:system/lib64/libteec.so
			PRODUCT_COPY_FILES += device/mediatek/mt6735/fingerprint_tee/tee-supplicant:system/bin/tee-supplicant
endif
#lizusheng@wind-mobi.com 20160524 end
#add by xulinchao@wind-mobi.com 2016.06.16 for asus adb start
ifeq ($(strip $(WIND_DEF_ASUS_ADB_FUNCTION))_$(strip $(TARGET_BUILD_VARIANT)),yes_eng)
PRODUCT_PACKAGES += PhoneInfoTest
endif
#add by xulinchao@wind-mobi.com 2016.06.16 for asus adb end
#add by sunxiaolong@wind-mobi.com for asus request start
ifeq ($(strip $(WIND_ASUS_INSTANT_CAMERA)), yes)
    PRODUCT_PROPERTY_OVERRIDES += asus.hardware.instant_camera = 1
else
    PRODUCT_PROPERTY_OVERRIDES += asus.hardware.instant_camera = 0
endif
#add by sunxiaolong@wind-mobi.com for asus request end