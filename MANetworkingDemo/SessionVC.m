//
//  SessionVC.m
//  MANetworking
//
//  Created by ma on 2020/8/10.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import "SessionVC.h"

NSString *GetUrlLik = @"https://api.weibo.com/2/statuses/public_timeline.json";
#define kScreanWidth [UIScreen mainScreen].bounds.size.width
#define kScreanHeight [UIScreen mainScreen].bounds.size.height

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
    
//    NSString *GetUrlLik = @"协议://ip:port/接口路径名称?参数key=参数value";
    NSURL *url = [NSURL URLWithString:GetUrlLik];
    
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

    NSURL *url = [NSURL URLWithString:GetUrlLik];
    
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
    
    NSURL *url = [NSURL URLWithString:GetUrlLik];
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
        //解析数据,JSON解析请参考http://www.cnblogs.com/wendingding/p/3815303.html
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
    
    NSURL *url = [NSURL URLWithString:GetUrlLik];
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

/*
3. HTTPS与HTTP的不同点
前面涉及到的GET和POST都属于HTTP请求，现在苹果的APP都推荐支持HTTPS，这就需要先配置一下证书，然后在NSURLSession（或者NSURLConnection但现在新的项目基本不用了）的代理方法里面进行一些特别的操作。如果是AFNetWorking，也需要对AFHTTPRequestOperationManager对象进行一些特别的操作。
关于证书的配置，及需要的特别的操作，推荐阅读：
https://www.jianshu.com/p/97745be81d64
https://www.jianshu.com/p/459e5471e61b
https://www.jianshu.com/p/4f826c6e48ed
*/


/*
4. AF封装了GET和POST操作的 -- AFHTTPSessionManager
AFNetworking2.0和3.0区别很大，也是因为苹果废弃了NSURLConnection，而改用了NSURLSession，AFNetworking3.0实际上只是对NSURLSession所做的操作进行了高度封装，提供更加简洁的API供编码调用。

查看AFHTTPSessionManager.h文件，可知AFHTTPSessionManager是AFURLSessionManager的子类：

@interface AFHTTPSessionManager : AFURLSessionManager <NSSecureCoding, NSCopying>
 */


//请求示例 -- 下载一个PDF文件
/*
- (void)DownloadPdfAndSave{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/pdf"];
    __weak __typeof__(self) weakSelf = self;
    //临时配置，需要自己根据接口地址改动！！！！！！！！！！！！！！！！！！！！
    self.urlStr = @"http://10.22.221.78/test.pdf";
    [manager GET:_urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        strongSelf.isWriten = [responseObject writeToFile:[self pathOfPdf] atomically:YES];
        [strongSelf openPdfByAddingSubView];
        //[strongSelf.previewController reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
    }];
}
*/

// get请求调用栈分析
// AFHTTPSessionManager.m
/*
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {

    return [self GET:URLString parameters:parameters progress:nil success:success failure:failure];
}
 
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {

    NSURLSessionDataTask *dataTask = [self dataTaskWithHTTPMethod:@"GET"
                                                        URLString:URLString
                                                       parameters:parameters
                                                   uploadProgress:nil
                                                 downloadProgress:downloadProgress
                                                          success:success
                                                          failure:failure];

    [dataTask resume];

    return dataTask;
}
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
 
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
        }

        return nil;
    }

    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];

    return dataTask;
}
*/


//AFURLSessionManager.m
/*
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler {

    __block NSURLSessionDataTask *dataTask = nil;
    url_session_manager_create_task_safely(^{
        dataTask = [self.session dataTaskWithRequest:request];
    });

    [self addDelegateForDataTask:dataTask uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completionHandler];

    return dataTask;
}
*/

//5. AF的GET和POST请求实现第二层 -- AFURLSessionManager
//5.1 downloadTaskWithRequest: progress: destination: completionandler:
//AFURLSessionManager.m
//调用示例 DownloadVC.m

//- (IBAction)downloadBtnClicked:(UIButton *)sender {
//
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    // 1. 创建会话管理者
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//
//    // 2. 创建下载路径和请求对象
//    NSURL *URL = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//
//    // 3.创建下载任务
//    /**
//     * 第一个参数 - request：请求对象
//     * 第二个参数 - progress：下载进度block
//     *      其中： downloadProgress.completedUnitCount：已经完成的大小
//     *            downloadProgress.totalUnitCount：文件的总大小
//     * 第三个参数 - destination：自动完成文件剪切操作
//     *      其中： 返回值:该文件应该被剪切到哪里
//     *            targetPath：临时路径 tmp NSURL
//     *            response：响应头
//     * 第四个参数 - completionHandler：下载完成回调
//     *      其中： filePath：真实路径 == 第三个参数的返回值
//     *            error:错误信息
//     */
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
//
//        __weak typeof(self) weakSelf = self;
//        // 获取主线程，不然无法正确显示进度。
//        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
//        [mainQueue addOperationWithBlock:^{
//            // 下载进度
//            weakSelf.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
//            weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
//        }];
//
//
//    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//
//        NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [path URLByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
//
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//
//        NSLog(@"File downloaded to: %@", filePath);
//    }];
//
//    // 4. 开启下载任务
//    [downloadTask resume];
//}


//内部封装分析 AFURLSessionManager.m
//- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
//                                             progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
//                                          destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
//                                    completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler
//{
//    __block NSURLSessionDownloadTask *downloadTask = nil;
//    url_session_manager_create_task_safely(^{
//        downloadTask = [self.session downloadTaskWithRequest:request];
//    });
//
//    [self addDelegateForDownloadTask:downloadTask progress:downloadProgressBlock destination:destination completionHandler:completionHandler];
//
//    return downloadTask;
//}
//其中self.session是AFURLSessionManager.h中的属性
//
//@property (readonly, nonatomic, strong) NSURLSession *session;
//它后面调用的API声明在NSFoundation的NSURLSession.h的头文件中
//
///* Creates a data task with the given request.  The request may have a body stream. */
//- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request;
//添加代理的封装 AFURLSessionManager.m
//
//- (void)addDelegateForDataTask:(NSURLSessionDataTask *)dataTask
//                uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
//              downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
//             completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
//{
//    AFURLSessionManagerTaskDelegate *delegate = [[AFURLSessionManagerTaskDelegate alloc] init];
//    delegate.manager = self;
//    delegate.completionHandler = completionHandler;
//
//    dataTask.taskDescription = self.taskDescriptionForSessionTasks;
//    [self setDelegate:delegate forTask:dataTask];
//
//    delegate.uploadProgressBlock = uploadProgressBlock;
//    delegate.downloadProgressBlock = downloadProgressBlock;
//}
////其中
//
//- (void)setDelegate:(AFURLSessionManagerTaskDelegate *)delegate
//            forTask:(NSURLSessionTask *)task
//{
//    NSParameterAssert(task);
//    NSParameterAssert(delegate);
//
//    [self.lock lock];
//    self.mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)] = delegate;
//    [delegate setupProgressForTask:task];
//    [self addNotificationObserverForTask:task];
//    [self.lock unlock];
//}
//其中，self.mutableTaskDelegatesKeyedByTaskIdentifier是个字典

//@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableTaskDelegatesKeyedByTaskIdentifier;
//被调用的地方在：

//- (AFURLSessionManagerTaskDelegate *)delegateForTask:(NSURLSessionTask *)task {
//    NSParameterAssert(task);
//
//    AFURLSessionManagerTaskDelegate *delegate = nil;
//    [self.lock lock];
//    delegate = self.mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)];
//    [self.lock unlock];
//
//    return delegate;
//}
//进而被调用的地方在：

//- (void)URLSession:(NSURLSession *)session
//      downloadTask:(NSURLSessionDownloadTask *)downloadTask
//didFinishDownloadingToURL:(NSURL *)location
//{
//    AFURLSessionManagerTaskDelegate *delegate = [self delegateForTask:downloadTask];
//    if (self.downloadTaskDidFinishDownloading) {
//        NSURL *fileURL = self.downloadTaskDidFinishDownloading(session, downloadTask, location);
//        if (fileURL) {
//            delegate.downloadFileURL = fileURL;
//            NSError *error = nil;
//            [[NSFileManager defaultManager] moveItemAtURL:location toURL:fileURL error:&error];
//            if (error) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:AFURLSessionDownloadTaskDidFailToMoveFileNotification object:downloadTask userInfo:error.userInfo];
//            }
//
//            return;
//        }
//    }
//
//    if (delegate) {
//        [delegate URLSession:session downloadTask:downloadTask didFinishDownloadingToURL:location];
//    }
//}
//5.2 dataTaskWithRequest: completionHandler:
//说明：这个NSURLSession的API容易跟AFURLSessionManager的API混淆，参数都是一个request和一个handler block。
//
//NSURLSession的API是这样的:
//- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
//{
//而AFURLSessionManager的API是这样的，可以对比学习下：
//- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
//{
////调用示例 -- dataTaskWithRequest: DownloadVC.m
//
// // 创建下载URL
//        NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
//
//        // 2.创建request请求
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//
//        // 设置HTTP请求头中的Range
//        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentLength];
//        [request setValue:range forHTTPHeaderField:@"Range"];
//
//        __weak typeof(self) weakSelf = self;
//        _downloadTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//            NSLog(@"dataTaskWithRequest");
//
//            // 清空长度
//            weakSelf.currentLength = 0;
//            weakSelf.fileLength = 0;
//
//            // 关闭fileHandle
//            [weakSelf.fileHandle closeFile];
//            weakSelf.fileHandle = nil;
//
//        }];
//}
//其中self.manager是懒加载得到的AFURLSessionManager

/**
 * manager的懒加载
 */
//- (AFURLSessionManager *)manager {
//    if (!_manager) {
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        // 1. 创建会话管理者
//        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    }
//    return _manager;
//}
//内部封装分析 AFURLSessionManager.m

//- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
//                            completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
//{
//    return [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:completionHandler];
//}
//- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
//                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
//                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
//                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler {
//
//    __block NSURLSessionDataTask *dataTask = nil;
//    url_session_manager_create_task_safely(^{
//        dataTask = [self.session dataTaskWithRequest:request];
//    });
//
//    [self addDelegateForDataTask:dataTask uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completionHandler];
//
//    return dataTask;
//}

//6. 调用栈分析
//初始化AFHTTPSessionManager的内部实现调用栈
//
//[AFHTTPSessionManager initWithBaseURL:]
//[AFHTTPSessionManager initWithBaseURL:sessionConfiguration:]
//[AFURLSessionManager initWithSessionConfiguration:] // 调用了父类AFURLSessionManager的初始化方法
//[NSURLSession sessionWithConfiguration:delegate:delegateQueue:] // 调用了原生类NSURLSession的初始化方法
//[AFJSONResponseSerializer serializer]
//[AFSecurityPolicy defaultPolicy]
//[AFNetworkReachabilityManager sharedManager]
//[AFHTTPRequestSerializer serializer]
//[AFJSONResponseSerializer serializer]
//AFHTTPSessionManager发送请求的内部实现调用栈
//
//[AFHTTPSessionManager GET:parameters:process:success:failure:]
//[AFHTTPSessionManager dataTaskWithHTTPMethod:parameters:uploadProgress:downloadProgress:success:failure:] // 【注解1】
//[AFHTTPRequestSerializer requestWithMethod:URLString:parameters:error:] // 获得NSMutableURLRequest
//[AFURLSessionManager dataTaskWithRequest:uploadProgress:downloadProgress:completionHandler:] // 【注解2】
//[NSURLSession dataTaskWithRequest:] // 【注解3】
//[AFURLSessionManager addDelegateForDataTask:uploadProgress:downloadProgress:completionHandler:] // 添加代理
//[AFURLSessionManagerTaskDelegate init]
//[AFURLSessionManager setDelegate:forTask:]
//[NSURLSessionDataTask resume]
//其中，【注解1】、【注解2】、【注解3】这三个方法得到的是同一个对象，即【注解3】中系统原生的NSURLSessionDataTask对象。所以，AF请求操作内部实现也是和原生NSURLSession操作一样，创建task，调用resume发送请求。
//
//7. 开放问题：session与TCP连接数
//请求的时候，NSURLSession的session跟TCP的个数是否有什么关系？有人说请求同域名且共享的session会复用同一个TCP链接，否则就不复用，就一个session一个TCP连接？
//
//关于这块的知识可研究资料较少，且不可信，笔者日后研究到确定的答案后再更新。也欢迎读者留下自己的见解。
//
//不过据我观察，可能没那么简单，新的iOS11系统新增了多路TCP即Multipath-TCP，因而也为NSURLSession和NSURLSessionConfiguration提供了新的属性multipathServiceType，以及HTTPMaximumConnectionsPerHost。下面是它们的定义：
//
//NSURLSession.h
///* multipath service type to use for connections.  The default is NSURLSessionMultipathServiceTypeNone */
//@property NSURLSessionMultipathServiceType multipathServiceType API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(macos, watchos, tvos);
//
///* The maximum number of simultanous persistent connections per host */
//@property NSInteger HTTPMaximumConnectionsPerHost;
//NSURLSession.h
//typedef NS_ENUM(NSInteger, NSURLSessionMultipathServiceType)
//{
//    NSURLSessionMultipathServiceTypeNone = 0,       /* None - no multipath (default) */
//    NSURLSessionMultipathServiceTypeHandover = 1,       /* Handover - secondary flows brought up when primary flow is not performing adequately. */
//    NSURLSessionMultipathServiceTypeInteractive = 2, /* Interactive - secondary flows created more aggressively. */
//    NSURLSessionMultipathServiceTypeAggregate = 3    /* Aggregate - multiple subflows used for greater bandwitdh. */
//} API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(macos, watchos, tvos) NS_SWIFT_NAME(URLSessionConfiguration.MultipathServiceType);
//NSURLSessionConfiguration.h
///* multipath service type to use for connections.  The default is NSURLSessionMultipathServiceTypeNone */
//@property NSURLSessionMultipathServiceType multipathServiceType API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(macos, watchos, tvos);
//
///* The maximum number of simultanous persistent connections per host */
//@property NSInteger HTTPMaximumConnectionsPerHost;
//

@end
