$dest = "c:\temp\"
$PackagesUrl = "https://api.github.com/repos/noyard/intunepackages/contents/Packages"
$Package = "Microsoft CodE"


$response = Invoke-WebRequest -Uri $PackageUrl -Method Get 
$PackageInfo = ConvertFrom-json $response.content

if (!($Package)) 
	{
		"Available Packages are:"
		$PackageInfo
	}else{
		If (!($PackageInfo | Where-Object Name -eq $package))
		{
			"Package $($package) not found"
		}else{
			$PackageInfo = $PackageInfo | Where-Object Name -eq $package
			$files =ConvertFrom-Json ((Invoke-WebRequest -Uri $PackageInfo.url -Method Get).content)
			Foreach ($file in $files)
				{
					$filepath = "$($dest)$($file.path)"
					New-Item $(Split-Path -Path $filepath -Parent) -ItemType Directory -Force
					Start-BitsTransfer -Source $file.download_url -Destination "$($dest)$($file.path)"
				}
		}
	}

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





