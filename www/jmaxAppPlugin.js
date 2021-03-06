var exec = require('cordova/exec');

function JmaxAppPlugin() {}
/** 
 *  exec一共5个参数 
 *  第一个 :成功回调 
 *  第二个 :失败回调 
 *  第三个 :将要调用的类的配置名字(在config.xml中配置 稍后在下面会讲解) 
 *  第四个 :调用的方法名(一个类里可能有多个方法 靠这个参数区分) 
 *  第五个 :传递的参数  以json数组
 */
JmaxAppPlugin.prototype.toast = function(message) {
	 exec(null, null, "JmaxAppPlugin", "toast", [message]);
};
JmaxAppPlugin.prototype.test = function(message) {
	 exec(function(rs){
     	alert(rs);
     }, null, "JmaxAppPlugin", "test", [message]);
};
//初始化本地端口服务，true or false，记得不要多吃初始化
JmaxAppPlugin.prototype.initLocalServer = function(port,callback) {
	 exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "initLocalServer", [port]);
};
//初始化服务信息：网关通信类型（0：udp 1：tcp）、楼栋序号（无效，传0）、单元序号（无效，传0）、房屋号（无效，传0） 、目标ip（局域网ip）、目标端口，本地端口（无效，传0）
JmaxAppPlugin.prototype.initServer = function(gateType,buildNo,unitNo,houseNo,smartIp,smartPort,localPort,callback) {
	 exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "initServer", [gateType,buildNo,unitNo,houseNo,smartIp,smartPort,localPort]);
};
//控制场景
JmaxAppPlugin.prototype.controlScene = function(ip,port,sceneNo,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "controlScene", [ip,port,sceneNo]);
};
//灯光控制
JmaxAppPlugin.prototype.controlLight = function(ip,port,areaNo,deviceNo,actionType,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, null, "JmaxAppPlugin", "controlLight", [ip,port,areaNo,deviceNo,actionType]);
};

//灯光状态读取
JmaxAppPlugin.prototype.readLightStatus = function(ip,port,areaNo,deviceNo,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, null, "JmaxAppPlugin", "readLightStatus", [ip,port,areaNo,deviceNo]);
};

//窗帘控制
JmaxAppPlugin.prototype.controlCurtain = function(ip,port,areaNo,deviceNo,actionType,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, null, "JmaxAppPlugin", "controlCurtain", [ip,port,areaNo,deviceNo,actionType]);
};

//窗帘状态读取
JmaxAppPlugin.prototype.readCurtainStatus = function(ip,port,areaNo,deviceNo,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, null, "JmaxAppPlugin", "readCurtainStatus", [ip,port,areaNo,deviceNo]);
};

//中央空调控制
JmaxAppPlugin.prototype.controlAir = function(ip,port,areaNo,deviceNo,mode,speed,temp,action,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, null, "JmaxAppPlugin", "controlAir", [ip,port,areaNo,deviceNo,mode,speed,temp,action]);
};

//中央空调状态读取
JmaxAppPlugin.prototype.readAirStatus = function(ip,port,areaNo,deviceNo,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, null, "JmaxAppPlugin", "readAirStatus", [ip,port,areaNo,deviceNo]);
};
//新风控制
JmaxAppPlugin.prototype.controlFresh = function(ip,port,areaNo,deviceNo,action,mode,fan,jsonObj,callback) {
        exec(function(rs){
            if(callback) {
                callback(rs,jsonObj);
            }
        }, null, "JmaxAppPlugin", "controlFresh", [ip,port,areaNo,deviceNo,action,mode,fan]);
};
//地暖控制
JmaxAppPlugin.prototype.controlFheat = function(ip,port,areaNo,deviceNo,action,mode,temp,jsonObj,callback) {
        exec(function(rs){
            if(callback) {
                callback(rs,jsonObj);
            }
        }, null, "JmaxAppPlugin", "controlFheat", [ip,port,areaNo,deviceNo,action,mode,temp]);
};
//音乐控制
JmaxAppPlugin.prototype.controlMusic = function(ip,port,areaNo,deviceNo,status,play,item,volume,jsonObj,callback) {
    exec(function(rs){
        if(callback) {
            callback(rs,jsonObj);
        }
    }, null, "JmaxAppPlugin", "controlMusic", [ip,port,areaNo,deviceNo,status,play,item,volume]);
};
//布防控制 devType=all bodySen gasSen doorSen IRSen waterSen
JmaxAppPlugin.prototype.controlDef = function(ip,port,devType,deviceNo,enable,jsonObj,callback) {
               exec(function(rs){
                    if(callback) {
                    callback(rs,jsonObj);
                    }
                    }, null, "JmaxAppPlugin", "controlDef", [ip,port,devType,deviceNo,enable]);
};


//防区状态读取
JmaxAppPlugin.prototype.readDefenceStatus = function(ip,port,areaNo,deviceNo,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, null, "JmaxAppPlugin", "readDefenceStatus", [ip,port,areaNo,deviceNo]);
};

//开关（电器）控制
JmaxAppPlugin.prototype.controlSwitch = function(ip,port,areaNo,deviceNo,actionType,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, null, "JmaxAppPlugin", "controlSwitch", [ip,port,areaNo,deviceNo,actionType]);
};

//开关（电器）状态读取
JmaxAppPlugin.prototype.readSwitchStatus = function(ip,port,areaNo,deviceNo,type,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, null, "JmaxAppPlugin", "readSwitchStatus", [ip,port,areaNo,deviceNo,type]);
};

//红外设备控制：电视/机顶盒/红外空调
JmaxAppPlugin.prototype.controlInfrared = function(ip,port,areaNo,deviceNo,actionType,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, null, "JmaxAppPlugin", "controlInfrared", [ip,port,areaNo,deviceNo,actionType]);
};

//门锁控制
JmaxAppPlugin.prototype.controlDoorLock = function(ip,port,areaNo,deviceNo,actionType,lockType,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, null, "JmaxAppPlugin", "controlDoorLock", [ip,port,areaNo,deviceNo,actionType,lockType]);
};

//门锁状态读取
JmaxAppPlugin.prototype.readDoorLock = function(ip,port,areaNo,deviceNo,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, null, "JmaxAppPlugin", "readDoorLock", [ip,port,areaNo,deviceNo]);
};

//对码控制
JmaxAppPlugin.prototype.checkControl = function(ip,port,startCheck,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, null, "JmaxAppPlugin", "checkControl", [ip,port,startCheck]);
};

//清除配置
JmaxAppPlugin.prototype.clearConfig = function(ip,port,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "clearConfig", [ip,port]);
};


//场景配置
JmaxAppPlugin.prototype.sceneConfig = function(ip,port,areaNo,deviceNo,deviceType,sceneNo,actionType,airMode,airSpeed,airTemp,airAction,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "sceneConfig", [ip,port,areaNo,deviceNo,deviceType,sceneNo,actionType,airMode,airSpeed,airTemp,airAction]);
};

//场景集合配置
JmaxAppPlugin.prototype.sceneListConfig = function(ip,port,data,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "sceneListConfig", [ip,port,data]);
};

//网关测试
JmaxAppPlugin.prototype.networkTest = function(ip,port,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "networkTest", [ip,port]);
};

//定时配置
JmaxAppPlugin.prototype.timeTask = function(ip,port,mode,areaNo,deviceNo,date,week,deviceType,actionType,airMode,airSpeed,airTemp,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "timeTask", [ip,port,mode,areaNo,deviceNo,date,week,deviceType,actionType,airMode,airSpeed,airTemp]);
};

//设置设备SN码
JmaxAppPlugin.prototype.setSn = function(ip,port,proNo,buildNo,unitNo,houseNo,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "setSn", [ip,port,proNo,buildNo,unitNo,houseNo]);
};

//设置网络参数 有需要变更的是localAddress、network、gateway,其它的自动回带服务端反馈的
JmaxAppPlugin.prototype.setNetConfig = function(proNo,buildNo,unitNo,houseNo,localAddress,localPort,netWork,gateway,webAddress,webPort,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "setNetConfig", [proNo,buildNo,unitNo,houseNo,localAddress,localPort,netWork,gateway,webAddress,webPort]);
};
//读取设置网络参数
JmaxAppPlugin.prototype.readNetConfig = function(ip,port,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "readNetConfig", [ip,port]);
};
//自动广播扫描
JmaxAppPlugin.prototype.scanSearchNetConfig = function(callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "scanSearchNetConfig", []);
};
//设置设备绑定表
JmaxAppPlugin.prototype.setDeviceBand = function(ip,port,areaNo,deviceNo,deviceType,iconNo,bandAddress,bandChannel,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "setDeviceBand", [ip,port,areaNo,deviceNo,deviceType,iconNo,bandAddress,bandChannel]);
};
//读取设备绑定表
JmaxAppPlugin.prototype.readDeviceBand = function(ip,port,areaNo,deviceNo,deviceType,iconNo,bandAddress,bandChannel,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "readDeviceBand", [ip,port,areaNo,deviceNo,deviceType,iconNo,bandAddress,bandChannel]);
};
//开始设备绑定 (里面包含对码和控制)  deviceType 设备类型 （0：灯光；1：窗帘；2：开关；4：中央空调；5：门锁,6:电视；7：红外空调） actionType：0关，1开
JmaxAppPlugin.prototype.startDeviceBand = function(ip,port,areaNo,deviceNo,deviceType,actionType,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "startDeviceBand", [ip,port,areaNo,deviceNo,deviceType,actionType]);
};
//App测试设备绑定是否成功 deviceType 设备类型 （0：灯光；1：窗帘；2：开关；3：红外设备；4：中央空调；5：门锁） 
//actionType(非红外设备：0关，1开，红外设备，就对应图标序号);
JmaxAppPlugin.prototype.testDeviceBand = function(ip,port,areaNo,deviceNo,deviceType,actionType,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "testDeviceBand", [ip,port,areaNo,deviceNo,deviceType,actionType]);
};
//读取设备
JmaxAppPlugin.prototype.readDeviceInfo = function(ip,port,no,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "readDeviceInfo", [ip,port,no]);
};
//删除设备
JmaxAppPlugin.prototype.deleteDeviceInfo = function(ip,port,no,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "deleteDeviceInfo", [ip,port,no]);
};

//读取模块软件版本
JmaxAppPlugin.prototype.readModuleSoft = function(ip,port,address,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "readModuleSoft", [ip,port,address]);
};
//重启设备
JmaxAppPlugin.prototype.reboot = function(ip,port,address,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "reboot", [ip,port,address]);
};
//读取设备状态集合
//设备类型,区域id,设备id,读取类型;设备类型,区域id,设备id,读取类型;   其中读取类型是由于有些电器是读取开关传1，有些事读取电量传17，数据格式必须都要传
JmaxAppPlugin.prototype.readDeviceInfos = function(ip,port,data,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "readDeviceInfos", [ip,port,data]);
};
//退出app
JmaxAppPlugin.prototype.exitApp = function() {
	exec(null, null, "JmaxAppPlugin", "exitApp", []);
};
//读取本地wifi  ip地址，为""或"0.0.0.0" 表示读取不到的意思
JmaxAppPlugin.prototype.getLocalAddr = function(callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs);
		 }
	 }, null, "JmaxAppPlugin", "getLocalAddr", []);
};

//设置临时密码,pwd 是临时密码 长度6-10位（每位取0-9数字），操作成功返回true字符串，默认情况下，操作动作超时8秒,lockType:mlock   flock
JmaxAppPlugin.prototype.setDoorPwd = function(ip,port,areaNo,deviceNo,pwd,lockType,jsonObj,callback) {
	exec(function(rs){ 
		 if(callback) {
			 callback(rs,jsonObj);
		 }
	 }, function(error){
		 if(callback) {
			 callback("false",jsonObj);
		 }
	 }, "JmaxAppPlugin", "setDoorPwd", [areaNo,deviceNo,pwd,lockType]);
};

/**
 * 以下几个设置联动的，linkages组成方式： devType1,areaNo1,devNo1,status1;devType2,areaNo2,status2; 跟读取设备状态类似
 * 如果是设置场景联动，那么devType=99；status=场景序号；
 */

/**
 *  设备号、指纹编号、是否有效（0禁用，1启用），时间范围
 *   deviceNo\fpNo\enable\timeRange\linkages
 *
 *
 */
JmaxAppPlugin.prototype.setFpLinkage = function(deviceNo,fpNo,enable,timeRange,linkages,jsonObj,callback) {
    exec(function(rs){
        if(callback) {
            callback(rs,jsonObj);
        }
    }, function(error){
        if(callback) {
            callback("false",jsonObj);
        }
    }, "JmaxAppPlugin", "setFpLinkage", [deviceNo,fpNo,enable,timeRange,linkages]);
};
/**
 * 参考指纹
 * deviceNo\pwdNo\password\enable\timeRange\linkages
 */
JmaxAppPlugin.prototype.setPwdLinkage = function(deviceNo,pwdNo,passsword,enable,timeRange,linkages,jsonObj,callback) {
    exec(function(rs){
        if(callback) {
            callback(rs,jsonObj);
        }
    }, function(error){
        if(callback) {
            callback("false",jsonObj);
        }
    }, "JmaxAppPlugin", "setPwdLinkage", [deviceNo,pwdNo,passsword,enable,timeRange,linkages]);
};

/**
 * deviceNo\devType\linkages
 */
JmaxAppPlugin.prototype.setDefLinkage = function(deviceNo, devType, linkages,
		jsonObj, callback) {
	exec(function(rs) {
		if (callback) {
			callback(rs, jsonObj);
		}
	}, function(error) {
		if (callback) {
			callback("false", jsonObj);
		}
	}, "JmaxAppPlugin", "setDefLinkage", [ deviceNo, devType, linkages ]);
};

/**
 * 定时序号、定时时间（格式2016-02-29 15:00）、禁用或启用，循环模式（字符串格式如："[1,2,3,4,5,6,7] ：1~7-周一至周日，若为[]则单次执行"）
 * timerNo\time\enable\cycle
 */
JmaxAppPlugin.prototype.setTimerLinkage = function(timerNo, time, enable,
		cycle, linkages, jsonObj, callback) {
	exec(function(rs) {
		if (callback) {
			callback(rs, jsonObj);
		}
	}, function(error) {
		if (callback) {
			callback("false", jsonObj);
		}
	}, "JmaxAppPlugin", "setTimerLinkage", [ timerNo, time, enable, cycle,
			linkages ]);
};
module.exports = new JmaxAppPlugin();
