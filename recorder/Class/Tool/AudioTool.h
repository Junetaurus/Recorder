//
//  AudioTool.h
//  recorder
//
//  Created by Zhang on 2021/1/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AudioType) {
    AudioTypeRecorder,
    AudioTypePlay,
};

@protocol AudioToolDelegate <NSObject>

@optional

- (void)audioToolResult:(AudioType)audioType error:(NSError *)error;

@end

@class RecorderModel;

@interface AudioTool : NSObject

+ (instancetype)tool;

@property (nonatomic, weak) id<AudioToolDelegate> delegate;

//授权
- (void)authorization;

//录音
- (void)startRecorderWithModel:(RecorderModel *)model;

- (void)stopRecorder;

- (BOOL)deleteRecorderWithModel:(RecorderModel *)model;

//播放
- (void)startPlayWithModel:(RecorderModel *)model;

- (void)stopPlay;

@end

NS_ASSUME_NONNULL_END
