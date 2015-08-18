# reference

function Assert-ValidWindowsServer {
  [regex] $os_notwindows = '(?i)^.*(RHEL|Ubuntu|Mac|Samba).*$'
  [regex] $os_noclient = '(?i)^.*(Embedded|Vista|XP).*$'
  [regex] $os_dontcare = '(?i)^(Windows 7|Windows 8).*'
  [regex] $ou_excluded = '(?i)^.*OU=(Citrix|ESX).*'
  $os_ignorelist = @($os_notwindows,$os_noclient,$os_dontcare)
  $ou_ignorelist = @($ou_excluded)
  $input | Where-Object { 
    ($_.OperatingSystem -notmatch $os_ignorelist) -and
    ($_.DistinguishedName -notmatch $ou_ignorelist) -and
    ($_.Enabled -eq $True)
  }
}

$SearchArgument = @{
       'Filter' = '*'
   'SearchBase' = 'OU=ContosoCorp,DC=contoso,dc=com';
   'Properties' = 'OperatingSystem';
  'SearchScope' = 'Subtree'
}

$windowsservers = Get-ADComputer @SearchArgument | Assert-ValidWindowsServer
