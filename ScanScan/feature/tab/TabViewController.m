//
//  TabViewController.m
//  ScanScan
//
//  Created by 李志华 on 2018/12/10.
//  Copyright © 2018 CoderApple. All rights reserved.
//

#import "TabViewController.h"

@interface TabViewController ()<UITabBarControllerDelegate>

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTabBar];
}

- (void)setupTabBar {
    UITabBar *tabBar = self.tabBar;
    self.delegate = self;
    NSArray *titles = @[@"扫描",@"生成",@"历史",@"设置"];
    NSArray *images = @[@"tab_11",@"tab_21",@"tab_31",@"tab_41"];
    NSArray *selectedImages = @[@"tab_1",@"tab_2",@"tab_3",@"tab_4"];
    [tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#555555"],NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:THEME_COLOR,NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateHighlighted];
        item.tag = idx;
        item.title = titles[idx];
        item.image = [[UIImage imageNamed:images[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:selectedImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
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
