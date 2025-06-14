use aiscstock;

-- 1. Usuario
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    rol ENUM('superadministrador', 'gerente', 'vendedor') NOT NULL
);

-- 2. Cliente
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(255)
);

-- 3. Proveedor
CREATE TABLE proveedor (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(255)
);

-- 4. Categoria
CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
);

-- 5. Producto
CREATE TABLE producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    precio_compra DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2) NOT NULL,
    stock_actual INT NOT NULL,
    stock_minimo INT NOT NULL,
    id_categoria INT NOT NULL,  -- FK
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

-- 6. Control de Facturacion 
CREATE TABLE control_facturacion (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    numero_factura VARCHAR(50) NOT NULL UNIQUE,
    fecha_emision DATETIME NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    estado ENUM('pagada', 'pendiente', 'cancelada') NOT NULL
);



-- 7. Venta
CREATE TABLE venta (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    fecha_venta DATETIME NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    estado ENUM('completada', 'cancelada') NOT NULL,
    id_cliente INT NOT NULL,  -- FK
    id_usuario INT NOT NULL,  -- FK
    id_factura INT,  -- FK
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_factura) REFERENCES control_facturacion(id_factura)
);

-- 8. DetalleVenta
CREATE TABLE detalle_venta (
    id_detalle_venta INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) DEFAULT 0,
    tipo_descuento ENUM('importe', 'porcentaje') DEFAULT 'importe',
    subtotal DECIMAL(10,2) NOT NULL,
    id_venta INT NOT NULL,  -- FK
    id_producto INT NOT NULL,  -- FK
    FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- 9. Control_Stock
CREATE TABLE control_stock (
    id_control_stock INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    cantidad INT NOT NULL,
    tipo_movimiento ENUM('entrada', 'salida', 'ajuste') NOT NULL,
    fecha_movimiento DATETIME NOT NULL,
    id_producto INT NOT NULL,  -- FK
    id_usuario INT NOT NULL,  -- FK
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- 10. Notificacion
CREATE TABLE notificacion (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    tipo VARCHAR(50) NOT NULL,
    mensaje TEXT NOT NULL,
    leida BOOLEAN DEFAULT FALSE,
    id_producto INT NOT NULL,  -- FK
    id_usuario INT NOT NULL,  -- FK
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- 11. Demanda_Historica
CREATE TABLE demanda_historica (
    id_demanda INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    cantidad_vendida INT NOT NULL,
    fecha_inicio_periodo DATE NOT NULL,
    fecha_fin_periodo DATE NOT NULL,
    id_producto INT NOT NULL,  -- FK
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- 12. Prediccion_Stock
CREATE TABLE prediccion_stock (
    id_prediccion INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    cantidad_recomendada INT NOT NULL,
    fecha_prediccion DATETIME NOT NULL,
    algoritmo_usado VARCHAR(100),
    precision_prediccion DECIMAL(5,2),
    id_producto INT NOT NULL,  -- FK
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- 13. Pedido
CREATE TABLE pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    numero_pedido VARCHAR(50) NOT NULL UNIQUE,
    fecha_pedido DATETIME NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    estado ENUM('pendiente', 'recibido', 'cancelado') NOT NULL,
    id_proveedor INT NOT NULL,  -- FK
    id_usuario INT NOT NULL,  -- FK
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

-- 14. Detalle_Pedido
CREATE TABLE detalle_pedido (
    id_detalle_pedido INT AUTO_INCREMENT PRIMARY KEY,  -- PK
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    id_pedido INT NOT NULL,  -- FK
    id_producto INT NOT NULL,  -- FK
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

