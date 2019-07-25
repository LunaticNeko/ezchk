:: ezchk, network adapter and functionality check for Windows
:: This is the main file.

@echo off

set FILENAME= "ezchk-log.txt"

echo # ... ezchk Vital Information Diagnostics ... > %FILENAME%

echo Getting System Configuration

echo ## Hardware >> %FILENAME%

echo\>> %FILENAME%
echo ### WMIC baseboard >> %FILENAME%
wmic baseboard get manufacturer,model | find /v "" >> %FILENAME%

echo\>> %FILENAME%
echo ### WMIC CPU >> %FILENAME%
wmic cpu get manufacturer,name,datawidth,numberofcores,numberofenabledcore,threadcount | find /v "" >> %FILENAME%

echo\>> %FILENAME%
echo ### WMIC NIC >> %FILENAME%
wmic nic get adaptertype,manufacturer,name,index,macaddress | find /v "" >> %FILENAME%

echo\>> %FILENAME%
echo ### ipconfig /all >> %FILENAME%
ipconfig /all >> %FILENAME%

echo\>> %FILENAME%
echo ### netsh interface show interface >> %FILENAME%
netsh interface show interface >> %FILENAME%

echo\>> %FILENAME%
echo ### netsh wlan show interface >> %FILENAME%
netsh wlan show interface >> %FILENAME%

echo\>> %FILENAME%
echo ### POWERSHELL: Wireless Modes >> %FILENAME%
powershell.exe Get-NetAdapteradvancedproperty "Wi-Fi*" | find /I "mode" >> %FILENAME%

echo\>> %FILENAME%
echo ### POWERSHELL: Number of Meaningful Lines in etc/hosts file >> %FILENAME%
powershell.exe -Command "Get-Content $Env:WINDIR\System32\drivers\etc\hosts | Select-String -Pattern '(^(\s*#))' -NotMatch | select -exp line | measure-object -Line | Out-String | Select-String -pattern '\d' -allmatches | Foreach-Object { $_.Matches} | Foreach-Object {$_.value}" >> %FILENAME%

echo Testing Network Functions

echo\>> %FILENAME%
echo ## Network Functions >> %FILENAME%

echo\>> %FILENAME%
echo ### DNS (Default) >> %FILENAME%
nslookup example.com 2>nul >> %FILENAME%

echo\>> %FILENAME%
echo ### POWERSHELL: HTTP (True == Works) >> %FILENAME%
powershell -Command "Invoke-Webrequest http://example.com/ >$null 2>$null ; $?" >> %FILENAME%

echo\>> %FILENAME%
echo ### POWERSHELL: HTTPS (True == Works) >> %FILENAME%
powershell -Command "Invoke-Webrequest https://example.com/ >$null 2>$null ; $?" >> %FILENAME%

:: TODO: Pass 2 should find and redact MAC addresses
echo Removing Personally Identifiable Information

set "UID_FIND='(IAID|DUID|GUID)(.*: *)(.*)'"
set "UID_REPLACE='$1$2[Hidden]'"
set "MACADDR_WMICNIC_FIND='(\d+\s+)([0-9A-F]{2}):([0-9A-F]{2}):([0-9A-F]{2}):([0-9A-F]{2}):([0-9A-F]{2}):([0-9A-F]{2})'"
set "MACADDR_WMICNIC_REPLACE='$1$2:$3:$4:XX:XX:$7'"
set "MACADDR_PHYSICAL_FIND='(Physical)(.*)([0-9A-F]{2})(:|\-)([0-9A-F]{2})(:|\-)([0-9A-F]{2})(:|\-)([0-9A-F]{2})(:|\-)([0-9A-F]{2})(:|\-)([0-9A-F]{2})'"
set "MACADDR_PHYSICAL_REPLACE='$1$2$3:$5:$7:XX:XX:$13'"
set "HOSTNAME_FIND='(Host Name.*:\s*)(\S+)'"
set "HOSTNAME_REPLACE='$1[Hidden]'"

powershell -Command "(Get-Content %FILENAME%) -replace %UID_FIND%, %UID_REPLACE% -replace %MACADDR_WMICNIC_FIND%, %MACADDR_WMICNIC_REPLACE% -replace %MACADDR_PHYSICAL_FIND%, %MACADDR_PHYSICAL_REPLACE% -replace %HOSTNAME_FIND%, %HOSTNAME_REPLACE% | Out-File -encoding ascii %FILENAME%"

echo All done. Please submit %FILENAME% to your system administrator.
