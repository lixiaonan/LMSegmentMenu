//
//  LMSegmentBar.m
//  LMSegmentBar
//
//  Created by 李小南 on 2016/11/26.
//  Copyright © 2016年 李小南. All rights reserved.
//

#import "LMSegmentBar.h"
#import "UIView+SegmentBar.h"
#import "LMSegmentBarButton.h"
#import "LMSegmentRightLeftBtn.h"

@interface LMSegmentBar ()
{
    // 记录最后一次点击的按钮
    UIButton *_lastBtn;
}
/** 内容承载视图 */
@property (nonatomic, weak) UIScrollView *contentView;

/** 添加的按钮数据 */
@property (nonatomic, strong) NSMutableArray <LMSegmentBarButton *>*itemBtns;

/** 指示器 */
@property (nonatomic, weak) UIView *indicatorView;

/** 底部分割线 */
@property (nonatomic, weak) UIView *bottomDividingLineView;

@property (nonatomic, strong) LMSegmentBarConfig *config;
/** 显示更多按钮 */
@property (nonatomic, strong) LMSegmentRightLeftBtn *showMoreBtn;

@end

@implementation LMSegmentBar



#pragma mark - 接口
+ (instancetype)segmentBarWithFrame: (CGRect)frame {
    LMSegmentBar *segmentBar = [[LMSegmentBar alloc] initWithFrame:frame];
    
    // 添加内容承载视图
    return segmentBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = self.config.segmentBarBackColor;
    }
    return self;
}


- (void)updateWithConfig: (void(^)(LMSegmentBarConfig *config))configBlock {
    
    if (configBlock) {
        configBlock(self.config);
    }
    
    // 按照当前的 self.config 进行刷新
    self.backgroundColor = self.config.segmentBarBackColor;
    
    for (UIButton *btn in self.itemBtns) {
        
        [btn setTitleColor:self.config.itemNormalColor forState:UIControlStateNormal];
        if (btn != _lastBtn) {
            btn.titleLabel.font = self.config.itemNormalFont;
        } else {
            btn.titleLabel.font = self.config.itemSelectedFont;
        }
        [btn setTitleColor:self.config.itemSelectedColor forState:UIControlStateSelected];
        
    }
    
    // 指示器
    self.indicatorView.backgroundColor = self.config.indicatorColor;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    // 数据过滤
    if (self.itemBtns.count == 0 || selectIndex < 0 || selectIndex > self.itemBtns.count - 1) {
        return;
    }
    _selectIndex = selectIndex;
    UIButton *btn = self.itemBtns[selectIndex];
    [self btnClick:btn];
}

- (void)setItems:(NSArray<NSString *> *)items {
    _items = items;
    
    // 删除之前添加过多额组件
    [self.itemBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtns = nil;
    _lastBtn = nil;
    
    // 根据所有的选项数据源， 创建Button, 添加到内容视图
    for (NSString *item in items) {
        LMSegmentBarButton *btn = [[LMSegmentBarButton alloc] init];
        btn.tag = self.itemBtns.count;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [btn setTitleColor:self.config.itemNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.config.itemSelectedColor forState:UIControlStateSelected];
        btn.titleLabel.font = self.config.itemNormalFont;
        [btn setTitle:item forState:UIControlStateNormal];
        [self.contentView addSubview:btn];
        [self.itemBtns addObject:btn];
    }
    
    // 手动刷新布局
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}


#pragma mark - 私有方法
- (void)btnClick:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(segmentBar:didSelectIndex:fromIndex:)]) {
        [self.delegate segmentBar:self didSelectIndex:btn.tag fromIndex:_lastBtn.tag];
    }

    _selectIndex = btn.tag;
    if (_lastBtn) {
        _lastBtn.selected = NO;
        _lastBtn.titleLabel.font = self.config.itemNormalFont;
        if (self.config.itemButtonLayoutType != LMItemButtonLayoutTypeFixedWidth) {
            [_lastBtn sizeToFit];
            _lastBtn.segmentBar_height = self.segmentBar_height;
        }
    }
    
    btn.selected = YES;
    btn.titleLabel.font = self.config.itemSelectedFont;
    if (self.config.itemButtonLayoutType != LMItemButtonLayoutTypeFixedWidth) {
        [btn sizeToFit];
        btn.segmentBar_height = self.segmentBar_height;
    }
    _lastBtn = btn;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (self.config.indicatorWidthFixed) {
            self.indicatorView.segmentBar_width = self.config.indicatorWidth;
        } else {
            self.indicatorView.segmentBar_width = btn.segmentBar_width + self.config.indicatorExtraW * 2;
        }
        self.indicatorView.segmentBar_centerX = btn.segmentBar_centerX;
    }];
    
    // 1. 先滚动到btn的位置
    if(self.contentView.contentSize.width > self.contentView.segmentBar_width) {
        CGFloat scrollX = btn.center.x - self.contentView.segmentBar_width * 0.5;
        
        if (scrollX < 0) {
            scrollX = 0;
        }
        if (scrollX > self.contentView.contentSize.width - self.contentView.segmentBar_width) {
            scrollX = self.contentView.contentSize.width - self.contentView.segmentBar_width;
        }
        
        [self.contentView setContentOffset:CGPointMake(scrollX, 0) animated:YES];
    }
}

#pragma mark - 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    
    if (!self.config.isShowMore) {
        self.contentView.frame = self.bounds;
        self.showMoreBtn.segmentBar_width = -1;
    } else {
        self.contentView.frame = CGRectMake(0, 0, self.segmentBar_width - self.config.showMoreItemWidth, self.segmentBar_height);
        self.showMoreBtn.frame = CGRectMake(self.segmentBar_width - self.config.showMoreItemWidth, 0, self.config.showMoreItemWidth, self.segmentBar_height);
    }
    
    /*
     三种按钮布局方式
        1.按钮等宽分布
        2.宽度随文字变化, 有最小间距
        3.宽度随文字变化, 有固定间距
     */
    
    CGFloat totalBtnWidth = 0;
    if (self.config.itemButtonLayoutType == LMItemButtonLayoutTypeTextWidthAndLimitMargin) {
        for (UIButton *btn in self.itemBtns) {
            [btn sizeToFit];
            totalBtnWidth += btn.segmentBar_width;
        }
    }
    
    switch (self.config.itemButtonLayoutType) {
        case LMItemButtonLayoutTypeFixedWidth: {
            
            CGFloat btnX = 0;
            CGFloat btnY = 0;
            CGFloat btnW = self.config.fixedWidth;
            CGFloat btnH = self.contentView.segmentBar_height;
            CGFloat lastX = 0;
            for (UIButton *btn in self.itemBtns) {
                btnX = lastX;
                btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
                lastX += btnW;
            }
            
            self.contentView.contentSize = CGSizeMake(lastX, 0);
            
            break;
        }
        case LMItemButtonLayoutTypeTextWidthAndLimitMargin: {
            // 计算间距
            CGFloat caculateMargin = (self.segmentBar_width - totalBtnWidth) / (self.items.count + 1);
            if (caculateMargin < self.config.limitMargin) {
                caculateMargin = self.config.limitMargin;
            }
            
            CGFloat lastX = caculateMargin;
            for (UIButton *btn in self.itemBtns) {
                [btn sizeToFit];
                btn.segmentBar_y = 0;
                btn.segmentBar_x = lastX;
                btn.segmentBar_height = self.segmentBar_height;
                lastX += btn.segmentBar_width + caculateMargin;
            }
            
            self.contentView.contentSize = CGSizeMake(lastX, 0);
            
            break;
        }
        case LMItemButtonLayoutTypeTextWidthAndFixedMargin: {
            // 固定间距
            CGFloat caculateMargin = self.config.fixedMargin;
            CGFloat lastX = self.config.fixedMargin;
            for (UIButton *btn in self.itemBtns) {
                [btn sizeToFit];
                btn.segmentBar_y = 0;
                btn.segmentBar_x = lastX;
                btn.segmentBar_height = self.segmentBar_height;
                lastX += btn.segmentBar_width + caculateMargin;
            }
            
            self.contentView.contentSize = CGSizeMake(lastX, 0);
            break;
        }
            
        default:
            break;
    }
    
    if (self.itemBtns.count == 0) {
        return;
    }
    
    // 指示器
    UIButton *btn = self.itemBtns[self.selectIndex];
    
    if (self.config.indicatorWidthFixed) {
        self.indicatorView.segmentBar_width = self.config.indicatorWidth;
    } else {
        self.indicatorView.segmentBar_width = btn.segmentBar_width + self.config.indicatorExtraW * 2;
    }
    self.indicatorView.segmentBar_centerX = btn.segmentBar_centerX;
    self.indicatorView.segmentBar_height = self.config.indicatorHeight;
    self.indicatorView.segmentBar_y = self.segmentBar_height - self.indicatorView.segmentBar_height;
    
    // 分割线
    if (self.config.addBottomDividingLine) {
        self.bottomDividingLineView.segmentBar_height = self.config.bottomDividingLineHeight;
        self.bottomDividingLineView.segmentBar_y = self.segmentBar_height - self.bottomDividingLineView.segmentBar_height;
        self.bottomDividingLineView.segmentBar_width = self.segmentBar_width;
        self.bottomDividingLineView.backgroundColor = self.config.bottomDividingLineColor;
    } else {
        if (_bottomDividingLineView) {
            [self.bottomDividingLineView removeFromSuperview];
            self.bottomDividingLineView = nil;
        }
    }
}

#pragma mark - Click Action
- (void)showMoreBtnClick:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    if (btn.selected) {
//        [self showDetailPane];
    } else {
//        [self hideDetailPane];
    }
    
    if ([self.delegate respondsToSelector:@selector(segmentBar:showMoreBtnClick:)]) {
        [self.delegate segmentBar:self showMoreBtnClick:btn];
    }
    
}

#pragma mark - 懒加载

- (NSMutableArray<LMSegmentBarButton *> *)itemBtns {
    if (!_itemBtns) {
        _itemBtns = [NSMutableArray array];
    }
    return _itemBtns;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        CGFloat indicatorH = self.config.indicatorHeight;
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - indicatorH, 0, indicatorH)];
        indicatorView.backgroundColor = self.config.indicatorColor;
        [self.contentView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

- (UIView *)bottomDividingLineView {
    if (!_bottomDividingLineView) {
        CGFloat lineH = self.config.bottomDividingLineHeight;
        UIView *bottomDividingLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - lineH, self.frame.size.width, lineH)];
        bottomDividingLineView.backgroundColor = self.config.bottomDividingLineColor;
        [self insertSubview:bottomDividingLineView atIndex:0];
        _bottomDividingLineView = bottomDividingLineView;
    }
    return _bottomDividingLineView;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        [self addSubview:scrollView];
        _contentView = scrollView;
    }
    return _contentView;
}

- (LMSegmentBarConfig *)config {
    if (!_config) {
        _config = [LMSegmentBarConfig defaultConfig];
    }
    return _config;
}

- (LMSegmentRightLeftBtn *)showMoreBtn {
    if (!_showMoreBtn) {
        LMSegmentRightLeftBtn *showMoreBtn = [[LMSegmentRightLeftBtn alloc] init];
        [showMoreBtn addTarget:self action:@selector(showMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showMoreBtn];
        _showMoreBtn = showMoreBtn;
        
        showMoreBtn.backgroundColor = [UIColor redColor];
    }
    return _showMoreBtn;
}


@end
