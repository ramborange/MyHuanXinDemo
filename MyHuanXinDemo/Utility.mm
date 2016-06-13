//
//  Utility.m
//  微霾
//
//  Created by blueSky on 14-10-26.
//  Copyright (c) 2014年 BlueSky. All rights reserved.
//

#import "Utility.h"

#define CURR_LANG  ([[NSLocale preferredLanguages] objectAtIndex:0])

@implementation Utility

+ (NSString *)DPLocalizedString:(NSString *)translation_key {
    NSString * s = NSLocalizedString(translation_key, nil);
    if (![CURR_LANG isEqual:@"en"] && ![CURR_LANG isEqual:@"zh-Hans"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    return s;
}

+ (CGSize)getLabelSizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize TextString:(NSString *)str{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//创建一个Button
+ (UIButton *)getButtonWithFontSize:(NSInteger)fontsize text:(NSString *)btnText textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor bgImg:(UIImage *)bgImg layerCorner:(NSInteger)layerCorner layerBoardWidth:(CGFloat)width layerBoardColor:(UIColor *)layerBoardColor btnRect:(CGRect)btnRect{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (fontsize) {
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    if (btnText!=nil) {
        [btn setTitle:btnText forState:UIControlStateNormal];
        [btn setTitleColor:textColor forState:UIControlStateNormal];
    }
    if (bgColor!=nil) {
        [btn setBackgroundColor:bgColor];
    }
    if (bgImg!=nil) {
        [btn setBackgroundImage:bgImg forState:UIControlStateNormal];
    }
    if (layerCorner) {
        btn.layer.cornerRadius = layerCorner;
        btn.layer.masksToBounds = YES;
    }
    if (width) {
        [btn.layer setBorderWidth:width];
        [btn.layer setBackgroundColor:layerBoardColor.CGColor];
    }
    btn.frame = btnRect;
    return btn;
}

//创建一个UITextFiled
+ (UITextField *)getTextFiledWithFrame:(CGRect)rect isSecurty:(BOOL)isSecurry placeholder:(NSString *)placeholder fontsize:(NSInteger)fontsize tintColor:(UIColor *)tintColor bground:(UIImage *)bground leftView:(UIView *)leftview rightView:(UIView *)rightView boardWith:(CGFloat)bWidth boardColor:(UIColor *)bColor cornerRadius:(CGFloat)radius {
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    textField.secureTextEntry = isSecurry;
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:fontsize];
    textField.tintColor = tintColor;
    textField.background = bground;
    textField.leftView = leftview;
    textField.rightView = rightView;
    if (bWidth) {
        textField.layer.borderWidth = bWidth;
        textField.layer.borderColor = bColor.CGColor;
    }
    if (radius) {
        textField.layer.cornerRadius = radius;
        textField.layer.masksToBounds = YES;
    }
    return textField;
}

//创建一个UIImageView
+ (UIImageView *)getImageViewWithFrame:(CGRect)rect img:(UIImage *)img cornerRadius:(CGFloat)radius {
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:rect];
    [imgview setImage:img];
    if (radius) {
        imgview.layer.cornerRadius = radius;
        imgview.layer.masksToBounds = YES;
    }
    return imgview;
}

//创建一个view
+ (UIView *)getViewWithFrame:(CGRect)rect bgColor:(UIColor *)bgColor boarderWidth:(CGFloat)width boardColor:(UIColor *)color cornerRadius:(CGFloat)radius {
    UIView *toReturnView = [[UIView alloc] initWithFrame:rect];
    toReturnView.backgroundColor = bgColor;
    if (width) {
        toReturnView.layer.borderWidth = width;
        toReturnView.layer.borderColor = color.CGColor;
    }
    if (radius) {
        toReturnView.layer.cornerRadius = radius;
        toReturnView.layer.masksToBounds = YES;
    }
    return toReturnView;
}

+ (NSString *)getDateStringWithTimeInternal:(long long)internal{
    NSDateFormatter *formatter;
    if (! formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    }
    NSString *dateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:internal/1000]];
    NSString *sysDateString = [formatter stringFromDate:[NSDate date]];
    NSArray *array1 = [dateString componentsSeparatedByString:@"-"];
    NSArray *array2 = [sysDateString componentsSeparatedByString:@"-"];
    if (![[array1 firstObject] isEqualToString:[array2 firstObject]]) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }else{
        if (![[array1 objectAtIndex:1] isEqualToString:[array2 objectAtIndex:1]]) {
            [formatter setDateFormat:@"MM-dd HH:mm"];
        }else{
            if (![[array1 objectAtIndex:2] isEqualToString:[array2 objectAtIndex:2]]) {
                int d1 = [[array1 objectAtIndex:2] intValue];
                int d2 = [[array2 objectAtIndex:2] intValue];
                int diff = d2-d1;
                if (diff==1) {
                    [formatter setDateFormat:@"昨天 HH:mm"];
                }else if (diff==2){
                    [formatter setDateFormat:@"前天 HH:mm"];
                }else{
                    [formatter setDateFormat:@"MM-dd HH:mm"];
                }
                
            }else{
                [formatter setDateFormat:@"今天 HH:mm"];
            }
        }
    }
    
    return  [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:internal/1000]];
}

//创建一个UILabel
+ (UILabel *)getLabelWith:(NSInteger)fontSize :(NSString *)title :(UIColor*)titleColor :(CGRect)lableRect :(NSInteger)lines{
    UILabel *lable = [[UILabel alloc] initWithFrame:lableRect];
    lable.font = [UIFont systemFontOfSize:fontSize];
    lable.text = title;
    lable.textColor = titleColor;
    lable.numberOfLines = lines;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.backgroundColor = [UIColor clearColor];
    return lable;
}

//剪切图片到正方形 运用CGImage
+(UIImage*)imageCrop:(UIImage*)original {
    UIImage *ret = nil;
    float originalWidth  = original.size.width;
    float originalHeight = original.size.height;
    
    float edge = fminf(originalWidth, originalHeight);
    
    float posX = (originalWidth   - edge) / 2.0f;
    float posY = (originalHeight  - edge) / 2.0f;
    
    CGRect cropSquare = CGRectMake(posX, posY,
                                   edge, edge);
    if(original.imageOrientation == UIImageOrientationLeft ||
       original.imageOrientation == UIImageOrientationRight) {
        cropSquare = CGRectMake(posY, posX,
                                edge, edge);
    } else {
        cropSquare = CGRectMake(posX, posY,
                                edge, edge);
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([original CGImage], cropSquare);
    ret = [UIImage imageWithCGImage:imageRef
                              scale:original.scale
                        orientation:original.imageOrientation];
    CGImageRelease(imageRef);
    return ret;
}

//绘制圆形图片
+(void)cirecleImg:(UIImageView *)imgv withImg:(UIImage *)img{
    UIGraphicsBeginImageContextWithOptions(imgv.bounds.size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:imgv.bounds
                                cornerRadius:imgv.bounds.size.width/2] addClip];
    [[Utility imageCrop:img] drawInRect:imgv.bounds];
    
    imgv.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

//获取设备ID
+(NSString *)generateUuidString {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    return uuidString;
}

//逆序输出一个数组
+(NSMutableArray *)getRevealArray:(NSMutableArray *)array{
    for (int i=0; i<=([array count]+1)/2-1; i++) {
        [array exchangeObjectAtIndex:i withObjectAtIndex:[array count]-i-1];
    }
    return array;
}

+(NSString * )getPathWithFileName:(NSString *)fileName
{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path =  [path stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];//链接路径加斜杠
    return path ;
}

+(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number{
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
}

//缓存
//获取缓存文件路径
+(NSString *)getCachesPath{
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    NSString *filePath = [cachesDir stringByAppendingPathComponent:@"/historyDataCaches"];
    
    return filePath;
}

///计算缓存文件的大小的M
+ (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (UIColor *)getColor:(NSString *)hexColor{
    NSString *string = [hexColor substringFromIndex:1];
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[string substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[string substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[string substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

+ (void)showAlertViewWithCancelString:(NSString*)cancelString title:(NSString *)titleString message:(NSString*)message otherBtn:(NSString*)other{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleString message:message delegate:nil cancelButtonTitle:cancelString otherButtonTitles:other,nil];
    [alert show];
}

+ (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

/*邮箱验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}


@end
