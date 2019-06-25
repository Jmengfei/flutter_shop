import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../config/service_url.dart';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list.dart';
import 'package:provide/provide.dart';
import '../model/categoryGoodsList.dart';

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
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodsList(),
              ],
            )
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
  int listIndex = 0;

  @override
  void initState() {
    _getCategory();
    _getGoodsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
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
    bool isClick= false;
    isClick = (index == listIndex)? true : false;
    return InkWell(
      onTap: (){
        setState(() {
          listIndex = index;
        });

        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        Provide.value<ChildCategory>(context).getChildCategory(childList);
        
        _getGoodsList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10,top: 14),
        decoration: BoxDecoration(
          color: isClick?Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
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
      setState(() {
        list = listModel.data;
      });

      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto);
    });
  }

  void _getGoodsList({String categoryId}) async{
    var data = {
      'categoryId': categoryId == null?'4':categoryId,
      'CategorySubId': '',
      'page': 1
    };

    await request(servicePath['getMallGoods'],formData: data).then((val){
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);

      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);

    });
  }
  
}

/// 右侧上部导航
class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {

  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder:(context,child,childCategory){
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.black12,width: 1.0)
              )
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context,index){
              return _rightInkWell(childCategory.childCategoryList[index]);
            },
          ),
        );
      }
    );
  }

  Widget _rightInkWell(BxMallSubDto childCategoryList){
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          childCategoryList.mallSubName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }
}

/// 商品列表，有上拉加载信息
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
        builder: (context,child,data){
          return Container(
            width: ScreenUtil().setWidth(570.0),
            height: ScreenUtil().setHeight(980),
            child: ListView.builder(
                itemCount: data.goodsList.length,
                itemBuilder: (context,index){
                  return _listItemWidget(data.goodsList,index);
                }
            ),
          );
        }
    );
  }

  Widget _goodsImage(List newList, int index){
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList, int index){
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28.0)),
      ),
    );
  }

  Widget _goodsPrice(List newList, index){
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格：￥${newList[index].presentPrice}',
            style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(30.0)),
          ),
          Text(
             '￥${newList[index].oriPrice}',
             style: TextStyle(color: Colors.black26,decoration: TextDecoration.lineThrough),
          )
        ],
      )
    );
  }

  Widget _listItemWidget(List newList, int index){
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0,color: Colors.black12)
          )
        ),

        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index)
              ],
            )
          ],
        ),
      ),
    );
  }

}


