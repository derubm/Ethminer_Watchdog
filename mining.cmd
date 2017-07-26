echo off
set target= %1
set user = %2
set type = %3
chcp 65001
echo mining to : %target% as type %type%
if %type% == "1" ethminer -F %target% --farm-recheck 450 -SC 2 -U --cuda-parallel-hash 4 --cuda-grid-size 8192 --cuda-block-size 256 -v 3 2>&1 | wtee output.log
:: Stratum below, i suggest using stratum proxy instead.
if %type% == "2" ethminer -S %target% -O %user% --farm-recheck 450 -SC 2 -U --cuda-parallel-hash 4 --cuda-grid-size 8192 --cuda-block-size 256 -v 3 2>&1 | wtee output.log
exit
