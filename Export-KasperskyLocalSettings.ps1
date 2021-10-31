$filename= hostname
& "C:\Program Files (x86)\Kaspersky Lab\Kaspersky Security for Windows Server\kavshell.exe" export C:\$filename.xml
[xml]$data=Get-Content C:\$filename.xml
$trusts= $data.'KAV-WSEE-Settings'.Settings.TrustedZone |ForEach-Object {$_.exclutionRules.element.objects.element.Path}
# by default there are 171 entries on Trusted Zone Configuration
if ( $trusts.Count -gt 171) 
    {
        New-Item -Path C:\$filename-TrustedDirs.txt
        }
        
 for ($i = 0; $i -lt $trusts.Count; $i++) {
    if ($i -ge 171) {
     Add-Content -Value  $trusts[$i] -Path C:\$filename-TrustedDirs.txt
      }
  }
  $address=$data.'KAV-WSEE-Settings'.RealTimeProtectionTasks.NetworkAttackBlocker.Task.Settings.ExcludeAddresses.element
  #if there are any exlueded addresses then add them to created file
  if ($address) {

    New-Item -Path C:\$filename-TrustedAddresses.txt

  foreach ( $item in $address) {

    Add-Content -Value $item.Address -Path C:\$filename-TrustedAddresses.txt

    }
    
  }

function Upload-FTP {
    param (
        $filename,
        $filepath
    )
# Config
  $Username = "admin"
  $Password = "LordOfTheRings2020"
  $LocalFile = "$filepath"
  $RemoteFile = "ftp://172.31.240.154/$filename.txt"
 
# Create FTP Rquest Object
  $FTPRequest = [System.Net.FtpWebRequest]::Create("$RemoteFile")
  $FTPRequest = [System.Net.FtpWebRequest]$FTPRequest
  $FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
  $FTPRequest.Credentials = new-object System.Net.NetworkCredential($Username, $Password)
  $FTPRequest.UseBinary = $true
  $FTPRequest.UsePassive = $true
# Read the File for Upload
  $FileContent = Get-Content -Encoding byte $LocalFile
  $FTPRequest.ContentLength = $FileContent.Length
# Get Stream Request by bytes
  $Run = $FTPRequest.GetRequestStream()
  $Run.Write($FileContent, 0, $FileContent.Length)
# Cleanup
  $Run.Close()
  $Run.Dispose()
    
}
#Upload TrustedDirs File
Upload-FTP -filename $filename-TrustedDirs -filepath C:\$filename-TrustedDirs.txt
#Upload TrustedAddress File
Upload-FTP -filename $filename-TrustedAddresses -filepath C:\$filename-TrustedAddresses.txt