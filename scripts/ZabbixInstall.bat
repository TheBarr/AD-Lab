@echo off
if exist "C:\Program Files\Zabbix Agent 2\zabbix_agent2.exe" exit

msiexec /i "\\192.168.10.10\apki\Installers\zabbix_agent2.msi" SERVER=192.168.10.20 SERVERACTIVE=192.168.10.20 /qn