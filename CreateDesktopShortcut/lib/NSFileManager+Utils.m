//
//  NSFileManager+Utils.m
//  7.6数据存储_Study1
//
//  Created by 曹学亮 on 15/7/6.
//  Copyright (c) 2015年 曹学亮. All rights reserved.
//

#import "NSFileManager+Utils.h"

@implementation NSFileManager (Utils)

+(NSString*)homeDirectory{

    return NSHomeDirectory();
}

+(NSString*)libraryDirectory{

    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
}

+(NSString*)documentsDirectory{

    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+(NSString*)tmpDirectory{

    return NSTemporaryDirectory();
}

+(NSString*)cachesDirectory{

 return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

//检查目录是否存在
+(BOOL)directoryExistAtPath:(NSString *)directory{
    BOOL isDirectory;
    if ([[NSFileManager defaultManager]fileExistsAtPath:directory isDirectory:&isDirectory] && isDirectory) {
        return YES;
    }
    return NO;
}

//检查文件是否存在
+(BOOL)fileExistAt:(NSString *)filePath{

    return [[NSFileManager defaultManager]fileExistsAtPath:filePath];
}


//创建目录
+(BOOL)createDirectory:(NSString *)directoryPath{
   BOOL flag = [[NSFileManager defaultManager]createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    if (flag) {
        NSLog(@"%@目录创建成功",directoryPath);
    }else{
        NSLog(@"%@目录创建失败",directoryPath);
    }
    return flag;
}

//创建带有内容的文件
+(BOOL)createFile:(NSString *)filePath withContent:(NSData *)content{
   return [[NSFileManager defaultManager]createFileAtPath:filePath contents:content attributes:nil];
}

//将目录或文件拷贝到指定位置
+(BOOL)copySourceItem:(NSString *)sourceItemPath toDestinationItem:(NSString *)destinationItemPath{
    NSError * error;
    BOOL flag = [[NSFileManager defaultManager]copyItemAtPath:sourceItemPath toPath:destinationItemPath error:&error];
    if (error) {
        NSLog(@"拷贝失败。。。");
    }
    return flag;
}

//将目录或文件移动到指定位置
+(BOOL)moveSourceItem:(NSString*)sourceItemPath toDestinationItem:(NSString*)destinationItemPath{
    NSError * error;
    BOOL flag = [[NSFileManager defaultManager]moveItemAtPath:sourceItemPath toPath:destinationItemPath error:&error];
    if (error) {
        NSLog(@"移动失败。。。。");
    }
    return flag;
}

//返回指定路径的内容
+(NSArray*)contentAtDirectory:(NSString *)directory{
    NSError * error;
    NSArray * contentArray = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:directory error:&error];
    if (error) {
        NSLog(@"目录内容读取出错，错误是%@",error);
    }
    return contentArray;
}

//读取文件或目录的属性信息
+(NSString*)itemAttributesAtPath:(NSString *)path{
    NSError * error;
    NSDictionary * attributes = [[NSFileManager defaultManager]attributesOfItemAtPath:path error:&error];
    if (error) {
        NSLog(@"读取目标目录或文件属性失败，错误是%@",error);
    }
   //让输出的内容分行
    NSMutableString * attributeString = [NSMutableString string];
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [attributeString appendString:[NSString stringWithFormat:@"%@:%@",key,obj]];
        [attributeString appendString:@"\n"];
    }];
    return attributeString;
}

//删除指定位置的目录或文件

+(BOOL)removeItemAtPath:(NSString *)path{
    NSError * error;
   BOOL flag = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
    if (error) {
        NSLog(@"删除失败，错误是%@",error);
    }
    return flag;
}

@end
