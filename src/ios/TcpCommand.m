//
//  TcpCommand.m
//  享·家
//
//  Created by Mac on 16/5/2.
//
//

#import "TcpCommand.h"

@implementation TcpCommand
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

@end
