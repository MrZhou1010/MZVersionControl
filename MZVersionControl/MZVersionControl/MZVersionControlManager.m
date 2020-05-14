//
//  MZVersionControlManager.m
//  MZVersionControl
//
//  Created by Mr.Z on 2019/12/18.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

#import "MZVersionControlManager.h"
#import <UIKit/UIKit.h>

@implementation MZVersionControlManager

#pragma mark - 单例
+ (instancetype)shareManager {
    static MZVersionControlManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - API
+ (void)checkNewVersionWithAppId:(NSString *)appId viewController:(UIViewController *)viewController {
    [[self shareManager] checkNewVersion:appId viewController:viewController];
}

+ (void)checkNewVersionWithAppId:(NSString *)appId showUpdate:(void(^)(NSDictionary *))showUpdate {
    [[self shareManager] checkNewVersion:appId showUpdate:showUpdate];
}

- (void)checkNewVersion:(NSString *)appId viewController:(UIViewController *)viewController {
    [self getAppStoreVersion:appId update:^(NSDictionary *versionInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlertWithInfo:versionInfo viewController:viewController];
        });
    }];
}

- (void)checkNewVersion:(NSString *)appId showUpdate:(void(^)(NSDictionary *))showUpdate {
    [self getAppStoreVersion:appId update:^(NSDictionary *versionInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showUpdate) {
                showUpdate(versionInfo);
            }
        });
    }];
}

#pragma mark - 获取AppStore上的版本信息
- (void)getAppStoreVersion:(NSString *)appId update:(void(^)(NSDictionary *))update {
    [self getAppStoreInfo:appId success:^(NSDictionary *resDic) {
        NSInteger resultCount = [resDic[@"resultCount"] integerValue];
        if (resultCount == 1) {
            NSDictionary *versionInfo = [resDic[@"results"] firstObject];
            // 是否提示更新
            BOOL result = [self isEqualNewVersion:versionInfo[@"version"]];
            if (result && update) {
                update(versionInfo);
            }
        }
    }];
}

#pragma mark - 获取AppStore的info信息
- (void)getAppStoreInfo:(NSString *)appId success:(void(^)(NSDictionary *))success {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", appId]];
        [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error && data && data.length > 0) {
                NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (success) {
                    success(resDic);
                }
            }
        }] resume];
    });
}

#pragma mark - 返回是否提示更新
- (BOOL)isEqualNewVersion:(NSString *)newVersion {
    // 获得忽略的版本
    NSString *ignoreVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"ingoreVersion"];
    // 获得当前的版本
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if ([currentVersion compare:newVersion] == NSOrderedDescending || NSOrderedSame || [ignoreVersion isEqualToString:newVersion]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - AlertController
- (void)showAlertWithInfo:(NSDictionary *)versionInfo viewController:(UIViewController *)viewController {
    NSString *title = [NSString stringWithFormat:@"有新的版本(%@)", versionInfo[@"version"]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:versionInfo[@"releaseNotes"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateRightNow:versionInfo[@"trackViewUrl"]];
    }];
    UIAlertAction *delayAction = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self ignoreNewVersion:versionInfo[@"version"]];
    }];
    [alertController addAction:updateAction];
    [alertController addAction:delayAction];
    [alertController addAction:ignoreAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)updateRightNow:(NSString *)trackViewUrl {
    NSURL *url = [NSURL URLWithString:trackViewUrl];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)ignoreNewVersion:(NSString *)version {
    // 保存忽略的版本号
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"ingoreVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
