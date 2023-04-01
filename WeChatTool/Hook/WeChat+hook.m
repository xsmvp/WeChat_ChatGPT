//
//  WeChat+hook.m
//  WeChatTool
//
//  Created by 贝克彦祖 on 2023/3/24.
//

#import <Foundation/Foundation.h>
#import "AppKit/AppKit.h"
#import "TKHelper.h"
#import "ChatGptTextModel.h"
#import "MessageManager.h"
#import "ChatGPTImageModel.h"

@implementation NSObject (WeChatHook)

+ (void)hookWeChat {
    
    // 微信消息同步
    SEL syncBatchAddMsgsMethod = @selector(FFImgToOnFavInfoInfoVCZZ:isFirstSync:);
    tk_hookMethod(objc_getClass("FFProcessReqsvrZZ"), syncBatchAddMsgsMethod, [self class], @selector(hook_OnSyncBatchAddMsgs:isFirstSync:));
    
    tk_hookMethod(objc_getClass("FFProcessReqsvrZZ"), @selector(notifyNewMsgNotificationOnMainThread:msgData:), [self class], @selector(hook_notifyNewMsgNotificationOnMainThread:msgData:));
    
    tk_hookMethod(objc_getClass("FFProcessReqsvrZZ"), @selector(notifyAddMsgOnMainThread:msgData:), [self class], @selector(hook_notifyAddMsgOnMainThread:msgData:));
    
    tk_hookMethod(objc_getClass("MMLoginOneClickViewController"), @selector(onLoginButtonClicked:), [self class], @selector(hook_onLoginButtonClicked:));
    
    tk_hookMethod(objc_getClass("WeChat"), @selector(applicationDidFinishLaunching:), [self class], @selector(hook_applicationDidFinishLaunching:));
    
    tk_hookMethod(objc_getClass("FFProcessReqsvrZZ"), @selector(handleAppMsg:), [self class], @selector(hook_handleAppMsg:));
}

/**
 hook 微信消息同步
 */
- (void)hook_OnSyncBatchAddMsgs:(NSArray *)msgs isFirstSync:(BOOL)arg2 {
    [self hook_OnSyncBatchAddMsgs:msgs isFirstSync:arg2];
}

- (void)hook_notifyNewMsgNotificationOnMainThread:(id)arg1 msgData:(MessageData *)msgData {
    [self hook_notifyNewMsgNotificationOnMainThread:arg1 msgData:msgData];
    
    NSString * msgContent = msgData.msgContent;
    NSString *currentUserName = [self getCurrentUserName];
    NSLog(@"Message Content: %@", msgContent);

    // 是否艾特了自己
    if ([self isWasAtWithAtUserList:msgData.m_nsAtUserList curUserName:currentUserName]) {
        [self chatGptRequestHandle:msgContent msgData:msgData];
    }
        
}

- (void)hook_notifyAddMsgOnMainThread:(id)arg1 msgData:(MessageData*)msgData {
    [self hook_notifyAddMsgOnMainThread:arg1 msgData:msgData];
    
    NSString * msgContent = msgData.msgContent;
    // 自己发送并带有暗语
    if ([self isSelfSendAndExistCodeWord:msgData] ) {
        [self chatGptRequestHandle:msgContent msgData:msgData];
    }

}

- (void)hook_onLoginButtonClicked:(NSButton *)btn {
    NSLog(@"点击了登录按钮");
    [self hook_onLoginButtonClicked:btn];
    
}

- (void)hook_applicationDidFinishLaunching:(id)arg1 {
    
    [self hook_applicationDidFinishLaunching:arg1];
    
    NSLog(@"注入成功");
}

- (void)hook_handleAppMsg:(id)arg1 {
    [self hook_handleAppMsg:arg1];
    
    NSLog(@"hook_handleAppMsg");
}

- (void)chatGptRequestHandle:(NSString *)msgContent msgData:(MessageData*)msgData {
    // 是否中了图片暗语
    if ([self isExistImageCodeWord:msgData]) {
        [self chatGptImageRequest:msgContent msgData:msgData];
    } else {
        [self chatGptTextRequest:msgContent msgData:msgData];
    }
}

- (NSString*)messageFormatHandle:(NSString *)msgContent msgData:(MessageData*)msgData {
    GroupStorage *contactStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("GroupStorage")];
    WCContactData *fromContact = [contactStorage GetGroupMemberContact:[msgData toUsrName]];
    NSString * inGroupNickName = [fromContact getGroupChatNickNameInGroup:[msgData fromUsrName]];
    //        NSLog(inGroupNickName);
    NSString * formatMessage = msgContent;
    NSRange range = [formatMessage rangeOfString:@"\n"];
    if (range.location != NSNotFound) {
        formatMessage = [formatMessage substringFromIndex:range.location + range.length];
    }
    if (inGroupNickName.length > 0) {
        formatMessage = [formatMessage stringByReplacingOccurrencesOfString:inGroupNickName withString:@""];
    }
    
    if ( [self isSelfSendAndExistCodeWord:msgData] ) {
        __block NSString * blockMsg = formatMessage;
        [codeWords enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([blockMsg containsString:obj]) {
                blockMsg = [blockMsg stringByReplacingOccurrencesOfString:obj withString:@""];
            }
        }];
        formatMessage = blockMsg;
    }
    
    if ([self isExistImageCodeWord:msgData]) {
        __block NSString * blockMsg = formatMessage;
        [pictureCodeWords enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([blockMsg containsString:obj]) {
                blockMsg = [blockMsg stringByReplacingOccurrencesOfString:obj withString:@""];
            }
        }];
        formatMessage = blockMsg;
    }
    
    
    return formatMessage;
}

- (void)chatGptTextRequest:(NSString *)message msgData:(MessageData*)msgData {
    
    NSString * msgContent = [self messageFormatHandle:message msgData:msgData];
    
    [Networking.shaerd chat:msgContent userName:msgData.fromUsrName succesBlock:^(id response) {
        [self handleGPTResponseWithMsgData:response msgData:msgData];
    } failedBlock:^(NSError *error) {
        [self handleGPTResonseError:error msgData:msgData];
    }];
}

- (void)chatGptImageRequest:(NSString *)message msgData:(MessageData*)msgData {
    
    NSString * msgContent = [self messageFormatHandle:message msgData:msgData];
    
    [Networking.shaerd images:msgContent userName:msgData.fromUsrName succesBlock:^(id response) {
        [self handleGPTResponseWithImageData:response msgData:msgData];
    } failedBlock:^(NSError *error) {
        [self handleGPTResonseError:error msgData:msgData];
    }];
}

- (void)handleGPTResponse:(id)response addMsg:(AddMsg*)addMsg {
    
    if ([response isKindOfClass:[ChatGPTTextModel class]]) {
        // 文字内容
        ChatGPTTextModel *textModel = response;
        NSString * message = textModel.choices.firstObject.message.content;
        NSString * messageFormat = [NSString stringWithFormat:@"\n以下👇🏻👇🏻👇🏻回答由ChatGPT AI生成:\n\n %@ \n\nby: xs", message];
        NSLog(@"GPT的消息是：\n%@",messageFormat);
        
        NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
        if ([addMsg.fromUserName.string isEqualToString:currentUserName] &&
            [addMsg.toUserName.string isEqualToString:currentUserName]) {
            [self replySelfWithMsg:messageFormat addMsg:addMsg];
        } else {
            [self replyWithMsg:messageFormat addMsg:addMsg];
        }
    }
    
}

- (void)handleGPTResponseWithMsgData:(id)response msgData:(MessageData*)msgData {
    
    if ([response isKindOfClass:[ChatGPTTextModel class]]) {
        // 文字内容
        ChatGPTTextModel *textModel = response;
        NSString * message = textModel.choices.firstObject.message.content;
        NSString * messageFormat = [NSString stringWithFormat:@"\n以下👇🏻👇🏻👇🏻回答由ChatGPT AI生成:\n\n %@ \n\nby: xs", message];
        NSLog(@"GPT的消息是：\n%@",messageFormat);
        [self replyMessage:messageFormat msgData:msgData];
    }
}

- (void)handleGPTResponseWithImageData:(id)response msgData:(MessageData*)msgData {
    
    if ([response isKindOfClass:[QTChatGPTImageModel class]]) {
        QTChatGPTImageModel *imgModel = response;

        [self replyImage:imgModel.data.firstObject.b64JSON msgData:msgData];
    }
}

- (void)handleGPTResonseError:(NSError*)error msgData:(MessageData*)msgData {
    NSString * messageFormat = @"⚠️⚠️⚠️您的回答请求超时,请稍后再试⚠️⚠️⚠️";
    [self replyMessage:messageFormat msgData:msgData];
}


- (void)replyWithMsg:(NSString *)content addMsg:(AddMsg *)addMsg {
    if (addMsg.msgType == 1 || addMsg.msgType == 3) {
        [[MessageManager shareManager] sendTextMessage:content toUsrName:addMsg.fromUserName.string delay:0];
    }
}

- (void)replySelfWithMsg:(NSString *)content addMsg:(AddMsg *)addMsg {
    if (addMsg.msgType == 1 || addMsg.msgType == 3) {
        [[MessageManager shareManager] sendTextMessageToSelf:content];
    }

}

- (void)replyMessage:(NSString *)content msgData:(MessageData*)msgData {
    
    if (msgData.messageType != 1 && msgData.messageType != 3) {
        return;
    }
    
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    if ([msgData.fromUsrName isEqualToString:currentUserName] &&
        [msgData.toUsrName isEqualToString:currentUserName]) {
        [[MessageManager shareManager] sendTextMessageToSelf:content];
    } else {
        if ( [self isSelfSendAndExistCodeWord:msgData] ) {
            [[MessageManager shareManager] sendAppReferMessage:msgData withText:content fromUsrName:msgData.fromUsrName toUsrName:msgData.toUsrName atUserList:nil];
        } else {
            [[MessageManager shareManager] sendAppReferMessage:msgData withText:content fromUsrName:msgData.toUsrName toUsrName:msgData.fromUsrName atUserList:nil];
        }
    }

}

- (void)replyImage:(NSString *)imgBase64Str msgData:(MessageData*)msgData {

    if (imgBase64Str == nil || imgBase64Str.length < 0) {
        return;
    }
    if (msgData.messageType != 1 && msgData.messageType != 3) {
        return;
    }
    NSData * thumbImgData = [self toData:imgBase64Str];
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    SendImageInfo * imageInfo = [[SendImageInfo alloc]init];
    imageInfo.m_uiOriginalWidth = 1024;
    imageInfo.m_uiOriginalHeight = 1024;
    imageInfo.m_uiThumbWidth = 256;
    imageInfo.m_uiThumbHeight = 256;
    imageInfo.m_uiImageSource = 1;
    
    if ([msgData.fromUsrName isEqualToString:currentUserName] &&
        [msgData.toUsrName isEqualToString:currentUserName]) {
        
        [[MessageManager shareManager] SendImgMessage:currentUserName toUsrName:currentUserName thumbImgData:thumbImgData imgData:thumbImgData imgInfo:nil];
    } else {
        if ( [self isSelfSendAndExistImageCodeWord:msgData] ) {
            [[MessageManager shareManager] SendImgMessage:msgData.toUsrName toUsrName:msgData.toUsrName thumbImgData:thumbImgData imgData:thumbImgData imgInfo:nil];
        } else {
            [[MessageManager shareManager] SendImgMessage:msgData.fromUsrName toUsrName:msgData.fromUsrName thumbImgData:thumbImgData imgData:thumbImgData imgInfo:nil];
        }
        
    }
}

/// 是否被艾特
- (bool)isWasAt:(NSString *)msgSourceXML curUserName: (NSString *)curUserName {
    NSDictionary * msgSourceDic = [[XMLDictionaryParser sharedInstance] dictionaryWithString:msgSourceXML];
    
    // at list
    if ([msgSourceDic.allKeys containsObject: @"atuserlist"]) {
        NSString * atuserlistStr = msgSourceDic[@"atuserlist"];
        bool isAtCurUser = [[atuserlistStr componentsSeparatedByString:@","] containsObject:curUserName];
        return isAtCurUser;
    }
    return false;
}

/// 是否被艾特
- (bool)isWasAtWithAtUserList:(NSString *)atUserList curUserName: (NSString *)curUserName {
    // at list
    bool isAtCurUser = [[atUserList componentsSeparatedByString:@","] containsObject:curUserName];
    return isAtCurUser;
}

- (NSString *)getCurrentUserName {
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    return currentUserName;
}

// 是否自己发送且中了暗语
- (BOOL)isSelfSendAndExistCodeWord:(MessageData*)msgData {
    
    NSString * msgContent = msgData.msgContent;
    NSString * currentUserName = [self getCurrentUserName];
    __block bool isExistCodeWord = false;
    [codeWords enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [[msgContent lowercaseString] containsString:obj] ) {
            isExistCodeWord = true;
        }
    }];
    if ([msgData.fromUsrName isEqualToString:currentUserName] && isExistCodeWord ) {
         return true;
    }
    return false;
}

// 是否中了图片暗语
- (BOOL)isExistImageCodeWord:(MessageData*)msgData {
    
    NSString * msgContent = msgData.msgContent;
    __block bool isExistCodeWord = false;
    [pictureCodeWords enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [[msgContent lowercaseString] containsString:obj] ) {
            isExistCodeWord = true;
        }
    }];
    if (isExistCodeWord) {
         return true;
    }
    return false;
}

// 是否自己发送且中了暗语
- (BOOL)isSelfSendAndExistImageCodeWord:(MessageData*)msgData {
    
    NSString * msgContent = msgData.msgContent;
    NSString * currentUserName = [self getCurrentUserName];
    __block bool isExistCodeWord = false;
    [pictureCodeWords enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [[msgContent lowercaseString] containsString:obj] ) {
            isExistCodeWord = true;
        }
    }];
    if ([msgData.fromUsrName isEqualToString:currentUserName] && isExistCodeWord ) {
         return true;
    }
    return false;
}

-(NSImage *)toImage:(NSString *)str {
    /**
     将base64字符串转为图片

     */
    NSData * imageData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];

    NSImage *photo = [[NSImage alloc]initWithData:imageData];
    return photo;
}

-(NSData *)toData:(NSString*)str {
    NSData * imageData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return imageData;
}

@end
