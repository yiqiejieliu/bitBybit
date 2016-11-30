//
//  CCScrollTitleViewContainerLikeUC.h
//  testScroll
//
//  Created by L on 2016/11/24.
//  Copyright © 2016年 L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCScrollTitleViewContainerLikeUC : UIView

/*
 * 设置标题
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles didSelect:(void(^)(NSInteger index))didSelect;

/*
 * 滑动的信息
 */
- (void)didScrollWitchContentOffsetX:(CGFloat)offsetX scrollWidth:(CGFloat)width;

@end
