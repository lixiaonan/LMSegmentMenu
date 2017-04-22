//
//  LMSegmentRightLeftBtn.m
//  LMSegmentMeua
//
//  Created by 李小南 on 2017/4/22.
//  Copyright © 2017年 LMIJKPlayer. All rights reserved.
//

#import "LMSegmentRightLeftBtn.h"

@implementation LMSegmentRightLeftBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"icon_radio_show"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"icon_radio_hide"] forState:UIControlStateSelected];
    }
    return self;
}

@end
