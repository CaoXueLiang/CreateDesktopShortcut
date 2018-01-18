//
//  UIImage+CXLDataURLImage.m
//  CreateDesktopShortcut
//
//  Created by 曹学亮 on 2018/1/18.
//  Copyright © 2018年 caoxueliang.cn. All rights reserved.
//

#import "UIImage+CXLDataURLImage.h"

@implementation UIImage (CXLDataURLImage)
- (NSString *)dataURISchemeImage{
    NSString *imageString = [UIImagePNGRepresentation(self) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *prefix = @"data:image/png;base64,";
    NSString *returnStr = [prefix stringByAppendingString:imageString];
    return returnStr;
}
@end
