CREATE DATABASE GerenciamentoDePedido;

-- INICIO DA ETAPA 1 

	CREATE TABLE IF NOT EXISTS Cliente (
	id_cliente int primary key auto_increment,
	nome_cliente varchar(100),
	telefone_cliente varchar(12)
	);

	CREATE TABLE IF NOT EXISTS Pedido(
	id_pedido int primary key auto_increment,
	id_cliente_pedido int not null,
    id_produto int not null,
	nome_produto varchar(60) not null,
	quantidade_produto int not null, 
	FOREIGN KEY (id_cliente_pedido) references Cliente(id_cliente),
    FOREIGN KEY (id_produto) references Produto(id_produto)
	);
    
    CREATE TABLE iF NOT EXISTS Produto (
    id_produto int primary key auto_increment,
    nome_produto varchar(90),
    valor_produto decimal(10,2)
    );
    
    
-- INSERINDO DADOS NA TABELA CLIENTE 

INSERT INTO Cliente (nome_cliente, telefone_cliente) VALUES
('John Lennon', '123-456789'),
('Paul McCartney', '987-654321'),
('Jimi Hendrix', '111-222333'),
('Freddie Mercury', '444-555666'),
('Elvis Presley', '777-888999'),
('Bob Dylan', '555-444333'),
('David Bowie', '222-333444'),
('Prince', '111-222333'),
('Michael Jackson', '999-888777'),
('Miles Davis', '666-555444');

-- INSERINDO DADOS NA TABELA PRODUTO

INSERT INTO Produto (nome_produto, valor_produto) VALUES
('Guitarra', 799.99),
('Baixo', 599.99),
('Teclado', 899.99),
('Bateria', 1499.99),
('Microfone', 129.99),
('Violão', 499.99),
('Saxofone', 899.99),
('Piano', 1499.99),
('Trompete', 599.99),
('Flauta', 299.99);


-- INSERINDO DADOS NA TABELA PEDIDO

INSERT INTO Pedido (id_cliente_pedido, id_produto, nome_produto, quantidade_produto) VALUES
(1, 1, 'Guitarra', 2),
(2, 2, 'Baixo', 1),
(3, 3, 'Teclado', 3),
(4, 4, 'Bateria', 2),
(5, 5, 'Microfone', 1),
(6, 6, 'Violão', 2),
(7, 7, 'Saxofone', 1),
(8, 8, 'Piano', 1),
(9, 9, 'Trompete', 2),
(10, 10, 'Flauta', 1);


-- FIM DA ETAPA 1

-- INICIO ETAPA 2 

DELIMITER $ 

CREATE PROCEDURE InserirPedido(in id_cliente int,in id_produto int, in nome_produto varchar(60),in quantidade_produto int)
BEGIN 

INSERT INTO Pedido (id_cliente_pedido, id_produto, nome_produto,quantidade_produto) values (id_cliente,id_produto, nome_produto,quantidade_produto);
SELECT 'OK' as Status_Atual;

end $ 



CALL InserirPedido(1,'Baixo Hofner',1);

CALL InserirPedido(1, 1, 'Guitarra', 2);
CALL InserirPedido(2, 2, 'Baixo', 1);
CALL InserirPedido(3, 3, 'Teclado', 3);
CALL InserirPedido(4, 4, 'Bateria', 2);
CALL InserirPedido(5, 5, 'Microfone', 1);

-- TESTE DE PROCEDURE  SELECT * FROM Pedido;

-- CRIÇÃO DA TRIGGER

CREATE TRIGGER atualizarTotalPedidos
AFTER INSERT ON Pedido
FOR EACH ROW
BEGIN
  UPDATE Cliente
  SET TotalPedidos = TotalPedidos + NEW.quantidade_produto * (
      SELECT valor_produto
      FROM Produto
      WHERE id_produto = NEW.id_produto
  )
  WHERE id_cliente = NEW.id_cliente_pedido;
END;


CALL InserirPedido(1, 1, 'Guitarra', 2);

-- CRIACAO DA VIEW 
CREATE VIEW PedidosClientes AS
SELECT
  Pedido.id_pedido,
  Pedido.id_cliente_pedido,
  Cliente.nome_cliente,
  Pedido.nome_produto,
  Pedido.quantidade_produto
FROM
  Pedido
JOIN
  Cliente ON Pedido.id_cliente_pedido = Cliente.id_cliente;
  
 
 -- CRIACAO DO SELECT COM JOIN (ESSE DEU DOR DE CABEÇA)
SELECT
  PedidosClientes.id_pedido as ID_PEDIDO,
  Cliente.nome_cliente as NOME_CLIENTE,
  PedidosClientes.nome_produto as NOME_PRODUTO,
  PedidosClientes.quantidade_produto as QTE_PRODUTO,
  Produto.valor_produto * PedidosClientes.quantidade_produto AS VALOR_TOTAL
FROM
  PedidosClientes
JOIN
  Produto ON PedidosClientes.nome_produto = Produto.nome_produto
JOIN
  Cliente ON PedidosClientes.id_cliente_pedido = Cliente.id_cliente;
  
  
