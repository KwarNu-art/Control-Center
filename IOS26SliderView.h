#import <UIKit/UIKit.h>  
  
typedef NS_ENUM(NSInteger, IOS26SliderType) {  
    IOS26SliderTypeBrightness,  
    IOS26SliderTypeVolume  
};  
  
@interface IOS26SliderView : UIControl  
  
@property (nonatomic, assign) CGFloat value; // 0.0 to 1.0  
@property (nonatomic, assign) IOS26SliderType sliderType;  
@property (nonatomic, strong) UIImageView *iconImageView;  
@property (nonatomic, strong) UILabel *percentageLabel;  
@property (nonatomic, strong) UIView *fillView;  
@property (nonatomic, strong) CAGradientLayer *fillGradient;  
  
- (instancetype)initWithFrame:(CGRect)frame sliderType:(IOS26SliderType)type;  
- (void)setValue:(CGFloat)value animated:(BOOL)animated;  
  
@end
