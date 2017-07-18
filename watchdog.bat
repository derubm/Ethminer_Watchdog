@echo off
echo -------------------------------------------------------------------
echo Simple script to restart your miner after the word "Error" appears in the logfile
echo -------------------------------------------------------------------
echo:
set restartinseconds=3
set executable=ethminer.exe
setx GPU_FORCE_64BIT_PTR 0
setx GPU_MAX_HEAP_SIZE 100
setx GPU_USE_SYNC_OBJECTS 1
setx GPU_MAX_ALLOC_PERCENT 100
setx GPU_SINGLE_ALLOC_PERCENT 100
:start
CLS
set /a timer=0
echo %time% > output.log
::start miner
start /b "ETHMiner" mining.cmd										
timeout 25 >nul														
:good
timeout 10 >nul														
set /a timer+=10
if %timer% gtr 14400 goto bad 										
findstr /i "error" output.log 										
if errorlevel 1 goto good
:bad
taskkill /f /im %executable%
echo Restarting Miner in %restartinseconds% seconds (%counter%)
timeout %restartinseconds%
goto start
