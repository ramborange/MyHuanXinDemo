//
//  ChatTableViewCell.m
//  MyHuanXinDemo
//
//  Created by ljf on 16/5/20.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _myPaopaoView = [[MyBubbleView alloc] init];
        [self.contentView addSubview:_myPaopaoView];
        
        _friendPaopaoView = [[FriendBubbleView alloc] init];
        [self.contentView addSubview:_friendPaopaoView];
        
        _friendHeaderView = [Utility getImageViewWithFrame:CGRectMake(5, 10, 30, 30) img:[UIImage imageNamed:@"account"] cornerRadius:0];
        [self.contentView addSubview:_friendHeaderView];
        
        _friendMsgLabel = [Utility getLabelWith:16 :@"" :[UIColor blackColor] :CGRectMake(0, 0, 0, 0) :0];
        _friendMsgLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_friendMsgLabel];
        
        _myHeaderView = [Utility getImageViewWithFrame:CGRectMake(SCREEN_WIDTH-35, 10, 30, 30) img:[UIImage imageNamed:@"account"] cornerRadius:3];
        [self.contentView addSubview:_myHeaderView];
        
        _myMsgLabel = [Utility getLabelWith:16 :@"" :[UIColor blackColor] :CGRectMake(0, 0, 0, 0) :0];
        _myMsgLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_myMsgLabel];
        
        _timeLabel = [Utility getLabelWith:12 :@"" :[UIColor darkGrayColor] :CGRectMake(0, 0, 0, 0) :0];
        [self.contentView addSubview:_timeLabel];
    }
    self.backgroundColor = MY_CHAT_COLOR;
    return self;
}

- (void)resetPaoPaoViewWithiSMy:(BOOL)isMy {
    if (isMy) {
        [_myPaopaoView setNeedsDisplay];
    }else {
        [_friendPaopaoView setNeedsDisplay];
    }
}

- (void)isFriendMsgCell {
    _friendMsgLabel.hidden = NO;
    _friendHeaderView.hidden= NO;
    _myMsgLabel.hidden = YES;
    _myHeaderView.hidden = YES;
    _myPaopaoView.hidden = YES;
    _friendPaopaoView.hidden = NO;
}

- (void)isMyMsgCell {
    _friendMsgLabel.hidden = YES;
    _friendHeaderView.hidden= YES;
    _myMsgLabel.hidden = NO;
    _myHeaderView.hidden = NO;
    _myPaopaoView.hidden = NO;
    _friendPaopaoView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
