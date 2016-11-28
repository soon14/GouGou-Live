//
//  MyFocusTableCell.h
//  GouGou-Live
//
//  Created by ma c on 16/11/8.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectBtnBlock)(BOOL isSelect);

@class FocusAndFansModel;
@interface MyFocusTableCell : UITableViewCell

@property(nonatomic, strong) SelectBtnBlock selectBlock; /**< 后边圆的按钮 */


@property(nonatomic, strong) FocusAndFansModel *model; /**< 模型 */

@end
