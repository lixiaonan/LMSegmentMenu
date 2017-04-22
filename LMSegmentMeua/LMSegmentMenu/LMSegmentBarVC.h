//
//  LMSementBarVC.h
//  LMSegmentBar
//
//  Created by 李小南 on 2016/11/26.
//  Copyright © 2016年 李小南. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMSegmentBar.h"

@class LMSegmentBarVC;
@protocol LMSegmentBarVCDelegate <NSObject>
@optional
/**
 代理方法, 告诉外界, 内部的点击数据
 
 @param segmentBarVC segmentBar
 @param toIndex    选中的索引(从0开始)
 @param fromIndex  上一个索引
 */
- (void)segmentBarVC:(LMSegmentBarVC *)segmentBarVC didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex;

/**
 *  显示更多按钮 的点击事件
 *
 *  @param showMoreBtn 从某个索引
 */
- (void)segmentBarVC: (LMSegmentBarVC *)segmentBarVC showMoreBtnClick:(UIButton *)showMoreBtn;

@end

@interface LMSegmentBarVC : UIViewController
/** 代理 */
@property (nonatomic, weak) id<LMSegmentBarVCDelegate> delegate;
@property (nonatomic, weak) LMSegmentBar *segmentBar;
/** 默认选中的选项 */
@property (nonatomic, assign) NSInteger defaultSelectedIndex;

/**
 *  设置标题数组和子控制器
 *
 *  @param items   标题数组
 *  @param childVCs 子控制器数组
 */
- (void)setUpWithItems: (NSArray <NSString *>*)items childVCs: (NSArray <UIViewController *>*)childVCs;


@end
