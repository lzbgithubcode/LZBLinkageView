//
//  ZBCollectionCategoryModel.h
//  LZBLinkageView
//
//  Created by zibin on 2018/1/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Property.h"

@interface ZBCollectionCategoryModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *subcategories;

@end
@interface ZBSubCategoryModel : NSObject

@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *name;

@end
