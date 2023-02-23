#!/bin/bash
#funciones
l_arch_dir()
{
  USERSCONENCT=$(ps -eo user|sort|uniq)
  for US in ${USERSCONENCT}
  do
    
	case $3 in
		)
		;;
 
		k)
		;;
		m)
		;;
     error_exit $3
          exit 1
  esac
}

which lsof >&/dev/null || echo "lsof no instalado"



