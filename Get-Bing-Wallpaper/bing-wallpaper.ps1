#
# Get Bing Wallpaper
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
if(!(Test-Path .\jsons)) {
  mkdir jsons
}
cd .\jsons

#get json
$url = "http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=10"

$data = Invoke-WebRequest $url
$data.Content | Out-File .\bing.json
$decode = ConvertFrom-Json($data)

#get jpg
cd .\..\today

$range = 1..8
$count = $range.Count

for($i=0; $i -lt $count; $i++) {
  $temp = $decode.images.Get($i)
  $urlsplit = -Join("http://www.bing.com",$temp.url)
  echo $urlsplit
  $filename = ($temp.hsh + ".jpg")
  Invoke-WebRequest $urlsplit -OutFile $filename
}

#delete jsons dir
if(Test-Path .\..\jsons) {
  Remove-Item -Recurse ".\..\jsons\*"
}

echo ok!
exit
