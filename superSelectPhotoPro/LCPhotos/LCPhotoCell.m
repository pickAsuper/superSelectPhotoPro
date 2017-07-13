//
//  LCPhotoCell.m
//  superSelectPhotoPro
//
//  Created by admin on 2017/7/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "LCPhotoCell.h"
@interface LCPhotoCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation LCPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addImageView];
        _imageManager = [[PHImageManager alloc] init];
        
        selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(19,3, 16, 16)];
        selectedImageView.image = [UIImage imageNamed:@"评价晒单-选取照片_16.png"];
     
        [self.contentView addSubview:selectedImageView];
        
//        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        self.selectBtn = selectBtn;
//        
//        [selectBtn setImage:[UIImage imageNamed:@"评价晒单-选取照片_16.png"] forState:UIControlStateNormal];
//        [selectBtn setImage:[UIImage imageNamed:@"评价晒单-选取照片_19@2x.png"] forState:UIControlStateSelected];
//        selectBtn.frame = CGRectMake(10, 10, 20, 20);
//        selectBtn.titleLabel.textColor = [UIColor redColor];
//        
//        [self.contentView addSubview:selectBtn];
        
        
    }
    return self;
}

- (void)setAsset:(PHAsset *)asset
{
    
    _asset = asset;
  
    // targetSize 这个是显示像素大小的 
    [_imageManager requestImageForAsset:asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        _imageView.image = result;
        
        
    }];
}

- (void)addImageView
{

    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    [self.contentView addSubview:_imageView];
    
//    _imageView.backgroundColor = [UIColor red];
}


- (void)setIsSelected:(BOOL)isSelected{
    
    BOOL oldeValue = _isSelected;
    _isSelected = isSelected;
    
    if (oldeValue != isSelected) {
        
        if (_isSelected) {
            
            image = [UIImage imageNamed:@"评价晒单-选取照片_19@2x.png"];
        } else {
            
            image = [UIImage imageNamed:@"评价晒单-选取照片_16.png"];
        }
        selectedImageView.image = image;
    }
    
}



@end
