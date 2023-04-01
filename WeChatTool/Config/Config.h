//
//  Network+Config.h
//  WeChatTool
//
//  Created by 贝克彦祖 on 2023/3/25.
//

#ifndef Network_Config_h
#define Network_Config_h

#define WXLocalizedString(key)  [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

#define TIMEOUT 60.f //请求超时时间
#define ChatGPT_Api_key @""




static NSDictionary  *headers;

static NSString *const chatUrlPath = @"https://api.openai.com/v1/chat/completions";
static NSString *const imagesUrlPath = @"https://api.openai.com/v1/images/generations";


static NSArray * pictureCodeWords = @[@"图片",@"IMG",@"image",@"pic"];
static NSArray * codeWords = @[@"那个谁",@"彦祖"];
#endif /* Network_Config_h */
