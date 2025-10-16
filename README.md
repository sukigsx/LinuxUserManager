# Nombre del Script: Linux User Manager

## Descripción General
Este script en **Bash** es una herramienta interactiva para gestionar usuarios, carpetas compartidas, permisos y configuración de **Samba** en sistemas Linux.

## Funcionalidad Principal
- **Nombre:** Linux User Manager  
- **Propósito:** Configurar y administrar usuarios, directorios compartidos, permisos de acceso y Samba para compartir archivos en red.

## Requisitos y Verificaciones
- **Ejecutado como root:** Verifica si se tienen privilegios administrativos. Si no, solicita autenticación mediante `sudo`.
- **Comprobación de conexión a internet:** Necesaria para actualizaciones y la instalación de software requerido.
- **Verificación e instalación de software necesario:** Comprueba que herramientas como `git`, `diff`, `curl`, etc., estén instaladas. Si no están, las instala automáticamente.
- **Actualización automática del script desde GitHub:** Si hay una versión más reciente en el repositorio, la descarga y reemplaza el script actual.

## Gestión de Carpeta Base
- Solicita al usuario una ruta para la carpeta base que contendrá los recursos compartidos.
- Si no existe la ruta, permite crearla automáticamente.
- Almacena esta ruta temporalmente para uso posterior en el script.

## Interfaz de Menú Interactivo
Muestra un menú desde donde el usuario puede:

1. Administrar usuarios del sistema.  
2. Gestionar carpetas compartidas.  
3. Asignar permisos a las carpetas compartidas.  
4. Configurar Samba para compartir archivos.  
5. Seleccionar o cambiar la carpeta base.  
90. Ver ayuda.  
99. Salir del script.

## Limpieza y Salida
- Al presionar `Ctrl+C` o elegir la opción de salir, elimina archivos temporales y muestra un mensaje de despedida.

## Resumen
Este script está diseñado para facilitar tareas comunes de administración de usuarios y compartición de archivos en redes locales.  
Es especialmente útil en entornos educativos, pequeñas oficinas o para usuarios que deseen automatizar configuraciones de red local.

## Instalacion 
Clonar el repositorio y ejecutar LinuxUserManager.sh

```  
git clone https://github.com/sukigsx/LinuxUserManager.git
```

Tambien puedes utilizar mi script (ejecutar_scripts).

```  
git clone https://github.com/sukigsx/ejecutar_scripts.git  
```
