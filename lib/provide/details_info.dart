import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../config/service_url.dart';


class DetailsInfoProvide with ChangeNotifier{
    DetailsModel goodsInfo = null;

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
}