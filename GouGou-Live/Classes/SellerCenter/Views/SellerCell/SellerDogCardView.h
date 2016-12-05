//
//  SellerDogCardView.h
//  GouGou-Live
//
//  Created by ma c on 16/11/15.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DogCardModel.h"

@interface SellerDogCardView : UIView

@property(nonatomic, strong) NSArray *dogCard; /**< 狗Card */
///** 狗狗信息模型 */
//@property (strong,nonatomic) DogCardModel *dogCardModel;
/** 狗狗图片*/
@property (strong, nonatomic)  UIImageView *dogImageView;
/** 狗狗名字 */
@property (strong, nonatomic)  UILabel *dogNameLabel;
/** 品种 */
@property(nonatomic, strong) UILabel *kindLabel;
/** 狗狗种类 */
@property (strong, nonatomic)  UILabel *dogKindLabel;
/** 狗狗年龄*/
@property (strong, nonatomic)  UILabel *dogAgeLabel;
/** 狗狗体型*/
@property (strong, nonatomic)  UILabel *dogSizeLabel;
/** 狗狗颜色*/
@property (strong, nonatomic)  UILabel *dogColorLabel;
/** 狗狗价格*/
@property (strong, nonatomic)  UILabel *nowPriceLabel;
/** 狗狗老价格*/
@property (strong, nonatomic)  UILabel *oldPriceLabel;

@end
