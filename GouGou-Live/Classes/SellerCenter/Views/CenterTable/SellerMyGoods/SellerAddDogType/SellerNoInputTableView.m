//
//  SellerNoInputTableView.m
//  GouGou-Live
//
//  Created by ma c on 16/11/20.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "SellerNoInputTableView.h"
#import "SellerNoInputHotBtnView.h" // 热搜按钮

@interface SellerNoInputTableView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSMutableArray *historyDataArr; /**< 历史数据源 */

@property(nonatomic, assign) CGFloat hotViewHeight; /**< 热门搜索高度 */

@property(nonatomic, strong) NSArray *hotDataArr; /**< 热门 */

@end

static NSString *cellid = @"SellerNoInputcell";

@implementation SellerNoInputTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [[UIView alloc] init];
        self.showsVerticalScrollIndicator = NO;
        
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellid];
        
    }
    return self;
}
#pragma mark
#pragma mark - 懒加载
- (NSMutableArray *)historyDataArr {
    if (!_historyDataArr) {
        _historyDataArr = [NSMutableArray array];
        [_historyDataArr addObject:@"狗狗铺1"];
        [_historyDataArr addObject:@"狗狗铺2"];
        [_historyDataArr addObject:@"狗狗铺3"];
    }
    return _historyDataArr;
}
- (NSArray *)hotDataArr {
    if (!_hotDataArr) {
        _hotDataArr = [NSArray array];
        _hotDataArr = @[@"金毛1", @"金毛2", @"金毛3", @"金毛4", @"金毛5", @"金毛6", @"金毛7", @"金毛8", @"金毛9", @"金毛21", @"金毛12"];
    }
    return _hotDataArr;
}
#pragma mark
#pragma mark - TableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return self.historyDataArr.count;
    }
    return 0;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"SellerHotSearch"];
        cell.backgroundView = [[UIView alloc] init];
        cell.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
        
        SellerNoInputHotBtnView *hotView = [[SellerNoInputHotBtnView alloc] init];
        hotView.datalist = self.hotDataArr;
        CGFloat height = [hotView getViewHeight:self.hotDataArr];
        hotView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        self.hotViewHeight = height;
        [cell.contentView addSubview:hotView];
        return cell;
    }
    
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = [UIImage imageNamed:@"搜索icon-拷贝"];
        cell.textLabel.text = self.historyDataArr[indexPath.row];
        
        UIButton *deleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [deleBtn sizeToFit];
        [deleBtn setImage:[UIImage imageNamed:@"-单删除"] forState:(UIControlStateNormal)];
        [deleBtn addTarget:self action:@selector(deleHistorydata) forControlEvents:(UIControlEventTouchDown)];
        cell.accessoryView = deleBtn;
//        [cell.accessoryView addSubview:deleBtn];
        
        return cell;
    }
    return nil;
}
- (void)deleHistorydata {
    // 删除搜索历史
    DLog(@"删除搜索历史");
}
- (void)deleAllHistorydata {
    // 删除全部
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view.backgroundColor = [UIColor whiteColor];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 50)];
        label.text = @"热门搜索";
        label.textColor = [UIColor colorWithHexString:@"#ffa11a"];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.backgroundColor = [UIColor whiteColor];
        [view addSubview:label];
        return view;
    }
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 50)];
        label.text = @"热门搜索";
        label.textColor = [UIColor colorWithHexString:@"#ffa11a"];
        label.font = [UIFont boldSystemFontOfSize:16];
        [view addSubview:label];
        
        UIButton *deleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        UIImage *image = [UIImage imageNamed:@"删除"];
        [deleBtn setImage:image forState:(UIControlStateNormal)];
        [deleBtn addTarget:self action:@selector(deleAllHistorydata) forControlEvents:(UIControlEventTouchDown)];
        deleBtn.frame = CGRectMake(SCREEN_WIDTH - 10 - image.size.width , (50 - image.size.height) / 2, image.size.width, image.size.height);
        [view addSubview:deleBtn];

        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.hotViewHeight + 10;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 50;
    }
    if (section == 1) {
        if (self.historyDataArr.count == 0) {
            return 0;
        }
        return 50;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end