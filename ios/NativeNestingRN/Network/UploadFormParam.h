//
//  UploadParam.h
//  ios-base-pj
//
//  Created by easonyi on 14/5/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UploadFormParam : NSObject

/**
 *  图片的二进制数据
 */
@property (nonatomic, strong) NSData *data;
/**
 *  服务器对应的参数名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  文件的名称(上传到服务器后，服务器保存的文件名)
 */
@property (nonatomic, copy) NSString *filename;
/**
 *  文件的MIME类型(image/png,image/jpg等)
 */
@property (nonatomic, copy) NSString *mimeType;

@end

NS_ASSUME_NONNULL_END
