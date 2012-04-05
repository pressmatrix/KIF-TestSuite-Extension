
#import "ASIHTTPRequest.h"

@interface KIFNetworkDisabler : ASIHTTPRequest <NSURLConnectionDelegate>

+ (KIFNetworkDisabler*)sharedInstance;

@property (assign) BOOL stopNetWork;

@end
