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
+ (NSString *)getReadDevListResult:(NSArray *)resultArray;

+ (NSData *)getSetSceneCmd:(long)flag devArray:(NSArray *)array;
+ (NSData *)getReadNetCmd:(long)flag;
+ (NSData *)getCtrlSceneCmd:(long)flag sceneNo:(int) sceneNo;
+ (NSData *)getCtrlLightCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status;
+ (NSData *)getCtrlCurtainCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status;
+ (NSData *)getCtrlAirCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status mode:(int) mode fan:(int) fan temp:(int) temp;
+ (NSData *)getCtrlSwitchCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status;
+ (NSData *)getReadSwitchCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo;

+ (NSData *)getCtrlIRCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo iconNo:(int) iconNo;
+ (NSData *)getCtrlLockCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status lockType:(NSString *) lockType;
+ (NSData *)getReadLockCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo lockType:(NSString *) lockType;
//
+ (NSData *)getReadDeteCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo deteType:(NSString *) deteType;

+ (NSData *)getCtrlFreshCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status mode:(int) mode fan:(int) fan;
+ (NSData *)getCtrlFheatCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status mode:(int) mode temp:(int) temp;

+ (NSData *)getReadMusicCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo;

+ (NSData *)getCtrlMusicCmd:(long)flag areaNo:(int) areaNo devNo:(int) devNo status:(int) status play:(int) play item:(int) item volume:(int) volume;

+ (NSData *)getCtrlDefCmd:(long)flag devType:(NSString *) devType devNo:(int) devNo enable:(int) enable;

+ (NSData *)getSetBindCmd:(long)flag enable:(int) enable;

@end
