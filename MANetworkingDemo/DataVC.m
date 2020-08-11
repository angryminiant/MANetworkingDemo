//
//  DataVC.m
//  MANetworking
//
//  Created by ma on 2020/8/11.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import "DataVC.h"

@interface DataVC ()

@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation DataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [UIImageView new];
    self.imageView.frame = CGRectMake(20, 120, 160, 120);
    [self.view addSubview:self.imageView];
    
    [self dataWayDownload];
    
}

#pragma mark - NSData原始方式
/**
 * 使用NSData下载图片文件，并显示再imageView上
 */
- (void) dataWayDownload {

    // 在子线程中发送下载文件请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 创建下载路径
        NSURL *url = [NSURL URLWithString:@"https://cdn2.jianshu.io/assets/web/nav-logo-4c7bbafe27adc892f3046e6978459bac.png"];
        
        // NSData的dataWithContentsOfURL:方法下载
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // 回到主线程，刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image = [UIImage imageWithData:data];
        });
    });
}

@end
