import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context,child,val){
        var goodsInfo = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo;

        if(goodsInfo != null){
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _goodsImage(goodsInfo.image1),
                _goodsName(goodsInfo.goodsName),
                _goodsNum(goodsInfo.goodsSerialNumber),
                _goodsPrice(goodsInfo.presentPrice)
              ],
            ),
          );
        }else{
          return Text('正在加载中...');
        }
      },
    );
  }
  
  
  // 商品图片
  Widget _goodsImage(String url){
    return Image.network(
      url,
      width: ScreenUtil().setWidth(740),
      
    );
  }
  
  // 商品名称
  Widget _goodsName(name){
    return Container(
      width: ScreenUtil().setWidth(740),
      padding: EdgeInsets.only(left: 15.0),
      child: Text(
        name,
        style: TextStyle(fontSize: ScreenUtil().setSp(30.0),color: Colors.black),
      ),
    );
  }
  
  // 商品编号
  Widget _goodsNum(num){
    return Container(
      width: ScreenUtil().setWidth(740.0),
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top: 8.0),
      child: Text(
        '编号：${num}',
        style: TextStyle(color: Colors.black26),
      ),
    );
  }
  
  Widget _goodsPrice(double price){
    return Container(
      width: ScreenUtil().setWidth(740.0),
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            '￥',
            style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(20.0)),
          ),
          Text(
            price.toString(),
            style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(32.0)),
          )
        ],
      )
    );
  }

}
