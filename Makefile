TARGET := iphone:clang:latest:14.0  
ARCHS := arm64  
  
# Support both Rootless and Rootful compilation modes  
THEOS_PACKAGE_SCHEME ?= rootless  
  
include $(THEOS)/makefiles/common.mk  
  
TWEAK_NAME = ControlCenter  
  
ControlCenter_FILES = Tweak.x IOS26GlassView.m IOS26SliderView.m IOS26ModuleMorpher.m  
ControlCenter_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -I./Headers  
ControlCenter_FRAMEWORKS = UIKit CoreGraphics QuartzCore AudioToolbox  
ControlCenter_PRIVATE_FRAMEWORKS = ControlCenterUI ControlCenterUIKit MediaRemote  
  
include $(THEOS_MAKE_PATH)/tweak.mk  
  
after-install::  
    install.exec "killall -9 SpringBoard"
