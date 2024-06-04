# Flutter Stripe Payment Gateway

This README file provides a step-by-step guide on integrating Stripe Payment gateway into your Flutter application. Follow the instructions below to set up and configure stripe payment for Android platform.

## Getting Started

1. Dependencies
- Add below dependencies in pubspec.yaml

```
  flutter_stripe: ^10.1.1
  flutter_dotenv: ^5.1.0
  http: ^1.2.1
```
2. Add this permission in AndroidManifest.xml file
  - Use Android 5.0 (API level 21) and above
  - Use Kotlin version 1.5.0 and above
  - Requires Android Gradle plugin 8 and higher
  - Using a descendant of Theme.AppCompat for your activity
    - payment_gateway_demo/android/app/src/main/res/values-night/styles.xml
```
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is on -->
    <!-- TODO document the necessary change -->
    <style name="LaunchTheme" parent="Theme.AppCompat.DayNight.NoActionBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             Flutter draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.
         
         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="Theme.MaterialComponents">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>
```
  - payment_gateway_demo/android/app/src/main/res/values/styles.xml
```
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Theme applied to the Android Window while the process is starting when the OS's Dark Mode setting is off -->
    <style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
        <!-- Show a splash screen on the activity. Automatically removed when
             Flutter draws its first frame -->
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <!-- Theme applied to the Android Window as soon as the process has started.
         This theme determines the color of the Android Window while your
         Flutter UI initializes, as well as behind your Flutter UI while its
         running.

         This Theme is only used starting with V2 of Flutter's Android embedding. -->
    <style name="NormalTheme" parent="Theme.MaterialComponents">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>
```
 - Using an up-to-date Android gradle build tools version
 -  up-to-date gradle version accordingly
    - payment_gateway_demo/android/gradel/wrapper/gradle-wrapper.properties
```
   distributionBase=GRADLE_USER_HOME
   distributionPath=wrapper/dists
   zipStoreBase=GRADLE_USER_HOME
   zipStorePath=wrapper/dists
   distributionUrl=https\://services.gradle.org/distributions/gradle-8.4-all.zip
```
- Using FlutterFragmentActivity instead of FlutterActivity in MainActivity.kt
  - payment_gateway_demo/android/app/main/kotlin/MainActivity.kt
```
package com.example.payment_gateway_demo

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
}
```
- Add the following rules to your proguard-rules.pro file
  -  payment_gateway_demo/android/app/proguard-rules.pro
```
# Suppress warnings for specific classes in the Stripe library
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
```
- For  add the following to your Info.plist:
```
<key>NSCameraUsageDescription</key>
<string>Scan your card to add it automatically</string>
<key>NSCameraUsageDescription
&lt;string&gt;To scan cards&lt;/string&gt;</key>
<string>To scan cards</string>
```

3. Create Stripe Account
- First, you need a Stripe account.
   - https://dashboard.stripe.com/register

- This integration requires endpoints on your server that talk to the Stripe API. Use one official libraries for access to the Stripe API from your server.
   Follow the steps here
  - https://docs.stripe.com/payments/accept-a-payment?platform=ios&ui=payment-sheet#setup-server-side
 
4. Now make .env file to store Publishable key and stripe key
```
STRIPE_PUBLISH_KEY = 'YOUR PUBLISH KEY',
STRIPE_SECRET_KEY = 'YOUR SECRET KEY'
```

5. Code Set Up
- initialize Stripe in your main file
  ```
   void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: '.env');
    Stripe.publishableKey = dotenv.env['STRIPE_PUBLISH_KEY']!;
    await Stripe.instance.applySettings();
    runApp(const MyApp());
  }
  ```
6. Create PaymentIntent
 ```
 Future<Map<String, dynamic>>  createPaymentIntent() async {
    try {
      final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
      final secretKey = dotenv.env["STRIPE_SECRET_KEY"]!;

      Map<String, String> body = {
        'amount': '100',
        'currency': 'INR',
        'description': 'Donate',
        'shipping[name]': 'User',
        'shipping[address][line1]': 'Varachha',
        'shipping[address][postal_code]': '123456',
        'shipping[address][city]': 'surat',
        'shipping[address][state]': 'Gujarat',
        'shipping[address][country]':'India',
        'payment_method_types[]':['card'],
      };
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $secretKey",
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          style: ThemeMode.dark,
        ),
      );
      }
    } on Exception catch (e) {
      throw Exception('$e');
    }
  }
 ```


## Videos

https://github.com/prodev-mob/stripe_payment/assets/97152083/f482ceb7-d203-4ad2-96dc-487ae703ee97

