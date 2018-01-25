//
//  ZBRightTableViewCell.m
//  LZBLinkageView
//
//  Created by zibin on 2018/1/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ZBRightTableViewCell.h"

#define ZBRightTableViewCell_imageV_WidthHeight  100
#define ZBRightTableViewCell_default_Margin  10

static NSString *registerID = @"ZBRightTableViewCellID";

@interface ZBRightTableViewCell()

@property (nonatomic, strong) UIImageView *bottomLineV;

@end

@implementation ZBRightTableViewCell
+ (ZBRightTableViewCell *)cellForTableView:(UITableView *)tableView
{
    ZBRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:registerID];
    if(cell == nil){
        cell = [[ZBRightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:registerID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.imgV];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.bottomLineV];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //左边线
    CGFloat imgVX = ZBRightTableViewCell_default_Margin;
    CGFloat imgVY = ZBRightTableViewCell_default_Margin;
    CGFloat imgVW = ZBRightTableViewCell_imageV_WidthHeight;
    CGFloat imgVH = ZBRightTableViewCell_imageV_WidthHeight;
    self.imgV.frame = CGRectMake(imgVX, imgVY, imgVW, imgVH);
    
    //titleLabel
    CGFloat  titleLabelX = CGRectGetMaxX(self.imgV.frame) + ZBRightTableViewCell_default_Margin;
    CGFloat  titleLabelY = ZBRightTableViewCell_default_Margin;
    CGFloat  titleLabelW = CGRectGetMaxX(self.frame) - titleLabelX - ZBRightTableViewCell_default_Margin;
    CGFloat  titleLabelH = imgVH;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    //底部分割线
    CGFloat bottomLineVHeight = 1;
    self.bottomLineV.frame = CGRectMake(0, CGRectGetMaxY(self.frame) - bottomLineVHeight, CGRectGetMaxX(self.frame), bottomLineVHeight);
    
}




#pragma mark - lazy
+ (CGFloat)getRightTableViewCellHeight
{
    return 120;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.highlightedTextColor = [UIColor redColor];
    }
    return _titleLabel;
}

- (UIImageView *)imgV
{
    if(!_imgV){
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.clipsToBounds = YES;
    }
    return _imgV;
}
- (UIImageView *)bottomLineV
{
    if(!_bottomLineV){
        _bottomLineV = [[UIImageView alloc]init];
        _bottomLineV.contentMode = UIViewContentModeScaleAspectFill;
        _bottomLineV.clipsToBounds = YES;
        _bottomLineV.backgroundColor = [UIColor grayColor];
    }
    return _bottomLineV;
}



@end
