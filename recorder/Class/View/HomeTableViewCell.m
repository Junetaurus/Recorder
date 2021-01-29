//
//  HomeTableViewCell.m
//  recorder
//
//  Created by Zhang on 2021/1/29.
//

#import "HomeTableViewCell.h"
#import "RecorderModel.h"
#import "UIView+Frame.h"

@interface HomeTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation HomeTableViewCell

+ (CGFloat)cellHeight {
    return 60.0f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (void)bindModel:(RecorderModel *)model {
    if (!model) return;
    
    _nameLabel.text = model.recorderName;
    _timeLabel.text = model.recorderTime;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_nameLabel sizeToFit];
    if (_nameLabel.width > self.width/2) {
        _nameLabel.width = self.width/2;
    }
    _nameLabel.x = 20;
    
    [_timeLabel sizeToFit];
    _timeLabel.x = _nameLabel.x;
    
    CGFloat margin = ([self.class cellHeight] - _nameLabel.height - _timeLabel.height)/3;
    _nameLabel.y = margin;
    _timeLabel.y = self.height - margin - _timeLabel.height;
}

#pragma mark - getter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor grayColor];
    }
    return _timeLabel;
}

@end
