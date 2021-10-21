import 'package:bulovva/Components/gradient_button.dart';
import 'package:bulovva/Components/progress.dart';
import 'package:bulovva/Login/login.dart';
import 'package:bulovva/services/authentication_service.dart';
import 'package:bulovva/services/toast_service.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Sign extends StatefulWidget {
  Sign({Key key}) : super(key: key);

  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordVerifyController =
      TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isVisible = false;

  void signUp() {
    if (passwordController.text != passwordVerifyController.text) {
      ToastService().showError(
          'Girdiğiniz şifreler eşleşmemektedir ! Lütfen girdiğiniz şifreleri tekrar kontrol ediniz.',
          context);
      return;
    }
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      context
          .read<AuthService>()
          .signUp(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
            CoolAlert.show(
                context: context,
                type: CoolAlertType.warning,
                title: '',
                text: value,
                showCancelBtn: false,
                backgroundColor: Theme.of(context).colorScheme.primary,
                confirmBtnColor: Theme.of(context).colorScheme.primary,
                onConfirmBtnTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                barrierDismissible: false,
                confirmBtnText: 'Evet');
          })
          .onError(
              (error, stackTrace) => ToastService().showError(error, context))
          .whenComplete(() => setState(() {
                isLoading = false;
              }));
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  String validateMail(value) {
    if (value.isEmpty) {
      return "* E-mail zorunludur !";
    } else {
      return null;
    }
  }

  String validatePass(value) {
    if (value.isEmpty) {
      return "* Şifre zorunludur !";
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading != true)
        ? Scaffold(
            body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontSize: 70.0,
                                    color: Colors.white,
                                    fontFamily: 'Armatic',
                                    fontWeight: FontWeight.bold),
                                children: [
                              TextSpan(
                                  text: 'Pa',
                                  style: TextStyle(color: Colors.red)),
                              TextSpan(
                                  text: 'Pa',
                                  style: TextStyle(color: Colors.amber[600])),
                              TextSpan(
                                  text: 'Pe',
                                  style: TextStyle(color: Colors.green[300]))
                            ]))),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 30.0, left: 30.0, bottom: 20.0, top: 30.0),
                        child: Column(
                          children: [
                            TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.account_circle_outlined),
                                    labelText: 'E-Posta'),
                                validator: validateMail),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                obscureText:
                                    (isVisible == false) ? true : false,
                                controller: passwordController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.vpn_key_outlined),
                                    labelText: 'Yeni Parola',
                                    suffixIcon: IconButton(
                                      icon: (isVisible == false)
                                          ? Icon(Icons.visibility_off)
                                          : Icon(Icons.visibility),
                                      onPressed: () {
                                        if (isVisible == true) {
                                          setState(() {
                                            isVisible = false;
                                          });
                                        } else {
                                          setState(() {
                                            isVisible = true;
                                          });
                                        }
                                      },
                                    )),
                                validator: validatePass,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: TextFormField(
                                obscureText:
                                    (isVisible == false) ? true : false,
                                controller: passwordVerifyController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.vpn_key_outlined),
                                    labelText: 'Yeni Parola (Tekrar)',
                                    suffixIcon: IconButton(
                                      icon: (isVisible == false)
                                          ? Icon(Icons.visibility_off)
                                          : Icon(Icons.visibility),
                                      onPressed: () {
                                        if (isVisible == true) {
                                          setState(() {
                                            isVisible = false;
                                          });
                                        } else {
                                          setState(() {
                                            isVisible = true;
                                          });
                                        }
                                      },
                                    )),
                                validator: validatePass,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: GradientButton(
                                  buttonText: 'Kayıt Ol',
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  startColor:
                                      Theme.of(context).colorScheme.primary,
                                  finishColor:
                                      Theme.of(context).colorScheme.primary,
                                  fontColor: Colors.white,
                                  iconColor: Colors.white,
                                  onPressed: signUp,
                                  icon: FontAwesomeIcons.save,
                                  widthMultiplier: 0.9,
                                )),
                            Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: GradientButton(
                                  buttonText: 'Geri',
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  startColor: Colors.amber[800],
                                  finishColor: Colors.amber[800],
                                  fontColor: Colors.white,
                                  iconColor: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Login()));
                                  },
                                  icon: FontAwesomeIcons.arrowLeft,
                                  widthMultiplier: 0.9,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ))
        : ProgressWidget();
  }
}
