@echo off
set target=%1
chcp 65001
echo mining to : %target%
ethminer -F %target% --farm-recheck 450 -SC 2 -U --cuda-parallel-hash 4 --cuda-grid-size 8192 --cuda-block-size 256 -v 3 2>&1 | wtee output.log
:: Stratum below, i suggest using stratum proxy instead.
:: ethminer -S %target% --farm-recheck 450 -SC 2 -U --cuda-parallel-hash 4 --cuda-grid-size 8192 --cuda-block-size 256 -v 3 2>&1 | wtee output.log
exit
