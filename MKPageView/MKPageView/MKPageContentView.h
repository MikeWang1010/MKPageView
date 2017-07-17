//
//  MKPageContentView.h
//  MKPageView
//
//  Created by MikeWang on 2017/7/12.
//  Copyright © 2017年 MikeWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MKPageContentViewDelegate <NSObject>
@optional

- (void)pageContentViewScrollFrom:(NSInteger) sourceIndex to:(NSInteger)targetIndex;
- (void)pageContentViewScrollTo:(NSInteger)targetIndex progress:(CGFloat)progress;

@end

@interface MKPageContentView : UIView

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) id <MKPageContentViewDelegate> delegate;

- (instancetype) initWithFrame:(CGRect)frame controllerArray:(NSArray *) controllerArray parentVc:(UIViewController *)superVc;

@end
