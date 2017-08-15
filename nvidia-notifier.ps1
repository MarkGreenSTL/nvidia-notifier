# This script needs BurntToast: https://www.powershellgallery.com/packages/BurntToast/0.6.0
# Install via: Install-Module -Name BurntToast

$r = Invoke-WebRequest -Uri 'https://www.nvidia.com/Download/processFind.aspx?psid=101&pfid=816&osid=57&lid=1&whql=1&lang=en-us&ctk=0' -Method GET

$latestVersion = $r.parsedhtml.GetElementsByClassName("gridItem")[2].innerText

$installedVersion = (Get-WmiObject Win32_PnPSignedDriver | Where-Object {$_.devicename -like "*nvidia*" -and $_.devicename -notlike "*audio*"}).DriverVersion.SubString(7).Remove(1,1).Insert(3,".")

if ($latestVersion -ne $installedVersion) {
    
    $url = "http://de.download.nvidia.com/Windows/$latestVersion/$latestVersion-desktop-win10-64bit-international-whql.exe"

    $title = New-BTText -Content "Update available"
    $description = New-BTText -Content "New graphics driver $latestVersion available."
    $image = New-BTImage -Source "C:\Users\markh\Desktop\nvidia-notifier\logo.png" -AppLogoOverride
    $binding = New-BTBinding -Children $title, $description -AppLogoOverride $image
    $visual = New-BTVisual -BindingGeneric $binding
    $content = New-BTContent -Visual $visual -ActivationType Protocol -Launch $url

    Submit-BTNotification -Content $content -UniqueIdentifier 'nvidia-notifier' -AppId "NVIDIA Notifier"
}
