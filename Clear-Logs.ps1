# Clear-Logs.ps1 - Run as Administrator before each attack

Write-Host "[+] Clearing Windows Event Logs..." -ForegroundColor Green

wevtutil cl Security
wevtutil cl System
wevtutil cl Application
wevtutil cl "Microsoft-Windows-PowerShell/Operational"
wevtutil cl "Microsoft-Windows-Sysmon/Operational"

Write-Host "[+] Clearing PowerShell Transcripts..." -ForegroundColor Yellow
Remove-Item C:\PSLogs\* -Force -ErrorAction SilentlyContinue

Write-Host "[+] Restarting Sysmon..." -ForegroundColor Cyan
Restart-Service Sysmon64 -ErrorAction SilentlyContinue

Write-Host "[+] Logs cleared. Ready for attack simulation." -ForegroundColor Green
