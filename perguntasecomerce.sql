
-- Quantos pedidos foram feitos por cada cliente?

SELECT c.idClient, CONCAT(c.Fname, ' ', c.Lname) AS Cliente, COUNT(o.idOrder) AS Total_Pedidos
	FROM clients c
	LEFT JOIN orders o ON c.idClient = o.idOrderClient
	GROUP BY c.idClient, c.Fname, c.Lname;



-- Quais clientes fizeram mais de um pedido?
SELECT c.idClient, c.Fname, COUNT(o.idOrder) AS Total_Pedidos
	FROM clients c
	INNER JOIN orders o ON c.idClient = o.idOrderClient
	GROUP BY c.idClient, c.Fname
	HAVING COUNT(o.idOrder) > 1;

 
-- Quais pedidos estão confirmados?

SELECT * FROM orders
	WHERE orderStatus = 'Confirmado';


-- Qual o valor total com frete (atributo derivado)?
SELECT idOrder, sendValue, (sendValue * 1.1) AS Total_Com_Taxa FROM orders;



-- Liste os clientes em ordem alfabética
SELECT Fname, Lname FROM clients
	ORDER BY Fname ASC;



-- Quais produtos estão em cada pedido?
SELECT o.idOrder, p.Pname, po.poQuantity FROM orders o
	INNER JOIN productOrder po ON o.idOrder = po.idOrder
	INNER JOIN product p ON p.idProduct = po.idProduct;



-- Quais produtos foram mais vendidos?
SELECT p.Pname, SUM(po.poQuantity) AS Total_Vendido FROM product p
	INNER JOIN productOrder po ON p.idProduct = po.idProduct
	GROUP BY p.Pname
	ORDER BY Total_Vendido DESC;


-- Quais clientes não fizeram pedidos?

SELECT c.Fname, c.Lname FROM clients c
	LEFT JOIN orders o ON c.idClient = o.idOrderClient
	WHERE o.idOrder IS NULL;



-- Relação de produtos, fornecedores e quantidades
SELECT p.Pname AS Produto, s.SocialName AS Fornecedor, ps.quantity FROM product p
	INNER JOIN productSupplier ps ON p.idProduct = ps.idProduct
	INNER JOIN supplier s ON s.idSupplier = ps.idSupplier;



-- Relação de fornecedores e produtos
SELECT s.SocialName AS Fornecedor, p.Pname AS Produto FROM supplier s
	INNER JOIN productSupplier ps ON s.idSupplier = ps.idSupplier
	INNER JOIN product p ON p.idProduct = ps.idProduct;



-- Existe vendedor que também é fornecedor?
SELECT s.SocialName AS Vendedor, f.SocialName AS Fornecedor FROM seller s
	INNER JOIN supplier f ON s.CNPJ = f.CNPJ;



-- Produtos em estoque por localização
SELECT p.Pname, ps.storageLocation, ps.quantity FROM product p
	INNER JOIN storageLocation sl ON p.idProduct = sl.idProduct
	INNER JOIN productStorage ps ON ps.idProdStorage = sl.idStorage;



-- Média de avaliação dos produtos por categoria
SELECT category, AVG(rating) AS Media_Avaliacao FROM product
	GROUP BY category;


-- Pedidos com valor de frete maior que 50
SELECT * FROM orders
	WHERE sendValue > 50;



-- Quantidade total de produtos por pedido
SELECT o.idOrder, SUM(po.poQuantity) AS Total_Produtos FROM orders o
	INNER JOIN productOrder po ON o.idOrder = po.idOrder
	GROUP BY o.idOrder;
    
    