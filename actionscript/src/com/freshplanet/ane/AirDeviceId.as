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

package com.freshplanet.ane {
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;

	public class AirDeviceId extends EventDispatcher {
		
		private static var _instance : AirDeviceId = null;
		
		private var _extCtx : ExtensionContext = null;
		private var _id 	: String = null;
		private var _idfv	: String = null;
		private var _idfa	: String = null;
		
		private var _idfaCallbacks : Vector.<Function> = new Vector.<Function>();
		
		/**
		 * AirDeviceId constructor
		 */		
		public function AirDeviceId() {
			
			if ( !_instance ) {
				
				_extCtx = ExtensionContext.createExtensionContext( 'com.freshplanet.ane.AirDeviceId', null );
				
				if  (_extCtx != null ) {
					_extCtx.addEventListener( StatusEvent.STATUS, onStatus );
				} 
				else {
					trace('[AirDeviceId] Error - Extension Context is null.');
				}
				
				_instance = this;
			}
			else {
				throw Error( 'This is a singleton, use getInstance(), do not call the constructor directly.' );
			}
		}
		
		/**
		 * singleton getter
		 * @return 
		 */		
		public static function getInstance() : AirDeviceId {
			return _instance ? _instance : new AirDeviceId();
		}
		
		/**
		 * @return test for determining if this is being run on a device
		 */		
		public function get isOnDevice() : Boolean {
		
			var value : Boolean = this.isOnIOS || this.isOnAndroid;
			return value;
		}
		
		/**
		 * @return 
		 */		
		public function get isOnIOS() : Boolean {
			
			var value : Boolean = Capabilities.manufacturer.indexOf( 'iOS' ) > -1;
			return value;
		}
		
		/**
		 * @return 
		 */		
		public function get isOnAndroid() : Boolean {
			
			var value : Boolean = Capabilities.manufacturer.indexOf( 'Android' ) > -1;
			return value;
		}
		
		/**
		 * Example function.
		 * Define your own API and use extCtx.call() to communicate with the native part of the ANE.
		 */
		public function isSupported() : Boolean {
			return _extCtx.call( 'isSupported' );
		}
		
		/**
		 * 
		 * @param 	salt		a developer specific salt
		 * @param	callback	
		 * @return				unique id for this device
		 */
		public function getID( salt:String, callback:Function ) : void {
			
			if ( !this.isOnDevice ) {
				
				callback( 'simulator' );
				return;
			}
			
			if ( !_id ) {
				_id = _extCtx.call( 'getID', salt ) as String;
			}
			
			callback( _id );
		}
		
		/**
		 * @param	callback	d
		 * @return 				vendor id or null on unavailable/Android
		 */
		public function getIDFV( callback:Function ) : void {
			
			if ( !this.isOnDevice ) {
			
				callback( null );
				return;
			}
			
			if ( !_idfv ) {
				_idfv = _extCtx.call( 'getIDFV' ) as String;
			}
			else {
				_extCtx.call( 'getIDFV' );
			}
			
			callback( _idfv == '00000000-0000-0000-0000-000000000000' ? null : _idfv );
		}
		
		/**
		 * @param	callback	d
		 * @return 				advertiser id
		 */
		public function getIDFA( callback:Function ) : void {
			
			if ( !this.isOnDevice ) {
				
				callback( null );
				return;
			}
			
			if ( _idfa ) {
				callback( _idfa == '00000000-0000-0000-0000-000000000000' ? null : _idfa );
			}
			else if ( isOnIOS ) {
				
				_idfa = _extCtx.call( 'getIDFA' ) as String;
				callback( _idfa == '00000000-0000-0000-0000-000000000000' ? null : _idfa );
			}
			else {
				
				if ( _idfaCallbacks.length == 0 ) {
					_extCtx.call( 'getIDFA' );
				}
				
				_idfaCallbacks.push( callback );
			}
		}
		
		/**
		 * Status events allow the native part of the ANE to communicate with the ActionScript part.
		 * We use event.code to represent the type of event, and event.level to carry the data.
		 */
		private function onStatus( event:StatusEvent ) : void {
			
			if ( event.code == 'LOGGING' ) {
				trace( '[AirDeviceId] ' + event.level );
			}
			else if ( event.code == 'IDFA_VALUE' ) {
				
				_idfa = null;

				var callbacks : Vector.<Function> = _idfaCallbacks.slice();
				_idfaCallbacks.length = 0;
				
				for each ( var callback:Function in callbacks ) {
					callback( _idfa == '00000000-0000-0000-0000-000000000000' ? null : _idfa );
				}
			}
		}
	}
}
