import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/counter.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('会员中心'),
      ),
      body: Center(
        child: Provide<Counter>(
            builder: (context,child,counter){
              return Text(
                '${counter.value}',
                style: Theme.of(context).textTheme.display1,
              );
            }
        ),
      ),
    );
  }
}
