//
//  QQApiHelper.h
//  QQApiDemo
//
//  Created by lebo on 13-8-13.
//
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface QQApiHelper : NSObject<TencentSessionDelegate>

@property (nonatomic, strong) TencentOAuth *oauth;

+ (id)shareInstance;

// 检查qq是否合法和支持分享
- (BOOL)checkQQ;

// 发送文字信息
- (void)sendTextMessage:(NSString *)content;

// 发送图片信息
- (void)sendImageMessage:(UIImage *)image preViewImage:(UIImage *)preImage title:(NSString *)title descrition:(NSString *)description;

// 发送图片、文字、链接等混合信息
- (void)sendHybridMessageImage:(UIImage *)image urlStr:(NSString *)urlStr title:(NSString *)title description:(NSString *)description;

// 发送音频信息
- (void)sendAudioMessageImage:(UIImage *)image urlStr:(NSString *)urlStr title:(NSString *)title description:(NSString *)description;

//  发送视频信息
- (void)sendVideoMessageImage:(UIImage *)image urlStr:(NSString *)urlStr title:(NSString *)title description:(NSString *)description;

- (void)onResp:(id)response;

@end
