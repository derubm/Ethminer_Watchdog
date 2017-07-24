@echo off
:beginn
Color 0A
ECHO.
ECHO ...............................................
ECHO 1 - ETH on Dwarfpool
ECHO 2 - ETH on Local Ethereum Proxy
ECHO 3 - ETC on Nanopool
ECHO ...............................................
::default Pool
CHOICE /N /C:123 /T 3 /D 1
::configure your Pools here
IF %ERRORLEVEL% ==3 set runner=http://etc-eu1.nanopool.org:18888/0xeaaecd2c2d6b27e49fa3c29f5e3d49a7f17e3ea7/1/miner@coin.org
IF %ERRORLEVEL% ==2 set runner="http://127.0.0.1:8080/GTX1060/miner@coin.org"
IF %ERRORLEVEL% ==1 set runner=http://eth-eu.dwarfpool.com:80/0x762c924a469f21a446529bd8f6b07db6bde124bf/GTX1060/miner@coin.org
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
start /b "ETHMiner" mining.cmd %runner%		
COLOR 09								
timeout 25 >nul														
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
