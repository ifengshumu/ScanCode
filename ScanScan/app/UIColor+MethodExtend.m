//
//  UIColor+MethodExtend.m
//  ZHUIKit
//
//  Created by zach on 2016/9/29.
//  Copyright © 2016年 leezhihua. All rights reserved.
//

#import "UIColor+MethodExtend.h"

@implementation UIColor (MethodExtend)
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    if (!hexString.length) {
        return nil;
    }
    NSDictionary *rgb = [self colorValueFromHexString:hexString];
    CGFloat red = [rgb[@"r"] floatValue];
    CGFloat green = [rgb[@"g"] floatValue];
    CGFloat blue = [rgb[@"b"] floatValue];
    CGFloat alpha = [rgb[@"a"] floatValue];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    if (!hexString.length) {
        return nil;
    }
    NSDictionary *rgb = [self colorValueFromHexString:hexString];
    CGFloat red = [rgb[@"r"] floatValue];
    CGFloat green = [rgb[@"g"] floatValue];
    CGFloat blue = [rgb[@"b"] floatValue];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (NSDictionary *)colorValueFromHexString:(NSString *)hexString {
    //去除空格
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //把开头截取
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    //6位或8位(带透明度)
    if ([cString length] < 6) {
        return nil;
    }
    //取出透明度、红、绿、蓝
    unsigned int a, r, g, b;
    NSRange range;
    range.location = 0;
    range.length = 2;
    if (cString.length == 8) {
        //a
        NSString *aString = [cString substringWithRange:range];
        //r
        range.location = 2;
        NSString *rString = [cString substringWithRange:range];
        //g
        range.location = 4;
        NSString *gString = [cString substringWithRange:range];
        //b
        range.location = 6;
        NSString *bString = [cString substringWithRange:range];
        
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return @{@"r":@(r / 255.0f), @"g":@(g / 255.0f), @"b":@(b / 255.0f), @"a":@(a / 255.0f)};
    } else {
        //r
        NSString *rString = [cString substringWithRange:range];
        //g
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        //b
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return @{@"r":@(r / 255.0f), @"g":@(g / 255.0f), @"b":@(b / 255.0f), @"a":@(1.0)};
    }
}

@end
