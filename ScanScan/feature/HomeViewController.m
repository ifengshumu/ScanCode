//
//  HomeViewController.m
//  ScanScan
//
//  Created by 李志华 on 2018/12/10.
//  Copyright © 2018 CoderApple. All rights reserved.
//

#import "HomeViewController.h"

#define kWidth SCREEN_WIDTH-100

@interface HomeViewController ()<ZHBarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"扫码";
    CGRect scanRect = CGRectMake(50, (SCREEN_HEIGHT-kWidth)/2.0, kWidth, kWidth);
    ZHBarSacnView *scanview = [[ZHBarSacnView alloc] initWithFrame:self.view.bounds scanRect:scanRect];
    scanview.cornerLineColor = THEME_COLOR;
    scanview.animatedLineColor = THEME_COLOR;
    [scanview setChoosePicture:^(UIButton *sender) {
        [self choosePic];
    }];
    [self.view addSubview:scanview];
    
    [ZHBarTool barTool].delegate = self;
    [[ZHBarTool barTool] startScanBarWithScanRect:scanRect scanType:ZHBarScanTypeAll layerView:scanview];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[ZHBarTool barTool] startScanning];
}
- (void)choosePic {
    [AppConfig requestPhotoLibraryWithAuthorizedResult:^(BOOL granted) {
        if (granted) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        } else {
            [AppConfig alterWithTitle:nil message:@"无相册权限，请到“设置”中开启相册权限" actions:@[@"取消",@"确定"] handler:^(NSString *title) {
                if ([title isEqualToString:@"确定"]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                    } else {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                }
            }];
        }
    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSString *content = [ZHBarTool decodeQRCodeImage:image];
    [self handleScanObject:content type:ZHBarScanTypeQRCode];
}

- (void)ZHBarAuthorizedCameraFailed {
    [AppConfig alterWithTitle:nil message:@"无相机权限，请到“设置”中开启相机权限" actions:@[@"取消",@"确定"] handler:^(NSString *title) {
        if ([title isEqualToString:@"确定"]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }
    }];
}
-(void)ZHBarDidScanBarGetObject:(NSString *)object barType:(ZHBarScanType)barType {
    [self handleScanObject:object type:barType];
}

- (void)handleScanObject:(NSString *)object type:(ZHBarScanType)type {
    [[ZHBarTool barTool] stopScanning];
    if ([object isKindOfClass:[NSString class]] && object.length) {
        if ([object containsString:@"://"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:object]];
            [[ZHBarTool barTool] startScanning];
        } else {
            [AppConfig alterWithTitle:@"扫描结果" message:object actions:@[@"确定"] handler:^(NSString *title) {
                [[ZHBarTool barTool] startScanning];
            }];
        }
        NSMutableArray *result = [[[NSUserDefaults standardUserDefaults] objectForKey:SCAN_OBJECT] mutableCopy];
        NSDateFormatter *format = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd HH:mm"];
        NSString *date = [format stringFromDate:[NSDate date]];
        NSString *content = [NSString stringWithFormat:@"%@scan_time=%@scan_type=%ld", object,date,type];
        if (result.count) {
            [result addObject:content];
        } else {
            result = [NSMutableArray arrayWithCapacity:0];
            [result addObject:content];
        }
        [[NSUserDefaults standardUserDefaults] setObject:result forKey:SCAN_OBJECT];
    } else {
        [AppConfig alterWithTitle:@"扫描失败" message:@"请检查所扫描的二维码或条形码" actions:@[@"确定"] handler:^(NSString *title) {
            [[ZHBarTool barTool] startScanning];
        }];
    }
}

@end
