import 'package:German123/controller/auth_controller.dart';
import 'package:German123/controller/question_controller.dart';
import 'package:German123/custom_packages/customselector/utils/enum.dart';
import 'package:German123/custom_packages/customselector/utils/flutter_custom_select_item.dart';
import 'package:German123/custom_packages/customselector/widget/flutter_custom_selector_sheet.dart';
import 'package:German123/data/model/response/category_model.dart';
import 'package:German123/data/model/response/question_model.dart';
import 'package:German123/enums/category.dart';
import 'package:German123/helper/route_helper.dart';
import 'package:German123/theme/light_theme.dart';
import 'package:German123/util/app_constants.dart';
import 'package:German123/util/color_constants.dart';
import 'package:German123/util/dimensions.dart';
import 'package:German123/util/images.dart';
import 'package:German123/util/styles.dart';
import 'package:German123/view/base/custom_app_bar.dart';
import 'package:German123/view/base/custom_snackbar.dart';
import 'package:German123/view/screens/home/main_screen.dart';
import 'package:German123/view/screens/question/widgets/question_item_widget.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:slide_to_act/slide_to_act.dart';

import '../../../util/app_strings.dart';
import '../../base/custom_button.dart';

class TrialQuestionScreen extends StatefulWidget {
  const TrialQuestionScreen({
    Key? key,
    
  }) : super(key: key);

  @override
  State<TrialQuestionScreen> createState() => _TrialQuestionScreenState();
}

class _TrialQuestionScreenState extends State<TrialQuestionScreen> {
  List<Question> questions = [];
  late PageController pageViewController;
  final List<Widget> _pageViewItem = <Widget>[];
  int currentIndex = 0;
  int questionNumber = 1;
  // final GlobalKey<SlideActionState> _key = GlobalKey();
  
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    pageViewController = PageController(initialPage: currentIndex);
  
  getQuestions();
    check();
    super.initState();
  }

  getQuestions(){
      Get.find<QuestionController>()
        .fetchTrialQuestions(isFromInitState: true)
        .then((value) {
      if (currentIndex > Get.find<QuestionController>().questions.length) {
        currentIndex = 0;
      }
    });
  }

   check() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();

                 AppConstants.learnInEnglish =  prefs.getBool('learnInEnglish')?? false;
                 setState(() {
                   
                 });
  }

  String id = '0';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: {"nextCategoryIndexToView": currentIndex});
        return true;
      },
      child: Scaffold(

        appBar: AppBar(
           toolbarHeight: 80,
      elevation: 8,
      backgroundColor: Colors.white,
      centerTitle: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16))),
      // backgroundColor: Colors.yellow,
      leadingWidth: 50,
      leading:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
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
      ),
      title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        'Einbürgerungstest',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: ralewayMedium.copyWith(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Testfragen # ' +
                (currentIndex + 1).toString(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: ralewayMedium.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                          
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      actions: [
              IconButton(
                onPressed: () async {
                  Map<String, List<String>?> result =
                      await CustomBottomSheetSelector<String>()
                          .customBottomSheet(
                    buildContext: context,
                    selectedItemColor: Theme.of(context).primaryColorLight,
                    initialSelection: [
                      Get.find<QuestionController>().isShowTranslation
                          ? "Übersetzung ausblenden"
                          : "Übersetzung zeigen"
                    ],
                    buttonType: CustomDropdownButtonType.singleSelect,
                    headerName: "Einstellungen",
                    dropdownItems: [
                      CustomMultiSelectDropdownItem(
                          Get.find<QuestionController>().isShowTranslation
                              ? "Übersetzung ausblenden"
                              : "Übersetzung zeigen",
                          Get.find<QuestionController>().isShowTranslation
                              ? "Übersetzung ausblenden"
                              : "Übersetzung zeigen"),
                    CustomMultiSelectDropdownItem('1', AppConstants.learnInEnglish? 'Auf Deutsch lernen': 'Learn in English')
                      
                    ],
                  );
                  if (result['selection'] != null) {
                    if(result['selection']![0] == '1'){

                       AppConstants.learnInEnglish = !AppConstants.learnInEnglish;

                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  prefs.setBool('learnInEnglish',AppConstants.learnInEnglish);

                  //questions ko dubara set ker wanahai

                  getQuestions();


                    }else{
                    Get.find<QuestionController>().hideOrShowTranslation();

                    }
                  }
                },
                icon: Icon(
                  Icons.settings_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                // icon: Image.asset(Images.,color: Theme.of(context).primaryColor,),
              ),
            ]
        ),
       
        // CustomAppBar(
        //   title: 'Trial Question #' + (currentIndex + 1).toString(),
        //   leading: InkWell(
        //     borderRadius: BorderRadius.circular(100),
        //     onTap: () {
        //       zoomDrawerController.toggle?.call();
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.all(5.0),
        //       child: Image.asset(
        //         Images.menu,
        //         width: 22,
        //         height: 22,
        //       ),
        //     ),
        //   ),
        //   showLeading: true,
        //   onBack: () {
        //     Get.back(result: {"nextCategoryIndexToView": currentIndex});
        //   },
        //   trailing: [
        //     IconButton(
        //       onPressed: () async {
        //         Map<String, List<String>?> result =
        //             await CustomBottomSheetSelector<String>().customBottomSheet(
        //           buildContext: context,
        //           selectedItemColor: Theme.of(context).primaryColorLight,
        //           initialSelection: [
        //             Get.find<QuestionController>().isShowTranslation
        //                 ? "Übersetzung ausblenden"
        //                 : "Übersetzung zeigen"
        //           ],
        //           buttonType: CustomDropdownButtonType.singleSelect,
        //           headerName: "Settings",
        //           dropdownItems: [
        //             CustomMultiSelectDropdownItem(
        //                 Get.find<QuestionController>().isShowTranslation
        //                     ? "Übersetzung ausblenden"
        //                     : "Übersetzung zeigen",
        //                 Get.find<QuestionController>().isShowTranslation
        //                     ? "Übersetzung ausblenden"
        //                     : "Übersetzung zeigen")
        //           ],
        //         );
        //         if (result['selection'] != null) {
        //           Get.find<QuestionController>().hideOrShowTranslation();
        //         }
        //       },
        //       icon: Icon(
        //         Icons.settings_rounded,
        //         color: Theme.of(context).primaryColor,
        //         size: 28,
        //       ),
        //       // icon: Image.asset(Images.,color: Theme.of(context).primaryColor,),
        //     ),
        //   ],
        // ),
        body: SafeArea(
            child: SmartRefresher(
          onRefresh: () async {
            await Get.find<QuestionController>()
                .fetchTrialQuestions(isFromInitState: false);
            if (currentIndex >
                Get.find<QuestionController>().questions.length) {
              currentIndex = 0;
              setState(() {});
            }
            _refreshController.refreshCompleted();
          },
          controller: _refreshController,
          physics: BouncingScrollPhysics(),
          child: Container(
            width: context.width,
            // color: Colors.red,
            // padding: const EdgeInsets.symmetric(
            //     horizontal: Dimensions.PADDING_SIZE_SMALL),
            margin: EdgeInsets.zero,
            child:
                GetBuilder<QuestionController>(builder: (questionController) {
              return !questionController.isDataFetching
                  ? Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: questionController.questions.length,
                              scrollDirection: Axis.horizontal,
                              controller: pageViewController,
                              onPageChanged: (index) {
                                setState(() {
                                  currentIndex = index;
                                  id = questionController.questions[index].id
                                      .toString();
                                });
                              },
                              itemBuilder: (context, position) {
                                Question question =
                                    questionController.questions[position];

                                return QuestionItemWidget(
                                  question: question,
                                  testMode: false,
                                  questionIndex: position,
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       if (currentIndex != 0)
                        //         Expanded(
                        //           child: Container(
                        //             // margin: const EdgeInsets.only(right: 10),
                        //             child: CustomButton(
                        //               fontSize: 11,
                        //               height: 44,
                        //               backgroundTransparent: true,
                        //               buttonText: AppString.previous.tr,
                        //               onPressed: () {
                        //                 questionController.hideOrShowAnswer(
                        //                     isShowAnswer: false);
                        //                 currentIndex--;
                        //                 pageViewController
                        //                     .jumpToPage(currentIndex);
                        //                 // pageViewController.animateToPage(currentIndex, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        //       if (currentIndex != 0)
                        //         const SizedBox(
                        //           width: 5,
                        //         ),
                        //       Expanded(
                        //         child: CustomButton(
                        //           height: 44,
                        //           fontSize: 11,
                        //           buttonText: questionController.isShowAnswer
                        //               ? AppString.hideAnswer.tr
                        //               : AppString.showAnswer.tr,
                        //           onPressed: () {
                        //             questionController.hideOrShowAnswer();
                        //           },
                        //         ),
                        //       ),
                        //       if (currentIndex + 1 !=
                        //           questionController.questions.length)
                        //         const SizedBox(
                        //           width: 5,
                        //         ),
                        //       if (currentIndex + 1 !=
                        //           questionController.questions.length)
                        //         Expanded(
                        //           child: Container(
                        //             // margin: const EdgeInsets.only(left: 5),
                        //             child: CustomButton(
                        //               fontSize: 11,
                        //               height: 44,

                        //               // width: 80,
                        //               backgroundTransparent: true,
                        //               buttonText: AppString.next.tr,
                        //               onPressed: () {
                        //                 questionController.hideOrShowAnswer(
                        //                     isShowAnswer: false);
                        //                 currentIndex++;
                        //                 FocusScope.of(context).unfocus();

                        //                 pageViewController
                        //                     .jumpToPage(currentIndex);
                        //                 // pageViewController.animateToPage(currentIndex, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        //     ],
                        //   ),
                        // ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(children: [
                            
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  questionController.hideOrShowAnswer();
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 44,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      // width: 56,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Color(0xffFFBF00)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(questionController.isShowAnswer
                                              ? 'Antwort Verstecken'
                                              : 'Antwort Zeigen',
                                              style: TextStyle(
                                                color: Colors.white
                                              ),
                                              ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Icon(questionController.isShowAnswer
                                              ? Icons.visibility_off_rounded
                                              : Icons.remove_red_eye_rounded,
                                              color: Colors.white,
                                              ),
                                        ],
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 4,
                                    // ),
                                    // Text('show Answers')
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                           GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {

                                      if( currentIndex != 0
                                 ){
     questionController.hideOrShowAnswer(
                                          isShowAnswer: false);
                                      currentIndex--;
                                      pageViewController
                                          .jumpToPage(currentIndex);
                                      // pageViewController.animateToPage(currentIndex, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                                  
                                 }
                                   },
                                    child: Column(
                                      children: [
                                        Container(
                                            height: 44,
                                            width: 44,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(56),
                                                  border: currentIndex == 0? Border.all(color: Colors.black.withOpacity(0.1), width: 1) : Border.all(width: 0, color: Color(0xffFFBF00)),
                                              color:
                                                 currentIndex == 0? Colors.transparent:  Color(0xffFFBF00),
                                            ),
                                            child: Icon(
                                              Icons.arrow_back_rounded,
                                              color: currentIndex == 0? Colors.black.withOpacity(0.1): Colors.white,
                                              size: 24,
                                            )
                                            // Lottie.asset(
                                            //     'assets/image/arrow.json',
                                            //     fit: BoxFit.contain),
                                            ),
                                        // SizedBox(
                                        //   height: 4,
                                        // ),
                                        // Text('Privious')
                                      ],
                                    ),
                                  )
                                ,
                            SizedBox(
                              width: 8,
                            ),
                            
                                 GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {

                                      if(currentIndex + 1 !=
                                    questionController.questions.length){
   questionController.hideOrShowAnswer(
                                          isShowAnswer: false);
                                      currentIndex++;
                                      FocusScope.of(context).unfocus();

                                      pageViewController
                                          .jumpToPage(currentIndex);
                                      // pageViewController.animateToPage(currentIndex, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                                  
                                    }
                                     },
                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                            height: 44,
                                            width: 44,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(56),
                                                    border: questionController.questions.length == currentIndex+1? Border.all(color: Colors.black.withOpacity(0.1), width: 1): Border.all(color: Color(0xffFFBF00), width: 0),
                                                color:questionController.questions.length == currentIndex+1? Colors.transparent:  Color(0xffFFBF00)
                                                    ),
                                            child: Icon(
                                               Icons.arrow_forward_rounded,
                                              color: questionController.questions.length == currentIndex+1? Colors.black.withOpacity(0.1): Colors.white,
                                              size: 24,
                                            )
                                            // Lottie.asset(
                                            //     'assets/image/arrow.json',
                                            //     fit: BoxFit.contain),
                                            ),
                                      ],
                                    ),
                                  )
                              
                          ]),
                        ),
                       if(questionController.questions.length == currentIndex+1)  const SizedBox(
                          height: 12,
                        ),
                         if(questionController.questions.length == currentIndex+1) GestureDetector(
          onTap: (){

            //ager click hota hai to hum ne isse 1 per le jana hai

            currentIndex = 0;
            pageViewController
                                          .jumpToPage(currentIndex);
            setState(() {
              
            });

            
            
          },
          child: Container(
            height: 56,
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xffFFBF00),
              // border: Border.all(width: 1.5, color: Colors.black)
              // boxShadow: const [
              //   BoxShadow(
              //     color: Colors.black26,
              //     blurRadius: 8,
              //   ),
              // ],
            ),
            child: Center(
              child: Text(
                "Beginnen Sie von vorne",
                style: ralewayBold.copyWith(
                  color: Colors.white,
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
            ),
          ),
        ),
                     const SizedBox(
                          height: 12,
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        margin: EdgeInsets.only(bottom: context.width * .3),
                        child: LoadingAnimationWidget.flickr(
                          leftDotColor: AppColor
                              .primaryGradiantStart, //Get.theme.primaryColor,
                          rightDotColor: AppColor.primaryGradiantEnd,
                          size: 50,
                        ),
                      ),
                    );
            }),
          ),
        )),
        bottomNavigationBar:
            Get.find<AuthController>().getLoginUserData()?.paymentStatus != "1"
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        sliderBtn(),
                        SizedBox(
                          height: 12,
                        )
                      ],
                    ),
                  )
                : const SizedBox(),
        // Get.find<AuthController>().getLoginUserData()?.paymentStatus != "1"
        //     ? GestureDetector(
        //         onTap: () {
        //           Get.toNamed(RouteHelper.getPurchasePlanScreenRoute());
        //         },
        //         child: Container(
        //           alignment: Alignment.center,

        //           height: 60,
        //           // minWidth: width,
        //           color: Theme.of(context).primaryColor,

        //           child: Text("Buy Full Version",
        //               textAlign: TextAlign.center,
        //               style: ralewayBold.copyWith(
        //                 color: Colors.white,
        //                 fontSize: Dimensions.fontSizeDefault,
        //               )),
        //         ),
        //       )
        //     : const SizedBox(),
      ),
    );
  }

  Widget sliderBtn() {
    
        return GestureDetector(
          onTap: (){
              if(Get.find<AuthController>()
                                  .getLoginUserData() != null){
        Get.toNamed(RouteHelper.getPurchasePlanScreenRoute());

                                  }else{
                                    showCustomSnackBar('Sie müssen sich zuerst anmelden', isError: false);
        Get.toNamed(RouteHelper.getSignInRoute());

                                  }
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xffFFBF00),
              // border: Border.all(width: 1.5, color: Colors.black)
              // boxShadow: const [
              //   BoxShadow(
              //     color: Colors.black26,
              //     blurRadius: 8,
              //   ),
              // ],
            ),
            child: Center(
              child: Text(
               Get.find<AuthController>().getLoginUserData() == null? 'Anmeldung zur Vollversion':  "Vollversion Kaufen",
                style: ralewayBold.copyWith(
                  color: Colors.white,
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
            ),
          ),
        );
      
   
      
    
    // return SlideAction(
    //   text: 'Buy Full Version',
    //   borderRadius: 12,
    //   key: _key,
    //   // innerborderRadius: 8,textAlign: TextAlign.center,
    //   textStyle: ralewayBold.copyWith(
    //     color: Colors.white,
    //     fontSize: Dimensions.fontSizeDefault,
    //   ),
    //   sliderButtonIcon: Icon(
    //     Icons.arrow_forward_ios_rounded,
    //     color: Colors.black,
    //   ),

    //   elevation: 1,
    //   innerColor: Colors.white,
    //   // innerborderRadius: 10,
    //   outerColor: Colors.black,
    //   sliderButtonIconPadding: 12,
    //   height: 56,
    //   sliderRotate: false,
    //   // alignment: Alignment.,

    //   onSubmit: () {
    //     Future.delayed(Duration(milliseconds: 300), () {
    //       _key.currentState!.reset();
    //       Get.toNamed(RouteHelper.getPurchasePlanScreenRoute());
    //     });
    //   },
    // );
  }
}



// SwipeActionCell(
//           controller: _swipecontroller,
//           closeWhenScrolling: true,

//           isDraggable: true,

//           backgroundColor: Colors.transparent,

//           ///this key is necessary
//           key: ObjectKey(index),
//           trailingActions: <SwipeAction>[
//             SwipeAction(

//                 ///this is the same as iOS native
//                 performsFirstActionWithFullSwipe: false,
//                 icon: GestureDetector(
//                   onTap: () {
//                     travelList.removeAt(index);

//                     var da = {'travels': travelList};
//                     print(da);

//                     ApiService()
//                         .updateuser(da, userData['_id'])
//                         .then((value) async {
//                       log(value.toString());
//                       if (value['status'] == 1) {
//                         await Auth().setUser(json.encode(value['data']));

//                         setState(() {});
//                       }
//                     });
//                   },
//                   child: Center(
//                     child: Container(
//                       height: 32,
//                       width: 32,
//                       child: Image.asset(
//                         'assets/del_w.png',
//                         color: textColor1,
//                       ),
//                     ),
//                   ),
//                 ),
//                 onTap: (CompletionHandler handler) async {},
//                 color: redColor),
//             SwipeAction(

//                 ///this is the same as iOS native
//                 performsFirstActionWithFullSwipe: false,
//                 icon: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => TravelsPage(
//                                   trips: travelList,
//                                   index: index,
//                                 ))).then((value) {
//                       getUser();
//                     });
//                   },
//                   child: Center(
//                     child: Container(
//                       height: 32,
//                       width: 32,
//                       child: Image.asset(
//                         'assets/edit.png',
//                         color: textColor4,
//                       ),
//                     ),
//                   ),
//                 ),
//                 onTap: (CompletionHandler handler) async {},
//                 color: inputFillColor),
//           ],

//           child: GestureDetector(
//             onTap: () {},
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 8, horizontal: h_Padding),
//               width: size.width,
//               // color: Colors.red,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 56,
//                     width: 56,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(100),
//                         color: inputFillColor,
//                         image: DecorationImage(
//                             image: AssetImage('assets/navigation.png'),
//                             scale: 4.5)),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         RichText(
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           text: TextSpan(
//                             text: travelList[index]['destination'],
//                             style: TextStyle(
//                                 color: textColor4,
//                                 fontFamily: 'Gilroy',
//                                 fontWeight: w600,
//                                 height: 1.25,
//                                 fontSize: f16),
//                             children: [
//                               TextSpan(
//                                 text: ' (' + travelList[index]['country'] + ')',
//                                 style: TextStyle(
//                                     color: textColor2,
//                                     fontWeight: w500,
//                                     height: 1.25,
//                                     fontSize: f16),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 4,
//                         ),
//                         Container(
//                           // width: size.width - 150,
//                           child: Text(
//                             travelList[index]['startDate'] +
//                                 ' - ' +
//                                 travelList[index]['endDate'],
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 color: textColor2,
//                                 fontWeight: w500,
//                                 fontSize: f16),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                       width: 32,
//                       height: 32,
//                       alignment: Alignment.center,
//                       // color: Colors.red,
//                       child: Image.asset(
//                         'assets/horizontal_dots.png',
//                       ))
//                 ],
//               ),
//             ),
//           ),
//         ),