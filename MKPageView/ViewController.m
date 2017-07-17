//
//  ViewController.m
//  MKPageView
//
//  Created by MikeWang on 2017/7/12.
//  Copyright © 2017年 MikeWang. All rights reserved.
//

#import "ViewController.h"
#import "MKPageView.h"
#import "MKPageViewStyle.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的pageView";
    self.automaticallyAdjustsScrollViewInsets = NO;//注意：如果有导航控制器一定要加这一句，否则，标题栏则不能正确显示位置
    
    NSMutableArray *vcArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 7; i++) {
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [self getRandomColor];
        [vcArray addObject:vc];
    }
    MKPageViewStyle *pageViewStyle = [[MKPageViewStyle alloc]init];
    pageViewStyle.titleViewH = 44.;
    pageViewStyle.margin = 10.;
    pageViewStyle.leftRinghtMargin = 5.;
    pageViewStyle.scale = 1.3;
    pageViewStyle.bottomLineH = 2.;
    pageViewStyle.norColor = [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1];
    pageViewStyle.seletedColor = [UIColor colorWithRed:255/255. green:127/255. blue:0/255. alpha:1];
    
    NSArray *titleArray = @[@"热点",@"国际新闻",@"国内新闻",@"体育",@"国际新闻A",@"国内新闻A",@"体育A"];
    
    MKPageView *pageView = [[MKPageView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) pageViewStyle:pageViewStyle titleArray:titleArray controllerArray:vcArray parentVc:self];
    [self.view addSubview:pageView];
}


- (UIColor *)getRandomColor {
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return  [UIColor colorWithRed:r / 255. green:g / 255. blue:b / 255. alpha:1];
}

@end
