#import "IOS26ModuleMorpher.h"  
#import "IOS26GlassView.h"  
  
@implementation IOS26ModuleMorpher  
  
+ (void)applyIOS26StylingToModuleView:(UIView *)view cornerRadius:(CGFloat)radius {  
    if (!view || [view viewWithTag:92601]) return;  
  
    view.layer.cornerRadius = radius;  
    view.layer.masksToBounds = NO;  
  
    // Inject Cyber Glass Backing  
    IOS26GlassView *glass = [[IOS26GlassView alloc] initWithFrame:view.bounds cornerRadius:radius];  
    glass.tag = 92601;  
    glass.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;  
    glass.userInteractionEnabled = NO;  
  
    [view insertSubview:glass atIndex:0];  
  
    // Smooth Spring Micro-interaction on Touch  
    view.layer.allowsGroupOpacity = YES;  
}  
  
+ (void)applyFloatingCyberAnimation:(UIView *)view delay:(CGFloat)delay {  
    view.transform = CGAffineTransformMakeTranslation(0, 30);  
    view.alpha = 0.0;  
  
    [UIView animateWithDuration:0.65 delay:delay usingSpringWithDamping:0.75 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{  
        view.transform = CGAffineTransformIdentity;  
        view.alpha = 1.0;  
    } completion:nil];  
}  
  
@end
