#import "JmaxAppPlugin.h"
#import "Cordova/CDV.h"

@implementation JmaxAppPlugin

-(void)test:(CDVInvokedUrlCommand*)command {
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end