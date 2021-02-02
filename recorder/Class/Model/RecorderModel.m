//
//  RecorderModel.m
//  recorder
//
//  Created by Zhang on 2021/1/29.
//

#import "RecorderModel.h"
#import <objc/runtime.h>

@interface RecorderModel () <NSCoding>

@property (nonatomic, copy, readwrite) NSString *recorderId;
@property (nonatomic, copy, readwrite) NSString *recorderPath;

@end

@implementation RecorderModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _recorderName = @"我的录音";
        _recorderTime = [self getCurrentTime];
        _recorderId = [NSUUID UUID].UUIDString;
    }
    return self;
}

- (NSString *)recorderPath {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"XRecorder"];
    if (![NSFileManager.defaultManager fileExistsAtPath:filePath]) {
        [NSFileManager.defaultManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@%@", self.recorderId, @".caf"];
    return [filePath stringByAppendingPathComponent:fileName];
}

- (NSString *)getCurrentTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    return [forMatter stringFromDate:date];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)coder {
    unsigned int count = 0;
    Ivar *ivarLists = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = ivar_getName(ivarLists[i]);
        NSString *strName = [NSString stringWithUTF8String:name];
        [coder encodeObject:[self valueForKey:strName] forKey:strName];
    }
    free(ivarLists);
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        unsigned int count = 0;
        Ivar *ivarLists = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            const char *name = ivar_getName(ivarLists[i]);
            NSString *strName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            id value = [coder decodeObjectForKey:strName];
            [self setValue:value forKey:strName];
        }
        free(ivarLists);
    }
    return self;
}

@end
