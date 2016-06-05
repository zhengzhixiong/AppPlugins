//
//  TcpCommand.h
//  享·家
//
//  Created by Mac on 16/5/2.
//
//

#import <Foundation/Foundation.h>

@interface TcpCommand : NSObject
+ (NSData *)getReadDevListCmd:(long)flag devArray:(NSArray *)devArray;
+ (NSData *)getReadNetCmd:(long)flag;
+ (NSData *)getCtrlSceneCmd:(long)flag sceneNo:(int) sceneNo;
+ (NSData *)getCtrlLightCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status;
+ (NSData *)getCtrlCurtainCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status;
@end
