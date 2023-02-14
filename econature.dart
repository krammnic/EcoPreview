import 'package:econature/pages/settings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../EcoWidgets.dart';
import '../constants.dart';
import '../logic.dart';
import 'add.dart';



class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}


class HomeScreenState extends State<HomeScreen> {
  dynamic harm = 0.0;
  dynamic safe = 0.0;
  dynamic midHarm = 0.0;
  bool chartVisibility = false;
  bool imageVisibility = true;

  @override
  void initState() {
    super.initState();
    setStatisticToView();
    setImages();
  }

  void getCurrentTimePeriod(){
    // TODO: Get current time period to change text
  }

  void setImages() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic statistic = prefs.getStringList('statistic');
    if (statistic.toString() == ['0', '0', '0'].toString() || statistic == null) {
      setState(() {
        imageVisibility = true;
        chartVisibility = false;
      });
    }
    else {
      setState(() {
        imageVisibility = false;
        chartVisibility = true;
      });
    }
  }


  void setStatisticToView() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic statistic = prefs.getStringList('statistic');

    if (statistic == null) {
      setState(() {
        harm = 0.0;
        safe = 0.0;
        midHarm = 0.0;
      });
      prefs.setStringList('statistic', ['0', '0', '0']);
    } else {
      setState(() {
        harm = int.parse(statistic[0]);
        safe = int.parse(statistic[1]);
        midHarm = int.parse(statistic[2]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldGradientBackground(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFFE6FAE9),
                      Color(0xFFD1D7CE),
                      Color(0xFFAED6B4),
                    ],
                  ),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 24,
                      fontFamily: 'Comfort'
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.add, color: kPrimaryColor),
                title: Text('Add ingredient', style: TextStyle(fontFamily: 'Comfort')),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddScreen()),
                  );
                }
              ),
              ListTile(
                leading: Icon(Icons.settings, color: kPrimaryColor),
                title: Text('Settings', style: TextStyle(fontFamily: 'Comfort')),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  }
              ),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined, color: kPrimaryColor),
                title: Text('Camera', style: TextStyle(fontFamily: 'Comfort')),
                  onTap: (){
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => RecognisedScreen()),
                    // );
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Where do you want to take the image from?', style: TextStyle(color: kPrimaryColor, fontFamily: 'Comfort')),
                          content: SingleChildScrollView(
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('From camera', style: TextStyle(color: kPrimaryColor, fontFamily: 'Comfort')),
                              onPressed: () {

                                recogniseE(context, ImageSource.camera);
                                // Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('From gallery',style: TextStyle(color: kPrimaryColor, fontFamily: 'Comfort')),
                              onPressed: () {
                                recogniseE(context, ImageSource.gallery);
                                // Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      }
                    );
              }
              ),
            ],
          )
        ),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Builder(
              builder: (context) {
                return IconButton(
                    icon: SvgPicture.asset('assets/svg/menu.svg'),
                    onPressed: (){
                      Scaffold.of(context).openDrawer();
                    }
                );
              }
            )),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFE6FAE9),
            Color(0xFFD1D7CE),
            Color(0xFFAED6B4),
          ],
        ),
        body: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 15),
              child: Text('Good Morning,',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      fontFamily: 'Comfort',
                      fontSize: 25)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 15),
              child: Text('Start day with right products!',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontFamily: 'Comfort')),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 12),
              child: EcoTextField(
                  hintText: 'Find E',
                  color: kPrimaryColor,
                  padding: kDefaultPadding,
                  icon: const Icon(Icons.search, color: kPrimaryColor),
                  submitFunction: searchE,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 15),
              child: Text('Your BHP level graphic:',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontFamily: 'Comfort')),
            ),
            Visibility(
              visible: chartVisibility,
              child: Expanded(
                child: SizedBox(
                  child: PieChart(PieChartData(
                      centerSpaceRadius: 10,
                      borderData: FlBorderData(show: false),
                      sections: [
                        PieChartSectionData(
                            value: double.parse(harm.toString()), color: Color(0xffef5f6c), radius: 100, titleStyle: TextStyle(color: Colors.white, fontFamily: 'Comfort', fontWeight: FontWeight.bold)),
                        PieChartSectionData(
                            value: double.parse(safe.toString()), color: Color(0xff61e585), radius: 110, titleStyle: TextStyle(color: Colors.white, fontFamily: 'Comfort', fontWeight: FontWeight.bold)),
                        PieChartSectionData(
                            value: double.parse(midHarm.toString()), color: Color(
                            0xffffad31), radius: 110, titleStyle: TextStyle(color: Colors.white, fontFamily: 'Comfort', fontWeight: FontWeight.bold)),

                      ])),
                ),
              ),
            ),
            Visibility(
              visible: imageVisibility,
              child: Expanded(
                child: SizedBox(
                  child: Image.asset('assets/images/logo.png')
                )
              ),
            )
          ]),
        ));
  }
}
