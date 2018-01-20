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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    sleep(1);
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

