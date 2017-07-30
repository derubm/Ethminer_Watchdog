echo off
CLS
set target= %1
set user = %2
set type = %3
echo [1;31m mining to : %target% as type %type% [1;36m
:: http type
if %type% == "1" ethminer -F %target% --farm-recheck 250 -SC 2 -U --cuda-parallel-hash 4 --cuda-grid-size 8192 --cuda-block-size 256 -v 1 2>&1 | wtee output.log
:: Stratum type, i suggest using stratum proxy instead.
if %type% == "2" ethminer -S %target% -O %user% --farm-recheck 250 -SC 2 -U --cuda-parallel-hash 4 --cuda-grid-size 8192 --cuda-block-size 256 -v 1 2>&1 | wtee output.log
exit