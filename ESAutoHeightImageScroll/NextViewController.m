//
//  NextViewController.m
//  ESAutoHeightImageScroll
//
//  Created by MaoMinghui on 2018/9/1.
//  Copyright © 2018年 lql. All rights reserved.
//

#import "NextViewController.h"
#import "ESAutoHeightImageScroll.h"

#define  SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define  topHeight SCREEN_WIDTH

@interface NextViewController ()

@property (nonatomic) ESAutoHeightImageScroll *imageScroll;
@property (nonatomic) NSArray *picArray;

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.picArray = @[
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535780747878&di=d53205c7b6f6cada1b0ca8aa69e9180d&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fblog%2F201404%2F06%2F20140406232455_m5XVy.jpeg",
                      @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3329677026,733095024&fm=26&gp=0.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535780826490&di=5fa172911fc56ca3c8396a3a8c611d8b&imgtype=0&src=http%3A%2F%2Fimg5q.duitang.com%2Fuploads%2Fitem%2F201404%2F18%2F20140418223400_UhPn5.thumb.700_0.jpeg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535780857197&di=589bdb72dd934ed669588468cc51cb5b&imgtype=jpg&src=http%3A%2F%2Fimg2.imgtn.bdimg.com%2Fit%2Fu%3D2630415757%2C4091184025%26fm%3D214%26gp%3D0.jpg",
                      @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535780878039&di=5342edea91005dc7e7a87e99db29162a&imgtype=0&src=http%3A%2F%2Fuploads.5068.com%2Fallimg%2F160120%2F60-1601201R938-50.jpg"];
    [self.view addSubview:self.imageScroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ESAutoHeightImageScroll *)imageScroll {
    if (nil == _imageScroll) {
        _imageScroll = [ESAutoHeightImageScroll es_imageScrollWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topHeight) images:self.picArray placeHolder:[UIImage imageNamed:@"timg.jpeg"]];
    }
    return _imageScroll;
}

@end
