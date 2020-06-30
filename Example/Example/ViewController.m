//
//  ViewController.m
//  Example
//
//  Created by hang_pan on 2020/6/30.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "ViewController.h"
#import <ExtRouter/ExtRouter.h>

@interface ViewController ()

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"login" style:UIBarButtonItemStyleDone target:self action:@selector(login)];
}

- (void)tap {
    [[ExtRouter shared] routeTo:@"store"];
}

- (void)login {
    [[ExtRouter shared] routeTo:@"login"];
}



//override
+ (NSArray *)ext_uniqueNames {
    return @[
        @"home"
    ];
}

- (NSDictionary *)ext_infoData {
    return @{@"text":self};
}

- (void)ext_handleRouteBackEventWithParams:(NSDictionary *)params caller:(UIViewController *)caller {
    [super ext_handleRouteBackEventWithParams:params caller:caller];
    self.params = params;
    NSLog(@"Color is : %@", params[@"color"]);
    self.view.backgroundColor = params[@"color"];
}
@end
