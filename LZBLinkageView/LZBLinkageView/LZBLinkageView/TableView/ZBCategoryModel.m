//
//  ZBCategoryModel.m
//  LZBLinkageView
//
//  Created by zibin on 2018/1/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ZBCategoryModel.h"

@implementation ZBCategoryModel
+ (NSDictionary *)objectClassInArray
{
    return @{ @"spus": @"ZBFoodModel" };
}
@end
@implementation ZBFoodModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{ @"foodId": @"id" };
}

@end
