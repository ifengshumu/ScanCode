//
//  ZHDeviceTool.h
//  ZHDeviceTool
//
//  Created by Lee on 2016/8/22.
//  Copyright © 2016年 CoderApple All rights reserved.
//

#import <UIKit/UIKit.h>

/// Screen Size
#define SCREEN_SIZE                     UIScreen.mainScreen.bounds.size
/// 屏幕宽
#define SCREEN_WIDTH                    UIScreen.mainScreen.bounds.size.width
/// 屏幕高
#define SCREEN_HEIGHT                   UIScreen.mainScreen.bounds.size.height

@interface ZHAttachment : NSObject
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mineType;
@end

@interface ZHDeviceTool : NSObject
+ (instancetype)deviceTool;
/**
 设备唯一标识符
 */
+ (NSString *)UUID;

/**
 设备型号名字 eg:iPhone 7
 */
+ (NSString *)deviceModelName;

/**
 设备系统名字 eg:iOS 10.3.2
 */
+ (NSString *)deviceSystemVersion;
- (void)sendEmail:(NSString *)content subject:(NSString *)subject recipients:(NSArray<NSString *> *)recipients ccRecipients:(NSArray<NSString *> *)ccRecipients bccRecipients:(NSArray<NSString *> *)bccRecipients attachments:(NSArray<ZHAttachment *> *)attachments result:(void(^)(BOOL success, NSError *error))result;
@end
