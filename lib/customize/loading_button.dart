import 'package:flutter/material.dart';

class LoadingButon extends StatefulWidget {
  final int state;
  final String buttonName;
  final Function onPressed;

  LoadingButon(
      {@required this.state,
      @required this.onPressed,
      @required this.buttonName});

  @override
  _LoadingButonState createState() => _LoadingButonState();
}

class _LoadingButonState extends State<LoadingButon>
    with TickerProviderStateMixin {
  bool _isPressed = false, _animatingReveal = false;
  // int widget.state = 0;
  double _width;
  Animation _animation;
  GlobalKey _globalKey = GlobalKey();
  AnimationController _controller;

  @override
  void deactivate() {
    reset();
    super.deactivate();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
        color: Colors.blue,
        elevation: calculateElevation(),
        borderRadius: BorderRadius.circular(25.0),
        child: Container(
          key: _globalKey,
          height: 48.0,
          width: 100.0,
          child: RaisedButton(
            padding: EdgeInsets.all(0.0),
            color: widget.state == 2 ? Colors.green : Colors.blue,
            child: buildButtonChild(),
            onPressed: () {
              this.widget.onPressed();
            },
            onHighlightChanged: (isPressed) {
              setState(() {
                _isPressed = isPressed;
                if (widget.state == 0) {
                  animateButton();
                }
              });
            },
          ),
        ));
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext.size.width;

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - 48.0) * _animation.value);
        });
      });
    _controller.forward();
  }

  Widget buildButtonChild() {
    if (widget.state == 0) {
      return Text(
        widget.buttonName,
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      );
    } else if (widget.state == 1) {
      return SizedBox(
        height: 36.0,
        width: 36.0,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  double calculateElevation() {
    if (_animatingReveal) {
      return 0.0;
    } else {
      return _isPressed ? 6.0 : 4.0;
    }
  }

  void reset() {
    _width = double.infinity;
    _animatingReveal = false;
    //  widget.state = 0;
  }
}
