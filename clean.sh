#!/bin/bash

# Verificar acceso Root
if [ "$EUID" -ne 0 ]; then
  echo -e "\e[1;31m[-] Este script debe ejecutarse como root (sudo -i).\e[0m"
  exit 1
fi

clear
echo -e "\e[1;96m====================================================\e[0m"
echo -e "\e[1;93m    INICIANDO LIMPIEZA PROFUNDA Y NUEVA INSTALACIÓN \e[0m"
echo -e "\e[1;96m====================================================\e[0m"

# 1. Detener y deshabilitar todos los servicios activos
echo -e "\e[1;33m[*] Deteniendo y deshabilitando servicios...\e[0m"
systemctl stop dropbear stunnel4 v2ray ws_proxy.service badvpn.service 2>/dev/null
systemctl disable dropbear stunnel4 v2ray ws_proxy.service badvpn.service 2>/dev/null

# 2. Borrar todos los usuarios creados previamente (excepto los del sistema por defecto)
echo -e "\e[1;33m[*] Eliminando usuarios creados anteriormente...\e[0m"
for u in $(awk -F: '$3 >= 1000 && $1 != "nobody" && $1 != "ubuntu" && $1 != "opc" {print $1}' /etc/passwd); do
  userdel -r "$u" 2>/dev/null
done

# 3. Eliminar binarios, configuraciones, registros y archivos de control de Russo Netfree
echo -e "\e[1;33m[*] Eliminando rastros, binarios y archivos de configuración...\e[0m"
rm -f /usr/bin/menu
rm -rf /etc/russo*
rm -rf /etc/stunnel
rm -rf /usr/local/etc/v2ray
rm -f /usr/local/bin/ws_proxy.py
rm -f /usr/local/bin/badvpn-udpgw
rm -f /etc/systemd/system/badvpn.service
rm -f /etc/systemd/system/ws_proxy.service

# 4. Quitar el auto-inicio del bashrc
echo -e "\e[1;33m[*] Limpiando auto-inicio del sistema...\e[0m"
sed -i '/^menu$/d' /root/.bashrc

# 5. Purgar paquetes de red y limpiar dependencias
echo -e "\e[1;33m[*] Purgando paquetes y limpiando dependencias...\e[0m"
apt-get purge -y dropbear stunnel4 v2ray 2>/dev/null
apt-get autoremove -y && apt-get clean

echo -e "\n\e[1;92m[+] ¡Limpieza profunda completada! La VPS está 100% en blanco, sin usuarios ni rastros previos.\e[0m"
