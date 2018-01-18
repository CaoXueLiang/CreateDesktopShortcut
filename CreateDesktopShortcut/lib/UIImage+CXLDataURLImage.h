//
//  UIImage+CXLDataURLImage.h
//  CreateDesktopShortcut
//
//  Created by 曹学亮 on 2018/1/18.
//  Copyright © 2018年 caoxueliang.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CXLDataURLImage)
/**
 *    @brief    生成Data URL Scheme 形式的图片字符串
 *
 *    @return    Data URL Scheme 形式的图片字符串
 */
- (NSString *)dataURISchemeImage;
@end
