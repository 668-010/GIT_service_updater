echo on
cd "C:\Program Files\GIT\lynx"
"C:\Program Files\GIT\lynx\lynx.exe" -source https://raw.githubusercontent.com/668-010/_win_zabbix_mod/master/version.txt > "C:\Program Files\GIT\tmp\newversion.txt"
cd "C:\Program Files\GIT\tmp"
fc /W "C:\Program Files\GIT\tmp\newversion.txt" "C:\Program Files\GIT\tmp\oldversion.txt" > nul

	if errorlevel 1 (
	
		cd "C:\Program Files\GIT\tmp"
			copy "C:\Program Files\GIT\tmp\newversion.txt" "C:\Program Files\GIT\tmp\oldversion.txt"

			del /f /q "C:\Program Files\GIT\tmp\master.zip"

		cd "C:\Program Files\GIT\wget\bin"
			"C:\Program Files\GIT\wget\bin\wget.exe" --no-check-certificate -c https://github.com/668-010/_win_zabbix_mod/archive/master.zip -O "C:\Program Files\GIT\tmp\master.zip"

		cd "C:\Program Files\GIT\log"
		echo ============================================ >> "C:\Program Files\GIT\log\log.txt"
		echo "Updates Downloaded (%date%    %time%)" >> "C:\Program Files\GIT\log\log.txt"

			net stop "Zabbix Agent"
			ping -n 6 127.0.0.1 > nul

		cd "C:\Program Files\GIT\log"
		echo "Zabbix agent stopped (%date%    %time%)" >> "C:\Program Files\GIT\log\log.txt"
			
		cd "C:\zabbix-agent\"
			rmdir /s /q "C:\zabbix-agent\_win_zabbix_mod\"

		cd "C:\Program Files\GIT\zip"
			"C:\Program Files\GIT\zip\7z.exe" x "C:\Program Files\GIT\tmp\master.zip" -o"C:\zabbix-agent\"
		
		cd "C:\Program Files\GIT\log"
		echo "Updates UnZipped (%date%    %time%)" >> "C:\Program Files\GIT\log\log.txt"
		
		cd "C:\zabbix-agent"
			ping -n 3 127.0.0.1 > nul
			rename "C:\zabbix-agent\_win_zabbix_mod-master" _win_zabbix_mod
			ping -n 6 127.0.0.1 > nul
			net start "Zabbix Agent"
		cd "C:\Program Files\GIT\log"
		echo "Zabbix agent started (%date%    %time%)" >> "C:\Program Files\GIT\log\log.txt"
) else (
cd "C:\Program Files\GIT\log"
echo ============================================ >> "C:\Program Files\GIT\log\log.txt"
echo "Zabbix modules not updated (%date%    %time%)" >> "C:\Program Files\GIT\log\log.txt"
echo ============================================ >> "C:\Program Files\GIT\log\log.txt"
exit
)
cd "C:\Program Files\GIT\log"
echo "Zabbix modules updated a new version  (%date%   %time%)" >> "C:\Program Files\GIT\log\log.txt"
echo ============================================ >> "C:\Program Files\GIT\log\log.txt"
exit