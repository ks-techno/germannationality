import 'dart:io';

import 'package:German123/controller/app_settings_controller.dart';
import 'package:German123/controller/auth_controller.dart';
import 'package:German123/data/model/response/app_settings_model.dart';
import 'package:German123/data/model/response/userinfo_model.dart';
import 'package:German123/data/repository/auth_repo.dart';
import 'package:German123/util/color_constants.dart';
import 'package:German123/view/screens/question/trial_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:German123/util/dimensions.dart';
import 'package:German123/view/screens/home/Widgets/drawer_widget.dart';
import 'package:get/get.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/images.dart';
import 'Widgets/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

late ZoomDrawerController zoomDrawerController;

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();

    checkUserStatus();
    checkVersion();

    zoomDrawerController = ZoomDrawerController();
  }

  checkUserStatus() async {
    SharedPreferences da = await SharedPreferences.getInstance();

    try{
var resp = await AuthRepo(sharedPreferences: da).getUserById(
        id: Get.find<AuthController>().getLoginUserData()!.id.toString());

    debugPrint('ali----------------');
    debugPrint(resp.toString());

    if (resp['Success']['success'] == true) {
      if (resp['Success']['result']['status'] != '1') {
        //iska matlab isko logout kerwa do
        Get.find<AuthController>().logout('');
      }
    }
    }catch(e){}
  }


  checkVersion() async {


    debugPrint('mein yahan hun------------------------------------------');

    AppSettings _settings =
      Get.find<AppSettingsController>().appSettings;
      String projectVersion;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        projectVersion = await packageInfo.version;
      } on PlatformException {
        projectVersion = 'Failed to get project version.';
      }
      String ios = _settings.ios_version!;
      String android = _settings.android_version!;
      bool force = _settings.forceUpdate! == '1'? true : false;
      bool showpage = _settings.showUpdate! == '1'? true:false;
     
   
     
    

      if (showpage) {
        if (Platform.isIOS) {
        
          if (projectVersion != ios) {
          //show popup
          showPopup(!force);
          } 
        } else if (Platform.isAndroid) {
       
          if (projectVersion != android) {
          //show popup
          showPopup(!force);
           
          }
        }
      } 
  }
 
  openPlayIos() async {
    
    var url = Platform.isAndroid? 'https://play.google.com/store/apps/details?id=de.germannationality': 'https://apps.apple.com/us/app/german-nationality/id6445913895';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  
  }

  showPopup(bool showClose){
    Alert(
      context: context,
      title: "Aktualisierung erforderlich!",
      desc: "Sie müssen Ihre App aktualisieren, um die neuesten Funktionen nutzen zu können.",
      onWillPopActive: true,
    
      closeIcon: showClose? Icon(Icons.close): Container(),
      buttons: [
       
        DialogButton(
          child: Text(
            "AKTUALISIEREN",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: (){

            openPlayIos();



          },
          color:  Theme.of(context).primaryColor,
         ),
        
      ],
    ).show();
//     final popup = BeautifulPopup(
//   context: context,
//   template: TemplateGift,
// );
//     popup.show(
//   title: 'String or Widget',
//   content: 'String or Widget',
//   actions: [
//     popup.button(
//       label: 'Close',
//       onPressed: Navigator.of(context).pop,
//     ),
//   ],
//   // bool barrierDismissible = false,
//   // Widget close,
// );
  }



  @override
  Widget build(BuildContext context) {
      
    return Scaffold(
      body: ZoomDrawer(
        controller: zoomDrawerController,
        style: DrawerStyle.defaultStyle,
        isRtl: false,
        // drawerShadowsBackgroundColor:Theme.of(context).backgroundColor,
        showShadow: false,
        mainScreenTapClose: true,
        menuScreenTapClose: true,
        mainScreenScale: 0.35,
        openCurve: Curves.fastOutSlowIn,
        slideWidth: MediaQuery.of(context).size.width * 0.65,
        duration: const Duration(milliseconds: 200),
        angle: -0.0,
        mainScreen:

        //yahan ab hum ne mukhtalif chezein check kerni ahai
        // sbb se pehle ager login hai or payment ok hai to home, 
        //login hai payment ok nahi hai to trial per lekin sath btana hai,
        //login nahi hai to trial per

        Get.find<AuthController>().getLoginUserData() != null && Get.find<AuthController>().getLoginUserData()?.paymentStatus == "1"?
                  HomeScreen(isTrial: false,)
                : const TrialQuestionScreen(),


            // Get.find<AuthController>().getLoginUserData()?.paymentStatus == "1"
            //     ? const HomeScreen()
            //     : const TrialQuestionScreen(),
        menuScreen:  const CustomDrawer(),
      ),
    );
  }
}
