import 'package:flutter/material.dart';

import '../globals.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool availableToPop = false;

  @override
  void initState() {
    super.initState();
    availableToPop = Navigator.canPop(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPopExit(context, availableToPop),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Image.asset(
            "assets/images/eden_farm_logo.jpg",
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}