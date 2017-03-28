# RCTelephonyForNetwork
使用CoreTelephony获取一些网络状态
# 干嘛的
    配合Apple Sample ‘Reachability’使用‘CoreTelephony’获取网络类型和运行商信息。
# 怎么用
```Objective-C
    ///属性
    @property (nonatomic, strong) RCNetworkingInfo *networkInfo;
    @property (weak, nonatomic) IBOutlet UILabel *cellularLabel;
    @property (weak, nonatomic) IBOutlet UILabel *statuLabel;
  
    ///使用
    _networkInfo = [[RCNetworkingInfo alloc] init];
    typeof(&*self) __weak weakSelf = self;
    _networkInfo.networkBlock = ^(RCNetworkStatus status){
    
        weakSelf.cellularLabel.text = weakSelf.networkInfo.carrierName;
        weakSelf.statuLabel.text = [RCNetworkingInfo rc_stringForNetworkStatus:status];
    };
    [_networkInfo rc_startNotifier];
```
![](https://github.com/Hymn-RoyCHANG/RCTelephonyForNetwork/raw/master/screenshot/no.jpeg "没有网络")
![](https://github.com/Hymn-RoyCHANG/RCTelephonyForNetwork/raw/master/screenshot/wifi.jpeg "wifi")
![](https://github.com/Hymn-RoyCHANG/RCTelephonyForNetwork/raw/master/screenshot/2G.jpeg "2G")
![](https://github.com/Hymn-RoyCHANG/RCTelephonyForNetwork/raw/master/screenshot/3G.jpeg "3G")

# MIT License

Copyright (c) 2017 Roy CHANG

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
