//
//  HttpRequest.m
//  ios-base-pj
//
//  Created by easonyi on 14/5/2021.
//

#import "HttpRequest.h"
#import <AFHTTPSessionManager.h>

@implementation HttpRequest

static id _instance = nil;
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.operationQueue.maxConcurrentOperationCount = 5;
        manager.requestSerializer.timeoutInterval = 30;
    });
    return _instance;
}

- (NSDictionary *)setupHeader {
    return @{
        @"token": @""
    };
}

#pragma mark -- GET请求 --
- (void)getWithURLString:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URLString parameters:parameters headers:[self setupHeader] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -- POST请求 --
- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URLString parameters:parameters headers:[self setupHeader] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


#pragma mark - 下载数据
- (void)downLoadWithURLString:(NSString *)URLString parameters:(id)parameters progerss:(void (^)(NSProgress * downloadProgress))progress success:(void (^)(NSURLResponse *response, NSURL * filePath))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSLog(@"targetPath:%@",targetPath);
        NSString *path =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSLog(@"path:%@",filePath);
        
        return url;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            failure(error);
        }else {
            NSLog(@"filePath:%@",filePath);
            success(response, filePath);
        }
    }];
    [downLoadTask resume];
}


#pragma mark - 上传
- (void)uploadWithURLString:(NSString *)URLString parameters:(id)parameters uploadParams:(NSArray<UploadFormParam *> *)uploadParams progerss:(void (^)(NSProgress * downloadProgress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:URLString parameters:parameters headers:[self setupHeader] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        // 表单设置文件参数
        for (UploadFormParam *uploadFormParam in uploadParams) {
            [formData appendPartWithFileData:uploadFormParam.data name:uploadFormParam.name fileName:uploadFormParam.filename mimeType:uploadFormParam.mimeType];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end
