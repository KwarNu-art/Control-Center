#import <UIKit/UIKit.h>  
#import "IOS26GlassEffect.h"  
  
@interface IOS26SliderView : UIView  
@property (nonatomic, assign) CGFloat progress;  
@property (nonatomic, strong) UILabel *percentageLabel;  
@property (nonatomic, strong) UIView *fillView;  
@end  
  
@implementation IOS26SliderView  
  
- (instancetype)initWithFrame:(CGRect)frame {  
    if (self = [super initWithFrame:frame]) {  
        self.layer.cornerRadius = 24.0;  
        self.layer.masksToBounds = YES;  
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.35];  
  
        IOS26GlassEffect *glass = [IOS26GlassEffect glassViewWithFrame:self.bounds cornerRadius:24.0];  
        [self addSubview:glass];  
  
        self.fillView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 0)];  
        self.fillView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.92];  
        [self addSubview:self.fillView];  
  
        self.percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 35, frame.size.width, 25)];  
        self.percentageLabel.textAlignment = NSTextAlignmentCenter;  
        self.percentageLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];  
        self.percentageLabel.textColor = [UIColor whiteColor];  
        [self addSubview:self.percentageLabel];  
    }  
    return self;  
}  
  
- (void)setProgress:(CGFloat)progress {  
    _progress = MIN(MAX(progress, 0.0), 1.0);  
    CGFloat height = self.bounds.size.height * _progress;  
    self.fillView.frame = CGRectMake(0, self.bounds.size.height - height, self.bounds.size.width, height);  
    self.percentageLabel.text = [NSString stringWithFormat:@"%d%%", (int)(_progress * 100)];  
}  
  
@end
