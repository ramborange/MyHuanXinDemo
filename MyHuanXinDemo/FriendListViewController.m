//
//  FriendListViewController.m
//  MyHuanXinDemo
//
//  Created by ljf on 16/5/19.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import "FriendListViewController.h"
#import "ViewController.h"
#import "ChatViewController.h"
#import "AddFriendViewController.h"

@interface FriendListViewController () <UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate,EMChatManagerBuddyDelegate>
{
    UIRefreshControl *refreshC;
}
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) UITableView *tableview;

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"好友列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *loginOutBtn = [Utility getButtonWithFontSize:20 text:@"注销" textColor:[UIColor blueColor] bgColor:nil bgImg:nil layerCorner:0 layerBoardWidth:0 layerBoardColor:nil btnRect:CGRectMake(0, 0, 40, 40)];
    [[loginOutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:YES error:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:loginOutBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor clearColor];
    _tableview.tableFooterView = footView;
    [self.view addSubview:_tableview];
    
    refreshC = [[UIRefreshControl alloc] init];
    [[refreshC rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        [self rerefreshData];
    }];
    [_tableview addSubview:refreshC];
    
    _listArray = [NSMutableArray arrayWithCapacity:0];
   
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self rerefreshData];
}


- (void)rerefreshData {
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            [_listArray removeAllObjects];
            [_listArray addObjectsFromArray:buddyList];
            [_tableview reloadData];
            [refreshC endRefreshing];
        }
    } onQueue:dispatch_get_main_queue()];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    EMBuddy *buddy = _listArray[indexPath.row];
    cell.textLabel.text = buddy.username;
    
    return cell;
}

#pragma mark - EaseMob ChatManagerDelegate
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"收到来自%@的请求", username] message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction * acceptAction = [UIAlertAction actionWithTitle:@"好" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *  action) {
        EMError * error;
        // 同意好友请求的方法
        if ([[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error] && !error) {
            NSLog(@"发送同意成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
                    
                    if (!error) {
                        NSLog(@"获取成功 -- %@", buddyList);
                        
                        [_listArray removeAllObjects];
                        [_listArray addObjectsFromArray:buddyList];
                        [_tableview reloadData];
                    }
                } onQueue:dispatch_get_main_queue()];
            });
        }
    }];
    UIAlertAction * rejectAction = [UIAlertAction actionWithTitle:@"滚" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        EMError * error;
        // 拒绝好友请求的方法
        if ([[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"滚, 快滚!" error:&error] && !error) {
            NSLog(@"发送拒绝成功");
        }
    }];
    [alertController addAction:acceptAction];
    [alertController addAction:rejectAction];
    [self showDetailViewController:alertController sender:nil];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *vc = [[ChatViewController alloc] init];
    EMBuddy *buddy = _listArray[indexPath.row];
    vc.name = buddy.username;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//添加好友
- (void)addFriend {
    AddFriendViewController *vc = [[AddFriendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
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
