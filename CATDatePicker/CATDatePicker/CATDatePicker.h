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
/** current date */
@property (strong, nonatomic) NSDate *date;

#pragma mark appearance
/** use fitting width for components */
@property (assign, nonatomic) BOOL fittingWidth;
/** line height for components */
@property (assign, nonatomic) CGFloat lineHeight;
/** title style for normal state */
@property (copy, nonatomic) NSDictionary *normalAttributes;
/** title style for highlight state */
@property (copy, nonatomic) NSDictionary *highlightAttributes;
/** title style for disable state */
@property (copy, nonatomic) NSDictionary *disableAttributes;

#pragma mark format
/**
 get date formatter for component
 @param unit    date component
 @return date formatter
 */
- (NSDateFormatter *)formatterForUnit:(CATDatePickerUnit)unit;
/**
 set date formatter for component
 @param formatter   date formatter
 @param unit        date component
 */
- (void)setFormatter:(NSDateFormatter *)formatter forUnit:(CATDatePickerUnit)unit;
@end
