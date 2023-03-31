//
//  main.m
//  WeChatTool
//
//  Created by 贝克彦祖 on 2023/3/25.
//

#import <Foundation/Foundation.h>
#import "Wechat+hook.h"

static void __attribute__((constructor)) initialize(void) {
    NSLog(@"----------开始加载----------");
    //    CBHookClassMethod();
    [NSObject hookWeChat];
}
