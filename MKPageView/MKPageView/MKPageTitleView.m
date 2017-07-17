//
//  MKPageTitleView.m
//  MKPageView
//
//  Created by MikeWang on 2017/7/12.
//  Copyright © 2017年 MikeWang. All rights reserved.
//


#import "MKPageTitleView.h"
#import "MKPageViewStyle.h"

@interface MKPageTitleView ()

@property (nonatomic, strong) MKPageViewStyle *pageViewStyle;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titleLabelArray;
@property (nonatomic, strong) NSMutableArray *titleWidthArray;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, assign) BOOL isScrollCenter;
@property (nonatomic, strong) NSArray *norColorArray;//普通颜色的RGB值
@property (nonatomic, strong) NSArray *selectedColorArray;//选中颜色的RGB值
@property (nonatomic, strong) NSArray *deltaRGBArray;//普通与选中颜色的RGB值差

@end

@implementation MKPageTitleView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray pageViewStyle:(MKPageViewStyle *)pageViewStyle{
    if (self = [super initWithFrame:frame]) {
        self.titleArray = titleArray;
        self.pageViewStyle = pageViewStyle;
        [self setupSubView];
        [self initColorForRGB];
    }
    return self;
}

#pragma mark - 初始化子控件
- (void)setupSubView {
    
    self.scrollView.frame = self.bounds;
    [self addSubview:self.scrollView];
    CGFloat sumW = 0.;
    CGFloat margin = self.pageViewStyle.margin;
    CGFloat contentW = 0.;
    for (NSInteger i = 0; i < self.titleArray.count; i++)  {
        NSString *title = self.titleArray[i];
        CGFloat titleW = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:0 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width + 6 * self.pageViewStyle.scale;
        sumW = sumW + titleW;
        [self.titleWidthArray addObject:[NSString stringWithFormat:@"%f",titleW]];
        UILabel *label = [[UILabel alloc]init];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:15];
        label.userInteractionEnabled = YES;
        label.tag = i;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick:)]];
        if (i == 0) {
            label.textColor = self.pageViewStyle.seletedColor;
            label.transform = CGAffineTransformMakeScale(self.pageViewStyle.scale, self.pageViewStyle.scale);
            self.currentLabel = label;
            self.currentIndex = 0;
        }else {
            label.textColor = self.pageViewStyle.norColor;
        }
        [self.titleLabelArray addObject:label];
    }
    //如果所有的标题长度加上间距小于等于一个屏幕尺寸，则优先铺满这个屏幕，间距自动计算，如果大于，则按照指定的间距展示
    CGFloat tempSumW = sumW + 2 * self.pageViewStyle.leftRinghtMargin + self.pageViewStyle.margin * (self.titleArray.count - 1);
    if (tempSumW <= self.scrollView.frame.size.width) {
        margin = (self.scrollView.frame.size.width - (sumW + 2 * self.pageViewStyle.leftRinghtMargin)) / (self.titleArray.count - 1);
        
        for (NSInteger i = 0; i < self.titleArray.count; i++) {
            UILabel *label = self.titleLabelArray[i];
            CGFloat labelW = [self.titleWidthArray[i] doubleValue];
            CGFloat labelX = 0.;
            if (i == 0) {
                labelX = self.pageViewStyle.leftRinghtMargin;
            }else {
                UILabel *preLabel = self.titleLabelArray[i - 1];
                CGFloat preLabelMaxX = CGRectGetMaxX(preLabel.frame);
                labelX = margin + preLabelMaxX;
            }
            label.frame = CGRectMake(labelX, 0, labelW, self.frame.size.height);
            [self.scrollView addSubview:label];
        }
    }else {
        self.isScrollCenter = YES;
        for (NSInteger i = 0; i < self.titleArray.count; i++) {
            UILabel *label = self.titleLabelArray[i];
            CGFloat labelW = [self.titleWidthArray[i] doubleValue];
            CGFloat labelX = 0.;
            if (i == 0) {
                labelX = self.pageViewStyle.leftRinghtMargin;
            }else {
                UILabel *preLabel = self.titleLabelArray[i - 1];
                CGFloat preLabelMaxX = CGRectGetMaxX(preLabel.frame);
                labelX = margin + preLabelMaxX;
            }
            label.frame = CGRectMake(labelX, 0, labelW, self.frame.size.height);
            [self.scrollView addSubview:label];
            if (i == self.titleArray.count - 1) {
                contentW = CGRectGetMaxX(label.frame) + self.pageViewStyle.leftRinghtMargin;
            }
            self.scrollView.contentSize = CGSizeMake(contentW, 0);
        }
    }
    UILabel *firstLabel = [self.titleLabelArray firstObject];
    self.bottomLineView.frame = CGRectMake(firstLabel.frame.origin.x, self.frame.size.height - self.pageViewStyle.bottomLineH, firstLabel.frame.size.width, self.pageViewStyle.bottomLineH);
    self.bottomLineView.backgroundColor = self.pageViewStyle.seletedColor;
    [self.scrollView addSubview:self.bottomLineView];
}

#pragma mark - 添加点击手势

- (void)labelClick:(UITapGestureRecognizer *)gesture {
    UILabel *newLabel = (UILabel *)gesture.view;
    if (newLabel == self.currentLabel) {
        return;
    }
    //改变颜色和文字大小
    self.currentLabel.textColor = self.pageViewStyle.norColor;
    newLabel.textColor = self.pageViewStyle.seletedColor;
    newLabel.transform = self.currentLabel.transform;
    self.currentLabel.transform = CGAffineTransformIdentity;
    self.currentLabel = newLabel;
    self.currentIndex = newLabel.tag;
    
    //改变底部横线位置
    self.bottomLineView.frame = CGRectMake(newLabel.frame.origin.x, self.frame.size.height - self.pageViewStyle.bottomLineH,newLabel.frame.size.width, self.pageViewStyle.bottomLineH);
    
    if ([self.delegate respondsToSelector:@selector(pageTitleView:clickWithIndex:)]) {
        [self.delegate pageTitleView:self clickWithIndex:self.currentIndex];
    }
}

#pragma mark - 滑动的时候改变颜色， 文字大小和底部横线的位置
- (void)changeTitleViewWithScrollToIndex:(NSInteger)targetIndex progress:(CGFloat)progress {
    if (targetIndex < self.titleLabelArray.count) {
        
        UILabel *newLabel = self.titleLabelArray [targetIndex];
        if (newLabel == self.currentLabel) {//防止滑动的时候没有滑到下一个，弹回的时候，造成当前的label颜色和大小都变成普通状态
            return;
        }
        //颜色渐变
        self.currentLabel.textColor = [UIColor colorWithRed:([self.selectedColorArray[0] doubleValue] - [self.deltaRGBArray[0] doubleValue] * progress) green:([self.selectedColorArray[1] doubleValue] - [self.deltaRGBArray[1] doubleValue] * progress)  blue:([self.selectedColorArray[2] doubleValue] - [self.deltaRGBArray[2] doubleValue] * progress)  alpha:1];
        
        newLabel.textColor = [UIColor colorWithRed:([self.norColorArray[0] doubleValue] + [self.deltaRGBArray[0] doubleValue] * progress)  green:([self.norColorArray[1] doubleValue] + [self.deltaRGBArray[1] doubleValue] * progress)  blue:([self.norColorArray[2] doubleValue] + [self.deltaRGBArray[2] doubleValue] * progress)  alpha:1];
        
        //缩小放大
        self.currentLabel.transform = CGAffineTransformMakeScale(self.pageViewStyle.scale - (self.pageViewStyle.scale - 1) * progress, self.pageViewStyle.scale - (self.pageViewStyle.scale - 1) * progress);
        newLabel.transform = CGAffineTransformMakeScale(1 + (self.pageViewStyle.scale - 1) * progress, 1 + (self.pageViewStyle.scale - 1) * progress);
        
        //底部横线滑动
        CGFloat deltaX = newLabel.frame.origin.x - self.currentLabel.frame.origin.x;
        CGFloat deltaW = newLabel.frame.size.width - self.currentLabel.frame.size.width;
        self.bottomLineView.frame = CGRectMake(self.currentLabel.frame.origin.x + deltaX * progress, self.frame.size.height - self.pageViewStyle.bottomLineH, self.currentLabel.frame.size.width + deltaW * progress, self.pageViewStyle.bottomLineH);
        
    }
}

#pragma mark - 初始化普通，选中的颜色的RGB值，以及之间的差值
- (void)initColorForRGB{
    self.norColorArray = [self getRGBWithColor:self.pageViewStyle.norColor];
    self.selectedColorArray = [self getRGBWithColor:self.pageViewStyle.seletedColor];
    
    self.deltaRGBArray = @[@([self.selectedColorArray[0] doubleValue] - [self.norColorArray[0] doubleValue]),@([self.selectedColorArray[1] doubleValue] - [self.norColorArray[1] doubleValue]),@([self.selectedColorArray[2] doubleValue] - [self.norColorArray[2] doubleValue])];
}

#pragma mark - 获取颜色的RBG值
- (NSArray *)getRGBWithColor:(UIColor *)color {
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}


#pragma mark - 改变选中Label的颜色的位置

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (self.currentIndex == currentIndex){
        return;
    }
    _currentIndex = currentIndex;
    if (currentIndex < self.titleArray.count){
        UILabel *newLabel = self.titleLabelArray[currentIndex];
        self.currentLabel.textColor = self.pageViewStyle.norColor;
        self.currentLabel.transform = CGAffineTransformIdentity;
        newLabel.textColor = self.pageViewStyle.seletedColor;
        newLabel.transform = CGAffineTransformMakeScale(self.pageViewStyle.scale, self.pageViewStyle.scale);
        self.currentLabel = newLabel;
        if (self.isScrollCenter){
            CGFloat offsetX = self.currentLabel.center.x - self.scrollView.bounds.size.width * 0.5;
            //如果label的中心点小于屏幕中心点，则不滚动
            if (offsetX < 0) {
                offsetX = 0;
            }
            //scrollView滚动的最大距离
            CGFloat maxOffset = self.scrollView.contentSize.width - self.bounds.size.width;
            //如果label的中心点与屏幕中心点的距离大于scrollView滚动的最大距离，则滚动为scrollView滚动的最大距离
            if (offsetX > maxOffset) {
                offsetX = maxOffset;
            }
            [self.scrollView setContentOffset:CGPointMake(offsetX, 0)];
        }
    }
}

#pragma mark - 属性
- (NSMutableArray *)titleLabelArray {
    if (!_titleLabelArray) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}

- (NSMutableArray *)titleWidthArray {
    if (!_titleWidthArray) {
        _titleWidthArray = [NSMutableArray array];
    }
    return _titleWidthArray;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
    }
    return _bottomLineView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView){
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        //        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor purpleColor];
    }
    return _scrollView;
}

@end
