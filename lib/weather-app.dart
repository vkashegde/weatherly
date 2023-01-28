import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:weatherly/consts/images.dart';
import 'package:weatherly/consts/strings.dart';
import 'package:weatherly/models/hourly_weather_model.dart';
import 'package:intl/intl.dart';
import 'controllers/main_controller.dart';
import 'models/current_weather_model.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var date = DateFormat("yMMMMd").format(DateTime.now());
    var theme = Theme.of(context);
    var controller = Get.put(MainController());

    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: AnimSearchBar(
              helpText: 'Enter city name',
              onSubmitted: (String p0) async {
                await controller.searchNewCity(p0);
              },
              width: 400,
              rtl: true,
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                });
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: const [
            // Obx(
            //   () => IconButton(
            //       onPressed: () {
            //         controller.changeTheme();
            //       },
            //       icon: Icon(
            //           controller.isDark.value
            //               ? Icons.light_mode
            //               : Icons.dark_mode,
            //           color: theme.iconTheme.color)),
            // ),
          ],
        ),
        body: Obx(
          () => controller.isloaded.value == true
              ? Container(
                  padding: const EdgeInsets.all(12),
                  child: FutureBuilder(
                    future: controller.currentWeatherData,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        CurrentWeatherData data = snapshot.data;

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      date,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    Text(data.name),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                  ],
                                ),
                              ),
                              primaryData(data, theme),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: null,
                                    icon: Icon(Icons.expand_less_rounded,
                                        color: theme.iconTheme.color),
                                    label: Text("${data.main.tempMax}$degree"),
                                  ),
                                  TextButton.icon(
                                      onPressed: null,
                                      icon: Icon(Icons.expand_more_rounded,
                                          color: theme.iconTheme.color),
                                      label:
                                          Text("${data.main.tempMin}$degree"))
                                ],
                              ),
                              secondaryData(data),
                              const Divider(),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Sunrice : ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(data.sys.sunrise * 1000))}',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.grey),
                                  ),
                                  Text(
                                      'Sunset : ${DateFormat('h:mm a').format(DateTime.fromMillisecondsSinceEpoch(data.sys.sunset * 1000))}',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey)),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              const Divider(),
                              const Text('Hourly Weather'),
                              const Divider(),
                              hourlyData(controller),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        'Humidity',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 18),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SleekCircularSlider(
                                        appearance: CircularSliderAppearance(
                                            size: 100,
                                            customWidths: CustomSliderWidths(
                                                progressBarWidth: 8)),
                                        min: 0,
                                        max: 100,
                                        initialValue:
                                            data.main.humidity.toDouble(),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Visibility',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 18),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      SleekCircularSlider(
                                        appearance: CircularSliderAppearance(
                                            size: 100,
                                            infoProperties: InfoProperties(
                                                modifier: (value) {
                                              final roundedValue = value
                                                  .ceil()
                                                  .toInt()
                                                  .toString();
                                              return '$roundedValue km';
                                            }),
                                            customWidths: CustomSliderWidths(
                                                progressBarWidth: 8)),
                                        min: 0,
                                        max: 20,
                                        initialValue: (data.visibility / 1000),
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }

  Widget primaryData(CurrentWeatherData data, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "assets/weather/${data.weather[0].icon}.png",
          width: 80,
          height: 80,
        ),
        RichText(
            text: TextSpan(
          children: [
            TextSpan(
                text: "${data.main.temp}$degree",
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 64,
                )),
            TextSpan(
                text: " ${data.weather[0].main}",
                style: TextStyle(
                  color: theme.primaryColor,
                  letterSpacing: 3,
                  fontSize: 14,
                )),
          ],
        )),
      ],
    );
  }

  Widget secondaryData(CurrentWeatherData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(3, (index) {
        var iconsList = [clouds, humidity, windspeed];
        var values = [
          "${data.clouds.all}",
          "${data.main.humidity}",
          "${data.wind.speed} km/h"
        ];
        return Column(
          children: [
            Image.asset(
              iconsList[index],
              width: 60,
              height: 60,
            ),
            Text('${values[index]}'),
          ],
        );
      }),
    );
  }

  Widget hourlyData(MainController controller) {
    return FutureBuilder(
      future: controller.hourlyWeatherData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          HourlyWeatherData hourlyData = snapshot.data;

          return SizedBox(
            height: 160,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount:
                  hourlyData.list!.length > 6 ? 6 : hourlyData.list!.length,
              itemBuilder: (BuildContext context, int index) {
                var time = DateFormat.jm().format(
                    DateTime.fromMillisecondsSinceEpoch(
                        hourlyData.list![index].dt!.toInt() * 1000));

                return Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text('${time}'),
                      Image.asset(
                        "assets/weather/${hourlyData.list![index].weather![0].icon}.png",
                        width: 80,
                      ),
                      Text("${hourlyData.list![index].main!.temp}$degree"),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
