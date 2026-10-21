// Control Center 26: iOS 26 style "liquid glass" for the iOS 14 to 16 Control Center (runs in SpringBoard).
//
// Fast by design: it re-uses the system's own blur (no extra blur views), adds only two cheap gradient
// layers per tile, rebuilds them only when a size changes, and has no timers, observers or animations.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

// Private Control Center classes, declared only so the hooks compile.
@interface CCUIContentModuleContainerView : UIView @end
@interface CCUIRoundButton : UIView @end
@interface CCUIContinuousSliderView : UIView @end
@interface CCUIModularControlCenterOverlayViewController : UIViewController @end

static const CGFloat kTileRadius = 30.0;    // iOS 26 tiles are rounder than the old 19 pt
static char kSheenKey, kRimKey, kSizeKey;

static UIColor *White(CGFloat a) { return [UIColor colorWithWhite:1 alpha:a]; }

// Adds the liquid glass finish: a soft light sheen and a thin rim that is bright at the top left and fades away,
// like light catching the edge of real glass.
static void ApplyGlass(UIView *view, CGFloat radius, BOOL clip) {
    CGRect b = view.bounds;
    if (CGRectIsEmpty(b) || radius <= 0) return;

    CALayer *layer = view.layer;
    layer.cornerRadius = radius;
    layer.cornerCurve = kCACornerCurveContinuous;
    if (clip) layer.masksToBounds = YES;

    CAGradientLayer *sheen = objc_getAssociatedObject(view, &kSheenKey);
    CAGradientLayer *rim = objc_getAssociatedObject(view, &kRimKey);
    if (!sheen || !rim) {
        sheen = [CAGradientLayer layer];
        sheen.colors = @[(id)White(0.20).CGColor, (id)White(0.03).CGColor, (id)White(0.0).CGColor, (id)White(0.07).CGColor];
        sheen.locations = @[@0, @0.38, @0.7, @1];
        sheen.startPoint = CGPointMake(0.1, 0);
        sheen.endPoint = CGPointMake(0.9, 1);
        sheen.cornerCurve = kCACornerCurveContinuous;
        sheen.masksToBounds = YES;
        sheen.zPosition = 900;

        rim = [CAGradientLayer layer];
        rim.colors = @[(id)White(0.85).CGColor, (id)White(0.10).CGColor, (id)White(0.38).CGColor];
        rim.locations = @[@0, @0.55, @1];
        rim.startPoint = CGPointMake(0, 0);
        rim.endPoint = CGPointMake(1, 1);
        rim.zPosition = 901;
        CAShapeLayer *ring = [CAShapeLayer layer];
        ring.fillColor = nil;
        ring.strokeColor = UIColor.whiteColor.CGColor;
        ring.lineWidth = 1.2;
        rim.mask = ring;

        [layer addSublayer:sheen];
        [layer addSublayer:rim];
        objc_setAssociatedObject(view, &kSheenKey, sheen, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(view, &kRimKey, rim, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    // Only rebuild when the size or radius changed.
    NSValue *now = [NSValue valueWithCGRect:CGRectMake(b.size.width, b.size.height, radius, 0)];
    if ([objc_getAssociatedObject(view, &kSizeKey) isEqualToValue:now]) return;
    objc_setAssociatedObject(view, &kSizeKey, now, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    sheen.frame = b;
    sheen.cornerRadius = radius;
    rim.frame = b;
    CAShapeLayer *ring = (CAShapeLayer *)rim.mask;
    ring.frame = CGRectMake(0, 0, b.size.width, b.size.height);
    ring.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(ring.bounds, 0.6, 0.6)
                                           cornerRadius:MAX(radius - 0.6, 0)].CGPath;
    [CATransaction commit];
}

// A very light tint behind the tiles, so the glass has something to refract against.
@interface CC26TintView : UIView @end
@implementation CC26TintView
+ (Class)layerClass { return CAGradientLayer.class; }
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        CAGradientLayer *g = (CAGradientLayer *)self.layer;
        g.colors = @[(id)White(0.05).CGColor,
                     (id)[UIColor colorWithWhite:0 alpha:0.08].CGColor,
                     (id)[UIColor colorWithWhite:0 alpha:0.20].CGColor];
    }
    return self;
}
@end

%hook CCUIModularControlCenterOverlayViewController

- (void)viewDidLoad {
    %orig;
    UIView *host = self.view;
    if ([host viewWithTag:2626]) return;
    CC26TintView *tint = [[CC26TintView alloc] initWithFrame:host.bounds];
    tint.tag = 2626;
    [host insertSubview:tint atIndex:MIN((NSUInteger)1, host.subviews.count)];
}

%end

// The tiles (connectivity, music, focus, brightness and so on).
%hook CCUIContentModuleContainerView

- (void)layoutSubviews {
    %orig;
    CGRect b = self.bounds;
    ApplyGlass(self, MIN(kTileRadius, MIN(b.size.width, b.size.height) / 2), YES);
}

%end

// The round buttons (Wi-Fi, Bluetooth, Airplane and so on).
%hook CCUIRoundButton

- (void)layoutSubviews {
    %orig;
    CGRect b = self.bounds;
    ApplyGlass(self, MIN(b.size.width, b.size.height) / 2, NO);
}

%end

// Brightness and volume: full capsules, like iOS 26.
%hook CCUIContinuousSliderView

- (void)layoutSubviews {
    %orig;
    CGRect b = self.bounds;
    ApplyGlass(self, MIN(b.size.width, b.size.height) / 2, YES);
}

%end
