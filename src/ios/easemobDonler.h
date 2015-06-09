
#import <Cordova/CDVPlugin.h>
#import "EaseMob.h"

@interface easemobDonler : CDVPlugin
{}

- (void) init:(CDVInvokedUrlCommand *)command;

- (void) login:(CDVInvokedUrlCommand *)command;

@end