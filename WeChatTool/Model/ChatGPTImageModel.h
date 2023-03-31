//
//  ChatGptImageModel.h
//  WeChatTool
//
//  Created by 贝克彦祖 on 2023/3/31.
//

#ifndef ChatGptImageModel_h
#define ChatGptImageModel_h

#import <Foundation/Foundation.h>

@class QTChatGPTImageModel;
@class QTDatum;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

@interface QTChatGPTImageModel : NSObject
@property (nonatomic, nullable, strong) NSNumber *created;
@property (nonatomic, nullable, copy)   NSArray<QTDatum *> *data;

+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;
@end

@interface QTDatum : NSObject
@property (nonatomic, nullable, copy) NSString *b64JSON;
@end

NS_ASSUME_NONNULL_END


#endif /* ChatGptImageModel_h */
