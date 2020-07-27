THEOS_DEVICE_IP=localhost
THEOS_DEVICE_PORT=2222
export TARGET = iphone:clang:latest:13.4
ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SwitcherClearer

SwitcherClearer_FILES = Tweak.xm
SwitcherClearer_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += switcherclearerprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
