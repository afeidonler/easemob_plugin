#import "easemobDonler.h"
#import "ChatSendHelper.h"
#import "EMChatManagerDelegateBase.h"
#import <AVFoundation/AVFoundation.h>

@interface easemobDonler()<IChatManagerDelegate>{

}
@end
@implementation easemobDonler;

- (void) init:(CDVInvokedUrlCommand *)command
{
    self.callbackId = command.callbackId;
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"donler#donlerapp"
     apnsCertName:@"55yali"
      otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    [EMCDDeviceManager sharedInstance].delegate = self;
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
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

- (void) logout:(CDVInvokedUrlCommand *)command
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES/NO completion:^(NSDictionary *info, EMError *error) {
        if (!error && info) {
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
}

/**
* 发送消息
*/
- (void) chat:(CDVInvokedUrlCommand *)command
{
    NSLog(@"%@",command.callbackId);
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

/**
* 开始录音
*/
- (void) recordstart:(CDVInvokedUrlCommand *)command
{
     if ([self canRecord]) {
         int x = arc4random() % 100000;
         NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
         NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
         NSLog(@"%@",fileName);
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

/**
* 录音结束，发向服务器
*/
- (void) recordend: (CDVInvokedUrlCommand *)command
{
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            NSString *chatType = command.arguments[0];
            NSString* target = command.arguments[1];
            EMMessageType messageType = [self convertToMessageType:chatType];
            EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:recordPath
                                                       displayName:@"audio"];
            voice.duration = aDuration;
            EMMessage *tempMessage = [ChatSendHelper sendVoice:voice
                                                    toUsername:target
                                                   messageType:messageType
                                             requireEncryption:NO ext:nil];
            NSMutableDictionary *resultMessage = [self formatMessage:tempMessage];
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: resultMessage];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"录音时间太短"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            });
        }
    }];
}

/**
* 取消录音
*/
- (void) recordcancel: (CDVInvokedUrlCommand *)command
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

/**
* 收到在线消息
*/
- (void)didReceiveMessage:(EMMessage *)message
{
    NSLog (@"%@", message);
    if (self.callbackId != nil)
    {
        NSMutableDictionary *resultMessage = [self formatMessage:message];
        NSError  *error;
        NSData   *jsonData   = [NSJSONSerialization dataWithJSONObject:resultMessage options:0 error:&error];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.commandDelegate evalJs:[NSString stringWithFormat:@"window.easemob.onReciveMessage(%@)",jsonString]];
    }
}

- (void)didReceiveCmdMessage:(EMMessage *)cmdMessage
{
    NSLog (@"%@", cmdMessage);
    if (self.callbackId != nil)
    {
        NSMutableDictionary *resultMessage = [self formatMessage:cmdMessage];
        NSError  *error;
        NSData   *jsonData   = [NSJSONSerialization dataWithJSONObject:resultMessage options:0 error:&error];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.commandDelegate evalJs:[NSString stringWithFormat:@"window.easemob.onReciveMessage(%@)",jsonString]];
    }
}
- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    NSLog (@"%@", offlineMessages);
    if (self.callbackId != nil)
    {
        NSMutableArray *resultMessages = [self formatMessages:offlineMessages];
        NSError  *error;
        NSData   *jsonData   = [NSJSONSerialization dataWithJSONObject:resultMessages options:0 error:&error];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.commandDelegate evalJs:[NSString stringWithFormat:@"window.easemob.onReciveOfflineMessages(%@)",jsonString]];
    }
}

/**
* 获取会话列表
*/
- (void) getGroups: (CDVInvokedUrlCommand *)command
{
    NSMutableArray *chatListResult = [self formatChatList];
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:chatListResult];
    [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
}

/**
* 获取某会话的聊天记录
*/
- (void) getMessages: (CDVInvokedUrlCommand *)command
{
    NSString *chatType = command.arguments[0];
    EMMessageType messageType = [self convertToMessageType:chatType];
    NSString *chatter = command.arguments[1];
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:messageType];
    NSString *messageId = command.arguments.count ==3 ? command.arguments[2] : nil;
    NSArray *messages = [conversation loadNumbersOfMessages:20 withMessageId:messageId];
    NSMutableArray *retMessages = [self formatMessages:messages];
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:retMessages];
    [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
}

/**
* 清零未读数
*/
- (void) resetUnreadMsgCount: (CDVInvokedUrlCommand *)command
{
    NSString *chatType = command.arguments[0];
    EMMessageType messageType = [self convertToMessageType:chatType];
    NSString *chatter = command.arguments[1];
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:messageType];
    [conversation markAllMessagesAsRead: 1];
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
}

/**
* 清零会话聊天记录
*/
- (void) clearConversation: (CDVInvokedUrlCommand *)command
{
    NSString *chatType = command.arguments[0];
    EMMessageType messageType = [self convertToMessageType:chatType];
    NSString *chatter = command.arguments[1];
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:messageType];
    [conversation removeAllMessages];
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
}

/**
* 删除会话某条聊天记录
*/
- (void) deleteConversation: (CDVInvokedUrlCommand *)command
{
    NSString *chatType = command.arguments[0];
    EMMessageType messageType = [self convertToMessageType:chatType];
    NSString *chatter = command.arguments[1];
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:messageType];
    NSString *msgId = command.arguments[2];
    [conversation removeMessageWithId: msgId];
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:commandResult callbackId:command.callbackId];
}

/**
* 字符串转换为EMMessageType
*/
- (EMMessageType) convertToMessageType: (NSString *)chatType
{
    EMMessageType messageType;
    if([chatType isEqualToString:@"single"])
    {
        messageType = eMessageTypeChat;
    }
    else
    {
        messageType = eMessageTypeGroupChat;
    }
    return messageType;
}

/**
* 格式化列表
*/
- (NSMutableArray *)formatChatList
{
    NSArray *chatList = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    NSMutableArray *ret = [NSMutableArray array];
    for(int i=0; i<chatList.count; i++){
        NSMutableDictionary *retGroup = [NSMutableDictionary dictionaryWithCapacity:10];
        EMConversation *temp = chatList[i];
        //todo 格式待定
        //会话对方的用户名. 如果是群聊, 则是群组的id
        retGroup[@"chatter"] = temp.chatter;
        //是否是群聊
        NSNumber *isGroup = @(temp.isGroup);
        retGroup[@"isGroup"] = isGroup;
        //最新消息
        if(temp.latestMessage) {
            retGroup[@"latestMessageFromOthers"] = [self formatMessage:temp.latestMessage];
        }
        //未读数
        NSNumber *unreadMessagesCount = @(temp.unreadMessagesCount);
        retGroup[@"unreadMessagesCount"] = unreadMessagesCount;
        [ret addObject:retGroup];
    }
    return ret;
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

/**
* 格式化每条信息
*/
- (NSMutableArray *)formatMessages: (NSArray*)originMessages
{
    NSMutableArray * resultMessages = [NSMutableArray array];
    for(int i=0; i<originMessages.count; i++) {
        [resultMessages addObject:[self formatMessage:originMessages[i]]];
    }
    return resultMessages;
}

/**
* 格式化一条信息
*/
- (NSMutableDictionary *)formatMessage:(EMMessage *)tempMessage
{
    NSMutableDictionary *resultMessage = [NSMutableDictionary dictionaryWithCapacity:10];

    id type ;
    //todo:换实现
    switch (tempMessage.messageType) {
        case eMessageTypeChat:{
            type = @"Chat";
        };
        break;
        case eMessageTypeGroupChat:{
            type = @"GroupChat";
        };
        break;
        default: {
            type = @"?";
        }
    }
    //基本属性
    resultMessage[@"chatType"] = type;
    resultMessage[@"to"] = tempMessage.to;
    resultMessage[@"from"] = tempMessage.from;
    resultMessage[@"msgId"] = tempMessage.messageId;
    NSNumber *timestamp = @(tempMessage.timestamp);
    resultMessage[@"msgTime"] = timestamp;
    NSNumber *unRead = @(!tempMessage.isRead);
    resultMessage[@"unRead"] = unRead;
    //isListened 未找到
    //todo 换实现
    id status ;
    switch (tempMessage.deliveryState) {
        case eMessageDeliveryState_Pending:{
            status = @"CREATE";
        };
        break;
        case eMessageDeliveryState_Delivering:{
            status = @"INPROGRESS";
        };
        break;
        case eMessageDeliveryState_Delivered:{
            status = @"SUCCESS";
        };
        break;
        case eMessageDeliveryState_Failure:{
            status = @"FAIL";
        };
        break;
    }
    resultMessage[@"status"] = status;
    NSNumber *isAcked = @(!tempMessage.isReadAcked);
    resultMessage[@"isAcked"] = isAcked;
    //progress 无
    tempMessage.ext ? resultMessage[@"ext"] = tempMessage.ext : nil;

    //body
    id<IEMMessageBody> msgBody = tempMessage.messageBodies.firstObject;
    NSMutableDictionary *messageBody = [NSMutableDictionary dictionaryWithCapacity:10];;
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:{
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            messageBody[@"text"] = txt;
        };
        break;
        case eMessageBodyType_Image:{
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            //大图remote路径
            //[messageBody setObject:body.remotePath forKey:@"remoteUrl"];
            //NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
            messageBody[@"localUrl"] = body.localPath;
            //大图的secret
            //[messageBody setObject:body.secretKey forKey:@"secretKey"];
            //大图的H
            NSNumber *height = @(body.size.height);
            messageBody[@"height"] = height;
            //大图的W
            NSNumber *width = @(body.size.width);
            messageBody[@"width"] = width;
            //大图的下载状态
            //[messageBody setObject:body.attachmentDownloadStatus forKey:@"attachmentDownloadStatus"];
            // 缩略图sdk会自动下载
            //小图local路径
            messageBody[@"thumbnailUrl"] = body.thumbnailLocalPath ? body.thumbnailLocalPath: @"";
            //NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);

            //小图的H
            NSNumber *thumbnailHeight = @(body.thumbnailSize.height);
            messageBody[@"height"] = thumbnailHeight;
            //小图的W
            NSNumber *thumbnailWidth = @(body.thumbnailSize.width);
            messageBody[@"width"] = thumbnailWidth;
            //NSLog(@"小图的下载状态 -- %lu",body.thumbnailDownloadStatus);
        };
        break;
        case eMessageBodyType_Location:{
            //todo
        };
        break;
        case eMessageBodyType_Voice:{
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            //NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
            //音频local路径 //需要使用sdk提供的下载方法后才会存在（音频会自动调用）
            messageBody[@"localUrl"] = body.localPath;
            //NSLog(@"音频的secret -- %@"        ,body.secretKey);
            NSNumber *duration = @(body.duration);
            messageBody[@"duration"] = duration;
            //NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
            //NSLog(@"音频文件的下载状态 -- %lu"   ,body.attachmentDownloadStatus);
            //NSLog(@"音频的时间长度 -- %lu"      ,body.duration);
        };
    }
    messageBody ? resultMessage[@"body"] = messageBody : nil;
    return resultMessage;
}

@end