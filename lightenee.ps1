[String]$CurrentPath = (Get-Item $myinvocation.mycommand.path).Directory.Fullname
$LogFile = "$CurrentPath\Lightenee.log"
$WebClient = new-object system.net.webclient
$CheapHours=$WebClient.DownloadString("https://api.preciodelaluz.org/v1/prices/cheapests?zone=PCB&n=8") | ConvertFrom-Json
$CurrentHour = Get-Date -Format HH
$isCheap = $false

foreach ($Hour in $CheapHours.hour){
    if ($Hour.StartsWith($CurrentHour)){ $isCheap = $true }
}

Get-Date | Tee-Object -FilePath  "$LogFile" -Append
if($isCheap) {
    miiocli chuangmiplug --ip  --token  on | Tee-Object -FilePath  "$LogFile" -Append
} else {
    miiocli chuangmiplug --ip  --token  off | Tee-Object -FilePath  "$LogFile" -Append
}
