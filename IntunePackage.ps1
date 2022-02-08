$dest = "c:\temp\"
$PackageUrl = "https://api.github.com/repos/noyard/intunepackages/contents/Packages"
$response = Invoke-WebRequest -Uri $PackageUrl -Method Get 

$Token = 'MyUserName:MyPAT'
$Base64Token = [System.Convert]::ToBase64String([char[]]$Token)

$Headers = @{
    "Authorization" = 'Basic {0}' -f $Base64Token;
    "accept" = "application/vnd.github.v3+json"
    }

$Uri = "https://api.github.com/repos/{owner}/{repo}/zipball"
$response = Invoke-WebRequest -Headers $Headers -Uri $Uri -Method Get 





# check for at .net 4.7.2 at the minimum
# https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed
If ((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release -ge 461808)
	{
	".Net framework version is good"
	}Else{
	"Upgrade .Net Framework"
	}

# download Microsoft Win32 Content Prep Tool
if (!(Test-path "$($dest)Microsoft-Win32-Content-Prep-Tool-master\IntuneWinAppUtil.exe"))
	{
	# URL and Destination
	$url = "https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/archive/refs/heads/master.zip"

	# Create temp destination for the zip and get zipfile name from source URL
	$zipFile = $dest  + $(Split-Path -Path $Url -Leaf)

	# Download file
	Start-BitsTransfer -Source $url -Destination $dest 

	# Create instance of COM Object
	$objShell = New-Object -ComObject Shell.Application

	# Extract the Files
	$extractedFiles = $ObjShell.NameSpace($zipFile).Items()

	# Copy the extracted files to the destination folder
	$ObjShell.NameSpace($dest).CopyHere($extractedFiles)

	# Remove file
	Remove-item $zipfile
	}

#Module AzureADPreview
if (Get-Module -ListAvailable -Name AzureADPreview) {
    Write-Host "AzureADPreview Module exists"
} else {
    Write-Host "Module does not exist, Installing AzureADPreview"
    Install-Module -Name AzureADPreview
}





