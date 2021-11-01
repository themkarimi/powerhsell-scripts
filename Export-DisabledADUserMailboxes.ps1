Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;
$ADUsers=Get-ADUser -Filter * -Property Enabled,Mail -SearchBase "PATH To Your OU" | Where-Object {$_.Enabled -like “false”} 

$ExportedMailboxes=@{}
$c=0
foreach ($Aduser in $ADUsers )
{
if($Aduser.Mail)
    {

        New-MailboxExportRequest -Mailbox $Aduser.SamAccountName -FilePath "\\your unc path\$aduser.pst"
        $c=$c+1
        $ExportedMailBoxes.add($c,$aduser.SamAccountName)
         }
  }
  $Answer="y"
 While($Answer -eq "y")
 {
 Write-Host "Do you want to check export progress?(y,n)"
 $Answer= Read-Host "Answer?"
  foreach ( $item in $ExportedMailboxes.Values )
    { 
    [bool]$flag=$false
    $State= (Get-MailboxExportRequest -Mailbox $item).Status
        if ($State -eq "Completed")
        {
            Write-host "Export of $item is $State"
           $flag=$true
            }
            else
            {
            $flag=$false
            
         }
      }
        
    if ($flag -eq $true)
        {
        foreach ( $MBX in $ExportedMailboxes.Values )
    { 
    Disable-Mailbox -Identity $MBX
    }
}
 }