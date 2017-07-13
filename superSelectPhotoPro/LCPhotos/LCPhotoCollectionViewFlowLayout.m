//
//  LCPhotoCollectionViewFlowLayout.m
//  superSelectPhotoPro
//
//  Created by admin on 2017/7/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "LCPhotoCollectionViewFlowLayout.h"
#define XT(v)               ((v * 1.0f) / 2)

@implementation LCPhotoCollectionViewFlowLayout

- (instancetype)init{
    if (self = [super init]) {
      
        CGFloat itemW = [UIScreen mainScreen].bounds.size.width / 4 - (XT(10));
        self.itemSize = CGSizeMake(itemW, itemW);
        self.minimumInteritemSpacing = XT(10);
        self.minimumLineSpacing = XT(10);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    }
    return self;
}


@end
