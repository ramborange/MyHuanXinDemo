//
//  ChatInputView.m
//  MyHuanXinDemo
//
//  Created by ljf on 16/5/19.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import "ChatInputView.h"

@interface ChatInputView() <UITextFieldDelegate>

@end

@implementation ChatInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textfield = [Utility getTextFiledWithFrame:CGRectMake(10, 6, frame.size.width-90, 38) isSecurty:NO placeholder:@" 说点什么呢" fontsize:16 tintColor:[UIColor darkGrayColor] bground:nil leftView:nil rightView:nil boardWith:1.0 boardColor:MY_LIGHTGRAY_COLOR cornerRadius:3];
        _textfield.returnKeyType = UIReturnKeyDone;
        _textfield.delegate = self;
        _textfield.backgroundColor = [UIColor whiteColor];
        [self addSubview:_textfield];
        
        _sendBtn = [Utility getButtonWithFontSize:18 text:@"发送" textColor:[UIColor whiteColor] bgColor:MY_COLOR bgImg:nil layerCorner:3 layerBoardWidth:0 layerBoardColor:nil btnRect:CGRectMake(frame.size.width-72, 8, 64, 34)];
        [self addSubview:_sendBtn];
        
    }
    [self.layer setShadowColor:MY_LIGHTGRAY_COLOR.CGColor];
    [self.layer setShadowOpacity:1.0];
    [self.layer setShadowRadius:1.0];
    [self.layer setShadowOffset:CGSizeMake(0, -1)];
    return self;
}

#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_textfield resignFirstResponder];
    return YES;
}

@end
