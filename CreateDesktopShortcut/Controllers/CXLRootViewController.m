//
//  CXLRootViewController.m
//  CreateDesktopShortcut
//
//  Created by bjovov on 2018/1/18.
//  Copyright © 2018年 caoxueliang.cn. All rights reserved.
//

#import "CXLRootViewController.h"
#import <YYCategories/YYCategories.h>

@interface CXLRootViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTable;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation CXLRootViewController
#pragma mark - Init Menthod
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTable];
}

#pragma mark - UITableView M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
}



#pragma mark - Setter && Getter
- (UITableView *)myTable{
    if (!_myTable) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
        [_myTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _myTable.tableFooterView = [UIView new];
        _myTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _myTable.delegate = self;
        _myTable.dataSource = self;
    }
    return _myTable;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"First",@"Second",@"Third",@"Four"];
    }
    return _dataArray;
}

@end
