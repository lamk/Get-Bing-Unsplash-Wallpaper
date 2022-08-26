#
# Get Unsplash Wallpaper
#

$x = Split-Path -Parent $MyInvocation.MyCommand.Definition
cd $x
if(!(Test-Path .\images)) {
  mkdir images
}
if(!(Test-Path .\today)) {
  mkdir today
}

#backup img
if(Test-Path .\today\*.jpg) {
  Move-Item -Force .\today\*.jpg .\images
  #delete
  #Remove-Item -Recurse ".\today\*.jpg"
}

#change dir
cd today
if(!(Test-Path .\jsons)) {
  mkdir jsons
}
cd jsons

#get json

#sign up for a free developer account on https://unsplash.com/developers to get API access
#create an application in the portal and copy the Access Key value to unsplash-access.txt
$access_key = Get-Content .\..\..\unsplash-access.txt

$baseUrl = "https://api.unsplash.com/photos/random"
$collections = "437035,8362253,220381,11649432,58118635"
$orientation = "landscape"
$count = 9

$url = $baseUrl + "?client_id=" + $access_key + "&collections=" + $collections + "&orientation=" + $orientation + "&count=" + $count

$data = Invoke-WebRequest $url
$data.Content | Out-File .\unsplash.json
$decode = ConvertFrom-Json($data)

# https://www.xnview.com/en/nconvert/#downloads
$cmd = "C:\App\NConvert\nconvert.exe"

#get jpg
cd ..
for($i=0; $i -lt $count; $i++) {
  $temp = $decode.Get($i)
  $urlsplit = $temp.urls.full
  echo $urlsplit
  $filename = ($temp.id + ".jpg")
  Invoke-WebRequest $urlsplit -OutFile $filename
  & $cmd -overwrite -ratio -resize 1920 0 $filename
}

#delete jsons dir
if(Test-Path .\jsons) {
  Remove-Item -Recurse ".\jsons\*"
}

echo ok!
exit
