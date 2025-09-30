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

package com.freshplanet.ane.AirDeviceId.events {
import flash.events.Event;

public class AirDeviceIdEvent extends Event {

	public static const RECEIVED_IDFA:String = "AirDeviceIdEvent_receivedIDFA";
	public static const RECEIVED_IDFV:String = "AirDeviceIdEvent_receivedIDFV";
	private var _id:String;

	public function AirDeviceIdEvent(type:String, id:String, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
		_id = id;
	}

	public function get idfa():String {
		return _id;
	}

	public function get idfv():String {
		return _id;
	}
}
}
