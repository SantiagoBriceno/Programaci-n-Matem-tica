fprintf("\t\t\nMETODOS DE MINIMIZACIÓN Y MAXIMIZACIÓN\n");
fprintf("\t\t\nSANTIAGO GABRIEL BRICEÑO FERNÁNDEZ - 28.063.634\n");

fprintf("\t\t\nMinimizacion por el Metodo de las 2 Fases\n");

fprintf("\n\n Minimizar Z = 4*X1 + X2\n\n\t Restricciones:\n\t3*X1 + X2 = 3\n\t4*X1 + 3*X2 >= 6\n\tX1 + 2*X2 <= 4\n\tX1 ^ X2 >= 0")

fprintf("\nMatriz SIMPLEX de inicio:\n")
matriz_inicio = [
    0, 0, 0, 0,-1,-1, 0;
    3, 1, 0, 0, 1, 0, 3;
    4, 3,-1, 0, 0, 1, 6;
    1, 2, 0, 1, 0, 0, 4;
];
disp(matriz_inicio)

fprintf("Igualando a 0 las variables de holgura (R1, R2)\n\n")

matriz_inicio(1,:) = matriz_inicio(1,:) + matriz_inicio(2,:) + matriz_inicio(3,:);

disp(matriz_inicio)

fprintf("Inicio de la primera fase\n\n")

#Funcion para verificacion de un positivo en la fila de Z
function [existe mayor indice_columna] = buscando_positivo(matriz)
  mayor = 0;
  existe = false;
  indice_columna = 0;
  fprintf("Buscamos en la fila de Z los numeros más positivos\n\n");
  for j=1:6

    if(mayor < matriz(1,j))
      fprintf("Valor positivo = %.6f \n\n",matriz(1,j))
      existe = true;
      mayor = matriz(1,j);
      indice_columna = j;
    end
  endfor
endfunction

#Funcion para buscar la menor de las divisiones entre la columna llegada y columna pivote
function [menor indice_fila] = buscando_pivote(matriz, indice_columna)
  menor = 999;
  fprintf("\n\n Buscamos el Pivote\n");
  for i=2:4
    if(matriz(i,indice_columna) > 0)
      fprintf("%.6f  /  %.6f  = %.6f\n\n",matriz(i,7),matriz(i,indice_columna),matriz(i,7) / matriz(i,indice_columna));
      if(matriz(i,7) / matriz(i,indice_columna) < menor) #Colocar condicion de negativos y 0 de no tomar en cuenta
        menor = matriz(i,7) / matriz(i,indice_columna)
        indice_fila = i;
      endif
    endif
  endfor
endfunction

#Funcion que regresa el pivote
function pivote = get_pivote(matriz,indice_fila,indice_columna) #UTILIZADO en pivote_1
  fprintf("\nObtenemos pivote: \n");
  pivote = matriz(indice_fila,indice_columna);
  disp(pivote)
endfunction

#Funcion que modifica la fila del pivote, y convierte el pivote a 1 SEGUN LOS PASOS DE GAUSS JORDAN
function matriz_act = pivote_1(matriz,indice_fila,indice_columna)
  matriz_act = matriz;
  fprintf("\n\nMatriz Antes del Cambio\n");
  disp(matriz_act)
  pivote_act = get_pivote(matriz,indice_fila,indice_columna);
  for j=1:7
    matriz_act(indice_fila,j) = matriz_act(indice_fila,j) / pivote_act;
  endfor

  fprintf("\n\nMatriz Actualizada: \n");
  disp(matriz_act)
endfunction

#Funcion que realiza los cambios a las filas para volver la columna pivote en 0
function matriz_actual = columna_pivote_cero(matriz, indice_fila, indice_columna)
    matriz_actual = matriz;
    for i=1:4
      valor_columna = matriz_actual(i,indice_columna);
      if(i == indice_fila)
        #Nada que hacer, estamos en la fila pivote
      else
        matriz_actual(i,:) = matriz_actual(i,:) - (matriz_actual(indice_fila,:) * valor_columna);
      endif
      fprintf("\n\nCambios a la Fila(%d))\n",i);
      disp(matriz_actual)
    endfor

    fprintf("\n\nMatriz antes del cambio:\n")
    disp(matriz)

    fprintf("\n\n\nValor luego de la Columna = 0 \n");
    disp(matriz_actual)
endfunction

#Inicio del Bucle de la Primera Fase
[positivo mayor columna] = buscando_positivo(matriz_inicio);
i = 0;
while(mayor > true && i!= 5)
  i += 1;
  fprintf("\n\n\t\tIteracion #%d\n\n",i);
  fprintf("Encontramos el valor más positivo de la tabla\n");
  fprintf("En la columna [%d] se encuentra el valor mas positivo, %.6f \n\n",columna,mayor);
  fprintf("Procedemos a encontrar el pivote de esa columna, segun la Menor division\n");
  [menor fila] = buscando_pivote(matriz_inicio,columna);
  fprintf("\n\n Convertimos el pivote en 1 y aplicamos CAMBIOS a la fila\n")
  matriz_inicio = pivote_1(matriz_inicio,fila,columna);
  fprintf("\n\n Luego Convertimos la columna del pivote en 0 y APLICAMOS CAMBIOS a las demas filas\n");
  matriz_inicio = columna_pivote_cero(matriz_inicio,fila,columna);
  fprintf("\n\nVerificamos si aun hay numeros positivos en la tabla...de ser si se repite, si no pasamos a la verificacion\n");
  [positivo mayor columna] = buscando_positivo(matriz_inicio);
endwhile

#Inicio de la Segunda Fase

fprintf("PUNTO DE INFLECCIÓN DEL METODO DE 2 FASES. Culmunando la primera.");

matriz_inicio(:, 5:6) = [];

Z = [-4, -1, 0, 0, 0];



fprintf("Modificando la matriz para inicio de la fase 2,  adicionando nuevo valor a la fila de Z\n\n");
matriz_inicio(1,:) = Z;
disp(matriz_inicio)

fprintf("\n\n\t Inicio de la SEGUNDA FASE\n\n");

fprintf("Volvemos 0 nuestras variables principales\n\n");

matriz_inicio(1,:) = matriz_inicio(1,:) + (4*(matriz_inicio(2,:))) + matriz_inicio(3,:);

fprintf("Matriz actulizada: \n\n")
disp(matriz_inicio)

fprintf("\nValrores Obtenidos:\n\t Z = %.6f \n\t X1 = %.6f \n\t X2 = %.6f",matriz_inicio(1,5),matriz_inicio(2,5),matriz_inicio(3,5));
Z = matriz_inicio(1,5);
X1 = matriz_inicio(2,5);
X2 = matriz_inicio(3,5);
fprintf("\n\n\t\t COMPROBACION:\n\nYa que no hay valores positivos procedemos a evaluar los resultados obtenidos:\n")
fprintf("\n\t Z = 4*%.6f + %.6f =",X1,X2);
disp(Z)
fprintf("\n\t 3*%.6f + %.6f = 3",X1,X2);
fprintf("\n\t 4*%.6f + 3*%.6f >= 6",X1,X2);
fprintf("\n\t %.6f + 2*%.6f <= 4",X1,X2);
fprintf("\n\t %.6f , %.6f >= 0",X1,X2);

fprintf("\n\n\n\t\t FIN DEL PROGRAMA\n\n");
