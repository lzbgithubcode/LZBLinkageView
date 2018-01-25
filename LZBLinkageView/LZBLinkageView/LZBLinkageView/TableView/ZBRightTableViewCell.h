//
//  ZBRightTableViewCell.h
//  LZBLinkageView
//
//  Created by zibin on 2018/1/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBRightTableViewCell : UITableViewCell
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//图片
@property (nonatomic, strong) UIImageView *imgV;

/**
 类方法快速创建
 */
+ (ZBRightTableViewCell *)cellForTableView:(UITableView *)tableView;


/**
 cell的高度
 */
+ (CGFloat)getRightTableViewCellHeight;
@end
