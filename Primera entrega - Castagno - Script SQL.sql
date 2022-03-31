DROP DATABASE IF EXISTS casa_mundi;
CREATE DATABASE casa_mundi;
USE casa_mundi;

/* CREACION DE TABLAS */

-- TABLA PADRE
CREATE TABLE clientes ( 
	id_cliente INT NOT NULL AUTO_INCREMENT,
    dni INT NOT NULL,
    nombre_cliente VARCHAR(20) NOT NULL,
    apellido_cliente VARCHAR(20) NOT NULL,
	genero VARCHAR(20) NOT NULL, -- deberia hacer otra tabla con las opciones para genero?
    direccion VARCHAR(30) NOT NULL,
    ciudad VARCHAR(20) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    codigo_postal VARCHAR(6),
    PRIMARY KEY (id_cliente)	
);

    -- TABLA PADRE
CREATE TABLE vendedores ( 
	id_vendedor INT NOT NULL AUTO_INCREMENT,
	folio INT NOT NULL,
    CUIL INT	NOT NULL, 
    nombre_vendedor VARCHAR(20) NOT NULL,
    apellido_vendedor VARCHAR(20) NOT NULL,
    genero VARCHAR(20) NOT NULL, -- deberia hacer otra tabla con las opciones para genero?
    fecha_nacimiento DATE NOT NULL,
    fecha_contratacion DATE NOT NULL,
    direccion VARCHAR(30) NOT NULL,
    ciudad VARCHAR(20) NOT NULL,
    codigo_postal VARCHAR(6),
    PRIMARY KEY (id_vendedor)	
);

-- TABLA PADRE
CREATE TABLE categoria_producto (
	id_categoria INT NOT NULL auto_increment,
    nombre_categoria VARCHAR(20) NOT NULL,
    PRIMARY KEY(id_categoria)
);

-- TABLA PADRE
CREATE TABLE proveedores (
	id_proveedor INT NOT NULL AUTO_INCREMENT,
    nombre_proveedor VARCHAR(20) NOT NULL,
    direccion VARCHAR(30) NOT NULL,
    ciudad VARCHAR(20) NOT NULL,
    codigo_postal VARCHAR(6) NOT NULL,
    telefono INT NOT NULL,
    email VARCHAR(30) NOT NULL,
    PRIMARY KEY(id_proveedor)
);

-- TABLA PADRE a la que hay que crearle FKs con alter table
    CREATE TABLE productos ( -- tabla padre a la que deberé agregarle FK lista_precio
	id_producto INT NOT NULL AUTO_INCREMENT,
    nombre_producto VARCHAR(30) NOT NULL,
    id_categoria INT NOT NULL,
    id_precio INT NOT NULL,  -- Será clave foranea. nombrar con alter table
    PRIMARY KEY (id_producto),
	CONSTRAINT fk_categoria FOREIGN KEY (id_categoria) REFERENCES categoria_producto(id_categoria)
    );

    CREATE TABLE stock (
	id_stock INT NOT NULL,
	id_producto INT NOT NULL,
    fecha_ingreso DATE NOT NULL,
    id_compra INT NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY(id_stock, id_producto)
    );
     /*La fk a id_compra la realizo luego de crear la tabla compras */
    
       CREATE TABLE lista_precios (
	id_producto INT NOT NULL,
    fecha_vigencia_precio DATE NOT NULL,
    precio_producto VARCHAR(20) NOT NULL,
	PRIMARY KEY(id_producto, fecha_vigencia_precio)  
    ); 
    
    /*acá se generan la FK de la tabla productos porque ya existiria las tabla lista_precios */
    
    ALTER TABLE productos
    ADD CONSTRAINT fk_precio FOREIGN KEY (id_precio) references lista_precios(id_producto);
    
    CREATE TABLE ventas (
	id_venta INT NOT NULL AUTO_INCREMENT,
    id_vendedor INT NOT NULL,
    id_cliente INT NOT NULL,
    fecha_venta DATETIME NOT NULL,
    precio_final DECIMAL(6,2) NOT NULL,
    PRIMARY KEY(id_venta),
	CONSTRAINT fk_vendedor foreign key(id_vendedor) REFERENCES vendedores(id_vendedor),
	CONSTRAINT fk_cliente FOREIGN KEY(id_cliente) REFERENCES clientes(id_cliente)
    );

CREATE TABLE detalle_venta (
	id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY(id_venta, id_producto),
	CONSTRAINT fk_det_venta FOREIGN KEY(id_venta) REFERENCES ventas(id_venta),
	CONSTRAINT fk_det_producto FOREIGN KEY(id_producto) REFERENCES productos(id_producto)
    );
    
   CREATE TABLE compras (
	id_compra INT NOT NULL AUTO_INCREMENT,
    id_proveedor INT NOT NULL,
    id_stock INT NOT NULL,
    fecha_compra DATETIME NOT NULL,
    precio_final DECIMAL(6,2) NOT NULL,
    PRIMARY KEY(id_compra),
	CONSTRAINT fk_proveedor_c foreign key(id_proveedor) REFERENCES proveedores(id_proveedor),
	CONSTRAINT fk_stock FOREIGN KEY(id_stock) REFERENCES stock(id_stock)
    );
    
     ALTER TABLE stock
    ADD CONSTRAINT fk_compra_s FOREIGN KEY(id_compra) REFERENCES compras(id_compra);

CREATE TABLE detalle_compras (
	id_compra INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(6,2) NOT NULL,
    PRIMARY KEY(id_compra, id_producto),
	CONSTRAINT fk_det_compra FOREIGN KEY(id_compra) REFERENCES compras(id_compra),
	CONSTRAINT fk_detcompra_producto FOREIGN KEY(id_producto) REFERENCES productos(id_producto)
    );