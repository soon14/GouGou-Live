//
//  DogCategoryModel.h
//  GouGou-Live
//
//  Created by ma c on 16/12/2.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "BaseModel.h"

@interface DogCategoryModel : BaseModel

@property(nonatomic, strong) NSString *name; /**< 名字 */

@property(nonatomic, strong) NSString *ID; /**< id */

@property(nonatomic, strong) NSString *createTime; /**< <#注释#> */
@property(nonatomic, strong) NSString *delFlg; /**< <#注释#> */
@property(nonatomic, strong) NSString *updateTime; /**< <#注释#> */

@end
