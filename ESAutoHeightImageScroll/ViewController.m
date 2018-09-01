//
//  ViewController.m
//  ESAutoHeightImageScroll
//
//  Created by MaoMinghui on 2018/8/31.
//  Copyright © 2018年 lql. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
    [btn setBackgroundColor:[UIColor cyanColor]];
    [btn setTitle:@"Click" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(next) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)next {
    NextViewController *next = [[NextViewController alloc] init];
    [self.navigationController pushViewController:next animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
