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
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    self.myTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.001, 0.001)];
    self.myTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.001, 0.001)];
    [self.myTableView registerClass:[ImageViewCell class] forCellReuseIdentifier:indentifier];
}


#pragma mark tableviewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
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
