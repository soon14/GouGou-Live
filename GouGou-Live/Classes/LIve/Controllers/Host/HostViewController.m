//
//  HostViewController.m
//  狗狗直播框架
//
//  Created by ma c on 16/10/23.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "HostViewController.h"
#import "DogPictureCollectionViewCell.h"
#import "DogTypesView.h"
#import "NoneNetWorkingView.h"

#import "LivingViewController.h"
#import "PlayBackViewController.h"

#import "MoreImpressViewController.h"

#import "DogTypesViewController.h"
#import "HostLiveModel.h"
#import "LiveListDogInfoModel.h"
#import "MoreImpressionModel.h"

static NSString * identifer = @"DogPictureCellID";
static NSString * reuseIdentifier = @"headerID";

@interface HostViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/** 正在直播的狗 */
@property (strong,nonatomic) UICollectionView *collection;
/** 顶部headerView */
@property (strong,nonatomic) DogTypesView *typesView;

/** 数据源 */
@property (strong,nonatomic) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *dogInfos; /**< 狗狗数据 */

@property(nonatomic, strong) NoneNetWorkingView *noneNetView; /**< 无网 */

@end

@implementation HostViewController
// 请求卡片
- (void)getRequestHostLive{
    NSDictionary *dict = @{
                           @"page":@(1),
                           @"pageSize":@(10)
                           };
    [self showHudInView:self.view hint:@"加载中"];
    [self getRequestWithPath:API_Look_like params:dict success:^(id successJson) {
        DLog(@"%@", successJson);
       
        [self.collection setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.dataArray removeAllObjects];
        [self.dogInfos removeAllObjects];
        /** 所有信息 */
        NSArray *liveArr = [HostLiveModel mj_objectArrayWithKeyValuesArray:successJson[@"data"][@"data"]];
        /** 直播信息 */
        NSMutableArray *liveMutableArr = [NSMutableArray array];
        /** 狗狗信息数组 */
        NSMutableArray *dogInfos = [NSMutableArray array];
        // 请求狗狗信息
        for (NSInteger i = 0; i < liveArr.count; i ++) {
            
            HostLiveModel *model = liveArr[i];
            NSDictionary *dict = @{
                                   @"live_id":model.liveId
                                   };
            DLog(@"%@",dict);
            
            [self getRequestWithPath:API_Live_list_product params:dict success:^(id successJson) {
                //                DLog(@"%@", successJson);
                if (successJson[@"data"]) {
                    [dogInfos addObject:[LiveListDogInfoModel mj_objectArrayWithKeyValuesArray:successJson[@"data"]]];
                }else{
                    [dogInfos addObject:@[]];
                }
                
                [liveMutableArr addObject:model];
                if (dogInfos.count == liveArr.count&&liveMutableArr.count == liveArr.count) {
                    [self hideHud];
                    self.dogInfos = dogInfos;
                    self.dataArray = liveMutableArr;
                    [self.collection reloadData];
                }
//                [self.collection reloadData];
            } error:^(NSError *error) {
                DLog(@"%@", error);
            }];
        }
//        [self.collection reloadData];
    } error:^(NSError *error) {
        DLog(@"%@", error);
    }];
}
// 印象
- (void)getRequestImpresion{
    NSDictionary *dict = @{
                           @"page":@(1),
                           @"pageSize":@(5)
                           };
    [self getRequestWithPath:API_Impression params:dict success:^(id successJson) {
        
        DLog(@"%@", successJson);
        NSArray *arr = [MoreImpressionModel mj_objectArrayWithKeyValuesArray:successJson[@"data"]];
        NSMutableArray *mutableArr = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i ++) {
            MoreImpressionModel *model = arr[i];
            [mutableArr addObject:model];
        }
        MoreImpressionModel *more = [[MoreImpressionModel alloc] init];
        more.name = @"更多印象";
        more.ID = @"0";
        [mutableArr addObject:more];
        self.typesView.impressionArr = mutableArr;

    } error:^(NSError *error) {
        DLog(@"%@", error);
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {

    self.view.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
    self.edgesForExtendedLayout = 0;
    [self addCollectionview];
    
    [self getRequestHostLive];
    [self getRequestImpresion];
    
    self.collection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getRequestHostLive];
        [self.collection.mj_header endRefreshing];
    }];
}

- (void)addCollectionview {
    
    [self.view addSubview:self.collection];
    [self.view addSubview:self.typesView];

    __weak typeof(self) weakself = self;
    
    [_typesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.view.top);
        make.left.right.equalTo(weakself.view);
        make.size.equalTo(CGSizeMake(SCREEN_WIDTH, 45));
    }];
    
    [_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.typesView.bottom).offset(10);
        make.left.right.equalTo(weakself.view);
        make.bottom.equalTo(weakself.view.bottom).offset(-110);
    }];
    
}
#pragma mark
#pragma mark - 懒加载
- (NoneNetWorkingView *)noneNetView {
    if (!_noneNetView) {
        _noneNetView = [[NoneNetWorkingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _noneNetView.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];    }
    return _noneNetView;
}
- (DogTypesView *)typesView {
    
    if (!_typesView) {
        
        _typesView = [[DogTypesView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _typesView.backgroundColor = [UIColor whiteColor];
        
        __weak typeof(self) weakSelf = self;
        _typesView.btnBlock = ^(MoreImpressionModel *model){
            DLog(@"%@", model);
            if ([model.name isEqualToString:@"更多印象"]) {

                MoreImpressViewController *moreImprsVc = [[MoreImpressViewController alloc] init];
                [weakSelf.navigationController pushViewController:moreImprsVc animated:YES];
            }else{

                DogTypesViewController *dogType = [[DogTypesViewController alloc] init];
                dogType.dogType = model;
                dogType.title = model.name;
                [weakSelf.navigationController pushViewController:dogType animated:YES];
            }
        };
    }
    return _typesView;
}

- (void)pushDogTypeVC:(NSString *)title {
    
    DogTypesViewController * typeVC = [[DogTypesViewController alloc] init];
    
    typeVC.title = title;
    typeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:typeVC animated:YES];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)dogInfos {
    if (!_dogInfos) {
        _dogInfos = [NSMutableArray array];
    }
    return _dogInfos;
}
- (UICollectionView *)collection {

    if (!_collection) {
        
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];

        //设置item的大小
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 2, 130);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        // 设置滚动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
//        // 设置头部区域大小
//        flowLayout.headerReferenceSize = CGSizeMake(0, 45);
        
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _collection.delegate  = self;
        _collection.dataSource = self;
        _collection.showsVerticalScrollIndicator = NO;
        
        _collection.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
        
        // 注册cell
        [_collection registerClass:[DogPictureCollectionViewCell class] forCellWithReuseIdentifier:identifer];
        
    }
    return _collection;
}

#pragma mark
#pragma mark - collection代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    DogPictureCollectionViewCell * dogpictureCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    dogpictureCell.model = self.dataArray[indexPath.row];
    
    dogpictureCell.backgroundColor = [UIColor whiteColor];
    
    return dogpictureCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *dogArr = self.dogInfos[indexPath.row];
    HostLiveModel *model = self.dataArray[indexPath.row];
            DLog(@"%@", model);
        if ([model.status isEqualToString:@"1"]) {
            LivingViewController *livingVC = [[LivingViewController alloc] init];
            livingVC.liveID = model.liveId;
            livingVC.liverId = model.userId;
            livingVC.liverIcon = model.userImgUrl;
            livingVC.liverName = model.userNickName;
            livingVC.doginfos = dogArr;
            livingVC.watchCount = model.viewNum;
            livingVC.chatRoomID = model.chatroom;
            livingVC.state = model.status;
            livingVC.isLandscape = NO;
            livingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:livingVC animated:YES];
        }
        if ([model.status isEqualToString:@"3"]) {
            PlayBackViewController *livingVC = [[PlayBackViewController alloc] init];
            livingVC.liveID = model.liveId;
            livingVC.liverId = model.userId;
            livingVC.liverIcon = model.userImgUrl;
            livingVC.liverName = model.userNickName;
            livingVC.doginfos = dogArr;
            livingVC.watchCount = model.viewNum;
            livingVC.chatRoomID = model.chatroom;
            livingVC.state = model.status;
            livingVC.isLandscape = NO;

            livingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:livingVC animated:YES];
        }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
