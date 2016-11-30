//
//  CCScrollTitleViewContainerLikeUC.m
//  testScroll
//
//  Created by L on 2016/11/24.
//  Copyright © 2016年 L. All rights reserved.
//

#import "CCScrollTitleViewContainerLikeUC.h"

#define titleLenght 50
#define slideOriginLenght 10

@interface CCScrollTitleViewContainerLikeUC ()

/*
 * 保持需要显示的标题
 */
@property (nonnull, nonatomic, strong) NSArray<NSString *> *titles;

/*
 * 标题控件
 */
@property (nonnull, nonatomic, strong) NSMutableArray<UILabel *> *titlesL;

/*
 * 下面的滑动展示视图
 */
@property (nonnull, nonatomic, strong) UIView *slideV;

/*
 * 设置当前位置
 */
@property (nonatomic, assign) NSInteger currentIndex;

/*
 * 点击title的操作
 */
@property (nonatomic, copy) void(^didSelctAction)(NSInteger index);

@end

@implementation CCScrollTitleViewContainerLikeUC
{
    // 正常状态下的frame
    CGRect normaFrame;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles didSelect:(void (^)(NSInteger))didSelect {
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, titles.count * titleLenght, frame.size.height)]) {
        self.titles = titles;
        self.titlesL = @[].mutableCopy;
        self.didSelctAction = didSelect;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    for (int i = 0; i < self.titles.count; i++) {
        UILabel *l = [[UILabel alloc] init];
        l.bounds = (CGRect){0, 0, titleLenght, self.bounds.size.height};
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.titles[i] attributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont systemFontOfSize:36/2]}];
        l.attributedText = attrStr;
        l.textAlignment = NSTextAlignmentCenter;
        [self addSubview:l];
        [self.titlesL addObject:l];
        
        l.center = (CGPoint){titleLenght / 2 + titleLenght * i, self.bounds.size.height / 2};
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        l.userInteractionEnabled = YES;
        [l addGestureRecognizer:tap];
    }
    
    self.slideV = [[UIView alloc] init];
    self.slideV.bounds = (CGRect){0, 0, slideOriginLenght, 2};
    self.slideV.backgroundColor = [UIColor orangeColor];
    self.slideV.layer.cornerRadius = 1;
    self.slideV.layer.masksToBounds = YES;
    [self addSubview:self.slideV];
    self.slideV.center = (CGPoint){titleLenght / 2, self.bounds.size.height - (2 + 2)/2};
    
    normaFrame = self.slideV.frame;
    self.currentIndex = 0;
}

#pragma mark animation
- (void)didScrollWitchContentOffsetX:(CGFloat)offsetX scrollWidth:(CGFloat)width {
    // 1: 获取当前分段中滑动的百分比
    CGFloat progress = (offsetX - self.currentIndex * width) / width;
    
    // 2: 当前段中的处理
    CGRect newFrame = CGRectZero;
    
    // 分两段处理，小于0.5的拉升，大于等于0.5的收缩
    if (0 < progress && progress < 0.5) {
        // 2.1: 拉升
        CGFloat strechLength = progress / 0.5 * titleLenght;
        newFrame = (CGRect){normaFrame.origin.x, normaFrame.origin.y, normaFrame.size.width + strechLength, normaFrame.size.height};
    } else if(progress >= 0.5 && progress != 1) {
        // 2.2: 收缩
        CGFloat shrinkLength = (progress - 0.5) / 0.5 * titleLenght;
        newFrame = (CGRect){normaFrame.origin.x + shrinkLength, normaFrame.origin.y, normaFrame.size.width + titleLenght - shrinkLength, normaFrame.size.height};
    } else if (-0.5 < progress && progress < 0) {
        // 2.3: 拉升
        CGFloat strechLength = -progress / 0.5 * titleLenght;
        newFrame = (CGRect){normaFrame.origin.x - strechLength, normaFrame.origin.y, normaFrame.size.width + strechLength, normaFrame.size.height};
    } else if (-1.0 < progress && progress <= 0.5) {
        // 2.4: 收缩
        CGFloat shrinkLength = -(progress + 0.5) / 0.5 * titleLenght;
        newFrame = (CGRect){normaFrame.origin.x -  ((self.currentIndex == 0) ? 0 : titleLenght), normaFrame.origin.y, normaFrame.size.width  + titleLenght - shrinkLength, normaFrame.size.height};
    }
    
    // 更新当前的位置
    self.slideV.frame = newFrame;
    
    // 3: 每段的时候更新初始位置
    NSInteger indexNow = offsetX / width;
    CGFloat progressValue = offsetX - indexNow * width;
    if (progressValue == 0) {
        self.currentIndex = offsetX / width;
        
        self.slideV.bounds = (CGRect){0, 0, slideOriginLenght, 2};
        self.slideV.center = (CGPoint){titleLenght / 2 + titleLenght * self.currentIndex, self.bounds.size.height - (2 + 2)/2};
        normaFrame = self.slideV.frame;
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    for (int i = 0; i < self.titlesL.count; i++) {
        UILabel *l = self.titlesL[i];
        if (i == currentIndex) {
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.titles[i] attributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont systemFontOfSize:36/2]}];
            l.attributedText = attrStr;
        } else {
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.titles[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.8], NSFontAttributeName:[UIFont systemFontOfSize:36/2]}];
            l.attributedText = attrStr;
        }
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    for (int i = 0; i < self.titlesL.count; i++) {
        UILabel *l = self.titlesL[i];
        if (l == tapGesture.self.view) {
            self.currentIndex = i;
            break;
        }
    }
    
    self.slideV.center = (CGPoint){titleLenght / 2 + titleLenght * self.currentIndex, self.bounds.size.height - (2 + 2)/2};
    
    if (self.didSelctAction) {
        self.didSelctAction(self.currentIndex);
    }
}
@end
