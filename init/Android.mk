LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := libinit_a2corelte
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := init_a2corelte.cpp
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
include $(BUILD_STATIC_LIBRARY)
