//
//  ADMediator+MineModule.m
//  ADMediatorCategory
//
//  Created by Andy on 23/01/2018.
//  Copyright © 2018 Andy. All rights reserved.
//

#import "ADMediator+MineModule.h"

static NSString *const admMineTarget = @"ADMineTarget";

@implementation ADMediator (MineModule)

- (NSString *)adm_mineChangeBackgroundColor:(UIColor *)color
{
    return [self performTarget:admMineTarget action:@"changeBackgroundColor:" params:@{@"backgroundColor" : color}];
}

@end
