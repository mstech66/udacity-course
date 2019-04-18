// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  /// This [Category]'s name.
  final String name;

  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the name, color, and units to not be null.
  const ConverterRoute({
    @required this.name,
    @required this.color,
    @required this.units,
  })  : assert(name != null),
        assert(color != null),
        assert(units != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  // TODO: Set some variables, such as for keeping track of the user's input
  // value and units
  Unit fromValue;
  Unit toValue;
  double input;
  String converted = '';
  bool _showError = false;
  List<DropdownMenuItem> _unitMenuItem;

  @override
  void initState() {
    super.initState();
    _createDropDownItems();
    _setDefaults();
  }

  void _setDefaults() {
    setState(() {
      fromValue = widget.units[0];
      toValue = widget.units[1];
    });
  }

  void _createDropDownItems() {
    var newItems = <DropdownMenuItem>[];
    for (var unit in widget.units) {
      newItems.add(DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(unit.name, softWrap: true),
        ),
      ));
    }
    setState(() {
      _unitMenuItem = newItems;
    });
  }
  // TODO: Determine whether you need to override anything, such as initState()

  // TODO: Add other helper functions. We've given you one, _format()

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  Widget _createDropdown (String currentVal, ValueChanged<dynamic> onChanged){
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
          color: Colors.grey[400],
          width: 1.0
        )
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[50]
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: currentVal,
              items: _unitMenuItem,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.title,
            ),
          ),
        ),
      ),
    );
  }
  Unit _getUnit(String unitName) {
    return widget.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }
  void _updateConversion() {
    setState(() {
      converted =
          _format(input * (toValue.conversion / fromValue.conversion));
    });
  }
  void _updateFromConversion(dynamic unitName) {
    setState(() {
      fromValue = _getUnit(unitName);
    });
    if (input != null) {
      _updateConversion();
    }
  }
  void _updateToConversion(dynamic unitName) {
    setState(() {
      toValue = _getUnit(unitName);
    });
    if (input != null) {
      _updateConversion();
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: Create the 'input' group of widgets. This is a Column that
    // includes the input value, and 'from' unit [Dropdown].
    final input = Padding(
      padding: EdgeInsets.all(16.0),
      child: new Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
               decoration: InputDecoration(
                 labelStyle: Theme.of(context).textTheme.display1,
                 labelText: "Input",
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(0.0)
                 )
               ),
               keyboardType: TextInputType.number,
            ),
            _createDropdown(fromValue.name, _updateFromConversion)
          ],
        ),
      ),
    );

    // TODO: Create a compare arrows icon.

    final arrows = RotatedBox(
      child: Icon(Icons.compare_arrows, size: 40),
      quarterTurns: 1,
    );

    // TODO: Create the 'output' group of widgets. This is a Column that
    // includes the output value, and 'to' unit [Dropdown].
    final output = Padding(
      padding: EdgeInsets.all(16.0),
      child: new Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
               decoration: InputDecoration(
                 labelStyle: Theme.of(context).textTheme.display1,
                 labelText: "Output",
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(0.0)
                 )
               ),
               keyboardType: TextInputType.number,
            ),
            _createDropdown(toValue.name, _updateToConversion)
          ],
        ),
      ),
    );

    // TODO: Return the input, arrows, and output widgets, wrapped in a Column.
    final converter =  Column(
      children: <Widget>[
        input,
        arrows,
        output
      ],
    );
    return Padding(
      child: converter,
      padding: EdgeInsets.all(16.0),
    );
    // TODO: Delete the below placeholder code.
  }
}
