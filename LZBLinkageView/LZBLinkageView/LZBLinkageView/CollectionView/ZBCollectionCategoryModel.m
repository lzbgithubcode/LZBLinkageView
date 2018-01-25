//
//  ZBCollectionCategoryModel.m
//  LZBLinkageView
//
//  Created by zibin on 2018/1/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ZBCollectionCategoryModel.h"
#import "NSObject+Property.h"

@implementation ZBCollectionCategoryModel

+ (NSDictionary *)objectClassInArray
{
    return @{ @"subcategories": @"ZBSubCategoryModel"};
}

@end

@implementation ZBSubCategoryModel

@end
