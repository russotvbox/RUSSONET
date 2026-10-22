#!/bin/bash
# Instalador automático para ADM-Lite / RUSSONET

echo "Iniciando instalación del script..."

# 1. Crear directorios principales
mkdir -p /etc/adm-lite

# 2. Descargar el paquete comprimido del repositorio
cd /tmp
curl -sL "https://raw.githubusercontent.com/russotvbox/RUSSONET/main/adm-lite-backup.tar.gz" -o adm-lite-backup.tar.gz

# 3. Descomprimir en el sistema
tar -zxvf adm-lite-backup.tar.gz -C /
rm -f /tmp/adm-lite-backup.tar.gz

# 4. Asignar permisos de ejecución
chmod +x /etc/adm-lite/*
chmod +x /usr/bin/menu
chmod +x /usr/bin/adm

echo "¡Instalación completada con éxito!"
echo "Escribe 'menu' o 'adm' para ejecutar el panel."
