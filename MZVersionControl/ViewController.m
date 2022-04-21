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

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UIButton *systemAlertBtn;

@property (nonatomic, strong) UIButton *customAlertBtn;

@end

@implementation ViewController

#pragma mark - Lazy
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.frame = CGRectMake(100.0, 100.0, 150.0, 50.0);
        _infoLabel.text = @"版本检测";
        _infoLabel.textColor = [UIColor redColor];
        _infoLabel.font = [UIFont systemFontOfSize:15];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.hidden = YES;
    }
    return _infoLabel;
}

- (UIButton *)systemAlertBtn {
    if (!_systemAlertBtn) {
        _systemAlertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _systemAlertBtn.tag = 101;
        _systemAlertBtn.frame = CGRectMake(100.0, 200.0, 150.0, 50.0);
        [_systemAlertBtn setTitle:@"版本更新一" forState:UIControlStateNormal];
        [_systemAlertBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_systemAlertBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _systemAlertBtn;
}

- (UIButton *)customAlertBtn {
    if (!_customAlertBtn) {
        _customAlertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _customAlertBtn.tag = 102;
        _customAlertBtn.frame = CGRectMake(100.0, 300.0, 150.0, 50.0);
        [_customAlertBtn setTitle:@"版本更新二" forState:UIControlStateNormal];
        [_customAlertBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_customAlertBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customAlertBtn;
}

#pragma mark - UI
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"版本控制(版本检测、版本更新)";
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.systemAlertBtn];
    [self.view addSubview:self.customAlertBtn];
    
    [MZVersionControlManager checkNewVersionWithAppId:@"1472485134" showUpdate:^(BOOL hasNewVersion, NSDictionary * _Nonnull versionInfo) {
        // 有新版本
        if (hasNewVersion) {
            self.infoLabel.hidden = NO;
            self.infoLabel.text = [NSString stringWithFormat:@"新版本: %@", versionInfo[@"version"]];
        }
    }];
}

- (void)btnAction:(UIButton *)btn {
    if (btn.tag == 101) {
        [MZVersionControlManager checkNewVersionWithAppId:@"1472485134" viewController:self];
    } else {
        [MZVersionControlManager checkNewVersionWithAppId:@"1472485134" showUpdate:^(BOOL hasNewVersion, NSDictionary * _Nonnull versionInfo) {
            // 自定义版本更新的视图
            if (hasNewVersion) {
                [self customAlertView:versionInfo];
            }
        }];
    }
}

- (void)customAlertView:(NSDictionary *)versionInfo {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"有新版本更新" message:versionInfo[@"releaseNotes"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:versionInfo[@"trackViewUrl"]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
    [alertController addAction:ignoreAction];
    [alertController addAction:updateAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
