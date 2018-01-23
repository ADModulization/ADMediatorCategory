//
//  ADMediator.m
//  ADMediator
//
//  Created by Andy on 22/01/2018.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADMediator.h"
#import <objc/runtime.h>
#import "ADMediatorExceptionHandler.h"

static NSString *const ADMediatorTargetName = @"targetName";
static NSString *const ADMediatorActionName = @"actionName";
static NSString *const ADMediatorParams = @"params";
static NSString *const ADMediatorResult = @"result";

@interface ADMediator()

@property (nonatomic, strong) NSMutableDictionary *cachedTargetDictionary;

@end

@implementation ADMediator

#pragma mark - public method

+ (instancetype)shareInstance
{
    static ADMediator *mediator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[ADMediator alloc] init];
    });
    return mediator;
}

- (id)performActionWithURL:(NSURL *)url completion:(void(^)(NSDictionary *info))completion
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if (elts.count < 2) continue;
        [params setObject:elts.lastObject forKey:elts.firstObject];
    }
    // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    id result = [self performTarget:url.host action:actionName params:params];
    if (completion) {
        if (result) {
            completion(@{ADMediatorResult : result});
        } else {
            completion(nil);
        }
    }
    return result;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params
{
    return [self performTarget:targetName action:actionName params:params cacheTarget:NO];
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params cacheTarget:(BOOL)cacheTarget
{
    Class targetClass;
    NSObject *target = self.cachedTargetDictionary[targetName];
    if (!target) {
        targetClass = NSClassFromString(targetName);
        target = [[targetClass alloc] init];
    }
    if (!target) {
        NSDictionary *info = @{ADMediatorTargetName : targetName, ADMediatorActionName : actionName, ADMediatorParams : params};
        [[ADMediatorExceptionHandler shareInstance] exceptionInstantiazeTargetFailedInfo:info];
        return nil;
    }
    if (cacheTarget) {
        [self.cachedTargetDictionary setObject:target forKey:targetName];
    }
    SEL action = NSSelectorFromString(actionName);
    if ([target respondsToSelector:action]) {
        return [self _safePerformTarget:target action:action params:params];
    } else {
        [self.cachedTargetDictionary removeObjectForKey:targetName];
        NSDictionary *info = @{ADMediatorTargetName : targetName, ADMediatorActionName : actionName, ADMediatorParams : params};
        [[ADMediatorExceptionHandler shareInstance] exceptionMethodNotFoundInfo:info];
        return nil;
    }
}

- (void)releaseCachedTargetWithTargetName:(NSString *)targetName
{
    [self.cachedTargetDictionary removeObjectForKey:targetName];
}

- (void)releaseAllCachedTargets
{
    [self.cachedTargetDictionary removeAllObjects];
}

#pragma mark - private method

- (id)_safePerformTarget:(NSObject *)target action:(SEL)action params:(NSDictionary *)params
{
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:action];
    if (!methodSignature) return nil;
    
    const char *returnType = [methodSignature methodReturnType];
    if (0 == strcmp(returnType, @encode(void))) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation setArgument:&params atIndex:2];
        [invocation invoke];
        return nil;
    }
    if (0 == strcmp(returnType, @encode(BOOL))) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation setArgument:&params atIndex:2];
        [invocation invoke];
        BOOL result = NO;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (0 == strcmp(returnType, @encode(NSInteger))) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation setArgument:&params atIndex:2];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (0 == strcmp(returnType, @encode(NSUInteger))) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation setArgument:&params atIndex:2];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (0 == strcmp(returnType, @encode(CGFloat))) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        [invocation setTarget:target];
        [invocation setSelector:action];
        [invocation setArgument:&params atIndex:2];
        [invocation invoke];
        CGFloat result = 0.0f;
        [invocation getReturnValue:&result];
        return @(result);
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

#pragma mark - getter and setter

- (NSMutableDictionary *)cachedTargetDictionary
{
    if (!_cachedTargetDictionary) {
        _cachedTargetDictionary = [[NSMutableDictionary alloc] init];
    }
    return _cachedTargetDictionary;
}

@end
