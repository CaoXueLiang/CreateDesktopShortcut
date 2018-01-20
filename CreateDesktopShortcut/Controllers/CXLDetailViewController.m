//
//  CXLDetailViewController.m
//  CreateDesktopShortcut
//
//  Created by bjovov on 2018/1/18.
//  Copyright © 2018年 caoxueliang.cn. All rights reserved.
//

#import "CXLDetailViewController.h"
#import "CXLCreateDesktopManager.h"

@interface CXLDetailViewController ()
@property (nonatomic,copy) NSString *tip;
@property (nonatomic,strong) UILabel *tipLabel;
@end

@implementation CXLDetailViewController
#pragma mark - Init Menthod
+ (instancetype)initWithTitle:(NSString *)title{
    CXLDetailViewController *controller = [[CXLDetailViewController alloc]init];
    controller.tip = title;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"详情页";
    [self addSubViews];
}

- (void)addSubViews{
    [self.view addSubview:self.tipLabel];
    self.tipLabel.frame = self.view.bounds;
    self.tipLabel.text = self.tip;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"+快捷方式" style:UIBarButtonItemStylePlain target:self action:@selector(addDesktop)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

#pragma mark - Event Response
- (void)addDesktop{
    NSString *scheme = [NSString stringWithFormat:@"CreateDesktop://%@",self.tip];
    [[CXLCreateDesktopManager sharedInsance] createDesktopWithIconImage:@"icoImage" launchImage:@"launch" appTitle:@"桌面快捷方式" URLScheme:scheme];
}

#pragma mark - Setter && Getter
- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.font = [UIFont boldSystemFontOfSize:50];
        _tipLabel.textColor = [UIColor blueColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

@end
