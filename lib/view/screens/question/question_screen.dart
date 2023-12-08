import 'package:German123/controller/auth_controller.dart';
import 'package:German123/controller/question_controller.dart';
import 'package:German123/custom_packages/customselector/utils/enum.dart';
import 'package:German123/custom_packages/customselector/utils/flutter_custom_select_item.dart';
import 'package:German123/custom_packages/customselector/widget/flutter_custom_selector_sheet.dart';
import 'package:German123/data/model/response/category_model.dart';
import 'package:German123/data/model/response/question_model.dart';
import 'package:German123/util/app_constants.dart';
import 'package:German123/util/color_constants.dart';
import 'package:German123/util/dimensions.dart';
import 'package:German123/util/styles.dart';
import 'package:German123/view/base/custom_app_bar.dart';
import 'package:German123/view/screens/question/widgets/question_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/app_strings.dart';
import '../../base/custom_button.dart';

class QuestionScreen extends StatefulWidget {
  final QuestionCategory questionCategory;
  const QuestionScreen({Key? key, required this.questionCategory})
      : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  // List<Question> questions = [];
  late PageController pageViewController;
  final List<Widget> _pageViewItem = <Widget>[];
  int currentIndex = 0;
  int questionNumber = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    currentIndex = Get.find<SharedPreferences>().getInt(
            "${AppConstants.CATEGORY_QUESTON_TO_VIEW_INDEX}${widget.questionCategory.id}") ??
        0;
    pageViewController = PageController(initialPage: currentIndex);
    Get.find<QuestionController>()
        .fetchQuestions(
            questionCategory: widget.questionCategory, isFromInitState: true)
        .then((value) {
      if (currentIndex+1 >= Get.find<QuestionController>().questions.length) {
        currentIndex = 0;
      }

     

     

     setState(() {
       
     });
      
    });
    super.initState();
  }


  savePerformance(questionId){

    dynamic data = {
      'user_id': Get
                                                            .find<
                                                                AuthController>()
                                                        .getLoginUserData()!.id,
      'q_id':questionId
    };
 
    Get.find<QuestionController>()
        .savePerformance(
data
           )
        .then((value) {

          debugPrint("--------------------------------------------");
          debugPrint(value.toString());
      //  value['Success']['result'];
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: {"nextCategoryIndexToView": currentIndex });
        return false;
      },
      child: Scaffold(

        appBar : AppBar(
      toolbarHeight: 80,
      elevation: 8,
      backgroundColor: Colors.white,
      centerTitle: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16))),
      // backgroundColor: Colors.yellow,
      leading: Container(
              // decoration: BoxDecoration(
              //   shape: BoxShape.circle,
              //   color: Colors.black26,
              //   border: Border.all(color: Colors.black26),
              // ),
              // margin: const EdgeInsets.only(left: 10),
              child: InkWell(
                  radius: 100,
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
   
                         Get.back(result: {"nextCategoryIndexToView":  currentIndex});

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  )),
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
                        'Frage # ' +
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
            )
          ,
      actions: [
              IconButton(
                padding: EdgeInsets.zero,
                color: Colors.red,
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
                              : "Übersetzung zeigen")
                    ],
                  );
                  if (result['selection'] != null) {
                    Get.find<QuestionController>().hideOrShowTranslation();
                  }
                },
                // icon: Icon(Icons.translate_rounded,),
                icon: Icon(
                  Icons.settings_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
              ),
            ]

      
      ),
       
        //  CustomAppBar(
        //   title: widget.questionCategory.primaryName +
        //       ' # ' +
        //       (currentIndex + 1).toString(),
        //   leading: null,
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
        //       // icon: Icon(Icons.translate_rounded,),
        //       icon: Icon(
        //         Icons.settings_rounded,
        //         color: Theme.of(context).primaryColor,
        //         size: 28,
        //       ),
        //     ),
        //   ],
        // ),
        body: SafeArea(
            child: SmartRefresher(
          onRefresh: () async {
            await Get.find<QuestionController>().fetchQuestions(
                questionCategory: widget.questionCategory,
                isFromInitState: false);
            if (currentIndex >
                Get.find<QuestionController>().questions.length) {
              currentIndex = 0;
              setState(() {});
            }
            _refreshController.refreshCompleted();
          },
          controller: _refreshController,
          child: Container(
            width: context.width,
            // padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
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
                                });

                                savePerformance(questionController.questions[currentIndex].id);
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
                        Container(
                          // color: Color(0xfff4f4f4),
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
                                          Text(
                                            questionController.isShowAnswer
                                                ? "Antwort Verstecken"
                          : "Antwort Zeigen",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
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

                                      if(currentIndex != 0){
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
                                                  border : currentIndex == 0? Border.all(color: Colors.black.withOpacity(0.1),width: 1): Border.all(color: Color(0xffFFBF00), width: 0),
                                              color:
                                                  currentIndex == 0? Colors.transparent: Color(0xffFFBF00),
                                            ),
                                            child: Icon(
                                              Icons.arrow_back_rounded,
                                              size: 24,

                                              color: currentIndex == 0? Colors.black.withOpacity(0.1): Colors.white,
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

                                  if (currentIndex + 1 !=
                                questionController.questions.length){
               questionController.hideOrShowAnswer(
                                      isShowAnswer: false);
                                  currentIndex++;
                                  FocusScope.of(context).unfocus();

                                  pageViewController.jumpToPage(currentIndex);
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
                                                       border : questionController.questions.length == currentIndex+1 ? Border.all(color: Colors.black.withOpacity(0.1),width: 1): Border.all(color: Color(0xffFFBF00), width: 0),
                                           

                                            color:  questionController.questions.length == currentIndex+1 ? Colors.transparent :
                                                Color(0xffFFBF00)),
                                        child: Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 24,
                                           color: questionController.questions.length == currentIndex+1 ? Colors.black.withOpacity(0.1): Colors.white,
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

                        if(currentIndex + 1 ==
                                questionController.questions.length) Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 12,
                        ),

                        GestureDetector(
          onTap: (){

            //ager click hota hai to hum ne isse 1 per le jana hai

            currentIndex = 0;
            pageViewController
                                          .jumpToPage(currentIndex);

            setState(() {
              
            });

             Get.find<SharedPreferences>().setInt(
                                          "${AppConstants.CATEGORY_QUESTONS_VIEWED}${widget.questionCategory.id}",
                                          0);
                                           Get.find<SharedPreferences>().setInt(
                                          "${AppConstants.CATEGORY_QUESTON_TO_VIEW_INDEX}${widget.questionCategory.id}",
                                          0);
            
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
                "Beginnen Sie von vorne",
                style: ralewayBold.copyWith(
                  color: Colors.white,
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
            ),
          ),
        ),
                       
                        SizedBox(
                          height: 12,
                        )
                      ],
                    ),
                  ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     if (currentIndex != 0)
                        //       Expanded(
                        //         child: Container(
                        //           child: CustomButton(
                        //             fontSize: 12,
                        //             height: 44,
                        //             backgroundTransparent: true,
                        //             buttonText: AppString.previous.tr,
                        //             onPressed: () {
                        //               questionController.hideOrShowAnswer(
                        //                   isShowAnswer: false);
                        //               currentIndex--;
                        //               pageViewController
                        //                   .jumpToPage(currentIndex);
                        //               // pageViewController.animateToPage(currentIndex, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                        //             },
                        //           ),
                        //         ),
                        //       ),
                        //     if (currentIndex != 0)
                        //       const SizedBox(
                        //         width: 5,
                        //       ),
                        //     Expanded(
                        //       child: CustomButton(
                        //         height: 44,
                        //         fontSize: 12,
                        //         buttonText: questionController.isShowAnswer
                        //             ? AppString.hideAnswer.tr
                        //             : AppString.showAnswer.tr,
                        //         onPressed: () {
                        //           questionController.hideOrShowAnswer();
                        //         },
                        //       ),
                        //     ),
                        //     if (currentIndex !=
                        //         questionController.questions.length - 1)
                        //       const SizedBox(
                        //         width: 5,
                        //       ),
                        //     if (currentIndex !=
                        //         questionController.questions.length - 1)
                        //       Expanded(
                        //         child: Container(
                        //           // margin: const EdgeInsets.only(left: 5),
                        //           child: CustomButton(
                        //             fontSize: 12,
                        //             height: 44,
                        //             // width: 80,
                        //             backgroundTransparent: true,
                        //             buttonText: AppString.next.tr,
                        //             onPressed: () {
                        //               questionController.hideOrShowAnswer(
                        //                   isShowAnswer: false);
                        //               currentIndex++;
                        //               FocusScope.of(context).unfocus();

                        //               pageViewController
                        //                   .jumpToPage(currentIndex);
                        //               // pageViewController.animateToPage(currentIndex, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                        //             },
                        //           ),
                        //         ),
                        //       ),
                        //   ],
                        // ),
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
      ),
    );
  }
}
