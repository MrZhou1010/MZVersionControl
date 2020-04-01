//
//  ViewController.m
//  MZVersionControl
//
//  Created by Mr.Z on 2019/12/18.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

#import "ViewController.h"
#import "MZVersionControlManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.tag = 101;
    [button1 setFrame:CGRectMake(100, 200, 150, 50)];
    [button1 setTitle:@"版本更新一" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = 102;
    [button2 setFrame:CGRectMake(100, 300, 150, 50)];
    [button2 setTitle:@"版本更新二" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}

- (void)buttonClick:(UIButton *)button {
    if (button.tag == 101) {
        [MZVersionControlManager checkNewVersionWithAppId:@"1472485134" viewController:self];
    } else {
        [MZVersionControlManager checkNewVersionWithAppId:@"1472485134" showUpdate:^(NSDictionary * _Nonnull versionInfo) {
            // 自定义版本跟新的视图
            [self customAlertView:versionInfo];
        }];
    }
}

- (void)customAlertView:(NSDictionary *)versionInfo {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新版本更新" message:versionInfo[@"releaseNotes"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:versionInfo[@"trackViewUrl"]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }];
    [alertController addAction:ignoreAction];
    [alertController addAction:updateAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
