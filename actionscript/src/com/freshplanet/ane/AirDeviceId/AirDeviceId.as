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

package com.freshplanet.ane.AirDeviceId {

import com.freshplanet.ane.AirDeviceId.events.AirDeviceIdEvent;

import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;

	public class AirDeviceId extends EventDispatcher {

		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									   PUBLIC API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//

		/** AirAlert is supported on iOS and Android devices. */
		public static function get isSupported() : Boolean {
			return isAndroid || isIOS;
		}

		/**
		 * AirDeviceId instance
		 * @return AirDeviceId instance
		 */
		public static function get instance() : AirDeviceId {
			return _instance ? _instance : new AirDeviceId();
		}
          
		/**
		 * Get vendor identifier
		 * @return
		 */
		public function getIDFV():void {

			if (isSupported)
				_context.call( 'getIDFV' );
		}

		/**
		 * Get advertising identifier
		 * @return
		 */
		public function getIDFA() : void {

			if ( isSupported )
				_context.call( 'getIDFA' );

		}

		// --------------------------------------------------------------------------------------//
		//																						 //
		// 									 	PRIVATE API										 //
		// 																						 //
		// --------------------------------------------------------------------------------------//

		private static const EXTENSION_ID : String = "com.freshplanet.ane.AirDeviceId";
		private static var _instance : AirDeviceId = null;
		private var _context : ExtensionContext = null;

		/**
		 * "private" singleton constructor
		 */
		public function AirDeviceId() {
			
			if ( !_instance ) {
				
				_context = ExtensionContext.createExtensionContext( EXTENSION_ID, null );
				
				if  (_context != null ) {
					_context.addEventListener( StatusEvent.STATUS, _onStatus );
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
		 * Status events allow the native part of the ANE to communicate with the ActionScript part.
		 * We use event.code to represent the type of event, and event.level to carry the data.
		 */
		private function _onStatus( event:StatusEvent ) : void {

			if ( event.code == AirDeviceIdEvent.RECEIVED_IDFA || event.code == AirDeviceIdEvent.RECEIVED_IDFV) {
				this.dispatchEvent(new AirDeviceIdEvent(event.code, event.level));
			}
			else if ( event.code == "log" ) {
				trace( '[AirDeviceId] ' + event.level );
			}
		}

		private static function get isIOS():Boolean {
			return Capabilities.manufacturer.indexOf("iOS") > -1 && Capabilities.os.indexOf("x86_64") < 0 && Capabilities.os.indexOf("i386") < 0;
		}

		private static function get isAndroid():Boolean {
			return Capabilities.manufacturer.indexOf("Android") > -1;
		}
	}
}
