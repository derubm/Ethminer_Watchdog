@echo off
set target=%1
echo mining to : %target%
ethminer --farm-recheck 350 -SC 2 -U -F %target% --cuda-parallel-hash 4 --cuda-grid-size 8192 --cuda-block-size 128 -v 9 --cl-global-work 8192 2>&1 | wtee output.log
exit
