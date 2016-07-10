#import "JmaxAppPlugin.h"
#import "Cordova/CDV.h"
#import "GCDAsyncSocket.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include "TcpCommand.h"
static int timeout = 300;
static NSString *host;
static int gateType;
static int port;
static long tag;
static long SEND_TAG;
static long RECE_TAG;
static GCDAsyncUdpSocket *gcdUdpSocket;
static GCDAsyncSocket *tcpSocket;
static int localPort;
static Byte cmdType;
static NSData *cmdResult;
static NSMutableArray *readDeviceStatusArray;
static NSMutableArray *sceneConfigArray;
static NSString *tcpCmdType;
@implementation JmaxAppPlugin

-(void)socket:(GCDAsyncSocket *)socket didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog([NSString stringWithFormat:@"连接到:%@",host]);
    [socket readDataWithTimeout:-1 tag:0];
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    // You could add checks here
    NSLog(@"-----GCDAsyncUdpSocket didSendDataWithTag-----tag=%ld-cmdType=%#x",tag,cmdType);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    // You could add checks here
    NSLog(@"-----GCDAsyncUdpSocket didNotSendDataWithTag-----tag=%ld",tag);
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    
    NSLog(@"cmdtype=%#x  didreceive",cmdType);
        Byte *testByte = (Byte *)[data bytes];
        for(int i=0;i<[data length];i++)
            printf("%#x ",testByte[i]);
        printf("\n");
    if (cmdType==0xff) {
        [readDeviceStatusArray addObject:data];
    }else {
        cmdResult = data;
    }
    
    //must no can everytime recieved;
    //    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];
    //    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}










-(NSString*)sendData:(NSString*) host host:(int) port {
    if (gcdUdpSocket==nil) {
        gcdUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        gcdUdpSocket.delegate=self;
        [gcdUdpSocket enableBroadcast:YES error:nil];
        NSError *error = nil;
        
        if (![gcdUdpSocket bindToPort:16000 error:&error])
        {
            NSLog(@"bindToPort error");
        }
        if (![gcdUdpSocket beginReceiving:&error])
        {
            NSLog(@"beginReceiving error");
        }
        
    }

   
    Byte byte[] = {0xAE,0xD0,0x06,0x49,0x01,0xce};
    NSData *data = [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
    [gcdUdpSocket connectToHost: host onPort:port error:nil];
    [gcdUdpSocket sendData:data withTimeout:-1 tag:2];
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

///////////////tcp//////////////

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    NSLog(@"socketDidSecure:%p", sock);
//    self.receView.text = [NSString stringWithFormat:@"%@\r\n-->recived:%@\r\n",self.receView.text,@"Connected + Secure"];
    
    NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", @"192.168.1.105"];
    NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [sock writeData:requestData withTimeout:-1 tag:0];
    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
    NSString *ip = [sock connectedHost];
    
    uint16_t port = [sock connectedPort];
    int length = [data length];
    Byte arrayBytes[length-8];
    Byte *testByte = (Byte *)[data bytes];
    for(int i=4;i<length-4;i++)
    {
        printf("%#x ",testByte[i]);
        //        if (i!=0||i!=1||i!=length-1||i!=length-2) {
        arrayBytes[i-4]=testByte[i];
        //        }
    }
    NSData *rdata = [[NSData alloc] initWithBytes:arrayBytes length:length-8];
    cmdResult = rdata;
//    printf("\n");
    NSString *s = [[NSString alloc]initWithData:rdata encoding:NSUTF8StringEncoding];
//    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//    s = [s stringByTrimmingCharactersInSet:whitespace];
    NSLog(@"%@",s);
//    cmdResult = [s dataUsingEncoding:NSUTF8StringEncoding];
    
//    id jsonObject = [NSJSONSerialization JSONObjectWithData:rdata options:NSJSONReadingMutableContainers error:nil];
//    BOOL rs = [jsonObject isKindOfClass:[NSDictionary class]];
    NSLog(@"_______");
//
//    NSString *s = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
//    UIAlertView* av=[[UIAlertView alloc]initWithTitle:@"接收数据" message:s delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil,nil];
//    
//    [av show];
//    
//    
//    [sock readDataWithTimeout:-1 tag:1];//持续接收服务端放回的数据
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
}

////////////tcp////////////////

//init server //初始化本地socket服务
-(void) initServer:(CDVInvokedUrlCommand *)command {
    gateType = [[command.arguments objectAtIndex:0] intValue];
    //4 smartgateIp 5 smartgatePort
    host = [command.arguments objectAtIndex:4];
    port = [(NSNumber *)[command.arguments objectAtIndex:5] intValue];
    if(gateType==0) {
        if (gcdUdpSocket==nil|| [gcdUdpSocket isClosed]) {
            gcdUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
            gcdUdpSocket.delegate=self;
            [gcdUdpSocket enableBroadcast:YES error:nil];
            NSError *error = nil;
            
            if (![gcdUdpSocket bindToPort:16000 error:&error])
            {
                NSLog(@"bindToPort error");
            }
            if (![gcdUdpSocket beginReceiving:&error])
            {
                NSLog(@"beginReceiving error");
            }
            
        }
        NSLog(@"UDP IS Ready,host=%@,port=%d",host,port);
    }
    else
    {

    }
    
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"true"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) connectTcp {
    tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    if (![tcpSocket connectToHost:host onPort:port error:nil])
    {
        NSLog(@"tcp connecting: error");
    }else {
        NSLog(@"tcp connecting......");
    }
}

//readNetConfig //读取网络配置参数
-(void) readNetConfig:(CDVInvokedUrlCommand *)command {
    //    NSError *error = nil;
    //    if (![udpSocket bindToPort:localPort error:&error])
    //    {
    //        NSLog(@"Error binding: %@", error);
    //        //return;
    //    }
    
    if (gateType==0) {
        Byte bytes[] = {0xAE,0xD0,0x06,0x49,0x01,0xca};
        cmdType = bytes[3];
        NSLog(@"cmdType======%#x",cmdType);
        //    NSLog(@"%d",bytes[5]);
        [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
        //    NSLog(@"%d",bytes[5]);
        NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
        //     NSLog(@"readNetConfig,host=%@,port=%d",host,port);
        //    command = command;
        [gcdUdpSocket sendData:data toHost:@"255.255.255.255" port:port withTimeout:-1 tag:tag];
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
                        break;
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
    }else {
        [self connectTcp];
        tcpCmdType = @"readNet";
        NSData *requestData = [TcpCommand getReadNetCmd:SEND_TAG++];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
    
    
    
}
/////////tcp send
-(void)sendTcpData:(NSData*)data {
    NSString *s = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"send content=%@",s);
    int length = data.length+8;
    Byte bytes[length];
    bytes[0] = 0x5A;
    bytes[1] = 0xA5;
    int headLength = data.length+4;
    bytes[2] = (headLength>>8&0xff);
    bytes[3] = (headLength&0xff);
    Byte *testByte = (Byte *)[data bytes];
    int check = headLength;
    for(int i=0;i<[data length];i++)
    {
//        printf("%#x ",testByte[i]);
        bytes[i+4]=testByte[i];
        check = check +(testByte[i]&0xff);
    }
    
    bytes[length-4] = (check>>8)&0xff;
    bytes[length-3] = check&0xff;
    
    bytes[length-1] = 0x5A;
    bytes[length-2] = 0xA5;
    
    NSData *data2 = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [tcpSocket writeData:data2 withTimeout:-1. tag:0];
}
-(void)returnTcpResult:(CDVInvokedUrlCommand*)command tag:(long)tag {
    [self.commandDelegate runInBackground:^{
        printf("returnTcpResultHanlder");
        NSString* result = nil;
        NSString* key = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
            if (cmdResult!=nil) {
                id jsonObject = [NSJSONSerialization JSONObjectWithData:cmdResult options:NSJSONReadingMutableContainers error:nil];
                BOOL rs = [jsonObject isKindOfClass:[NSDictionary class]];
                if ([@"readNet" isEqualToString:tcpCmdType]) {
//                    {"localIP":"192.168.1.120","localPort":3000,"gateway":"192.168.1.1","netmask":"255.255.255.0","serverIP":"121.43.226.8","serverPort":15999,"result":"ok","devSN":"1-123-456-120","flag":0}
//                    result = [[NSString alloc]initWithData:cmdResult encoding:NSUTF8StringEncoding];
//                    NSString *s = [[NSString alloc]initWithData:cmdResult encoding:NSUTF8StringEncoding];
//                    NSLog(@"-------%@",s);
                    if (rs) {
                        NSDictionary *jsonDictionary = (NSDictionary*)jsonObject;
                        result = [NSString stringWithFormat:@"{\"projectNo\":0,\"buildingNo\":0,\"unitNo\":0,\"houseNo\":0,\"localAddress\":\"%@\",\"localPort\":%@,\"netWork\":\"%@\",\"gateway\":\"%@\",\"webAddress\":\"%@\",\"webPort\":%@,\"udid\":\"%@\"}",[jsonDictionary valueForKey:@"localIP"],[jsonDictionary valueForKey:@"localPort"],[jsonDictionary valueForKey:@"netmask"],[jsonDictionary valueForKey:@"gateway"],
                                  [jsonDictionary valueForKey:@"serverIP"],
                                  [jsonDictionary valueForKey:@"serverPort"],
                                  [JmaxAppPlugin getmd5WithString:[jsonDictionary valueForKey:@"devSN"]]
                                  ];
                        break;
                    }
                    
                }else if([@"readDevList" isEqualToString:tcpCmdType]){
                    //read dev status readDevList
                    
                    if (rs) {
                        NSDictionary *jsonDictionary = (NSDictionary*)jsonObject;
                        NSArray *devList = [jsonDictionary valueForKey:@"devList"];
                        result = [TcpCommand getReadDevListResult:devList];
                        NSLog(@"%@",result);
                        break;
                    }
                    
                    
                }
                else{
//                    {"result":"no","devSN":"1-123-456-120","flag":15}
                    if (rs) {
                        NSDictionary *jsonDictionary = (NSDictionary*)jsonObject;
                        result = [@"ok" isEqualToString:[jsonDictionary valueForKey:@"result"]]?@"true":@"false";
                    }
                }
              
            }else {
              result = @"false";
            }
            
        }
        cmdResult = nil;
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
}
/////////
//场景控制
-(void) controlScene:(CDVInvokedUrlCommand *)command {
    if (gateType==0) {
        Byte bytes[] = {0xAE,0xD0,0x07,0x01,0x01,0x01,0x00};
        cmdType = bytes[3];
        bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
        [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
        NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
        [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
        [self returnResult:command sendBytes:bytes];
    }
    else
    {
        [self connectTcp];
        tcpCmdType = @"ctrlScene";
        NSData *requestData = [TcpCommand getCtrlSceneCmd:SEND_TAG++ sceneNo:[[command.arguments objectAtIndex:2] intValue]];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
    
}

//灯光控制
-(void) controlLight:(CDVInvokedUrlCommand *)command {
    if (gateType==0) {
        Byte bytes[] = {0xAE,0xD0,0x09,0x02,0x01,0x00,0x00,0x01,0x01};
        cmdType = bytes[3];
        //    int localPort = [(NSNumber *)[command.arguments objectAtIndex:2] intValue];
        bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
        bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
        bytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
        [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
        NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
        [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
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
                        result = @"true";
                        break;
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
    }else
    {
        [self connectTcp];
        tcpCmdType = @"ctrlLight";
        NSData *requestData = [TcpCommand getCtrlLightCmd:SEND_TAG++ areaNo:[[command.arguments objectAtIndex:2] intValue] devNo:[[command.arguments objectAtIndex:3] intValue] status:[[command.arguments objectAtIndex:4] intValue]];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
   
}
//灯光状态读取
-(void) readLightStatus:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x08,0x82,0x01,0x01,0x00,0x00};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
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

-(NSString*) readLightStatus:(int) areaNo secondDeviceNo:(int) deviceNo{
    Byte bytes[] = {0xAE,0xD0,0x08,0x82,0x01,0x00,0x00,0x00};
//    cmdType = bytes[3];
    bytes[5] = (Byte)areaNo;
    bytes[6] = (Byte)deviceNo;
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
//        NSString* result = nil;
//        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
//        NSLog(@"readlightstatus cmdType=%#x",cmdType);
//        while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
//            if (cmdResult!=nil) {
//                Byte *returnByte = (Byte *)[cmdResult bytes];
//                //            NSLog(@"handler type=%#x\n",cmdType);
//                if (cmdType == returnByte[3]) {
//                    result = [NSString stringWithFormat:@"%d",returnByte[13]];;
//                    NSLog(@"read light status=%@",result);
//                }else {
//                    result = @"-2";
//                }
//            }else {
//                result = @"-2";
//            }
//            
//        }
    return @"-2";
}
//窗帘控制
-(void) controlCurtain:(CDVInvokedUrlCommand *)command {
    if (gateType==0) {
        Byte bytes[] = {0xAE,0xD0,0x09,0x03,0x01,0x00,0x00,0x01,0x00};
        cmdType = bytes[3];
        bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
        bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
        bytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
        [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
        NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
        [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
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
                        result = @"true";
                        break;
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
    else
    {
        [self connectTcp];
        tcpCmdType = @"ctrlCurtain";
        NSData *requestData = [TcpCommand getCtrlCurtainCmd:SEND_TAG++ areaNo:[[command.arguments objectAtIndex:2] intValue] devNo:[[command.arguments objectAtIndex:3] intValue] status:[[command.arguments objectAtIndex:4] intValue]];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
    
}
//窗帘状态读取
-(void) readCurtainStatus:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x08,0x83,0x01,0x01,0x00,0x01};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self returnResult:command sendBytes:bytes];
}
-(NSString*) readCurtainStatus:(Byte) areaNo secondDeviceNo:(Byte) deviceNo{
    Byte bytes[] = {0xAE,0xD0,0x08,0x83,0x01,0x00,0x00,0x01};
    bytes[5] = areaNo;
    bytes[6] = deviceNo;
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    
//    [self.commandDelegate runInBackground:^{
//        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
//        NSLog(@"readcutainsstatus cmdType=%#x",cmdType);
//
//        NSString* result = nil;
//    while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
//        if (cmdResult!=nil) {
//            Byte *returnByte = (Byte *)[cmdResult bytes];
//            //            NSLog(@"handler type=%#x\n",cmdType);
//            if (cmdType == returnByte[3]) {
//                result = [NSString stringWithFormat:@"%d",returnByte[13]];;
//                NSLog(@"read cutains status=%@",result);
//                return result;
//            }else {
//                result = @"-2";
//            }
//        }else {
//            result = @"-2";
//        }
//        
//    }
//    }];
    return @"-2";
}
//中央空调控制
-(void) controlAir:(CDVInvokedUrlCommand *)command {
    if (gateType==0) {
        Byte bytes[] = {0xAE,0xD0,0x0C,0x04,0x01,0x00,0x00,0x01,0x02,0x00,0x00,0x01};
        cmdType = bytes[3];
        bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
        bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
        //action
        bytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:7] intValue];
        //mode
        bytes[8] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
        //speed
        bytes[9] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:5] intValue];
        //temp
        bytes[10] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:6] intValue];
        //    NSLog(@"cmdtype=%#x  controAir",cmdType);
        //    for(int i=0;i<12;i++)
        //    printf("%#x ",bytes[i]);
        //    printf("\n");
        [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
        NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
        [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
        //    Byte actionType = bytes[7];
        [self.commandDelegate runInBackground:^{
            NSString* result = nil;
            long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
            NSLog(@"cmdType=%#x",cmdType);
            while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=timeout) {
                if (cmdResult!=nil) {
                    Byte *returnByte = (Byte *)[cmdResult bytes];
                    if (cmdType == returnByte[3]) {
                        //zanshi mei you yi yi dui ying
                        result = @"true";
                        break;
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
    else
    {
        [self connectTcp];
        tcpCmdType = @"ctrlAir";
        NSData *requestData = [TcpCommand getCtrlAirCmd:SEND_TAG++ areaNo:[[command.arguments objectAtIndex:2] intValue] devNo:[[command.arguments objectAtIndex:3] intValue] status:[[command.arguments objectAtIndex:7] intValue] mode:[[command.arguments objectAtIndex:4] intValue] fan:[[command.arguments objectAtIndex:5] intValue] temp:[[command.arguments objectAtIndex:6] intValue]];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
   
}
//中央空调状态
-(void) readAirStatus:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x08,0x84,0x01,0x01,0x00,0x01};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
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
                break;
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
//中央空调状态
-(NSString*) readAirStatus:(Byte) areaNo secondDeviceNo:(Byte) deviceNo {
    Byte bytes[] = {0xAE,0xD0,0x08,0x84,0x01,0x01,0x00,0x01};
    bytes[5] = areaNo;
    bytes[6] = deviceNo;
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    return @"-2";
}
//新风控制
-(void) controlFresh:(CDVInvokedUrlCommand *)command
{
    if (gateType==1) {
        [self connectTcp];
        tcpCmdType = @"ctrlFresh";
        NSData *requestData = [TcpCommand getCtrlFreshCmd:SEND_TAG++ areaNo:[[command.arguments objectAtIndex:2] intValue] devNo:[[command.arguments objectAtIndex:3] intValue] status:[[command.arguments objectAtIndex:4] intValue] mode:[[command.arguments objectAtIndex:5] intValue] fan:[[command.arguments objectAtIndex:6] intValue]];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
}
//地暖控制
-(void) controlFheat:(CDVInvokedUrlCommand *)command
{
    if (gateType==1) {
        [self connectTcp];
        tcpCmdType = @"ctrlFheat";
        NSData *requestData = [TcpCommand getCtrlFheatCmd:SEND_TAG++ areaNo:[[command.arguments objectAtIndex:2] intValue] devNo:[[command.arguments objectAtIndex:3] intValue] status:[[command.arguments objectAtIndex:4] intValue] mode:[[command.arguments objectAtIndex:5] intValue] temp:[[command.arguments objectAtIndex:6] intValue]];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
}
//音乐控制
-(void) controlMusic:(CDVInvokedUrlCommand *)command
{
    if (gateType==1) {
        [self connectTcp];
        tcpCmdType = @"ctrlMusic";
        NSData *requestData = [TcpCommand getCtrlMusicCmd:SEND_TAG++ areaNo:[[command.arguments objectAtIndex:2] intValue] devNo:[[command.arguments objectAtIndex:3] intValue] status:[[command.arguments objectAtIndex:4] intValue] play:[[command.arguments objectAtIndex:5] intValue] item:[[command.arguments objectAtIndex:6] intValue] volume:[[command.arguments objectAtIndex:7] intValue]];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
}
-(void) controlDef:(CDVInvokedUrlCommand *)command {
    if (gateType==1) {
        [self connectTcp];
        tcpCmdType = @"ctrlDef";
        NSString *devType = @"all";
        switch ([[command.arguments objectAtIndex:2] intValue]) {
            case 14:
                devType = @"gasSen";
                break;
            case 21:
                devType = @"bodySen";
                break;
            case 15:
                devType = @"doorSen";
                break;
            case 16:
                devType = @"IRSen";
                break;
            default:
                break;
        }
        NSData *requestData = [TcpCommand getCtrlDefCmd:SEND_TAG++ devType:devType devNo:[[command.arguments objectAtIndex:2] intValue] enable:[[command.arguments objectAtIndex:3] intValue]];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
}
//防区状态读取
-(void) readDefenceStatus:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x07,0x85,0x01,0x01};
    cmdType = bytes[3];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self returnResult:command sendBytes:bytes];
    
}
//开关／电器控制
-(void) controlSwitch:(CDVInvokedUrlCommand *)command {
    if (gateType==0) {
        Byte bytes[] = {0xAE,0xD0,0x09,0x06,0x01,0x00,0x00,0x01,0x01};
        cmdType = bytes[3];
        bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
        bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
        bytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
        [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
        NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
        [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
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
                        result = @"true";
                        break;
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
    else
    {
        [self connectTcp];
        tcpCmdType = @"ctrlSwitch";
        NSData *requestData = [TcpCommand getCtrlSwitchCmd:SEND_TAG++ areaNo:[[command.arguments objectAtIndex:2] intValue] devNo:[[command.arguments objectAtIndex:3] intValue] status:[[command.arguments objectAtIndex:4] intValue]];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
    
    
}
//开关／电器状态读取
-(NSString *) readSwitchStatus:(Byte) areaNo secondDeviceNo:(Byte) deviceNo action:(Byte) action{
    Byte bytes[] = {0xAE,0xD0,0x08,0x86,0x01,0x01,0x01,0x01};
    bytes[5] = areaNo;
    bytes[6] = deviceNo;
    bytes[4] = action;
    //1 kaiguan 17 dianliang
    //{"result":-2,"hz":0.0,"vmp":0.0,"ma":0.0,"pf":0.0,"ac":0.0,"ap":0.0,"checkHz":0,"checkVmp":0,"checkMa":0,"checkPf":0,"checkAc":0}
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    return @"-2";
}
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
    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self.commandDelegate runInBackground:^{
        NSString* result = nil;
        long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSLog(@"cmdType=%#x",cmdType);
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
                break;
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
    if (gateType==0) {
        Byte bytes[] = {0xAE,0xD0,0x09,0x07,0x01,0x00,0x00,0x01,0x01};
        cmdType = bytes[3];
        bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
        bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
        bytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
        [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
        NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
        [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
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
                        result = @"true";
                        break;
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
    else
    {
        [self connectTcp];
        tcpCmdType = @"ctrlIR";
        NSData *requestData = [TcpCommand getCtrlIRCmd:SEND_TAG++ areaNo:[[command.arguments objectAtIndex:2] intValue] devNo:[[command.arguments objectAtIndex:3] intValue] iconNo:[[command.arguments objectAtIndex:4] intValue]];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
    
}
//门锁控制
-(void) controlDoorLock:(CDVInvokedUrlCommand *)command {
    if (gateType==0) {
        Byte bytes[] = {0xAE,0xD0,0x09,0x08,0x01,0x00,0x00,0x01,0x01};
        cmdType = bytes[3];
        bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
        bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
        bytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
        [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
        NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
        [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
        Byte actionType = bytes[7];
        [self.commandDelegate runInBackground:^{
            NSString* result = nil;
            long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
            NSLog(@"cmdType=%#x",cmdType);
            while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=8000) {
                if (cmdResult!=nil) {
                    Byte *returnByte = (Byte *)[cmdResult bytes];
                    //            NSLog(@"handler type=%#x\n",cmdType);
                    if (cmdType == returnByte[3]) {
                        result = actionType==returnByte[13]?@"true":@"false";
                        break;
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
    else
    {
        [self connectTcp];
        tcpCmdType = @"ctrlLock";
        NSString *lockType = ([[command.arguments objectAtIndex:5] intValue]==12)?@"mlock":@"flock";
        NSData *requestData = [TcpCommand getCtrlLockCmd:SEND_TAG++ areaNo:[[command.arguments objectAtIndex:2] intValue] devNo:[[command.arguments objectAtIndex:3] intValue] status:[[command.arguments objectAtIndex:4] intValue] lockType:lockType ];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
    
}

//设置门锁临时密码
-(void) setDoorPwd:(CDVInvokedUrlCommand *)command {
    NSString *pwd = [command.arguments objectAtIndex:2];
    NSString *locktype = [command.arguments objectAtIndex:3];
    if (gateType==0) {
        int pwdLength = [pwd length];
        int lengt = pwdLength+9;
        
        Byte bytes[lengt];
        
        
        bytes[0] = (Byte)0xAE;
        bytes[1] = (Byte)0xD0;
        //设置数据长度
        bytes[2] = (Byte) (pwdLength+9);
        
        bytes[3] = (Byte)0x31;
        bytes[4] = (Byte)0x01;
        //设置区域号
        bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:0] intValue];
        //设置设备号
        bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:1] intValue];
        //设置时间
        bytes[7] = (Byte)0x05;
        cmdType = bytes[3];
        //根据密码设置密码长度
        for (int i = 0; i < pwdLength; i++) {
            
            bytes[8+i] = (Byte) [[pwd substringWithRange:NSMakeRange(i, 1)] intValue];
        }
        
        
        [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
        
        for(int i=0;i<sizeof(bytes);i++)
            printf(" %#x ",bytes[i]);
        
        NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
        [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
        //    Byte actionType = bytes[7];
        [self.commandDelegate runInBackground:^{
            NSString* result = nil;
            long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
            NSLog(@"cmdType=%#x",cmdType);
            while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=6000) {
                if (cmdResult!=nil) {
                    result = @"true";
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
    else
    {
        [self connectTcp];
        tcpCmdType = @"setTempPwd";
        NSData *requestData = [TcpCommand getSetLockPwdCmd:SEND_TAG++ areaNo:[[command.arguments objectAtIndex:0] intValue] devNo:[[command.arguments objectAtIndex:1] intValue] lockType:@"mlock" pwd:pwd];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
    
}
//门锁状态读取
-(void) readDoorLock:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x08,0x88,0x01,0x00,0x00,0x00};
    cmdType = bytes[3];
    bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
    bytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    [self returnResult:command sendBytes:bytes];
}
-(NSString*) readDoorLock:(Byte) areaNo secondDeviceNo:(Byte) deviceNo {
    Byte bytes[] = {0xAE,0xD0,0x08,0x88,0x01,0x00,0x00,0x00};
    bytes[5] = areaNo;
    bytes[6] = deviceNo;
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
    return @"-2";
}
//对码控制
-(void) checkControl:(CDVInvokedUrlCommand *)command {
    if (gateType==0) {
        Byte bytes[] = {0xAE,0xD0,0x07,0x41,0x01,0x00,0x00};
        cmdType = bytes[3];
        bytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
        [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
        NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
        [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
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
                        break;
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
    else
    {
        [self connectTcp];
        tcpCmdType = @"ctrlCheck";
        NSData *requestData = [TcpCommand getSetBindCmd:SEND_TAG++ enable:[[command.arguments objectAtIndex:2] intValue]];
        [self sendTcpData:requestData];
        [self returnTcpResult:command tag:SEND_TAG];
    }
   
}
-(Boolean) checkControlAction:(Byte) action {
    Byte bytes[] = {0xAE,0xD0,0x07,0x41,0x01,0x00,0x00};
    cmdType = bytes[3];
    bytes[5] = action;
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    Boolean result = false;
    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];

    return YES;
}
//清除配置
-(void) clearConfig:(CDVInvokedUrlCommand *)command {
    Byte bytes[] = {0xAE,0xD0,0x06,0x42,0x01,0x00};
    cmdType = bytes[3];
    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
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
        [gcdUdpSocket sendData:data1 toHost:host port:port withTimeout:-1 tag:tag];
//        [self returnResult:command sendBytes:airbytes];
    }else {
        otherbytes[5] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:2] intValue];
        otherbytes[6] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:3] intValue];
        otherbytes[7] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:4] intValue];
        otherbytes[8] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:5] intValue];
        otherbytes[9] = (Byte)[(NSNumber *)[command.arguments objectAtIndex:6] intValue];
        
        cmdType = otherbytes[3];
        NSData *data2 = [[NSData alloc] initWithBytes:otherbytes length:sizeof(otherbytes)];
        [gcdUdpSocket sendData:data2 toHost:host port:port withTimeout:-1 tag:tag];
//        [self returnResult:command sendBytes:otherbytes];
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

//    Byte bytes[] = {0xAE,0xD0,0x07,0x41,0x01,0x00,0x00};
//    bytes[5] = 0x00;
//    [JmaxAppPlugin getCheckByte:bytes sizeParam:sizeof(bytes)];
//    NSData *data = [[NSData alloc] initWithBytes:bytes length:sizeof(bytes)];
//    [gcdUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:tag];
//        [NSThread sleepForTimeInterval:1];
//        int areaNo = [(NSNumber *)[command.arguments objectAtIndex:2] intValue];
//        int deviceNo = [(NSNumber *)[command.arguments objectAtIndex:3] intValue];
        int deviceType = [(NSNumber *)[command.arguments objectAtIndex:4] intValue];
//        int actionType = [(NSNumber *)[command.arguments objectAtIndex:5] intValue];
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
    //sceneNo,areano,deviceNo,deviceType,actiontype,mode,speed,temp
    if (gateType==0) {
        NSString* result = @"[";
        NSString *data = [command.arguments objectAtIndex:2];
        NSArray *array = [data componentsSeparatedByString:@";"];
        
        NSString* rs = @"";
        int count = [array count]-1;//减少调用次数
        if(count>0) {
            //config scene
            cmdType=0x00;
            sceneConfigArray = [NSMutableArray arrayWithCapacity:0];
            for(int i=0; i<count; i++){
                
                if (![JmaxAppPlugin isBlankString:[array objectAtIndex:i]]) {
                    [NSThread sleepForTimeInterval:0.1];
                    //                NSLog(@"%i-%@", i, [array objectAtIndex:i]);
                    //not blank
                    [NSThread sleepForTimeInterval:0.15];
                    NSArray *oneArray =  [[array objectAtIndex:i]componentsSeparatedByString:@","];
                    int deviceType = [[oneArray objectAtIndex:3] intValue];
                    
                    Byte airbytes[] = {0xAE,0xD0,0x0E,0x43,0x01,0x00,0x00,0x04,0x01,0x01,0x00,0x00,0x04,0x00};
                    Byte otherbytes[] = {0xAE,0xD0,0x0B,0x43,0x01,0x00,0x00,0x04,0x01,0x00,0x00};
                    if (deviceType==4) {
                        //areano
                        airbytes[5] = (Byte)[[oneArray objectAtIndex:1] intValue];
                        //deviceno
                        airbytes[6] = (Byte)[[oneArray objectAtIndex:2] intValue];
                        //devicetype
                        airbytes[7] = (Byte)[[oneArray objectAtIndex:3] intValue];
                        //sceneno
                        airbytes[8] = (Byte)[[oneArray objectAtIndex:0] intValue];
                        //action
                        airbytes[9] = (Byte)[[oneArray objectAtIndex:4] intValue];
                        //mode
                        airbytes[10] = (Byte)[[oneArray objectAtIndex:5] intValue];
                        //speed
                        airbytes[11] = (Byte)[[oneArray objectAtIndex:6] intValue];
                        //temp
                        airbytes[12] = (Byte)[[oneArray objectAtIndex:7] intValue];
                        [JmaxAppPlugin getCheckByte:airbytes sizeParam:sizeof(airbytes)];
                        NSData *data1 = [[NSData alloc] initWithBytes:airbytes length:sizeof(airbytes)];
                        [gcdUdpSocket sendData:data1 toHost:host port:port withTimeout:-1 tag:tag];
                    }else {
                        otherbytes[5] = (Byte)[[oneArray objectAtIndex:1] intValue];
                        otherbytes[6] = (Byte)[[oneArray objectAtIndex:2] intValue];
                        otherbytes[7] = (Byte)[[oneArray objectAtIndex:3] intValue];
                        otherbytes[8] = (Byte)[[oneArray objectAtIndex:0] intValue];
                        otherbytes[9] = (Byte)[[oneArray objectAtIndex:4] intValue];
                        for(int i=0;i<11;i++)
                            printf("%#x ",otherbytes[i]);
                        printf("\n");
                        [JmaxAppPlugin getCheckByte:otherbytes sizeParam:sizeof(otherbytes)];
                        NSData *data2 = [[NSData alloc] initWithBytes:otherbytes length:sizeof(otherbytes)];
                        [gcdUdpSocket sendData:data2 toHost:host port:port withTimeout:-1 tag:tag];
                    }
                    
                }
                
            }
        }
        
        [self.commandDelegate runInBackground:^{
            //        NSLog(@"readDeviceStatusArray size=%d",[readDeviceStatusArray count]);
            long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
            NSLog(@"cmdType=%#x",cmdType);
            NSString* rs = @"true";

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:rs==nil?result:rs];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
    else
    {
        //sceneNo,areano,deviceNo,deviceType,actiontype,mode,speed,temp
        NSString *data = [command.arguments objectAtIndex:2];
        NSArray *array = [data componentsSeparatedByString:@";"];
//        NSLog(data);
        int count = [array count]-1;//减少调用次数
        if(count>0) {
            [self connectTcp];
            tcpCmdType=@"setScene";
            NSData *requestData = [TcpCommand getSetSceneCmd:SEND_TAG++ devArray:array];
            [self sendTcpData:requestData];
            [self returnTcpResult:command tag:SEND_TAG];
        }
    }
    
}
+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
//读取设备信息
-(void) readDeviceInfos:(CDVInvokedUrlCommand *)command {
    //used
    //设备类型,区域id,设备id,读取类型;设备类型,区域id,设备id,读取类型;
    
    //[{"deviceType":"0","roomZoneNo":1,"deviceNo":1,"obj":-2},{"deviceType":"1","roomZoneNo":1,"deviceNo":1,"obj":-2},{"deviceType":"2","roomZoneNo":1,"deviceNo":1,"obj":{"result":-2,"hz":0.0,"vmp":0.0,"ma":0.0,"pf":0.0,"ac":0.0,"ap":0.0,"checkHz":0,"checkVmp":0,"checkMa":0,"checkPf":0,"checkAc":0}},{"deviceType":"2","roomZoneNo":1,"deviceNo":1,"obj":{"result":-2,"hz":0.0,"vmp":0.0,"ma":0.0,"pf":0.0,"ac":0.0,"ap":0.0,"checkHz":0,"checkVmp":0,"checkMa":0,"checkPf":0,"checkAc":0}},{"deviceType":"4","roomZoneNo":1,"deviceNo":1,"obj":{"mode":0,"speed":0,"temp":0,"action":-2}},{"deviceType":"5","roomZoneNo":1,"deviceNo":1,"obj":-2}]
    
    //used
    //0:ip 1:port 2:data
    //设备类型,区域id,设备id,读取类型;设备类型,区域id,设备id,读取类型;
    if (gateType==0) {
        NSString* result = @"[";
        NSString *data = [command.arguments objectAtIndex:2];
        NSArray *array = [data componentsSeparatedByString:@";"];
        NSLog(data);
        NSString* rs = @"";
        int count = [array count]-1;//减少调用次数
        if(count>0) {
            //read device status;
            cmdType=0xff;
            readDeviceStatusArray = [NSMutableArray arrayWithCapacity:0];
            for(int i=0; i<count; i++){
                
                if (![JmaxAppPlugin isBlankString:[array objectAtIndex:i]]) {
                    [NSThread sleepForTimeInterval:0.1];
                    //                NSLog(@"%i-%@", i, [array objectAtIndex:i]);
                    //not blank
                    NSArray *oneArray =  [[array objectAtIndex:i]componentsSeparatedByString:@","];
                    int deviceType = [[oneArray objectAtIndex:0] intValue];
                    //0：灯光；1：窗帘；2：开关；3：红外设备；4：中央空调；5：门锁；6:电视；7：红外空调
                    //                NSLog(@"deviceType=%d",deviceType);
                    switch(deviceType) {
                        case 0:
                            rs = [self readLightStatus:[[oneArray objectAtIndex:1] intValue] secondDeviceNo:[[oneArray objectAtIndex:2] intValue]];
                            result = [result stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"0\",\"roomZoneNo\":%@,\"deviceNo\":%@,\"obj\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2],rs]];
                            break;
                        case 1:
                            rs = [self readCurtainStatus:[[oneArray objectAtIndex:1] intValue] secondDeviceNo:[[oneArray objectAtIndex:2] intValue]];
                            result = [result stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"1\",\"roomZoneNo\":%@,\"deviceNo\":%@,\"obj\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2],rs]];
                            break;
                        case 2:
                            rs = [self readSwitchStatus:[[oneArray objectAtIndex:1] intValue] secondDeviceNo:[[oneArray objectAtIndex:2] intValue] action:0x01];
                            result = [result stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"2\",\"roomZoneNo\":%@,\"deviceNo\":%@,\"obj\":{\"result\":%@,\"hz\":0.0,\"vmp\":0.0,\"ma\":0.0,\"pf\":0.0,\"ac\":0.0,\"ap\":0.0,\"checkHz\":0,\"checkVmp\":0,\"checkMa\":0,\"checkPf\":0,\"checkAc\":0}},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2],rs]];
                            break;
                        case 4:
                            rs = [self readAirStatus:[[oneArray objectAtIndex:1] intValue] secondDeviceNo:[[oneArray objectAtIndex:2] intValue]];
                            result = [result stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"4\",\"roomZoneNo\":%@,\"deviceNo\":%@,\"obj\":{\"mode\":0,\"speed\":0,\"temp\":0,\"action\":-2}},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2]]];
                            break;
                        case 5:
                            rs = [self readDoorLock:[[oneArray objectAtIndex:1] intValue] secondDeviceNo:[[oneArray objectAtIndex:2] intValue]];
                            result = [result stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"5\",\"roomZoneNo\":%@,\"deviceNo\":%@,\"obj\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2],rs]];
                            break;
                    }
                }
                
            }
        }
        result = [result substringToIndex:[result length]-1];
        result = [result stringByAppendingString:@"]"];
        
        [self.commandDelegate runInBackground:^{
            //        NSLog(@"readDeviceStatusArray size=%d",[readDeviceStatusArray count]);
            long long beginTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
            NSLog(@"cmdType=%#x",cmdType);
            NSString* rs = nil;
            while ([[NSDate date] timeIntervalSince1970] * 1000-beginTimestamp<=4000) {
                if ([readDeviceStatusArray count]==count) {
                    NSLog(@"readDeviceStatusArray size=%d",[readDeviceStatusArray count]);
                    rs = @"[";
                    for (NSData *data in readDeviceStatusArray) {
                        Byte *testByte = (Byte *)[data bytes];
                        switch(testByte[3]) {
                            case 0x82:
                                rs = [rs stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"0\",\"roomZoneNo\":%d,\"deviceNo\":%d,\"obj\":%d},",testByte[11],testByte[12],testByte[13]]];
                                break;
                            case 0x83:
                                rs = [rs stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"1\",\"roomZoneNo\":%d,\"deviceNo\":%d,\"obj\":%d},",testByte[11],testByte[12],testByte[13]]];
                                break;
                            case 0x86:
                                rs = [rs stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"2\",\"roomZoneNo\":%d,\"deviceNo\":%d,\"obj\":{\"result\":%d,\"hz\":0.0,\"vmp\":0.0,\"ma\":0.0,\"pf\":0.0,\"ac\":0.0,\"ap\":0.0,\"checkHz\":0,\"checkVmp\":0,\"checkMa\":0,\"checkPf\":0,\"checkAc\":0}},",testByte[11],testByte[12],testByte[13]]];
                                break;
                                rs = [rs stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"4\",\"roomZoneNo\":%d,\"deviceNo\":%d,\"obj\":{\"mode\":%d,\"speed\":%d,\"temp\":%d,\"action\":%d}},",testByte[11],testByte[12],testByte[14],testByte[15],testByte[16],testByte[13]]];
                                break;
                            case 0x88:
                                rs = [rs stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"5\",\"roomZoneNo\":%d,\"deviceNo\":%d,\"obj\":%d},",testByte[11],testByte[12],testByte[13]]];
                                break;
                        }
                    }
                    rs = [rs substringToIndex:[rs length]-1];
                    rs = [rs stringByAppendingString:@"]"];
                    break;
                }
                
            }
            
            if ([readDeviceStatusArray count]!=count&&[readDeviceStatusArray count]>0) {
                NSLog(@"not all readDeviceStatusArray size=%d",[readDeviceStatusArray count]);
                rs = @"[";
                for (NSData *data in readDeviceStatusArray) {
                    Byte *testByte = (Byte *)[data bytes];
                    switch(testByte[3]) {
                        case 0x82:
                            rs = [rs stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"0\",\"roomZoneNo\":%d,\"deviceNo\":%d,\"obj\":%d},",testByte[11],testByte[12],testByte[13]]];
                            break;
                        case 0x83:
                            rs = [rs stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"1\",\"roomZoneNo\":%d,\"deviceNo\":%d,\"obj\":%d},",testByte[11],testByte[12],testByte[13]]];
                            break;
                        case 0x86:
                            rs = [rs stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"2\",\"roomZoneNo\":%d,\"deviceNo\":%d,\"obj\":{\"result\":%d,\"hz\":0.0,\"vmp\":0.0,\"ma\":0.0,\"pf\":0.0,\"ac\":0.0,\"ap\":0.0,\"checkHz\":0,\"checkVmp\":0,\"checkMa\":0,\"checkPf\":0,\"checkAc\":0}},",testByte[11],testByte[12],testByte[13]]];
                            break;
                        case 0x84:
                            rs = [rs stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"4\",\"roomZoneNo\":%d,\"deviceNo\":%d,\"obj\":{\"mode\":%d,\"speed\":%d,\"temp\":%d,\"action\":%d}},",testByte[11],testByte[12],testByte[14],testByte[15],testByte[16],testByte[13]]];
                            break;
                        case 0x88:
                            rs = [rs stringByAppendingString:[NSString stringWithFormat:@"{\"deviceType\":\"5\",\"roomZoneNo\":%d,\"deviceNo\":%d,\"obj\":%d},",testByte[11],testByte[12],testByte[13]]];
                            break;
                    }
                }
                rs = [rs substringToIndex:[rs length]-1];
                rs = [rs stringByAppendingString:@"]"];
            }
            
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:rs==nil?result:rs];
//            NSLog(rs);
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
    else
    {
        // //设备类型,区域id,设备id,读取类型;设备类型,区域id,设备id,读取类型;
        NSString *data = [command.arguments objectAtIndex:2];
        NSArray *array = [data componentsSeparatedByString:@";"];
        NSLog(data);
        int count = [array count]-1;//减少调用次数
        if(count>0) {
            
            [self connectTcp];
            tcpCmdType=@"readDevList";
            NSData *requestData = [TcpCommand getReadDevListCmd:SEND_TAG++ devArray:array];
            [self sendTcpData:requestData];
            [self returnTcpResult:command tag:SEND_TAG];
            
        }
    }
    
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
        [outPutStr appendFormat:@"%02X", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr uppercaseString];
}

+(void)getCheckByte:(Byte[])bytes sizeParam:(int)size {
    int check = 0;
    //    int size = sizeof(bytes);
    for(int i=0;i<size-1;i++) {
        check = check+bytes[i]&0xff;
    }
    check = check&0xff;
    bytes[size-1] = check;
//    NSLog(@"size=%d----%d",size,bytes[size-1] );
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