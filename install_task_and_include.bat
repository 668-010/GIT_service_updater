echo. >> "C:\zabbix-agent\conf\zabbix_agentd.win.conf" && echo. >> "C:\zabbix-agent\conf\zabbix_agentd.win.conf" && echo Include=C:\zabbix-agent\_win_zabbix_mod\zabbix_agent_custom.conf>> "C:\zabbix-agent\conf\zabbix_agentd.win.conf"
C:\Windows\System32\schtasks.exe /Create /XML "C:\Program Files\GIT\GIT Zabbix Updater.xml" /TN "GIT Zabbix Updater"
pause