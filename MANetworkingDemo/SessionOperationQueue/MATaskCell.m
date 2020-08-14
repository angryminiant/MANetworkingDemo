//
//  MATaskCell.m
//  MANetworkingDemo
//
//  Created by ma on 2020/8/13.
//  Copyright © 2020 com.ma. All rights reserved.
//

#import "MATaskCell.h"
//#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface MATaskCell ()

@property (weak, nonatomic) IBOutlet UIView *playerView;


@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@end
@implementation MATaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.progressView.progress = 0;
    [self btnActionClick:self.btnAction];
}

- (void) loadAVPlayerWith:(id)path  {

    [_playerLayer removeFromSuperlayer];
    _playerItem = nil;
    _player = nil;
    _playerLayer = nil;
    
    //获取视频数据（1234.MP4视频已被移除，请自行测试）
//    NSURL *url = [[NSBundle mainBundle]URLForResource:@"1234" withExtension:@"mp4"]; // ok
    
//    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"1234.mp4" ofType:nil]; // ok
//    NSURL *url = [NSURL fileURLWithPath:urlStr];
        
    NSURL *url = [NSURL fileURLWithPath:path]; // ok
    
    _playerItem = [AVPlayerItem playerItemWithURL:url];// 创建playerItem
    _player = [AVPlayer playerWithPlayerItem:_playerItem];// 创建playerItem
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];// 创建playerLayer
    _playerLayer.frame = self.playerView.bounds;
    [self.playerView.layer addSublayer:_playerLayer];// 添加到_playerView中
    
    
    [self btnActionClick:self.btnAction];
}

- (IBAction)btnActionClick:(UIButton *)sender {
    
    if ( _player ) {
        
        if ( sender.isSelected == NO ) {
            [_player play];
            [sender setTitle:@"播放中，点击暂停" forState:UIControlStateNormal];
        }
        else {
            [_player pause];
            [sender setTitle:@"暂停中，点击播放" forState:UIControlStateNormal];
        }
        sender.selected = !sender.isSelected;
    }
    else {
        sender.selected = NO;
        [sender setTitle:@"加载中" forState:UIControlStateNormal];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
