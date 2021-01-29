//
//  RecorderViewController.h
//  recorder
//
//  Created by Zhang on 2021/1/29.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecorderViewController : BaseViewController

@property (nonatomic, copy) void (^recorderBlock) (RecorderModel *model);

@end

NS_ASSUME_NONNULL_END
