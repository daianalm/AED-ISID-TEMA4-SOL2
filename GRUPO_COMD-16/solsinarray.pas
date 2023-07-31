{$CODEPAGE UTF8}
program XCOMMaterialReport;

const
  MAX_MATERIALS = 1000; //  Se Puede ajustar este valor.

type
  Material = record
    codigo: string[5];
    tecnologia: Char;
    nombreClave: string[30];
    cantidad: Integer;
    estado: string[100];
  end;

  PMaterial = ^MaterialNode;

  MaterialNode = record
    material: Material;
    next: PMaterial;
  end;

var
  head: PMaterial;
  numMateriales: Integer;

procedure AgregarMaterial(var head: PMaterial; codigo: string; tecnologia: Char;
  nombreClave: string; cantidad: Integer; estado: string);
var
  newMaterialNode: PMaterial;
begin
  New(newMaterialNode);
  newMaterialNode^.material.codigo := codigo;
  newMaterialNode^.material.tecnologia := tecnologia;
  newMaterialNode^.material.nombreClave := nombreClave;
  newMaterialNode^.material.cantidad := cantidad;
  newMaterialNode^.material.estado := estado;
  newMaterialNode^.next := head;
  head := newMaterialNode;
end;

procedure LeerMateriales();
var
  archivoEntrada: Text;
  linea, codigo, nombreClave, estado: string;
  tecnologia: Char;
  cantidad, convertResult: Integer;
begin
  Assign(archivoEntrada, 'datos_materiales.txt');
  Reset(archivoEntrada);

  numMateriales := 0;
  head := nil;

  while not EOF(archivoEntrada) do
  begin
    ReadLn(archivoEntrada, linea);
    codigo := Copy(linea, 1, 5);
    tecnologia := linea[7];
    nombreClave := Copy(linea, 9, Pos('#', linea) - 9);
    Val(Copy(linea, Pos('#', linea) + 1, 3), cantidad, convertResult);
    estado := Copy(linea, Pos('#', linea) + 5);

    if convertResult = 0 then
      AgregarMaterial(head, codigo, tecnologia, nombreClave, cantidad, estado)
    else
      Writeln('Error en la cantidad del material ', nombreClave);
  end;

  Close(archivoEntrada);
end;

procedure GenerarSecuenciaSalida();
var
  actual: PMaterial;
begin
  actual := head;
  writeln('Materiales de tecnología L o P:');
  while actual <> nil do
  begin
    if (actual^.material.tecnologia = 'L') or (actual^.material.tecnologia = 'P') then
      writeln('Código: ', actual^.material.codigo, ', Tecnología: ', actual^.material.tecnologia,
              ', Nombre Clave: ', actual^.material.nombreClave, ', Cantidad: ', actual^.material.cantidad)
    else if actual^.material.tecnologia = 'B' then
      writeln('Código: ', actual^.material.codigo, ', Tecnología: ', actual^.material.tecnologia,
              ', Material de tecnología B: ', actual^.material.nombreClave, ', Cantidad: ', actual^.material.cantidad);

    actual := actual^.next;
  end;
end;

procedure InformarCantidadPorTecnologia();
var
  actual: PMaterial;
  cantB, cantL, cantP: Integer;
begin
  actual := head;
  cantB := 0;
  cantL := 0;
  cantP := 0;

  while actual <> nil do
  begin
    case actual^.material.tecnologia of
      'B': cantB := cantB + 1;
      'L': cantL := cantL + 1;
      'P': cantP := cantP + 1;
    end;
    actual := actual^.next;
  end;

  writeln('Cantidad de materiales de tecnología B: ', cantB);
  writeln('Cantidad de materiales de tecnología L: ', cantL);
  writeln('Cantidad de materiales de tecnología P: ', cantP);
end;

procedure GenerarArchivoSalida(codigoBuscado: string);
var
  archivoSalida: Text;
  actual: PMaterial;
begin
  Assign(archivoSalida, 'materiales_tipo_L.txt');
  Rewrite(archivoSalida);

  actual := head;
  while actual <> nil do
  begin
    if (actual^.material.tecnologia = 'L') and (actual^.material.codigo = codigoBuscado) then
      writeln(archivoSalida, actual^.material.nombreClave, ',', actual^.material.cantidad, ',', actual^.material.estado);
    actual := actual^.next;
  end;

  Close(archivoSalida);

  writeln('Archivo de salida generado correctamente.');
end;

var
  codigoBuscado: string;
begin
  LeerMateriales();
  GenerarSecuenciaSalida();
  InformarCantidadPorTecnologia();

  writeln('Ingrese el código para el archivo de salida: ');
  readln(codigoBuscado);

  GenerarArchivoSalida(codigoBuscado);

  writeln('Presione Enter para salir...');
  readln;
end.



procedure GenerarSecuenciaSalida();
var
  actual: PMaterial;
begin
  actual := head;
  writeln('Materiales de tecnología L o P:');
  while actual <> nil do
  begin
    if (actual^.tecnologia = 'L') or (actual^.tecnologia = 'P') then
      writeln('Código: ', actual^.codigo, ', Tecnología: ', actual^.tecnologia,
              ', Nombre Clave: ', actual^.nombreClave, ', Cantidad: ', actual^.cantidad);

    if actual^.tecnologia = 'B' then
      writeln('Código: ', actual^.codigo, ', Tecnología: ', actual^.tecnologia,
              ', Material de tecnología B: ', actual^.nombreClave);

    actual := actual^.next;
  end;
end;

procedure InformarCantidadPorTecnologia();
var
  actual: PMaterial;
  cantB, cantL, cantP: Integer;
begin
  actual := head;
  cantB := 0;
  cantL := 0;
  cantP := 0;

  while actual <> nil do
  begin
    case actual^.tecnologia of
      'B': cantB := cantB + 1;
      'L': cantL := cantL + 1;
      'P': cantP := cantP + 1;
    end;
    actual := actual^.next;
  end;

  writeln('Cantidad de materiales de tecnología B: ', cantB);
  writeln('Cantidad de materiales de tecnología L: ', cantL);
  writeln('Cantidad de materiales de tecnología P: ', cantP);
end;

procedure GenerarArchivoSalida(codigoBuscado: string);
var
  archivoSalida: Text;
  actual: PMaterial;
begin
  Assign(archivoSalida, 'materiales_tipo_L.txt');
  Rewrite(archivoSalida);

  actual := head;
  while actual <> nil do
  begin
    if (actual^.tecnologia = 'L') and (actual^.codigo = codigoBuscado) then
      writeln(archivoSalida, actual^.nombreClave, ',', actual^.cantidad, ',', actual^.estado);

    actual := actual^.next;
  end;

  Close(archivoSalida);

  writeln('Archivo de salida generado correctamente.');
end;

// Programa principal
var
  codigoBuscado: string;
begin
  LeerMateriales();
  GenerarSecuenciaSalida();
  InformarCantidadPorTecnologia();

  writeln('Ingrese el código para el archivo de salida: ');
  readln(codigoBuscado);

  GenerarArchivoSalida(codigoBuscado);

  writeln('Presione Enter para salir...');
  readln;
end.
