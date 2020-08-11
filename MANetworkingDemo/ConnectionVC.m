//
//  ConnectionVC.m
//  MANetworking
//
//  Created by ma on 2020/8/11.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import "ConnectionVC.h"

#define kScreanWidth [UIScreen mainScreen].bounds.size.width
#define kScreanHeight [UIScreen mainScreen].bounds.size.height

@interface ConnectionVC ()

@property (assign, nonatomic) long long fileLength;
@property (assign, nonatomic) NSUInteger currentLength;
@property (strong, nonatomic) NSFileHandle *fileHandle;


@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic,strong) UIView *progressView;
@property (nonatomic,strong) UILabel *lblProgress;

@property (assign, nonatomic) BOOL isDelegateConnection;

@end

@implementation ConnectionVC

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
    self.lblProgress = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreanWidth, 30)];
    self.lblProgress.textColor = [UIColor blackColor];
    self.lblProgress.font = [UIFont boldSystemFontOfSize:15];
    self.lblProgress.textAlignment = NSTextAlignmentCenter;
    self.lblProgress.center = CGPointMake(kScreanWidth * 0.5, 350);
    self.lblProgress.text = [NSString stringWithFormat:@"下载进度:%.2f%%",100.0 * 0];
    [self.view addSubview:self.lblProgress];
    
    //
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.tag = 1001;
    btn1.frame = CGRectMake(20, 0, 80, 40);
    [btn1 setTitle:@"异步GET" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn1.center = CGPointMake(kScreanWidth * 0.5 - 50, 400);
    [btn1 addTarget:self action:@selector(commonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    UIButton* btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn4.tag = 1004;
    btn4.frame = CGRectMake(20, 0, 80, 40);
    [btn4 setTitle:@"异步POST" forState:UIControlStateNormal];
    btn4.backgroundColor = [UIColor redColor];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn4.center = CGPointMake(kScreanWidth * 0.5 + 50, 400);
    [btn4 addTarget:self action:@selector(commonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
    

    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.tag = 1002;
    btn2.frame = CGRectMake(20, 0, 80, 40);
    [btn2 setTitle:@"同步GET" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn2.center = CGPointMake(kScreanWidth * 0.5 - 50, 480);
    [btn2 addTarget:self action:@selector(commonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn3.tag = 1003;
    btn3.frame = CGRectMake(20, 0, 80, 40);
    [btn3 setTitle:@"代理GET" forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor redColor];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn3.center = CGPointMake(kScreanWidth * 0.5 + 50, 480);
    [btn3 addTarget:self action:@selector(commonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    
}


// 开始下载
- (void)download {
    
    self.isDelegateConnection = NO;
    if (self.urlConnection) {    // 如果有正在进行中的,需要停止先
        [self stop];
    }
    // 1.URL
    
    NSURL *url = [NSURL URLWithString:@"https://dldir1.qq.com/weixin/mac/WeChatMac.dmg"];
    
    // 2.请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 3.下载(创建完conn对象后，会自动发起一个异步请求)
    self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
}

// 取消下载
- (void)stop {
    
    [self.urlConnection cancel];
    self.urlConnection = nil;
    
    CGRect frame = CGRectMake(0, 0, 0, 20);
    self.progressView.frame = frame;
    self.lblProgress.text = [NSString stringWithFormat:@"下载进度:%.2f%%",100.0 * 0];
    
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    self.currentLength = 0;
    self.fileLength = 0;
    
    self.isDelegateConnection = NO;
}


- (void) commonHandler:(UIButton *) sender  {
    
    NSInteger tag = sender.tag;
 
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/2/statuses/public_timeline.json"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    self.isDelegateConnection = NO;
    // 1 异步方式，需要operaionQueue
    if ( tag == 1001 ) {

        self.lblProgress.text = @"异步-稍后请看控制台";

        
        NSOperationQueue *operaionQueue = [[NSOperationQueue alloc] init];
        operaionQueue = [NSOperationQueue mainQueue];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:operaionQueue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            // 此时是否是主线程 注意 [NSThread currentThread]
            self.lblProgress.text = [NSString stringWithFormat:@"异步-下载%@-请看控制台", connectionError ? @"失败" : @"成功"];
            NSLog(@" 异步 response : %@, data : %@, connectionError : %@", response, data, connectionError);
        }];
    }

    // 2 同步方式，需要定义网络响应体，错误
    else if ( tag == 1002 ) {

        self.lblProgress.text = @"同步-稍后请看控制台";
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *connectionError;
            NSURLResponse *response = [[NSURLResponse alloc] init];
            [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&connectionError];
            NSLog(@" 同步 response : %@, data : %@, connectionError : %@", response, nil, connectionError);
            self.lblProgress.text = [NSString stringWithFormat:@"同步-下载%@-请看控制台", connectionError ? @"失败" : @"成功"];
        });
    }
    

    // 3 代理方式，需要实现相关代理方法，在代理方法里获取相关对象和数据
    else if ( tag == 1003 ) {

        [self stop];
        self.isDelegateConnection = YES;
        self.lblProgress.text = @"代理-稍后请看控制台";
        
        // 任选其一
//        self.conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
//        self.conn = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
//        self.conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];

        self.urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:NO];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [self.urlConnection scheduleInRunLoop:runLoop forMode:NSDefaultRunLoopMode];
        [self.urlConnection start];
    }
    else if ( tag == 1004) {
        
        self.lblProgress.text = @"异步POST-稍后请看控制台";
        
        //设置请求超时等待时间（超过这个时间就算超时，请求失败）
        [urlRequest setTimeoutInterval:15.0];
        
        //设置请求方法（比如GET和POST）
        [urlRequest setHTTPMethod:@"POST"];
        
        //设置请求体
        NSString *bodyStr = @"key=value";
        [urlRequest setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        //设置请求头
        [urlRequest setValue:@"" forHTTPHeaderField:@""];
        
        // 3.异步发送请求
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * response, NSData *data, NSError *connectionError) {
            
            // 注意 [NSThread currentThread]
            dispatch_async(dispatch_get_main_queue(), ^{
                self.lblProgress.text = [NSString stringWithFormat:@"异步POST-下载%@-请看控制台", connectionError ? @"失败" : @"成功"];
            });
                                                              
        }];
    }
}

#pragma mark - 代理实现方法示例
#pragma mark NSURLConnectionDelegate <NSObject>

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if ( self.isDelegateConnection ) {
        
        NSLog(@" 代理 response : %@, data : %@, connectionError : %@", nil, nil, error);
        return;
    }
}

#pragma mark NSURLConnectionDataDelegate <NSURLConnectionDelegate>
// 接收到响应的时候：创建一个空的沙盒文件
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    if ( self.isDelegateConnection ) {
        return;
    }
    
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
    
    if ( self.isDelegateConnection ) {
        
        NSLog(@" 代理 response : %@, data : %@, connectionError : %@", nil, data, nil);
        return;
    }
    
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
    
    if ( self.isDelegateConnection ) {
        self.lblProgress.text = @"代理-完成-请看控制台";
    }
    
    // 关闭fileHandle
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    
    // 清空长度
    self.currentLength = 0;
    self.fileLength = 0;
}


@end
