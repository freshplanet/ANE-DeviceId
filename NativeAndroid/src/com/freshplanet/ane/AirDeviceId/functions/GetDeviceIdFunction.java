package com.freshplanet.ane.AirDeviceId.functions;

import android.provider.Settings.Secure;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

public class GetDeviceIdFunction implements FREFunction {

	public FREObject call(FREContext arg0, FREObject[] arg1) {
		FREObject deviceId = null;
		try {
			deviceId = FREObject.newObject(Secure.ANDROID_ID);
		} catch (FREWrongThreadException e) {
			e.printStackTrace();
		}
		return deviceId;
	}

}
