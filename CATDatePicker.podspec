Pod::Spec.new do |s|

  s.name          = "CATDatePicker"
  s.summary       = "A flexible date picker for iOS"
  s.description   = <<-DESC

                    typedef enum {
                         UIDatePickerModeTime ,
                         UIDatePickerModeDate ,
                         UIDatePickerModeDateAndTime ,
                         UIDatePickerModeCountDownTimer 
                      } UIDatePickerMode;

                    UIDatePicker only supports 4 modes, and one of them is a timer. I need more component combinations.
                    
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

                   DESC

  s.homepage      = "https://github.com/li-qing/CATDatePicker"
  s.author        = { "li-qing" => "lshhch@gmail.com" }
  s.license       = "MIT"

  s.version       = "1.0.0"
  s.platform      = :ios, "6.0"
  s.requires_arc  = true
  s.frameworks    = 'Foundation', 'UIKit' 
  s.source        = { :git => "https://github.com/li-qing/CATDatePicker.git", :tag => s.version.to_s }
  s.source_files  = "CATDatePicker/*.{h,m}"

end
