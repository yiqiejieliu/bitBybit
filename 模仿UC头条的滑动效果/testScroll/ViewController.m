//
//  ViewController.m
//  testScroll
//
//  Created by L on 2016/11/24.
//  Copyright © 2016年 L. All rights reserved.
//

#import "ViewController.h"
#import "CCScrollViewContainerLikeUC.h"
#import "CCScrollTitleViewContainerLikeUC.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, nonnull, strong) CCScrollViewContainerLikeUC *scrollViewContainer;
@property (nonatomic, nonnull, strong) CCScrollTitleViewContainerLikeUC *titleContainer;

@end

@implementation ViewController
{
    CGFloat contentOffsetBefore;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    __weak typeof(self) weakSelf = self;
    self.titleContainer = [[CCScrollTitleViewContainerLikeUC alloc] initWithFrame:CGRectMake(0, 0, 0, 44) titles:@[@"12", @"11", @"2", @"23", @"45"] didSelect:^(NSInteger index) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.scrollViewContainer.currentIndex = index;
    }];
    self.navigationItem.titleView = self.titleContainer;
    
    UIImageView *imagV1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"12.png"]];
    UIImageView *imagV2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"11.png"]];
    UIImageView *imagV3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.jpg"]];
    UIImageView *imagV4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"23.png"]];
    UIImageView *imagV5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"45.png"]];

    self.scrollViewContainer = [[CCScrollViewContainerLikeUC alloc] initWithFrame:self.view.bounds views:@[imagV1, imagV2, imagV3, imagV4, imagV5] withBlock:^(CGFloat offsetX, CGFloat scrollWidth) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.titleContainer didScrollWitchContentOffsetX:offsetX scrollWidth:scrollWidth];
    }];
    [self.view addSubview:self.scrollViewContainer];
}

@end
