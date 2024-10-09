-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 09-10-2024 a las 21:30:11
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `marketcenter`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_salario_empleado` (IN `p_id_empleado` INT, IN `p_nuevo_salario` DECIMAL(10,2))   BEGIN
    UPDATE empleado
    SET salario = p_nuevo_salario
    WHERE id_empleado = p_id_empleado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `agregar_producto` (IN `p_nombre_producto` VARCHAR(150), IN `p_descripcion` TEXT, IN `p_precio_unitario` DECIMAL(10,2), IN `p_id_proveedor` INT, IN `p_id_categoria` INT, IN `p_stock_inicial` INT, IN `p_stock_minimo` INT)   BEGIN
    INSERT INTO producto (nombre_producto, descripcion, precio_unitario, id_proveedor, id_categoria, stock_actual, stock_minimo)
    VALUES (p_nombre_producto, p_descripcion, p_precio_unitario, p_id_proveedor, p_id_categoria, p_stock_inicial, p_stock_minimo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_productos_categoria` (IN `p_nombre_categoria` VARCHAR(100))   BEGIN
    SELECT p.nombre_producto, p.precio_unitario, p.stock_actual
    FROM producto p
    JOIN categoria c ON p.id_categoria = c.id_categoria
    WHERE c.nombre_categoria = p_nombre_categoria;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `calcular_salario_anual` (`p_salario_mensual` DECIMAL(10,2)) RETURNS DECIMAL(10,2)  BEGIN
    RETURN p_salario_mensual * 12;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total_productos_stock` () RETURNS INT(11)  BEGIN
    DECLARE total INT;
    SELECT SUM(stock_actual) INTO total
    FROM producto;
    RETURN total;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `valor_total_inventario_producto` (`p_id_producto` INT) RETURNS DECIMAL(10,2)  BEGIN
    DECLARE valor_total DECIMAL(10, 2);
    SELECT stock_actual * precio_unitario INTO valor_total
    FROM producto
    WHERE id_producto = p_id_producto;
    RETURN valor_total;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `id_categoria` int(11) NOT NULL,
  `nombre_categoria` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`id_categoria`, `nombre_categoria`, `descripcion`) VALUES
(1, 'Electrónica', 'Productos electrónicos y gadgets.'),
(2, 'Ropa', 'Vestimenta y accesorios.'),
(3, 'Alimentos', 'Comida y bebidas.'),
(4, 'Hogar', 'Artículos para el hogar.'),
(5, 'Deportes', 'Equipos y ropa deportiva.'),
(6, 'Belleza', 'Productos de cuidado personal y belleza.'),
(7, 'Juguetes', 'Juguetes y artículos para niños.'),
(8, 'Automóviles', 'Accesorios y productos para automóviles.'),
(9, 'Libros', 'Literatura y libros educativos.'),
(10, 'Salud', 'Productos de salud y bienestar.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamento`
--

CREATE TABLE `departamento` (
  `id_departamento` int(11) NOT NULL,
  `nombre_departamento` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `departamento`
--

INSERT INTO `departamento` (`id_departamento`, `nombre_departamento`, `descripcion`) VALUES
(1, 'Ventas', 'Departamento encargado de las ventas.'),
(2, 'Compras', 'Departamento encargado de las compras.'),
(3, 'Marketing', 'Departamento de marketing y publicidad.'),
(4, 'Recursos Humanos', 'Gestión del personal y talento.'),
(5, 'Contabilidad', 'Manejo de finanzas y contabilidad.'),
(6, 'Logística', 'Control de la logística y distribución.'),
(7, 'IT', 'Soporte técnico y desarrollo de sistemas.'),
(8, 'Atención al Cliente', 'Servicio al cliente y soporte.'),
(9, 'Producción', 'Producción y control de calidad.'),
(10, 'Administración', 'Gestión general de la empresa.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado`
--

CREATE TABLE `empleado` (
  `id_empleado` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `id_departamento` int(11) DEFAULT NULL,
  `puesto` varchar(100) NOT NULL,
  `fecha_contratacion` date NOT NULL,
  `salario` decimal(10,2) NOT NULL CHECK (`salario` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empleado`
--

INSERT INTO `empleado` (`id_empleado`, `nombre`, `apellido`, `id_departamento`, `puesto`, `fecha_contratacion`, `salario`) VALUES
(1, 'Ana', 'Gómez', 1, 'Vendedora', '2020-01-15', 3000.00),
(2, 'Luis', 'Pérez', 2, 'Comprador', '2019-03-20', 3500.00),
(3, 'María', 'López', 3, 'Gerente de Marketing', '2021-06-01', 5000.00),
(4, 'Javier', 'Martínez', 4, 'Especialista en Recursos Humanos', '2018-09-10', 4000.00),
(5, 'Sofía', 'Díaz', 5, 'Contadora', '2020-11-30', 4500.00),
(6, 'Carlos', 'García', 6, 'Logística', '2021-02-15', 3200.00),
(7, 'Lucía', 'Hernández', 7, 'Desarrolladora', '2019-07-05', 4800.00),
(8, 'Fernando', 'Rodríguez', 8, 'Agente de Atención al Cliente', '2020-04-20', 2800.00),
(9, 'Marta', 'Ramírez', 9, 'Jefa de Producción', '2021-01-01', 6000.00),
(10, 'Diego', 'Cruz', 10, 'Administrador', '2018-12-12', 5000.00);

--
-- Disparadores `empleado`
--
DELIMITER $$
CREATE TRIGGER `evitar_reduccion_salario` BEFORE UPDATE ON `empleado` FOR EACH ROW BEGIN
    IF NEW.salario < OLD.salario THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No se puede reducir el salario de un empleado.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimiento_stock`
--

CREATE TABLE `movimiento_stock` (
  `id_movimiento` int(11) NOT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `id_tipo_movimiento` int(11) DEFAULT NULL,
  `cantidad` int(11) NOT NULL CHECK (`cantidad` > 0),
  `fecha_movimiento` date NOT NULL DEFAULT curdate(),
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `movimiento_stock`
--

INSERT INTO `movimiento_stock` (`id_movimiento`, `id_producto`, `id_tipo_movimiento`, `cantidad`, `fecha_movimiento`, `descripcion`) VALUES
(1, 1, 1, 20, '2023-10-01', 'Entrada de stock de smartphones.'),
(2, 2, 2, 5, '2023-10-02', 'Salida de chaquetas vendidas.'),
(3, 3, 1, 50, '2023-10-03', 'Entrada de cereales.'),
(4, 4, 2, 2, '2023-10-04', 'Salida de sofás vendidos.'),
(5, 5, 1, 15, '2023-10-05', 'Entrada de balones de fútbol.'),
(6, 6, 2, 10, '2023-10-06', 'Salida de cremas hidratantes.'),
(7, 7, 1, 100, '2023-10-07', 'Entrada de muñecas de juguete.'),
(8, 8, 2, 5, '2023-10-08', 'Salida de aceites de motor.'),
(9, 9, 1, 20, '2023-10-09', 'Entrada de libros de cocina.'),
(10, 10, 2, 8, '2023-10-10', 'Salida de vitaminas.');

--
-- Disparadores `movimiento_stock`
--
DELIMITER $$
CREATE TRIGGER `actualizar_stock_producto` AFTER INSERT ON `movimiento_stock` FOR EACH ROW BEGIN
    IF NEW.id_tipo_movimiento = (SELECT id_tipo_movimiento FROM tipo_movimiento WHERE tipo = 'entrada') THEN
        UPDATE producto 
        SET stock_actual = stock_actual + NEW.cantidad 
        WHERE id_producto = NEW.id_producto;
    ELSEIF NEW.id_tipo_movimiento = (SELECT id_tipo_movimiento FROM tipo_movimiento WHERE tipo = 'salida') THEN
        UPDATE producto 
        SET stock_actual = stock_actual - NEW.cantidad 
        WHERE id_producto = NEW.id_producto;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `id_producto` int(11) NOT NULL,
  `nombre_producto` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio_unitario` decimal(10,2) NOT NULL CHECK (`precio_unitario` >= 0),
  `id_proveedor` int(11) DEFAULT NULL,
  `id_categoria` int(11) DEFAULT NULL,
  `stock_actual` int(11) DEFAULT 0 CHECK (`stock_actual` >= 0),
  `stock_minimo` int(11) DEFAULT 0 CHECK (`stock_minimo` >= 0),
  `fecha_ingreso` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`id_producto`, `nombre_producto`, `descripcion`, `precio_unitario`, `id_proveedor`, `id_categoria`, `stock_actual`, `stock_minimo`, `fecha_ingreso`) VALUES
(1, 'Smartphone', 'Teléfono inteligente con pantalla táctil.', 699.99, 1, 1, 70, 10, '2024-10-09'),
(2, 'Chaqueta de invierno', 'Chaqueta abrigada para invierno.', 89.99, 2, 2, 25, 5, '2024-10-09'),
(3, 'Cereal Integral', 'Cereal saludable para el desayuno.', 3.99, 3, 3, 150, 20, '2024-10-09'),
(4, 'Sofá de Tres Plazas', 'Sofá cómodo para sala de estar.', 499.99, 4, 4, 18, 5, '2024-10-09'),
(5, 'Balón de Fútbol', 'Balón de fútbol oficial.', 25.00, 5, 5, 75, 10, '2024-10-09'),
(6, 'Crema Hidratante', 'Crema para el cuidado de la piel.', 19.99, 6, 6, 70, 15, '2024-10-09'),
(7, 'Muñeca de Juguete', 'Muñeca de juguete para niñas.', 14.99, 7, 7, 300, 30, '2024-10-09'),
(8, 'Aceite de Motor', 'Aceite de motor para vehículos.', 29.99, 8, 8, 10, 3, '2024-10-09'),
(9, 'Libro de Cocina', 'Libro con recetas fáciles.', 24.99, 9, 9, 60, 8, '2024-10-09'),
(10, 'Vitaminas', 'Suplemento vitamínico.', 29.99, 10, 10, 62, 10, '2024-10-09');

--
-- Disparadores `producto`
--
DELIMITER $$
CREATE TRIGGER `fecha_ingreso_por_defecto` BEFORE INSERT ON `producto` FOR EACH ROW BEGIN
    IF NEW.fecha_ingreso IS NULL THEN
        SET NEW.fecha_ingreso = CURDATE();
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `verificar_stock_minimo` AFTER UPDATE ON `producto` FOR EACH ROW BEGIN
    IF NEW.stock_actual < NEW.stock_minimo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Advertencia: El stock del producto está por debajo del nivel mínimo.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `id_proveedor` int(11) NOT NULL,
  `nombre_proveedor` varchar(150) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `ciudad` varchar(100) DEFAULT NULL,
  `pais` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`id_proveedor`, `nombre_proveedor`, `telefono`, `email`, `direccion`, `ciudad`, `pais`) VALUES
(1, 'Proveedor A', '123456789', 'proveedora@example.com', 'Calle 1', 'Madrid', 'España'),
(2, 'Proveedor B', '987654321', 'proveedorb@example.com', 'Calle 2', 'Barcelona', 'España'),
(3, 'Proveedor C', '123123123', 'proveedorc@example.com', 'Calle 3', 'Valencia', 'España'),
(4, 'Proveedor D', '456456456', 'proveedord@example.com', 'Calle 4', 'Sevilla', 'España'),
(5, 'Proveedor E', '789789789', 'proveedore@example.com', 'Calle 5', 'Bilbao', 'España'),
(6, 'Proveedor F', '321321321', 'proveedorf@example.com', 'Calle 6', 'Zaragoza', 'España'),
(7, 'Proveedor G', '654654654', 'proveedorg@example.com', 'Calle 7', 'Malaga', 'España'),
(8, 'Proveedor H', '852852852', 'proveedorh@example.com', 'Calle 8', 'Alicante', 'España'),
(9, 'Proveedor I', '963963963', 'proveedori@example.com', 'Calle 9', 'Murcia', 'España'),
(10, 'Proveedor J', '741741741', 'proveedorj@example.com', 'Calle 10', 'Granada', 'España');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_movimiento`
--

CREATE TABLE `tipo_movimiento` (
  `id_tipo_movimiento` int(11) NOT NULL,
  `tipo` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_movimiento`
--

INSERT INTO `tipo_movimiento` (`id_tipo_movimiento`, `tipo`) VALUES
(1, 'entrada'),
(2, 'salida');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_empleados_departamento`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_empleados_departamento` (
`nombre_completo` varchar(201)
,`nombre_departamento` varchar(100)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_movimientos_recientes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_movimientos_recientes` (
`nombre_producto` varchar(150)
,`id_tipo_movimiento` int(11)
,`cantidad` int(11)
,`fecha_movimiento` date
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_productos_bajo_minimo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_productos_bajo_minimo` (
`nombre_producto` varchar(150)
,`stock_actual` int(11)
,`stock_minimo` int(11)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_productos_categoria`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_productos_categoria` (
`nombre_categoria` varchar(100)
,`nombre_producto` varchar(150)
,`precio_unitario` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_proveedores_productos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_proveedores_productos` (
`nombre_proveedor` varchar(150)
,`nombre_producto` varchar(150)
,`precio_unitario` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_empleados_departamento`
--
DROP TABLE IF EXISTS `vista_empleados_departamento`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_empleados_departamento`  AS SELECT concat(`e`.`nombre`,' ',`e`.`apellido`) AS `nombre_completo`, `d`.`nombre_departamento` AS `nombre_departamento` FROM (`empleado` `e` join `departamento` `d` on(`e`.`id_departamento` = `d`.`id_departamento`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_movimientos_recientes`
--
DROP TABLE IF EXISTS `vista_movimientos_recientes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_movimientos_recientes`  AS SELECT `p`.`nombre_producto` AS `nombre_producto`, `m`.`id_tipo_movimiento` AS `id_tipo_movimiento`, `m`.`cantidad` AS `cantidad`, `m`.`fecha_movimiento` AS `fecha_movimiento` FROM (`movimiento_stock` `m` join `producto` `p` on(`m`.`id_producto` = `p`.`id_producto`)) ORDER BY `m`.`fecha_movimiento` DESC LIMIT 0, 10 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_productos_bajo_minimo`
--
DROP TABLE IF EXISTS `vista_productos_bajo_minimo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_productos_bajo_minimo`  AS SELECT `producto`.`nombre_producto` AS `nombre_producto`, `producto`.`stock_actual` AS `stock_actual`, `producto`.`stock_minimo` AS `stock_minimo` FROM `producto` WHERE `producto`.`stock_actual` < `producto`.`stock_minimo` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_productos_categoria`
--
DROP TABLE IF EXISTS `vista_productos_categoria`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_productos_categoria`  AS SELECT `c`.`nombre_categoria` AS `nombre_categoria`, `p`.`nombre_producto` AS `nombre_producto`, `p`.`precio_unitario` AS `precio_unitario` FROM (`producto` `p` join `categoria` `c` on(`p`.`id_categoria` = `c`.`id_categoria`)) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_proveedores_productos`
--
DROP TABLE IF EXISTS `vista_proveedores_productos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_proveedores_productos`  AS SELECT `pr`.`nombre_proveedor` AS `nombre_proveedor`, `p`.`nombre_producto` AS `nombre_producto`, `p`.`precio_unitario` AS `precio_unitario` FROM (`proveedor` `pr` join `producto` `p` on(`p`.`id_proveedor` = `pr`.`id_proveedor`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id_categoria`),
  ADD UNIQUE KEY `nombre_categoria` (`nombre_categoria`);

--
-- Indices de la tabla `departamento`
--
ALTER TABLE `departamento`
  ADD PRIMARY KEY (`id_departamento`),
  ADD UNIQUE KEY `nombre_departamento` (`nombre_departamento`);

--
-- Indices de la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD PRIMARY KEY (`id_empleado`),
  ADD KEY `id_departamento` (`id_departamento`);

--
-- Indices de la tabla `movimiento_stock`
--
ALTER TABLE `movimiento_stock`
  ADD PRIMARY KEY (`id_movimiento`),
  ADD KEY `id_producto` (`id_producto`),
  ADD KEY `id_tipo_movimiento` (`id_tipo_movimiento`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`id_producto`),
  ADD KEY `id_proveedor` (`id_proveedor`),
  ADD KEY `id_categoria` (`id_categoria`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`id_proveedor`),
  ADD UNIQUE KEY `nombre_proveedor` (`nombre_proveedor`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indices de la tabla `tipo_movimiento`
--
ALTER TABLE `tipo_movimiento`
  ADD PRIMARY KEY (`id_tipo_movimiento`),
  ADD UNIQUE KEY `tipo` (`tipo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id_categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `departamento`
--
ALTER TABLE `departamento`
  MODIFY `id_departamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `empleado`
--
ALTER TABLE `empleado`
  MODIFY `id_empleado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `movimiento_stock`
--
ALTER TABLE `movimiento_stock`
  MODIFY `id_movimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `id_proveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `tipo_movimiento`
--
ALTER TABLE `tipo_movimiento`
  MODIFY `id_tipo_movimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD CONSTRAINT `empleado_ibfk_1` FOREIGN KEY (`id_departamento`) REFERENCES `departamento` (`id_departamento`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `movimiento_stock`
--
ALTER TABLE `movimiento_stock`
  ADD CONSTRAINT `movimiento_stock_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `movimiento_stock_ibfk_2` FOREIGN KEY (`id_tipo_movimiento`) REFERENCES `tipo_movimiento` (`id_tipo_movimiento`) ON DELETE CASCADE;

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`id_proveedor`) REFERENCES `proveedor` (`id_proveedor`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `producto_ibfk_2` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
