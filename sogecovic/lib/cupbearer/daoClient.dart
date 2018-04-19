import 'dart:convert';
import 'package:sqljocky5/sqljocky.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../objetos.dart';

const ip =
    // "10.0.1.200"; // BHS
    // "10.224.65.104"; // PUC
    "192.168.43.94"; // REDE DO IGOR
    // "10.0.1.11"; // PANDORA
    // "10.0.2.2";
    // "127.0.0.1"; // PC
const porta = "8080";


var _banco = new ConnectionPool(
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: 'toor',
    db: 'sogecovic',
    max: 5
);

// void main() async {
//     var response = await http.get("http://127.0.0.1:8080/mesas");
//         print(response.body);
//         Map<String,dynamic> objeto = await JSON.decode(response.body);
//         print(objeto.runtimeType);
//     // Mesa mesa = new Mesa(1);
//     // mesa.id = 1;
//     // mesa.abertura = new DateTime.now();
//     // mesa.fechamento = null;
//     // MesaDAO.updateMesa(mesa);
// }

abstract class MesaDAO {

    static Future<Map> mesasAbertas(Map cardapio) async {

        var response = await http.get("http://$ip:$porta/mesas");
        Map<String,dynamic> objeto = await JSON.decode(response.body);
        // print(objeto);
        var mesas = objeto["content"]["mesas"];
        // print(mesas);
        
        Map saguao = new Map();
        for (var mesa in mesas) {
            Mesa m = new Mesa();
            m.id = mesa["id_mesa"];
            m.numeroMesa = mesa["num_mesa"];
            m.abertura = DateTime.parse(mesa["abertura"]);
            m.fechamento = null;
            m.pedidos = new List();
            for (var pedido in mesa["pedidos"]){
                Pedido p = new Pedido(cardapio[pedido["id_item"]], m);
                p.id = pedido["id_pedido"];
                p.pedido = DateTime.parse(pedido["hora_pedido"]);
                p.obs = pedido["observacao"];
                p.estado = Estado.values[pedido["estado"]];
                m.pedidos.add(p);
            }
            saguao[m.id] = m;
        }

        return saguao;


        // Map resp = new Map();
        // var queryMesas = await _banco.query("SELECT * FROM sogecovic.tbl_mesas WHERE fechamento is null;");
        // await queryMesas.forEach( (mesa) {
        //     Mesa row = new Mesa(mesa[1]);
        //     row.id = mesa[0];
        //     row.numeroMesa = mesa[1];
        //     row.abertura = mesa[2];
        //     row.fechamento = null;
        //     resp[mesa[0]] = (row);
        // } );
        // for (var row in resp) {
        //     List pedidos = new List();
        //     var queryPedidos = await _banco.query("SELECT * FROM sogecovic.tbl_pedidos WHERE id_mesa = ${row["id_mesa"]};");
        //     await queryPedidos.forEach( (pedido) {
        //         Pedido pdd = new Pedido(null,null);
        //         pdd.id = pedido[0];
        //         pdd.pedido = pedido[1];
        //         pdd.mesa = resp[pedido[2]];
        //         pdd.item = cardapio[pedido[3]];
        //         pdd.obs = pedido[4];
        //         pdd.estado = pedido[5];
        //         pedidos.add(pdd);
        //     });
        //     row["pedidos"] = pedidos;
        // }
        // return resp;
    }

    static Future<int> abreMesa(int numMesa) async {
        print("ABRE MESA $numMesa");
        Map corpo = new Map();
        corpo["header"] = {
            "status" : 2,
            "status_desc" : "Request bem sucedido!"
        };
        corpo["content"] = {
            "mesa": {
                "numMesa" : numMesa
            }
        };
        var resposta = await http.post("http://$ip:$porta/mesas", body: JSON.encode(corpo));
        print(resposta);
    }

    static Future<Pedido> adicionaPedido(Mesa m, Item i) async {
        Map corpo = new Map();
        Map pedido = new Map();
        corpo["header"] = {
            "status" : 2,
            "status_desc" : "Request bem sucedido!"
        };
        corpo["content"] = pedido;

        pedido["id_mesa"] = m.id;
        pedido["id_item"] = i.id;

        var resposta = await http.post("http://$ip:$porta/mesas/${m.id}", body: JSON.encode(corpo));

        print(resposta);
        return null;
    }
}

class ItemDAO {
    static Future<Map> allItems() async {
        // print("TENTANDO GET http://$ip:$porta/cardapio");
        var response = await http.get("http://$ip:$porta/cardapio");
        // print("GETOU CARDAPIO");
        Map<String,dynamic> objeto = await JSON.decode(response.body);
        // print(objeto);

        Map cardapio = new Map();
        var itens = objeto["content"]["itens"];
        for (var item in itens){
            Item i = new Item(item["id_item"], item["nome"], item["imagem"], item["descricao"], item["preco"]);
            cardapio[i.id] = i;
        }
        return cardapio;
        // var query = await _banco.query("SELECT * FROM tbl_itens");
        // await query.forEach( (item) {
        //     Item row = new Item(item[0],item[1],item[2],item[3],item[4]);
        //     resp[item[0]] = row;
        // });
        // return null;
    }

}