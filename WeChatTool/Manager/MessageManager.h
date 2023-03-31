//
//  MessageManager.h
//  WeChatTool
//
//  Created by 贝克彦祖 on 2023/3/25.
//

#ifndef MessageManager_h
#define MessageManager_h
#import "WeChatHeader.h"

@interface MessageManager : NSObject

+ (instancetype)shareManager;

- (void)sendTextMessageToSelf:(id)msgContent;
- (void)sendTextMessage:(id)msgContent toUsrName:(id)toUser delay:(NSInteger)delayTime;
- (void)clearUnRead:(id)arg1;
- (NSString *)getMessageContentWithData:(MessageData *)msgData;
- (NSArray *)getMsgListWithChatName:(id)arg1 minMesLocalId:(unsigned int)arg2 limitCnt:(NSInteger)arg3;
- (void)playVoiceWithMessageData:(MessageData *)msgData;

- (void)sendAppReferMessage:(MessageData *)msgData withText:(NSString *)arg2 fromUsrName:(NSString *)arg3 toUsrName:(NSString *)arg4 atUserList:(NSString *)arg5;

- (void)SendImgMessage:(id)arg1 toUsrName:(NSString *)arg2 thumbImgData:(NSData*)arg3 imgData:(NSData*)arg4 imgInfo:(SendImageInfo *)arg5;

@end

#endif /* MessageManager_h */
