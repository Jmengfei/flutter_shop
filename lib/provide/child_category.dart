import 'package:flutter/material.dart';
import '../model/category.dart';


class ChildCategory with ChangeNotifier{
  List<BxMallSubDto> childCategoryList = [];

  getChildCategory(List list){
    childCategoryList = list;
    notifyListeners();
  }

}