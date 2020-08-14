//
//  MASessionOperationQueueTaskVC.m
//  MANetworkingDemo
//
//  Created by ma on 2020/8/13.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import "MASessionOperationQueueTaskVC.h"
#import "MATaskManager.h"
#import "MATaskCell.h"

@interface MASessionOperationQueueTaskVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) MATaskManager *taskManager;
@property (nonatomic,strong) NSArray<NSString *> *taskUrls;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MASessionOperationQueueTaskVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.taskUrls = @[@"https://img-baofun.zhhainiao.com/pcwallpaper_ugc/preview/72246715a91357135554023df0ef7154_preview.mp4",
                       @"https://img-baofun.zhhainiao.com/pcwallpaper_ugc/preview/dcd1a62b03841b97a6e968b30fae4d65_preview.mp4",
                       @"https://img-baofun.zhhainiao.com/pcwallpaper_ugc/preview/b861ccb00dfc3cd35a99d247e68e267b_preview.mp4",
                       @"https://wallpaperm-mp4.duba.com/live/preview_video/d750d206b3ea064f594d0a94663a6a2c_preview.mp4",
                       @"https://wallpaperm-mp4.duba.com/scene/preview_video/97ba6b60662ab4f31ef06cdf5a5f8e94_preview.mp4",
                     ];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];// 避免出现空白cell    
    [self.tableView registerNib:[UINib nibWithNibName:@"MATaskCell" bundle:nil] forCellReuseIdentifier:@"cell_ID"];
    [self.view addSubview:self.tableView];
    
    
    self.taskManager = [[MATaskManager alloc]init];    
    
    __weak typeof (self) weakSelf = self;
    self.taskManager.progressBlock = ^(CGFloat progress, NSString * _Nonnull urlStr) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[weakSelf.taskUrls indexOfObject:urlStr]  inSection:0];
            MATaskCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                cell.progressView.progress = progress;
            }
        });
        
    };
    
    self.taskManager.finishBlock = ^(NSString * _Nonnull path, NSString * _Nonnull urlStr) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[weakSelf.taskUrls indexOfObject:urlStr]  inSection:0];
            MATaskCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                [cell loadAVPlayerWith:path];
            }
        });
    };
    
    // 添加任务
    for ( NSInteger i = 0 ; i < self.taskUrls.count ; i++ ) {
        [self.taskManager addTaskUrl:self.taskUrls[i]];
    }
}
     
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskUrls.count;
}
     
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MATaskCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell_ID" forIndexPath:indexPath];    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120;
}


@end
