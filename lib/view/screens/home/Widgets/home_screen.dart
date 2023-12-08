import 'package:German123/controller/categories_controller.dart';
import 'package:German123/controller/question_controller.dart';
import 'package:German123/custom_packages/customselector/utils/enum.dart';
import 'package:German123/custom_packages/customselector/utils/flutter_custom_select_item.dart';
import 'package:German123/custom_packages/customselector/widget/flutter_custom_selector_sheet.dart';
import 'package:German123/data/model/response/category_model.dart';
import 'package:German123/enums/category.dart';
import 'package:German123/helper/route_helper.dart';
import 'package:German123/util/app_constants.dart';
import 'package:German123/util/color_constants.dart';
import 'package:German123/view/base/custom_button.dart';
import 'package:German123/view/base/custom_snackbar.dart';
import 'package:German123/view/base/loading_widget.dart';
import 'package:German123/view/screens/privacy%20policy/instructions.dart';
import 'package:German123/view/screens/question/notification.dart';
import 'package:German123/view/screens/question/test_question_screen.dart';
import 'package:accordion/controllers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:German123/util/images.dart';
import 'package:German123/controller/auth_controller.dart';
import 'package:German123/util/dimensions.dart';
import 'package:German123/view/base/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../util/app_strings.dart';
import '../../../../util/styles.dart';
import '../main_screen.dart';
import 'weather_widget.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:accordion/accordion.dart';

class HomeScreen extends StatefulWidget {
  bool isTrial;
   HomeScreen({
    Key? key,
    required this.isTrial,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size deviceSize;
  late double weatherCardWidth;
  late double weatherCardHeight;
  List<Widget> weatherItemList = <Widget>[];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  double totalPercentage = 100;
  double readPercentage = 0;

  List notificationlist = [];

  bool isOpen1 = false; 
  bool isOpen2 = false; 
   bool alreadyRead = true;

  @override
  void initState() {
    Get.find<CategoryController>().fetchCategories(isFromInitState: true);

    if(!widget.isTrial)
    {

    
    
    getPerformanceandnotification();
    }

    check();
    super.initState();
  }

  check() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();

                 AppConstants.learnInEnglish =  prefs.getBool('learnInEnglish')?? false;
                 setState(() {
                   
                 });
  }

  getPerformanceandnotification(){

    Get.find<QuestionController>()
        .fetchPerformance(
           )
        .then((value) {

         
      if(value['Success'] != null && value['Success']['success'] == true){
 debugPrint("--------------------------------------------");
          debugPrint(value.toString());
        try{
          totalPercentage = double.parse(value['Success']['result'][0]['total_percentage'].toString());
          readPercentage = double.parse(value['Success']['result'][0]['read_percentage_question'].toString());
        }catch(e){
          showCustomSnackBar(e.toString());
        }

      }

    

      setState(() {
        
      });
     
    });

    //lets get notifications as well
     Get.find<QuestionController>()
        .fetchNotification(
           )
        .then((value) async {
debugPrint('mein -------------------------');
debugPrint(value.toString());
         
      if(value['Success'] != null && value['Success']['success'] == true){
 debugPrint("--------------------------------------------");
          debugPrint(value.toString());
        try{
          notificationlist = value['Success']['result'];

           if(notificationlist.isNotEmpty && notificationlist[0]['notificationID'] == '1'){
            //hum dekhein ge k is ne iss month mein read kiya hai ya nahi

SharedPreferences prefs = await SharedPreferences.getInstance();
            alreadyRead = prefs.getString('notiReadMonth')  == DateTime.now().month.toString() ? true: false;
          }
          else if(notificationlist.isNotEmpty){
            //hum pehle index ko check ker lein ge k iss ne read kiya hua hai ya nahi
            alreadyRead = notificationlist[0]['is_read'] == true ? true: false;
          }

          debugPrint('already read------------------');
          debugPrint(alreadyRead.toString());


        }catch(e){
          showCustomSnackBar(e.toString());
        }

      }

    

      setState(() {
        
      });
     
    });
  }

    markNotificationRead(id){

    debugPrint(id);

    Get.find<QuestionController>()
        .readNotification(
          id.toString()
           )
        .then((value) {
debugPrint('mein hun notifications -------------------------');
debugPrint(value.toString());


         
      


     
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: myCustomAppBar(
         widget.isTrial? 'Bundesland wählen': AppString.home,
         widget.isTrial? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                   
                  ),
                  margin: const EdgeInsets.only(left: 10),
                  child: 
                      InkWell(
                          radius: 100,
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                          
                              Get.back();
                            
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ))): InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              zoomDrawerController.toggle?.call();
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                Images.menu,
                color: Colors.black,
                width: 22,
                height: 22,
              ),
            ),
          ),
          true,
          Colors.white,
      widget.isTrial? [Container(width: 50,)]:  [
            GestureDetector(
              // padding: EdgeInsets.zero,
              // color: Colors.red,
              onTap: () async {
                Map<String, List<String>?> result =
                    await CustomBottomSheetSelector<String>().customBottomSheet(
                  buildContext: context,
                  selectedItemColor: Theme.of(context).primaryColorLight,
                  initialSelection: ['1'],
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff313b3e)),
                  buttonType: CustomDropdownButtonType.singleSelect,
                  headerName: "Einstellungen",
                  dropdownItems: [
                    // CustomMultiSelectDropdownItem('1', 'Einen Test schreiben #1'),
                    // CustomMultiSelectDropdownItem('2', 'Einen Test schreiben #2')
                    CustomMultiSelectDropdownItem('', AppConstants.learnInEnglish? 'Auf Deutsch lernen': 'Learn in English')
                  ],
                );
                if (result['selection'] != null) {

                  AppConstants.learnInEnglish = !AppConstants.learnInEnglish;

                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  prefs.setBool('learnInEnglish',AppConstants.learnInEnglish);

                  
                setState((){});
                  

                
                  // List<String>? test = result['selection'];

                  // //yahan se hum ne isko 2sre page per le ker jana hai

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => InstructionScreen(
                  //               testNumber: test![0],
                  //             )));
                }
                setState((){});
              },
              // child: Image.asset(Images.takeTest,width: 30,),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(right:10),
                  height: 32,
                  width: 32,
                  // padding: EdgeInsets.all(4),
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(8),
                  //     color: Colors.white),
                  child: Image.asset(
                   AppConstants.learnInEnglish?  Images.german : Images.english,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
          () {}),
      body: SafeArea(
          child: SmartRefresher(
        onRefresh: () async {
          await Get.find<CategoryController>()
              .fetchCategories(isFromInitState: false);
          _refreshController.refreshCompleted();
        },
        controller: _refreshController,
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 20, bottom: 20),
          shrinkWrap: true,
          children: [
            Container(
              width: context.width,
              // height: context.height,
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL + 6),
              margin: EdgeInsets.zero,
              child:
                  GetBuilder<CategoryController>(builder: (categoryController) {
                if (!categoryController.isDataFetching ||
                    categoryController.categories.isNotEmpty) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

 if(!widget.isTrial && notificationlist.isNotEmpty) Accordion(
      maxOpenSections: 1,
          headerBackgroundColorOpened: Colors.black54,
          scaleWhenAnimating: true,
          openAndCloseAnimation: true,
          contentBorderColor: Colors.grey.shade100.withOpacity(.7),
          headerPadding:
              const EdgeInsets.symmetric(vertical: 7, horizontal: 15),

              paddingListBottom: 0,
              paddingListTop: 7,
              
          
              
          sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
          sectionClosingHapticFeedback: SectionHapticFeedback.light,
          children: [
            AccordionSection(  isOpen: isOpen1,
            onOpenSection: () async {

               if(alreadyRead ==  false && notificationlist.isNotEmpty && notificationlist[0]['notificationID'] == '1'){

                 //iska matlab ye plan wala hai , hmein is month ko save kerwana hai

                 SharedPreferences prefs = await SharedPreferences.getInstance();
                 prefs.setString('notiReadMonth', DateTime.now().month.toString());

                 debugPrint('mein to yahan hun');

                 
             

              }
               else if(alreadyRead ==  false && notificationlist.isNotEmpty && notificationlist[0]['is_read'] != true){


              markNotificationRead(notificationlist[0]['notificationID']);

              }


              setState(() {
                isOpen1 = true;
                 alreadyRead = true;
              });
            },

            onCloseSection: (){
                setState(() {
                isOpen1 = false;
               
              });
            },
            
            
              leftIcon: const Icon(Icons.notifications_active_outlined, color: Colors.black),
            rightIcon:const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black) ,
            flipRightIconIfOpen: true,
              headerBackgroundColor: Colors.grey.shade100.withOpacity(.7),
              headerBackgroundColorOpened: Theme.of(context).primaryColor,
              header: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Benachrichtigungen', style: ralewayMedium ),
                   if(!isOpen1 && !alreadyRead )Container(
                  // margin: EdgeInsets.only(right: 16),
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Color(0xffFFBF00),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  alignment: Alignment.center,
                  child: Text(notificationlist.length.toString(), style: ralewayMedium.copyWith(),),
                ),
                ],
              ), content: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.end,
  mainAxisSize: MainAxisSize.min,
  children: 

    List.generate(notificationlist.length > 0? 1 :0, (i) => 
    Column(
      children: [
        ListTile(
          
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(notificationlist[i]['notificationTitle'], style: ralewayMedium,)),
              if(notificationlist.length > 1)GestureDetector(
                onTap: (){

                  Navigator.push(context, MaterialPageRoute(builder: (context)=> NotificationScreen(notificationlist: notificationlist,)));

                },
                child: Text('Mehr Sehen', style: ralewayMedium.copyWith(color:Color(0xffFFBF00),decoration: TextDecoration.underline ),)),
            ],
          ),
          subtitle: Text(notificationlist[i]['notificationText'], style: ralewayRegular,),
 

          
        ),
        if(notificationlist[i]['notificationType'] == 'Erneuerung planen' ) GestureDetector(
          onTap: (){
             
        Get.toNamed(RouteHelper.getPurchasePlanScreenRoute());

                                  
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xffFFBF00),
             
            ),
            child: Center(
              child: Text(
               'Erneuern',
                style: ralewayBold.copyWith(
                  color: Colors.white,
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
            ),
          ),
        )
      ],
    )
    )


                       

  ,
))
          ],
 ) ,

 if(!widget.isTrial) Accordion(
      maxOpenSections: 1,
          headerBackgroundColorOpened: Colors.black54,
          scaleWhenAnimating: true,
          openAndCloseAnimation: true,
          contentBorderColor: Colors.grey.shade100.withOpacity(.7),
          headerPadding:
              const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
           paddingListBottom: 10,
                paddingListTop: 7,
              
          sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
          sectionClosingHapticFeedback: SectionHapticFeedback.light,
          children: [
            AccordionSection(  isOpen: isOpen2,
            onOpenSection: (){
                setState(() {
                isOpen2 = true;
              });
            },
            onCloseSection: (){
                setState(() {
                isOpen2 = false;
              });
            },
              leftIcon: const Icon(Icons.insights_rounded, color: Colors.black),
            rightIcon:const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black) ,
            flipRightIconIfOpen: true,
              headerBackgroundColor: Colors.grey.shade100.withOpacity(.7),
              headerBackgroundColorOpened: Theme.of(context).primaryColor,
              header: Text('Leistung', style: ralewayMedium ), content: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
                        // _getRadialGauge(1),
                        // SizedBox(width: 5,),
                        _getRadialGauge(2),
                        // SizedBox(width: 5,),

                        // _getRadialGauge(3),

  ],
))
          ],
 ) ,

                    




                        GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16),
                            itemCount: categoryController.categories.length,
                            itemBuilder: (BuildContext ctx, index) {
                              QuestionCategory category =
                                  categoryController.categories[index];
                              int viewedQuestions =
                                  (Get.find<SharedPreferences>().getInt(
                                              "${AppConstants.CATEGORY_QUESTONS_VIEWED}${category.id}") ??
                                          0) +
                                      1;


                              return DelayedDisplay(
                                slidingBeginOffset:
                                    Offset(index.isEven ? -1 : 1, 0),
                                child: InkWell(
                                  onTap: () async {

                                    if(widget.isTrial){
                                      Get.offAll(MainScreen());
                                    }else{
  dynamic result = await Get.toNamed(
                                            RouteHelper.getQuestionScreenRoute(
                                                questionCategory: category)) ??
                                        {"nextCategoryIndexToView": 0};



debugPrint(result.toString());
debugPrint(viewedQuestions.toString());
                                   
                                    if (result["nextCategoryIndexToView"]+1 >
                                        viewedQuestions) {
                                          viewedQuestions = result['nextCategoryIndexToView'];
                                       Get.find<SharedPreferences>().setInt(
                                          "${AppConstants.CATEGORY_QUESTONS_VIEWED}${category.id}",
                                          result["nextCategoryIndexToView"]);
                                           Get.find<SharedPreferences>().setInt(
                                        "${AppConstants.CATEGORY_QUESTON_TO_VIEW_INDEX}${category.id}",
                                        result["nextCategoryIndexToView"]);
                                         
                                    }
                                   
                                      setState(() {});

getPerformanceandnotification();

                                    }
                                  
                                    
                                  },
                                  radius: 12,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    children: [
                                      Container(
                                        // alignment: Alignment.center,
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: catColors(index),
                                          boxShadow: [
                                            // BoxShadow(
                                            //     color: Colors.grey.withOpacity(0.3),
                                            //     blurRadius: 20,
                                            //     spreadRadius: 10)
                                          ],
                                          // gradient: AppColor.boxGradient,
                                          // border: Border.all(color: Theme.of(context).primaryColor),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),

                                                  ),

                                        
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    
                                                    child: OptimizedCacheImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          AppConstants.STORAGE_URL +
                                                              category.imageUrl,
                                                      height: 500,
                                                      width: 500,
                                                      
                                                    ),
                                                  ),
                                                ),
                                                
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                              // height:
                                              //     Dimensions.PADDING_SIZE_DEFAULT,
                                            ),
                                            Text(
                                              category.primaryName.tr,
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              style: ralewayMedium.copyWith(
                                                  fontSize: 15,
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            // const SizedBox(
                                            //   height: 4,
                                            // ),
                                            category.secondaryName.isNotEmpty
                                                ? Text(
                                                    category.secondaryName.tr,
                                                    maxLines: 1,
                                                    // textAlign: TextAlign.center,
                                                    style: GoogleFonts.getFont(Get
                                                                .find<
                                                                    AuthController>()
                                                            .getLoginUserData()!
                                                            .translationLanguage!
                                                            .fontFamily)
                                                        .copyWith(
                                                            fontSize: 15,
                                                            color: Theme.of(context)
                                                                .primaryColorLight,
                                                            fontWeight:
                                                                FontWeight.w500),
                                                  )
                                                : const SizedBox(),
                                               
                                          ],
                                        ),
                                      ),
                                   Positioned(

                                     right: 5,
                                     top: 5,
                                     
                                     child:  viewedQuestions > 1
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 8),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      // color: Color(0xffffffff)
                                                      //     .withOpacity(1),
                                                    ),
                                                    child: Text(
                                                      "$viewedQuestions 👁️",
                                                      // textAlign: TextAlign.center,
                                                      style: ralewayRegular
                                                          .copyWith(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  )
                                                : const SizedBox())
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ]);
                } else {
                  return Center(
                    child: SizedBox(
                      height: context.height * .8,
                      child: LoadingAnimationWidget.flickr(
                        leftDotColor: AppColor
                            .primaryGradiantStart, //Get.theme.primaryColor,
                        rightDotColor: AppColor.primaryGradiantEnd,
                        size: 50,
                      ),
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      )),
    );
  }

 Widget _getRadialGauge(int number) {
    return Container(
      height: number == 2? 130 : 80,
      width: number == 2? 130 : 80,
      child: SfRadialGauge(
        enableLoadingAnimation: true,
        
          axes: <RadialAxis>[
            RadialAxis(
              showLabels: false,
              showTicks: false,
              minimum: 0, maximum: totalPercentage, ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: readPercentage,
                  color: readPercentage< 40? AppColor.primaryGradiantStart: readPercentage < 80? AppColor.primaryGradiantEnd: Colors.green ,
                  startWidth: 10,
                  endWidth: 10),
              
            ], pointers: <GaugePointer>[
              NeedlePointer(value: readPercentage,
              needleColor: AppColor.primaryGradiantStart,
              needleEndWidth: 3,
              needleStartWidth: 0,
              knobStyle: KnobStyle(
                color: AppColor.primaryGradiantStart
              ),
              )
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Container(
                      child:  Text(readPercentage.toStringAsFixed(0) +' %',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold))),
                  angle: 90,
                  positionFactor: 0.8)
            ])
          ]),
    );
  }
  Color catColors(index) {
    Color color = Colors.black;
    if (index % 4 == 0) {
      color = Colors.red.withOpacity(0.15);
    }
    if (index % 4 == 1) {
      color = Color(0xff926bef).withOpacity(0.15);
    }
    if (index % 4 == 2) {
      color = Color(0xff3dd598).withOpacity(0.15);
    }
    if (index % 4 == 3) {
      color = Color(0xfff7cc46).withOpacity(0.15);
    }
    return color;
  }
}
