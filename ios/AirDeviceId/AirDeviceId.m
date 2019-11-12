/*
 * Copyright 2017 FreshPlanet
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AirDeviceId.h"
#import <AdSupport/AdSupport.h>
#import "Constants.h"

@interface AirDeviceId ()
@property (nonatomic, readonly) FREContext context;
@end

@implementation AirDeviceId

- (instancetype)initWithContext:(FREContext)extensionContext {
    
    if ((self = [super init])) {
        
        _context = extensionContext;
    }
    
    return self;
}

- (void) sendLog:(NSString*)log {
    [self sendEvent:@"log" level:log];
}

- (void) sendEvent:(NSString*)code {
    [self sendEvent:code level:@""];
}

- (void) sendEvent:(NSString*)code level:(NSString*)level {
    FREDispatchStatusEventAsync(_context, (const uint8_t*)[code UTF8String], (const uint8_t*)[level UTF8String]);
}
@end

AirDeviceId* GetAirDeviceIdContextNativeData(FREContext context) {
    
    CFTypeRef controller;
    FREGetContextNativeData(context, (void**)&controller);
    return (__bridge AirDeviceId*)controller;
}

DEFINE_ANE_FUNCTION(getIDFV) {
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        NSString* idString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        return AirDeviceId_FPANE_NSStringToFREObject(idString);
    }
    
    return nil;
}

DEFINE_ANE_FUNCTION(getIDFA) {
  
    AirDeviceId* controller = GetAirDeviceIdContextNativeData(context);
    
    if (!controller)
        return AirDeviceId_FPANE_CreateError(@"context's AirDeviceId is null", 0);
    
    if ([[ASIdentifierManager sharedManager] respondsToSelector:@selector(advertisingIdentifier)]) {
        NSString* idString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [controller sendEvent:kAirDeviceIdEvent_receivedIDFA level:idString];
    }
    
    return nil;
}

#pragma mark - ANE setup

void AirDeviceIdContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                                uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    AirDeviceId* controller = [[AirDeviceId alloc] initWithContext:ctx];
    FRESetContextNativeData(ctx, (void*)CFBridgingRetain(controller));
    
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(getIDFV, NULL),
        MAP_FUNCTION(getIDFA, NULL)
    };
    
    *numFunctionsToTest = sizeof(functions) / sizeof(FRENamedFunction);
    *functionsToSet = functions;
    
}

void AirDeviceIdContextFinalizer(FREContext ctx) {
    CFTypeRef controller;
    FREGetContextNativeData(ctx, (void **)&controller);
    CFBridgingRelease(controller);
}

void AirDeviceIdInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &AirDeviceIdContextInitializer;
    *ctxFinalizerToSet = &AirDeviceIdContextFinalizer;
}

void AirDeviceIdFinalizer(void *extData) {}
