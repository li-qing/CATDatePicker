//
//  CATDatePickerLayout.h
//  DatePicker
//
//  Created by wit on 14-8-12.
//  Copyright (c) 2014年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

/** attribute for date component picker */
@interface CATDateUnitLayoutAttribute : UICollectionViewLayoutAttributes
/** distance from this index path to center index path */
@property (assign, nonatomic) NSInteger distance;
@end

/** layout for date component picker */
@interface CATDatePickerLayout : UICollectionViewFlowLayout
@end
