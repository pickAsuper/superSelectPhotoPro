//
//  LCPhotoPickerViewController.m
//  superSelectPhotoPro
//
//  Created by admin on 2017/7/3.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "LCPhotoPickerViewController.h"


// 操作相册的库
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHCollection.h>
#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>

#import "LCPhotoCollectionViewFlowLayout.h"
#import "LCPhotoCell.h"
#import "LCTakePhotoCell.h"

//导航高度
#define navHeight 64


@interface LCPhotoPickerViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

//导航
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *navTitleBtn;
@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) UITableView *navTableView;
@property (nonatomic, copy) NSArray *navImages;
@property (nonatomic, copy) NSArray *navTitles;

// 照片
@property (nonatomic, strong) UICollectionView *photoCollectionView;

// 当前选中的相册
@property (nonatomic, strong) PHAssetCollection *currentAlbum;

// 所有的相册
@property (nonatomic, strong) NSArray *allAlbums;

@property (nonatomic, strong) PHImageManager *imgManager;


@property (nonatomic,strong)NSMutableDictionary * selectState ;


@end

@implementation LCPhotoPickerViewController


// 懒加载 PHImageManager
- (PHImageManager *)imgManager{
    if (!_imgManager) {
        _imgManager = [[PHImageManager alloc] init];
    }
    return _imgManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.selectState = [[NSMutableDictionary alloc ]init];
    
    [self setupNavView];
    
    [self loadNavTableView];
 
    [self setupCollecionView];

}


- (void)setupCollecionView{

    LCPhotoCollectionViewFlowLayout *flowLayout = [[LCPhotoCollectionViewFlowLayout alloc] init];
    //    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,navHeight, self.view.frame.size.width, self.view.frame.size.height - navHeight) collectionViewLayout:flowLayout];

    _photoCollectionView.delegate = self;
    _photoCollectionView.dataSource = self;
    _photoCollectionView.backgroundColor = [UIColor whiteColor];
    [_photoCollectionView registerClass:[LCPhotoCell class] forCellWithReuseIdentifier:@"photo"];
    [_photoCollectionView registerClass:[LCTakePhotoCell class] forCellWithReuseIdentifier:@"photo1"];

    [self.view addSubview:_photoCollectionView];

}



// 加载所有的相册
- (void)loadNavTableView{
  
    
    // PHAssetCollectionTypeSmartAlbum 获取到所以的列表
    PHFetchResult *tmpResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 如果没有
    if (tmpResult.count == 0) {
        return;
    }
    
    __block NSMutableArray *tmpImgArr = [NSMutableArray array];
    __block NSMutableArray *tmpTitleArr = [NSMutableArray array];
    __block NSMutableArray *tmpAlbumArr = [NSMutableArray array];
    
    
    //    PHFetchOptions *option1 = [[PHFetchOptions alloc] init];
    //
    //    option1.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:0]];
    //    PHFetchResult *result = [PHAsset fetchAssetsWithOptions:option1];
    //    NSLog(@"result --> {%@}",result);
    //
    //    [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        NSLog(@"result --> {%@}",obj);
    //
    //    }];
    
    [tmpResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAssetCollection *collection = (PHAssetCollection *)obj;
        PHFetchResult *assetResult  =  [PHAsset fetchAssetsInAssetCollection:collection options:nil];
        
//        NSLog(@"assetResult ===>> (%@)",assetResult);
        
        if (assetResult.count != 0) {
            
            [tmpAlbumArr addObject:collection];
        
            [tmpTitleArr addObject:[NSString stringWithFormat:@"%@(%lu)", collection.localizedTitle, (unsigned long)assetResult.count]];
            
            
            PHAsset *latestAsset = [assetResult objectAtIndex:0];
            
            //             图片 /视频 等等
            //            NSLog(@"latestAsset.mediaType = %zd",latestAsset.mediaType);
            //
            //            // 相片的类型
            //            NSLog(@"mediaSubtypes = %zd",latestAsset.mediaSubtypes);
            //
            //            // 经纬度
            //            //    <+37.98870000,+120.67930000> +/- 0.00m (speed -1.00 mps / course -1.00)
            //            NSLog(@"latestAsset .location = %@",latestAsset.location);
            //
            //            //    latestAsset.duration = 4606882178824859375
            //            NSLog(@"latestAsset.duration = %zd",latestAsset.duration);
            
            
    
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
//          option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
            option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

            
            [self.imgManager requestImageForAsset:latestAsset targetSize:CGSizeMake(300,300) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                [tmpImgArr addObject:result];
            
                _navImages = [tmpImgArr copy];
            
            }];
            
        }
    }];
    
    _navTitles = [tmpTitleArr copy];
    _allAlbums = [tmpAlbumArr copy];
    
    [_navTitleBtn setTitle:tmpTitleArr[0] forState:UIControlStateNormal];
   
    _navTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -200, self.view.frame.size.width, 200) style:UITableViewStylePlain];
    [self.view addSubview:_navTableView];
    
    _navTableView.hidden = YES;
    _navTableView.delegate = self;
    _navTableView.dataSource = self;
    
    
    [self.view bringSubviewToFront:_navView];
    
    _currentAlbum = [_allAlbums objectAtIndex:0];
    
    
}


// 设置导航UI
-(void)setupNavView{
  
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navHeight)];
    [self.view addSubview:navView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 51, navView.frame.size.width, 2)];
    imageView.image = [UIImage imageNamed:@"line"];
    [navView addSubview:imageView];
    
    UIButton *navBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 18, 35, 40)];
    [navBackBtn setImage:[UIImage imageNamed:@"fanhui@2x.png"] forState:UIControlStateNormal];
    [navView addSubview:navBackBtn];
    [navBackBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    //标题
    _navTitleBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 230, 40)];
    [_navTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _navTitleBtn.center = CGPointMake(navView.frame.size.width / 2 , 40);
    [navView addSubview:_navTitleBtn];
    [_navTitleBtn setTitle:@"标题" forState:UIControlStateNormal];
    [_navTitleBtn addTarget:self action:@selector(showPhotoAlbums:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showPhotoAlbums:(UIButton *)btn{
   
     btn.enabled = !btn.isEnabled;
    
    _navTableView.hidden = !_navTableView.isHidden;
    
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, navHeight, self.view.bounds.size.width, self.view.bounds.size.height-navHeight)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelectAlbum:)];
    
    [_shadowView addGestureRecognizer:tap];
    
    
    [self.view addSubview:_shadowView];
    [self.view bringSubviewToFront:_navTableView];
    
    [UIView animateWithDuration:0.4 animations:^{
    
        _navTableView.transform = CGAffineTransformMakeTranslation(0, 200 + navHeight);
    
        _shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _navTitles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.text = _navTitles[indexPath.row];
    
    cell.imageView.image = _navImages[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_navTitleBtn setTitle:_navTitles[indexPath.row] forState:UIControlStateNormal];
    
    
    [UIView animateWithDuration:0.4 animations:^{
        _shadowView.alpha = 0;
        _navTableView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
     
        [_shadowView removeFromSuperview];
        _navTitleBtn.enabled = YES;
        _navTableView.hidden = YES;
    
    }];
    
    _currentAlbum = _allAlbums[indexPath.row];
    [_photoCollectionView reloadData];

}

- (void)cancelSelectAlbum:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.4 animations:^{
    
        tap.view.alpha = 0;
        _navTableView.transform = CGAffineTransformMakeTranslation(0, 0);
    
    } completion:^(BOOL finished) {
    
        [tap.view removeFromSuperview];
        _navTitleBtn.enabled = YES;
        _navTableView.hidden = YES;
    
    }];
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    PHFetchResult *assetResult  =  [PHAsset fetchAssetsInAssetCollection:_currentAlbum options:nil];
    
    [self.imgManager requestImageDataForAsset:assetResult[0] options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
    
        UIImage *image = [UIImage imageWithData:imageData];
    
    }];
   
    return assetResult.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.item == 0) {
//        
//        LCTakePhotoCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"photo1" forIndexPath:indexPath];
//        [cell startCapture];
//        
//        //        [_photoCollectionView registerClass:[LCTakePhotoCell class] forCellWithReuseIdentifier:@"photo1"];
//        
//        return cell;
//        
//    }else{
    
    
        //  在cell 内部去控制像素值的
        LCPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
        BOOL  isSelect = [[_selectState objectForKey:@(indexPath.row)] boolValue];

         cell.isSelected =isSelect;

    
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:_currentAlbum options:nil];
        
        cell.asset = result[indexPath.row];
        
        return cell;
    
//    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LCPhotoCell * cell = (LCPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.isSelected) {
        
        cell.isSelected = NO;
      
        [_selectState setObject:@(cell.isSelected) forKey:@(indexPath.row)];

//        UIImage *selectImage = [_selectDic objectForKey:@(indexPath.row)];
        
        [self deleteObjectFromSeletDicWithKey:@(indexPath.row)];

        
    } else {
        
        cell.isSelected = YES;
        
        [_selectState setObject:@(cell.isSelected) forKey:@(indexPath.row)];

        
        PHFetchResult *assetResult  =  [PHAsset fetchAssetsInAssetCollection:_currentAlbum options:nil];
        
        [self.imgManager requestImageDataForAsset:assetResult[indexPath.row] options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            
            UIImage *image = [UIImage imageWithData:imageData];
            
            [self addDataToSelecteDic:image forKey:@(indexPath.row)];
            
            
        }];
    }
    

   
    
    
}

- (void)addDataToSelecteDic:(UIImage *)iconImage forKey:(NSNumber *)key{
    
    [_selectDic setObject:iconImage forKey:key];
    
}

- (void)deleteObjectFromSeletDicWithKey:(NSNumber *)key {
    
    [_selectDic removeObjectForKey:key];
}
@end
