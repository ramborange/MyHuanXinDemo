//
//  ChatViewController.m
//  MyHuanXinDemo
//
//  Created by ljf on 16/5/19.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatInputView.h"
#import "ChatTableViewCell.h"

@interface ChatViewController () <EMChatManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) ChatInputView *inputView;
@property (nonatomic, strong) EMConversation *converation;

@end

@implementation ChatViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = MY_CHAT_COLOR;
    self.navigationItem.title = self.name;
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50) style:UITableViewStylePlain];
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMyKeyboard)];
    [_tableview addGestureRecognizer:tap];
    
    _inputView = [[ChatInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    _inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_inputView];
    
    [[_inputView.sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([_inputView.textfield.text isEqualToString:@""]||_inputView.textfield.text==nil) {
            [SVProgressHUD showErrorWithStatus:@"不说话你还好意思发过去~"];
        }else {
            [self sendMessageWithMsg:_inputView.textfield.text];
        }
    }];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self reloadChatRecord];
        
}

- (void)dismissMyKeyboard {
    [_inputView.textfield resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        _inputView.frame = CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50);
    }];
}

#pragma mark - 发送消息
- (void)sendMessageWithMsg:(NSString *)msgText {
    EMChatText *chatText = [[EMChatText alloc] initWithText:msgText];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    
    //生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:self.name bodies:@[body]];
    message.messageType = eMessageTypeChat;
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:^(EMMessage *message, EMError *error) {
        
    } onQueue:dispatch_get_main_queue() completion:^(EMMessage *message, EMError *error) {
        [self reloadChatRecord];
    } onQueue:dispatch_get_main_queue()];
    
    _inputView.textfield.text = @"";
    [_inputView.textfield resignFirstResponder];
}

#pragma mark - recieve a message
- (void)didReceiveMessage:(EMMessage *)message {
    [self reloadChatRecord];
}

#pragma mark - 重新加载聊天数据
- (void)reloadChatRecord {
    _converation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.name conversationType:eConversationTypeChat];
    [_tableview reloadData];
    if (_converation.loadAllMessages.count) {
        [_tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_converation.loadAllMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - 滚动的时候隐藏键盘输入视图
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self dismissMyKeyboard];
}


#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _converation.loadAllMessages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMMessage *message = _converation.loadAllMessages[indexPath.row];
    EMTextMessageBody *body = [message.messageBodies lastObject];
    NSString *textString = body.text;
    CGFloat height = [self getHeightWithString:textString];
    if (indexPath.row==0) {
        return height+50;
    }else {
        //判断如果显示时间标签 则返回更大的高度
        EMMessage *lastMsg = _converation.loadAllMessages[indexPath.row-1];
        BOOL isHideTimeLabel = [self shouldShowTimeLabelWithTimeStamp1:lastMsg.timestamp timestamp2:message.timestamp];
        if (!isHideTimeLabel) {
            return height+60;
        }else {
            return height+30;
        }
    }
    return height+20;
}

//根据字符串获取高度
- (CGFloat)getHeightWithString:(NSString *)textString {
    CGFloat height = [textString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    return height;
}

//根据字符串获取宽度
- (CGFloat)getWidthWithString:(NSString *)textString {
    CGFloat width = [textString boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-100, [self getHeightWithString:textString]) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width;
    return width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellIdentifier";
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    EMMessage *message = _converation.loadAllMessages[indexPath.row];
    EMTextMessageBody *body = [message.messageBodies lastObject];
    CGFloat height = [self getHeightWithString:body.text];
    CGFloat width = [self getWidthWithString:body.text];
    if ([message.to isEqualToString:self.name]) {
        [cell isMyMsgCell];
        cell.myMsgLabel.text = body.text;
        if (height<20) {
            cell.myMsgLabel.frame = CGRectMake(SCREEN_WIDTH-50-width, 15, width, height);
            cell.myPaopaoView.frame = CGRectMake(SCREEN_WIDTH-50-width-10, 8, width+30, height+14);
        }else {
            cell.myMsgLabel.frame = CGRectMake(60, 15, SCREEN_WIDTH-100, height);
            cell.myPaopaoView.frame = CGRectMake(50, 8, SCREEN_WIDTH-80, height+14);
        }
        [cell resetPaoPaoViewWithiSMy:YES];
    }else {
        [cell isFriendMsgCell];
        cell.friendMsgLabel.text = body.text;
        if (height<20) {
            cell.friendMsgLabel.frame = CGRectMake(50, 15, width, height);
            cell.friendPaopaoView.frame = CGRectMake(40, 8, width+20, height+14);
        }else {
            cell.friendMsgLabel.frame = CGRectMake(50, 15, SCREEN_WIDTH-100, height);
            cell.friendPaopaoView.frame = CGRectMake(40, 8, SCREEN_WIDTH-90, height+14);
        }
        [cell resetPaoPaoViewWithiSMy:NO];
    }
    
    //时间标签的显示或隐藏 两条消息的时间差大于三分钟显示
    if (indexPath.row==0) {
        cell.timeLabel.hidden = NO;
        cell.timeLabel.frame = CGRectMake(0, height+30, SCREEN_WIDTH, 20);
        cell.timeLabel.text = [self getTimeWithTimeStamp:message.timestamp];
    }else {
        EMMessage *lastMsg = _converation.loadAllMessages[indexPath.row-1];
        BOOL isHideTimeLabel = [self shouldShowTimeLabelWithTimeStamp1:lastMsg.timestamp timestamp2:message.timestamp];
        cell.timeLabel.hidden = isHideTimeLabel;
        if (!isHideTimeLabel) {
            cell.timeLabel.frame = CGRectMake(0, height+30, SCREEN_WIDTH, 20);
            cell.timeLabel.text = [self getTimeWithTimeStamp:message.timestamp];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (BOOL)shouldShowTimeLabelWithTimeStamp1:(long long)time1 timestamp2:(long long)time2 {
    long diff = (time2-time1)/1000;
    //相差多少秒 大于180s 显示时间标签 返回NO
    if (diff>=180) {
        return NO;
    }
    return YES;
}

- (NSString *)getTimeWithTimeStamp:(long long)timeInternal {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInternal/1000];
    NSString *time = [f stringFromDate:date];
    return time;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppeared:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismissed:) name:UIKeyboardWillHideNotification object:nil];

}

#pragma mark - UIKeyboard notofication
- (void)keyboardAppeared:(NSNotification *)notification {
    NSDictionary *userInfoDic = notification.userInfo;
    CGPoint keyboardEndPoint = [[userInfoDic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
    [UIView animateWithDuration:0.35 animations:^{
        _inputView.frame = CGRectMake(0, keyboardEndPoint.y-50, SCREEN_WIDTH, 50);
    }];
    
}

- (void)keyboardDismissed:(NSNotification *)notification {
    [self dismissMyKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
