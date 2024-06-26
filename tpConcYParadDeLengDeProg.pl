% Declarar los predicados como dinámicos hace que puedan ser modificados en ejecución
% Que se puedan crear, modificar y eliminar hechos del predicado durante la ejecución
:- dynamic producto/3.
:- dynamic cliente/3.
:- dynamic venta/4.
:- dynamic stock/2.

%************* PRODUCTOS *************

% Producto tiene nombre, lista de ingredientes con cantidad y precio
producto(helado_dulce_de_leche, [(leche, 1), (azucar, 1), (dulce_de_leche, 3), (crema_de_leche, 2)], 1600).
producto(helado_americana, [(leche, 1), (azucar, 1), (crema_americana, 3), (crema_de_leche, 2)], 1550).
producto(helado_frutilla, [(leche, 1), (azucar, 1), (frutilla, 3), (crema_de_leche, 2)], 1500).
producto(helado_banana_split, [(leche, 1), (azucar, 1), (banana, 3), (crema_de_leche, 2)], 1650).
producto(helado_chocolate_amargo, [(leche, 1), (azucar, 1), (chocolate_amargo, 3), (crema_de_leche, 2)], 1600).
producto(helado_menta_granizada, [(leche, 1), (azucar, 1), (extracto_de_menta, 2), (chocolate, 2), (crema_de_leche, 2)], 1550).
producto(helado_durazno, [(leche, 1), (azucar, 1), (durazno, 3), (crema_de_leche, 2)], 1500).
producto(helado_limon, [(agua, 1), (azucar, 1), (limon, 3)], 1400).
producto(helado_kinotos_al_whisky, [(leche, 1), (azucar, 1), (kinotos, 3), (whisky, 1), (crema_de_leche, 2)], 1700).
producto(helado_tiramisu, [(leche, 1), (azucar, 1), (cafe, 2), (chocolate, 2), (crema_de_leche, 2)], 1650).
producto(helado_crema_del_cielo, [(leche, 1), (azucar, 1), (vainilla, 3), (crema_de_leche, 2)], 1550).

% Predicado para crear un nuevo producto.
crear_producto(Nombre, Ingredientes, Precio) :-
    % Se agrega a la base de datos el producto con los datos ingresados
    assert(producto(Nombre, Ingredientes, Precio)),
    % Se crea a su vez el producto en el stock, con catidad = 0
    assert(stock(Nombre, 0)),
    writeln('Nuevo producto creado exitosamente.').
    
% Se imprime una lista con todos los productos
lista_productos :-
    writeln('LISTA DE PRODUCTOS:'),
    % Devuelve una lista con nombre, ingredientes[ingrediente, cantidad] y precio de cada producto
    findall((Nombre, Ingredientes, Precio), producto(Nombre, Ingredientes, Precio), Lista),
    imprimir_lista_prod(Lista).

% Imprime la lista de productos formateada
% Se crea una función imprimir_lista_prod vacía para que corte la recursividad cuando se vacía la lista
imprimir_lista_prod([]).
% Se toma el primer elemento (cabecera) de la lista y se crea Resto, una lista con los demás productos
imprimir_lista_prod([(Nombre, Ingredientes, Precio) | Resto]) :-
    % ~w es un especificador se utiliza para imprimir cualquier término Prolog de manera predeterminada
    % ~n añade un salto de línea
    % ~2f es un especificador de formato para un número de punto flotante con 2 decimales
    % A format 1° se le pasa un string con el formato y 2° las variables que ocupan el lugar de las ~w
    format('■ ~w ~n   ► precio: ~2f pesos~n', [Nombre, Precio]),
    imprimir_ingredientes(Ingredientes),
    % Imprime un salto de linea = ~n
    nl,
    % Se llama recursivamente hasta vaciar la lista
    imprimir_lista_prod(Resto).

% Imprime los ingredientes de cada producto
% Se crea una función imprimir_lista_prod vacía para que corte la recursividad cuando se vacía la lista
imprimir_ingredientes([]).
% Se toma el primer elemento (cabecera) de la lista y se crea Resto, una lista con los demás productos
imprimir_ingredientes([(Ingrediente, Cantidad) | Resto]) :-
    % ~w es un especificador se utiliza para imprimir cualquier término Prolog de manera predeterminada
    % ~n añade un salto de línea
    format('   ► ~w: ~w~n', [Ingrediente, Cantidad]),
    % Se llama recursivamente hasta vaciar la lista
    imprimir_ingredientes(Resto).

% Se imprime la lista de ingredientes de un producto
ingredientes_producto(Producto) :-
    format('INGREDIENTES DE ~w:~n~n',Producto),
    % Se consulta el producto
    producto(Producto, Ingredientes, _),
    imprimir_ingredientes(Ingredientes).
    
% Ventas de un producto específico: imprime una lista con las ventas de un producto dado su nombre.
ventas_producto(Producto) :-
    format('VENTAS DEL PRODUCTO: ~w~n', [Producto]),
    % Devuelve una lista con la fecha de la venta, el nombre del cliente, el nombre del producto
    % y la cantidad, de las ventas de ese cliente
    findall((Fecha, NombreCliente, Producto, Cantidad), (venta(Fecha, IdCliente, Producto, Cantidad), cliente(IdCliente, NombreCliente, _)), Lista),
    imprimir_lista_ventas(Lista).

%************* CLIENTES *************

% Cliente tiene id, nombre y dirección
cliente(1, nico_perez, avenida_siempre_viva_1234).
cliente(2, alejandra_lopez, calle_falsa_3456).
cliente(3, pedro_diaz, avenida_29_de_septiembre_6789).
cliente(4, laura_fernandez, pablo_nogues_4321).
cliente(5, nelson_rodriguez, oscar_bidegain_6543).

% Predicado para crear un nuevo cliente.
crear_cliente(Id, Nombre, Direccion) :-
    % Se agrega a la base de datos el cliente con los datos ingresados
    assert(cliente(Id, Nombre, Direccion)),
    writeln('Nuevo cliente creado exitosamente.').

% Se imprime una lista con todos los clientes
lista_clientes :-
    writeln('LISTA DE CLIENTES:'),
    % Devuelve una lista con nombre y dirección de cada cliente
    findall((Nombre, Direccion), cliente(_, Nombre, Direccion), Lista),
    imprimir_lista_clientes(Lista).

% Imprime la lista de clientes formateada
% Se crea una función imprimir_lista_clientes vacía para que corte la recursividad cuando se vacía la lista
imprimir_lista_clientes([]).
% Se toma el primer elemento (cabecera) de la lista y se crea Resto, una lista con los demás clientes
imprimir_lista_clientes([(Nombre, Direccion) | Resto]) :-
    % ~w es un especificador se utiliza para imprimir cualquier término Prolog de manera predeterminada
    % ~n añade un salto de línea
    format('■ nombre: ~w ~n■ direccion: ~w ~n~n', [Nombre, Direccion]),
    % Se llama recursivamente hasta vaciar la lista
    imprimir_lista_clientes(Resto).
    
% Se imprime una lista con las compras de un cliente dado su id
compras_cliente(IdCliente) :-
    writeln('COMPRAS DE UN CLIENTE:'),
    % Devuelve una lista con la fecha de la venta, el producto y la cantidad de las ventas de ese cliente
    findall((Fecha, Nombre, Producto, Cantidad), venta(Fecha, IdCliente, Producto, Cantidad), cliente(IdCliente,Nombre,_), Lista),
    imprimir_lista_ventas(Lista).

% Encuentra al cliente que ha realizado más compras
cliente_mas_compras :-
    writeln('CLIENTE CON MAS COMPRAS REALIZADAS:'),
    % Se buscan todos los clientes -> con aggregate se cuenta el n° de ventas de cada cliente ->
    % se crea una lista con el id de los clientes y ese n° de ventas que se calculó
    % Aggregate -> 1° Se especifica el tipo de agregación (count para contar elementos)
                 % 2° Se especifica el objetivo para el cual se realiza la agregación
                 % 3° Se especifica la varible en la que se guarda el resultado que devuelve
    findall((IdCliente, Count), (cliente(IdCliente, _, _), aggregate(count, venta(_, IdCliente, _, _), Count)), Lista),
    % Se ordena la lista la lista de mayor a menor según el segundo elemento (n° de ventas)
    % Se toma el primer elemento con "[(IdCliente, MaxCount)|_]" para usarlo en la salida de texto
    % sort -> 1° posición del elemento que se usa para ordenar 2° criterio de ordenamiento
            % 3°  lista a ordenar 4° lista ordenada (en este caso se obtiene solo el primer elemento)
    sort(2, @>=, Lista, [(IdCliente, MaxCount)|_]),
    % Se consulta el cliente que más compras realizado gracias al id obtenido antes
    cliente(IdCliente, Nombre, _),
    format('cliente: ~w~ncantidad total de compras: ~w~n', [Nombre, MaxCount]).

% Encuentra al cliente que ha gastado más en total
cliente_compra_mayor :-
    writeln('CLIENTE QUE GASTÓ MÁS EN COMPRAS:'),
    % Se recorre cada cliente -> se guarda el subtotal, el precio de cada venta "Precios -> se suman
    % los subtotales y se guarda en "Total" -> se devuelve el id de cada cliente con su "Total"
    % Se devuelve en Lista cada id de los clientes con los totales de lo gastado
    findall((IdCliente, Total),
        (cliente(IdCliente, _, _),
            % Devuelve en la lista "Precios" los precios de las ventas realizadas por cada cliente
            findall(Precio,
                (venta(_, IdCliente, Producto, Cantidad),
                producto(Producto, _, PrecioUnitario),
                Precio is PrecioUnitario * Cantidad),
                Precios),
            % Se suma todos los precios en la lista "Precios", calculando el Total gastado por el cliente
            sum_list(Precios, Total)),
        Lista),
    % Ordeno la lista de mayor a menor según el "Total" y obtengo el primer elemento, el mayor
    sort(2, @>=, Lista, [(IdCliente, MaxTotal)|_]),
    % Se consulta el cliente que más gastó gracias al id obtenido en el sort
    cliente(IdCliente, Nombre, _),
    format('cliente: ~w~nmonto total en compras: ~2f~n', [Nombre, MaxTotal]).
    
%************* VENTAS *************

% Venta tiene fecha, id del cliente, producto y cantidad
venta('2024-05-01', 1, helado_dulce_de_leche, 2).
venta('2024-05-02', 2, helado_americana, 1).
venta('2024-05-03', 3, helado_frutilla, 3).
venta('2024-05-04', 4, helado_banana_split, 1).
venta('2024-05-05', 1, helado_chocolate_amargo, 4).
venta('2024-05-06', 2, helado_menta_granizada, 2).
venta('2024-05-07', 3, helado_durazno, 1).
venta('2024-05-08', 4, helado_limon, 2).
venta('2024-05-09', 5, helado_kinotos_al_whisky, 1).
venta('2024-05-10', 1, helado_tiramisu, 1).

% Registrar una nueva venta (se valida si hay suficiente stock disponible)
registrar_venta(Fecha, IdCliente, Producto, Cantidad) :-
    % Verifica si hay suficiente stock
    (   verificar_stock(Producto, Cantidad)
    % Si verificar_stock = true entonces ->
    ->  % Si hay suficiente stock, realiza las siguientes operaciones
        % Se agrega la venta a la base de datos
        assert(venta(Fecha, IdCliente, Producto, Cantidad)),
        % Se resta la cantidad vendida del producto del stock
        disminuir_stock(Producto, Cantidad),
        writeln('Venta registrada exitosamente.')
    % Si verificacar_stock = false entonces ->
    ;   % Si no hay suficiente stock, imprime un mensaje de error
        writeln('Error: No hay suficiente stock para realizar la venta.')
    ),
    % Se impide backtracking para que Prolog no siga buscando más reglas o hechos que puedan satisfacer la consulta
    % Para reducir redundancia en el flujo de ejecución
    !.
    
% Se imprime una lista con todas las ventas realizadas
lista_ventas :-
    writeln('LISTA DE VENTAS:'),
    % Devuelve una lista con fecha, nombre del cliente, producto y cantidad de cada venta
    findall((Fecha, NombreCliente, Producto, Cantidad),(venta(Fecha, IdCliente, Producto, Cantidad), cliente(IdCliente, NombreCliente, _)),Lista),
    imprimir_lista_ventas(Lista).

% Imprime la lista de ventas formateada
% Se crea una función imprimir_lista_ventas vacía para que corte la recursividad cuando se vacía la lista
imprimir_lista_ventas([]).
% Se toma el primer elemento (cabecera) de la lista y se crea Resto, una lista con las demás ventas
imprimir_lista_ventas([(Fecha, NombreCliente, Producto, Cantidad) | Resto]) :-
    % ~w es un especificador se utiliza para imprimir cualquier término Prolog de manera predeterminada
    % ~n añade un salto de línea
    format('fecha: ~w~ncliente: ~w~nproducto: ~w~ncantidad: ~w~n~n', [Fecha, NombreCliente, Producto, Cantidad]),
    % Se llama recursivamente hasta vaciar la lista
    imprimir_lista_ventas(Resto).

% Se imprime una lista con las compras que superan el monto dado
compras_monto_mayor(Monto) :-
    format('COMPRAS MAYORES A ~w PESOS:~n~n',Monto),

    % Se unen todas las ventas y todos los productos -> se obtiene el precio unitario del producto
    % para calcular el total de la venta y luego filtrar las ventas cuyo total sea mayor al monto dado,
    % así en la lista solo se incluyen los datos que cumplan con esa condición

    % Devuelve una lista con el id del cliente, el nombre del producto, la canidad y el total
    findall((IdCliente, Producto, Cantidad, Total),
            (venta(_, IdCliente, Producto, Cantidad), producto(Producto, _, PrecioUnitario), Total is PrecioUnitario * Cantidad, Total > Monto),
            Lista),
    imprimir_lista_compras(Lista).

% Se imprime una lista con las compras que son menores al monto dado
compras_monto_menor(Monto) :-
    format('COMPRAS MENORES A ~w PESOS:~n~n',Monto),

    % Se unen todas las ventas y todos los productos -> se obtiene el precio unitario del producto
    % para calcular el total de la venta y luego filtrar las ventas cuyo total sea menor al monto dado,
    % así en la lista solo se incluyen los datos que cumplan con esa condición

    % Devuelve una lista con el id del cliente, el nombre del producto, la canidad y el total
    findall((IdCliente, Producto, Cantidad, Total),
    (venta(_, IdCliente, Producto, Cantidad), producto(Producto, _, PrecioUnitario), Total is PrecioUnitario * Cantidad, Total < Monto), Lista),
    imprimir_lista_compras(Lista).

% Se imprime la lista de compras formateada
% Se crea una función imprimir_lista_compras vacía para que corte la recursividad cuando se vacía la lista
imprimir_lista_compras([]).
% Se toma el primer elemento (cabecera) de la lista y se crea Resto, una lista con las demás compras
imprimir_lista_compras([(IdCliente, Producto, Cantidad, Total) | Resto]) :-
    cliente(IdCliente, Nombre, _),
    % ~w es un especificador se utiliza para imprimir cualquier término Prolog de manera predeterminada
    % ~n añade un salto de línea
    format('cliente: ~w~nproducto: ~w~ncantidad: ~w~ntotal: ~2f~n~n', [Nombre, Producto, Cantidad, Total]),
    % Se llama recursivamente hasta vaciar la lista
    imprimir_lista_compras(Resto).

% Se imprime una lista con las ventas realizadas entre dos fechas dadas (incluidas ambas)
ventas_entre_fechas(FechaInicio, FechaFin) :-
    format('VENTAS ENTRE ~w Y ~w~n', [FechaInicio, FechaFin]),
    % Devuelve una lista con la fecha, el nombre del cliente, el nombre del producto
    % y la cantidad de todas las ventas que tengan las fechas dadas o que este entre estas
    findall((Fecha, NombreCliente, Producto, Cantidad),
    (venta(Fecha, IdCliente, Producto, Cantidad),cliente(IdCliente, NombreCliente, _), Fecha @>= FechaInicio, Fecha @=< FechaFin), Lista),
    imprimir_lista_ventas(Lista).

%************* STOCK *************

% Stock de productos tiene nombre del producto y cantidad disponible.
stock(helado_dulce_de_leche, 10).
stock(helado_americana, 5).
stock(helado_frutilla, 7).
stock(helado_banana_split, 8).
stock(helado_chocolate_amargo, 6).
stock(helado_menta_granizada, 5).
stock(helado_durazno, 9).
stock(helado_limon, 12).
stock(helado_kinotos_al_whisky, 4).
stock(helado_tiramisu, 6).
stock(helado_crema_del_cielo, 4).

% Predicado para cargar más stock para un producto existente.
cargar_stock(Producto, CantidadNueva) :-
    % Se elimina el stock del producto indicado de la base de datos
    retract(stock(Producto, StockActual)),
    % Se calcula el nuevo stock
    NuevoStock is StockActual + CantidadNueva,
    % Se agrega a la base de datos el nuevo stock
    assert(stock(Producto, NuevoStock)),
    writeln('Stock actualizado exitosamente.').

% Se imprime una lista con el stock disponible de cada producto
lista_stock :-
    writeln('LISTA DE STOCK:'),
    % Devuelve una lista con el nombre del producto y la cantidad en stock
    findall((Producto, Cantidad), stock(Producto, Cantidad), Lista),
    imprimir_lista_stock(Lista).

% Imprime la lista de stock formateada
% Se crea una función imprimir_lista_stock vacía para que corte la recursividad cuando se vacía la lista
imprimir_lista_stock([]).
% Se toma el primer elemento (cabecera) de la lista y se crea Resto, una lista con los demás productos del stock
imprimir_lista_stock([(Producto, Cantidad) | Resto]) :-
    % ~w es un especificador se utiliza para imprimir cualquier término Prolog de manera predeterminada
    % ~n añade un salto de línea
    format('producto: ~w~ncantidad: ~w~n~n', [Producto, Cantidad]),
    % Se llama recursivamente hasta vaciar la lista
    imprimir_lista_stock(Resto).
    
% Se actualiza el stock de un producto después de realizar una venta
disminuir_stock(Producto, Cantidad) :-
    % Se consulta el stock actual del producto
    stock(Producto, StockActual),
    % Se calcula eel nuevo stock
    NuevoStock is StockActual - Cantidad,
    % Se elimina el hecho (el stock de ese producto) de la base de datos
    retract(stock(Producto, StockActual)),
    % Se inserta el nuevo hecho (el stock de ese producto actualizado) recién creado en la base de datos
    assert(stock(Producto, NuevoStock)).

% Se comprueba si hay suficiente stock para realizar una venta
verificar_stock(Producto, Cantidad) :-
    stock(Producto, StockActual),
    StockActual >= Cantidad.
