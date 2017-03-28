//
//  RCNetworkingInfo.m
//  RCTelephony
//
//  Created by Roy on 2017/3/28.
//  Copyright © 2017年 Roy CHANG. All rights reserved.
//

#import "RCNetworkingInfo.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

NSString *const g_RC_HostName = @"www.apple.com";

NSString *const g_Default_CarrierName = @"未知";

@interface RCNetworkingInfo ()

@property (nonatomic, strong) Reachability *reach;

@property (nonatomic, strong) CTTelephonyNetworkInfo *networkInfo;

@end

@implementation RCNetworkingInfo

@synthesize currentNetworkStatus = _currentNetworkStatus;

- (instancetype)init
{
    if(self = [super init])
    {
        _networkInfo = [[CTTelephonyNetworkInfo alloc] init];
        _currentNetworkStatus = RCNetworkStatusUnknown;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rc_reachbilityDidChanged:) name:kReachabilityChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rc_radioAccessTechnologyDidChanged:) name:CTRadioAccessTechnologyDidChangeNotification object:nil];
    }
    
    return self;
}

#pragma mark - release resources

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    _networkBlock = nil;
    _networkInfo = nil;
    if(_reach)
    {
        [_reach stopNotifier];
        _reach = nil;
    }
}

#pragma mark - properties

- (Reachability *)reach
{
    if(!_reach)
    {
        _reach = [Reachability reachabilityWithHostName:g_RC_HostName];
    }
    
    return _reach;
}

- (NSString *)carrierName
{
    NSString *name_t = [self.networkInfo.subscriberCellularProvider carrierName];
    return name_t ?: g_Default_CarrierName;
}

- (RCNetworkStatus)currentNetworkStatus
{
    return _currentNetworkStatus;
}

#pragma mark - cellular info

- (RCNetworkStatus)rc_networkStatusForCellular:(CTTelephonyNetworkInfo *)networkInfo
{
    @autoreleasepool {
        
        NSString *radio =  networkInfo.currentRadioAccessTechnology;
        if(!radio)
        {
            return RCNetworkStatusUnknown;
        }
        
        NSDictionary *dic_RadioAccessTechnology = @{
                                                CTRadioAccessTechnologyGPRS : @(RCNetworkStatus2G),
                                                CTRadioAccessTechnologyEdge : @(RCNetworkStatus2G),
                                                CTRadioAccessTechnologyCDMA1x : @(RCNetworkStatus2G),
                                                    
                                                CTRadioAccessTechnologyWCDMA : @(RCNetworkStatus3G),
                                                CTRadioAccessTechnologyHSDPA : @(RCNetworkStatus3G),
                                                CTRadioAccessTechnologyHSUPA : @(RCNetworkStatus3G),
                                                CTRadioAccessTechnologyCDMAEVDORev0 : @(RCNetworkStatus3G),
                                                CTRadioAccessTechnologyCDMAEVDORevA : @(RCNetworkStatus3G),
                                                CTRadioAccessTechnologyCDMAEVDORevB : @(RCNetworkStatus3G),
                                                CTRadioAccessTechnologyeHRPD : @(RCNetworkStatus3G),
                                                    
                                                CTRadioAccessTechnologyLTE : @(RCNetworkStatus4G),};
        
        _currentNetworkStatus = [dic_RadioAccessTechnology[radio] integerValue];
        return _currentNetworkStatus;
    }
}

#pragma mark - update network

- (void)rc_updateNetwok:(Reachability*)reachability
{
    if(![reachability isKindOfClass:[Reachability class]])
    {
        return;
    }
    
    RCNetworkStatus status = RCNetworkStatusUnknown;
    
    switch([reachability currentReachabilityStatus])
    {
        case NotReachable:
        {
            status = RCNetworkStatusUnconnected;
        }
            break;
            
        case ReachableViaWiFi:
        {
            status = RCNetworkStatusWifi;
        }
            break;
            
        case ReachableViaWWAN:
        {
            status = [self rc_networkStatusForCellular:self.networkInfo];
        }
            break;
    }
    
    if(_networkBlock)
    {
        _networkBlock(status);
    }
}

#pragma mark - reachbility notification selector

- (void)rc_reachbilityDidChanged:(NSNotification *)notify
{
    Reachability *reach_t = (Reachability*)notify.object;
    [self rc_updateNetwok:reach_t];
}

#pragma mark - radio access technology notification

- (void)rc_radioAccessTechnologyDidChanged:(NSNotification *)notify
{
    [self rc_updateNetwok:self.reach];
}

#pragma mark - start notifier

- (BOOL)rc_startNotifier
{
    return [self.reach startNotifier];
}

#pragma mark - stop notifier

- (void)rc_stopNotifier
{
    [self.reach stopNotifier];
    _reach = nil;
}

#pragma mark - status string from status

+ (NSString *)rc_stringForNetworkStatus:(RCNetworkStatus)status
{
    NSString *result = @"网络未知";
    switch(status)
    {
        case RCNetworkStatusUnconnected:result = @"网络未联接";break;
        case RCNetworkStatusWifi:result = @"Wifi";break;
        case RCNetworkStatus2G:result = @"2G";break;
        case RCNetworkStatus3G:result = @"3G";break;
        case RCNetworkStatus4G:result = @"4G";break;
        default:break;
    }
    
    return result;
}

@end
