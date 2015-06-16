#import "easemobDonler.h"
#import "ChatSendHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation easemobDonler

- (void) init:(CDVInvokedUrlCommand *)command
{
  [[EaseMob sharedInstance] registerSDKWithAppKey:@"donler#donlerapp" 
    apnsCertName:@"55yali"
      otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
}

/**
* login: command.arguments:[username, password];
*/
- (void) login:(CDVInvokedUrlCommand *)command
{
  NSString* username = [command.arguments objectAtIndex: 0];
  NSString* password = [command.arguments objectAtIndex: 1];

  [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {

         if (loginInfo && !error) {
             //获取群组列表
             // [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];

             CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
             [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
         }
         else
         {
             NSString *errorMessage = [NSString stringWithFormat:@"%@",error.errorCode];
             CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
             [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
         }
     } onQueue:nil];

  
  //NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity: 10];
  //[resultDic setObject:username forKey:@"name"];
  //[resultDic setObject:password forKey:@"password"];
  //NSArray* resultArray = @[resultDic, resultDic];

  //CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: resultArray];
  //[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) chat:(CDVInvokedUrlCommand *)command
{
    NSDictionary *args = [command.arguments objectAtIndex: 0];
    NSString* chatType = [args objectForKey: @"chatType"];
    NSString* target = [args objectForKey: @"target"];
    NSDictionary *content = [args objectForKey: @"content"];
    EMMessageType messageType;
    if([chatType isEqualToString:@"single"])
    {
        messageType = eMessageTypeChat;
    }
    else
    {
        messageType = eMessageTypeGroupChat;
    }
    EMMessage *tempMessage;
    NSString *contentType = [args objectForKey:@"contentType"];
    if([contentType isEqualToString:@"TXT"])
    {
        NSString *text = [content objectForKey:@"text"];
        tempMessage = [ChatSendHelper sendTextMessageWithString:text
                                                     toUsername:target
                                                    messageType:messageType
                                              requireEncryption:NO
                                                            ext:nil];
    }
    else if([contentType isEqualToString:@"IMAGE"])
    {
        NSString *path = [content objectForKey:@"filePath"];
        //NSString *referenceURL = [[NSURL fileURLWithPath:path] URLByStandardizingPath];
        NSString *referenceURL = [path substringFromIndex:8];
        //NSURL *urlString = (NSURL *)path;
        //NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:urlString]])];
        //UIImage *image = [UIImage imageWithData:imageData];

        UIImage *image = [[UIImage alloc] initWithContentsOfFile:referenceURL];
        tempMessage = [ChatSendHelper sendImageMessageWithImage:image
                                                     toUsername:target
                                                    messageType:messageType
                                              requireEncryption:NO
                                                            ext:nil];
    }
    else if([contentType isEqualToString:@"VOICE"])
    {
        NSString *recordPath = [content objectForKey:@"filePath"];
        EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:recordPath
                                                   displayName:@"audio"];
        tempMessage = [ChatSendHelper sendVoice:voice
                                                     toUsername:target
                                                    messageType:messageType
                                              requireEncryption:NO
                                                            ext:nil];
    }
    else
    {

    }

    NSMutableDictionary *resultMessage = [self formatMessage:tempMessage];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: resultMessage];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

//- (void) recordStart:(CDVInvokedUrlCommand *)command
//{
//
//}

- (void) recordstart:(CDVInvokedUrlCommand *)command
{
     NSString *username = [command.arguments objectAtIndex: 0];
     if ([self canRecord]) {
         //DXRecordView *tmpView = (DXRecordView *)recordView;
         //tmpView.center = self.view.center;
         //[self.view addSubview:tmpView];
         //[self.view bringSubviewToFront:recordView];
         int x = arc4random() % 100000;
         NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
         NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
         NSLog(@"%@",fileName);
//         CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//         [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
         [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName
                                                                  completion:^(NSError *error)
          {
              if (error) {
                  NSLog(NSLocalizedString(@"message.startRecordFail", @"failure to start recording"));
                  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
                  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
              }
              else {
                  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
              }
          }];
     }
}

- (void) recordend: (CDVInvokedUrlCommand *)command
{
    //__weak typeof(self) weakSelf = self;

    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            NSString *chatType = [command.arguments objectAtIndex: 0];
            NSString* target = [command.arguments objectAtIndex: 1];
            EMMessageType messageType;
            if([chatType isEqualToString:@"single"])
            {
                messageType = eMessageTypeChat;
            }
            else
            {
                messageType = eMessageTypeGroupChat;
            }
            EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:recordPath
                                                       displayName:@"audio"];
            voice.duration = aDuration;
            //[weakSelf sendAudioMessage:voice];
            EMMessage *tempMessage = [ChatSendHelper sendVoice:voice
                                                    toUsername:target
                                                   messageType:messageType
                                             requireEncryption:NO ext:nil];
            NSMutableDictionary *resultMessage = [self formatMessage:tempMessage];
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: resultMessage];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //[weakSelf hideHud];
                //weakSelf.chatToolBar.recordButton.enabled = YES;
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"录音时间太短"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            });
        }
    }];
}

- (BOOL)canRecord
{
     __block BOOL bCanRecord = YES;
     if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
     {
         AVAudioSession *audioSession = [AVAudioSession sharedInstance];
         if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
             [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                 bCanRecord = granted;
             }];
         }
     }

     return bCanRecord;
}


-(NSMutableDictionary *)formatMessage:(EMMessage *)tempMessage
{
    NSMutableDictionary *resultMessage = [NSMutableDictionary dictionaryWithCapacity:10];

    id type ;
    switch (tempMessage.messageType) {
        case eMessageTypeChat:{
            type = @"single";
        };
        break;
        case eMessageTypeGroupChat:{
            type = @"group";
        };
    }
    [resultMessage setObject:type forKey:@"type"];
    [resultMessage setObject:@"send" forKey:@"direct"];
    [resultMessage setObject:tempMessage.to forKey:@"to"];
    [resultMessage setObject:tempMessage.from forKey:@"from"];
    [resultMessage setObject:tempMessage.messageId forKey:@"msgId"];
    id<IEMMessageBody> msgBody = tempMessage.messageBodies.firstObject;
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:{
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            [resultMessage setObject:txt forKey:@"text"];
        };
        break;
        case eMessageBodyType_Image:{

        };
        break;
        case eMessageBodyType_Location:{

        };
        break;
        case eMessageBodyType_Voice:{

        };
    }
    return resultMessage;
}

@end