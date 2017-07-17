//
//  MKPageViewStyle.m
//  MKPageView
//
//  Created by MikeWang on 2017/7/12.
//  Copyright © 2017年 MikeWang. All rights reserved.
//

#import "MKPageViewStyle.h"

@implementation MKPageViewStyle

- (void)setScale:(CGFloat)scale {
    if (scale > 1.2) {
        scale = 1.2;
    }
    _scale = scale;
}
@end
