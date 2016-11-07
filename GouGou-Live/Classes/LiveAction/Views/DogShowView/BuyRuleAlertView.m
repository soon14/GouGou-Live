//
//  BuyRuleAlertView.m
//  GouGou-Live
//
//  Created by ma c on 16/11/3.
//  Copyright © 2016年 LXq. All rights reserved.
//
#define LabelFont 12

#import "BuyRuleAlertView.h"

@interface BuyRuleAlertView ()
/** 蒙版 */
@property (strong, nonatomic) UIControl *overLayer;

@property(nonatomic, strong) UILabel *ruleLabel; /**< 交易规则 */

@property(nonatomic, strong) UILabel *ruleContent; /**< 规则内容 */

@property(nonatomic, strong) UILabel *ruleAlertLabel; /**< 规则提示 */


@property(nonatomic, strong) UILabel *line; /**< 线 */

@property(nonatomic, strong) UIButton *cancelBtn; /**< 取消按钮 */

@property(nonatomic, strong) UIButton *sureBtn; /**< 确定按钮 */

@end

@implementation BuyRuleAlertView
#pragma mark
#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.ruleLabel];
        [self addSubview:self.ruleContent];
        [self addSubview:self.ruleAlertLabel];
        [self addSubview:self.line];
        [self addSubview:self.sureBtn];
        [self addSubview:self.cancelBtn];
    }
    return self;
}

#pragma mark
#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.ruleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top).offset(10);
        make.centerX.equalTo(self.centerX);
    }];
    
    [self.cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.bottom.equalTo(self.bottom);
        make.size.equalTo(CGSizeMake(SCREEN_WIDTH / 2, 50));
    }];
    [self.sureBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right);
        make.bottom.equalTo(self.bottom);
        make.size.equalTo(CGSizeMake(SCREEN_WIDTH / 2, 50));
    }];
    [self.line makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left);
        make.right.equalTo(self.right);
        make.bottom.equalTo(self.cancelBtn.top);
        make.height.equalTo(1);
    }];
    DLog(@"%@", self.line);
    [self.ruleAlertLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.bottom.equalTo(self.line.top).offset(-10);
    }];
    
    [self.ruleContent makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left).offset(10);
        make.top.equalTo(self.ruleLabel.bottom).offset(10);
        make.right.equalTo(self.right).offset(-10);
        make.bottom.equalTo(self.ruleAlertLabel.top).offset(-5);
    }];
}

#pragma mark
#pragma mark - 懒加载

- (UILabel *)ruleLabel {
    if (!_ruleLabel) {
        _ruleLabel = [[UILabel alloc] init];
        _ruleLabel.text = @"交易规则";
        _ruleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        _ruleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _ruleLabel;
}
- (UILabel *)ruleContent {
    if (!_ruleContent) {
        _ruleContent = [[UILabel alloc] init];
        _ruleContent.text = @"交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则交易规则";
        _ruleContent.textColor = [UIColor colorWithHexString:@"#666666"];
        _ruleContent.font = [UIFont systemFontOfSize:LabelFont];
        _ruleContent.numberOfLines = 0;
        // 首行
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        CGFloat emptylen = LabelFont * 2;
        paragraph.firstLineHeadIndent = emptylen;

        _ruleContent.attributedText = [[NSAttributedString alloc] initWithString:_ruleContent.text attributes:@{
                                                    NSParagraphStyleAttributeName:paragraph                                                       }];
        ;
    }
    return _ruleContent;
}
- (UILabel *)ruleAlertLabel {
    if (!_ruleAlertLabel) {
        _ruleAlertLabel = [[UILabel alloc] init];
        _ruleAlertLabel.text = @"线上支付，可享受30天保障";
        _ruleAlertLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _ruleAlertLabel.font = [UIFont systemFontOfSize:LabelFont];
    }
    return _ruleAlertLabel;
}
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    }
    return _line;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:(UIControlStateNormal)];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchDown)];
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        _sureBtn.backgroundColor = [UIColor colorWithHexString:@"#99CC33"];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:(UIControlStateNormal)];
        [_sureBtn addTarget:self action:@selector(clickSureBtnAction) forControlEvents:(UIControlEventTouchDown)];
    }
    return _sureBtn;
}
- (void)clickSureBtnAction {
    if (_sureBlock) {
        _sureBlock();
        [self dismiss];
    }
}

#pragma mark
#pragma mark - 蒙版弹出效果
- (UIControl *)overLayer {
    // 懒加载 蒙版
    if (!_overLayer) {
        _overLayer = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _overLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [_overLayer addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _overLayer;
}
- (void)show {
    //获取主window
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    //载入蒙版
    [keyWindow addSubview:self.overLayer];
    //载入alertView
    [keyWindow addSubview:self];
    
#pragma mark
#pragma mark - 设置当前view的frame
    
    CGRect rect = self.frame;
    rect = CGRectMake(0, SCREEN_HEIGHT - 264, SCREEN_WIDTH, 264);
    self.frame = rect;
    
    // 约束
//    [self setUP];
    
    //渐入动画
    [self fadeIn];
    
}
- (void)dismiss {
    //返回时调用
    [self fadeOut];
}
- (void)fadeIn {
    self.transform = CGAffineTransformMakeScale(0.3, 0.3);
    
    self.overLayer.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.overLayer.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    }];
}
- (void)fadeOut {
    [UIView animateWithDuration:0.3 animations:^{
        self.overLayer.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.3, 0.3);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [self.overLayer removeFromSuperview];
    }];
}

@end