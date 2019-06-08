#!/bin/bash
#En esta variable ponemos nuestro dominio educativo (incluyendo la @)
DOMINIO="@midominio.com"
#Unimos los .csv de los distintos cursos que haya en la carpeta (regAlum de Séneca)
cat *.csv > ficheros-unidos.csv
#Insertamos \n porque de lo contrario no lee el último alumno
echo '\n' >> ficheros-unidos.csv
#Convertimos el fichero al formato UTF-8
iconv -f "windows-1252" -t "UTF-8" ficheros-unidos.csv > ficheros-unidos-utf8.csv
#Escribimos las cabeceras necesarias en el archivo para poder importarlo en Office365
echo "Nombre de usuario,Nombre,Apellidos,Nombre para mostrar,Puesto,Departamento,Número del trabajo,Teléfono del trabajo,Teléfono móvil,Número de fax,Dirección,Ciudad,Estado o provincia,Código postal,País o región" > importarOffice.csv
IFS=,
while read apellidos nombre resto;
do
	#El email estará formado por el nombre y dos apellidos seguidos
	email=$(echo "${nombre/\"/}${apellidos/\"/}"$DOMINIO | tr '[:upper:]' '[:lower:]' | tr -d '[[:space:]]' | tr "áéíóúñ'" "aeioun")
	nombre=$(echo ${nombre/\"/}| sed 's/^[[:space:]]*//')
	if [ $email != $(echo 'estadomatricula"alumno/a"'$DOMINIO) ]
	then
		echo "$email,$nombre,${apellidos/\"/},${nombre/\"/}"" ""${apellidos/\"/},,,,,,,,,,," >> importarOffice.csv
	fi
done < ficheros-unidos-utf8.csv
#Eliminamos los ficheros auxiliares utilizados
rm ficheros-unidos.csv
rm ficheros-unidos-utf8.csv