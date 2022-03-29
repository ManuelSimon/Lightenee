param ([Parameter(Mandatory)]$ip, [Parameter(Mandatory)]$token, $hours=8)
[String]$CurrentPath = (Get-Item $myinvocation.mycommand.path).Directory.Fullname
$LogFile = "$CurrentPath\lightenee.log"
$WebClient = new-object system.net.webclient
$CheapHours=$WebClient.DownloadString("https://api.preciodelaluz.org/v1/prices/cheapests?zone=PCB&n=$hours") | ConvertFrom-Json
$CurrentHour = Get-Date -Format HH
$isCheap = $false

foreach ($Hour in $CheapHours.hour){
    if ($Hour.StartsWith($CurrentHour)){ $isCheap = $true }
}

Get-Date | Tee-Object -FilePath  "$LogFile" -Append
if($isCheap) {
    miiocli chuangmiplug --ip $ip --token $token on | Tee-Object -FilePath  "$LogFile" -Append
} else {
    miiocli chuangmiplug --ip $ip --token $token off | Tee-Object -FilePath  "$LogFile" -Append
}
