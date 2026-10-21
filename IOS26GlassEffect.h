#import <UIKit/UIKit.h>  
  
@interface IOS26GlassEffect : UIView  
+ (instancetype)glassViewWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius;  
- (void)applyDynamicGlowColor:(UIColor *)glowColor;  
@end
