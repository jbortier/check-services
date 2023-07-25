#Require -RunAsAdministrator
$services = "IKEEXT","PolicyAgent"

foreach ($service in Get-Service -Name $services | where-object {$_.Status -eq "Stopped"}) {
    Write-Host "The service $($service.Name) is $($service.Status) with startup type $($service.StartupType)."
    if ($service.StartupType -eq "Disabled") {
        try {
            Write-Host "Set startup type to automatic."
            Set-Service $service.Name -StartupType Automatic -ErrorAction Stop
        }
        catch {
            Write-Host -ForegroundColor Red "Cannot set the startup type for the service $($service.Name)."
            Write-Host -ForegroundColor Red $_.Exception.Message
            continue
        }
    }
    try {
        Write-Host "Starting the service $($service.Name)."
        Start-Service $service.Name -ErrorAction Stop
        Write-Host -ForegroundColor Green "The service $($service.Name) is now running."
    }
    catch {
        Write-Host -ForegroundColor Red "Cannot start the service $($service.Name)."
        Write-Host -ForegroundColor Red $_.Exception.Message
        continue
    }
}
