//
//  UIViewController+Dealloc.m
//  LZBLinkageView
//
//  Created by zibin on 2018/1/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "UIViewController+Dealloc.h"
#import <objc/runtime.h>

@implementation UIViewController (Dealloc)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
        Method newMethod = class_getInstanceMethod(self, @selector(lzb_dealloc));
        method_exchangeImplementations(originMethod, newMethod);
    });
}

- (void)lzb_dealloc
{
    NSLog(@"%@销毁了", self);
   
}
@end
