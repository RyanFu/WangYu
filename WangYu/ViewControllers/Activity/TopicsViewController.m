//
//  TopicsViewController.m
//  WangYu
//
//  Created by KID on 15/6/1.
//  Copyright (c) 2015年 KID. All rights reserved.
//

#import "TopicsViewController.h"
#import "WYEngine.h"
#import "NewsViewCell.h"
#import "WYProgressHUD.h"
#import "WYNewsInfo.h"
#import "UIImageView+WebCache.h"
#import "WYLinkerHandler.h"

@interface TopicsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UITableView *topicsTableView;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) NSMutableArray *topicsInfos;

@end

@implementation TopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topicsTableView.tableHeaderView = self.headerView;
    [self refreshHeaderView];
    [self refreshTopicsInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews {
    [self setTitle:@"资讯专题"];
}

- (void)refreshHeaderView {
    if (![self.newsInfo.cover isEqual:[NSNull null]]) {
        [self.headerImageView sd_setImageWithURL:self.newsInfo.hotImageURL placeholderImage:[UIImage imageNamed:@"activity_load_icon"]];
    }else{
        [self.headerImageView sd_setImageWithURL:nil];
        [self.headerImageView setImage:[UIImage imageNamed:@"activity_load_icon"]];
    }
    self.headerLabel.text = self.newsInfo.title;
}

- (void)refreshTopicsInfo {
    WS(weakSelf);
    int tag = [[WYEngine shareInstance] getConnectTag];
    [[WYEngine shareInstance] getTopicsListWithTid:@"1" Tag:tag];
    [[WYEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //        [WYProgressHUD AlertLoadDone];
        [self.pullRefreshView finishedLoading];
        NSString* errorMsg = [WYEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [WYProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        weakSelf.newsInfo = [[WYNewsInfo alloc] init];
        NSMutableDictionary *newsDic = [[jsonRet objectForKey:@"object"] objectForKey:@"detail"];
        [weakSelf.newsInfo setNewsInfoByJsonDic:newsDic];
    
        weakSelf.topicsInfos = [NSMutableArray array];
        NSArray *activityDicArray = [[[jsonRet objectForKey:@"object"] objectForKey:@"subjects"] arrayObjectForKey:@"list"];
        for (NSDictionary *dic in activityDicArray) {
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            WYNewsInfo *topicsInfo = [[WYNewsInfo alloc] init];
            [topicsInfo setNewsInfoByJsonDic:dic];
            [weakSelf.topicsInfos addObject:topicsInfo];
        }
        [weakSelf refreshHeaderView];
        [weakSelf.topicsTableView reloadData];
    }tag:tag];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicsInfos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsViewCell";
    NewsViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    WYNewsInfo *newsInfo = _topicsInfos[indexPath.row];
    cell.newsInfo = newsInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WYNewsInfo *newsInfo = _topicsInfos[indexPath.row];
    id vc = [WYLinkerHandler handleDealWithHref:[NSString stringWithFormat:@"%@/activity/info/web/detail?id=%@", [WYEngine shareInstance].baseUrl, newsInfo.nid] From:self.navigationController];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
}

@end
