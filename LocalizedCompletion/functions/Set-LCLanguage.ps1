function Set-LCLanguage {
	[CmdletBinding()]
	param (
		[ValidateScript({
			if ($_ -in [System.Globalization.CultureInfo]::GetCultures('AllCultures').Name) { return $true }
			Write-Warning "Invalid language! Must be in a format similar to 'en-US' or 'de-DE'! $_"
			throw "Invalid language! Must be in a format similar to 'en-US' or 'de-DE'! $_"
		})]
		[string]
		$Language,

		[ValidateScript({
			if ($_ -in [System.Globalization.CultureInfo]::GetCultures('AllCultures').Name) { return $true }
			Write-Warning "Invalid language! Must be in a format similar to 'en-US' or 'de-DE'! $_"
			throw "Invalid language! Must be in a format similar to 'en-US' or 'de-DE'! $_"
		})]
		[string]
		$DefaultLanugage
	)
	process {
		if ($Language) { $script:Language = $Language }
		if ($DefaultLanugage) { $script:DefaultLanugage = $DefaultLanugage }
	}
}