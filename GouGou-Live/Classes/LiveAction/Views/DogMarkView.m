//
//  DogMarkView.m
//  GouGou-Live
//
//  Created by ma c on 16/10/31.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "DogMarkView.h"


@implementation DogMarkView

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)marks {
    self = [super init];
    if (self) {
        CGFloat w = 40;
        CGFloat h = 22;
        CGFloat magrin = 10;
        
        for (NSInteger i = 0; i < marks.count; i ++) {
            
            UILabel *label = [[UILabel alloc] init];
            label.text = marks[i];
            label.frame = CGRectMake(i * (w + magrin), 0, w, h);

            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor colorWithHexString:@"#ffffff"];
            label.backgroundColor = [UIColor colorWithHexString:@"#ffa11a"];
            label.textAlignment = NSTextAlignmentCenter;
            
            label.layer.cornerRadius = 5;
            label.layer.masksToBounds = YES;

            [self addSubview:label];
        }
    }
    return self;
}


@end