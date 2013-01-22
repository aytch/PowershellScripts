# A simple script to write a Puppet Config file for a Windows server.
# In this script, we'll take all services that are currently running, and write out a Puppet configuration file that
# ensures they will stay running.
#
# Sample Output:
# 
# service { 'AdobeARMservice' :
#     ensure           => running,
#     enable           => true,
#     hasstatus        => true,
#     hasrestart       => true,
#     }
#
#
#

$myFile = "C:\scripts\localhost_services.txt"
New-Item $myFile -type file -Force
$myServices = Get-Service | Where-Object { $_.Status -eq "Running" }

#Construct Puppet Manifest
foreach ( $i in $myServices ) {
$stringA = "service { '"
$content = $i .Name
$stringB = "' :
      ensure            => running,
      enable            => true,
      hasstatus         => true,
      hasrestart        => true,
      }
"
Add-Content $myFile $stringA$content$stringB
}
