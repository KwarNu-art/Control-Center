export TARGET = iphone:clang:latest:14.0
export ARCHS = arm64

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ControlCenter26

ControlCenter26_FILES = Tweak.x
ControlCenter26_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-function -Wno-unused-variable
ControlCenter26_FRAMEWORKS = UIKit QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk
