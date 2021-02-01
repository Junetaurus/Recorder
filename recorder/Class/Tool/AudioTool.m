//
//  AudioTool.m
//  recorder
//
//  Created by Zhang on 2021/1/29.
//

#import "AudioTool.h"
#import <AVFoundation/AVFoundation.h>
#import "RecorderModel.h"

@interface AudioTool () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation AudioTool

+ (instancetype)tool {
    static AudioTool *tool;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[self.class alloc] init];
    });
    return tool;
}

- (void)authorization {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio
                                     completionHandler:^(BOOL granted) {}];
    }
}

- (void)startRecorderWithModel:(RecorderModel *)model {
    [self stopRecorder];
    if (!model) return;
    NSURL *url = [NSURL URLWithString:model.recorderPath];
    NSDictionary *settings = @{AVEncoderAudioQualityKey : [NSNumber numberWithInteger:AVAudioQualityLow],
                               AVEncoderBitRateKey : [NSNumber numberWithInteger:16],
                               AVSampleRateKey : [NSNumber numberWithFloat:8000],
                               AVNumberOfChannelsKey : [NSNumber numberWithInteger:2]};
    NSError *error;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (!error) {
        _audioRecorder.delegate = self;
        [_audioRecorder record];
    }
}

- (void)stopRecorder {
    if (_audioRecorder) {
        [_audioRecorder stop];
        _audioRecorder = nil;
    }
}

- (void)startPlayWithModel:(RecorderModel *)model {
    [self stopPlay];
    if (!model) return;
}

- (void)stopPlay {
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer.delegate = self;
        _audioPlayer = nil;
    }
}

@end
