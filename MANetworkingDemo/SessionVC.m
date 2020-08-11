//
//  SessionVC.m
//  MANetworking
//
//  Created by ma on 2020/8/10.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import "SessionVC.h"


@interface SessionVC ()<NSURLSessionDelegate,NSURLSessionDataDelegate>


@property (nonatomic,strong) UILabel *lblDes;
@property (nonatomic,strong) NSMutableData *responseData;


@end

@implementation SessionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUI];
        
}

- (void)setUI {
    
    // 进度值
    self.lblDes = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreanWidth, 30)];
    self.lblDes.textColor = [UIColor blackColor];
    self.lblDes.font = [UIFont boldSystemFontOfSize:15];
    self.lblDes.textAlignment = NSTextAlignmentCenter;
    self.lblDes.center = CGPointMake(kScreanWidth * 0.5, 120);
    self.lblDes.text = @"";
    [self.view addSubview:self.lblDes];
    
    //
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.tag = 1001;
    btn1.frame = CGRectMake(20, 0, 120, 40);
    [btn1 setTitle:@"GetUrl" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn1.center = CGPointMake(kScreanWidth * 0.5 - 80, 180);
    [btn1 addTarget:self action:@selector(commonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];

    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.tag = 1002;
    btn2.frame = CGRectMake(20, 0, 120, 40);
    [btn2 setTitle:@"GetRequest" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn2.center = CGPointMake(kScreanWidth * 0.5 + 80, 180);
    [btn2 addTarget:self action:@selector(commonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn3.tag = 1003;
    btn3.frame = CGRectMake(20, 0, 120, 40);
    [btn3 setTitle:@"GetDelegate" forState:UIControlStateNormal];
    btn3.backgroundColor = [UIColor redColor];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn3.center = CGPointMake(kScreanWidth * 0.5 - 80, 250);
    [btn3 addTarget:self action:@selector(commonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton* btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn4.tag = 1004;
    btn4.frame = CGRectMake(20, 0, 120, 40);
    [btn4 setTitle:@"PostRequest" forState:UIControlStateNormal];
    btn4.backgroundColor = [UIColor redColor];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn4.center = CGPointMake(kScreanWidth * 0.5 + 80, 250);
    [btn4 addTarget:self action:@selector(commonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
}


- (void) commonHandler:(UIButton *) sender  {
    
    NSInteger tag = sender.tag;
    
    if ( tag == 1001 ) {
        
        self.lblDes.text = @"GetUrl-稍后请看控制台";
        [self getByDataTaskWithURL];
    }
    else if ( tag == 1002 ) {
        self.lblDes.text = @"GetRequest-稍后请看控制台";
        [self getByDataTaskWithRequest];
    }
    else if ( tag == 1003 ) {
        self.lblDes.text = @"GetDelegate-稍后请看控制台";
        [self getWithDelegate];
    }
    else if ( tag == 1004 ) {
        self.lblDes.text = @"PostResquest-稍后请看控制台";
        [self postByDataTaskWithRequest];
    }
    else if ( tag == 1005 ) {
        
    }
        
}

/*

现在的苹果原生网络框架 -- NSURLSession
在iOS9.0之后，以前使用的NSURLConnection过期，
苹果推荐使用NSURLSession来替换NSURLConnection完成网路请求相关操作。
NSURLSession的使用非常简单，先根据会话对象创建一个请求Task，然后执行该Task即可。
NSURLSessionTask本身是一个抽象类，在使用的时候，通常是根据具体的需求使用它的几个子类。关系如下：

2.1 GET请求（NSURLRequest默认设置）
使用NSURLSession发送GET请求的方法和NSURLConnection类似，整个过程如下：
1）确定请求路径（一般由公司的后台开发人员以接口文档的方式提供），GET请求参数直接跟在URL后面
2）创建请求对象（默认包含了请求头和请求方法【GET】），此步骤可以省略
3）创建会话对象（NSURLSession）
4）根据会话对象创建请求任务（NSURLSessionDataTask）
5）执行Task
6）当得到服务器返回的响应后，解析数据（XML|JSON|HTTP）
*/

//GET   NSURLRequest默认设置               请求参数直接?key=value拼接在接口后面
//POST  NSURLRequest设置请求方法HTTPMethod  请求参数放在请求体重


//① 下载完的事件采用block形式
-(void) getByDataTaskWithURL {
    
    // Get : @"协议://ip:port/接口路径名称?参数key=参数value";
    NSURL *url = [NSURL URLWithString:JsonUrlLink];
    
    //2.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //3.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求路径
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
               data：响应体信息（期望的数据）
               response：响应头信息，主要是对服务器端的描述
               error：错误信息，如果请求失败，则error有值
     注意：
        1）该方法内部会自动将请求路径包装成一个请求对象，该请求对象默认包含了请求头信息和请求方法（GET）
        2）如果要发送的是POST请求，则不能使用该方法
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //5.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"GetUrl -%@",dict);
        // 注意 [NSThread currentThread]
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lblDes.text = [NSString stringWithFormat:@"GetUrl-下载%@-请看控制台", error ? @"失败" : @"成功"];
        });
        
        
        //  下载图片
        /*
         
         // 获取沙盒的 caches 路径
         NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
         
         // 生成 url 路径
         NSURL *url = [NSURL fileURLWithPath:path];
         
         // 将文件保存到指定文件目录下
         [[NSFileManager defaultManager] moveItemAtURL:location toURL:url error:nil];
         
         NSLog(@"path = %@",path);
         
         //切记当前为子线程，
         dispatch_async(dispatch_get_main_queue(), ^{
         
             self.imgView.image = [UIImage imageNamed:path];
         });
         
         */
        
    }];
    
    // 执行任务
    [dataTask resume];
}

-(void) getByDataTaskWithRequest {

    NSURL *url = [NSURL URLWithString:JsonUrlLink];
    
    // 请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 获得会话对象
      NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    // 根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
               data：响应体信息（期望的数据）
               response：响应头信息，主要是对服务器端的描述
               error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"GetRequest -%@",dict);
            // 注意 [NSThread currentThread]
            dispatch_async(dispatch_get_main_queue(), ^{
                self.lblDes.text = [NSString stringWithFormat:@"GetRequest-下载%@-请看控制台", error ? @"失败" : @"成功"];
            });
        }
    }];
        
    // 执行任务
    [dataTask resume];
}



//② 下载完的事件采用delegate形式
-(void) getWithDelegate {
    
    self.responseData = [NSMutableData data];
    
    NSURL *url = [NSURL URLWithString:JsonUrlLink];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象,并设置代理
    /*
     第一个参数：会话对象的配置信息defaultSessionConfiguration 表示默认配置
     第二个参数：谁成为代理，此处为控制器本身即self
     第三个参数：队列，该队列决定代理方法在哪个线程中调用，可以传主队列|非主队列
     [NSOperationQueue mainQueue]   主队列：   代理方法在主线程中调用
     [[NSOperationQueue alloc]init] 非主队列： 代理方法在子线程中调用
     */
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // 子线程
    // session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]];
        
    //4.根据会话对象创建一个Task(发送请求）
    // NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    
    //5.执行任务
    [dataTask resume];
}


#pragma mark NSURLSessionDataDelegate
//1.接收到服务器响应的时候调用该方法
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    //在该方法中可以得到响应头信息，即response
    NSLog(@"代理 didReceiveResponse thread - %@",[NSThread currentThread]);
    
    //注意：需要使用completionHandler回调告诉系统应该如何处理服务器返回的数据
    //默认是取消的
    /*
     NSURLSessionResponseCancel = 0,        默认的处理方式，取消
     NSURLSessionResponseAllow = 1,         接收服务器返回的数据
     NSURLSessionResponseBecomeDownload = 2,变成一个下载请求
     NSURLSessionResponseBecomeStream        变成一个流
     */
    
    completionHandler(NSURLSessionResponseAllow);
}

//2.接收到服务器返回数据的时候会调用该方法，如果数据较大那么该方法可能会调用多次
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"代理 didReceiveData thread - %@",[NSThread currentThread]);
    
    //拼接服务器返回的数据
    [self.responseData appendData:data];
}

//3.当请求完成(成功|失败)的时候会调用该方法，如果请求失败，则error有值
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    NSLog(@"代理 didCompleteWithError thread - %@",[NSThread currentThread]);
    
    if( error == nil ) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:nil];
        NSLog(@"GetDelegate - %@",dict);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lblDes.text = [NSString stringWithFormat:@"GetDelegate-下载%@-请看控制台", error ? @"失败" : @"成功"];
    });
}

//2.2 POST请求（需另外单独设置request.HTTPMethod属性）
-(void)postByDataTaskWithRequest {
    
    self.responseData = [NSMutableData data];
    
    NSURL *url = [NSURL URLWithString:JsonUrlLink];
    NSURLSession *session = [NSURLSession sharedSession];
    // 子线程
    // session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]];
    
    //创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 修改请求方法为POST
    request.HTTPMethod = @"POST";
    
    // 设置请求体
    request.HTTPBody = [@"key=value" dataUsingEncoding:NSUTF8StringEncoding];
    
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
                data：响应体信息（期望的数据）
                response：响应头信息，主要是对服务器端的描述
                error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //8.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict);
        NSLog(@"PostRequest - %@",dict);
        // 注意 [NSThread currentThread]
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lblDes.text = [NSString stringWithFormat:@"PostRequest-下载%@-请看控制台", error ? @"失败" : @"成功"];
        });
        
    }];
    
    // session 代理方法
    // dataTask = [session dataTaskWithRequest:request];
    
    //7.执行任务
    [dataTask resume];
}


@end
