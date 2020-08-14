//
//  MATaskCell.h
//  MANetworkingDemo
//
//  Created by ma on 2020/8/13.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MATaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnAction;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

- (void) loadAVPlayerWith:(id)path;

@end

NS_ASSUME_NONNULL_END
