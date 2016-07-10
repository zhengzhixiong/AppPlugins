//
//  TcpCommand.m
//  享·家
//
//  Created by Mac on 16/5/2.
//
//

#import "TcpCommand.h"

@implementation TcpCommand
+ (NSData *)getReadNetCmd:(long)flag
{
    //{"action":"readNet","flag":1462181185860}
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"readNet" forKey:@"action"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;
}
+ (NSData *)getCtrlSceneCmd:(long)flag sceneNo:(int) sceneNo
{
    //场景控制格式{"action":"ctrlScene","sceneNo":1,"flag":1462181185860}
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"ctrlScene" forKey:@"action"];
    [dictionary setValue:[NSNumber numberWithInteger:sceneNo] forKey:@"sceneNo"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
     return requestData;
}
+ (NSData *)getCtrlLightCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status
{
    //灯光控制格式{"action":"ctrlDev","devType":"light","areaNo":0,"devNo":0,"status":0,"flag":1462181185860}
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"ctrlDev" forKey:@"action"];
    [dictionary setValue:@"light" forKey:@"devType"];
    [dictionary setValue:[NSNumber numberWithInteger:areaNo] forKey:@"areaNo"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:[NSNumber numberWithInteger:status] forKey:@"status"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;
}

+ (NSData *)getCtrlCurtainCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status
{
    //{"action":"ctrlDev","devType":"curtain","areaNo":0,"devNo":0,"status":0,"flag":1462181185860}
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"ctrlDev" forKey:@"action"];
    [dictionary setValue:@"curtain" forKey:@"devType"];
    [dictionary setValue:[NSNumber numberWithInteger:areaNo] forKey:@"areaNo"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:[NSNumber numberWithInteger:status] forKey:@"status"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;
}

+ (NSData *)getCtrlAirCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status mode:(int) mode fan:(int) fan temp:(int) temp
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"ctrlDev" forKey:@"action"];
    [dictionary setValue:@"air" forKey:@"devType"];
    [dictionary setValue:[NSNumber numberWithInteger:areaNo] forKey:@"areaNo"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:[NSNumber numberWithInteger:status] forKey:@"status"];
    [dictionary setValue:[NSNumber numberWithInteger:mode] forKey:@"mode"];
    [dictionary setValue:[NSNumber numberWithInteger:fan] forKey:@"fan"];
    [dictionary setValue:[NSNumber numberWithInteger:temp] forKey:@"temp"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;
}

+ (NSData *)getCtrlSwitchCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"ctrlDev" forKey:@"action"];
    [dictionary setValue:@"switch" forKey:@"devType"];
    [dictionary setValue:[NSNumber numberWithInteger:areaNo] forKey:@"areaNo"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:[NSNumber numberWithInteger:status] forKey:@"status"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;

}

+ (NSData *)getReadSwitchCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"ctrlDev" forKey:@"action"];
    [dictionary setValue:@"switch" forKey:@"devType"];
    [dictionary setValue:[NSNumber numberWithInteger:areaNo] forKey:@"areaNo"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;
}

+ (NSData *)getCtrlIRCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo iconNo:(int) iconNo
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"readDev" forKey:@"action"];
    [dictionary setValue:@"IR" forKey:@"devType"];
    [dictionary setValue:[NSNumber numberWithInteger:areaNo] forKey:@"areaNo"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:[NSNumber numberWithInteger:iconNo] forKey:@"iconNo"];
    [dictionary setValue:@"" forKey:@"data"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;
}
+ (NSData *)getCtrlLockCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status lockType:(NSString *) lockType
{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"ctrlDev" forKey:@"action"];
    [dictionary setValue:lockType forKey:@"devType"];
//    [dictionary setValue:[NSNumber numberWithInteger:areaNo] forKey:@"areaNo"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:[NSNumber numberWithInteger:status] forKey:@"status"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;
}

+ (NSData *)getReadLockCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo lockType:(NSString *) lockType
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"readDev" forKey:@"action"];
    [dictionary setValue:lockType forKey:@"devType"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;
}
+ (NSData *)getSetLockPwdCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo lockType:(NSString *) lockType pwd:(NSString *)pwd
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"setTempPwd" forKey:@"action"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:pwd forKey:@"password"];
    [dictionary setValue:[NSNumber numberWithInteger:5] forKey:@"time"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;

}

+ (NSData *)getReadDeteCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo deteType:(NSString *) deteType
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"readDev" forKey:@"action"];
    [dictionary setValue:deteType forKey:@"devType"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;
}

+ (NSData *)getCtrlFreshCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status mode:(int) mode fan:(int) fan
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"ctrlDev" forKey:@"action"];
    [dictionary setValue:@"fresh" forKey:@"devType"];
    [dictionary setValue:[NSNumber numberWithInteger:areaNo] forKey:@"areaNo"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:[NSNumber numberWithInteger:status] forKey:@"status"];
    [dictionary setValue:[NSNumber numberWithInteger:mode] forKey:@"mode"];
    [dictionary setValue:[NSNumber numberWithInteger:fan] forKey:@"fan"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;

}
+ (NSData *)getCtrlFheatCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status mode:(int) mode temp:(int) temp
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"ctrlDev" forKey:@"action"];
    [dictionary setValue:@"fheat" forKey:@"devType"];
    [dictionary setValue:[NSNumber numberWithInteger:areaNo] forKey:@"areaNo"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:[NSNumber numberWithInteger:status] forKey:@"status"];
    [dictionary setValue:[NSNumber numberWithInteger:mode] forKey:@"mode"];
        [dictionary setValue:[NSNumber numberWithInteger:temp] forKey:@"temp"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;

}

+ (NSData *)getReadMusicCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"readDev" forKey:@"action"];
    [dictionary setValue:@"music" forKey:@"devType"];
    [dictionary setValue:[NSNumber numberWithInteger:areaNo] forKey:@"areaNo"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;

}

+ (NSData *)getCtrlMusicCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status play:(int) play item:(int) item volume:(int) volume
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"ctrlDev" forKey:@"action"];
    [dictionary setValue:@"music" forKey:@"devType"];
    [dictionary setValue:[NSNumber numberWithInteger:areaNo] forKey:@"areaNo"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:[NSNumber numberWithInteger:status] forKey:@"status"];
    [dictionary setValue:[NSNumber numberWithInteger:play] forKey:@"play"];
    [dictionary setValue:[NSNumber numberWithInteger:item] forKey:@"item"];
    [dictionary setValue:[NSNumber numberWithInteger:volume] forKey:@"volume"];
    [dictionary setValue:[NSNumber numberWithInteger:255] forKey:@"items"];
    [dictionary setValue:[NSNumber numberWithInteger:255] forKey:@"volumes"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;

}

+ (NSData *)getCtrlDefCmd:(long)flag devType:(NSString *) devType devNo:(int) devNo enable:(int) enable
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"ctrlDef" forKey:@"action"];
    [dictionary setValue:devType forKey:@"devType"];
    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
    [dictionary setValue:[NSNumber numberWithInteger:enable] forKey:@"enable"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;
}

+ (NSData *)getSetBindCmd:(long)flag enable:(int) enable
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"setBind" forKey:@"action"];
    [dictionary setValue:[NSNumber numberWithInteger:enable] forKey:@"enable"];
    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;
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
+ (NSData *)getReadDevListCmd:(long)flag devArray:(NSArray *)array
{
    // //设备类型,区域id,设备id,读取类型;设备类型,区域id,设备id,读取类型;
//    NSArray *arry=@[@"pass1234",@"123456" ];
//    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"KingKong",@"username" ,@"男",@"sex",arry,@"password",nil];
//    //将字典集合数据转换为JSON数据类型
//    NSData *json=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//    //重新解析JSON数据
//    NSString *strjson=[[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",strjson);
//    NSMutableArray *arry= @[];
    NSString* rs = @"";
    int count = [array count]-1;//减少调用次数
    
    NSMutableString *jsonStr = [[NSMutableString alloc] initWithString:@"{\"action\":\"readDev\",\"flag\":12345678,\"devList\":["];
//    jsonStr appendString:<#(nonnull NSString *)#>
    if(count>0) {
//        arry = [NSMutableArray arrayWithCapacity:count];
        //read device status;
        for(int i=0; i<count; i++){
            
            if (![TcpCommand isBlankString:[array objectAtIndex:i]]) {
                //                NSLog(@"%i-%@", i, [array objectAtIndex:i]);
                //not blank
                NSArray *oneArray =  [[array objectAtIndex:i]componentsSeparatedByString:@","];
                int deviceType = [[oneArray objectAtIndex:0] intValue];
                //0：灯光；1：窗帘；2：开关；3：红外设备；4：中央空调；5：门锁；6:电视；7：红外空调
                //                NSLog(@"deviceType=%d",deviceType);
                switch(deviceType) {
                    case 0:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"light\",\"areaNo\":%@,\"devNo\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2]];
//                        [arry addObject:rs];
                        
                        break;
                    case 1:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"curtain\",\"areaNo\":%@,\"devNo\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2]];
//                        [arry addObject:rs];
                        break;
                    case 2:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"switch\",\"areaNo\":%@,\"devNo\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2]];
//                        [arry addObject:rs];
                        break;
                    case 4:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"air\",\"areaNo\":%@,\"devNo\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2]];
//                        [arry addObject:rs];
                        break;
                    case 5:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"mlock\",\"areaNo\":%@,\"devNo\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2]];
//                        [arry addObject:rs];
                        break;
                    case 9:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"music\",\"areaNo\":%@,\"devNo\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2]];
//                        [arry addObject:rs];
                        break;
                    case 10:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"fresh\",\"areaNo\":%@,\"devNo\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2]];
//                        [arry addObject:rs];
                        break;
                    case 11:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"fheat\",\"areaNo\":%@,\"devNo\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2]];
//                        [arry addObject:rs];
                        break;
                    case 12:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"mlock\",\"areaNo\":%@,\"devNo\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2]];
//                        [arry addObject:rs];
                        break;
                    case 13:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"flock\",\"areaNo\":%@,\"devNo\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2]];
//                        [arry addObject:rs];
                        break;
                }
                [jsonStr appendString:rs];
            }
            
        }
        NSUInteger location = [jsonStr length]-1;
        NSRange range = NSMakeRange(location, 1);
        [jsonStr replaceCharactersInRange:range withString:@"]}"];

    }else
    {
        [jsonStr appendString:@"]}"];
    }
    
    
//    NSDictionary *dictionary=[[NSDictionary alloc]initWithObjectsAndKeys:@"readDev",@"action" ,[NSNumber numberWithInteger:flag],@"flag",arry,@"devList",nil];
    
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
//    [dictionary setValue:@"readDev" forKey:@"action"];
//    [dictionary setValue:@"curtain" forKey:@"devType"];
//    [dictionary setValue:[NSNumber numberWithInteger:areaNo] forKey:@"areaNo"];
//    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
//    [dictionary setValue:[NSNumber numberWithInteger:status] forKey:@"status"];
//    [dictionary setValue:@"devList" forKey:devArray];
//    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
//    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSData *requestData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    return requestData;
}

+ (NSString *)getReadDevListResult:(NSArray *)resultArray
{
    //[{"deviceType":"0","roomZoneNo":1,"deviceNo":1,"obj":-2},{"deviceType":"1","roomZoneNo":1,"deviceNo":1,"obj":-2},{"deviceType":"2","roomZoneNo":1,"deviceNo":1,"obj":{"result":-2,"hz":0.0,"vmp":0.0,"ma":0.0,"pf":0.0,"ac":0.0,"ap":0.0,"checkHz":0,"checkVmp":0,"checkMa":0,"checkPf":0,"checkAc":0}},{"deviceType":"2","roomZoneNo":1,"deviceNo":1,"obj":{"result":-2,"hz":0.0,"vmp":0.0,"ma":0.0,"pf":0.0,"ac":0.0,"ap":0.0,"checkHz":0,"checkVmp":0,"checkMa":0,"checkPf":0,"checkAc":0}},{"deviceType":"4","roomZoneNo":1,"deviceNo":1,"obj":{"mode":0,"speed":0,"temp":0,"action":-2}},{"deviceType":"5","roomZoneNo":1,"deviceNo":1,"obj":-2}]
    
    //                    {"devList":[{"devType":"light","areaNo":0,"devNo":0,"status":0},{"devType":"light","areaNo":0,"devNo":1,"status":0},{"devType":"light","areaNo":0,"devNo":2,"status":0},{"devType":"curtain","areaNo":0,"devNo":0,"status":1}],"result":"ok","devSN":"1-123-456-120","flag":12345678}
    NSMutableString *jsonStr = [[NSMutableString alloc] initWithString:@"["];
    if (resultArray!=nil) {
        for (int i=0; i< [resultArray count]; i++) {
            NSDictionary *dictionary = [resultArray objectAtIndex:i];
            NSString *deviceType = [dictionary valueForKey:@"devType"];
            NSString *rs = @"";
            if ([@"light" isEqualToString:deviceType]) {
                rs = [NSString stringWithFormat:@"{\"deviceType\":\"0\",\"roomZoneNo\":%@,\"deviceNo\":%@,\"obj\":%@},",[dictionary valueForKey:@"areaNo"],[dictionary valueForKey:@"devNo"],[dictionary valueForKey:@"status"]];
            }
            else if([@"curtain" isEqualToString:deviceType])
            {
                rs = [NSString stringWithFormat:@"{\"deviceType\":\"1\",\"roomZoneNo\":%@,\"deviceNo\":%@,\"obj\":%@},",[dictionary valueForKey:@"areaNo"],[dictionary valueForKey:@"devNo"],[dictionary valueForKey:@"status"]];
            }
                
            [jsonStr appendString:rs];
        }
        NSUInteger location = [jsonStr length]-1;
        NSRange range = NSMakeRange(location, 1);
        [jsonStr replaceCharactersInRange:range withString:@"]"];
        
    }
    else
    {
        [jsonStr appendString:@"]"];
    }
    
    return jsonStr;
    
}

+ (NSData *)getSetSceneCmd:(long)flag devArray:(NSArray *)array
{
//    sceneNo,areano,deviceNo,deviceType,actiontype,mode,speed,temp
    NSString* rs = @"";
    int count = [array count]-1;//减少调用次数
    NSArray *firsArray =  [[array objectAtIndex:0]componentsSeparatedByString:@","];
    
    NSString *jsonResult = [NSString stringWithFormat:@"{\"action\":\"setScene\",\"flag\":%ld,\"sceneNo\":%@,\"linkage\":[",flag,[firsArray objectAtIndex:0]];
    
    NSMutableString *jsonStr = [[NSMutableString alloc] initWithString:jsonResult];
    if(count>0) {
        for(int i=0; i<count; i++){
            
            if (![TcpCommand isBlankString:[array objectAtIndex:i]]) {
                NSArray *oneArray =  [[array objectAtIndex:i]componentsSeparatedByString:@","];
                int deviceType = [[oneArray objectAtIndex:3] intValue];
                //0：灯光；1：窗帘；2：开关；3：红外设备；4：中央空调；5：门锁；6:电视；7：红外空调
                //                NSLog(@"deviceType=%d",deviceType);
                switch(deviceType) {
                    case 0:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"light\",\"action\":\"ctrlDev\",\"areaNo\":%@,\"devNo\":%@,\"status\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2],[oneArray objectAtIndex:4]];
                        break;
                    case 1:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"curtain\",\"action\":\"ctrlDev\",\"areaNo\":%@,\"devNo\":%@,\"status\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2],[oneArray objectAtIndex:4]];
                        break;
                    case 2:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"switch\",\"action\":\"ctrlDev\",\"areaNo\":%@,\"devNo\":%@,\"status\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2],[oneArray objectAtIndex:4]];
                        break;
                    case 4:
                        rs = [NSString stringWithFormat:@"{\"deviceType\":\"air\",\"roomZoneNo\":%@,\"deviceNo\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2]];
                        break;
                    case 5:
                       rs = [NSString stringWithFormat:@"{\"devType\":\"mlock\",\"action\":\"ctrlDev\",\"devNo\":%@,\"status\":%@},",[oneArray objectAtIndex:2],[oneArray objectAtIndex:4]];
                        break;
                    case 9:
                         rs = [NSString stringWithFormat:@"{\"devType\":\"music\",\"action\":\"ctrlDev\",\"areaNo\":%@,\"devNo\":%@,\"status\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2],[oneArray objectAtIndex:4]];
                        break;
                    case 10:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"fresh\",\"action\":\"ctrlDev\",\"areaNo\":%@,\"devNo\":%@,\"status\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2],[oneArray objectAtIndex:4]];
                        break;
                    case 11:
                         rs = [NSString stringWithFormat:@"{\"devType\":\"fheat\",\"action\":\"ctrlDev\",\"areaNo\":%@,\"devNo\":%@,\"status\":%@},",[oneArray objectAtIndex:1],[oneArray objectAtIndex:2],[oneArray objectAtIndex:4]];
                        break;
                    case 12:
                        rs = [NSString stringWithFormat:@"{\"devType\":\"mlock\",\"action\":\"ctrlDev\",\"devNo\":%@,\"status\":%@},",[oneArray objectAtIndex:2],[oneArray objectAtIndex:4]];
                        break;
                    case 13:
                       rs = [NSString stringWithFormat:@"{\"devType\":\"flock\",\"action\":\"ctrlDev\",\"devNo\":%@,\"status\":%@},",[oneArray objectAtIndex:2],[oneArray objectAtIndex:4]];
                        break;
                }
                [jsonStr appendString:rs];
            }
            
        }
        NSUInteger location = [jsonStr length]-1;
        NSRange range = NSMakeRange(location, 1);
        [jsonStr replaceCharactersInRange:range withString:@"]}"];
        
    }else
    {
        [jsonStr appendString:@"]}"];
    }
    NSData *requestData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    return requestData;
}

@end
