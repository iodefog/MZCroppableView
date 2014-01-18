//
//  AppDelegate.m
//  MZCroppableView
//
//  Created by King on 13-11-19.
//  Copyright (c) 2013年 Lebo. All rights reserved.
//

#import "AppDelegate.h"
#import "OperationViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    OperationViewController *rvc = [[OperationViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rvc];
    self.window.rootViewController = nav;
    
    // 向微信注册
    [WXApi registerApp:@"wx1ae161cb75d576fb"];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 微信 method
// 发视频到微信好友回调
- (void)onResp:(BaseResp*)resp
{
    NSLog(@"微信发送完毕,  返回时调用!");
}

// 发视频到微信好友
- (void)sendVideoContent:(NSString *)content title:(NSString *)title thumbImage:(UIImage *)thumbImage videoUrl:(NSString *)videoUrl
{
    WXMediaMessage *message = [WXMediaMessage message];
    if (!title || [title isEqualToString:@""]) {
        message.title = nil;
        message.description = title;
    }else{
        message.title = title;
    }
    // 压缩视频缩略图 wx上传图片需小于32k
//    LeBoImagePicker *picker = [[LeBoImagePicker alloc] init];
//    NSData *data = [picker compressImage:thumbImage PixelCompress:YES MaxPixel:200 JPEGCompress:YES MaxSize_KB:32.0f];
    
//    NSLog(@"%f",data.length/1024.0f);
//    message.thumbData = data;
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = videoUrl;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.text = @"Hello World";
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void) sendImageContent:(UIImage *)image
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"res5thumb.png"]];
    
    WXImageObject *ext = [WXImageObject object];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5thumb" ofType:@"png"];
//    NSLog(@"filepath :%@",filePath);
//    ext.imageData = [NSData dataWithContentsOfFile:filePath];
//    
//    //UIImage* image = [UIImage imageWithContentsOfFile:filePath];
//    UIImage* image = [UIImage imageWithData:ext.imageData];
    ext.imageData = UIImagePNGRepresentation(image);
    
    //    UIImage* image = [UIImage imageNamed:@"res5thumb.png"];
    //    ext.imageData = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}


//切换 分享到对话或者是朋友圈
- (void)changeScene:(NSInteger)scene{
    _scene = scene;
}

#define BUFFER_SIZE 1024 * 100
- (void)sendAppContent
{
    // 发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = APPLICATIONTITLE;
//    message.description = WXDEFAULTTEXT;
//    LeBoImagePicker *picker = [[LeBoImagePicker alloc] init];
//    NSData *data = [picker compressImage:[UIImage imageNamed:@"icon-60@2x.png"] PixelCompress:YES MaxPixel:200 JPEGCompress:YES MaxSize_KB:32.0f];
    
//    [message setThumbData:data];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
//    ext.url = APPSTOREURL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}


@end
