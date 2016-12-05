//
//  SellerOrderModel.h
//  GouGou-Live
//
//  Created by ma c on 16/12/5.
//  Copyright © 2016年 LXq. All rights reserved.
//  订单列表cell

#import "BaseModel.h"

@interface SellerOrderModel : BaseModel

@property(nonatomic, strong) NSString *status; /**< 订单状态 */
@property(nonatomic, strong) NSString *userImgUrl; /**< 用户图片 */
@property(nonatomic, strong) NSString *userName; /**< 用户名字 */
@property(nonatomic, strong) NSString *comment; /**< 备注 */

@property(nonatomic, strong) NSString *ageName; /**< 狗狗年龄 */
@property(nonatomic, strong) NSString *colorName; /**< 狗狗颜色 */
@property(nonatomic, strong) NSString *sizeName; /**< 狗狗体型 */
@property(nonatomic, strong) NSArray *impresssion; /**< 印象 */
@property(nonatomic, strong) NSString *kindName; /**< 品种 */
@property(nonatomic, strong) NSString *name; /**< 名字 */
@property(nonatomic, strong) NSString *pathSmall; /**< 缩略图 */
@property(nonatomic, strong) NSString *price; /**< 价格 */

@property(nonatomic, strong) NSString *priceOld; /**< 老价格 */
@property(nonatomic, strong) NSString *productDeposit; /**< 定金 */
@property(nonatomic, strong) NSString *productRealDeposit; /**< 实付定金 */

@property(nonatomic, strong) NSString *productBalance; /**< 尾款 */
@property(nonatomic, strong) NSString *productRealBalance; /**< 实付尾款 */



@end