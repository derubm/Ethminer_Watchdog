@echo off
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
		set user = " "
		CHOICE /N /C:12345 /T 8 /D 1
		::configure your Pools here
		::type 1: geth, 2: stratum
		::for stratum you need to specify a user and worker ( see sample 5)
		IF %ERRORLEVEL% ==1 (		set type="1" 
						set runner="http://eth-eu.dwarfpool.com:80/0x762c924a469f21a446529bd8f6b07db6bde124bf/GTX1060/miner@miner.orgg" )
		IF %ERRORLEVEL% ==2 (		set type="1" 
						set runner="http://127.0.0.1:8080/GTX1060/miner@miner.org" )
		IF %ERRORLEVEL% ==3 (		set type="1" 
						set runner="http://etc-eu1.nanopool.org:18888/0xeaaecd2c2d6b27e49fa3c29f5e3d49a7f17e3ea7/1/miner@miner.org")
		IF %ERRORLEVEL% ==4 (		set type="1" 
						set runner="http://eth-eu1.nanopool.org:8888/0x762c924a469f21a446529bd8f6b07db6bde124bf/GTX1060/miner@miner.org")
		IF %ERRORLEVEL% ==5 (		set type="2" 
						set runner= "eu1.ethermine.org:4444" 
						set user="0x762c924a469f21a446529bd8f6b07db6bde124bf.Rig1" )
:: restart miner every 8 hours (28800 seconds)
		set /a restartintervall=28800
		set restartinseconds=5
		set executable=ethminer.exe
		setx GPU_FORCE_64BIT_PTR 0
		setx GPU_MAX_HEAP_SIZE 100
		setx GPU_USE_SYNC_OBJECTS 1
		setx GPU_MAX_ALLOC_PERCENT 100
		setx GPU_SINGLE_ALLOC_PERCENT 100
CLS
:start
	set /a timer=0
	echo %time% > output.log
	::start miner, pass pool to miner
	start /b "ETHMiner" mining.cmd %runner%	%user% %type%
	COLOR 0B
	timeout 25 >nul														
	COLOR 0A								
:good
		choice /C:üxr /N /T:10 /D ü >nul
		IF %ERRORLEVEL% == 2 GOTO bad
		IF %ERRORLEVEL% == 3 GOTO bad2
		set /a timer+=10
		if %timer% gtr %restartintervall% goto bad 										
		findstr /i "error exception" output.log 
	if %ERRORLEVEL% ==1 goto good
:bad
		taskkill /f /im %executable%
		echo Restarting Miner in %restartinseconds% seconds (%counter%)
		timeout %restartinseconds%
	goto start
:bad2
	taskkill /f /im %executable%
	echo Restarting Miner in %restartinseconds% seconds (%counter%)
	timeout %restartinseconds%
	CLS
	goto beginn
