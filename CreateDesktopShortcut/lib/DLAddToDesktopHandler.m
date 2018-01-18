//
// DLAddToDesktopHandler.m
//  DLCreateShortcut
//
//  Created by donglei on 16/3/30.
//  Copyright © 2016年 DL. All rights reserved.
//

#import "DLAddToDesktopHandler.h"
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DLBase64.h"
#import "NSFileManager+Utils.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

#define DLCSTitle                   @"DLCSTitle"
#define DLCSImageData               @"DLCSImageData"
#define DLCSAPPScheme               @"DLCSAPPScheme"
#define DLCSDataURISchemeContent    @"DLCSDataURISchemeContent"
#define DLAPPDownloadUrl            @"DLAPPDownloadUrl"

@interface DLAddToDesktopHandler()

@property(nonatomic, strong) HTTPServer *myHTTPServer;

@end


@implementation DLAddToDesktopHandler

#pragma mark - MainMethod

+(DLAddToDesktopHandler *)sharedInsance{
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    static DLAddToDesktopHandler *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DLAddToDesktopHandler alloc] init];
    });
    
    return _sharedInstance;
}

- (void)addToDesktopWithDataURISchemeImage:(NSString *)dataURISchemeImage title:(NSString *)title urlScheme:(NSString *)urlScheme appDownloadUrl:(NSString *)appDownloadUrl{

    [self addToDesktopWithDataURISchemeImage:dataURISchemeImage
                                         title:title
                                     urlScheme:urlScheme
                                appDownloadUrl:appDownloadUrl
                                     localPort:12346];
}

- (void)addToDesktopWithDataURISchemeImage:(NSString *)dataURISchemeImage title:(NSString *)title urlScheme:(NSString *)urlScheme  appDownloadUrl:(NSString *)appDownloadUrl localPort:(int)localPort{

    NSString *contentHtmlString = [self contentHtmlWithBase64Image:dataURISchemeImage title:title appScheme:urlScheme appDownloadUrl:appDownloadUrl];
    
    contentHtmlString = [DLBase64 encodeBase64String:contentHtmlString];
    NSString *DataURIString = [NSString stringWithFormat:@"0;data:text/html;charset=utf-8;base64,%@",contentHtmlString];
    NSString *indexHtmlString = [self indexHtmlWithBase64ContentString:DataURIString];
    
    /*将转换index.html保存到本地*/
    if ([self writeHTMLToDocument:indexHtmlString]) {
        /*配置本地服务器*/
        [self configHttpServerWithPort:localPort htmlString:indexHtmlString];
    }

    /*启动服务*/
    if ([self startServer]) {
        NSString *localAddress = [NSString stringWithFormat:@"http://127.0.0.1:%d",localPort];
        /*第一次可能加载不成功，加载两次*/
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:localAddress]];
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
    
    NSLog(@"----------WebPath路径:%@", serverWebPath);
}

- (BOOL)startServer{
    NSError *error;
    BOOL isSucess = NO;
    if([_myHTTPServer start:&error]){
        isSucess = YES;
        SLog(@"--------Started HTTP Server on port %hu", [_myHTTPServer listeningPort]);
    }else{
        isSucess = NO;
        SLog(@"--------Error starting HTTP Server: %@", error);
    }
    return isSucess;
}

#pragma mark - HTMLMethod
-(NSString *)contentHtmlWithBase64Image:(NSString *)base64ImageString title:(NSString *)title appScheme:(NSString *)scheme appDownloadUrl:(NSString *)appDownloadUrl{
    
    NSString *contentHtmlPath = [self getcontentHTMLTempletPath];
    NSString *contentHtmlString = [NSString stringWithContentsOfFile:contentHtmlPath encoding:NSUTF8StringEncoding error:nil];
    
    contentHtmlString = [contentHtmlString stringByReplacingOccurrencesOfString:DLCSImageData withString:base64ImageString];
    contentHtmlString = [contentHtmlString stringByReplacingOccurrencesOfString:DLCSTitle withString:title];
    contentHtmlString = [contentHtmlString stringByReplacingOccurrencesOfString:DLCSAPPScheme withString:scheme];
    contentHtmlString = [contentHtmlString stringByReplacingOccurrencesOfString:DLAPPDownloadUrl withString:appDownloadUrl];
   
    return contentHtmlString;

}

-(NSString *)indexHtmlWithBase64ContentString:(NSString *)contentString{
    NSString *indexHtmlPath = [self getIndexHTMLTempletPath];
    NSString *indexHtmlString = [NSString stringWithContentsOfFile:indexHtmlPath encoding:NSUTF8StringEncoding error:nil];
    
    indexHtmlString = [indexHtmlString stringByReplacingOccurrencesOfString:DLCSDataURISchemeContent withString:contentString];
    
    return indexHtmlString;

}

#pragma mark - FileMethod
- (BOOL)writeHTMLToDocument:(NSString *)htmlString{
    NSString *serverWebPath = [self getServerWebPath];
    if ([NSFileManager directoryExistAtPath:serverWebPath]) {
        [NSFileManager removeItemAtPath:serverWebPath];
    }
    BOOL created = [[NSFileManager defaultManager] createDirectoryAtPath:serverWebPath withIntermediateDirectories:YES attributes:nil error:nil];
    BOOL isSucess = NO;
    if(created){
        NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
        BOOL writeToDucument = [data writeToFile:[NSString stringWithFormat:@"%@/index.html",serverWebPath] atomically:YES];
        if (writeToDucument) {
            NSLog(@"---------index.html、写入文件成功");
            isSucess = YES;
        }
    }
    return isSucess;
}

- (NSString *)getServerWebPath{
    
    NSString *serverWebPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"DLCreateShortcutWebPath"];
    
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
