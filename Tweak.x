#import <UIKit/UIKit.h>  
#import "ControlCenterUI.h"  
#import "IOS26GlassView.h"  
#import "IOS26SliderView.h"  
#import "IOS26ModuleMorpher.h"  
  
// Static Reference Hook Variables  
static IOS26GlassView *globalBackgroundCanvas = nil;  
  
%hook CCUIModularControlCenterViewController  
  
- (void)viewDidLoad {  
    %orig;  
  
    // Remove legacy dark dimmer and install dynamic iOS 26 Nebula Canvas  
    if (!globalBackgroundCanvas) {  
        CGRect screenBounds = [UIScreen mainScreen].bounds;  
        globalBackgroundCanvas = [[IOS26GlassView alloc] initWithFrame:screenBounds cornerRadius:0.0];  
        globalBackgroundCanvas.tag = 8826;  
        globalBackgroundCanvas.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;  
        [self.view insertSubview:globalBackgroundCanvas atIndex:0];  
    }  
}  
  
- (void)viewWillAppear:(BOOL)animated {  
    %orig;  
  
    if (globalBackgroundCanvas) {  
        globalBackgroundCanvas.alpha = 0.0;  
        [UIView animateWithDuration:0.35 animations:^{  
            globalBackgroundCanvas.alpha = 1.0;  
        }];  
    }  
}  
  
%end  
  
%hook CCUIModuleCollectionViewController  
  
- (void)viewDidLayoutSubviews {  
    %orig;  
  
    // Morph all active Control Center module containers into iOS 26 floating capsules  
    NSArray<UIView *> *subviews = self.view.subviews;  
    CGFloat delayCounter = 0.02;  
  
    for (UIView *moduleView in subviews) {  
        if ([moduleView isKindOfClass:[UIView class]] && moduleView.bounds.size.width > 40) {  
            [IOS26ModuleMorpher applyIOS26StylingToModuleView:moduleView cornerRadius:26.0];  
  
            // Staggered Cyber Entrance  
            if (moduleView.alpha < 0.1) {  
                [IOS26ModuleMorpher applyFloatingCyberAnimation:moduleView delay:delayCounter];  
                delayCounter += 0.03;  
            }  
        }  
    }  
}  
  
%end  
  
%hook CCUIContinuousSliderView  
  
- (void)layoutSubviews {  
    %orig;  
  
    // Detect Brightness & Volume modules and overlay iOS 26 Capsule Sliders  
    UIView *parentModule = self.superview;  
    if (parentModule && ![parentModule viewWithTag:7726]) {  
        IOS26SliderType type = IOS26SliderTypeBrightness;  
  
        // Distinguish module by class/identifier name  
        NSString *desc = [self description];  
        if ([desc containsString:@"Audio"] || [desc containsString:@"Volume"]) {  
            type = IOS26SliderTypeVolume;  
        }  
  
        IOS26SliderView *futuristicSlider = [[IOS26SliderView alloc] initWithFrame:self.bounds sliderType:type];  
        futuristicSlider.tag = 7726;  
        futuristicSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;  
        futuristicSlider.value = self.value;  
  
        // Bridge touch events back to SpringBoard framework  
        [futuristicSlider addTarget:self action:@selector(ios26_sliderValueChanged:) forControlEvents:UIControlEventValueChanged];  
  
        // Hide standard slider rendering  
        self.valueIndicatorClippingView.hidden = YES;  
        [self addSubview:futuristicSlider];  
    } else {  
        IOS26SliderView *existing = [parentModule viewWithTag:7726];  
        if (existing) {  
            existing.value = self.value;  
        }  
    }  
}  
  
%new  
- (void)ios26_sliderValueChanged:(IOS26SliderView *)slider {  
    self.value = slider.value;  
    [self sendActionsForControlEvents:UIControlEventValueChanged];  
}  
  
%end
