//
//  ADMediator.h
//  ADMediator
//
//  Created by Andy on 22/01/2018.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADMediator : NSObject

/// 中间件单例对象
+ (instancetype)shareInstance;
/// 远程App调用入口
- (id)performActionWithURL:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;
/// 本地组建调用入口，默认不对target对象做缓存
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params;
/// 本地组建调用入口，可选是否对target对象做缓存
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params cacheTarget:(BOOL)cacheTarget;
/// 根据target名称释放缓存的对象
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;
/// 释放所有缓存对象
- (void)releaseAllCachedTargets;

@end
