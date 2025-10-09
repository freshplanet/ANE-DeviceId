/*
 * Copyright 2017 FreshPlanet
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.freshplanet.ane.AirDeviceId.functions;

import android.app.Activity;
import android.content.Context;

import android.provider.Settings.Secure;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirDeviceId.AirDeviceIdExtension;

import com.freshplanet.ane.AirDeviceId.Constants;
import com.google.android.gms.appset.AppSet;
import com.google.android.gms.appset.AppSetIdClient;
import com.google.android.gms.appset.AppSetIdInfo;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;

public class GetIDFVFunction extends BaseFunction {

	public FREObject call(FREContext context, FREObject[] args) {

		super.call(context, args);

		// Closest thing to iOS' IDFV on Android
		Context applicationContext = context.getActivity().getApplicationContext();
		AppSetIdClient client = AppSet.getClient(applicationContext);
		Task<AppSetIdInfo> task = client.getAppSetIdInfo();

		task.addOnSuccessListener(new OnSuccessListener<AppSetIdInfo>() {
			@Override
			public void onSuccess(AppSetIdInfo info) {
				finished(context.getActivity(), info);
			}
		});

		task.addOnFailureListener(new OnFailureListener() {
			@Override
			public void onFailure(Exception e) {
				AirDeviceIdExtension.context.dispatchStatusEventAsync("log", "Exception occurred while trying to getIDFV " + e.getLocalizedMessage() );
			}
		});

		return null;

	}

	private void finished(final Activity activity, final AppSetIdInfo info){
		if (info != null) {
			activity.runOnUiThread(new Runnable() {
				@Override
				public void run() {
					String idfv = info.getId();
					AirDeviceIdExtension.context.dispatchStatusEventAsync(Constants.AirDeviceIdEvent_receivedIDFV, idfv );
				}
			});
		}
		else {
			AirDeviceIdExtension.context.dispatchStatusEventAsync(Constants.AirDeviceIdEvent_receivedIDFV, "" );
		}

	}
}