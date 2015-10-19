<#
json:
[
  {
    "Name": "Your Collection Name Here",
    "Members": [
      "Member1", "Member2"
    ]
  },
  {
    "Name": "Your other Collection Name",
    "Members": [
      "OtherMember1",
      "OtherMember2"
    ]
  }
]
#>

function Initialize-PSManagedCollection {
  param(
    [Parameter(
      Position = 0,
      ValueFromPipeline = $True)
    ]
    $CollectionName
  )
  if ((Get-CMDeviceCollection -Name $CollectionName) -eq $null) {
    Write-Output "Adding New PS Managed Collection: $CollectionName"
    New-CMDeviceCollection -Name $CollectionName @DeviceCollectionArgs
  }
  Get-CMDeviceCollection -Name $CollectionName
}

function Set-PSManagedCollectionMembership {
  param(
    [Parameter(
      Position = 0)
    ]
    $Collection,
    [Parameter(
        Position = 1)
    ]
    $Device
  )

  $CMDevice = Get-CMDevice -Name $Device

  if ($CMDevice -ne $null) {
    $MembershipRule = @{
      'CollectionName' = $Collection;
      'ResourceID' = $CMDevice.ResourceID
    }
  }
  else {
    Write-Warning "    Missing: $DeviceName"
  }

  if ((Get-CMDeviceCollectionDirectMembershipRule @MembershipRule) -eq $null) {
    Write-Output "     Adding: $($CMDevice.Name) as $($CMDevice.ResourceID)"
    Add-CMDeviceCollectionDirectMembershipRule @MembershipRule
  }
  else { Write-Output "     Exists: $($CMDevice.Name)" }
}

<#

$jsonpath = "C:\PSManaged\collections.json""

$jsonimport = $jsonpath | Get-Content | Out-String | ConvertFrom-Json

#>

Import-module (
  $Env:SMS_ADMIN_UI_PATH.Substring(
    0,$Env:SMS_ADMIN_UI_PATH.Length-5) + '\ConfigurationManager.psd1')

$SiteCode = Get-PSDrive -PSProvider CMSITE
Set-location $SiteCode":"

$Schedule = New-CMSchedule -RecurInterval Days -RecurCount 7

$FolderPath = $SiteCode.Name + ":\DeviceCollection\PS_Managed"

$DeviceCollectionArgs = @{
  'LimitingCollectionName' = $LimitingCollection;
  'RefreshSchedule' = $Schedule;
  'RefreshType' = 'ConstantUpdate'
}

ForEach ($collection in $jsonimport) {

  $FBManagedCollection = $Collection.Name | Initialize-PSManagedCollection
  Write-Output "`nUsing PS Managed Collection:`n"
  Write-Output $PSManagedCollection.Name

  ForEach ($Device in $Collection.Members) {
    Set-PSManagedCollectionMembership $PSManagedCollection.Name $Device
  }

  $PSManagedCollections = @{
    'FolderPath' = $FolderPath;
    'InputObject' = $PSManagedCollection;
    'Confirm' = $false
  }

  Move-CMObject @PSManagedCollections
}
