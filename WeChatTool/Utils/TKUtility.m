//
//  TKUtility.m
//  WeChatPlugin
//
//  Created by TK on 2019/1/12.
//  Copyright © 2019 tk. All rights reserved.
//

#import "TKUtility.h"

@implementation TKUtility

+ (BOOL)isLargerOrEqualVersion:(NSString *)version {
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    if ([dict[@"CFBundleShortVersionString"] compare:version options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    } else {
        return YES;
    }
}

+ (NSString *)getTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        default:
            return @"jpg";
    }
    return nil;
}

///yyyy-MM-dd
+ (NSDateFormatter *)getDateFormater {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
    });
    return formatter;
}

+ (NSString *)getOnlyDateString {
    return [[self getDateFormater] stringFromDate:[NSDate date]];
}

+ (NSArray *)getMemberSplitKeywords {
    return @[ @[@"\"", @"\"邀请\"", @"\"加入了群聊"],
              @[@"\" ", @"\"通过扫描\"", @"\"分享的二维码加入群聊"],
              @[@"\"", @"\"与群里其他人都不是微信朋友关系，请注意隐私安全"],
              @[@"你通过扫描二维码加入群聊，群聊参与人还有：", [NSNull null]],
              @[@"\"", @"\"邀请你和\"", @"\"加入了群聊"]
    ];
}
@end
