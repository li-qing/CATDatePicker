//
//  CATDatePicker.h
//  DatePicker
//
//  Created by wit on 14-8-10.
//  Copyright (c) 2014年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

/** date component */
typedef NS_OPTIONS (NSUInteger, CATDatePickerUnit) {
    /** date component - era */
    CATDatePickerUnitEra        = 1 << 0,
    /** date component - year */
    CATDatePickerUnitYear       = 1 << 1,
    /** date component - month */
    CATDatePickerUnitMonth      = 1 << 2,
    /** date component - day */
    CATDatePickerUnitDay        = 1 << 3,
    /** date component - hour */
    CATDatePickerUnitHour       = 1 << 4,
    /** date component - minute */
    CATDatePickerUnitMinute     = 1 << 5,
    /** date component - second */
    CATDatePickerUnitSecond     = 1 << 6,
    /** date component - date */
    CATDatePickerUnitDate       = CATDatePickerUnitYear | CATDatePickerUnitMonth | CATDatePickerUnitDay,
    /** date component - time */
    CATDatePickerUnitTime       = CATDatePickerUnitHour | CATDatePickerUnitMinute | CATDatePickerUnitSecond,
    /** date component - default */
    CATDatePickerUnitDefault    = CATDatePickerUnitDate
};

/** date picker */
@interface CATDatePicker : UIView

#pragma mark settings
/** calendar */
@property (copy, nonatomic) NSCalendar *calendar;
/** locale */
@property (copy, nonatomic) NSLocale *locale;
/** date components */
@property (assign, nonatomic) CATDatePickerUnit units;

#pragma mark date & range
/** minimum date, should be earlier than maximumDate */
@property (strong, nonatomic) NSDate *minimumDate;
/** maximum date, should be later than minimumDate */
@property (strong, nonatomic) NSDate *maximumDate;
/** 日期 */
@property (strong, nonatomic) NSDate *date;

#pragma mark appearance
/** 每个构成是否自适应宽度 */
@property (assign, nonatomic) BOOL fittingWidth;
/** 行高 */
@property (assign, nonatomic) CGFloat lineHeight;
/** 标题通常状态样式 */
@property (copy, nonatomic) NSDictionary *normalAttributes;
/** 标题高亮状态样式 */
@property (copy, nonatomic) NSDictionary *highlightAttributes;
/** 标题无效状态样式 */
@property (copy, nonatomic) NSDictionary *disableAttributes;

#pragma mark format
/**
 获取日期构成显示格式
 @param unit 日期构成
 @return 显示格式
 */
- (NSDateFormatter *)formatterForUnit:(CATDatePickerUnit)unit;
/**
 设定日期构成显示格式
 @param formatter 显示格式
 @param unit 日期构成
 */
- (void)setFormatter:(NSDateFormatter *)formatter forUnit:(CATDatePickerUnit)unit;
@end
