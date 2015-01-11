//
//  NSDate+CATKit.h
//  CATKit
//
//  Created by wit on 14-8-6.
//  Copyright (c) 2014年 com.cat. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 每分钟秒数 */
#define CATSecondsPerMinute 60.f
/** 每小时分钟数 */
#define CATMinutesPerHour   60.f
/** 每天小时数 */
#define CATHoursPerDay      24.f
/** 每小时秒数 */
#define CATSecondsPerHour   (CATMinutesPerHour * CATSecondsPerMinute)
/** 每天秒数 */
#define CATSecondsPerDay    (CATHoursPerDay * CATMinutesPerHour * CATSecondsPerMinute)
/** 每周天数 */
#define CATDaysPerWeek      7.f

@interface NSDate (CATKit)

#pragma mark date from offset
/**
 按分钟偏移日期
 @param minutes 偏移分钟数
 @return 偏移日期
 */
- (NSDate *)cat_dateByAddingMinutes:(NSInteger)minutes;
/**
 按小时偏移日期
 @param minutes 偏移小时数
 @return 偏移日期
 */
- (NSDate *)cat_dateByAddingHours:(NSInteger)hours;
/**
 按天偏移日期
 @param minutes 偏移天数
 @return 偏移日期
 */
- (NSDate *)cat_dateByAddingDays:(NSInteger)days;
/**
 按周钟偏移日期
 @param minutes 偏移周数
 @return 偏移日期
 */
- (NSDate *)cat_dateByAddingWeeks:(NSInteger)weeks;

@end
