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

import com.dnk.smart.communication.udp.SendHandler;

import android.widget.Toast;

/**
 *
 * @author max.zheng
 * @create 2015-10-13下午8:12:55
 * @since 1.0
 * @see
 */
public class JmaxAppPlugin extends CordovaPlugin {
	public boolean execute(String action, JSONArray args,
			CallbackContext callbackContext) throws JSONException {
		if ("toast".equals(action)) {
			this.toast(args.getString(0), callbackContext);
			return true;
		}else if ("test".equals(action)) {
			boolean rs = SendHandler.initLocalSocket(16000);
			callbackContext.success(rs+"---"+args.getString(0));
			return true;
		}
		callbackContext.success();
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
