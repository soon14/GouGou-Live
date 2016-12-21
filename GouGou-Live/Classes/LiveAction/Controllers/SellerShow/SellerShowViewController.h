//
//  SellerShowViewController.h
//  GouGou-Live
//
//  Created by ma c on 16/10/29.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "BaseViewController.h"

@interface SellerShowViewController : BaseViewController

@property(nonatomic, strong) NSString *authorId; /**< 主播id */
@property (nonatomic, strong) NSString *liverIcon; /**< 主播头像 */
@property (nonatomic, strong) NSString *liverName; /**< 主播名字 */

@end
