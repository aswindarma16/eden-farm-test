
import 'package:flutter/material.dart';
import '../globals.dart';
import 'home_page.dart';

class MainMenu extends StatefulWidget {
  final String activePage;

  const MainMenu({
    Key? key, 
    required this.activePage
  }) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with WidgetsBindingObserver{
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String activePage = "home";
  
  @override
  void initState() {
    super.initState();
    activePage = widget.activePage;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool availableToPop = Navigator.canPop(context);
    
    return WillPopScope(
      onWillPop: () => onWillPopExit(context, availableToPop),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 60.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: activePage == "home" ? null : () {
                      setState(() {
                        activePage = "home";
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.home,
                            size: 20.0,
                            color: activePage == "home" ? primaryColor : bottomBarInactiveColor,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 1),
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            fontSize: 11.0,
                            color: activePage == "home" ? primaryColor : bottomBarInactiveColor,
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: activePage == "profile" ? null : () {
                      setState(() {
                        activePage = "profile";
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Icon(
                            Icons.account_circle,
                            size: 20.0,
                            color: activePage == "profile" ? primaryColor : bottomBarInactiveColor,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 1),
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 11.0,
                            color: activePage == "profile" ? primaryColor : bottomBarInactiveColor,
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      /** TODO sign out here */
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Center(
                          child: Icon(
                            Icons.logout,
                            size: 20.0,
                            color: bottomBarInactiveColor,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 1),
                        ),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 11.0,
                            color: bottomBarInactiveColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SafeArea(
              child: activePage == "home" ? const HomePage() : Container()
            );
          },
        ),
      ),
    );
  }
}
