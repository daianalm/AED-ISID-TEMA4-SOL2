{$CODEPAGE UTF8}
program XCOMMaterialReport;

const
  MAX_MATERIALS = 1000; // Puedes ajustar este valor según tus necesidades.

type
  Material = record
    codigo: string[5];
    tecnologia: Char;
    nombreClave: string[30];
    cantidad: Integer;
    estado: string[100];
  end;

var
  materiales: array[1..MAX_MATERIALS] of Material;
  numMateriales: Integer;

procedure LeerMateriales();
var
  archivoEntrada: Text;
  linea, campo: string;
  i, inicioCampo, finCampo, convertResult: Integer;
begin
  // Abrir el archivo de entrada.
  Assign(archivoEntrada, 'datos_materiales.txt');
  Reset(archivoEntrada);

  // Inicializar la cantidad de materiales a cero.
  numMateriales := 0;

  // Leer los datos de cada material desde el archivo.
  while not EOF(archivoEntrada) do
  begin
    // Leer una línea del archivo.
    ReadLn(archivoEntrada, linea);

    // Dividir la línea en campos usando la coma como delimitador.
    inicioCampo := 1;
    for i := 1 to 5 do
    begin
      finCampo := Pos(',', linea, inicioCampo);
      if finCampo = 0 then
        finCampo := Length(linea) + 1;

      campo := Copy(linea, inicioCampo, finCampo - inicioCampo);
      case i of
        1: materiales[numMateriales + 1].codigo := campo;
        2: materiales[numMateriales + 1].tecnologia := UpCase(campo[1]); // Convertir a mayúsculas para evitar problemas con la validación.
        3: materiales[numMateriales + 1].nombreClave := campo;
        4:
        begin
          // Verificamos si el campo cantidad está vacío y lo asumimos como cero.
          if campo = '' then
            materiales[numMateriales + 1].cantidad := 0
          else
          begin
            Val(campo, materiales[numMateriales + 1].cantidad, convertResult);
            if convertResult <> 0 then
            begin
              Writeln('Error en la cantidad del material ', materiales[numMateriales + 1].nombreClave);
              Exit; // Terminar el programa si hay un error
            end;
          end;
        end;
        5: materiales[numMateriales + 1].estado := campo;
      end;
      inicioCampo := finCampo + 1;
    end;

    // Incrementar la cantidad de materiales.
    Inc(numMateriales);
  end;

  // Cerrar el archivo.
  Close(archivoEntrada);
end;

procedure MostrarMaterialesTecnologiaB();
var
  i: Integer;
begin
  writeln('Materiales de tecnología B:');
  for i := 1 to numMateriales do
  begin
    if materiales[i].tecnologia = 'B' then
      writeln('Nombre Clave: ', materiales[i].nombreClave, ', Cantidad: ', materiales[i].cantidad);
  end;
end;

procedure GenerarSecuenciaSalida(tecnologiaFiltrada: Char);
var
  i: Integer;
begin
  writeln('Materiales de tecnología ', tecnologiaFiltrada, ':');
  for i := 1 to numMateriales do
  begin
    if (materiales[i].tecnologia = tecnologiaFiltrada) then
    begin
      writeln('Nombre Clave: ', materiales[i].nombreClave, ', Cantidad: ', materiales[i].cantidad);

      // Aquí puedes agregar cualquier otra acción que quieras realizar con los materiales P o L
    end;
  end;
end;

procedure InformarCantidadPorTecnologia();
var
  i, cantB, cantL, cantP: Integer;
begin
  // Inicializamos los contadores a cero.
  cantB := 0;
  cantL := 0;
  cantP := 0;

  // Contamos los materiales de cada tecnología.
  for i := 1 to numMateriales do
  begin
    case materiales[i].tecnologia of
      'B': cantB := cantB + 1;
      'L': cantL := cantL + 1;
      'P': cantP := cantP + 1;
    end;
  end;

  // Mostramos los resultados por pantalla.
  writeln('Cantidad de materiales de tecnología B: ', cantB);
  writeln('Cantidad de materiales de tecnología L: ', cantL);
  writeln('Cantidad de materiales de tecnología P: ', cantP);
end;

procedure GenerarArchivoSalida(codigoBuscado: string);
var
  archivoSalida: Text;
  i: Integer;
begin
  Assign(archivoSalida, 'materiales_tipo_L.txt');
  Rewrite(archivoSalida);

  for i := 1 to numMateriales do
  begin
    if (materiales[i].tecnologia = 'L') and (materiales[i].codigo = codigoBuscado) then
    begin
      writeln(archivoSalida, 'Nombre Clave: ', materiales[i].nombreClave);
      writeln(archivoSalida, 'Cantidad: ', materiales[i].cantidad);
      writeln(archivoSalida, 'Estado: ', materiales[i].estado);
      writeln(archivoSalida, '-------------------');
    end;
  end;

  Close(archivoSalida);
  writeln('Archivo de salida generado correctamente.');
end;


//Programa principal
var
  codigoBuscado: string;
  tecnologiaFiltrada: Char;
  continuar: Char;
begin
  repeat
    LeerMateriales();

    // Solicitamos al usuario que ingrese la tecnología 'P' o 'L'
    repeat
      writeln('Ingrese la tecnología a filtrar (P o L): ');
      readln(tecnologiaFiltrada);

      // Validamos que solo se haya ingresado la letra 'P' o 'L'
      tecnologiaFiltrada := UpCase(tecnologiaFiltrada); // Convertimos a mayúscula para evitar problemas con la validación.

      if (tecnologiaFiltrada <> 'P') and (tecnologiaFiltrada <> 'L') then
      begin
        writeln('Error: La tecnología ingresada no es válida. Por favor, ingrese P o L.');
      end;
    until (tecnologiaFiltrada = 'P') or (tecnologiaFiltrada = 'L');

    // Mostramos los materiales de tecnología 'B' por pantalla
    MostrarMaterialesTecnologiaB();

    // Mostramos los materiales de tecnología 'P' o 'L' por pantalla
    GenerarSecuenciaSalida(tecnologiaFiltrada);

    // Informamos la cantidad de materiales por tecnología
    InformarCantidadPorTecnologia();

    // Generamos el archivo de salida con el código de "TECNOLOGÍA L" si se ingresó la tecnología 'P'
    if tecnologiaFiltrada = 'P' then
    begin
      writeln('¿Desea generar el archivo de tecnología L? (S/N)');
      readln(continuar);
      continuar := UpCase(continuar);
      if continuar = 'S' then
      begin
        writeln('Ingrese el código de "TECNOLOGÍA L" para el archivo de salida: ');
        readln(codigoBuscado);
        GenerarArchivoSalida(codigoBuscado);
      end;
    end
    else if tecnologiaFiltrada = 'L' then
    begin
      writeln('¿Desea generar el archivo de tecnología L? (S/N)');
      readln(continuar);
      continuar := UpCase(continuar);
      if continuar = 'S' then
      begin
        writeln('Ingrese el código para el archivo de salida de tecnología L: ');
        readln(codigoBuscado);
        GenerarArchivoSalida(codigoBuscado);
      end;
    end;

    //Mensaje de despedida y preguntar si desea continuar
    writeln('GRACIAS');
    writeln('¿Desea consultar otra tecnología? (S/N)');
    readln(continuar);
    continuar := UpCase(continuar);
  until continuar <> 'S';

  // Mensaje de despedida final
  writeln('¡Hasta luego!');
end.