import 'package:bulb/Campaigns/campaigns.dart';
import 'package:bulb/Components/favorite_button.dart';
import 'package:bulb/Wishes/wishes.dart';
import 'package:bulb/Models/store_model.dart';
import 'package:bulb/Products/products.dart';
import 'package:bulb/Reservations/reservations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Store extends StatefulWidget {
  final StoreModel storeData;
  final String docId;

  Store({Key key, this.storeData, this.docId}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController commentTitle = TextEditingController();
  final TextEditingController commentDesc = TextEditingController();
  double rating;
  bool isLoading = false;

  String formatDate(Timestamp date) {
    var _date = DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch)
        .toLocal();
    return dateFormat.format(_date);
  }

  makePhoneCall() async {
    await launch("tel:${widget.storeData.storePhone}");
  }

  findPlace() async {
    String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=${widget.storeData.storeLocLat},${widget.storeData.storeLocLong}";
    await launch(googleMapslocationUrl);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actions: [
            FavoriteButton(
              storeId: widget.storeData.storeId,
            )
          ],
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: FaIcon(FontAwesomeIcons.tags, color: Colors.white)),
              Tab(icon: FaIcon(FontAwesomeIcons.bookOpen, color: Colors.white)),
              Tab(icon: FaIcon(FontAwesomeIcons.bullhorn, color: Colors.white)),
              Tab(icon: FaIcon(FontAwesomeIcons.bell, color: Colors.white)),
            ],
          ),
          centerTitle: true,
          title: Text('Bulb',
              style: TextStyle(
                  fontSize: 45.0,
                  fontFamily: 'Armatic',
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        body: (isLoading == false)
            ? Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor
                ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0))),
                    child: TabBarView(
                      children: [
                        Campaigns(
                          storeData: widget.storeData,
                        ),
                        Menu(
                          storeData: widget.storeData,
                        ),
                        Wishes(
                          storeData: widget.storeData,
                        ),
                        Reservations(
                          storeData: widget.storeData,
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
      ),
    );
  }
}
