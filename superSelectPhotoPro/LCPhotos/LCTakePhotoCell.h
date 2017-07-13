//
//  LCTakePhotoCell.h
//  DDPhotoPicker
//
//  Created by admin on 2017/7/3.
//  Copyright © 2017年 Davy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCTakePhotoCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;

- (void)startCapture;

- (void)restartCapture;

@end
