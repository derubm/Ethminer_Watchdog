@echo off
cls
chcp 65001
:beginn
		Color 0A
		ECHO.
		ECHO ...............................................
		ECHO 1 - ETH on Dwarfpool
		ECHO 2 - ETH on Local Proxy
		ECHO 3 - ETC on Nanopool
		ECHO 4 - ETH on Nanopool
		ECHO 5 - ETH stratum Ethermine
		ECHO ...............................................
::default Pool
		set /a timetaken=0
		set user = " "
::set Default (Autostart) Pool here ( /D [1-5] )		
		CHOICE /N /C:12345 /T 8 /D 1
		::configure your Pools here
		::type 1: geth, 2: stratum
		::for stratum you need to specify a adress and worker ( see sample 5)
		IF %ERRORLEVEL% ==1 (		set type="1" 
						set runner="http://eth-eu.dwarfpool.com:80/0x762c924a469f21a446529bd8f6b07db6bde124bf/GTX1060/yourmail@adress.com" )
		IF %ERRORLEVEL% ==2 (		set type="1" 
						set runner="http://127.0.0.1:8080/GTX1060/yourmail@adress.com" )
		IF %ERRORLEVEL% ==3 (		set type="1" 
						set runner="http://etc-eu1.nanopool.org:18888/0xeaaecd2c2d6b27e49fa3c29f5e3d49a7f17e3ea7/1/yourmail@adress.com")
		IF %ERRORLEVEL% ==4 (		set type="1" 
						set runner="http://eth-eu1.nanopool.org:8888/0x762c924a469f21a446529bd8f6b07db6bde124bf/GTX1060/yourmail@adress.com")
		IF %ERRORLEVEL% ==5 (		set type="2" 
						set runner= "eu1.ethermine.org:4444" 
						set user="0x762c924a469f21a446529bd8f6b07db6bde124bf.Miner1" )
:: restart miner every 8 hours (28800 seconds)
		set /a restartintervall=28800
		set restartinseconds=5
		set /a badconnection=0
		
		setx GPU_FORCE_64BIT_PTR 0
		setx GPU_MAX_HEAP_SIZE 100
		setx GPU_USE_SYNC_OBJECTS 1
		setx GPU_MAX_ALLOC_PERCENT 100
		setx GPU_SINGLE_ALLOC_PERCENT 100
CLS
	set /a %NUM%=0
:start
	set /a hour=0
	set /a minute=0
	set /a timer=0
	set /a status=0
	set /a hour=0
	set hours =""
	echo %time% > output.log
	::start miner, pass pool to miner
	start /b "ETHMiner" mining.cmd %runner%	%user% %type%
	COLOR 0B
	timeout 25 >nul														
:good
		choice /C:üxr /N /T:10 /D ü >nul
		IF %ERRORLEVEL% == 2 GOTO bad
		IF %ERRORLEVEL% == 3 GOTO bad2
		set /a timer+=10
		set /a status+=10
		if %status% lss 60 goto cont
		set /a minute+=1
		if %minute% lss 60 goto cont2
			set /a hour+=1
			set /a minute=0
:cont2		
:: shows stats ~ every minute	
		for /F %%N in ('find /C "accepted" ^< "output.log"') do set "NUM=%%N"
		set /a timetaken+=1
		if not %hour% == 0 set hours=%hour% Hours
:cont3		
		echo [1;33m I:  %time% :      [1;32m***%NUM% Shares found ***[1;33m   (%hours% %minute% minutes.)*** [1;36m 
		set /a status = 0
:cont		
		if %timer% gtr %restartintervall% goto bad 
::check if we are still connected in logfile	
		findstr /i "could not connect" output.log
		if %ERRORLEVEL% == 1 goto checkmore
		set badconnection +=1
:: after 10 fails restart miner and go to pool #1
		if badconnection gtr 10 goto bad2
:checkmore	
::check if there are "error" or "exception" messages in the logfile									
		findstr /i "error exception" output.log 
		if %ERRORLEVEL% ==1 goto good
:bad
		taskkill /f /im %executable%
		echo Restarting Miner in %restartinseconds% seconds (%counter%)
		timeout %restartinseconds%
	goto start
:bad2
	taskkill /f /im %executable%
	set /a badconnection = 0
	echo Restarting Miner in %restartinseconds% seconds (%counter%)
	timeout %restartinseconds%
	CLS
	goto beginn
