//
//  HBKeyboardButtonOverlayerView.m
//  hbgj
//
//  Created by panf on 2017/3/21.
//
//

#import "HBKeyboardButtonOverlayerView.h"
#import "HBKeyboardButton.h"
#import "HBBezierPath.h"

@interface HBKeyboardButtonOverlayerView ()

@property (nonatomic, assign) HBKeyboardButton *button;

@end


@implementation HBKeyboardButtonOverlayerView

- (instancetype)initWithKeyboardButton:(HBKeyboardButton *)button {
    CGRect frame = [UIScreen mainScreen].bounds;
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        frame = CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetWidth(frame));
    }
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _button = button;
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    
    return self;
}


#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    [self drawInputView:rect];
}

- (void)drawInputView:(CGRect)rect {

    UIBezierPath *bezierPath = [self inputViewPath];
    
    CGRect keyRect = [self convertRect:self.button.frame fromView:self.button.superview];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    {
        UIColor* shadow = [[UIColor lightGrayColor] colorWithAlphaComponent: 0.5];
        CGSize shadowOffset = CGSizeMake(0, 0.5);
        CGFloat shadowBlurRadius = 2;
        
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
        [[UIColor whiteColor] setFill];
        [bezierPath fill];
        CGContextRestoreGState(context);
    }
    
    {
        UIColor *color = [UIColor whiteColor];
        UIColor *shadow = [UIColor lightGrayColor];
        CGSize shadowOffset = CGSizeMake(0.1, 1.1);
        CGFloat shadowBlurRadius = 0;

        UIBezierPath *roundedRectanglePath =
        [UIBezierPath bezierPathWithRoundedRect:CGRectMake(keyRect.origin.x, keyRect.origin.y, keyRect.size.width, keyRect.size.height - 1) cornerRadius:4];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
        [color setFill];
        [roundedRectanglePath fill];
        
        CGContextRestoreGState(context);
    }
    
    // Text drawing
    {
        UIColor *stringColor = [UIColor blackColor];
        
        CGRect stringRect = bezierPath.bounds;
        
        NSMutableParagraphStyle *p = [NSMutableParagraphStyle new];
        p.alignment = NSTextAlignmentCenter;
        
        NSString *inputString = self.button.titleLabel.text;
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithString:inputString
                                                attributes:
                                                @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:40], NSForegroundColorAttributeName : stringColor, NSParagraphStyleAttributeName : p}];
        [attributedString drawInRect:stringRect];
    }
}

- (UIBezierPath *)inputViewPath {
    CGRect keyRect = [self convertRect:self.button.frame fromView:self.button.superview];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(7, 13, 7, 13);
    CGFloat upperWidth = CGRectGetWidth(_button.frame) + insets.left + insets.right;
    CGFloat lowerWidth = CGRectGetWidth(_button.frame);
    CGFloat majorRadius = 10.f;
    CGFloat minorRadius = 4.f;
    
    HBBezierPath *path = [HBBezierPath new];
    [path home];
    path.lineWidth = 0;
    path.lineCapStyle = kCGLineCapRound;
    
    switch (self.button.position) {
        case HBKeyboardButtonPosition_Middle:
        {
            [path rightArc:majorRadius turn:90]; // #1
            [path forward:upperWidth - 2 * majorRadius]; // #2 top
            [path rightArc:majorRadius turn:90]; // #3
            [path forward:CGRectGetHeight(keyRect) - 2 * majorRadius + insets.top + insets.bottom]; // #4 right big
            [path rightArc:majorRadius turn:48]; // #5
            [path forward:8.5f];
            [path leftArc:majorRadius turn:48]; // #6
            [path forward:CGRectGetHeight(keyRect) - 8.5f + 1];
            [path rightArc:minorRadius turn:90];
            [path forward:lowerWidth - 2 * minorRadius]; //  lowerWidth - 2 * minorRadius + 0.5f
            [path rightArc:minorRadius turn:90];
            [path forward:CGRectGetHeight(keyRect) - 2 * minorRadius];
            [path leftArc:majorRadius turn:48];
            [path forward:8.5f];
            [path rightArc:majorRadius turn:48];
            
            CGFloat offsetX = 0, offsetY = 0;
            CGRect pathBoundingBox = path.bounds;
            
            offsetX = CGRectGetMidX(keyRect) - CGRectGetMidX(path.bounds);
            offsetY = CGRectGetMaxY(keyRect) - CGRectGetHeight(pathBoundingBox) + 10;
            
            [path applyTransform:CGAffineTransformMakeTranslation(offsetX, offsetY)];
        }
            break;
            
        case HBKeyboardButtonPosition_Left:
        {
            [path rightArc:majorRadius turn:90]; // #1
            [path forward:upperWidth - 2 * majorRadius]; // #2 top
            [path rightArc:majorRadius turn:90]; // #3
            [path forward:CGRectGetHeight(keyRect) - 2 * majorRadius + insets.top + insets.bottom]; // #4 right big
            [path rightArc:majorRadius turn:45]; // #5
            [path forward:28]; // 6
            [path leftArc:majorRadius turn:45]; // #7
            [path forward:CGRectGetHeight(keyRect) - 26 + (insets.left + insets.right) / 4]; // #8
            [path rightArc:minorRadius turn:90]; // 9
            [path forward:path.currentPoint.x - minorRadius]; // 10
            [path rightArc:minorRadius turn:90]; // 11
            
            
            CGFloat offsetX = 0, offsetY = 0;
            CGRect pathBoundingBox = path.bounds;
            
            offsetX = CGRectGetMaxX(keyRect) - CGRectGetWidth(path.bounds);
            offsetY = CGRectGetMaxY(keyRect) - CGRectGetHeight(pathBoundingBox) - CGRectGetMinY(path.bounds);
            
            [path applyTransform:CGAffineTransformTranslate(CGAffineTransformMakeScale(-1, 1), -offsetX - CGRectGetWidth(path.bounds), offsetY)];
        }
            break;
            
        case HBKeyboardButtonPosition_Right:
        {
            [path rightArc:majorRadius turn:90]; // #1
            [path forward:upperWidth - 2 * majorRadius]; // #2 top
            [path rightArc:majorRadius turn:90]; // #3
            [path forward:CGRectGetHeight(keyRect) - 2 * majorRadius + insets.top + insets.bottom]; // #4 right big
            [path rightArc:majorRadius turn:45]; // #5
            [path forward:28]; // 6
            [path leftArc:majorRadius turn:45]; // #7
            [path forward:CGRectGetHeight(keyRect) - 26 + (insets.left + insets.right) / 4]; // #8
            [path rightArc:minorRadius turn:90]; // 9
            [path forward:path.currentPoint.x - minorRadius]; // 10
            [path rightArc:minorRadius turn:90]; // 11
            
            CGFloat offsetX = 0, offsetY = 0;
            CGRect pathBoundingBox = path.bounds;
            
            offsetX = CGRectGetMinX(keyRect);
            offsetY = CGRectGetMaxY(keyRect) - CGRectGetHeight(pathBoundingBox) - CGRectGetMinY(path.bounds);
            
            [path applyTransform:CGAffineTransformMakeTranslation(offsetX, offsetY)];
        }
            break;
            
        default:
            break;
    }
    
    return path;
}

@end
