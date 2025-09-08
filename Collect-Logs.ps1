# Collect-Logs.ps1 — Run AFTER attack simulation (as Administrator)

param(
    [string]$OutputBasePath = "C:\AttackLogs"
)

# Create base folder if not exists
if (-not (Test-Path $OutputBasePath)) {
    New-Item -ItemType Directory -Path $OutputBasePath -Force | Out-Null
}

# Create timestamped subfolder
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$OutputFolder = Join-Path $OutputBasePath $timestamp
New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null

Write-Host "[+] Exporting logs to: $OutputFolder" -ForegroundColor Green

# Define logs to export
$logs = @(
    @{ Name = "Security";     Path = "Security" },
    @{ Name = "System";       Path = "System" },
    @{ Name = "Application";  Path = "Application" },
    @{ Name = "PowerShell";   Path = "Microsoft-Windows-PowerShell/Operational" },
    @{ Name = "Sysmon";       Path = "Microsoft-Windows-Sysmon/Operational" }
)

# Export each log to .evtx
foreach ($log in $logs) {
    $outputFile = Join-Path $OutputFolder "$($log.Name).evtx"
    try {
        wevtutil epl $log.Path $outputFile
        Write-Host "  → Exported $($log.Name) log" -ForegroundColor Cyan
    } catch {
        Write-Host "  → Failed to export $($log.Name): $_" -ForegroundColor Red
    }
}

# Copy PowerShell Transcripts (if enabled)
$transcriptSource = "C:\PSLogs\"
if (Test-Path $transcriptSource) {
    $transcriptDest = Join-Path $OutputFolder "PS_Transcripts"
    Copy-Item "$transcriptSource\*" -Destination $transcriptDest -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "  → Copied PowerShell transcripts" -ForegroundColor Cyan
}

# Optional: Create ZIP archive
$zipPath = "$OutputFolder.zip"
Compress-Archive -Path "$OutputFolder\*" -DestinationPath $zipPath -Force
Write-Host "`n[✓] Logs exported and archived to: $zipPath" -ForegroundColor Green

Write-Host "`n[💡] Tip: Use Chainsaw, EVTX Explorer, or Event Viewer to analyze .evtx files." -ForegroundColor Yellow
