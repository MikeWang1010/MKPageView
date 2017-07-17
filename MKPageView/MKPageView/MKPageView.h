//
//  MKPageView.h
//  MKPageView
//
//  Created by MikeWang on 2017/7/12.
//  Copyright © 2017年 MikeWang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKPageViewStyle;

@interface MKPageView : UIView

- (instancetype) initWithFrame:(CGRect)frame pageViewStyle:(MKPageViewStyle *)pageViewStyle titleArray:(NSArray *)titleArray controllerArray:(NSArray *) controllerArray parentVc:(UIViewController *)superVc;

@end
