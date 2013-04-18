#!/bin/bash

adt -package -target ane Binaries/AirDeviceId.ane AS/src/extension.xml\
    -swc AS/bin/AirDeviceId.swc\
    -platform default -C Binaries/Default .\
    -platform iPhone-ARM\
      -platformoptions NativeIOS/AirDeviceId/AirDeviceId/platformoptions.xml -C Binaries/iOS .\
    -platform Android-ARM\
      -C Binaries/Android .
