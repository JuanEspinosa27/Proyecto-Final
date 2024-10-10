CREATE DATABASE IF NOT EXISTS MarketCenter;
USE MarketCenter;

CREATE TABLE departamento (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nombre_departamento VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
) ENGINE=InnoDB;

INSERT INTO departamento (nombre_departamento, descripcion) VALUES
('Ventas', 'Departamento encargado de las ventas de la empresa'),
('Compras', 'Departamento responsable de las adquisiciones'),
('Recursos Humanos', 'Gestión del personal y bienestar'),
('IT', 'Tecnología e infraestructura informática'),
('Marketing', 'Promoción y publicidad de productos'),
('Finanzas', 'Gestión financiera y contable'),
('Logística', 'Cadena de suministro y distribución'),
('Servicio al Cliente', 'Atención y soporte al cliente'),
('Investigación y Desarrollo', 'Innovación y desarrollo de productos'),
('Producción', 'Fabricación y ensamblaje de productos');

CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    id_departamento INT,
    puesto VARCHAR(100) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    salario DECIMAL(10, 2) NOT NULL CHECK (salario >= 0),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento) 
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    INDEX(id_departamento)
) ENGINE=InnoDB;

INSERT INTO empleado (nombre, apellido, id_departamento, puesto, fecha_contratacion, salario) VALUES
('Juan', 'Pérez', 1, 'Vendedor', '2020-01-15', 2500.00),
('María', 'García', 2, 'Comprador', '2019-03-22', 2700.00),
('Carlos', 'López', 3, 'Especialista en RRHH', '2018-06-10', 2600.00),
('Laura', 'Martínez', 4, 'Desarrollador', '2021-07-01', 3000.00),
('José', 'Rodríguez', 5, 'Analista de Marketing', '2019-11-05', 2800.00),
('Ana', 'Fernández', 6, 'Contador', '2020-02-18', 2900.00),
('David', 'Gómez', 7, 'Coordinador Logístico', '2017-09-30', 2700.00),
('Sandra', 'Díaz', 8, 'Representante de Servicio', '2018-12-12', 2400.00),
('Luis', 'Torres', 9, 'Ingeniero de I+D', '2020-04-20', 3200.00),
('Patricia', 'Sánchez', 10, 'Supervisor de Producción', '2017-08-25', 3100.00);

CREATE TABLE proveedor (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre_proveedor VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(25),
    email VARCHAR(100) UNIQUE,
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    pais VARCHAR(100)
) ENGINE=InnoDB;

INSERT INTO proveedor (nombre_proveedor, telefono, email, direccion, ciudad, pais) VALUES
('Proveedor A', '123456789', 'contacto@proveedora.com', 'Calle 1', 'Ciudad A', 'País A'),
('Proveedor B', '987654321', 'info@proveedorb.com', 'Avenida 2', 'Ciudad B', 'País B'),
('Proveedor C', '456123789', 'ventas@proveedorc.com', 'Calle 3', 'Ciudad C', 'País C'),
('Proveedor D', '789456123', 'servicio@proveedord.com', 'Boulevard 4', 'Ciudad D', 'País D'),
('Proveedor E', '321654987', 'soporte@proveedore.com', 'Plaza 5', 'Ciudad E', 'País E'),
('Proveedor F', '654987321', 'contacto@proveedorf.com', 'Camino 6', 'Ciudad F', 'País F'),
('Proveedor G', '147258369', 'ventas@proveedorg.com', 'Callejón 7', 'Ciudad G', 'País G'),
('Proveedor H', '369258147', 'info@proveedorh.com', 'Paseo 8', 'Ciudad H', 'País H'),
('Proveedor I', '258147369', 'servicio@proveedori.com', 'Ruta 9', 'Ciudad I', 'País I'),
('Proveedor J', '852963741', 'soporte@proveedorj.com', 'Autopista 10', 'Ciudad J', 'País J');

CREATE TABLE categoria (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
) ENGINE=InnoDB;

INSERT INTO categoria (nombre_categoria, descripcion) VALUES
('Electrónica', 'Productos electrónicos y gadgets'),
('Ropa', 'Vestimenta y accesorios'),
('Hogar', 'Artículos para el hogar y decoración'),
('Juguetes', 'Juguetes y juegos para niños'),
('Alimentos', 'Productos alimenticios'),
('Bebidas', 'Bebidas alcohólicas y no alcohólicas'),
('Libros', 'Libros y material de lectura'),
('Deportes', 'Artículos deportivos'),
('Salud y Belleza', 'Productos de cuidado personal'),
('Automotriz', 'Accesorios y repuestos de vehículos');

CREATE TABLE tipo_movimiento (
    id_tipo_movimiento INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(10) NOT NULL UNIQUE
) ENGINE=InnoDB;

INSERT INTO tipo_movimiento (tipo) VALUES ('entrada'), ('salida');

CREATE TABLE producto (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre_producto VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio_unitario DECIMAL(10, 2) NOT NULL CHECK (precio_unitario >= 0),
    id_proveedor INT NULL,
    id_categoria INT NULL,
    stock_actual INT DEFAULT 0 CHECK (stock_actual >= 0),
    stock_minimo INT DEFAULT 0 CHECK (stock_minimo >= 0),
    fecha_ingreso DATE DEFAULT CURDATE(),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO producto (nombre_producto, descripcion, precio_unitario, id_proveedor, id_categoria, stock_actual, stock_minimo) VALUES
('Smartphone XYZ', 'Teléfono inteligente de última generación', 500.00, 1, 1, 100, 10),
('Camisa de Algodón', 'Camisa de manga larga 100% algodón', 20.00, 2, 2, 200, 20),
('Sillón Recliner', 'Sillón reclinable de cuero', 250.00, 3, 3, 50, 5),
('Juego de Mesa "Aventura"', 'Juego de mesa para toda la familia', 30.00, 4, 4, 150, 15),
('Cereal Integral', 'Cereal rico en fibra y vitaminas', 5.00, 5, 5, 300, 30),
('Agua Mineral', 'Agua mineral natural', 1.00, 6, 6, 500, 50),
('Novela "El Misterio"', 'Novela de suspenso y misterio', 15.00, 7, 7, 120, 12),
('Pelota de Fútbol', 'Pelota profesional de fútbol', 25.00, 8, 8, 80, 8),
('Champú Orgánico', 'Champú libre de químicos', 8.00, 9, 9, 200, 20),
('Aceite para Motor', 'Aceite sintético para motor', 10.00, 10, 10, 150, 15);

CREATE TABLE movimiento_stock (
    id_movimiento INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT NOT NULL,
    id_tipo_movimiento INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    fecha_movimiento DATE NOT NULL DEFAULT CURDATE(),
    descripcion TEXT,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) 
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_tipo_movimiento) REFERENCES tipo_movimiento(id_tipo_movimiento) 
        ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO movimiento_stock (id_producto, id_tipo_movimiento, cantidad, fecha_movimiento, descripcion) VALUES
(1, 1, 50, '2021-05-01', 'Ingreso inicial de stock'),
(2, 1, 100, '2021-05-02', 'Ingreso inicial de stock'),
(3, 1, 30, '2021-05-03', 'Ingreso inicial de stock'),
(4, 2, 10, '2021-05-04', 'Venta de productos'),
(5, 2, 20, '2021-05-05', 'Venta de productos'),
(6, 1, 200, '2021-05-06', 'Ingreso adicional de stock'),
(7, 2, 15, '2021-05-07', 'Venta de productos'),
(8, 1, 40, '2021-05-08', 'Ingreso adicional de stock'),
(9, 2, 25, '2021-05-09', 'Venta de productos'),
(10, 1, 60, '2021-05-10', 'Ingreso adicional de stock');

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre_cliente VARCHAR(100) NOT NULL,
    telefono VARCHAR(25),
    email VARCHAR(100) UNIQUE,
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    pais VARCHAR(100)
) ENGINE=InnoDB;

INSERT INTO cliente (nombre_cliente, telefono, email, direccion, ciudad, pais) VALUES
('Pedro Morales', '111111111', 'pedro@example.com', 'Calle Gran Vía 10', 'Madrid', 'España'),
('Lucía Ramos', '222222222', 'lucia@example.com', 'Avenida Insurgentes Sur 300', 'Ciudad de México', 'México'),
('Diego López', '333333333', 'diego@example.com', 'Calle Florida 500', 'Buenos Aires', 'Argentina'),
('Sofía González', '444444444', 'sofia@example.com', 'Calle 50 No. 100', 'Bogotá', 'Colombia'),
('Manuel Herrera', '555555555', 'manuel@example.com', 'Rua Augusta 250', 'São Paulo', 'Brasil'),
('Marta Ruiz', '666666666', 'marta@example.com', 'Calle Alcalá 15', 'Sevilla', 'España'),
('Alberto Díaz', '777777777', 'alberto@example.com', 'Avenida Paulista 1578', 'São Paulo', 'Brasil'),
('Elena Sánchez', '888888888', 'elena@example.com', 'Calle 8 No. 123', 'Lima', 'Perú'),
('Pablo Ortiz', '999999999', 'pablo@example.com', 'Avenida Libertador 750', 'Caracas', 'Venezuela'),
('Laura Gómez', '000000000', 'laura@example.com', 'Calle Colón 200', 'Quito', 'Ecuador');

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) NOT NULL CHECK (total >= 0),
    fecha_venta DATE NOT NULL DEFAULT CURDATE(),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) 
        ON DELETE CASCADE
) ENGINE=InnoDB;

DELIMITER $$
CREATE TRIGGER actualizar_total_venta
BEFORE INSERT ON ventas
FOR EACH ROW
BEGIN
    DECLARE precio DECIMAL(10, 2);
    SELECT precio_unitario INTO precio FROM producto WHERE id_producto = NEW.id_producto;
    SET NEW.precio_unitario = precio;
    SET NEW.total = precio * NEW.cantidad;
END$$
DELIMITER ;

INSERT INTO ventas (id_producto, cantidad, fecha_venta) VALUES
(1, 2, '2021-06-01'),
(2, 5, '2021-06-02'),
(3, 1, '2021-06-03'),
(4, 3, '2021-06-04'),
(5, 10, '2021-06-05'),
(6, 20, '2021-06-06'),
(7, 4, '2021-06-07'),
(8, 2, '2021-06-08'),
(9, 5, '2021-06-09'),
(10, 3, '2021-06-10');

CREATE TABLE factura (
    id_factura INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NULL,
    id_venta INT NOT NULL,
    fecha_emision DATE NOT NULL DEFAULT CURDATE(),
    total DECIMAL(10, 2) NOT NULL CHECK (total >= 0),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) 
        ON DELETE SET NULL,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta) 
        ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO factura (id_cliente, id_venta, fecha_emision, total) VALUES
(1, 1, '2021-06-11', 1000.00),
(2, 2, '2021-06-12', 100.00),
(3, 3, '2021-06-13', 250.00),
(4, 4, '2021-06-14', 90.00),
(5, 5, '2021-06-15', 50.00),
(6, 6, '2021-06-16', 20.00),
(7, 7, '2021-06-17', 60.00),
(8, 8, '2021-06-18', 50.00),
(9, 9, '2021-06-19', 40.00),
(10, 10, '2021-06-20', 30.00);

CREATE TABLE descuento (
    id_descuento INT PRIMARY KEY AUTO_INCREMENT,
    porcentaje DECIMAL(5, 2) NOT NULL CHECK (porcentaje >= 0),
    fecha_inicio DATE,
    fecha_fin DATE
) ENGINE=InnoDB;

INSERT INTO descuento (porcentaje, fecha_inicio, fecha_fin) VALUES
(5.00, '2021-07-01', '2021-07-31'),
(10.00, '2021-08-01', '2021-08-31'),
(15.00, '2021-09-01', '2021-09-30'),
(20.00, '2021-10-01', '2021-10-31'),
(25.00, '2021-11-01', '2021-11-30'),
(30.00, '2021-12-01', '2021-12-31'),
(35.00, '2022-01-01', '2022-01-31'),
(40.00, '2022-02-01', '2022-02-28'),
(45.00, '2022-03-01', '2022-03-31'),
(50.00, '2022-04-01', '2022-04-30');

CREATE TABLE promociones (
    id_promocion INT PRIMARY KEY AUTO_INCREMENT,
    nombre_promocion VARCHAR(100),
    descuento_id INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (descuento_id) REFERENCES descuento(id_descuento) 
        ON DELETE SET NULL
) ENGINE=InnoDB;

INSERT INTO promociones (nombre_promocion, descuento_id, fecha_inicio, fecha_fin) VALUES
('Promoción de Verano', 1, '2021-07-01', '2021-07-31'),
('Back to School', 2, '2021-08-01', '2021-08-31'),
('Oferta de Otoño', 3, '2021-09-01', '2021-09-30'),
('Halloween', 4, '2021-10-01', '2021-10-31'),
('Black Friday', 5, '2021-11-01', '2021-11-30'),
('Navidad', 6, '2021-12-01', '2021-12-31'),
('Año Nuevo', 7, '2022-01-01', '2022-01-31'),
('San Valentín', 8, '2022-02-01', '2022-02-28'),
('Primavera', 9, '2022-03-01', '2022-03-31'),
('Día del Niño', 10, '2022-04-01', '2022-04-30');

CREATE TABLE proveedor_producto (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_proveedor INT NOT NULL,
    id_producto INT NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor) 
        ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) 
        ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO proveedor_producto (id_proveedor, id_producto) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

DELIMITER 
CREATE TRIGGER verificar_stock_minimo
AFTER UPDATE ON producto
FOR EACH ROW
BEGIN
    IF NEW.stock_actual < NEW.stock_minimo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Advertencia: El stock del producto está por debajo del nivel mínimo.';
    END IF;
END
DELIMITER ;


CREATE VIEW vista_productos_bajo_minimo AS
SELECT nombre_producto, stock_actual, stock_minimo
FROM producto
WHERE stock_actual < stock_minimo;

CREATE VIEW vista_ventas_recientes AS
SELECT v.id_venta, p.nombre_producto, v.cantidad, v.fecha_venta, v.total
FROM ventas v
JOIN producto p ON v.id_producto = p.id_producto
ORDER BY v.fecha_venta DESC
LIMIT 10;

CREATE VIEW vista_empleados_departamento AS
SELECT CONCAT(e.nombre, ' ', e.apellido) AS nombre_completo, d.nombre_departamento
FROM empleado e
JOIN departamento d ON e.id_departamento = d.id_departamento;

CREATE VIEW vista_productos_categoria AS
SELECT c.nombre_categoria, p.nombre_producto, p.precio_unitario
FROM producto p
JOIN categoria c ON p.id_categoria = c.id_categoria;

CREATE VIEW vista_proveedores_productos AS
SELECT pr.nombre_proveedor, p.nombre_producto, p.precio_unitario
FROM proveedor pr
JOIN producto p ON p.id_proveedor = pr.id_proveedor;

DELIMITER 
CREATE PROCEDURE agregar_producto(
    IN p_nombre_producto VARCHAR(150),
    IN p_descripcion TEXT,
    IN p_precio_unitario DECIMAL(10,2),
    IN p_id_proveedor INT,
    IN p_id_categoria INT,
    IN p_stock_inicial INT,
    IN p_stock_minimo INT
)
BEGIN
    IF p_stock_inicial < p_stock_minimo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El stock inicial no puede ser menor que el stock mínimo.';
    ELSE
        INSERT INTO producto (nombre_producto, descripcion, precio_unitario, id_proveedor, id_categoria, stock_actual, stock_minimo)
        VALUES (p_nombre_producto, p_descripcion, p_precio_unitario, p_id_proveedor, p_id_categoria, p_stock_inicial, p_stock_minimo);
    END IF;
END
DELIMITER ;

DELIMITER 
CREATE PROCEDURE generar_venta(
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE precio DECIMAL(10, 2);
    DECLARE stock_disponible INT;
    -- Verificación de stock disponible
    SELECT stock_actual INTO stock_disponible FROM producto WHERE id_producto = p_id_producto;
    IF stock_disponible < p_cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Stock insuficiente para la venta.';
    ELSE
        SELECT precio_unitario INTO precio FROM producto WHERE id_producto = p_id_producto;
        INSERT INTO ventas (id_producto, cantidad, precio_unitario, total) 
        VALUES (p_id_producto, p_cantidad, precio, precio * p_cantidad);
        -- Actualizar el stock del producto
        UPDATE producto SET stock_actual = stock_actual - p_cantidad WHERE id_producto = p_id_producto;
    END IF;
END
DELIMITER ;

DELIMITER 
CREATE FUNCTION total_ventas_periodo(
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total DECIMAL(10, 2);
    SELECT SUM(total) INTO total
    FROM ventas
    WHERE fecha_venta BETWEEN p_fecha_inicio AND p_fecha_fin;
    RETURN total;
END
DELIMITER ;

DELIMITER 
CREATE FUNCTION total_productos_stock()
RETURNS INT
BEGIN
    DECLARE total INT;
    SELECT SUM(stock_actual) INTO total
    FROM producto;
    RETURN total;
END
DELIMITER ;