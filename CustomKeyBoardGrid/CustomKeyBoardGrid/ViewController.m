//
//  ViewController.m
//  CustomKeyBoardGrid
//
//  Created by panf on 2017/3/21.
//  Copyright © 2017年 panf. All rights reserved.
//

#import "ViewController.h"
#import "HBKeyboardDefine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clickKeyboardButtonAction:)
                                                 name:HBKeyboardButtonClickNotification
                                               object:nil];

}

- (void)addTextField {
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, kScreenWidth - 50 * 2, 50)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.delegate = self;
    _textField.font = HBFONT(16);
    _textField.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _textField.layer.borderWidth= 1.0f;
    _textField.placeholder = @"请选择";
    _textField.textColor = [UIColor blackColor];
    _textField.returnKeyType = UIReturnKeyNext;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.textInputView.backgroundColor = [UIColor clearColor];
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:_textField];
    
    _textField.inputAccessoryView = [self TextFieldSetInputAccessoryView];
    
}

- (UIInputView *)TextFieldSetInputAccessoryView {
    UIInputView *inputView = [[UIInputView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 45) inputViewStyle:UIInputViewStyleKeyboard];
    
    inputView.backgroundColor = HBRGB(232,237,241);
    
    float totalWidth = CGRectGetWidth(self.view.frame);
    float totalheight = 45;
    float ySpace = 5.0f;
    float xSpace = 3.0f;
    float buttonHeight = totalheight - ySpace * 2;
    float buttonWidth = (totalWidth - xSpace * 20) / 10.0f;
    
    for(NSInteger count = 1; count <= 10; count++) {
        HBKeyboardButton *button = [HBKeyboardButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor  = HBRGB(235, 235, 235).CGColor;
        button.layer.cornerRadius = 5;
        button.tag = count;
        NSString *titleStr = (count == 10) ? @"0" : [NSString stringWithFormat:@"%ld",(long)count];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = HBFONT(19);
        
        button.frame = CGRectMake(xSpace + (xSpace * 2 + buttonWidth) * (count - 1), ySpace, buttonWidth, buttonHeight);
        [inputView addSubview:button];
    }
    
    return inputView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//输入后放置到末尾，光标移动需要自行设置
- (void)clickKeyboardButtonAction:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSString *str = [info valueForKey:HBKeyboardButtonClickKey];
    _textField.text = [_textField.text stringByAppendingString:str];
}

@end
