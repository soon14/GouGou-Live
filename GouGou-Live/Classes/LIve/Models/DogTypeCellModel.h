//
//  DogTypeCellModel.h
//  GouGou-Live
//
//  Created by ma c on 16/10/28.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DogTypeCellModel : NSObject

/** 狗狗图片 */
@property (copy,nonatomic) NSString *dogIcon;

/** 人数 */
@property (copy,nonatomic) NSString *focusCount;

/** 狗狗简介 */
@property (copy,nonatomic) NSString *dogDesc;

/** 主播名字 */
@property (strong, nonatomic) NSString *anchorName;

/** 销量信息 */
@property (copy,nonatomic) NSString *saleMessage;

@end
