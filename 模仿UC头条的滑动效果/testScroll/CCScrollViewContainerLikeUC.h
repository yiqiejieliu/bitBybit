//
//  CCScrollViewContainerLikeUC.h
//  testScroll
//
//  Created by L on 2016/11/24.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCScrollViewContainerLikeUC : UIView

/*
 * 对象创建
 */
- (instancetype)initWithFrame:(CGRect)frame views:(NSArray<UIView *> *)views withBlock:(void(^)(CGFloat progress, CGFloat width))progress;

/*
 * 设置当前显示的index
 */
@property (nonatomic, assign) NSInteger currentIndex;

@end
