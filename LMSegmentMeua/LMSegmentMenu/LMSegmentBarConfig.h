//
//  LMSegmentBarConfig.h
//  LMSegmentBar
//
//  Created by 李小南 on 2016/11/26.
//  Copyright © 2016年 李小南. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 判断发起搜索窗口的来源
typedef NS_ENUM(NSInteger, LMItemButtonLayoutType) {
    LMItemButtonLayoutTypeFixedWidth = 1, // 等宽
    LMItemButtonLayoutTypeTextWidthAndLimitMargin, // 宽度随文字变化并有最小间距(中间布局)
    LMItemButtonLayoutTypeTextWidthAndFixedMargin  // 宽度随文字变化并有固定间距(从左向右布局)
};

@interface LMSegmentBarConfig : NSObject


+ (instancetype)defaultConfig;

/** 背景颜色 */
@property (nonatomic, strong) UIColor *segmentBarBackColor;
/** 选项颜色(普通) */
@property (nonatomic, strong) UIColor *itemNormalColor;
/** 选项颜色(选中) */
@property (nonatomic, strong) UIColor *itemSelectedColor;
/** 选项字体(普通) */
@property (nonatomic, strong) UIFont *itemNormalFont;
/** 选项字体(选中) */
@property (nonatomic, strong) UIFont *itemSelectedFont;


// 指示器
/** 指示器颜色, 默认红色 */
@property (nonatomic, strong) UIColor *indicatorColor;
/** 指示器高度 */
@property (nonatomic, assign) CGFloat indicatorHeight;
/** 指示器的宽度是否固定(固定时采用固定宽度, 不固定时采用 文字 + 额外宽度) */
@property (nonatomic, assign) BOOL indicatorWidthFixed;
/** 指示器宽度固定时的宽度 */
@property (nonatomic, assign) CGFloat indicatorWidth;
/** 指示器的额外宽度(在跟随字体宽度之外的额外宽度) */
@property (nonatomic, assign) CGFloat indicatorExtraW;

// 分割线
/** 是否有底部分割线 */
@property (nonatomic, assign) BOOL addBottomDividingLine;
/** 底部分割线颜色 */
@property (nonatomic, strong) UIColor *bottomDividingLineColor;
/** 底部分割线的高度 */
@property (nonatomic, assign) CGFloat bottomDividingLineHeight;


/*
 按钮布局与宽度:   
    1.固定宽度, 等宽分布, 超过父控件宽度时, 可以滑动 (默认从左向右排列)
    2.宽度不固定, 宽度随文字宽度变化, 但有最小间距, 不超过父控件宽度时, 平均分布, 超过父控件宽度时, 按最小间距分布
 
    3.宽度不固定, 宽度随文字宽度变化, 但有固定间距 (默认从左向右分布)
 
 */
/** 选项按钮布局方式 */
@property (nonatomic, assign) LMItemButtonLayoutType itemButtonLayoutType;
/** 选项按钮固定的宽度 */
@property (nonatomic, assign) CGFloat fixedWidth;
/** 选项按钮固定的间距 */
@property (nonatomic, assign) CGFloat fixedMargin;
/** 选项卡之间的最小间距 */
@property (nonatomic, assign) CGFloat limitMargin;


// 链式编程的改法
- (LMSegmentBarConfig *(^)(UIColor *color))itemNC;
- (LMSegmentBarConfig *(^)(UIColor *color))itemSC;



@end
