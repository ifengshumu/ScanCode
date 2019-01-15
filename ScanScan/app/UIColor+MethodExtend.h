//
//  UIColor+MethodExtend.h
//  ZHUIKit
//
//  Created by zach on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MethodExtend)
/**
 十六进制颜色值转UIColor，
 hexString除去开头的0X或#为6位或8位，
 hexStringt如果是6位则alpha=1，如果为8位则使用颜色值中的透明度
 
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 十六进制颜色值转UIColor，指定alpha
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end

