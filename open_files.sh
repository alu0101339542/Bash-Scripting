#!/bin/bash
#Práctica SSOO por Daniel Pérez Lozano

#Funciones

l_arch_usu() #Muestra una lista de los archivos abiertos por los USuarios junto con algunas propiedades
{
  USERS=$(who | cut -f1 -d" " | sort | uniq)
  for US in ${USERS}
  do
    NOPENFILES=$(lsof -u ${US} | wc -l)
    USERID=$(id -u ${US})
    PID=$(ps -f -u ${US} --sort=start_time|head -n2|tail -n1|tr -s " " " "|cut -f2 -d" ")
    echo User name: ${US}, number of open files: ${NOPENFILES}, UID: ${USERID}, PID mas antiguo: ${PID}
  done
}

argumentos()
{
  while [ "$1" != "" ]; do
    case $1 in
      -f | --file )
          shift
          busc_patron $1
          ;;
        -u )
          fuser $*
          ;;
        -o | --off_line )
          usuarios_no_conectados
          ;;
        -h | --help )
          echo "Este programa muestra una lista de los archivos abiertos por los usuarios junto con algunas propiedades\
además busca archivos con un patron determinado con la opcion -f.  Parámetro -o --off_line se debe incluir el listado anterior\
pero únicamente para los usuarios que no estén conectados al sistema. Parametro -u para filtrar por usuario"  
          exit
          ;;
        * )
          error_exit $1
          exit 1
    esac
    shift
  done
}

busc_patron() #funcion que busca un patron 
{
  PATTERN=$1
  echo "Suma del numero de archivos abiertos en el sitema por un parametro dado: "
  lsof | grep ${PATTERN}$ | wc -l 

}

error_exit() #Funcion que da errores en el paso de argumentos
{
        echo Error en el paso de argumentos "$1" 1>&2
        exit 1
}

usuarios_no_conectados() #funcion que imprime el numero de ficheros abiertos no interactivos
{
  ALLUSE=$(ps -eo user --no-headers|sort|uniq)
  INTERACTIVE=$(who | cut -f1 -d" " | sort | uniq)
  DUMMY=1
  for AUS in ${ALLUSE}
  do
    for INT in ${INTERACTIVE}
      do
      if [ "${AUS}" == "${INT}" ]; then
        DUMMY=0
        break
      fi
    done
    if [ "${DUMMY}" == 1 ]; then
      echo -n "${AUS}:   "
      lsof -u ${AUS} | wc -l
    fi 
    DUMMY=1
  done
}

fuser() #funcion que limita hasta donde estan los usuarios y donde se encuentra el patron
{
  USERS=""
  PATTERN=""
  shift
  while [ "$1" != "" ] 
  do
    if [ "$1" != "-f" ]; then
      USERS="${USERS} $1"
    else
      shift
      PATTERN=$1
    fi
    shift
  done

search_pattern $USERS $PATTERN
}

search_pattern() #funcion que imprime los ficheros abiertos por un determinado usuario con un patron
{
  for USE in $USERS
  do
    echo -n "Ficheros abiertos con la restriccion ${PATTERN} para el usuario ${USE} --> "
    lsof -u ${USE}| grep ${PATTERN}$ | wc -l
  done
  exit 0
}

#Comienzo del programa

which lsof >&/dev/null || echo "lsof no instalado" 
argumentos $*
l_arch_usu
 


