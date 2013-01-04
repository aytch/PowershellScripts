Import-Module SMLets

param($IncidentArg)

#Sanitize our variables from previous runs
$IncidentID = $null
$continue = $null
$IncidentSupportGroup = $null
$IncidentUrgency = $null
$IncidentStatus = $null
$IncidentComment = $null

#Get Incident ID
$IncidentID = "IR"
$IncidentID += $IncidentArg
$myIncident = Get-SCSMIncident -ID $IncidentID

#Paginate the Output for Description
$myIncident.Description | Format-Table -Wrap | Out-Host -Paging

#Decide whether to continue modifying ticket or not
$continue = read-host "Would you like to update this Ticket (Y/n)?"

#Define some sweet values for our arrays.
$SupportGroupValues = "Black","Grey","Advisory","Red","Green","Blue"
$UrgencyValues = "Low","Medium","High"
$StatusValues = "Active","Updated","Pending","On Hold","Resolved","Closed"

#Get some information about the ticket
switch ( $continue ) {
	Y  { $IncidentSupportGroup = read-host "Assign to which Team? ["$SupportGroupValues"]"
        $IncidentUrgency = read-host "Assign Urgency? ["$UrgencyValues"]"
        $IncidentStatus = read-host "Change Status? ["$StatusValues"]"
		$IncidentComment = "`""
        $IncidentComment += read-host "Comment?"
		$IncidentComment += "`""
		}
	DEFAULT {exit}
	}
	
#Define our base argument	
$SCSMArgument = @{"ID" = $IncidentID}

#Build arguments that we will pass to the Set-SCSMIncident command
if ( $IncidentSupportGroup -ine "" ) { $SCSMArgument += @{"SupportGroup" = $IncidentSupportGroup } }
if ( $IncidentUrgency -ine "" ) { $SCSMArgument += @{"Urgency" = $IncidentUrgency } }
if ( $IncidentStatus -ine "" ) { $SCSMArgument += @{"Status" = $IncidentStatus } }
if ( $IncidentComment -ine "" ) {$SCSMArgument += @{"Comment" = $IncidentComment } }
else 
	{ exit }

# Get Confirmation# set the colors you want
[console]::ForegroundColor = "yellow"
#[console]::BackgroundColor= "black"
$continue = read-host "Set-SCSMIncident" @SCSMArgument "to be written. Continue? (Y/n)" 
[console]::ResetColor()

# VARIABLE! Y U NO PASS?!
switch ( $continue ) {
		Y { Set-SCSMIncident @SCSMArgument
		}
	DEFAULT {exit}
	}
Write-Host -ForegroundColor Green -BackgroundColor Black "AWWWWWW YEAHHHHHH"
	