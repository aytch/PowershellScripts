function Watch-FunctionUsage($param) {

  function Assert-Custom_PowershellLog {
    $LogPresent = [System.Diagnostics.EventLog]::SourceExists("Custom_Powershell")
    if ($LogPresent -eq $False) {
      New-EventLog -LogName "Application" -Source "Custom_Powershell"
    }
  }

  function Write-FileLog($param) {
    $LogPath = "$param.log"
    $Date = Get-Date -UFormat "%Y-%m-%d"
    $InvokingComputer = $ENV:COMPUTERNAME
    $Payload = "$Date,$InvokingComputer,$param"
    $ArgSplat = @{
      'FilePath' = $LogPath;
      'Encoding' = 'ascii';
      'Append' = $True;
    }
    if (Test-Path -Path $LogPath) {
      $Payload | Out-File @ArgSplat
    }
    else {
      New-Item -Path $LogPath -ItemType "file"
      $Payload | Out-File @ArgSplat
    }
  }

  $CurrentEAP = $ErrorActionPreference
  $ErrorActionPreference = "SilentlyContinue"
  if ($PSVersionTable.PSVersion.Major -ge 3) {
    Assert-Custom_PowershellLog
    $LogEvent = @{
      'LogName' = 'Application';
      'Source' = 'Custom_Powershell';
      'EntryType' = 'Information';
      'Message' = "$param"
      'EventID' = 1337
    }
  Write-EventLog @LogEvent
  }
  else {
    Write-FileLog($param)
  }
  $ErrorActionPreference = $CurrentEAP
}
