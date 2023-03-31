//
//  WeChat+hook.h
//  WeChatTool
//
//  Created by 贝克彦祖 on 2023/3/24.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject(WeChatHook)

+ (void)hookWeChat;

@end
