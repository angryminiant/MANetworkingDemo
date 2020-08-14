//
//  MAOperation.h
//  MANetworkingDemo
//
//  Created by ma on 2020/8/12.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// @protocol 与 @interface 可以同名
@protocol MAOperation <NSObject>
@end


@protocol MAOperationDelegate <NSObject>


@end


@interface MAOperation : NSOperation

@property (strong, nonatomic) NSURLSessionTask *dataTask;

#pragma mark - Task操作
- (void)suspendTask;

- (void) completionTask;

@end

NS_ASSUME_NONNULL_END
