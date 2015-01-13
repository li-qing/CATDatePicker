//
//  NSDate+CATKit.h
//  CATKit
//
//  Created by wit on 14-8-6.
//  Copyright (c) 2014年 com.cat. All rights reserved.
//

#import <Foundation/Foundation.h>

/** seconds per minute */
#define CATSecondsPerMinute 60.f
/** minutes per hour */
#define CATMinutesPerHour   60.f
/** hours per day */
#define CATHoursPerDay      24.f
/** seconds per hour */
#define CATSecondsPerHour   (CATMinutesPerHour * CATSecondsPerMinute)
/** seconds per day */
#define CATSecondsPerDay    (CATHoursPerDay * CATMinutesPerHour * CATSecondsPerMinute)
/** days per week */
#define CATDaysPerWeek      7.f

@interface NSDate (CATKit)

#pragma mark date from offset
/**
 offset date by minutes
 @param minutes number of minutes to be added on receiver
 @return offset date
 */
- (NSDate *)cat_dateByAddingMinutes:(NSInteger)minutes;
/**
 offset date by hours
 @param hours   number of hours to be added on receiver
 @return offset date
 */
- (NSDate *)cat_dateByAddingHours:(NSInteger)hours;
/**
 offset date by days
 @param days    number of days to be added on receiver
 @return offset date
 */
- (NSDate *)cat_dateByAddingDays:(NSInteger)days;
/**
 offset date by weeks
 @param weeks   number of weeks to be added on receiver
 @return offset date
 */
- (NSDate *)cat_dateByAddingWeeks:(NSInteger)weeks;

@end
