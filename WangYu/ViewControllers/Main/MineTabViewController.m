//
//  MineTabViewController.m
//  WangYu
//
//  Created by KID on 15/4/22.
//  Copyright (c) 2015年 KID. All rights reserved.
//

#import "MineTabViewController.h"
#import "WYTabBarViewController.h"
#import "AboutViewController.h"
#import "WYEngine.h"
#import "AppDelegate.h"
#import "SettingViewController.h"

@interface MineTabViewController ()

- (IBAction)editAction:(id)sender;
@end

@implementation MineTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getCacheTopicInfo];
    [self refreshTopicList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    [self setTitle:@"我的"];
    [self setRightButtonWithTitle:@"设置" selector:@selector(settingAction:)];
    [self.titleNavBarRightBtn setTitleColor:UIColorToRGB(0x387cbc) forState:0];
}

- (UINavigationController *)navigationController{
    if ([super navigationController]) {
        return [super navigationController];
    }
    return self.tabController.navigationController;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - request
- (void)getCacheTopicInfo{
    
}

- (void)refreshTopicList{
    
}

#pragma mark - IBAction
- (IBAction)editAction:(id)sender{
    
}
- (void)settingAction:(id)sender {
    SettingViewController *setVc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
}

@end
