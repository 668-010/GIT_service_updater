echo off
:: GIT Zabbix shell for Mods Updater 
:: Для батников запускаемых с высокими привилегиями, перед выполнением любых действий обязателен переход на папку с файлом или выполняемым пакетом

:: С помощью текстового браузера lynx смотрим версию win_shell в нашем интернет-репозитории и записываем в файл
cd "C:\Program Files\GIT\lynx"
"C:\Program Files\GIT\lynx\lynx.exe" -source https://raw.githubusercontent.com/668-010/win_shell/master/version.txt > "C:\Program Files\GIT\tmp\shell_version.txt"

:: Переходим в папку куда записали версию и сравниваем с имеющейся версией в системе.
cd "C:\Program Files\GIT\tmp"
fc /W "C:\Program Files\GIT\tmp\shell_version.txt" "C:\zabbix-agent\_win_zabbix_mod\shell\version.txt" > nul

:: Если содержимое файлов отличается то переход на выполнение shell_update
if errorlevel 1 goto shell_update
goto no_update
	
:shell_update
	echo shell update
	
:: Переход в папку tmp и удаляем старый архив.
	cd "C:\Program Files\GIT\tmp\"
	del /f /q "C:\Program Files\GIT\tmp\win_shell.zip"

:: Переход в папку с пакетом WGET и с помощью него с параметрами игнорирования сертификата HTTPS скачиваем новый архив в папку tmp	
	cd "C:\Program Files\GIT\wget\bin"
	"C:\Program Files\GIT\wget\bin\wget.exe" --no-check-certificate -c https://github.com/668-010/win_shell/archive/master.zip -O "C:\Program Files\GIT\tmp\win_shell.zip"

:: Останавливаем службу Zabbix агент и делаем маленький таймаут с помощью пинга		
	net stop "Zabbix Agent"
	ping -n 6 127.0.0.1 > nul

:: Переход в папку с пакетом архиватора 7z и извлечение скачанного архива в папку C:\zabbix-agent	
	cd "C:\Program Files\GIT\zip"
	"C:\Program Files\GIT\zip\7z.exe" x "C:\Program Files\GIT\tmp\win_shell.zip" -o"C:\zabbix-agent\"

:: Переход в папку заббикс-агента, таймаут/
	cd "C:\zabbix-agent"
	ping -n 3 127.0.0.1 > nul
	
:: Переход в папку Супер-Киллера и шлепаем все запущенные shell процессы
	cd "C:\Program Files\SuperKiller\"
	"C:\Program Files\SuperKiller\superkiller.exe" apcaccess
	"C:\Program Files\SuperKiller\superkiller.exe" arcconf
	"C:\Program Files\SuperKiller\superkiller.exe" driverUpdate
	"C:\Program Files\SuperKiller\superkiller.exe" perl.bat
	"C:\Program Files\SuperKiller\superkiller.exe" perl
	"C:\Program Files\SuperKiller\superkiller.exe" regpnp
	"C:\Program Files\SuperKiller\superkiller.exe" rstcli
	"C:\Program Files\SuperKiller\superkiller.exe" smartctl
	"C:\Program Files\SuperKiller\superkiller.exe" smartctl64

:: Копируем содержимое извлчеченного архива в папку с заббикс шелом, с параметрами: скрытые, без подтверждения, с каталогами и т.п.	
	xcopy "C:\zabbix-agent\win_shell-master" "C:\zabbix-agent\_win_zabbix_mod\shell" /H /Y /C /R /S

:: Таймаут и запуск службы Заббикс агент
	ping -n 6 127.0.0.1 > nul
	net start "Zabbix Agent"
			
:: Пишем в лог что обновились заббикс шеллы
	cd "C:\Program Files\GIT\log"
	echo ============================================ >> "C:\Program Files\GIT\log\log.txt"
	echo "Zabbix Shells modules updated a new version  (%date%   %time%)" >> "C:\Program Files\GIT\log\log.txt"
	echo ============================================ >> "C:\Program Files\GIT\log\log.txt"
	
:: Удаляем папку ранее извлеченного архива
	rmdir /s /q "C:\zabbix-agent\win_shell-master"
	
	goto exit

:: Иначе если файлы версий совпадают то пишем в лог что нет обновления	
:no_update
	echo no shell updates
	cd "C:\Program Files\GIT\log"
	echo ============================================ >> "C:\Program Files\GIT\log\log.txt"
	echo "For Zabbix shells new updates not found  (%date%   %time%)" >> "C:\Program Files\GIT\log\log.txt"
	echo ============================================ >> "C:\Program Files\GIT\log\log.txt"

:exit
cd ..
:: Выход
pause