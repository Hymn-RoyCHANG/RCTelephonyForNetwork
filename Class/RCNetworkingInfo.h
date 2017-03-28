//
//  RCNetworkingInfo.h
//  RCTelephony
//
//  Created by Roy on 2017/3/28.
//  Copyright © 2017年 Roy CHANG. All rights reserved.
//

#import <Foundation/Foundation.h>

///网络状态
typedef NS_ENUM(NSInteger, RCNetworkStatus)
{
    ///未知
    RCNetworkStatusUnknown,
    ///未联接
    RCNetworkStatusUnconnected,
    ///wifi网络
    RCNetworkStatusWifi,
    ///2G网络
    RCNetworkStatus2G,
    ///3G网络
    RCNetworkStatus3G,
    ///4G网络
    RCNetworkStatus4G
};

typedef void (^RCNetworkBlock)(RCNetworkStatus status);

/**
 * 基本的网络信息
 *
 * @author Roy CHANG
 */
NS_CLASS_AVAILABLE_IOS(7_0) @interface RCNetworkingInfo : NSObject

///网络信息回调块
@property (nonatomic, copy) RCNetworkBlock networkBlock;

///运营商名
@property (nonatomic, readonly) NSString *carrierName;

///当前网络状态
@property (nonatomic, readonly) RCNetworkStatus currentNetworkStatus;

///开启监听
- (BOOL)rc_startNotifier;

///关闭
- (void)rc_stopNotifier;

///状态字符串化
+ (NSString *)rc_stringForNetworkStatus:(RCNetworkStatus)status;

@end
