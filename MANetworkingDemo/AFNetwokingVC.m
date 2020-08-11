//
//  AFNetwokingVC.m
//  MANetworkingDemo
//
//  Created by hugengya on 2020/8/11.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import "AFNetwokingVC.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface AFNetwokingVC ()

@property(nonatomic,strong) UIView *progressView;
@property(nonatomic,strong) UILabel *lblProgress;

@property(nonatomic,strong) NSURLSessionTask *sessionTask;

@end

@implementation AFNetwokingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setUI];
}

- (void)setUI {
    
    // 下载
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 0, 60, 40);
    [button setTitle:@"GET" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.center = CGPointMake(kScreanWidth * 0.5 - 60, 150);
    [button addTarget:self action:@selector(getHandler) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(20, 0, 150, 40);
    [button1 setTitle:@"DownloadRequest" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button1.center = CGPointMake(kScreanWidth * 0.5 + 60, 150);
    [button1 addTarget:self action:@selector(downloadTaskWithRequest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
    // 进度条
    UIView *proView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreanWidth * 0.8, 20)];
    proView.backgroundColor = [UIColor grayColor];
    proView.center = CGPointMake(kScreanWidth * 0.5, 200);
    [self.view addSubview:proView];
    
    // 进度条
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    progressView.backgroundColor = [UIColor greenColor];
    [proView addSubview:progressView];
    self.progressView = progressView;
    
    // 进度值
    self.lblProgress = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.lblProgress.textColor = [UIColor blackColor];
    self.lblProgress.font = [UIFont boldSystemFontOfSize:15];
    self.lblProgress.textAlignment = NSTextAlignmentCenter;
    self.lblProgress.center = CGPointMake(kScreanWidth * 0.5, 250);
    [self.view addSubview:self.lblProgress];
    [self setProgressValue:0];
}
  
- (void) getHandler {

    [self setProgressValue:0];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/pdf"];
    
    __weak __typeof__(self) weakSelf = self;
    //临时配置，需要自己根据接口地址改动
    NSString *urlStr = PdfUrlLink;
    
    self.sessionTask = [manager GET:urlStr parameters:@{} headers:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
                   
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        // 下载进度
        CGFloat progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf setProgressValue:progress];
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSString *filePath = @"";
//        [responseObject writeToFile:filePath atomically:YES];
                
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}


- (void)downloadTaskWithRequest {

    [self setProgressValue:0];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    // 2. 创建下载路径和请求对象
    NSURL *URL = [NSURL URLWithString:DownloadUrlLink];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    // 3.创建下载任务
    /**
     * 第一个参数 - request：请求对象
     * 第二个参数 - progress：下载进度block
     *      其中： downloadProgress.completedUnitCount：已经完成的大小
     *            downloadProgress.totalUnitCount：文件的总大小
     * 第三个参数 - destination：自动完成文件剪切操作
     *      其中： 返回值:该文件应该被剪切到哪里
     *            targetPath：临时路径 tmp NSURL
     *            response：响应头
     * 第四个参数 - completionHandler：下载完成回调
     *      其中： filePath：真实路径 == 第三个参数的返回值
     *            error:错误信息
     */
    
    __weak __typeof__(self) weakSelf = self;
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {

        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        // 获取主线程，不然无法正确显示进度。
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            
            // 下载进度
            CGFloat progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            [strongSelf setProgressValue:progress];
        }];


    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {

        NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [path URLByAppendingPathComponent:@"education.pdf"];

    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {

        NSLog(@"File downloaded to: %@", filePath);
    }];

    self.sessionTask = downloadTask;
    [downloadTask resume];
    
}

- (void) setProgressValue:(CGFloat) progress {
    
    self.lblProgress.text = [NSString stringWithFormat:@"下载进度:%.2f%%",100.0 * progress];
    CGRect frame = CGRectMake(0, 0, kScreanWidth * 0.8 * progress, 20);
    self.progressView.frame = frame;
    
    if ( progress == 0 ) {
        [self.sessionTask cancel];
    }
    
}

@end
