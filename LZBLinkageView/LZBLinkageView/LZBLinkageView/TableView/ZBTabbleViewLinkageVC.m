//
//  ZBTabbleViewLinkageVC.m
//  LZBLinkageView
//
//  Created by zibin on 2018/1/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ZBTabbleViewLinkageVC.h"
#import "ZBLeftTableViewCell.h"
#import "ZBCategoryModel.h"
#import "ZBRightTableViewCell.h"
#import <UIImageView+WebCache.h>

static float kLeftTableViewWidth = 100.f;
#define ZB_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define ZB_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ZBTabbleViewLinkageVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) NSMutableArray<ZBCategoryModel *> *categoryLists;
@property (nonatomic, strong) NSMutableArray<ZBFoodModel *> *foodsLists;


//确定滚动的方向
@property (nonatomic, assign) BOOL isScrollDirectionDown;


@end

@implementation ZBTabbleViewLinkageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    self.isScrollDirectionDown = NO;
    
    //默认选中第一个
    [self leftScrollToIndexPath:0];
    [self rightScrollToIndexPath:0];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.leftTableView == tableView){
        return 1;
    }else{
        return self.categoryLists.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.leftTableView == tableView){
        return self.categoryLists.count;
    }else{
        NSArray *foods = self.categoryLists[section].spus;
        return foods.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.leftTableView == tableView){ //左侧cell
        ZBLeftTableViewCell *cell = [ZBLeftTableViewCell cellForTableView:tableView];
        //赋值
        if(indexPath.row < self.categoryLists.count){
            ZBCategoryModel *categoryModel = self.categoryLists[indexPath.row];
            cell.titleLabel.text = categoryModel.name;
        }
        return cell;
        
    }else{
        ZBRightTableViewCell *cell = [ZBRightTableViewCell cellForTableView:tableView];
        //赋值
        if(indexPath.section < self.categoryLists.count){
            ZBCategoryModel *categoryModel = self.categoryLists[indexPath.section];
            NSArray <ZBFoodModel *>*foods= categoryModel.spus;
            if(indexPath.row < foods.count){
                ZBFoodModel *food = foods[indexPath.row];
                cell.titleLabel.text = food.name;
                [cell.imgV sd_setImageWithURL:[NSURL URLWithString:food.picture] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    cell.imgV.image = image;
                }];
               
            }
           
        }
        return cell;
    }
}


#pragma mark - 头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == self.rightTableView){
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor redColor];
        UILabel *titleLabel = [UILabel new];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        ZBCategoryModel *categoryModel = self.categoryLists[section];
        titleLabel.text =categoryModel.name;
        titleLabel.frame = CGRectMake(0, 0, [ZBRightTableViewCell getRightTableViewCellHeight], 40);
        [view addSubview:titleLabel];
        
        
        return view;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.rightTableView == tableView){
        return 40;
    }else
    {
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}


#pragma mark - 事件
//分组展示开始  - 向上滚动没有问题
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    //手动拖动是dragging = YES  非用户滚动是dragging = NO
    //手动拖动是decelerating = YES  非用户滚动是decelerating = NO
    
    if((self.rightTableView == tableView)
       && !self.isScrollDirectionDown
       &&(self.rightTableView.dragging || self.rightTableView.decelerating)){
            [self leftScrollToIndexPath:section];
    }
}
//分组展示结束 - 向下滚动
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if((self.rightTableView == tableView)
       && self.isScrollDirectionDown
       &&(self.rightTableView.dragging || self.rightTableView.decelerating)){
        [self leftScrollToIndexPath:section - 1];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果点击左边的数据
    if(tableView == self.leftTableView){
        
        //1.确定点击的indexPath,点击左边的row 就是右边的section
        NSInteger leftSection = indexPath.row;
    
        //2.创建右边indexPath,滚动到指定的位置 ,需要调用两次来能到指定的位置
        [self rightScrollToIndexPath:leftSection];
        [self rightScrollToIndexPath:leftSection];
      
        
        //3.穿件左边滚动左边TabbleView到顶
        [self leftScrollToIndexPath:leftSection];
      
        

    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    static CGFloat lastOffsetY = 0;
    UITableView *scrollTableView = (UITableView *)scrollView;
    //滚动右边的tableView
    if(self.rightTableView == scrollTableView){
        
        self.isScrollDirectionDown = lastOffsetY > scrollTableView.contentOffset.y;
        lastOffsetY = scrollTableView.contentOffset.y;
    }
}

//右边滚动到指定的位置
- (void)rightScrollToIndexPath:(NSInteger)index
{
    NSIndexPath *rightIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.rightTableView scrollToRowAtIndexPath:rightIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

//左边滚动到指定位置
- (void)leftScrollToIndexPath:(NSInteger)index
{
    NSIndexPath *leftIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.leftTableView selectRowAtIndexPath:leftIndexPath
                                animated:YES
                          scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - lazy
- (UITableView *)leftTableView
{
    if(_leftTableView == nil){
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftTableViewWidth, ZB_SCREEN_HEIGHT)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = [ZBLeftTableViewCell getLeftTableViewCellHeight];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorColor = [UIColor clearColor];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _leftTableView;
}
- (UITableView *)rightTableView
{
    if(_rightTableView == nil){
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kLeftTableViewWidth, 0,ZB_SCREEN_WIDTH-kLeftTableViewWidth, ZB_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = [ZBRightTableViewCell getRightTableViewCellHeight];
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.separatorColor = [UIColor clearColor];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _rightTableView;
}


- (NSMutableArray<ZBCategoryModel *> *)categoryLists
{
    if(!_categoryLists){
        _categoryLists = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"meituan" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *foods = dict[@"data"][@"food_spu_tags"];
        for (NSDictionary *dict in foods)
        {
            ZBCategoryModel *model = [ZBCategoryModel objectWithDictionary:dict];
            [_categoryLists addObject:model];
            
            NSMutableArray *datas = [NSMutableArray array];
            for (ZBFoodModel *f_model in model.spus)
            {
                [datas addObject:f_model];
            }
            [self.foodsLists addObjectsFromArray:datas];
        }
    }
    return _categoryLists;
}

- (NSMutableArray<ZBFoodModel *> *)foodsLists
{
    if(_foodsLists == nil)
    {
        _foodsLists = [NSMutableArray array];
    }
    return _foodsLists;
}
@end
