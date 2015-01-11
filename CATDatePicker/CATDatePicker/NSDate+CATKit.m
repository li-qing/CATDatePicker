//
//  NSDate+CATKit.m
//  CATKit
//
//  Created by wit on 14-8-6.
//  Copyright (c) 2014年 com.cat. All rights reserved.
//

#import "NSDate+CATKit.h"

@implementation NSDate (CATKit)

#pragma mark date from offset
- (NSDate *)cat_dateByAddingMinutes:(NSInteger)minutes {
    return [self dateByAddingTimeInterval:minutes * CATSecondsPerMinute];
}

- (NSDate *)cat_dateByAddingHours:(NSInteger)hours {
    return [self dateByAddingTimeInterval:hours * CATMinutesPerHour * CATSecondsPerMinute];
}

- (NSDate *)cat_dateByAddingDays:(NSInteger)days {
    return [self dateByAddingTimeInterval:days * CATHoursPerDay * CATMinutesPerHour * CATSecondsPerMinute];
}

- (NSDate *)cat_dateByAddingWeeks:(NSInteger)weeks {
    return [self cat_dateByAddingDays:weeks * CATDaysPerWeek];
}
@end
