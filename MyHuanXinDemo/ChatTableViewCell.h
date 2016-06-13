//
//  ChatTableViewCell.h
//  MyHuanXinDemo
//
//  Created by ljf on 16/5/20.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyBubbleView.h"
#import "FriendBubbleView.h"

@interface ChatTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *friendHeaderView;
@property (nonatomic, strong) UILabel *friendMsgLabel;
@property (nonatomic, strong) FriendBubbleView *friendPaopaoView;

@property (nonatomic, strong) UIImageView *myHeaderView;
@property (nonatomic, strong) UILabel *myMsgLabel;
@property (nonatomic, strong) MyBubbleView *myPaopaoView;

@property (nonatomic, strong) UILabel *timeLabel;

- (void)resetPaoPaoViewWithiSMy:(BOOL)isMy;
- (void)isFriendMsgCell;
- (void)isMyMsgCell;
@end
