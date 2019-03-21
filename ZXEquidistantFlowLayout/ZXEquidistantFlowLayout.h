//
//  ZXEquidistantFlowLayout.h
//  ZXEquidistantFlowLayout
//
//  Created by Zhang, Xiang on 2018/4/26.
//  Copyright © 2018 xiangzhangkg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZXEquidistantFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionViewSize;

@end

@interface ZXEquidistantFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<ZXEquidistantFlowLayoutDelegate> delegate;
@property (nonatomic, assign, readonly) CGFloat collectionViewH;

@end
