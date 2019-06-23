import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/service_url.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  int page = 1;
  List<Map> hotGoodsList = [] ;

  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  @override
  bool get wantKeepAlive => true;

//  @override
//  void initState(){
//    super.initState();
//    _getHotGoods();
//  }


  String homePageContent = '正在获取数据';

  @override
  Widget build(BuildContext context) {
    var formData = {'lon':'115.02932','lat':'35.76189'};
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+'),),
      body: FutureBuilder(
        future: request(servicePath['homePageContent'], formData: formData),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString());
            List<Map> swiper = (data['data']['slides'] as List).cast();
            List<Map> categoryList = (data['data']['category'] as List).cast();
            String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];
            List<Map> recommend = (data['data']['recommend'] as List).cast();
            String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
            String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
            String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];
            List<Map> floor1 = (data['data']['floor1'] as List).cast();
            List<Map> floor2 = (data['data']['floor2'] as List).cast();
            List<Map> floor3 = (data['data']['floor3'] as List).cast();

            return EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                bgColor: Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                showMore: true,
                noMoreText: '',
                moreInfo: '加载中...',
                loadReadyText: '上拉加载...',
              ),

              child: ListView(
                children: <Widget>[
                  SwiperCustom(swiperDateList: swiper),
                  TopNavigator(navigatorList: categoryList),
                  AdBanner(adPicture: adPicture),
                  LeaderPhone(leaderImage: leaderImage,leaderPhone: leaderPhone),
                  Recommend(recommendList: recommend),
                  FloorTitle(picture_address: floor1Title),
                  FloorContent(floorGoodsList: floor1),
                  FloorTitle(picture_address: floor2Title),
                  FloorContent(floorGoodsList: floor2),
                  FloorTitle(picture_address: floor3Title),
                  FloorContent(floorGoodsList: floor3),
                  _hotGoods()
//                  HotGoods()
                ],
              ),

              loadMore: () async {
                print('开始加载更多....');
                var formData = {'page':page};
                await request(servicePath['homePageBelowConten'],formData: formData).then((val){
                  var data = json.decode(val.toString());
                  List<Map> newGoodsList = (data['data'] as List).cast();
                  setState(() {
                    hotGoodsList.addAll(newGoodsList);
                    page++;
                  });
                });
              },

            );
          }else{
            return Center(
              child: Text('加载中...'),
            );
          }
        },
      )
    );
  }

//  void _getHotGoods(){
//    var formData = {'page':page};
//    request(servicePath['homePageBelowConten'],formData: formData).then((val){
//      var data = json.decode(val.toString());
//      List<Map> newGoodsList = (data['data'] as List).cast();
//      setState(() {
//        hotGoodsList.addAll(newGoodsList);
//        page++;
//      });
//    });
//  }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    alignment: Alignment.center,
    color: Colors.transparent,
    child: Text('火爆专区'),
    padding: EdgeInsets.all(5.0),
  );

  Widget _wrapList(){
    if(hotGoodsList.length != 0){
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){},
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'],width: ScreenUtil().setWidth(370),),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}',),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(
                        color: Colors.black26,
                        decoration: TextDecoration.lineThrough
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget
      );
    }else{
      return Text('');
    }
  }

  Widget _hotGoods(){
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      ),
    );
  }
}

/// 首页轮播组件
class SwiperCustom extends StatelessWidget {
  final List swiperDateList;
  SwiperCustom({this.swiperDateList});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index){
          return Image.network('${swiperDateList[index]['image']}',fit: BoxFit.fill,);
        },
        itemCount:swiperDateList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

/// 8个中部导航位
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key,this.navigatorList}):super(key:key);

  Widget _gridViewItemUI(BuildContext context,item){
    return InkWell(
      onTap: (){print('点击了导航');},
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width: ScreenUtil().setWidth(80),),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(this.navigatorList.length > 10){
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(350),
      padding: EdgeInsets.all(5.0),
      child:GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          padding: EdgeInsets.all(5.0),
          children: navigatorList.map((item){
            return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

/// 广告位导航
class AdBanner extends StatelessWidget {

  final String adPicture;
  AdBanner({Key key, this.adPicture}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

/// 店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage; // 店长图片
  final String leaderPhone; // 店长电话
  LeaderPhone({Key key, this.leaderImage,this.leaderPhone}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launcherURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launcherURL() async{
    String url = 'tel:'+leaderPhone;
    print('url------------'+url);
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'url不能进行访问异常';
    }
  }
}

/// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList}):super(key: key);
  // 标题
  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black12,width: 0.5)
        )
      ),

      child: Text('商品推荐',style: TextStyle(color: Colors.pink),),
    );
  }

  // 商品单独项
  Widget _itemWidget(index){
    return InkWell(
      onTap: (){},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            right: BorderSide(color: Colors.black12,width: 0.5)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(
              recommendList[index]['image'],
              width: ScreenUtil().setWidth(250),
              height: ScreenUtil().setHeight(226),
            ),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 横向列表方法
  Widget _recommendList(){
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context,index){
          return _itemWidget(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList()
        ],
      ),
    );
  }
}

/// 楼层标题
class FloorTitle extends StatelessWidget {
  final String picture_address;
  FloorTitle({Key key, this.picture_address}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

/// 楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  FloorContent({Key key, this.floorGoodsList}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods()
        ],
      ),
    );
  }

  Widget _firstRow(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods){
    return Container(
      width: ScreenUtil().setWidth(375.0),
      child: InkWell(
        onTap: (){print('点击了楼层商品');},
        child: Image.network(goods['image']),
      ),
    );
  }

}


//class HotGoods extends StatefulWidget {
//  @override
//  _HotGoodsState createState() => _HotGoodsState();
//}
//
//class _HotGoodsState extends State<HotGoods> {
//
//  @override
//  void initState() {
//    super.initState();
//    int page = 1;
//    request(servicePath['homePageBelowConten'], formData: page).then((val){
//      print("getHomePageBelowContent ====================> "+val);
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Text('2222222222'),
//    );
//  }
//}








