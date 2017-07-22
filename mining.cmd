@echo off
set target=%1
chcp 65001
echo mining to : %target%
ethminer --farm-recheck 450 -SC 2 -U -F %target% --cuda-parallel-hash 4 --cuda-grid-size 8192 --cuda-block-size 256 -v 3 2>&1 | wtee output.log
exit
