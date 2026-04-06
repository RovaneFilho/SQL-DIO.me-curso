
USE ecommerce;


-- Índice para melhorar JOIN entre clients e orders
CREATE INDEX idx_orders_client 
ON orders(idOrderClient);

-- Índice para agrupamento por localização (cidade)
CREATE INDEX idx_seller_location 
ON seller(location);

-- Índices para melhorar JOIN entre orders, productOrder e product
CREATE INDEX idx_productOrder_order 
ON productOrder(idOrder);

CREATE INDEX idx_productOrder_product 
ON productOrder(idProduct);



-- Cliente com maior número de pedidos
SELECT 
    c.idClient,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    COUNT(o.idOrder) AS total_pedidos
FROM clients c
JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient
ORDER BY total_pedidos DESC
LIMIT 1;

-- Vendedores por cidade
SELECT 
    location,
    COUNT(idSeller) AS total_vendedores
FROM seller
GROUP BY location
ORDER BY total_vendedores DESC;

-- Relação de produtos por pedido
SELECT 
    o.idOrder,
    p.Pname,
    po.poQuantity
FROM orders o
JOIN productOrder po ON o.idOrder = po.idOrder
JOIN product p ON p.idProduct = po.idProduct;


DELIMITER $$

CREATE PROCEDURE manage_clients (
    IN p_option INT,
    IN p_id INT,
    IN p_fname VARCHAR(50),
    IN p_lname VARCHAR(50),
    IN p_cpf CHAR(11)
)
BEGIN

    -- INSERIR
    IF p_option = 1 THEN
        INSERT INTO clients (Fname, Lname, CPF)
        VALUES (p_fname, p_lname, p_cpf);

    -- ATUALIZAR
    ELSEIF p_option = 2 THEN
        UPDATE clients 
        SET Fname = p_fname, Lname = p_lname
        WHERE idClient = p_id;

    -- DELETAR
    ELSEIF p_option = 3 THEN
        DELETE FROM clients
        WHERE idClient = p_id;

    -- CONSULTAR
    ELSEIF p_option = 4 THEN
        SELECT * FROM clients WHERE idClient = p_id;

    END IF;

END $$

DELIMITER ;


-- Inserir cliente
CALL manage_clients(1, NULL, 'Carlos', 'Silva', '12345678900');

-- Atualizar cliente
CALL manage_clients(2, 1, 'Carlos', 'Souza', NULL);

-- Consultar cliente
CALL manage_clients(4, 1, NULL, NULL, NULL);

-- Deletar cliente
CALL manage_clients(3, 1, NULL, NULL, NULL);