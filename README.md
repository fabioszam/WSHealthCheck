# WSHealthCheck

A lightweight PowerShell tool for on-demand health checks on Windows Servers.

## The Problem

Windows Server administrators often need a quick way to check if a server is working as expected before investigating a specific problem.

Checking different parts of a server manually can take time and may lead to inconsistent results.

## The Solution

**WSHealthCheck** runs a small set of repeatable checks on a Windows Server and combines the results into one simple health report.

The goal is to provide a quick first-level check that can help identify conditions that need further investigation.

## Demo

The demo shows two scenarios: a healthy server and a server with a warning condition.

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
BootTime                : 15/09/2026 11:06:31
Uptime                  : 22:38:11
DiskFreeSpacePercentage : 57.80
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

The script uses the `-ComputerName` parameter to define the target server.

When no computer name is provided, the script checks the local computer.

System and disk information are collected using CIM.

When checking a remote server, service status is collected using PowerShell Remoting with `Invoke-Command`.

The individual check results are then used to calculate the overall health status.

## Remote Access

When checking a remote server, WSHealthCheck uses CIM and PowerShell Remoting (WinRM).

The target server must allow the required remote connections. In non-domain environments, additional authentication or WinRM configuration may be required.

## How to Run

Load the function into the current PowerShell session:

```powershell
. .\Get-WindowsServerHealth.ps1
```

Run a local health check:

```powershell
Get-WindowsServerHealth
```

Run a health check against a remote server:

```powershell
Get-WindowsServerHealth -ComputerName PS-SERVER
```

The command returns a PowerShell object with the health check results.

## What I Practiced

This project was built as a hands-on study of PowerShell applied to Windows Server administration.

Main topics practiced:

* Advanced functions and parameters
* Comment-based help and `Get-Help`
* Objects and `PSCustomObject`
* PowerShell pipeline and object filtering
* CIM for system and disk information
* PowerShell Remoting with `Invoke-Command`
* Local and remote execution
* Error handling with `try/catch` and `-ErrorAction Stop`
* Conditional logic and health status rules
* `TimeSpan` and date calculations
* Remote service checks with `Get-Service`
* Git, GitHub, and version control
* Incremental development and release management

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
