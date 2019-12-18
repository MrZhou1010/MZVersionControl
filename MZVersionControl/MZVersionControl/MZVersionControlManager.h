//
//  MZVersionControlManager.h
//  MZVersionControl
//
//  Created by Mr.Z on 2019/12/18.
//  Copyright © 2019 Mr.Z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIViewController;

@interface MZVersionControlManager : NSObject

/// 单例
+ (instancetype)shareManager;

/// 检查更新版本
/// @param appId 应用的id
/// @param viewController 所在的vc
+ (void)checkNewVersionWithAppId:(NSString *)appId viewController:(UIViewController *)viewController;

/// 检查更新版本
/// @param appId 应用的id
/// @param showUpdate 回调version数据
+ (void)checkNewVersionWithAppId:(NSString *)appId showUpdate:(void(^)(NSDictionary *))showUpdate;

/// 检查更新版本
/// @param appId 应用的id
/// @param viewController 所在的vc
- (void)checkNewVersion:(NSString *)appId viewController:(UIViewController *)viewController;

/// 检查更新版本
/// @param appId 应用的id
/// @param showUpdate 回调version数据
- (void)checkNewVersion:(NSString *)appId showUpdate:(void(^)(NSDictionary *))showUpdate;

@end

NS_ASSUME_NONNULL_END
