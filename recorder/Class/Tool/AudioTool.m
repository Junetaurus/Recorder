//
//  AudioTool.m
//  recorder
//
//  Created by Zhang on 2021/1/29.
//

#import "AudioTool.h"
#import <AVFoundation/AVFoundation.h>
#import "RecorderModel.h"

@interface AudioTool () <AVAudioRecorderDelegate>

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

- (instancetype)init {
    self = [super init];
    if (self) {
        [AVAudioSession.sharedInstance setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [AVAudioSession.sharedInstance setActive:YES error:nil];
    }
    return self;
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
    //
    _audioRecorder = [self audioRecorderWithPath:model.recorderPath];
    if (_audioRecorder) {
        _audioRecorder.meteringEnabled = YES;
        if ([_audioRecorder prepareToRecord]) {
            [_audioRecorder record];
        }
    }
}

- (void)stopRecorder {
    if (_audioRecorder) {
        [_audioRecorder stop];
        _audioPlayer.delegate = nil;
        _audioRecorder = nil;
    }
}

- (BOOL)deleteRecorderWithModel:(RecorderModel *)model {
    [self stopPlay];
    NSError *error;
    return [NSFileManager.defaultManager removeItemAtPath:model.recorderPath error:&error];
}

- (void)startPlayWithModel:(RecorderModel *)model {
    [self stopPlay];
    if (!model) return;
    //
    _audioPlayer = [self audioPlayerWithPath:model.recorderPath];
    if (_audioPlayer) {
        if ([_audioPlayer prepareToPlay]) {
            [_audioPlayer play];
        }
    }
}

- (void)stopPlay {
    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSError *error;
    if (!flag) error = [NSError errorWithDomain:NSFilePathErrorKey code:100 userInfo:nil];
    if ([_delegate respondsToSelector:@selector(audioToolResult:error:)]) {
        [_delegate audioToolResult:AudioTypeRecorder error:error];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    if ([_delegate respondsToSelector:@selector(audioToolResult:error:)]) {
        [_delegate audioToolResult:AudioTypeRecorder error:error];
    }
}

#pragma mark - getter
- (AVAudioRecorder *)audioRecorderWithPath:(NSString *)path {
    if (path) {
        NSURL *url = [NSURL URLWithString:path];
        NSDictionary *settings = @{AVEncoderAudioQualityKey : [NSNumber numberWithInteger:AVAudioQualityLow],
                                   AVEncoderBitRateKey : [NSNumber numberWithInteger:16],
                                   AVSampleRateKey : [NSNumber numberWithFloat:8000],
                                   AVNumberOfChannelsKey : [NSNumber numberWithInteger:2]};
        NSError *error;
        AVAudioRecorder *audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
        audioRecorder.delegate = self;
        if (!error) {
            return audioRecorder;
        }
    }
    return nil;
}

- (AVAudioPlayer *)audioPlayerWithPath:(NSString *)path {
    if (path) {
        NSURL *url = [NSURL URLWithString:path];
        NSError *error;
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioPlayer.numberOfLoops = 0;
        audioPlayer.volume = 1.0;
        if (!error) {
            return audioPlayer;
        }
    }
    return nil;
}

@end
