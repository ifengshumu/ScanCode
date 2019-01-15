//
//  HistoryDetailController.m
//  ScanScan
//
//  Created by 李志华 on 2018/12/10.
//  Copyright © 2018 CoderApple. All rights reserved.
//

#import "HistoryDetailController.h"
#import <Social/Social.h>

@interface HistoryDetailController ()
@property (nonatomic, strong) UIImage *codeImg;
@end

@implementation HistoryDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleDone target:self action:@selector(shareCode)];
    self.navigationItem.rightBarButtonItem = item;
    [self layout];
}
- (void)shareCode {
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:@[self.content,self.codeImg] applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}
- (void)copyResult {
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    pb.string = self.content;
    [AppConfig alterWithTitle:nil message:@"已复制到剪贴板" actions:nil handler:nil];
}

- (void)layout {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSuitHeight) style:UITableViewStylePlain];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [self.view addSubview:tableView];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    tableView.tableHeaderView = header;
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 30)];
    l.text = @"扫描结果：";
    [header addSubview:l];
    CGFloat h = [self.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-90, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    h = h < 45 ? 45 : h;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, l.bottom+5, SCREEN_WIDTH, h+10)];
    [header addSubview:v];
    UILabel *ll = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30-60, h)];
    ll.backgroundColor = [UIColor whiteColor];
    ll.text = self.content;
    ll.numberOfLines = 0;
    ll.font = [UIFont systemFontOfSize:15];
    [v addSubview:ll];
    
    UIButton *copy = [UIButton buttonWithType:UIButtonTypeCustom];
    copy.frame = CGRectMake(SCREEN_WIDTH-60-15, (v.height-35)/2.0, 60, 35);
    copy.layer.masksToBounds = YES;
    copy.layer.cornerRadius = 17.5;
    copy.backgroundColor = THEME_COLOR;
    [copy setTitle:@"复制" forState:UIControlStateNormal];
    [copy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [copy addTarget:self action:@selector(copyResult) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:copy];
    
    UIView *b = [[UIView alloc] initWithFrame:CGRectMake(0, v.bottom+10, SCREEN_WIDTH, 20)];
    b.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [header addSubview:b];
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(15, b.bottom+10, SCREEN_WIDTH, 30)];
    t.text = @"扫描时间：";
    [header addSubview:t];
    UILabel *tt = [[UILabel alloc] initWithFrame:CGRectMake(15, t.bottom, SCREEN_WIDTH, 30)];
    tt.text = self.time;
    [header addSubview:tt];
    
    UIView *bb = [[UIView alloc] initWithFrame:CGRectMake(0, tt.bottom+10, SCREEN_WIDTH, 20)];
    bb.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [header addSubview:bb];
    
    UILabel *m = [[UILabel alloc] initWithFrame:CGRectMake(15, bb.bottom+10, SCREEN_WIDTH, 30)];
    m.text = self.type == ZHBarScanTypeQRCode?@"二维码：":@"条形码:";
    [header addSubview:m];
    
    UIImage *img = nil;
    if (self.type == ZHBarScanTypeQRCode) {
        img = [ZHBarTool encodeQRCodeImageWithContent:self.content size:SCREEN_WIDTH-100];
    } else {
        img = [ZHBarTool encodeBarcodeImageWithContent:self.content size:CGSizeMake(SCREEN_WIDTH-100, 50)];
    }
    self.codeImg = img;
    UIImageView *iv = [[UIImageView alloc] initWithImage:img];
    iv.frame = CGRectMake(50, m.bottom, SCREEN_WIDTH-100, img.size.height);
    [header addSubview:iv];
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.frame = CGRectMake((SCREEN_WIDTH-160)/2.0, iv.bottom+20, 160, 50);
    save.layer.masksToBounds = YES;
    save.layer.cornerRadius = 25;
    save.backgroundColor = THEME_COLOR;
    [save setTitle:@"保存到相册" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:save];
    
    header.height = save.bottom+20;
}
- (void)saveAction {
    [AppConfig requestPhotoLibraryWithAuthorizedResult:^(BOOL granted) {
        if (granted) {
            UIImageWriteToSavedPhotosAlbum(self.codeImg, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = error?@"保存失败":@"保存成功";
    [AppConfig alterWithTitle:nil message:msg actions:nil handler:nil];
}
    
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
