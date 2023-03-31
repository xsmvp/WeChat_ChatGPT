//
//  ChatGptTextModel.h
//  WeChatTool
//
//  Created by 贝克彦祖 on 2023/3/25.
//

#ifndef ChatGPTTextModel_h
#define ChatGPTTextModel_h

@class ChatGPTTextModel;
@class QTChoice;
@class QTMessage;
@class QTUsage;

NS_ASSUME_NONNULL_BEGIN

@interface ChatGPTTextModel : NSObject

@property (nonatomic, nullable, copy)   NSString *identifier;
@property (nonatomic, nullable, copy)   NSString *object;
@property (nonatomic, nullable, strong) NSNumber *created;
@property (nonatomic, nullable, copy)   NSString *model;
@property (nonatomic, nullable, strong) QTUsage *usage;
@property (nonatomic, nullable, copy)   NSArray<QTChoice *> *choices;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

@interface QTChoice : NSObject
@property (nonatomic, nullable, strong) QTMessage *message;
@property (nonatomic, nullable, copy)   NSString *finishReason;
@property (nonatomic, nullable, strong) NSNumber *index;
@end

@interface QTMessage : NSObject
@property (nonatomic, nullable, copy) NSString *role;
@property (nonatomic, nullable, copy) NSString *content;
@end

@interface QTUsage : NSObject
@property (nonatomic, nullable, strong) NSNumber *promptTokens;
@property (nonatomic, nullable, strong) NSNumber *completionTokens;
@property (nonatomic, nullable, strong) NSNumber *totalTokens;
@end

NS_ASSUME_NONNULL_END

#endif /* ChatGPTTextModel_h */
