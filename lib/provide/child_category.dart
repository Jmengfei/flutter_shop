import 'package:flutter/material.dart';
import '../model/category.dart';


class ChildCategory with ChangeNotifier{
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; // 子类高亮索引
  String categoryId = '4'; // 大类的id
  String subId = ''; // 子类的id
  int page = 1; // 列表页数
  String noMoreText = ''; // 显示没有数据的文字


  // 大类切换逻辑
  getChildCategory(List<BxMallSubDto> list,String id){

    // 每次点击大类需要归零
    childIndex = 0;
    categoryId = id;
    page = 1;
    noMoreText = '';

    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '00';
    all.comments = 'null';
    all.mallSubName = '全部';

    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  // 改变子类索引
  changeChildIndex(index,String subId){
    childIndex = index;
    this.subId = subId;
    page = 1;
    noMoreText = '';
    notifyListeners();
  }

  // 增加page的方法
  addPage(){
    page++;
  }

  changeNoMoreText(String text){
    noMoreText = text;
    notifyListeners();
  }
}