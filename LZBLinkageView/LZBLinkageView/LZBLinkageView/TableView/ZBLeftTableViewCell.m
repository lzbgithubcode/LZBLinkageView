//
//  ZBLeftTableViewCell.m
//  LZBLinkageView
//
//  Created by zibin on 2018/1/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ZBLeftTableViewCell.h"
static NSString *registerID = @"ZBLeftTableViewCellID";

@interface ZBLeftTableViewCell()

@property (nonatomic, strong) UIImageView *leftLineImgV;
@property (nonatomic, strong) UIImageView *bottomLineV;

@end

@implementation ZBLeftTableViewCell

+ (ZBLeftTableViewCell *)cellForTableView:(UITableView *)tableView
{
    ZBLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:registerID];
    if(cell == nil){
        cell = [[ZBLeftTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:registerID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [self.contentView addSubview:self.leftLineImgV];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.bottomLineV];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //左边线
    CGFloat leftLineImgVX = 0;
    CGFloat leftLineImgVY = 5;
    CGFloat leftLineImgVW = 5;
    CGFloat leftLineImgVH = [ZBLeftTableViewCell getLeftTableViewCellHeight] - 2*leftLineImgVY;
    self.leftLineImgV.frame = CGRectMake(leftLineImgVX, leftLineImgVY, leftLineImgVW, leftLineImgVH);
    
    //titleLabel
    CGFloat  titleLabelX = CGRectGetMaxX(self.leftLineImgV.frame) + 5;
    CGFloat  titleLabelY = leftLineImgVY;
    CGFloat  titleLabelW = CGRectGetMaxX(self.frame) - titleLabelX;
    CGFloat  titleLabelH = leftLineImgVH;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    //底部分割线
    CGFloat bottomLineVHeight = 1;
    self.bottomLineV.frame = CGRectMake(0, CGRectGetMaxX(self.frame) -bottomLineVHeight, CGRectGetMaxX(self.frame), bottomLineVHeight);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //改变选中状态
    if(selected){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.highlighted = YES;
        self.leftLineImgV.hidden = NO;
    }else{
        self.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        self.titleLabel.highlighted = NO;
        self.leftLineImgV.hidden = YES;
    }
}


#pragma mark - lazy
+ (CGFloat)getLeftTableViewCellHeight
{
    return 50;
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

- (UIImageView *)leftLineImgV
{
    if(!_leftLineImgV){
        _leftLineImgV = [[UIImageView alloc]init];
        _leftLineImgV.contentMode = UIViewContentModeScaleAspectFill;
        _leftLineImgV.clipsToBounds = YES;
        _leftLineImgV.backgroundColor = [UIColor redColor];
    }
    return _leftLineImgV;
}
- (UIImageView *)bottomLineV
{
    if(!_bottomLineV){
        _bottomLineV = [[UIImageView alloc]init];
        _bottomLineV.contentMode = UIViewContentModeScaleAspectFill;
        _bottomLineV.clipsToBounds = YES;
        _bottomLineV.backgroundColor = [UIColor whiteColor];
    }
    return _bottomLineV;
}

@end
