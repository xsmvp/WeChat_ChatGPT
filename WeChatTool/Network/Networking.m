//
//  Network.m
//  WeChatTool
//
//  Created by 贝克彦祖 on 2023/3/25.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Networking.h"
#import "Config.h"
#import "ChatGptTextModel.h"
#import "ChatGPTImageModel.h"

@interface Networking()
@property (assign, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation Networking

enum ApiType {
    Chat,
    Image
};
typedef enum ApiType ApiType;

+ (instancetype)shaerd{
    static Networking *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - manager
- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //默认解析模式
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.requestSerializer.timeoutInterval = TIMEOUT;
        
        //配置响应序列化
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"application/octet-stream", @"application/zip"]];
        _manager = manager;
    }
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            [_manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    //每次网络请求的时候，检查此时磁盘中的缓存大小，阈值默认是40MB，如果超过阈值，则清理LRU缓存,同时也会清理过期缓存，缓存默认SSL是7天，磁盘缓存的大小和SSL的设置可以通过该方法[ZBCacheManager shareManager] setCacheTime: diskCapacity:]设置
//    [[ZBCacheManager shareManager] clearLRUCache];
    return _manager;
}

#pragma mark - 网络回调统一处理
//网络回调统一处理
- (id)networkResponseManage:(id)responseObject apiType:(ApiType)apiType {
    NSData *data = nil;
    NSError *error = nil;
    if ([responseObject isKindOfClass:[NSData class]]) {
        data = responseObject;
    } else if ([responseObject isKindOfClass:[NSDictionary class]]){
        data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
    }
    NSLog(@"%@",data);
    
    if (apiType == Chat) {
        ChatGPTTextModel *textModel = [ChatGPTTextModel fromData:data error:&error];
        if (textModel != nil) {
            return textModel;
        }
    } else if (apiType == Image) {
        QTChatGPTImageModel *imageModel = [QTChatGPTImageModel fromData:data error:&error];
        if (imageModel != nil) {
            return imageModel;
        }
    }

    return nil;
}

-(void)networkResponseError:(NSError*)error {
    
    NSHTTPURLResponse * errResponse = error.userInfo[@"com.alamofire.serialization.response.error.response"];

    NSLog(@"❌❌❌errResponse: %@❌❌❌", errResponse.allHeaderFields);
    NSLog(@"%@", error.localizedDescription);
}


-(void)chat:(NSString *)message
   userName:(NSString *)userName
        succesBlock:(ResponseSuccessBlock)successBlock
        failedBlock:(ResponseFailBlock)failedBlock {
    NSString * api_key = [NSString stringWithFormat:@"Bearer %@", ChatGPT_Api_key];
    NSDictionary * header = @{ @"Content-Type": @"application/json", @"Authorization": api_key };
    headers = header;
    AFHTTPSessionManager * manager = [self manager];
    NSDictionary *parameters = @{@"model": @"gpt-3.5-turbo",
                                 @"user": userName,
                                 @"messages": @[@{@"role": @"user",
                                                  @"content": message}]};

    [manager POST:chatUrlPath parameters:parameters headers:header progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id responseModel = [self networkResponseManage:responseObject apiType:Chat];
            if (successBlock) successBlock(responseModel);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self networkResponseError:error];
            if (failedBlock) failedBlock(error);
        }];
 
}

- (void)images:(NSString*)message
      userName:(NSString *)userName
   succesBlock:(ResponseSuccessBlock)successBlock
   failedBlock:(ResponseFailBlock)failedBlock {
    
    NSString * api_key = [NSString stringWithFormat:@"Bearer %@", ChatGPT_Api_key];
    NSDictionary * header = @{ @"Content-Type": @"application/json", @"Authorization": api_key };
    headers = header;
    AFHTTPSessionManager * manager = [self manager];
    NSDictionary *parameters = @{@"prompt": message,
                                 @"n": @(1),
                                 @"user": userName,
                                 @"size": @"1024x1024",
                                 @"response_format": @"b64_json"
                                };
    [manager POST:imagesUrlPath parameters:parameters headers:header progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id responseModel = [self networkResponseManage:responseObject apiType:Image];
            if (successBlock) successBlock(responseModel);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self networkResponseError:error];
            if (failedBlock) failedBlock(error);
        }];
 
}

@end
