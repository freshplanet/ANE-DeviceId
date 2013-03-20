Air Native Extension to access a device unique id (iOS + Android)
======================================

This is an [Air native extension](http://www.adobe.com/devnet/air/native-extensions-for-air.html) that gives you access to a device unique id and an advertiser unique id. It has been developed by [FreshPlanet](http://freshplanet.com).


Build script
---------

Should you need to edit the extension source code and/or recompile it, you will find an ant build script (build.xml) in the *build* folder:

    cd /path/to/the/ane/build
    #edit the build.properties file to provide your machine-specific paths
    ant

Reference
------

- iOS 6 http://developer.apple.com/library/ios/#DOCUMENTATION/UIKit/Reference/UIDevice_Class/Reference/UIDevice.html#//apple_ref/occ/instp/UIDevice/identifierForVendor
http://developer.apple.com/library/ios/#documentation/AdSupport/Reference/ASIdentifierManager_Ref/ASIdentifierManager.html#//apple_ref/occ/instp/ASIdentifierManager/advertisingIdentifier
- iOS 5 http://developer.apple.com/library/ios/#DOCUMENTATION/UIKit/Reference/UIDevice_Class/DeprecationAppendix/AppendixADeprecatedAPI.html
- Android http://developer.android.com/reference/android/provider/Settings.Secure.html#ANDROID_ID

Authors
------

This ANE has been written by [Arnaud Bernard](https://github.com/arnobern). It belongs to [FreshPlanet Inc.](http://freshplanet.com) and is distributed under the [Apache Licence, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).