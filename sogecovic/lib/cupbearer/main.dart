import 'package:flutter/material.dart';
import '../objetos.dart';
import 'daoClient.dart';

void main() async {
	await startBD();
	runApp(new MyApp());
} 

Map saguao = new Map();
Map cardapio = new Map();

void startBD() async {
	try{
		print("Iniciando o StartBD");
		cardapio = await ItemDAO.allItems();
		print("Cardapio Getado");

		saguao = await MesaDAO.mesasAbertas(cardapio);
		print("Saguão Getado");

	} catch (e) {
		print(e);
	}
}

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return new MaterialApp(
			title: 'Mesas do Restaurante',
			home: new ConjuntoMesas(),
			theme: new ThemeData(
				primaryColor: Colors.brown,
				accentColor: Colors.orange
			),
		);
	}
}

class ConjuntoMesas extends StatefulWidget {
	@override
	createState() => new ConjuntoMesasState();
}

class ConjuntoMesasState extends State<ConjuntoMesas> {
	// final TextStyle _biggerFont = new TextStyle(fontSize: 18.0);

	// Future<Response> fetchPost() {
  	// 	return http.get('https://jsonplaceholder.typicode.com/posts/1');
	// }

	

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			appBar: new AppBar(
				title: new Text('Mesas do Restaurante'),
			),
			body: new RefreshIndicator(
				child: _buildListaMesas(),
				onRefresh: () { startBD(); },
			),
			
			floatingActionButton: new FloatingActionButton(
				backgroundColor: Colors.orange,
				onPressed: () { 
					abreMesa();
					return null;
				},
				child: new Icon(Icons.add),
			),
		);
	}

	Widget _buildListaMesas() {
		List listaMesas = saguao.values.toList(); 
		// print("LISTA MESAS $listaMesas");
		return new ListView(
			// physics: const AlwaysScrollableScrollPhysics(),
			padding: const EdgeInsets.all(8.0),
			children: 
				ListTile.divideTiles(
					context: context,
					tiles: listaMesas.map( (mesa) {
						// print(mesa.runtimeType);
						return _buildMesa(mesa);
					}),
				).toList(),
			addRepaintBoundaries: true,
		);
	}

	Widget _buildMesa(Mesa mesa) {
		return new ListTile(
			title: new Card(
				margin: EdgeInsets.all(8.0),
				child: new Column(
					mainAxisSize: MainAxisSize.min,
					children: <Widget>[
						new ListTile(
							title: new Text("Mesa ${mesa.numeroMesa}"),
							subtitle: new Text(mesa.abertura.toString()),
							trailing: new IconButton(
								icon: new Icon(Icons.add),
								onPressed: () { 
									novoPedido(mesa);
								 }
							),
							
						),
						new Divider(),
						new ListView.builder(
							physics: new NeverScrollableScrollPhysics(),
							itemBuilder: (context, i) {
								// print(mesa.pedidos.toString());
								if (i<mesa.pedidos.length)
									return _buildPedido(mesa.pedidos[i]);
							},
							shrinkWrap: true,
						)
					],
				),
				color: _setColor(mesa)
			),
		);
	}

	Color _setColor(Mesa mesa) {
		if (mesa.fechamento!=null) return Colors.blueGrey;
		else return null;
	}

	Widget _buildPedido(Pedido p) {
		return new ListTile(
			title: new Text(p.item.nome),
			// subtitle: _buildEstadoPedido(p),
			trailing: new IconButton(
						icon: new Icon(Icons.check),
						onPressed: () {print("TIMER");},
						color: Colors.green,
			),
			
		);
	}

	novoPedido(Mesa mesa){
		Navigator.of(context).push(
			new MaterialPageRoute(
				builder: (context) {
					return new Scaffold(
						appBar: new AppBar(
							title: new Text("Novo Pedido")
						),
						body: listarCardapio(mesa)
					);
				},

			)
		);
	}

	Widget listarCardapio(Mesa mesa){
		List listaCardapio = cardapio.values.toList();
		return new ListView(
			children: 
				ListTile.divideTiles(
					context: context,
					tiles: listaCardapio.map( (item) {
						// print(mesa.runtimeType);
						return _buildItem(item, mesa);
					}),
				).toList(),
		);
	}

	Widget _buildItem(Item item, Mesa mesa){
		return new ListTile(
			title: new Text(item.nome),
			onTap: () {
				MesaDAO.adicionaPedido(mesa, item);
				Navigator.pop(context);
			},
		);
	}

	abreMesa() {
		Navigator.of(context).push(
			new MaterialPageRoute(
				builder: (context) {
					print("CRIANDO AS MESAS PARA ABRIR");
					return new Scaffold(
						appBar: new AppBar(
							title: new Text("Abrir Mesa"),
						),
						body: selectMesasFechadas()
					);
				}
			)
		);
	}

	Widget selectMesasFechadas() {
		List mesasFechadas = new List();
		for (var i=1; i<15; i++) {
			mesasFechadas.add(i);
		}
		print(mesasFechadas);
		for (var mesa in saguao.values.toList()){
			print("remove ${mesa.numeroMesa} = ${mesasFechadas.remove(mesa.numeroMesa)}");
		}
		print(mesasFechadas);

		return new ListView.builder(
			itemBuilder: (context, i) {
				if (i<mesasFechadas.length)
					return _buildMesaFechada(mesasFechadas[i]);
			}
		);
	}

	Widget _buildMesaFechada(int i) {
		return new ListTile(
			title: new Text("Mesa $i"),
			onTap: () {
				MesaDAO.abreMesa(i);
				Navigator.pop(context);
			},
		);
	}
}
