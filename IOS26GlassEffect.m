#import "IOS26GlassEffect.h"  
  
@interface IOS26GlassEffect ()  
@property (nonatomic, strong) UIVisualEffectView *blurView;  
@property (nonatomic, strong) CAGradientLayer *borderGlow;  
@end  
  
@implementation IOS26GlassEffect  
  
+ (instancetype)glassViewWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius {  
    IOS26GlassEffect *view = [[self alloc] initWithFrame:frame];  
    view.layer.cornerRadius = radius;  
    view.layer.masksToBounds = YES;  
    [view setupGlassLayersWithRadius:radius];  
    return view;  
}  
  
- (void)setupGlassLayersWithRadius:(CGFloat)radius {  
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialDark];  
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];  
    self.blurView.frame = self.bounds;  
    self.blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;  
    [self addSubview:self.blurView];  
  
    // iOS 26 Specular Highlight Border  
    self.borderGlow = [CAGradientLayer layer];  
    self.borderGlow.frame = self.bounds;  
    self.borderGlow.colors = @[  
        (id)[UIColor colorWithWhite:1.0 alpha:0.45].CGColor,  
        (id)[UIColor colorWithWhite:1.0 alpha:0.05].CGColor,  
        (id)[UIColor colorWithWhite:1.0 alpha:0.25].CGColor  
    ];  
    self.borderGlow.startPoint = CGPointMake(0.0, 0.0);  
    self.borderGlow.endPoint = CGPointMake(1.0, 1.0);  
    self.borderGlow.cornerRadius = radius;  
  
    CAShapeLayer *mask = [CAShapeLayer layer];  
    mask.lineWidth = 1.5;  
    mask.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius].CGPath;  
    mask.fillColor = [UIColor clearColor].CGColor;  
    mask.strokeColor = [UIColor whiteColor].CGColor;  
    self.borderGlow.mask = mask;  
  
    [self.layer addSublayer:self.borderGlow];  
}  
  
- (void)applyDynamicGlowColor:(UIColor *)glowColor {  
    self.layer.shadowColor = glowColor.CGColor;  
    self.layer.shadowOpacity = 0.6f;  
    self.layer.shadowRadius = 14.0f;  
    self.layer.shadowOffset = CGSizeZero;  
    self.layer.masksToBounds = NO;  
}  
  
- (void)layoutSubviews {  
    [super layoutSubviews];  
    self.blurView.frame = self.bounds;  
    self.borderGlow.frame = self.bounds;  
    if ([self.borderGlow.mask isKindOfClass:[CAShapeLayer class]]) {  
        ((CAShapeLayer *)self.borderGlow.mask).path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;  
    }  
}  
  
@end
