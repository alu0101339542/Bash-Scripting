#!/bin/bash
info_usuario()
{
  echo ${USER}
  echo $(date +"%d-%m-%y-%T")

}
mas_grande()
{
  du ~/backups/* #|sort -n|tail -n1|cut -f2
}


cd ~/
if [ -d ~/backups ]; then
  echo "el directorio ya existe"
else
  mkdir ~/backups
fi

cp /tmp/*[[:digit:]][[:digit:]][[:digit:]]*.txt ~/backups
pgrep xeyes >& /dev/null && echo "si encontro"
rm -r ~/backups/fotos{1..12}
mkdir ~/backups/fotos{1..12}

info_usuario
mas_grande