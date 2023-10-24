# varijable unutar kojih se stavlja ID kamere i mikrofona
$cameraDeviceId = 0 #pr.pronalazi se sa pr. Get-Process WebCam
$microphoneDeviceId = 1

# funkcija koja sluzi za provjeru ako se pojavio neki od eventa, pr. kamere ili mikrofona
function CheckProcessAccess($deviceId, $deviceName) {
    $processes = Get-CimInstance -Namespace "Root\CIMv2" -ClassName Win32_PnPEntity | Where-Object { $_.PNPClass -eq "Image" -and $_.DeviceID -like "*$deviceId*" } #trazi instancu iz sistemske klase koja zadovoljava dane uvjete
    if ($processes) {
        Write-Host "$deviceName is being accessed by the following processes:"
        $processes | ForEach-Object {
            Write-Host ("  " + $_.Caption)
        }
        # open source gui za upravljanje sistemom dok je app u run modeu
	Add-Type -AssemblyName System.Windows.Forms

	# naslov i tekst poruke
	$title = "Alert"
	$message = "Camera or microphone started!"

	# pop up poruka
	[System.Windows.Forms.MessageBox]::Show($message, $title, [System.Windows.Forms.MessageBoxButtons]::OK, 	[System.Windows.Forms.MessageBoxIcon]::Information)
    }
}

# petlja koja konstantno provjera aktivnost kamere ili mikrofona, postavljena na sleep 5 sekundi / svakih 5 s
while ($true) {
    CheckProcessAccess $cameraDeviceId "Camera"
    CheckProcessAccess $microphoneDeviceId "Microphone"
    Start-Sleep -Seconds 5  
}