import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weatherly/services/api_services.dart';
import 'package:geocoding/geocoding.dart';

class MainController extends GetxController {
  var isDark = false.obs;
  dynamic currentWeatherData;
  dynamic hourlyWeatherData;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var isloaded = false.obs;
  var cityName = 'bangalore'.obs;

  @override
  void onInit() async {
    await getUserLocation();
    getFreshData();

    super.onInit();
  }

  getFreshData() {
    currentWeatherData = getCurrentWeather(cityName);
    hourlyWeatherData = getHourlyWeather(cityName);
  }

  // changeTheme() {
  //   isDark.value = !isDark.value;
  //   Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
  // }

  getCityNameFromLatLong() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude.value, longitude.value);
    print('${placemarks[0].locality.toString()}');
    String cityName = placemarks[0].locality.toString();
    isloaded.value = true;
  }

  searchNewCity(city) {
    print('city: ${city}');
    isloaded.value = false;
    cityName.value = city;
    getFreshData();
    isloaded.value = true;
  }

  getUserLocation() async {
    bool isLocationEnabled;
    LocationPermission userPermission;

    isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      return Future.error("Location is not enabled");
    }

    userPermission = await Geolocator.checkPermission();
    if (userPermission == LocationPermission.deniedForever) {
      return Future.error("Permission is denied forever");
    } else if (userPermission == LocationPermission.denied) {
      userPermission = await Geolocator.requestPermission();
      if (userPermission == LocationPermission.denied) {
        return Future.error("Permission is denied");
      }
    }

    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      latitude.value = value.latitude;
      longitude.value = value.longitude;
      getCityNameFromLatLong();
    });
  }
}
