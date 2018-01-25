//
//  ZBCollectionViewCell.m
//  LZBLinkageView
//
//  Created by zibin on 2018/1/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ZBCollectionViewCell.h"



@implementation ZBCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.imgV];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;    
    //左边线
    CGFloat imgVX = ZBCollectionViewCell_default_Margin;
    CGFloat imgVY = ZBCollectionViewCell_default_Margin;
    CGFloat imgVW = width - 2*ZBCollectionViewCell_default_Margin;
    CGFloat imgVH = imgVW;
    self.imgV.frame = CGRectMake(imgVX, imgVY, imgVW, imgVH);
    
    //titleLabel
    CGFloat  titleLabelX = imgVX;
    CGFloat  titleLabelY = CGRectGetMaxY(self.imgV.frame) + ZBCollectionViewCell_default_Margin;
    CGFloat  titleLabelW = imgVW;
    CGFloat  titleLabelH = ceil([self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}].height);
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    
    
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


@end
