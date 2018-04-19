enum Estado {em_espera, preparando, pronto, cancelado}

// class Restaurante {
//     Map<int,Item> cardapio;
//     Map<int,Mesa> saguao;

//     Restaurante() {
//         cardapio = new Map<int,Item>();
//         saguao = new Map<int,Mesa>();        
//     }

//     void abreMesa(int num){
//         saguao[num] = new Mesa(num);
//     }

//     void fechaMesa(int num){
//         saguao[num].fechaMesa();
//         //TODO query para armazenar no bd
//         saguao[num] = null;
//     }

//     int novoPedido(int item, int mesa){
//         return saguao[mesa].novoPedido(cardapio[item]);
//     }

//     void cancelaPedido(int pedido, int mesa){
//         //TODO conferir se pode remover o pedido
//         saguao[mesa].cancelaPedido(pedido);
//         //TODO query para alterar no bd
//     }

// }

class Mesa {
    int id;
    int numeroMesa;
    DateTime abertura;
    DateTime fechamento;
    List<Pedido> pedidos;

    Mesa() {
        id = 0;
        numeroMesa = 0;
        abertura = null;
        fechamento = null;
        pedidos = null;
    }

    Mesa.numDaMesa(int num) {
        this.numeroMesa = num;
        abertura = new DateTime.now();
        fechamento = null;
        pedidos = new List<Pedido>();
    }

    void fechaMesa() {
        this.fechamento = new DateTime.now();
    }

    int novoPedido(Item item){
        Pedido p = new Pedido(item, this);
        pedidos.add(p);
        return pedidos.length-1;
    }

    @override
    String toString() {
        return 'Mesa{numeroMesa: $numeroMesa, abertura: $abertura, fechamento: $fechamento, pedidos: $pedidos}';
    }

    void cancelaPedido(int pedido) {
            pedidos[pedido].cancelaPedido();
            pedidos.removeAt(pedido);
    }

}

class Pedido {
    int id;
    DateTime pedido;
    Mesa mesa;
    Item item;
    String obs;
    Estado estado;

    Pedido(Item item, Mesa mesa) {
        pedido = new DateTime.now();
        id = pedido.millisecondsSinceEpoch;
        this.mesa = mesa;
        this.item = item;
    }

    void cancelaPedido(){
        this.estado = Estado.cancelado;
    }

    @override
    String toString() {
        return 'Pedido{id: $id, pedido: $pedido, mesa: ${mesa.numeroMesa}, item: ${item}, obs: $obs, estado: $estado}';
    }
}

class Item {
    int id;
    String nome;
    String foto;
    String descricao;
    double valor;

    Item(this.id, this.nome, this.foto, this.descricao, this.valor);

}