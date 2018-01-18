//
//  NSFileManager+Utils.h
//  7.6数据存储_Study1
//
//  Created by 曹学亮 on 15/7/6.
//  Copyright (c) 2015年 曹学亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Utils)

//沙箱根目录
+(NSString *)homeDirectory;
+(NSString *)documentsDirectory;
+(NSString *)libraryDirectory;
+(NSString *)tmpDirectory;
+(NSString *)cachesDirectory;

//检查指定路径目录是否存在
+(BOOL)directoryExistAtPath:(NSString*)directory;


//检查指定路径文件是否存在
+(BOOL)fileExistAt:(NSString*)filePath;



//创建目录
+(BOOL)createDirectory:(NSString*)directoryPath;



//在指定位置创建文件并写入内容
+(BOOL)createFile:(NSString *)filePath withContent:(NSData*)content;



//将文件或目录拷贝到指定位置
+(BOOL)copySourceItem:(NSString*)sourceItemPath toDestinationItem:(NSString*)destinationItemPath;


//将文件或目录移动到指定位置
+(BOOL)moveSourceItem:(NSString*)sourceItemPath toDestinationItem:(NSString*)destinationItemPath;


//获得返回目录的内容
+(NSArray*)contentAtDirectory:(NSString*)directory;


//获得文件或目录的属性信息
+(NSString*)itemAttributesAtPath:(NSString*)path;



//移除指定位置的文件或目录
+(BOOL)removeItemAtPath:(NSString*)path;
@end
