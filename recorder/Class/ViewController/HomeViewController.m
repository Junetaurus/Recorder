//
//  HomeViewController.m
//  recorder
//
//  Created by Zhang on 2021/1/29.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "RecorderViewController.h"
#import "AudioTool.h"

#define RecorderDataKey @"XRecorderDataKey"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <RecorderModel *> *dataArray;
@property (nonatomic, strong) UIButton *recorderBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"录音机";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.recorderBtn];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _tableView.frame = self.view.bounds;
    [_recorderBtn sizeToFit];
    _recorderBtn.x = self.view.width - _recorderBtn.width - 20;
    _recorderBtn.y = self.view.height * 0.8;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(HomeTableViewCell.class)];
    [cell bindModel:_dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HomeTableViewCell.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [AudioTool.tool startPlayWithModel:_dataArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        RecorderModel *model = _dataArray[indexPath.row];
        if ([AudioTool.tool deleteRecorderWithModel:model]) {
            [_dataArray removeObject:model];
            [_tableView reloadData];
            [self storageRecorderData];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark - event
- (void)btnClick:(UIButton *)btn {
    if (btn == _recorderBtn) {
        RecorderViewController *recorderVC = [[RecorderViewController alloc] init];
        recorderVC.modalPresentationStyle = UIModalPresentationFullScreen;
        __weak typeof(self)weakSelf = self;
        recorderVC.recorderBlock = ^(RecorderModel * _Nonnull model) {
            [weakSelf.dataArray addObject:model];
            [weakSelf.tableView reloadData];
            [weakSelf storageRecorderData];
        };
        [self presentViewController:recorderVC animated:YES completion:nil];
    }
}

- (void)storageRecorderData {
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:_dataArray.count];
    for (RecorderModel *model in _dataArray) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
        [dataArray addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dataArray.copy forKey:RecorderDataKey];
}

- (NSArray *)getRecorderData {
    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:RecorderDataKey];
    for (NSData *data in array) {
        RecorderModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (model) {
            [dataArray addObject:model];
        }
    }
    
    return dataArray.copy;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:HomeTableViewCell.class forCellReuseIdentifier:NSStringFromClass(HomeTableViewCell.class)];
    }
    return _tableView;
}

- (NSMutableArray<RecorderModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithArray:[self getRecorderData]];
    }
    return _dataArray;
}

- (UIButton *)recorderBtn {
    if (!_recorderBtn) {
        _recorderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recorderBtn setImage:[UIImage imageNamed:@"recorder"] forState:UIControlStateNormal];
        [_recorderBtn setImage:[UIImage imageNamed:@"recorder"] forState:UIControlStateHighlighted];
        [_recorderBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recorderBtn;
}

@end
