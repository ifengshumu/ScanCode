//
//  ColorPickerController.m
///  ScanScan
//
//  Created by 李志华 on 2018/12/10.
//  Copyright © 2018 CoderApple. All rights reserved.
//
#define kColorText @[@"黑色",@"红色",@"橙色",@"黄色",@"绿色",@"青色",@"蓝色",@"紫色"]
#define kColorHex @[@"#000000",@"#FF0000",@"#FFA500",@"#FFFF00",@"#008000",@"#00FFFF",@"#0000FF",@"#800080"]

#import "ColorPickerController.h"

@interface ColorPickerController ()
@property (nonatomic,strong) NSMutableArray *btnArray;
@property (nonatomic, strong) UIButton *selectBtn;

@end

@implementation ColorPickerController
-(NSMutableArray *)btnArray {
    if (!_btnArray) {
        self.btnArray = [NSMutableArray new];
    }
    return _btnArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择颜色";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(chooseColorDone)];
    self.navigationItem.rightBarButtonItem = item;
    [self layout];
}
- (void)chooseColorDone {
    if (self.handleColor) {
        self.handleColor(self.colorName, self.colorHex);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) layout{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSuitHeight) style:UITableViewStylePlain];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [self.view addSubview:tableView];
    
    UIView *header = [[UIView alloc] init];
    header.frame =  CGRectMake(0, 0, SCREEN_WIDTH, 200);
    tableView.tableHeaderView = header;
    
    NSInteger cnt = 3;
    CGFloat space = 15;
    CGFloat w = (SCREEN_WIDTH-space*(cnt+1))/cnt;
    CGFloat h = 35;
    for (int i = 0; i < kColorText.count; i ++) {
        CGFloat x = (i % cnt)*(w+space)+space;
        CGFloat y = (i / cnt)*(h+space)+space;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(x, y, w , h);
        btn.tag = i+1000;
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#d8d8d8"].CGColor;
        btn.backgroundColor = [UIColor colorWithHexString:kColorHex[i]];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:kColorText[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
        [btn setImage:nil forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.width, 0, btn.imageView.width)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.width+15, 0, -btn.titleLabel.width-15)];
        [header addSubview:btn];
        [self.btnArray addObject:btn];
        if ([self.colorName isEqualToString:kColorText[i]]) {
            btn.selected = YES;
            self.selectBtn = btn;
        }
        if (i == kColorText.count-1) {
            header.height = btn.bottom+20;
        }
    }
}
- (void) selectButton:(UIButton *)button {
    if (self.selectBtn != button) {
        self.selectBtn.selected = NO;
        self.selectBtn = button;
    }
    self.selectBtn.selected = YES;
    
    NSString *name = button.titleLabel.text;
    self.colorName = name;
    self.colorHex = kColorHex[button.tag-1000];
}

@end
