#import <UIKit/UIKit.h>  
  
@interface IOS26GlassView : UIView  
  
@property (nonatomic, strong) UIVisualEffectView *blurEffectView;  
@property (nonatomic, strong) CAGradientLayer *specularBorderLayer;  
@property (nonatomic, strong) CAGradientLayer *innerGlowLayer;  
  
- (instancetype)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius;  
- (void)updateGlowIntensity:(CGFloat)intensity animated:(BOOL)animated;  
  
@end
