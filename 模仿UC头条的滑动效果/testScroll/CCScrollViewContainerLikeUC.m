//
//  CCScrollViewContainerLikeUC.m
//  testScroll
//
//  Created by L on 2016/11/24.
//  Copyright © 2016年 L. All rights reserved.
//

#import "CCScrollViewContainerLikeUC.h"

#define scrollViewPageExternSize 5

@interface CCScrollViewContainerLikeUC () <UIScrollViewDelegate>

/*
 * 滑动的子元素
 */
@property (nonnull, nonatomic, strong) NSArray<UIView *> *elementsV;

/*
 * 滑动的scrollView
 */
@property (nonnull, nonatomic, strong) UIScrollView *scrollV;

/*
 * 各个视图的center
 */
@property (nonnull, nonatomic, strong) NSMutableArray<NSValue *> *elementCenter;

/*
 * 回调
 */
@property (nonatomic, copy) void(^progress)(CGFloat offsetX, CGFloat width);

@end

@implementation CCScrollViewContainerLikeUC
{
    CGFloat contentOffsetBefore;
}

- (instancetype)initWithFrame:(CGRect)frame views:(NSArray<UIView *> *)views withBlock:(void (^)(CGFloat, CGFloat))progress {
    if (self = [super initWithFrame:frame]) {
        self.progress = progress;
        [self setupViews:views];
    }
    return self;
}

- (void)setupViews:(NSArray<UIView *> *)views {
    self.elementsV = views;
    self.elementCenter = [NSMutableArray arrayWithCapacity:views.count];
    [self setupScrollV:views.count];
    for (int i = 0; i < views.count; i++) {
        UIView *v = [UIView new];
        v.bounds = self.bounds;
        [self.scrollV addSubview:v];
        
        v.center = (CGPoint){i * self.scrollV.bounds.size.width + self.scrollV.bounds.size.width / 2, self.bounds.size.height / 2};
        v.clipsToBounds = YES;
        
        UIView *showV = views[i];
        [v addSubview:showV];
        showV.bounds = v.bounds;
        if (i == 0) {
            showV.center = (CGPoint){v.bounds.size.width / 2, v.bounds.size.height / 2};
        } else {
            showV.center = (CGPoint){0, v.bounds.size.height / 2};
        }
        
        [self.elementCenter addObject:[NSValue valueWithCGPoint:showV.center]];
    }
}

- (void)setupScrollV:(NSInteger)elementCount {
    self.scrollV = [[UIScrollView alloc] initWithFrame:(CGRect){-scrollViewPageExternSize, 0, self.bounds.size.width + 2 * scrollViewPageExternSize, self.bounds.size.height}];
    [self addSubview:self.scrollV];
    
    self.scrollV.pagingEnabled = YES;
    self.scrollV.contentSize = (CGSize){self.scrollV.frame.size.width * elementCount, self.scrollV.frame.size.height};
    self.scrollV.delegate = self;
    self.scrollV.showsHorizontalScrollIndicator = NO;
}

#pragma mark

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.progress) {
        self.progress(scrollView.contentOffset.x, scrollView.bounds.size.width);
    }
    
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    if ([self isReachedPagedOffset:scrollView.contentOffset.x]) {
        for (int i = 0; i < self.elementsV.count; i++) {
            UIView *showV = self.elementsV[i];
            if (index == i) {
                showV.center = [self.elementCenter[0] CGPointValue];
            }
        }
    } else {
        CGFloat offset = scrollView.contentOffset.x - contentOffsetBefore;
        contentOffsetBefore = scrollView.contentOffset.x;
        CGFloat scale = (self.bounds.size.width/2) / scrollView.bounds.size.width;
        UIView *firstV = self.elementsV[index];
        firstV.center = CGPointMake(firstV.center.x + offset * scale, firstV.center.y);
        if (index + 1 <= self.elementsV.count - 1) {
            UIView *nextV = self.elementsV[index + 1];
            nextV.center = CGPointMake(nextV.center.x + offset * scale, nextV.center.y);
        }
    }
}

- (BOOL)isReachedPagedOffset:(CGFloat)offset {
    for (int i = 0; i < self.elementsV.count; i++) {
        if (offset == i * self.scrollV.bounds.size.width) {
            _currentIndex = i;
            return YES;
        }
    }
    
    return NO;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    currentIndex = MAX(MIN(currentIndex, self.elementsV.count - 1), 0);
    _currentIndex = currentIndex;
    contentOffsetBefore = self.scrollV.bounds.size.width * currentIndex;
    [self.scrollV setContentOffset:(CGPoint){self.scrollV.bounds.size.width * currentIndex, 0} animated:NO];
    
    for (int i = 0; i < self.elementsV.count; i++) {
        UIView *v = self.elementsV[i];
        if (i == currentIndex) {
            v.center = (CGPoint){v.bounds.size.width / 2, v.bounds.size.height / 2};
        } else if (i < currentIndex){
            v.center = (CGPoint){v.bounds.size.width, v.bounds.size.height / 2};
        } else if (i > currentIndex) {
            v.center = (CGPoint){0, v.bounds.size.height / 2};
        }
    }
}
@end
