# WSHealthCheck

A lightweight PowerShell tool for on-demand health checks on Windows Servers.

## The Problem

Windows Server administrators often need a quick way to check if a server is working as expected before investigating a specific problem.

Checking different parts of a server manually can take time and may lead to inconsistent results.

## The Solution

**WSHealthCheck** runs a small set of repeatable checks on a Windows Server and combines the results into one simple health report.

The goal is to provide a quick first-level check that can help identify conditions that need further investigation.

## Demo

The following demo shows WSHealthCheck running a health check on a Windows Server.

![WSHealthCheck Demo](assets/wshealthcheck-demo.gif)

## What It Checks

The current version checks:

* Operating system information
* Last boot time and uptime
* Free space on the `C:` drive
* Windows Event Log service
* Remote Procedure Call (RPC) service
* Overall health status

## Health Rules

| Check             | Condition            | Result    |
| ----------------- | -------------------- | --------- |
| Disk space        | 20% or more free     | `OK`      |
| Disk space        | Less than 20% free   | `WARNING` |
| Windows Event Log | Running              | `OK`      |
| Windows Event Log | Stopped              | `WARNING` |
| RPC               | Running              | `OK`      |
| RPC               | Stopped              | `WARNING` |
| Overall health    | All checks are OK    | `HEALTHY` |
| Overall health    | At least one warning | `WARNING` |

## Example Output

```text
ComputerName            : PS-SERVER
OperatingSystem         : Microsoft Windows Server 2025 Standard Evaluation
BootTime                : 15/09/2026 11:04:48
Uptime                  : 17:00:56
DiskFreeSpacePercentage : 57.60
DiskStatus              : OK
EventLog                : OK
RpcSs                   : OK
OverallStatus           : HEALTHY
```

## Environment

Developed mainly with:

* PowerShell 7
* Windows Server 2025

Also tested with:

* Windows PowerShell 5.1

The project was developed and tested in a Windows Server lab using PowerShell Remoting and CIM.

## How It Works

The script receives the target computer through the `-ComputerName` parameter.

System and disk information are collected using CIM.

Service status is checked on the target computer using PowerShell Remoting with `Invoke-Command`.

The individual check results are then used to calculate the overall health status.

## Remote Access

The health check uses CIM and PowerShell Remoting (WinRM) to collect information from the target Windows Server.

The target server must allow the required remote connections. In non-domain environments, additional authentication or WinRM configuration may be required.

## How to Run

Load the script into the current PowerShell session:

```powershell
. .\Get-WindowsServerHealth.ps1
```

Run the health check:

```powershell
Get-WindowsServerHealth -ComputerName PS-SERVER
```

The command returns a PowerShell object that can be further filtered, formatted, or exported.

## What I Practiced

This project was built as a hands-on study of PowerShell applied to Windows Server administration.

Main topics practiced:

* Advanced functions
* Parameters
* Objects and `PSCustomObject`
* PowerShell pipeline
* CIM
* PowerShell Remoting
* Conditional logic
* `TimeSpan` and date calculations
* Remote service checks
* Git and GitHub
* Version control and incremental development

## Current Limitations

This project is intentionally small.

The current version:

* checks only the `C:` drive;
* checks two core Windows services;
* runs an on-demand health check instead of continuous monitoring;
* does not provide historical data or alerts;
* does not attempt to measure the complete health of a Windows Server environment.

## Roadmap

Future improvements will remain focused on practical Windows administration and automation.

Possible improvements include:

* More Windows health checks
* Better error handling
* Improved report presentation
* Role-based checks for specific server roles
* Additional automation and reporting capabilities
