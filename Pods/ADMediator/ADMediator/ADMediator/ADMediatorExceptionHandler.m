//
//  ADMediatorExceptionHandler.m
//  ADMediator
//
//  Created by Andy on 22/01/2018.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADMediatorExceptionHandler.h"

@implementation ADMediatorExceptionHandler

+ (instancetype)shareInstance
{
    static ADMediatorExceptionHandler *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[ADMediatorExceptionHandler alloc] init];
    });
    return handler;
}

- (void)exceptionInstantiazeTargetFailedInfo:(NSDictionary *)info
{
    NSLog(@"ADMediatorExceptionHandler_%@_info: %@", NSStringFromSelector(_cmd), info);
}

- (void)exceptionMethodNotFoundInfo:(NSDictionary *)info
{
    NSLog(@"ADMediatorExceptionHandler_%@_info: %@", NSStringFromSelector(_cmd), info);
}

@end
