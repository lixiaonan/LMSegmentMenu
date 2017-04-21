//
//  LMSementBarVC.m
//  LMSegmentBar
//
//  Created by 李小南 on 2016/11/26.
//  Copyright © 2016年 李小南. All rights reserved.
//

#import "LMSementBarVC.h"
#import "UIView+SegmentBar.h"

@interface LMSementBarVC ()<LMSegmentBarDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *contentView;

@property (nonatomic, assign) BOOL isInitial;
@end

@implementation LMSementBarVC
- (LMSegmentBar *)segmentBar {
    if (!_segmentBar) {
        LMSegmentBar *segmentBar = [LMSegmentBar segmentBarWithFrame:CGRectZero];
        segmentBar.delegate = self;
        segmentBar.backgroundColor = [UIColor brownColor];
        [self.view addSubview:segmentBar];
        _segmentBar = segmentBar;
        
    }
    return _segmentBar;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        
        UIScrollView *contentView = [[UIScrollView alloc] init];
        contentView.delegate = self;
        contentView.pagingEnabled = YES;
        contentView.bounces = NO;
        contentView.scrollsToTop = NO;
        [self.view addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    if (_isInitial == NO) {
//        _isInitial = YES;
//        self.segmentBar.selectIndex = 0;
//    }
//}

- (void)viewWillAppear:(BOOL)animated {
    if (_isInitial == NO) {
        _isInitial = YES;
        self.segmentBar.selectIndex = 0;
    }
}


- (void)setUpWithItems: (NSArray <NSString *>*)items childVCs: (NSArray <UIViewController *>*)childVCs {
    
    NSAssert(items.count != 0 || items.count == childVCs.count, @"个数不一致, 请自己检查");
    
    self.segmentBar.items = items;
    
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    // 添加几个自控制器
    // 在contentView, 展示子控制器的视图内容
    for (UIViewController *vc in childVCs) {
        [self addChildViewController:vc];
    }
    
    //
    self.contentView.contentSize = CGSizeMake(items.count * self.view.segmentBar_width, 0);
    
//    self.segmentBar.selectIndex = 0;
}


- (void)showChildVCViewsAtIndex: (NSInteger)index {
    
    if (self.childViewControllers.count == 0 || index < 0 || index > self.childViewControllers.count - 1) {
        return;
    }
    
    UIViewController *vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index * self.contentView.segmentBar_width, 0, self.contentView.segmentBar_width, self.contentView.segmentBar_height);
    [self.contentView addSubview:vc.view];
    
    // 滚动到对应的位置
//    [self.contentView setContentOffset:CGPointMake(index * self.contentView.width, 0) animated:YES];
    [self.contentView setContentOffset:CGPointMake(index * self.contentView.segmentBar_width, 0) animated:NO];
    
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (self.segmentBar.superview == self.view) {
        self.segmentBar.frame = CGRectMake(0, 60, self.view.segmentBar_width, 35);
        
        CGFloat contentViewY = self.segmentBar.segmentBar_y + self.segmentBar.segmentBar_height;
        CGRect contentFrame = CGRectMake(0, contentViewY, self.view.segmentBar_width, self.view.segmentBar_height - contentViewY);
        self.contentView.frame = contentFrame;
        self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.segmentBar_width, 0);

        return;
    }
    
    
    CGRect contentFrame = CGRectMake(0, 0,self.view.segmentBar_width,self.view.segmentBar_height);
    self.contentView.frame = contentFrame;
     self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.segmentBar_width, 0);
    
    
    // 其他的控制器视图, 大小
    // 遍历所有的视图, 重新添加, 重新进行布局
    // 注意: 1个视图
    //
    
//    self.segmentBar.selectIndex = self.segmentBar.selectIndex;
    
}

#pragma mark - 选项卡代理方法
- (void)segmentBar:(LMSegmentBar *)segmentBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    if ([self.delegate respondsToSelector:@selector(segmentBarVC:didSelectIndex:fromIndex:)]) {
        [self.delegate segmentBarVC:self didSelectIndex:toIndex fromIndex:fromIndex];
    }
    
//    NSLog(@"%zd----%zd", fromIndex, toIndex);
    [self showChildVCViewsAtIndex:toIndex];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 计算最后的索引
    NSInteger toIndex = self.contentView.contentOffset.x / self.contentView.segmentBar_width;
    
    NSInteger fromIndex = self.segmentBar.selectIndex;
    if ([self.delegate respondsToSelector:@selector(segmentBarVC:didSelectIndex:fromIndex:)]) {
        [self.delegate segmentBarVC:self didSelectIndex:toIndex fromIndex:fromIndex];
    }
//    [self showChildVCViewsAtIndex:toIndex];
    self.segmentBar.selectIndex = toIndex;
    
}

@end
