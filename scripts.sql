CREATE TABLE clientes(
	codigo INT AUTO_INCREMENT, 
	nome VARCHAR(40) NOT NULL, 
	cidade VARCHAR(30) NOT NULL, 
	uf CHAR(2) NOT NULL,
	PRIMARY KEY (codigo)
);

CREATE TABLE produtos(
	codigo INT AUTO_INCREMENT, 
	descricao VARCHAR(40), 
	preco DOUBLE(8,4) NOT NULL,
	PRIMARY KEY (codigo)
);

CREATE TABLE pedidos(
	numero INT AUTO_INCREMENT, 
	data_emissao DATE NOT NULL, 
	cod_cliente INT NOT NULL, 
	vlTot DOUBLE(8,4),
	PRIMARY KEY (numero),
	FOREIGN KEY (cod_cliente) REFERENCES clientes(codigo)
);

CREATE TABLE ped_prod(
	codigo INT AUTO_INCREMENT, 
	num_pedido INT NOT NULL, 
	cod_prod INT NOT NULL, 
	qtd INT NOT NULL,
	vlTot DOUBLE(8,4),
	vlUni DOUBLE(8,4),
	PRIMARY KEY (codigo),
	FOREIGN KEY (num_pedido) REFERENCES pedidos(numero),
	FOREIGN KEY (cod_prod) REFERENCES produtos(codigo)
);

INSERT INTO clientes(nome, cidade, uf) VALUES ('Kelmer Souza Passos', 'Salvador', 'BA'),
('Rodrigo Lima Barreto', 'Salvador', 'BA'),
('Carlos Julio Lima', 'Salvador', 'BA'),
('Pedro Marciel Novais', 'Salvador', 'BA'),
('Camilo Mezenga Souza', 'Salvador', 'BA'),
('Adriel Lucas Pinheiro', 'Salvador', 'BA'),
('Gabriele Pineheiro de Santana', 'Lauro de Freitas', 'BA'),
('Carlos Salgado Junior', 'Lauro de Freitas', 'BA'),
('Samuel Pereira Gomes', 'Lauro de Freitas', 'BA'),
('Felipe Santana Pimentel', 'Lauro de Freitas', 'BA'),
('Gioberto Aloisio Pereira', 'Lauro de Freitas', 'BA'),
('Giovane Souza Santos', 'Lauro de Freitas', 'BA'),
('Kauan Pinheiro Pimentel', 'Lauro de Freitas', 'BA'),
('Lucas Santos Silva', 'Lauro de Freitas', 'BA'),
('Gabriel Silva Junior', 'Lauro de Freitas', 'BA'),
('Eduardo Couto Novais', 'Cama�ari', 'BA'),
('Eduarda Couto Novais', 'Cama�ari', 'BA'),
('Pedro Pinheiro Passos', 'Cama�ari', 'BA'),
('Elisa Melo Lima', 'Cama�ari', 'BA'),
('Adriele Melo Silva', 'Cama�ari', 'BA'),
('Rodrigo Santos de Cardoso', 'Cama�ari', 'BA'),
('Bruno Mendes Santos', 'Cama�ari', 'BA'),
('Bruno Almeida de Santana', 'Cama�ari', 'BA');

INSERT INTO produtos (descricao, preco) VALUES ('Feij�o Kikaldo', 5.40), 
('Feij�o Tio Mingote ', 5.00),('Caldo Kinor Grande', 3.20),
('Caldo Kinor Pequeno', 1.50),('Arroz Tio Mingote', 3.40),
('Arroz Aura', 3.10),('Arroz Emo��es', 4.00),
('Farinha Tapi', 5.00),('Farinha Emo��es', 5.40),
('Sab�o OMO', 6.19),('Detergente Minuano', 2.99),
('Detergente Ala', 2.50),('Sabonete LUX', 1.29),
('Sabonete Dove', 3.99),('Creme Dental Colgate', 2.60),
('Creme Dental Oral B', 3.19),('Ol�o de Soja Soia', 7.39),
('Desodorante Monange', 7.40),('Desodorante Rexona', 10.39),
('Cerveja Heinelem 275ml', 3.80),('Cerveja Budwaiser 275ml', 2.99);