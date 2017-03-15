//
//  MeController.m
//  CustomPresentViewController
//
//  Created by 大家保 on 2017/3/15.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "MeController.h"
#import "ImageViewCell.h"
#import "AppDelegate.h"
#import "TestController.h"
#define SCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height

static NSString *const indentifier=@"cell";

@interface MeController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    UIButton *leftButtom=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [leftButtom setImage:[UIImage imageNamed:@"会员头像"] forState:0];
    [leftButtom addTarget:self action:@selector(openLeftVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButtom];
    
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    self.myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.001, 0.001)];
    self.myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.001, 0.001)];
    [self.myTableView registerClass:[ImageViewCell class] forCellReuseIdentifier:indentifier];
}

- (void)openLeftVC{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([tempAppDelegate.LeftSlideVC closed]) {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }else{
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}

#pragma mark tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDTH*394/580.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    cell.iconImageView.image=[UIImage imageNamed:@"美女2.jpg"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}

#pragma mark tableviewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TestController *testVC=[[TestController alloc]init];
    testVC.hidesBottomBarWhenPushed=YES;
    testVC.titleString=@"我";
    [self.navigationController pushViewController:testVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
