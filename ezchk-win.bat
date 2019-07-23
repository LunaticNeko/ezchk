:: ezchk, network adapter and functionality check for Windows
:: This is the main file.

@echo off

set FILENAME= "ezchk-log.txt"

echo # ... ezchk Vital Information Diagnostics ... > %FILENAME%

echo ## Hardware >> %FILENAME%

echo: >> %FILENAME%
echo ### WMIC baseboard >> %FILENAME%
wmic baseboard get manufacturer,model | find /v "" >> %FILENAME%

echo: >> %FILENAME%
echo ### WMIC CPU >> %FILENAME%
wmic cpu get manufacturer,name,datawidth,numberofcores,numberofenabledcore,threadcount | find /v "" >> %FILENAME%

echo: >> %FILENAME%
echo ### WMIC NIC >> %FILENAME%
wmic nic get adaptertype,manufacturer,name,index,macaddress | find /v "" >> %FILENAME%

echo: >> %FILENAME%
echo ### ipconfig /all >> %FILENAME%
ipconfig /all >> %FILENAME%

echo: >> %FILENAME%
echo ### netsh interface show interface >> %FILENAME%
netsh interface show interface >> %FILENAME%

echo: >> %FILENAME%
echo ### netsh wlan show interface >> %FILENAME%
netsh wlan show interface >> %FILENAME%

echo: >> %FILENAME%
echo ### POWERSHELL: Wireless Modes >> %FILENAME%
powershell.exe Get-NetAdapteradvancedproperty "Wi-Fi*" | find /I "mode" >> %FILENAME%

echo: >> %FILENAME%
echo ## Network Functions >> %FILENAME%

echo: >> %FILENAME%
echo ### DNS >> %FILENAME%
nslookup example.com 2>nul >> %FILENAME%

echo: >> %FILENAME%
echo ### HTTP (True == Works) >> %FILENAME%
powershell -Command "Invoke-Webrequest http://example.com/ >$null 2>$null ; $?"

echo: >> %FILENAME%
echo ### HTTPS (True == Works) >> %FILENAME%
powershell -Command "Invoke-Webrequest https://example.com/ >$null 2>$null ; $?"

:: TODO: Pass 2 should find and redact MAC addresses
