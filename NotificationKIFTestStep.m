
#import "NotificationKIFTestStep.h"

@interface NotificationKIFTestStep() 

@property (nonatomic, retain) NSMutableArray* timedNotificationTimes;
@property (nonatomic, retain) NSObject* timedNotificationObject;
@property (nonatomic, copy) NSString* timedNotificationName;
@property (nonatomic, assign) NSTimeInterval timedNotificationInterval;

- (void)notificationOccured:(NSNotification*)notification;

@end

@implementation NotificationKIFTestStep

@synthesize timedNotificationTimes;
@synthesize timedNotificationObject;
@synthesize timedNotificationName;
@synthesize timedNotificationInterval;


- (id)init{
    self = [super init];
    if (self) {
        self.timedNotificationTimes = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.timedNotificationName = nil;
    self.timedNotificationTimes = nil;
    self.timedNotificationObject = nil;
    [super dealloc];
}

- (void)notificationOccured:(NSNotification*)notification{
    if ([notification.name isEqualToString:self.timedNotificationName]) {
        if (self.timedNotificationObject == nil || self.timedNotificationObject == notification.object) {
            [self.timedNotificationTimes addObject:[NSDate date]];
        }
    }
}

- (KIFTestStepResult)executeAndReturnError:(NSError **)error;
{    
    BOOL notificationFiredOnTime = NO;
    for (NSDate* fireTime in self.timedNotificationTimes) {
        if (fabs([fireTime timeIntervalSinceNow]) <= self.timedNotificationInterval) {
            notificationFiredOnTime = YES;
            break;
        }
    }
    if (error && !notificationFiredOnTime) {
        *error = [NSError errorWithDomain:@"KIFTest" 
                                     code:KIFTestStepResultFailure 
                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"The notification was not fired within the specified time", NSLocalizedDescriptionKey, nil]];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.timedNotificationName = nil;
    self.timedNotificationTimes = nil;
    self.timedNotificationObject = nil;
    
    return notificationFiredOnTime ? KIFTestStepResultSuccess : KIFTestStepResultFailure;
}


+ (KIFTestStep*)stepToDetectNotification:(NSString*)notificationName 
                                  object:(NSObject*)object
                  sentWithinTimeinterval:(NSTimeInterval)interval{
    NSString *description = [NSString stringWithFormat:@"Checking if notification \"%@\" occured within the last %f seconds", notificationName, interval];
    
    NotificationKIFTestStep *step = [[[NotificationKIFTestStep alloc] init] autorelease];
    step.description = description;
    step.timedNotificationName = notificationName;
    step.timedNotificationObject = object;
    step.timedNotificationInterval = interval;
    [[NSNotificationCenter defaultCenter] addObserver:step selector:@selector(notificationOccured:) name:notificationName object:object];
                         
    
    return step;
}


@end
