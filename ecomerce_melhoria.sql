USE ecommerce;


-- CLIENTES

CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Minit CHAR(3),
    Lname VARCHAR(50) NOT NULL,
    CPF CHAR(11) NOT NULL,
    Address VARCHAR(255),
    CONSTRAINT unique_cpf_client UNIQUE (CPF)
);


-- PRODUTOS

CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(255) NOT NULL,
    classification_kids BOOLEAN DEFAULT FALSE,
    category ENUM('Eletronico','Vestimenta','Brinquedos','Alimentos','Moveis') NOT NULL,
    rating FLOAT DEFAULT 0,
    size VARCHAR(20)
);


-- PAGAMENTOS

CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT,
    idClient INT,
    typePayment ENUM('Boleto','Cartao','Dois_cartoes') NOT NULL,
    limitAvailable FLOAT,
    PRIMARY KEY (idPayment, idClient),
    CONSTRAINT fk_payment_client FOREIGN KEY (idClient)
        REFERENCES clients(idClient)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- PEDIDOS

CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('Cancelado','Confirmado','Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_orders_client FOREIGN KEY (idOrderClient)
        REFERENCES clients(idClient)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- ESTOQUE

CREATE TABLE productStorage (
    idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);


-- FORNECEDOR

CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);


-- VENDEDOR

CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    AbstName VARCHAR(255),
    CNPJ CHAR(15),
    CPF CHAR(11),
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);


-- RELACIONAMENTO PRODUTO-VENDEDOR

CREATE TABLE productSeller (
    idSeller INT,
    idProduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idSeller, idProduct),
    CONSTRAINT fk_ps_seller FOREIGN KEY (idSeller)
        REFERENCES seller(idSeller),
    CONSTRAINT fk_ps_product FOREIGN KEY (idProduct)
        REFERENCES product(idProduct)
);


-- RELACIONAMENTO PRODUTO-PEDIDO

DROP TABLE productOrder;

CREATE TABLE productOrder (
    idProduct INT,
    idOrder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponivel','Sem_estoque') DEFAULT 'Disponivel',
    PRIMARY KEY (idProduct, idOrder),
    CONSTRAINT fk_po_product FOREIGN KEY (idProduct)
        REFERENCES product(idProduct),
    CONSTRAINT fk_po_order FOREIGN KEY (idOrder)
        REFERENCES orders(idOrder)
);


-- LOCALIZAÇÃO DO ESTOQUE
DROP TABLE storageLocation;
CREATE TABLE storageLocation (
    idProduct INT,
    idStorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idProduct, idStorage),
    CONSTRAINT fk_sl_product FOREIGN KEY (idProduct)
        REFERENCES product(idProduct),
    CONSTRAINT fk_sl_storage FOREIGN KEY (idStorage)
        REFERENCES productStorage(idProdStorage)
);


-- RELAÇÃO PRODUTO-FORNECEDOR
DROP TABLE productSupplier;

CREATE TABLE productSupplier (
    idSupplier INT,
    idProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idSupplier, idProduct),
    CONSTRAINT fk_psupplier_supplier FOREIGN KEY (idSupplier)
        REFERENCES supplier(idSupplier),
    CONSTRAINT fk_psupplier_product FOREIGN KEY (idProduct)
        REFERENCES product(idProduct)
);


SHOW TABLES;