//
//  ViewController.m
//  CustomPresentViewController
//
//  Created by 大家保 on 2017/3/14.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewCell.h"
#import "DetailViewController.h"



static NSString *const indentifier=@"cell";
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *leftButtom=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [leftButtom setImage:[UIImage imageNamed:@"会员头像"] forState:0];
    [leftButtom addTarget:self action:@selector(openLeftVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButtom];
    
    
    self.myTableView= [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.myTableView.dataSource = self;
    self.myTableView.delegate  = self;
    [self.view addSubview:self.myTableView];
    [self.myTableView registerClass:[ImageViewCell class] forCellReuseIdentifier:indentifier];
    
    NSLog(@"主页出现了");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AppDelegate *tempAppDelegate =KEYAPPDELEGATE;
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *tempAppDelegate =KEYAPPDELEGATE;
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}

- (void)openLeftVC{
    AppDelegate *tempAppDelegate = KEYAPPDELEGATE;
    if ([tempAppDelegate.LeftSlideVC closed]) {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }else{
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}


#pragma mark tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREENWIDTH*400/750.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    cell.iconImageView.image=[UIImage imageNamed:@"banner"];
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
    
    ImageViewCell *cell=(id)[tableView cellForRowAtIndexPath:indexPath];
    CGRect rectInTableView=[tableView rectForRowAtIndexPath:indexPath];
    CGRect rect=[tableView convertRect:rectInTableView toView:[tableView superview]];
    
    DetailViewController *detail=[[DetailViewController alloc]init];
    detail.resoource=cell.iconImageView.image;
    detail.startFrame=rect;
    [self presentViewController:detail animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
