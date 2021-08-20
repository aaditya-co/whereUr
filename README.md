
# WhereUr

A Flutter app For fetching current Location with google maps. Gives latitude longitude & Current Address


## 🔗 Download Apk
[![download](https://img.shields.io/badge/Download-3DDC84?style=for-the-badge&logo=Android&logoColor=white)](https://github.com/adityaraj3644/whereUr/releases/download/v1.0/WhereUr.apk)

  


## Installation

Install my-project

```bash
  git clone https://github.com/adityaraj3644/whereUr.git
  cd whereUr
  Open the pubspec.yaml file located inside the app folder
  Install it
      From the terminal: Run flutter pub get.
    OR
      From Android Studio/IntelliJ: Click Packages get in the action ribbon at the top of pubspec.yaml.
      From VS Code: Click Get Packages located in right side of the action ribbon at the top of pubspec.yaml.
  flutter run
```

## Todo
```bash
    ✅ Add Google Map API in android/app/src/main/AndroidManifest.xml
        <meta-data android:name="com.google.android.geo.API_KEY"
                android:value="YOUR_API_KEY_HERE"/>
    ✅ Add Yandex Geocoder API in lib/main.dart
       final YandexGeocoder geo =
            YandexGeocoder(apiKey: 'YANDEX_GEOCODER_API_HERE');

 ```
    
## Screenshots
Start
![App Screenshot](https://github.com/adityaraj3644/whereUr/blob/main/screenshots/initialPage.jpg?raw=true)
Fetched user Location
![App Screenshot](https://github.com/adityaraj3644/whereUr/blob/main/screenshots/LocationPage.jpg?raw=true)

  
## Tech Stack

**Client:** Flutter, Dart

**Plugin:** flutter_google_map, Location , Geolocator


## Feedback

If you have any feedback, please reach out to us at adityarajlp@live.com

  
