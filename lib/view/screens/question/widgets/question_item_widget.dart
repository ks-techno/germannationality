import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:German123/controller/auth_controller.dart';
import 'package:German123/controller/question_controller.dart';
import 'package:German123/controller/translation_language_controller.dart';
import 'package:German123/data/model/response/question_model.dart';
import 'package:German123/data/repository/auth_repo.dart';
import 'package:German123/enums/auido_player.dart';
import 'package:German123/util/app_constants.dart';
import 'package:German123/util/app_strings.dart';
import 'package:German123/util/color_constants.dart';
import 'package:German123/util/styles.dart';
import 'package:German123/view/base/custom_snackbar.dart';
import 'package:German123/view/base/loading_widget.dart';
import 'package:German123/view/base/my_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';
// import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart' as Getx;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class QuestionItemWidget extends StatefulWidget {
  final Question question;
  final int questionIndex;
  final bool testMode;
  const QuestionItemWidget({
    Key? key,
    required this.question,
    required this.testMode,
    required this.questionIndex,
  }) : super(key: key);

  @override
  State<QuestionItemWidget> createState() => _QuestionItemWidgetState();
}

class _QuestionItemWidgetState extends State<QuestionItemWidget>
    with TickerProviderStateMixin {
  late AnimationController progressController;
  late AnimationController videoPausePlayButtonVisibilityController;
  CachedVideoPlayerController? controller;
  final TextEditingController _answerController = TextEditingController();
  final FocusNode _answerFocusNode = FocusNode();
  CachedVideoPlayerController? audioController;
  CachedVideoPlayerController? audioController2;
  late Color color;
  List<TranslationLanguage> selectedAnswer = <TranslationLanguage>[];
  Duration _audioPlayerMaxDuration = const Duration(seconds: 0);
  bool isAnswerCorrect = false;
  Color boxBackGroundColor = const Color(0xFF808080).withOpacity(0.05);
   bool inGerman = false;

  VideoPlayerOptions v_opt = VideoPlayerOptions(
    mixWithOthers: true,
  );

  @override
  void initState() {
    progressController = AnimationController(
      vsync: this,
      duration: _audioPlayerMaxDuration,
    );
    videoPausePlayButtonVisibilityController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );
   
    if (widget.question.videoUrl != null) {
      controller = CachedVideoPlayerController.network(
          AppConstants.STORAGE_URL + widget.question.videoUrl!,
          videoPlayerOptions: v_opt);

      controller!.initialize().then((value) {
        controller!.setLooping(true);
        controller!.setVolume(0.0);
        if (!Platform.isIOS) {
          controller!.play();
        }
        setState(() {});
      }).catchError((onError) {
        showCustomSnackBar('Unable to play video');
      });
    }
   
    if (widget.question.audioUrl != null && !widget.testMode) {
      audioController = CachedVideoPlayerController.network(
          AppConstants.STORAGE_URL + widget.question.audioUrl!);
      audioController!.initialize().then((value) {
        audioController!.setLooping(false);
        setState(() {});
      }).catchError((onError) {
        debugPrint("on audio play Error :-> $onError");
        showCustomSnackBar('Unable to play audio');
      });
    }
    if (widget.question.audioUrl_german != null && !widget.testMode) {
      audioController2 = CachedVideoPlayerController.network(
          AppConstants.STORAGE_URL + widget.question.audioUrl_german!);
      audioController2!.initialize().then((value) {
        audioController2!.setLooping(false);
        setState(() {});
      }).catchError((onError) {
        debugPrint("on audio play Error :-> $onError");
        // showCustomSnackBar('Unable to play audio');
      });
    }

    super.initState();
  }


  bool isLTR(){

    bool da = true;

    try{
    da =  Get.find<AuthController>()
                                  .getLoginUserData()!
                                  .translationLanguage!
                                  .isLTR;
    }catch(e){
      //na hua to matlab login nahi hai

     da =  Get.find<AuthController>().authRepo.getSelectedLanguage()['is_ltr'] == 0? false: true;

    }



    return da;

  }
  TextStyle translationStyle(){
    TextStyle da = TextStyle();

    try{
     da = GoogleFonts.getFont(
                                        Get.find<AuthController>()
                                            .getLoginUserData()!
                                            .translationLanguage!
                                            .fontFamily)
                                    .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.primaryGradiantStart,
                                );
    }catch(e){
      //matlab login nahi hai

       da = GoogleFonts.getFont(Get.find<AuthController>().authRepo.getSelectedLanguage()['font_family']
                                       )
                                    .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.primaryGradiantStart,
                                );
    }

    return da;
  }

  addMarks(int index, int marks) async {
  
   

    if (widget.question.type == 'option') {
      //hmein sare options ko check kerna ho ga
   


      int actualCorrect = widget.question.options
          .where((el) => el.isCorrectAnswer == true)
          .toList()
          .length;
      int selectedCorrect = selectedAnswer
          .where((el) => el.isCorrectAnswer == true)
          .toList()
          .length;
      int totalSelected = selectedAnswer
          .length;
            debugPrint(selectedCorrect.toString());
 

  
      if ((selectedCorrect != actualCorrect) || (totalSelected != selectedCorrect)) {
        marks = 0;
 

  

      }
    } else {
      //jo peche se marks aa rahe jaane do
   
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      List testResults = jsonDecode(prefs.getString('testResults')!);

      debugPrint(testResults.toString());

      testResults[index] = marks;

      debugPrint(testResults.toString());

      prefs.setString('testResults', jsonEncode(testResults));
    } catch (e) {}
  }

  @override
  void dispose() {
    controller?.dispose();
    audioController?.dispose();
    audioController2?.dispose();
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    color = Colors.grey.shade300;
    return GetBuilder<QuestionController>(builder: (questionController) {
      return ListView(
        shrinkWrap: true,
        // padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          // const SizedBox(
          //   height: 20,
          // ),
          // Text(
          //   "Q: ${widget.questionIndex+1}",
          //   textAlign: TextAlign.center,
          //   style: ralewayMedium.copyWith(
          //     fontSize: 18,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // const SizedBox(height: 10,),
          /// Question portion
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              // border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              // borderRadius: BorderRadius.circular(12),
              // color: Colors.amberAccent.withOpacity(0.2),
              // color: boxBackGroundColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Text(AppConstants.STORAGE_URL+widget.question.videoUrl.toString()),

                ///Image or Video portion
                widget.question.videoUrl != null ||
                        widget.question.imageUrl != null
                    ? GestureDetector(
                        onTap: () {
                          videoPausePlayButtonVisibilityController.stop(
                              canceled: true);
                          videoPausePlayButtonVisibilityController =
                              AnimationController(
                            vsync: this,
                            duration: const Duration(milliseconds: 1500),
                          );
                          videoPausePlayButtonVisibilityController.forward();
                          setState(() {});
                          Future.delayed(const Duration(milliseconds: 1500))
                              .then((value) {
                            if (videoPausePlayButtonVisibilityController
                                .isAnimating) {
                              videoPausePlayButtonVisibilityController.stop(
                                  canceled: true);
                              setState(() {});
                            }
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              
                            

                              borderRadius: BorderRadius.circular(12),
                              child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: widget.question.videoUrl != null &&
                                          controller!.value.isInitialized
                                      ? GestureDetector(
                                          onTap: () {
                                            if (Platform.isIOS) {
                                              if (controller!.value.isPlaying) {
                                                controller!.pause();
                                              } else {
                                                controller!.play();
                                              }
                                            }
                                          },
                                          child: CachedVideoPlayer(controller!))
                                      : widget.question.videoUrl != null
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  AppConstants.STORAGE_URL +
                                                      widget.question.videoUrl!,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              // errorWidget: (context, url, error) => const Icon(Icons.error),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(),
                                              fit: BoxFit.fill,
                                              memCacheHeight: 10,
                                              memCacheWidth: 10,
                                              height: 10,
                                              width: 10,
                                              key: Key(
                                                  widget.question.videoUrl ??
                                                      ''),
                                              cacheKey:
                                                  widget.question.videoUrl ??
                                                      '',
                                            )
                                          : widget.question.imageUrl != null
                                              ? CachedNetworkImage(
                                                  imageUrl: AppConstants
                                                          .STORAGE_URL +
                                                      widget.question.imageUrl!,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  fit: BoxFit.fill,
                                                )
                                              : const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )),
                            ),
                            // widget.question.videoUrl != null &&
                            //         (controller?.value.isInitialized ??
                            //             false) &&
                            //         videoPausePlayButtonVisibilityController
                            //             .isAnimating
                            //     ? Container(
                            //         decoration: BoxDecoration(
                            //           color: Colors.black12,
                            //           shape: BoxShape.circle,
                            //           border: Border.all(
                            //               color: Colors.grey.shade200),
                            //         ),
                            //         alignment: Alignment.center,
                            //         child: IconButton(
                            //           onPressed: () async {
                            //             if (controller!.value.isPlaying) {
                            //               await controller!.pause();
                            //             } else {
                            //               await controller!.play();
                            //             }
                            //             setState(() {});
                            //           },
                            //           icon: Icon(
                            //               controller!.value.isPlaying
                            //                   ? Icons.pause
                            //                   : Icons.play_arrow,
                            //               size: 35,
                            //               color: ColorTween(
                            //                       begin: AppColor
                            //                           .primaryGradiantEnd,
                            //                       end: AppColor
                            //                           .primaryGradiantStart)
                            //                   .transform(8 / 10)),
                            //         ),
                            //       )
                            //     : const SizedBox(),

                            if (widget.question.videoUrl != null && Platform.isIOS)
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  if (controller!.value.isPlaying) {
                                    await controller?.pause();
                                  } else {
                                    await controller?.play();
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                      color: Color(0xfff4f4f4),
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Icon(
                                    controller!.value.isPlaying
                                        ? Icons.pause_rounded
                                        : 
                                        Icons.play_arrow_rounded,
                                    size: 32,
                                    color: AppColor.primaryGradiantStart,
                                  ),
                                ),
                              )
                          ],
                        ),
                      )
                    : const SizedBox(),
                SizedBox(
                  height: widget.question.videoUrl != null ||
                          widget.question.imageUrl != null
                      ? 10
                      : 0,
                ),
 SizedBox(
            height: 10,
          ),
           /// Audio File Section

                (widget.question.audioUrl != null )&&
                        questionController.isShowTranslation &&
                        !widget.testMode
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          // color: Colors.red,
                          // border: Border.all(color: Theme.of(context).primaryColor),
                          // borderRadius: BorderRadius.circular(0),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {

                                      if(inGerman){
 if (audioController2!
                                          .value.isInitialized) {
                                        if (audioController2!.value.isPlaying) {
                                          pauseAudioPlayer();
                                        } else {
                                          startAudioPlayer();
                                        }
                                      }
                                      }else{
                                         if (audioController!
                                          .value.isInitialized) {
                                        if (audioController!.value.isPlaying) {
                                          pauseAudioPlayer();
                                        } else {
                                          startAudioPlayer();
                                        }
                                      }
                                      }
                                     
                                     
                                    },
                                    radius: 100,
                                    borderRadius: BorderRadius.circular(100),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100)
                                      ),
                                      elevation: 10,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: audioController!
                                                  .value.isInitialized &&  audioController2!
                                                  .value.isInitialized
                                              ? Icon(
                                                  audioController!.value.isPlaying || audioController2!.value.isPlaying
                                                      ? Icons.pause_rounded
                                                      : Icons.play_arrow_rounded,
                                                  size: 35,
                                                  color: ColorTween(
                                                          begin: Theme.of(context).errorColor,
                                                          end: Theme.of(context).errorColor)
                                                      .transform(8 / 10),
                                                )
                                              : const SizedBox(
                                                  height: 35,
                                                  width: 35,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                
                                  Expanded(
                                    child: Container(
                                      height: 4,
                                      
                                      padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: LinearProgressIndicator(
color: Theme.of(context).errorColor,

                                          value: progressController.value,
                                          backgroundColor: Colors.grey,
                                          minHeight: 2,
                                          
                                          semanticsLabel:
                                              'Linear progress indicator',
                                        ),
                                      ),
                                      // child: AirLinearStateProgressIndicator(
                                      //   size: const Size(150, 150),
                                      //   shouldRepaint: true,
                                      //   value: _audioPlayerDuration.inMilliseconds.toDouble(),
                                      //   min: 0,
                                      //   max: _audioPlayerMaxDuration.inMilliseconds.toDouble(),
                                      //   valueColor: AppColor.primaryGradiantStart,
                                      //   pathStrokeWidth: 10.0,
                                      //   valueStrokeWidth: 10.0,
                                      //   roundCap: true,
                                      // ),
                                    ),
                                  ),
                               if(widget.question.audioUrl_german != null)  InkWell(
                                    onTap: () {
pauseAudioPlayer();
audioController!.seekTo(Duration(seconds: 0));
audioController2!.seekTo(Duration(seconds: 0));
                                      setState(() {
                                        inGerman = !inGerman;
                                      });
                                      
                                     
                                    },
                                    radius: 100,
                                    borderRadius: BorderRadius.circular(100),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100)
                                      ),
                                      elevation: 10,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        height: 44,
                                        width: 44,
                                        decoration: BoxDecoration(

                                          color: Colors.white,
                                          

                                          image: DecorationImage(
                                            image: const AssetImage('assets/image/Germany.jpeg'),
                                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),

                                            fit: BoxFit.cover
                                          ),
                                          
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(

                                          child: inGerman? const Icon(Icons.check,
                                          color: Colors.white,
                                          
                                        ): Container(),
                                         
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // Icon(Icons.volume_up_rounded,
                                  // size: 30,
                                  // )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                     SizedBox(
                  height: 10,
                ),
               
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Text(
                    widget.question.question.primary,
                    textAlign: TextAlign.start,
                    style: ralewayMedium.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF181818).withOpacity(0.8),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Divider(
                //   height:
                //       questionController.isShowTranslation && !widget.testMode
                //           ? 10
                //           : 0,
                // ),

                questionController.isShowTranslation && !widget.testMode
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: 
                          isLTR()
                              ? MainAxisAlignment.start
                              : 
                              MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                widget.question.question.secondary,
                                textAlign:
                                isLTR()
                                    ? TextAlign.left
                                    :
                                     TextAlign.right,
                                style: translationStyle(),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
               
              ],
            ),
          ),

         
          
                const SizedBox(
                  height: 16,
                ),

          // widget.question.options.isNotEmpty
          widget.question.type == 'option'
              ? Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    // color: Colors.amber.withOpacity(0.2),
                  ),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.question.options.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        TranslationLanguage option =
                            widget.question.options[index];
                        return option.primary == ''? Container(): optionRow(
                            option: option,
                            questionController: questionController,
                            testMode: widget.testMode,
                            index: index);
                      }),
                )
              : Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInputTextField(
                        controller: _answerController,
                        focusNode: _answerFocusNode,
                        isPassword: true,
                        fieldRadius: 5,
                        noPadding: true,
                        context: context,
                        maxLines: 3,
                        minLines: 1,
                        hintText: AppString.enterAnswer,
                        onValueChange: (value) {
                          if ((value ?? "").trim() ==
                              widget.question.answerValue) {
                            isAnswerCorrect = true;
                            addMarks(widget.questionIndex,
                                int.parse(widget.question.marks));
                          } else {
                            isAnswerCorrect = false;
                            addMarks(widget.questionIndex, 0);
                          }
                          setState(() {});
                        },
                        suffixIcon: _answerController.text.trim().isNotEmpty &&
                                !widget.testMode
                            ? Icon(
                                isAnswerCorrect
                                    ? Icons.done_outlined
                                    : Icons.close,
                                color:
                                    isAnswerCorrect ? Colors.green : Colors.red,
                              )
                            : null,
                        // validator: (inputData) {
                        // return inputData!.isEmpty
                        // ? ErrorMessage.passwordEmptyError
                        //     : inputData.length<AppConstants.PASSWORD_MIN_LENGTH
                        // ?  ErrorMessage.passwordMinLengthError
                        //     : inputData.length>250
                        // ? ErrorMessage.passwordMaxLengthError
                        //     : null;
                        // },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (!widget.testMode)
                        Text(
                          " Answer:  ${questionController.isShowAnswer ? widget.question.answerValue : ''}",
                          style: ralewayRegular.copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
              ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    });
  }

  Widget optionRow(
      {required TranslationLanguage option,
      required QuestionController questionController,
      required bool testMode,
      required int index}) {
    Color questionColor = questionController.getQuestionSelectionColor(
        option: option, context: context, selectedAnswersList: selectedAnswer);
    Color borderColor = questionController.getQuestionSelectionColor(
        option: option,
        context: context,
        selectedAnswersList: selectedAnswer,
        isBorder: true);

    Color primaryColor = Theme.of(context).primaryColor;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          if (questionController.checkIfOptionExists(
              option: option, selectionList: selectedAnswer)) {
            selectedAnswer.remove(option);
          } else {
            selectedAnswer.add(option);
          }
          if (testMode) {
            //marks calculation bhe kerwani hai
            //yahan hum ne dekhna hai k 1 se zyada ager correct hain to dono correcrt hoon ge to add ho ga

            // if(option.isCorrectAnswer){
            addMarks(widget.questionIndex, int.parse(widget.question.marks));

            // }else{
            // addMarks(widget.questionIndex,0);

            // }

          }
        });
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border:
                   testMode? Border.all(width: 1, color: Colors.grey.withOpacity(0.3)) : Border.all(width: 1, color: borderColor),

                // borderRadius: BorderRadius.circular(12),
                color: testMode? Colors.transparent: questionColor == Colors.grey.shade300? Colors.transparent:   questionColor != Theme.of(context).errorColor?  Color(0xffFFF8DC) : Colors.transparent,

               
                // gradient: LinearGradient(
                //   colors: [
                //     Colors.black.withOpacity(0.05),
                //     Colors.grey.withOpacity(0.05)
                //   ],
                // ),
                // border: Border(bottom: BorderSide(color: boxBackGroundColor)),
                // color: Colors.blueGrey,
                boxShadow: const [
                  // BoxShadow(
                  //   color: Color(0xfff4f4f4),
                  //   blurRadius: 4,
                  //   spreadRadius: 1,
                  //   // offset: Offset(1, 0)
                  // )
                ]
                // border: Border.all(
                //   color: questionController.getQuestionSelectionColor(option: option, context: context, selectedAnswersList: selectedAnswer,isBorder: true),
                // ),
                ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: testMode ? primaryColor : borderColor, width: 2),
                    borderRadius: BorderRadius.circular(5),
                    color: questionColor == color
                        ? Colors.white
                        : testMode
                            ? primaryColor
                            : questionColor,
                  ),
                  child: Center(
                    child: Icon(
                        questionColor == Theme.of(context).errorColor &&
                                !testMode
                            ? Icons.close_rounded
                            : Icons.done_rounded,
                        size: 20,
                        color: questionColor == color
                            ? Colors.transparent
                            : Colors.white),
                    // child: Text(
                    //     optionSequence,
                    //   style: ralewayMedium.copyWith(
                    //       color: questionController.getQuestionSelectionColor(option: option, context: context, answersList: widget.question.correctAnswer, selectedAnswersList: selectedAnswer) ==color? Colors.black : Colors.white,fontWeight: FontWeight.w600),
                    // ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toBeginningOfSentenceCase(option.primary)!,
                        textAlign: TextAlign.start,
                        style: ralewayRegular.copyWith(

                          color : testMode? Color(0xFF181818).withOpacity(0.7): questionColor == Colors.grey.shade300? Color(0xFF181818).withOpacity(0.7):   questionColor != Theme.of(context).errorColor?  Color(0xFF181818) : Color(0xFF181818).withOpacity(0.7)
                          ,
                         
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Divider(
                      //   height:
                      //       questionController.isShowTranslation && !testMode
                      //           ? 10
                      //           : 0,
                      // ),
                      questionController.isShowTranslation && !testMode
                          ? Row(
                              mainAxisAlignment:
                               isLTR()
                                  ? MainAxisAlignment.start
                                  : 
                                  MainAxisAlignment.end,
                              children: [
                                Flexible(
                                  child: Text(
                                    option.secondary,
                                    textAlign:
                                     isLTR()
                                        ? TextAlign.left
                                        :
                                         TextAlign.right,
                                    style: translationStyle(),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ************* (AUDIO PLAYER) ********************
  void startAudioPlayer() async {
    

    if(inGerman){
await audioController2!.play();
    if (audioController2!.value.position.inMilliseconds > 0) {
      progressController.forward();
    } else {
      _audioPlayerMaxDuration = audioController2!.value.duration;
      progressController = AnimationController(
        vsync: this,
        duration: audioController2!.value.duration,
      );
      progressController.forward();
      progressController.addListener(() {
        if (progressController.isCompleted) {
          audioController2!.pause();
          audioController2!.seekTo(const Duration(seconds: 0));
          progressController.stop(canceled: true);
          progressController.animateTo(0,
              duration: const Duration(milliseconds: 100));
        }
        setState(() {});
      });
    }
    }else{
      await audioController!.play();
    if (audioController!.value.position.inMilliseconds > 0) {
      progressController.forward();
    } else {
      _audioPlayerMaxDuration = audioController!.value.duration;
      progressController = AnimationController(
        vsync: this,
        duration: audioController!.value.duration,
      );
      progressController.forward();
      progressController.addListener(() {
        if (progressController.isCompleted) {
          audioController!.pause();
          audioController!.seekTo(const Duration(seconds: 0));
          progressController.stop(canceled: true);
          progressController.animateTo(0,
              duration: const Duration(milliseconds: 100));
        }
        setState(() {});
      });
    }
    }
    
    setState(() {});
  }

  void pauseAudioPlayer() async {
    try {
      await audioController!.pause();
      await audioController2!.pause();
      progressController.stop(canceled: false);
      // if (playerModule.isPlaying) {
      //   await playerModule.pausePlayer();
      //   progressController.stop(canceled: false);
      // }
    } on Exception catch (err) {
      debugPrint("Exception on pauseAudioPlayer:-> $err");
    }
    setState(() {});
  }

}
