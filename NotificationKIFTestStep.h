

#import "KIFTestStep.h"

@interface NotificationKIFTestStep : KIFTestStep

+ (KIFTestStep*)stepToDetectNotification:(NSString*)notificationName 
                                object:(NSObject*) object
                sentWithinTimeinterval:(NSTimeInterval)interval;


@end
