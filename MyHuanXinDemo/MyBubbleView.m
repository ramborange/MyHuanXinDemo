//
//  MyBubbleView.m
//  MyHuanXinDemo
//
//  Created by ljf on 16/5/20.
//  Copyright © 2016年 hanwang. All rights reserved.
//

#import "MyBubbleView.h"

@implementation MyBubbleView

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
    CGContextSetFillColorWithColor(context, MY_COLOR.CGColor);
    CGContextSetStrokeColorWithColor(context, MY_GRAY_COLOR.CGColor);
    
    /*画圆角矩形*/
    float fw = size.width;
    float fh = size.height;
    CGContextMoveToPoint(context, fw-25, 0);//开始坐标右边开始
    CGContextAddArcToPoint(context, fw-15, 0, fw-15, 10, 5);//右上角
    
    CGPoint p1 = CGPointMake(fw-15, 12);
    CGPoint p2 = CGPointMake(fw-10, 16);
    CGPoint p3 = CGPointMake(fw-15, 20);
    
    CGContextAddLineToPoint(context, p1.x, p1.y);
    CGContextAddLineToPoint(context, p2.x, p2.y);
    CGContextAddLineToPoint(context, p3.x, p3.y);
    
    CGContextAddArcToPoint(context, fw-15, fh, fw-25, fh, 5);//右下角角度
    CGContextAddArcToPoint(context, 0, fh, 0, fh-10, 5);//左下角角度
    CGContextAddArcToPoint(context, 0, 0, fw+10, 0, 5);//左上角
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);//根据坐标绘制路径
    
   
}




@end
