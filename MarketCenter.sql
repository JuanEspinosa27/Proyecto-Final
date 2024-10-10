-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS MarketCenter;
USE MarketCenter;

-- Creación de la tabla Departamento
CREATE TABLE departamento (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nombre_departamento VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
) ENGINE=InnoDB;

-- Creación de la tabla Empleado
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

-- Creación de la tabla Proveedor
CREATE TABLE proveedor (
    id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre_proveedor VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    pais VARCHAR(100)
) ENGINE=InnoDB;

-- Creación de la tabla Categoría
CREATE TABLE categoria (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
) ENGINE=InnoDB;

-- Creación de la tabla TipoMovimiento
CREATE TABLE tipo_movimiento (
    id_tipo_movimiento INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(10) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Insertar tipos de movimiento
INSERT INTO tipo_movimiento (tipo) VALUES ('entrada'), ('salida');

-- Creación de la tabla Producto
CREATE TABLE producto (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre_producto VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio_unitario DECIMAL(10, 2) NOT NULL CHECK (precio_unitario >= 0),
    id_proveedor INT,
    id_categoria INT,
    stock_actual INT DEFAULT 0 CHECK (stock_actual >= 0),
    stock_minimo INT DEFAULT 0 CHECK (stock_minimo >= 0),
    fecha_ingreso DATE DEFAULT CURDATE(),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE,
    INDEX(id_proveedor),
    INDEX(id_categoria)
) ENGINE=InnoDB;

-- Creación de la tabla Movimiento de Stock (Transaccional)
CREATE TABLE movimiento_stock (
    id_movimiento INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    id_tipo_movimiento INT,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    fecha_movimiento DATE NOT NULL DEFAULT CURDATE(),
    descripcion TEXT,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) 
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_tipo_movimiento) REFERENCES tipo_movimiento(id_tipo_movimiento) 
        ON DELETE CASCADE,
    INDEX(id_producto),
    INDEX(id_tipo_movimiento)
) ENGINE=InnoDB;

-- Creación de la tabla Ventas (Tabla de Hechos)
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    total DECIMAL(10, 2) NOT NULL CHECK (total >= 0),
    fecha_venta DATE NOT NULL DEFAULT CURDATE(),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) 
        ON DELETE CASCADE,
    INDEX(id_producto)
) ENGINE=InnoDB;

-- Creación de la tabla Clientes
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre_cliente VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    pais VARCHAR(100)
) ENGINE=InnoDB;

-- Creación de la tabla Factura
CREATE TABLE factura (
    id_factura INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_venta INT,
    fecha_emision DATE NOT NULL DEFAULT CURDATE(),
    total DECIMAL(10, 2) NOT NULL CHECK (total >= 0),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) 
        ON DELETE SET NULL,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta) 
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Creación de la tabla Descuentos
CREATE TABLE descuento (
    id_descuento INT PRIMARY KEY AUTO_INCREMENT,
    porcentaje DECIMAL(5, 2) NOT NULL CHECK (porcentaje >= 0),
    fecha_inicio DATE,
    fecha_fin DATE
) ENGINE=InnoDB;

-- Creación de la tabla Proveedores_Productos (Tabla Transaccional)
CREATE TABLE proveedores_productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_proveedor INT,
    id_producto INT,
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor) 
        ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) 
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Creación de la tabla Promociones
CREATE TABLE promociones (
    id_promocion INT PRIMARY KEY AUTO_INCREMENT,
    nombre_promocion VARCHAR(100),
    descuento_id INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (descuento_id) REFERENCES descuento(id_descuento) 
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- TRIGGERS

-- 1. Advertir si el stock de un producto cae por debajo del mínimo
DELIMITER $$
CREATE TRIGGER verificar_stock_minimo
AFTER UPDATE ON producto
FOR EACH ROW
BEGIN
    IF NEW.stock_actual < NEW.stock_minimo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Advertencia: El stock del producto está por debajo del nivel mínimo.';
    END IF;
END$$
DELIMITER ;

-- 2. Actualizar el total en la tabla de ventas tras una inserción
DELIMITER $$
CREATE TRIGGER actualizar_total_venta
BEFORE INSERT ON ventas
FOR EACH ROW
BEGIN
    DECLARE precio DECIMAL(10, 2);
    SELECT precio_unitario INTO precio FROM producto WHERE id_producto = NEW.id_producto;
    SET NEW.total = precio * NEW.cantidad;
END$$
DELIMITER ;

-- VIEWS (Vistas)

-- 1. Productos con stock bajo el mínimo
CREATE VIEW vista_productos_bajo_minimo AS
SELECT nombre_producto, stock_actual, stock_minimo
FROM producto
WHERE stock_actual < stock_minimo;

-- 2. Ventas recientes
CREATE VIEW vista_ventas_recientes AS
SELECT v.id_venta, p.nombre_producto, v.cantidad, v.fecha_venta, v.total
FROM ventas v
JOIN producto p ON v.id_producto = p.id_producto
ORDER BY v.fecha_venta DESC
LIMIT 10;

-- 3. Empleados por departamento
CREATE VIEW vista_empleados_departamento AS
SELECT CONCAT(e.nombre, ' ', e.apellido) AS nombre_completo, d.nombre_departamento
FROM empleado e
JOIN departamento d ON e.id_departamento = d.id_departamento;

-- 4. Productos por categoría
CREATE VIEW vista_productos_categoria AS
SELECT c.nombre_categoria, p.nombre_producto, p.precio_unitario
FROM producto p
JOIN categoria c ON p.id_categoria = c.id_categoria;

-- 5. Proveedores y sus productos
CREATE VIEW vista_proveedores_productos AS
SELECT pr.nombre_proveedor, p.nombre_producto, p.precio_unitario
FROM proveedor pr
JOIN producto p ON p.id_proveedor = pr.id_proveedor;

-- STORED PROCEDURES (Procedimientos Almacenados)

-- 1. Agregar un nuevo producto
DELIMITER $$
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
    INSERT INTO producto (nombre_producto, descripcion, precio_unitario, id_proveedor, id_categoria, stock_actual, stock_minimo)
    VALUES (p_nombre_producto, p_descripcion, p_precio_unitario, p_id_proveedor, p_id_categoria, p_stock_inicial, p_stock_minimo);
END$$
DELIMITER ;

-- 2. Generar una nueva venta
DELIMITER $$
CREATE PROCEDURE generar_venta(
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE precio DECIMAL(10, 2);
    SELECT precio_unitario INTO precio FROM producto WHERE id_producto = p_id_producto;
    INSERT INTO ventas (id_producto, cantidad, total) VALUES (p_id_producto, p_cantidad, precio * p_cantidad);
END$$
DELIMITER ;

-- FUNCTIONS (Funciones)

-- 1. Calcular el total de ventas en un periodo
DELIMITER $$
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
END$$
DELIMITER ;

-- 2. Obtener el total de productos en stock
DELIMITER $$
CREATE FUNCTION total_productos_stock()
RETURNS INT
BEGIN
    DECLARE total INT;
    SELECT SUM(stock_actual) INTO total
    FROM producto;
    RETURN total;
END$$
DELIMITER ;

-- Inserciones de datos de ejemplo

-- Insertar Departamentos
INSERT INTO departamento (nombre_departamento, descripcion) VALUES
('Ventas', 'Departamento encargado de las ventas.'),
('Compras', 'Departamento encargado de las compras.'),
('Recursos Humanos', 'Departamento encargado de la gestión del personal.'),
('Logística', 'Departamento encargado de la logística y distribución.'),
('Contabilidad', 'Departamento encargado de la contabilidad.'),
('Marketing', 'Departamento encargado de las estrategias de marketing.'),
('IT', 'Departamento de tecnología de la información.'),
('Servicio al Cliente', 'Departamento encargado de la atención al cliente.'),
('Desarrollo', 'Departamento de desarrollo de productos.'),
('Administración', 'Departamento administrativo.');

-- Insertar Empleados
INSERT INTO empleado (nombre, apellido, id_departamento, puesto, fecha_contratacion, salario) VALUES
('Juan', 'Pérez', 1, 'Vendedor', '2023-01-15', 3000.00),
('Ana', 'García', 1, 'Vendedora', '2023-02-10', 2800.00),
('Luis', 'Martínez', 3, 'Jefe de Recursos Humanos', '2022-11-20', 4500.00),
('Maria', 'López', 4, 'Coordinador Logístico', '2023-03-05', 3500.00),
('José', 'Rodríguez', 2, 'Comprador', '2023-04-01', 3200.00),
('Laura', 'Hernández', 6, 'Especialista en Marketing', '2023-05-15', 3000.00),
('Carlos', 'González', 7, 'Desarrollador', '2023-06-10', 4000.00),
('Elena', 'Torres', 1, 'Asistente de Ventas', '2023-07-20', 2500.00),
('Javier', 'Ramírez', 5, 'Contador', '2022-10-15', 3600.00),
('Sofia', 'Mendoza', 8, 'Atención al Cliente', '2023-08-01', 2300.00);

-- Insertar Proveedores
INSERT INTO proveedor (nombre_proveedor, telefono, email, direccion, ciudad, pais) VALUES
('Proveedor A', '123456789', 'contacto@proveedora.com', 'Calle Falsa 123', 'Ciudad A', 'País A'),
('Proveedor B', '987654321', 'contacto@proveedorb.com', 'Avenida Siempre Viva 742', 'Ciudad B', 'País B'),
('Proveedor C', '456123789', 'contacto@proveedorc.com', 'Paseo de los Ríos 45', 'Ciudad C', 'País C'),
('Proveedor D', '321654987', 'contacto@provedord.com', 'Boulevard del Sol 80', 'Ciudad D', 'País D'),
('Proveedor E', '654789321', 'contacto@proveedore.com', 'Plaza Mayor 10', 'Ciudad E', 'País E'),
('Proveedor F', '789123456', 'contacto@proveedorf.com', 'Camino Real 50', 'Ciudad F', 'País F'),
('Proveedor G', '159753486', 'contacto@proveedorg.com', 'Calle de la Luna 20', 'Ciudad G', 'País G'),
('Proveedor H', '753159468', 'contacto@proveedorh.com', 'Avenida de la Paz 30', 'Ciudad H', 'País H'),
('Proveedor I', '852963741', 'contacto@proveedori.com', 'Calle del Agua 15', 'Ciudad I', 'País I'),
('Proveedor J', '951753864', 'contacto@proveedorj.com', 'Calle del Viento 5', 'Ciudad J', 'País J');

-- Insertar Categorías
INSERT INTO categoria (nombre_categoria, descripcion) VALUES
('Electrónica', 'Productos electrónicos.'),
('Muebles', 'Muebles para el hogar.'),
('Ropa', 'Prendas de vestir.'),
('Alimentos', 'Productos alimenticios.'),
('Hogar', 'Artículos para el hogar.'),
('Deportes', 'Equipos y accesorios deportivos.'),
('Jardín', 'Productos para el jardín.'),
('Belleza', 'Productos de belleza y cuidado personal.'),
('Juguetes', 'Juguetes para niños.'),
('Libros', 'Libros de diversos géneros.');

-- Insertar Productos
INSERT INTO producto (nombre_producto, descripcion, precio_unitario, id_proveedor, id_categoria, stock_actual, stock_minimo) VALUES
('Televisor', 'Televisor LED 40 pulgadas', 500.00, 1, 1, 10, 2),
('Sofa', 'Sofá de 3 plazas', 800.00, 2, 2, 5, 1),
('Camisa', 'Camisa de algodón', 30.00, 3, 3, 20, 5),
('Galletas', 'Galletas de chocolate', 2.50, 4, 4, 100, 20),
('Lámpara', 'Lámpara de mesa', 45.00, 5, 5, 15, 3),
('Balón de fútbol', 'Balón de fútbol tamaño 5', 25.00, 6, 6, 50, 10),
('Maceta', 'Maceta de cerámica', 15.00, 7, 7, 30, 5),
('Crema hidratante', 'Crema hidratante facial', 20.00, 8, 8, 25, 5),
('Muñeca', 'Muñeca de trapo', 15.00, 9, 9, 40, 10),
('Libro de cocina', 'Libro de recetas saludables', 30.00, 10, 10, 5, 1);

-- Insertar Ventas
INSERT INTO ventas (id_producto, cantidad, total) VALUES
(1, 1, 500.00),
(2, 1, 800.00),
(3, 2, 60.00),
(4, 10, 25.00),
(5, 2, 90.00),
(6, 3, 75.00),
(7, 4, 60.00),
(8, 1, 20.00),
(9, 5, 75.00),
(10, 1, 30.00);

-- Insertar Clientes
INSERT INTO cliente (nombre_cliente, telefono, email, direccion, ciudad, pais) VALUES
('Carlos', '123456789', 'carlos@example.com', 'Calle 1', 'Ciudad X', 'País Y'),
('Lucía', '987654321', 'lucia@example.com', 'Calle 2', 'Ciudad Y', 'País Z'),
('Fernando', '456123789', 'fernando@example.com', 'Calle 3', 'Ciudad Z', 'País A'),
('Marta', '321654987', 'marta@example.com', 'Calle 4', 'Ciudad W', 'País B'),
('Javier', '654789321', 'javier@example.com', 'Calle 5', 'Ciudad V', 'País C'),
('Sofía', '789123456', 'sofia@example.com', 'Calle 6', 'Ciudad U', 'País D'),
('Diego', '159753486', 'diego@example.com', 'Calle 7', 'Ciudad T', 'País E'),
('Patricia', '753159468', 'patricia@example.com', 'Calle 8', 'Ciudad S', 'País F'),
('Andrés', '852963741', 'andres@example.com', 'Calle 9', 'Ciudad R', 'País G'),
('Elena', '951753864', 'elena@example.com', 'Calle 10', 'Ciudad Q', 'País H');

-- Insertar Facturas
INSERT INTO factura (id_cliente, id_venta, total) VALUES
(1, 1, 500.00),
(2, 2, 800.00),
(3, 3, 60.00),
(4, 4, 25.00),
(5, 5, 90.00),
(6, 6, 75.00),
(7, 7, 60.00),
(8, 8, 20.00),
(9, 9, 75.00),
(10, 10, 30.00);

-- Insertar Descuentos
INSERT INTO descuento (porcentaje, fecha_inicio, fecha_fin) VALUES
(10.00, '2023-01-01', '2023-12-31'),
(15.00, '2023-03-01', '2023-03-31'),
(5.00, '2023-05-01', '2023-05-31'),
(20.00, '2023-07-01', '2023-07-31'),
(25.00, '2023-09-01', '2023-09-30');

-- Insertar Proveedores_Productos
INSERT INTO proveedores_productos (id_proveedor, id_producto) VALUES
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

-- Insertar Promociones
INSERT INTO promociones (nombre_promocion, descuento_id, fecha_inicio, fecha_fin) VALUES
('Promoción Verano', 1, '2023-06-01', '2023-09-01'),
('Promoción Navidad', 2, '2023-12-01', '2023-12-31'),
('Descuento de Año Nuevo', 3, '2024-01-01', '2024-01-15');
