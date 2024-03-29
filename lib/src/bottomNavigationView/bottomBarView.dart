import 'package:dom_marino_app/src/models/tabIconData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:badges/badges.dart';

import 'package:flutter/widgets.dart';

class BottomBarView extends StatefulWidget {
  final Function(int index) changeIndex;
  final Function addClick;
  final List<TabIconData> tabIconsList;
  final dbHelper;
  final FirebaseUser user;

  const BottomBarView(
      {Key key, this.tabIconsList, this.changeIndex, this.addClick, this.dbHelper,this.user})
      : super(key: key);

  @override
  _BottomBarViewState createState() {
    return _BottomBarViewState(dbHelper, user);
  }
}

class _BottomBarViewState extends State<BottomBarView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  int cartId=0;
  int cartItemsSize=0;
  final thisDbHelper;
  final FirebaseUser thisUser;

  Future<dynamic> allCartItems;

  _BottomBarViewState(this.thisDbHelper, this.thisUser);

  @override
  void initState() {

    if (thisUser!=null) {
      //print("initState user: "+thisUser.uid.toString());
    }

//    retrieveCartId();

//    WidgetsBinding.instance
//        .addPostFrameCallback((_) {
//      setState(() {
//        cartItemsSize = allCartItems.length;
//      });
//    });

    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1000),
    );
    animationController.forward();

//    Future.delayed(Duration.zero, () {
//      //This setState is necessary because it refreshes the listView
//      setState(() {});
//    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

//    retrieveCartId();
//    allCartItems = retrieveAllCartItemsList();
    helperMethod();

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return new Transform(
              transform: new Matrix4.translationValues(0.0, 0.0, 0.0),
              child: new PhysicalShape(
                color: Color(0xff4c2717),
                elevation: 16.0,
                clipper: TabClipper(
                    radius: Tween(begin: 0.0, end: 1.0)
                            .animate(CurvedAnimation(
                                parent: animationController,
                                curve: Curves.fastOutSlowIn))
                            .value *
                        38.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 42,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8, top: 4),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TabIcons(
                                  tabIconData: widget.tabIconsList[0],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(
                                        widget.tabIconsList[0]);
                                    widget.changeIndex(0);
                                  }),
                            ),
                            Expanded(
                              child: TabIcons(
                                  tabIconData: widget.tabIconsList[1],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(
                                        widget.tabIconsList[1]);
                                    widget.changeIndex(1);
                                  }),
                            ),
                            SizedBox(
                              width: Tween(begin: 0.0, end: 1.0)
                                      .animate(CurvedAnimation(
                                          parent: animationController,
                                          curve: Curves.fastOutSlowIn))
                                      .value *
                                  64.0,
                            ),
                            Expanded(
                              child: TabIcons(
                                  tabIconData: widget.tabIconsList[2],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(
                                        widget.tabIconsList[2]);
                                    widget.changeIndex(2);
                                  }),
                            ),
                            Expanded(
                              child: TabIcons(
                                  tabIconData: widget.tabIconsList[3],
                                  removeAllSelect: () {
                                    setRemoveAllSelection(
                                        widget.tabIconsList[3]);
                                    widget.changeIndex(3);
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              ),
            );
          },
        ),
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: SizedBox(
            width: 38 * 2.0,
            height: 8 + 62.0,
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.transparent,
              child: SizedBox(
                width: 38 * 2.0,
                height: 38 * 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                        parent: animationController,
                        curve: Curves.fastOutSlowIn)),
                    child: FutureBuilder(
                      builder: (context, productSnap) {

                        cartItemsSize = 0;

                        //print("productSnap: "+productSnap.data.toString());

//                        if (productSnap.connectionState == ConnectionState.done) {
//
//                        }

                        if (productSnap.data!=null) {
                          for (int i = 0; i < productSnap.data.length; i++) {
                            //print("entrou for: "+productSnap.data[i]['productAmount'].toString());
                            cartItemsSize += productSnap.data[i]['productAmount'];
                          }

                        }

//                        //print(productSnap);
                        //print("Entrou FutureBuilder: "+cartItemsSize.toString());

                        return Badge(
                          badgeColor: Colors.red,
                          badgeContent: Text(cartItemsSize.toString(), style: TextStyle(color: Colors.white)),
                          showBadge: cartItemsSize!=0?true:false,
                          toAnimate: false,
                          elevation: 5,
                          position: BadgePosition.topRight(top: -5, right: -5),
                          child: Container(
                            // alignment: Alignment.center,s
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xff4c2717),
                                    Colors.brown,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.brown.withOpacity(0.4),
                                    offset: Offset(8.0, 16.0),
                                    blurRadius: 16.0),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  splashColor: Colors.yellow.withOpacity(0.1),
                                  highlightColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  onTap: () {
                                    widget.addClick();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.asset('images/cart.png'),
                                  )),
                            ),
                          ),
                        );
                      },
                      future: allCartItems,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void setRemoveAllSelection(TabIconData tabIconData) {
    if (!mounted) return;
    setState(() {
      widget.tabIconsList.forEach((tab) {
        tab.isSelected = false;
        if (tabIconData.index == tab.index) {
          tab.isSelected = true;
        }
      });
    });
  }

  Future<void> retrieveCartId() async {

    if (thisUser!=null) {
      //print("entrou user: "+thisUser.uid.toString());
      Map<String, dynamic> cart = await thisDbHelper.searchCart(thisUser.uid);

      if (cart != null) {
        //se tem carrinho
        cartId = cart['cartId'];
        //print("cart!=null");
      }

//      allCartItems = retrieveAllCartItems();
//      //print("passou a instancia do allCartItems");

    }else{
//      //print("entrou user: "+thisUser.toString());
//      allCartItems = resetAllCartItems();
//      cartItemsSize = 0;
    }

  }

  Future retrieveAllCartItemsList2() async {
//    cartItemsSize = 0;

    List<Map<String, dynamic>> thisAllCartItems;

    if (widget.user!=null) {
      //print("entrou retrieveAllCartItemsSize user: "+widget.user.uid.toString());
//      //print("entrou retrieveAllCartItemsSize user!=null");
      thisAllCartItems =
      await thisDbHelper.searchCartItemsBadge(widget.user.uid);
    }else{
      //print("entrou retrieveAllCartItemsSize user: "+widget.user.toString());
      thisAllCartItems =
      await thisDbHelper.retrieveAllCartItems(0);
    }



//    for (int i = 0; i < thisAllCartItems.length; i++) {
//      //print("entrou for");
////      setState(() {
////        cartItemsSize += thisAllCartItems[i]['productAmount'];
////      });
//    }

    //print("entrou thisAllCartItems: "+thisAllCartItems.length.toString());

//    allCartItems = thisAllCartItems;

    return thisAllCartItems;
  }

  Future retrieveAllCartItemsList() async {
//    cartItemsSize = 0;

  List<Map<String, dynamic>> thisAllCartItems;

  if (thisUser!=null) {
    //print("entrou retrieveAllCartItemsSize user: "+thisUser.uid.toString());
    //print("entrou retrieveAllCartItemsSize user!=null");
    thisAllCartItems =
    await thisDbHelper.retrieveAllCartItems(cartId);
  }else{
    //print("entrou retrieveAllCartItemsSize user: "+thisUser.toString());
    thisAllCartItems =
    await thisDbHelper.retrieveAllCartItems(0);
  }



//    for (int i = 0; i < thisAllCartItems.length; i++) {
//      //print("entrou for");
////      setState(() {
////        cartItemsSize += thisAllCartItems[i]['productAmount'];
////      });
//    }

    //print("entrou thisAllCartItems: "+thisAllCartItems.length.toString());

//    allCartItems = thisAllCartItems;

    return thisAllCartItems;
  }

  void helperMethod() {
    allCartItems = retrieveAllCartItemsList2();
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class TabIcons extends StatefulWidget {
  final TabIconData tabIconData;
  final Function removeAllSelect;

  const TabIcons({Key key, this.tabIconData, this.removeAllSelect})
      : super(key: key);

  @override
  _TabIconsState createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabIconData.animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 400),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (!mounted) return;
          widget.removeAllSelect();
          widget.tabIconData.animationController.reverse();
        }
      });
    super.initState();
  }

  void setAnimation() {
    widget.tabIconData.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
//            if (!widget.tabIconData.isSelected) {
              setAnimation();
//            }
          },
          child: IgnorePointer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                new ScaleTransition(
                  alignment: Alignment.center,
                  scale: Tween(begin: 0.88, end: 1.0).animate(CurvedAnimation(
                      parent: widget.tabIconData.animationController,
                      curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn))),
                  child: Image.asset(widget.tabIconData.isSelected
                      ? widget.tabIconData.selctedImagePath
                      : widget.tabIconData.imagePath),
                ),
                Positioned(
                  top: 4,
                  left: 6,
                  right: 0,
                  child: new ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                        parent: widget.tabIconData.animationController,
                        curve:
                            Interval(0.2, 1.0, curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 6,
                  bottom: 8,
                  child: new ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                        parent: widget.tabIconData.animationController,
                        curve:
                            Interval(0.5, 0.8, curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 8,
                  bottom: 0,
                  child: new ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                        parent: widget.tabIconData.animationController,
                        curve:
                            Interval(0.5, 0.6, curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabClipper extends CustomClipper<Path> {
  final double radius;

  TabClipper({this.radius = 38.0});

  @override
  Path getClip(Size size) {
    final path = Path();

    final v = radius * 2;
    path.lineTo(0, 0);
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
        degreeToRadians(90), false);
    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2) - v / 2) - radius + v * 0.04, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);

    path.arcTo(Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
        degreeToRadians(160), degreeToRadians(-140), false);

    path.arcTo(
        Rect.fromLTWH((size.width - ((size.width / 2) - v / 2)) - v * 0.04, 0,
            radius, radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);
    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
