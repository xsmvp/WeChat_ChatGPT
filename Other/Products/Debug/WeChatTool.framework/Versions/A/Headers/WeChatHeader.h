//
//  WeChatTool.h
//  WeChatTool
//
//  Created by 贝克彦祖 on 2023/3/24.
//

#import <Cocoa/Cocoa.h>

//! Project version number for WeChatTool.
FOUNDATION_EXPORT double WeChatToolVersionNumber;

//! Project version string for WeChatTool.
FOUNDATION_EXPORT const unsigned char WeChatToolVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <WeChatTool/PublicHeader.h>

@interface WCPayInfoItem : NSObject
@property(retain, nonatomic) NSString *m_nsFeeDesc;
@end

@interface MessageData : NSObject
- (id)initWithMsgType:(long long)arg1;
@property(retain, nonatomic) NSString *fromUsrName;
@property(retain, nonatomic) NSString *toUsrName;
@property(retain, nonatomic) NSString *msgContent;
@property(retain, nonatomic) NSString *msgPushContent;
@property(retain, nonatomic) NSString *realChatUserName;
@property(retain, nonatomic) WCPayInfoItem *m_oWCPayInfoItem; // @dynamic m_oWCPayInfoItem;
@property(retain, nonatomic) NSString *m_nsAppName;
@property(retain, nonatomic) NSString *m_nsSourceDisplayname;
@property(retain, nonatomic) NSString *m_nsAtUserList;
@property(nonatomic) int messageType;
@property(nonatomic) int msgStatus;
@property(nonatomic) int msgCreateTime;
@property(nonatomic) int mesLocalID;
@property(nonatomic) long long mesSvrID;
@property(retain, nonatomic) NSString *msgVoiceText;
@property(copy, nonatomic) NSString *m_nsEmoticonMD5;
- (BOOL)isChatRoomMessage;
- (NSString *)groupChatSenderDisplayName;
- (id)getRealMessageContent;
- (id)getChatRoomUsrName;
- (BOOL)isSendFromSelf;
- (BOOL)isCustomEmojiMsg;
- (BOOL)isImgMsg;
- (BOOL)isVideoMsg;
- (BOOL)isVoiceMsg;
- (BOOL)canForward;
- (BOOL)IsPlayingSound;
- (id)summaryString:(BOOL)arg1;
- (BOOL)isEmojiAppMsg;
- (BOOL)isAppBrandMsg;
- (BOOL)IsUnPlayed;
- (void)SetPlayed;
@property(retain, nonatomic) NSString *m_nsTitle;
- (id)originalImageFilePath;
@property(retain, nonatomic) NSString *m_nsVideoPath;
@property(retain, nonatomic) NSString *m_nsFilePath;
@property(retain, nonatomic) NSString *m_nsAppMediaUrl;
@property(nonatomic) MessageData *m_refMessageData;
@property(nonatomic) unsigned int m_uiDownloadStatus;
- (void)SetPlayingSoundStatus:(BOOL)arg1;
@end


@interface SendImageInfo : NSObject

@property(strong, nonatomic) NSURL *m_nuImageSourceURL; // @synthesize m_nuImageSourceURL=_m_nuImageSourceURL;
@property(assign, nonatomic) unsigned int m_uiOriginalHeight; // @synthesize m_uiOriginalHeight=_m_uiOriginalHeight;
@property(assign, nonatomic) unsigned int m_uiOriginalWidth; // @synthesize m_uiOriginalWidth=_m_uiOriginalWidth;
@property(assign, nonatomic) unsigned int m_uiThumbHeight; // @synthesize m_uiThumbHeight=_m_uiThumbHeight;
@property(assign, nonatomic) unsigned int m_uiThumbWidth; // @synthesize m_uiThumbWidth=_m_uiThumbWidth;
@property(assign, nonatomic) unsigned int m_uiImageSource; // @synthesize m_uiImageSource=_m_uiImageSource;

@end


@interface MMLoginOneClickViewController : NSViewController
- (void)onLoginButtonClicked:(id)arg1;
- (void)FFImgToOnFavInfoInfoVCZZ:(id)arg1 isFirstSync:(BOOL)arg2;
- (void)handleAppMsg:(id)arg1;
@end

@interface FFProcessReqsvrZZ: NSObject;

- (void)OnSyncBatchAddMsgs:(NSArray *)arg1 isFirstSync:(BOOL)arg2;
- (id)FFProcessTReqZZ:(id)arg1 toUsrName:(id)arg2 msgText:(id)arg3 atUserList:(id)arg4;
- (BOOL)ClearUnRead:(id)arg1 FromID:(unsigned int)arg2 ToID:(unsigned int)arg3;
- (BOOL)ClearUnRead:(id)arg1 FromCreateTime:(unsigned int)arg2 ToCreateTime:(unsigned int)arg3;
- (id)GetMsgListWithChatName:(id)arg1 fromCreateTime:(unsigned int)arg2 localId:(NSInteger)arg3 limitCnt:(NSInteger)arg4 hasMore:(char *)arg5 sortAscend:(BOOL)arg6;
- (void)DelMsg:(id)arg1 msgList:(id)arg2 isDelAll:(BOOL)arg3 isManual:(BOOL)arg4;

- (void)notifyChatSyncMsgs:(id)arg1 msgList:(id)arg2;

- (BOOL)preFilterAddMsg:(id)arg1 chatName:(id)arg2;

- (id)sendAppReferMessage:(MessageData *)msgData withText:(NSString *)arg2 fromUsrName:(NSString *)arg3 toUsrName:(NSString *)arg4 atUserList:(NSString *)arg5;

- (void)notifyNewMsgNotificationOnMainThread:(id)arg1 msgData:(id)arg2;
- (void)notifyAddMsgOnMainThread:(id)arg1 msgData:(id)arg2;

- (id)SendImgMessage:(id)arg1 toUsrName:(id)arg2 thumbImgData:(id)arg3 imgData:(id)arg4 imgInfo:(id)arg5;

@end

@interface SKBuiltinString_t : NSObject
@property(retain, nonatomic, setter=SetString:) NSString *string; // @synthesize string;
@property(retain, nonatomic, setter=SetBuffer:) NSData *buffer; // @synthesize buffer;
@property(readonly, nonatomic) BOOL hasBuffer; // @synthesize hasBuffer;
@property(nonatomic, setter=SetILen:) unsigned int iLen; // @synthesize iLen;
@property(readonly, nonatomic) BOOL hasILen; // @synthesize hasILen;
@end

@interface AddMsg : NSObject
@property(retain, nonatomic, setter=SetContent:) SKBuiltinString_t *content; // @synthesize content;
@property(retain, nonatomic, setter=SetFromUserName:) SKBuiltinString_t *fromUserName; // @synthesize fromUserName;
@property(nonatomic, setter=SetMsgType:) int msgType; // @synthesize msgType;
@property(retain, nonatomic, setter=SetToUserName:) SKBuiltinString_t *toUserName; // @synthesize toUserName;
@property (nonatomic, assign) unsigned int createTime;
@property(nonatomic, setter=SetNewMsgId:) long long newMsgId;
@property(retain, nonatomic, setter=SetPushContent:) NSString *pushContent; // @synthesize pushContent;
@property(retain, nonatomic, setter=SetMsgSource:) NSString *msgSource;

@end

@interface CUtility : NSObject
+ (BOOL)HasWechatInstance;
+ (BOOL)FFSvrChatInfoMsgWithImgZZ;
+ (unsigned long long)getFreeDiskSpace;
+ (void)ReloadSessionForMsgSync;
+ (id)GetCurrentUserName;
+ (id)GetContactByUsrName:(id)arg1;
+ (BOOL)IsStickyChatsFolder:(id)arg1;
@end

@interface MMServiceCenter : NSObject
+ (id)defaultCenter;
- (id)getService:(Class)arg1;
@end


@interface MultiPlatformStatusSyncMgr : NSObject
- (void)markVoiceMessageAsRead:(id)arg1;
@end

@interface MMVoiceMessagePlayer : NSObject
+ (id)defaultPlayer;
- (void)playWithVoiceMessage:(id)arg1 isUnplayedBeforePlay:(BOOL)arg2;
- (void)playVoiceWithMessage:(id)arg1 isUnplayedBeforePlay:(BOOL)arg2;
- (void)stop;
@end

@interface GroupStorage : NSObject
{
    NSMutableDictionary *m_dictGroupContacts;
}
- (id)GetAllGroups;
- (id)GetGroupMemberContact:(id)arg1;
- (void)notifyModifyGroupContactsOnMainThread:(id)arg1;
//- (id)GetGroupMemberListWithGroupContact:(id)arg1;
- (id)GetGroupMemberListWithGroupContact:(id)arg1 limit:(unsigned int)arg2 filterSelf:(BOOL)arg3;
@end

@interface ChatRoomData : NSObject
{
    NSMutableDictionary *m_dicData;
}

@property(nonatomic) unsigned int chatRoomType; // @synthesize chatRoomType=_chatRoomType;
@property(nonatomic) BOOL isSimplify; // @synthesize isSimplify;
@property(nonatomic) unsigned int chatRoomVersion; // @synthesize chatRoomVersion=m_chatRoomVersion;
@property(nonatomic) unsigned int maxMemberCount; // @synthesize maxMemberCount=m_maxMemberCount;
- (id)getDislayNameForUserName:(id)arg1;
@end

@interface WCContactData : NSObject
@property(retain, nonatomic) NSString *m_nsUsrName; // @synthesize m_nsUsrName;
@property(nonatomic) unsigned int m_uiFriendScene;  // @synthesize m_uiFriendScene;
@property(retain, nonatomic) NSString *m_nsNickName;    // 用户昵称
@property(retain, nonatomic) NSString *m_nsRemark;      // 备注
@property(retain, nonatomic) NSString *m_nsHeadImgUrl;  // 头像
@property(retain, nonatomic) NSString *m_nsHeadHDImgUrl;
@property(retain, nonatomic) NSString *m_nsHeadHDMd5;
@property(retain, nonatomic) NSString *m_nsAliasName;
@property(retain, nonatomic) NSString *avatarCacheKey;
@property(readonly, nonatomic) unsigned long long groupMemberCount;
@property(retain, nonatomic) ChatRoomData *m_chatRoomData;
@property(nonatomic) BOOL m_isShowRedDot;
- (BOOL)isBrandContact;
- (BOOL)isSelf;
- (id)innerGetGroupDisplayName;
- (NSString *)groupChatDisplayNameInGroup:(id)arg1;
- (NSString *)getGroupChatNickNameInGroup:(id)arg1;
- (id)getContactDisplayUsrName;
- (BOOL)isGroupChat;
- (BOOL)isMMChat;
- (BOOL)isMMContact;
- (BOOL)containsMember:(id)arg1;
- (id)displayRegion;
- (BOOL)isStickyFolder;
@end
