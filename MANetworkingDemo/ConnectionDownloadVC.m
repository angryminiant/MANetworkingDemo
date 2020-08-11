//
//  ConnectionDownloadVC.m
//  MANetworking
//
//  Created by ma on 2020/8/11.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import "ConnectionDownloadVC.h"


@interface ConnectionDownloadVC ()


@property (assign, nonatomic) long long fileLength;
@property (assign, nonatomic) NSUInteger currentLength;
@property (strong, nonatomic) NSFileHandle *fileHandle;


@property (nonatomic, strong) NSURLConnection *urlConnection;
@property(nonatomic,strong) UIView *progressView;
@property(nonatomic,strong) UILabel *lblProgress;


@end

@implementation ConnectionDownloadVC

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
    [button1 addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
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
    [button2 addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}


// 开始下载
- (void)download {
    
    if (self.urlConnection) {    // 如果有正在进行中的,需要停止先
        [self cancel];
    }
    // 1.URL
    
    NSURL *url = [NSURL URLWithString:DownloadUrlLink];
    
    // 2.请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 设置请求头 重点
    NSString *range = [NSString stringWithFormat:@"bytes=%lu-", (unsigned long)self.currentLength];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    // 3.下载(创建完conn对象后，会自动发起一个异步请求)
    self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
}

// 取消下载
- (void)stop {
    
    [self cancel];
    
    CGRect frame = CGRectMake(0, 0, 0, 20);
    self.progressView.frame = frame;
    self.lblProgress.text = [NSString stringWithFormat:@"下载进度:%.2f%%",100.0 * 0];
    
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    self.currentLength = 0;
    self.fileLength = 0;
}

// 暂定下载
- (void)cancel {
    [self.urlConnection cancel];
    self.urlConnection = nil;
}

#pragma mark - 代理实现方法示例
#pragma mark NSURLConnectionDelegate <NSObject>

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

#pragma mark NSURLConnectionDataDelegate <NSURLConnectionDelegate>
// 接收到响应的时候：创建一个空的沙盒文件
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    // 获得下载文件的总长度
    self.fileLength = response.expectedContentLength;
    
    // 沙盒文件路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"WeChatMac.dmg"];
    
    NSLog(@"File downloaded to: %@",path);
    
    // 创建一个空的文件到沙盒中
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    
    // 创建文件句柄
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
}

// 接收到具体数据：把数据写入沙盒文件中
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    // 指定数据的写入位置 -- 文件内容的最后面
    [self.fileHandle seekToEndOfFile];
    
    // 向沙盒写入数据
    [self.fileHandle writeData:data];
    
    // 拼接文件总长度
    self.currentLength += data.length;
    
    // 下载进度
    CGFloat progress = 1.0 * self.currentLength / self.fileLength;
    self.lblProgress.text = [NSString stringWithFormat:@"下载进度:%.2f%%",100.0 * progress];
    CGRect frame = CGRectMake(0, 0, kScreanWidth * 0.8 * progress, 20);
    self.progressView.frame = frame;
}

/**
 *  下载完文件之后调用：关闭文件、清空长度
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // 关闭fileHandle
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    
    // 清空长度
    self.currentLength = 0;
    self.fileLength = 0;
}




@end
