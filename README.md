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


















