package com.freshplanet.ane.AirDeviceId.functions;

public class getIDFunction extends FREFunction {

	public FREObject call(FREContext arg0, FREObject[] arg1) {
		FREObject deviceId = null;
		try {
			deviceId = FREObject.newObject(Secure.getString(arg0.getActivity().getContentResolver(), Secure.ANDROID_ID));
		} catch (FREWrongThreadException e) {
			e.printStackTrace();
		}
		return deviceId;
	}
}
