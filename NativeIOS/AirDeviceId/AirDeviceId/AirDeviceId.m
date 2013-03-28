//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Freshplanet (http://freshplanet.com | opensource@freshplanet.com)
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  
//////////////////////////////////////////////////////////////////////////////////////

#import "AirDeviceId.h"
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import "MacAddressUID.h"

FREContext AirDeviceIdCtx = nil;


@implementation AirDeviceId

#pragma mark - Singleton

static AirDeviceId *sharedInstance = nil;

+ (AirDeviceId *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }

    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return self;
}

@end


#pragma mark - C interface

/* This is a TEST function that is being included as part of this template. 
 *
 * Users of this template are expected to change this and add similar functions 
 * to be able to call the native functions in the ANE from their ActionScript code
 */
DEFINE_ANE_FUNCTION(IsSupported)
{
    NSLog(@"Entering IsSupported()");

    FREObject fo;

    FREResult aResult = FRENewObjectFromBool(YES, &fo);
    if (aResult == FRE_OK)
    {
        //things are fine
        NSLog(@"Result = %d", aResult);
    }
    else
    {
        //aResult could be FRE_INVALID_ARGUMENT or FRE_WRONG_THREAD, take appropriate action.
        NSLog(@"Result = %d", aResult);
    }
    
    NSLog(@"Exiting IsSupported()");
    
    return fo;
}

DEFINE_ANE_FUNCTION(getDeviceId)
{
    NSLog(@"Entering getDeviceId()");
    FREObject fo;
    
    // get the id
    NSString * idString;
    
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)])
    {
        NSLog(@"identifierForVendor supported");
        idString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    // Forbidden by Apple starting 2013-05-01
    //else if([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)])
    //{
    //    NSLog(@"identifierForVendor not supported, using uniqueIdentifier");
    //    idString = [[UIDevice currentDevice] uniqueIdentifier];
    //}
    else
    {
        // get the salt
        uint32_t stringArgLength;
        const uint8_t *stringArg;
        
        NSString *salt;
        if (FREGetObjectAsUTF8(argv[0], &stringArgLength, &stringArg) != FRE_OK)
        {
            salt = @"";
        }
        else
        {
            salt = [NSString stringWithUTF8String:(char*)stringArg];
        }
        
        // get the mac address id
        idString = [MacAddressUID uniqueIdentifierForSalt:salt];
    }
    
    // set the id in the response
    NSLog(@"id returned: %@", idString);
    FRENewObjectFromUTF8(strlen([idString UTF8String]), (const uint8_t *)[idString UTF8String], &fo);
    NSLog(@"Exiting getDeviceId()");
    return fo;
}

DEFINE_ANE_FUNCTION(getAdvertisingId)
{
    NSLog(@"Entering getAdvertisingId()");
    FREObject fo;
    
    // get the id
    NSString * idString;
    
    if([[ASIdentifierManager sharedManager] respondsToSelector:@selector(advertisingIdentifier)])
    {
        NSLog(@"advertisingIdentifier supported");
        idString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    // Forbidden by Apple starting 2013-05-01
    //else if([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)])
    //{
    //    NSLog(@"advertisingIdentifier not supported, using uniqueIdentifier");
    //    idString = [[UIDevice currentDevice] uniqueIdentifier];
    //}
    else
    {
        // get the salt
        uint32_t stringArgLength;
        const uint8_t *stringArg;
        
        NSString *salt;
        if (FREGetObjectAsUTF8(argv[0], &stringArgLength, &stringArg) != FRE_OK)
        {
            salt = @"";
        }
        else
        {
            salt = [NSString stringWithUTF8String:(char*)stringArg];
        }
        
        // get the mac address id
        idString = [MacAddressUID uniqueIdentifierForSalt:salt];
    }
    
    NSLog(@"id returned: %@", idString);
    FRENewObjectFromUTF8(strlen([idString UTF8String]), (const uint8_t *)[idString UTF8String], &fo);
    NSLog(@"Exiting getAdvertisingId()");
    return fo;
}

#pragma mark - ANE setup

/* AirDeviceIdExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml 
 */
void AirDeviceIdExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    NSLog(@"Entering AirDeviceIdExtInitializer()");

    *extDataToSet = NULL;
    *ctxInitializerToSet = &ContextInitializer;
    *ctxFinalizerToSet = &ContextFinalizer;

    NSLog(@"Exiting AirDeviceIdExtInitializer()");
}

/* AirDeviceIdExtFinalizer()
 * The extension finalizer is called when the runtime unloads the extension. However, it may not always called.
 *
 * Please note: this should be same as the <finalizer> specified in the extension.xml 
 */
void AirDeviceIdExtFinalizer(void* extData) 
{
    NSLog(@"Entering AirDeviceIdExtFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting AirDeviceIdExtFinalizer()");
    return;
}

/* ContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
 */
void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering ContextInitializer()");

    /* The following code describes the functions that are exposed by this native extension to the ActionScript code.
     * As a sample, the function isSupported is being provided.
     */
    *numFunctionsToTest = 3;

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));
    func[0].name = (const uint8_t*) "isSupported";
    func[0].functionData = NULL;
    func[0].function = &IsSupported;
    
    func[1].name = (const uint8_t*) "getDeviceId";
    func[1].functionData = NULL;
    func[1].function = &getDeviceId;
    
    func[2].name = (const uint8_t*) "getAdvertisingId";
    func[2].functionData = NULL;
    func[2].function = &getAdvertisingId;

    *functionsToSet = func;

    AirDeviceIdCtx = ctx;

    NSLog(@"Exiting ContextInitializer()");
}

/* ContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void ContextFinalizer(FREContext ctx) 
{
    NSLog(@"Entering ContextFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting ContextFinalizer()");
    return;
}


