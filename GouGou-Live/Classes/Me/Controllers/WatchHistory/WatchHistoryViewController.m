//
//  WatchHistoryViewController.m
//  GouGou-Live
//
//  Created by ma c on 16/10/25.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "WatchHistoryViewController.h"
#import "WatchHistoryCell.h"
#import "FavoriteLivePlayerVc.h"
#import "PlayBackModel.h"
#import "NoneDateView.h"

static NSString * watchCell = @"watchCellID";
@interface WatchHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableview */
@property (strong,nonatomic) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArr; /**< 数据源 */

@property (nonatomic, strong) NoneDateView *noneDateView; /**< 没有数据 */

@end

@implementation WatchHistoryViewController
- (void)getRequestWatchHiostory {
    NSDictionary *dict = @{
                           @"user_id":[UserInfos sharedUser].ID,
                           @"page":@(1),
                           @"pageSize":@(10)
                           };
    [self showHudInView:self.view hint:@"加载..."];
    [self getRequestWithPath:API_List_view_history params:dict success:^(id successJson) {
        DLog(@"%@", successJson);
        if (successJson[@"data"]) {
            self.tableview.hidden = NO;
            self.noneDateView.hidden = YES;
            self.dataArr = [PlayBackModel mj_objectArrayWithKeyValuesArray:successJson[@"data"][@"data"]];
            [self.tableview reloadData];
        }else{
            self.tableview.hidden = YES;
            self.noneDateView.hidden = NO;
        }
        [self hideHud];
    } error:^(NSError *error) {
        DLog(@"%@", error);
    }];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initUI];
    
    [self setNavBarItem];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self getRequestWatchHiostory];
}
- (void)initUI {

    [self.view addSubview:self.tableview];
    [self.view addSubview:self.noneDateView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    self.title = @"观看历史";
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getRequestWatchHiostory];
        [self.tableview.mj_header endRefreshing];
    }];
}
- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
- (UITableView *)tableview {

    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableview registerClass:[WatchHistoryCell class] forCellReuseIdentifier:watchCell];
    }
    return _tableview;
}

#pragma mark
#pragma mark - 没有数据
- (NoneDateView *)noneDateView {
    if (!_noneDateView) {
        _noneDateView = [[NoneDateView alloc] initWithFrame:self.view.bounds];
        _noneDateView.noteStr = @"没有观看历史";
        _noneDateView.hidden = YES;
        _noneDateView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    }
    return _noneDateView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 273;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    WatchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:watchCell];
    PlayBackModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    cell.deleBlock = ^(UIButton *btn){
        if (btn.selected) {
            
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#99cc33"]];
            
        } else {
            [btn setBackgroundColor:[UIColor colorWithHexString:@"#ffffff"]];
        }
        NSDictionary *dict = @{
                               @"id":model.liveId
                               };
        DLog(@"%@", dict);
        [self getRequestWithPath:API_Del_view_history params:dict success:^(id successJson) {
            DLog(@"%@", successJson);
            [self showAlert:successJson[@"message"]];
            [self getRequestWatchHiostory];
        } error:^(NSError *error) {
            DLog(@"%@", error);
        }];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 回放界面
    
    FavoriteLivePlayerVc *playerVc = [[FavoriteLivePlayerVc alloc] init];
    PlayBackModel *model = self.dataArr[indexPath.row];

    playerVc.liveID = model.liveId;
    playerVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playerVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
