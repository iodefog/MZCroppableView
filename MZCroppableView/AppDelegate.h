//
//  AppDelegate.h
//  MZCroppableView
//
//  Created by King on 13-11-19.
//  Copyright (c) 2013年 Lebo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate ,WXApiDelegate>{
     enum WXScene                _scene;
}
@property (strong, nonatomic) UIWindow *window;
-(void) sendVideoContent:(NSString *)content title:(NSString *)title thumbImage:(UIImage *)thumbImage videoUrl:(NSString *)videoUrl;
-(void) changeScene:(NSInteger)scene;
- (void) sendAppContent;
- (void) sendImageContent:(UIImage *)image;
@end
