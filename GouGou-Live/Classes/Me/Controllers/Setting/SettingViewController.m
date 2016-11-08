//
//  SettingViewController.m
//  GouGou-Live
//
//  Created by ma c on 16/10/25.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "SettingViewController.h"

#import "ResetLoginPsdView.h"

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>

/** tableView*/
@property (strong, nonatomic) UITableView *tableView;

/** 数据源 */
@property (strong, nonatomic) NSArray *dataArr;

/** 控制器 */
@property (strong, nonatomic) NSArray *controllerNames;

@end

static NSString *cellid = @"SetcellId";

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self setNavBarItem];
}

- (void)initUI {
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 500) style:(UITableViewStylePlain)];
        
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@[@"账号安全", @"通知消息提醒"], @[@"关于我们"], @[@"意见反馈", @"清除缓存"]];
    }
    return _dataArr;
}
- (NSArray *)controllerNames {
    if (!_controllerNames) {
        _controllerNames = @[@[@"SecurityAccountViewController", @"MessagePushViewController"], @[@"AboutUsViewController"], @[@"SuggestViewController", @"RemoveCookieViewController"]];
    }
    return _controllerNames;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataArr[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellid];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = @"detailTextLabel";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellText = self.controllerNames[indexPath.section][indexPath.row];
    NSString *title = self.dataArr[indexPath.section][indexPath.row];
    
    UIViewController *VC = [[NSClassFromString(cellText) alloc] init];
    VC.title = title;
    [self.navigationController pushViewController:VC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (IBAction)clickLoginoutAction:(UIButton *)sender {
    
}

@end
