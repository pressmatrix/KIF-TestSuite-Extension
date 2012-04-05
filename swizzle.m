

#import <objc/runtime.h> 
#import <objc/message.h>
#import <UIKit/UIKit.h>
#import "swizzle.h"

static void SwizzleInstanceMethod(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

static void SwizzleInstanceMethodFromClass(Class c, SEL orig, Class c2, SEL new)
{
    //Add the new method from a c2 to c1
    Method newMethod = class_getInstanceMethod(c2, new);
    class_addMethod(c, new, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    // Then just swizzle
    SwizzleInstanceMethod(c, orig, new);
}

static void SwizzleNameInstanceMethodFromClass(NSString *cn, SEL orig, NSString *cn2, SEL new)
{
    Class c = NSClassFromString(cn);
    Class c2 = NSClassFromString(cn2);
    
    SwizzleInstanceMethodFromClass(c, orig, c2, new);
}

static void SwizzleClassMethod(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c, new);
    Class cMetaClass = objc_getMetaClass(class_getName(c));
    if(class_addMethod(cMetaClass, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(cMetaClass, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

static void SwizzleClassMethodFromClass(Class c, SEL orig, Class c2, SEL new)
{
    Method origMethod = class_getClassMethod(c, orig);
    Method newMethod = class_getClassMethod(c2, new);
    Class cMetaClass = objc_getMetaClass(class_getName(c));
    if(class_addMethod(cMetaClass, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(cMetaClass, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}


//Method to exchange methods in Runtime
void doSwizzle(){
    SwizzleNameInstanceMethodFromClass(@"ASIHTTPRequest",@selector(main),@"KIFNetworkDisabler",@selector(newASImain));
    SwizzleNameInstanceMethodFromClass(@"AFHTTPRequestOperation",@selector(operationDidStart),@"KIFNetworkDisabler",@selector(newAFoperationDidStart));
    SwizzleNameInstanceMethodFromClass(@"KIFTestStep",@selector(executeAndReturnError:),@"KIFTestStep",@selector(suiteExecuteAndReturnError:));
    SwizzleNameInstanceMethodFromClass(@"KIFTestScenario",@selector(setStepsToSetUp:),@"KIFTestScenario",@selector(suiteSetStepsToSetUp:));
    SwizzleNameInstanceMethodFromClass(@"KIFTestScenario",@selector(setStepsToTearDown:),@"KIFTestScenario",@selector(suiteSetStepsToTearDown:));
}



