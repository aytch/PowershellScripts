function New-RemoteSession($param) {
  # NYI
  $argList = "$session = New-PSSession $param | enter-PSSession"
  Invoke-Command { start-process powershell -Wait -LoadUserProfile -ArgumentList $argList}
}

function Assert-Module {
  [CmdletBinding()]
  Param
  (
    [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
    [string[]] $ModuleName
  )

  if ( ( Get-Module -ListAvailable -Name $ModuleName ) -ne $null ) {
    Import-Module $ModuleName
    Write-Host "***    $ModuleName loaded." -ForegroundColor "Green"
  }
  else {
    Write-Host "***    $ModuleName module could not be loaded." -ForegroundColor "Cyan"
    break
  }
}

if ( ($PSVersionTable.PSVersion.MajorVersion) -ge 4) {
    Assert-Module "PSReadLine"
  }

# [REMOTE||LOCAL]: user@host

function Set-SessionWindowTitle($environment) {
# lol kinda works
  if ($environment -eq "Remote") {
    $host.UI.RawUI.WindowTitle = (Get-EnvironmentStatus) + ": $env:USERNAME@$env:COMPUTERNAME"
  }
  else {
    $host.UI.RawUI.WindowTitle = (Get-EnvironmentStatus) + ": $env:USERNAME@$env:COMPUTERNAME"
  }
}

function Get-EnvironmentStatus {
# more lol kinda works
  if ( (Get-ChildItem env:SESSIONNAME) -eq $null ) {"[REMOTE]"}
  else {"[LOCAL]"}
}

function Set-ElevatedStatus {
# works and is awesome
  $WindowsPrincipal = new-object System.Security.Principal.WindowsPrincipal(`
    [System.Security.Principal.WindowsIdentity]::GetCurrent() )
  $IsAdmin = $WindowsPrincipal.IsInRole(`
    [System.Security.Principal.WindowsBuiltInRole]::Administrator)
  if ($IsAdmin -eq $True) {
    # No action required
  }
  else {
    Start-Process powershell -Verb runas
    exit
  }
}

Set-ElevatedStatus


function prompt {
  Set-SessionWindowTitle(Get-EnvironmentStatus)
  Write-Output "PS $pwdir>"
}
