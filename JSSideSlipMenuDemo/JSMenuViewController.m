//
//  ViewController.m
//  JSSideSlipMenuDemo
//
//  Created by drision on 2017/1/16.
//  Copyright © 2017年 drision. All rights reserved.
//

#import "JSMenuViewController.h"

@interface JSMenuViewController ()

@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation JSMenuViewController

static CGFloat const duration = 0.2;
static NSInteger const originalTag = 1000;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 0;
    self.leftWidth = 250;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - set
- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    for (int i = 0;i < _viewControllers.count;i++) {
        UIViewController *vc = _viewControllers[i];
        vc.view.tag = i + originalTag;
        if (0 == i) continue;
        CGRect frame = vc.view.frame;
        frame.origin.x += self.leftWidth;
        vc.view.frame = frame;
    }
    UIViewController *firstVC = [_viewControllers firstObject];
    [self addChildViewController:firstVC];
    [self.view addSubview:firstVC.view];
    [firstVC didMoveToParentViewController:self];
    self.currentViewController = firstVC;
    [self addPanTap];
}

#pragma mark - IBAction
- (void)setIsSideSlip:(BOOL)isSideSlip {
    _isSideSlip = isSideSlip;
    if (_isSideSlip) {
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = self.currentViewController.view.frame;
            frame.origin.x += self.leftWidth;
            self.currentViewController.view.frame = frame;
        } completion:^(BOOL finished) {
            if (finished)
                _isSideSlip = NO;
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = self.currentViewController.view.frame;
            frame.origin.x -= self.leftWidth;
            self.currentViewController.view.frame = frame;
        } completion:^(BOOL finished) {
            if (finished)
                _isSideSlip = YES;
        }];
    }
}

#pragma mark - private
- (void)addPanTap {
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftSlip:)];
    [self.currentViewController.view addGestureRecognizer:panGR];
}

- (void)leftSlip:(UIPanGestureRecognizer *)panGR {
    CGPoint point = [panGR translationInView:self.view];
//    NSLog(@"point.x = %f, point.y = %f", point.x, point.y);
    CGFloat offsetX = point.x;//每次拖动的偏移量
    UIView *slipView = panGR.view;
    CGPoint slipViewPoint = slipView.center;
    slipViewPoint.x += offsetX;
//    NSLog(@"slipViewPoint.x = %f, slipViewPoint.y = %f", slipViewPoint.x, slipViewPoint.y);
    CGFloat realOffset = slipViewPoint.x - self.view.center.x;//实际偏移量
    if (panGR.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"拖动结束");
        //拖动超过一半，则出现
        if (realOffset > self.leftWidth/2) {
            [UIView animateWithDuration:duration animations:^{
                slipView.center = CGPointMake(self.view.center.x + self.leftWidth, slipViewPoint.y);
            }];
            _isSideSlip = YES;
        } else {
            [UIView animateWithDuration:duration animations:^{
                slipView.center = CGPointMake(self.view.center.x, slipViewPoint.y);
            }];
        }
        [panGR setTranslation:CGPointMake(0, 0) inView:self.view];
        return;
    }
    //最大偏移量
    if (realOffset >= self.leftWidth) {
        slipView.center = CGPointMake(self.view.center.x + self.leftWidth, slipViewPoint.y);
    } else {
        slipView.center = slipViewPoint;
    }
    
    [panGR setTranslation:CGPointMake(0, 0) inView:self.view];
}

#pragma mark - public
- (void)changeVCWithIndex:(NSInteger)index {
    if (index >= self.viewControllers.count) {
        NSLog(@"你所切换的vc超出设置的数量");
        return;
    }
    self.currentIndex = index;
    //点击也就是当前页，不做处理，直接隐藏菜单
    if (index + originalTag == self.currentViewController.view.tag) {
        self.isSideSlip = NO;
        return;
    }
    UIViewController *newVC = self.viewControllers[index];
    UIViewController *oldVC = self.currentViewController;
    [self addChildViewController:newVC];
    [self transitionFromViewController:oldVC toViewController:newVC duration:duration options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newVC didMoveToParentViewController:self];
            [oldVC didMoveToParentViewController:nil];
            [oldVC removeFromParentViewController];
            self.currentViewController = newVC;
            self.isSideSlip = NO;
            [self addPanTap];
        } else {
            self.currentViewController = oldVC;
        }
    }];
}

@end
