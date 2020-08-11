//
//  SessionDownloadVC.m
//  MANetworking
//
//  Created by ma on 2020/8/11.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import "SessionDownloadVC.h"

#define kScreanWidth [UIScreen mainScreen].bounds.size.width
#define kScreanHeight [UIScreen mainScreen].bounds.size.height

@interface SessionDownloadVC ()<NSURLSessionDownloadDelegate>


@property(nonatomic,strong) UIView *progressView;
@property(nonatomic,strong) UILabel *lblProgress;

@property(nonatomic,strong)NSData *resumeData;
@property(nonatomic,strong)NSURLSession *urlSession;
@property(nonatomic,strong)NSURLSessionDownloadTask *downloadTask;


@end

@implementation SessionDownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
}


- (void)setUI {
    
    // 下载
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 0, 200, 40);
    [button setTitle:@"下载" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.center = CGPointMake(kScreanWidth * 0.5, 150);
    [button addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 取消
    UIButton* button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame = CGRectMake(20, 0, 200, 40);
    [button1 setTitle:@"停止" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor redColor];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button1.center = CGPointMake(kScreanWidth * 0.5, 220);
    [button1 addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    // 进度条
    UIView *proView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreanWidth * 0.8, 20)];
    proView.backgroundColor = [UIColor grayColor];
    proView.center = CGPointMake(kScreanWidth * 0.5, 300);
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
    self.lblProgress.center = CGPointMake(kScreanWidth * 0.5, 350);
    self.lblProgress.text = [NSString stringWithFormat:@"下载进度:%.2f%%",100.0 * 0];
    [self.view addSubview:self.lblProgress];
            
    // 暂停
    UIButton* button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(20, 0, 200, 40);
    [button2 setTitle:@"暂停" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor redColor];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button2.center = CGPointMake(kScreanWidth * 0.5, 420);
    [button2 addTarget:self action:@selector(suspend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}


#pragma mark - 断点续传

// 开始下载
- (void) download {
    
    NSURL *url = [NSURL URLWithString:@"https://dldir1.qq.com/weixin/mac/WeChatMac.dmg"];
    if ( self.downloadTask ) {
             
        // 完全取消，不可原点重启
        // [self.downloadTask cancel];
        
        [self suspendCallBack:^{
            
            // 完全取消后再继续下载
            [self download];
        }];
        return;
    }
    if (self.resumeData) {  // 之前已经下载过了
        self.downloadTask = [self.urlSession downloadTaskWithResumeData:self.resumeData];
    } else {
        self.urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        self.downloadTask = [self.urlSession downloadTaskWithRequest:request];
        [self.urlSession downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
        }];
    }
    
    [self.downloadTask resume];
}

// 恢复
- (void) reset {
        
    [self suspendCallBack:^{
        
        self.downloadTask = nil;
        self.urlSession = nil;
        self.resumeData = nil;
    }];
    
    self.lblProgress.text = [NSString stringWithFormat:@"下载进度:%.2f%%",100.0 * 0];
    CGRect frame = CGRectMake(0, 0, kScreanWidth * 0.6 * 0, 20);
    self.progressView.frame = frame;
}

// 取消下载
- (void) suspend {
    
    [self suspendCallBack:nil];
}

- (void) suspendCallBack:(void(^)(void)) callBack {
    
    if (self.downloadTask) {
        
        __weak typeof (self)weakSelf = self;
        [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
            NSLog(@"resumeData:%@",resumeData);
            weakSelf.resumeData = resumeData;
            weakSelf.downloadTask = nil;
            if ( callBack ) {
                callBack();
            }
        }];
    }
}


#pragma mark - NSURLSessionDownloadDelegate

/**
 *  写入临时文件时调用
 *  @param bytesWritten              本次写入大小
 *  @param totalBytesWritten         已写入文件大小
 *  @param totalBytesExpectedToWrite 请求的总文件的大小
 */
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    //可以监听下载的进度
    CGFloat progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lblProgress.text = [NSString stringWithFormat:@"下载进度:%.2f%%",100.0 * progress];
        CGRect frame = CGRectMake(0, 0, kScreanWidth * 0.8 * progress, 20);
        self.progressView.frame = frame;
    });
}

// 下载完成调用
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    // location 还是一个临时路径,需要自己挪到需要的路径（caches 文件夹）
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
    NSLog(@"downloadTask 移动文件路径 - %@", filePath);
//    downloadTask 移动文件路径 - /var/mobile/Containers/Data/Application/15F41978-D67F-4349-87DE-F8EE437C72F8/Library/Caches/WeChatMac.dmg

}

@end
