//
//  LCPhotoCell.h
//  superSelectPhotoPro
//
//  Created by admin on 2017/7/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface LCPhotoCell : UICollectionViewCell
{
    UIImage *image;
    
    UIImageView * imageView;
    UIImageView * selectedImageView;
}
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) PHImageManager *imageManager;

@property (nonatomic, weak)UIButton *selectBtn;

@property(nonatomic,assign)BOOL isSelected;

@end
