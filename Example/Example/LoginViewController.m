//
//  LoginViewController.m
//  Example
//
//  Created by hang_pan on 2020/6/30.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Login";
}

+ (NSArray *)ext_uniqueNames {
    return @[
        @"login",
    ];
}

@end
