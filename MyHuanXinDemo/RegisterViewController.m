//
//  RegisterViewController.m
//  MyHuanXinDemo
//
//  Created by ljf on 16/5/19.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
{
    UITextField *accountTf;
    UITextField *passwordTf;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"注册界面";
    
    accountTf = [Utility getTextFiledWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-40, 40) isSecurty:NO placeholder:@"  输入用户名" fontsize:18 tintColor:[UIColor darkGrayColor] bground:nil leftView:nil rightView:nil boardWith:1.0 boardColor:MY_GRAY_COLOR cornerRadius:3];
    [self.view addSubview:accountTf];
    
    passwordTf = [Utility getTextFiledWithFrame:CGRectMake(20, 160, SCREEN_WIDTH-40, 40) isSecurty:YES placeholder:@"  输入密码" fontsize:18 tintColor:[UIColor darkGrayColor] bground:nil leftView:nil rightView:nil boardWith:1.0 boardColor:MY_GRAY_COLOR cornerRadius:3];
    [self.view addSubview:passwordTf];
    
    UIButton *registerBtn = [Utility getButtonWithFontSize:20 text:@"注 册" textColor:[UIColor whiteColor] bgColor:MY_COLOR bgImg:nil layerCorner:5 layerBoardWidth:0 layerBoardColor:nil btnRect:CGRectMake(20, 240, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:registerBtn];
    [[registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:accountTf.text password:passwordTf.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
           if (!error) {
               [SVProgressHUD showSuccessWithStatus:@"注册成功"];
               [self.navigationController popViewControllerAnimated:YES];
           }else {
               [SVProgressHUD showErrorWithStatus:[error description]];
           }
       } onQueue:dispatch_get_main_queue()];
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [accountTf resignFirstResponder];
    [passwordTf resignFirstResponder];
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
