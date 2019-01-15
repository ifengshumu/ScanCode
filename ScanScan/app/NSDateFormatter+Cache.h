//
//  NSDateFormatter+Cache.h
//  ZHKit
//
//  Created by Lee on 2016/6/8.
//  Copyright © 2016年 CoderApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Cache)
/// 默认的DateFormatter，yyyy-MM-dd
+ (NSDateFormatter *)defaultDateFormatter;
/// 指定日期格式的DateFormatter
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format;
@end

