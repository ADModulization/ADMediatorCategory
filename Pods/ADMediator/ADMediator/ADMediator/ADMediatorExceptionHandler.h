//
//  ADMediatorExceptionHandler.h
//  ADMediator
//
//  Created by Andy on 22/01/2018.
//  Copyright © 2018 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADMediatorExceptionHandler : NSObject

/// 单例对象
+ (instancetype)shareInstance;
/// 实例化target失败
- (void)exceptionInstantiazeTargetFailedInfo:(NSDictionary *)info;
/// 消息无响应
- (void)exceptionMethodNotFoundInfo:(NSDictionary *)info;

@end
