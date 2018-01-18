//
//  CXLCreateDesktopManager.m
//  CreateDesktopShortcut
//
//  Created by 曹学亮 on 2018/1/18.
//  Copyright © 2018年 caoxueliang.cn. All rights reserved.
//

#import "CXLCreateDesktopManager.h"
#import <CocoaHTTPServer/HTTPServer.h>
#import "NSFileManager+Utils.h"
#import "UIImage+CXLDataURLImage.h"
#import <YYCategories/YYCategories.h>

static NSString *CXLAppTitle = @"CXLAppTitle";
static NSString *CXLIconImageData = @"CXLIconImageData";
static NSString *CXLLaunchImageData = @"CXLLaunchImageData";
static NSString *CXLAppScheme = @"CXLAppScheme";
static NSString *CXLDataURISchemeContent = @"CXLDataURISchemeContent";
static NSString *CXLWebPath = @"CXLWebPath";

@interface CXLCreateDesktopManager()
@property(nonatomic, strong) HTTPServer *myHTTPServer;
@end

@implementation CXLCreateDesktopManager
#pragma mark - Main Menthod
+ (CXLCreateDesktopManager *)sharedInsance{
    static CXLCreateDesktopManager *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[CXLCreateDesktopManager alloc] init];
    });
    return sharedInstance;
}

- (void)createDesktopWithIconImage:(NSString *)iconImageName launchImage:(NSString *)launchImageName appTitle:(NSString *)title URLScheme:(NSString *)scheme{
    
    NSString *iconDataURLImage = [[UIImage imageNamed:iconImageName] dataURISchemeImage];
    NSString *launchDataURLImage = [[UIImage imageNamed:launchImageName] dataURISchemeImage];
    NSString *contentHtmlString = [self contentHtmlWithIconImageString:iconDataURLImage launchImageString:launchDataURLImage title:title appScheme:scheme];
    
    contentHtmlString = [contentHtmlString base64EncodedString];
    NSString *DataURIString = [NSString stringWithFormat:@"0;data:text/html;charset=utf-8;base64,%@",contentHtmlString];
    NSString *indexHtmlString = [self indexHtmlWithBase64ContentString:DataURIString];
    
    int localPort = 12346;
    /*将转换index.html保存到本地*/
    if ([self writeHTMLToDocument:indexHtmlString]) {
        /*配置本地服务器*/
        [self configHttpServerWithPort:localPort htmlString:indexHtmlString];
    }
    
    /*启动服务*/
    if ([self startServer]) {
        NSString *localAddress = [NSString stringWithFormat:@"http://127.0.0.1:%d",localPort];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:localAddress]];
    };
}

#pragma mark - HttpServerMethod
- (void)configHttpServerWithPort:(int)port htmlString:(NSString *)html{
    //配置HttpServer
    if (_myHTTPServer) {
        [_myHTTPServer stop];
    }
    if (!_myHTTPServer) {
        _myHTTPServer = [[HTTPServer alloc] init];
        [_myHTTPServer setType:@"_http._tcp."];
    }
    [_myHTTPServer setPort:port];
    NSString *serverWebPath = [self getServerWebPath];
    [_myHTTPServer setDocumentRoot:serverWebPath];
    NSLog(@"WebPath路径:%@", serverWebPath);
}

- (BOOL)startServer{
    NSError *error;
    BOOL isSucess = NO;
    if([_myHTTPServer start:&error]){
        isSucess = YES;
        NSLog(@"Started HTTP Server on port %hu", [_myHTTPServer listeningPort]);
    }else{
        isSucess = NO;
        NSLog(@"Error starting HTTP Server: %@", error);
    }
    return isSucess;
}

#pragma mark - HTML Menthod
-(NSString *)contentHtmlWithIconImageString:(NSString *)iconImageString launchImageString:(NSString *)launchImageString title:(NSString *)title appScheme:(NSString *)scheme{
    
    NSString *contentHtmlPath = [self getcontentHTMLTempletPath];
    NSString *contentHtmlString = [NSString stringWithContentsOfFile:contentHtmlPath encoding:NSUTF8StringEncoding error:nil];
    
    /*替换字符串*/
    contentHtmlString = [contentHtmlString stringByReplacingOccurrencesOfString:CXLIconImageData withString:iconImageString];
    contentHtmlString = [contentHtmlString stringByReplacingOccurrencesOfString:CXLLaunchImageData withString:launchImageString];
    contentHtmlString = [contentHtmlString stringByReplacingOccurrencesOfString:CXLAppTitle withString:title];
    contentHtmlString = [contentHtmlString stringByReplacingOccurrencesOfString:CXLAppScheme withString:scheme];
    return contentHtmlString;
    
}

-(NSString *)indexHtmlWithBase64ContentString:(NSString *)contentString{
    NSString *indexHtmlPath = [self getIndexHTMLTempletPath];
    NSString *indexHtmlString = [NSString stringWithContentsOfFile:indexHtmlPath encoding:NSUTF8StringEncoding error:nil];
    /*替换字符串*/
    indexHtmlString = [indexHtmlString stringByReplacingOccurrencesOfString:CXLDataURISchemeContent withString:contentString];
    return indexHtmlString;
}

#pragma mark - File Menthod
- (BOOL)writeHTMLToDocument:(NSString *)htmlString{
    NSString *serverWebPath = [self getServerWebPath];
    /*如果目录存在，先将目录删除*/
    if ([NSFileManager directoryExistAtPath:serverWebPath]) {
        [NSFileManager removeItemAtPath:serverWebPath];
    }
    BOOL writeSuccess = NO;
    /*创建目录成功后，进行写入操作*/
    if ([NSFileManager createDirectory:serverWebPath]) {
        NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
        BOOL writeToDucument = [data writeToFile:[NSString stringWithFormat:@"%@/index.html",serverWebPath] atomically:YES];
        if (writeToDucument) {
            NSLog(@"index.html 写入文件成功");
            writeSuccess = YES;
        }
    }
    return writeSuccess;
}

- (NSString *)getServerWebPath{
    NSString *serverWebPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:CXLWebPath];
    return serverWebPath;
}

- (NSString *)getIndexHTMLTempletPath{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/index.html"];
    return path;
}

- (NSString *)getcontentHTMLTempletPath{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/content.html"];
    return path;
}

@end
