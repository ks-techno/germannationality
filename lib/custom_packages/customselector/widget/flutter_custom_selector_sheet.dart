import 'package:German123/util/styles.dart';
import 'package:flutter/material.dart';
import '../utils/enum.dart';
import '../utils/flutter_custom_select_item.dart';
import '../utils/utils.dart';
import 'flutter_custom_select_button.dart';

class CustomBottomSheetSelector<T> {
  Future<Map<String, List<T>?>> customBottomSheet({
    required BuildContext buildContext,
    required String headerName,
    required CustomDropdownButtonType buttonType,
    required List<CustomMultiSelectDropdownItem<T>> dropdownItems,
    required List<T> initialSelection,
    required Color selectedItemColor,
    final TextStyle? textStyle,
    bool isAllOptionEnable = false,
  }) async {
    List<T> selectionList = <T>[];
    bool selectionDone = false;
    bool isAllSelected = false;
    List<CustomMultiSelectDropdownItem<T>> searchedItems =
        <CustomMultiSelectDropdownItem<T>>[];

    for (T value in initialSelection) {
      selectionList.add(value);
    }

    for (int i = 0; i < dropdownItems.length; i++) {
      if (selectionList.contains(dropdownItems[i].buttonObjectValue)) {
        dropdownItems[i].selected = true;
      }
    }

    if (selectionList.length == dropdownItems.length) {
      isAllSelected = true;
    }

    await showModalBottomSheet(
        context: buildContext,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        builder: (BuildContext bc) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: StatefulBuilder(builder: (_, setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 47,
                          height: 4,
                          margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          // color: Colors.grey.shade200,
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            headerName,
                            style: ralewayMedium.copyWith(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(
                          thickness: 1,
                          height: 0,
                          color: Color(0xffe5e6e6),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          child: ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              isAllOptionEnable &&
                                      buttonType ==
                                          CustomDropdownButtonType.multiSelect
                                  ? CustomBottomSheetButton(
                                      trailing: Container(
                                        decoration: BoxDecoration(
                                          color: isAllSelected
                                              ? selectedItemColor
                                              : Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isAllSelected
                                                ? Colors.transparent
                                                : Colors.grey,
                                            width: 1.0,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 3),
                                        child: Icon(
                                          Icons.done,
                                          color: isAllSelected
                                              ? Colors.white
                                              : Colors.transparent,
                                          size: 20,
                                        ),
                                      ),
                                      onPressed: () {
                                        isAllSelected = !isAllSelected;
                                        selectionList.clear();
                                        for (CustomMultiSelectDropdownItem<
                                            T> value in dropdownItems) {
                                          value.selected = isAllSelected;
                                          if (isAllSelected) {
                                            selectionList
                                                .add(value.buttonObjectValue);
                                          }
                                        }
                                        setState(() {});
                                      },
                                      buttonTextStyle: textStyle?.copyWith(
                                            color: isAllSelected
                                                ? selectedItemColor
                                                : Colors.black,
                                          ) ??
                                          defaultTextStyle(
                                              color: isAllSelected
                                                  ? selectedItemColor
                                                  : Colors.black),
                                      buttonText: 'Alle',
                                    )
                                  : const SizedBox(),
                              isAllOptionEnable &&
                                      buttonType ==
                                          CustomDropdownButtonType.multiSelect
                                  ? Container(
                                      height: 1,
                                      width: double.infinity,
                                      color: Color(0xffe5e6e6),
                                    )
                                  : const SizedBox(),
                              Wrap(
                                children: [
                                  for (CustomMultiSelectDropdownItem<T> item
                                      in searchedItems.isNotEmpty
                                          ? searchedItems
                                          : dropdownItems)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomBottomSheetButton(
                                          leading: Container(width: 0),
                                          trailing: buttonType ==
                                                  CustomDropdownButtonType
                                                      .multiSelect
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    color: item.selected
                                                        ? selectedItemColor
                                                        : Colors.white,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: item.selected
                                                          ? Colors.transparent
                                                          : Colors.grey,
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 0,
                                                      vertical: 0),
                                                  child: Icon(
                                                    Icons.done,
                                                    color: item.selected
                                                        ? Colors.white
                                                        : Colors.transparent,
                                                    size: 20,
                                                  ),
                                                )
                                              : const SizedBox(),
                                          onPressed: () {
                                            if (buttonType ==
                                                CustomDropdownButtonType
                                                    .multiSelect) {
                                              item.selected = !item.selected;
                                              if (item.selected) {
                                                selectionList.add(
                                                    item.buttonObjectValue);
                                                if (selectionList.length ==
                                                    dropdownItems.length) {
                                                  isAllSelected = true;
                                                }
                                              } else {
                                                isAllSelected = false;
                                                selectionList.remove(
                                                    item.buttonObjectValue);
                                              }
                                              setState(() {});
                                            } else {
                                              selectionList.clear();
                                              selectionList
                                                  .add(item.buttonObjectValue);
                                              selectionDone = true;
                                              Navigator.pop(
                                                buildContext,
                                              );
                                            }
                                          },
                                          buttonTextStyle: textStyle?.copyWith(
                                                color: item.selected
                                                    ? selectedItemColor
                                                    : Colors.black,
                                              ) ??
                                              defaultTextStyle(
                                                  color: item.selected
                                                      ? selectedItemColor
                                                      : Colors.black),
                                          // buttonTextColor: Colors.black,
                                          buttonText: item.buttonText,
                                        ),
                                        Container(
                                          height: item != dropdownItems.last
                                              ? 1
                                              : 0,
                                          width: double.infinity,
                                          color: Color(0xffe5e6e6),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              buttonType == CustomDropdownButtonType.multiSelect
                                  ? Container(
                                      width: MediaQuery.of(bc).size.width - 50,
                                      height: 50,
                                      margin: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: MaterialButton(
                                        onPressed: () {
                                          selectionDone = true;
                                          Navigator.pop(
                                            buildContext,
                                          );
                                        },
                                        color: Colors.grey,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        minWidth:
                                            MediaQuery.of(bc).size.width - 50,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Center(
                                            child:
                                                Text("Getan", style: textStyle),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: MediaQuery.of(bc).size.width - 50,
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: MaterialButton(
                                        elevation: 0,
                                        onPressed: () {
                                          selectionDone = false;
                                          Navigator.pop(buildContext);
                                        },
                                        color: Color(0xfff4f4f4),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        minWidth:
                                            MediaQuery.of(bc).size.width - 50,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Center(
                                            child: Text(
                                              "Absagen",
                                              style: textStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          );
        });
    return {
      selectedList: selectionDone ? selectionList : null,
    };
  }
}
