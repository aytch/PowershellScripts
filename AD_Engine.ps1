Import-Module ActiveDirectory

function Get-AllUsers {
    try {
    Get-ADUser -Filter * -Properties employeeid,employeenumber,mail
    return
    }
    catch [Exception]{
    start-sleep -m 10
    Get-AllUsers
    }
}

function Get-ActiveLiveUsers {
    $input | Where { ( $_.Enabled -eq $True ) -and ( $_.employeeid -ne $null ) }
}

function Get-ActiveUsers {
    $input | Where { ( $_.Enabled) -eq $True ) }
}

function Get-DisabledUsers {
    $input | Where { ( $_.Enabled -eq "False" ) }
}

function Get-ContosoUsers {
    $input | Where { $_.mail -like "*contoso.com" }
    }

function Get-ServiceAccounts {
    $input | Where { ( $_.EmployeeNumber -contains "999999*" ) }
    }

function Get-UsersInActiveOUs {
    $input | Where { ( $_.DistinguishedName -notcontains "*Disabled Users*" ) }
    }

$allusers = Get-AllUsers

# Contoso's Dynamically Static Distribution List
$allusers | Get-ActiveLiveUsers | Get-ContosoUsers | Add-DistributionGroupMember -Identity "Group Name" -WhatIf
$allusers | Get-DisabledUsers | Get-ContosoUsers | Remove-DistributionGroupMember -Identity "Group Name" -WhatIf

# Disabled Users in Active OUs
$allusers | Get-DisabledUsers | Get-UsersInActiveOUs | Move-ADObject -TargetPath "OU=Disabled Users,DC=Contoso,DC=com"

