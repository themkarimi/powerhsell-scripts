param(
	[string]$url
	);
$Res=Invoke-RestMethod -Uri $url
$State=$Res.state
$Role=$Res.role
$Version=$Res.server_version
If ( $State -eq "running" )
{
    $StateCode = 1

   }

   else {
   $StateCode = 0

   }

If ( $Role -eq "master" )
{
    $RoleCode = 1

   }

   else {

   $RoleCode = 0

   }


Write-Host "
<?xml version='1.0' encoding='UTF-8' ?>
<prtg>"

Write-Host

            "<result>"
            "<channel>IsRunning?</channel>"
            "<value>$StateCode</value>"
            "</result>"
			
            "<result>"
            "<channel>IsMaster?</channel>"
            "<value>$RoleCode</value>"
            "</result>"
            
            "<result>"
            "<channel>Version</channel>"
            "<value>$Version</value>"
            "</result>"
Write-Host "</prtg>"
