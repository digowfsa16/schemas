-- Criação do banco de dados\CREATE DATABASE OficinaMecanica;
USE OficinaMecanica;

-- Tabela para os clientes
CREATE TABLE Clientes (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Endereco VARCHAR(255),
    Telefone VARCHAR(15),
    Email VARCHAR(100)
);

-- Tabela para os veículos
CREATE TABLE Veiculos (
    VeiculoID INT AUTO_INCREMENT PRIMARY KEY,
    ClienteID INT NOT NULL,
    Placa VARCHAR(10) NOT NULL UNIQUE,
    Modelo VARCHAR(100) NOT NULL,
    Ano INT NOT NULL,
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

-- Tabela para os mecânicos
CREATE TABLE Mecanicos (
    MecanicoID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Endereco VARCHAR(255),
    Telefone VARCHAR(15),
    Especialidade VARCHAR(100) NOT NULL
);

-- Tabela para ordens de serviço (OS)
CREATE TABLE OrdensDeServico (
    OSID INT AUTO_INCREMENT PRIMARY KEY,
    VeiculoID INT NOT NULL,
    DataEmissao DATE NOT NULL,
    DataConclusao DATE,
    ValorTotal DECIMAL(10, 2),
    Status ENUM('Pendente', 'Aprovada', 'Concluída') DEFAULT 'Pendente',
    FOREIGN KEY (VeiculoID) REFERENCES Veiculos(VeiculoID)
);

-- Tabela para serviços
CREATE TABLE Servicos (
    ServicoID INT AUTO_INCREMENT PRIMARY KEY,
    Descricao VARCHAR(255) NOT NULL,
    ValorMaoDeObra DECIMAL(10, 2) NOT NULL
);

-- Tabela para itens de serviços da OS
CREATE TABLE OS_Servicos (
    OSServicoID INT AUTO_INCREMENT PRIMARY KEY,
    OSID INT NOT NULL,
    ServicoID INT NOT NULL,
    Quantidade INT NOT NULL DEFAULT 1,
    Valor DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OSID) REFERENCES OrdensDeServico(OSID),
    FOREIGN KEY (ServicoID) REFERENCES Servicos(ServicoID)
);

-- Tabela para peças
CREATE TABLE Pecas (
    PecaID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Valor DECIMAL(10, 2) NOT NULL
);

-- Tabela para itens de peças da OS
CREATE TABLE OS_Pecas (
    OSPecaID INT AUTO_INCREMENT PRIMARY KEY,
    OSID INT NOT NULL,
    PecaID INT NOT NULL,
    Quantidade INT NOT NULL DEFAULT 1,
    Valor DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OSID) REFERENCES OrdensDeServico(OSID),
    FOREIGN KEY (PecaID) REFERENCES Pecas(PecaID)
);

-- Tabela para equipes de mecânicos
CREATE TABLE Equipes (
    EquipeID INT AUTO_INCREMENT PRIMARY KEY,
    NomeEquipe VARCHAR(100) NOT NULL
);

-- Relacionamento entre mecânicos e equipes
CREATE TABLE EquipeMecanicos (
    EquipeMecanicoID INT AUTO_INCREMENT PRIMARY KEY,
    EquipeID INT NOT NULL,
    MecanicoID INT NOT NULL,
    FOREIGN KEY (EquipeID) REFERENCES Equipes(EquipeID),
    FOREIGN KEY (MecanicoID) REFERENCES Mecanicos(MecanicoID)
);

-- Relacionamento entre equipes e ordens de serviço
CREATE TABLE EquipeOS (
    EquipeOSID INT AUTO_INCREMENT PRIMARY KEY,
    EquipeID INT NOT NULL,
    OSID INT NOT NULL,
    FOREIGN KEY (EquipeID) REFERENCES Equipes(EquipeID),
    FOREIGN KEY (OSID) REFERENCES OrdensDeServico(OSID)
);
