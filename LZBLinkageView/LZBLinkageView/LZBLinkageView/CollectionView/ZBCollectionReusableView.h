//
//  ZBCollectionReusableView.h
//  LZBLinkageView
//
//  Created by zibin on 2018/1/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kZBCollectionReusableViewID = @"ZBCollectionReusableViewID";

@interface ZBCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLabel;
@end
