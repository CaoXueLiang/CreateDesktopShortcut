//
//  AppDelegate.m
//  CreateDesktopShortcut
//
//  Created by bjovov on 2018/1/18.
//  Copyright © 2018年 caoxueliang.cn. All rights reserved.
//

#import "AppDelegate.h"
#import "CXLRootViewController.h"
#import <YYCategories/YYCategories.h>
#import "CXLDetailViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CXLRootViewController *controller = [[CXLRootViewController alloc]init];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:controller];
    [self.window makeKeyAndVisible];
    [self setNavigation];
    return YES;
}

- (void)setNavigation{
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    UIImage *backgroundImage = [UIImage imageWithColor:[UIColor orangeColor]];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    NSDictionary *textAttributes = textAttributes = @{
                                                      NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                                      };
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}


-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    NSLog(@"scheme : %@",[url scheme]);
    NSLog(@"url : %@",url);
    
    if ([[url scheme] isEqualToString:@"createdesktop"] && [url absoluteString].length > 13) {
        NSString *title = [url.absoluteString substringFromIndex:16];
        CXLDetailViewController *controller = [CXLDetailViewController initWithTitle:title];
        UINavigationController *rooNav = (UINavigationController*)self.window.rootViewController;
        [rooNav pushViewController:controller animated:NO];
    }

    return YES;
}

@end
