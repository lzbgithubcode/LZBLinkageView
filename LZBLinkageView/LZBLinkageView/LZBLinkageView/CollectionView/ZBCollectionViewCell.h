//
//  ZBCollectionViewCell.h
//  LZBLinkageView
//
//  Created by zibin on 2018/1/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ZBCollectionViewCell_default_Margin  10

static NSString *ZBCollectionViewCellID = @"ZBCollectionViewCellID";
@interface ZBCollectionViewCell : UICollectionViewCell

//标题
@property (nonatomic, strong) UILabel *titleLabel;
//图片
@property (nonatomic, strong) UIImageView *imgV;

@end
