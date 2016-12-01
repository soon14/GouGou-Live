//
//  WaitPayingViewController.m
//  GouGou-Live
//
//  Created by ma c on 16/11/11.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "WaitPayingViewController.h"  // 待支付控制器
#import "WaitBackMoneyCell.h"  // 待付尾款cell
#import "WaitFontMoneyCell.h"  // 待付定金cell
#import "WaitAllMoneyCell.h"   // 待付全款cell
#import "FunctionButtonView.h"  // cell下边按钮
#import "PayingAllMoneyViewController.h"  // 支付全款控制器
#import "NicknameView.h" // 商家昵称View
#import "BuyCenterModel.h"

static NSString * waitBackCell = @"waitBackCellID";
static NSString * waitFontCell = @"waitFontCellID";
static NSString * waitAllMoneyCell = @"waitAllMoneyCellID";

@interface WaitPayingViewController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (strong,nonatomic) UITableView *tableview;
/** 数据 */
@property (strong,nonatomic) NSArray *dataArray;

@end

@implementation WaitPayingViewController
#pragma mark - 网络请求
- (void)postGetAllStateOrderRequest {
//    @([[UserInfos sharedUser].ID integerValue]
    NSDictionary * dict = @{
                            @"user_id":@(11),
                            @"status":@(5),
                            @"page":@(1),
                            @"pageSize":@(2),
                            @"is_right":@(1)
                            };
    
    [self postRequestWithPath:API_List_order params:dict success:^(id successJson) {
        DLog(@"%@",successJson[@"data"][@"info"]);
        self.dataArray = [BuyCenterModel mj_objectArrayWithKeyValuesArray:successJson[@"data"][@"info"]];
    } error:^(NSError *error) {
        
        DLog(@"%@",error);
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self postGetAllStateOrderRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self setNavBarItem];
}

- (void)initUI {
    
    [self.view addSubview:self.tableview];
    
}
#pragma mark
#pragma mark - 初始化
- (NSArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (UITableView *)tableview {
    
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 88 - 64) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        // 注册cell
        [_tableview registerClass:[WaitBackMoneyCell class] forCellReuseIdentifier:waitBackCell];
        [_tableview registerClass:[WaitFontMoneyCell class] forCellReuseIdentifier:waitFontCell];
        [_tableview registerClass:[WaitAllMoneyCell class] forCellReuseIdentifier:waitAllMoneyCell];
    }
    return _tableview;
}

#pragma mark
#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 255;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    BuyCenterModel *model = self.dataArray[indexPath.row];
    
    if ([model.status integerValue] == 1) {
        // 代付款cell
        WaitAllMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:waitAllMoneyCell];
        cell.centerModel = model;
        FunctionButtonView * funcBtn = [[FunctionButtonView alloc] initWithFrame:CGRectMake(0, 210, SCREEN_WIDTH, 45) title:@[@"支付全款",@"联系买家"] buttonNum:2];
        
        funcBtn.difFuncBlock = ^(UIButton * button) {
            if ([button.titleLabel.text  isEqual:@"支付全款"]) {
                // 点击支付全乱
                [self clickPayAllMoney];
                
                DLog(@"%@--%@",self,button.titleLabel.text);
                
                //                // 待付全款控制器
                //                PayingAllMoneyViewController * payAllVC = [[PayingAllMoneyViewController alloc] init];
                //
                //                [self.navigationController pushViewController:payAllVC animated:YES];
            } else if ([button.titleLabel.text isEqual:@"联系卖家"]) {
                // 跳转至联系卖家
                SingleChatViewController *viewController = [[SingleChatViewController alloc] initWithConversationChatter:EaseTest_Chat3 conversationType:(EMConversationTypeChat)];
                viewController.title = EaseTest_Chat3;
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:YES];
                DLog(@"%@--%@",self,button.titleLabel.text);
                
            }
            
        };
        
        [cell.contentView addSubview:funcBtn];
        
        return cell;

    }
    
    if ([model.status integerValue] == 2) {
        
        WaitFontMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:waitFontCell];
        cell.centerModel = model;
        FunctionButtonView * funcBtn = [[FunctionButtonView alloc] initWithFrame:CGRectMake(0, 210, SCREEN_WIDTH, 45) title:@[@"支付定金",@"取消订单",@"联系买家"] buttonNum:3];
        
        funcBtn.difFuncBlock = ^(UIButton * button) {
            if ([button.titleLabel.text  isEqual:@"取消订单"]) {
                // 点击取消订单
                [self clickCancleOrder];
                
                DLog(@"%@--%@",self,button.titleLabel.text);
                
            } else if ([button.titleLabel.text  isEqual:@"支付定金"]){
                // 点击支付定金
                [self clickPayFontMoney];
                
                DLog(@"%@--%@",self,button.titleLabel.text);
                
                
            } else if ([button.titleLabel.text isEqual:@"联系卖家"]) {
                
                DLog(@"%@--%@",self,button.titleLabel.text);
            }
            
        };
        
        [cell.contentView addSubview:funcBtn];
        
        return cell;
    }
    if ([model.status integerValue] == 3) {
        
        WaitBackMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:waitBackCell];
        cell.centerModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        FunctionButtonView * funcBtn = [[FunctionButtonView alloc] initWithFrame:CGRectMake(0, 210, SCREEN_WIDTH, 45) title:@[@"支付尾款",@"不想买了",@"联系买家",@"申请维权"] buttonNum:4];
        
        funcBtn.difFuncBlock = ^(UIButton * button) {
            if ([button.titleLabel.text  isEqual:@"申请维权"]) {
                // 点击申请维权
                [self clickApplyProtectPower];
                
                DLog(@"%@--%@",self,button.titleLabel.text);
                
            } else if ([button.titleLabel.text  isEqual:@"支付尾款"]){
                // 点击支付尾款
                [self clickPayBackMoney];
                
                DLog(@"%@--%@",self,button.titleLabel.text);
                
            } else if ([button.titleLabel.text isEqual:@"不想买了"]) {
                // 点击不想买了
                [self clickNotBuy];
                
                DLog(@"%@--%@",self,button.titleLabel.text);
                
            } else if ([button.titleLabel.text isEqual:@"联系卖家"]) {
                
                DLog(@"%@--%@",self,button.titleLabel.text);
            }
            
        };
        
        [cell.contentView addSubview:funcBtn];
        
        return cell;
  
    }
//    else if (indexPath.row == 2) {
//        
//        WaitAllMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:waitAllMoneyCell];
//        
//        FunctionButtonView * funcBtn = [[FunctionButtonView alloc] initWithFrame:CGRectMake(0, 210, SCREEN_WIDTH, 45) title:@[@"支付全款",@"联系买家"] buttonNum:2];
//        
//        funcBtn.difFuncBlock = ^(UIButton * button) {
//            if ([button.titleLabel.text  isEqual:@"支付全款"]) {
//                // 点击支付全乱
//                [self clickPayAllMoney];
//                
//                DLog(@"%@--%@",self,button.titleLabel.text);
//                
//                //                // 待付全款控制器
//                //                PayingAllMoneyViewController * payAllVC = [[PayingAllMoneyViewController alloc] init];
//                //
//                //                [self.navigationController pushViewController:payAllVC animated:YES];
//            } else if ([button.titleLabel.text isEqual:@"联系卖家"]) {
//                // 跳转至联系卖家
//                SingleChatViewController *viewController = [[SingleChatViewController alloc] initWithConversationChatter:EaseTest_Chat3 conversationType:(EMConversationTypeChat)];
//                viewController.title = EaseTest_Chat3;
//                viewController.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:viewController animated:YES];
//                DLog(@"%@--%@",self,button.titleLabel.text);
//                
//            }
//            
//        };
//        
//        [cell.contentView addSubview:funcBtn];
//        
//        return cell;
//    }
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
