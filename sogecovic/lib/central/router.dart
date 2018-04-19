import 'package:sqljocky5/sqljocky.dart';
import 'dart:io';
import 'dart:convert';
import 'daoServer.dart';

var ip =
    // new InternetAddress("10.0.1.200"); // BHS
    // new InternetAddress("10.224.65.104"); // PUC
    new InternetAddress("192.168.43.94"); // REDE DO IGOR
    // new InternetAddress("10.0.1.11");// PANDORA
    // InternetAddress.LOOPBACK_IP_V4;
const porta = 8080;

var banco = new ConnectionPool(
    host: 'localhost', port: 3306,
    user: 'root', password: 'toor',
    db: 'sogecovic', max: 5
);

void main() async {
    var server = await HttpServer.bind(ip, porta);
	print("Servidor iniciado em ${server.address.address}:${server.port} às ${new DateTime.now().toString()}!");

    Map resp = new Map();
    Map header = new Map();
    resp["header"] = header;

    await for (var request in server){
        request.response.headers.contentType = ContentType.JSON;
        print("[${new DateTime.now()}] => ${request.method} ${request.uri} vindo de ${request.connectionInfo.remoteAddress.address.toString()}");
        // print(request.uri.path.split("/"));
        switch (request.uri.path.split("/")[1]) {
            case "mesas": 
                mesasController(request);
            break;
            case "cardapio": 
                itensController(request);
            break;
            default: 
                header["status"] = 5;
                header["status_desc"] = "Path ${request.uri.path} não encontrado no Router!";
                request.response
                    ..statusCode = HttpStatus.NOT_FOUND
                    ..write(JSON.encode(resp))
                    ..close();
            break;
        }
    }
}

void mesasController(HttpRequest request) async {
    Map resp = new Map();
    Map header = new Map();
    Map content = new Map();
    resp["header"] = header;
    resp["content"] = content;

    try {
        switch (request.method) {
            case "GET": 
                header["status"] = 2;
                header["status_desc"] = "GET MESAS feito com sucesso!";
                
                // if (request.uri.path.split("/")[2])

                MesaDAO.mesasAbertas().then( (obj) {
                    content["mesas"] = JSON.decode(obj);
                    request.response
                        ..write(JSON.encode(resp))
                        ..close();
                } );
                break;
            case "POST":
                // print("request uri path = ${request.uri.path.split("/")[2] == null}");
                if (request.uri.path.split("/").length<=2){
                    // print("Entrou no POST");
                    header["status"] = 2;
                    header["status_desc"] = "POST MESA feito com sucesso!";
                    String requisicao = await request.transform(UTF8.decoder).join();
                    // print(requisicao);
                    Map jsonEntrada = JSON.decode(requisicao);
                    int numMesa = jsonEntrada['content']['mesa']['numMesa'];
                    print(numMesa);
                    MesaDAO.abreMesa(numMesa).then( (obj) {
                        content["id_mesa"] = JSON.decode(obj);
                        request.response
                            ..write(JSON.encode(resp))
                            ..close();
                    } );
                } else {
                    header["status"] = 2;
                    header["status_desc"] = "POST PEDIDO feito com sucesso!";
                    String requisicao = await request.transform(UTF8.decoder).join();
                    print(requisicao);
                    Map jsonEntrada = JSON.decode(requisicao);
                    int id_mesa = jsonEntrada['content']['id_mesa'];
                    int id_item = jsonEntrada['content']['id_item'];
                    MesaDAO.inserePedido(id_mesa, id_item).then( (obj) {
                        content["id_pedido"] = JSON.decode(obj);
                        request.response
                            ..write(JSON.encode(resp))
                            ..close();
                    } );
                }
                
                break;
            default:
                
                break;
        }
    } catch (e) {
        print(e);
        switch (e.runtimeType) {
            case FormatException: 
            break;
        }
    }
}

void itensController(HttpRequest request) async {
    Map resp = new Map();
    Map header = new Map();
    Map content = new Map();
    resp["header"] = header;
    resp["content"] = content;

    try {
      switch (request.method){
          case "GET":
            header["status"] = 2;
                header["status_desc"] = "GET CARDAPIO feito com sucesso!";
                
                // if (request.uri.path.split("/")[2])

                ItemDAO.allItems().then( (obj) {
                    content["itens"] = JSON.decode(obj);
                    request.response
                        ..write(JSON.encode(resp))
                        ..close();
                } );
                break;
          break;
      }
    } catch (e) {
    }
}

void pedidosController(HttpRequest request) {

}

void usuariosController(HttpRequest request) {

}