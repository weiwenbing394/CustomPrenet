//
//  LeftSlideViewController.h
//  CustomPresentViewController
//
//  Created by 大家保 on 2017/3/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenSize           [[UIScreen mainScreen] bounds].size

#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width

#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height

//打开左侧窗时,右视图露出的宽度
#define kMainPageDistance     100

//打开左侧窗时，右视图缩放比例（小于1的话会有缩放效果，建议0.8）
#define kMainPageScale        1

//打开左侧窗时，右视图中心点  （第一种手势判断需要使用）
#define kMainPageCenter       CGPointMake(kScreenWidth- kMainPageDistance + kScreenWidth * kMainPageScale / 2.0 , kScreenHeight / 2)

//滑动距离大于此数时，状态改变（关-->开，或者开-->关）（第一种手势判断需要使用）
#define vCouldChangeDeckStateDistance    (kScreenWidth - kMainPageDistance)/ 2.0 - 40

//滑动速度 （第一种手势判断需要使用）
#define vSpeedFloat           0.7

//左侧蒙版的最大值
#define kLeftAlpha            0.9

//左侧初始偏移量
#define kLeftCenterX          30

//左侧初始缩放比例（小于1的话会有缩放效果，建议0.7）
#define kLeftScale           1

//手势类型
typedef NS_ENUM(NSInteger , PanType){
    typeWithCenter,
    typeWithOriginX
};

@interface LeftSlideViewController : UIViewController

//滑动速度系数-建议在0.5-1之间。默认为0.7
@property (nonatomic, assign) CGFloat speedf;

//左侧窗控制器
@property (nonatomic, strong) UIViewController *leftVC;

//中间（主）控制器
@property (nonatomic,strong) UIViewController *mainVC;
//滑动手势控制器

@property (nonatomic, strong)UIPanGestureRecognizer *pan;
//点击手势控制器，是否允许点击视图恢复视图位置。默认为yes
@property (nonatomic, strong) UITapGestureRecognizer *sideslipTapGes;

//侧滑窗是否关闭(关闭时显示为主页)
@property (nonatomic, assign) BOOL closed;

//手势类型
@property (nonatomic, assign) PanType pantype;

/**
 @brief 初始化侧滑控制器
 @param leftVC 右视图控制器
 mainVC 中间视图控制器
 @result instancetype 初始化生成的对象
 */
- (instancetype)initWithLeftView:(UIViewController *)leftVC andMainView:(UIViewController *)mainVC;

/**
 @brief 关闭左视图
 */
- (void)closeLeftView;


/**
 @brief 打开左视图
 */
- (void)openLeftView;

/**
 *  设置滑动开关是否开启
 *
 *  @param enabled YES:支持滑动手势，NO:不支持滑动手势
 */
- (void)setPanEnabled: (BOOL) enabled;

@end
