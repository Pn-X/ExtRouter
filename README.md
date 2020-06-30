# ExtRouter
A lightweight router library 

### Installation

Simply add the following line to your Podfile:

`pod 'ExtRouter'`

### Usage

It`s easy to use ExtRouter, you can clone this repository and run exapmle project to see how it works. In most cases, you only need to perform the following steps

* Override  +[UIViewController ext_uniqueNames] method

  ```objective-c
  //  StoreViewController.m
  ...
  + (NSArray *)ext_uniqueNames {
      return @[
          @"store",
          @"martshow/store"
      ];
  }
  ...
  ```

* Register viewController's class to ExtRouter 

  ```objective-c
  //  AppDelegate.m
  ...
  
  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      
      //othercode
    
      [[ExtRouter shared] registViewControllerClass:[ViewController class]];
      [[ExtRouter shared] registViewControllerClass:[StoreViewController class]];
      [[ExtRouter shared] registViewControllerClass:[LoginViewController class]];
  
      //othercode
    
      return YES;
  }
  
  ...
  ```

* Route to destination

  ```objective-c
  [[ExtRouter shared] routeTo:@"store"];
  ```

### Advanced Usage

You can found it in [Wiki](https://github.com/Pn-X/ExtRouter/wiki)

### License

ExtRouter is released under the MIT license