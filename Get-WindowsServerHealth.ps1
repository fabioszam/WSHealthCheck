function Get-WindowsServerHealth {
    <#
.SYNOPSIS
Performs an on-demand health check on a Windows Server.

.DESCRIPTION
Collects system information, uptime, disk space, and critical service status
from the target Windows Server.

.PARAMETER ComputerName
Specifies the target Windows Server. Defaults to the local computer.

.EXAMPLE
Get-WindowsServerHealth -ComputerName PS-SERVER

Runs the health check against PS-SERVER and returns the results as a PowerShell object.

.EXAMPLE
Get-WindowsServerHealth

Runs the health check against the local computer.
#>

    [CmdletBinding()]
    param (
        [string]$ComputerName = $env:COMPUTERNAME
    )

    try {

        $IsLocal = $ComputerName -in @('.', 'localhost', $env:COMPUTERNAME)
        if ($IsLocal) {
            $OperatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
            $Disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" -ErrorAction Stop
            $Services = Get-Service -Name RpcSs, EventLog -ErrorAction Stop
        }
        else {
            $OperatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $ComputerName -ErrorAction Stop
            $Disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" -ComputerName $ComputerName -ErrorAction Stop
            $Services = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                Get-Service -Name RpcSs, EventLog
            } -ErrorAction Stop
        }

        $Uptime = (Get-Date) - $OperatingSystem.LastBootUpTime

        $FreeSpacePercentage = ($Disk.FreeSpace / $Disk.Size) * 100
        $DiskStatus = if ($FreeSpacePercentage -ge 20) { 'OK' } else { 'WARNING' }

        $ServiceEventLog = $Services.Where({ $_.Name -eq 'EventLog' })
        $ServiceRpcSs = $Services.Where({ $_.Name -eq 'RpcSs' })

        $EventLogStatus = if ($ServiceEventLog.Status -eq 'Running') { 'OK' } else { 'WARNING' }
        $RpcSsStatus = if ($ServiceRpcSs.Status -eq 'Running') { 'OK' } else { 'WARNING' }

        $OverallStatus = if ($DiskStatus -eq 'WARNING' -or
            $EventLogStatus -eq 'WARNING' -or
            $RpcSsStatus -eq 'WARNING') {
            'WARNING'
        }
        else {
            'HEALTHY'
        }

        $ReturnedObject = [PSCustomObject]@{
            ComputerName            = $ComputerName
            OperatingSystem         = $OperatingSystem.Caption
            BootTime                = $OperatingSystem.LastBootUpTime
            Uptime                  = $Uptime
            DiskFreeSpacePercentage = $FreeSpacePercentage
            DiskStatus              = $DiskStatus
            EventLog                = $EventLogStatus
            RpcSs                   = $RpcSsStatus
            OverallStatus           = $OverallStatus
        }

        return $ReturnedObject

    }
    catch {
        Write-Error "Health check failed for '$ComputerName': $($_.Exception.Message)"
    }
}
