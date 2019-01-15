//
//  ZHDeviceTool.m
//  ZHDeviceTool
//
//  Created by Lee on 2016/8/22.
//  Copyright © 2016年 CoderApple All rights reserved.
//

#import "ZHDeviceTool.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <MessageUI/MessageUI.h>

@implementation ZHAttachment

@end


@interface ZHDeviceTool ()<MFMailComposeViewControllerDelegate>
@property (nonatomic, copy) void(^sendEmailResult)(BOOL success, NSError *error);

@end

@implementation ZHDeviceTool
+ (instancetype)deviceTool {
    static ZHDeviceTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[ZHDeviceTool alloc] init];
    });
    return tool;
}
+ (NSString *)UUID {
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"];
    if(uuid == nil) {
        uuid = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"UUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return uuid;
}

+ (NSString *)deviceModelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"] || [deviceString isEqualToString:@"iPhone5,4"])                  return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"] || [deviceString isEqualToString:@"iPhone6,2"])                  return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"] || [deviceString isEqualToString:@"iPhone9,3"])                  return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"] || [deviceString isEqualToString:@"iPhone9,4"])                  return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"] || [deviceString isEqualToString:@"iPhone10,4"])                 return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"] || [deviceString isEqualToString:@"iPhone10,5"])                 return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"])                 return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"] || [deviceString isEqualToString:@"iPhone11,6"])                 return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
 
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad4,4"]||[deviceString isEqualToString:@"iPad4,5"]||[deviceString isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"]||[deviceString isEqualToString:@"iPad4,8"]||[deviceString isEqualToString:@"iPad4,9"])  return @"iPad mini 3";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceString;
}

+ (NSString *)deviceSystemVersion {
    NSString *name = [[UIDevice currentDevice] systemName];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    return [NSString stringWithFormat:@"%@ %@", name, version];
}

- (void)sendEmail:(NSString *)content subject:(NSString *)subject recipients:(NSArray<NSString *> *)recipients ccRecipients:(NSArray<NSString *> *)ccRecipients bccRecipients:(NSArray<NSString *> *)bccRecipients attachments:(NSArray<ZHAttachment *> *)attachments result:(void(^)(BOOL success, NSError *error))result {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        mailVC.mailComposeDelegate = self;
        //收件人
        [mailVC setToRecipients:recipients];
        //抄送
        [mailVC setCcRecipients:ccRecipients];
        //密送
        [mailVC setBccRecipients:bccRecipients];
        //主题
        [mailVC setSubject:subject];
        //正文
        if (content.length) {
            BOOL html = [content containsString:@"<html>"];
            [mailVC setMessageBody:content isHTML:html];
        }
        //附件
        if (attachments.count) {
            for (ZHAttachment *attachment in attachments) {
                [mailVC addAttachmentData:attachment.data mimeType:attachment.mineType fileName:attachment.name];
            }
        }
        self.sendEmailResult = result;
        [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:mailVC animated:YES completion:nil];
    } else {
        NSLog(@"Warning:this client cannot send email!");
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:^{
        if (self.sendEmailResult) {
            __block NSError *err = nil;
            switch (result) {
                case MFMailComposeResultSent:
                    self.sendEmailResult(YES, nil);
                    break;
                case MFMailComposeResultFailed:
                    self.sendEmailResult(NO, error);
                    break;
                case MFMailComposeResultSaved:
                    err = [NSError errorWithDomain:@"Email Send Error-Saved" code:MFMailComposeResultSaved userInfo:nil];
                    self.sendEmailResult(NO, err);
                    break;
                case MFMailComposeResultCancelled:
                    err = [NSError errorWithDomain:@"Email Send Error-Cancelled" code:MFMailComposeResultCancelled userInfo:nil];
                    self.sendEmailResult(NO, err);
                    break;
                default:
                    break;
            }
        }
    }];
}

@end
