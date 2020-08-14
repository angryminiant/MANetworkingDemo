//
//  MATaskManager.h
//  MANetworkingDemo
//
//  Created by ma on 2020/8/13.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MATaskManager : NSObject


/// 进度条回调
@property (copy, nonatomic) void(^progressBlock)(CGFloat progress, NSString *urlStr);


/// 完成回调
@property (copy, nonatomic) void(^finishBlock)(NSString *path, NSString *urlStr);


/// 添加任务链接
/// @param urlStr 链接
- (void) addTaskUrl:(NSString *)urlStr;


@end

NS_ASSUME_NONNULL_END
