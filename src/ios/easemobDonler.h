
#import <Cordova/CDVPlugin.h>
#import "EaseMob.h"
#import "EMCDDeviceManager.h"

@interface easemobDonler : CDVPlugin
{}

- (void) init:(CDVInvokedUrlCommand *)command;

- (void) login:(CDVInvokedUrlCommand *)command;

- (void) chat:(CDVInvokedUrlCommand *)command;

- (void) recordstart:(CDVInvokedUrlCommand *)command;

- (void) recordend: (CDVInvokedUrlCommand *)command;
@end