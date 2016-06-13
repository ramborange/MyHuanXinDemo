//
//  ChatInputView.h
//  MyHuanXinDemo
//
//  Created by ljf on 16/5/19.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^inputViewTextBlock)(NSString *);

@interface ChatInputView : UIView

@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) inputViewTextBlock myTextBlock;

@end
