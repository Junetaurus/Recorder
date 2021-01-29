//
//  AudioTool.m
//  recorder
//
//  Created by Zhang on 2021/1/29.
//

#import "AudioTool.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioTool ()

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

- (void)startRecorder {
    
}

- (void)stopRecorder {
    
}

- (void)startPlay {
    
}

- (void)stopPlay {
    
}

@end
