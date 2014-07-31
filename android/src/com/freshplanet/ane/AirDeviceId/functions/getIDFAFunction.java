package com.freshplanet.ane.AirDeviceId.functions;


import java.io.IOException;

import android.app.Activity;
import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.freshplanet.ane.AirDeviceId.AirDeviceIdExtension;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.ads.identifier.AdvertisingIdClient.Info;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;

public class getIDFAFunction implements FREFunction {

	private final String IDFA_VALUE = "IDFA_VALUE";
	
	public FREObject call(FREContext arg0, FREObject[] arg1) {

		final Activity	activity	= arg0.getActivity();
		final Context	context		= activity.getApplicationContext();
		
		// getAdvertisingIdInfo needs to be handled in a separate thread
		Thread idfaThread = new Thread(new Runnable() {
			
			@Override
			public void run() {
				
				Info	adInfo	= null;
				String	adId	= null;
				
				try {
					
					adInfo 	= AdvertisingIdClient.getAdvertisingIdInfo(context);
					adId	= adInfo.getId();
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
				
				AirDeviceIdExtension.context.dispatchStatusEventAsync(IDFA_VALUE, adId);
			}
		});
		
		idfaThread.start();
		
		return null;
	}
}
