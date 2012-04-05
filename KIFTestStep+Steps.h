
#import "KIFTestStep.h"

@interface KIFTestStep (Steps)

- (KIFTestStep*)_setTimeout:(NSTimeInterval)timeout;
- (KIFTestStep*)_setDescription:(NSString*)desc;

+ (KIFTestStep*)stepToDismissAllAlertViewsAndActionSheets;
+ (KIFTestStep*)stepToClearTextFieldWithLabel:(NSString*)label;
+ (KIFTestStep*)stepToFailWithAccessibilityLabel:(NSString*)label;
+ (KIFTestStep*)stepToAssumeFirstResponderAtElementWithAccessibilityLabel:(NSString*)label;
+ (KIFTestStep*)stepToAssumeFirstResponderNotAtElementWithAccessibilityLabel:(NSString*)label;
+ (KIFTestStep*)stepToTapKeyBoardReturnKeyOfType:(UIReturnKeyType)type;
+ (KIFTestStep*)stepToTapBackButton;
+ (KIFTestStep*)stepToTapViewWithLocalizedAccessibilityLabel:(NSString*)localizedKey;

+ (KIFTestStep*)stepSetFocusOnSearchbar:(NSString*)accessibilityLabel;
+ (KIFTestStep*)stepToTapSearchBarScope:(NSInteger)scopeBarIndex 
                   inSearchbarWithLabel:(NSString*)searchBarAccessibilityLabel;

+ (id)accessibilityViewWithLabel:(NSString*)label;


@end
