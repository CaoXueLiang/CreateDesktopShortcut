//
//  CXLRootViewController.m
//  CreateDesktopShortcut
//
//  Created by bjovov on 2018/1/18.
//  Copyright © 2018年 caoxueliang.cn. All rights reserved.
//

#import "CXLRootViewController.h"
#import <YYCategories/YYCategories.h>
#import "CXLDetailViewController.h"

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
    self.navigationItem.title = @"首页";
}

#pragma mark - UITableView M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CXLDetailViewController *controller = [CXLDetailViewController initWithTitle:self.dataArray[indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
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
