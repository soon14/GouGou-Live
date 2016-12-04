//
//  BuyCenterModel.h
//  GouGou-Live
//
//  Created by ma c on 16/12/1.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "BaseModel.h"

@interface BuyCenterModel : BaseModel
/** 商家图片 */
@property (copy,nonatomic) NSString *merchantImgl;
/** 商家名称 */
@property (copy,nonatomic) NSString *merchantName;
/** 订单状态 */
@property (copy,nonatomic) NSString *status;

/** 商品名称 */
@property (copy,nonatomic) NSString *name;
/** 缩略图 */
@property (copy, nonatomic) NSString *pathSmall;
/** 品种 */
@property (copy,nonatomic) NSString *kindName;
/** 狗狗年龄 */
@property (copy,nonatomic) NSString *ageName;
/** 狗狗体型 */
@property (copy,nonatomic) NSString *sizeName;
/** 狗狗颜色 */
@property (copy,nonatomic) NSString *colorName;
/** 原价 */
@property (copy,nonatomic) NSString *priceOld;
/** 现价 */
@property (copy,nonatomic) NSString *price;

/** 商品定金 */
@property (copy,nonatomic) NSString *productDeposit;
/** 实付定金 */
@property (copy,nonatomic) NSString *productRealDeposit;
/** 商品尾款 */
@property (copy,nonatomic) NSString *balance;
/** 实付尾款 */
@property (copy,nonatomic) NSString *realLalance;

@end