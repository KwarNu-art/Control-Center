#import "IOS26GlassView.h"  
  
@implementation IOS26GlassView  
  
- (instancetype)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius {  
    self = [super initWithFrame:frame];  
    if (self) {  
        self.backgroundColor = [UIColor clearColor];  
        self.layer.masksToBounds = NO;  
  
        // 1. Ultra-deep Acrylic Blur  
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialDark];  
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];  
        _blurEffectView.frame = self.bounds;  
        _blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;  
        _blurEffectView.layer.cornerRadius = radius;  
        _blurEffectView.layer.masksToBounds = YES;  
        [self addSubview:_blurEffectView];  
  
        // 2. Cyan / Violet Holographic Specular Border  
        _specularBorderLayer = [CAGradientLayer layer];  
        _specularBorderLayer.frame = self.bounds;  
        _specularBorderLayer.cornerRadius = radius;  
        _specularBorderLayer.colors = @[  
            (id)[UIColor colorWithRed:0.0 green:0.85 blue:1.0 alpha:0.65].CGColor,  
            (id)[UIColor colorWithRed:0.75 green:0.1 blue:1.0 alpha:0.25].CGColor,  
            (id)[UIColor colorWithRed:0.0 green:0.85 blue:1.0 alpha:0.1].CGColor  
        ];  
        _specularBorderLayer.startPoint = CGPointMake(0.0, 0.0);  
        _specularBorderLayer.endPoint = CGPointMake(1.0, 1.0);  
  
        CAShapeLayer *borderMask = [CAShapeLayer layer];  
        borderMask.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius].CGPath;  
        borderMask.fillColor = [UIColor clearColor].CGColor;  
        borderMask.strokeColor = [UIColor whiteColor].CGColor;  
        borderMask.lineWidth = 1.2;  
        _specularBorderLayer.mask = borderMask;  
        [self.layer addSublayer:_specularBorderLayer];  
  
        // 3. Neon Ambient Drop Shadow  
        self.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:0.4].CGColor;  
        self.layer.shadowOpacity = 0.55;  
        self.layer.shadowRadius = 14.0;  
        self.layer.shadowOffset = CGSizeMake(0, 6);  
    }  
    return self;  
}  
  
- (void)layoutSubviews {  
    [super layoutSubviews];  
    _blurEffectView.frame = self.bounds;  
    _specularBorderLayer.frame = self.bounds;  
    CAShapeLayer *mask = (CAShapeLayer *)_specularBorderLayer.mask;  
    mask.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.blurEffectView.layer.cornerRadius].CGPath;  
}  
  
- (void)updateGlowIntensity:(CGFloat)intensity animated:(BOOL)animated {  
    void (^actions)(void) = ^{  
        self.layer.shadowOpacity = intensity * 0.8;  
        self.layer.shadowRadius = 10.0 + (intensity * 10.0);  
    };  
  
    if (animated) {  
        [UIView animateWithDuration:0.25 animations:actions];  
    } else {  
        actions();  
    }  
}  
  
@end
