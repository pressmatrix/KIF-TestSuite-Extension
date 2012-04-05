
#import <Foundation/Foundation.h>
#import "KIFTestScenario.h"
#import "KIFTestStep.h"
#import "KIFTestStep+Steps.h"
#import "NotificationKIFTestStep.h"

@interface KIFTestSuite : NSObject

+ (NSArray*)suiteStepsToSetup;
+ (NSArray*)suiteStepsToTearDown;

- (KIFTestScenario*)screnarioaaaSetUp;
- (KIFTestScenario*)screnariozzzTearDown;


@end
