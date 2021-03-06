//
//  SellerShipTemplateView.m
//  GouGou-Live
//
//  Created by ma c on 16/11/20.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "SellerShipTemplateView.h"

@interface SellerShipTemplateView ()<UITableViewDataSource, UITableViewDelegate>
/** 蒙版 */
@property (strong, nonatomic) UIControl *overLayer;

/** 数据 */
//@property (strong, nonatomic) NSArray *dataPlist;

/** 上一个按钮 */
@property (strong, nonatomic) UIButton *lastBtn;

@property(nonatomic, strong) NSMutableArray *buttons; /**< 按钮数组 */

@property(nonatomic, assign) NSInteger lastIndex; /**< 上一个选中的按钮的位置 */


@property (nonatomic, strong) UITableViewCell *lastCell; /**< <#注释#> */

@end
static NSString *cellid = @"SellerShipTemplate";
@implementation SellerShipTemplateView
#pragma mark
#pragma mark - TableView 代理
- (void)setDetailPlist:(NSArray *)detailPlist {
    _detailPlist = detailPlist;
//    self.dataPlist = detailPlist;
    [self reloadData];
}
- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray  array];
    }
    return _buttons;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_detailPlist.count == 0) {
        return 1;
    }else{
        return self.detailPlist.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellid];
    }
    if (_detailPlist.count == 0) {
        cell.textLabel.text = @"暂无模板";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        UIImage *image = [UIImage imageNamed:@"椭圆-1"];
        [btn setImage:image forState:(UIControlStateNormal)];
        btn.frame = CGRectMake(10 , (44 - image.size.height) / 2, image.size.width, image.size.height);
        
        [btn setImage:[UIImage imageNamed:@"圆角-对勾"] forState:(UIControlStateSelected)];
        [btn addTarget:self action:@selector(choseTransformBtn:) forControlEvents:(UIControlEventTouchDown)];
        [self.buttons addObject:btn];
        [cell.contentView addSubview:btn];
        SellerShipTemplateModel *model = self.detailPlist[indexPath.row];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(image.size.width + 20, 0, 200, 44)];
        label.text = model.name;
        label.textColor = [UIColor colorWithHexString:@"#999999"];
        label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:label];
        NSString *cost = @"";
        if (model.type == 0) { //模板类型 0运费模版 1免运费 2按时计算
            cost = model.money;
        }else  if(model.type == 1) {
            cost = @"免运费";
        }else if(model.type == 2) {
            cost = @"按实结算";
        }
        cell.detailTextLabel.attributedText = [self getAttributeWith:cost];
        self.lastCell = cell;
    }
    return cell;

}
- (void)choseTransformBtn:(UIButton *)btn {
    
}

// 富文本
- (NSAttributedString *)getAttributeWith:(NSString *)string{
    NSAttributedString *attribut = [[NSAttributedString alloc] initWithString:string attributes:@{
                                                                                                  NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#000000"],
                                                                                                  NSFontAttributeName:[UIFont systemFontOfSize:16]
                                                                                                  }];
    return attribut;
}
#pragma mark 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 49;
}
#pragma mark 头尾
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        
        label.text = @"运费设置";
        label.textAlignment = NSTextAlignmentCenter;
        
        // 线
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
        [label addSubview:line];
        
        return label;
    }
    
    return nil;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
        NSString *title;
        if (self.detailPlist.count == 0) {
            title = @"您未添加运费模板";
        }else{
            title = @"确认";
        }
        [button setTitle:title forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:(UIControlStateNormal)];
        
        [button setBackgroundColor:[UIColor colorWithHexString:@"#99cc33"]];
        [button addTarget:self action:@selector(clickSureBtnAction) forControlEvents:(UIControlEventTouchDown)];
        
        return button;
    }
    
    return nil;
    
}
- (void)clickSureBtnAction {
    if (_sureBlock) {
        [self dismiss];
        _sureBlock(self.detailPlist[self.lastIndex]);
    }
}
#pragma mark 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIButton *btn = (UIButton *)self.buttons[indexPath.row];
    self.lastBtn.selected = NO;
    
    btn.selected = YES;
    self.lastBtn = btn;
    self.lastIndex = indexPath.row;
}

- (UIControl *)overLayer
{
    // 懒加载 蒙版
    if (!_overLayer) {
        _overLayer = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _overLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        //        [_overLayer addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _overLayer;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.dataSource = self;
        self.delegate = self;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.separatorColor = [UIColor colorWithHexString:@"#e0e0e0"];
        self.bounces = NO;
        
    }
    return self;
}
#pragma mark
#pragma mark - 弹出效果
- (void)show
{
    //获取主window
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    //载入蒙版
    [keyWindow addSubview:self.overLayer];
    //载入alertView
    [keyWindow addSubview:self];
    
    
    //根据overlayer设置alertView的中心点
    CGRect rect = self.frame;
    CGFloat height = 0;
    rect = CGRectMake(0, SCREEN_HEIGHT - ((self.detailPlist.count +1)* 44), SCREEN_WIDTH, ((self.detailPlist.count +1)* 44));
    self.frame = rect;
    //渐入动画
    [self fadeIn];
    
}
- (void)dismiss
{
    //返回时调用
    [self fadeOut];
}
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(0.3, 0.3);
    
    self.overLayer.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.overLayer.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    }];
}
- (void)fadeOut
{
    [UIView animateWithDuration:0.3 animations:^{
        self.overLayer.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.3, 0.3);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [self.overLayer removeFromSuperview];
    }];
}

@end
