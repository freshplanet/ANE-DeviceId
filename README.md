Air Native Extension to access a device unique id (iOS + Android)
======================================

This is an [Air native extension](http://www.adobe.com/devnet/air/native-extensions-for-air.html) that gives you access to a device unique id and an advertiser unique id. It has been developed by [FreshPlanet](http://freshplanet.com).

Usage
---------

Complete usage example is in the *sample* directory.

On android make sure to add this to your android manifest additions inside the application descriptor:

    
    <application android:enabled="true">
        ...
        <meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version" />
        ...
     </application>
    

Build script
---------

Should you need to edit the extension source code and/or recompile it, you will find an ant build script (build.xml) in the *build* folder:

    cd /path/to/the/ane/build
    #edit the build.properties file to provide your machine-specific paths
    ant

    
Notes:
* included binary has been compiled for 64-bit iOS support

Reference
------

- iOS 6 http://developer.apple.com/library/ios/#DOCUMENTATION/UIKit/Reference/UIDevice_Class/Reference/UIDevice.html#//apple_ref/occ/instp/UIDevice/identifierForVendor
http://developer.apple.com/library/ios/#documentation/AdSupport/Reference/ASIdentifierManager_Ref/ASIdentifierManager.html#//apple_ref/occ/instp/ASIdentifierManager/advertisingIdentifier
- iOS 5 http://developer.apple.com/library/ios/#DOCUMENTATION/UIKit/Reference/UIDevice_Class/DeprecationAppendix/AppendixADeprecatedAPI.html
- Android http://developer.android.com/reference/android/provider/Settings.Secure.html#ANDROID_ID

Authors
------

This ANE has been written by [Arnaud Bernard](https://github.com/arnobern) and [Mateo Kozomara](mateo.kozomara@gmail.com). It belongs to [FreshPlanet Inc.](http://freshplanet.com) and is distributed under the [Apache Licence, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).


Join the FreshPlanet team - GAME DEVELOPMENT in NYC
------

We are expanding our mobile engineering teams.

FreshPlanet is a NYC based mobile game development firm and we are looking for senior engineers to lead the development initiatives for one or more of our games/apps. We work in small teams (6-9) who have total product control.  These teams consist of mobile engineers, UI/UX designers and product experts.


Please contact Tom Cassidy (tcassidy@freshplanet.com) or apply at http://freshplanet.com/jobs/
