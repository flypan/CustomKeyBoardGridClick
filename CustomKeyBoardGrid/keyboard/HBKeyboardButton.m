//
//  HBKeyboardButton.m
//  hbgj
//
//  Created by panf on 2017/3/21.
//
//

#import "HBKeyboardButton.h"
#import "HBKeyboardButtonOverlayerView.h"
#import "HBKeyboardDefine.h"

@interface HBKeyboardButton ()

@property (nonatomic, strong) HBKeyboardButtonOverlayerView *buttonView;

@end


@implementation HBKeyboardButton

#pragma mark - lifeCycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if(self) {
        [self addTarget:self action:@selector(handleTouchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(handleTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)didMoveToSuperview {
    [self updateButtonPosition];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setNeedsDisplay];
    
    [self updateButtonPosition];
}

- (void)updateButtonPosition {
    CGFloat leftPadding = CGRectGetMinX(self.frame);
    CGFloat rightPadding = CGRectGetMaxX(self.superview.frame) - CGRectGetMaxX(self.frame);
    CGFloat minimumClearance = CGRectGetWidth(self.frame) / 2 + 8;
    
    if (leftPadding >= minimumClearance && rightPadding >= minimumClearance) {
        self.position = HBKeyboardButtonPosition_Middle;
    } else if (leftPadding > rightPadding) {
        self.position = HBKeyboardButtonPosition_Left;
    } else {
        self.position = HBKeyboardButtonPosition_Right;
    }
}


#pragma mark - Touch Actions
- (void)handleTouchDown {
    [[UIDevice currentDevice] playInputClick];
    
    [self showInputView];
}

- (void)handleTouchUpInside {
    [self hideInputView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HBKeyboardButtonClickNotification object:nil userInfo:@{HBKeyboardButtonClickKey:self.titleLabel.text}];
}

#pragma mark - Internal - UI
- (void)showInputView {
    [self hideInputView];
    
    self.buttonView = [[HBKeyboardButtonOverlayerView alloc] initWithKeyboardButton:self];
    
    [self.window addSubview:self.buttonView];
}

- (void)hideInputView {
    [self.buttonView removeFromSuperview];
    self.buttonView = nil;
}

@end
