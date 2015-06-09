#import "easemobDonler.h"

@implementation easemobDonler

- (void) init:(CDVInvokedUrlCommand *)command
{
  [[EaseMob sharedInstance] registerSDKWithAppKey:@"donler#donlerapp" 
    apnsCertName:@"55yali"
      otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
  // [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
  // NSLog(@"%@", command);
  // CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  // [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) login:(CDVInvokedUrlCommand *)command
{
  NSLog(@"%@", command);
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
@end