//
//  DecoderObject.m
//  XMRunTimeKit
//
//  Created by 王续敏 on 2017/7/7.
//  Copyright © 2017年 wangxumin. All rights reserved.
//

#import "DecoderObject.h"
#import "XMRuntimeKit.h"

#define save_path [NSString stringWithFormat:@"%@/",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]]

@implementation DecoderObject


- (NSArray *)ignoreProperties{
    return @[];
}


//解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        NSArray *ivars = [XMRuntimeKit getIvarList:[self class]];
        [ivars enumerateObjectsUsingBlock:^(NSDictionary *ivarDic, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *ivar = ivarDic[@"ivarName"];
            NSArray *ignoreProperties = [weakSelf ignoreProperties];
            if (ignoreProperties.count && [ignoreProperties containsObject:ivar]) {
                return ;
            }
            id value  = [aDecoder decodeObjectForKey:ivar];
            [self setValue:value forKey:ivar];
        }];
    }
    return self;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    __weak typeof(self) weakSelf = self;
    NSArray *ivars = [XMRuntimeKit getIvarList:[self class]];
    [ivars enumerateObjectsUsingBlock:^(NSDictionary *ivarDic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *ivar = ivarDic[@"ivarName"];
        NSArray *ignoreProperties = [weakSelf ignoreProperties];
        if (ignoreProperties.count && [ignoreProperties containsObject:ivar]) {
            return ;
        }
        id value  = [self valueForKeyPath:ivar];
        [aCoder encodeObject:value forKey:ivar];
    }];
}

- (void)archiverForKey:(NSString *)key path:(NSString *)savePath{
    NSMutableData *savaData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:savaData];
    [archiver encodeObject:self forKey:key];
    if (savePath == nil) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:save_path]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        savePath = save_path;
    }
    [archiver finishEncoding];
    NSString *archiverPath = [savePath stringByAppendingString:[NSString stringWithFormat:@"%@.archiver",key]];
    [savaData writeToFile:archiverPath atomically:YES];
}

+ (id)unArchiverForKey:(NSString *)key path:(NSString *)savePath{
    if (savePath == nil) {
        savePath = save_path;
    }
    NSString *unArchiverPath = [savePath stringByAppendingString:[NSString stringWithFormat:@"%@.archiver",key]];
    NSData *decoderData = [[NSData alloc] initWithContentsOfFile:unArchiverPath];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:decoderData];
    Class class = [self class];
    class = [unArchiver decodeObjectForKey:key];
    [unArchiver finishDecoding];
    return class;
}


@end
