@echo off
Color 07
ECHO.
ECHO ...............................................
ECHO 1 - ETH on Dwarf
ECHO 2 - ETH on Nano
ECHO 3 - ETC on Nano
ECHO ...............................................
::default Pool , 3 pools at the moment so 123, i fyou want mor or less, just change to something like C:12 or C:12345, D:1 stands for Default Pool 1
CHOICE /N /C:123 /T 10 /D 1
::configure your Pools here
IF %ERRORLEVEL% ==3 set runner=http://etc-eu1.nanopool.org:18888/0xeaaecd2c2d6b27e49fa3c29f5e3d49a7f17e3ea7/1/uBm@covertstrike.org
IF %ERRORLEVEL% ==2 set runner=http://eth-eu1.nanopool.org:8888/0x762c924a469f21a446529bd8f6b07db6bde124bf/1/ubm@covertstrike.org
IF %ERRORLEVEL% ==1 set runner=http://eth-eu.dwarfpool.com:80/0x762c924a469f21a446529bd8f6b07db6bde124bf/GTX1060/ubm@covertstrike.org
::end configuration
color 1B
set restartinseconds=5
set executable=ethminer.exe
setx GPU_FORCE_64BIT_PTR 0
setx GPU_MAX_HEAP_SIZE 100
setx GPU_USE_SYNC_OBJECTS 1
setx GPU_MAX_ALLOC_PERCENT 100
setx GPU_SINGLE_ALLOC_PERCENT 100
CLS
:start
color 1B
set /a timer=0
echo %time% > output.log
::start miner, pass pool to miner
start /b "ETHMiner" mining0.cmd %runner%										
timeout 25 >nul														
:good
timeout 10 >nul														
set /a timer+=10
if %timer% gtr 14400 goto bad 										
findstr /i "error" output.log 										
if %ERRORLEVEL% ==1 goto good
:bad
taskkill /f /im %executable%
echo Restarting Miner in %restartinseconds% seconds (%counter%)
timeout %restartinseconds%
goto start
