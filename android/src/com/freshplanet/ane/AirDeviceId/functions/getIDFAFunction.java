package com.freshplanet.ane.AirDeviceId.functions;


import java.io.IOException;

import android.app.Activity;
import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.freshplanet.ane.AirDeviceId.AirDeviceIdExtension;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
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
				
				try {
					finished(activity, AdvertisingIdClient.getAdvertisingIdInfo(context));
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
	            	AirDeviceIdExtension.context.dispatchStatusEventAsync(IDFA_VALUE, idfa);
	            }
	        });
	    }
	}
}
