#import <UIKit/UIKit.h>  
  
@interface CCUIModularControlCenterViewController : UIViewController  
- (void)dismissAnimated:(BOOL)animated withCompletionHandler:(id)completion;  
@end  
  
@interface CCUIModularControlCenterOverlayViewController : UIViewController  
@property (nonatomic, readonly) CCUIModularControlCenterViewController *modularControlCenterViewController;  
@end  
  
@interface CCUIModuleCollectionViewController : UIViewController  
@property (nonatomic, strong) UIScrollView *moduleScrollView;  
@end  
  
@interface CCUIModuleContentViewController : UIViewController  
@property (nonatomic, strong) UIView *view;  
@end  
  
@interface CCUIContinuousSliderView : UIControl  
@property (nonatomic, assign) float value;  
@property (nonatomic, strong) UIView *valueIndicatorClippingView;  
@end  
  
@interface CCUIModuleSliderView : CCUIContinuousSliderView  
@end
