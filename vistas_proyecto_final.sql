 -- Algunas vistas sobre la base de datos
 
-- Mayo de 2021
-- Autor: Esteban Gómez Palomo
-- email: egp.curso.bbdd@gmail.com
-- Ningún derecho reservado.
-- Este trabajo se ha realizado en el marco del curso CERTIFICADO ADMINISTRACIÓN Y GESTIÓN DE BBDD 18/6809
-- de la Comunidad de Madrid.

-- DESCARGA DE RESPONSABILIDAD.
-- Todos los datos contenidos en ésta base de datos son DUMMY, es decir, se han obtenido de forma aleatoria en fuentes públicas como
-- el INE, de resivistas sectoriales e Internet, y haciendo uso de funciones como RAND() o ALEATORIO.ENTRE().
-- 



CREATE VIEW Contactos_Tecnicos_Activos as 
SELECT concat(`nombre`,' ', `apellidos`) as Contacto, `movil` as Móvil , `email` as Email, 
cargos.nombre_cargo as Ocupación 
FROM `contactos` 
INNER JOIN cargos ON cargos.cargo_id = contactos.cargo_id 
WHERE cargos.nombre_cargo LIKE '%técnico%' and contactos.activo = '1';

CREATE VIEW Cargo_y_Antigüedad_Empleados AS
select `empleados`.`empleado_id` as 'Número de Empleado', 
cargos.nombre_cargo as Ocupación, concat(`nombre`,' ',`apellidos`) as Empleado, 
YEAR(CURDATE())-YEAR(recursos_humanos.fecha_inicio) as 'Antigüedad' 
FROM empleados 
INNER JOIN recursos_humanos ON recursos_humanos.empleado_id = empleados.empleado_id 
INNER JOIN cargos ON cargos.cargo_id = empleados.cargo_id 
WHERE recursos_humanos.situacion != 'INACTIVO';

CREATE VIEW totales_por_pedido_id AS
select `proyecto_final`.`lineas_de_pedido`.`pedido_id` AS `pedido_id`,
round(sum(`proyecto_final`.`lineas_de_pedido`.`unidades` * `proyecto_final`.`lineas_de_pedido`.`precio_unitario` * (1 - `proyecto_final`.`lineas_de_pedido`.`descuento`) * (1 + `proyecto_final`.`lineas_de_pedido`.`porcentaje_iva`)),2) AS `total_linea` 
from `proyecto_final`.`lineas_de_pedido` 
group by `proyecto_final`.`lineas_de_pedido`.`pedido_id`;

CREATE VIEW totales_por_linea_de_pedido AS
select `proyecto_final`.`lineas_de_pedido`.`linea_de_pedido_id` AS `linea_de_pedido_id`,
`proyecto_final`.`lineas_de_pedido`.`lista_de_precios_id` AS `lista_de_precios_id`,
`proyecto_final`.`lineas_de_pedido`.`unidades` AS `unidades`,
`proyecto_final`.`lineas_de_pedido`.`precio_unitario` AS `precio_unitario`,
round(`proyecto_final`.`lineas_de_pedido`.`unidades` * `proyecto_final`.`lineas_de_pedido`.`precio_unitario` * (1 - `proyecto_final`.`lineas_de_pedido`.`descuento`),2) AS `valor_neto`,
`proyecto_final`.`lineas_de_pedido`.`porcentaje_iva` AS `porcentaje_iva`,
round(`proyecto_final`.`lineas_de_pedido`.`unidades` * `proyecto_final`.`lineas_de_pedido`.`precio_unitario` * (1 - `proyecto_final`.`lineas_de_pedido`.`descuento`) * (1 + `proyecto_final`.`lineas_de_pedido`.`porcentaje_iva`),2) AS `total_linea` 
from `proyecto_final`.`lineas_de_pedido`;

create view pedidos_por_cliente_2018 AS
select `proyecto_final`.`clientes`.`razon_social` AS `razon_social`,
sum(`total_pedido`.`total_linea`) AS `TOTAL_PEDIDO` from ((`proyecto_final`.`clientes` 
INNER join `proyecto_final`.`pedidos` on(`proyecto_final`.`pedidos`.`cliente_id` = `proyecto_final`.`clientes`.`cliente_id`)) 
INNER join `proyecto_final`.`total_pedido` on(`total_pedido`.`pedido_id` = `proyecto_final`.`pedidos`.`pedido_id`)) 
where `proyecto_final`.`pedidos`.`fecha_pedido` between '2018-01-01' and '2018-12-31' 
group by `proyecto_final`.`clientes`.`razon_social`

