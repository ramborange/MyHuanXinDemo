//
//  Utility.h
//  微霾
//
//  Created by blueSky on 14-10-26.
//  Copyright (c) 2014年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

//获取一个label
+ (UILabel *)getLabelWith:(NSInteger)fontSize :(NSString *)title :(UIColor*)titleColor :(CGRect)lableRect :(NSInteger)lines;
//获取一个Button
+ (UIButton *)getButtonWithFontSize:(NSInteger)fontsize text:(NSString *)btnText textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor bgImg:(UIImage *)bgImg layerCorner:(NSInteger)layerCorner layerBoardWidth:(CGFloat)width layerBoardColor:(UIColor *)layerBoardColor btnRect:(CGRect)btnRect;
//获取一个UITextFiled
+ (UITextField *)getTextFiledWithFrame:(CGRect)rect isSecurty:(BOOL)isSecurry placeholder:(NSString *)placeholder fontsize:(NSInteger)fontsize tintColor:(UIColor *)tintColor bground:(UIImage *)bground leftView:(UIView *)leftview rightView:(UIView *)rightView boardWith:(CGFloat)bWidth boardColor:(UIColor *)bColor cornerRadius:(CGFloat)radius;
//获取一个UIImageView
+ (UIImageView *)getImageViewWithFrame:(CGRect)rect img:(UIImage *)img cornerRadius:(CGFloat)radius;
//获取一个简单的View
+ (UIView *)getViewWithFrame:(CGRect)rect bgColor:(UIColor *)bgColor boarderWidth:(CGFloat)width boardColor:(UIColor *)color cornerRadius:(CGFloat)radius;

+ (NSString *)DPLocalizedString:(NSString *)translation_key;

//剪切图片到正方形 运用CGImage
+(UIImage*)imageCrop:(UIImage*)original;
//绘制圆形图片
+(void)cirecleImg:(UIImageView *)imgv withImg:(UIImage *)img;
//判断是否是有效的邮箱格式
+(BOOL)isValidateEmail:(NSString *)email;
//判断是否是有效的手机号格式
+ (BOOL)isValidateMobile:(NSString *)mobile;

+(NSString * )getPathWithFileName:(NSString *)fileName;

+ (CGSize)getLabelSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize TextString:(NSString *)str;

+(NSMutableArray *)getRevealArray:(NSMutableArray *)array;

+(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number;

+(NSString *)getCachesPath;

+ (long long)fileSizeAtPath:(NSString*) filePath;

+ (UIColor *)getColor:(NSString *)hexColor;

+ (void)showAlertViewWithCancelString:(NSString*)cancelString title:(NSString *)titleString message:(NSString*)message otherBtn:(NSString*)other;

+ (void)setExtraCellLineHidden: (UITableView *)tableView;

+ (NSString *)getDateStringWithTimeInternal:(long long)internal;
@end
