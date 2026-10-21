export TARGET = iphone:clang:15.5:14.0  
export ARCHS = arm64 arm64e  
  
# Support rootless environments  
THEOS_PACKAGE_SCHEME = rootless  
  
include $(THEOS)/makefiles/common.mk  
  
TWEAK_NAME = ControlCenterIOS26  
  
ControlCenterIOS26_FILES = Tweak.x IOS26GlassEffect.m IOS26SliderView.m  
ControlCenterIOS26_CFLAGS = -fobjc-arc -I.  
ControlCenterIOS26_FRAMEWORKS = UIKit CoreGraphics QuartzCore AudioToolbox  
ControlCenterIOS26_PRIVATE_FRAMEWORKS = ControlCenterUI ControlCenterUIKit MaterialKit  
  
include $(THEOS_MAKE_PATH)/tweak.mk  
  
after-install::  
    install.exec "killall -9 SpringBoard"
