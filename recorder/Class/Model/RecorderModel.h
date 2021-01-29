//
//  RecorderModel.h
//  recorder
//
//  Created by Zhang on 2021/1/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecorderModel : NSObject

@property (nonatomic, copy) NSString *recorderName;
@property (nonatomic, copy) NSString *recorderTime;
@property (nonatomic, copy, readonly) NSString *recorderId;
@property (nonatomic, copy, readonly) NSString *recorderPath;

@end

NS_ASSUME_NONNULL_END
