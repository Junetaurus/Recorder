//
//  RecorderViewController.m
//  recorder
//
//  Created by Zhang on 2021/1/29.
//

#import "RecorderViewController.h"

@interface RecorderViewController ()

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *stopBtn;

@property (nonatomic, strong) RecorderModel *model;

@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.stopBtn];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_closeBtn sizeToFit];
    _closeBtn.y = UIApplication.sharedApplication.statusBarFrame.size.height + 20;
    _closeBtn.x = self.view.width - _closeBtn.width - 20;
    
    [_titleLabel sizeToFit];
    _titleLabel.centerX = self.view.width/2;
    _titleLabel.y = _closeBtn.y + _closeBtn.height + 60;
    
    _textField.size = CGSizeMake(self.view.width/2, 30);
    _textField.centerX = _titleLabel.centerX;
    _textField.y = _titleLabel.y + _titleLabel.height + 15;
    
    [_startBtn sizeToFit];
    _startBtn.x = self.view.centerX - _startBtn.width - 30;
    _startBtn.y = self.view.height * 0.65;
    
    [_stopBtn sizeToFit];
    _stopBtn.x = self.view.centerX + 30;
    _stopBtn.y = _startBtn.y;
}

- (void)btnClick:(UIButton *)btn {
    if (btn == _closeBtn) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (btn == _startBtn) {
        [self startRecorder];
    }
    if (btn == _stopBtn) {
        [self endRecorder];
    }
}

- (void)startRecorder {
    _startBtn.enabled = NO;
    _stopBtn.enabled = YES;
    //
    _model = [[RecorderModel alloc] init];
}

- (void)endRecorder {
    _startBtn.enabled = YES;
    _stopBtn.enabled = NO;
    //
    if (_model) {
        if (_textField.text.length) {
            _model.recorderName = _textField.text;
        }
        !_recorderBlock ? : _recorderBlock(_model);
    }
}

#pragma mark - getter
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateHighlighted];
        [_closeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        [_startBtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateHighlighted];
        [_startBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIButton *)stopBtn {
    if (!_stopBtn) {
        _stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopBtn.enabled = NO;
        [_stopBtn setImage:[UIImage imageNamed:@"end"] forState:UIControlStateNormal];
        [_stopBtn setImage:[UIImage imageNamed:@"end"] forState:UIControlStateHighlighted];
        [_stopBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"录音标题";
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"我的录音";
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.borderStyle = UITextBorderStyleBezel;
    }
    return _textField;
}

@end
