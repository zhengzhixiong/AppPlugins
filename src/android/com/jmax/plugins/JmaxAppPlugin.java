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
import org.json.JSONObject;

import com.dnk.smart.communication.monitor.UdpInfo;
import com.dnk.smart.communication.udp.SendHandler;
import com.dnk.smart.communication.udp.UdpServer;
import com.dnk.smart.communication.vo.AirVo;
import com.dnk.smart.communication.vo.DeviceBand;
import com.dnk.smart.communication.vo.DeviceInfo;
import com.dnk.smart.communication.vo.NetConfig;
import com.dnk.smart.communication.vo.Task;
import com.dnk.smart.communication.vo.WiringVo;
import com.google.gson.Gson;

import android.widget.Toast;

/**
 *
 * @author max.zheng
 * @create 2015-10-13下午8:12:55
 * @since 1.0
 * @see
 */
public class JmaxAppPlugin extends CordovaPlugin {
	private UdpInfo udpInfo;
	public boolean execute(String action, JSONArray args,
			CallbackContext callbackContext) throws JSONException {
		boolean rs = false;
		String result = "";
		if ("toast".equals(action)) {
			this.toast(args.getString(0), callbackContext);
			return true;
		}else if ("test".equals(action)) {
			result = "调用---"+args.getString(0);
		}else if ("initLocalServer".equals(action))
		{
			UdpServer.initUdpServer(args.getString(0));
			result = "true";
		}else if ("controlScene".equals(action))
		{
			//控制场景
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			rs = SendHandler.controlScene(udpInfo,Integer.valueOf(args.getString(2)));
			result = rs+"";
		}else if ("controlLight".equals(action))
		{
			//控制灯光
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			rs = SendHandler.controlLight(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)),Integer.valueOf(args.getString(4)));
			result = rs+"";
		}else if ("readLightStatus".equals(action))
		{
			//灯光状态读取
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			int b = SendHandler.readLightStatus(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)));
			result = b+"";
		}else if ("controlCurtain".equals(action))
		{
			//控制窗帘
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			rs = SendHandler.controlCurtain(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)),Integer.valueOf(args.getString(4)));
			result = rs+"";
		}else if ("readLightStatus".equals(action))
		{
			//窗帘状态读取
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			int b = SendHandler.readCurtainStatus(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)));
			result = b+"";
		}else if ("controlAir".equals(action))
		{
			//控制中央空调
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			AirVo air = new AirVo(args.getString(4), args.getString(5), args.getString(6), args.getString(7));
			rs = SendHandler.controlAir(udpInfo, Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)), air);
			result = rs+"";
		}else if ("readAirStatus".equals(action))
		{
			//中央空调状态读取
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			AirVo air = SendHandler.readAirStatus(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)));
			result = new Gson().toJson(air);
		}else if ("readDefenceStatus".equals(action))
		{
			//防区状态读取
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			int b = SendHandler.readDefenceStatus(udpInfo);
			result = b+"";
		}else if ("controlSwitch".equals(action))
		{
			//开关（电器）控制
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			rs = SendHandler.controlSwitch(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)),Integer.valueOf(args.getString(4)));
			result = rs+"";
		}else if ("readSwitchStatus".equals(action))
		{
			//开关（电器）状态读取
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			WiringVo wiringVo = SendHandler.readSwitchStatus(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)),Integer.valueOf(args.getString(4)));
			result = new Gson().toJson(wiringVo);;
		}else if ("controlInfrared".equals(action))
		{
			//红外设备控制：电视/机顶盒/红外空调
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			rs = SendHandler.controlInfrared(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)),Integer.valueOf(args.getString(4)));
			result = rs+"";
		}else if ("controlDoorLock".equals(action))
		{
			//门锁控制
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			rs = SendHandler.controlDoorLock(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)),Integer.valueOf(args.getString(4)));
			result = rs+"";
		}else if ("readDoorLock".equals(action))
		{
			//门锁状态读取
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			int b = SendHandler.readDoorLock(udpInfo,Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)));
			result = b+"";
		}else if ("checkControl".equals(action))
		{
			//对码控制
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			rs = SendHandler.checkControl(udpInfo,Integer.valueOf(args.getString(2)));
			result = rs+"";
		}else if ("clearConfig".equals(action))
		{
			//清除配置
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			rs = SendHandler.clearConfig(udpInfo);
			result = rs+"";
		}else if ("sceneConfig".equals(action))
		{
			//场景配置
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			AirVo air = new AirVo(args.getString(7), args.getString(8), args.getString(9), args.getString(10));
			rs = SendHandler.sceneConfig(udpInfo, Integer.valueOf(args.getString(2)),Integer.valueOf(args.getString(3)), Integer.valueOf(args.getString(4)), Integer.valueOf(args.getString(5)), Integer.valueOf(args.getString(6)), air);
			result = rs+"";
		}else if ("networkTest".equals(action))
		{
			//网关测试
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			rs = SendHandler.networkTest(udpInfo);
			result = rs+"";
		}else if ("timeTask".equals(action))
		{
			//定时配置
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			Task task = new Task(args.getString(2), args.getString(3), args.getString(4), args.getString(5), args.getString(6), args.getString(7), args.getString(8), args.getString(9), args.getString(10), args.getString(11));
			rs = SendHandler.timeTask(udpInfo, task);
			result = rs+"";
		}else if ("setSn".equals(action))
		{
			//设置设备SN码
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			rs = SendHandler.setSn(udpInfo, Integer.valueOf(args.getString(2)), Integer.valueOf(args.getString(3)), Integer.valueOf(args.getString(4)), Integer.valueOf(args.getString(5)));
			result = rs+"";
		}else if ("setNetConfig".equals(action))
		{
			//设置网络参数
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			NetConfig netConfig = new NetConfig(args.getString(2), Integer.valueOf(args.getString(3)), args.getString(4), args.getString(5), args.getString(6), Integer.valueOf(args.getString(7)));
			rs = SendHandler.setNetConfig(udpInfo, netConfig);
			result = rs+"";
		}else if ("readNetConfig".equals(action))
		{
			//读取网络参数
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
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
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			DeviceBand deviceBand = new DeviceBand(args.getString(2), args.getString(3), args.getString(4), args.getString(5), args.getString(6), args.getString(7));
			rs = SendHandler.setDeviceBand(udpInfo, deviceBand);
			result = rs+"";
		}else if ("readDeviceBand".equals(action))
		{
			//读取设备绑定
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			DeviceBand deviceBand = new DeviceBand(args.getString(2), args.getString(3), args.getString(4), args.getString(5), args.getString(6), args.getString(7));
			deviceBand = SendHandler.readDeviceBand(udpInfo, deviceBand);
			result = new Gson().toJson(deviceBand);
		}else if ("startDeviceBand".equals(action))
		{
			//开始设备绑定表
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			DeviceBand deviceBand = new DeviceBand(args.getString(2), args.getString(3), args.getString(4), args.getString(5), args.getString(6), args.getString(7));
			rs = SendHandler.startDeviceBand(udpInfo, deviceBand);
			result = rs+"";
		}else if ("testDeviceBand".equals(action))
		{
			//测试设备绑定
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			DeviceBand deviceBand = new DeviceBand(args.getString(2), args.getString(3), args.getString(4), args.getString(5), args.getString(6), args.getString(7));
			rs = SendHandler.testDeviceBand(udpInfo, deviceBand);
			result = rs+"";
		}else if ("readDeviceInfo".equals(action))
		{
			//读取设备
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			DeviceInfo deviceInfo = SendHandler.readDeviceInfo(udpInfo, Integer.valueOf(args.getString(2)));
			result = new Gson().toJson(deviceInfo);;
		}else if ("deleteDeviceInfo".equals(action))
		{
			//删除设备
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			rs = SendHandler.deleteDeviceInfo(udpInfo, Integer.valueOf(args.getString(2)));
			result = rs+"";
		}else if ("readModuleSoft".equals(action))
		{
			//开始设备绑定表
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			int b = SendHandler.readModuleSoft(udpInfo, args.getString(2));
			result = b+"";
		}else if ("reboot".equals(action))
		{
			//重启设备
			udpInfo = new UdpInfo(args.getString(0), args.getString(1));
			rs = SendHandler.reboot(udpInfo,args.getString(2));
			result = rs+"";
		}
		
		callbackContext.success(result);
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
