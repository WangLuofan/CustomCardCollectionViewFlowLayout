//
//  CustomCardCollectionViewFlowLayout.m
//  CustomCollectionView
//
//  Created by 王落凡 on 16/8/19.
//  Copyright © 2016年 王落凡. All rights reserved.
//

#import "CustomCardCollectionViewFlowLayout.h"

@interface CustomCardCollectionViewFlowLayout ()

@property(nonatomic, assign) NSInteger itemsCount;

@end

@implementation CustomCardCollectionViewFlowLayout

-(void)prepareLayout {
    [super prepareLayout];
    
    _itemsCount = [self.collectionView numberOfItemsInSection:0];
    
    if(_internalItemSpacing == 0)
        _internalItemSpacing = 5;
    
    if(_sectionEdgeInsets.top == 0 && _sectionEdgeInsets.bottom == 0 && _sectionEdgeInsets.left == 0 && _sectionEdgeInsets.right == 0)
        _sectionEdgeInsets = UIEdgeInsetsMake(0, ([UIScreen mainScreen].bounds.size.width - self.itemSize.width) / 2, 0, ([UIScreen mainScreen].bounds.size.width - self.itemSize.width) / 2);
    
//    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewTapped:)];
//    [tapGesture setDelegate:self];
//    [self.collectionView addGestureRecognizer:tapGesture];
    
    return ;
}

-(void)collectionViewTapped:(UIGestureRecognizer*)recognizer {
    CGPoint location = [recognizer locationInView:self.collectionView];
    NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    if(indexPath == nil)
        return ;
    
    if(_currentItemIndex == indexPath.item) {
        if([self.collectionView.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)])
            [self.collectionView.delegate collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    }
    else {
        _currentItemIndex = indexPath.item;
        [self.collectionView setContentOffset:CGPointMake(indexPath.item * (_internalItemSpacing + _itemSize.width), 0) animated:YES];
        
        if([self.delegate respondsToSelector:@selector(scrolledToTheCurrentItemAtIndex:)])
            [self.delegate scrolledToTheCurrentItemAtIndex:_currentItemIndex];
    }
    
    return ;
}

-(void)scrollToItemAtIndex:(NSInteger)itemIndex {
    _currentItemIndex = itemIndex;
    
    [self.collectionView setContentOffset:CGPointMake(_currentItemIndex * (_internalItemSpacing + _itemSize.width), 0) animated:YES];
    
    if([self.delegate respondsToSelector:@selector(scrolledToTheCurrentItemAtIndex:)])
        [self.delegate scrolledToTheCurrentItemAtIndex:itemIndex];
    
    return ;
}

-(CGSize)collectionViewContentSize {
    CGFloat contentWidth = _sectionEdgeInsets.left + _sectionEdgeInsets.right + _itemsCount * _itemSize.width + (_itemsCount - 1) * _internalItemSpacing;
    CGFloat contentHeight = _sectionEdgeInsets.top + _sectionEdgeInsets.bottom + self.collectionView.frame.size.height;
    return CGSizeMake(contentWidth, contentHeight);
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attr.size = _itemSize;
    attr.frame = CGRectMake((int)indexPath.row * (_itemSize.width + _internalItemSpacing) + _sectionEdgeInsets.left, (self.collectionView.bounds.size.height - _itemSize.height) / 2 + _sectionEdgeInsets.top, attr.size.width, attr.size.height);
    
    return attr;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray* attributes = [NSMutableArray array];
    
    CGRect visiableRect = CGRectMake(self.collectionView.contentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    CGFloat centerX = self.collectionView.contentOffset.x + [UIScreen mainScreen].bounds.size.width / 2;
    
    for (NSInteger i=0 ; i < _itemsCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attributes addObject:attr];
        
        if(CGRectIntersectsRect(attr.frame, visiableRect) == false)
            continue ;
        CGFloat xOffset = fabs(attr.center.x - centerX);
        
        CGFloat scale = 1 - (xOffset * (1 - _scale)) / (([UIScreen mainScreen].bounds.size.width + self.itemSize.width) / 2 - self.internalItemSpacing);
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return attributes;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    return CGPointMake(3 * (_itemSize.width + _internalItemSpacing) + _sectionEdgeInsets.left, 0);
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    NSInteger itemIndex = (NSInteger)(self.collectionView.contentOffset.x / (_itemSize.width + _internalItemSpacing));
    CGFloat xOffset = itemIndex * (_internalItemSpacing + _itemSize.width);
    CGFloat xOffset_1 = (itemIndex + 1) * (_internalItemSpacing + _itemSize.width);
    
    if(fabs(proposedContentOffset.x - xOffset) > fabs(xOffset_1 - proposedContentOffset.x)) {
        _currentItemIndex = itemIndex + 1;
        if([self.delegate respondsToSelector:@selector(scrolledToTheCurrentItemAtIndex:)])
            [self.delegate scrolledToTheCurrentItemAtIndex:_currentItemIndex];
        return CGPointMake(xOffset_1, 0);
    }
    
    _currentItemIndex = itemIndex;
    if([self.delegate respondsToSelector:@selector(scrolledToTheCurrentItemAtIndex:)])
        [self.delegate scrolledToTheCurrentItemAtIndex:_currentItemIndex];
    return CGPointMake(xOffset, 0);
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint location = [touch locationInView:self.collectionView];
    NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    if(indexPath == nil || indexPath.item == _currentItemIndex)
        return NO;
    return YES;
}

@end
