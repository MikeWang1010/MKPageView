//
//  MKPageView.m
//  MKPageView
//
//  Created by MikeWang on 2017/7/12.
//  Copyright © 2017年 MikeWang. All rights reserved.
//


#import "MKPageView.h"
#import "MKPageTitleView.h"
#import "MKPageContentView.h"
#import "MKPageViewStyle.h"

@interface MKPageView ()<MKPageContentViewDelegate,MKPageTitleViewDelegate>

@property (nonatomic, strong) MKPageViewStyle *pageViewStyle;
@property (nonatomic, strong) NSArray *controllerArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) MKPageTitleView *titleView;
@property (nonatomic, strong) MKPageContentView *contentView;
@property (nonatomic, strong) UIViewController *superVc;

@end

@implementation MKPageView

- (instancetype) initWithFrame:(CGRect)frame pageViewStyle:(MKPageViewStyle *)pageViewStyle titleArray:(NSArray *)titleArray controllerArray:(NSArray *) controllerArray parentVc:(UIViewController *)superVc {
    if (self = [super initWithFrame:frame]) {
        self.pageViewStyle = pageViewStyle;
        if(!self.pageViewStyle){//默认设置
            self.pageViewStyle = [[MKPageViewStyle alloc]init];
            self.pageViewStyle.titleViewH = 44.;
            self.pageViewStyle.margin = 10.;
            self.pageViewStyle.leftRinghtMargin = 5.;
            self.pageViewStyle.scale = 1.2;
            self.pageViewStyle.bottomLineH = 2.;
            self.pageViewStyle.norColor = [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1];
            self.pageViewStyle.seletedColor = [UIColor colorWithRed:255/255. green:127/255. blue:0/255. alpha:1];
        }
        self.titleArray = titleArray;
        self.controllerArray = controllerArray;
        self.superVc = superVc;
        [self setupSubView];
    }
    return self;
}


- (void)setupSubView {
    [self addSubview:self.titleView];
    [self addSubview:self.contentView];
}


#pragma mark - MKPageContentViewDelegate

- (void)pageContentViewScrollFrom:(NSInteger)sourceIndex to:(NSInteger)targetIndex {
    self.titleView.currentIndex = targetIndex;
    
    
}
- (void)pageContentViewScrollTo:(NSInteger)targetIndex progress:(CGFloat)progress {
    [self.titleView changeTitleViewWithScrollToIndex:targetIndex progress:progress];
}

#pragma mark - MKPageTitleViewDelegate

- (void)pageTitleView:(MKPageTitleView *)pageTitleView clickWithIndex:(NSInteger)currentIndex {
    self.contentView.currentIndex = currentIndex;
}

#pragma mark - 属性

- (MKPageTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[MKPageTitleView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.pageViewStyle.titleViewH) titleArray:self.titleArray pageViewStyle:self.pageViewStyle];
        _titleView.delegate = self;
    }
    return _titleView;
}

- (MKPageContentView *)contentView {
    if (!_contentView) {
        _contentView = [[MKPageContentView alloc]initWithFrame:CGRectMake(0, self.pageViewStyle.titleViewH, self.frame.size.width, self.frame.size.height - self.pageViewStyle.titleViewH) controllerArray:self.controllerArray parentVc:self.superVc];
        _contentView.delegate = self;
    }
    return _contentView;
}

@end
