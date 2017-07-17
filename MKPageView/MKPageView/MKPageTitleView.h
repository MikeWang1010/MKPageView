//
//  MKPageTitleView.h
//  MKPageView
//
//  Created by MikeWang on 2017/7/12.
//  Copyright © 2017年 MikeWang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKPageTitleView,MKPageViewStyle;

@protocol MKPageTitleViewDelegate <NSObject>

@optional
- (void)pageTitleView:(MKPageTitleView *)pageTitleView clickWithIndex:(NSInteger)currentIndex;

@end

@interface MKPageTitleView : UIView

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) id <MKPageTitleViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray pageViewStyle:(MKPageViewStyle *)pageViewStyle;

- (void)changeTitleViewWithScrollToIndex:(NSInteger)targetIndex progress:(CGFloat)progress;
@end
