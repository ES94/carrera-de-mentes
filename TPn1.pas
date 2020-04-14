program Carrera_de_Mente;

uses crt;

const 
    MaxCasillas = 100;
    sDirectorio = 'D:\DatosTP1';

type
    Jugador = record
        Nombre: string;
        PosClavija: integer;
        vEstrellas: array [0..5] of integer; //<---Este es el campo estrellas que cambié a vector de estrellas.
    end;
    
    Casillero = record
        Numero, Estado: integer;
        Color: string;
        Estrella: boolean;
    end;
    
    Pregunta = record
        Trivia, Respuesta, Color: string[255];
        vOpciones: array [1..3] of string[255];
        Estado, Numero: integer;
    end;

    Categoria = record
        Nombre, Color: string;
        vPreguntas: array [1..6] of Pregunta; //<---Este es el campo pregunta que cambié a vector de preguntas.
        Estado: integer;
    end;
    
var 
    listaJugadores: array [0..5] of Jugador;
    listaCasilleros: array [0..MaxCasillas - 1] of Casillero;
    fCasilleros: file of Casillero;
    fCategorias: file of Categoria;
    fPreguntas: file of Pregunta;
    i, j, k, posMenu: integer;
    charOpcion: char;
    boolCasilleros, boolCategorias, boolPreguntas: boolean;    
    vectorPpal: array [0..3] of string;
    vectorOp: array [0..2] of string;
    vectorOp1, vectorOp2, vectorOp3: array [0..1] of string;

function FncTirarDados: integer;
var 
    intDado: integer;

begin
    intDado := 0;
    randomize;
    intDado := random(6) + 1;
    FncTirarDados := intDado;
end;

function FncLeer(var tecla: char; tipo: boolean; longitud, posX, posY: integer): string;
var 
    palabra: string[255];
    num, error, x, i: integer;

begin
    gotoXY(posX, posY);

    for i := 0 to longitud-1 do
    begin
        writeln(' ');
        gotoXY(posX + i, posY);
    end;

    gotoXY(posX, posY);
    tecla := readKey;
    palabra := '';
    x := 1;
    error := 0;

    while (ord(tecla) <> 27) and (ord(tecla) <> 13) do //Mientras no se presione ni Enter ni Escape...
    begin
        if (ord(tecla) = 8) then //Si se presiona BackSpace...
        begin
            if (Length(palabra) <> 0) then //Si la longitud de lo ingresado es mayor a cero...
            begin
                Delete(palabra, x-1, 1);
                x := x - 1;
                gotoXY(posx + x-1, posY);
                write(' ');
                gotoXY(posX + x-1, posY);
            end;
        end
        else if (x < longitud) then //Si lo ingresado no supera la cantidad máxima de caracteres...
        begin
            val(tecla, num, error); //Se intenta convertir lo ingresado a un número.

            if (tipo = true) and (error = 0) then //Si lo ingresado y lo que se debe ingresar es un número...
            begin
                tecla := upcase(tecla);
                write(tecla);
                insert(tecla, palabra, x);
                inc(x);
            end;
            
            if (tipo = false) and (error <> 0) then //Si lo ingresado y lo que se debe ingresar es una cadena...
            begin
                tecla := upcase(tecla);
                write(tecla);
                insert(tecla, palabra, x);
                inc(x);
            end;
        end
        else
        begin
            sound(320);
            delay(100);
            noSound;
        end;

        tecla := readKey;
    end;

    if ord(tecla) = 27 then
        palabra := '';

    FncLeer := palabra;
end;    

procedure PantallaPpal;
var
    i, j: integer;

begin
    //Fondo de pantalla.
    textBackground(red);
    textColor(white);    

    for i := 2 to 49 do
        begin
            gotoXY(1, i);
            write('                                                                                                                                                                ');
        end;
        
    //imagen de carrera de mentes
    gotoXY(1, 3);
    writeln ('       CGGCCCCCCGCCCCCCCCGGCGOOOOC                                                              OOOOOOOOOOOOOOOOOOOOOOOOOO');
    writeln ('       CCGCCCCCCCCCCCCCCCCCGCCGO                                                                 OOOOOOOOOOOOOOOOOOOOOOOOO');
    writeln ('       OOOGCGCGCCCCCCCCCCCCGGGG                                                                   GOOOOOOOOOOOOOOOOOOOOOOO');
    writeln ('       OOOOOOGCGCCCCGCCCCGGCCG                                                                     COOOOOOOOOOOOOOOOOOOOOO');
    writeln ('       OOOOOOOOOOGGGGCCCGCCGC                                                                        OOOOOOOOOOOOOOOOOOOOO');
    writeln ('       OOOOOOOOOOOOOGGCCCGCC                                                                          OOOOOOOOOOOOOOOOOOOO');
    writeln ('       OOOOOOOOOOOOOOOOOGGC                                                                            OOOOOOOOOOOOOOOOOOO');
    writeln ('       OOOOOOOOOOOOOOOOOOC                                                                              OOOOOOOOOOOOOOOOOO');
    writeln ('       OOOOOOOOOOOOOOOOO                                                                                 GOOOOOOOOOOOOOOOO');
    writeln ('       OOOOOOOOOOOOOOOO        CO00OGG   CG      CCCGCC     CGGGOOC     CCCCCGG  CCCGGCC                  GOOOOOOOOOOOOOOO');
    writeln ('       OOOOOOOOOOOOOOO      O0O          000     G00   C00   O0G  000   00C       00    00C     000        COOOOOOOOOOOOOO');
    writeln ('       0000000OOOOOOO      00           0CC00    G00    00O  O0G   00   C0C       00    C00    0GG00         OOOOOOOGGGGGC');
    writeln ('       000000000000G      000          0G  O00   C0O    00   O00000     C000000   00    00    GO  00O         GCGGGCCCCCCG');
    writeln ('       00000000000C       000         G0oooo00G  C00GGO00    O0C  00    G0C       00GGG00    C0oooo00C         GGCCCCCCCCC');
    writeln ('       0000000000         O00        G0C    C00G C00    00C  00O   O00  C0C       00    00O C0G    C00          CGGCCCCCCG');
    writeln ('       000000000           000       G           000     G00C           0000000G O00     C00G                    CCCCCCCCC');
    writeln ('       00000000              000GCCG00                                                                            CGGCGCCC');
    writeln ('       0000000                                          00       00C        G00    00 CCCCCCC 00OGG0G              CCCCCCC');
    writeln ('       OOOOOOG                     O0CCG0O  O0OO00      O00     000  00GGG0  000   GGO   G0   00                    000000');
    writeln ('       OOOOOOO                     G0    00 00          OC0G   OC00  00      0 O0C CO    G0   00                   G000000');
    writeln ('       OOOOOOOO                    G0    O0 00OO00     CG O0  CO O0  00GGOO  0  C00CO    G0   G0CCCO              G0000000');
    writeln ('       OOOOOOOOO                   G0    0C 00         GC  00 0  G0  00      0    00O    G0   O0                 O00000000');
    writeln ('       OOOOOOOOOOC                 00000O   OCCCCC     0C   00   O0CG000000 GGG    CG    00G  00OGG0G           0000000000');
    writeln ('       OOOOOOOOOOOC                                                                                            00000000000');
    writeln ('       OOOOOOOOOOOOG                                                                                          000000000000');
    writeln ('       OOOOOOOOOOOOOO                                                                                       COOOOOOOO00000');
    writeln ('       OOOOOOOOOOOOOOO                                                                                     COOOOOOOOOOOOOO');
    writeln ('       OOOOOOOOOOOOOOOO                                                                                   OOOOOOOOOOOOOOOO');
    writeln ('       OOOOOOOOOOOOOOOOO                                                                                 0OOOOOOOOOOOOOOOO');
    writeln ('       OOOOOOOOOOOOOOOOOOC                                                                              0OOOOOOOOOOOOOOOOO');
    writeln ('       OOOOOOOOOOOOOOOO000G                                                                            0000OOOOOOOOOOOOOOO');
    writeln ('       OOOOOOOOOOOOO00000000                                                                          00000000OOOOOOOOOOOO');
    writeln ('       OOOOOOOOO0000000000000                                                                       C0000000000000OOOOOOOO');
    writeln ('       OOOOOO00000000000000008                                                                     G00000000000000000OOOOO');
    writeln ('       OO0000000000000000000000                                                                   00000000000000000000000O');
    writeln ('       000000000000000000000000OC                                                                OO00000000000000000000000');
    writeln ('       0000000000000000000000OOOOC                                                              OOOOO000000000000000000000');


    //Delimitadores horizontales de pantalla.
    for i := 1 to 160 do
    begin
        gotoXY(i, 40);
        write('_');
    end;    

    //Delimitadores verticales de pantalla.
    for i := 2 to 40 do
    begin
        gotoXY(130, i);
        write('|');
    end;    

    //Opciones de la barra negra superior.
    textBackground(black);
    gotoXY(1, 1);
        
    for i := 0 to 3 do
        write(' ', vectorPpal[i], ' |');
        
    //Contenido de la barra negra inferior.
    gotoXY(124,50);
    write('   Escape = salir | Enter = aceptar');
    
    textBackground(red);

    //Etiqueta de la pantalla de información.
    gotoXY(1, 41);
    write('Informacion');    
    
    //borrar imagen de carrera de mentes:
    gotoXY(1, 3);
    delay(1750);
    for i := 1 to 37 do
    begin
        writeln ('                                                                                                                           ');
        delay(20);
    end;    
end;

procedure PrcConfiguracion;
var
    i, j, posSubMenu: integer;
    charOpcionSub: char;

    procedure PrcCasilleros;
    var
        i, j, posSubMenu1: integer;
        charOpcionSub1: char;
        varCasillero: Casillero;
        
        function FncAltaCasilleros: boolean;
        var 
            retorno, flag, b: boolean;
            i, j, numCasilla: integer;
            strColor, strEstrella: string;            
        
        begin
            reset(fCasilleros);

            //Cuadro de diálogo.
            textBackground(white);

            for i := 7 to 35 do
                begin
                    gotoXY(20, i);
                    write('                                                                                          ');    
                end;           
            
            //Texto del cuadro de diálogo.
            textColor(black);
            
            gotoXY(55, 7);
            write('ALTA DE CASILLEROS');
            gotoXY(22, 12);
            write('Color de casillero:');
            gotoXY(43, 12);
            write('(V, A, C, R, M, N, o G)');
            gotoXY(22, 15);
            write('Estrella:');
            gotoXY(33, 15);
            write('(S o N)');

            //Campos de edición.
            textBackground(red);

            gotoXY(41, 12);
            write('  ');
            gotoXY(31, 15);
            write('  ');

            //Texto de la barra de estado.
            textColor(white);
            textBackground(black);

            gotoXY(104, 50);
            write('Escape = cancelar |');             
            
            //CÓDIGO PRINCIPAL.
            retorno := false;

            repeat
                i := 0;
                flag := false;                

                //Código para obtener el número del nuevo casillero.
                while flag = false do
                begin
                    inc(i);
                    b := false;
                    seek(fCasilleros, 0); //Se posiciona al comienzo del archivo.

                    while (b = false) and (not eof(fCasilleros)) do
                    begin
                        read(fCasilleros, varCasillero);
                        numCasilla := i;

                        //Si encuentra un casillero que coincida con el número...
                        if varCasillero.Numero = i then
                            b := true; //Torna en "true" la bandera 'b', indicando que 'i' es un número que no se debe utilizar.                        
                    end;

                    //Si la bandera 'b' es "false", torna en "true" la bandera 'flag', indicando que se encontró un número libre.
                    if b = false then
                        flag := true;
                end;

                textColor(black);
                textBackground(white);

                gotoXY(22, 10);
                write('Casillero nro. ', numCasilla);

                textColor(white);
                textBackground(red);
                
                flag := false; //Se inicializa la bandera como "false".
                strColor := FncLeer(charOpcionSub1, false, 2, 41, 12); //Se ingresa la opción de color.

                //Si lo ingresado como color es válido...
                if ord(charOpcionSub1) <> 27 then
                begin
                    if (strColor <> '') and ((strColor = 'R') or (strColor = 'V') or (strColor = 'N') or (strColor = 'A') or (strColor = 'C') or (strColor = 'M') or (strColor = 'G')) then
                    begin
                        varCasillero.Color := strColor; //Se le asigna virtualmente el color al casillero.
                        flag := true; //Se torna en "true" la bandera, indicando que se ingresó una opción válida.
                    end
                    else                
                        //Mientras la opción de color ingresada sea inválida...                
                        while (flag = false) and (ord(charOpcionSub1) <> 27) do
                        begin
                            //Si lo ingresado como color es válido...
                            if (strColor <> '') and ((strColor = 'R') or (strColor = 'V') or (strColor = 'N') or (strColor = 'A') or (strColor = 'C') or (strColor = 'M') or (strColor = 'G')) then
                            begin
                                varCasillero.Color := strColor; //Se le asinga virtualmente el color al casillero.
                                flag := true; //Se torna en "true" la bandera, indicando que se ingresó una opción válida.
                            end
                            //Si lo ingresado como color no es válido...
                            else
                            begin
                                textColor(white);
                                textBackground(red);

                                gotoXY(1, 43);

                                //Si no se ingresó nada como opción...
                                if strColor = '' then
                                    write('Debe completar el campo. Por favor, ingrese una de las opciones validas.');                        

                                //Si se ingresó algo inválido como color...
                                if strColor <> '' then                        
                                    write('El valor ingresado no es valido. Por favor, ingrese una opcion valida.');

                                delay(1750);
                                gotoXY(1, 43);
                                write('                                                                         ');                        

                                strColor := FncLeer(charOpcionSub1, false, 2, 41, 12); //Se ingresa la opción de color.
                            end;
                        end;                    

                    //Si la lectura de color no se canceló, se realiza la lectura de la estrella...
                    if flag = true then
                    begin
                        textColor(white);
                        textBackground(red);

                        strEstrella := FncLeer(charOpcionSub1, false, 2, 31, 15); //Lectura de estrella del casillero.

                        //Si no se presiona "esc"...
                        if ord(charOpcionSub1) <> 27 then
                            //Si se ingresa una opción válida...
                            if (strEstrella <> '') and ((strEstrella = 'S') or (strEstrella = 'N')) then
                            begin
                                //Si se ingresó 'S'...
                                if strEstrella = 'S' then
                                    varCasillero.Estrella := true //Se le asigna una estrella al casillero.
                                //Si se ingresó 'N'...
                                else
                                    varCasillero.Estrella := false; //No se le asigna una estrella al casillero.

                                varCasillero.Numero := numCasilla; //Se le asigna su número correspondiente al casillero.
                                varCasillero.Estado := 0; //Se pone al casillero en estado "Activo".

                                seek(fCasilleros, fileSize(fCasilleros)); //se ubica al puntero al final del archivo.
                                write(fCasilleros, varCasillero); //Se graba el casillero en el archivo.

                                //Se muestra un mensaje en la barra de estado.
                                textColor(white);
                                textBackground(black);

                                gotoXY(2, 50);
                                write('Casillero guardado');
                                delay(1500);
                                gotoXY(2, 50);
                                write('                  ');                                
                            end
                            //Si no se ingresa una opción válida...
                            else
                                //Mientras la opción de estrella ingresada sea inválida...
                                while (flag = true) and (ord(charOpcionSub1) <> 27) do
                                begin
                                    //Si la opción ingresada es válida...
                                    if (strEstrella <> '') and ((strEstrella = 'S') or (strEstrella = 'N')) then
                                    begin
                                        if strEstrella = 'S' then
                                            varCasillero.Estrella := true
                                        else
                                            varCasillero.Estrella := false;

                                        varCasillero.Numero := numCasilla; //Se le asigna su número correspondiente al casillero.
                                        varCasillero.Estado := 0; //Se pone al casillero en estado "Activo".

                                        seek(fCasilleros, fileSize(fCasilleros)); //se ubica al puntero al final del archivo.
                                        write(fCasilleros, varCasillero); //Se graba el casillero en el archivo.

                                        //Se muestra un mensaje en la barra de estado.
                                        textColor(white);
                                        textBackground(black);

                                        gotoXY(2, 50);
                                        write('Casillero guardado');
                                        delay(1500);
                                        gotoXY(2, 50);
                                        write('                  ');

                                        flag := false;
                                    end
                                    //Si la opción ingresada no es válida...
                                    else
                                    begin
                                        textColor(white);
                                        textBackground(red);

                                        gotoXY(1, 43);

                                        if strEstrella = '' then
                                            write('Debe completar el campo. Por favor, ingrese una de las opciones validas.');

                                        if strEstrella <> '' then
                                            write('El valor ingresado no es valido. Por favor, ingrese una opcion valida.');

                                        delay(1750);
                                        gotoXY(1, 43);
                                        write('                                                                         ');

                                        strEstrella := FncLeer(charOpcionSub1, false, 2, 31, 15);
                                    end;
                                end;
                    end;
                    
                    //Se limpian los campos de edición.
                    textBackground(red);
                    gotoXY(41, 12);
                    write('  ');
                    gotoXY(31, 15);
                    write('  ');
                end;
            until ord(charOpcionSub1) = 27;
            
            //Se borra la opción de la barra de estado.
            textBackground(black);
            
            gotoXY(104, 50);
            write('                   ');
            
            //Se borra el cuadro de diálogo.
            textBackground(red);

            for i := 5 to 35 do
                begin
                    gotoXY(20, i);
                    write('                                                                                          ');    
                end;
 
            close(fCasilleros);
            FncAltaCasilleros := retorno;
        end;

        procedure PrcBuscarCasilleros;
        var 
            charAccion: char;
            respuesta: string;
            flag, b, a, c, encontrado: boolean;
            resultado, varCasillero: casillero;
            i, j, k, errVal, numVal, menuAcciones, posResultado: integer;
            vAcciones: array [0..3] of string;

        begin
            reset(fCasilleros);

            vAcciones[0] := 'Modificar color';
            vAcciones[1] := 'Modificar estrella';
            vAcciones[2] := 'Eliminar';
            vAcciones[3] := 'Salir';
            menuAcciones := 0;

            //Barra de estado.
            textColor(white);
            textBackground(black);

            gotoXY(104, 50);
            write('Escape = cancelar |');
            
            //Cuadro de diálogo.
            textBackground(white);

            for i := 7 to 35 do
                begin
                    gotoXY(20, i);
                    write('                                                                                          ');    
                end; 
            
            flag := false; //Corta el ciclo de búsqueda.        

            //Mientras no se cancele la búsqueda de casilleros...
            while (flag = false) and (ord(charOpcionSub1) <> 27) do
            begin
                textColor(black);
                textBackground(white);

                gotoXY(51, 7);
                write('BUSQUEDA DE CASILLEROS');
                gotoXY(22, 12);
                write('Ingresar numero de casillero:');

                textColor(white);
                textBackground(red);

                gotoXY(51, 12);
                write('  ');                

                respuesta := FncLeer(charOpcionSub1, true, 3, 51, 12); //Se ingresa el parámetro.

                //Si no se presionó escape en el ingreso de datos...
                if ord(charOpcionSub1) <> 27 then
                begin                    
                    //Si no se dejó vacio el campo...
                    if respuesta <> '' then
                    begin
                        //Búsqueda.
                        encontrado := false;
                        seek(fCasilleros, 0);
                        val(respuesta, numVal, errVal);
                                
                        while (not eof(fCasilleros)) and (encontrado = false) do
                        begin
                            read(fCasilleros, varCasillero);

                            if varCasillero.Numero = numVal then
                            begin
                                posResultado := filePos(fCasilleros) - 1;
                                resultado := varCasillero;
                                encontrado := true;
                            end;
                        end;

                        //Limpia el cuadro de diálogo para mostrar el resultado.
                        textColor(black);                                
                        textBackground(white);

                        for i := 8 to 35 do
                        begin
                            gotoXY(20, i);
                            write('                                                                                          ');    
                        end; 

                        //Si se encontró un casillero...
                        if encontrado = true then
                        begin
                            gotoXY(22, 12);
                            write('Resultado:');
                            gotoXY(22, 13);
                            write('Nro.: ', resultado.Numero, '  Color: ', resultado.Color, '  Estrella: ');

                            //Si tiene estrella...
                            if resultado.Estrella then
                                write('si  ')
                            //Si no tiene estrella...
                            else
                                write('no  ');

                            write('Estado: ');

                            //Si está activo...
                            if resultado.Estado = 0 then
                                write('activo')
                            //Si está inactivo...
                            else
                                write('inactivo');

                            //Se muestran las acciones disponibles.
                            a := false;
                                    
                            gotoXY(22, 16);
                            write('Acciones disponibles:');
                                    
                            gotoXY(24, 17);
                            write('-', vAcciones[0]);
                            gotoXY(24, 18);
                            write('-', vAcciones[1]);
                            gotoXY(24, 19);
                            write('-', vAcciones[2]);
                            gotoXY(24, 20);
                            write('-', vAcciones[3]);

                            //Selector de acciones disponibles.
                            repeat                                        
                                for i := 0 to 3 do
                                begin
                                    if menuAcciones = i then
                                    begin
                                        textBackground(blue);
                                        textColor(white);
                                    end
                                    else
                                    begin
                                        textBackground(white);
                                        textColor(black);
                                    end;

                                    gotoXY(24, i + 17);
                                    write('-', vAcciones[i]);
                                end;

                                charAccion := readKey;

                                case ord(charAccion) of
                                    //Flecha abajo.
                                    80: if menuAcciones < 3 then
                                        menuAcciones := menuAcciones + 1;

                                    //Flecha arriba.
                                    72: if menuAcciones > 0 then
                                        menuAcciones := menuAcciones - 1;

                                    13: case menuAcciones of
                                        0: //Modificar color.
                                        begin
                                            textColor(black);
                                            textBackground(white);

                                            gotoXY(22, 25);
                                            write('Ingrese un color nuevo: ');

                                            textColor(white);
                                            textBackground(red);

                                            //Campo de edición.
                                            gotoXY(46, 25);
                                            write('  ');                                                        

                                            respuesta := FncLeer(charOpcionSub1, false, 2, 46, 25);

                                            while (respuesta <> 'V') and (respuesta <> 'A') and (respuesta <> 'C') and (respuesta <> 'R') and (respuesta <> 'M') and (respuesta <> 'N') and (respuesta <> 'G') do
                                            begin
                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(1, 43);
                                                write('Color invalido. ingrese una opcion valida.');
                                                delay(1750);
                                                gotoXY(1, 43);
                                                write('                                          ');

                                                //Campo de edición.
                                                gotoXY(46, 25);
                                                write('  ');

                                                textColor(black);
                                                textBackground(white);

                                                gotoXY(22, 25);
                                                write('Ingrese un color nuevo: ');

                                                textColor(white);
                                                textBackground(red);

                                                respuesta := FncLeer(charOpcionSub1, false, 2, 46, 25);
                                            end;

                                            gotoXY(1, 43);
                                            write('                              ');

                                            resultado.Color := respuesta;
                                            seek(fCasilleros, posResultado);
                                            write(fCasilleros, resultado);

                                            //Notificación.
                                            textColor(white);
                                            textBackground(black);

                                            gotoXY(1, 50);
                                            write('Color cambiado');
                                            delay(1500);
                                            gotoXY(1, 50);
                                            write('              ');

                                            //Se borra el campo y el texto de edición.
                                            textBackground(white);

                                            gotoXY(22, 25);
                                            write('                           ');
                                        end;

                                        1: //Modificar estrella.
                                        begin
                                            textColor(white);
                                            textBackground(red);
                                            
                                            gotoXY(1, 43);
                                            write('Ingrese nuevo valor de estrella: ');                                                        

                                            respuesta := FncLeer(charOpcionSub1, false, 2, 34, 43);

                                            while (respuesta = '') or ((respuesta <> 'S') and (respuesta <> 'N')) do
                                            begin
                                                gotoXY(1, 43);
                                                write('Respuesta invalida. ingrese una opcion valida.');
                                                delay(1750);
                                                gotoXY(1, 43);
                                                write('                                              ');
                                                gotoXY(1, 43);
                                                write('Ingrese nuevo valor de estrella: ');
                                                            
                                                respuesta := FncLeer(charOpcionSub1, false, 2, 34, 43);
                                            end;

                                            gotoXY(1, 43);
                                            write('                                   ');

                                            if respuesta = 'S' then
                                                resultado.Estrella := true
                                            else
                                                resultado.Estrella := false;                                            
                                            
                                            seek(fCasilleros, posResultado);
                                            write(fCasilleros, resultado);

                                            //Notificación.
                                            textColor(white);
                                            textBackground(black);

                                            gotoXY(1, 50);
                                            write('Estrella cambiada');
                                            delay(1500);
                                            gotoXY(1, 50);
                                            write('                 ');
                                        end;

                                        2: //Eliminar casillero.
                                        begin
                                            //Pregunta.
                                            textColor(white);
                                            textBackground(red);

                                            gotoXY(1, 43);
                                            write('Desea eliminar el casillero actual? (S/N): ');
                                            
                                            respuesta := FncLeer(charOpcionSub1, false, 2, 44, 43);

                                            if (respuesta = 'S') or (respuesta = 'N') then
                                            begin
                                                if respuesta = 'S' then
                                                begin
                                                    resultado.Estado := 99;
                                                    seek(fCasilleros, posResultado);
                                                    write(fCasilleros, resultado);

                                                    //Notificación.
                                                    textColor(white);
                                                    textBackground(black);

                                                    gotoXY(1, 50);
                                                    write('Casillero eliminado');
                                                    delay(1500);
                                                    gotoXY(1, 50);
                                                    write('                   ');
                                                end;

                                                textBackground(red);

                                                gotoXY(1, 43);
                                                write('                                                          ');
                                            end
                                            else
                                            begin
                                                c := false;

                                                while c = false do
                                                begin
                                                    textColor(white);
                                                    textBackground(red);
                                                    
                                                    gotoXY(1, 43);
                                                    write('Respuesta invalida. ingrese una opcion valida.');
                                                    delay(1750);
                                                    gotoXY(1, 43);
                                                    write('                                              ');
                                                    gotoXY(1, 43);
                                                    write('Desea eliminar el casillero actual? (S/N): ');
                                            
                                                    respuesta := FncLeer(charOpcionSub1, false, 2, 44, 43);

                                                    if (respuesta = 'S') or (respuesta = 'N') then
                                                    begin
                                                        c := true;

                                                        if respuesta = 'S' then
                                                        begin
                                                            resultado.Estado := 99;
                                                            seek(fCasilleros, posResultado);
                                                            write(fCasilleros, resultado);

                                                            //Notificación.
                                                            textColor(white);
                                                            textBackground(black);

                                                            gotoXY(1, 50);
                                                            write('Casillero eliminado');
                                                            delay(1500);
                                                            gotoXY(1, 50);
                                                            write('                   ');
                                                        end;

                                                        textBackground(red);

                                                        gotoXY(1, 43);
                                                        write('                                                          ');
                                                    end;
                                                end;
                                            end;
                                        end;

                                        3: a := true; //Opción 'Salir'.
                                    end;

                                    27: a := true; //Opción 'Salir'.
                                end;
                            until a = true;
                        end
                        //Si no hubo resultado...
                        else
                        begin
                            gotoXY(22, 15);
                            write('NO SE ENCONTRARON RESULTADOS. PRESIONE CUALQUIER TECLA PARA CONTINUAR.');
                            charOpcionSub1 := readKey;

                            if ord(charOpcionSub1) = 27 then
                            begin
                                //Se borra el cuadro de diálogo.
                                textBackground(red);

                                for i := 5 to 35 do
                                begin
                                    gotoXY(20, i);
                                    write('                                                                                          ');    
                                end; 
                            end;
                
                            gotoXY(22, 15);
                            write('                                                                      ');
                        end;
                    end
                    //Si no se llenó el campo...
                    else
                    begin
                        b := false;

                        //Mientras no se complete el campo y no se presione escape...
                        while (b = false) and (ord(charOpcionSub1) <> 27) do
                        begin
                            gotoXY(1, 43);
                            write('Debe completar el campo.');
                            delay(1750);
                            gotoXY(1, 43);
                            write('                        ');

                            respuesta := FncLeer(charOpcionSub1, true, 3, 51, 12);

                            //Si la respuesta es válida y no se presionó escape...
                            if (ord(charOpcionSub1) <> 27) and (respuesta <> '') then
                            begin
                                b := true;
                                encontrado := false;
                                seek(fCasilleros, 0);
                                val(respuesta, numVal, errVal);
                                
                                while (not eof(fCasilleros)) and (encontrado = false) do
                                begin
                                    read(fCasilleros, varCasillero);

                                    if varCasillero.Numero = numVal then
                                    begin
                                        posResultado := filePos(fCasilleros) - 1;
                                        resultado := varCasillero;
                                        encontrado := true;
                                    end;
                                end;

                                //Limpia el cuadro de diálogo para mostrar el resultado.
                                textColor(black);                                
                                textBackground(white);

                                for i := 8 to 35 do
                                    for j := 20 to 110 do
                                    begin
                                        gotoXY(j, i);
                                        write(' ');    
                                    end;

                                //Si se encontró un casillero...
                                if encontrado = true then
                                begin
                                    gotoXY(22, 12);
                                    write('Resultado:');
                                    gotoXY(22, 13);
                                    write('Nro.: ', resultado.Numero, '  Color: ', resultado.Color, '  Estrella: ');

                                    //Si tiene estrella...
                                    if resultado.Estrella then
                                        write('si  ')
                                    //Si no tiene estrella...
                                    else
                                        write('no  ');

                                    write('Estado: ');

                                    //Si está activo...
                                    if resultado.Estado = 0 then
                                        write('activo')
                                    //Si está inactivo...
                                    else
                                        write('inactivo');

                                    //Se muestran las acciones disponibles.
                                    a := false;
                                    
                                    gotoXY(22, 16);
                                    write('Acciones disponibles:');
                                    
                                    gotoXY(24, 17);
                                    write('-', vAcciones[0]);
                                    gotoXY(24, 18);
                                    write('-', vAcciones[1]);
                                    gotoXY(24, 19);
                                    write('-', vAcciones[2]);
                                    gotoXY(24, 20);
                                    write('-', vAcciones[3]);

                                     //Selector de acciones disponibles.
                                    repeat                                        
                                        for i := 0 to 3 do
                                        begin
                                            if menuAcciones = i then
                                            begin
                                                textBackground(blue);
                                                textColor(white);
                                            end
                                            else
                                            begin
                                                textBackground(white);
                                                textColor(black);
                                            end;

                                            gotoXY(24, i + 17);
                                            write('-', vAcciones[i]);
                                        end;

                                        charAccion := readKey;

                                        case ord(charAccion) of
                                            //Flecha abajo.
                                            80: if menuAcciones < 3 then
                                                menuAcciones := menuAcciones + 1;

                                            //Flecha arriba.
                                            72: if menuAcciones > 0 then
                                                menuAcciones := menuAcciones - 1;

                                            13: case menuAcciones of
                                                    0: //Modificar color.
                                                    begin
                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(22, 25);
                                                        write('Ingrese un color nuevo: ');

                                                        textColor(white);
                                                        textBackground(red);

                                                        //Campo de edición.
                                                        gotoXY(46, 25);
                                                        write('  ');                                                        

                                                        respuesta := FncLeer(charOpcionSub1, false, 2, 46, 25);

                                                        while (respuesta <> 'V') and (respuesta <> 'A') and (respuesta <> 'C') and (respuesta <> 'R') and (respuesta <> 'M') and (respuesta <> 'N') and (respuesta <> 'G') do
                                                        begin
                                                            textColor(white);
                                                            textBackground(red);
                                                            
                                                            gotoXY(1, 43);
                                                            write('Color invalido. ingrese una opcion valida.');
                                                            delay(1750);
                                                            gotoXY(1, 43);
                                                            write('                                          ');
                                                            
                                                            //Campo de edición.
                                                            gotoXY(46, 25);
                                                            write('  ');

                                                            textColor(black);
                                                            textBackground(white);

                                                            gotoXY(22, 25);
                                                            write('Ingrese un color nuevo: ');

                                                            textColor(white);
                                                            textBackground(red);

                                                            respuesta := FncLeer(charOpcionSub1, false, 2, 46, 25);
                                                        end;

                                                        gotoXY(1, 43);
                                                        write('                           ');

                                                        resultado.Color := respuesta;
                                                        seek(fCasilleros, posResultado);
                                                        write(fCasilleros, resultado);

                                                        //Notificación.
                                                        textColor(white);
                                                        textBackground(black);

                                                        gotoXY(1, 50);
                                                        write('Color cambiado');
                                                        delay(1500);
                                                        gotoXY(1, 50);
                                                        write('              ');

                                                        //Se borra el campo y el texto de edición.
                                                        textBackground(white);

                                                        gotoXY(22, 25);
                                                        write('                           ');
                                                    end;

                                                    1: //Modificar estrella.
                                                    begin
                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(1, 43);
                                                        write('Ingrese nuevo valor de estrella: ');                                                        

                                                        respuesta := FncLeer(charOpcionSub1, false, 2, 34, 43);

                                                        while (respuesta = '') or ((respuesta <> 'S') and (respuesta <> 'N')) do
                                                        begin
                                                            gotoXY(1, 43);
                                                            write('Respuesta invalida. ingrese una opcion valida.');
                                                            delay(1750);
                                                            gotoXY(1, 43);
                                                            write('                                              ');
                                                            gotoXY(1, 43);
                                                            write('Ingrese nuevo valor de estrella: ');
                                                            
                                                            respuesta := FncLeer(charOpcionSub1, false, 2, 34, 43);
                                                        end;

                                                        gotoXY(1, 43);
                                                        write('                                   ');

                                                        if respuesta = 'S'  then
                                                            resultado.Estrella := true
                                                        else
                                                            resultado.Estrella := false;

                                                        seek(fCasilleros, posResultado);
                                                        write(fCasilleros, resultado);

                                                        //Notificación.
                                                        textColor(white);
                                                        textBackground(black);

                                                        gotoXY(1, 50);
                                                        write('Estrella cambiada');
                                                        delay(1500);
                                                        gotoXY(1, 50);
                                                        write('                 ');
                                                    end;

                                                    2: //Eliminar casillero.
                                                    begin
                                                        //Pregunta.
                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(1, 43);
                                                        write('Desea eliminar el casillero actual? (S/N): ');
                                            
                                                        respuesta := FncLeer(charOpcionSub1, false, 2, 44, 43);

                                                        if (respuesta = 'S') or (respuesta = 'N') then
                                                        begin
                                                            if respuesta = 'S' then
                                                            begin
                                                                resultado.Estado := 99;
                                                                seek(fCasilleros, posResultado);
                                                                write(fCasilleros, resultado);

                                                                //Notificación.
                                                                textColor(white);
                                                                textBackground(black);

                                                                gotoXY(1, 50);
                                                                write('Casillero eliminado');
                                                                delay(1500);
                                                                gotoXY(1, 50);
                                                                write('                   ');
                                                            end;

                                                            textBackground(red);

                                                            gotoXY(1, 43);
                                                            write('                                                          ');
                                                        end
                                                        else if respuesta <> 'N' then
                                                        begin
                                                            c := false;

                                                            while c = false do
                                                            begin
                                                                textColor(white);
                                                                textBackground(red);
                                                    
                                                                gotoXY(1, 43);
                                                                write('Respuesta invalida. ingrese una opcion valida.');
                                                                delay(1750);
                                                                gotoXY(1, 43);
                                                                write('                                              ');
                                                                gotoXY(1, 43);
                                                                write('Desea eliminar el casillero actual? (S/N): ');
                                            
                                                                respuesta := FncLeer(charOpcionSub1, false, 2, 44, 43);

                                                                if (respuesta = 'S') or (respuesta = 'N') then
                                                                begin
                                                                    c := true;

                                                                    if respuesta = 'S' then
                                                                    begin
                                                                        resultado.Estado := 99;
                                                                        seek(fCasilleros, posResultado);
                                                                        write(fCasilleros, resultado);

                                                                        //Notificación.
                                                                        textColor(white);
                                                                        textBackground(black);

                                                                        gotoXY(1, 50);
                                                                        write('Casillero eliminado');
                                                                        delay(1500);
                                                                        gotoXY(1, 50);
                                                                        write('                   ');
                                                                    end;

                                                                    textBackground(red);

                                                                    gotoXY(1, 43);
                                                                    write('                                                          ');
                                                                end;
                                                            end;
                                                        end;
                                                    end;

                                                    3: a := true; //Opción 'Salir'.
                                                end;

                                            27: a := true; //Opción 'Salir'.
                                        end;
                                    until a = true;
                                end
                                //Si no hubo resultado...
                                else
                                begin
                                    gotoXY(22, 15);
                                    write('NO SE ENCONTRARON RESULTADOS. PRESIONE CUALQUIER TECLA PARA CONTINUAR.');
                                    charOpcionSub1 := readKey;

                                    if ord(charOpcionSub1) = 27 then
                                    begin
                                        //Se borra el cuadro de diálogo.
                                        textBackground(red);

                                        for i := 7 to 35 do
                                        begin
                                             gotoXY(20, i);
                                             write('                                                                                          ');    
                                        end; 
                                    end;

                                    gotoXY(22, 15);
                                    write('                                                                      ');
                                end;
                            end;        
                        end;
                    end;
                end;

                //Se pregunta por la búsqueda de otro casillero...
                if ord(charOpcionSub1) <> 27 then
                begin
                    textColor(white);
                    textBackground(red);

                    gotoXY(1, 43);
                    write('Desea realizar una nueva busqueda? (S/N): ');

                    respuesta := FncLeer(charOpcionSub1, false, 3, 43, 43);
                    
                    if ord(charOpcionSub1) <> 27 then
                        gotoXY(1, 43);
                        write('                                            ');

                        if (respuesta = 'N') or (respuesta = 'S') then
                        begin
                            //Si se cancela...
                            if respuesta = 'N' then
                                flag := true //Corta el ciclo de búsqueda.
                            else
                            begin
                                textColor(black);
                                textBackground(white);

                                for i := 8 to 35 do
                                begin
                                    gotoXY(20, i);
                                    write('                                                                                          ');
                                end;
                            end;
                        end
                        //Si se ingresó un caracter inválido...
                        else
                        begin
                            b := false;

                            //Mientras no se cancele o se ingrese un caracter inválido...
                            while (b = false) and (ord(charOpcionSub1) <> 27) do
                            begin
                                gotoXY(1, 43);                                                           
                                write('                                           ');
                                gotoXY(1, 43);
                                write('Caracter invalido ingresado. Por favor, ingrese un carcter correspondiente.');
                                delay(1750);
                                gotoXY(1, 43);
                                write('                                                                           ');
                                gotoXY(1, 43);
                                write('Desea realizar una nueva busqueda? (S/N): ');

                                respuesta := FncLeer(charOpcionSub1, false, 3, 43, 43);

                                //Si no se presionó escape...
                                if ord(charOpcionSub1) <> 27 then
                                    //Si se ingresó una respuesta válida...
                                    if (respuesta = 'N') or (respuesta = 'S') then
                                    begin
                                        b := true; //Se corta el ciclo de ingreso S/N.
                                        gotoXY(1, 43);
                                        write('                                            ');
                                
                                        //Si se cancela la búsqueda de otro casillero...
                                        if respuesta = 'N' then
                                            flag := true //Corta el ciclo de búsqueda.
                                        else
                                        begin
                                            textColor(black);                                
                                            textBackground(white);

                                            for i := 8 to 35 do
                                                for j := 20 to 105 do
                                                begin
                                                    gotoXY(j, i);
                                                    write(' ');    
                                                end;
                                        end;
                                    end;
                            end;
                        end;
                end;
            end;

            //Se borra el cuadro de diálogo.
            textBackground(red);

            for i := 7 to 35 do
            begin
                gotoXY(20, i);
                write('                                                                                          ');    
            end; 

            //Se borra la opción de la barra de estado.
            textBackground(black);

            gotoXY(104, 50);
            write('                    ');

            close(fCasilleros);
        end;

    begin
        vectorOp1[0] := 'Alta    ';
        vectorOp1[1] := 'Busqueda';
        posSubMenu1 := 0;

        //Fondo del sub-submenú 'Casilleros' del submenú 'Configuracion'.
        textBackground(black);

        for i := 1 to 2 do
        begin
            gotoXY(20, i + 1);
            write('         ');
        end;

        //Opciones de 'alta' y 'buscar'.
        textColor(white);
        
        for i := 0 to 1 do
        begin
            gotoXY(20, i + 2);
            write('-', vectorOp1[i]);
        end;

        //Selector.
        while (posSubMenu1 <> -1) do
        begin
            for i := 0 to 1 do
            begin
                if posSubMenu1 = i then
                begin
                    textBackground(lightGray);
                    textColor(yellow);
                end
                else
                begin
                    textBackground(black);
                    textColor(white);
                end;

                gotoXY(20, i + 2);
                write('-', vectorOp1[i]);
            end;

            charOpcionSub1 := readKey;

            case ord(charOpcionSub1) of
                80: if posSubMenu1 < 1 then //Flecha abajo.
                    posSubMenu1 := posSubMenu1 + 1;

                72: if posSubMenu1 > 0 then //Flecha arriba.
                    posSubMenu1 := posSubMenu1 - 1;

                13: case posSubMenu1 of //Enter.
                        0: boolCasilleros := FncAltaCasilleros;
                        1: PrcBuscarCasilleros;
                    end;

                08: posSubMenu1 := -1;
            end;
        end;

        //Borra el menú.
        textBackground(red);

        for i := 2 downto 1 do
        begin
            gotoXY(20, i + 1);
            write('         ');
        end;
    end;

    procedure PrcCategorias;
    var
        i, j, posSubMenu2: integer;
        charOpcionSub2: char;
        vCategorias: Categoria;
        
        function FncAltaCategorias: boolean;
        var 
            retorno, correcto: boolean;
            i, j: integer;
            
            procedure PrcMensaje;
            begin
                textColor(white);
                textBackground(red);

                gotoXY(1, 43);

                //Si no se ingresó nada como opción...
                write('Campo incompleto o incorrecto. Por favor, ingrese una de las opciones validas.');

                delay(1750);
                gotoXY(1, 43);
                write('                                                                              ');
            end;
            
        begin
            reset(fCategorias);
            retorno := false;
            
            //Cuadro de diálogo.
            textBackground(white);

            for i := 7 to 35 do
                begin
                    gotoXY(20, i);
                    write('                                                                                          ');    
                end; 

            //Texto del cuadro de diálogo.
            textColor(black);
            
            gotoXY(55, 7);
            write('ALTA DE CATEGORIAS');
            gotoXY(22, 12);
            write('Nombre de la Categoria:');
            gotoXY(22, 15);
            write('Color de la Categoria:');
            
            //Texto de la barra de estado.
            textColor(white);
            textBackground(black);

            gotoXY(104, 50);
            write('Escape = cancelar |');    

            //Campos de edición.

            textBackground(red);

            gotoXY(45, 12);
            write('                              ');
            gotoXY(44, 15);
            write('  ');        
            textBackground(white);
            textcolor(black);
            write('(V, A, C, R, M o N)');
            
            textBackground(red);
            
            //CÓDIGO PRINCIPAL.
            correcto := false;
            textColor(white);
            repeat
                vCategorias.nombre := FncLeer(charOpcionSub2, false, 31, 45, 12);//30 espacios para el nombre

                if (charOpcionSub2 <> #27) and (vCategorias.nombre <> '') then
                    correcto := true
                else
                begin
                    PrcMensaje;
                    
                    textBackground(red);
                    
                    gotoXY(45, 12);
                    write('                              ');
                end;
            until (charOpcionSub2 = #27) or (correcto);
            
            correcto := false;

            if charOpcionSub2 <> #27 then //si el campo no está vacío o se preciona esc.
                repeat
                    vCategorias.color := FncLeer(charOpcionSub2, false, 2, 44, 15); //espacios para el color

                    if (((charOpcionSub2 = #13) and (vCategorias.color <> '')) and ((vCategorias.color = 'R') or (vCategorias.color = 'V') or (vCategorias.color = 'N') or (vCategorias.color = 'A') or (vCategorias.color = 'C') or (vCategorias.color = 'M')) or (charOpcionSub2 = #27)) then
                        correcto := true
                    else
                    begin
                        PrcMensaje;

                        textBackground(red);

                        gotoXY(44, 15);
                        write('  ');
                    end;
                until (charOpcionSub2 = #27) or (correcto);
            
            if charOpcionSub2 <> #27 then
            begin
                retorno := true;
                vCategorias.estado := 0;
                reset(fCategorias);
                seek(fCategorias, fileSize(fCategorias));
                write(fCategorias,vCategorias);
                
                //Se muestra un mensaje en la barra de estado.
                textColor(white);
                textBackground(black);

                gotoXY(2, 50);
                write('Categoria guardada');
                delay(1500);
                gotoXY(2, 50);
                write('                  ');
            end;   

            //Se borra el cuadro de diálogo.
            textBackground(red);

            for i := 7 to 35 do
            begin
                gotoXY(20, i);
                write('                                                                                          ');    
            end; 

            fncAltaCategorias := retorno;
            
            //Borar: Texto de la barra de estado.
            textBackground(black);
            gotoXY(104, 50); 
            write('                   ');  
            
            close(fCategorias);
        end;

        procedure PrcBuscarCategorias;
        var
            posicion, i,j, menuAcciones: integer;
            charAccion: char;
            fin, correcto, finMientras: boolean;
            color, respuesta: string;
            vAcciones: array [0..2] of string;
            vCasilleros: Casillero;
            
            procedure PrcMensaje;
            begin
                textColor(white);
                textBackground(red);

                gotoXY(1, 43);

                //Si no se ingresó nada como opción...
                write('Campo incompleto o incorrecto. Por favor, ingrese una de las opciones validas.');

                delay(1750);
                gotoXY(1, 43);
                write('                                                                              ');
            end;
            
            procedure PrcMensaje2;
            begin
                textColor(white);
                textBackground(red);

                gotoXY(1, 43);

                //Si no se ingresó nada como opción...
                write('El color no encontado. Intente ingresar otro color o carguelocargue uno nuevo en las configuraciones de categoria.');

                delay(2000);
                gotoXY(1, 43);
                write('                                                                                                                  ');
            end;
            
        begin
            reset(fCategorias);

             //proceso buscar categorias
             //Cuadro de diálogo.
            textBackground(white);

            for i := 7 to 35 do
            begin
                gotoXY(20,i);
                write('                                                                                          ');                
            end;
            
            //Texto del cuadro de diálogo.
            textColor(black);
            
            gotoXY(53, 7);
            write('BUSQUEDA DE CATEGORIAS');
            gotoXY(22, 12);
            write('Ingrese el color de la categoria: ');
            
            //Texto de la barra de estado.
            textColor(white);
            textBackground(black);

            gotoXY(104, 50);
            write('Escape = cancelar |'); 
            
            //Campos de edición.
                ////FncLeer(var Tecla: char; Tipo: boolean; Longitud, PosX, PosY: integer)
                        
            textBackground(red);
            
                //se crean los campos de edicion
            gotoXY(55, 12);
            write('  ');//2 espacios: color
            textBackground(white);
            textcolor(black);
            write('(V, A, C, R, M o N)');
            textBackground(red);
           
            
            //se lee en los campos //CÓDIGO PRINCIPAL.
            textBackground(red);
            textColor(white);
            fin:= false;
            correcto := false;
            repeat
                color := FncLeer(charOpcionSub2,false,2,55,12);// espacios para el color
                if (((charOpcionSub2 = #13) and (color <> '')) and ((color = 'R') or (color = 'V') or (color = 'N') or (color = 'A') or (color = 'C') or (color = 'M'))) then
                begin
                    //se verifica si el valor está en el archivo
                    reset(fCategorias);
                    correcto := true;
                    finMientras := false;
                    while ( (not eof(fCategorias)) and (not finMientras) ) do
                     begin
                        read(fCategorias,vCategorias);
                        if ( (vCategorias.color = color) and (vCategorias.estado = 0) ) then
                         begin
                            finMientras := true;
                            fin := true;
                            correcto := true;
                            posicion := FilePos (fCategorias);
                            posicion := posicion - 1;
                            seek(fcategorias, (posicion) );
                         end
                        else
                         begin
                            correcto := false;
                         end;    
                     end;
                    if not correcto then
                        PrcMensaje2;// valor no encontrado
                end  
                else
                begin
                    if charOpcionSub2 <> #27 then
                        PrcMensaje//icorrecto o invalido
                    else//salir
                    fin := true;
                    
                    correcto := false;
                end;              
            until (fin);

            fin := false; 
            if correcto then
            begin
                vAcciones[0] := 'Modificar nombre';
                vAcciones[1] := 'Eliminar';
                vAcciones[2] := 'Salir';
                menuAcciones := 0;

                //Limpia el cuadro de diálogo para mostrar el resultado.
                textColor(black);                                
                textBackground(white);

                for i := 8 to 35 do
                begin
                    gotoXY(20, i);
                    write('                                                                                          ');    
                end;

                begin
                    gotoXY(22, 12);
                    write('Resultado:');
                    gotoXY(22, 13);
                    write('  Color: ');
                    case vCategorias.Color of
                        'V': write('Verde');
                        'A': write('Amarillo');
                        'C': write('Celeste');
                        'R': write('Rosa');
                        'M': write('Marron');
                        'N': write('Naranja');
                    end;

                    
                    write('  Nombre: ',vCategorias.nombre);

                    write(' Estado: ');
                    //Si está activo...
                    if vCategorias.Estado = 0 then
                        write('Activo')
                    //Si está inactivo...
                    else
                        write('inactivo');

                    //Se muestran las acciones disponibles.

                    gotoXY(22, 16);
                    write('Acciones disponibles:');
                                    
                    gotoXY(24, 17);
                    write('-', vAcciones[0]);
                    gotoXY(24, 18);
                    write('-', vAcciones[1]);
                    gotoXY(24, 19);
                    write('-', vAcciones[2]);

                    //Selector de acciones disponibles.
                    repeat                                        
                        for i := 0 to 2 do
                        begin
                            if menuAcciones = i then
                            begin
                                textBackground(blue);
                                textColor(white);
                             end
                             else
                             begin
                                textBackground(white);
                                textColor(black);
                             end;

                             gotoXY(24, i + 17);
                             write('-', vAcciones[i]);
                        end;

                        charAccion := readKey;

                        case ord(charAccion) of
                            //Flecha abajo.
                            80: if menuAcciones < 2 then
                            menuAcciones := menuAcciones + 1;

                            //Flecha arriba.
                            72: if menuAcciones > 0 then
                            menuAcciones := menuAcciones - 1;

                            13: case menuAcciones of
                                0://opción modificar nombre
                                begin 
                                    //Texto del cuadro de diálogo.
                                    textColor(black);
                                    gotoXY(22, 21);
                                    write('Nombre de la Categoria:');
                                
                                    //Campos de edición.
                                    textBackground(red);
                                    //se crean los campos de edicion
                                    gotoXY(45, 21);
                                    write('                              ');

                                    //se lee en los campos //CÓDIGO PRINCIPAL.
                                    correcto := false;
                                    fin:= false;
                                    textBackground(red);
                                    textColor(white);
                                    
                                    repeat
                                        vCategorias.nombre := FncLeer(charOpcionSub2,false,31,46,21);//30 espacios para el nombre
                                        if ( (charOpcionSub2 = #13) and (vCategorias.nombre <> '') ) then
                                        begin
                                            correcto := true;
                                            fin := true;
                                            write(fCategorias,vCategorias);
                                        end
                                        else 
                                        begin
                                            prcMensaje;
                                            if  (charOpcionSub2 = #27) then
                                                fin := true;
                                        end;
                                            
                                    until( fin );//sale sólo si se preciona enter y se escribió algun valor o si presiona esc

                                    //se borra el texto
                                    textBackground(white);
                                    gotoXY(45, 21);
                                    write('                               ');
                                    textBackground(red);

                                end;
                                1://opción eliminar
                                begin 
                                    //Pregunta.
                                    fin := false;
                                    repeat
                                        textColor(white);
                                        textBackground(red);

                                        gotoXY(1, 43);
                                        write('Desea eliminar el casillero actual? (S/N): ');

                                        respuesta := FncLeer(charOpcionSub2, false, 2, 44, 43);

                                        if respuesta = 'S' then
                                        begin
                                            correcto := false;
                                            //se verifica si el valor está en el archivo, ya que solo se puede eliminar si en la categoria no hay casilleros
                                            reset(fCasilleros);
                                            finMientras := false;
                                            while ( (not eof(fCasilleros)) and (not finMientras) ) do
                                            begin
                                                read(fCasilleros,vCasilleros);
                                                if ( (vCasilleros.color = color) and (vCasilleros.estado = 0) ) then
                                                begin
                                                    finMientras := true;
                            	                    correcto := true;//se encuentra en la posición
                                                end
                                                else
                                                begin
                                                    correcto := false;//no se encuentra en la posición
                                                end;    
                                            end;
                                            
                                            fin := true;

                                            if  not correcto then //no hay casilleros asignados
                                            begin
                                                vCategorias.Estado := 99;//se borra
                                                write(fCategorias,vCategorias );
                                                
                                                //Notificación.
                                                textColor(white);
                                                textBackground(black);

                                                gotoXY(1, 50);
                                                write('Casillero eliminado');
                                                delay(1500);
                                                gotoXY(1, 50);
                                                write('                   ');
                                                textBackground(red);
                                                gotoXY(1, 43);
                                                write('                                                          ');
                                            end
                                            else
                                            begin
                                                    gotoXY(1, 43);
                                                    write('                                              ');
                                                    gotoXY(1, 43); //mensaje
                                                    write('No se puede eliminar: casilleros asignados.');
                                                    delay(2000);
                                                    gotoXY(1, 43);
                                                    write('                                              ');
                                            end;
                                        end
                                        else if respuesta = 'N' then //si la respuesta es no se sale
                                             fin := true
                                             else
                                             begin
                                                if (charOpcionSub2 = #27) then //si la respuesta es escape se sale
                                                    fin := true
                                                else // si no es es 'no' ni tampoco escape se vuelve a pedir una respuesta
                                                begin
                                                    gotoXY(1, 43);
                                                write('                                              ');
                                                    gotoXY(1, 43);
                                                    write('Respuesta invalida.');
                                                    delay(1750);
                                                end;   
                                                gotoXY(1, 43);
                                                write('                                              ');
                                             end;
                                    until (fin);
                                end;
                                2: fin := true;//Opción 'Salir'.
                            end;
                        end;
                    until(fin);
                end;
            end;  

            //Se borra el cuadro de diálogo.
            textBackground(red);

            for i := 5 to 35 do
            begin
                    gotoXY(20, i);
                    write('                                                                                          ');    
            end;

            //Borar: Texto de la barra de estado.
            textBackground(black);
            gotoXY(104, 50); 
            write('                   ');

            close(fCategorias);
        end; //fin del proceso de busqueda

    begin
        vectorOp2[0] := 'Alta    ';
        vectorOp2[1] := 'Busqueda';
        posSubMenu2 := 0;

        //Fondo del sub-submenú 'Categorias' del submenú 'Configuracion'.
        textBackground(black);

        for i := 1 to 2 do
        begin
            gotoXY(20, i + 2);
            write('         ');
        end;

        //Opciones de 'alta' y 'buscar'.
        textColor(white);
        
        for i := 0 to 1 do
        begin
            gotoXY(20, i + 3);
            write('-', vectorOp2[i]);
        end;

        //Selector.
        while (posSubMenu2 <> -1) do
        begin
            for i := 0 to 1 do
            begin
                if posSubMenu2 = i then
                begin
                    textBackground(lightGray);
                    textColor(yellow);
                end
                else
                begin
                    textBackground(black);
                    textColor(white);
                end;

                gotoXY(20, i + 3);
                write('-', vectorOp2[i]);
            end;

            charOpcionSub2 := readKey;

            case ord(charOpcionSub2) of
                80: if posSubMenu2 < 1 then //Flecha abajo.
                    posSubMenu2 := posSubMenu2 + 1;

                72: if posSubMenu2 > 0 then //Flecha arriba.
                    posSubMenu2 := posSubMenu2 - 1;

                13: case posSubMenu2 of //Enter.
                        0: boolCategorias := FncAltaCategorias;
                        1: PrcBuscarCategorias;
                    end;

                08: posSubMenu2 := -1;
            end;
        end;

        //Borra el menú.
        textBackground(red);

        for i := 2 downto 1 do
        begin
            gotoXY(20, i + 2);
            write('         ');
        end;
    end;

    procedure PrcPreguntas;
    var 
        i, j, posSubMenu3: integer;
        charOpcionSub3: char;
        vCategoria: Categoria;
        varPregunta: Pregunta;
            
        function FncAltaPreguntas: boolean;
        var
            retorno, correcto, fin, finMientras, flag, b, cantMaxPreg: boolean; //correcto indica si se puede continuar con el alta, fin indica la salida de un ciclo de busqueda.
            i, j, posicion, numPreg: integer;
            color, preg, resp1, resp2, resp3, respCorr, respuesta: string;//color: variable que se ingresa para preguntas.
            vCategorias: Categoria;//vCategoria.Color: variable Aux. que se recupera del archivo fCategorias.color
            
            procedure PrcMensaje;
            begin
                textColor(white);
                textBackground(red);

                gotoXY(1, 43);

                //Si no se ingresó nada como opción...
                write('Campo incompleto o incorrecto. Por favor, ingrese una de las opciones validas.');

                delay(1750);
                gotoXY(1, 43);
                write('                                                                              ');
            end;
            
            procedure PrcMensaje2;
            begin
                textColor(white);
                textBackground(red);

                gotoXY(1, 43);

                //Si no se ingresó nada como opción...
                write('Color no encontado. Intente ingresar otro color o cargue uno nuevo en las configuraciones de categoria.');

                delay(2000);
                gotoXY(1, 43);
                write('                                                                                                                  ');
            end;
        
        begin
            reset(fPreguntas);
            retorno := false;
            
            //Cuadro de diálogo.
            textBackground(white);

            for i := 7 to 35 do
                begin
                    gotoXY(20, i);
                    write('                                                                                          ');    
                end;

            //Texto del cuadro de diálogo.
            textColor(black);
            
            gotoXY(55, 7);
            write('ALTA DE PREGUNTAS');
            gotoXY(22, 11);
            write('Color de la Categoria:');
            gotoXY(22, 14);
            write('Pregunta:');
            gotoXY(26, 17);
            write('Opcion 1:');
            gotoXY(26, 19);
            write('Opcion 2:');
            gotoXY(26, 21);
            write('Opcion 3:');
            gotoXY(22, 24);
            write('respuesta correcta:');

            //Texto de la barra de estado.
            textColor(white);
            textBackground(black);

            gotoXY(104, 50);
            write('Escape = cancelar |');

            textBackground(red);

            //Campos de edición.
            gotoXY(45, 11);
            write('  ');
            textBackground(white);
            textcolor(black);
            write('(V, A, C, R, M o N)');
            textBackground(red);
            gotoXY(35, 14);
            write('                                                                          '); //Pregunta.
            gotoXY(35, 17);
            write('                                                                          '); //Opción 1.
            gotoXY(35, 19);
            write('                                                                          '); //Opción 2.
            gotoXY(35, 21);
            write('                                                                          '); //Opción 3.
            gotoXY(42, 24);
            write('  '); 

            textBackground(white);
            textcolor(black);
            write('(1, 2 o 3)');

            //CÓDIGO PRINCIPAL.
            textBackground(red);
            textColor(white);

            correcto := false;
            fin := false;

            repeat
                b := false;

                while (charOpcionSub3 <> #27) and (b = false) do
                begin
                    color := FncLeer(charOpcionSub3, false, 2, 45, 11);

                    //Comprobación de lo ingresado.
                    while (charOpcionSub3 <> #27) and ((color = '') or ((color <> 'R') and (color <> 'V') and (color <> 'N') and (color <> 'A') and (color <> 'C') and (color <> 'M'))) do
                    begin
                        textColor(white);
                        textBackground(red);
                        gotoXY(1, 43);

                        //Si el campo está vacío...
                        if color = '' then
                            write('Debe completar el campo.')
                        //Si el campo no está vacío, pero con dato incorrecto...
                        else if (color <> 'R') and (color <> 'V') and (color <> 'N') and (color <> 'A') and (color <> 'C') and (color <> 'M') then
                            write('Error: dato incorrecto. Ingrese una opcion valida.');

                        delay(1750);
                        gotoXY(1, 43);
                        write('                                                  ');
                        gotoXY(45, 11);
                        write('  ');
                        
                        color := FncLeer(charOpcionSub3, false, 2, 45, 11);
                    end;

                    //Si no se presionó escape: comprobación del color.
                    if charOpcionSub3 <> #27 then
                    begin
                        //Se verifica si existe categoría con dicho color.
                        reset(fCategorias);
                        seek(fCategorias, 0);
                        finMientras := false;

                        //Se revisa el archivo de categorias.
                        while (not eof(fCategorias)) and (not finMientras) do
                        begin
                            read(fCategorias, vCategorias);

                            //Si existe una categoría activa con el color buscado...
                            if (vCategorias.Color = color) and (vCategorias.estado = 0) then
                            begin
                                finMientras := true; //Se corta el ciclo de búsqueda.
                                b := true; //Corta el ciclo de ingreso del color.
                            end;
                        end;

                        //Si ne se encuentra la categoría activa en el archivo...
                        if finMientras = false then
                            PrcMensaje2; //Lanza un mensaje de error.
                    end;
                end;

                //Trivia.
                if charOpcionSub3 <> #27 then
                begin
                    //Código para la obtención del número de pregunta.
                    i := 0;
                    flag := false;
                    cantMaxPreg := false;                

                    while flag = false do
                    begin
                        inc(i);

                        //Si aún no se alcanzó la cantidad máxima de preguntas en la categoría...
                        if i <= 6 then
                        begin
                            numPreg := 1; //El número de pregunta inicia en 1, por defecto.
                            b := false;
                            seek(fPreguntas, 0); //Se posiciona al comienzo del archivo.

                            //Mientras no se encuentre un coincidencia y no se llegue al fin de archivo...
                            while (b = false) and (not eof(fPreguntas)) do
                            begin
                                read(fPreguntas, varPregunta);
                                
                                //Si el color de pregunta es el ingresado y la misma está activa...
                                if (varPregunta.Color = color) and (varPregunta.Estado = 0) then
                                begin
                                    numPreg := i;

                                    //Si encuentra una pregunta que coincida con el número...
                                    if varPregunta.Numero = i then
                                        b := true; //Torna en "true" la bandera 'b', indicando que 'i' es un número que no se debe utilizar.
                                end;
                            end;

                            //Si la bandera 'b' es "false", torna en "true" la bandera 'flag', indicando que se encontró un número libre.
                            if b = false then
                                flag := true;
                        end
                        //Si se alcanzó la cantidad máxima de preguntas en la categoría...
                        else
                        begin
                            cantMaxPreg := true; //Inidica que se llegó a la cantidad máxima de preguntas.
                            flag := true; //Corta el ciclo.
                        end;
                    end;
                    
                    //Si no se llegó a la cantidad máxima de preguntas en la categoría...
                    if cantMaxPreg = false then
                    begin
                        textBackground(white);
                        textcolor(black);

                        gotoXY(30,14);
                        write(' ', numPreg,'/6:');

                        textBackground(red);
                        textColor(white);

                        preg := FncLeer(charOpcionSub3, false, 74, 35, 14); //Se ingresa la pregunta.

                        //Mientras no se presione escape y no se complete el campo...
                        while (charOpcionSub3 <> #27) and (preg = '') do
                        begin
                            textColor(white);
                            textBackground(red);

                            gotoXY(1, 43);
                            write('Debe completar el campo.');
                            delay(1750);
                            gotoXY(1, 43);
                            write('                        ');
                            gotoXY(35, 14);
                            write('                                                                          ');

                            preg := FncLeer(charOpcionSub3, false, 74, 35, 14); //Se vuelve a ingresar la pregunta.
                        end;
                    end
                    //Si se llego a la cantidad maxima de preguntas para esta categoria...
                    else
                    begin
                        textBackground(red);
                        textColor(white);

                        gotoXY(1, 43);
                        write('Se llego a la cantidad maxima de preguntas para esta categoria.');
                        delay(1750);
                        gotoXY(1, 43);
                        write('                                                               ');

                        charOpcionSub3 := #27; //Sale del alta de preguntas.
                    end;        
                end;
            
                //Respuesta Nº 1
                if charOpcionSub3 <> #27 then
                begin
                    textColor(white);
                    textBackground(red);
                    resp1 := FncLeer(charOpcionSub3, false, 74, 35, 17);

                    while (charOpcionSub3 <> #27) and (resp1 = '') do
                    begin
                        textBackground(red);
                        textColor(white);

                        gotoXY(1, 43);
                        write('Debe completar el campo.');
                        delay(1750);
                        gotoXY(1, 43);
                        write('                        ');
                        gotoXY(35, 17);
                        write('                                                                          ');

                        resp1 := FncLeer(charOpcionSub3, false, 74, 35, 17);
                    end;
                end;
            
                //Respuesta Nº 2
                if charOpcionSub3 <> #27 then
                begin
                    textColor(white);
                    textBackground(red);
                    resp2 := FncLeer(charOpcionSub3, false, 74, 35, 19);

                    while (charOpcionSub3 <> #27) and (resp2 = '') do
                    begin
                        textBackground(red);
                        textColor(white);

                        gotoXY(1, 43);
                        write('Debe completar el campo.');
                        delay(1750);
                        gotoXY(1, 43);
                        write('                        ');
                        gotoXY(35, 19);

                        resp2 := FncLeer(charOpcionSub3, false, 74, 35, 19);
                    end;
                end;
            
                //Respuesta Nº 3
                if charOpcionSub3 <> #27 then
                begin
                    textColor(white);
                    textBackground(red);
                    resp3 := FncLeer(charOpcionSub3, false, 74, 35, 21);

                    while (charOpcionSub3 <> #27) and (resp3 = '') do
                    begin
                        textBackground(red);
                        textColor(white);

                        gotoXY(1, 43);
                        write('Debe completar el campo.');
                        delay(1750);
                        gotoXY(1, 43);
                        write('                        ');
                        gotoXY(35, 21);
                        write('                                                                          ');

                        resp3 := FncLeer(charOpcionSub3, false, 74, 35, 21);
                    end;
                end;
            
                //Respuesta correcta
                if charOpcionSub3 <> #27 then
                begin
                    textColor(white);
                    textBackground(red);
                    
                    respCorr := FncLeer(charOpcionSub3, true, 2, 42, 24);

                    while (charOpcionSub3 <> #27) and (respCorr = '') do
                    begin
                        textBackground(red);
                        textColor(white);

                        gotoXY(1, 43);
                        write('Debe completar el campo.');
                        delay(1750);
                        gotoXY(1, 43);
                        write('                        ');
                        gotoXY(42, 24);
                        write('  ');

                        respCorr := FncLeer(charOpcionSub3, true, 2, 42, 24);
                    end;
                end;

                //Grabado de pregunta.
                if charOpcionSub3 <> #27 then
                begin
                    retorno := true;
                    seek(fPreguntas, fileSize(fPreguntas)); //Se posiciona al final del archivo.
                    
                    //Llena la pregunta con los datos ingresados.
                    varPregunta.Numero := numPreg;
                    varPregunta.Color := color;
                    varPregunta.Trivia := preg;
                    varPregunta.vOpciones[1] := resp1;
                    varPregunta.vOpciones[2] := resp2;
                    varPregunta.vOpciones[3] := resp3;
                    varPregunta.Respuesta := respCorr;
                    varPregunta.Estado := 0;

                    write(fPreguntas, varPregunta); //Graba la pregunta en el archivo.

                    //Se muestra un mensaje en la barra de estado.
                    textColor(white);
                    textBackground(black);

                    gotoXY(1, 50);
                    write('Pregunta Guardada');
                    delay(1500);
                    gotoXY(1, 50);
                    write('                 ');

                    //Se pregunta por el ingreso de una nueva pregunta.
                    textBackground(red);

                    gotoXY(1, 43);
                    write('Desea ingresar otra pregunta? (S/N): ');

                    respuesta := FncLeer(charOpcionSub3, false, 2, 38, 43);

                    while (respuesta = '') or ((respuesta <> 'S') and (respuesta <> 'N')) do
                    begin
                        textColor(white);
                        textBackground(red);

                        gotoXY(1, 43);
                        write('                                      ');
                        gotoXY(1, 43);

                        //Si no se elije ninguna opción...
                        if respuesta = '' then
                            write('Debe ingresar una respuesta.')
                        //Si se elije una opción inválida..
                        else
                            write('Debe ingresar una respuesta valida.');

                        delay(1750);
                        gotoXY(1, 43);
                        write('                                      ');
                        gotoXY(1, 43);
                        write('Desea ingresar otra pregunta? (S/N): ');

                        respuesta := FncLeer(charOpcionSub3, false, 2, 38, 43);
                    end;

                    gotoXY(1, 43);
                    write('                                      ');

                    //Si el usuario cancela el ingreso de otra pregunta...
                    if respuesta = 'N' then
                        fin := true //Sale del alta de preguntas.
                    //Si no lo cancela, limpia los campos de edición...
                    else
                    begin
                        textBackground(red);
                        
                        gotoXY(45, 11);
                        write('  ');
                        gotoXY(35, 14);
                        write('                                                                          ');   
                        gotoXY(35, 17);
                        write('                                                                          '); 
                        gotoXY(35, 19);
                        write('                                                                          '); 
                        gotoXY(35, 21);
                        write('                                                                          ');
                        gotoXY(42, 24);
                        write('  ');
                    end;
                end;    
            until (charOpcionSub3 = #27) or (fin); //Fin del ciclo de alta de preguntas.

            //Se borra el cuadro de diálogo.
            textBackground(red);

            for i := 7 to 35 do
                begin
                    gotoXY(20, i);
                    write('                                                                                          ');    
                end;

            FncAltaPreguntas  := retorno;
            
            //Borrar: Texto de la barra de estado.
            textBackground(black);
            gotoXY(104, 50); 
            write('                   ');  
                  
            close(fPreguntas);
        end;

        procedure PrcBuscarPreguntas;
        var
            i, j, k: integer;
            respuesta: string;
            fin, finMientras, correcto: boolean;
            vResultadoBusqueda: array [1..6] of categoria; 

            procedure PrcMensaje;
            begin
                textColor(white);
                textBackground(red);

                gotoXY(1, 43);

                //Si no se ingresó nada como opción...
                write('Campo incompleto o incorrecto. Por favor, ingrese una de las opciones validas.');

                delay(1750);
                gotoXY(1, 43);
                write('                                                                              ');
            end;

            procedure PrcBuscarNumero;
            var
                respuesta: string;
                tecla, tecla2: char;
                i, j, numVal, errVal, intMenu, intMenu2, posFile: integer;
                varPregunta: Pregunta;
                vResultados: array [0..5] of Pregunta;
                vPosResult: array [0..5] of integer;
                vAcciones: array [0..5] of string;

            begin
                //Inicialización de vectores.
                for i := 0 to 5 do
                    vPosResult[i] := 0;

                //CÓDIGO PRINCIPAL.
                repeat
                    //Texto del cuadro de diálogo.
                    textColor(black);
                    textBackground(white);
            
                    gotoXY(22, 12);
                    write('Ingrese el numero de pregunta:');
            
                    //Campos de edición.        
                    textBackground(red);

                    gotoXY(53, 12);
                    write('  ');

                    textBackground(white);
                    textColor(black);

                    write('(Numero del 1 al 6)');

                    textColor(white);
                    textBackground(red);

                    respuesta := FncLeer(charOpcionSub3, true, 2, 53, 12);

                    //Mientras no se presione escape y no se elija una opción válida...
                    while (charOpcionSub3 <> #27) and (respuesta <> '1') and (respuesta <> '2') and (respuesta <> '3') and (respuesta <> '4') and (respuesta <> '5') and (respuesta <> '6') do
                    begin
                        textColor(white);
                        textBackground(red);

                        gotoXY(1, 43);
                        write('Error: debe ingresar una opcion valida.');
                        delay(1750);
                        gotoXY(1, 43);
                        write('                                       ');

                        respuesta := FncLeer(charOpcionSub3, true, 2, 53, 12);
                    end;

                    //Si no se presionó escape...
                    if charOpcionSub3 <> #27 then
                    begin
                        seek(fPreguntas, 0); //Se posiciona al inicio del archivo de preguntas.
                        i := -1; //Contador de resultados (-1 indica que no se encontraron resultados).
                        val(respuesta, numVal, errVal);

                        //Se revisa el archivo de preguntas...
                        while not eof(fPreguntas) do
                        begin
                            read(fPreguntas, varPregunta);
                            
                            //Si el número de pregunta coincide con el ingresado...
                            if varPregunta.Numero = numVal then
                            begin
                                inc(i);
                                vResultados[i] := varPregunta; //Se almacena la pregunta encontrada.
                                vPosResult[i] := filePos(fPreguntas) - 1; //Se alamacena la posición de la pregunta.
                            end;
                        end;

                        textBackground(white);

                        gotoXY(22, 12);
                        write('                                                     ');

                        //Si se encontraron resultados...
                        if i <> -1 then
                        begin
                            intMenu := 0;

                            repeat
                                textColor(black);
                                textBackground(white);

                                gotoXY(22, 10);
                                write('Resultados:');
                                gotoXY(22, 11);
                                write('Numero |Color |Pregunta');

                                for j := 0 to i do
                                begin
                                    if intMenu = j then
                                    begin
                                        textColor(white);
                                        textBackground(blue);
                                    end
                                    else
                                    begin
                                        textColor(black);
                                        textBackground(white);
                                    end;

                                    gotoXY(22, j + 12);
                                    write(vResultados[j].Numero, '      |', vResultados[j].Color, '     |',vResultados[j].Trivia);
                                end;

                                tecla := readKey;

                                if tecla = #0 then
                                    tecla := readKey;

                                case ord(tecla) of
                                    //Abajo.
                                    80:
                                        if intMenu < i then
                                            intMenu := intMenu + 1;

                                    //Arriba.
                                    72:
                                        if intMenu > 0 then
                                            intMenu := intMenu - 1;

                                    //Enter.
                                    13:
                                    begin
                                        textBackground(white);

                                        for j := 7 to 35 do
                                        begin
                                            gotoXY(20, j);
                                            write('                                                                                           ');
                                        end;

                                        vAcciones[0] := 'Modificar pregunta';
                                        vAcciones[1] := 'Modificar respuesta 1';
                                        vAcciones[2] := 'Modificar respuesta 2';
                                        vAcciones[3] := 'Modificar respuesta 3';
                                        vAcciones[4] := 'Eliminar pregunta';
                                        vAcciones[5] := 'Salir';
                                        intMenu2 := 0;

                                        repeat
                                            textColor(black);
                                            textBackground(white);

                                            gotoXY(22, 10);
                                            write(vResultados[intMenu].Numero, ' ', vResultados[intMenu].Trivia);
                                            gotoXY(24, 11);
                                            write('- Respuesta 1: ', vResultados[intMenu].vOpciones[1]);
                                            gotoXY(24, 12);
                                            write('- Respuesta 2: ', vResultados[intMenu].vOpciones[2]);
                                            gotoXY(24, 13);
                                            write('- Respuesta 3: ', vResultados[intMenu].vOpciones[3]);
                                            gotoXY(24, 14);
                                            write('Color: ', vResultados[intMenu].Color, ' | Estado: ');

                                            if vResultados[intMenu].Estado = 0 then
                                                write('activa')
                                            else
                                                write('no activa');

                                            gotoXY(22, 16);
                                            write('Acciones:');

                                            for j := 0 to 5 do
                                            begin
                                                if intMenu2 = j then
                                                begin
                                                    textColor(white);
                                                    textBackground(blue);
                                                end
                                                else
                                                begin
                                                    textColor(black);
                                                    textBackground(white);
                                                end;

                                                gotoXY(22, j + 17);
                                                write('-', vAcciones[j]);
                                            end;

                                            tecla2 := readKey;

                                            if tecla2 = #0 then
                                                tecla2 := readKey;

                                            case ord(tecla2) of
                                                //Abajo.
                                                80:
                                                    if intMenu2 < 5 then
                                                        intMenu2 := intMenu2 + 1;
                                                
                                                //Arriba.
                                                72:
                                                    if intMenu2 > 0 then
                                                        intMenu2 := intMenu2 - 1;
                                                
                                                //Enter.
                                                13:
                                                begin
                                                    textBackground(white);

                                                    for j := 7 to 35 do
                                                    begin
                                                        gotoXY(20, j);
                                                        write('                                                                                           ');
                                                    end;
                                                    
                                                    case intMenu2 of
                                                        //Modificar pregunta.
                                                        0:
                                                        begin
                                                            textColor(black);
                                                            textBackground(white);

                                                            textColor(black);

                                                            gotoXY(22, 10);
                                                            write(vResultados[intMenu].Numero, ' ', vResultados[intMenu].Trivia);

                                                            gotoXY(22, 14);
                                                            write('Ingrese nueva pregunta:');

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(22, 15);
                                                            write('                                                                          ');
                                                            
                                                            respuesta := FncLeer(charOpcionSub3, false, 74, 22, 15);

                                                            while (charOpcionSub3 <> #27) and (respuesta = '') do
                                                            begin
                                                                gotoXY(1, 43);
                                                                write('Debe completar el campo.');
                                                                delay(1750);
                                                                gotoXY(1, 43);
                                                                write('                        ');

                                                                respuesta := FncLeer(charOpcionSub3, false, 74, 22, 13);
                                                            end;

                                                            if charOpcionSub3 <> #27 then
                                                            begin
                                                                //Se graba la modificación.
                                                                varPregunta := vResultados[intMenu]; //Recupera la pregunta.
                                                                posFile := vPosResult[intMenu]; //Recupera la posición.
                                                                seek(fPreguntas, posFile); //Va a la posición.
                                                                varPregunta.Trivia := respuesta; //Modificación.
                                                                write(fPreguntas, varPregunta); //Guarda la pregunta.

                                                                //Notificación de la barra de estado.
                                                                textColor(white);
                                                                textBackground(black);

                                                                gotoXY(1, 50);
                                                                write('Pregunta modificada');
                                                                delay(1500);
                                                                gotoXY(1, 50);
                                                                write('                   ');
                                                            end;

                                                            textBackground(white);

                                                            for j := 7 to 35 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                           ');
                                                            end;
                                                        end;
                                                        
                                                        //Modificar respuesta 1.
                                                        1:
                                                        begin
                                                            textColor(black);
                                                            textBackground(white);

                                                            gotoXY(22, 10);
                                                            write(vResultados[intMenu].Numero, ' ', vResultados[intMenu].Trivia);
                                                            gotoXY(22, 12);
                                                            write('Respuesta 1: ', vResultados[intMenu].vOpciones[1]);

                                                            gotoXY(22, 14);
                                                            write('Ingrese nueva respuesta:');
                                                            
                                                            textBackground(red);

                                                            gotoXY(22, 15);
                                                            write('                                                                          ');

                                                            textColor(white);
                                                            
                                                            respuesta := FncLeer(charOpcionSub3, false, 74, 22, 15);

                                                            while (charOpcionSub3 <> #27) and (respuesta = '') do
                                                            begin
                                                                gotoXY(1, 43);
                                                                write('Debe completar el campo.');
                                                                delay(1750);
                                                                gotoXY(1, 43);
                                                                write('                        ');

                                                                respuesta := FncLeer(charOpcionSub3, false, 74, 22, 13);
                                                            end;

                                                            if charOpcionSub3 <> #27 then
                                                            begin
                                                                //Se graba la modificación.
                                                                varPregunta := vResultados[intMenu];
                                                                posFile := vPosResult[intMenu];
                                                                seek(fPreguntas, posFile);
                                                                varPregunta.vOpciones[1] := respuesta;
                                                                write(fPreguntas, varPregunta);

                                                                //Notificación de la barra de estado.
                                                                textColor(white);
                                                                textBackground(black);

                                                                gotoXY(1, 50);
                                                                write('Pregunta modificada');
                                                                delay(1500);
                                                                gotoXY(1, 50);
                                                                write('                   ');
                                                            end;

                                                            textBackground(white);

                                                            for j := 7 to 35 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                           ');
                                                            end;
                                                        end;
                                                        
                                                        //Modificar respuesta 2.
                                                        2:
                                                        begin
                                                            textColor(black);
                                                            textBackground(white);

                                                            gotoXY(22, 10);
                                                            write(vResultados[intMenu].Numero, ' ', vResultados[intMenu].Trivia);
                                                            gotoXY(22, 12);
                                                            write('Respuesta 2: ', vResultados[intMenu].vOpciones[2]);

                                                            gotoXY(22, 14);
                                                            write('Ingrese nueva respuesta:');
                                                            
                                                            textBackground(red);

                                                            gotoXY(22, 15);
                                                            write('                                                                          ');

                                                            textColor(white);
                                                            
                                                            respuesta := FncLeer(charOpcionSub3, false, 74, 22, 15);

                                                            while (charOpcionSub3 <> #27) and (respuesta = '') do
                                                            begin
                                                                gotoXY(1, 43);
                                                                write('Debe completar el campo.');
                                                                delay(1750);
                                                                gotoXY(1, 43);
                                                                write('                        ');

                                                                respuesta := FncLeer(charOpcionSub3, false, 74, 22, 13);
                                                            end;

                                                            if charOpcionSub3 <> #27 then
                                                            begin
                                                                //Se graba la modificación.
                                                                varPregunta := vResultados[intMenu];
                                                                posFile := vPosResult[intMenu];
                                                                seek(fPreguntas, posFile);
                                                                varPregunta.vOpciones[2] := respuesta;
                                                                write(fPreguntas, varPregunta);

                                                                //Notificación de la barra de estado.
                                                                textColor(white);
                                                                textBackground(black);

                                                                gotoXY(1, 50);
                                                                write('Pregunta modificada');
                                                                delay(1500);
                                                                gotoXY(1, 50);
                                                                write('                   ');
                                                            end;

                                                            textBackground(white);

                                                            for j := 7 to 35 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                           ');
                                                            end;
                                                        end;
                                                        
                                                        //Modificar respuesta 3.
                                                        3:
                                                        begin
                                                            textColor(black);
                                                            textBackground(white);

                                                            gotoXY(22, 10);
                                                            write(vResultados[intMenu].Numero, ' ', vResultados[intMenu].Trivia);
                                                            gotoXY(22, 12);
                                                            write('Respuesta 3: ', vResultados[intMenu].vOpciones[3]);

                                                            gotoXY(22, 14);
                                                            write('Ingrese nueva respuesta:');
                                                            
                                                            textBackground(red);

                                                            gotoXY(22, 15);
                                                            write('                                                                          ');

                                                            textColor(white);
                                                            
                                                            respuesta := FncLeer(charOpcionSub3, false, 74, 22, 15);

                                                            while (charOpcionSub3 <> #27) and (respuesta = '') do
                                                            begin
                                                                gotoXY(1, 43);
                                                                write('Debe completar el campo.');
                                                                delay(1750);
                                                                gotoXY(1, 43);
                                                                write('                        ');

                                                                respuesta := FncLeer(charOpcionSub3, false, 74, 22, 13);
                                                            end;

                                                            if charOpcionSub3 <> #27 then
                                                            begin
                                                                //Se graba la modificación.
                                                                varPregunta := vResultados[intMenu];
                                                                posFile := vPosResult[intMenu];
                                                                seek(fPreguntas, posFile);
                                                                varPregunta.vOpciones[3] := respuesta;
                                                                write(fPreguntas, varPregunta);

                                                                //Notificación de la barra de estado.
                                                                textColor(white);
                                                                textBackground(black);

                                                                gotoXY(1, 50);
                                                                write('Pregunta modificada');
                                                                delay(1500);
                                                                gotoXY(1, 50);
                                                                write('                   ');
                                                            end;

                                                            textBackground(white);

                                                            for j := 7 to 35 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                           ');
                                                            end;
                                                        end;
                                                        
                                                        //Eliminar pregunta.
                                                        4:
                                                        begin
                                                            textColor(black);
                                                            textBackground(white);

                                                            gotoXY(22, 10);
                                                            write(vResultados[intMenu].Numero, ' ', vResultados[intMenu].Trivia);

                                                            gotoXY(22, 12);
                                                            write('Desea realmente eliminar esta pregunta? (S/N):');
                                                            
                                                            textColor(white);
                                                            textBackground(red);

                                                            write('  ');

                                                            respuesta := FncLeer(charOpcionSub3, false, 2, 68, 12);

                                                            while (charOpcionSub3 <> #27) and ((respuesta = '') or ((respuesta <> 'S') and (respuesta <> 'N'))) do
                                                            begin
                                                                textColor(white);
                                                                textBackground(red);

                                                                gotoXY(1, 43);
                                                                write('Campo vacio o respuesta invalida. Complete el campo con una opcion valida.');
                                                                delay(1750);
                                                                gotoXY(1, 43);
                                                                write('                                                                          ');

                                                                respuesta := FncLeer(charOpcionSub3, false, 2, 68, 12);
                                                            end;

                                                            if (charOpcionSub3 <> #27) and (respuesta = 'S') then
                                                            begin
                                                                //Se elimina la pregunta.
                                                                varPregunta := vResultados[intMenu];
                                                                posFile := vPosResult[intMenu];
                                                                seek(fPreguntas, posFile);
                                                                varPregunta.Estado := 99;
                                                                write(fPreguntas, varPregunta);

                                                                //Notificación de la barra de estado.
                                                                textColor(white);
                                                                textBackground(black);

                                                                gotoXY(1, 50);
                                                                write('Pregunta eliminada');
                                                                delay(1500);
                                                                gotoXY(1, 50);
                                                                write('                  ');
                                                            end;

                                                            textBackground(white);

                                                            for j := 7 to 35 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                           ');
                                                            end;
                                                        end;
                                                        
                                                        //Salir.
                                                        5: intMenu2 := -1;
                                                    end;
                                                end;
                                            end;
                                        until intMenu2 = -1;
                                    end;

                                    //Escape.
                                    27: intMenu := -1;
                                end;
                            until intMenu = -1;

                            textBackground(white);

                            for j := 7 to 35 do
                            begin
                                gotoXY(20, j);
                                write('                                                                                           ');
                            end;
                        end
                        //Si no se encontraron resultados...
                        else
                        begin
                            textColor(black);
                            textBackground(white);

                            gotoXY(22, 15);
                            write('NO SE ENCONTRARON RESULTADOS. PRESIONE CUALQUIER TECLA PARA CONTINUAR.');
                            charOpcionSub3 := readKey;
                            gotoXY(22, 15);
                            write('                                                                      ');
                        end;
                    end;
                until charOpcionSub3 = #27;
            end;//fin del proceso de busqueda por número

            procedure PrcBuscarDescripcion;
            var
                varPregunta: Pregunta;
                tecla, tecla2: char;
                i, j, k, intMenu, intMenu2, iniVector, finVector, posFile: integer;
                respuesta: string[255];                
                vAcciones: array [0..5] of string;
                vResultados: array [0..99] of Pregunta; //Guarda las coincidencias de la búsqueda.
                vPosResult: array [0..99] of integer; //Guarda la posición de la pregunta dentro del archivo.

            begin
                for i := 0 to 5 do
                    vPosResult[i] := 0;

                repeat
                    textColor(black);
                    textBackground(white);

                    gotoXY(37, 35);
                    write('                                      ');

                    //Texto del cuadro de diálogo.
                    gotoXY(33, 7);
                    write('BUSQUEDA POR DESCRIPCION');
                    gotoXY(22, 10);
                    write('Ingrese descripcion:');

                    textColor(white);
                    textBackground(red);

                    gotoXY(22, 11);
                    write('                                                                          ');

                    respuesta := FncLeer(charOpcionSub3, false, 74, 22, 11);

                    while (charOpcionSub3 <> #27) and (respuesta = '') do
                    begin
                        textColor(white);
                        textBackground(red);

                        gotoXY(1, 43);
                        write('Debe completar el campo.');
                        delay(1750);
                        gotoXY(1, 43);
                        write('                        ');

                        respuesta := FncLeer(charOpcionSub3, false, 74, 22, 11);
                    end;

                    if charOpcionSub3 <> #27 then
                    begin
                        seek(fPreguntas, 0);
                        i := -1;

                        while not eof(fPreguntas) do
                        begin
                            read(fPreguntas, varPregunta);

                            //Si la pregunta coincide con la descripción de búsqueda...
                            if pos(respuesta, varPregunta.Trivia) <> 0 then
                            begin
                               inc(i); //Se incrementa el contador de resultados. 
                               vResultados[i] := varPregunta; //Se almacena el resultado.
                               vPosResult[i] := filePos(fPreguntas) - 1; //Se almacena la posición del resultado en el archivo.
                            end;
                        end;

                        textBackground(white);
                        
                        gotoXY(33, 7);
                        write('                        ');
                        gotoXY(22, 10);
                        write('                        ');
                        gotoXY(22, 11);
                        write('                                                                          ');

                        //Si se encontraron resultados...
                        if i <> -1 then
                        begin
                            intMenu := 0;
                            iniVector := 0;
                            
                            if i > 9 then
                            begin
                                textColor(black);
                                textBackground(white);
                                
                                finVector := 9;
                                gotoXY(37, 35);
                                write('<<: Pag. anterior | >>: Pag. siguiente');
                            end
                            else
                                finVector := i;

                            repeat
                                textColor(black);
                                textBackground(white);

                                gotoXY(22, 10);
                                write('Resultados:');
                                gotoXY(22, 11);
                                write('Numero |Color |Pregunta');
                                k := 0;

                                for j := iniVector to finVector do
                                begin
                                    if intMenu = j then
                                    begin
                                        textColor(white);
                                        textBackground(blue);
                                    end
                                    else
                                    begin
                                        textColor(black);
                                        textBackground(white);
                                    end;

                                    
                                    gotoXY(22, k + 12);
                                    write(vResultados[j].Numero, '      |', vResultados[j].Color, '     |',vResultados[j].Trivia);
                                    inc(k);
                                end;

                                tecla := readKey;

                                if tecla = #0 then
                                    tecla := readKey;

                                case ord(tecla) of
                                    //Abajo. Cambia de pregunta.
                                    80:
                                        if intMenu < finVector then
                                            intMenu := intMenu + 1;

                                    //Arriba. Cambia de pregunta.
                                    72:
                                        if intMenu > iniVector then
                                            intMenu := intMenu - 1;

                                    //Derecha. Cambia a la página siguiente.
                                    77:
                                        if finVector < i then
                                        begin
                                            //Se limpia la "página".
                                            textBackground(white);
                                        
                                            for k := 12 to 22 do
                                            begin
                                                gotoXY(20, k);
                                                write('                                                                                           ');
                                            end;

                                            //Se mueven los punteros.
                                            iniVector := finVector + 1;
                                            finVector := iniVector;
                                            k := 1;

                                            while (finVector < i) and (k < 10) do
                                            begin
                                                inc(k);
                                                inc(finVector);
                                            end;

                                            intMenu := iniVector;
                                        end;

                                    //Izquierda. Cambia a la página anterior.
                                    75:
                                        if iniVector > 0 then
                                        begin
                                            //Se limpia la "página".
                                            textBackground(white);
                                        
                                            for k := 12 to 22 do
                                            begin
                                                gotoXY(20, k);
                                                write('                                                                                           ');
                                            end;

                                            //Se mueven los punteros.
                                            finVector := iniVector - 1;
                                            iniVector := iniVector - 10;
                                            intMenu := iniVector;
                                        end;

                                    //Enter.
                                    13:
                                    begin
                                        textBackground(white);

                                        for j := 7 to 34 do
                                        begin
                                            gotoXY(20, j);
                                            write('                                                                                           ');
                                        end;

                                        vAcciones[0] := 'Modificar pregunta';
                                        vAcciones[1] := 'Modificar respuesta 1';
                                        vAcciones[2] := 'Modificar respuesta 2';
                                        vAcciones[3] := 'Modificar respuesta 3';
                                        vAcciones[4] := 'Eliminar pregunta';
                                        vAcciones[5] := 'Salir';
                                        intMenu2 := 0;

                                        repeat
                                            textColor(black);
                                            textBackground(white);

                                            gotoXY(22, 10);
                                            write(vResultados[intMenu].Numero, ' ', vResultados[intMenu].Trivia);
                                            gotoXY(24, 11);
                                            write('- Respuesta 1: ', vResultados[intMenu].vOpciones[1]);
                                            gotoXY(24, 12);
                                            write('- Respuesta 2: ', vResultados[intMenu].vOpciones[2]);
                                            gotoXY(24, 13);
                                            write('- Respuesta 3: ', vResultados[intMenu].vOpciones[3]);
                                            gotoXY(24, 14);
                                            write('Color: ', vResultados[intMenu].Color, ' | Estado: ');

                                            if vResultados[intMenu].Estado = 0 then
                                                write('activa')
                                            else
                                                write('no activa');

                                            gotoXY(22, 16);
                                            write('Acciones:');

                                            for j := 0 to 5 do
                                            begin
                                                if intMenu2 = j then
                                                begin
                                                    textColor(white);
                                                    textBackground(blue);
                                                end
                                                else
                                                begin
                                                    textColor(black);
                                                    textBackground(white);
                                                end;

                                                gotoXY(22, j + 17);
                                                write('-', vAcciones[j]);
                                            end;

                                            tecla2 := readKey;

                                            if tecla2 = #0 then
                                                tecla2 := readKey;

                                            case ord(tecla2) of
                                                //Abajo.
                                                80:
                                                    if intMenu2 < 5 then
                                                        intMenu2 := intMenu2 + 1;
                                                
                                                //Arriba.
                                                72:
                                                    if intMenu2 > 0 then
                                                        intMenu2 := intMenu2 - 1;
                                                
                                                //Enter.
                                                13:
                                                begin
                                                    textBackground(white);

                                                    for j := 7 to 34 do
                                                    begin
                                                        gotoXY(20, j);
                                                        write('                                                                                           ');
                                                    end;
                                                    
                                                    case intMenu2 of
                                                        //Modificar pregunta.
                                                        0:
                                                        begin
                                                            textColor(black);
                                                            textBackground(white);

                                                            textColor(black);

                                                            gotoXY(22, 10);
                                                            write(vResultados[intMenu].Numero, ' ', vResultados[intMenu].Trivia);

                                                            gotoXY(22, 14);
                                                            write('Ingrese nueva pregunta:');

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(22, 15);
                                                            write('                                                                          ');
                                                            
                                                            respuesta := FncLeer(charOpcionSub3, false, 74, 22, 15);

                                                            while (charOpcionSub3 <> #27) and (respuesta = '') do
                                                            begin
                                                                gotoXY(1, 43);
                                                                write('Debe completar el campo.');
                                                                delay(1750);
                                                                gotoXY(1, 43);
                                                                write('                        ');

                                                                respuesta := FncLeer(charOpcionSub3, false, 74, 22, 13);
                                                            end;

                                                            if charOpcionSub3 <> #27 then
                                                            begin
                                                                //Se graba la modificación.
                                                                varPregunta := vResultados[intMenu];
                                                                posFile := vPosResult[intMenu];
                                                                seek(fPreguntas, posFile);
                                                                varPregunta.Trivia := respuesta;
                                                                write(fPreguntas, varPregunta);

                                                                //Notificación de la barra de estado.
                                                                textColor(white);
                                                                textBackground(black);

                                                                gotoXY(1, 50);
                                                                write('Pregunta modificada');
                                                                delay(1500);
                                                                gotoXY(1, 50);
                                                                write('                   ');
                                                            end;

                                                            textBackground(white);

                                                            for j := 7 to 34 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                           ');
                                                            end;
                                                        end;
                                                        
                                                        //Modificar respuesta 1.
                                                        1:
                                                        begin
                                                            textColor(black);
                                                            textBackground(white);

                                                            gotoXY(22, 10);
                                                            write(vResultados[intMenu].Numero, ' ', vResultados[intMenu].Trivia);
                                                            gotoXY(22, 12);
                                                            write('Respuesta 1: ', vResultados[intMenu].vOpciones[1]);

                                                            gotoXY(22, 14);
                                                            write('Ingrese nueva respuesta:');
                                                            
                                                            textBackground(red);

                                                            gotoXY(22, 15);
                                                            write('                                                                          ');

                                                            textColor(white);
                                                            
                                                            respuesta := FncLeer(charOpcionSub3, false, 74, 22, 15);

                                                            while (charOpcionSub3 <> #27) and (respuesta = '') do
                                                            begin
                                                                gotoXY(1, 43);
                                                                write('Debe completar el campo.');
                                                                delay(1750);
                                                                gotoXY(1, 43);
                                                                write('                        ');

                                                                respuesta := FncLeer(charOpcionSub3, false, 74, 22, 13);
                                                            end;

                                                            if charOpcionSub3 <> #27 then
                                                            begin
                                                                //Se graba la modificación.
                                                                varPregunta := vResultados[intMenu];
                                                                posFile := vPosResult[intMenu];
                                                                seek(fPreguntas, posFile);
                                                                varPregunta.vOpciones[1] := respuesta;
                                                                write(fPreguntas, varPregunta);

                                                                //Notificación de la barra de estado.
                                                                textColor(white);
                                                                textBackground(black);

                                                                gotoXY(1, 50);
                                                                write('Pregunta modificada');
                                                                delay(1500);
                                                                gotoXY(1, 50);
                                                                write('                   ');
                                                            end;

                                                            textBackground(white);

                                                            for j := 7 to 34 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                           ');
                                                            end;
                                                        end;
                                                        
                                                        //Modificar respuesta 2.
                                                        2:
                                                        begin
                                                            textColor(black);
                                                            textBackground(white);

                                                            gotoXY(22, 10);
                                                            write(vResultados[intMenu].Numero, ' ', vResultados[intMenu].Trivia);
                                                            gotoXY(22, 12);
                                                            write('Respuesta 2: ', vResultados[intMenu].vOpciones[2]);

                                                            gotoXY(22, 14);
                                                            write('Ingrese nueva respuesta:');
                                                            
                                                            textBackground(red);

                                                            gotoXY(22, 15);
                                                            write('                                                                          ');

                                                            textColor(white);
                                                            
                                                            respuesta := FncLeer(charOpcionSub3, false, 74, 22, 15);

                                                            while (charOpcionSub3 <> #27) and (respuesta = '') do
                                                            begin
                                                                gotoXY(1, 43);
                                                                write('Debe completar el campo.');
                                                                delay(1750);
                                                                gotoXY(1, 43);
                                                                write('                        ');

                                                                respuesta := FncLeer(charOpcionSub3, false, 74, 22, 13);
                                                            end;

                                                            if charOpcionSub3 <> #27 then
                                                            begin
                                                                //Se graba la modificación.
                                                                varPregunta := vResultados[intMenu];
                                                                posFile := vPosResult[intMenu];
                                                                seek(fPreguntas, posFile);
                                                                varPregunta.vOpciones[2] := respuesta;
                                                                write(fPreguntas, varPregunta);

                                                                //Notificación de la barra de estado.
                                                                textColor(white);
                                                                textBackground(black);

                                                                gotoXY(1, 50);
                                                                write('Pregunta modificada');
                                                                delay(1500);
                                                                gotoXY(1, 50);
                                                                write('                   ');
                                                            end;

                                                            textBackground(white);

                                                            for j := 7 to 34 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                           ');
                                                            end;
                                                        end;
                                                        
                                                        //Modificar respuesta 3.
                                                        3:
                                                        begin
                                                            textColor(black);
                                                            textBackground(white);

                                                            gotoXY(22, 10);
                                                            write(vResultados[intMenu].Numero, ' ', vResultados[intMenu].Trivia);
                                                            gotoXY(22, 12);
                                                            write('Respuesta 3: ', vResultados[intMenu].vOpciones[3]);

                                                            gotoXY(22, 14);
                                                            write('Ingrese nueva respuesta:');
                                                            
                                                            textBackground(red);

                                                            gotoXY(22, 15);
                                                            write('                                                                          ');

                                                            textColor(white);
                                                            
                                                            respuesta := FncLeer(charOpcionSub3, false, 74, 22, 15);

                                                            while (charOpcionSub3 <> #27) and (respuesta = '') do
                                                            begin
                                                                gotoXY(1, 43);
                                                                write('Debe completar el campo.');
                                                                delay(1750);
                                                                gotoXY(1, 43);
                                                                write('                        ');

                                                                respuesta := FncLeer(charOpcionSub3, false, 74, 22, 13);
                                                            end;

                                                            if charOpcionSub3 <> #27 then
                                                            begin
                                                                //Se graba la modificación.
                                                                varPregunta := vResultados[intMenu];
                                                                posFile := vPosResult[intMenu];
                                                                seek(fPreguntas, posFile);
                                                                varPregunta.vOpciones[3] := respuesta;
                                                                write(fPreguntas, varPregunta);

                                                                //Notificación de la barra de estado.
                                                                textColor(white);
                                                                textBackground(black);

                                                                gotoXY(1, 50);
                                                                write('Pregunta modificada');
                                                                delay(1500);
                                                                gotoXY(1, 50);
                                                                write('                   ');
                                                            end;

                                                            textBackground(white);

                                                            for j := 7 to 34 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                           ');
                                                            end;
                                                        end;
                                                        
                                                        //Eliminar pregunta.
                                                        4:
                                                        begin
                                                            textColor(black);
                                                            textBackground(white);

                                                            gotoXY(22, 10);
                                                            write(vResultados[intMenu].Numero, ' ', vResultados[intMenu].Trivia);

                                                            gotoXY(22, 12);
                                                            write('Desea realmente eliminar esta pregunta? (S/N):');
                                                            
                                                            textColor(white);
                                                            textBackground(red);

                                                            write('  ');

                                                            respuesta := FncLeer(charOpcionSub3, false, 2, 68, 12);

                                                            while (charOpcionSub3 <> #27) and ((respuesta = '') or ((respuesta <> 'S') and (respuesta <> 'N'))) do
                                                            begin
                                                                textColor(white);
                                                                textBackground(red);

                                                                gotoXY(1, 43);
                                                                write('Campo vacio o respuesta invalida. Complete el campo con una opcion valida.');
                                                                delay(1750);
                                                                gotoXY(1, 43);
                                                                write('                                                                          ');

                                                                respuesta := FncLeer(charOpcionSub3, false, 2, 68, 12);
                                                            end;

                                                            if (charOpcionSub3 <> #27) and (respuesta = 'S') then
                                                            begin
                                                                //Se elimina la pregunta.
                                                                varPregunta := vResultados[intMenu];
                                                                posFile := vPosResult[intMenu];
                                                                seek(fPreguntas, posFile);
                                                                varPregunta.Estado := 99;
                                                                write(fPreguntas, varPregunta);

                                                                //Notificación de la barra de estado.
                                                                textColor(white);
                                                                textBackground(black);

                                                                gotoXY(1, 50);
                                                                write('Pregunta eliminada');
                                                                delay(1500);
                                                                gotoXY(1, 50);
                                                                write('                  ');
                                                            end;

                                                            textBackground(white);

                                                            for j := 7 to 34 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                           ');
                                                            end;
                                                        end;
                                                        
                                                        //Salir.
                                                        5: intMenu2 := -1;
                                                    end;
                                                end;
                                            end;
                                        until intMenu2 = -1;
                                    end;

                                    //Escape.
                                    27: intMenu := -1;
                                end;
                            until intMenu = -1;

                            textBackground(white);

                            for j := 7 to 34 do
                            begin
                                gotoXY(20, j);
                                write('                                                                                           ');
                            end;
                        end
                        //Si no se encontraron resultados...
                        else
                        begin
                            textColor(black);
                            textBackground(white);

                            gotoXY(22, 15);
                            write('NO SE ENCONTRARON RESULTADOS. PRESIONE CUALQUIER TECLA PARA CONTINUAR.');
                            charOpcionSub3 := readKey;
                            gotoXY(22, 15);
                            write('                                                                      ');
                        end;
                    end;
                until charOpcionSub3 = #27;
            end;

        begin 
            reset(fPreguntas);

            //buscar preguntas
             //Cuadro de diálogo.
            textBackground(white);

            for i := 7 to 35 do
            begin
                gotoXY(20,i);
                write('                                                                                           ');                
            end;

            //Texto del cuadro de diálogo.
            textColor(black);
            
            gotoXY(46, 7);
            write('BUSQUEDA DE PREGUNTAS Y RESPUESTAS');
            gotoXY(22, 12);
            write('Para buscar por numero de pregunta ingrese      - 1. ');
            gotoXY(22, 13);
            write('Para buscar por descripcion de pregunta ingrese - 2. ');
            
            textBackground(red);
            gotoXY(75, 12);
            write('  ');

            //Texto de la barra de estado.
            textColor(white);
            textBackground(black);
            gotoXY(104, 50);
            write('Escape = cancelar |');

            //se lee la respuesta.
            fin := false;
            correcto := false;

            repeat
                textBackground(red);
                textColor(white);

                respuesta := FncLeer(charOpcionSub3, true, 2, 75, 12);

                if ((respuesta = '1') or (respuesta = '2')) then
                begin
                    fin := true;
                    correcto := true; //lo que se ingresó es válido
                end
                else // no es válido
                begin
                    if charOpcionSub3 = #27 then //si no es válido sale solo si se presiona escape, si no, se repite la operación.
                        fin := true
                    else
                        PrcMensaje;

                    correcto := false; //sale por escape. 
                end;
            until (fin);

            if correcto then //se ingresaron valores válidos
            begin
                textBackground(white);

                gotoXY(22, 12);
                write('                                                       ');
                gotoXY(22, 13);
                write('                                                     ');
                
                if respuesta = '1' then
                    PrcBuscarNumero
                else if respuesta = '2' then
                    PrcBuscarDescripcion;
            end;
            
            //Se borra el cuadro de diálogo.
            textBackground(red);

            for i := 7 to 35 do
            begin
                    gotoXY(20, i);
                    write('                                                                                           ');    
            end;

            //Borar: Texto de la barra de estado.
            textBackground(black);
            gotoXY(104, 50); 
            write('                   '); 

            close(fPreguntas);
        end; //fin del proceso de busqueda

    begin
        vectorOp3[0] := 'Alta    ';
        vectorOp3[1] := 'Busqueda';
        posSubMenu3 := 0;

        //Fondo del sub-submenú 'Preguntas' del submenú 'Configuracion'.
        textBackground(black);

        for i := 1 to 2 do
        begin
            gotoXY(20, i + 3);
            write('         ');
        end;

        //Opciones de 'alta' y 'buscar'.
        textColor(white);
        
        for i := 0 to 1 do
        begin
            gotoXY(20, i + 4);
            write('-', vectorOp3[i]);
        end;

        //Selector.
        while (posSubMenu3 <> -1) do
        begin
            for i := 0 to 1 do
            begin
                if posSubMenu3 = i then
                begin
                    textBackground(lightGray);
                    textColor(yellow);
                end
                else
                begin
                    textBackground(black);
                    textColor(white);
                end;

                gotoXY(20, i + 4);
                write('-', vectorOp3[i]);
            end;

            charOpcionSub3 := readKey;

            case ord(charOpcionSub3) of
                80: if posSubMenu3 < 1 then //Flecha abajo.
                    posSubMenu3 := posSubMenu3 + 1;

                72: if posSubMenu3 > 0 then //Flecha arriba.
                    posSubMenu3 := posSubMenu3 - 1;

                13: case posSubMenu3 of //Enter.
                        0: boolPreguntas := FncAltaPreguntas;
                        1: PrcBuscarPreguntas;
                    end;

                08: posSubMenu3 := -1;
            end;
        end;

        //Borra el menú.
        textBackground(red);

        for i := 2 downto 1 do
        begin
            gotoXY(20, i + 3);
            write('         ');
        end;
    end;

begin
    vectorOp[0] := 'Casilleros';
    vectorOp[1] := 'Categorias';
    vectorOp[2] := 'Preguntas ';     
    posSubMenu := 0;

    //Fondo del submenú 'Configuración'.
    textBackground(black);

    for i := 1 to 3 do
    begin
        gotoXY(9, i + 1);
        write('          ');
    end;

    //Opciones de barra de estado.
    textColor(white);
    gotoXY(124, 50); write('BackSpace = atras');

    for i := 0 to 2 do
    begin
        gotoXY(9, i + 2);
        write('-', vectorOp[i]);
    end;

    //Selector.
    while (posSubMenu <> -1) do
    begin
        for i := 0 to 2 do
        begin
            if posSubMenu = i then
            begin
                textBackground(lightGray);
                textColor(yellow);
            end
            else
            begin
                textBackground(black);
                textColor(white);
            end;

            gotoXY(9, i + 2);
            write('-', vectorOp[i]);
        end;

        charOpcionSub := readKey;

        case ord(charOpcionSub) of
            80: if posSubMenu < 2 then
                posSubMenu := posSubMenu + 1;

            72: if posSubMenu > 0 then
                posSubMenu := posSubMenu - 1;

            13: case posSubMenu of
                    0: PrcCasilleros;
                    1: PrcCategorias;
                    2: PrcPreguntas;
                end;

            08: posSubMenu := -1;
        end;
    end;

    //Se reestablecen las opciones de la barra de estado.
    textBackground(black);
    textColor(white);
    gotoXY(124, 50); write('   Escape = salir');

    textBackground(red);

    for i := 3 downto 1 do
    begin
        gotoXY(9, i + 1);
        write('           ');
    end;
end;

procedure PrcJugar;
var 
    casilleroFinal, i, j, k, turnoAnt, cantEstrellas, iContador, turnoJugador, intPos, pregPos: integer;
    varCasillero: Casillero;
    varCategoria: Categoria;
    varPregunta: Pregunta;
    teclaJuego: char;
    respuesta, color: string;
    finDeJuego, flag, equivocado: boolean;
    listaFiltro: array [0..99] of casillero;
    aColores: array [0..5] of integer;

begin
    reset(fCasilleros);
    reset(fCategorias);
    reset(fPreguntas);

    //Comprobación de requisitos:
     //Cantidad mínima de casilleros estrella activos.
    for i := 0 to 5 do
        aColores[i] := 0;

    seek(fCasilleros, 0);

    while not eof(fCasilleros) do
    begin
        read(fCasilleros, varCasillero);

        //Si el casillero está activo y tiene estrella...
        if (varCasillero.Estado = 0) and (varCasillero.Estrella = true) then
            case varCasillero.Color of
                'V': inc(aColores[0]);
                'A': inc(aColores[1]);
                'C': inc(aColores[2]);
                'R': inc(aColores[3]);
                'M': inc(aColores[4]);
                'N': inc(aColores[5]);
            end;
    end;

    boolCasilleros := true;

    for i := 0 to 5 do
        if aColores[i] = 0 then
            boolCasilleros := false;

     //Cantidad mínima de preguntas activas por categoría.
    for i := 0 to 5 do
        aColores[i] := 0;

    seek(fPreguntas, 0);

    while not eof(fPreguntas) do
    begin
        read(fPreguntas, varPregunta);

        //Si la pregunta está activa...
        if varPregunta.Estado = 0 then
        begin
            case varPregunta.Color of
                'V': inc(aColores[0]); //Preguntas activas de la categoría V.
                'A': inc(aColores[1]); //Preguntas activas de la categoría A.
                'C': inc(aColores[2]); //Preguntas activas de la categoría C.
                'R': inc(aColores[3]); //Preguntas activas de la categoría R.
                'M': inc(aColores[4]); //Preguntas activas de la categoría M.
                'N': inc(aColores[5]); //Preguntas activas de la categoría N.
            end;
        end;
    end;

    boolPreguntas := true;

    for i := 0 to 5 do
        if aColores[i] < 6 then
            boolPreguntas := false;

    //Si la configuración cumple con los requisitos necesarios para iniciar el juego...
    if (boolCasilleros) and (boolPreguntas) then
    begin        
        i := 0;
        j := 0;
        k := 0;
        finDeJuego := false; //Bandera de condición para finalizar el juego, indicando que un jugador ganó.
        seek(fCasilleros, 0); //Se posiciona al comienzo del archivo.
        casilleroFinal := 0; //Almacenará la posición del último casillero (Servirá como condición de corte del ciclo del "tablero").

        //Llena la lista-filtro con los casilleros creados ordenados.
        while not eof(fCasilleros) do
        begin
            read(fCasilleros, varCasillero);
            listaFiltro[varCasillero.Numero] := varCasillero; //Va almacenando ordenadamente los casilleros en lista.
            
            if varCasillero.Estado = 0 then
                inc(k); //Lleva la cantidad de casilleros activos ingresados.                
        end;

        //La lista-filtro filtra todos los casilleros activos y los almacena en la lista ("tablero") del juego.
        for i := 0 to (k - 1) do
            if listaFiltro[i].Estado = 0 then
            begin
                listaCasilleros[j] := listaFiltro[i];
                inc(j);
            end;

        casilleroFinal := j - 1; //Guarda la posición del último casillero.
        
        PantallaPpal; //Se redibuja la pantalla completa.

        textColor(white);
        textBackground(red);

        //Dibuja el separador horizontal de la pantalla de jugadores.
        for i := 131 to 160 do
        begin
            gotoXY(i, 3);
            write('_');
        end;

        //Dibuja el separador vertical de la pantalla de jugadores.
        gotoXY(145, 2);
        write('|');
        gotoXY(145, 3);
        write('|');

        //Etiquetas de la pantalla de jugadores.
        gotoXY(134, 2);
        write('Jugadores');
        gotoXY(149, 2);
        write('Estrellas');

        //Cuadro de diálogo.
        textBackground(white);

        for i := 7 to 35 do
            begin
                gotoXY(20, i);
                write('                                                                                          ');    
            end; 

        //Texto del cuadro de diálogo.
        textColor(black);

        gotoXY(55, 7);
        write('INGRESO DE JUGADORES');
        gotoXY(40, 15);
        write('Nombre de jugador:');

        textColor(white);
        textBackground(red);

        gotoXY(58, 15);
        write('               ');        
        
        //Ingreso de los jugadores:
        iContador := 0; //Contador de jugadores ingresados exitósamente al juego.
        flag := false; //Bandera que indica si el usuario canceló o no en ingreso de jugadores.

         //Mientras el usuario no haya cancelado el ingreso de jugadores y no haya presionado escape...
        while (flag = false) and (ord(teclaJuego) <> 27) do
        begin
            //Si la cantidad de jugadores no supera el máximo permitido...
            if iContador < 6 then
            begin
                listaJugadores[iContador].Nombre := FncLeer(teclaJuego, false, 15, 58, 15); //Se ingresa el nombre del jugador.                
            end
            //Si la cantidad de jugadores llegó al máximo permitido...
            else
            begin
                textColor(white);
                textBackground(red);
                
                gotoXY(1, 43);
                write('Se ha ingresado la cantidad maxima posible de jugadores.');
                delay(1750);
                gotoXY(1, 43);
                write('                                                        ');
                flag := true; //Torna en "true" la bandera, indicando el fin del ciclo.
            end;
            
            //Si no se llegó a la cantidad máxima de jugadores y no se presionó escape en ningún momento...
            if (flag = false) and (ord(teclaJuego) <> 27) then
            begin
                listaJugadores[i].PosClavija := -1; //Posiciona al jugador al comienzo del tablero.
                
                //Inicia el contador de estrellas del jugador.
                for j := 0 to 5 do
                    listaJugadores[i].vEstrellas[j] := 0;
                
                inc(iContador); //Incrementa la cantidad de jugadores registrados.
                gotoXY(1, 43);
                
                //Si la cantidad de jugadores no superó la cantidad máxima permitida...
                if iContador < 6 then
                begin
                    textColor(white);
                    textBackground(red);
                    
                    gotoXY(1, 43);
                    write('Desea ingresar otro jugador? (S/N): ');
                    respuesta := FncLeer(teclaJuego, false, 2, 36, 43);

                    //Si el usuario cancela el ingreso de datos...
                    if respuesta = 'N' then
                        flag := true //Torna en "true" la bandera, indicando el fin del ciclo.
                    //Si se ingresó una opción inválida...
                    else if respuesta <> 'S' then
                        //Mientras se ingrese una respuesta inválida...
                        while (respuesta <> 'N') and (respuesta <> 'S') do
                        begin
                            textColor(white);
                            textBackground(red);
                            
                            gotoXY(36, 43);
                            write('  ');
                            gotoXY(1, 43);
                            write('Respuesta no permitida. Ingrese una respuesta valida.');
                            delay(1750);
                            gotoXY(1, 43);
                            write('                                                     ');
                            gotoXY(1, 43);
                            write('Desea ingresar otro jugador? (S/N): ');
                            respuesta := FncLeer(teclaJuego, false, 2, 36, 43);

                            //Si el usuario cancela el ingreso de datos...
                            if respuesta = 'N' then
                                flag := true; //Torna en "true" la bandera, indicando el fin del ciclo.
                        end;

                    gotoXY(1, 43);
                    write('                                    ');
                end;
            end;            
        end;

        //CÓDIGO PRINCIPAL.
         //Se borra el cuadro de diálogo de ingreso de jugadores.
        textBackground(red);

        for i := 7 to 35 do
        begin
            gotoXY(20, i);
            write('                                                                                          ');
        end;

        turnoJugador := 0; //Inicialización. Indica el jugador que tiene el turno.

         //Si existe la cantidad mínima de jugadores necesarios para jugar...
        if (iContador > 1) and (teclaJuego <> #27) then
        begin
            //Se inicializa en pantalla el puntaje de los jugadores.
            textColor(white);
            textBackground(red);

            turnoAnt := (turnoJugador * 2) + 5;
            gotoXY(128, (turnoJugador * 2) + 5);
            write('=>'); //Indica gráficamente quien tiene el truno.

            gotoXY(117, 42);
            write('Jugador | Posicion | V | A | C | R | M | N');

            for i := 0 to (iContador - 1) do
            begin
                gotoXY(131, (i * 2) + 5);
                write(listaJugadores[i].Nombre); //Escribe en pantalla el nombre del jugador.
                gotoXY(117, i + 44);
                write(listaJugadores[i].Nombre);
                gotoXY(130, i + 44);
                write('0');
                gotoXY(160, (i * 2) + 5);
                write('0'); //Inicializa en pantalla el puntaje del jugador.
            end;

            repeat
                //Mientras ningún jugador gane el juego...
                while finDeJuego = false do
                begin
                    equivocado := false;

                    //Mientras el jugador de turno no se equivoque...
                    while (equivocado = false) and (finDeJuego = false) do
                    begin
                        textColor(white);
                        textBackground(red);
                        
                        gotoXY(1, 43);
                        write('Eleccion de tema: presione cualquier tecla para tirar los dados.');

                        repeat
                            teclaJuego := readKey;
                        until ord(teclaJuego) = 13;

                        gotoXY(1, 43);
                        write('                                                                ');
                        
                        intPos := FncTirarDados(); //El jugador tira los dados. Se guarda la cantidad de lugares que va a 
                                                   //avanzar la clavija del jugador.
                        
                        textColor(white);
                        textBackground(black);

                        gotoXY(1, 50);
                        write('Ha sacado un ', intPos); //Muestra en la barra de estado que número sacó con el dado.

                        //Control en caso de dar la vuelta al tablero.
                        for i := 1 to intPos do
                        begin
                            inc(listaJugadores[turnoJugador].PosClavija); //Mueve la clavija un casillero.

                            //Si el jugador dió la vuelta al tablero...
                            if listaJugadores[turnoJugador].PosClavija > casilleroFinal then
                            begin
                                listaJugadores[turnoJugador].PosClavija := 0; //La clavija vuelve al principio del tablero.

                                //El jugador elige una estrella.
                                textColor(black);
                                textBackground(white);

                                for j := 7 to 35 do
                                begin
                                    gotoXY(20, j);
                                    write('                                                                                          ');
                                end;

                                gotoXY(22, 15);
                                write('Ha dado la vuelta al tablero. Elija una categoria: ');

                                gotoXY(22, 17);
                                write('Verde    - Deportes');
                                gotoXY(22, 18);
                                write('Amarillo - Naturaleza y Ciencia');
                                gotoXY(22, 19);
                                write('Celeste  - Historia y Geografia');
                                gotoXY(22, 20);
                                write('Rosa     - Entretenimientos y Espectaculos');
                                gotoXY(22, 21);
                                write('Marron   - Arte');
                                gotoXY(22, 22);
                                write('Naranja  - Cambalache');

                                textColor(white);
                                textBackground(red);

                                gotoXY(74, 15);
                                write('  ');
                                flag := false;

                                color := FncLeer(teclaJuego, false, 2, 74, 15); //Ingresa selección del color.

                                //Si se ingresa una opción válida...
                                if (color <> '') and ((color = 'V') or (color = 'A') or (color = 'C') or (color = 'R') or (color = 'M') or (color = 'N')) then
                                begin
                                    while flag = false do
                                    begin
                                        case color of
                                            'V':
                                                if listaJugadores[turnoJugador].vEstrellas[0] = 0 then
                                                begin
                                                    flag := true; //Corta el ciclo.
                                                    listaJugadores[turnoJugador].vEstrellas[0] := 1; //Asigna la estrella.

                                                    textBackground(white);

                                                    for j := 7 to 35 do
                                                    begin
                                                        gotoXY(20, j);
                                                        write('                                                                                          ');
                                                    end;

                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(138, turnoJugador + 44);
                                                    write('*');

                                                    finDeJuego := true;
                                                    cantEstrellas := 0;

                                                    //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                    for j := 0 to 5 do
                                                    begin
                                                        if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                            finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                        else
                                                            inc(cantEstrellas);
                                                    end;

                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(160, (turnoJugador * 2) + 5);
                                                    write(cantEstrellas);
                                                end
                                                else
                                                begin
                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(1, 43);
                                                    write('Ya tiene esta estrella. Elija otro color.');
                                                    delay(1750);
                                                    gotoXY(1, 43);
                                                    write('                                         ');
                                                end;

                                            'A':
                                                if listaJugadores[turnoJugador].vEstrellas[1] = 0 then
                                                begin
                                                    flag := true;
                                                    listaJugadores[turnoJugador].vEstrellas[1] := 1; //Asigna la estrella.

                                                    textBackground(white);

                                                    for j := 7 to 35 do
                                                    begin
                                                        gotoXY(20, j);
                                                        write('                                                                                          ');
                                                    end;

                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(142, turnoJugador + 44);
                                                    write('*');

                                                    finDeJuego := true;
                                                    cantEstrellas := 0;
                                    
                                                    //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                    for j := 0 to 5 do
                                                    begin
                                                        if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                            finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                        else
                                                            inc(cantEstrellas);
                                                    end;

                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(160, (turnoJugador * 2) + 5);
                                                    write(cantEstrellas);
                                                end
                                                else
                                                begin
                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(1, 43);
                                                    write('Ya tiene esta estrella. Elija otro color.');
                                                    delay(1750);
                                                    gotoXY(1, 43);
                                                    write('                                         ');
                                                end;

                                            'C':
                                                if listaJugadores[turnoJugador].vEstrellas[2] = 0 then
                                                begin
                                                    flag := true;
                                                    listaJugadores[turnoJugador].vEstrellas[2] := 1; //Asigna la estrella.

                                                    textBackground(white);

                                                    for j := 7 to 35 do
                                                    begin
                                                        gotoXY(20, j);
                                                        write('                                                                                          ');
                                                    end;

                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(146, turnoJugador + 44);
                                                    write('*');

                                                    finDeJuego := true;
                                                    cantEstrellas := 0;
                                    
                                                    //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                    for j := 0 to 5 do
                                                    begin
                                                        if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                            finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                        else
                                                            inc(cantEstrellas);
                                                    end;

                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(160, (turnoJugador * 2) + 5);
                                                    write(cantEstrellas);
                                                end
                                                else
                                                begin
                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(1, 43);
                                                    write('Ya tiene esta estrella. Elija otro color.');
                                                    delay(1750);
                                                    gotoXY(1, 43);
                                                    write('                                         ');
                                                end;

                                            'R':
                                                if listaJugadores[turnoJugador].vEstrellas[3] = 0 then
                                                begin
                                                    flag := true;
                                                    listaJugadores[turnoJugador].vEstrellas[3] := 1; //Asigna la estrella.

                                                    textBackground(white);

                                                    for j := 7 to 35 do
                                                    begin
                                                        gotoXY(20, j);
                                                        write('                                                                                          ');
                                                    end;

                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(150, turnoJugador + 44);
                                                    write('*');

                                                    finDeJuego := true;
                                                    cantEstrellas := 0;
                                    
                                                    //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                    for j := 0 to 5 do
                                                    begin
                                                        if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                            finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                        else
                                                            inc(cantEstrellas);
                                                    end;

                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(160, (turnoJugador * 2) + 5);
                                                    write(cantEstrellas);
                                                end
                                                else
                                                begin
                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(1, 43);
                                                    write('Ya tiene esta estrella. Elija otro color.');
                                                    delay(1750);
                                                    gotoXY(1, 43);
                                                    write('                                         ');
                                                end;

                                            'M':
                                                if listaJugadores[turnoJugador].vEstrellas[4] = 0 then
                                                begin
                                                    flag := true;
                                                    listaJugadores[turnoJugador].vEstrellas[4] := 1; //Asigna la estrella.

                                                    textBackground(white);

                                                    for j := 7 to 35 do
                                                    begin
                                                        gotoXY(20, j);
                                                        write('                                                                                          ');
                                                    end;

                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(154, turnoJugador + 44);
                                                    write('*');

                                                    finDeJuego := true;
                                                    cantEstrellas := 0;
                                    
                                                    //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                    for j := 0 to 5 do
                                                    begin
                                                        if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                            finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                        else
                                                            inc(cantEstrellas);
                                                    end;

                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(160, (turnoJugador * 2) + 5);
                                                    write(cantEstrellas);
                                                end
                                                else
                                                begin
                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(1, 43);
                                                    write('Ya tiene esta estrella. Elija otro color.');
                                                    delay(1750);
                                                    gotoXY(1, 43);
                                                    write('                                         ');
                                                end;
                                
                                            'N':
                                                if listaJugadores[turnoJugador].vEstrellas[5] = 0 then
                                                begin
                                                    flag := true;
                                                    listaJugadores[turnoJugador].vEstrellas[5] := 1; //Asigna la estrella.

                                                    textBackground(white);

                                                    for j := 7 to 35 do
                                                    begin
                                                        gotoXY(20, j);
                                                        write('                                                                                          ');
                                                    end;

                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(158, turnoJugador + 44);
                                                    write('*');

                                                    finDeJuego := true;
                                                    cantEstrellas := 0;
                                    
                                                    //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                    for j := 0 to 5 do
                                                    begin
                                                        if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                            finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                        else
                                                            inc(cantEstrellas);
                                                    end;

                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(160, (turnoJugador * 2) + 5);
                                                    write(cantEstrellas);
                                                end
                                                else
                                                begin
                                                    textColor(white);
                                                    textBackground(red);

                                                    gotoXY(1, 43);
                                                    write('Ya tiene esta estrella. Elija otro color.');
                                                    delay(1750);
                                                    gotoXY(1, 43);
                                                    write('                                         ');
                                                end;
                                        end;

                                        //Si el jugador eligió una estrella que ya tenía...
                                        if flag = false then
                                            color := FncLeer(teclaJuego, false, 2, 74, 15); //Se le vuelve a pedir una estrella de su elección.
                                    end;
                                end
                                else
                                    //Mientras se ingrese una opción inválida...
                                    while (color = '') or ((color <> 'V') and (color <> 'A') and (color <> 'C') and (color <> 'R') and (color <> 'M') and (color <> 'N')) do
                                    begin
                                        textColor(white);
                                        textBackground(red);

                                        gotoXY(74, 15);
                                        write('  ');

                                        gotoXY(1, 43);
                                        write('Color invalido. Realice otra eleccion.');
                                        delay(1750);
                                        gotoXY(1, 43);
                                        write('                                      ');

                                        color := FncLeer(teclaJuego, false, 2, 74, 15);

                                        //Si se ingresa una opción válida...
                                        if (color <> '') and ((color = 'V') or (color = 'A') or (color = 'C') or (color = 'R') or (color = 'M') or (color = 'N')) then
                                        begin
                                            while flag = false do
                                            begin
                                                case color of
                                                    'V':
                                                        if listaJugadores[turnoJugador].vEstrellas[0] = 0 then
                                                        begin
                                                            flag := true; //Corta el ciclo.
                                                            listaJugadores[turnoJugador].vEstrellas[0] := 1; //Asigna la estrella.

                                                            textBackground(white);

                                                            for j := 7 to 35 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                          ');
                                                            end;

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(138, turnoJugador + 44);
                                                            write('*');

                                                            finDeJuego := true;
                                                            cantEstrellas := 0;

                                                            //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                            for j := 0 to 5 do
                                                            begin
                                                                if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                                    finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                                else
                                                                    inc(cantEstrellas);
                                                            end;

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(160, (turnoJugador * 2) + 5);
                                                            write(cantEstrellas);
                                                        end
                                                        else
                                                        begin
                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(1, 43);
                                                            write('Ya tiene esta estrella. Elija otro color.');
                                                            delay(1750);
                                                            gotoXY(1, 43);
                                                            write('                                         ');
                                                        end;

                                                    'A':
                                                        if listaJugadores[turnoJugador].vEstrellas[1] = 0 then
                                                        begin
                                                            flag := true;
                                                            listaJugadores[turnoJugador].vEstrellas[1] := 1; //Asigna la estrella.

                                                            textBackground(white);

                                                            for j := 7 to 35 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                          ');
                                                            end;

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(142, turnoJugador + 44);
                                                            write('*');

                                                            finDeJuego := true;
                                                            cantEstrellas := 0;
                                            
                                                            //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                            for j := 0 to 5 do
                                                            begin
                                                                if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                                    finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                                else
                                                                    inc(cantEstrellas);
                                                            end;

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(160, (turnoJugador * 2) + 5);
                                                            write(cantEstrellas);
                                                        end
                                                        else
                                                        begin
                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(1, 43);
                                                            write('Ya tiene esta estrella. Elija otro color.');
                                                            delay(1750);
                                                            gotoXY(1, 43);
                                                            write('                                         ');
                                                        end;

                                                    'C':
                                                        if listaJugadores[turnoJugador].vEstrellas[2] = 0 then
                                                        begin
                                                            flag := true;
                                                            listaJugadores[turnoJugador].vEstrellas[2] := 1; //Asigna la estrella.

                                                            textBackground(white);

                                                            for j := 7 to 35 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                          ');
                                                            end;

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(146, turnoJugador + 44);
                                                            write('*');

                                                            finDeJuego := true;
                                                            cantEstrellas := 0;
                                            
                                                            //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                            for j := 0 to 5 do
                                                            begin
                                                                if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                                    finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                                else
                                                                    inc(cantEstrellas);
                                                            end;

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(160, (turnoJugador * 2) + 5);
                                                            write(cantEstrellas);
                                                        end
                                                        else
                                                        begin
                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(1, 43);
                                                            write('Ya tiene esta estrella. Elija otro color.');
                                                            delay(1750);
                                                            gotoXY(1, 43);
                                                            write('                                         ');
                                                        end;

                                                    'R':
                                                        if listaJugadores[turnoJugador].vEstrellas[3] = 0 then
                                                        begin
                                                            flag := true;
                                                            listaJugadores[turnoJugador].vEstrellas[3] := 1; //Asigna la estrella.

                                                            textBackground(white);

                                                            for j := 7 to 35 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                          ');
                                                            end;

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(150, turnoJugador + 44);
                                                            write('*');

                                                            finDeJuego := true;
                                                            cantEstrellas := 0;
                                            
                                                            //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                            for j := 0 to 5 do
                                                            begin
                                                                if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                                    finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                                else
                                                                    inc(cantEstrellas);
                                                            end;

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(160, (turnoJugador * 2) + 5);
                                                            write(cantEstrellas);
                                                        end
                                                        else
                                                        begin
                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(1, 43);
                                                            write('Ya tiene esta estrella. Elija otro color.');
                                                            delay(1750);
                                                            gotoXY(1, 43);
                                                            write('                                         ');
                                                        end;

                                                    'M':
                                                        if listaJugadores[turnoJugador].vEstrellas[4] = 0 then
                                                        begin
                                                            flag := true;
                                                            listaJugadores[turnoJugador].vEstrellas[4] := 1; //Asigna la estrella.

                                                            textBackground(white);

                                                            for j := 7 to 35 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                          ');
                                                            end;

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(154, turnoJugador + 44);
                                                            write('*');

                                                            finDeJuego := true;
                                                            cantEstrellas := 0;
                                            
                                                            //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                            for j := 0 to 5 do
                                                            begin
                                                                if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                                    finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                                else
                                                                    inc(cantEstrellas);
                                                            end;

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(160, (turnoJugador * 2) + 5);
                                                            write(cantEstrellas);
                                                        end
                                                        else
                                                        begin
                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(1, 43);
                                                            write('Ya tiene esta estrella. Elija otro color.');
                                                            delay(1750);
                                                            gotoXY(1, 43);
                                                            write('                                         ');
                                                        end;
                                        
                                                    'N':
                                                        if listaJugadores[turnoJugador].vEstrellas[5] = 0 then
                                                        begin
                                                            flag := true;
                                                            listaJugadores[turnoJugador].vEstrellas[5] := 1; //Asigna la estrella.

                                                            textBackground(white);

                                                            for j := 7 to 35 do
                                                            begin
                                                                gotoXY(20, j);
                                                                write('                                                                                          ');
                                                            end;

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(158, turnoJugador + 44);
                                                            write('*');

                                                            finDeJuego := true;
                                                            cantEstrellas := 0;
                                            
                                                            //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                            for j := 0 to 5 do
                                                            begin
                                                                if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                                    finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                                else
                                                                    inc(cantEstrellas);
                                                            end;

                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(160, (turnoJugador * 2) + 5);
                                                            write(cantEstrellas);
                                                        end
                                                        else
                                                        begin
                                                            textColor(white);
                                                            textBackground(red);

                                                            gotoXY(1, 43);
                                                            write('Ya tiene esta estrella. Elija otro color.');
                                                            delay(1750);
                                                            gotoXY(1, 43);
                                                            write('                                         ');
                                                        end;
                                                end;

                                                //Si el jugador eligió una estrella que ya tenía...
                                                if flag = false then
                                                    color := FncLeer(teclaJuego, false, 2, 74, 15); //Se le vuelve a pedir una estrella de su elección.
                                            end;
                                        end;                                
                                    end;
                            end;
                        end;
                        
                        intPos := listaJugadores[turnoJugador].PosClavija; //Se actualiza la posición del jugador.

                        textColor(white);
                        textBackground(red);

                        //Actualiza la posición del jugador en el marcador del área de información.
                        gotoXY(130, turnoJugador + 44);
                        write(intPos);
                        
                        //Actualiza los datos del casillero.
                        gotoXY(91, 39);
                        write('Casillero ', listaCasilleros[intPos].Numero, ' => color: ', listaCasilleros[intPos].Color, '; estrella: ');

                        if listaCasilleros[intPos].Estrella = true then
                            write('si')
                        else
                            write('no');

                        color := listaCasilleros[intPos].Color;

                        //Si el jugador cae en un casillero gris...
                        if listaCasilleros[intPos].Color = 'G' then
                        begin
                            textColor(black);
                            textBackground(white);

                            for i := 7 to 35 do
                            begin
                                gotoXY(20, i);
                                write('                                                                                          ');
                            end;

                            gotoXY(22, 15);
                            write('Ha caido en un casillero gris. Elija una categoria: ');

                            gotoXY(22, 17);
                            write('Verde    - Deportes');
                            gotoXY(22, 18);
                            write('Amarillo - Naturaleza y Ciencia');
                            gotoXY(22, 19);
                            write('Celeste  - Historia y Geografia');
                            gotoXY(22, 20);
                            write('Rosa     - Entretenimientos y Espectaculos');
                            gotoXY(22, 21);
                            write('Marron   - Arte');
                            gotoXY(22, 22);
                            write('Naranja  - Cambalache');

                            textColor(white);
                            textBackground(red);

                            gotoXY(74, 15);
                            write('  ');
                            flag := false;

                            color := FncLeer(teclaJuego, false, 2, 74, 15); //Ingresa selección del color.

                            //Si se ingresa una opción válida...
                            if (color <> '') and ((color = 'V') or (color = 'A') or (color = 'C') or (color = 'R') or (color = 'M') or (color = 'N')) then
                            begin
                                while flag = false do
                                begin
                                    case color of
                                        'V':
                                            if listaJugadores[turnoJugador].vEstrellas[0] = 0 then
                                            begin
                                                flag := true; //Corta el ciclo.
                                                listaJugadores[turnoJugador].vEstrellas[0] := 1; //Asigna la estrella.

                                                textBackground(white);

                                                for i := 7 to 35 do
                                                begin
                                                    gotoXY(20, i);
                                                    write('                                                                                          ');
                                                end;

                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(138, turnoJugador + 44);
                                                write('*');

                                                finDeJuego := true;
                                                cantEstrellas := 0;

                                                //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                for i := 0 to 5 do
                                                begin
                                                    if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                        finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                    else
                                                        inc(cantEstrellas);
                                                end;

                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(160, (turnoJugador * 2) + 5);
                                                write(cantEstrellas);
                                            end
                                            else
                                            begin
                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(1, 43);
                                                write('Ya tiene esta estrella. Elija otro color.');
                                                delay(1750);
                                                gotoXY(1, 43);
                                                write('                                         ');
                                            end;

                                        'A':
                                            if listaJugadores[turnoJugador].vEstrellas[1] = 0 then
                                            begin
                                                flag := true;
                                                listaJugadores[turnoJugador].vEstrellas[1] := 1; //Asigna la estrella.

                                                textBackground(white);

                                                for i := 7 to 35 do
                                                begin
                                                    gotoXY(20, i);
                                                    write('                                                                                          ');
                                                end;

                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(142, turnoJugador + 44);
                                                write('*');

                                                finDeJuego := true;
                                                cantEstrellas := 0;
                                    
                                                //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                for i := 0 to 5 do
                                                begin
                                                    if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                        finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                    else
                                                        inc(cantEstrellas);
                                                end;

                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(160, (turnoJugador * 2) + 5);
                                                write(cantEstrellas);
                                            end
                                            else
                                            begin
                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(1, 43);
                                                write('Ya tiene esta estrella. Elija otro color.');
                                                delay(1750);
                                                gotoXY(1, 43);
                                                write('                                         ');
                                            end;

                                        'C':
                                            if listaJugadores[turnoJugador].vEstrellas[2] = 0 then
                                            begin
                                                flag := true;
                                                listaJugadores[turnoJugador].vEstrellas[2] := 1; //Asigna la estrella.

                                                textBackground(white);

                                                for i := 7 to 35 do
                                                begin
                                                    gotoXY(20, i);
                                                    write('                                                                                          ');
                                                end;

                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(146, turnoJugador + 44);
                                                write('*');

                                                finDeJuego := true;
                                                cantEstrellas := 0;
                                    
                                                //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                for i := 0 to 5 do
                                                begin
                                                    if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                        finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                    else
                                                        inc(cantEstrellas);
                                                end;

                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(160, (turnoJugador * 2) + 5);
                                                write(cantEstrellas);
                                            end
                                            else
                                            begin
                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(1, 43);
                                                write('Ya tiene esta estrella. Elija otro color.');
                                                delay(1750);
                                                gotoXY(1, 43);
                                                write('                                         ');
                                            end;

                                        'R':
                                            if listaJugadores[turnoJugador].vEstrellas[3] = 0 then
                                            begin
                                                flag := true;
                                                listaJugadores[turnoJugador].vEstrellas[3] := 1; //Asigna la estrella.

                                                textBackground(white);

                                                for i := 7 to 35 do
                                                begin
                                                    gotoXY(20, i);
                                                    write('                                                                                          ');
                                                end;

                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(150, turnoJugador + 44);
                                                write('*');

                                                finDeJuego := true;
                                                cantEstrellas := 0;
                                    
                                                //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                for i := 0 to 5 do
                                                begin
                                                    if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                        finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                    else
                                                        inc(cantEstrellas);
                                                end;

                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(160, (turnoJugador * 2) + 5);
                                                write(cantEstrellas);
                                            end
                                            else
                                            begin
                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(1, 43);
                                                write('Ya tiene esta estrella. Elija otro color.');
                                                delay(1750);
                                                gotoXY(1, 43);
                                                write('                                         ');
                                            end;

                                        'M':
                                            if listaJugadores[turnoJugador].vEstrellas[4] = 0 then
                                            begin
                                                flag := true;
                                                listaJugadores[turnoJugador].vEstrellas[4] := 1; //Asigna la estrella.

                                                textBackground(white);

                                                for i := 7 to 35 do
                                                begin
                                                    gotoXY(20, i);
                                                    write('                                                                                          ');
                                                end;

                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(154, turnoJugador + 44);
                                                write('*');

                                                finDeJuego := true;
                                                cantEstrellas := 0;
                                    
                                                //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                for i := 0 to 5 do
                                                begin
                                                    if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                        finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                    else
                                                        inc(cantEstrellas);
                                                end;

                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(160, (turnoJugador * 2) + 5);
                                                write(cantEstrellas);
                                            end
                                            else
                                            begin
                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(1, 43);
                                                write('Ya tiene esta estrella. Elija otro color.');
                                                delay(1750);
                                                gotoXY(1, 43);
                                                write('                                         ');
                                            end;
                                
                                        'N':
                                            if listaJugadores[turnoJugador].vEstrellas[5] = 0 then
                                            begin
                                                flag := true;
                                                listaJugadores[turnoJugador].vEstrellas[5] := 1; //Asigna la estrella.

                                                textBackground(white);

                                                for i := 7 to 35 do
                                                begin
                                                    gotoXY(20, i);
                                                    write('                                                                                          ');
                                                end;

                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(158, turnoJugador + 44);
                                                write('*');

                                                finDeJuego := true;
                                                cantEstrellas := 0;
                                    
                                                //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                for i := 0 to 5 do
                                                begin
                                                    if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                        finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                    else
                                                        inc(cantEstrellas);
                                                end;

                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(160, (turnoJugador * 2) + 5);
                                                write(cantEstrellas);
                                            end
                                            else
                                            begin
                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(1, 43);
                                                write('Ya tiene esta estrella. Elija otro color.');
                                                delay(1750);
                                                gotoXY(1, 43);
                                                write('                                         ');
                                            end;
                                    end;

                                    //Si el jugador eligió una estrella que ya tenía...
                                    if flag = false then
                                        color := FncLeer(teclaJuego, false, 2, 74, 15); //Se le vuelve a pedir una estrella de su elección.
                                end;
                            end
                            else
                                //Mientras se ingrese una opción inválida...
                                while (color = '') or ((color <> 'V') and (color <> 'A') and (color <> 'C') and (color <> 'R') and (color <> 'M') and (color <> 'N')) do
                                begin
                                    textColor(white);
                                    textBackground(red);

                                    gotoXY(74, 15);
                                    write('  ');

                                    gotoXY(1, 43);
                                    write('Color invalido. Realice otra eleccion.');
                                    delay(1750);
                                    gotoXY(1, 43);
                                    write('                                      ');

                                    color := FncLeer(teclaJuego, false, 2, 74, 15);

                                    //Si se ingresa una opción válida...
                                    if (color <> '') and ((color = 'V') or (color = 'A') or (color = 'C') or (color = 'R') or (color = 'M') or (color = 'N')) then
                                    begin
                                        while flag = false do
                                        begin
                                            case color of
                                                'V':
                                                    if listaJugadores[turnoJugador].vEstrellas[0] = 0 then
                                                    begin
                                                        flag := true; //Corta el ciclo.
                                                        listaJugadores[turnoJugador].vEstrellas[0] := 1; //Asigna la estrella.

                                                        textBackground(white);

                                                        for i := 7 to 35 do
                                                        begin
                                                            gotoXY(20, i);
                                                            write('                                                                                          ');
                                                        end;

                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(138, turnoJugador + 44);
                                                        write('*');

                                                        finDeJuego := true;
                                                        cantEstrellas := 0;

                                                        //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                        for i := 0 to 5 do
                                                        begin
                                                            if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                                finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                            else
                                                                inc(cantEstrellas);
                                                        end;

                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(160, (turnoJugador * 2) + 5);
                                                        write(cantEstrellas);
                                                    end
                                                    else
                                                    begin
                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(1, 43);
                                                        write('Ya tiene esta estrella. Elija otro color.');
                                                        delay(1750);
                                                        gotoXY(1, 43);
                                                        write('                                         ');
                                                    end;

                                                'A':
                                                    if listaJugadores[turnoJugador].vEstrellas[1] = 0 then
                                                    begin
                                                        flag := true;
                                                        listaJugadores[turnoJugador].vEstrellas[1] := 1; //Asigna la estrella.

                                                        textBackground(white);

                                                        for i := 7 to 35 do
                                                        begin
                                                            gotoXY(20, i);
                                                            write('                                                                                          ');
                                                        end;

                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(142, turnoJugador + 44);
                                                        write('*');

                                                        finDeJuego := true;
                                                        cantEstrellas := 0;
                                            
                                                        //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                        for i := 0 to 5 do
                                                        begin
                                                            if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                                finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                            else
                                                                inc(cantEstrellas);
                                                        end;

                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(160, (turnoJugador * 2) + 5);
                                                        write(cantEstrellas);
                                                    end
                                                    else
                                                    begin
                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(1, 43);
                                                        write('Ya tiene esta estrella. Elija otro color.');
                                                        delay(1750);
                                                        gotoXY(1, 43);
                                                        write('                                         ');
                                                    end;

                                                'C':
                                                    if listaJugadores[turnoJugador].vEstrellas[2] = 0 then
                                                    begin
                                                        flag := true;
                                                        listaJugadores[turnoJugador].vEstrellas[2] := 1; //Asigna la estrella.

                                                        textBackground(white);

                                                        for i := 7 to 35 do
                                                        begin
                                                            gotoXY(20, i);
                                                            write('                                                                                          ');
                                                        end;

                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(146, turnoJugador + 44);
                                                        write('*');

                                                        finDeJuego := true;
                                                        cantEstrellas := 0;
                                            
                                                        //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                        for i := 0 to 5 do
                                                        begin
                                                            if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                                finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                            else
                                                                inc(cantEstrellas);
                                                        end;

                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(160, (turnoJugador * 2) + 5);
                                                        write(cantEstrellas);
                                                    end
                                                    else
                                                    begin
                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(1, 43);
                                                        write('Ya tiene esta estrella. Elija otro color.');
                                                        delay(1750);
                                                        gotoXY(1, 43);
                                                        write('                                         ');
                                                    end;

                                                'R':
                                                    if listaJugadores[turnoJugador].vEstrellas[3] = 0 then
                                                    begin
                                                        flag := true;
                                                        listaJugadores[turnoJugador].vEstrellas[3] := 1; //Asigna la estrella.

                                                        textBackground(white);

                                                        for i := 7 to 35 do
                                                        begin
                                                            gotoXY(20, i);
                                                            write('                                                                                          ');
                                                        end;

                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(150, turnoJugador + 44);
                                                        write('*');

                                                        finDeJuego := true;
                                                        cantEstrellas := 0;
                                            
                                                        //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                        for i := 0 to 5 do
                                                        begin
                                                            if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                                finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                            else
                                                                inc(cantEstrellas);
                                                        end;

                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(160, (turnoJugador * 2) + 5);
                                                        write(cantEstrellas);
                                                    end
                                                    else
                                                    begin
                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(1, 43);
                                                        write('Ya tiene esta estrella. Elija otro color.');
                                                        delay(1750);
                                                        gotoXY(1, 43);
                                                        write('                                         ');
                                                    end;

                                                'M':
                                                    if listaJugadores[turnoJugador].vEstrellas[4] = 0 then
                                                    begin
                                                        flag := true;
                                                        listaJugadores[turnoJugador].vEstrellas[4] := 1; //Asigna la estrella.

                                                        textBackground(white);

                                                        for i := 7 to 35 do
                                                        begin
                                                            gotoXY(20, i);
                                                            write('                                                                                          ');
                                                        end;

                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(154, turnoJugador + 44);
                                                        write('*');

                                                        finDeJuego := true;
                                                        cantEstrellas := 0;
                                            
                                                        //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                        for i := 0 to 5 do
                                                        begin
                                                            if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                                finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                            else
                                                                inc(cantEstrellas);
                                                        end;

                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(160, (turnoJugador * 2) + 5);
                                                        write(cantEstrellas);
                                                    end
                                                    else
                                                    begin
                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(1, 43);
                                                        write('Ya tiene esta estrella. Elija otro color.');
                                                        delay(1750);
                                                        gotoXY(1, 43);
                                                        write('                                         ');
                                                    end;
                                        
                                                'N':
                                                    if listaJugadores[turnoJugador].vEstrellas[5] = 0 then
                                                    begin
                                                        flag := true;
                                                        listaJugadores[turnoJugador].vEstrellas[5] := 1; //Asigna la estrella.

                                                        textBackground(white);

                                                        for i := 7 to 35 do
                                                        begin
                                                            gotoXY(20, i);
                                                            write('                                                                                          ');
                                                        end;

                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(158, turnoJugador + 44);
                                                        write('*');

                                                        finDeJuego := true;
                                                        cantEstrellas := 0;
                                            
                                                        //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                        for i := 0 to 5 do
                                                        begin
                                                            if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                                finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                            else
                                                                inc(cantEstrellas);
                                                        end;

                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(160, (turnoJugador * 2) + 5);
                                                        write(cantEstrellas);
                                                    end
                                                    else
                                                    begin
                                                        textColor(white);
                                                        textBackground(red);

                                                        gotoXY(1, 43);
                                                        write('Ya tiene esta estrella. Elija otro color.');
                                                        delay(1750);
                                                        gotoXY(1, 43);
                                                        write('                                         ');
                                                    end;
                                            end;

                                            //Si el jugador eligió una estrella que ya tenía...
                                            if flag = false then
                                                color := FncLeer(teclaJuego, false, 2, 74, 15); //Se le vuelve a pedir una estrella de su elección.
                                        end;
                                    end;                                
                                end;
                        end
                        //Si el jugador no cae en un casillero gris...
                        else
                        begin
                            //Se busca la categoría del casillero y la pregunta...
                            flag := false;
                            seek(fCategorias, 0);

                            //Mientras no se encuentre la categoría...
                            while flag = false do
                            begin
                                read(fCategorias, varCategoria);

                                //Si se enuentra la categoría...
                                if varCategoria.Color = color then
                                begin
                                    flag := true; //Corta el ciclo de búsqueda.
                                    pregPos := 0; //Se inicializa el puntero de las preguntas.
                                
                                    textColor(white);
                                    textBackground(red);
                                
                                    gotoXY(1, 43);
                                    write('Eleccion de pregunta: presione cualquier tecla para tirar los dados.');

                                    repeat
                                        teclaJuego := readKey;
                                    until ord(teclaJuego) = 13;

                                    gotoXY(1, 43);
                                    write('                                                                    ');
                                
                                    pregPos := FncTirarDados(); //El jugador tira los dados para buscar la pregunta.

                                    textColor(white);
                                    textBackground(black);

                                    gotoXY(1, 50);
                                    write('Ha sacado un ', pregPos);

                                    flag := false;
                                    seek(fPreguntas, 0);

                                    while (not eof(fPreguntas)) and (flag = false) do
                                    begin
                                        read(fPreguntas, varPregunta);

                                        if (varPregunta.Color = color) and (varPregunta.Numero = pregPos) then
                                            flag := true; //Corta el ciclo.
                                    end;

                                    textColor(black);
                                    textBackground(white);

                                    for i := 7 to 35 do
                                    begin
                                        gotoXY(20, i);
                                        write('                                                                                          ');
                                    end;

                                    gotoXY(61, 7);
                                    write('PREGUNTA');

                                    gotoXY(22, 9);
                                    write('Tema: ', varCategoria.Nombre); //Muestra el nombre de la categoría.
                                
                                    gotoXY(22, 15);
                                    write(varPregunta.Trivia); //Muestra la pregunta en pantalla.

                                    //Muestra las diferentes respuestas posibles...
                                    for i := 0 to 2 do
                                    begin
                                        gotoXY(23, (i * 2) + 18);
                                        write(i + 1, ') ',varPregunta.vOpciones[i + 1]);
                                    end;
                                end;
                            end;

                            textBackground(red);

                            gotoXY(53, 25);
                            write('  ');

                            textColor(black);
                            textBackground(white);
                                
                            gotoXY(22, 25);
                            write('Elija una respuesta (1, 2 o 3): ');

                            textColor(white);
                            textBackground(red);

                            respuesta := FncLeer(teclaJuego, true, 2, 53, 25);

                            textBackground(black);

                            gotoXY(1, 50);
                            write('              ');
                        
                            //Si se elige una respuesta inválida...
                            if (respuesta <> '1') and (respuesta <> '2') and (respuesta <> '3') then
                            begin                            
                                flag := false;
                            
                                //Mientras la opción elegida sea inválida...
                                while flag = false do
                                begin
                                    textColor(white);
                                    textBackground(red);

                                    gotoXY(1, 43);
                                    write('Respuesta fuera del rango permitido. Elija una de las respuestas en pantalla.');
                                    delay(1750);
                                    gotoXY(1, 43);
                                    write('                                                                             ');
                                    gotoXY(53, 25);
                                    write('  ');
                                
                                    textColor(black);
                                    textBackground(white);

                                    respuesta := FncLeer(teclaJuego, true, 2, 53, 25);

                                    //Si la respuesta es válida...
                                    if (respuesta = '1') or (respuesta = '2') or (respuesta = '3') then
                                    begin
                                        gotoXY(22, 25);
                                        write('                                         ');

                                        flag := true; //Torna en "true" la bandera, indicando el fin de ciclo.

                                        //Si el jugador contesta bien...
                                        if respuesta = varPregunta.Respuesta then
                                        begin
                                            //Si el casillero tiene estrella...
                                            if listaCasilleros[intPos].Estrella = true then
                                            begin
                                                case color of
                                                    //Si el jugador no tiene la estrella del color del casillero...
                                                    'V': if listaJugadores[turnoJugador].vEstrellas[0] = 0 then
                                                            listaJugadores[turnoJugador].vEstrellas[0] := 1; //Se le asigna la estrella al jugador.

                                                    'A': if listaJugadores[turnoJugador].vEstrellas[1] = 0 then
                                                            listaJugadores[turnoJugador].vEstrellas[1] := 1;

                                                    'C': if listaJugadores[turnoJugador].vEstrellas[2] = 0 then
                                                            listaJugadores[turnoJugador].vEstrellas[2] := 1;

                                                    'R': if listaJugadores[turnoJugador].vEstrellas[3] = 0 then
                                                            listaJugadores[turnoJugador].vEstrellas[3] := 1;

                                                    'M': if listaJugadores[turnoJugador].vEstrellas[4] = 0 then
                                                            listaJugadores[turnoJugador].vEstrellas[4] := 1;

                                                    'N': if listaJugadores[turnoJugador].vEstrellas[5] = 0 then
                                                            listaJugadores[turnoJugador].vEstrellas[5] := 1;
                                                end;

                                                textColor(white);
                                                textBackground(red);
                                                
                                                finDeJuego := true; //Se configura en "true" la bandera de fin de juego.
                                                cantEstrellas := 0;
                                                j := 138;

                                                //Se actualizan las estrellas del jugador en el marcador.
                                                for i := 0 to 5 do
                                                begin
                                                    if listaJugadores[turnoJugador].vEstrellas[i] = 1 then
                                                    begin
                                                        gotoXY(j, turnoJugador + 44);
                                                        write('*');
                                                    end;
                                                
                                                    j := j + 4;
                                                end;

                                                j := 0;

                                                //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                                for i := 0 to 5 do
                                                begin
                                                    if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                        finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                                    else
                                                        inc(cantEstrellas);
                                                end;

                                                textColor(white);
                                                textBackground(red);

                                                gotoXY(160, (turnoJugador * 2) + 5);
                                                write(cantEstrellas);
                                            end;

                                            textColor(black);
                                            textBackground(white);

                                            gotoXY(35, 30);
                                            write('RESPUESTA CORRECTA');                                              
                                            gotoXY(30, 31);
                                            write('PRESIONE CUALQUIER TECLA PARA CONTINUAR');                                              
                                            repeat until keypressed;

                                            textBackground(white);

                                            for i := 7 to 35 do
                                            begin
                                                gotoXY(20, i);
                                                write('                                                                                          ');
                                            end;
                                        end
                                        //Si el jugador contesta mal...
                                        else
                                        begin
                                            equivocado := true; //Torna en "false" la bandera, finalizando el turno del jugador.

                                            textColor(black);
                                            textBackground(white);

                                            gotoXY(35, 30);
                                            write('RESPUESTA INCORRECTA');                                              
                                            gotoXY(30, 31);
                                            write('PRESIONE CUALQUIER TECLA PARA CONTINUAR');                                              
                                            repeat until keypressed;
                                        
                                            textBackground(white);

                                            for i := 7 to 35 do
                                            begin
                                                gotoXY(20, i);
                                                write('                                                                                          ');
                                            end;
                                        end;

                                        textBackground(red);

                                        gotoXY(91, 39);
                                        write('                                      ');
                                    end;
                                end;
                            end
                            //Si se elige una respuesta válida...(NOTA: la respuesta válida es aquella que está dentro de las respuestas posibles en pantalla)
                            else
                            begin
                                textBackground(white);
                            
                                gotoXY(22, 25);
                                write('                                         ');

                                //Si el jugador contesta bien...(En caso de que la respuesta sea VÁLIDA y CORRECTA)
                                if respuesta = varPregunta.Respuesta then
                                begin
                                    //Si el casillero tiene estrella...
                                    if listaCasilleros[intPos].Estrella = true then
                                    begin
                                        case color of
                                            'V': //Si el jugador no tiene la estrella del color del casillero...
                                                 if listaJugadores[turnoJugador].vEstrellas[0] = 0 then
                                                    listaJugadores[turnoJugador].vEstrellas[0] := 1; //Se le asigna la estrella al jugador.

                                            'A': if listaJugadores[turnoJugador].vEstrellas[1] = 0 then
                                                    listaJugadores[turnoJugador].vEstrellas[1] := 1;

                                            'C': if listaJugadores[turnoJugador].vEstrellas[2] = 0 then
                                                    listaJugadores[turnoJugador].vEstrellas[2] := 1;

                                            'R': if listaJugadores[turnoJugador].vEstrellas[3] = 0 then
                                                    listaJugadores[turnoJugador].vEstrellas[3] := 1;

                                            'M': if listaJugadores[turnoJugador].vEstrellas[4] = 0 then
                                                    listaJugadores[turnoJugador].vEstrellas[4] := 1;

                                            'N': if listaJugadores[turnoJugador].vEstrellas[5] = 0 then
                                                    listaJugadores[turnoJugador].vEstrellas[5] := 1;
                                        end;

                                        textColor(white);
                                        textBackground(red);
                                        
                                        finDeJuego := true; //Se configura en "true" la bandera de fin de juego.
                                        cantEstrellas := 0;
                                        j := 138;

                                        //Se actualizan las estrellas del jugador en el marcador.
                                        for i := 0 to 5 do
                                        begin
                                            if listaJugadores[turnoJugador].vEstrellas[i] = 1 then
                                            begin
                                                gotoXY(j, turnoJugador + 44);
                                                write('*');
                                            end;
                                                
                                            j := j + 4;
                                        end;

                                        j := 0;

                                        //Si se encuentra al menos una estrella que el jugador no tenga ganada...
                                        for i := 0 to 5 do
                                        begin
                                            if listaJugadores[turnoJugador].vEstrellas[i] = 0 then
                                                finDeJuego := false //Se vuelve a configurar como "false" la bandera de fin de juego.
                                            else
                                                inc(cantEstrellas);
                                        end;

                                        textColor(white);
                                        textBackground(red);

                                        gotoXY(160, (turnoJugador * 2) + 5);
                                        write(cantEstrellas);
                                    end;

                                    textColor(black);
                                    textBackground(white);

                                    gotoXY(35, 30);
                                    write('RESPUESTA CORRECTA');                           
                                    gotoXY(30, 31);
                                    write('PRESIONE CUALQUIER TECLA PARA CONTINUAR');                                              
                                    repeat until keypressed;

                                    textBackground(white);

                                    for i := 7 to 35 do
                                    begin
                                        gotoXY(20, i);
                                        write('                                                                                          ');
                                    end;
                                end
                                //Si el jugador contesta mal...
                                else
                                begin
                                    equivocado := true; //Torna en "false" la bandera, finalizando el turno del jugador.

                                    textColor(black);
                                    textBackground(white);

                                    gotoXY(35, 30);
                                    write('RESPUESTA INCORRECTA');                           
                                    gotoXY(30, 31);
                                    write('PRESIONE CUALQUIER TECLA PARA CONTINUAR');                                              
                                    repeat until keypressed;
                                
                                    textBackground(white);

                                    for i := 7 to 35 do
                                    begin
                                        gotoXY(20, i);
                                        write('                                                                                          ');
                                    end;
                                end;

                                textBackground(red);

                                gotoXY(91, 39);
                                write('                                      ');
                            end;
                        end;
                    end;

                    //Si el jugador ganó, se muestra un mensaje en pantalla...
                    if finDeJuego = true then
                    begin
                        textColor(black);
                        textBackground(white);

                        for i := 7 to 35 do
                        begin
                            gotoXY(20, i);
                            write('                                                                                          ');
                        end;

                        gotoXY(30, 21);
                        write('FIN DEL JUEGO. GANADOR: ', listaJugadores[turnoJugador].Nombre);
                        gotoXY(30, 23);
                        write('PRESIONE CUALQUIER TECLA PARA CONTINUAR');
                    end;                    
                    
                    inc(turnoJugador); //Cambia el truno del jugador.

                    textColor(white);
                    textBackground(red);                    
                    
                    gotoXY(91, 39);
                    write('                                      ');

                    //Si se recorrió toda la lista de jugadores...
                    if turnoJugador = iContador then
                        turnoJugador := 0; //Se vuelve al principio de la lista.

                    gotoXY(128, turnoAnt);
                    write('  ');
                    turnoAnt := (turnoJugador * 2) + 5;
                    gotoXY(128, (turnoJugador * 2) + 5);
                    write('=>');
                end;
            until (ord(teclaJuego) = 27) or (finDeJuego);
        end
        //Si no existe la cantidad mínima de jugadores necesarios para jugar...
        else if teclaJuego <> #27 then
        begin
            textColor(white);
            textBackground(red);

            gotoXY(1, 43);
            write('No hay suficientes jugadores para comenzar la partida.');
            delay(1750);
            gotoXY(1, 43);
            write('                                                      ');
        end;
        
        textColor(white);
        textBackground(red);

        if teclaJuego <> #27 then
        begin
            gotoXY(1, 43);
            write('Presione Enter para continuar.');
            repeat
                teclaJuego := readKey;
            until teclaJuego = #13;
        end;
        
        //Se reestablecen los parámetros de diseño anteriores de la pantalla:
         //Borra el separador horizontal de la pantalla de jugadores.
        for i := 131 to 160 do
        begin
            gotoXY(i, 3);
            write(' ');
        end;

         //Borra el separador vertical de la pantalla de jugadores.
        gotoXY(145, 2);
        write(' ');
        gotoXY(145, 3);
        write(' ');

         //Borra las etiquetas de la pantalla de jugadores.
        gotoXY(134, 2);
        write('         ');
        gotoXY(149, 2);
        write('         ');        
    end
    //Si la configuración no cumple con los requisitos necesarios para iniciar el juego...
    else
    begin
        textColor(white);
        textBackground(red);
        
        gotoXY(1, 43);
        write('Imposible iniciar juego. Compruebe si hay algun parametro pendiente por configurar.');
        delay(1750);
        gotoXY(1, 43);
        write('                                                                                   ');
    end;

    close(fCasilleros);
    close(fCategorias);
    close(fPreguntas);
end;
    
//MENÚ PRINCIPAL.
begin
    assign(fCasilleros, sDirectorio + '\Casilleros.dat');
    assign(fCategorias, sDirectorio + '\Categorias.dat');
    assign(fPreguntas, sDirectorio + '\Preguntas.dat');

    clrScr;
    vectorPpal[0] := 'Jugar';
    vectorPpal[1] := 'Configuracion';
    vectorPpal[2] := 'Salir';
    vectorPpal[3] := 'Crear archivos';
    PantallaPpal;
    posMenu := 0;

    repeat 
        for i := 0 to 3 do
        begin
            if posMenu = i then
            begin
                textBackground(lightGray);
                textColor(yellow);
            end
            else
            begin
                textBackground(black);
                textColor(white);
            end;

            k := 0; //Se re/inicializa la variable para acumular la longitud de las opciones. 

            if i > 0 then //Si la opción elegida no es la primera...
                for j := 0 to (i - 1) do //
                    k := k + length(vectorPpal[j]) + 3;

            gotoXY(k + 1, 1);
            write(' ', vectorPpal[i], ' |');
        end;

        charOpcion := readKey;

        case ord(charOpcion) of
            77: if posMenu < 3 then
                posMenu := posMenu + 1;

            75: if posMenu > 0 then
                posMenu := posMenu - 1;

            13: case posMenu of
                    0: PrcJugar; //Inicia el juego (aún no controla si se configuraron todos los puntos anteriores).
                    1: PrcConfiguracion; //Abre la configuración.
                    2: posMenu := -1; //Opción 'Salir'. Sale del programa.
                    3:
                    begin
                        rewrite(fCasilleros);
                        rewrite(fCategorias);
                        rewrite(fPreguntas);

                        textBackground(black);
                        textColor(white);

                        gotoXY(1, 50);
                        write('Archivos creados/limpiados');
                        delay(1500);
                        gotoXY(1, 50);
                        write('                          ');
                    end;
                end;

            27: posMenu := -1; //Sale del programa.
        end;
    until posMenu = -1;
end.