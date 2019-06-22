import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String homePageContent = '正在获取数据';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+'),),
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString());
            List<Map> swiper = (data['data']['slides'] as List).cast();
            List<Map> categoryList = (data['data']['category'] as List).cast();
            String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SwiperCustom(swiperDateList: swiper),
                  TopNavigator(navigatorList: categoryList),
                  AdBanner(adPicture: adPicture),
                  LeaderPhone(leaderImage: leaderImage,leaderPhone: leaderPhone,)
                ],
              )
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
/// 8个中部导航位制作
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
          crossAxisCount: 5,
          padding: EdgeInsets.all(5.0),
          children: navigatorList.map((item){
            return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

/// 广告位导航制作
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




