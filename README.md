# MZVersionControl
版本控制(版本检测、版本更新)

    /// 单例
    + (instancetype)shareInstance;

    /// 检查更新版本
    /// @param appId 应用的id
    /// @param viewController 所在的vc
    + (void)checkNewVersionWithAppId:(NSString *)appId viewController:(UIViewController *)viewController;

    /// 检查更新版本
    /// @param appId 应用的id
    /// @param showUpdate 回调hasNewVersion及version数据
    + (void)checkNewVersionWithAppId:(NSString *)appId showUpdate:(void(^)(BOOL, NSDictionary *))showUpdate;

    /// 检查更新版本
    /// @param appId 应用的id
    /// @param viewController 所在的vc
    - (void)checkNewVersion:(NSString *)appId viewController:(UIViewController *)viewController;

    /// 检查更新版本
    /// @param appId 应用的id
    /// @param showUpdate 回调hasNewVersion及version数据
    - (void)checkNewVersion:(NSString *)appId showUpdate:(void(^)(BOOL, NSDictionary *))showUpdate;
