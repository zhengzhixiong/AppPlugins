#import "JmaxAppPlugin.h"
#import "Cordova/CDV.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
static int timeout = 300;
static NSString *host;
static int port;
static long tag;
static AsyncUdpSocket *udpSocket;
static int localPort;
static Byte cmdType;
static NSData *cmdResult;


@implementation JmaxAppPlugin
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    
    //    NSLog(@"----------");
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    
    //    NSLog(@"-----err-----");
}
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"didreceive");
    //    Byte *testByte = (Byte *)[data bytes];
    //    for(int i=0;i<[data length];i++)
    //        printf("%#x ",testByte[i]);
    //    printf("\n");
    cmdResult = data;
    //must no can everytime recieved;
    //    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];
    //    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    return NO;
}
/**
 * Called if an error occurs while trying to receive a requested datagram.
 * This is generally due to a timeout, but could potentially be something else if some kind of OS error occurred.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
}

/**
 * Called when the socket is closed.
 * A socket is only closed if you explicitly call one of the close methods.
 **/
- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
}






-(NSString*)sendData:(NSString*) host host:(int) port {
    udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    [udpSocket enableBroadcast:YES error:nil];
    NSError *error = nil;
    
    if (![udpSocket bindToPort:16000 error:&error])
    {
        NSLog(@"Error binding: %@", error);
        //return;
    }
    //    [udpSocket receiveWithTimeout:-1 tag:0];
    //    NSLog(@"Ready");
    
    //send
    NSLog(@"send");
    //    NSString *host = @"192.168.1.104";
    //    int port = 3001;
    //    NSString *msg = @"1234567890";
    
    
    //    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    //    0xae,0xd0,0x6,0x49,0x1,0xce
    Byte byte[] = {0xAE,0xD0,0x06,0x49,0x01,0xce};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    return  @"ok";
}


-(void)test:(CDVInvokedUrlCommand*)command {
    NSLog(@"call");
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) echo:(CDVInvokedUrlCommand *) command
{
    NSLog(@"echo");
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];
    //    if (echo != nil && [echo length] > 0)
    //    {
    //        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    //    }
    //    else
    //    {
    //        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    //    }
    
    //    echo = [self sendData:@"192.168.1.107" host:3001];
    echo = [self sendData:@"192.168.1.112" host:3052];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    //    NSLog(@"ok");
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

//线程处理
- (void)myPluginMethod:(CDVInvokedUrlCommand*)command
{
    NSLog(@"threadcall");
    // Check command.arguments here.
    [self.commandDelegate runInBackground:^{
        NSString* payload = [command.arguments objectAtIndex:0];
        // Some blocking logic...
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:payload];
        NSLog(@"%@",payload);
        //----
        
        // The sendPluginResult method is thread-safe.
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

//init server //初始化本地socket服务
-(void) initServer:(CDVInvokedUrlCommand *)command {
    udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    
    [udpSocket enableBroadcast:YES error:nil];
    NSError *error = nil;
    localPort = [(NSNumber *)[command.arguments objectAtIndex:6] intValue];
    if (![udpSocket bindToPort:localPort error:&error])
    {
        NSLog(@"Error binding: %@", error);
        //return;
    }else {
        NSLog(@"init server succed");
    }
    [udpSocket receiveWithTimeout:-1 tag:0];
    
    //4 smartgateIp 5 smartgatePort
    host = [command.arguments objectAtIndex:4];
    port = [(NSNumber *)[command.arguments objectAtIndex:5] intValue];
    
    NSLog(@"UDP IS Ready,host=%@,port=%d",host,port);
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

//readNetConfig //读取网络配置参数
-(void) readNetConfig:(CDVInvokedUrlCommand *)command {
    //    NSError *error = nil;
    //    if (![udpSocket bindToPort:localPort error:&error])
    //    {
    //        NSLog(@"Error binding: %@", error);
    //        //return;
    //    }
    Byte bytes[] = {0xAE,0xD0,0x06,0x49,0x01,0xca};
    cmdType = bytes[3];
    NSLog(@"cmdType======%#x",cmdType);
    //    NSLog(@"%d",bytes[5]);
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    //    NSLog(@"%d",bytes[5]);
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    //     NSLog(@"readNetConfig,host=%@,port=%d",host,port);
    //    command = command;
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    //    [self returnResult:command sendBytes:bytes];
    [self.commandDelegate runInBackground:^{
        NSString* result = nil;
        NSString* key = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSLog(@"cmdType=%#x",cmdType);
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
            if (cmdResult!=nil) {
                Byte *returnByte = (Byte *)[cmdResult bytes];
                //            NSLog(@"handler type=%#x\n",cmdType);
                if (cmdType == returnByte[3]) {
                    key = [NSString stringWithFormat:@"%d-%d-%d-%d",[self byte2ToInt:returnByte[5] twoParam:returnByte[6]],returnByte[7],returnByte[8],[self byte2ToInt:returnByte[9] twoParam:returnByte[10]]];
                    result = [NSString stringWithFormat:@"{\"projectNo\":%d,\"buildingNo\":%d,\"unitNo\":%d,\"houseNo\":%d,\"localAddress\":\"%d.%d.%d.%d\",\"localPort\":%d,\"netWork\":\"%d.%d.%d.%d\",\"gateway\":\"%d.%d.%d.%d\",\"webAddress\":\"%d.%d.%d.%d\",\"webPort\":%d,\"udid\":\"%@\"}",[self byte2ToInt:returnByte[5] twoParam:returnByte[6]],returnByte[7],returnByte[8],[self byte2ToInt:returnByte[9] twoParam:returnByte[10]],returnByte[11],returnByte[12],returnByte[13],returnByte[14],
                              [self byte2ToInt:returnByte[15] twoParam:returnByte[16]],
                              returnByte[17],returnByte[18],returnByte[19],returnByte[20],
                              returnByte[21],returnByte[22],returnByte[23],returnByte[24],
                              returnByte[25],returnByte[26],returnByte[27],returnByte[28],
                              [self byte2ToInt:returnByte[29] twoParam:returnByte[30]],
                              [JmaxAppPlugin getmd5WithString:key]
                              ];
                }
            }else {
                result = @"";
            }
            
        }
        cmdResult = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
    
}

//场景控制
-(void) controlScene:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x07,0x01,0x01,0x01,0x00};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self returnResult:command sendBytes:bytes];
}

//灯光控制
-(void) controlLight:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x09,0x02,0x01,0x00,0x00,0x01,0x01};
    cmdType = bytes[3];
    //    int localPort = [(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    bytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    //    NSLog(@"controlLight,host=%@,port=%d",host,port);
    //        for(int i=0;i<[data length];i++)
    //            printf("%#x ",bytes[i]);
    //        printf("\n");
    Byte actionType = bytes[7];
    [self.commandDelegate runInBackground:^{
        NSString* result = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSLog(@"cmdType=%#x",cmdType);
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
            if (cmdResult!=nil) {
                Byte *returnByte = (Byte *)[cmdResult bytes];
                //            NSLog(@"handler type=%#x\n",cmdType);
                if (cmdType == returnByte[3]) {
                    result = actionType==returnByte[13]?@"true":@"false";
                }else {
                    result = @"false";
                }
            }else {
                result = @"false";
            }
            
        }
        cmdResult = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
//灯光状态读取
-(void) readLightStatus:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x08,0x82,0x01,0x01,0x00,0x00};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self.commandDelegate runInBackground:^{
        NSString* result = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSLog(@"cmdType=%#x",cmdType);
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
            if (cmdResult!=nil) {
                Byte *returnByte = (Byte *)[cmdResult bytes];
                //            NSLog(@"handler type=%#x\n",cmdType);
                if (cmdType == returnByte[3]) {
                    result = [NSString stringWithFormat:@"%d",returnByte[13]];;
                }else {
                    result = @"-2";
                }
            }else {
                result = @"-2";
            }
            
        }
        cmdResult = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

-(void) readLightStatus:(int)areaNo secondDeviceNo:(int)deviceNo {
    Byte bytes[] = {0xAE,0xD0,0x08,0x82,0x01,0x01,0x00,0x00};
    cmdType = bytes[3];
    bytes[5] = (Byte)areaNo;
    bytes[6] = (Byte)deviceNo;
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self.commandDelegate runInBackground:^{
        NSString* result = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSLog(@"cmdType=%#x",cmdType);
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
            if (cmdResult!=nil) {
                Byte *returnByte = (Byte *)[cmdResult bytes];
                //            NSLog(@"handler type=%#x\n",cmdType);
                if (cmdType == returnByte[3]) {
                    result = [NSString stringWithFormat:@"%d",returnByte[13]];;
                }else {
                    result = @"-2";
                }
            }else {
                result = @"-2";
            }
            
        }
    }];
}
//窗帘控制
-(void) controlCurtain:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x09,0x03,0x01,0x00,0x00,0x01,0x00};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    bytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    Byte actionType = bytes[7];
    [self.commandDelegate runInBackground:^{
        NSString* result = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSLog(@"cmdType=%#x",cmdType);
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
            if (cmdResult!=nil) {
                Byte *returnByte = (Byte *)[cmdResult bytes];
                //            NSLog(@"handler type=%#x\n",cmdType);
                if (cmdType == returnByte[3]) {
                    result = actionType==returnByte[13]?@"true":@"false";
                }else {
                    result = @"false";
                }
            }else {
                result = @"false";
            }
        }
        cmdResult = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
//窗帘状态读取
-(void) readCurtainStatus:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x08,0x83,0x01,0x01,0x00,0x01};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self returnResult:command sendBytes:bytes];
}
//中央空调控制
-(void) controlAir:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x0C,0x04,0x01,0x00,0x00,0x01,0x02,0x00,0x00,0x01};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    
    bytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
    bytes[8] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:5] intValue];
    bytes[9] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:6] intValue];
    bytes[10] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:7] intValue];
    
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    Byte actionType = bytes[7];
    [self.commandDelegate runInBackground:^{
        NSString* result = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSLog(@"cmdType=%#x",cmdType);
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
            if (cmdResult!=nil) {
                Byte *returnByte = (Byte *)[cmdResult bytes];
                if (cmdType == returnByte[3]) {
                    //zanshi mei you yi yi dui ying
                    result = actionType==returnByte[13]?@"true":@"false";
                }else {
                    result = @"false";
                }
            }else {
                result = @"false";
            }
        }
        cmdResult = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
//中央空调状态
-(void) readAirStatus:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x08,0x84,0x01,0x01,0x00,0x01};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self.commandDelegate runInBackground:^{
        NSString* result = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
//        NSLog(@"cmdType=%#x",cmdType);
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
            if (cmdResult!=nil) {
                Byte *returnByte = (Byte *)[cmdResult bytes];
                result = [NSString stringWithFormat:@"{\"mode\":%d,\"speed\":%d,\"temp\":%d,\"action\":%d}",              returnByte[14],
                          returnByte[15],
                          returnByte[16],
                          returnByte[13]
                          ];
            }else {
                result = @"{\"mode\":0,\"speed\":0,\"temp\":0,\"action\":-2}";
            }
        }
        cmdResult = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
//防区状态读取
-(void) readDefenceStatus:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x07,0x85,0x01,0x01};
    cmdType = bytes[3];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self returnResult:command sendBytes:bytes];
    
}
//开关／电器控制
-(void) controlSwitch:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x09,0x06,0x01,0x00,0x00,0x01,0x01};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    bytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    Byte actionType = bytes[7];
    [self.commandDelegate runInBackground:^{
        NSString* result = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSLog(@"cmdType=%#x",cmdType);
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
            if (cmdResult!=nil) {
                Byte *returnByte = (Byte *)[cmdResult bytes];
                //            NSLog(@"handler type=%#x\n",cmdType);
                if (cmdType == returnByte[3]) {
                    result = actionType==returnByte[13]?@"true":@"false";
                }else {
                    result = @"false";
                }
            }else {
                result = @"false";
            }
        }
        cmdResult = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
}
//开关／电器状态读取
-(void) readSwitchStatus:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x08,0x86,0x01,0x01,0x01,0x01};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    bytes[4] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
    //1 kaiguan 17 dianliang
    Byte actionType = bytes[4];
    //{"result":-2,"hz":0.0,"vmp":0.0,"ma":0.0,"pf":0.0,"ac":0.0,"ap":0.0,"checkHz":0,"checkVmp":0,"checkMa":0,"checkPf":0,"checkAc":0}
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self.commandDelegate runInBackground:^{
        NSString* result = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        //        NSLog(@"cmdType=%#x",cmdType);
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
            if (cmdResult!=nil) {
                Byte *returnByte = (Byte *)[cmdResult bytes];
                if (actionType==0x01&&returnByte[4]==0x02) {
                    result = [NSString stringWithFormat:@"{\"result\":%d,\"hz\":0.0,\"vmp\":0.0,\"ma\":0.0,\"pf\":0.0,\"ac\":0.0,\"ap\":0.0,\"checkHz\":0,\"checkVmp\":0,\"checkMa\":0,\"checkPf\":0,\"checkAc\":0}",
                              returnByte[13]
                              ];
                }else {
                    //pinglv
                    double hz = 0.00;
                    if (returnByte[27] == 255) {
                        returnByte[27] = 100;
                    }
                    hz = 1.0*(returnByte[13] * 256 + returnByte[14])*4000* returnByte[27]/32768/100;
                    //dianya
                    // 电压计算
                    double vmp = 0.00;
                    if (returnByte[28] == 255) {
                        returnByte[28] = 100;
                    }
                    vmp = 1.0*(returnByte[15] * 256 + returnByte[16])* 375.25 * returnByte[28]/ 65536 / 100;
                    //dianliu
                    // 电流计算
                    double ma = 0.00;
                    if (returnByte[29] == 255) {
                        returnByte[29] = 100;
                    }
                    ma = 1.0*(returnByte[17] * 256 + returnByte[18]) * 250
                            * returnByte[29]/ 65536 / 100;
                    //gonglvyinshu
                    double pf = 0.00;
                    if (returnByte[30] == 255) {
                        returnByte[30] = 100;
                    }
                    pf = 1.0*(returnByte[19]* 256 + returnByte[20])
                            * returnByte[30]/ 32768 / 100;
                    if (pf >= 1.00) {
                        pf = 1.00;
                    }
                    //yougonggonlv
                    // 有功功率计算
                    double ac = 0.00;
                    if (returnByte[31] == 255) {
                        returnByte[31] = 100;
                    }
                    ac = 1.0*((returnByte[21]* 256 + returnByte[22])* 375.25 * 250 * returnByte[31])/ 32768 / 100;
                    //yougongdianliang
                    // 有功电量
                    float ap = (float) (((returnByte[23] << 24)
                                                 + (returnByte[24] << 16) + (returnByte[25] << 8) + returnByte[26])
                                                * 375.25 * 250 * returnByte[31] / 32768 / 100 / 1000);
                    result = [NSString stringWithFormat:@"{\"result\":1,\"hz\":%.1f,\"vmp\":%.1f,\"ma\":%.3f,\"pf\":%.2f,\"ac\":%.1f,\"ap\":%.2f,\"checkHz\":0,\"checkVmp\":0,\"checkMa\":0,\"checkPf\":0,\"checkAc\":0}",hz,vmp,ma,pf,ac,ap];
                }
                
            }else {
                result = @"{\"result\":-2,\"hz\":0.0,\"vmp\":0.0,\"ma\":0.0,\"pf\":0.0,\"ac\":0.0,\"ap\":0.0,\"checkHz\":0,\"checkVmp\":0,\"checkMa\":0,\"checkPf\":0,\"checkAc\":0}";
            }
        }
        cmdResult = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
//红外设备：电视／机顶盒／红外空调 控制
-(void) controlInfrared:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x09,0x07,0x01,0x00,0x00,0x01,0x01};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    bytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    Byte actionType = bytes[7];
    [self.commandDelegate runInBackground:^{
        NSString* result = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSLog(@"cmdType=%#x",cmdType);
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=2000) {
            if (cmdResult!=nil) {
                Byte *returnByte = (Byte *)[cmdResult bytes];
                //            NSLog(@"handler type=%#x\n",cmdType);
                if (cmdType == returnByte[3]) {
                    result = actionType==returnByte[13]?@"true":@"false";
                }else {
                    result = @"false";
                }
            }else {
                result = @"false";
            }
        }
        cmdResult = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
}
//门锁控制
-(void) controlDoorLock:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x09,0x08,0x01,0x00,0x00,0x01,0x01};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    bytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    Byte actionType = bytes[7];
    [self.commandDelegate runInBackground:^{
        NSString* result = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSLog(@"cmdType=%#x",cmdType);
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=2000) {
            if (cmdResult!=nil) {
                Byte *returnByte = (Byte *)[cmdResult bytes];
                //            NSLog(@"handler type=%#x\n",cmdType);
                if (cmdType == returnByte[3]) {
                    result = actionType==returnByte[13]?@"true":@"false";
                }else {
                    result = @"false";
                }
            }else {
                result = @"false";
            }
        }
        cmdResult = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
//门锁状态读取
-(void) readDoorLock:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x08,0x88,0x01,0x00,0x00,0x00};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self returnResult:command sendBytes:bytes];
}
//对码控制
-(void) checkControl:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x07,0x41,0x01,0x00,0x00};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self.commandDelegate runInBackground:^{
        NSString* result = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSLog(@"cmdType=%#x",cmdType);
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=2000) {
            if (cmdResult!=nil) {
                Byte *returnByte = (Byte *)[cmdResult bytes];
                //            NSLog(@"handler type=%#x\n",cmdType);
                if (0x02 == returnByte[4]) {
                    result = @"true";
                }else {
                    result = @"false";
                }
            }else {
                result = @"false";
            }
        }
        cmdResult = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
-(Boolean) checkControlAction:(Byte) action {
    Byte bytes[] = {0xAE,0xD0,0x07,0x41,0x01,0x00,0x00};
    cmdType = bytes[3];
    bytes[5] = action;
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    Boolean result = false;
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    //        NSLog(@"cmdType=%#x",cmdType);
    while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
        if (cmdResult!=nil) {
            Byte *returnByte = (Byte *)[cmdResult bytes];
            //            NSLog(@"handler type=%#x\n",cmdType);
            if (0x02 == returnByte[4]) {
                result = true;
            }
        }
    }
    cmdResult = nil;
    return result;
}
//清除配置
-(void) clearConfig:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x06,0x42,0x01,0x00};
    cmdType = bytes[3];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self returnResult:command sendBytes:bytes];
}
//场景配置
-(void) sceneConfig:(CDVInvokedUrlCommand *)command {
    int deviceType = [(NSNumber *)[command.arguments objectAtIndex:4] intValue];
    Byte airbytes[] = {0xAE,0xD0,0x0E,0x43,0x01,0x00,0x00,0x04,0x01,0x01,0x00,0x00,0x04,0x00};
    Byte otherbytes[] = {0xAE,0xD0,0x0B,0x43,0x01,0x00,0x00,0x04,0x01,0x00,0x00};
    if (deviceType==4) {
        //air
        airbytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
        airbytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
        //            airbytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
        airbytes[8] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:5] intValue];
        
        airbytes[9] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:7] intValue];
        airbytes[10] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:8] intValue];
        airbytes[11] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:9] intValue];
        airbytes[12] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:10] intValue];
        
        cmdType = airbytes[3];
        NSData *data1 = [[NSData alloc] initWithBytes:airbytes length:sizeof(airbytes)];
        [udpSocket sendData:data1 toHost:host port:port withTimeout:-1 tag:tag];
        [self returnResult:command sendBytes:airbytes];
    }else {
        otherbytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
        otherbytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
        otherbytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
        otherbytes[8] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:5] intValue];
        otherbytes[9] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:6] intValue];
        
        cmdType = otherbytes[3];
        NSData *data2 = [[NSData alloc] initWithBytes:otherbytes length:sizeof(otherbytes)];
        [udpSocket sendData:data2 toHost:host port:port withTimeout:-1 tag:tag];
        [self returnResult:command sendBytes:otherbytes];
    }
}
//网关测试
-(void) networkTest:(CDVInvokedUrlCommand *)command {
    
}
//定时配置
-(void) timeTask:(CDVInvokedUrlCommand *)command {
    
}
//设置设备sn号
-(void) setSn:(CDVInvokedUrlCommand *)command {
    
}
//设置网络参数
-(void) setNetConfig:(CDVInvokedUrlCommand *)command {
    
}
//设置设备绑定
-(void) setDeviceBand:(CDVInvokedUrlCommand *)command {
    
}
//读取设备绑定
-(void) readDeviceBand:(CDVInvokedUrlCommand *)command {
    
}
//开始test设备绑定
-(void) startDeviceBand:(CDVInvokedUrlCommand *)command {
    NSString* result = @"false";
    if ([self checkControlAction:0x00]) {
        sleep(0.5);
        int areaNo = [(NSNumber *)[command.arguments objectAtIndex:2] intValue];
        int deviceNo = [(NSNumber *)[command.arguments objectAtIndex:3] intValue];
        int deviceType = [(NSNumber *)[command.arguments objectAtIndex:4] intValue];
        int actionType = [(NSNumber *)[command.arguments objectAtIndex:5] intValue];
        switch (deviceType) {
            case 0:
                //light
                [self controlLight:command];
                break;
            case 1:
                //curtain
                [self controlCurtain:command];
                break;
            case 2:
                [self controlSwitch:command];
                break;
            case 3:
                [self controlInfrared:command];
                break;
            case 4:
                [self controlAir:command];
                break;
            case 5:
                [self controlDoorLock:command];
                break;
            default:
                break;
        }
        
    }
    
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
//测试设备绑定是否成功
-(void) testDeviceBand:(CDVInvokedUrlCommand *)command {
    
}
//读取设备
-(void) readDeviceInfo:(CDVInvokedUrlCommand *)command {
    
}
//删除设备
-(void) deleteDeviceInfo:(CDVInvokedUrlCommand *)command {
    
}
//读取软件模块版本
-(void) readModuleSoft:(CDVInvokedUrlCommand *)command {
    
}
//重启设备
-(void) reboot:(CDVInvokedUrlCommand *)command {
    
}
//场景配置
-(void) sceneListConfig:(CDVInvokedUrlCommand *)command {
    
}
//读取设备信息
-(void) readDeviceInfos:(CDVInvokedUrlCommand *)command {
    //used
    //设备类型,区域id,设备id,读取类型;设备类型,区域id,设备id,读取类型;
    NSString* result = @"";
    //[{"deviceType":"0","roomZoneNo":1,"deviceNo":1,"obj":-2},{"deviceType":"1","roomZoneNo":1,"deviceNo":1,"obj":-2},{"deviceType":"2","roomZoneNo":1,"deviceNo":1,"obj":{"result":-2,"hz":0.0,"vmp":0.0,"ma":0.0,"pf":0.0,"ac":0.0,"ap":0.0,"checkHz":0,"checkVmp":0,"checkMa":0,"checkPf":0,"checkAc":0}},{"deviceType":"2","roomZoneNo":1,"deviceNo":1,"obj":{"result":-2,"hz":0.0,"vmp":0.0,"ma":0.0,"pf":0.0,"ac":0.0,"ap":0.0,"checkHz":0,"checkVmp":0,"checkMa":0,"checkPf":0,"checkAc":0}},{"deviceType":"4","roomZoneNo":1,"deviceNo":1,"obj":{"mode":0,"speed":0,"temp":0,"action":-2}},{"deviceType":"5","roomZoneNo":1,"deviceNo":1,"obj":-2}]

    //used
    //0:ip 1:port 2:data
    //设备类型,区域id,设备id,读取类型;设备类型,区域id,设备id,读取类型;
    NSString *data = [command.arguments objectAtIndex:2];
    NSArray *aArray = [data componentsSeparatedByString:@";"];
    int count = aArray.count;//减少调用次数
    if(count>0) {
        for(int i=0; i<count; i++){
            //NSLog(@"%i-%@", i, [aArray objectAtIndex:i]);
            NSArray *oneArray =  [[aArray objectAtIndex:i]componentsSeparatedByString:@","];
            int deviceType = [oneArray objectAtIndex:0];
            //0：灯光；1：窗帘；2：开关；3：红外设备；4：中央空调；5：门锁；6:电视；7：红外空调
            switch(deviceType) {
                case 0:
//                    self readLightStatus:<#(CDVInvokedUrlCommand *)#>
                    break;
                case 1:
                    
                    break;
                case 2:
                    
                    break;
            }
        }
    }
    
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}
//获取本地地址
-(void) getLocalAddr:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[self getIPAddress]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

//return method
-(void)returnResult:(CDVInvokedUrlCommand*)command sendBytes:(Byte[])bytes {
    [self.commandDelegate runInBackground:^{
        printf("returnResultHanlder");
        Byte cmdType = bytes[3];
        NSString* result = nil;
        NSString* key = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSLog(@"cmdType=%#x",cmdType);
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
            if (cmdResult!=nil) {
                Byte *returnByte = (Byte *)[cmdResult bytes];
                //            NSLog(@"handler type=%#x\n",cmdType);
                if (cmdType == returnByte[3]) {
                    switch (cmdType) {
                        case 0x49:
                            key = [NSString stringWithFormat:@"%d-%d-%d-%d",[self byte2ToInt:returnByte[5] twoParam:returnByte[6]],returnByte[7],returnByte[8],[self byte2ToInt:returnByte[9] twoParam:returnByte[10]]];
                            result = [NSString stringWithFormat:@"{\"projectNo\":%d,\"buildingNo\":%d,\"unitNo\":%d,\"houseNo\":%d,\"localAddress\":\"%d.%d.%d.%d\",\"localPort\":%d,\"netWork\":\"%d.%d.%d.%d\",\"gateway\":\"%d.%d.%d.%d\",\"webAddress\":\"%d.%d.%d.%d\",\"webPort\":%d,\"udid\":\"%@\"}",[self byte2ToInt:returnByte[5] twoParam:returnByte[6]],returnByte[7],returnByte[8],[self byte2ToInt:returnByte[9] twoParam:returnByte[10]],returnByte[11],returnByte[12],returnByte[13],returnByte[14],
                                      [self byte2ToInt:returnByte[15] twoParam:returnByte[16]],
                                      returnByte[17],returnByte[18],returnByte[19],returnByte[20],
                                      returnByte[21],returnByte[22],returnByte[23],returnByte[24],
                                      returnByte[25],returnByte[26],returnByte[27],returnByte[28],
                                      [self byte2ToInt:returnByte[29] twoParam:returnByte[30]],
                                      [JmaxAppPlugin getmd5WithString:key]
                                      ];
                            //                        result = @"{\"projectNo\":%d,\"buildingNo\":2,\"unitNo\":2,\"houseNo\":3,\"localAddress\":\"192.168.1.112\",\"localPort\":3052,\"netWork\":\"255.255.255.0\",\"gateway\":\"192.168.1.1\",\"webAddress\":\"120.55.88.51\",\"webPort\":16000,\"udid\":\"1F8210111D16BAE5D636845BBA93668B\"}";
                            break;
                        case 0x02:
                            result = bytes[7]==returnByte[13]?@"true":@"false";
                            break;
                        case 0x82:
                            result = [NSString stringWithFormat:@"%d",returnByte[13]];
                            break;
                        default:
                            break;
                    }
                }
                //            Byte *testByte = (Byte *)[cmdResult bytes];
                //            for(int i=0;i<[cmdResult length];i++)
                //                printf("%#x ",testByte[i]);
                //            break;
            }else {
                result = @"false";
            }
            
        }
        cmdResult = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        //    NSLog(@"ok");
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
}

-(int) byte2ToInt:(Byte)one twoParam:(Byte) two {
    int value;
    value = (int) ((one&0xFF)<<8
                   | ((two&0xFF)));
    return value;
}

+ (NSString*)getmd5WithString:(NSString *)string
{
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

+(void)getCheckByte:(Byte[])bytes sizeParam:(int)size {
    int check = 0;
    //    int size = sizeof(bytes);
    for(int i=0;i<size-1;i++) {
        check = check+bytes[i]&0xff;
    }
    check = check&0xff;
    bytes[size-1] = check;
    NSLog(@"size=%d----%d",size,bytes[size-1] );
}
- (NSString *)getIPAddress
{
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}
@end