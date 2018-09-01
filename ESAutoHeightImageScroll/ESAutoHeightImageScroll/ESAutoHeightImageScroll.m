//
//  ESAutoHeightImageScroll.m
//  zuwome
//
//  Created by MaoMinghui on 2018/8/20.
//  Copyright © 2018年 TimoreYu. All rights reserved.
//

#import "ESAutoHeightImageScroll.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ESAutoHeightImageScroll () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, assign) CGFloat lastPosition;

@end

@implementation ESAutoHeightImageScroll

+ (instancetype)es_imageScrollWithFrame:(CGRect)frame images:(NSArray *)images placeHolder:(UIImage *)placeHolder {
    ESAutoHeightImageScroll *imageScroll = [[ESAutoHeightImageScroll alloc] initWithFrame:frame];
    imageScroll.images = images;
    imageScroll.placeHolder = placeHolder;
    return imageScroll;
}

+ (instancetype)es_imageScrollWithFrame:(CGRect)frame imageModels:(NSArray *)images urlKey:(NSString *)urlKey placeHolder:(UIImage *)placeHolder {
    ESAutoHeightImageScroll *imageScroll = [[ESAutoHeightImageScroll alloc] initWithFrame:frame];
    imageScroll.urlKey = urlKey;
    imageScroll.images = images;
    imageScroll.placeHolder = placeHolder;
    return imageScroll;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentSize = frame.size;
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.clipsToBounds = YES;
        
        self.defaultSize = self.frame.size;
    }
    return self;
}

- (void)fillImageIntoScroll {
    self.contentSize = CGSizeMake(self.frame.size.width * _images.count, self.frame.size.height);
    for (int i = 0; i < _images.count; i++) {
        //图片大小先用容器大小设置，图片加载完成在动态改变frame
        CGFloat x = self.frame.size.width * i;
        CGFloat y = 0;
        CGFloat w = self.frame.size.width;
        CGFloat h = self.frame.size.height;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        imageView.tag = 100 + i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        [self.imageViewArray addObject:imageView];
        //解析图片
        id image = _images[i];
        if ([image isKindOfClass:[UIImage class]]) {
            imageView.image = image;
            [self resetFrameWithImage:image atIndex:i];
        } else if ([image isKindOfClass:[NSString class]]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:_placeHolder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [self resetFrameWithImage:image atIndex:i];
            }];
        } else {
            id imageData = [image valueForKey:_urlKey];
            if ([imageData isKindOfClass:[UIImage class]]) {
                imageView.image = imageData;
                [self resetFrameWithImage:image atIndex:i];
            } else if ([imageData isKindOfClass:[NSString class]]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageData] placeholderImage:_placeHolder completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    [self resetFrameWithImage:image atIndex:i];
                }];
            }
        }
    }
}

- (void)resetFrameWithImage:(UIImage *)image atIndex:(NSInteger)index {
    if (index == 0) {   //获取图片后重置高度
        CGRect frame = self.frame;
        NSLog(@"%.2f, %.2f",image.size.width, image.size.height);
        if (image.size.width == 0 || image.size.height == 0) {    //网络图片未获取到高度，或者图片损坏无法获取高度时，使用预设大小
            frame.size.height = frame.size.width * self.defaultSize.height / self.defaultSize.width;
        } else {
            frame.size.height = frame.size.width * image.size.height / image.size.width;
        }
        self.frame = frame;
        UIImageView *imageView = [self viewWithTag:100 + index];
        imageView.frame = frame;
        //frame变更，通知父视图
        !self.frameDidUpdate ? : self.frameDidUpdate(self.frame);
    }
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //通过与上次位置记录的偏移量比较，两张图片在等宽情况下的高度差，等比换算出前后两张图frame的变化
    CGFloat scrollW = scrollView.frame.size.width;
    CGFloat currentPosition = scrollView.contentOffset.x;
    NSInteger index = currentPosition / scrollView.frame.size.width;
    if (index == self.imageViewArray.count - 1) {   //防止滑到最后一张的时候出现数组越界
        index--;
    }
    
    UIImageView *firstImageView = self.imageViewArray[index];
    CGFloat firstHeight;
    if (firstImageView.image.size.width == 0 || firstImageView.image.size.height == 0) {    //网络图片未获取到高度，或者图片损坏无法获取高度时，使用预设大小
        firstHeight = scrollW * self.defaultSize.height / self.defaultSize.width;
    } else {
        firstHeight = scrollW * firstImageView.image.size.height / firstImageView.image.size.width;
    }
    UIImageView *secondImageView = self.imageViewArray[index + 1];
    CGFloat secondHeight;
    if (secondImageView.image.size.width == 0 || secondImageView.image.size.height == 0) {    //网络图片未获取到高度，或者图片损坏无法获取高度时，使用预设大小
        secondHeight = scrollW * self.defaultSize.height / self.defaultSize.width;
    } else {
        secondHeight = scrollW * secondImageView.image.size.height / secondImageView.image.size.width;
    }
    
    CGFloat heightSub = secondHeight - firstHeight;
    CGFloat offsetHeight = heightSub * (currentPosition - index * scrollW) / scrollW;
    
    //重设高度
    CGRect frame = firstImageView.frame;
    frame.size.height = offsetHeight + firstHeight;
    firstImageView.frame = frame;
    //第二张图宽高与第一张相同，只有位置不一样
    frame.origin.x = secondImageView.frame.origin.x;
    frame.origin.y = secondImageView.frame.origin.y;
    secondImageView.frame = frame;
    
    frame = self.frame;
    frame.size.height = firstImageView.frame.size.height;
    self.frame = frame;
    
    CGSize contentSize = self.contentSize;
    contentSize.height = firstImageView.frame.size.height;
    self.contentSize = contentSize;
    
    //frame变更，通知父视图
    !self.frameDidUpdate ? : self.frameDidUpdate(self.frame);
    //记录当前偏移量
    _lastPosition = currentPosition;
}

#pragma mark -- setter
- (void)setImages:(NSArray *)images {
    _images = images;
    [self fillImageIntoScroll];
}

- (void)setPlaceHolder:(UIImage *)placeHolder {
    _placeHolder = placeHolder;
}

#pragma mark -- getter
- (NSMutableArray *)imageViewArray {
    if (nil == _imageViewArray) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

@end
