CREATE DATABASE oficina;
USE oficina;

-- CLIENTE

CREATE TABLE cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    telefone VARCHAR(20)
);

-- EQUIPE

CREATE TABLE equipe (
    idEquipe INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100),
    possui_pecas BOOLEAN
);


-- MECANICO

CREATE TABLE mecanico (
    idMecanico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    endereco VARCHAR(100),
    codigo VARCHAR(50),
    especialidade VARCHAR(50),
    idEquipe INT,
    FOREIGN KEY (idEquipe) REFERENCES equipe(idEquipe)
);


-- VEICULO

CREATE TABLE veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(50),
    placa VARCHAR(20),
    idCliente INT,
    idEquipe INT,
    FOREIGN KEY (idCliente) REFERENCES cliente(idCliente),
    FOREIGN KEY (idEquipe) REFERENCES equipe(idEquipe)
);

-- ORDEM DE SERVIÇO

CREATE TABLE ordem_servico (
    idOrdem INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(50),
    data_emissao DATE,
    valor_servico FLOAT,
    data_conclusao DATE,
    status VARCHAR(50),
    idEquipe INT,
    FOREIGN KEY (idEquipe) REFERENCES equipe(idEquipe)
);


-- AUTORIZAÇÃO

CREATE TABLE autorizacao (
    idAutorizacao INT AUTO_INCREMENT PRIMARY KEY,
    idOrdem INT,
    idEquipe INT,
    idCliente INT,
    autorizado BOOLEAN,
    FOREIGN KEY (idOrdem) REFERENCES ordem_servico(idOrdem),
    FOREIGN KEY (idEquipe) REFERENCES equipe(idEquipe),
    FOREIGN KEY (idCliente) REFERENCES cliente(idCliente)
);


-- PEÇAS

CREATE TABLE pecas (
    idPeca INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100),
    valor FLOAT,
    idOrdem INT,
    FOREIGN KEY (idOrdem) REFERENCES ordem_servico(idOrdem)
);


-- MÃO DE OBRA

CREATE TABLE mao_obra (
    idMaoObra INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100),
    valor FLOAT,
    idOrdem INT,
    FOREIGN KEY (idOrdem) REFERENCES ordem_servico(idOrdem)
);


-- DADOS FICTICIOS

INSERT INTO cliente (nome, telefone) VALUES
('João', '1111-1111'),
('Maria', '2222-2222');

INSERT INTO equipe (descricao, possui_pecas) VALUES
('Equipe A', TRUE),
('Equipe B', FALSE);

INSERT INTO mecanico (nome, endereco, codigo, especialidade, idEquipe) VALUES
('Carlos', 'Rua A', 'M001', 'Motor', 1),
('Pedro', 'Rua B', 'M002', 'Freio', 1);

INSERT INTO veiculo (modelo, placa, idCliente, idEquipe) VALUES
('Gol', 'ABC1234', 1, 1),
('Civic', 'XYZ9876', 2, 2);

INSERT INTO ordem_servico (numero, data_emissao, valor_servico, data_conclusao, status, idEquipe) VALUES
('OS001', '2025-01-01', 500, '2025-01-05', 'Concluido', 1);


-- PERGUNTAS

-- Quantas ordens por cliente?
SELECT c.nome, COUNT(o.idOrdem) AS total FROM cliente c
	JOIN veiculo v ON c.idCliente = v.idCliente
	JOIN ordem_servico o ON v.idEquipe = o.idEquipe
	GROUP BY c.nome;
    
-- Ordens acima de 500
SELECT * FROM ordem_servico
	WHERE valor_servico > 500;
    
-- Valor total (peça + mão de obra)
SELECT o.idOrdem, SUM(p.valor) + SUM(m.valor) AS total FROM ordem_servico o
	LEFT JOIN pecas p ON o.idOrdem = p.idOrdem
	LEFT JOIN mao_obra m ON o.idOrdem = m.idOrdem
	GROUP BY o.idOrdem;
    
-- Mecânicos por equipe
SELECT e.descricao, COUNT(m.idMecanico) FROM equipe e
	JOIN mecanico m ON e.idEquipe = m.idEquipe
	GROUP BY e.descricao;
    
    
    
    