Import-Module SMLets

param($beginRange,$endRange)

#variables!
$range = $beginRange..$endRange
$total = $endRange - $beginRange
$total = $total + 1
$continue = Read-Host "Starting at $beginRange, ending at $endRange. $total tickets will be resolved. Continue? (Y/n)?"
	
#Close the range	
switch ( $continue ) {
	Y  { 	foreach ($i in $range) {
	$IncidentId = "IR"
	$IncidentId = $IncidentId+=$i
	Set-SCSMIncident -ID $IncidentId -Status Resolved
	Write-Host "Resolving $IncidentId"
	}
		}
	DEFAULT { Exit }
	}