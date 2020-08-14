//
//  ViewController.m
//  MANetworking
//
//  Created by ma on 2020/8/10.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *vcs;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"网络篇";
    
    self.data = @[@"NSData",
    @"NSURLConnection",
    @"NSURLConnection 断点下载",
    @"NSURLSession",
    @"NSURLSession 断点下载",
    @"NSURLSession 上传",
    @"AFNetworking",
    @"NSURLSession队列管理多任务下载"];
    
    self.vcs = @[@"DataVC",
    @"ConnectionVC",
    @"ConnectionDownloadVC",
    @"SessionVC",
    @"SessionDownloadVC",
    @"SessionUploadVC",
    @"AFNetwokingVC",
    @"MASessionOperationQueueTaskVC"];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];// 避免出现空白cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell_ID"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_ID" forIndexPath:indexPath];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_ID"];
    }
    cell.textLabel.text = self.data[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    Class classvc = NSClassFromString(self.vcs[indexPath.row]);
    UIViewController *vc = [classvc new];
    vc.title = self.data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
