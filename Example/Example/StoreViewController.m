//
//  StoreViewController.m
//  Example
//
//  Created by hang_pan on 2020/6/30.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "StoreViewController.h"
#import <ExtRouter/ExtRouter.h>

@interface StoreViewController ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(arc4random()%256)/255.0f green:(arc4random()%256)/255.0f blue:(arc4random()%256)/255.0f alpha:1.0f];
    self.title = @"store";
    
    
    [self.view addSubview:self.textLabel];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
    
    self.navigationItem.rightBarButtonItems = @[
    [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(backToRoot)],
    [[UIBarButtonItem alloc] initWithTitle:@"pushHome" style:UIBarButtonItemStyleDone target:self action:@selector(pushHome)]
    ];
}

- (void)tap {
    [[ExtRouter shared] routeTo:@"martshow/store"];
}

- (void)backToRoot {
    [[ExtRouter shared] routeBackTo:@"home" params:@{@"color":self.view.backgroundColor}];
}

- (void)pushHome {
    [[ExtRouter shared] routeTo:@"home"];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    }
    return _textLabel;
}



//override
+ (NSArray *)ext_uniqueNames {
    return @[
        @"store",
        @"martshow/store"
    ];
}

- (NSDictionary *)ext_infoData {
    return @{@"text":self};
}

- (void)ext_handleRouteEventWithParams:(NSDictionary *)params caller:(UIViewController *)caller {
    [super ext_handleRouteEventWithParams:params caller:caller];
    self.textLabel.text = [NSString stringWithFormat:@"caller:%@", [caller ext_infoData][@"text"]];
}
@end
