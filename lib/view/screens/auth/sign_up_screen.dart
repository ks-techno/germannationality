import 'package:German123/custom_packages/customselector/widget/flutter_single_select.dart';
import 'package:German123/enums/gender.dart';
import 'package:German123/theme/light_theme.dart';
import 'package:German123/util/dimensions.dart';
import 'package:German123/util/images.dart';
import 'package:German123/util/styles.dart';
import 'package:German123/view/base/custom_app_bar.dart';
import 'package:German123/view/base/custom_snackbar.dart';
import 'package:German123/view/screens/auth/widget/gender_widget.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../util/app_constants.dart';
import '../../../util/app_strings.dart';
import '../../base/custom_button.dart';
import '../../base/my_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _mobileNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  Gender userGender = Gender.Male;
  bool hidePassword = true;
  bool hideConfirmPassword=true;
  final _formKey = GlobalKey<FormState>();
  // String ?selectedLanguage;

  bool terms = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const CustomAppBar(title: AppString.signUp, leading: null,showLeading: true,leadingIconColor: Colors.white,),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            width: context.width,
            height: context.height,
            margin: EdgeInsets.zero,
            decoration: null,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: context.height,
                width: context.width,
                decoration:  BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(Dimensions.BORDER_RADIUS),topRight: Radius.circular(Dimensions.BORDER_RADIUS)),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                padding: const EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 15),
                child: GetBuilder<AuthController>(builder: (authController) {
                  return DelayedDisplay(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // physics: const BouncingScrollPhysics(),
                        // shrinkWrap: true,
                        children: [

                         

                         
                           
                           
                    
                          /// Full Name Field
                          CustomInputTextField(
                            controller: _nameController,
                            focusNode: _nameFocus,
                            isPassword: false,
                            context: context,
                             onValueChange: (_){
                            setState(() {
                              
                            });
                          },
                            hintText: AppString.fullName,
                            validator: (inputData) {
                              return inputData!.isEmpty
                                  ? ErrorMessage.nameEmptyError
                                  : inputData.length>250
                                  ? ErrorMessage.nameMaxLengthError
                                  : null;
                            },
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          /// Mobile Number Field
                          CustomInputTextField(
                            controller: _mobileNumberController,
                            focusNode: _mobileNumberFocus,
                            maxTextLength: 15,
                            isPassword: false,
                            context: context,
                             onValueChange: (_){
                            setState(() {
                              
                            });
                          },
                            keyboardType: getKeyboardTypeForDigitsOnly(),
                            hintText: AppString.phoneNoTextField,
                            // validator: (inputData) {
                            //   return inputData!.isEmpty
                            //       ? ErrorMessage.mobileNumberEmptyError
                            //       : inputData.length>250
                            //       ? ErrorMessage.mobileNumberInvalidError
                            //       : null;
                            // },
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          /// Email (Optional) Field
                          CustomInputTextField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            isPassword: false,
                             onValueChange: (_){
                            setState(() {
                              
                            });
                          },
                            context: context,
                            hintText: AppString.email,
                            validator: (inputData) {
                              return inputData!.isEmpty
                                  ? ErrorMessage.emailEmptyError
                                  : inputData.length>250
                                  ? ErrorMessage.emailMaxLengthError
                                  : null;
                            },
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          /// Gender Selection
                            Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Text(AppString.gender.tr,
                                style: ralewayMedium.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ),
                                const SizedBox(height: 8,),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                            decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS)
                            ),
                            child: Column(
                              children: [
                              
                                Row(
                                  children: [
                                    GenderWidget(
                                      title: AppString.male,
                                      onPressed: (){
                                        setState((){
                                          userGender = Gender.Male;
                                        });
                                      },
                                      isSelected: userGender == Gender.Male,
                                    ),
                                    const SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                                    GenderWidget(
                                      title: AppString.female,
                                      onPressed: (){
                                        setState((){
                                          userGender = Gender.Female;
                                        });
                                      },
                                      isSelected: userGender == Gender.Female,
                                    ),
                                    const SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                                    GenderWidget(
                                      title: AppString.other,
                                      onPressed: (){
                                        setState((){
                                          userGender = Gender.Other;
                                        });
                                      },
                                      isSelected: userGender == Gender.Other,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          /// Language Selection
                          // CustomSingleSelectField<String>(
                          //   items: const [
                          //     'German',
                          //     'English',
                          //     'Urdu'
                          //   ],
                          //
                          //   title: "Language",
                          //   textStyle: ralewayMedium,
                          //   onSelectionDone: (value){
                          //     selectedLanguage = value;
                          //     setState(() {});
                          //   },
                          //   decoration: inputFieldDecoration(hintText: "Language", context: context),
                          //   selectedItemColor: Theme.of(context).primaryColor,
                          //   itemAsString: (item)=>item,
                          // ),
                          // const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          /// Password Field
                          CustomInputTextField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            isPassword: true,
                            context: context,
                             onValueChange: (_){
                            setState(() {
                              
                            });
                          },
                            obscureText: hidePassword,
                            hintText: AppString.password,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              icon: hidePassword
                                  ? const Icon(Icons.visibility_off,)
                                  : const Icon(Icons.visibility,),
                            ),
                            maxLines: 1,
                            validator: (inputData) {
                              return inputData!.isEmpty
                                  ? ErrorMessage.passwordEmptyError
                                  : inputData.length<AppConstants.PASSWORD_MIN_LENGTH
                                  ?  ErrorMessage.passwordMinLengthError
                                  : inputData.length>250
                                  ? ErrorMessage.passwordMaxLengthError
                                  : null;
                            },
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          /// Confirm Password Field
                          CustomInputTextField(
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            isPassword: true,
                            context: context,
                             onValueChange: (_){
                            setState(() {
                              
                            });
                          },
                            maxLines: 1,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideConfirmPassword = !hideConfirmPassword;
                                });
                              },
                              icon: hideConfirmPassword
                                  ? const Icon(Icons.visibility_off,)
                                  : const Icon(Icons.visibility,),
                            ),
                            obscureText: hideConfirmPassword,
                            hintText: AppString.confirmPassword,
                            validator: (inputData) {
                              return inputData!.isEmpty
                                  ? ErrorMessage.passwordEmptyError
                                  : inputData.length<AppConstants.PASSWORD_MIN_LENGTH
                                  ?  ErrorMessage.passwordMinLengthError
                                  : inputData.length>250
                                  ? ErrorMessage.passwordMaxLengthError
                                  : null;
                            },
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                        
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                               GestureDetector(
                                 onTap: (){
                                   setState(() {
                                     terms = !terms;
                                   });
                                 },
                                 child: Container(
                                             height: 25,
                                             width: 25,
                                             decoration: BoxDecoration(
                                               border: Border.all(
                                                 color: Theme.of(context).primaryColor,
                                               ),
                                               borderRadius: BorderRadius.circular(5),
                                               color: terms? Theme.of(context).primaryColor:Colors.white,
                                             ),
                                             child:  Center(
                                               child: Icon(
                                                    Icons.done_outlined,
                                                    size: 20,
                                                 color:  Colors.white
                                               ),
                                               
                                             ),
                                           ),
                               ),
                                  SizedBox(width:10),
                                  RichText(
                                          text: TextSpan(
                      style: ralewayRegular.copyWith(
                        fontSize: 14,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Ich akzeptiere das",
                          style:  ralewayRegular.copyWith(
                            fontSize: 14,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                        TextSpan(
                            text: ' Geschäftsbedingungen',
                            style:  ralewayRegular.copyWith(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(RouteHelper.getPrivacyPolicyRoute());
                              }),
                      ])),
                    
                              ],
                            ),
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          
                          Padding(
                                                       padding: const EdgeInsets.symmetric(horizontal: 10),
                    
                            child: CustomButton(
                              
                              height: 50,
                              fontSize: 16,
                              
                              color: _nameController.text.isNotEmpty &&
                              // _mobileNumberController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty &&
                              terms ? null : Colors.grey.withOpacity(0.2)
                              ,
                              buttonText: AppString.signUp.tr,
                              onPressed: (){
                                if (  _formKey.currentState!.validate() && terms) {
                                  _register(authController);
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                         
                         
                        ],
                      ),
                    ),
                  );
                })
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppString.alreadyHaveAccount,
            style: ralewayRegular,
          ),
          TextButton(
            
            onPressed: (){
              Get.offAllNamed(RouteHelper.getSignInRoute());
            },
            child: Text(
              AppString.signIn,
               style: ralewayBold.copyWith(color: light().primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _register(AuthController authController) {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword=_confirmPasswordController.text.trim();
    String phoneNumber = _mobileNumberController.text.trim();
    if (password != confirmPassword) {
      showCustomSnackBar(ErrorMessage.confirmPasswordError.tr);
    } else {
      authController.signUp(name: name,email: email,password: password,phoneNumber:phoneNumber,gender: userGender.name);
    }
  }
}
