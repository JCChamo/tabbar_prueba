import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(0),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  int tab;
  MyHomePage(this.tab, {Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  late int initialTab;

  late Size size;

  final List<Widget> _children = [
    Center(
      child: Text("Habichuelas"),
    ),
    Center(
      child: Text("Lentejas"),
    ),
    Center(
      child: Text("Garbanzos"),
    ),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    // ignore: unnecessary_null_comparison
    if (widget.tab != null) {
      initialTab = widget.tab;
      _tabController.index = initialTab;
    } else {
      initialTab = 0;
      _tabController.index = initialTab;
    }
  }

  void _handleTabSelection() {
    setState(() {
      _tabController.animateTo(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          getTabBarView(size),
          getTabsRow(size),
        ],
      ),
    );
  }

  Widget getTabsRow(Size size) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: size.width,
        height: size.height * 0.12,
        child: TabBar(
          labelPadding: EdgeInsets.only(bottom: 0),
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          labelColor: Colors.red,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 0, color: Colors.transparent)),
          tabs: [
            Container(
              height: size.height * 0.1,
              child: Tab(
                icon: SvgPicture.asset(
                  "assets/icons8_casa.svg",
                  width: size.width * 0.04,
                  height: size.height * 0.035,
                  color: getColor(0),
                ),
                text: "Inicio",
              ),
            ),
            Container(
              height: size.height * 0.1,
              child: Tab(
                icon: SvgPicture.asset(
                  "assets/icons8_ajustes.svg",
                  width: size.width * 0.04,
                  height: size.height * 0.035,
                  color: getColor(1),                  
                ),
                text: "Ajustes",
              ),
            ),
            Container(
              height: size.height * 0.1,
              child: Tab(
                icon: SvgPicture.asset(
                  "assets/more_svgrepo_com.svg",
                  width: size.width * 0.04,
                  height: size.height * 0.035,
                  color: getColor(2),                  
                ),
                text:"Más",
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 3,
              color: Colors.blueGrey,
              spreadRadius: 0.1,
              offset: Offset(0.0, -1.0),
            ),
          ],
        ),
      ),
    );
  }

  getTabBarView(Size size) {
    return Positioned(
      top: 0.0,
      child: Container(
        width: size.width,
        height: size.height * 0.88,
        child: TabBarView(
          controller: _tabController,
          physics: ScrollPhysics(),
          children: _children,
        ),
      ),
    );
  }

  

  
  getColor(int tabIndex) {
    final selectedColorTween = ColorTween(begin: Colors.grey, end: Colors.red);
    final previousColorTween = ColorTween(begin: Colors.red, end: Colors.grey);

    Color background;

    if (_tabController.indexIsChanging) {
      final double t = 1.0 - _indexChangeProgress(_tabController);
      if (_tabController.index == tabIndex)
        background = selectedColorTween.lerp(t)!;
      else if (_tabController.previousIndex == tabIndex)
        background = previousColorTween.lerp(t)!;
      else
        background = selectedColorTween.begin!;
    } else {
      // The selection's offset reflects how far the TabBarView has / been dragged
      // to the previous page (-1.0 to 0.0) or the next page (0.0 to 1.0).
      final double offset = _tabController.offset;
      if (_tabController.index == tabIndex) {
        background = selectedColorTween.lerp(1.0 - offset.abs())!;
      } else if (_tabController.index == tabIndex - 1 && offset > 0.0) {
        background = selectedColorTween.lerp(offset)!;
      } else if (_tabController.index == tabIndex + 1 && offset < 0.0) {
        background = selectedColorTween.lerp(-offset)!;
      } else {
        background = selectedColorTween.begin!;
      }
    }
    return background;
  }

  double _indexChangeProgress(TabController controller) {
    final double controllerValue = controller.animation!.value;
    final double previousIndex = controller.previousIndex.toDouble();
    final double currentIndex = controller.index.toDouble();

    // The controller's offset is changing because the user is dragging the
    // TabBarView's PageView to the left or right.
    if (!controller.indexIsChanging)
      return (currentIndex - controllerValue).abs().clamp(0.0, 1.0);

    // The TabController animation's value is changing from previousIndex to currentIndex.
    return (controllerValue - currentIndex).abs() /
        (currentIndex - previousIndex).abs();
  }
}
