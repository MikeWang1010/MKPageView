//
//  MKPageContentView.m
//  MKPageView
//
//  Created by MikeWang on 2017/7/12.
//  Copyright © 2017年 MikeWang. All rights reserved.
//
#define kCellId  @"CellId"

#import "MKPageContentView.h"

@interface MKPageContentView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *controllerArray;
@property (nonatomic, strong) UIViewController *superVc;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat starOffsetx;

@end

@implementation MKPageContentView

- (instancetype)initWithFrame:(CGRect)frame controllerArray:(NSArray *)controllerArray parentVc:(UIViewController *)superVc {
    if (self = [super initWithFrame:frame]) {
        self.controllerArray = controllerArray;
        self.superVc = superVc;
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView {
    [self addSubview:self.collectionView];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.controllerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    UIViewController *vc = self.controllerArray [indexPath.row];
    [self.superVc addChildViewController:vc];
    vc.view.frame = cell.bounds;
    [cell.contentView addSubview:vc.view];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

#pragma mark - scrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.starOffsetx = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.starOffsetx != scrollView.contentOffset.x) {
        NSInteger sourceIndex = self.currentIndex;
        self.currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        if ([self.delegate respondsToSelector:@selector(pageContentViewScrollFrom:to:)]) {
            [self.delegate pageContentViewScrollFrom:sourceIndex to:self.currentIndex];
        }
        NSLog(@"currentIndex:%ld",self.currentIndex);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat progress = 0.;
    NSInteger index = 0;
    if (offsetX > self.starOffsetx){
        index =  (self.starOffsetx / scrollView.bounds.size.width) + 1;
        if (index >= self.controllerArray.count) {
            index = self.controllerArray.count - 1;
        }
        progress = (offsetX - self.starOffsetx) / scrollView.bounds.size.width;
    }else {
        index = (self.starOffsetx / scrollView.bounds.size.width) - 1;
        if (index < 0) {
            index = 0;
        }
        progress = (self.starOffsetx - offsetX ) / scrollView.bounds.size.width;
    }

    NSLog(@"targetIndex:%ld  progress:%f",index,progress);
    if (progress < 1.) {
        if ([self.delegate respondsToSelector:@selector(pageContentViewScrollTo:progress:)]) {
            [self.delegate pageContentViewScrollTo:index progress:progress];
        }
    }
}


#pragma mark - 属性

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    CGFloat offsetX = self.collectionView.bounds.size.width * currentIndex;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0.;
        layout.minimumInteritemSpacing = 0.;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellId];
    }
    return  _collectionView;
}
@end
