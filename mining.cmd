@echo off
ethminer.exe --farm-recheck 350 -U -SC 2 -SP 1 -F http://eth-eu.dwarfpool.com:80/0x762c924a469f21a446529bd8f6b07db6bde124bf 2>&1 | wtee output.log
exit
