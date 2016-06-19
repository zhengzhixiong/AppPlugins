#import <Cordova/CDV.h>
#import "AsyncUdpSocket.h"
#import <CommonCrypto/CommonDigest.h>
#import "GCDAsyncUdpSocket.h"
#import "TcpCommand.h"
#define FileHashDefaultChunkSizeForReadingData 1024*8 // 8K
@interface JmaxAppPlugin : CDVPlugin {
    //     NSString *host;
    //     int port;
    //     long tag;
    //     AsyncUdpSocket *udpSocket;
    //
    //     Byte cmdType;
    //     NSData* cmdResult;
    //    CDVInvokedUrlCommand *command;
    
}
-(void)test:(CDVInvokedUrlCommand*)command;

//实例方法
-(void) echo:(CDVInvokedUrlCommand *) command;

- (void)myPluginMethod:(CDVInvokedUrlCommand*)command;


//初始化本地socket服务
-(void)initServer:(CDVInvokedUrlCommand*)command;
//读取网络配置参数
-(void) readNetConfig:(CDVInvokedUrlCommand *)command;
//场景控制
-(void) controlScene:(CDVInvokedUrlCommand *)command;
//灯光控制
-(void) controlLight:(CDVInvokedUrlCommand *)command;
//灯光状态读取
-(void) readLightStatus:(CDVInvokedUrlCommand *)command;
//窗帘控制
-(void) controlCurtain:(CDVInvokedUrlCommand *)command;
//窗帘状态读取
-(void) readCurtainStatus:(CDVInvokedUrlCommand *)command;
//中央空调控制
-(void) controlAir:(CDVInvokedUrlCommand *)command;
//中央空调状态
-(void) readAirStatus:(CDVInvokedUrlCommand *)command;
//新风控制
-(void) controlFresh:(CDVInvokedUrlCommand *)command;
//地暖控制
-(void) controlFheat:(CDVInvokedUrlCommand *)command;
//布防控制
-(void) controlDef:(CDVInvokedUrlCommand *)command;
//防区状态读取
-(void) readDefenceStatus:(CDVInvokedUrlCommand *)command;
//开关／电器控制
-(void) controlSwitch:(CDVInvokedUrlCommand *)command;
//开关／电器状态读取
-(void) readSwitchStatus:(CDVInvokedUrlCommand *)command;
//红外设备：电视／机顶盒／红外空调 控制
-(void) controlInfrared:(CDVInvokedUrlCommand *)command;
//门锁控制
-(void) controlDoorLock:(CDVInvokedUrlCommand *)command;
//门锁状态读取
-(void) readDoorLock:(CDVInvokedUrlCommand *)command;
//设置门锁临时密码
-(void) setDoorPwd:(CDVInvokedUrlCommand *)command;
//对码控制
-(void) checkControl:(CDVInvokedUrlCommand *)command;

-(Boolean) checkControlAction:(Byte) action;
//清除配置
-(void) clearConfig:(CDVInvokedUrlCommand *)command;
//场景配置
-(void) sceneConfig:(CDVInvokedUrlCommand *)command;
//网关测试
-(void) networkTest:(CDVInvokedUrlCommand *)command;
//定时配置
-(void) timeTask:(CDVInvokedUrlCommand *)command;
//设置设备sn号
-(void) setSn:(CDVInvokedUrlCommand *)command;
//设置网络参数
-(void) setNetConfig:(CDVInvokedUrlCommand *)command;
//设置设备绑定
-(void) setDeviceBand:(CDVInvokedUrlCommand *)command;
//读取设备绑定
-(void) readDeviceBand:(CDVInvokedUrlCommand *)command;
//开始设备绑定
-(void) startDeviceBand:(CDVInvokedUrlCommand *)command;
//测试设备绑定是否成功
-(void) testDeviceBand:(CDVInvokedUrlCommand *)command;
//读取设备
-(void) readDeviceInfo:(CDVInvokedUrlCommand *)command;
//删除设备
-(void) deleteDeviceInfo:(CDVInvokedUrlCommand *)command;
//读取软件模块版本
-(void) readModuleSoft:(CDVInvokedUrlCommand *)command;
//重启设备
-(void) reboot:(CDVInvokedUrlCommand *)command;
//场景配置
-(void) sceneListConfig:(CDVInvokedUrlCommand *)command;
//读取设备信息
-(void) readDeviceInfos:(CDVInvokedUrlCommand *)command;
//getLocalAddress
-(void) getLocalAddr:(CDVInvokedUrlCommand *)command;
//计算字符串的MD5值，
+(NSString*)getmd5WithString:(NSString*)string;
//check byte
+(void)getCheckByte:(Byte[])bytes sizeParam:(int)size;
@end
