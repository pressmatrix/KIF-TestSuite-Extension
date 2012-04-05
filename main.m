
#import <UIKit/UIKit.h>

#if RUN_KIF_TESTS
    #import "swizzle.h"
#endif

int main(int argc, char *argv[]) {
    
#if RUN_KIF_TESTS
    doSwizzle();
#endif
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, @"AppApplication", nil);
    [pool release];
    return retVal;
}
    