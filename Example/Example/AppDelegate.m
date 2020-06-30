//
//  AppDelegate.m
//  Example
//
//  Created by hang_pan on 2020/6/30.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "StoreViewController.h"
#import "LoginViewController.h"
#import <ExtRouter/ExtRouter.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registViewControllersToRouter];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    if (@available(iOS 13.0, *)) {
        return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
    } else {
        return nil;
    }
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (void)registViewControllersToRouter {
    //you can also regist these class from configuration file
    [[ExtRouter shared] registViewControllerClass:[ViewController class]];
    [[ExtRouter shared] registViewControllerClass:[StoreViewController class]];
    [[ExtRouter shared] registViewControllerClass:[LoginViewController class]];
    [ExtRouter shared].fallbackVCBuilder = ^UIViewController *(NSDictionary *params){
        UIViewController *vc = [UIViewController new];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.title = @"页面丢失了";
        return vc;
    };
}

@end
