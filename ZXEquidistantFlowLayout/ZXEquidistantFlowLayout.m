//
//  ZXEquidistantFlowLayout.m
//  ZXEquidistantFlowLayout
//
//  Created by Zhang, Xiang on 2018/4/26.
//  Copyright © 2018 xiangzhangkg. All rights reserved.
//

#import "ZXEquidistantFlowLayout.h"

@interface ZXEquidistantFlowLayout () {
    NSMutableArray *_itemAttributeArr;
}

@end

@implementation ZXEquidistantFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupData];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupData];
    }
    
    return self;
}

#pragma mark -

- (void)setupData {
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumInteritemSpacing = 8.f;
    self.minimumLineSpacing = 4.f;
    self.sectionInset = UIEdgeInsetsMake(12.f, 15.f, 12.f, 15.f);
    _itemAttributeArr = [[NSMutableArray alloc] initWithCapacity:[self.collectionView numberOfItemsInSection:0]];
}

#pragma mark - Override

- (void)prepareLayout {
    [super prepareLayout];
    
    [_itemAttributeArr removeAllObjects];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat xOffset = self.sectionInset.left;// every item's x end
    CGFloat yOffset = self.sectionInset.top;// every item's y origin
    CGFloat rowYOffset = yOffset;// first item's y end in last row, for different item's height in row
    for (NSInteger i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGSize itemSize = [_delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        if (xOffset == self.sectionInset.left) {// first item
            xOffset += itemSize.width;
            rowYOffset += itemSize.height;
        } else {
            CGFloat xOffsetMax = xOffset + self.minimumInteritemSpacing + itemSize.width;
            if (xOffsetMax <= CGRectGetWidth(self.collectionView.bounds) - self.sectionInset.right) {
                xOffset = xOffsetMax;
                rowYOffset = MAX(rowYOffset, yOffset + itemSize.height);
            } else {// new row
                xOffset = self.sectionInset.left + itemSize.width;
                yOffset = rowYOffset + self.minimumLineSpacing;
                rowYOffset = yOffset + itemSize.height;
            }
        }
        UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        layoutAttributes.frame = CGRectMake(xOffset - itemSize.width, yOffset, itemSize.width, itemSize.height);
        [_itemAttributeArr addObject:layoutAttributes];
    }
    _collectionViewH = rowYOffset + self.sectionInset.bottom;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _itemAttributeArr[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [_itemAttributeArr filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, evaluatedObject.frame);
    }]];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

@end
