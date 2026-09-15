function Get-WindowsServerHealth {
    [CmdletBinding()]
    param (
        # Mandatory: the target server must always be specified.
        [Parameter(Mandatory = $true)]
        [string]$ComputerName
    )

    # Query the target operating system through CIM.
    $OperatingSystem = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $ComputerName
    
    # Calculate uptime by subtracting the last boot time from the current date.
    # The result is a TimeSpan, which allows numeric comparisons later.
    $Uptime = (Get-Date) - $OperatingSystem.LastBootUpTime

    # Query the C: drive on the target computer and calculate the percentage of free space remaining.
    $Disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" -ComputerName $ComputerName
    $FreeSpacePercentage = ($Disk.FreeSpace / $Disk.Size) * 100
    $DiskStatus = if ($FreeSpacePercentage -ge 20) {"OK"} else {"WARNING"}

    # Build a custom object so the output can be piped, formatted or exported.
    $ReturnedObject = [PSCustomObject]@{
        ComputerName = $ComputerName
        OperatingSystem = $OperatingSystem.Caption
        BootTime = $OperatingSystem.LastBootUpTime
        Uptime = $Uptime
        DiskFreeSpacePercentage = $FreeSpacePercentage
        DiskStatus = $DiskStatus
    }

    return $ReturnedObject
}