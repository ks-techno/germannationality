import 'package:German123/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:German123/util/styles.dart';

import '../../util/color_constants.dart';

AppBar myCustomAppBar(
    final String? title,
    final Widget? leading,
    final bool showLeading,
    final Color leadingIconColor,
    final List<Widget> trailing,
    final Function? onBack) {
  return AppBar(
      toolbarHeight: 80,
      elevation: 8,
      backgroundColor: Colors.white,
      centerTitle: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16))),
      // backgroundColor: Colors.yellow,
      leading: !showLeading
          ? const SizedBox()
          : Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.white,
                // border: Border.all(
                //     color: leading != null ? Colors.white : leadingIconColor),
              ),
              margin: const EdgeInsets.only(left: 10),
              child: leading ??
                  InkWell(
                      radius: 100,
                      borderRadius: BorderRadius.circular(100),
                      onTap: () {
                        if (onBack != null) {
                          onBack!();
                        } else {
                          Get.back();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ))),
      title: title != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    title!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: ralewayMedium.copyWith(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            )
          : const SizedBox(),
      actions: trailing

      // ListTile(
      //   dense: false,
      //   leading: !showLeading
      //       ? const SizedBox()
      //       : Container(
      //           decoration: BoxDecoration(
      //             shape: BoxShape.circle,
      //             color: leadingIconColor == Colors.white ? Colors.black26 : null,
      //             border: Border.all(
      //                 color: leading != null ? Colors.white : leadingIconColor),
      //           ),
      //           margin: const EdgeInsets.only(left: 10),
      //           child: leading ??
      //               InkWell(
      //                   radius: 100,
      //                   borderRadius: BorderRadius.circular(100),
      //                   onTap: () {
      //                     if (onBack != null) {
      //                       onBack!();
      //                     } else {
      //                       Get.back();
      //                     }
      //                   },
      //                   child: Padding(
      //                     padding: const EdgeInsets.all(2.0),
      //                     child: Icon(
      //                       Icons.arrow_back,
      //                       color: leadingIconColor,
      //                     ),
      //                   ))),
      //   contentPadding: const EdgeInsets.all(0),
      //   title: title != null
      //       ? Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Flexible(
      //               child: Text(
      //                 title!,
      //                 textAlign: TextAlign.center,
      //                 style: ralewayMedium.copyWith(
      //                   fontSize: 22,
      //                   fontWeight: FontWeight.w700,
      //                 ),
      //               ),
      //             ),
      //           ],
      //         )
      //       : const SizedBox(),
      //   trailing: trailing.isEmpty
      //       ? const SizedBox(
      //           width: 45,
      //         )
      //       : Wrap(
      //           alignment: WrapAlignment.end,
      //           children: trailing,
      //         ),
      // ),
      );
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final bool showLeading;
  final Color leadingIconColor;
  final List<Widget> trailing;
  final Function? onBack;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.leading,
    this.onBack,
    List<Widget>? trailing,
    this.showLeading = true,
    this.leadingIconColor = Colors.grey,
  })  : trailing = trailing ?? const <Widget>[],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: PreferredSize(
        preferredSize: Size(deviceSize.width, deviceSize.height * 0.05),
        child: ListTile(
          dense: false,
          leading: !showLeading
              ? const SizedBox()
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // color: leadingIconColor == Colors.white
                    //     ? Colors.black26
                    //     : null,
                    // border: Border.all(
                    //     color:
                    //         leading != null ? Colors.white : leadingIconColor),
                  ),
                  margin: const EdgeInsets.only(left: 10),
                  child: leading ??
                      InkWell(
                          radius: 100,
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            if (onBack != null) {
                              onBack!();
                            } else {
                              Get.back();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                          ))),
          contentPadding: const EdgeInsets.all(0),
          title: title != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: ralewayMedium.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          trailing: trailing.isEmpty
              ? const SizedBox(
                  width: 45,
                )
              : Wrap(
                  alignment: WrapAlignment.end,
                  children: trailing,
                ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, GetPlatform.isDesktop ? 70 : 50);
}
