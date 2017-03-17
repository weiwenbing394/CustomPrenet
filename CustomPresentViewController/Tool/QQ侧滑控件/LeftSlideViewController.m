//
//  LeftSlideViewController.m
//  CustomPresentViewController
//
//  Created by 大家保 on 2017/3/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "LeftSlideViewController.h"
#import "UIView_extra.h"

@interface LeftSlideViewController ()<UIGestureRecognizerDelegate>{
    //实时横向位移
    CGFloat _scalef;
}

//左侧蒙版view
@property (nonatomic,strong) UIView *contentView;

//左侧需要发生形变的tableview
@property (nonatomic,strong) UITableView *leftTableview;

@end

@implementation LeftSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 @brief 初始化侧滑控制器
 @param leftVC 右视图控制器
 mainVC 中间视图控制器
 @result instancetype 初始化生成的对象
 */
- (instancetype)initWithLeftView:(UIViewController *)leftVC andMainView:(UIViewController *)mainVC{
    if (self=[super init]) {
        self.speedf=vSpeedFloat;
        self.leftVC=leftVC;
        self.mainVC=mainVC;
        
        //左侧蒙版
        UIView *view=[[UIView alloc]init];
        view.frame=self.leftVC.view.bounds;
        view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.contentView=view;
        [self.leftVC.view addSubview:view];
        
        //获取左侧的tableView
        for (UIView *obj in self.leftVC.view.subviews) {
            if ([obj isKindOfClass:[UITableView class]]) {
                self.leftTableview=(UITableView *)obj;
            }
        }
        
        //设置左侧tableview的初始位置和缩放系数
        self.leftTableview.backgroundColor=[UIColor clearColor];
        self.leftTableview.frame=CGRectMake(0, 0, kScreenWidth-kMainPageDistance, kScreenHeight);
        self.leftTableview.transform=CGAffineTransformMakeScale(kLeftScale, kLeftScale);
        self.leftTableview.center=CGPointMake(kLeftCenterX, kScreenHeight*0.5);
        
        [self.view addSubview:self.leftVC.view];
        [self.view addSubview:self.mainVC.view];
        //初始时侧滑关闭
        self.closed=YES;
        
        NSLog(@"侧滑控制器创建了");
    }
    return self;
};

//设置手势类型
- (void)setPantype:(PanType)pantype{
    _pantype=pantype;
    //滑动手势
    if (pantype==typeWithCenter) {
        self.pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    }else{
        self.pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanWithOrigin:)];
    }
    self.pan.delegate=self;
    [self.pan setCancelsTouchesInView:YES];
    [self.mainVC.view addGestureRecognizer:self.pan];
}

#pragma mark - 滑动手势 （第一种实现）
//滑动手势（第一种实现）
- (void) handlePan: (UIPanGestureRecognizer *)rec{
    
    CGPoint point=[rec translationInView:self.view];
    _scalef=(point.x*self.speedf+_scalef);
    
    //是否跟随手指移动
    BOOL needMoveWithTap=YES;
    //超过边界值
    if (((self.mainVC.view.x <= 0) && (_scalef <= 0)) || ((self.mainVC.view.x >= (kScreenWidth - kMainPageDistance )) && (_scalef >= 0))) {
        _scalef=0;
        needMoveWithTap=NO;
    }
    //边界值内
    if (needMoveWithTap && (rec.view.frame.origin.x >= 0) && (rec.view.frame.origin.x <= (kScreenWidth - kMainPageDistance))) {
        
        CGFloat  recCenterX=rec.view.center.x+point.x*self.speedf;
        if (recCenterX<kScreenWidth*0.5-2) {
            recCenterX=kScreenWidth*0.5;
        }
        CGFloat recCenterY = rec.view.center.y;
        rec.view.center=CGPointMake(recCenterX, recCenterY);
        
        //右界面
        CGFloat scale=1-(1-kMainPageScale)*(rec.view.frame.origin.x/(kScreenWidth-kMainPageDistance));
        rec.view.transform=CGAffineTransformScale(CGAffineTransformIdentity,scale, scale);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        
        //左侧界面
        CGFloat leftTabCenterX=kLeftCenterX+((kScreenWidth-kMainPageDistance)*0.5-kLeftCenterX)*(rec.view.frame.origin.x/(kScreenWidth-kMainPageDistance));
        CGFloat leftScale=kLeftScale+(1-kLeftScale)*(rec.view.frame.origin.x/(kScreenWidth-kMainPageDistance));
        self.leftTableview.center=CGPointMake(leftTabCenterX, kScreenHeight*0.5);
        self.leftTableview.transform=CGAffineTransformScale(CGAffineTransformIdentity, leftScale, leftScale);
        
        //蒙版
        CGFloat tempAlpha=kLeftAlpha-kLeftAlpha*(rec.view.frame.origin.x/(kScreenWidth-kMainPageDistance));
        self.contentView.alpha=tempAlpha;
    }else{
        
        if (self.mainVC.view.x<0) {
            [self closeLeftView];
        }else if (self.mainVC.view.x>(kScreenWidth-kMainPageDistance)){
            [self openLeftView];
        }
    }
    
    //手势结束后，手势超出一半的向多出的一半偏移
    if (rec.state==UIGestureRecognizerStateEnded) {
        if (fabs(_scalef)>vCouldChangeDeckStateDistance) {
            if (self.closed) {
                [self openLeftView];
            }else{
                [self closeLeftView];
            }
        }else{
            if (self.closed) {
                [self closeLeftView];
            }else{
                [self openLeftView];
            }
        }
    }
}

#pragma mark - 滑动手势 （第二种实现）
- (void) handlePanWithOrigin: (UIPanGestureRecognizer *)rec{

    CGPoint point = [rec translationInView:self.view];
    _scalef=(point.x+_scalef);
    //根据视图位置判断是左滑还是右边滑动
    if ( rec.view.x >= 0 && (rec.view.x <=(kScreenWidth - kMainPageDistance))){
        CGFloat pointX =_scalef;
        if (pointX >=(kScreenWidth-kMainPageDistance) ) {
            pointX = (kScreenWidth-kMainPageDistance);
        }
        if (pointX <=0) {
            pointX =0;
        }
        rec.view.x=pointX;
        //右界面
        CGFloat scale=1-(1-kMainPageScale)*(rec.view.x/(kScreenWidth-kMainPageDistance));
        rec.view.transform=CGAffineTransformScale(CGAffineTransformIdentity,scale, scale);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        //左侧界面
        CGFloat leftTabCenterX=kLeftCenterX+((kScreenWidth-kMainPageDistance)*0.5-kLeftCenterX)*(rec.view.x/(kScreenWidth-kMainPageDistance));
        CGFloat leftScale=kLeftScale+(1-kLeftScale)*(rec.view.x/(kScreenWidth-kMainPageDistance));
        self.leftTableview.center=CGPointMake(leftTabCenterX, kScreenHeight*0.5);
        self.leftTableview.transform=CGAffineTransformScale(CGAffineTransformIdentity, leftScale, leftScale);
        //蒙版
        CGFloat tempAlpha=kLeftAlpha-kLeftAlpha*(rec.view.x/(kScreenWidth-kMainPageDistance));
        self.contentView.alpha=tempAlpha;
        
    }
    //手势结束后，手势超出一半的向多出的一半偏移
    if (rec.state==UIGestureRecognizerStateEnded) {
        if (rec.view.x>= (kScreenWidth-kMainPageDistance)/2.0){
            [self openLeftView];
        }else{
            [self closeLeftView];
        }
    }
}


/**
 @brief 关闭左视图
 */
- (void)closeLeftView{
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.mainVC.view.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    self.closed = YES;
    _scalef=0;
    if (self.pantype==typeWithOriginX) {
        self.mainVC.view.x=0;
    }
    
    self.leftTableview.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
    self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
    self.contentView.alpha = kLeftAlpha;
    
    [UIView commitAnimations];
    [self removeSingleTap];
}


/**
 @brief 打开左视图
 */
- (void)openLeftView{
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform=CGAffineTransformScale(CGAffineTransformIdentity, kMainPageScale, kMainPageScale);
    self.mainVC.view.center=kMainPageCenter;
    self.closed=NO;
    if (self.pantype==typeWithOriginX) {
        _scalef=kScreenWidth-kMainPageDistance;
        self.mainVC.view.x=kScreenWidth-kMainPageDistance;
    }else{
        _scalef=0;
    }
    
    self.leftTableview.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    self.leftTableview.center=CGPointMake((kScreenWidth-kMainPageDistance)*0.5, kScreenHeight*0.5);
    self.contentView.alpha=0;
    [UIView commitAnimations];
    [self disableTapButton];
};

#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    if (!self.closed&&(tap.state==UIGestureRecognizerStateEnded)) {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform=CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        tap.view.center=CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
        self.closed=YES;
        _scalef=0;
        if (self.pantype==typeWithOriginX) {
            self.mainVC.view.x=0;
        }
        
        self.leftTableview.transform=CGAffineTransformScale(CGAffineTransformIdentity, kLeftScale, kLeftScale);
        self.leftTableview.center=CGPointMake(kLeftCenterX, kScreenHeight*0.5);
        self.contentView.alpha=kLeftAlpha;
        [UIView commitAnimations];
        [self removeSingleTap];
    }
}


//关闭行为收敛
- (void) removeSingleTap{
    for (UIButton *tempButton in [self.mainVC.view  subviews]){
        [tempButton setUserInteractionEnabled:YES];
    }
    [self.mainVC.view removeGestureRecognizer:self.sideslipTapGes];
    self.sideslipTapGes = nil;
}

/**
 @brief 添加主界面的点击事件
 */
- (void)disableTapButton{
    for (UIButton *tempButtom in [self.mainVC.view subviews]) {
        [tempButtom setUserInteractionEnabled:NO];
    }
    if (!self.sideslipTapGes) {
        self.sideslipTapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
        [self.sideslipTapGes setNumberOfTapsRequired:1];
        [self.mainVC.view addGestureRecognizer:self.sideslipTapGes];
        //点击事件盖住其它响应事件,但盖不住Button;
        self.sideslipTapGes.cancelsTouchesInView=YES;
    }
}


/**
 *  设置滑动开关是否开启
 *
 *  @param enabled YES:支持滑动手势，NO:不支持滑动手势
 */
- (void)setPanEnabled: (BOOL) enabled{
    [self.pan setEnabled:enabled];
};


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    NSLog(@"侧滑控制器释放了");
}

@end
