import 'package:flutter/material.dart';
import '../train_test/train_test_widget.dart';
import '../helper/triple.dart';
import '../constants/strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // <title, desc, image>
  final List<Triple> _items = StringAssets.homeScreenTests;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            StringAssets.appName,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueGrey,
        ),
        backgroundColor: Colors.black45,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [

              // items
              ...List.generate(_items.length, (index) {
                return _buildListTile(context, _items[index]);
              }),

              // new games soon text
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 4),
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                title: Text(
                  StringAssets.addedSoonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // list tile
  Widget _buildListTile(BuildContext context, Triple item) {

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        onTap: () {
          switch (item.first) {
            case StringAssets.crtTitle:
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return TrainTestApp();
              }));
              break;
          }
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.white),
        ),
        title: Text(
          item.first,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 12,
          ),
          child: Text(
            item.second,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        trailing: Image.asset(item.third),
      ),
    );
  }
}
