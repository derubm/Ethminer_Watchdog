@echo off
Color 0A
ECHO.
ECHO ...............................................
ECHO 1 - ETH on Dwarfpool
ECHO 2 - ETH on Nanopool
ECHO 3 - ETC on Nanopool
ECHO ...............................................
::default Pool
CHOICE /N /C:123 /T 3 /D 1
::configure your Pools here
IF %ERRORLEVEL% ==3 set runner=http://etc-eu1.nanopool.org:18888/0xeaaecd2c2d6b27e49fa3c29f5e3d49a7f17e3ea7/1/dwarf@miner.com
IF %ERRORLEVEL% ==2 set runner=http://eth-eu1.nanopool.org:8888/0x762c924a469f21a446529bd8f6b07db6bde124bf/1/dwarf@miner.com
IF %ERRORLEVEL% ==1 set runner=http://eth-eu.dwarfpool.com:80/0x762c924a469f21a446529bd8f6b07db6bde124bf/GTX1060/dwarf@miner.com

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
choice /C:üx /N /T:10 /D ü >nul
IF %ERRORLEVEL% == 2 GOTO bad
set /a timer+=10
if %timer% gtr 14400 goto bad 										
findstr /i "error" output.log 										
if %ERRORLEVEL% ==1 goto good
:bad
taskkill /f /im %executable%
echo Restarting Miner in %restartinseconds% seconds (%counter%)
timeout %restartinseconds%
goto start
