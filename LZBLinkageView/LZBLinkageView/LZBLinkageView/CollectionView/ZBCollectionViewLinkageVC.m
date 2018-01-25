//
//  ZBCollectionViewLinkageVC.m
//  LZBLinkageView
//
//  Created by zibin on 2018/1/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ZBCollectionViewLinkageVC.h"
#import "ZBLeftTableViewCell.h"
#import "ZBCollectionReusableView.h"
#import "ZBCollectionViewFlowLayout.h"
#import "ZBCollectionViewCell.h"
#import "ZBCollectionCategoryModel.h"
#import <UIImageView+WebCache.h>

static float kLeftTableViewWidth = 100.f;
#define ZB_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define ZB_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define ZB_NAVI_HEIGHT  64

@interface ZBCollectionViewLinkageVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic, strong) ZBCollectionViewFlowLayout *flowLayout;

//数据
@property (nonatomic, strong) NSMutableArray <ZBCollectionCategoryModel *>*categoryList;
@property (nonatomic, strong) NSMutableArray <ZBSubCategoryModel *>*goodsList;

//滚动向下
@property (nonatomic, assign) BOOL isRightScrollDericetionDown;


@end

@implementation ZBCollectionViewLinkageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.leftTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.rightCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.isRightScrollDericetionDown = NO;
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightCollectionView];
    [self leftScrollToIndexPath:0];
    self.view.backgroundColor = [UIColor yellowColor];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBLeftTableViewCell *cell = [ZBLeftTableViewCell cellForTableView:tableView];
    //赋值
    cell.titleLabel.text = [NSString stringWithFormat:@"标题-%ld",indexPath.row];
    if(indexPath.row < self.categoryList.count){
        ZBCollectionCategoryModel *categoryModel = self.categoryList[indexPath.row];
        cell.titleLabel.text = categoryModel.name;
    }
    return cell;
}

#pragma mark-UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.categoryList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    ZBCollectionCategoryModel *categoryModel = self.categoryList[section];
    return categoryModel.subcategories.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZBCollectionViewCellID forIndexPath:indexPath];
    //赋值
    if(indexPath.section < self.categoryList.count){
        ZBCollectionCategoryModel *categoryModel = self.categoryList[indexPath.section];
        if(indexPath.row < categoryModel.subcategories.count){
           ZBSubCategoryModel *subCate = categoryModel.subcategories[indexPath.row];
            cell.titleLabel.text = subCate.name;
            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:subCate.icon_url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                cell.imgV.image = image;
            }];
        }
    }
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ZBCollectionReusableView *reuableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kZBCollectionReusableViewID forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        ZBCollectionCategoryModel *model = self.categoryList[indexPath.section];
        reuableView.titleLabel.text = model.name;
    }
    return reuableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ZB_SCREEN_WIDTH - kLeftTableViewWidth - 4*ZBCollectionViewCell_default_Margin) / 3,
                      140);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ZB_SCREEN_WIDTH, 30);
}

#pragma mark - 事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //使用这种方式滚动会出现遮盖section header
    [self rightScrollToSectionTopIndex:indexPath.row];
    
    [self leftScrollToIndexPath:indexPath.row];
}


//右边头部即将显示的时候 - 向上方向
-(void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(nonnull UICollectionReusableView *)view forElementKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    //左边滚动
    if(!self.isRightScrollDericetionDown && (collectionView.dragging ||collectionView.decelerating)){
        NSInteger section = indexPath.section;
        [self leftScrollToIndexPath:section];
    }
}

//右边头部显示结束的时候 - 向下方向
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath
{
    //左边滚动
    if(self.isRightScrollDericetionDown && (collectionView.dragging ||collectionView.decelerating)){
        NSInteger section = indexPath.section;
        [self leftScrollToIndexPath:section - 1];
    }
}

//滚动判断方向
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //如果是右边的collectionView  就判断方向
    static CGFloat lastOffsetY = 0;
    if(scrollView == self.rightCollectionView){
        self.isRightScrollDericetionDown = self.rightCollectionView.contentOffset.y < lastOffsetY;
        lastOffsetY =  self.rightCollectionView.contentOffset.y;
    }
}

//右边滚动到指定位置
- (void)rightScrollToSectionTopIndex:(NSInteger)index
{
    CGRect headerSectionFrame = [self frameWithHeaderSection:index];
    CGPoint topOfHeader = CGPointMake(0, headerSectionFrame.origin.y + self.rightCollectionView.contentInset.top);
    [self.rightCollectionView setContentOffset:topOfHeader animated:YES];
    
    
}

- (CGRect)frameWithHeaderSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    UICollectionViewLayoutAttributes *attributes = [self.rightCollectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    return attributes.frame;
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
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ZB_NAVI_HEIGHT, kLeftTableViewWidth, ZB_SCREEN_HEIGHT-ZB_NAVI_HEIGHT)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = [ZBLeftTableViewCell getLeftTableViewCellHeight];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorColor = [UIColor clearColor];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _leftTableView;
}

- (ZBCollectionViewFlowLayout *)flowLayout
{
    if(!_flowLayout){
        _flowLayout = [[ZBCollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = 2;
        _flowLayout.minimumLineSpacing = 2;
    }
    return _flowLayout;
}
- (UICollectionView *)rightCollectionView
{
    if (!_rightCollectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 15;
        flowLayout.minimumLineSpacing = 10;
        
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kLeftTableViewWidth, ZB_NAVI_HEIGHT,ZB_SCREEN_WIDTH-kLeftTableViewWidth, ZB_SCREEN_HEIGHT-ZB_NAVI_HEIGHT) collectionViewLayout:flowLayout];
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        _rightCollectionView.showsHorizontalScrollIndicator = NO;
        [_rightCollectionView setBackgroundColor:[UIColor clearColor]];
        //注册cell
        [_rightCollectionView registerClass:[ZBCollectionViewCell class] forCellWithReuseIdentifier:ZBCollectionViewCellID];
        //注册分区头标题
        [_rightCollectionView registerClass:[ZBCollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:kZBCollectionReusableViewID];
    }
    return _rightCollectionView;
}

- (NSMutableArray<ZBCollectionCategoryModel *> *)categoryList
{
    if(!_categoryList)
    {
        _categoryList = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"liwushuo" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *foods = dict[@"data"][@"categories"];
        for (NSDictionary *dict in foods)
        {
            ZBCollectionCategoryModel *model = [ZBCollectionCategoryModel objectWithDictionary:dict];
            [_categoryList addObject:model];
            
            NSMutableArray *datas = [NSMutableArray array];
            for (ZBSubCategoryModel *f_model in model.subcategories)
            {
                [datas addObject:f_model];
            }
            [self.goodsList addObjectsFromArray:datas];
        }
    }
    return _categoryList;
}
- (NSMutableArray<ZBSubCategoryModel *> *)goodsList
{
    if(_goodsList == nil)
    {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

@end
