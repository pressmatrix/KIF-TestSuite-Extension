#import "KIFNetworkDisabler.h"

static KIFNetworkDisabler* sharedInstance;

static void releaseInstance()
{
    [sharedInstance release];
    sharedInstance = nil;
}

@implementation KIFNetworkDisabler

+ (KIFNetworkDisabler *)sharedInstance 
{ 
	static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        atexit(releaseInstance);
    });
    return sharedInstance;
} 

@synthesize stopNetWork;

- (void)newASImain{
    
    if ([KIFNetworkDisabler sharedInstance].stopNetWork){
        NSError* failError = [[NSError alloc] initWithDomain:NetworkRequestErrorDomain code:ASIRequestTimedOutErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"The request timed out",NSLocalizedDescriptionKey,nil]];
        [self failWithError:[failError autorelease]];
    }
    else{
        [self newASImain];
    }
}

- (void)newAFoperationDidStart{
    if ([KIFNetworkDisabler sharedInstance].stopNetWork){
        NSError* failError = [[NSError alloc] initWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"The request timed out",NSLocalizedDescriptionKey,nil]];
        [self connection:nil 
        didFailWithError:[failError autorelease]];
    }
    else{
        [self newAFoperationDidStart];
    }
}

@end
