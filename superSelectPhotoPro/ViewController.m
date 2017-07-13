//
//  ViewController.m
//  superSelectPhotoPro
//
//  Created by admin on 2017/7/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import "LCPhotoPickerViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <Photos/Photos.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"背景图片@2x.jpg"];
    imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:imageView];
    

    UIButton *chooseImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    chooseImageBtn.adjustsImageWhenHighlighted = NO;
    [chooseImageBtn setBackgroundImage:[UIImage imageNamed:@"takePhoto@3x.png"] forState:UIControlStateNormal];
    [self.view addSubview:chooseImageBtn];
    [chooseImageBtn addTarget:self action:@selector(showPhotoPickerVC) forControlEvents:UIControlEventTouchUpInside];
  
    
    
    
}

- (void)showPhotoPickerVC{
    
    // Use PHAssetCollectionType and PHAssetCollectionSubtype in the Photos framework instead"
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
        NSString *tips = @"请先授权本App可以访问相册\n设置方式:手机设置->隐私->照片\n允许本App访问相册";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return;
        
    }else{
    
       LCPhotoPickerViewController *photoPickerVC = [LCPhotoPickerViewController new];
       [self presentViewController:photoPickerVC animated:YES completion:nil];
    
    }
    
    
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    
//    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
//        
//    {
//        NSString *tips = @"请先授权本App可以访问相机\n设置方式:手机设置->隐私->照片\n允许本App访问相机";
//        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//        
//    }else{
//        
//        NSLog(@"能打开相机");
//        
//    }

    
    
    
}


@end
