#import <UIKit/UIKit.h>  
#import <QuartzCore/QuartzCore.h>  
  
@interface MTMaterialView : UIView  
+ (instancetype)materialViewWithRecipe:(NSInteger)recipe configuration:(NSInteger)configuration;  
@property (nonatomic, assign) CGFloat weight;  
@end  
  
@interface CCUIModularControlCenterOverlayViewController : UIViewController  
@property (nonatomic, readonly) UIView *overlayHeaderView;  
@property (nonatomic, readonly) UIView *overlayBackgroundView;  
@end  
  
@interface CCUIContentModuleContainerView : UIView  
@property (nonatomic, copy) NSString *moduleIdentifier;  
@property (nonatomic, readonly) UIView *contentView;  
@end  
  
@interface CCUIContinuousSliderView : UIView  
@property (nonatomic, assign) float value;  
@property (nonatomic, readonly) UIView *valueIndicatorClippingView;  
@end  
  
@interface CCUIHeaderPocketView : UIView  
@property (nonatomic, readonly) UIView *headerBackgroundView;  
@end
