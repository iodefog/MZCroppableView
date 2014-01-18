//
//  QQApiHelper.m
//  QQApiDemo
//
//  Created by lebo on 13-8-13.
//
//

#import "QQApiHelper.h"

#define tencentAppID @"100502123"

@implementation QQApiHelper

static QQApiHelper *helper = nil;

+ (id)shareInstance{
    if (!helper) {
        helper = [[QQApiHelper alloc] init];
        helper.oauth = [[TencentOAuth alloc] initWithAppId:tencentAppID
                                                 andDelegate:helper];
    }
    return helper;
}


- (BOOL)checkQQ
{
    if(![QQApi isQQInstalled]){
        return NO;
    }
    
    if(![QQApi isQQSupportApi]){
        return NO;
    }
    
    return YES;
}

- (void)sendTextMessage:(NSString *)content
{
    if(![self checkQQ]) return;
    
    QQApiTextObject* txt = [QQApiTextObject objectWithText:content];
    
    QQApiMessage* msg = [QQApiMessage messageWithObject:txt];
    
    QQApiSendResultCode sent = [QQApi sendMessage:msg];
    [self handleSendResult:sent];

}

- (void)sendImageMessage:(UIImage *)image preViewImage:(UIImage *)preImage title:(NSString *)title descrition:(NSString *)description
{
    if(![self checkQQ]) return;
  
    NSData *data = UIImageJPEGRepresentation(image, 0.2f);
	NSData *preData = UIImageJPEGRepresentation(preImage, 0.2f);
    
    QQApiImageObject* img = [QQApiImageObject objectWithData:data previewImageData:preData title:title description:description];
    QQApiMessage* msg = [QQApiMessage messageWithObject:img];
    
    QQApiSendResultCode sent = [QQApi sendMessage:msg];
    [self handleSendResult:sent];

}

- (void)sendHybridMessageImage:(UIImage *)image urlStr:(NSString *)urlStr title:(NSString *)title description:(NSString *)description
{
    if(![self checkQQ]) return;
    
    NSData* data = UIImageJPEGRepresentation(image, 0.8f);
    
	NSURL* url = [NSURL URLWithString:urlStr];
	
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:title description:description previewImageData:data];
    
    QQApiMessage* msg = [QQApiMessage messageWithObject:img];
    
    QQApiSendResultCode sent = [QQApi sendMessage:msg];
    [self handleSendResult:sent];
}

- (void)sendAudioMessageImage:(UIImage *)image urlStr:(NSString *)urlStr title:(NSString *)title description:(NSString *)description
{
    if(![self checkQQ]) return;
    
    NSData* data = UIImageJPEGRepresentation(image, 0.8f);
    
    int urllen = 776;
    if(urlStr.length < urllen){
        urllen = urlStr.length;
    }
    NSLog(@"url length is:%d",urllen);
    urlStr = [urlStr substringToIndex:urllen];
	NSURL* url = [NSURL URLWithString:urlStr];
    
    
    QQApiAudioObject* img = [QQApiAudioObject objectWithURL:url title:title description:description previewImageData:data];
    
    QQApiMessage* msg = [QQApiMessage messageWithObject:img];
    
    QQApiSendResultCode sent = [QQApi sendMessage:msg];
    [self handleSendResult:sent];
}

- (void)sendVideoMessageImage:(UIImage *)image urlStr:(NSString *)urlStr title:(NSString *)title description:(NSString *)description
{
    if(![self checkQQ]) return;
    // 压缩视频缩略图 wx上传图片需小于32k
//    LeBoImagePicker *picker = [[LeBoImagePicker alloc] init];
//    NSData *data = [picker compressImage:image PixelCompress:YES MaxPixel:200 JPEGCompress:YES MaxSize_KB:32.0f];
    
	NSURL* url = [NSURL URLWithString:urlStr];
	
    QQApiVideoObject* img = [QQApiVideoObject objectWithURL:url title:title description:description previewImageData:nil];
    
    QQApiMessage* msg = [QQApiMessage messageWithObject:img];
    
    QQApiSendResultCode sent = [QQApi sendMessage:msg];
    
    [self handleSendResult:sent];

}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        default:
        {
            break;
        }
    }
}


- (void)tencentDidNotNetWork{
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled{
    
}

- (void)tencentDidLogin{
    
}

- (void)onResp:(id)response{
    NSLog(@"%@", response);
}

@end
