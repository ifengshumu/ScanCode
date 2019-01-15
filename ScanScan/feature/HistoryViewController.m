//
//  HistoryViewController.m
//  ScanScan
//
//  Created by 李志华 on 2018/12/10.
//  Copyright © 2018 CoderApple. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryDetailController.h"
@interface HistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *selectData;
@property (nonatomic, assign) BOOL isEditing;
@end

static NSString * const identifier = @"cell";
@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"历史";
    [self layoutTableView];
    self.selectData = [NSMutableArray arrayWithCapacity:0];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataSource = [[[NSUserDefaults standardUserDefaults] objectForKey:SCAN_OBJECT] mutableCopy];
    self.navigationItem.rightBarButtonItem.title = self.dataSource.count?@"编辑":nil;
    [self.tableView reloadData];
}

- (IBAction)editAction:(UIBarButtonItem *)sender {
    self.isEditing = !self.isEditing;
    self.tableView.editing = self.isEditing;
    if (self.isEditing) {
        sender.title = @"取消";
    } else {
        sender.title = @"编辑";
    }
    self.navigationItem.leftBarButtonItem.title = self.isEditing?@"删除":nil;
}
- (IBAction)deleteACtion:(UIBarButtonItem *)sender {
    if (self.selectData.count) {
        [self.dataSource removeObjectsInArray:self.selectData.copy];
        NSMutableArray *result = [[[NSUserDefaults standardUserDefaults] objectForKey:SCAN_OBJECT] mutableCopy];
        [result removeObjectsInArray:self.selectData.copy];
        [[NSUserDefaults standardUserDefaults] setObject:result forKey:SCAN_OBJECT];
        [self.tableView reloadData];
    } else {
        [AppConfig alterWithTitle:nil message:@"请先选择历史记录" actions:nil handler:nil];
    }
}

- (void)layoutTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSuitHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorColor = THEME_COLOR;
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 50;
    tableView.allowsMultipleSelectionDuringEditing = YES;
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    self.tableView = tableView;
    [self.view addSubview:tableView];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *content = self.dataSource[indexPath.row];
    NSArray *obj = [content componentsSeparatedByString:SCAN_TIME];
    cell.textLabel.text = obj[0];
    NSString *tt = obj[1];
    cell.detailTextLabel.text = [tt componentsSeparatedByString:SCAN_TYPE].firstObject;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditing) {
        NSString *content = self.dataSource[indexPath.row];
        [self.selectData addObject:content];
    } else {
        NSString *content = self.dataSource[indexPath.row];
        NSArray *obj = [content componentsSeparatedByString:SCAN_TIME];
        NSString *tt = obj[1];
        HistoryDetailController *hd = [[HistoryDetailController alloc] init];
        hd.content = obj[0];
        hd.time = [tt componentsSeparatedByString:SCAN_TYPE].firstObject;
        hd.type = [tt componentsSeparatedByString:SCAN_TYPE].lastObject.integerValue;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hd animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = self.dataSource[indexPath.row];
    [self.selectData removeObject:content];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


@end
