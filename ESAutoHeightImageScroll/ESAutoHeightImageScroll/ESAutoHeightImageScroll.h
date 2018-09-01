//
//  ESAutoHeightImageScroll.h
//  zuwome
//
//  Created by MaoMinghui on 2018/8/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  仿小红书轮播图，高度根据图片比例自适应
 *  目前只支持横屏滑动。不支持无限轮播。
 *  网络图片加载基于SDWebImage
 */

@interface ESAutoHeightImageScroll : UIScrollView

@property (nonatomic, strong) NSArray *images;      //轮播图片(可存UIImage，NSString，Model)
@property (nonatomic, strong) UIImage *placeHolder; //占位图
@property (nonatomic, copy) NSString *urlKey;       //用于解析模型
@property (nonatomic, assign) CGSize defaultSize;   //预设大小

@property (nonatomic, copy) void(^frameDidUpdate)(CGRect frame);

+ (instancetype)es_imageScrollWithFrame:(CGRect)frame images:(NSArray *)images placeHolder:(UIImage *)placeHolder;
+ (instancetype)es_imageScrollWithFrame:(CGRect)frame imageModels:(NSArray *)images urlKey:(NSString *)urlKey placeHolder:(UIImage *)placeHolder;

@end
