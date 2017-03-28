//
//  ViewController.m
//  RCTelephony
//
//  Created by Roy on 2017/3/28.
//  Copyright © 2017年 Roy CHANG. All rights reserved.
//

#import "ViewController.h"
#import "RCNetworkingInfo.h"

@interface ViewController ()

@property (nonatomic, strong) RCNetworkingInfo *networkInfo;
@property (weak, nonatomic) IBOutlet UILabel *cellularLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _networkInfo = [[RCNetworkingInfo alloc] init];
    typeof(&*self) __weak weakSelf = self;
    _networkInfo.networkBlock = ^(RCNetworkStatus status){
    
        weakSelf.cellularLabel.text = weakSelf.networkInfo.carrierName;
        weakSelf.statuLabel.text = [RCNetworkingInfo rc_stringForNetworkStatus:status];
    };
    [_networkInfo rc_startNotifier];
}

- (void)dealloc
{
    [_networkInfo rc_stopNotifier];
    _networkInfo = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
