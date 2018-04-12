enum Estado {em_espera, preparando, pronto, cancelado}

class Restaurante {
    Map<int,Item> cardapio;
    Map<int,Mesa> saguao;

    Restaurante() {
        cardapio = new Map<int,Item>();
        saguao = new Map<int,Mesa>();
    }

    void abreMesa(int num){
        saguao[num] = new Mesa(num);
    }

    void fechaMesa(int num){
        saguao[num].fechaMesa();
        //TODO query para armazenar no bd
        saguao[num] = null;
    }

    int novoPedido(int item, int mesa){
        return saguao[mesa].novoPedido(cardapio[item]);
    }

    void cancelaPedido(int pedido, int mesa){
        //TODO conferir se pode remover o pedido
        saguao[mesa].cancelaPedido(pedido);
        //TODO query para alterar no bd
    }

}

class Mesa {
    int numeroMesa;
    DateTime abertura;
    DateTime fechamento;
    List<Pedido> pedidos;
    bool fechada;

    Mesa(int num) {
        this.numeroMesa = num;
        abertura = new DateTime.now();
        fechamento = null;
        pedidos = new List<Pedido>();
        fechada = false;
    }

    void fechaMesa() {
        this.fechada = true;
    }

    int novoPedido(Item item){
        Pedido p = new Pedido(item, this);
        pedidos[p.id] = p;;
        return p.id;
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
}

class Item {
    int id;
    String nome;
    String foto;
    String icone;
    double valor;

    Item(this.id, this.nome, this.foto, this.icone, this.valor);

}