//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Freshplanet (http://freshplanet.com | opensource@freshplanet.com)
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  
//////////////////////////////////////////////////////////////////////////////////////

package com.freshplanet.ane
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;

	public class AirDeviceId extends EventDispatcher
	{
		private static var _instance:AirDeviceId;
		
		private var extCtx:ExtensionContext = null;
		private var _deviceId:String;
		private var _advertisingId:String;
				
		public function AirDeviceId()
		{
			if (!_instance)
			{
				extCtx = ExtensionContext.createExtensionContext("com.freshplanet.ane.AirDeviceId", null);
				if (extCtx != null)
				{
					extCtx.addEventListener(StatusEvent.STATUS, onStatus);
				} 
				else
				{
					trace('[AirDeviceId] Error - Extension Context is null.');
				}
				_instance = this;
			}
			else
			{
				throw Error('This is a singleton, use getInstance(), do not call the constructor directly.');
			}
		}
		
		public static function getInstance() : AirDeviceId
		{
			return _instance ? _instance : new AirDeviceId();
		}
		
		public function get isOnDevice():Boolean
		{
			var value:Boolean = this.isOnIOS || this.isOnAndroid;
			return value;
		}
		
		public function get isOnIOS():Boolean
		{
			var value:Boolean = Capabilities.manufacturer.indexOf('iOS') > -1;
			return value;
		}
		
		public function get isOnAndroid():Boolean
		{
			var value:Boolean = Capabilities.manufacturer.indexOf('Android') > -1;
			return value;
		}
		
		/**
		 * Example function.
		 * Define your own API and use extCtx.call() to communicate with the native part of the ANE.
		 */
		public function isSupported() : Boolean {
			return extCtx.call( 'isSupported' );
		}
		
		/**
		 * Returns a unique id on ios and android, "emulator" otherwise.
		 * @param salt a developer specific salt
		 */
//		public function getDeviceId(salt:String) : String
//		{
//			if(!this.isOnDevice)
//				return "emulator";
//			if(!this._deviceId)
//				this._deviceId = this.extCtx.call('getDeviceId', salt) as String;
//			return this._deviceId;
//		}
		
		/**
		 * Returns the advertising id on ios > 6.0, the same as getDeviceId otherwise.
		 * @param salt a developer specific salt
		 */
//		public function getAdvertisingId(salt:String) : String
//		{
//			if(!this.isOnDevice)
//				return "emulator";
//			if(!this._advertisingId)
//			{
//				if(this.isOnIOS)
//					this._advertisingId = this.extCtx.call('getAdvertisingId', salt) as String;
//				else
//					this._advertisingId = getDeviceId(salt);
//			}
//			return this._advertisingId;
//		}
		
		/**
		 * 
		 * @param salt	a developer specific salt
		 * @return		unique id for this device
		 */
		public function getID( salt:String ) : String {
			
			if ( !this.isOnDevice ) {
				return "emulator";
			}
			
			if ( !this._deviceId ) {
				this._deviceId = this.extCtx.call( 'getID', salt ) as String;
			}
			
			return this._deviceId;
		}
		
		/**
		 * @return vendor id or null on unavailable/Android
		 */
		public function getIDFV() : String {
			return extCtx.call( 'getIDFV' );
		}
		
		/**
		 * @return advertiser id or null on unavailable/Android
		 */
		public function getIDFA() : String {
			return extCtx.call( 'getIDFA' );
		}
		
		/**
		 * Status events allow the native part of the ANE to communicate with the ActionScript part.
		 * We use event.code to represent the type of event, and event.level to carry the data.
		 */
		private function onStatus( event : StatusEvent ) : void
		{
			if (event.code == "LOGGING")
			{
				trace('[AirDeviceId] ' + event.level);
			}
		}
	}
}
