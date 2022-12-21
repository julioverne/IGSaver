include $(THEOS)/makefiles/common.mk

TWEAK_NAME = IGSaver

$(TWEAK_NAME)_FILES = /mnt/d/codes/igsaver/Tweak.xm /mnt/d/codes/igsaver/IGSaverImportListController.m

$(TWEAK_NAME)_FRAMEWORKS = CydiaSubstrate Foundation UIKit CoreMedia CoreGraphics AVFoundation Photos
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_LDFLAGS = -Wl,-segalign,4000

export ARCHS = armv7 armv7s arm64 arm64e
$(TWEAK_NAME)_ARCHS = armv7 armv7s arm64 arm64e

include $(THEOS_MAKE_PATH)/tweak.mk
