-- Criando o banco de dados
CREATE DATABASE SistemaClientes;
USE SistemaClientes;

-- Tabela de Clientes (Pessoa Jurídica ou Física)
CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    tipo_cliente ENUM('PJ', 'PF') NOT NULL,
    nome VARCHAR(255) NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255),
    telefone VARCHAR(20)
);

-- Tabela de Formas de Pagamento
CREATE TABLE Pagamentos (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL
);

-- Tabela de Pedidos
CREATE TABLE Pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente) ON DELETE CASCADE
);

-- Tabela de Itens do Pedido
CREATE TABLE Itens (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido) ON DELETE CASCADE
);

-- Tabela de Produtos
CREATE TABLE Produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(255) NOT NULL,
    id_fornecedor INT NOT NULL,
    estoque INT DEFAULT 0,
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedores(id_fornecedor) ON DELETE CASCADE
);

-- Tabela de Fornecedores
CREATE TABLE Fornecedores (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome_fornecedor VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(255)
);

-- Tabela de Entregas
CREATE TABLE Entregas (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    status_entrega ENUM('Pendente', 'Enviado', 'Entregue', 'Cancelado') NOT NULL,
    codigo_rastreio VARCHAR(50),
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido) ON DELETE CASCADE
);

-- Associando Clientes e Formas de Pagamento (Relacionamento N:N)
CREATE TABLE ClientePagamentos (
    id_cliente INT NOT NULL,
    id_pagamento INT NOT NULL,
    PRIMARY KEY (id_cliente, id_pagamento),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (id_pagamento) REFERENCES Pagamentos(id_pagamento) ON DELETE CASCADE
);

-- Inserção de dados de exemplo
INSERT INTO Clientes (tipo_cliente, nome, cpf_cnpj, email, telefone) VALUES
('PF', 'João Silva', '12345678900', 'joao@email.com', '11999999999'),
('PJ', 'Empresa ABC', '98765432000100', 'contato@empresaabc.com', '1122223333');

INSERT INTO Pagamentos (descricao) VALUES ('Cartão de Crédito'), ('Boleto'), ('Pix');

INSERT INTO Fornecedores (nome_fornecedor, telefone, email) VALUES
('Fornecedor A', '11988887777', 'fornecedora@email.com'),
('Fornecedor B', '11977776666', 'fornecedorb@email.com');

INSERT INTO Produtos (nome_produto, id_fornecedor, estoque) VALUES
('Produto 1', 1, 100),
('Produto 2', 2, 50);

INSERT INTO Pedidos (id_cliente) VALUES (1), (2);

INSERT INTO Itens (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 2, 50.00),
(2, 2, 1, 100.00);

INSERT INTO Entregas (id_pedido, status_entrega, codigo_rastreio) VALUES
(1, 'Enviado', 'BR1234567890'),
(2, 'Pendente', NULL);

 Queries exemplos

-- 1. Quantos pedidos foram feitos por cada cliente?
SELECT 
    c.nome AS cliente,
    COUNT(p.id_pedido) AS total_pedidos
FROM 
    Clientes c
LEFT JOIN 
    Pedidos p ON c.id_cliente = p.id_cliente
GROUP BY 
    c.nome;

-- 2. Algum vendedor também é fornecedor?
SELECT 
    c.nome AS vendedor, 
    f.nome_fornecedor AS fornecedor
FROM 
    Clientes c
INNER JOIN 
    Fornecedores f ON c.nome = f.nome_fornecedor;

-- 3. Relação de produtos, fornecedores e estoques
SELECT 
    p.nome_produto AS produto,
    f.nome_fornecedor AS fornecedor,
    p.estoque
FROM 
    Produtos p
INNER JOIN 
    Fornecedores f ON p.id_fornecedor = f.id_fornecedor;

-- 4. Relação de nomes dos fornecedores e nomes dos produtos
SELECT 
    f.nome_fornecedor AS fornecedor,
    p.nome_produto AS produto
FROM 
    Fornecedores f
INNER JOIN 
    Produtos p ON f.id_fornecedor = p.id_fornecedor;
