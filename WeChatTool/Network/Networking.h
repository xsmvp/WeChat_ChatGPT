//
//  Network.h
//  WeChatTool
//
//  Created by 贝克彦祖 on 2023/3/25.
//

#ifndef Network_h
#define Network_h

#import <Foundation/Foundation.h>

/**
 *  成功回调
 *
 *  @param response 成功后返回的数据
 */
typedef void(^ResponseSuccessBlock)(id response);

/**
 *  失败回调
 *
 *  @param error 失败后返回的错误信息
 */
typedef void(^ResponseFailBlock)(NSError *error);


@interface Networking : NSObject

+ (instancetype)shaerd;

/**
 聊天请求
 */
-(void)chat:(NSString *)message
   userName:(NSString *)userName
        succesBlock:(ResponseSuccessBlock)successBlock
        failedBlock:(ResponseFailBlock)failedBlock;
- (void)images:(NSString*)message
      userName:(NSString *)userName
   succesBlock:(ResponseSuccessBlock)successBlock
   failedBlock:(ResponseFailBlock)failedBlock;

@end

#endif /* Network_h */
