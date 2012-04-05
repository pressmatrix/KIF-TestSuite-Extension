
#import "KIFTestStep+Steps.h"
#import "UIApplication-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIView-KIFAdditions.h"

@interface KIFTestStep ()

+ (void)checkViews:(NSArray *)subviews;

@end

@implementation KIFTestStep (Steps)

#pragma mark instance methods

- (KIFTestStep*)_setTimeout:(NSTimeInterval)tout{
    self.timeout = tout;
    return self;
}

- (KIFTestStep*)_setDescription:(NSString*)desc{
    self.description = desc;
    return self;
}

#pragma mark class methods

+ (id)accessibilityViewWithLabel:(NSString*)label{
    UIAccessibilityElement *element = [[UIApplication sharedApplication] accessibilityElementWithLabel:label];
    return [UIAccessibilityElement viewContainingAccessibilityElement:element];
}

+ (void)checkViews:(NSArray *)subviews {
    Class AVClass = [UIAlertView class];
    Class ASClass = [UIActionSheet class];
    for (UIView * subview in subviews){
        if ([subview isKindOfClass:AVClass]){
            [(UIAlertView *)subview dismissWithClickedButtonIndex:[(UIAlertView *)subview cancelButtonIndex] animated:NO];
        } else if ([subview isKindOfClass:ASClass]){
            [(UIActionSheet *)subview dismissWithClickedButtonIndex:[(UIActionSheet *)subview cancelButtonIndex] animated:NO];
        } else {
            [self checkViews:subview.subviews];
        }
    }
}

+ (KIFTestStep*)stepToTapSearchBarScope:(NSInteger)scopeBarIndex inSearchbarWithLabel:(NSString*)searchBarAccessibilityLabel{
    
    return [KIFTestStep stepWithDescription:@"selecting a scope in the searchbar" 
                             executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
                                 UISearchBar* searchbar = (UISearchBar*)[self accessibilityViewWithLabel:searchBarAccessibilityLabel];
                                 KIFTestWaitCondition(searchbar, error, @"could not find the searchbar");
                                 KIFTestCondition(searchbar.scopeButtonTitles.count > scopeBarIndex, error, @"the specified index %i is out of range for the searchbar, it has only %i scopes", scopeBarIndex, searchbar.scopeButtonTitles.count);
                                 NSString* scopeTitle = [[[searchbar scopeButtonTitles] objectAtIndex:scopeBarIndex] stringByAppendingFormat:@", %i ",scopeBarIndex+1];
                                 NSLog(@"searching for the scope:%@",scopeTitle);
                                 
                                 UIView* segmentAtIndex  = nil;
                                 for (id searchSubView in searchbar.subviews) {
                                     if([searchSubView isKindOfClass:[UISegmentedControl class]]){
                                         for (UIView* segment in [searchSubView subviews]) {
                                             if ([segment.accessibilityLabel rangeOfString:scopeTitle].location != NSNotFound) {
                                                 segmentAtIndex = segment;
                                                 break;
                                             }
                                         }
                                     }
                                 }
                                 KIFTestCondition(segmentAtIndex, error, @"no scope in the searchbar found");
                                 
                                 CGRect elementFrame = [segmentAtIndex.window convertRect:segmentAtIndex.accessibilityFrame toView:segmentAtIndex];
                                 CGPoint tappablePointInElement = [segmentAtIndex tappablePointInRect:elementFrame];
                                 [segmentAtIndex tapAtPoint:tappablePointInElement];
                                 return KIFTestStepResultSuccess;
                             }];
}

+ (KIFTestStep*)stepSetFocusOnSearchbar:(NSString*)accessibilityLabel{
    return [KIFTestStep stepWithDescription:@"selecting a scope in the searchbar" 
                             executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
                                 UISearchBar* searchbar = (UISearchBar*)[self accessibilityViewWithLabel:accessibilityLabel];
                                 KIFTestWaitCondition(searchbar, error, @"could not find the searchbar");
                                 
                                 UIView* segmentAtIndex  = nil;
                                 for (id searchSubView in searchbar.subviews) {
                                     if([searchSubView isKindOfClass:[UITextField class]]){
                                         segmentAtIndex = searchSubView;
                                     }
                                 }
                                 KIFTestCondition(segmentAtIndex, error, @"no UITextField in the searchbar found");
                                 CGRect elementFrame = [segmentAtIndex.window convertRect:segmentAtIndex.accessibilityFrame toView:segmentAtIndex];
                                 CGPoint tappablePointInElement = [segmentAtIndex tappablePointInRect:elementFrame];
                                 [segmentAtIndex tapAtPoint:tappablePointInElement];
                                 return KIFTestStepResultSuccess;
                             }];
    
}

+ (KIFTestStep*)stepToDismissAllAlertViewsAndActionSheets{
    NSString *description = [NSString stringWithFormat:@"closing all possible UIAlertViews and Actionsheets"];
    return [KIFTestStep stepWithDescription:description
                             executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
                                 NSArray *windows = [[UIApplication sharedApplication] windows];
                                 for (UIWindow* window in windows) {
                                     [KIFTestStep checkViews:windows];
                                 }
                                 return KIFTestStepResultSuccess;
                             }];
}




+ (KIFTestStep*)stepToTapKeyBoardReturnKeyOfType:(UIReturnKeyType)type
{
    NSString* identifier = nil;
    switch (type) {
        case UIReturnKeySearch:
            identifier = @"System_Return_Key_Search";
            break;
        case UIReturnKeyNext:
            identifier = @"System_Return_Key_Next";
            break;
        case UIReturnKeySend:
            identifier = @"System_Return_Key_Send";
            break;
        case UIReturnKeyDefault:
            identifier = @"System_Return_Key_Default";
            break;
        case UIReturnKeyEmergencyCall:
            identifier = @"System_Return_Key_EmergencyCall";
            break;
        case UIReturnKeyGo:
            identifier = @"System_Return_Key_Go";
            break;
        case UIReturnKeyDone:
            identifier = @"System_Return_Key_Done";
            break;
        case UIReturnKeyJoin:
            identifier = @"System_Return_Key_Join";
            break;
        case UIReturnKeyRoute:
            identifier = @"System_Return_Key_Route";
            break;
        case UIReturnKeyYahoo:
            identifier = @"System_Return_Key_Yahoo";
            break;
        case UIReturnKeyGoogle:
            identifier = @"System_Return_Key_Google";
            break;
    }
    identifier = NSLocalizedString(identifier, nil);
    if ([identifier rangeOfString:@"System_Return_Key_"].location != NSNotFound) {
        return [KIFTestStep stepWithDescription:@"The return type was not setup in the tests" executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
            KIFTestCondition(FALSE, error, @"there was no localized verion of the Return type %@",identifier);
        }];
    }
    KIFTestStep* step = [KIFTestStep stepToTapViewWithAccessibilityLabel:identifier];
    step.description =  [NSString stringWithFormat:@"Tapping on the return key of the keyboard which should be of type \"%@\"", identifier];
    return step;
}

+ (KIFTestStep*)stepToTapBackButton{
    return [KIFTestStep stepToTapViewWithAccessibilityLabel:NSLocalizedString(@"System_Back", nil)];
}

+ (KIFTestStep*)stepToClearTextFieldWithLabel:(NSString*)label{
    NSString *description = [NSString stringWithFormat:@"Clearing label %@", label];
    return [KIFTestStep stepWithDescription:description
                             executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
                                 UITextView *textView = [KIFTestStep accessibilityViewWithLabel:label];
                                 KIFTestWaitCondition(textView ,error, @"The element with accessibility label %@ was not found", label);
                                 [textView setText:@""];
                                 return KIFTestStepResultSuccess;
                             }];
}

+ (KIFTestStep*)stepToFailWithAccessibilityLabel:(NSString*)label{
    NSString *description = [NSString stringWithFormat:@"Searching for AccessibilityLabel %@", label];
    return [KIFTestStep stepWithDescription:description
                             executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
                                 id view = [KIFTestStep accessibilityViewWithLabel:label];
                                 KIFTestCondition(!view, error, @"The element with accessibility label %@ should not have been visible", label);
                                 return KIFTestStepResultSuccess;
                             }];
}

+ (KIFTestStep*)stepToAssumeFirstResponderAtElementWithAccessibilityLabel:(NSString*)label{
    NSString *description = [NSString stringWithFormat:@"Checking if element for AccessibilityLabel %@ if the first Responder", label];
    return [KIFTestStep stepWithDescription:description
                             executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
                                 id view = [KIFTestStep accessibilityViewWithLabel:label];
                                 KIFTestWaitCondition(!view ,error, @"The element with accessibility label %@ was not found", label);
                                 KIFTestCondition(!view || ![view isFirstResponder], error, @"The element with accessibility label %@ is not the first", label);
                                 return KIFTestStepResultSuccess;
                             }];
}

+ (KIFTestStep*)stepToAssumeFirstResponderNotAtElementWithAccessibilityLabel:(NSString*)label{
    NSString *description = [NSString stringWithFormat:@"Checking if element for AccessibilityLabel %@ if not the first Responder anymore", label];
    return [KIFTestStep stepWithDescription:description
                             executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
                                 id view = [KIFTestStep accessibilityViewWithLabel:label];
                                 KIFTestWaitCondition(!view ,error, @"The element with accessibility label %@ was not found", label);
                                 KIFTestCondition(view && ![view isFirstResponder], error, @"The element with accessibility label %@ should not have been the first responder", label);
                                 return KIFTestStepResultSuccess;                                 
                             }];
}

+ (KIFTestStep*)stepToTapViewWithLocalizedAccessibilityLabel:(NSString*)localizedKey{
    KIFTestStep* step = [KIFTestStep stepToTapViewWithAccessibilityLabel:NSLocalizedString(localizedKey, nil)];
    step.description = [NSString stringWithFormat:@"Tap view with localized accessibility label:%@ (translates to \"%@\"",localizedKey, NSLocalizedString(localizedKey, nil)];
    return step;
}




@end
