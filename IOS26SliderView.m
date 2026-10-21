#import "IOS26SliderView.h"  
#import "IOS26GlassView.h"  
#import <AudioToolbox/AudioToolbox.h>  
  
@interface IOS26SliderView () {  
    CGPoint _lastTouchPoint;  
    UIImpactFeedbackGenerator *_feedbackGenerator;  
}  
@property (nonatomic, strong) IOS26GlassView *glassBackground;  
@end  
  
@implementation IOS26SliderView  
  
- (instancetype)initWithFrame:(CGRect)frame sliderType:(IOS26SliderType)type {  
    self = [super initWithFrame:frame];  
    if (self) {  
        _sliderType = type;  
        _value = 0.5;  
        _feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];  
  
        CGFloat radius = 28.0;  
        self.layer.cornerRadius = radius;  
        self.layer.masksToBounds = YES;  
  
        // Background Glass  
        _glassBackground = [[IOS26GlassView alloc] initWithFrame:self.bounds cornerRadius:radius];  
        _glassBackground.userInteractionEnabled = NO;  
        [self addSubview:_glassBackground];  
  
        // Fill Container with Cyber Gradient  
        _fillView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height * (1.0 - _value), frame.size.width, frame.size.height * _value)];  
        _fillView.backgroundColor = [UIColor clearColor];  
        _fillView.userInteractionEnabled = NO;  
  
        _fillGradient = [CAGradientLayer layer];  
        _fillGradient.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);  
  
        if (type == IOS26SliderTypeBrightness) {  
            _fillGradient.colors = @[  
                (id)[UIColor colorWithRed:1.0 green:0.85 blue:0.2 alpha:0.9].CGColor,  
                (id)[UIColor colorWithRed:1.0 green:0.45 blue:0.0 alpha:0.85].CGColor  
            ];  
        } else {  
            _fillGradient.colors = @[  
                (id)[UIColor colorWithRed:0.0 green:0.8 blue:1.0 alpha:0.9].CGColor,  
                (id)[UIColor colorWithRed:0.0 green:0.4 blue:1.0 alpha:0.85].CGColor  
            ];  
        }  
        _fillGradient.startPoint = CGPointMake(0.5, 0.0);  
        _fillGradient.endPoint = CGPointMake(0.5, 1.0);  
        [_fillView.layer addSublayer:_fillGradient];  
        [self addSubview:_fillView];  
  
        // Real-Time Percentage Label  
        _percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, frame.size.width, 18)];  
        _percentageLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightHeavy];  
        _percentageLabel.textColor = [UIColor whiteColor];  
        _percentageLabel.textAlignment = NSTextAlignmentCenter;  
        _percentageLabel.alpha = 0.9;  
        [self addSubview:_percentageLabel];  
  
        // Icon Image  
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 24) / 2.0, frame.size.height - 38, 24, 24)];  
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;  
        _iconImageView.tintColor = [UIColor whiteColor];  
  
        NSString *symbolName = (type == IOS26SliderTypeBrightness) ? @"sun.max.fill" : @"speaker.wave.3.fill";  
        _iconImageView.image = [UIImage systemImageNamed:symbolName];  
        [self addSubview:_iconImageView];  
  
        [self updateDisplay];  
    }  
    return self;  
}  
  
- (void)layoutSubviews {  
    [super layoutSubviews];  
    _glassBackground.frame = self.bounds;  
    [self updateDisplay];  
}  
  
- (void)setValue:(CGFloat)value animated:(BOOL)animated {  
    _value = fmaxf(0.0f, fminf(1.0f, value));  
  
    void (^updateBlock)(void) = ^{  
        [self updateDisplay];  
    };  
  
    if (animated) {  
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:updateBlock completion:nil];  
    } else {  
        updateBlock();  
    }  
}  
  
- (void)updateDisplay {  
    CGFloat fillHeight = self.bounds.size.height * _value;  
    self.fillView.frame = CGRectMake(0, self.bounds.size.height - fillHeight, self.bounds.size.width, fillHeight);  
    self.fillGradient.frame = CGRectMake(0, - (self.bounds.size.height - fillHeight), self.bounds.size.width, self.bounds.size.height);  
    self.percentageLabel.text = [NSString stringWithFormat:@"%.0f%%", _value * 100.0];  
}  
  
#pragma mark - Touch Tracking  
  
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {  
    [_feedbackGenerator prepare];  
    _lastTouchPoint = [touch locationInView:self];  
    [self handleTouchAtPoint:_lastTouchPoint];  
    [self animateScale:YES];  
    return YES;  
}  
  
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {  
    CGPoint point = [touch locationInView:self];  
    [self handleTouchAtPoint:point];  
    return YES;  
}  
  
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {  
    [self animateScale:NO];  
    [_feedbackGenerator impactOccurred];  
}  
  
- (void)cancelTrackingWithEvent:(UIEvent *)event {  
    [self animateScale:NO];  
}  
  
- (void)handleTouchAtPoint:(CGPoint)point {  
    CGFloat rawValue = 1.0 - (point.y / self.bounds.size.height);  
    CGFloat clamped = fmaxf(0.0f, fminf(1.0f, rawValue));  
  
    if (fabs(clamped - _value) > 0.01) {  
        self.value = clamped;  
        [self sendActionsForControlEvents:UIControlEventValueChanged];  
    }  
}  
  
- (void)animateScale:(BOOL)pressed {  
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{  
        self.transform = pressed ? CGAffineTransformMakeScale(1.04, 1.04) : CGAffineTransformIdentity;  
        [self.glassBackground updateGlowIntensity:pressed ? 1.0 : 0.4 animated:NO];  
    } completion:nil];  
}  
  
@end
