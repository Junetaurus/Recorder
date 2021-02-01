//
//  AudioTool.h
//  recorder
//
//  Created by Zhang on 2021/1/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RecorderModel;

@interface AudioTool : NSObject

+ (instancetype)tool;

//授权
- (void)authorization;

//录音
- (void)startRecorderWithModel:(RecorderModel *)model;

- (void)stopRecorder;

//播放
- (void)startPlayWithModel:(RecorderModel *)model;

- (void)stopPlay;

@end

NS_ASSUME_NONNULL_END
