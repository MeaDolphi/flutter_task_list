import 'package:flutter/material.dart';

import '../icons.dart';

class TaskListCheckBox extends StatefulWidget {
  final double size;
  final double width;
  final Color borderColor;
  final Color fillColor;
  final Color checkColor;
  bool value;
  final Function onChanged;

  TaskListCheckBox({this.size = 24, this.width = 3, this.checkColor = Colors.black, this.borderColor = Colors.white, this.fillColor = Colors.white, this.value = false, this.onChanged});

  @override
  State<StatefulWidget> createState() {
    return _TaskListCheckBoxState();
  }
}

class _TaskListCheckBoxState extends State<TaskListCheckBox> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    widget.value ? _animationController.forward() : _animationController.reset();
  }

  @override
  void didUpdateWidget(covariant TaskListCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.value ? _animationController.forward() : _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.value = !widget.value;

        widget.onChanged(widget.value);
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          border: Border.all(
            width: widget.width,
            color: widget.fillColor,
          ),
          color: widget.value ? widget.borderColor : null
        ),
        child: FadeTransition(
          opacity: _animation,
          child: Icon(
            widget.value ? TaskListIcons.check : null,
            size: widget.size/2,
            color: widget.checkColor,
          )
        ),
      ),
    );
  }
}