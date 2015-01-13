//
//  CATDatePicker.m
//  DatePicker
//
//  Created by wit on 14-8-10.
//  Copyright (c) 2014年 cat. All rights reserved.
//

#import "CATDatePicker.h"
#import "CATDatePickerLayout.h"
#import "NSCalendar+CATKit.h"

typedef struct  {
    NSInteger location;
    NSInteger length;
} CATDateRange;

NS_INLINE CATDateRange CATDateRangeMake(NSInteger location, NSInteger length) {
    CATDateRange range;
    range.location = location;
    range.length = length;
    return range;
};
NS_INLINE NSInteger CATDateRangeMin(CATDateRange range) {
    return range.location;
}
NS_INLINE NSInteger CATDateRangeMax(CATDateRange range) {
    return range.location + range.length - 1;
}
NS_INLINE BOOL CATLocationInDateRange(NSInteger location, CATDateRange range) {
    return location >= CATDateRangeMin(range) && location <= CATDateRangeMax(range);
}
NS_INLINE CATDateRange CATDateRangeWithRange(NSRange range) {
    CATDateRange result;
    result.location = range.location;
    result.length = range.length;
    return result;
}
NS_INLINE CATDateRange CATDateRangeInfinity() {
    CATDateRange result;
    result.location = 0;
    result.length = 1000000;
    return result;
}
NS_INLINE BOOL CATDateRangeEqualToRange(CATDateRange range1, CATDateRange range2) {
    return range1.location = range2.location && range1.length == range2.length;
}

#pragma mark -
@interface CATDateUnitCell : UICollectionViewCell
// UI
@property (strong, nonatomic) UILabel *titleLabel;
// state
@property (assign, nonatomic) BOOL enabled;
// appearance
@property (copy, nonatomic) NSDictionary *normalAttributes;
@property (copy, nonatomic) NSDictionary *highlightAttributes;
@property (copy, nonatomic) NSDictionary *disableAttributes;
@end

@implementation CATDateUnitCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}
- (void)applyLayoutAttributes:(CATDateUnitLayoutAttribute *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    NSString *text = _titleLabel.attributedText.string ?: _titleLabel.text;
    NSDictionary *attributes = nil;
    if (!_enabled) {
        attributes = _disableAttributes;
    } else if (layoutAttributes.distance == 0) {
        attributes = _highlightAttributes;
    } else {
        attributes = _normalAttributes;
    }
    if (attributes) {
        _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
}
@end

#pragma mark -
#define kCyclicFilling 0xFF
#define kReuseIdentifer @"Cell"

@interface CATDateUnitPicker : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
// layout settings
@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
@property (assign, nonatomic) BOOL cyclic;
// appearance
@property (assign, nonatomic, readonly) CGFloat preferredWidth;
@property (copy, nonatomic) NSDictionary *normalAttributes;
@property (copy, nonatomic) NSDictionary *highlightAttributes;
@property (copy, nonatomic) NSDictionary *disableAttributes;
// callbacks
@property (copy, nonatomic) void (^validate)();
@property (copy, nonatomic) void (^pickUpValue)(NSInteger value);
@property (copy, nonatomic) NSString *(^titleForValue)(NSInteger value);
// cache
@property (assign, nonatomic) CATDateRange naturalRange;
@property (assign, nonatomic) CATDateRange validRange;
@end

@implementation CATDateUnitPicker

#pragma mark life cycle
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        self.backgroundColor = [UIColor clearColor];
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[CATDateUnitCell class] forCellWithReuseIdentifier:kReuseIdentifer];
    }
    return self;
}
- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window) [self revalidate];
}

- (void)revalidate {
    _validate();
}

#pragma mark property
- (void)setCyclic:(BOOL)cyclic {
    [self willChangeValueForKey:@"cyclic"];
    _cyclic = cyclic;
    [self didChangeValueForKey:@"cyclic"];
    [self reloadData];
}

- (CGFloat)preferredWidth {
    NSString *title = _titleForValue(CATDateRangeMax(_naturalRange));
    NSAttributedString *normal = [[NSAttributedString alloc] initWithString:title attributes:_normalAttributes];
    NSAttributedString *disable = [[NSAttributedString alloc] initWithString:title attributes:_disableAttributes];
    NSAttributedString *highlight = [[NSAttributedString alloc] initWithString:title attributes:_highlightAttributes];
    return ceilf(MAX(MAX(normal.size.width, disable.size.width), highlight.size.width));
}

#pragma mark transfer
- (NSInteger)rowForValue:(NSInteger)value {
    return value - CATDateRangeMin(_naturalRange);
}
- (NSInteger)valueForRow:(NSInteger)row {
    return CATDateRangeMin(_naturalRange) + row;
}
- (CGFloat)offsetForRow:(NSInteger)row {
    CGFloat offset = row * [self lineHeight];
    if (_cyclic) offset += floor(kCyclicFilling / 2) * [self numberOfItemsInSection:0] * [self lineHeight];
    return offset;
}
- (NSInteger)rowForOffset:(CGFloat)offset {
    NSInteger row = offset / [self lineHeight];
    if (_cyclic) row = row % [self numberOfItemsInSection:0];
    return row;
}

#pragma mark query
- (CGFloat)lineHeight {
    return self.collectionViewLayout.itemSize.height;
}
- (CGFloat)paddingHeight {
    return (CGRectGetHeight(self.frame) - [self lineHeight]) / 2;
}
- (NSInteger)validatedRow:(NSInteger)row {
    if (row + CATDateRangeMin(_naturalRange) < CATDateRangeMin(_validRange)) {
        return CATDateRangeMin(_validRange) - CATDateRangeMin(_naturalRange);
    } else if (row + CATDateRangeMin(_naturalRange) >= CATDateRangeMax(_validRange)) {
        return CATDateRangeMax(_validRange) - CATDateRangeMin(_naturalRange);
    } else {
        return row;
    }
}

#pragma mark modification
- (void)centerizeValue:(NSInteger)value animated:(BOOL)animated {
    [self centerizeRow:[self rowForValue:value] animated:animated];
}
- (void)centerizeRow:(NSInteger)row animated:(BOOL)animated {
    [self setContentOffset:CGPointMake(0, [self offsetForRow:row]) animated:animated];
}
- (void)centerizeAndNotifyRow:(NSInteger)row {
    [self centerizeRow:row animated:YES];
    _pickUpValue(CATDateRangeMin(_naturalRange) + row);
}

#pragma mark event
- (void)pickerDragged {
    [self centerizeAndNotifyRow:[self validatedRow:[self rowForOffset:self.contentOffset.y]]];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _cyclic ? kCyclicFilling : 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _naturalRange.length;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CATDateUnitCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifer forIndexPath:indexPath];
    NSInteger value = CATDateRangeMin(_naturalRange) + indexPath.row;
    cell.titleLabel.text = _titleForValue(value);
    cell.enabled = CATLocationInDateRange(indexPath.row + CATDateRangeMin(_naturalRange), _validRange);
    cell.normalAttributes = _normalAttributes;
    cell.highlightAttributes = _highlightAttributes;
    cell.disableAttributes = _disableAttributes;
    [cell applyLayoutAttributes:[self layoutAttributesForItemAtIndexPath:indexPath]];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([self validatedRow:indexPath.row] == indexPath.row) {
        [self centerizeAndNotifyRow:indexPath.row];
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    CGFloat space = [self paddingHeight];
    if ([self numberOfSections] == 1) {
        return UIEdgeInsetsMake(space, 0, space, 0);
    } else if (section == 0) {
        return UIEdgeInsetsMake(space, 0, 0, 0);
    } else if (section == [self numberOfSections] - 1) {
        return UIEdgeInsetsMake(0, 0, space, 0);
    } else {
        return UIEdgeInsetsZero;
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) [self pickerDragged];;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self pickerDragged];
}
@end

#pragma mark -
@interface CATDatePicker () {
    BOOL _disablePickerAnimation;
}
@property (strong, nonatomic) NSMutableArray *pickers;
@property (strong, nonatomic) NSMutableDictionary *formatterByUnits;
@end

@implementation CATDatePicker

#pragma mark life cycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self cat_initialize];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self cat_initialize];
    }
    return self;
}
- (void)cat_initialize {
    // cache
    self.pickers = [NSMutableArray arrayWithCapacity:3];
    self.formatterByUnits = [NSMutableDictionary dictionary];
    
    // settings
    self.calendar = [NSCalendar currentCalendar];
    self.locale = [NSLocale currentLocale];
    self.units = CATDatePickerUnitDefault;
    
    // date
    self.date = [NSDate date];
    
    // appearance
    self.normalAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:.3f alpha:1.f], NSFontAttributeName : [UIFont systemFontOfSize:13]};
    self.disableAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:.8f alpha:1.f], NSFontAttributeName : [UIFont systemFontOfSize:13]};
    self.highlightAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.f alpha:1.f], NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
    self.lineHeight = ceilf([UIFont systemFontOfSize:15].lineHeight) + 10;
    
    [self cat_registerKVO];
}
- (void)dealloc {
    [self cat_unregisterKVO];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow) {
        _disablePickerAnimation = YES;
        [self cat_reloadPickers];
        _disablePickerAnimation = NO;
    }
}

#pragma mark layout
- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake([[_pickers valueForKeyPath:@"@sum.preferredWidth"] doubleValue], _lineHeight * 3);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_fittingWidth) {
        CGFloat totalWidth = [[_pickers valueForKeyPath:@"@sum.preferredWidth"] doubleValue];
        CGFloat filling = floor((CGRectGetWidth(self.frame) - totalWidth) / [_pickers count]);
        CGFloat x = 0;
        
        for (int i = 0; i < [_pickers count]; i++) {
            CATDateUnitPicker *picker = _pickers[i];
            CGFloat width = picker.preferredWidth + filling;
            picker.frame = CGRectMake(x, 0, width, CGRectGetHeight(self.frame));
            x += width;
        }
    } else {
        CGFloat width = round((CGRectGetWidth(self.frame)) / [_pickers count]);
        CGFloat x = 0;
        
        for (int i = 0; i < [_pickers count]; i++) {
            CATDateUnitPicker *picker = _pickers[i];
            picker.frame = CGRectMake(x, 0, width, CGRectGetHeight(self.frame));
            x += width;
        }
    }
    
    _disablePickerAnimation = YES;
    [self cat_revalidate];
    _disablePickerAnimation = NO;
}

#pragma mark property
- (void)setDate:(NSDate *)date {
    date = [self cat_validateDate:date ?: [NSDate date]];
    
    BOOL changed = !_date || ![_date isEqualToDate:date];
    [self willChangeValueForKey:@"date"];
    _date = date;
    [self didChangeValueForKey:@"date"];
    if (changed) [self cat_revalidate];
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    [self willChangeValueForKey:@"maximumDate"];
    _maximumDate = maximumDate;
    [self didChangeValueForKey:@"maximumDate"];
    NSAssert(!_minimumDate || [_maximumDate laterDate:_minimumDate] == _maximumDate, @"maximumDate should be later than minimumDate !");
    self.date = [self cat_validateDate:_date];
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    [self willChangeValueForKey:@"minimumDate"];
    _minimumDate = minimumDate;
    [self didChangeValueForKey:@"minimumDate"];
    NSAssert(!_maximumDate || [_minimumDate earlierDate:_maximumDate] == _minimumDate, @"minimumDate should be earlier than maximumDate !");
    self.date = [self cat_validateDate:_date];
}

#pragma mark kvo
+ (NSSet *)propertiesNeedsReload {
    return [NSSet setWithArray:@[@"calendar", @"locale", @"units", @"lineHeight", @"normalAttributes", @"highlightAttributes", @"disableAttributes"]];
}
+ (NSSet *)propertiesNeedsRelayout {
    return [NSSet setWithObject:@"fittingWidth"];
}
+ (NSSet *)propertiesNeedsKVO {
    NSSet *result = [self propertiesNeedsReload];
    result = [result setByAddingObjectsFromSet:[self propertiesNeedsRelayout]];
    return result;
}

- (void)cat_registerKVO {
    for (NSString *path in [[self class] propertiesNeedsKVO]) {
        [self addObserver:self forKeyPath:path options:kNilOptions context:NULL];
    }
}
- (void)cat_unregisterKVO {
    for (NSString *path in [[self class] propertiesNeedsKVO]) {
        [self removeObserver:self forKeyPath:path];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([[[self class] propertiesNeedsReload] containsObject:keyPath]) {
        if (self.window) [self cat_reloadPickers];
    } else if ([[[self class] propertiesNeedsRelayout] containsObject:keyPath]) {
        [self setNeedsLayout];
        if (self.window) [UIView animateWithDuration:0.5f animations:^{
            [self layoutIfNeeded];
        }];
    }
}

#pragma mark transfer value <-> date
- (NSDate *)cat_originDate {
    return [_calendar dateFromComponents:[[NSDateComponents alloc] init]];
}

- (NSInteger)cat_valueForUnit:(CATDatePickerUnit)unit ofDate:(NSDate *)date {
    switch (unit) {
        case CATDatePickerUnitEra: {
            return [_calendar cat_component:NSCalendarUnitEra fromDate:date];
        }
        case CATDatePickerUnitYear: {
            if (_units & CATDatePickerUnitEra) {
                return [_calendar cat_component:NSCalendarUnitYear fromDate:date];
            } else {
                return [_calendar components:NSCalendarUnitYear fromDate:[self cat_originDate] toDate:date options:kNilOptions].year;
            }
        }
        case CATDatePickerUnitMonth: {
            if (_units & CATDatePickerUnitYear) {
                // handle leap month here
                NSDate *startOfYear = [_calendar cat_startOfYearForDate:date];
                NSInteger delta = [_calendar components:NSCalendarUnitMonth fromDate:startOfYear toDate:date options:kNilOptions].month;
                return [_calendar cat_component:NSCalendarUnitMonth fromDate:startOfYear] + delta;
            } else {
                return [_calendar components:NSCalendarUnitMonth fromDate:[self cat_originDate] toDate:date options:kNilOptions].month;
            }
        }
        case CATDatePickerUnitDay: {
            if (_units & CATDatePickerUnitMonth) {
                return [_calendar cat_component:NSCalendarUnitDay fromDate:date];
            } else if (_units & CATDatePickerUnitYear) {
                return [_calendar components:NSCalendarUnitDay fromDate:[_calendar cat_startOfYearForDate:date] toDate:date options:kNilOptions].day;
            } else {
                return [_calendar components:NSCalendarUnitDay fromDate:[self cat_originDate] toDate:date options:kNilOptions].day;
            }
        }
        case CATDatePickerUnitHour: {
            return [_calendar cat_component:NSCalendarUnitHour fromDate:date];
        }
        case CATDatePickerUnitMinute: {
            return [_calendar cat_component:NSCalendarUnitMinute fromDate:date];
        }
        case CATDatePickerUnitSecond:{
            return [_calendar cat_component:NSCalendarUnitSecond fromDate:date];
        }
        default:
            return 0;
    }
}

- (NSDate *)cat_date:(NSDate *)date setUnit:(CATDatePickerUnit)unit toValue:(NSInteger)value {
    NSInteger delta = value - [self cat_valueForUnit:unit ofDate:date];
    NSDate *result = nil;
    switch (unit) {
        case CATDatePickerUnitEra: {
            result = [_calendar cat_dateByAddingUnit:NSCalendarUnitEra value:delta toDate:date options:kNilOptions];
        } break;
        case CATDatePickerUnitYear: {
            result = [_calendar cat_dateByAddingUnit:NSCalendarUnitYear value:delta toDate:date options:kNilOptions];
        } break;
        case CATDatePickerUnitMonth: {
            // handle leap month here
            NSCalendarUnit collector = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            if (_units & CATDatePickerUnitYear) {
                collector = collector | NSCalendarUnitEra | NSCalendarUnitYear;
            }
            NSDate *from = [_calendar dateFromComponents:[_calendar components:collector fromDate:date]];
            NSInteger delta = value - [self cat_naturalRangeForUnit:unit ofDate:date].location;
            result = [_calendar cat_dateByAddingUnit:NSCalendarUnitMonth value:delta toDate:from options:kNilOptions];
        } break;
        case CATDatePickerUnitDay: {
            result = [_calendar cat_dateByAddingUnit:NSCalendarUnitDay value:delta toDate:date options:kNilOptions];
        } break;
        case CATDatePickerUnitHour: {
            result = [_calendar cat_dateByAddingUnit:NSCalendarUnitHour value:delta toDate:date options:kNilOptions];
        } break;
        case CATDatePickerUnitMinute: {
            result = [_calendar cat_dateByAddingUnit:NSCalendarUnitMinute value:delta toDate:date options:kNilOptions];
        } break;
        case CATDatePickerUnitSecond:{
            result = [_calendar cat_dateByAddingUnit:NSCalendarUnitSecond value:delta toDate:date options:kNilOptions];
        } break;
        default: {
            result = date;
        } break;
    }
    return result;
}

#pragma mark range
- (CATDateRange)cat_naturalRangeForUnit:(CATDatePickerUnit)unit ofDate:(NSDate *)date {
    switch (unit) {
        case CATDatePickerUnitEra: {
            return CATDateRangeWithRange([_calendar maximumRangeOfUnit:NSCalendarUnitEra]);
        }
        case CATDatePickerUnitYear: {
            if (_units & CATDatePickerUnitEra) {
                return CATDateRangeWithRange([_calendar rangeOfUnit:NSCalendarUnitYear inUnit:NSCalendarUnitEra forDate:date]);
            } else {
                return CATDateRangeInfinity();
            }
        }
        case CATDatePickerUnitMonth: {
            if (_units & CATDatePickerUnitYear) {
                // leap month does not count in -rangeOfUnit:inUnit:forDate:
                NSDate *thisYear = [_calendar cat_startOfYearForDate:date];
                NSDate *nextYear = [_calendar cat_dateByAddingUnit:NSCalendarUnitYear value:1 toDate:thisYear options:kNilOptions];
                NSInteger location = [_calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:date].location;
                NSInteger length = [_calendar components:NSCalendarUnitMonth fromDate:thisYear toDate:nextYear options:kNilOptions].month;
                return CATDateRangeMake(location, length);
            } else {
                return CATDateRangeInfinity();
            }
        }
        case CATDatePickerUnitDay: {
            if (_units & CATDatePickerUnitMonth) {
                return CATDateRangeWithRange([_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date]);
            } else if (_units & CATDatePickerUnitYear) {
                // NSCalendarUnitDay means day in month, so it could not be used for range query
                NSDate *thisYear = [_calendar cat_startOfYearForDate:date];
                NSDate *nextYear = [_calendar cat_dateByAddingUnit:NSCalendarUnitYear value:1 toDate:thisYear options:kNilOptions];
                NSInteger location = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date].location;
                NSInteger length = [_calendar components:NSCalendarUnitDay fromDate:thisYear toDate:nextYear options:kNilOptions].day;
                return CATDateRangeMake(location, length);
            } else {
                return CATDateRangeInfinity();
            }
        }
        case CATDatePickerUnitHour: {
            return CATDateRangeWithRange([_calendar rangeOfUnit:NSCalendarUnitHour inUnit:NSCalendarUnitDay forDate:date]);
        }
        case CATDatePickerUnitMinute: {
            return CATDateRangeWithRange([_calendar rangeOfUnit:NSCalendarUnitMinute inUnit:NSCalendarUnitHour forDate:date]);
        }
        case CATDatePickerUnitSecond:{
            return CATDateRangeWithRange([_calendar rangeOfUnit:NSCalendarUnitSecond inUnit:NSCalendarUnitMinute forDate:date]);
        }
        default:
            return CATDateRangeMake(0, 0);
    }
}

- (CATDateRange)cat_validateRange:(CATDateRange)naturalRange forUnit:(CATDatePickerUnit)unit ofDate:(NSDate *)date {
    NSInteger min = CATDateRangeMin(naturalRange);
    NSInteger max = CATDateRangeMax(naturalRange);
    NSDate *rangeMinDate = [self cat_date:date setUnit:unit toValue:min];
    NSDate *rangeMaxDate = [self cat_date:date setUnit:unit toValue:max];
    if (_minimumDate && [_minimumDate earlierDate:rangeMinDate] == rangeMinDate) {
        min = [self cat_valueForUnit:unit ofDate:_minimumDate];
    }
    if (_maximumDate && [_maximumDate laterDate:rangeMaxDate] == rangeMaxDate) {
        max = [self cat_valueForUnit:unit ofDate:_maximumDate];
    }
    return CATDateRangeMake(min, max - min + 1);
}

- (NSDate *)cat_validateDate:(NSDate *)date {
    NSDate *result = date;
    if (_minimumDate) result = [_minimumDate laterDate:result];
    if (_maximumDate) result = [_maximumDate earlierDate:result];
    return result;
}

#pragma mark format
- (NSDateFormatter *)cat_defaultFormatterForUnit:(CATDatePickerUnit)unit {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.calendar = _calendar;
    formatter.locale = _locale;
    switch (unit) {
        case CATDatePickerUnitEra: {
            formatter.dateFormat = @"G";
        } break;
        case CATDatePickerUnitYear: {
            formatter.dateFormat = @"yyyy";
        } break;
        case CATDatePickerUnitMonth: {
            formatter.dateFormat = @"MMM";
        } break;
        case CATDatePickerUnitDay: {
            if (_units & CATDatePickerUnitMonth) {
                formatter.dateFormat = @"d";
            } else {
                formatter.dateFormat = @"D";
            }
        } break;
        case CATDatePickerUnitHour: {
            formatter.dateFormat = @"HH";
        } break;
        case CATDatePickerUnitMinute: {
            formatter.dateFormat = @"mm";
        } break;
        case CATDatePickerUnitSecond:{
            formatter.dateFormat = @"ss";
        } break;
        default:
            formatter.dateFormat = @"";
    }
    return formatter;
}

- (NSDateFormatter *)formatterForUnit:(CATDatePickerUnit)unit {
    return _formatterByUnits[@(unit)];
}

- (void)setFormatter:(NSDateFormatter *)formatter forUnit:(CATDatePickerUnit)unit {
    _formatterByUnits[@(unit)] = formatter;
    if (self.window) [self cat_reloadPickers];
}

#pragma mark load
- (void)cat_removeAllPickers {
    [_pickers makeObjectsPerformSelector:@selector(removeFromSuperview)]; // rarely reload hence no picker reuse logic here
    [_pickers removeAllObjects];
}

- (void)cat_loadPickerForUnit:(CATDatePickerUnit)unit {
    if (!(_units & unit)) return;
    
    // layout
    CATDatePickerLayout *layout = [[CATDatePickerLayout alloc] init];
    layout.itemSize = CGSizeMake(layout.itemSize.width, _lineHeight);
    
    // appearance
    CATDateUnitPicker *picker = [[CATDateUnitPicker alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    picker.cyclic = unit == CATDatePickerUnitMinute || unit == CATDatePickerUnitSecond;
    picker.normalAttributes = _normalAttributes;
    picker.highlightAttributes = _highlightAttributes;
    picker.disableAttributes = _disableAttributes;
    
    // validate callback
    __weak typeof(self) _weak_self_ = self;
    __weak typeof(picker) _weak_picker_ = picker;
    picker.validate = ^() {
        __strong typeof(_weak_self_) self = _weak_self_;
        __strong typeof(_weak_picker_) picker = _weak_picker_;
        CATDateRange naturalRange = picker.naturalRange;
        CATDateRange validRange = picker.validRange;
        picker.naturalRange = [self cat_naturalRangeForUnit:unit ofDate:self.date];
        picker.validRange = [self cat_validateRange:picker.naturalRange forUnit:unit ofDate:self.date];

        BOOL changed = NO
        || !CATDateRangeEqualToRange(naturalRange, picker.naturalRange)
        || !CATDateRangeEqualToRange(validRange, picker.validRange);
        if (changed) [picker reloadData];
        
        [picker centerizeValue:[self cat_valueForUnit:unit ofDate:self.date] animated:!self->_disablePickerAnimation];
    };
    
    // pick callback
    picker.pickUpValue = ^(NSInteger value) {
        __strong typeof(_weak_self_) self = _weak_self_;
        self.date = [self cat_validateDate:[self cat_date:self.date setUnit:unit toValue:value]];
    };
    
    // title callback
    NSDateFormatter *formatter = _formatterByUnits[@(unit)] ?: [self cat_defaultFormatterForUnit:unit];
    picker.titleForValue = ^(NSInteger value) {
        __strong typeof(_weak_self_) self = _weak_self_;
        return [formatter stringFromDate:[self cat_date:self.date setUnit:unit toValue:value]];
    };
    
    [_pickers addObject:picker];
    [self addSubview:picker];
}

- (void)cat_reloadPickers {
    [self cat_removeAllPickers];
    [self cat_loadPickerForUnit:CATDatePickerUnitEra];
    [self cat_loadPickerForUnit:CATDatePickerUnitYear];
    [self cat_loadPickerForUnit:CATDatePickerUnitMonth];
    [self cat_loadPickerForUnit:CATDatePickerUnitDay];
    [self cat_loadPickerForUnit:CATDatePickerUnitHour];
    [self cat_loadPickerForUnit:CATDatePickerUnitMinute];
    [self cat_loadPickerForUnit:CATDatePickerUnitSecond];
    [self setNeedsLayout];
}

#pragma mark validate
- (void)cat_revalidate {
    [_pickers makeObjectsPerformSelector:@selector(revalidate)];
}

@end
