//
//  HBKeyboardButton.h
//  hbgj
//
//  Created by panf on 2017/3/21.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HBKeyboardButtonPosition) {
    HBKeyboardButtonPosition_Left,
    HBKeyboardButtonPosition_Middle,
    HBKeyboardButtonPosition_Right,
};

@interface HBKeyboardButton : UIButton

@property (nonatomic, assign) HBKeyboardButtonPosition position;

@end
