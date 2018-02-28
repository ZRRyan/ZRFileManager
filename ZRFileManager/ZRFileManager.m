//
//  ZRFileManager.m
//  Pati
//
//  Created by Ryan on 2017/6/19.
//  Copyright © 2017年 mew. All rights reserved.
//

#import "ZRFileManager.h"

@implementation ZRFileManager


/**
 沙盒路径(NSDocumentDirectory)
 */
+ (NSString *)documentPath {
    
    NSArray *arrDocumentPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentPath=[arrDocumentPaths objectAtIndex:0];
    return documentPath;
}


/**
 判断文件是否存在

 @param path 文件路径
 @return 是否存在
 */
+ (BOOL)isExistsAtPath: (NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

/**
 创建一个文件夹

 @param path 文件夹路径
 @param succ 成功
 @param fail 失败
 */
+ (void)createFileDirWithPath: (NSString *)path succ: (void(^)(void))succ fail: (void(^)(void))fail {
    if ([self isExistsAtPath:path]) {
        succ();
    } else {
        if ([[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
            succ();
        } else {
            fail();
        }
    }
}

/**
 保存文件（要确保文件夹路径是存在的）

 @param path 文件路径
 @param data 文件内容
 @param succ 成功
 @param fail 失败
 */
+ (void)saveFileWithPath: (NSString *)path  data: (NSData *)data succ: (void(^)(void))succ fail: (void(^)(void))fail {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if ([manager fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory == NO) { // 文件存在
        NSError *error = nil;
        if ([manager removeItemAtPath:path error:&error] && error == nil) {
            BOOL success = [manager createFileAtPath:path contents:data attributes:nil];
            if (success) {
                succ();
            } else {
                fail();
            }
        }
    } else {
        BOOL success = [manager createFileAtPath:path contents:data attributes:nil];
        if (success) {
            succ();
        } else {
            fail();
        }
    }
}



/**
 保存文件

 @param dirPath 文件夹目录
 @param fileName 文件名称
 @param data 文件内容
 @param succ 成功
 @param fail 失败
 */
+ (void)saveFileWithDirPath: (NSString *)dirPath fileName: (NSString *)fileName data: (NSData *)data succ: (void(^)(void))succ fail: (void(^)(void))fail {
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", dirPath, fileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDirectory = NO;
    if ([manager fileExistsAtPath:dirPath isDirectory: &isDirectory] && isDirectory == NO) { // 文件存在
        [self saveFileWithPath:path data:data succ:succ fail:fail];
    } else {
        [self createFileDirWithPath:dirPath succ:^{
            [self saveFileWithPath:path data:data succ:succ fail:fail];
        } fail:fail];
    }
}


/**
 获取文件

 @param path 文件路径
 @param succ 成功
 @param fail 失败
 */
+ (void)asyncFileWithPath: (NSString *)path succ: (void(^)(NSData *data))succ fail: (void(^)(void))fail {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if ([manager fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory == NO) { // 文件存在
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        if (data) {
            succ(data);
        } else {
            fail();
        }
    } else {
        fail();
    }
}



/**
 删除文件
 
 @param path 文件路径
 @param succ 成功
 @param fail 失败
 */
+ (void)deleteFileWithPath: (NSString *)path succ: (void(^)(void))succ fail: (void(^)(void))fail {
    NSError *error = nil;
    if ([[NSFileManager defaultManager] removeItemAtPath:path error:&error] && error == nil) {
        succ();
    } else {
        fail();
    }
}



/**
 获取某个路径下的文件大小（单位：kb）

 @param path 路径
 @return 文件大小
 */
+ (NSInteger)fileSizeWithPath: (NSString *)path {
    NSError *error = nil;
    NSInteger size = 0;
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (NSString *subPath in enumerator) {
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, subPath];
        size += [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error].count;
    }
    return size;
}

@end
