import 'dart:math';
import 'package:bulovva/Constants/colors_constants.dart';
import 'package:bulovva/Models/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;

  const ProductCard({Key key, this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isBack = false;
  double angle = 0;

  void _flip() {
    setState(() {
      angle = (angle + pi) % (2 * pi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: angle),
          duration: const Duration(milliseconds: 400),
          builder: (BuildContext context, double val, __) {
            if (val >= (pi / 2)) {
              isBack = true;
            } else {
              isBack = false;
            }
            return (Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(val),
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  clipBehavior: Clip.antiAlias,
                  width: 300,
                  decoration: BoxDecoration(
                      color: ColorConstants.instance.thirdColor,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: (isBack == false)
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.center,
                            children: [
                              (widget.product != null &&
                                      widget.product.productPicRef != null)
                                  ? ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.4),
                                          BlendMode.multiply),
                                      child: Image.network(
                                        widget.product.productPicRef,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      color: ColorConstants.instance.thirdColor,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                    ),
                              Center(
                                  child: Text(
                                widget.product.productName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorConstants.instance.textOnColor,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                    shadows: const <Shadow>[
                                      Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 2.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ],
                                    fontSize: 25.0),
                              ))
                            ],
                          ),
                        )
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(pi),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.product.productName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ColorConstants
                                              .instance.waitingColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        widget.product.productDesc,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: ColorConstants
                                                .instance.textOnColor,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        'TRY ${widget.product.productPrice.toDouble().toString()}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ColorConstants
                                                .instance.waitingColor,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
            ));
          }),
    );
  }
}
