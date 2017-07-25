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

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirDeviceId.AirDeviceIdExtension;
import com.freshplanet.ane.AirDeviceId.Constants;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;

import java.io.IOException;

public class GetIDFAFunction extends BaseFunction {

	public FREObject call(FREContext context, FREObject[] args) {

		super.call(context, args);

		final Activity activity	= context.getActivity();
		final Context applicationContext		= activity.getApplicationContext();

		Thread idfaThread = new Thread(new Runnable() {

			@Override
			public void run() {

				try {
					finished(activity, AdvertisingIdClient.getAdvertisingIdInfo(applicationContext));
				}
				catch (GooglePlayServicesRepairableException e) {
					AirDeviceIdExtension.context.dispatchStatusEventAsync("log", "Exception occurred while trying to getIDFA " + e.getLocalizedMessage() );
				}
				catch (GooglePlayServicesNotAvailableException e) {
					AirDeviceIdExtension.context.dispatchStatusEventAsync("log", "Exception occurred while trying to getIDFA " + e.getLocalizedMessage() );
				}
				catch (IOException e) {
					AirDeviceIdExtension.context.dispatchStatusEventAsync("log", "Exception occurred while trying to getIDFA " + e.getLocalizedMessage() );
				}

			}
		});

		idfaThread.start();

		return null;

	}

	private void finished(final Activity activity, final AdvertisingIdClient.Info adInfo){
		if (adInfo != null) {
			activity.runOnUiThread(new Runnable() {
				@Override
				public void run() {
					String idfa = adInfo.getId();
					AirDeviceIdExtension.context.dispatchStatusEventAsync(Constants.AirDeviceIdEvent_receivedIDFA, idfa );
				}
			});
		}
		else {
			AirDeviceIdExtension.context.dispatchStatusEventAsync(Constants.AirDeviceIdEvent_receivedIDFA, "" );
		}

	}
}
