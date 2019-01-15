//
//  FeedViewController.m
//  ScanScan
//
//  Created by 李志华 on 2018/12/11.
//  Copyright © 2018 CoderApple. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITextView *tv;
@property (nonatomic, strong) UIImageView *insertImg;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"反馈建议";
    [self layout];
}
- (void)layout {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSuitHeight) style:UITableViewStylePlain];
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [self.view addSubview:tableView];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    tableView.tableHeaderView = header;
    
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH-30, 200)];
    self.tv = tv;
    tv.layer.borderWidth = 0.5;
    tv.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tv.layer.cornerRadius = 5;
    tv.font = [UIFont systemFontOfSize:18];
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入内容";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = [UIColor lightGrayColor];
    [placeHolderLabel sizeToFit];
    [tv addSubview:placeHolderLabel];
    [tv setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    [header addSubview:tv];
    
    UIView *bl = [[UIView alloc] initWithFrame:CGRectMake(0, tv.bottom+10, SCREEN_WIDTH, 20)];
    bl.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [header addSubview:bl];
    
    UILabel *z = [[UILabel alloc] initWithFrame:CGRectMake(15, bl.bottom, SCREEN_WIDTH, 45)];
    [z addUnderLine];
    z.text = @"附件";
    [header addSubview:z];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    CGFloat kw = 25;
    img.frame = CGRectMake(SCREEN_WIDTH-15-kw, (z.height-kw)/2.0, kw, kw);
    [z addSubview:img];
    
    UIImageView *imgs = [[UIImageView alloc] initWithFrame:CGRectMake(img.left-45-10, 0, 45, 45)];
    self.insertImg = imgs;
    [z addSubview:imgs];
    UITapGestureRecognizer *tapc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePic)];
    [z addGestureRecognizer:tapc];
    z.userInteractionEnabled = YES;
    
    UIView *bbl = [[UIView alloc] initWithFrame:CGRectMake(0, z.bottom, SCREEN_WIDTH, 20)];
    bbl.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [header addSubview:bbl];
    
    UILabel *e = [[UILabel alloc] initWithFrame:CGRectMake(15, bbl.bottom, SCREEN_WIDTH, 45)];
    [e addUnderLine];
    e.text = @"设备";
    [header addSubview:e];
    UILabel *s = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 45)];
    s.textAlignment = NSTextAlignmentRight;
    s.text = [ZHDeviceTool deviceModelName];
    [e addSubview:s];
    
    UILabel *ios = [[UILabel alloc] initWithFrame:CGRectMake(15, e.bottom, SCREEN_WIDTH, 45)];
    [ios addUnderLine];
    ios.text = @"系统";
    [header addSubview:ios];
    UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 45)];
    v.textAlignment = NSTextAlignmentRight;
    v.text = [ZHDeviceTool deviceSystemVersion];
    [ios addSubview:v];
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info valueForKey:@"CFBundleShortVersionString"];
    NSString *build = [info valueForKey:@"CFBundleVersion"];
    UILabel *b = [[UILabel alloc] initWithFrame:CGRectMake(15, ios.bottom, SCREEN_WIDTH, 45)];
    [b addUnderLine];
    b.text = @"APP版本";
    [header addSubview:b];
    UILabel *bv = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 45)];
    bv.textAlignment = NSTextAlignmentRight;
    bv.text = version;
    [b addSubview:bv];
    
    UILabel *bd = [[UILabel alloc] initWithFrame:CGRectMake(15, b.bottom, SCREEN_WIDTH, 45)];
    [bd addUnderLine];
    bd.text = @"APP Build";
    [header addSubview:bd];
    UILabel *bdv = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 45)];
    bdv.textAlignment = NSTextAlignmentRight;
    bdv.text = build;
    [bd addSubview:bdv];
    
    UIButton *send = [UIButton buttonWithType:UIButtonTypeCustom];
    send.frame = CGRectMake((SCREEN_WIDTH-160)/2.0, bd.bottom+20, 160, 50);
    send.layer.masksToBounds = YES;
    send.layer.cornerRadius = 25;
    send.backgroundColor = THEME_COLOR;
    [send setTitle:@"发送邮件" forState:UIControlStateNormal];
    [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendEamil) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:send];
    
    header.height = send.bottom+20;
}

- (void)sendEamil {
    if (!self.tv.text.length) {
        [AppConfig alterWithTitle:nil message:@"请输入内容" actions:nil handler:nil];
        return;
    }
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info valueForKey:@"CFBundleShortVersionString"];
    NSString *build = [info valueForKey:@"CFBundleVersion"];
    NSString *content = self.tv.text;
    content = [content stringByAppendingFormat:@"\n\n设备：%@\n系统：%@\nAPP版本：%@\nAPP Build：%@",[ZHDeviceTool deviceModelName],[ZHDeviceTool deviceSystemVersion],version,build];
    NSArray *att = nil;
    if (self.insertImg.image) {
        ZHAttachment *at = [[ZHAttachment alloc] init];
        at.data = UIImagePNGRepresentation(self.insertImg.image);
        at.name = @"file.png";
        at.mineType = @"png";
        att = @[at];
    }
    [[ZHDeviceTool deviceTool] sendEmail:content subject:@"反馈建议" recipients:@[@"lzh@cheok.com"] ccRecipients:nil bccRecipients:nil attachments:att result:^(BOOL success, NSError *error) {
        
    }];
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
    self.insertImg.image = image;
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
