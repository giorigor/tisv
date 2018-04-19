import 'dart:convert';
import 'package:sqljocky5/sqljocky.dart';
import 'package:sogecovic/objetos.dart';
import 'dart:async';

var _banco = new ConnectionPool(
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: 'toor',
    db: 'sogecovic',
    max: 5
);

void main() {
    print(new DateTime.now().millisecondsSinceEpoch);
    // Mesa mesa = new Mesa(1);
    // mesa.id = 1;
    // mesa.abertura = new DateTime.now();
    // mesa.fechamento = null;
    // MesaDAO.updateMesa(mesa);
}

abstract class MesaDAO {

    static Future<String> mesasAbertas() async {
        List resp = new List();
        var queryMesas = await _banco.query("SELECT * FROM sogecovic.tbl_mesas WHERE fechamento is null;");
        await queryMesas.forEach( (mesa) {
            Map<String, dynamic> row = new Map();
            row["id_mesa"] = mesa[0];
            row["num_mesa"] = mesa[1];
            row["abertura"] = mesa[2].toString();
            row["fechamento"] = null;
            resp.add(row);
        } );

        for (var row in resp) {
            List pedidos = new List();
            var queryPedidos = await _banco.query("SELECT * FROM sogecovic.tbl_pedidos WHERE id_mesa = ${row["id_mesa"]};");
            await queryPedidos.forEach( (pedido) {
                // print("PEDIDOS SAO ESCRITOS DA SEGUINTE MANEIRA $pedido");
                Map pdd = new Map();
                pdd["id_pedido"] = pedido[0];
                pdd["hora_pedido"] = pedido[1].toString();
                pdd["id_mesa"] = pedido[2];
                pdd["id_item"] = pedido[3];
                pdd["observacao"] = pedido[4];
                pdd["estado"] = pedido[5];
                pedidos.add(pdd);
            });
            row["pedidos"] = pedidos;
        }
        return JSON.encode(resp);
    }

    static Future<String> abreMesa(int numMesa) async {
        var query = await _banco.query("INSERT INTO sogecovic.tbl_mesas (num_mesa, abertura) VALUES ($numMesa, '${new DateTime.now().toString().substring(0,19)}');");
        print(query.insertId);
        return query.insertId.toString();
    }

    static Future<String> inserePedido(int id_mesa, int id_pedido) async {
        var query = await _banco.query("INSERT INTO sogecovic.tbl_pedidos (horaPedido, id_mesa, id_item, observacao, estado) VALUES (NOW(), $id_mesa, $id_pedido, null, 0);");
        print(query.insertId);
        return query.insertId.toString();
    }
}

class ItemDAO {
    static Future<String> allItems() async {
        List resp = new List ();
        var query = await _banco.query("SELECT * FROM tbl_itens");
        await query.forEach( (item) {
            Map row = new Map();
            row["id_item"] = item[0];
            row["nome"] = item[1];
            row["descricao"] = item[2];
            row["imagem"] = item[3];
            row["preco"] = item[4];
            resp.add(row);
        });

        return JSON.encode(resp);
    }

    static Future<List<Pedido>> pedidosMesa(int mesa) async {
        List<Pedido> resp = new List<Pedido>();
        
        return resp;
    }

    static Future<List<Pedido>> pedidosEmAbertoMesa(int mesa) async {
        List<Pedido> resp = new List<Pedido>();
        
        return resp;
    }

}