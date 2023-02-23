#!/bin/bash

# sysinfo - Un script que informa del estado del sistema

# Opciones por defecto. OJO, lo normal es ponerlas al principio del script, junto a las
# constantes, para que sean fáciles de encontrar y modificar por otros programadores

interactive=
filename=~/sysinfo.txt
PROGNAME=$(basename $0)

##### Constantes

TITLE="Información del sistema para $HOSTNAME"
RIGHT_NOW=$(date +"%x %r%Z")
TIME_STAMP="Actualizada el $RIGHT_NOW por $USER"

##### Estilos

TEXT_BOLD=$(tput bold)
TEXT_ULINE=$(tput sgr 0 1)
TEXT_GREEN=$(tput setaf 2)
TEXT_RESET=$(tput sgr0)


##### Funciones

error_exit()
{

#        --------------------------------------------------------------
#        Función para salir en caso de error fatal

#                Acepta 1 argumento:
#                        cadena conteniendo un mensaje descriptivo del error
#        --------------------------------------------------------------

    echo "${PROGNAME}: ${1:-"Error desconocido"}" 1>&2
    exit 1
}


system_info()
{
   echo "${TEXT_ULINE}Versión del sistema${TEXT_RESET}"

    echo
   uname -a
}


show_uptime()
{
   echo "${TEXT_ULINE}Tiempo de encendido del sistema${TEXT_RESET}"

    echo
   uptime
}

show_stats()
{
  USUARIO=$(who | cut -f1 -d" " | sort | uniq)
  
  echo USUARIO      ID          SHELL         NROC
  echo --------------------------------------------------------
  for US in ${USUARIO}
  do
    NROC=$(ps -f -u $US --sort=start_time|head -n2|tail -n1|tr -s " " " "|cut -f2 -d" ")
    SHELL=$(getent passwd $US | cut -f7 -d":")
    echo "${US} $UID ${SHELL} ${NROC}"
  done
  #printf "|%10s|%10s|\n" "$(whoami)" "Nombre"
}


drive_space()
{
   echo "${TEXT_ULINE}Espacio en el sistema de archivos${TEXT_RESET}"
   echo
   df
}

home_space()
{
   # Sólo el superusuario puede obtener esta información
   if [ "$USER" = "root" ]; then
       echo "${TEXT_ULINE}Espacio en home por usuario${TEXT_RESET}"
       echo
       echo "Bytes Directorio"
       du -s /home/* | sort -nr
   fi
}

usage()
{
   echo "usage: sysinfo [-f file ] [-i] [-h]"

}


##### Programa principal

write_page()

{

    # El script-here se puede indentar dentro de la función si

    # se usan tabuladores y "<<-EOF" en lugar de "<<".

    cat << _EOF_

$TEXT_BOLD$TITLE$TEXT_RESET


$(system_info)


$(show_uptime)

$(show_stats)


$(drive_space)


$(home_space)


$TEXT_GREEN$TIME_STAMP$TEXT_RESET

)

_EOF_

}


# Procesar la línea de comandos del script para leer las opciones
while [ "$1" != "" ]; do
   case $1 in
       -f | --file )

            shift
           filename=$1
           ;;
       -i | --interactive )

            interactive=1

            ;;
       -s | --show_stats )

            show_stats

            ;;

       -h | --help )

            usage
           exit
           ;;
       * )

            usage
           error_exit "Opción desconocida"
   esac
   shift
done


# Generar el informe del sistema y guardarlo en el archivo indicado

# en $filename

write_page > $filename