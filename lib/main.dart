import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  //provide the same scrollController for list and draggableScrollbar
  final ScrollController horizontalController = ScrollController();
  final ScrollController verticalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Draggable Scroll Bar Demo'),
        ),
        //DraggableScrollbar builds Stack with provided Scrollable List of Grid
        body: new DraggableScrollbar(
          child: _buildGrid(),
          horizontalController: horizontalController,
          verticalController: verticalController,
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {

      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: horizontalController,
        child: SingleChildScrollView(
          controller: verticalController,
          child: Container(
            width: 2000,
            height: 2000,
            child: Image.network('https://repository-images.githubusercontent.com/31792824/fb7e5700-6ccc-11e9-83fe-f602e1e1a9f1',
              fit: BoxFit.fill,
            ),
            color: Colors.green,
          ),
        ),//scrollController is final in this stateless widget
      ),
    );
  }
}

class DraggableScrollbar extends StatefulWidget {
  final double widthHorizontalScrollThumb;
  final double heightVerticalScrollThumb;
  final Widget child;
  final ScrollController horizontalController;
  final ScrollController verticalController;

  DraggableScrollbar({
    this.widthHorizontalScrollThumb = 100.0,
    this.heightVerticalScrollThumb = 100.0,
    this.child,
    this.horizontalController,
    this.verticalController,
  });

  @override
  _DraggableScrollbarState createState() => new _DraggableScrollbarState();
}

class _DraggableScrollbarState extends State<DraggableScrollbar> {

  double _horizontalBarOffset;
  double _verticalBarOffset;
  double _horizontalViewOffset;
  double _verticalViewOffset;
  bool _isHorizontalDragInProcess;
  bool _isVerticalDragInProcess;
  bool _isVerticalListener;

  @override
  void initState() {
    super.initState();
    _horizontalBarOffset = 0.0;
    _verticalBarOffset = 0.0;
    _horizontalViewOffset = 0.0;
    _verticalViewOffset = 0.0;
    _isHorizontalDragInProcess = false;
    _isVerticalDragInProcess = false;
    _isVerticalListener = false;
  }

  double get horizontalBarMaxScrollExtent =>
      context.size.width - widget.widthHorizontalScrollThumb;
  double get horizontalBarMinScrollExtent => 0.0;

  double get verticalBarMaxScrollExtent =>
      context.size.height - widget.heightVerticalScrollThumb;
  double get verticalBarMinScrollExtent => 0.0;

  double get horizontalViewMaxScrollExtent => widget.horizontalController.position.maxScrollExtent;
  double get verticalViewMaxScrollExtent => widget.verticalController.position.maxScrollExtent;

  double get horizontalViewMinScrollExtent => widget.horizontalController.position.minScrollExtent;
  double get verticalViewMinScrollExtent => widget.verticalController.position.minScrollExtent;

  double getHorizontalScrollViewDelta(
      double horizontalBarDelta,
      double horizontalBarMaxScrollExtent,
      double horizontalViewMaxScrollExtent,
      ) {//propotion
    return horizontalBarDelta * horizontalViewMaxScrollExtent / horizontalBarMaxScrollExtent;
  }

  double getVerticalScrollViewDelta(
      double verticalBarDelta,
      double verticalBarMaxScrollExtent,
      double verticalViewMaxScrollExtent,
      ) {//propotion
    return verticalBarDelta * verticalViewMaxScrollExtent / verticalBarMaxScrollExtent;
  }

  double getHorizontalBarDelta(
      double horizontalscrollViewDelta,
      double horizontalBarMaxScrollExtent,
      double horizontalViewMaxScrollExtent,
      ) {//propotion
    return horizontalscrollViewDelta * horizontalBarMaxScrollExtent / horizontalViewMaxScrollExtent;
  }

  double getVerticalBarDelta(
      double verticalscrollViewDelta,
      double verticalBarMaxScrollExtent,
      double verticalViewMaxScrollExtent,
      ) {//propotion
    return verticalscrollViewDelta * verticalBarMaxScrollExtent / verticalViewMaxScrollExtent;
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    setState(() {
      _isHorizontalDragInProcess = true;
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
    setState(() {
      _isVerticalDragInProcess = true;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      _isHorizontalDragInProcess = false;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    setState(() {
      _isVerticalDragInProcess = false;
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _horizontalBarOffset += details.delta.dx;

      if (_horizontalBarOffset < horizontalBarMinScrollExtent) {
        _horizontalBarOffset = horizontalBarMinScrollExtent;
      }
      if (_horizontalBarOffset > horizontalBarMaxScrollExtent) {
        _horizontalBarOffset = horizontalBarMaxScrollExtent;
      }

      double horizontalViewDelta = getHorizontalScrollViewDelta(
          details.delta.dx, horizontalBarMaxScrollExtent, horizontalViewMaxScrollExtent);

      _horizontalViewOffset = widget.horizontalController.position.pixels + horizontalViewDelta;
      if (_horizontalViewOffset < widget.horizontalController.position.minScrollExtent) {
        _horizontalViewOffset = widget.horizontalController.position.minScrollExtent;
      }
      if (_horizontalViewOffset > horizontalViewMaxScrollExtent) {
        _horizontalViewOffset = horizontalViewMaxScrollExtent;
      }
      widget.horizontalController.jumpTo(_horizontalViewOffset);
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _verticalBarOffset += details.delta.dy;

      if (_verticalBarOffset < verticalBarMinScrollExtent) {
        _verticalBarOffset = verticalBarMinScrollExtent;
      }
      if (_verticalBarOffset > verticalBarMaxScrollExtent) {
        _verticalBarOffset = verticalBarMaxScrollExtent;
      }

      double verticalViewDelta = getVerticalScrollViewDelta(
          details.delta.dy, verticalBarMaxScrollExtent, verticalViewMaxScrollExtent);

      _verticalViewOffset = widget.verticalController.position.pixels + verticalViewDelta;
      if (_verticalViewOffset < widget.verticalController.position.minScrollExtent) {
        _verticalViewOffset = widget.verticalController.position.minScrollExtent;
      }
      if (_verticalViewOffset > verticalViewMaxScrollExtent) {
        _verticalViewOffset = verticalViewMaxScrollExtent;
      }
      widget.verticalController.jumpTo(_verticalViewOffset);
    });
  }

  changeHorizontalPosition(ScrollNotification notification) {
    print(_isVerticalListener);
    if (_isHorizontalDragInProcess || _isVerticalDragInProcess || _isVerticalListener) {
      return;
    }

    setState(() {
      if (notification is ScrollUpdateNotification) {
        _horizontalBarOffset += getHorizontalBarDelta(
          notification.scrollDelta,
          horizontalBarMaxScrollExtent,
          horizontalViewMaxScrollExtent,
        );

        if (_horizontalBarOffset < horizontalBarMinScrollExtent) {
          _horizontalBarOffset = horizontalBarMinScrollExtent;
        }
        if (_horizontalBarOffset > horizontalBarMaxScrollExtent) {
          _horizontalBarOffset = horizontalBarMaxScrollExtent;
        }

        _horizontalViewOffset += notification.scrollDelta;
        if (_horizontalViewOffset < widget.horizontalController.position.minScrollExtent) {
          _horizontalViewOffset = widget.horizontalController.position.minScrollExtent;
        }
        if (_horizontalViewOffset > horizontalViewMaxScrollExtent) {
          _horizontalViewOffset = horizontalViewMaxScrollExtent;
        }
      }
    });
  }

  changeVerticalPosition(ScrollNotification notification) {
    if (_isVerticalDragInProcess || _isHorizontalDragInProcess) {
      return;
    }

    setState(() {
      if (notification is ScrollStartNotification) {
        _isVerticalListener = true;
      }
      if (notification is ScrollUpdateNotification) {
        _verticalBarOffset += getVerticalBarDelta(
          notification.scrollDelta,
          verticalBarMaxScrollExtent,
          verticalViewMaxScrollExtent,
        );

        if (_verticalBarOffset < verticalBarMinScrollExtent) {
          _verticalBarOffset = verticalBarMinScrollExtent;
        }
        if (_verticalBarOffset > verticalBarMaxScrollExtent) {
          _verticalBarOffset = verticalBarMaxScrollExtent;
        }

        _verticalViewOffset += notification.scrollDelta;
        if (_verticalViewOffset < widget.verticalController.position.minScrollExtent) {
          _verticalViewOffset = widget.verticalController.position.minScrollExtent;
        }
        if (_verticalViewOffset > verticalViewMaxScrollExtent) {
          _verticalViewOffset = verticalViewMaxScrollExtent;
        }
      }
      if (notification is ScrollEndNotification) {
        _isVerticalListener = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          changeHorizontalPosition(notification);
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: widget.horizontalController,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              changeVerticalPosition(notification);
            },
            child: SingleChildScrollView(
              controller: widget.verticalController,
              child: Container(
                width: 2000,
                height: 2000,
                child: Image.network('https://repository-images.githubusercontent.com/31792824/fb7e5700-6ccc-11e9-83fe-f602e1e1a9f1',
                  fit: BoxFit.fill,
                ),
                color: Colors.green,
              ),
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
            ),
          ),
          height: 20.0,
          width: double.infinity,
          child: GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragStart: _onHorizontalDragStart,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: _horizontalBarOffset),
                child: _buildHorizontalScrollThumb()),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
            ),
          ),
          width: 20.0,
          height: double.infinity,
          child: GestureDetector(
            onVerticalDragUpdate: _onVerticalDragUpdate,
            onVerticalDragStart: _onVerticalDragStart,
            onVerticalDragEnd: _onVerticalDragEnd,
            child: Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: _verticalBarOffset),
                child: _buildVerticalScrollThumb()),
          ),
        ),
      ),
    ]);
  }

  Widget _buildHorizontalScrollThumb() {
    return new Container(
      width: widget.widthHorizontalScrollThumb,
      height: 3.0,
      color: Colors.blue,
    );
  }
  Widget _buildVerticalScrollThumb() {
    return new Container(
      height: widget.heightVerticalScrollThumb,
      width: 3.0,
      color: Colors.blue,
    );
  }
}