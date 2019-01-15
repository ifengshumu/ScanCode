//
//  NSDateFormatter+Cache.m
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 CoderApple. All rights reserved.
//

#import "NSDateFormatter+Cache.h"

@implementation NSDateFormatter (Cache)
+ (NSDateFormatter *)defaultDateFormatter {
    return [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
}
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format {
    NSMutableDictionary *threadDic = [[NSThread currentThread] threadDictionary];
    NSString *key = [@"NSDateFormatter_" stringByAppendingString:format];
    NSDateFormatter *dateFormatter = threadDic[key];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [dateFormatter setDateFormat:format];
        threadDic[key] = dateFormatter;
    }
    return dateFormatter;
}
@end
