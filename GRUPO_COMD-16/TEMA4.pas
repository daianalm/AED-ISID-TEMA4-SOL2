{$CODEPAGE UTF8}
program XCOMMaterialReport;

const
  MAX_MATERIALS = 1000; // Puedes ajustar este valor.

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
        2: materiales[numMateriales + 1].tecnologia := campo[1];
        3: materiales[numMateriales + 1].nombreClave := campo;
        4: 
        begin
          Val(campo, materiales[numMateriales + 1].cantidad, convertResult);
          if convertResult <> 0 then
          begin
            Writeln('Error en la cantidad del material ', materiales[numMateriales + 1].nombreClave);
            Exit; // Terminate the program if there is an error
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

procedure GenerarSecuenciaSalida();
var
  i: Integer;
begin
  writeln('Materiales de tecnología L o P:');
  for i := 1 to numMateriales do
  begin
    if (materiales[i].tecnologia = 'L') or (materiales[i].tecnologia = 'P') then
      writeln('Nombre Clave: ', materiales[i].nombreClave, ', Cantidad: ', materiales[i].cantidad);

    if materiales[i].tecnologia = 'B' then
      writeln('Material de tecnología B: ', materiales[i].nombreClave);
  end;
end;

procedure InformarCantidadPorTecnologia();
var
  i: Integer;
  cantB, cantL, cantP: Integer;
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
  // Creamos el archivo de salida.
  Assign(archivoSalida, 'materiales_tipo_L.txt');
  Rewrite(archivoSalida);

  // Recorremos los materiales y escribimos los de tecnología 'L' con el código buscado.
  for i := 1 to numMateriales do
  begin
    if (materiales[i].tecnologia = 'L') and (materiales[i].codigo = codigoBuscado) then
      writeln(archivoSalida, materiales[i].nombreClave, ',', materiales[i].cantidad, ',', materiales[i].estado);
  end;

  // Cerramos el archivo.
  Close(archivoSalida);

  writeln('Archivo de salida generado correctamente.');
end;

// Programa principal
var
  codigoBuscado: string[5];
begin
  LeerMateriales();
  GenerarSecuenciaSalida();
  InformarCantidadPorTecnologia();

  // Solicitamos el código a buscar en el archivo de salida.
  writeln('Ingrese el código para el archivo de salida: ');
  readln(codigoBuscado);

  GenerarArchivoSalida(codigoBuscado);

  // Esperamos a que el usuario presione Enter antes de terminar el programa.
  writeln('Presione Enter para salir...');
  readln;
end.