//
//  CATCategoryViewController.m
//  Demo
//
//  Created by wit on 15/1/11.
//  Copyright (c) 2015年 cat. All rights reserved.
//

#import "CATCategoryViewController.h"
#import "CATDatePicker.h"
#import "NSDate+CATKit.h"

@implementation CATCategoryViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CATDatePicker *picker = [[CATDatePicker alloc] init];
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                // default
            } else if (indexPath.row == 1) {
                picker.units = CATDatePickerUnitDate | CATDatePickerUnitTime;
            } else {
                picker.units = CATDatePickerUnitTime;
            }
            break;
            
        case 1:
            if (indexPath.row == 0) {
                picker.units = CATDatePickerUnitDate | CATDatePickerUnitTime;
                picker.minimumDate = [[NSDate date] cat_dateByAddingDays:-100];
                picker.maximumDate = [[NSDate date] cat_dateByAddingDays:100];
            } else if (indexPath.row == 1) {
                picker.units = CATDatePickerUnitDate | CATDatePickerUnitTime;
                picker.fittingWidth = YES;
            } else {
                picker.minimumDate = [[NSDate date] cat_dateByAddingDays:-1000];
                picker.maximumDate = [[NSDate date] cat_dateByAddingDays:1000];
                picker.lineHeight = 40;
                picker.normalAttributes = @{NSForegroundColorAttributeName : [UIColor redColor],
                                            NSBackgroundColorAttributeName : [UIColor orangeColor],
                                            NSFontAttributeName : [UIFont systemFontOfSize:14]};
                picker.highlightAttributes = @{NSForegroundColorAttributeName : [UIColor yellowColor],
                                            NSBackgroundColorAttributeName : [UIColor greenColor],
                                            NSFontAttributeName : [UIFont systemFontOfSize:20]};
                picker.disableAttributes = @{NSForegroundColorAttributeName : [UIColor cyanColor],
                                            NSBackgroundColorAttributeName : [UIColor blueColor],
                                            NSFontAttributeName : [UIFont systemFontOfSize:8]};
            }
            break;
            
        case 2:
            picker.fittingWidth = YES;
            if (indexPath.row == 0) {
                picker.units = CATDatePickerUnitDefault | CATDatePickerUnitHour;
                [picker setFormatter:({
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"a hh";
                    formatter;
                }) forUnit:CATDatePickerUnitHour];
            } else if (indexPath.row == 1) {
                picker.units = CATDatePickerUnitYear | CATDatePickerUnitDay | CATDatePickerUnitTime;
                [picker setFormatter:({
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"MMM-d";
                    formatter;
                }) forUnit:CATDatePickerUnitDay];
            } else if (indexPath.row == 2) {
                picker.units = CATDatePickerUnitMonth | CATDatePickerUnitDay | CATDatePickerUnitTime;
                [picker setFormatter:({
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyy-MMM";
                    formatter;
                }) forUnit:CATDatePickerUnitMonth];
            } else if (indexPath.row == 3) {
                picker.units = CATDatePickerUnitDay | CATDatePickerUnitTime;
                [picker setFormatter:({
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyy-MMM-d";
                    formatter;
                }) forUnit:CATDatePickerUnitDay];
            } else {
                picker.units = CATDatePickerUnitDefault | CATDatePickerUnitHour;
                picker.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
                picker.locale = [NSLocale localeWithLocaleIdentifier:@"zh-hans"];
                [picker setFormatter:({
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.calendar = picker.calendar;
                    formatter.locale = picker.locale;
                    formatter.dateFormat = @"UUUU";
                    formatter;
                }) forUnit:CATDatePickerUnitYear];
                [picker setFormatter:({
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.calendar = picker.calendar;
                    formatter.locale = picker.locale;
                    formatter.dateStyle = NSDateComponentsFormatterUnitsStyleFull;
                    formatter.dateFormat = @"d";
                    formatter;
                }) forUnit:CATDatePickerUnitDay];
                [picker setFormatter:({
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.calendar = picker.calendar;
                    formatter.locale = picker.locale;
                    formatter.timeStyle = NSDateComponentsFormatterUnitsStyleFull;
                    formatter.dateFormat = @"HH";
                    formatter;
                }) forUnit:CATDatePickerUnitHour];
            }
            break;
            
        default:
            break;
    }
    
    UIViewController *controller = [[UIViewController alloc] init];
    controller.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    controller.view.backgroundColor = [UIColor whiteColor];
    picker.frame = (CGRect) {
        .origin.x = 30,
        .origin.y = CGRectGetMinY(tableView.frame) + (CGRectGetHeight(tableView.frame) - 5 * picker.lineHeight) / 2,
        .size.width = CGRectGetWidth(tableView.frame) - 30 * 2,
        .size.height = 5 * picker.lineHeight
    };
    [controller.view addSubview:picker];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
