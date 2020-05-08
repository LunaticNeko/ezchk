:: ezchk, network adapter and functionality check for Windows
::
:: This is the main file for ezchk project
:: (C) 2019 Chawanat Nakasan. Released under MIT License.
:: See readme.md and license.md for more details.

:Main

@echo off

set FILENAME="ezchk-log.txt"

echo ezchk computer diagnosis tool, version 0.01
echo

echo # ... ezchk Vital Information Diagnostics ... > %FILENAME%

echo Getting System Configuration

echo ## Hardware >> %FILENAME%

echo\>> %FILENAME%
echo ### PS: CIM Basic Information >> %FILENAME%
powershell.exe -Command "Get-CimInstance -ClassName CIM_System | select manufacturer,model | Format-List" >> %FILENAME%
powershell.exe -Command "Get-CimInstance -ClassName Win32_BaseBoard | select manufacturer,model | Format-List" >> %FILENAME%

echo\>> %FILENAME%
echo ### PS: CIM BIOS >> %FILENAME%
powershell.exe -Command "Get-CimInstance -ClassName CIM_BIOSElement | select manufacturer,name,version | Format-List" >> %FILENAME%

echo\>> %FILENAME%
echo ### WMIC CPU >> %FILENAME%
rem wmic cpu get manufacturer,name,datawidth,numberofcores,numberofenabledcore,threadcount | find /v ""
powershell.exe -Command "Get-CimInstance -ClassName CIM_Processor | select manufacturer,name,maxclockspeed | Format-List" >> %FILENAME%

echo\>> %FILENAME%
echo ### PS: CIM Video/GPU/Graphics >> %FILENAME%
powershell.exe -Command "Get-CimInstance -ClassName CIM_VideoController | select deviceid,name,status,driverversion | Format-List" >> %FILENAME%

echo\>> %FILENAME%
echo ### PS: Adapters >> %FILENAME%
powershell.exe -Command "Get-NetAdapter | Format-List" >> %FILENAME%

echo\>> %FILENAME%
echo ### PS: Configuration >> %FILENAME%
powershell.exe -Command "Get-NetIPConfiguration -AllCompartments -Detailed | Format-List" >> %FILENAME%

echo\>> %FILENAME%
echo ### netsh interface show interface >> %FILENAME%
netsh interface show interface >> %FILENAME%

echo\>> %FILENAME%
echo ### netsh wlan show interface >> %FILENAME%
netsh wlan show interface >> %FILENAME%

echo\>> %FILENAME%
echo ### POWERSHELL: Wireless Modes >> %FILENAME%
powershell.exe -Command "Get-NetAdapterAdvancedProperty 'Wi-Fi*' | where-object {($_.DisplayName -like '*Mode*') -or ($_.DisplayName -like '*802.11*')}" >> %FILENAME%

echo\>> %FILENAME%
echo ### POWERSHELL: Number of Meaningful Lines in etc/hosts file >> %FILENAME%
powershell.exe -Command "Get-Content $Env:WINDIR\System32\drivers\etc\hosts | Select-String -Pattern '(^(\s*#))' -NotMatch | select -exp line | measure-object -Line | Out-String | Select-String -pattern '\d' -allmatches | Foreach-Object { $_.Matches} | Foreach-Object {$_.value}" >> %FILENAME%

echo\>> %FILENAME%
echo ## OS >> %FILENAME%

echo\>> %FILENAME%
echo ### POWERSHELL: OS Information >> %FILENAME%
powershell.exe -Command "get-wmiobject -class win32_operatingsystem" >> %FILENAME%

echo\>> %FILENAME%
echo ### POWERSHELL: Quick Fixes >> %FILENAME%
powershell.exe -Command "get-wmiobject -class win32_quickfixengineering | select Description, HotFixID, InstalledBy, InstalledOn | Format-Table" >> %FILENAME%

echo Testing Network Functions

echo\>> %FILENAME%
echo ## Network Functions >> %FILENAME%

echo\>> %FILENAME%
echo ### DNS (Default) >> %FILENAME%
nslookup example.com 2>nul >> %FILENAME%

set "TEST_URI_HTTP='http://example.com'"
set "TEST_URI_HTTPS='https://example.com'"

echo\>> %FILENAME%
echo ### POWERSHELL: HTTP >> %FILENAME%
call :MakeWebRequest %TEST_URI_HTTP% >> %FILENAME%

echo\>> %FILENAME%
echo ### POWERSHELL: HTTPS >> %FILENAME%
call :MakeWebRequest %TEST_URI_HTTPS% >> %FILENAME%

:: Pass 2 to find and redact MAC addresses and other PIIs
echo Removing Personally Identifiable Information

set "UID_FIND='(IAID|DUID|GUID)(.*: *)(.*)'"
set "UID_REPLACE='$1$2[Hidden]'"
set "MACADDR_WMICNIC_FIND='(\d+\s+)([0-9A-F]{2}):([0-9A-F]{2}):([0-9A-F]{2}):([0-9A-F]{2}):([0-9A-F]{2}):([0-9A-F]{2})'"
set "MACADDR_WMICNIC_REPLACE='$1$2:$3:$4:XX:XX:$7'"
set "MACADDR_PHYSICAL_FIND='(^(?!.*?BSSID).*\w+)(.*)([0-9a-fA-F]{2})(:|\-)([0-9a-fA-F]{2})(:|\-)([0-9a-fA-F]{2})(:|\-)([0-9a-fA-F]{2})(:|\-)([0-9a-fA-F]{2})(:|\-)([0-9a-fA-F]{2})'"
set "MACADDR_PHYSICAL_REPLACE='$1$2$3:$5:$7:XX:XX:$13'"
set "HOSTNAME_FIND='(Host Name.*:\s*)(\S+)'" ::TODO add Japanese support
set "HOSTNAME_REPLACE='$1[Hidden]'"
set "COMPUTERNAME_FIND='(ComputerName.*:\s*)(\S+)'"
set "COMPUTERNAME_REPLACE='$1[Hidden]'"

powershell -Command "(Get-Content %FILENAME%) -replace %UID_FIND%, %UID_REPLACE% -replace %MACADDR_WMICNIC_FIND%, %MACADDR_WMICNIC_REPLACE% -replace %MACADDR_PHYSICAL_FIND%, %MACADDR_PHYSICAL_REPLACE% -replace %HOSTNAME_FIND%, %HOSTNAME_REPLACE% -replace %COMPUTERNAME_FIND%, %COMPUTERNAME_REPLACE% | Out-File -encoding ascii %FILENAME%"

echo All done. Please submit %FILENAME% to your system administrator.

exit /B %ERRORLEVEL%

:MakeWebRequest
powershell -Command "try {Invoke-WebRequest -UseBasicParsing %~1 | Select-Object -Property StatusCode,StatusDescription | Format-List | Write-Output} catch [System.Net.WebException] {[PSCustomObject]@{Status=$_.Exception.Status;StatusCode=[Int]$_.Exception.Response.StatusCode;StatusDescription=$_.Exception.Response.StatusDescription} | Format-List | Write-Output}"
exit /B 0
