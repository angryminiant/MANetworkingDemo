//
//  SessionUploadVC.m
//  MANetworking
//
//  Created by ma on 2020/8/11.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import "SessionUploadVC.h"


@interface SessionUploadVC ()

@property(nonatomic,strong) UILabel *lblProgress;

@end

@implementation SessionUploadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

    [self setUI];
}


- (void)setUI {
    
    // 下载
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(20, 0, 200, 40);
    [button setTitle:@"上传" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.center = CGPointMake(kScreanWidth * 0.5, 150);
    [button addTarget:self action:@selector(sessionUploadTask) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // 进度值
    self.lblProgress = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.lblProgress.textColor = [UIColor blackColor];
    self.lblProgress.font = [UIFont boldSystemFontOfSize:15];
    self.lblProgress.textAlignment = NSTextAlignmentCenter;
    self.lblProgress.center = CGPointMake(kScreanWidth * 0.5, 220);
    self.lblProgress.text = [NSString stringWithFormat:@"未上传"];
    [self.view addSubview:self.lblProgress];
}

- (void) sessionUploadTask {
    
    NSURL *url = [NSURL URLWithString:JsonUrlLink];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    //设置请求体
    [request setValue:[NSString stringWithFormat: @"multipart/form-data;%@", @"cs"] forHTTPHeaderField:@"Content-type"];
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picture" ofType:@"jpg"]];
    
    // 拼接body，可扩展
    NSMutableData *myRequestData = [NSMutableData data];
    [myRequestData appendData:data];//将image的data加入
    NSData *body = myRequestData;
    
    // 发送请求
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error = %@",error.description);
        } else {
            NSLog(@"upload  success");
        }
        
        // 注意 [NSThread currentThread]
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lblProgress.text = [NSString stringWithFormat:@"上传-%@, error：%@", error ? @"失败" : @"成功", error.description?:@""];
        });
    }];
    [uploadTask resume];
}

#pragma mark-拼接请求体

- (NSData *)getBodyDataWithBoundary:(NSString *)boundary
                                  params:(NSDictionary *)params
                               fieldName:(NSString *)fieldName
                                fileName:(NSString *)fileName
                         fileContentType:(NSString *)fileContentType
                                    data:(NSData *)fileData {
    
    // NSData *body =  [self getBodyDataWithBoundary:@"cs" params:@{@"access_token":@"2.00cYYKWF6EKpiB3883361b1dJiZ4eD",@"status":@"哈哈，这是我测试NSURLSession上传文件的微博"} fieldName:@"pic" fileName:@"pic.png" fileContentType:@"image/png" data:data];
    NSString *preBoundary = [NSString stringWithFormat:@"--%@",boundary];
    NSString *endBoundary = [NSString stringWithFormat:@"--%@--",boundary];
    NSMutableString *body = [[NSMutableString alloc] init];
    //遍历
    for (NSString *key in params) {
        //得到当前的key
        //如果key不是当前的pic，说明value是字符类型，比如name：Boris
        //添加分界线，换行，必须使用\r\n
        [body appendFormat:@"%@\r\n",preBoundary];
        //添加字段名称换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段值
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
    }
    //添加分界线，换行
    [body appendFormat:@"%@\r\n",preBoundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",fieldName,fileName];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: %@\r\n\r\n",fileContentType];
    //声明结束符
    NSString *endStr = [NSString stringWithFormat:@"\r\n%@",endBoundary];
    //声明myRequestData，用来放入http  body
    NSMutableData *myRequestData = [NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:fileData];
    //加入结束符--hwg--
    [myRequestData appendData:[endStr dataUsingEncoding:NSUTF8StringEncoding]];
    return myRequestData;
}

@end
