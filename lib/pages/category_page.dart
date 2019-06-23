import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../config/service_url.dart';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('商品分类'),),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Text('右侧分类')
          ],
        ),
      ),
    );
  }



}

/// 左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {

  List list = [];

  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(190),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1.0,color: Colors.black12)
        )
      ),
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context,index){
            return _leftInkWell(index);
          }
      ),
    );
  }

  Widget _leftInkWell(int index){
    return InkWell(
      onTap: (){},
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10,top: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0,color: Colors.black12)
          )
        ),

        child: Text(list[index].mallCategoryName,style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
      ),
    );
  }

  void _getCategory() async{
    await request(servicePath['getCategory']).then((val){
      var data = json.decode(val.toString());
      CategoryModel listModel = CategoryModel.fromJson(data);
      listModel.data.forEach((item)=> print(item.mallCategoryName));
      setState(() {
        list = listModel.data;
      });
    });
  }
}


