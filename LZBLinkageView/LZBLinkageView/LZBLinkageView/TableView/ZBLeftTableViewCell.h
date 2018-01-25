//
//  ZBLeftTableViewCell.h
//  LZBLinkageView
//
//  Created by zibin on 2018/1/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBLeftTableViewCell : UITableViewCell
//标题
@property (nonatomic, strong) UILabel *titleLabel;

/**
  类方法快速创建
 */
+ (ZBLeftTableViewCell *)cellForTableView:(UITableView *)tableView;


/**
  cell的高度
 */
+ (CGFloat)getLeftTableViewCellHeight;
@end
