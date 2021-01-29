//
//  AudioTool.h
//  recorder
//
//  Created by Zhang on 2021/1/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioTool : NSObject

+ (instancetype)tool;

//录音
- (void)startRecorder;

- (void)stopRecorder;

//播放
- (void)startPlay;

- (void)stopPlay;

@end

NS_ASSUME_NONNULL_END
