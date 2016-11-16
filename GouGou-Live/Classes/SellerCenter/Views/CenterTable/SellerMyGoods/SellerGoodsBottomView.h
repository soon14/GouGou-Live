//
//  SellerGoodsBottomView.h
//  GouGou-Live
//
//  Created by ma c on 16/11/16.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickAllSelectBtnBlock)();
typedef void(^ClickDeleteBtnBlock)();

@interface SellerGoodsBottomView : UIView

@property(nonatomic, strong) ClickAllSelectBtnBlock allSelectBlock; /**< 全选回调 */
@property(nonatomic, strong) ClickDeleteBtnBlock deleteBlock; /**< 删除回调 */

@end
