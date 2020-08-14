//
//  MAOperation.m
//  MANetworkingDemo
//
//  Created by ma on 2020/8/12.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import "MAOperation.h"

@interface MAOperation ()

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;

@end


@implementation MAOperation

@synthesize cancelled = _cancelled;
@synthesize finished = _finished;
@synthesize executing = _executing;


#pragma mark - Task操作
- (void)suspendTask {
    
    if ( self.isExecuting ) self.executing = NO;
    [self cancel];
}

- (void) completionTask {
        
    if ( !self.isFinished )  self.finished = YES;
    if ( self.isExecuting ) self.executing = NO;
}


#pragma mark - KVO手动绑定 set方法
- (void)setFinished:(BOOL)finished {

    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setCancelled:(BOOL)cancelled {
    
    [self willChangeValueForKey:@"isCancelled"];
    _cancelled = cancelled;
    [self didChangeValueForKey:@"isCancelled"];
}

#pragma mark - 重写
- (void)start {
    
    @synchronized ( self ) {
        
        if ( self.isCancelled ) {
            
            self.finished = YES;
        }
        else {
            
            self.executing = YES;
            [self.dataTask resume];
        }
    }
}

- (void)cancel {
    
    @synchronized ( self ) {

        if ( self.isFinished ) return;
        
        [super cancel];// self.cancelled = YES;
        [self.dataTask cancel];// self.dataTask = nil;
        [self completionTask];
    }
}


@end
