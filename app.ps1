$EventLogSource = "App"
Write-Host "Starting app"
New-EventLog -LogName Application -Source $EventLogSource

while($true)
{
    $Message = "APPLICATION LOG - $(Get-Date)"
    Write-Host "Emitting message $Message to log file and event logs"
    Add-Content -Path "C:\logs\app.log" -Value $Message
    Write-EventLog -LogName "Application" -Source $EventLogSource -Message $Message -EventId 999

    Start-Sleep 1
}
