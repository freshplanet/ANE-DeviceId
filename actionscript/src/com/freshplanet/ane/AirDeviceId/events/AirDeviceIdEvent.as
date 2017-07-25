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
	private var _idfa:String;

	public function AirDeviceIdEvent(type:String, idfa:String, bubbles:Boolean = false, cancelable:Boolean = false) {
		super(type, bubbles, cancelable);
		_idfa = idfa;
	}

	public function get idfa():String {
		return _idfa;
	}
}
}
