//
//  LMSegmentBarConfig.m
//  LMSegmentBar
//
//  Created by 李小南 on 2016/11/26.
//  Copyright © 2016年 李小南. All rights reserved.
//

#import "LMSegmentBarConfig.h"

@implementation LMSegmentBarConfig

+ (instancetype)defaultConfig {
    
    LMSegmentBarConfig *config = [[LMSegmentBarConfig alloc] init];
    config.segmentBarBackColor = [UIColor whiteColor];
    
    config.itemNormalFont = [UIFont systemFontOfSize:15];
    config.itemSelectedFont = [UIFont systemFontOfSize:15];
    config.itemNormalColor = [UIColor lightGrayColor];
    config.itemSelectedColor = [UIColor redColor];
    
    config.indicatorColor = [UIColor redColor];
    config.indicatorHeight = 3;
    
    config.indicatorWidthFixed = YES;
    config.indicatorWidth = 30;
    config.indicatorExtraW = 10;
    config.addBottomDividingLine = YES;
    config.bottomDividingLineColor = [UIColor lightGrayColor];
    config.bottomDividingLineHeight = 1;
    
    // ----选项按钮布局
    config.itemButtonLayoutType = LMItemButtonLayoutTypeTextWidthAndFixedMargin;
    config.fixedWidth = 60;
    config.fixedMargin = 10;
    config.limitMargin = 30;
    
    return config;
    
}


// 普通 itemNormalColor
- (LMSegmentBarConfig *(^)(UIColor *))itemNC {

    return ^(UIColor *color){
        self.itemNormalColor = color;
        return self;
    };

}

// 选中 itemSelectColor
-(LMSegmentBarConfig *(^)(UIColor *))itemSC {
    return ^(UIColor *color){
        self.itemSelectedColor = color;
        return self;
    };
}


@end
