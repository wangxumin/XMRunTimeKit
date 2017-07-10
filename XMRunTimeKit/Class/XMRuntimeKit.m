//
//  XMRuntimeKit.m
//  XMRunTimeKit
//
//  Created by 王续敏 on 2017/7/7.
//  Copyright © 2017年 wangxumin. All rights reserved.
//

#import "XMRuntimeKit.h"

@implementation XMRuntimeKit

+ (NSString *)getClassName:(Class)class{
    const char *className = class_getName(class);
    return [NSString stringWithUTF8String:className];
}

+ (NSArray *)getIvarList:(Class)class{
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(class, &count);
    NSMutableArray *ivars = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        NSMutableDictionary *ivarDic = [NSMutableDictionary dictionaryWithCapacity:2];
        const char *ivarName = ivar_getName(ivarList[i]);
        const char *ivarType = ivar_getTypeEncoding(ivarList[i]);
        [ivarDic setObject:[NSString stringWithUTF8String:ivarName] forKey:@"ivarName"];
        [ivarDic setObject:[NSString stringWithUTF8String:ivarType] forKey:@"ivarType"];
        [ivars addObject:ivarDic];
    }
    free(ivarList);
    return ivars;
}

+ (NSArray *)getPropertyList:(Class)class{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(class, &count);
    NSMutableArray *propertys = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        [propertys addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertyList);
    return propertys;
}

+ (NSArray *)getMethodList:(Class)class{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(class, &count);
    NSMutableArray *methods = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
        SEL methodName = method_getName(methodList[i]);
        [methods addObject:NSStringFromSelector(methodName)];
    }
    free(methodList);
    return methods;
}

+ (NSArray *)getProtocolList:(Class)class{
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(class, &count);
    NSMutableArray *protocols = [NSMutableArray arrayWithCapacity:count];
    for (unsigned int i = 0; i < count; i++) {
       const char *protocolName = protocol_getName(protocolList[i]);
        [protocols addObject:[NSString stringWithUTF8String:protocolName]];
    }
    free(protocolList);
    return protocols;
}
+ (void)exchangeClassMethod:(Class)class originalMethod:(NSString *)originalMethodStr swizzledMethod:(NSString *)swizzledMehodStr{
    SEL originalSelector = NSSelectorFromString(originalMethodStr);
    SEL swizzledSelector = NSSelectorFromString(swizzledMehodStr);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
