//
//  MATaskManager.m
//  MANetworkingDemo
//
//  Created by ma on 2020/8/13.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import "MATaskManager.h"
#import "MAOperation.h"

@interface MATaskManager ()<NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;

@property (strong, nonatomic) NSOperationQueue *downloadQueue;

@property (strong, nonatomic) NSMutableDictionary<NSString *, MAOperation *> *operationDict;

@end

@implementation MATaskManager

- (instancetype)init {
    
    if ( self = [super init] ) {
        
        self.downloadQueue = [[NSOperationQueue alloc] init];
        self.downloadQueue.maxConcurrentOperationCount = 2; // 最大并发数量
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.allowsCellularAccess = YES; // 是否允许蜂窝移动网络
        self.session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue new]];
        
        self.operationDict = [NSMutableDictionary<NSString *, MAOperation *> dictionary];
    }
    
    return self;
}

- (void) addTaskUrl:(NSString *)urlStr {
    
    NSMutableURLRequest *mUrlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:mUrlRequest];
    
    MAOperation *operation = [MAOperation new];
    operation.dataTask = task;
    [self.downloadQueue addOperation:operation];
    [self.operationDict addEntriesFromDictionary:@{urlStr : operation}];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    
    NSLog(@"error - %@", error);
    MAOperation *operation = [self.operationDict objectForKey:task.originalRequest.URL.absoluteString];
    if ( error ) {
        [operation suspendTask];
    }
    else {
        [operation completionTask];
    }
}


#pragma mark - 下载
/**
 *  写入临时文件时调用
 *  @param bytesWritten              本次写入大小
 *  @param totalBytesWritten         已写入文件大小
 *  @param totalBytesExpectedToWrite 请求的总文件的大小
 */
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    //可以监听下载的进度
    CGFloat progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;            
    if ( self.progressBlock ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressBlock( progress, downloadTask.originalRequest.URL.absoluteString);
        });
    }
}

// 下载完成调用
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    // 1 创建文件目录
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    // 2 location 是一个临时路径,需要移动到创建好的路径（caches 文件夹）中，缓存在磁盘里
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
    NSLog(@"downloadTask 移动文件路径 - %@,   location = %@", filePath, location);
    
    
    //  保存视频到相册
//    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath)) {
//        // 保存相册核心代码
//        UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, nil, nil);
//    }
    
    
    if ( self.finishBlock ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.finishBlock(filePath, downloadTask.originalRequest.URL.absoluteString);
            
        });
    }

}

@end
