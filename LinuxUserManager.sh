#!/bin/bash

#VARIABLES PRINCIPALES
# con export son las variables necesarias para exportar al los siguientes script
#variables para el menu_info

export NombreScript="Linux User Manager"
export DescripcionDelScript="Herramienta configuracion usuarios, carpetas y permisos, configuracion samba"
export Correo="scripts@mbbsistemas.com"
export Web="https://repositorio.mbbsistemas.es"
export version="1.1"
conexion="Sin comprobar"
software="Sin comprobar"
actualizado="No se ha podido comprobar la actualizacion del script"

# VARIABLE QUE RECOJEN LAS RUTAS
ruta_ejecucion=$(dirname "$(readlink -f "$0")") #es la ruta de ejecucion del script sin la / al final
ruta_escritorio=$(xdg-user-dir DESKTOP) #es la ruta de tu escritorio sin la / al final

# VARIABLES PARA LA ACTUALIZAION CON GITHUB
NombreScriptActualizar="LinuxUserManager.sh" #contiene el nombre del script para poder actualizar desde github
DireccionGithub="https://github.com/sukigsx/LinuxUserManager" #contiene la direccion de github para actualizar el script

#VARIABLES DE SOFTWARE NECESARIO
# Asociamos comandos con el paquete que los contiene [comando a comprobar]="paquete a instalar"
    declare -A requeridos
    requeridos=(
        #[NombreDeUtilidad]="PaqueteParaInstalar"
        [git]="git"
        [diff]="diff"
        [curl]="curl"
        [getfacl]="acl"
        [which]="which"
        [ping]="ping"
       # [samba]="smbclient"
        [awk]="gawk"
        [realpath]="coreutils"
        [nano]="nano"
        [figlet]="figlet"
    )


#colores
rojo="\e[0;31m\033[1m" #rojo
verde="\e[;32m\033[1m"
azul="\e[0;34m\033[1m"
amarillo="\e[0;33m\033[1m"
rosa="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
borra_colores="\033[0m\e[0m" #borra colores


# FUNCIONES

#!/bin/bash

# Función que comprueba si se ejecuta como root
check_root() {
    clear
    menu_info


    if [ "$EUID" -ne 0 ]; then
        echo ""
        echo -e "${amarillo} Este script necesita permisos de sudo${borra_colores}"
        echo ""
        exec sudo bash "$0" "$@"
        echo -e "${verde} Ejecutando como root${borra_colores}"; sleep 2
    fi
}


#toma el control al pulsar control + c
trap ctrl_c INT
function ctrl_c()
{
clear
echo ""
echo -e "${azul} GRACIAS POR UTILIZAR MI SCRIPT${borra_colores}"
echo ""
sudo rm -r /tmp/base_dir >/dev/null 2>&1
sleep 1
exit
}

menu_info(){
# muestra el menu de sukigsx
echo ""
echo -e "${rosa}            _    _                  ${azul}   Nombre del script${borra_colores} ($NombreScript)"
echo -e "${rosa}  ___ _   _| | _(_) __ _ _____  __  ${azul}   Descripcion${borra_colores} ($DescripcionDelScript)"
echo -e "${rosa} / __| | | | |/ / |/ _\ / __\ \/ /  ${azul}   Version            =${borra_colores} $version"
echo -e "${rosa} \__ \ |_| |   <| | (_| \__ \>  <   ${azul}   Conexion Internet  =${borra_colores} $conexion"
echo -e "${rosa} |___/\__,_|_|\_\_|\__, |___/_/\_\  ${azul}   Software necesario =${borra_colores} $software"
echo -e "${rosa}                  |___/             ${azul}   Actualizado        =${borra_colores} $actualizado"
echo -e ""
echo -e "${azul} Contacto:${borra_colores} (Correo $Correo) (Web $Web)${borra_colores}"
echo ""
}


actualizar_script(){
# actualizar el script
#para que esta funcion funcione necesita:
#   conexion a internet
#   la paleta de colores
#   software: git diff

git clone $DireccionGithub /tmp/comprobar >/dev/null 2>&1

diff $ruta_ejecucion/$NombreScriptActualizar /tmp/comprobar/$NombreScriptActualizar >/dev/null 2>&1


if [ $? = 0 ]
then
    #esta actualizado, solo lo comprueba
    echo ""
    echo -e "${verde} El script${borra_colores} $0 ${verde}esta actualizado.${borra_colores}"
    echo ""
    chmod -R +w /tmp/comprobar
    rm -R /tmp/comprobar
    actualizado="SI"
    sleep 2
else
    #hay que actualizar, comprueba y actualiza
    echo ""
    echo -e "${amarillo} EL script${borra_colores} $0 ${amarillo}NO esta actualizado.${borra_colores}"
    echo -e "${verde} Se procede a su actualizacion automatica.${borra_colores}"
    sleep 3
    cp -r /tmp/comprobar/* $ruta_ejecucion
    chmod -R +w /tmp/comprobar
    rm -R /tmp/comprobar
    echo ""
    echo -e "${amarillo} El script se ha actualizado, es necesario cargarlo de nuevo.${borra_colores}"
    echo ""
    sleep 2
    exit
fi
}


software_necesario(){
#funcion software necesario
#para que funcione necesita:
#   conexion a internet
#   la paleta de colores
#   software: which

echo ""
echo -e "${azul} Comprobando el software necesario.${borra_colores}"
echo ""
#which git diff ping figlet xdotool wmctrl nano fzf
#########software="which git diff ping figlet nano gdebi curl konsole" #ponemos el foftware a instalar separado por espacion dentro de las comillas ( soft1 soft2 soft3 etc )
for comando in "${!requeridos[@]}"; do
        which $comando &>/dev/null
        sino=$?
        contador=1
        while [ $sino -ne 0 ]; do
            if [ $contador -ge 4 ] || [ "$conexion" = "no" ]; then
                clear
                echo ""
                echo -e " ${amarillo}NO se ha podido instalar ${rojo}${requeridos[$comando]}${amarillo}.${borra_colores}"
                echo -e " ${amarillo}Inténtelo usted con: (${borra_colores}sudo apt install ${requeridos[$comando]}${amarillo})${borra_colores}"
                echo -e ""
                echo -e " ${rojo}No se puede ejecutar el script sin el software necesario.${borra_colores}"
                echo ""; read p
                echo ""
                exit 1
            else
                echo " Instalando ${requeridos[$comando]}. Intento $contador/3."
                sudo apt install ${requeridos[$comando]} -y &>/dev/null
                let "contador=contador+1"
                which $comando &>/dev/null
                sino=$?
            fi
        done
        echo -e " [${verde}ok${borra_colores}] $comando (${requeridos[$comando]})."
    done

    echo ""
    echo -e "${azul} Todo el software ${verde}OK${borra_colores}"
    software="SI"
    sleep 2
}


conexion(){
#funcion de comprobar conexion a internet
#para que funciones necesita:
#   conexion ainternet
#   la paleta de colores
#   software: ping

if ping -c1 google.com &>/dev/null
then
    conexion="SI"
    echo ""
    echo -e " Conexion a internet = ${verde}SI${borra_colores}"
else
    conexion="NO"
    echo ""
    echo -e " Conexion a internet = ${rojo}NO${borra_colores}"
fi
}

#logica de arranque
#variables de resultado $conexion $software $actualizado
#funciones actualizar_script, conexion, software_necesario

#logica para ejecutar o no ejecutar
#comprobado conexcion
#    si=actualizar_script
#        si=software_necesario
#            si=ejecuta, poner variables a sii todo
#            no=Ya sale el solo desde la funcion
#        no=software_necesario
#            si=ejecuta, variables software="SI", conexion="SI", actualizado="No se ha podiso comprobar actualizacion de script"
#            no=Ya sale solo desde la funcion
#
#    no=software_necesario
#        si=ejecuta, variables software="SI", conexion="NO", actualizado="No se ha podiso comprobar actualizacion de script"
#        no=Ya sale solo desde la funcion

function carpeta_base(){
    echo ""
    echo -e "${amarillo} INFO:${borra_colores} La carpeta base es la que contiene tus carpetas que tienes compartidas."
    echo -e " Es necesario que indiques su ruta absoluta para poder configurar."
    echo ""
    read -p " Ingrese la ruta de la carpeta base: " base_dir

    if [ -z $base_dir ]; then
        echo ""
        echo -e "${amarillo} La ruta no puede estar vacia${borra_colores}"; sleep 3
        return
    fi

    # Convertir a ruta absoluta
    export base_dir=$(realpath -m "$base_dir")
    echo $base_dir > /tmp/base_dir


    if [ -d "$base_dir" ]; then
        echo ""
        echo -e "${verde} Carpeta${borra_colores} $base_dir ${verde}seleccionada correctamente.${borra_colores}"; sleep 3
    else
        read -p " La carpeta $base_dir NO existe, deseas crearla (s/n): " sino
        if [ "$sino" == "s" ] || [ "$sino" == "S" ]; then
            sudo mkdir -p "$base_dir"
            echo ""
            echo -e "${verde} Carpeta ${borra_colores}$base_dir ${verde}creada.${borra_colores}"; sleep 3
        else
            echo ""
            echo -e "${rojo} La ruta '$base_dir' no existe o no es un directorio, No se puede continuar.${borra_colores}"; sleep 4
            base_dir="No seleccionada"
        fi
    fi
}

clear
menu_info
conexion
if [ $conexion = "SI" ]; then
    actualizar_script
    if [ $actualizado = "SI" ]; then
        software_necesario
        if [ $software = "SI" ]; then
            export software="SI"
            export conexion="SI"
            export actualizado="SI"
            #bash $ruta_ejecucion/ #PON LA RUTA
        else
            echo ""
        fi
    else
        software_necesario
        if [ $software = "SI" ]; then
            export software="SI"
            export conexion="NO"
            export actualizado="No se ha podido comprobar la actualizacion del script"
            #bash $ruta_ejecucion/ #PON LA RUTA
        else
            echo ""
        fi
    fi
else
    software_necesario
    if [ $software = "SI" ]; then
        export software="SI"
        export conexion="NO"
        export actualizado="No se ha podido comprobar la actualizacion del script"
        #bash $ruta_ejecucion/ #PON LA RUTA
    else
        echo ""
    fi
fi

check_root
while :
do
clear
menu_info
#comprueba la carpeta base y lo muestra en el menu
if [ -f /tmp/base_dir ]; then
    base_dir=$(cat /tmp/base_dir)
else
    base_dir="$(echo -e "${amarillo} Carpeta base NO seleccionada${borra_colores}")"

fi

echo -e "${azul} --- Opciones principales ---${borra_colores}"
echo -e ""
echo -e "     1. ${azul}Gestion de usuarios de tu $(grep ^PRETTY_NAME= /etc/os-release | cut -d= -f2- | tr -d '"').${borra_colores}"
echo -e "     2. ${azul}Gestion de carpetas compartidas.${borra_colores} $base_dir"
echo -e "     3. ${azul}Gestion de permisos de las carpetas compartidas.${borra_colores} $base_dir"
echo -e "     4. ${azul}Gestion de Samba.${borra_colores} $base_dir"
echo -e "     5. ${azul}Seleccionar o modifica la carpeta base${borra_colores}"
echo -e ""
echo -e "    90. ${azul}Ayuda.${borra_colores}"
echo -e "    99. ${azul}Salir.${borra_colores}"
echo -e ""
echo -n " Seleccione una opcion del menu -> "
read opcion
case $opcion in
        1)  sudo -E bash $ruta_ejecucion/LinuxUserManager.usuarios
            ;;

        2)  #comprueba la carpeta base y lo muestra en el menu
            if [ -f /tmp/base_dir ]; then
                sudo -E bash $ruta_ejecucion/LinuxUserManager.carpetas
            else
                echo ""
                echo -e "${amarillo} Carpeta base NO seleccionada${borra_colores}"; sleep 2
            fi
            ;;

        3)  #comprueba la carpeta base y lo muestra en el menu
            if [ -f /tmp/base_dir ]; then
                sudo -E bash $ruta_ejecucion/LinuxUserManager.permisos
            else
                echo ""
                echo -e "${amarillo} Carpeta base NO seleccionada${borra_colores}"; sleep 2
            fi
            ;;

        4)  #comprueba la carpeta base y lo muestra en el menu
            if [ -f /tmp/base_dir ]; then
                sudo -E bash $ruta_ejecucion/LinuxUserManager.samba
            else
                echo ""
                echo -e "${amarillo} Carpeta base NO seleccionada${borra_colores}"; sleep 2
            fi
            ;;

        5)  carpeta_base
            ;;

        90) sudo -E bash $ruta_ejecucion/LinuxUserManager.ayuda
            ;;

        99)  ctrl_c
            ;;

        *)      #se activa cuando se introduce una opcion no controlada del menu
                echo "";
                echo -e " ${amarillo}OPCION NO DISPONIBLE EN EL MENU.${borra_colores}"; sleep 2
                ;;

esac
done

