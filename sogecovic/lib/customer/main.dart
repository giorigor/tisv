import 'package:flutter/material.dart';
import 'package:sogecovic/objetos.dart';

void main() => runApp(new CustomerApp());

class CustomerApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return new MaterialApp(
			title: "Cardápio Victório's",
			home: new Scaffold(
				appBar: new AppBar(
					title: new Text("Cardápio Victório's"),
				),
				body: new Center(
					child: new Divider(),
				)
			),
		);
	}
}
