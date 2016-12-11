//
//  TalkingViewController.h
//  GouGou-Live
//
//  Created by ma c on 16/10/29.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "BaseViewController.h"

@interface TalkingViewController : BaseViewController

@property(nonatomic, strong) UITextField *textField; /**< 输入框 */

@property(nonatomic, strong) NSString *roomID; /**< 聊天房间id */

@property(nonatomic, assign) BOOL isHidText; /**< 隐藏编辑栏 */
@end
