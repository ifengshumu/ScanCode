//
//  AppConfig.m
//  AKCar
//
//  Created by zach on 2018/10/16.
//  Copyright © 2018年 zach. All rights reserved.
//

#import "AppConfig.h"
#import <Photos/Photos.h>

@interface AppConfig()

@end

@implementation AppConfig
+ (void)alterWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray *)actions handler:(void(^)(NSString *title))handler {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (NSString *title in actions) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            handler(title);
        }];
        [alter addAction:action];
    }
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
    if (!actions.count) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alter dismissViewControllerAnimated:YES completion:nil];
        });
    }
}
+ (void)requestPhotoLibraryWithAuthorizedResult:(void(^)(BOOL granted))result {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                result(YES);
            }else{
                result(NO);
            }
        }];
    } else if (authStatus == PHAuthorizationStatusAuthorized){
        result(YES);
    } else {
        result(NO);
    }
}

//状态栏适配
BOOL isIPhoneX() {
    if ([UIScreen mainScreen].bounds.size.height > 800) {
        return YES;
    }
    return NO;
}
CGFloat suitScreenHeight() {
    CGFloat h = UIScreen.mainScreen.bounds.size.height;
    return isIPhoneX() ? h-tabbarSpace() : h;
}
CGFloat tabbarSpace() {
    return isIPhoneX() ? 34 : 0;
}
CGFloat tabbarHeight() {
    return 49;
}
CGFloat statusHeight() {
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    return rectStatus.size.height;
}
CGFloat naviHeight() {
    return 44;
}
CGFloat topBarHeight() {
    return naviHeight()+statusHeight();
}
CGFloat suitHeight() {
    return kSuitScreenHeight-topBarHeight();
}

@end
