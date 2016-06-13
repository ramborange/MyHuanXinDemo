//
//  ViewController.m
//  MyHuanXinDemo
//
//  Created by ljf on 16/5/19.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "FriendListViewController.h"

@interface ViewController ()
{
    UITextField *accountTf;
    UITextField *passwordTf;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"登录界面";
    
    accountTf = [Utility getTextFiledWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-40, 40) isSecurty:NO placeholder:@"  输入用户名" fontsize:18 tintColor:[UIColor darkGrayColor] bground:nil leftView:nil rightView:nil boardWith:1.0 boardColor:MY_GRAY_COLOR cornerRadius:3];
    [self.view addSubview:accountTf];
    
    passwordTf = [Utility getTextFiledWithFrame:CGRectMake(20, 160, SCREEN_WIDTH-40, 40) isSecurty:YES placeholder:@"  输入密码" fontsize:18 tintColor:[UIColor darkGrayColor] bground:nil leftView:nil rightView:nil boardWith:1.0 boardColor:MY_GRAY_COLOR cornerRadius:3];
    [self.view addSubview:passwordTf];
    
    UIButton *loginBtn = [Utility getButtonWithFontSize:20 text:@"登 录" textColor:[UIColor whiteColor] bgColor:MY_COLOR bgImg:nil layerCorner:5 layerBoardWidth:0 layerBoardColor:nil btnRect:CGRectMake(20, 240, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:loginBtn];
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:accountTf.text password:passwordTf.text completion:^(NSDictionary *loginInfo, EMError *error) {
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                
                [[NSUserDefaults standardUserDefaults] setObject:accountTf.text forKey:@"AccountName"];
                [[NSUserDefaults standardUserDefaults] setObject:passwordTf.text forKey:@"Password"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                FriendListViewController *vc = [[FriendListViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }else {
                [SVProgressHUD showErrorWithStatus:[error description]];
            }
        } onQueue:dispatch_get_main_queue()];
    }];
    
    
    UIButton *registerBtn = [Utility getButtonWithFontSize:20 text:@"注 册" textColor:[UIColor whiteColor] bgColor:MY_GRAY_COLOR bgImg:nil layerCorner:5 layerBoardWidth:0 layerBoardColor:nil btnRect:CGRectMake(20, 300, SCREEN_WIDTH-40, 40)];
    [self.view addSubview:registerBtn];
    [[registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        RegisterViewController *vc = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *accountName = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccountName"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"];
    if (accountName!=nil) {
        accountTf.text = accountName;
        passwordTf.text = password;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [accountTf resignFirstResponder];
    [passwordTf resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
