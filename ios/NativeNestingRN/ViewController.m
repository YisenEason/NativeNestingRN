//
//  ViewController.m
//  NativeNestingRN
//
//  Created by easonyi on 19/5/2021.
//

#import "ViewController.h"
#import <React/RCTRootView.h>
#import "HttpRequest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 100, 100);
    [self.view addSubview:btn];
    [btn setTitle:@"btn action" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction {
    NSLog(@"High Score Button Pressed");
//    NSURL *jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.bundle?platform=ios"];
//    NSURL *jsCodeLocation = [NSURL URLWithString:@"https://gfuntest-1256722795.cos.ap-nanjing.myqcloud.com/index.ios.bundle?platform=ios&dev=false"];
    
　　 NSURL *jsCodeLocation = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"index.ios.bundle" ofType:nil]];
    
//    [NSURL urlwith]
    
    [[HttpRequest sharedInstance] downLoadWithURLString:@"https://gfuntest-1256722795.cos.ap-nanjing.myqcloud.com/index.ios.bundle" parameters:@{} progerss:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"progress:  %@", downloadProgress);
    } success:^(NSURLResponse * _Nonnull resp, NSURL * _Nonnull file) {
        NSLog(@"===>>> %@, %@", file, resp);
        
        RCTRootView *rootView =
          [[RCTRootView alloc] initWithBundleURL: file
                                      moduleName: @"RNHighScores"
                               initialProperties:
                                 @{
                                   @"scores" : @[
                                     @{
                                       @"name" : @"Alex",
                                       @"value": @"42"
                                      },
                                     @{
                                       @"name" : @"Joel",
                                       @"value": @"10"
                                     }
                                   ]
                                 }
                                   launchOptions: nil];
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view = rootView;
        [self presentViewController:vc animated:YES completion:nil];
        
    } failure:^(NSError * _Nonnull err) {
        
    }];

//    RCTRootView *rootView =
//      [[RCTRootView alloc] initWithBundleURL: jsCodeLocation
//                                  moduleName: @"RNHighScores"
//                           initialProperties:
//                             @{
//                               @"scores" : @[
//                                 @{
//                                   @"name" : @"Alex",
//                                   @"value": @"42"
//                                  },
//                                 @{
//                                   @"name" : @"Joel",
//                                   @"value": @"10"
//                                 }
//                               ]
//                             }
//                               launchOptions: nil];
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.view = rootView;
//    [self presentViewController:vc animated:YES completion:nil];
}


@end
