echo off
:: GIT Zabbix Mod Updater 
:: Для батников запускаемых с высокими привилегиями, перед выполнением любых действий обязателен переход на папку с файлом или выполняемым пакетом.
:: С помощью текстового браузера lynx смотрим версию zabbix_mod в нашем интернет-репозитории и записываем в файл.
cd "C:\Program Files\GIT\lynx"
"C:\Program Files\GIT\lynx\lynx.exe" -source https://raw.githubusercontent.com/668-010/_win_zabbix_mod/master/version.txt > "C:\Program Files\GIT\tmp\mods_version.txt"

:: Переходим в папку куда записали версию и сравниваем с имеющейся версией в системе.
cd "C:\Program Files\GIT\tmp"
fc /W "C:\Program Files\GIT\tmp\mods_version.txt" "C:\zabbix-agent\_win_zabbix_mod\version.txt" > nul

:: Если содержимое файлов отличается (значение 1) то переход на выполнение команд в скобках
if errorlevel 1 goto mod_update
goto no_update

:mod_update
	
:: Переход в папку tmp и удаляем старый архив.
	cd "C:\Program Files\GIT\tmp\"
	del /f /q "C:\Program Files\GIT\tmp\win_mods.zip"
		
:: Переход в папку с пакетом WGET и с помощью него с параметрами игнорирования сертификата HTTPS скачиваем новый архив в папку tmp		
	cd "C:\Program Files\GIT\wget\bin"
	"C:\Program Files\GIT\wget\bin\wget.exe" --no-check-certificate -c https://github.com/668-010/_win_zabbix_mod/archive/master.zip -O "C:\Program Files\GIT\tmp\win_mods.zip"

:: Останавливаем службу Zabbix агент и делаем маленький таймаут с помощью пинга		
	net stop "Zabbix Agent"
	ping -n 6 127.0.0.1 > nul
			
:: Переход в папку с пакетом архиватора 7z и извлечение скачанного архива в папку C:\zabbix-agent
	cd "C:\Program Files\GIT\zip"
	"C:\Program Files\GIT\zip\7z.exe" x "C:\Program Files\GIT\tmp\win_mods.zip" -o"C:\zabbix-agent\"
		
:: Переход в папку заббикс-агента, таймаут, и копируем содержимое извлчеченного архива в папку с заббикс модами, с параметрами (скрытые, без подтверждения, с каталогами и т.п.)		
	cd "C:\zabbix-agent"
	ping -n 3 127.0.0.1 > nul
	xcopy "C:\zabbix-agent\_win_zabbix_mod-master" "C:\zabbix-agent\_win_zabbix_mod" /H /Y /C /R /S /I

:: Таймаут и запуск службы Заббикс агент
	ping -n 6 127.0.0.1 > nul
	net start "Zabbix Agent"

:: Пишем в лог что обновились заббикс модули
	cd "C:\Program Files\GIT\log"
	echo ============================================ >> "C:\Program Files\GIT\log\log.txt"
	echo "Zabbix modules updated a new version  (%date%   %time%)" >> "C:\Program Files\GIT\log\log.txt"
	echo ============================================ >> "C:\Program Files\GIT\log\log.txt"

:: Удаляем папку ранее извлеченного архива
	rmdir /s /q "C:\zabbix-agent\_win_zabbix_mod-master"
	
	goto shell_update

:: Иначе (если файлы версий совпадают то пишем в лог что нет обновления)		
:no_update
	
	cd "C:\Program Files\GIT\log"
	echo ============================================ >> "C:\Program Files\GIT\log\log.txt"
	echo "Zabbix modules not updated (%date%    %time%)" >> "C:\Program Files\GIT\log\log.txt"
	echo ============================================ >> "C:\Program Files\GIT\log\log.txt"
	exit
	
:shell_update
	:: Переход в папку с пакетами GIT и запускаем Shell Updater с ожиданием его окончания, для проверки обновлений компонентов заббикс модулей
	cd "C:\Program Files\GIT\"
	call "C:\Program Files\GIT\git_shell.bat"