//
//  ProtectFaliedCell.m
//  GouGou-Live
//
//  Created by ma c on 16/11/15.
//  Copyright © 2016年 LXq. All rights reserved.
//   维权失败cell

#import "ProtectFaliedCell.h"

#import "WaitPayAllNickView.h"
#import "SellerDogCardView.h"
#import "LogisticsInfoView.h"
#import "CostView.h"

#import "ProtectProwerTableModel.h"


@interface ProtectFaliedCell ()
/** 昵称View */
@property (strong,nonatomic) WaitPayAllNickView *nickView;
/** 横线 */
@property (strong,nonatomic) UIView *lineview1;
/** 狗狗卡片 */
@property (strong,nonatomic) SellerDogCardView *dogCardView;
/** 物流信息 */
@property (strong,nonatomic) LogisticsInfoView *logisticView;
/** 横线 */
@property (strong,nonatomic) UIView *lineview2;
/** 花费 */
@property (strong,nonatomic) CostView *costView;
/** 横线 */
@property (strong,nonatomic) UIView *lineview3;

@end

@implementation ProtectFaliedCell
#pragma mark - 模型
- (void)setProtectModel:(ProtectProwerTableModel *)protectModel {
    
    _protectModel = protectModel;
    // 名称
    self.nickView.model.merchantName = protectModel.name;
    self.nickView.model.status = protectModel.status;
    self.nickView.model.merchantImgl = protectModel.merchantImgl;
    // 狗狗卡片
    self.dogCardView.dogCardModel.sizeName = protectModel.sizeName;
    self.dogCardView.dogCardModel.colorName = protectModel.colorName;
    self.dogCardView.dogCardModel.ageName = protectModel.ageName;
    self.dogCardView.dogCardModel.name = protectModel.name;
    self.dogCardView.dogCardModel.pathSmall = protectModel.pathSmall;
    self.dogCardView.dogCardModel.priceOld = protectModel.priceOld;
    self.dogCardView.dogCardModel.price = protectModel.price;
    self.dogCardView.dogCardModel.kindName = protectModel.kindName;
    // 商品价格
    self.costView.costModel.productRealDeposit = protectModel.productPrice;
    self.costView.costModel.traficRealFee = protectModel.traficRealFee;
    self.costView.costModel.balance = protectModel.productRealBalance;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.nickView];
        [self.contentView addSubview:self.lineview1];
        [self.contentView addSubview:self.dogCardView];
        [self.contentView addSubview:self.logisticView];
        [self.contentView addSubview:self.lineview2];
        [self.contentView addSubview:self.costView];
        [self.contentView addSubview:self.lineview3];
        
    }
    return self;
}


#pragma mark
#pragma mark - 约束
- (void)layoutSubviews {
    
    [super layoutSubviews];
    __weak typeof(self) weakself = self;
    
    
    [_nickView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(weakself);
        make.height.equalTo(54);
        
    }];
    
    [_lineview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakself.nickView.bottom);
        make.left.right.equalTo(weakself);
        make.height.equalTo(1);
        
    }];
    
    [_dogCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakself.lineview1.bottom);
        make.left.right.equalTo(weakself);
        make.height.equalTo(110);
        
    }];

    
    [_logisticView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakself.dogCardView.bottom);
        make.left.right.equalTo(weakself);
        make.height.equalTo(88);
        
    }];
    
    [_lineview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakself.logisticView.bottom);
        make.left.right.equalTo(weakself);
        make.height.equalTo(1);
        
    }];
    
    [_costView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakself.lineview2.bottom);
        make.left.right.equalTo(weakself);
        make.height.equalTo(44);
    }];
    
    [_lineview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakself.costView.bottom);
        make.left.right.equalTo(weakself);
        make.height.equalTo(1);
        
    }];
    
}

#pragma mark
#pragma mark - 懒加载

- (WaitPayAllNickView *)nickView {
    
    if (!_nickView) {
        _nickView = [[WaitPayAllNickView alloc] init];
//        [_nickView setOrderState:@"维权成功"];
    }
    return _nickView;
}

- (UIView *)lineview1 {
    
    if (!_lineview1) {
        _lineview1 = [[UIView alloc] init];
        _lineview1.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    }
    return _lineview1;
}

- (SellerDogCardView *)dogCardView {
    
    if (!_dogCardView) {
        _dogCardView = [[SellerDogCardView alloc] init];
    }
    return _dogCardView;
}

- (UIView *)lineview2 {
    
    if (!_lineview2) {
        _lineview2 = [[UIView alloc] init];
        _lineview2.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    }
    return _lineview2;
}

- (LogisticsInfoView *)logisticView {
    
    if (!_logisticView) {
        _logisticView = [[LogisticsInfoView alloc] init];
    }
    return _logisticView;
}

- (UIView *)lineview3 {
    
    if (!_lineview3) {
        _lineview3 = [[UIView alloc] init];
        _lineview3.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    }
    return _lineview3;
}

- (CostView *)costView {
    
    if (!_costView) {
        _costView = [[CostView alloc] init];
//        [_costView costWithFreightPrice:@"￥50）" fontMoneyLabel:nil fontMoney:nil backMoneyLable:@"已付全款:" backMoney:@"￥1450"];
    }
    return _costView;
}

@end
