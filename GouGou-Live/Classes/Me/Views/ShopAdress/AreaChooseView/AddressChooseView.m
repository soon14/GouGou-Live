//
//  AddressChooseView.m
//  GouGou-Live
//
//  Created by ma c on 16/11/4.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "AddressChooseView.h"
#import "MyShopProvinceModel.h"

@interface AddressChooseView ()<UIPickerViewDelegate,UIPickerViewDataSource>
/** 蒙版 */
@property (strong,nonatomic) UIControl *areaHUD;

@property(nonatomic, strong) UIView *backGroundView; /**< 背景View */
/** 取消按钮 */
@property (strong, nonatomic) UIButton *cancelBtn;
/** title */
@property (strong, nonatomic) UILabel *titleLabel;
/** 确认按钮 */
@property (strong, nonatomic) UIButton *sureBtn;

@property(nonatomic, strong) NSString *province; /**< 省 */
@property(nonatomic, strong) NSString *city; /**< 市 */
@property(nonatomic, strong) NSString *destic; /**< 县 */

@property(nonatomic, strong) NSMutableArray *provinceArr; /**< <#注释#> */
@property(nonatomic, strong) NSMutableArray *cityArr; /**< <#注释#> */
@property(nonatomic, strong) NSMutableArray *desticArr; /**< <#注释#> */
@end

@implementation AddressChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backGroundView];
        [self.backGroundView addSubview:self.cancelBtn];
        [self.backGroundView addSubview:self.titleLabel];
        [self.backGroundView addSubview:self.sureBtn];
        [self addSubview:self.areaPicker];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.backGroundView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.top);
        make.left.right.equalTo(self);
        make.height.equalTo(45);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backGroundView.center);
    }];
    
    [self.cancelBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.left.equalTo(self.backGroundView.left).offset(10);
    }];
    
    [self.sureBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.centerY);
        make.right.equalTo(self.backGroundView.right).offset(-10);
    }];
    
    [self.areaPicker makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backGroundView.bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
}
#pragma mark
#pragma mark - 懒加载
- (UIView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] init];
        _backGroundView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    }
    return _backGroundView;
}
- (UIPickerView *)areaPicker {
    if (!_areaPicker) {
        _areaPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _areaPicker.backgroundColor = [UIColor whiteColor];
        _areaPicker.delegate = self;
        _areaPicker.dataSource = self;
    }
    return _areaPicker;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"请选择区域";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _titleLabel;
    
}

- (UIButton *)sureBtn {
    
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_sureBtn sizeToFit];
        [_sureBtn setTintColor:[UIColor colorWithHexString:@"#ffa11a"]];
        [_sureBtn setTitle:@"确认" forState:(UIControlStateNormal)];
        [_sureBtn addTarget:self action:@selector(clickSureButtonAction) forControlEvents:(UIControlEventTouchDown)];
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_cancelBtn setTintColor:[UIColor colorWithHexString:@"#ffa11a"]];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelBtn addTarget:self action:@selector(clickCancelBtnAction) forControlEvents:(UIControlEventTouchDown)];
    }
    return _cancelBtn;
}
- (void)clickSureButtonAction {
    if (_areaBlock) {
        _areaBlock(self.province, self.city, self.destic);
        [self dismiss];
    }

}
- (void)setProvinceDataArr:(NSArray *)provinceDataArr {
    _provinceDataArr = provinceDataArr;
    [self.provinceArr addObjectsFromArray:provinceDataArr];
    [self.areaPicker reloadComponent:0];
}
- (void)setCityDataArr:(NSArray *)cityDataArr {
    _cityDataArr = cityDataArr;
    [self.cityArr addObjectsFromArray:cityDataArr];
    [self.areaPicker reloadComponent:1];
}
- (void)setDesticDataArr:(NSArray *)desticDataArr {
    _desticDataArr = desticDataArr;
    [self.desticArr addObjectsFromArray:desticDataArr];
    [self.areaPicker reloadComponent:2];
}
- (void)clickCancelBtnAction {

    [self fadeOut];
}
#pragma mark
#pragma mark - 级联代理方法
- (NSMutableArray *)provinceArr {
    if (!_provinceArr) {
        _provinceArr = [NSMutableArray array];
    }
    return _provinceArr;
}
- (NSMutableArray *)cityArr {
    if (!_cityArr) {
        _cityArr = [NSMutableArray array];
    }
    return _cityArr;
}
- (NSMutableArray *)desticArr {
    if (!_desticArr) {
        _desticArr = [NSMutableArray array];
    }
    return _desticArr;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    // 列数
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        // 获取第一列数据
        return self.provinceDataArr.count;
    }else if(component == 1){
        //第1列选中第几排
        return self.cityDataArr.count;
    }else if (component == 2){
        //第2列选中第几排
        return self.desticDataArr.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0) {
        // 获取第一列数据
        MyShopProvinceModel *model = self.provinceDataArr[row];
        return model.name;
    }else if(component == 1){
        //第1列选中第几排
        MyShopProvinceModel *model = self.cityDataArr[row];
        return model.name;
    }else if (component == 2){
        //第2列选中第几排
        MyShopProvinceModel *model = self.desticDataArr[row];
        return model.name;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    self.province = [self.provinceDataArr[row] name];
        self.city = [self.cityArr[0] name];
        self.destic = [self.desticArr[0] name];
    
    if (component == 0) {
        // 获取第一列数据
        MyShopProvinceModel *model = self.provinceDataArr[row];
        self.province = model.name;
        if (_firstBlock) {
            // 获得第二行数据
            [self.cityArr removeAllObjects];
           [self.cityArr addObjectsFromArray:_firstBlock(model)];
            
            // 刷新
            [self.areaPicker reloadComponent:1];
            [self.areaPicker selectRow:0 inComponent:1 animated:YES];
//            [self pickerView:self.areaPicker titleForRow:0 forComponent:1];

            // 县数据
            MyShopProvinceModel *cityModel = self.cityArr[0];
            if (_secondBlock) {
                // 获得第三行数据
                [self.desticArr removeAllObjects];
               [self.desticArr addObjectsFromArray:_secondBlock(cityModel)];
                // 刷新
                [self.areaPicker selectRow:0 inComponent:2 animated:YES];
                [self.areaPicker reloadComponent:2];

//                [self pickerView:self.areaPicker titleForRow:0 forComponent:2];
            }
        }

    }else if(component == 1){
        
        //第1列选中第几排
        NSInteger index = [self.areaPicker selectedRowInComponent:1];
        MyShopProvinceModel *model = self.cityDataArr[index];
        self.city = model.name;
        
        if (_secondBlock) {
            // 获得第三行数据
            [self.desticArr removeAllObjects];
            [self.desticArr addObjectsFromArray:_secondBlock(model)];
            // 刷新
            [self.areaPicker selectRow:0 inComponent:2 animated:YES];
            [self.areaPicker reloadComponent:2];

//            [self pickerView:self.areaPicker titleForRow:0 forComponent:2];
        }
    }else if (component == 2){
        //第2列选中第几排
        NSInteger index = [self.areaPicker selectedRowInComponent:2];
        MyShopProvinceModel *model = self.desticDataArr[index];
     
        self.destic = model.name;
    }
}


#pragma mark
#pragma mark - 蒙版弹出效果
- (UIControl *)areaHUD
{
    // 懒加载 蒙版
    if (!_areaHUD) {
        _areaHUD = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _areaHUD.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        //        [_overLayer addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _areaHUD;
}

- (void)show
{
    //获取主window
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    //载入蒙版
    [keyWindow addSubview:self.areaHUD];
    //载入alertView
    [keyWindow addSubview:self];
    
#pragma mark
#pragma mark - 设置当前view的frame
    
    CGRect rect = self.frame;
    rect = CGRectMake(0, SCREEN_HEIGHT - 264, SCREEN_WIDTH, 264);
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
    
    self.areaHUD.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.areaHUD.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    }];
}
- (void)fadeOut
{
    [UIView animateWithDuration:0.3 animations:^{
        self.areaHUD.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.3, 0.3);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [self.areaHUD removeFromSuperview];
    }];
}
- (void)test {
    //    if (component == 0) {
    //        [pickerView reloadComponent:1];
    //        [pickerView reloadComponent:2];
    //    }else if (component == 1){
    //        [pickerView reloadComponent:2];
    //    }
    //    NSInteger provinceIndex = [self.areaPicker selectedRowInComponent:0];
    //    MyShopProvinceModel *provinceModel = self.provinceDataArr[provinceIndex];
    //    self.province = provinceModel.name;
    //    if (_firstBlock) {
    //        // 获得第二行数据
    //        self.cityDataArr = _firstBlock(provinceModel);
    //        // 刷新
    //        [self.areaPicker selectRow:0 inComponent:1 animated:YES];
    //        if (_secondBlock) {
    //            // 获得第三行数据
    //            self.desticDataArr = _secondBlock(self.cityDataArr[0]);
    //
    //            [self.areaPicker selectRow:0 inComponent:2 animated:YES];
    //        }
    //    }
    //    // 列号为1
    //    NSInteger cityIndex = [self.areaPicker selectedRowInComponent:1];
    //    MyShopProvinceModel *cityModel = self.cityDataArr[cityIndex];
    //    if (_secondBlock) {
    //        // 获得第三行数据
    //        self.desticDataArr = _secondBlock(cityModel);
    //        // 刷新
    //
    //        [self.areaPicker selectRow:0 inComponent:2 animated:YES];
    //    }
    //    self.city = cityModel.name;
    //
    //    //第2列
    //    NSInteger desticIndex = [self.areaPicker selectedRowInComponent:2];
    //    MyShopProvinceModel *model = self.desticDataArr[desticIndex];
    //    self.province = model.name;
}

@end
