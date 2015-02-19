//
//  CATDatePickerLayout.m
//  CATDatePicker
//
//  Created by wit on 14-8-12.
//  Copyright (c) 2014年 cat. All rights reserved.
//

#import "CATDatePickerLayout.h"

@implementation CATDateUnitLayoutAttribute
- (id)copyWithZone:(NSZone *)zone {
    CATDateUnitLayoutAttribute *copy = [super copyWithZone:zone];
    copy.distance = self.distance;
    return copy;
}
- (BOOL)isEqual:(id)object {
    return [super isEqual:object] && [object distance] == _distance;
}
@end

#pragma mark -
@implementation CATDatePickerLayout

#pragma mark life cycle
+ (Class)layoutAttributesClass {
    return [CATDateUnitLayoutAttribute class];
}

- (instancetype)init {
    self = [super init];
    if (self) [self cat_initialize];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) [self cat_initialize];
    return self;
}

- (void)cat_initialize {
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
}

#pragma mark layout
- (void)prepareLayout {
    #define kLittleValueToAvoidZero 0.00001
    self.itemSize = (CGSize) {
        MAX(self.collectionView.frame.size.width, kLittleValueToAvoidZero),
        MAX(self.itemSize.height, kLittleValueToAvoidZero)
    };
    
    [super prepareLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark attribtue
- (NSInteger)cat_distanceForLayoutAttributes:(CATDateUnitLayoutAttribute *)attributes {
    CGFloat padding = [(id)self.collectionView collectionView:self.collectionView
                                                       layout:self
                                       insetForSectionAtIndex:0].top;
    CGFloat centerY = [self targetContentOffsetForProposedContentOffset:self.collectionView.contentOffset].y;
    CGFloat y = attributes.frame.origin.y - padding;
    return (centerY - y) / self.itemSize.height;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *results = [super layoutAttributesForElementsInRect:rect];
    
    for (CATDateUnitLayoutAttribute *attributes in results) {
        attributes.distance = [self cat_distanceForLayoutAttributes:attributes];
    }
    return results;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    CATDateUnitLayoutAttribute *attributes = (id)[super layoutAttributesForItemAtIndexPath:indexPath];
    attributes.distance = [self cat_distanceForLayoutAttributes:attributes];
    return attributes;
}

#pragma mark scroll
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    return (CGPoint){
        .x = proposedContentOffset.x,
        .y = round(proposedContentOffset.y / self.itemSize.height) * self.itemSize.height
    };
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity {
    return [self targetContentOffsetForProposedContentOffset:proposedContentOffset];
}
@end
