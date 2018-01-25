//
//  ViewController.m
//  LZBLinkageView
//
//  Created by zibin on 2018/1/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "ZBTabbleViewLinkageVC.h"
#import "ZBCollectionViewLinkageVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"联动效果";
}

- (IBAction)tableViewLinkageAction:(UIButton *)sender {
    
    ZBTabbleViewLinkageVC *vc = [[ZBTabbleViewLinkageVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)collectionViewLinkageAction:(UIButton *)sender {
    ZBCollectionViewLinkageVC *vc = [[ZBCollectionViewLinkageVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
