//
//  CXLCreateDesktopManager.h
//  CreateDesktopShortcut
//
//  Created by 曹学亮 on 2018/1/18.
//  Copyright © 2018年 caoxueliang.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CXLCreateDesktopManager : NSObject

/**
 创建CXLCreateDesktopManager单例
 @return CXLCreateDesktopManager单例
 */
+ (CXLCreateDesktopManager *)sharedInsance;


/**
 创建桌面快捷方式
 @param iconImageName    app图标
 @param launchImageName  启动图
 @param title            app名称
 @param scheme           APP的URL Schemes
 */
- (void)createDesktopWithIconImage:(NSString *)iconImageName launchImage:(NSString *)launchImageName appTitle:(NSString *)title URLScheme:(NSString *)scheme;

@end
