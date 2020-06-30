//
//  ExtRouter.m
//  ExtRouter
//
//  Created by Pn-X on 2020/5/9.
//  Copyright © 2020 pn-x. All rights reserved.
//

#import "ExtRouter.h"
#import <objc/runtime.h>

ExtRouterParamsKey * const ExtRouterAnimatedKey = @"__animated";
ExtRouterParamsKey * const ExtRouterCallbackKey = @"__callback";

@implementation UIWindow (ExtRouter)

- (BOOL)ext_routerAvaliable {
    id obj = objc_getAssociatedObject(self, "ext_routerAvaliable");
    return [obj boolValue];
}

- (void)ext_setRouterAvaliable:(BOOL)ext_routerAvaliable {
    objc_setAssociatedObject(self, "ext_routerAvaliable", @(ext_routerAvaliable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)ext_topViewController {
    UIViewController *vc = self.rootViewController;
    while (1) {
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
            continue;
        }
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
            continue;
        }
        if ([vc isKindOfClass:[UISplitViewController class]] && ((UISplitViewController *)vc).viewControllers.count > 0) {
            vc = ((UISplitViewController *)vc).viewControllers.lastObject;
            continue;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
            continue;
        }
        if ([vc isKindOfClass:[UIViewController class]] && vc.childViewControllers.count > 0) {
            NSArray *subviews = vc.view.subviews;
            NSArray *childVCs = vc.childViewControllers;
            NSInteger index = -1;
            UIViewController *child = nil;
            for (UIViewController *childVC in childVCs) {
                NSInteger i = [subviews indexOfObject:childVC.view];
                if (i > index) {
                    child = childVC;
                }
            }
            if (child) {
                vc = child;
                continue;
            }
        }
        break;
    }
    return vc;
}

@end

@implementation UIView (ExtRouter)

- (UIViewController *)ext_viewController {
    UIResponder *responsder = self;
    while (responsder.nextResponder) {
        responsder = responsder.nextResponder;
        if ([responsder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responsder;
        }
    }
    return nil;
}

@end

@implementation UIViewController (ExtRouter)

- (UIWindow *)ext_window {
    UIResponder *responsder = self;
    while (responsder.nextResponder) {
        responsder = responsder.nextResponder;
        if ([responsder isKindOfClass:[UIWindow class]]) {
            return (UIWindow *)responsder;
        }
    }
    return nil;
}

- (UIViewController *)ext_findViewController:(NSString *)uniqueName {
    if ([self isKindOfClass:[UITabBarController class]]) {
        for (UIViewController *vc in [(UITabBarController *)self viewControllers]) {
            NSArray *nameArray = [[vc class] ext_uniqueNames];
            if (nameArray && [nameArray containsObject:uniqueName]) {
                return vc;
            }
        }
        for (UIViewController *vc in [(UITabBarController *)self viewControllers]) {
            return [vc ext_findViewController:uniqueName];
        }
    } else if ([self isKindOfClass:[UINavigationController class]]) {
        for (UIViewController *vc in [(UINavigationController *)self viewControllers]) {
            NSArray *nameArray = [[vc class] ext_uniqueNames];
            if (nameArray && [nameArray containsObject:uniqueName]) {
                return vc;
            }
        }
        for (UIViewController *vc in [(UITabBarController *)self viewControllers]) {
            return [vc ext_findViewController:uniqueName];
        }
    } else {
        for (UIViewController *vc in [self childViewControllers]) {
            NSArray *nameArray = [[vc class] ext_uniqueNames];
            if (nameArray && [nameArray containsObject:uniqueName]) {
                return vc;
            }
        }
        for (UIViewController *vc in [(UITabBarController *)self viewControllers]) {
            return [vc ext_findViewController:uniqueName];
        }
    }
    return nil;
}

- (NSDictionary *)ext_infoData {
    return @{};
}

+ (NSArray <NSString *> *)ext_uniqueNames {
    return @[
        NSStringFromClass([self class])
    ];
}

+ (instancetype)ext_constructor:(NSDictionary *)params {
    return [self new];
}

- (void)ext_handleRouteEventWithParams:(NSDictionary *)params caller:(UIViewController *)caller {
    BOOL animated = params[ExtRouterAnimatedKey] ? [params[ExtRouterAnimatedKey] boolValue] : YES;
    UINavigationController *navi = nil;
    if ([caller isKindOfClass:[UINavigationController class]]) {
        navi = (UINavigationController *)caller;
    } else if (caller.navigationController) {
        navi = (UINavigationController *)caller.navigationController;
    }
    if (navi && ![self isKindOfClass:[UINavigationController class]]) {
        [navi pushViewController:self animated:animated];
    } else {
        [caller presentViewController:self animated:animated completion:nil];
    }
}

- (void)ext_handleRouteBackEventWithParams:(NSDictionary *)params caller:(UIViewController *)caller {
    BOOL animated = params[ExtRouterAnimatedKey] ? [params[ExtRouterAnimatedKey] boolValue] : YES;
    UINavigationController *navi = nil;
    if ([caller isKindOfClass:[UINavigationController class]]) {
        navi = (UINavigationController *)caller;
    } else if (caller.navigationController) {
        navi = (UINavigationController *)caller.navigationController;
    }
    if (navi && ![self isKindOfClass:[UINavigationController class]] && self.navigationController == navi) {
        [navi popToViewController:self animated:animated];
    } else {
        UIViewController *presentingViewController = self.presentingViewController;
        while (presentingViewController) {
            if (presentingViewController == self) {
                [presentingViewController dismissViewControllerAnimated:animated completion:nil];
                break;
            }
            presentingViewController = self.presentingViewController;
        }
    }
}

- (void)ext_handleCloseEventWithParams:(NSDictionary *)params caller:(UIViewController *)caller {
    BOOL animated = params[ExtRouterAnimatedKey] ? [params[ExtRouterAnimatedKey] boolValue] : YES;
    if (self.navigationController) {
        NSArray *viewControllers = self.navigationController.viewControllers;
        NSInteger index = 0;
        for (NSInteger i = 0; i < viewControllers.count; i++) {
            UIViewController *vc  = viewControllers[i];
            if (vc == self) {
                index = i;
                break;
            }
        }
        UIViewController *vc = viewControllers[index];
        if (index == 0) {
            if (vc.presentingViewController) {
                [vc.presentingViewController dismissViewControllerAnimated:animated completion:nil];
            }
        } else {
            [self.navigationController popToViewController:vc animated:animated];
        }
    } else if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:animated completion:nil];
    }
}

@end

@implementation ExtRouterContext

@end

@interface ExtRouter ()

@property (nonatomic, strong) NSMutableDictionary *contextMap;
@property (nonatomic, strong) NSMutableDictionary *nameAndClassMap;

@end

@implementation ExtRouter

+ (instancetype)shared {
    static ExtRouter *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [ExtRouter new];
    });
    return obj;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contextMap = [NSMutableDictionary dictionary];
        self.nameAndClassMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registViewControllerClass:(Class)aClass {
    NSAssert1([aClass isSubclassOfClass:[UIViewController class]], @"[ExtRouter][Class '%@' must be subclass of  UIViewController class]", aClass);
    NSArray *uniqueNameArray = [aClass ext_uniqueNames];
    NSAssert1(uniqueNameArray.count >= 1, @"[ExtRouter][Class '%@' must return 1 uniqueName at least]", aClass);
    for (NSString *uniqueName in uniqueNameArray) {
        Class oldClass = self.nameAndClassMap[uniqueName];
        NSAssert3(oldClass == nil, @"[ExtRouter][UniqueName '%@' registration conflict between Class '%@' and Class '%@']", uniqueName, oldClass, aClass);
        if (oldClass) {
            continue;
        }
        ExtRouterContext *context = [ExtRouterContext new];
        context.aClass = aClass;
        context.uniqueName = uniqueName;
        context.constructor = ^UIViewController * _Nonnull(NSDictionary * _Nonnull params) {
            return [aClass ext_constructor:params];
        };
        context.routeBlock = ^(UIViewController *viewController, NSDictionary *params, UIViewController *caller) {
            [viewController ext_handleRouteEventWithParams:params caller:caller];
        };
        context.routeBackBlock = ^(UIViewController *viewController, NSDictionary *params, UIViewController *caller) {
            [viewController ext_handleRouteBackEventWithParams:params caller:caller];
        };
        context.closeBlock = ^(UIViewController *viewController, NSDictionary *params, UIViewController *caller) {
            [viewController ext_handleCloseEventWithParams:params caller:caller];
        };
        [self registRouterContext:context];
    }
}

- (BOOL)canMacth:(NSString *)uniqueName {
    return [self contextWithUniqueName:uniqueName] != nil;
}

- (void)routeTo:(NSString *)uniqueName {
    [self routeTo:uniqueName params:@{} caller:nil];
}

- (void)routeBackTo:(NSString *)uniqueName {
    [self routeBackTo:uniqueName params:@{} caller:nil];
}

- (void)close:(NSString *)uniqueName {
    [self close:uniqueName params:@{} caller:nil];
}

@end

@implementation ExtRouter (ExtRouter)

- (UIWindow *)topWindow {
    NSArray *windows = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                windows = windowScene.windows;
                break;
            }
        }
    } else {
        windows = [UIApplication sharedApplication].windows;
    }
    UIWindow *window = nil;
    for (NSInteger i = windows.count - 1; i >= 0; i--) {
        window = windows[i];
        if (window.ext_routerAvaliable || i == 0) {
            break;
        }
    }
    return window;
}

- (UIWindow *)rootWindow {
    NSArray *windows = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                windows = windowScene.windows;
                break;
            }
        }
    } else {
        windows = [UIApplication sharedApplication].windows;
    }
    UIWindow *window = windows.firstObject;
    return window;
}

- (void)registRouterContext:(ExtRouterContext *)context {
    NSAssert(context.aClass != nil && context.uniqueName != nil, @"[ExtRouter][Context's property aClass and uniqueName must not be nil]");
    if (!context.aClass || !context.uniqueName) {
        return;
    }
    self.contextMap[context.uniqueName] = context;
    self.nameAndClassMap[context.uniqueName] = context.aClass;
}

- (ExtRouterContext *)contextWithUniqueName:(NSString *)uniqueName {
    return self.contextMap[uniqueName];
}

- (UIViewController *)buildViewController:(NSString *)uniqueName {
    ExtRouterContext *context = [[ExtRouter shared] contextWithUniqueName:uniqueName];
    UIViewController *vc = nil;
    if (context.constructor) {
        vc = context.constructor(@{});
    }
    Class class = NSClassFromString(uniqueName);
    if (class && [class isSubclassOfClass:[UIViewController class]]) {
        if ([class respondsToSelector:@selector(ext_constructor:)]) {
            vc = [class ext_constructor:@{}];
        } else {
            vc = [class new];
        }
    }
    return vc;
}

- (UIViewController *)findViewController:(NSString *)uniqueName {
    UIWindow *window = self.routeWindow?:[self topWindow];
    return [window.rootViewController ext_findViewController:uniqueName];
}

- (void)routeTo:(NSString *)uniqueName params:(NSDictionary *)params {
    [self routeTo:uniqueName params:params caller:nil];
}

- (void)routeBackTo:(NSString *)uniqueName params:(NSDictionary *)params {
    [self routeBackTo:uniqueName params:params caller:nil];
}

- (void)close:(NSString *)uniqueName params:(NSDictionary *)params {
    [self close:uniqueName params:params caller:nil];
}

- (void)routeTo:(NSString *)uniqueName params:(NSDictionary *)params caller:(UIViewController *)caller {
    if (!caller) {
        UIWindow *window = [self routeWindow]?:[self topWindow];
        caller = [window ext_topViewController];
    }
    ExtRouterContext *context = [[ExtRouter shared] contextWithUniqueName:uniqueName];
    UIViewController *vc = [self buildViewController:uniqueName];
    if (!vc && [ExtRouter shared].fallbackVCBuilder) {
        vc = [ExtRouter shared].fallbackVCBuilder(params);
    }
    if (!vc) {
        return;
    }
    if (context.routeBlock) {
        context.routeBlock(vc, params, caller);
    } else {
        [vc ext_handleRouteEventWithParams:params caller:caller];
    }
}


- (void)routeBackTo:(NSString *)uniqueName params:(NSDictionary *)params caller:(UIViewController *)caller {
    if (!caller) {
        UIWindow *window = [self routeWindow]?:[self topWindow];
        caller = [window ext_topViewController];
    }
    ExtRouterContext *context = [[ExtRouter shared] contextWithUniqueName:uniqueName];
    UIViewController *vc = [self findViewController:uniqueName];
    if (!vc) {
        return;
    }
    if (context.routeBackBlock) {
        context.routeBackBlock(vc, params, caller);
    } else {
        [vc ext_handleRouteBackEventWithParams:params caller:caller];
    }
}

- (void)close:(NSString *)uniqueName params:(NSDictionary *)params caller:(UIViewController *)caller {
    if (!caller) {
        UIWindow *window = [self routeWindow]?:[self topWindow];
        caller = [window ext_topViewController];
    }
    ExtRouterContext *context = [[ExtRouter shared] contextWithUniqueName:uniqueName];
    UIViewController *vc = [[caller ext_window].rootViewController ext_findViewController:uniqueName];
    if (!vc) {
        return;
    }
    if (context.closeBlock) {
        context.closeBlock(vc, params, caller);
    } else {
        [vc ext_handleCloseEventWithParams:params caller:caller];
    }
}

- (void)routeToViewController:(UIViewController *)viewController params:(NSDictionary *)params caller:(UIViewController *)caller {
    if (!caller) {
        UIWindow *window = [self routeWindow]?:[self topWindow];
        caller = [window ext_topViewController];
    }
    NSArray *uniqueNameArray = [[viewController class] ext_uniqueNames];
    ExtRouterContext *context = [[ExtRouter shared] contextWithUniqueName:uniqueNameArray[0]];
    if (context.routeBlock) {
        context.routeBlock(viewController, @{}, caller);
    } else {
        [viewController ext_handleRouteEventWithParams:@{} caller:caller];
    }
}

- (void)routeBackToViewController:(UIViewController *)viewController params:(NSDictionary *)params caller:(UIViewController *)caller;{
    if (!caller) {
        UIWindow *window = [self routeWindow]?:[self topWindow];
        caller = [window ext_topViewController];
    }
    NSArray *uniqueNameArray = [[viewController class] ext_uniqueNames];
    ExtRouterContext *context = [[ExtRouter shared] contextWithUniqueName:uniqueNameArray[0]];
    if (context.routeBackBlock) {
        context.routeBackBlock(viewController, @{}, caller);
    } else {
        [viewController ext_handleRouteBackEventWithParams:@{} caller:caller];
    }
}

- (void)closeViewController:(UIViewController *)viewController params:(NSDictionary *)params caller:(UIViewController *)caller {
    if (!caller) {
        UIWindow *window = [self routeWindow]?:[self topWindow];
        caller = [window ext_topViewController];
    }
    NSArray *uniqueNameArray = [[viewController class] ext_uniqueNames];
    ExtRouterContext *context = [[ExtRouter shared] contextWithUniqueName:uniqueNameArray[0]];
    if (context.closeBlock) {
        context.closeBlock(viewController, @{}, caller);
    } else {
        [viewController ext_handleCloseEventWithParams:@{} caller:caller];
    }
}

- (void)closeTopViewController {
    UIWindow *window = self.routeWindow?:[self topWindow];
    [self closeViewController:[window ext_topViewController] params:@{} caller:nil];
}

- (NSString *)contextDescription {
    return [self.nameAndClassMap description];
}
@end
