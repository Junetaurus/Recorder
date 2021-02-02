//
//  HomeTableViewCell.h
//  recorder
//
//  Created by Zhang on 2021/1/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RecorderModel;

@interface HomeTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImageView *playImageView;

+ (CGFloat)cellHeight;

- (void)bindModel:(RecorderModel *)model;

@end

NS_ASSUME_NONNULL_END
