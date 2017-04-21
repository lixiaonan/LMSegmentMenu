//
//  LMSegmentBar.h
//  LMSegmentBar
//
//  Created by 李小南 on 2016/11/26.
//  Copyright © 2016年 李小南. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSegmentBarConfig.h"

@class LMSegmentBar;
@protocol LMSegmentBarDelegate <NSObject>

/**
 *  选项卡 从某个索引 选中某个索引
 *
 *  @param toIndex   选中的索引
 *  @param fromIndex 从某个索引
 */
- (void)segmentBar: (LMSegmentBar *)segmentBar didSelectIndex: (NSInteger)toIndex fromIndex: (NSInteger)fromIndex;

@end


@interface LMSegmentBar : UIView
/**
 *  快速创建选项卡
 *  @return 选项卡
 */
+ (instancetype)segmentBarWithFrame: (CGRect)frame;
/** 代理 */
@property (nonatomic, weak) id<LMSegmentBarDelegate> delegate;
/** 数据源 */
@property (nonatomic, strong) NSArray <NSString *>*items;
/** 当前选中的索引, 双向设置 */
@property (nonatomic, assign) NSInteger selectIndex;

- (void)updateWithConfig: (void(^)(LMSegmentBarConfig *config))configBlock;


@end
