//
//  FriendBubbleView.m
//  MyHuanXinDemo
//
//  Created by ljf on 16/5/20.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import "FriendBubbleView.h"

@implementation FriendBubbleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGSize size = self.bounds.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(context, MY_GRAY_COLOR.CGColor);
    
    /*画圆角矩形*/
    float fw = size.width;
    float fh = size.height;
    CGContextMoveToPoint(context, 15, 0);//开始坐标左边开始
    CGContextAddArcToPoint(context, 5, 0, 5, 10, 5);//左上角
    
    CGPoint p1 = CGPointMake(5, 12);
    CGPoint p2 = CGPointMake(0, 16);
    CGPoint p3 = CGPointMake(5, 20);
    
    CGContextAddLineToPoint(context, p1.x, p1.y);
    CGContextAddLineToPoint(context, p2.x, p2.y);
    CGContextAddLineToPoint(context, p3.x, p3.y);
    
    CGContextAddArcToPoint(context, 5, fh, 15, fh, 5);//左下角角度
    CGContextAddArcToPoint(context, fw, fh, fw, fh-10, 5);//右下角角度
    CGContextAddArcToPoint(context, fw, 0, fw-10, 0, 5);//右上角
   
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);//根据坐标绘制路径
    
    
}

@end
