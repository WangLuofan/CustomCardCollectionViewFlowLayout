//
//  CustomCardCollectionViewFlowLayout.h
//  CustomCollectionView
//
//  Created by 王落凡 on 16/8/19.
//  Copyright © 2016年 王落凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomCardCollectionViewFlowLayout;
@protocol CustomCardCollectionViewFlowLayoutDelegate <NSObject>

@optional
-(void)scrolledToTheCurrentItemAtIndex:(NSInteger)itemIndex;

@end

@interface CustomCardCollectionViewFlowLayout : UICollectionViewLayout

@property(nonatomic, assign) CGFloat internalItemSpacing;
@property(nonatomic, assign) CGSize itemSize;
@property(nonatomic, assign) UIEdgeInsets sectionEdgeInsets;
@property(nonatomic, assign) CGFloat scale;
@property(nonatomic, assign) NSInteger currentItemIndex;
@property(nonatomic, assign) id<CustomCardCollectionViewFlowLayoutDelegate> delegate;

-(void)scrollToItemAtIndex:(NSInteger)itemIndex;

@end
