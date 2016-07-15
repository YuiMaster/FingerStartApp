LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := optional

LOCAL_SRC_FILES := $(call all-subdir-java-files)
LOCAL_SRC_FILES += $(src/android/hardware/fingerprint/Fingerprint.java src/android/hardware/fingerprint/FingerprintManager.java)
					

LOCAL_JAVA_LIBRARIES += mediatek-framework \
						telephony-common
						
LOCAL_STATIC_JAVA_LIBRARIES := android-support-v4 android-support-v13

LOCAL_RESOURCE_DIR := $(LOCAL_PATH)/res
								
LOCAL_PACKAGE_NAME := WOSAppLock

LOCAL_CERTIFICATE := platform
#LOCAL_DEX_PREOPT	:= false

LOCAL_PRIVILEGED_MODULE := false

#include frameworks/opt/setupwizard/navigationbar/common.mk
#include frameworks/opt/setupwizard/library/common.mk
include frameworks/base/packages/SettingsLib/common.mk

include $(BUILD_PACKAGE)


include $(CLEAR_VARS)
#LOCAL_PREBUILT_STATIC_JAVA_LIBRARIES := android-support-v4:libs/android-support-v4.jar \
#							baidulib-WOSSmartCover:libs/android_api_3.7.0.5.jar 
									
include $(BUILD_MULTI_PREBUILT)

include $(call all-makefiles-under, $(LOCAL_PATH))
