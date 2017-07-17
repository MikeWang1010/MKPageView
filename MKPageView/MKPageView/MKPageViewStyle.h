//
//  MKPageViewStyle.h
//  MKPageView
//
//  Created by MikeWang on 2017/7/12.
//  Copyright © 2017年 MikeWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKPageViewStyle : NSObject

@property (nonatomic, assign) CGFloat titleViewH;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat leftRinghtMargin;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat bottomLineH;
@property (nonatomic, strong) UIColor *norColor;
@property (nonatomic, strong) UIColor *seletedColor;

@end
