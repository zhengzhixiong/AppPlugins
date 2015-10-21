/*
 * Copyright 2013-2015 the original author or authors.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.jmax.plugins;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import com.dnk.smart.communication.monitor.UdpInfo;
import com.dnk.smart.communication.udp.SendHandler;
import com.dnk.smart.communication.udp.UdpServer;
import com.dnk.smart.communication.util.ProcotolUtils;
import com.dnk.smart.communication.vo.AirVo;
import com.dnk.smart.communication.vo.DeviceBand;
import com.dnk.smart.communication.vo.DeviceInfo;
import com.dnk.smart.communication.vo.NetConfig;
import com.dnk.smart.communication.vo.Task;
import com.dnk.smart.communication.vo.WiringVo;
import com.google.gson.Gson;

/**
 * 
 * @author max.zheng
 * @create 2015-10-13下午8:12:55
 * @since 1.0
 * @see
 */
public class JmaxAppPlugin extends CordovaPlugin {
	private CallbackContext callbackContext;
	Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			Bundle data = msg.getData();
			String val = data.getString("value");
			Log.i("mylog", "请求结果为-->" + val);
			callbackContext.success(val);
		}
	};
//	private UdpInfo udpInfo;

	public boolean execute(final String action, final JSONArray args,
			CallbackContext callbackContext) throws JSONException {
		this.callbackContext = callbackContext;
		if ("toast".equals(action)) {
			this.toast(args.getString(0), callbackContext);
			return true;
		} else if ("test".equals(action)) {
			callbackContext.success("调用---" + args.getString(0));
		} else {
			new Thread() {
				@Override
				public void run() {
					try {
						boolean rs = false;
						String result = "";
						
						UdpInfo udpInfo = ProcotolUtils.currentUdpInfo;
						
						if ("initLocalServer".equals(action))
						{
							UdpServer.initUdpServer(args.getString(0));
							result = "true";
						}else if ("controlScene".equals(action))
						{
							//控制场景
							rs = SendHandler.controlScene(udpInfo,Integer.valueOf(args.getString(2)));
							result = rs+"";
						}else if ("controlLight".equals(action))
						{
							//控制灯光
							Log.i("mylog", "ip-->" + udpInfo.getIp());
							rs = SendHandler.controlLight(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)),Integer.valueOf(args.getString(4)));
							result = rs+"";
						}else if ("readLightStatus".equals(action))
						{
							//灯光状态读取
							int b = SendHandler.readLightStatus(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)));
							result = b+"";
						}else if ("controlCurtain".equals(action))
						{
							//控制窗帘
							rs = SendHandler.controlCurtain(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)),Integer.valueOf(args.getString(4)));
							result = rs+"";
						}else if ("readLightStatus".equals(action))
						{
							//窗帘状态读取
							int b = SendHandler.readCurtainStatus(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)));
							result = b+"";
						}else if ("controlAir".equals(action))
						{
							//控制中央空调
							AirVo air = new AirVo(args.getString(4), args.getString(5), args.getString(6), args.getString(7));
							rs = SendHandler.controlAir(udpInfo, Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)), air);
							result = rs+"";
						}else if ("readAirStatus".equals(action))
						{
							//中央空调状态读取
							AirVo air = SendHandler.readAirStatus(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)));
							result = new Gson().toJson(air);
						}else if ("readDefenceStatus".equals(action))
						{
							//防区状态读取
							int b = SendHandler.readDefenceStatus(udpInfo);
							result = b+"";
						}else if ("controlSwitch".equals(action))
						{
							//开关（电器）控制
							rs = SendHandler.controlSwitch(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)),Integer.valueOf(args.getString(4)));
							result = rs+"";
						}else if ("readSwitchStatus".equals(action))
						{
							//开关（电器）状态读取
							WiringVo wiringVo = SendHandler.readSwitchStatus(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)),Integer.valueOf(args.getString(4)));
							result = new Gson().toJson(wiringVo);;
						}else if ("controlInfrared".equals(action))
						{
							//红外设备控制：电视/机顶盒/红外空调
							rs = SendHandler.controlInfrared(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)),Integer.valueOf(args.getString(4)));
							result = rs+"";
						}else if ("controlDoorLock".equals(action))
						{
							//门锁控制
							rs = SendHandler.controlDoorLock(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)),Integer.valueOf(args.getString(4)));
							result = rs+"";
						}else if ("readDoorLock".equals(action))
						{
							//门锁状态读取
							int b = SendHandler.readDoorLock(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)));
							result = b+"";
						}else if ("checkControl".equals(action))
						{
							//对码控制
							rs = SendHandler.checkControl(udpInfo,Integer.valueOf(args.getString(2)));
							result = rs+"";
						}else if ("clearConfig".equals(action))
						{
							//清除配置
							rs = SendHandler.clearConfig(udpInfo);
							result = rs+"";
						}else if ("sceneConfig".equals(action))
						{
							//场景配置
							AirVo air = new AirVo(args.getString(7), args.getString(8), args.getString(9), args.getString(10));
							rs = SendHandler.sceneConfig(udpInfo, Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)), Integer.valueOf(args.getString(4)), Integer.valueOf(args.getString(5)), Integer.valueOf(args.getString(6)), air);
							result = rs+"";
						}else if ("networkTest".equals(action))
						{
							//网关测试
							UdpInfo tempUdpInfo = new UdpInfo(args.getString(0), args.getString(1));
							rs = SendHandler.networkTest(tempUdpInfo);
							result = rs+"";
						}else if ("timeTask".equals(action))
						{
							//定时配置
							Task task = new Task(args.getString(2), args.getString(3), args.getString(4), args.getString(5), args.getString(6), args.getString(7), args.getString(8), args.getString(9), args.getString(10), args.getString(11));
							rs = SendHandler.timeTask(udpInfo, task);
							result = rs+"";
						}else if ("setSn".equals(action))
						{
							//设置设备SN码
							rs = SendHandler.setSn(udpInfo, Integer.valueOf(args.getString(2)), Integer.valueOf(args.getString(3)), Integer.valueOf(args.getString(4)), Integer.valueOf(args.getString(5)));
							result = rs+"";
						}else if ("setNetConfig".equals(action))
						{
							//设置网络参数
							NetConfig netConfig = new NetConfig(args.getString(2), Integer.valueOf(args.getString(3)), args.getString(4), args.getString(5), args.getString(6), Integer.valueOf(args.getString(7)));
							rs = SendHandler.setNetConfig(udpInfo, netConfig);
							result = rs+"";
						}else if ("readNetConfig".equals(action))
						{
							//读取网络参数
							NetConfig netConfig = SendHandler.readNetConfig(udpInfo);
							result = new Gson().toJson(netConfig);
						}else if ("scanSearchNetConfig".equals(action))
						{
							//自动广播扫描
							NetConfig netConfig = SendHandler.scanSearchNetConfig();
							result = new Gson().toJson(netConfig);
						}else if ("setDeviceBand".equals(action))
						{
							//设置设备绑定表
							DeviceBand deviceBand = new DeviceBand(args.getString(2), args.getString(3), args.getString(4), args.getString(5), args.getString(6), args.getString(7));
							rs = SendHandler.setDeviceBand(udpInfo, deviceBand);
							result = rs+"";
						}else if ("readDeviceBand".equals(action))
						{
							//读取设备绑定
							DeviceBand deviceBand = new DeviceBand(args.getString(2), args.getString(3), args.getString(4), args.getString(5), args.getString(6), args.getString(7));
							deviceBand = SendHandler.readDeviceBand(udpInfo, deviceBand);
							result = new Gson().toJson(deviceBand);
						}else if ("startDeviceBand".equals(action))
						{
							//app开始设备绑定
							rs = SendHandler.appStartDeviceBand(udpInfo,args.getInt(2), args.getInt(3), args.getInt(4),args.getInt(5));
							result = rs+"";
						}else if ("testDeviceBand".equals(action))
						{
							//测试设备绑定是否成功
							rs = SendHandler.appTestDeviceBand(udpInfo,args.getInt(2), args.getInt(3), args.getInt(4),args.getInt(5));
							result = rs+"";
						}else if ("readDeviceInfo".equals(action))
						{
							//读取设备
							DeviceInfo deviceInfo = SendHandler.readDeviceInfo(udpInfo, Integer.valueOf(args.getString(2)));
							result = new Gson().toJson(deviceInfo);;
						}else if ("deleteDeviceInfo".equals(action))
						{
							//删除设备
							rs = SendHandler.deleteDeviceInfo(udpInfo, Integer.valueOf(args.getString(2)));
							result = rs+"";
						}else if ("readModuleSoft".equals(action))
						{
							//读取软件版本
							int b = SendHandler.readModuleSoft(udpInfo, args.getString(2));
							result = b+"";
						}else if ("reboot".equals(action))
						{
							//重启设备
							rs = SendHandler.reboot(udpInfo,args.getString(2));
							result = rs+"";
						}
						//处理结果
						Message msg = new Message();
				        Bundle data = new Bundle();
				        data.putString("value",result);
				        msg.setData(data);
				        handler.sendMessage(msg);
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}.start();

		}

		return true;
	}

	/**
	 * 
	 * @author max.zheng
	 * @create 2015-10-13下午8:16:04
	 * @modified by
	 * @param msg
	 * @param callbackContext
	 */
	private void toast(final String msg, final CallbackContext callbackContext) {
		this.cordova.getActivity().runOnUiThread(new Runnable() {
			public void run() {
				Toast.makeText(cordova.getActivity(), msg, 1000).show();
			}
		});
	}

}
