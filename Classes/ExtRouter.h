//
//  ExtRouter.h
//  ExtRouter
//
//  Created by Pn-X on 2020/5/9.
//  Copyright © 2020 pn-x. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExtRouterContext;

typedef void(^ExtRouterCallback)(BOOL ret, NSString *msg, id data);
typedef NSString ExtRouterParamsKey;

extern ExtRouterParamsKey * const ExtRouterAnimatedKey;
extern ExtRouterParamsKey * const ExtRouterCallbackKey;

@interface ExtRouter : NSObject

@property (nonatomic, weak) UIWindow *routeWindow;

@property (nonatomic, strong) UIViewController*(^fallbackVCBuilder)(NSDictionary *params);

+ (instancetype)shared;

- (void)registViewControllerClass:(Class)aClass;

- (BOOL)canMacth:(NSString *)uniqueName;

- (void)routeTo:(NSString *)uniqueName;

- (void)routeBackTo:(NSString *)uniqueName;

- (void)close:(NSString *)uniqueName;

@end

@interface ExtRouter (ExtRouter)

- (UIWindow *)topWindow;

- (UIWindow *)rootWindow;

- (void)registRouterContext:(ExtRouterContext *)context;

- (ExtRouterContext *)contextWithUniqueName:(NSString *)uniqueName;

- (UIViewController *)buildViewController:(NSString *)uniqueName;

- (UIViewController *)findViewController:(NSString *)uniqueName;

- (void)routeTo:(NSString *)uniqueName params:(NSDictionary *)params;

- (void)routeBackTo:(NSString *)uniqueName params:(NSDictionary *)params;

- (void)close:(NSString *)uniqueName params:(NSDictionary *)params;

- (void)routeTo:(NSString *)uniqueName params:(NSDictionary *)params caller:(UIViewController *)caller;

- (void)routeBackTo:(NSString *)uniqueName params:(NSDictionary *)params caller:(UIViewController *)caller;

- (void)close:(NSString *)uniqueName params:(NSDictionary *)params caller:(UIViewController *)caller;

- (void)routeToViewController:(UIViewController *)viewController params:(NSDictionary *)params caller:(UIViewController *)caller;

- (void)routeBackToViewController:(UIViewController *)viewController params:(NSDictionary *)params caller:(UIViewController *)caller;

- (void)closeViewController:(UIViewController *)viewController params:(NSDictionary *)params caller:(UIViewController *)caller;

- (void)closeTopViewController;

- (NSString *)contextDescription;

@end


@interface UIWindow (ExtRouter)

@property (nonatomic, assign, setter=ext_setRouterAvaliable:) BOOL ext_routerAvaliable;

- (UIViewController *)ext_topViewController;

@end


@interface UIView (ExtRouter)

- (UIViewController *)ext_viewController;

@end


@interface UIViewController (ExtRouter)

- (UIWindow *)ext_window;

- (UIViewController *)ext_findViewController:(NSString *)uniqueName;

//override by subclass

+ (NSArray <NSString *> *)ext_uniqueNames;

+ (instancetype)ext_constructor:(NSDictionary *)params;

- (NSDictionary *)ext_infoData;

- (void)ext_handleRouteEventWithParams:(NSDictionary *)params caller:(UIViewController *)caller;

- (void)ext_handleRouteBackEventWithParams:(NSDictionary *)params caller:(UIViewController *)caller;

- (void)ext_handleCloseEventWithParams:(NSDictionary *)params caller:(UIViewController *)caller;

@end


@interface ExtRouterContext : NSObject

@property (nonatomic, copy) NSString *uniqueName;

@property (nonatomic, strong) Class aClass;

@property (nonatomic, copy) UIViewController*(^constructor)(NSDictionary *params);

@property (nonatomic, copy) void(^routeBlock)(UIViewController *viewController, NSDictionary *params, UIViewController *caller);

@property (nonatomic, copy) void(^closeBlock)(UIViewController *viewController,  NSDictionary *params, UIViewController *caller);

@property (nonatomic, copy) void(^routeBackBlock)(UIViewController *viewController,  NSDictionary *params, UIViewController *caller);

@end
