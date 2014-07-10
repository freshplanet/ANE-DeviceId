package com.freshplanet.ane.AirDeviceId.functions;


import java.io.IOException;

import android.app.Activity;
import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.ads.identifier.AdvertisingIdClient.Info;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;

public class getIDFAFunction implements FREFunction {

	public FREObject call(FREContext arg0, FREObject[] arg1) {
		
		FREObject 	ret 		= null;
		Info		adInfo		= null;
		String		adId		= null;
		
		Activity	activity	= arg0.getActivity();
		Context		context		= activity.getApplicationContext();
		
		try {
			
			adInfo 	= AdvertisingIdClient.getAdvertisingIdInfo(context);
			adId	= adInfo.getId();
			ret 	= FREObject.newObject(adId);
		} 
		catch (FREWrongThreadException e) {
			e.printStackTrace();
		} 
		catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		catch (GooglePlayServicesRepairableException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		catch (GooglePlayServicesNotAvailableException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return ret;
	}
}
