@echo off
echo -------------------------------------------------------------------
echo Simple script to restart your miner after the word "Error" appears in the logfile
echo -------------------------------------------------------------------
echo:
set restartinseconds=3
set /a counter=0
timeout 3
setx GPU_FORCE_64BIT_PTR 0
setx GPU_MAX_HEAP_SIZE 100
setx GPU_USE_SYNC_OBJECTS 1
setx GPU_MAX_ALLOC_PERCENT 100
setx GPU_SINGLE_ALLOC_PERCENT 100
:start
echo time() > output.log
start "ETHMiner" mining.cmd
timeout 25 >nul
:good
timeout 10 >nul
findstr "Error" output.log 
if errorlevel 1 goto good
taskkill /f /im %executable%
echo Restarted %a% times. - 
echo Restarting Miner in %restartinseconds% seconds (%counter%)
timeout %restartinseconds%
set /a counter+=1
echo:
echo:
goto start
