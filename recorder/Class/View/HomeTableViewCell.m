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
@property (nonatomic, strong, readwrite) UIImageView *playImageView;

@end

@implementation HomeTableViewCell

+ (CGFloat)cellHeight {
    return 60.0f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.playImageView];
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
    
    [_playImageView sizeToFit];
    _playImageView.x = self.width - _playImageView.width - 20;
    _playImageView.y = (self.height - _playImageView.height)/2;
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

- (UIImageView *)playImageView {
    if (!_playImageView) {
        _playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play"]];
        _playImageView.hidden = YES;
    }
    return _playImageView;
}

@end
