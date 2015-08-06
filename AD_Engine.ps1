Import-Module -Name ActiveDirectory

function Get-AllUser {
    try {
    Get-ADUser -Filter * -Properties employeeid,employeenumber,mail
    return
    }
    catch [Exception]{
    start-sleep -m 10
    Get-AllUsers
    }
}

function Get-ActiveLiveUser {
    $input | Where { ( $_.Enabled -eq $True ) -and ( $_.employeeid -ne $null ) }
}

function Get-ActiveUser {
    $input | Where { ( $_.Enabled) -eq $True ) }
}

function Get-DisabledUser {
    $input | Where { ( $_.Enabled -eq "False" ) }
}

function Get-ContosoUser {
    $input | Where { $_.mail -like "*contoso.com" }
    }

function Get-ServiceAccount {
    $input | Where { ( $_.EmployeeNumber -contains "999999*" ) }
    }

function Get-UserInActiveOU {
    $input | Where { ( $_.DistinguishedName -notcontains "*Disabled Users*" ) }
    }

$allusers = Get-AllUser

# Contoso's Dynamically Static Distribution List
$allusers | Get-ActiveLiveUser | Get-ContosoUser | Add-DistributionGroupMember -Identity "Group Name" -WhatIf
$allusers | Get-DisabledUser | Get-ContosoUser | Remove-DistributionGroupMember -Identity "Group Name" -WhatIf

# Disabled Users in Active OUs
$allusers | Get-DisabledUser | Get-UserInActiveOU | Move-ADObject -TargetPath "OU=Disabled Users,DC=Contoso,DC=com"

