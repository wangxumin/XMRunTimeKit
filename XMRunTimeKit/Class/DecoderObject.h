//
//  DecoderObject.h
//  XMRunTimeKit
//
//  Created by 王续敏 on 2017/7/7.
//  Copyright © 2017年 wangxumin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 所有需要归档接档的类都可以继承本类
 */
@interface DecoderObject : NSObject<NSCoding>

/**
 所有需要忽略归档解档的属性数组

 @return array
 */
- (NSArray *_Nullable)ignoreProperties;

/**
 归档

 @param key key
 @param savePath 归档路径
 */
- (void)archiverForKey:(nonnull NSString *)key path:(nullable NSString *)savePath;

/**
 解档

 @param key key
 @param savePath 解档路径
 */
+ (id _Nullable )unArchiverForKey:(nonnull NSString *)key path:(nullable NSString *)savePath;
@end
