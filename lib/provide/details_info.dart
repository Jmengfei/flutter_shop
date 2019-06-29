import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../config/service_url.dart';


class DetailsInfoProvide with ChangeNotifier{
    DetailsModel goodsInfo = null;

    bool isLeft = true;
    bool isRight = false;

    // 从后台获取商品数据
    getGoodsInfo(String id){
      var formData = {'goodId':id};
      request(servicePath['getGoodDetailById'],formData: formData).then((val){
        var responseData = json.decode(val.toString());
        print(responseData);
        goodsInfo = DetailsModel.fromJson(responseData);
        notifyListeners();
      });
    }

    changeLeftAndRight(String changeState){
      if(changeState == 'left'){
        isLeft = true;
        isRight = false;
      }else{
        isLeft = false;
        isRight = true;
      }
      notifyListeners();
    }
}