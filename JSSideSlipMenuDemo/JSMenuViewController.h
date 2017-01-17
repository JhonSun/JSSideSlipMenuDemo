//
//  ViewController.h
//  JSSideSlipMenuDemo
//
//  Created by drision on 2017/1/16.
//  Copyright © 2017年 drision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSMenuViewController : UIViewController

@property (nonatomic, assign) CGFloat leftWidth;//菜单栏宽度,需在添加控制前之前设置
@property (nonatomic, copy) NSArray *viewControllers;//子控制器
@property (nonatomic, assign) BOOL isSideSlip;//控制显示还是隐藏

- (void)changeVCWithIndex:(NSInteger)index;//切换控制器

@end

