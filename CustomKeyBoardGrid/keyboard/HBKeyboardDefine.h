//
//  HBKeyboardDefine.h
//  CustomKeyBoardGrid
//
//  Created by panf on 2017/3/21.
//  Copyright © 2017年 panf. All rights reserved.
//

#ifndef HBKeyboardDefine_h
#define HBKeyboardDefine_h

#import "HBKeyboardButton.h"


#define HBRGB(r,g,b)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define HBFONT(a)     [UIFont systemFontOfSize:a]

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width


#define HBKeyboardButtonClickNotification  @"HBKeyboardButtonClickNotification"
#define HBKeyboardButtonClickKey @"HBKeyboardButtonClickKey"


#endif /* HBKeyboardDefine_h */


