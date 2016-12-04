//
//  LogisticsInfoView.m
//  GouGou-Live
//
//  Created by ma c on 16/11/10.
//  Copyright © 2016年 LXq. All rights reserved.
//  物流信息View

#import "LogisticsInfoView.h"

@interface LogisticsInfoView ()
/** 物流信息 */
@property (strong,nonatomic) UILabel *logisticInfoLabel;
/** 快递名 */
@property (strong,nonatomic) UILabel *expressNameLabe;
/** 快递编号 */
@property (strong,nonatomic) UILabel *numLabel;
/** 复制 */
@property (strong,nonatomic) UIButton *copyButton;

@end

@implementation LogisticsInfoView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.logisticInfoLabel];
        [self addSubview:self.expressNameLabe];
        [self addSubview:self.numLabel];
        [self addSubview:self.copyButton];
        
    }
    return self;
}
#pragma mark
#pragma mark - 约束
- (void)layoutSubviews {

    [super layoutSubviews];
    __weak typeof(self) weakself = self;

    [_logisticInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakself.left).offset(10);
        make.top.equalTo(weakself.top).offset(10);
        
    }];
    
    [_expressNameLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakself.left).offset(10);
        make.top.equalTo(weakself.logisticInfoLabel.bottom).offset(30);
    }];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakself.expressNameLabe.right).offset(10);
        make.centerY.equalTo(weakself.expressNameLabe.centerY);
        
    }];
    
    [_copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakself.left).offset(315);
        make.centerY.equalTo(weakself.expressNameLabe.centerY);
        make.size.equalTo(CGSizeMake(50, 25));
        
    }];
    
}

#pragma mark
#pragma mark - 懒加载
- (UILabel *)logisticInfoLabel {

    if (!_logisticInfoLabel) {
        _logisticInfoLabel = [[UILabel alloc] init];
        _logisticInfoLabel.text = @"物流信息";
        _logisticInfoLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _logisticInfoLabel.font = [UIFont systemFontOfSize:16];
        
    }
    return _logisticInfoLabel;
}

- (UILabel *)expressNameLabe {
    
    if (!_expressNameLabe) {
        _expressNameLabe = [[UILabel alloc] init];
        _expressNameLabe.text = @"狗狗快递";
        _expressNameLabe.textColor = [UIColor colorWithHexString:@"#666666"];
        _expressNameLabe.font = [UIFont systemFontOfSize:14];
        
    }
    return _expressNameLabe;
}
- (UILabel *)numLabel {
    
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"7281737272627";
        _numLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _numLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _numLabel;
}

- (UIButton *)copyButton {

    if (!_copyButton) {
        _copyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_copyButton setTitle:@"复制" forState:UIControlStateNormal];
        [_copyButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_copyButton setBackgroundColor:[UIColor colorWithHexString:@"#e0e0e0"]];
        
        _copyButton.layer.cornerRadius = 10;
        _copyButton.layer.masksToBounds = YES;
        _copyButton.layer.borderWidth = 1;
        _copyButton.layer.borderColor = [UIColor colorWithHexString:@"#b4b4b4"].CGColor;
        
        _copyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_copyButton addTarget:self action:@selector(clickCopyBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
        
    return _copyButton;
}

- (void)clickCopyBtn {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    
    NSString *string = self.numLabel.text;
    
    [pab setString:string];
    
    if (pab == nil) {
        DLog(@"%@",pab.string);
        
    }else
    {
        DLog(@"%@",pab.string);

    }

}

@end
