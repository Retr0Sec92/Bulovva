import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Components/title.dart';
import 'package:bulovva/Models/store_model.dart';
import 'package:bulovva/Models/wishes_model.dart';
import 'package:bulovva/services/authentication_service.dart';
import 'package:bulovva/services/firestore_service.dart';
import 'package:bulovva/services/toast_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Wish extends StatefulWidget {
  final StoreModel store;

  Wish({Key key, this.store}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Wish> {
  final TextEditingController _reportTitle = TextEditingController();
  final TextEditingController _reportDesc = TextEditingController();
  final TextEditingController _reportPhone = TextEditingController();
  GlobalKey<FormState> formKeyComment = GlobalKey<FormState>();
  bool _isLoading = false;

  String _validateComTitle(String value) {
    if (value.isEmpty) {
      return '* Dilek & Şikayet başlığı boş olmamalıdır !';
    }
    if (value.contains(RegExp(r'[a-zA-ZğüşöçİĞÜŞÖÇ]')) != true) {
      return '* Harf içermelidir !';
    }

    return null;
  }

  String _validateComDesc(String value) {
    if (value.isEmpty) {
      return '* Dilek & Şikayet açıklaması boş olmamalıdır !';
    }

    if (value.contains(RegExp(r'[a-zA-ZğüşöçİĞÜŞÖÇ]')) != true) {
      return '* Harf içermelidir !';
    }

    return null;
  }

  String _validatePhone(String value) {
    if (value.contains(RegExp(r'[^\d]')) == true) {
      return '* Sadece rakam içermelidir !';
    }

    return null;
  }

  saveComment() {
    if (formKeyComment.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      WishesModel newComment = WishesModel(
          wishId: Uuid().v4(),
          wishTitle: _reportTitle.text,
          wishDesc: _reportDesc.text,
          wishStore: widget.store.storeId,
          wishStoreName: widget.store.storeName,
          wishUserPhone: _reportPhone.text,
          wishUser: AuthService(FirebaseAuth.instance).getUserId(),
          createdAt: Timestamp.now());

      FirestoreService()
          .saveWish(newComment)
          .then((value) => ToastService().showSuccess(value, context))
          .onError(
              (error, stackTrace) => ToastService().showError(error, context))
          .whenComplete(() => setState(() {
                _isLoading = false;
              }));
      setState(() {
        _reportTitle.text = '';
        _reportDesc.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading != true)
        ? Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(elevation: 0, centerTitle: true, title: TitleApp()),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).primaryColor
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0))),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Form(
                          key: formKeyComment,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Text(
                                    " * Dilek & Şikayet başlığı kısaca konunun ne olduğunu anlatmanız içindir.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.amber[900],
                                        fontFamily: 'Roboto',
                                        fontSize: 16.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    controller: _reportTitle,
                                    maxLength: 50,
                                    validator: _validateComTitle,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        labelText: 'Dilek & Şikayet Başlığı',
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Text(
                                    " * Dilek & Şikayet açıklamasını elinizden geldiği kadar açık ve net yazmanız işletme için çok önemlidir.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.amber[900],
                                        fontFamily: 'Roboto',
                                        fontSize: 16.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    validator: _validateComDesc,
                                    controller: _reportDesc,
                                    keyboardType: TextInputType.text,
                                    maxLength: 255,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                        labelText: 'Dilek & Şikayet Açıklaması',
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Text(
                                    " * İletişim numarası doldurması zorunlu bir alan değildir. İşletmenin sizinle iletişime geçmesini istiyorsanız doldurabilirsiniz.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.amber[900],
                                        fontFamily: 'Roboto',
                                        fontSize: 16.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: TextFormField(
                                    validator: _validatePhone,
                                    controller: _reportPhone,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                        prefix: Text('+90'),
                                        labelText: 'İletişin Numarası',
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 60.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        gradient: LinearGradient(
                                            colors: [
                                              Theme.of(context).primaryColor,
                                              Theme.of(context).primaryColor
                                            ],
                                            begin: Alignment.centerRight,
                                            end: Alignment.centerLeft)),
                                    child: TextButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: Icon(
                                                Icons.save,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                                "Dilek & Şikayet Oluştur"
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white,
                                                    fontFamily: 'Bebas')),
                                          ],
                                        ),
                                        onPressed: () {
                                          saveComment();
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ))
        : ProgressWidget();
  }
}
