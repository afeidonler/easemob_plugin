
#import <Cordova/CDVPlugin.h>
#import "EaseMob.h"
#import "EMCDDeviceManager.h"

@interface easemobDonler : CDVPlugin
{}

@property (nonatomic, copy) NSString *callbackId;
@property (nonatomic, copy) NSString *callback;

- (void) init:(CDVInvokedUrlCommand *)command;

- (void) login:(CDVInvokedUrlCommand *)command;

- (void) logout:(CDVInvokedUrlCommand *)command;

- (void) chat:(CDVInvokedUrlCommand *)command;

- (void) recordstart:(CDVInvokedUrlCommand *)command;

- (void) recordend: (CDVInvokedUrlCommand *)command;

- (void) recordcancel: (CDVInvokedUrlCommand *)command;

- (void) getAllConversations: (CDVInvokedUrlCommand *)command;

- (void) getMessages: (CDVInvokedUrlCommand *)command;

- (void) resetUnreadMsgCount: (CDVInvokedUrlCommand *)command;

- (void) clearConversation: (CDVInvokedUrlCommand *)command;

- (void) deleteConversation: (CDVInvokedUrlCommand *)command;

- (void) deleteMessage: (CDVInvokedUrlCommand *)command;

- (void) downloadMessage: (CDVInvokedUrlCommand *)command;
@end