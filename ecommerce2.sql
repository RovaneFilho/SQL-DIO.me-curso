DROP DATABASE IF EXISTS ecommerce2;
CREATE DATABASE ecommerce2;
USE ecommerce2;



-- CLIENTES
CREATE TABLE clients(
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(20),
    Minit CHAR(3),
    Lname VARCHAR(20),
    CPF CHAR(11) UNIQUE,
    Address VARCHAR(255)
);

-- PRODUTOS
CREATE TABLE product(
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(255) NOT NULL,
    category ENUM('Eletronico','Vestimenta','Brinquedos','Alimentos','Moveis'),
    price FLOAT NOT NULL
);

-- PEDIDOS
CREATE TABLE orders(
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('Cancelado','Confirmado','Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (idOrderClient) REFERENCES clients(idClient)
);

-- RELAÇÃO PRODUTO-PEDIDO
CREATE TABLE productOrder(
    idProduct INT,
    idOrder INT,
    quantity INT DEFAULT 1,
    PRIMARY KEY (idProduct, idOrder),
    FOREIGN KEY (idProduct) REFERENCES product(idProduct),
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);



INSERT INTO clients (Fname, Minit, Lname, CPF, Address) VALUES
					('Maria','M','Silva','12345678901','Fortaleza'),
					('Joao','A','Souza','98765432100','Ceara'),
					('Ana','B','Costa','11122233344','São Paulo');

INSERT INTO product (Pname, category, price) VALUES
					('Fone','Eletronico',200),
					('Camisa','Vestimenta',80),
					('Boneca','Brinquedos',150);

INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) VALUES
					(1,'Confirmado','Compra app',20,1),
					(2,'Em processamento','Compra site',15,0);

INSERT INTO productOrder (idProduct, idOrder, quantity) VALUES
							(1,1,2),
							(2,2,1);



SET autocommit = 0;

START TRANSACTION;

-- Consulta
SELECT * FROM clients WHERE idClient = 1;

-- Atualização
UPDATE clients 
	SET Address = 'Endereco atualizado - CE'
	WHERE idClient = 1;

-- Inserção de pedido
INSERT INTO orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
VALUES (1,'Confirmado','Nova compra',30,1);

-- Conferência
SELECT * FROM orders WHERE idOrderClient = 1;

-- Finalização
COMMIT;

-- ROLLBACK; -- usar para testes


DELIMITER //

CREATE PROCEDURE control_transaction(IN opcao INT)
BEGIN
    DECLARE erro BOOL DEFAULT FALSE;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    SET erro = TRUE;

    START TRANSACTION;

    SAVEPOINT inicio;

    IF opcao = 1 THEN
        INSERT INTO clients (Fname, Minit, Lname, CPF, Address)
        VALUES ('Carlos','C','Silva','55566677788','Rio de Janeiro');

    ELSEIF opcao = 2 THEN
        UPDATE clients 
        SET Address = 'Atualizado via procedure'
        WHERE idClient = 2;

    ELSEIF opcao = 3 THEN
        DELETE FROM clients WHERE idClient = 3;

    END IF;

    IF erro THEN
        ROLLBACK TO inicio;
        SELECT 'Erro detectado - rollback executado' AS resultado;
    ELSE
        COMMIT;
        SELECT 'Sucesso na transacao' AS resultado;
    END IF;

END //

DELIMITER ;



CALL control_transaction(1); -- INSERT
CALL control_transaction(2); -- UPDATE
CALL control_transaction(3); -- DELETE



SELECT * FROM clients;
SELECT * FROM orders;
SELECT * FROM product;
SELECT * FROM productOrder;