//
//  XMRuntimeKit.h
//  XMRunTimeKit
//
//  Created by 王续敏 on 2017/7/7.
//  Copyright © 2017年 wangxumin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
@interface XMRuntimeKit : NSObject

/**
 获取类名

 @param class class
 @return className
 */
+ (NSString *)getClassName:(Class)class;

/**
 获取成员变量

 @param class class
 @return 成员变量数组 字典@[@{ivarName:ivar,ivarType:ivarType}.....]
 */
+ (NSArray *)getIvarList:(Class)class;

/**
 获取属性列表

 @param class class
 @return 属性数组
 */
+ (NSArray *)getPropertyList:(Class)class;

/**
 获取类的实例方法

 @param class class
 @return 实例方法列表
 */
+ (NSArray *)getMethodList:(Class)class;

/**
 获取类遵循的协议列表

 @param class class
 @return 协议列表
 */
+ (NSArray *)getProtocolList:(Class)class;


/**
 交换类方法

 @param class class
 @param originalMethod 原方法
 @param swizzledMehod 交换后的方法
 备注:(交换后的方法一定要手动再调用一次)
 
 example:
 
+ (void)load{
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
   [XMRuntimeKit exchangeClassMethod:[xxx class] originalMethod:@"viewDidLoad" swizzledMethod:@"add_viewDidLoad"];
   });
}
 ///交换后的方法
 - (void)add_viewDidLoad{
 //在此可以做一些事情
   [self add_viewDidLoad];
 }
 */
+ (void)exchangeClassMethod:(Class)class originalMethod:(NSString *)originalMethod swizzledMethod:(NSString *)swizzledMehod;
@end
