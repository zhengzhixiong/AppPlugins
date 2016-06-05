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

+ (NSData *)getReadDevListCmd:(long)flag devArray:(NSArray *)devArray
{
    
//    NSArray *arry=@[@"pass1234",@"123456" ];
//    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"KingKong",@"username" ,@"男",@"sex",arry,@"password",nil];
//    //将字典集合数据转换为JSON数据类型
//    NSData *json=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
//    //重新解析JSON数据
//    NSString *strjson=[[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",strjson);
    
    
    NSArray *arry= @[];
    NSDictionary *dictionary=[[NSDictionary alloc]initWithObjectsAndKeys:@"readDev",@"action" ,[NSNumber numberWithInteger:flag],@"flag",arry,@"devList",nil];
    
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
//    [dictionary setValue:@"readDev" forKey:@"action"];
//    [dictionary setValue:@"curtain" forKey:@"devType"];
//    [dictionary setValue:[NSNumber numberWithInteger:areaNo] forKey:@"areaNo"];
//    [dictionary setValue:[NSNumber numberWithInteger:devNo] forKey:@"devNo"];
//    [dictionary setValue:[NSNumber numberWithInteger:status] forKey:@"status"];
//    [dictionary setValue:@"devList" forKey:devArray];
//    [dictionary setValue:[NSNumber numberWithInteger:flag] forKey:@"flag"];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    return requestData;
}

@end
