#import "Headers.h"  
#import "IOS26GlassEffect.h"  
  
%hook CCUIModularControlCenterOverlayViewController  
  
- (void)viewDidLoad {  
    %orig;  
  
    // Apply Deep Liquid Dim & Blur Background  
    UIView *bgView = [self overlayBackgroundView];  
    if (bgView) {  
        bgView.backgroundColor = [UIColor colorWithRed:0.02 green:0.03 blue:0.07 alpha:0.65];  
  
        UIBlurEffect *ultraBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialDark];  
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:ultraBlur];  
        blurView.frame = bgView.bounds;  
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;  
        [bgView insertSubview:blurView atIndex:0];  
    }  
}  
  
%end  
  
%hook CCUIContentModuleContainerView  
  
- (void)layoutSubviews {  
    %orig;  
  
    // Morph module cards into iOS 26 Capsule/Pill aesthetic  
    self.layer.cornerRadius = 22.0;  
    self.layer.cornerCurve = kCACornerCurveContinuous;  
    self.layer.masksToBounds = NO;  
  
    // Specular edge glow & ambient shadow  
    self.layer.shadowColor = [UIColor colorWithRed:0.35 green:0.65 blue:1.0 alpha:0.3].CGColor;  
    self.layer.shadowOpacity = 0.45;  
    self.layer.shadowRadius = 12.0;  
    self.layer.shadowOffset = CGSizeMake(0, 4);  
  
    // Apply glass layer if not present  
    if (![self viewWithTag:2601]) {  
        IOS26GlassEffect *glass = [IOS26GlassEffect glassViewWithFrame:self.bounds cornerRadius:22.0];  
        glass.tag = 2601;  
        glass.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;  
        [self insertSubview:glass atIndex:0];  
    }  
}  
  
%end  
  
%hook CCUIContinuousSliderView  
  
- (void)layoutSubviews {  
    %orig;  
    self.layer.cornerRadius = 24.0;  
    self.layer.cornerCurve = kCACornerCurveContinuous;  
    self.layer.masksToBounds = YES;  
    self.layer.borderWidth = 1.2;  
    self.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.35].CGColor;  
}  
  
%end
