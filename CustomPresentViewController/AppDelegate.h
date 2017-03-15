//
//  AppDelegate.h
//  CustomPresentViewController
//
//  Created by 大家保 on 2017/3/14.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//侧滑控制器
@property (nonatomic,strong) LeftSlideViewController *LeftSlideVC;

//主视图
@property (nonatomic,strong) UITabBarController *mainTabBarController;


@end

