#!/usr/bin/env bash

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
paqueteria="No detectada"

# VARIABLE QUE RECOJEN LAS RUTAS
ruta_ejecucion=$(dirname "$(readlink -f "$0")") #es la ruta de ejecucion del script sin la / al final
ruta_escritorio=$(xdg-user-dir DESKTOP) #es la ruta de tu escritorio sin la / al final

# VARIABLES PARA LA ACTUALIZAION CON GITHUB
NombreScriptActualizar="LinuxUserManager.sh" #contiene el nombre del script para poder actualizar desde github
DireccionGithub="https://github.com/sukigsx/LinuxUserManager" #contiene la direccion de github para actualizar el script
nombre_carpeta_repositorio="LinuxUserManager" #poner el nombre de la carpeta cuando se clona el repo para poder eliminarla

#VARIABLES DE SOFTWARE NECESARIO
# Asociamos comandos con el paquete que los contiene [comando a comprobar]="paquete a instalar"
    declare -A requeridos
    requeridos=(
        [git]="git"
        [nano]="nano"
        [diff]="diff"
        [sudo]="sudo"
        [ping]="ping"
        [curl]="curl"
        [grep]="grep"
        [jq]="jq"
        [sed]="sed"
        [getfacl]="acl"
        [awk]="gawk"
        [realpath]="coreutils"
        #[smbclient]="smbclient"
        #[cifs-utils]="cifs-utils"
        [samba-tool]="samba"
        #samba smbclient cifs-utils samba-common
    )


#colores
rojo="\e[0;31m\033[1m" #rojo
verde="\e[;32m\033[1m"
azul="\e[0;34m\033[1m"
amarillo="\e[0;33m\033[1m"
rosa="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
borra_colores="\033[0m\e[0m" #borra colores

#toma el control al pulsar control + c
trap ctrl_c INT
function ctrl_c()
{
clear
echo ""
echo -e "${azul} GRACIAS POR UTILIZAR MI SCRIPT${borra_colores}"
echo ""
sleep 1
exit
}

menu_info(){
# muestra el menu de sukigsx
echo ""
echo -e "${rosa}            _    _                  ${azul}   Nombre del script${borra_colores} $NombreScript"
echo -e "${rosa}  ___ _   _| | _(_) __ _ _____  __  ${azul}   Descripcion${borra_colores} $DescripcionDelScript"
echo -e "${rosa} / __| | | | |/ / |/ _\ / __\ \/ /  ${azul}   Version            =${borra_colores} $version"
echo -e "${rosa} \__ \ |_| |   <| | (_| \__ \>  <   ${azul}   Conexion Internet  =${borra_colores} $conexion"
echo -e "${rosa} |___/\__,_|_|\_\_|\__, |___/_/\_\  ${azul}   Software necesario =${borra_colores} $software"
echo -e "${rosa}                  |___/             ${azul}   Actualizado        =${borra_colores} $actualizado"
echo -e "${rosa}                                    ${azul}   Sistema paqueteria =${borra_colores} $paqueteria"
echo -e ""
echo -e "${azul} Contacto:${borra_colores} ( Correo${rosa} $Correo${borra_colores} ) ( Web${rosa} $Web${borra_colores} )${borra_colores}"
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
        echo -e "${verde} El script se ha actualizado.${amarillo} Es necesario cargarlo de nuevo.${borra_colores}"
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
paqueteria
echo ""
echo -e "${azul} Comprobando el software necesario.${borra_colores}"
echo ""
#which git diff ping figlet xdotool wmctrl nano fzf
#########software="which git diff ping figlet nano gdebi curl konsole" #ponemos el foftware a instalar separado por espacion dentro de las comillas ( soft1 soft2 soft3 etc )
for comando in "${!requeridos[@]}"; do
        command -v $comando &>/dev/null
        sino=$?
        contador=1
        while [ $sino -ne 0 ]; do
            if [ $contador -ge 4 ] || [ "$conexion" = "no" ]; then
                clear
                menu_info
                echo -e " ${amarillo}NO se puede ejecutar el script sin los paquetes necesarios ${rojo}${requeridos[$comando]}${amarillo}.${borra_colores}"
                echo -e " ${amarillo}NO se ha podido instalar ${rojo}${requeridos[$comando]}${amarillo}.${borra_colores}"
                echo -e " ${amarillo}Inténtelo usted con: (${borra_colores}$instalar${requeridos[$comando]}${amarillo})${borra_colores}"
                echo -e ""
                echo -e "${azul} Listado de los paquetes necesarios para poder ejecutar el script:${borra_colores}"
                for elemento in "${requeridos[@]}"; do
                    echo -e "     $elemento"
                done
                echo ""
                echo -e " ${rojo}No se puede ejecutar el script sin todo el software necesario.${borra_colores}"
                echo ""
                exit 1
            else
                echo -e "${amarillo} Se necesita instalar ${borra_colores}$comando${amarillo} para la ejecucion del script${borra_colores}"
                ### check_root
                echo " Instalando ${requeridos[$comando]}. Intento $contador/3."
                $instalar ${requeridos[$comando]} #&>/dev/null
                let "contador=contador+1"
                command -v $comando &>/dev/null
                sino=$?
            fi
        done
        echo -e " [${verde}ok${borra_colores}] $comando (${requeridos[$comando]})."
    done

    echo ""
    echo -e "${azul} Todo el software ${verde}OK${borra_colores}"
    software="SI"
    sleep 2; read p
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

# Función que comprueba si se ejecuta como root
check_root() {
    #clear
    #menu_info
  if [ "$EUID" -ne 0 ]; then
    #echo ""
    #echo -e "${amarillo} Se necesita privilegios de root ingresa la contraseña.${borra_colores}"

    # Pedir contraseña para sudo
    #echo -e ""

    # Validar contraseña mediante sudo -v (verifica sin ejecutar comando)
    if sudo -v; then
      echo ""
      echo -e "${verde} Autenticación correcta. Ejecutando como root...${borra_colores}"; sleep 2
      # Reejecuta el script como root
      #exec sudo "$0" "$@"
    else
      clear
      menu_info
      echo -e "${rojo} Contraseña incorrecta o acceso denegado. Saliendo del script.${borra_colores}"
      echo ""
      echo -e "${azul} Listado de los paquetes necesarios para poder ejecutar el script:${borra_colores}"
      for elemento in "${requeridos[@]}"; do
        echo -e "     $elemento"
      done
      echo ""
      echo -e "${azul} GRACIAS POR UTILIZAR MI SCRIPT${borra_colores}"
     echo ""; exit
    fi
  fi
}

#funcion de detectar sistema de paquetado para instalar
paqueteria(){
echo -e "${azul} Detectando sistema de paquetería...${borra_colores}"
echo ""

if command -v apt >/dev/null 2>&1; then
    echo -e "${verde} Sistema de paquetería detectado: APT (Debian, Ubuntu, Mint, etc.)${borra_colores}"
    instalar="sudo apt install -y "
    paqueteria="apt"

elif command -v dnf >/dev/null 2>&1; then
    echo -e "${cerde} Sistema de paquetería detectado: DNF (Fedora, RHEL, Rocky, AlmaLinux)${borra_colores}"
    instalar="sudo dnf install -y "
    paqueteria="dnf"

elif command -v yum >/dev/null 2>&1; then
    echo -e "${verde}Sistema de paquetería detectado: YUM (CentOS, RHEL antiguos)${borra_colores}"
    instalar="sudo yum install -y "
    paqueteria="yum"

elif command -v pacman >/dev/null 2>&1; then
    echo -e "${verde} Sistema de paquetería detectado: Pacman (Arch Linux, Manjaro)${borra_colores}"
    instalar="sudo pacman -S --noconfirm "
    paqueteria="pacman"

elif command -v zypper >/dev/null 2>&1; then
    echo -e "${verde} Sistema de paquetería detectado: Zypper (openSUSE)${borra_colores}"
    instalar="sudo zypper install -y "
    paqueteria="zypper"

elif command -v apk >/dev/null 2>&1; then
    echo -e "${verde}Sistema de paquetería detectado: APK (Alpine Linux)${borra_colores}"
    instalar="sudo apk add --no-interactive "
    paqueteria="apk"

elif command -v emerge >/dev/null 2>&1; then
    echo -e "${verde}Sistema de paquetería detectado: Portage (Gentoo)${borra_colores}"
    instalar="sudo emerge -av "
    paqueteria="emerge"

else
    echo -e "${amarillo} No se pudo detectar un sistema de paquetería conocido.${borra_colores}"
    paqueteria="${rojo}Desconocido${borra_colores}"
fi
sleep 2
}


#comprobar si se ejecuta en una terminal bash
terminal_bash() {

    shell_actual="$(ps -p $$ -o comm=)"

    if [ "$shell_actual" != "bash" ]; then
        echo -e "${amarillo} Este script ${rojo}NO${amarillo} se está ejecutando en Bash.${borra_colores}"
        echo -e "   Shell detectado: ${rojo}$shell_actual${borra_colores}"
        echo -e "   Puede ocasionar problemas ya que solo está pensado para bash."
        echo -e "   ${rojo}No${borra_colores} se procede con la instalación ni la ejecución."
        echo ""
        echo -e "${azul} GRACIAS POR UTILIZAR MI SCRIPT${borra_colores}"
        echo ""
        exit 1
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

clear
menu_info
conexion
if [ $conexion = "SI" ]; then
    actualizar_script
    if [ $actualizado = "SI" ]; then
        terminal_bash
        software_necesario
        if [ "$software" = "SI" ]; then
            export software="SI"
            export conexion="SI"
            export actualizado="SI"
            #bash $ruta_ejecucion/ #PON LA RUTA
        else
            echo ""
        fi
    else
        terminal_bash
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

clear
menu_info





# Función que comprueba si se ejecuta como root
check_root() {
# Comprobar si se ejecuta como root
echo ""
echo -e "${amarillo} Este script necesita permisos de administrador.${borra_colores}"
echo ""
echo -e "${azul} Comprobando permisos sudo${borra_colores}"
echo ""
if [[ $EUID -ne 0 ]]; then
    # Comprobar que sudo existe
    if ! command -v sudo &>/dev/null; then
        echo -e "${rojo}Error: sudo no está instalado.${borra_colores}"
        exit 1
    fi

    exec sudo bash "$0" "$@"
fi

echo -e "${verde} Ejecutando como root.${borra_colores}"
sleep 2

}

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

