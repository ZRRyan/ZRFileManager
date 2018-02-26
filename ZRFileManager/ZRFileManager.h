//
//  ZRFileManager.h
//  Pati
//
//  Created by Ryan on 2017/6/19.
//  Copyright © 2017年 mew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRFileManager : NSObject

/**
 沙盒路径(NSDocumentDirectory)
 */
+ (NSString *)documentPath;

/**
 判断文件是否存在
 
 @param path 文件路径
 @return 是否存在
 */
+ (BOOL)isExistsAtPath: (NSString *)path;

/**
 保存文件
 
 @param path 文件路径
 @param data 文件内容
 @param succ 成功
 @param fail 失败
 */
+ (void)saveFileWithPath: (NSString *)path data: (NSData *)data succ: (void(^)(void))succ fail: (void(^)(void))fail;


/**
 获取文件
 
 @param path 文件路径
 @param succ 成功
 @param fail 失败
 */
+ (void)asyncFileWithPath: (NSString *)path succ: (void(^)(NSData *data))succ fail: (void(^)(void))fail;



/**
 清空缓存文件
 
 @param path 文件路径
 @param succ 成功
 @param fail 失败
 */
+ (void)cleanCacheWithPath: (NSString *)path succ: (void(^)(void))succ fail: (void(^)(void))fail;


/**
 获取某个路径下的文件大小（单位：kb）
 
 @param path 路径
 @return 文件大小
 */
+ (NSInteger)fileSizeWithPath: (NSString *)path;
@end
