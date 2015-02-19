//
//  NSCalendar+CATKit.h
//  CATKit
//
//  Created by wit on 14-8-6.
//  Copyright (c) 2014年 com.cat. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Weekday */
typedef NS_ENUM(NSInteger, CATWeekday) {
    /** Sunday */
    CATWeekdaySunday = 1,
    /** Monday */
    CATWeekdayMonday,
    /** Tuesday */
    CATWeekdayTuesday,
    /** Wednesday */
    CATWeekdayWednesday,
    /** Thurday */
    CATWeekdayThurday,
    /** Friday */
    CATWeekdayFriday,
    /** Saturday */
    CATWeekdaySaturday
};

#pragma mark -
@interface NSCalendar (CATKit)
/**
 get week's first date of a given date.
 @param date    given date
 @return week's first date
 */
- (NSDate *)cat_startOfWeekForDate:(NSDate *)date;
/**
 get month first date of a given date.
 @param date    given date
 @return month's first date
 */
- (NSDate *)cat_startOfMonthForDate:(NSDate *)date;
/**
 get year's first date of a given date.
 @param date    given date
 @return year's first date
 */
- (NSDate *)cat_startOfYearForDate:(NSDate *)date;
/**
 get era's first date of a given date.
 @param date    given date
 @return era's first date
 */
- (NSDate *)cat_startOfEraForDate:(NSDate *)date;
/**
 offset a specific component of NSDate
 @param unit    specific component
 @param value   value of the specific component
 @param date    date
 @param opts    options for adding
 @return offset date
 */
- (NSDate *)cat_dateByAddingUnit:(NSCalendarUnit)unit value:(NSInteger)value toDate:(NSDate *)date options:(NSCalendarOptions)opts;
/**
 get a specific component of NSDate
 @param component   specific component
 @param date        date
 @return value of the specific component
 */
- (NSInteger)cat_component:(NSCalendarUnit)component fromDate:(NSDate *)date;
@end

#pragma mark -
@interface NSDateComponents (CATKit)
/**
 create a date components with specific component
 @param value   value of the specific component
 @param unit    specific component
 @return date components
 */
+ (instancetype)cat_componentsWithValue:(NSInteger)value forComponent:(NSCalendarUnit)unit;
/**
 set a specific component of NSDateComponents
 @param value   value of the specific component
 @param unit    specific component
 */
- (void)cat_setValue:(NSInteger)value forComponent:(NSCalendarUnit)unit;
/**
 get a specific component of NSDateComponents
 @param unit    specific component
 @return value of the specific component
 */
- (NSInteger)cat_valueForComponent:(NSCalendarUnit)unit;
@end
