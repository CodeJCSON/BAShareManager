//
//  ShareManage.m
//  yrapp
//
//  Created by 博爱 on 16/2/3.
//  Copyright © 2016年 有人科技. All rights reserved.
//  友盟分享工具类

#import "BAShareManage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import "BAShareAnimationView.h"
#import "UMSocialQQHandler.h"

@implementation BAShareManage {
    UIViewController *_viewC;
}

static BAShareManage *shareManage;

+ (BAShareManage *)shareManage
{
    @synchronized(self)
    {
        if (shareManage == nil) {
            shareManage = [[self alloc] init];
        }
        return shareManage;
    }
}

#pragma mark - 友盟分享
#pragma mark 注册友盟分享微信
- (void)shareConfig
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:self.BAShareUmengAppkey];
    [UMSocialData openLog:YES];
    
    //注册微信
    [WXApi registerApp:self.BAShareWX_APP_KEY];
    //设置图文分享
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
}

#pragma mark 微信分享
- (void)BA_wxShareWithViewControll:(UIViewController *)viewC withShareText:shareText image:shareImage url:shareURLString
{
    _viewC = viewC;
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
    
    [UMSocialWechatHandler setWXAppId:self.BAShareWX_APP_KEY appSecret:self.BAShareWX_APP_SECRET url:shareURLString];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark 新浪微博分享
- (void)BA_wbShareWithViewControll:(UIViewController *)viewC withShareText:shareText image:shareImage
{
    _viewC = viewC;
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:self.BAShareSinaAppKey].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark 微信朋友圈分享
- (void)BA_wxpyqShareWithViewControll:(UIViewController *)viewC withShareText:shareText image:shareImage url:shareURLString
{
    _viewC = viewC;
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
    [UMSocialWechatHandler setWXAppId:self.BAShareWX_APP_KEY appSecret:self.BAShareWX_APP_SECRET url:shareURLString];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark qq分享
- (void)BA_qqShareWithViewControll:(UIViewController *)viewC withShareText:shareText image:shareImage url:shareURLString
{
    _viewC = viewC;
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
    [UMSocialQQHandler setQQWithAppId:self.BASharekQQAppID appKey:self.BASharekQQKey url:shareURLString];

    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark qqzone分享
- (void)BA_qqzoneShareWithViewControll:(UIViewController *)viewC withShareText:shareText image:shareImage url:shareURLString
{
    _viewC = viewC;
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:nil];
    [UMSocialQQHandler setQQWithAppId:self.BASharekQQAppID appKey:self.BASharekQQKey url:shareURLString];
    
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark 短信分享
- (void)BA_smsShareWithViewControll:(UIViewController *)viewC withShareText:shareText image:shareImage
{
    _viewC = viewC;
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheetWithShareText:(NSString *)shareText];
        }
        else {
            //@"设备没有短信功能"
        }
    }
    else {
        //@"iOS版本过低,iOS4.0以上才支持程序内发送短信"
    }
}

#pragma mark 短信的代理方法
- (void)BA_messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [_viewC dismissViewControllerAnimated:YES completion:nil];
    switch (result)
    {
        case MessageComposeResultCancelled:
            
            break;
        case MessageComposeResultSent:
            //@"感谢您的分享!"
            break;
        case MessageComposeResultFailed:
            
            break;
        default:
            break;
    }
}

#pragma mark 分享列表
- (void)BA_UMshareListWithViewControll:(UIViewController *)viewC withShareText:(NSString *)shareText image:(UIImage *)shareImage url:(NSString *)shareURLString
{
//    NSMutableArray *titarray = [NSMutableArray arrayWithObjects:@"微信",@"朋友圈",@"微博", @"QQ",@"空间",nil];
//    NSMutableArray *picarray = [NSMutableArray arrayWithObjects:@"wechat",@"pyq",@"weibo", @"qq",@"zone",nil];
    
    /*! 分享的名字数组（要和图片名字一一对应哦！）【可以参照上图所示，也可以自己单独调用】 */
    NSMutableArray *titarray = self.shareNameArray;
    NSMutableArray *picarray = self.shareImageArray;
    BAShareAnimationView *animationView = [[BAShareAnimationView alloc]initWithTitleArray:titarray picarray:picarray title:@"第三方分享"];
    [animationView selectedWithIndex:^(NSInteger index,id shareType) {
        NSLog(@"你选择的index ＝＝ %ld",(long)index);
        NSLog(@"要分享到的平台");
        
        switch (index)
        {
            case 1:
                [self BA_wxShareWithViewControll:viewC withShareText:shareText image:shareImage url:shareURLString];
                break;
            case 2:
                [self BA_wxpyqShareWithViewControll:viewC withShareText:shareText image:shareImage url:shareURLString];
                break;
            case 3:
                [self BA_wbShareWithViewControll:viewC withShareText:shareText image:shareImage];
                break;
            case 4:
                [self BA_qqShareWithViewControll:viewC withShareText:shareText image:shareImage url:shareURLString];
                break;
            case 5:
                [self BA_qqzoneShareWithViewControll:viewC withShareText:shareText image:shareImage url:shareURLString];
                break;
                
            default:
                break;
        }
    }];
    [animationView CLBtnBlock:^(UIButton *btn) {
        
        NSLog(@"你点了选择/取消按钮");
    }];
    [animationView show];
}

- (void)displaySMSComposerSheetWithShareText:(NSString *)shareText
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.navigationBar.tintColor = [UIColor blackColor];
    //    picker.recipients = [NSArray arrayWithObject:@"10086"];
    picker.body = shareText;
    [_viewC presentViewController:picker animated:YES completion:nil];
}

// 实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    // 根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        // 得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

#pragma mark - 友盟登录
/**友盟 QQ 登录**/
- (void)BA_QQLogin:(UIViewController *)viewController
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(viewController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSDictionary *dict = [NSDictionary dictionary];
            dict = @{
                     @"userName" : snsAccount.userName,
                     @"usid" : snsAccount.usid,
                     @"accessToken" : snsAccount.accessToken,
                     @"iconURL" : snsAccount.iconURL
                     };
            // delegate
            [self.delegate getUserData:dict];

            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
        }});
}

/**友盟 Qzone 登录**/
- (void)BA_QzoneLogin:(UIViewController *)viewController
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone];
    
    snsPlatform.loginClickHandler(viewController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        // 获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQzone];
            
            NSDictionary *dict = [NSDictionary dictionary];
            dict = @{
                     @"userName" : snsAccount.userName,
                     @"usid" : snsAccount.usid,
                     @"accessToken" : snsAccount.accessToken,
                     @"iconURL" : snsAccount.iconURL
                     };
            // delegate
            [self.delegate getUserData:dict];

            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});
}

/**友盟 新浪微博 登录**/
- (void)BA_SinaLogin:(UIViewController *)viewController
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(viewController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        // 获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSDictionary *dict = [NSDictionary dictionary];
            dict = @{
                     @"userName" : snsAccount.userName,
                     @"usid" : snsAccount.usid,
                     @"accessToken" : snsAccount.accessToken,
                     @"iconURL" : snsAccount.iconURL
                     };
            // delegate
            [self.delegate getUserData:dict];

            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});
}

/**删除新浪微博登陆授权调用下面的方法**/
- (void)deleteSinaLogin
{
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
    }];
}

/**友盟 微信 登录**/
- (void)BA_WechatSessionLogin:(UIViewController *)viewController
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(viewController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSDictionary *dict = [NSDictionary dictionary];
            dict = @{
                     @"userName" : snsAccount.userName,
                     @"usid" : snsAccount.usid,
                     @"accessToken" : snsAccount.accessToken,
                     @"iconURL" : snsAccount.iconURL
                     };

            // delegate
            [self.delegate getUserData:dict];

            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
        }
    });
}

/**友盟登录列表**/
- (void)BA_UMLoginListWithViewControll:(UIViewController *)viewController
{
    //    NSMutableArray *titarray = [NSMutableArray arrayWithObjects:@"微信",@"朋友圈",@"微博", @"QQ",@"空间",nil];
    //    NSMutableArray *picarray = [NSMutableArray arrayWithObjects:@"wechat",@"pyq",@"weibo", @"qq",@"zone",nil];
    
    /*! 分享的名字数组（要和图片名字一一对应哦！）【可以参照上图所示，也可以自己单独调用】 */
    NSMutableArray *titarray = self.shareNameArray;
    NSMutableArray *picarray = self.shareImageArray;
    BAShareAnimationView *animationView = [[BAShareAnimationView alloc]initWithTitleArray:titarray picarray:picarray title:@"第三方登录"];
    [animationView selectedWithIndex:^(NSInteger index,id shareType) {
        NSLog(@"你选择的index ＝＝ %ld",(long)index);
        NSLog(@"要登录的平台");
        
        switch (index)
        {
            case 1:
                [self BA_WechatSessionLogin:viewController];
                break;
            case 2:
                [self BA_SinaLogin:viewController];
                break;
            case 3:
                [self BA_QQLogin:viewController];
                break;
            case 4:
                [self BA_QzoneLogin:viewController];
                break;

            default:
                break;
        }
    }];
    [animationView CLBtnBlock:^(UIButton *btn) {
        
        NSLog(@"你点了选择/取消按钮");
    }];
    [animationView show];
}

@end
