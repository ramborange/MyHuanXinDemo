//
//  AddFriendViewController.m
//  MyHuanXinDemo
//
//  Created by ljf on 16/5/19.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import "AddFriendViewController.h"

@interface AddFriendViewController ()
{
    UITextField *userNameTf;
}
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"添加好友";
    
    userNameTf = [Utility getTextFiledWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-40, 40) isSecurty:NO placeholder:@"  输入用户名" fontsize:18 tintColor:[UIColor darkGrayColor] bground:nil leftView:nil rightView:nil boardWith:1.0 boardColor:MY_GRAY_COLOR cornerRadius:3];
    [self.view addSubview:userNameTf];
    
    
    UIButton *addBtn = [Utility getButtonWithFontSize:20 text:@"添加" textColor:[UIColor whiteColor] bgColor:MY_COLOR bgImg:nil layerCorner:5 layerBoardWidth:0 layerBoardColor:nil btnRect:CGRectMake(20, 160, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:addBtn];
    [[addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       BOOL result = [[EaseMob sharedInstance].chatManager addBuddy:userNameTf.text message:@"加个好友呗O(∩_∩)O哈哈~" error:nil];
        if (result) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"发送失败"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
