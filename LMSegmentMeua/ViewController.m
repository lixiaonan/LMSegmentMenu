//
//  ViewController.m
//  LMSegmentMeua
//
//  Created by 李小南 on 2017/4/21.
//  Copyright © 2017年 LMIJKPlayer. All rights reserved.
//

#import "ViewController.h"
#import "LMSementBarVC.h"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
@interface ViewController ()<LMSementBarVCDelegate>
@property (nonatomic, weak) LMSementBarVC *segmentBarVC;
@end

@implementation ViewController

- (LMSementBarVC *)segmentBarVC {
    if (!_segmentBarVC) {
        LMSementBarVC *vc = [[LMSementBarVC alloc] init];
        [self addChildViewController:vc];
        _segmentBarVC = vc;
    }
    return _segmentBarVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.segmentBarVC.delegate = self;
    
    self.segmentBarVC.segmentBar.frame = CGRectMake(0, 64, kScreenWidth, 35);
    self.segmentBarVC.segmentBar.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.segmentBarVC.segmentBar];
    
    
    self.segmentBarVC.view.frame = CGRectMake(0, 64 + 35, kScreenWidth, kScreenHeight - 64 - 35);
    [self.view addSubview:self.segmentBarVC.view];
    
    
    NSArray *items = @[@"专辑", @"声音", @"下载中", @"你好啊好啊", @"vc5"];
    
    // 添加几个自控制器
    // 在contentView, 展示子控制器的视图内容
    
    UIViewController *vc1 = [UIViewController new];
    vc1.view.backgroundColor = [UIColor redColor];
    
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor greenColor];
    
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController *vc4 = [UIViewController new];
    vc4.view.backgroundColor = [UIColor yellowColor];
    
    UIViewController *vc5 = [UIViewController new];
    vc5.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.segmentBarVC setUpWithItems:items childVCs:@[vc1, vc2, vc3, vc4, vc5]];
    [self.segmentBarVC.segmentBar updateWithConfig:^(LMSegmentBarConfig *config) {
        
        config.segmentBarBackColor = [UIColor cyanColor];
        config.itemSC([UIColor brownColor]).itemNC([UIColor yellowColor]);
        
        config.indicatorHeight = 3;
        config.indicatorColor = [UIColor blueColor];
        config.addBottomDividingLine = NO;
        config.itemSelectedFont = [UIFont systemFontOfSize:18];
        
        // 1.平分屏幕
        config.indicatorWidthFixed = YES;
        config.indicatorWidth = kScreenWidth / 3;
        config.itemButtonLayoutType = LMItemButtonLayoutTypeFixedWidth;
        config.fixedWidth = kScreenWidth / 3;
        
        // 2.从左到右
        config.indicatorWidthFixed = NO;
        config.indicatorExtraW = 8;
        config.itemButtonLayoutType = LMItemButtonLayoutTypeTextWidthAndFixedMargin;
        config.fixedMargin = 50;
        
        // 3.从中间均分
        config.indicatorWidthFixed = NO;
        config.indicatorExtraW = 8;
        config.itemButtonLayoutType = LMItemButtonLayoutTypeTextWidthAndLimitMargin;
        config.limitMargin = 50;
        
    }];
}

#pragma mark - LMSementBarVCDelegate
- (void)segmentBarVC:(LMSementBarVC *)segmentBarVC didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex {
    NSLog(@"%zd----%zd", fromIndex, toIndex);
}


@end
