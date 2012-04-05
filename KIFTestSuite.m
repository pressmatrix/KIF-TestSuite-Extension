
#import "KIFTestSuite.h"

#import <objc/runtime.h>

static char suiteObjectKey;

@interface KIFTestStep (suite)

@end

@implementation KIFTestStep (suite)

- (BOOL)isSetupOrTearDown {
    NSNumber* associatedNumber = (NSNumber*)objc_getAssociatedObject(self, &suiteObjectKey);
    return [associatedNumber boolValue];
}

- (void)setSetupOrTearDown:(BOOL )setupOrTearDown {
    objc_setAssociatedObject(self, &suiteObjectKey, [NSNumber numberWithBool:setupOrTearDown], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KIFTestStepResult)suiteExecuteAndReturnError:(NSError **)error{
    KIFTestStepResult result = [self suiteExecuteAndReturnError:error];
    
    if ([self isSetupOrTearDown] && (result == KIFTestStepResultFailure || result == KIFTestStepResultWait)) {
        return KIFTestStepResultSuccess;
    }
    return result;
}

@end

@interface KIFTestScenario(suite)

@end

@implementation KIFTestScenario (suite)

- (void)suiteSetStepsToSetUp:(NSArray *)inStepsToSetUp{
    for (KIFTestStep* step in inStepsToSetUp) {
        [step setSetupOrTearDown:YES];
    }
    [self suiteSetStepsToSetUp:inStepsToSetUp];
}

- (void)suiteSetStepsToTearDown:(NSArray *)inStepsToTearDown{
    for (KIFTestStep* step in inStepsToTearDown) {
        [step setSetupOrTearDown:YES];
    }
    [self suiteSetStepsToTearDown:inStepsToTearDown];    
}


@end

@implementation KIFTestSuite

+ (NSArray*)suiteStepsToSetup{
    return nil;
}
+ (NSArray*)suiteStepsToTearDown{
    return nil;
}


- (KIFTestScenario*)screnarioaaaSetUp{
    KIFTestScenario* setup = [[[KIFTestScenario alloc] init] autorelease];
    [setup addStepsFromArray:[[self class] suiteStepsToSetup]];
    return setup;
}
- (KIFTestScenario*)screnariozzzTearDown{
    KIFTestScenario* tearDown = [[[KIFTestScenario alloc] init] autorelease];
    [tearDown addStepsFromArray:[[self class] suiteStepsToTearDown]];
    for (KIFTestStep* step in tearDown.steps) {
        [step setSetupOrTearDown:YES];
    }
    return tearDown;
}



@end
