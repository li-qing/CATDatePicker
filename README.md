# CATDatePicker
A flexible date picker for iOS.


## Modivation to Implement a Date Picker

	typedef enum {
	   UIDatePickerModeTime ,
	   UIDatePickerModeDate ,
	   UIDatePickerModeDateAndTime ,
	   UIDatePickerModeCountDownTimer 
	} UIDatePickerMode;

UIDatePicker only supports 4 modes, and one of them is a timer. I need more component combinations.


## What components does this date picker offer

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

These options provide modes below:

	(era) - year - month - day of month - (hour) - (minute) - (second)
	(era) - year - day of year - (hour) - (minute) - (second)
	(era) - month - day of month - (hour) - (minute) - (second)
	(era) - day - (hour) - (minute) - (second)

all components in parentheses are optional.


## Configurable Component Format

	- (NSDateFormatter *)formatterForUnit:(CATDatePickerUnit)unit;
	- (void)setFormatter:(NSDateFormatter *)formatter forUnit:(CATDatePickerUnit)unit;

CATDatePicker provides get/set method to config date formatter for each component. And CATDatePicker has a build-in behavior to supply date formatter for all un-configured cases. The default formatters are listed below:

	 component 		| formatter
	----------------|-----------
	 era 	   		| G
	 year      		| yyyy
	 month     		| MMM
	 day of month 	| d
	 day of year 	| D
	 hour 			| HH
	 minute 		| mm
	 second 		| ss


## Title Styles for Normal/Highlight/Disable state

Same as UIDatePicker, CATDatePicker provides minimumDate and maximumDate. The date of current row is in highlight date; valid dates use normal style; invalid dates are treated as disabled. Styles could be set through 3 properties of CATDatePicker:

	@property (copy, nonatomic) NSDictionary *normalAttributes;
	@property (copy, nonatomic) NSDictionary *highlightAttributes;
	@property (copy, nonatomic) NSDictionary *disableAttributes;


## Other Features

1. automatically fitting width for components

2. editbale line height

## Features to be Implement

1. configurable/query-able width for components

2. intervals for components


- - -

There's a showcase in the project to illustrate points above. Have fun!

-EOF-