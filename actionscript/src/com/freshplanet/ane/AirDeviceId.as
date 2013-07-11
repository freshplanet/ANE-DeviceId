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
		private var _id 	: String = null;
		private var _idfv	: String = null;
		private var _idfa	: String = null;
		
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
		 * 
		 * @param salt	a developer specific salt
		 * @return		unique id for this device
		 */
		public function getID( salt:String ) : String {
			
			if ( !this.isOnDevice ) {
				return "simulator";
			}
			
			if ( !this._id ) {
				this._id = this.extCtx.call( 'getID', salt ) as String;
			}
			
			return this._id;
		}
		
		/**
		 * @return vendor id or null on unavailable/Android
		 */
		public function getIDFV() : String {
			
			if ( !this.isOnDevice ) {
				return null;
			}
			
			if ( !this._idfv ) {
				this._idfv = extCtx.call( 'getIDFV' ) as String;
			}
			
			return this._idfv;
		}
		
		/**
		 * @return advertiser id or null on unavailable/Android
		 */
		public function getIDFA() : String {
			
			if ( !this.isOnDevice ) {
				return null;
			}
			
			if ( !this._idfa ) {
				this._idfa = extCtx.call( 'getIDFA' ) as String;
			}
			
			return this._idfa;
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
