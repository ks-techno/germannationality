import 'dart:io';

import 'package:German123/controller/auth_controller.dart';
import 'package:German123/view/base/custom_dialog_box.dart';
import 'package:German123/view/screens/auth/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:German123/helper/route_helper.dart';
import 'package:German123/util/app_strings.dart';
import 'package:German123/util/dimensions.dart';
import 'package:German123/util/styles.dart';
import 'package:German123/view/screens/home/main_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../util/images.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    zoomDrawerController.toggle?.call();
                  },
                  child: Container(
                    height: 56,
                    width: 56,
                    child: Icon(
                      Icons.clear,
                      size: 32,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ))
            ],
          ),
          const SizedBox(
            height: Dimensions.PADDING_SIZE_LARGE,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: Image.asset( Images.splashLogo, width: 155),
          ),
          // const SizedBox(
          //   height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
          // ),

           /// My Profile
          if(Get.find<AuthController>().getLoginUserData() != null )  DrawerItem(
            title: "Profil",
            onPressed: () {

              Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen()));
              
            },
            leadingImage: Images.profile_black,
          ),
  Divider(),
          /// Language Selection
          DrawerItem(
            title: AppString.selectLanguage,
            onPressed: () {
              Get.toNamed(RouteHelper.getSelectLanguageRoute());
            },
            leadingImage: Images.language1,
            leadingImageColor: Colors.black,
          ),
          Divider(),

          /// Privacy Policy
          DrawerItem(
            title: AppString.privacyPolicy,
            onPressed: () {
              Get.toNamed(RouteHelper.getPrivacyPolicyRoute());
            },
            leadingImage: Images.privacy,
            leadingImageColor: Colors.black,
          ),
          Divider(),

          /// Change password
         if(Get.find<AuthController>().getLoginUserData() != null)  DrawerItem(
            title: AppString.changePassword,
            onPressed: () {
              Get.toNamed(RouteHelper.getChangePasswordRoute(
                  isChangePassword: true, email: ''));
            },
            leadingImage: Images.lock,
            leadingImageColor: Colors.black,
          ),
          if(Get.find<AuthController>().getLoginUserData() != null)  Divider(),

          DrawerItem(
            title: AppString.shareApp,
            onPressed: () async {
              zoomDrawerController.toggle?.call();
              var link = Platform.isIOS
                  ? 'https://apps.apple.com/us/app/german-nationality/id6445913895' 
                  : 'https://play.google.com/store/apps/details?id=de.germannationality';
              await FlutterShare.share(
                title: 'Bitte teilen Sie die GermanNationality App mit Ihren Freunden',
                text: 'Bitte teilen Sie die GermanNationality App mit Ihren Freunden',
                linkUrl: link,
              );

              // final box = context.findRenderObject() as RenderBox?;

              // Share.share(link,
              //     sharePositionOrigin:
              //         box!.localToGlobal(Offset.zero) & box.size);
            },
            leadingImage: Images.share,
            leadingImageColor: Colors.black,
          ),
          Divider(),

          if(Get.find<AuthController>().getLoginUserData() != null)  DrawerItem(
            title: AppString.logout,
            onPressed: () async {
              bool isConfirmed = await showCustomDialog(
                context: context,
                descriptions: AppString.logoutMessage,
                title: AppString.logout,
              );
              if (isConfirmed) {
                Get.find<AuthController>().logout('');
              }
            },
            leadingImage: Images.logout,
            leadingImageColor: Colors.black,
          ),
         if(Get.find<AuthController>().getLoginUserData() != null)   Divider(),

          SizedBox(
            height: 30,
          ),

          /// Delete Account
         if(Get.find<AuthController>().getLoginUserData() != null)   DrawerItem(
              title: AppString.deleteAccount,
              onPressed: () async {
                bool isConfirmed = await showCustomDialog(
                  context: context,
                  descriptions: AppString.deleteAccountMessage,
                  title: AppString.deleteAccount,
                );
                if (isConfirmed) {
                  // Get.find<AuthController>().logout('');
                  Get.find<AuthController>().deleteAccount();
                }
              },
              leadingImage: Images.delete,
              leadingImageColor: Colors.red),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final String leadingImage;
  final Color? leadingImageColor;
  final void Function() onPressed;
  const DrawerItem(
      {Key? key,
      required this.title,
      required this.onPressed,
      required this.leadingImage,
      this.leadingImageColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      // color: Colors.red,
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                leadingImage,
               
                width: 18,
                height: 18,
                color: leadingImageColor,
              ),
              const SizedBox(
                width: Dimensions.PADDING_SIZE_SMALL,
              ),
              Expanded(
                child: Text(
                  title,
                  style: ralewayRegular.copyWith(
                      fontSize: 16,
                      color:
                          title == 'Konto löschen' ? Colors.red : Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
