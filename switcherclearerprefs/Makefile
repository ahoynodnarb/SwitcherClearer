include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SwitcherClearerPrefs

SwitcherClearerPrefs_FILES = SCPRootListController.m
SwitcherClearerPrefs_INSTALL_PATH = /Library/PreferenceBundles
SwitcherClearerPrefs_FRAMEWORKS = UIKit
SwitcherClearerPrefs_PRIVATE_FRAMEWORKS = Preferences
SwitcherClearerPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SwitcherClearerPrefs.plist$(ECHO_END)
