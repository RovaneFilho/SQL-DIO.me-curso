USE company_constraints;


DROP TRIGGER IF EXISTS superssn_check;
DROP TRIGGER IF EXISTS null_value_check;
DROP TRIGGER IF EXISTS salary_update_check;
DROP TRIGGER IF EXISTS backup_employee_before_delete;

DROP TABLE IF EXISTS user_messages;
DROP TABLE IF EXISTS employee_backup;


CREATE TABLE user_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(100),
    ssn CHAR(9),
    CONSTRAINT fk_ssn_messages FOREIGN KEY (ssn) REFERENCES employee(Ssn)
);


CREATE TABLE employee_backup (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(50),
    Lname VARCHAR(50),
    Ssn CHAR(9),
    Salary DECIMAL(10,2),
    Dno INT,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //

CREATE TRIGGER superssn_check
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    CASE NEW.Dno
        WHEN 1 THEN SET NEW.Super_ssn = '333445555';
        WHEN 2 THEN SET NEW.Super_ssn = NULL;
        WHEN 3 THEN SET NEW.Super_ssn = NULL;
        WHEN 4 THEN SET NEW.Super_ssn = '123456789';
        WHEN 5 THEN SET NEW.Super_ssn = '987654321';
    END CASE;
END;
//

DELIMITER ;


DELIMITER //

CREATE TRIGGER null_value_check
AFTER INSERT ON employee
FOR EACH ROW
BEGIN
    IF NEW.Address IS NULL THEN
        INSERT INTO user_messages (message, ssn)
        VALUES (CONCAT('Atualize seu endereço: ', NEW.Fname), NEW.Ssn);
    ELSE
        INSERT INTO user_messages (message, ssn)
        VALUES (CONCAT('Cadastro realizado: ', NEW.Fname), NEW.Ssn);
    END IF;
END;
//

DELIMITER ;


DELIMITER //

CREATE TRIGGER salary_update_check
BEFORE UPDATE ON employee
FOR EACH ROW
BEGIN
    IF NEW.Dno = 1 THEN
        SET NEW.Salary = NEW.Salary * 1.20;
    END IF;
END;
//

DELIMITER ;

DELIMITER //

CREATE TRIGGER backup_employee_before_delete
BEFORE DELETE ON employee
FOR EACH ROW
BEGIN
    INSERT INTO employee_backup (Fname, Lname, Ssn, Salary, Dno)
    VALUES (OLD.Fname, OLD.Lname, OLD.Ssn, OLD.Salary, OLD.Dno);
END;
//

DELIMITER ;


-- Inserção (testa BEFORE INSERT + AFTER INSERT)
INSERT INTO employee 
(Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
VALUES 
('João', 'B', 'Silva', '111222333', '1990-01-01', NULL, 'M', 30000, NULL, 1);

-- Verificar dados
SELECT * FROM employee;
SELECT * FROM user_messages;

-- Testar UPDATE (aumento automático)
UPDATE employee
SET Salary = 10000
WHERE Dno = 1;

SELECT * FROM employee;

-- Testar DELETE (backup)
DELETE FROM employee
WHERE Ssn = '111222333';

-- Verificar backup
SELECT * FROM employee_backup;

-- Ver triggers
SHOW TRIGGERS;


-- Modelo E-commerce


USE ecommerce;


DROP TRIGGER IF EXISTS before_insert_order;
DROP TRIGGER IF EXISTS after_insert_order;
DROP TRIGGER IF EXISTS before_update_order;
DROP TRIGGER IF EXISTS before_delete_order;

DROP TABLE IF EXISTS order_logs;
DROP TABLE IF EXISTS deleted_orders;


CREATE TABLE order_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(255),
    order_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE deleted_orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    idClient INT,
    status VARCHAR(50),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


DELIMITER //

CREATE TRIGGER before_insert_order
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    IF NEW.sendValue IS NULL THEN
        SET NEW.sendValue = 10;
    END IF;

    IF NEW.orderStatus IS NULL THEN
        SET NEW.orderStatus = 'Em processamento';
    END IF;
END;
//

DELIMITER ;

DELIMITER //

CREATE TRIGGER after_insert_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO order_logs (message, order_id)
    VALUES (CONCAT('Pedido criado com sucesso - ID: ', NEW.idOrder), NEW.idOrder);
END;
//

DELIMITER ;


DELIMITER //

CREATE TRIGGER before_update_order
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN
    IF NEW.paymentCash = 1 THEN
        SET NEW.sendValue = 0;
    END IF;
END;
//

DELIMITER ;


DELIMITER //

CREATE TRIGGER before_delete_order
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO deleted_orders (idOrder, idClient, status)
    VALUES (OLD.idOrder, OLD.idOrderClient, OLD.orderStatus);
END;
//

DELIMITER ;


-- Inserção (testa BEFORE + AFTER)
INSERT INTO orders (idOrderClient, orderDescription, paymentCash)
VALUES (1, 'Compra teste', 0);

-- Verificar logs
SELECT * FROM order_logs;

-- Testar UPDATE (frete grátis)
UPDATE orders
SET paymentCash = 1
WHERE idOrder = 1;

SELECT * FROM orders;

-- Testar DELETE (backup)
DELETE FROM orders
WHERE idOrder = 1;

-- Ver backup
SELECT * FROM deleted_orders;

-- Ver triggers
SHOW TRIGGERS;