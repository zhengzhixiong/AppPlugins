//
//  TcpCommand.h
//  享·家
//
//  Created by Mac on 16/5/2.
//
//

#import <Foundation/Foundation.h>

@interface TcpCommand : NSObject
+ (NSData *)getCtrlSceneCmd:(long)flag sceneNo:(int) sceneNo;
@end
