
# Some special characters must be escaped, like `$
$command = "if ( [string]::IsNullOrEmpty((ipconfig /all | Select-String -Pattern '  IPv6 Address' | out-string)) -eq `$False) { (ipconfig /all | Select-String -Pattern '  IPv6 Address' | out-string).replace(' :', '^').split('^')[1].Trim().Replace('(Preferred)', '')}"

$bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
$encodedCommand = [Convert]::ToBase64String($bytes)
$encodedCommand

# Execution from a CMD window or batch script.
powershell.exe -NoProfile -OutputFormat Text -EncodedCommand $encodedCommand

# Decode a Base64-encoded string
$decodedCommand = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($encodedCommand));
