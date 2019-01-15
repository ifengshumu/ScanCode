//
//  CreateViewController.m
//  ScanScan
//
//  Created by 李志华 on 2018/12/10.
//  Copyright © 2018 CoderApple. All rights reserved.
//

#import "CreateViewController.h"
#import "ColorPickerController.h"

@interface CreateViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *tv;
@property (nonatomic, strong) UITextField *tfcc;
@property (nonatomic, strong) UITextField *tfcd;
@property (nonatomic, strong) UITextField *tfkd;
@property (nonatomic, strong) NSString *colorNameT;
@property (nonatomic, strong) NSString *colorHexT;
@property (nonatomic, strong) NSString *colorNameB;
@property (nonatomic, strong) NSString *colorHexB;
@property (nonatomic, strong) UILabel *tcLabel;
@property (nonatomic, strong) UILabel *bcLabel;
@property (nonatomic, strong) UIImageView *insertImg;
@property (nonatomic, assign) CGFloat insertCor;
@property (nonatomic, strong) UIImageView *qrcodeImg;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *shareBtn;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self layout];
}
- (IBAction)selectType:(UISegmentedControl *)sender {
    self.type = sender.selectedSegmentIndex;
    [self layout];
}

- (void)layout {
    if (!self.tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSuitHeight) style:UITableViewStylePlain];
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [tableView setTableFooterView:view];
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    self.tableView.tableHeaderView = header;
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 30)];
    l.text = @"输入内容（必填）：";
    [header addSubview:l];
    
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(15, l.bottom+5, SCREEN_WIDTH-30, 150)];
    self.tv = tv;
    tv.keyboardType = self.type==0?UIKeyboardTypeDefault:UIKeyboardTypeNumberPad;
    tv.layer.borderWidth = 0.5;
    tv.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tv.layer.cornerRadius = 5;
    tv.font = [UIFont systemFontOfSize:18];
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入定制内容";
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
    z.text = @"主题颜色：";
    [header addSubview:z];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    CGFloat kw = 25;
    img.frame = CGRectMake(SCREEN_WIDTH-15-kw, (z.height-kw)/2.0, kw, kw);
    [z addSubview:img];
    UILabel *zc = [[UILabel alloc] initWithFrame:CGRectMake(img.left-100, 0, 100, 45)];
    zc.textAlignment = NSTextAlignmentRight;
    [z addSubview:zc];
    self.tcLabel = zc;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseThemeColor)];
    [z addGestureRecognizer:tap];
    z.userInteractionEnabled = YES;
    
    CGFloat top = 0;
    if (self.type == 0) {
        UILabel *b = [[UILabel alloc] initWithFrame:CGRectMake(15, z.bottom, SCREEN_WIDTH, 45)];
        [b addUnderLine];
        b.text = @"背景颜色：";
        [header addSubview:b];
        UIImageView *imgb = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        imgb.frame = CGRectMake(SCREEN_WIDTH-15-kw, (b.height-kw)/2.0, kw, kw);
        [b addSubview:imgb];
        UILabel *bc = [[UILabel alloc] initWithFrame:CGRectMake(imgb.left-100, 0, 100, 45)];
        bc.textAlignment = NSTextAlignmentRight;
        [b addSubview:bc];
        self.bcLabel = bc;
        UITapGestureRecognizer *tapb = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseBackgroundColor)];
        [b addGestureRecognizer:tapb];
        b.userInteractionEnabled = YES;
        
        UILabel *cc = [[UILabel alloc] initWithFrame:CGRectMake(15, b.bottom, SCREEN_WIDTH, 45)];
        [cc addUnderLine];
        cc.font = [UIFont systemFontOfSize:17];
        cc.text = @"尺寸大小：";
        cc.userInteractionEnabled = YES;
        [header addSubview:cc];
        CGFloat w = [cc.text boundingRectWithSize:CGSizeMake(1000, 45) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width+15;
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(w, 0, SCREEN_WIDTH-w, 45)];
        self.tfcc = tf;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        [cc addSubview:tf];
        
        UIView *bbl = [[UIView alloc] initWithFrame:CGRectMake(0, cc.bottom, SCREEN_WIDTH, 20)];
        bbl.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [header addSubview:bbl];
        
        UILabel *c = [[UILabel alloc] initWithFrame:CGRectMake(15, bbl.bottom, SCREEN_WIDTH, 45)];
        [c addUnderLine];
        c.text = @"插入图片：";
        [header addSubview:c];
        UIImageView *imgc = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        imgc.frame = CGRectMake(SCREEN_WIDTH-15-kw, (b.height-kw)/2.0, kw, kw);
        [c addSubview:imgc];
        
        UIImageView *imgs = [[UIImageView alloc] initWithFrame:CGRectMake(imgc.left-45-10, 0, 45, 45)];
        self.insertImg = imgs;
        [c addSubview:imgs];
        UITapGestureRecognizer *tapc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseInsertPic)];
        [c addGestureRecognizer:tapc];
        c.userInteractionEnabled = YES;
        
        UILabel *y = [[UILabel alloc] initWithFrame:CGRectMake(15, c.bottom, SCREEN_WIDTH, 45)];
        [y addUnderLine];
        y.text = @"插入图片裁成圆形：";
        y.userInteractionEnabled = YES;
        [header addSubview:y];
        UISwitch *s = [[UISwitch alloc] init];
        CGSize size = s.size;
        s.frame = CGRectMake(SCREEN_WIDTH-30-size.width, (y.height-size.height)/2.0, 0, 0);
        [s addTarget:self action:@selector(insertPicCircle:) forControlEvents:UIControlEventValueChanged];
        [y addSubview:s];
        
        top = y.bottom;
    } else {
        UILabel *cd = [[UILabel alloc] initWithFrame:CGRectMake(15, z.bottom, SCREEN_WIDTH, 45)];
        [cd addUnderLine];
        cd.font = [UIFont systemFontOfSize:17];
        cd.text = @"长度：";
        cd.userInteractionEnabled = YES;
        [header addSubview:cd];
        CGFloat w = [cd.text boundingRectWithSize:CGSizeMake(1000, 45) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width+15;
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(w, 0, SCREEN_WIDTH-w, 45)];
        self.tfcd = tf;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        [cd addSubview:tf];
        
        UILabel *kd = [[UILabel alloc] initWithFrame:CGRectMake(15, cd.bottom, SCREEN_WIDTH, 45)];
        [kd addUnderLine];
        kd.font = [UIFont systemFontOfSize:17];
        kd.text = @"宽度：";
        kd.userInteractionEnabled = YES;
        [header addSubview:kd];
        UITextField *kdtf = [[UITextField alloc] initWithFrame:CGRectMake(w, 0, SCREEN_WIDTH-w, 45)];
        self.tfkd = tf;
        kdtf.keyboardType = UIKeyboardTypeNumberPad;
        [kd addSubview:kdtf];
        
        top = kd.bottom;
    }
    
    UIView *bbbl = [[UIView alloc] initWithFrame:CGRectMake(0, top, SCREEN_WIDTH, 20)];
    bbbl.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [header addSubview:bbbl];
    
    
    UILabel *e = [[UILabel alloc] initWithFrame:CGRectMake(15, bbbl.bottom, SCREEN_WIDTH, 45)];
    [e addUnderLine];
    e.text = self.type==0?@"二维码":@"条形码";
    [header addSubview:e];
    e.userInteractionEnabled = YES;
    
    UIButton *creat = [UIButton buttonWithType:UIButtonTypeCustom];
    creat.layer.masksToBounds = YES;
    creat.layer.cornerRadius = 15;
    creat.backgroundColor = THEME_COLOR;
    creat.titleLabel.font = [UIFont systemFontOfSize:15];
    [creat setTitle:[NSString stringWithFormat:@"生成%@",e.text] forState:UIControlStateNormal];
    [creat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [creat addTarget:self action:@selector(creatCodeImage) forControlEvents:UIControlEventTouchUpInside];
    CGFloat cw = [creat.titleLabel.text boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width+10;
    [creat setFrame:CGRectMake(SCREEN_WIDTH-cw-20, 7.5, cw, 30)];
    [e addSubview:creat];
    
    
    UIImageView *imge = [[UIImageView alloc] initWithFrame:CGRectMake(0, e.bottom+10, 1, 1)];
    self.qrcodeImg = imge;
    [header addSubview:imge];
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveBtn = save;
    save.layer.masksToBounds = YES;
    save.layer.cornerRadius = 25;
    save.backgroundColor = THEME_COLOR;
    [save setTitle:@"保存到相册" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [save addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:save];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn = share;
    share.layer.masksToBounds = YES;
    share.layer.cornerRadius = 25;
    share.backgroundColor = THEME_COLOR;
    [share setTitle:@"分享" forState:UIControlStateNormal];
    [share setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:share];
    
    header.height = imge.bottom+20;
}

- (void)chooseThemeColor {
    ColorPickerController *cp = [[ColorPickerController alloc] init];
    void (^handleColor)(NSString *colorName, NSString *colorHex) = ^(NSString *colorName, NSString *colorHex) {
        self.colorNameT = colorName;
        self.colorHexT = colorHex;
        self.tcLabel.text = colorName;
    };
    cp.colorName = self.colorNameT;
    cp.colorHex = self.colorHexT;
    cp.handleColor = handleColor;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cp animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)chooseBackgroundColor {
    ColorPickerController *cp = [[ColorPickerController alloc] init];
    void (^handleColor)(NSString *colorName, NSString *colorHex) = ^(NSString *colorName, NSString *colorHex) {
        self.colorNameB = colorName;
        self.colorHexB = colorHex;
        self.bcLabel.text = colorName;
    };
    cp.colorName = self.colorNameB;
    cp.colorHex = self.colorHexB;
    cp.handleColor = handleColor;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cp animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)chooseInsertPic {
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
- (void)insertPicCircle:(UISwitch *)sender {
    self.insertCor = sender.isOn?self.insertImg.image.size.width/2.0:0;
}

- (void)creatCodeImage {
    if (self.tv.text.length) {
        CGFloat x = 50;
        CGFloat w = SCREEN_WIDTH-x*2;
        CGFloat h = w;
        if (self.type == 0) {
            if (self.tfcc.text.length && self.tfcc.text.integerValue <= SCREEN_WIDTH) {
                w = self.tfcc.text.integerValue;
                h = w;
                x = (SCREEN_WIDTH-w)/2.0;
            }
        } else {
            if (self.tfcd.text.length && self.tfcd.text.integerValue <= SCREEN_WIDTH) {
                w = self.tfcd.text.integerValue;
                x = (SCREEN_WIDTH-w)/2.0;
            }
            if (self.tfkd.text.length) {
                h = self.tfkd.text.integerValue;
            } else {
                h = 50;
            }
        }
        self.qrcodeImg.left = x;
        self.qrcodeImg.size = CGSizeMake(w, h);
        self.saveBtn.frame = CGRectMake(50, self.qrcodeImg.bottom+20, (SCREEN_WIDTH-150)/2.0, 50);
        self.shareBtn.frame = CGRectMake(self.saveBtn.right+50, self.qrcodeImg.bottom+20, (SCREEN_WIDTH-150)/2.0, 50);
        self.tableView.tableHeaderView.height = self.saveBtn.bottom+20;
        [self.tableView reloadData];
        UIImage *img = nil;
        if (self.type == 0) {
            img = [ZHBarTool encodeQRCodeImageWithContent:self.tv.text size:self.qrcodeImg.width backgroundColor:[UIColor colorWithHexString:self.colorHexB] themeColor:[UIColor colorWithHexString:self.colorHexT] insetImage:self.insertImg.image imageCornerRadius:self.insertCor];
        } else {
            img = [ZHBarTool encodeBarcodeImageWithContent:self.tv.text size:CGSizeMake(w, h) color:[UIColor colorWithHexString:self.colorHexT]];
        }
        self.qrcodeImg.image = img;
    } else {
        [AppConfig alterWithTitle:nil message:@"请输入定制内容" actions:nil handler:nil];
    }
}

- (void)saveAction {
    [AppConfig requestPhotoLibraryWithAuthorizedResult:^(BOOL granted) {
        if (granted) {
            UIImageWriteToSavedPhotosAlbum(self.qrcodeImg.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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
- (void)shareAction {
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:@[self.tv.text,self.qrcodeImg.image] applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

@end
