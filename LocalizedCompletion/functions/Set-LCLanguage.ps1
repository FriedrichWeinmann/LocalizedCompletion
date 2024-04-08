function Set-LCLanguage {
	<#
	.SYNOPSIS
		Sets the language completed for.
	
	.DESCRIPTION
		Sets the language completed for.
	
	.PARAMETER Language
		The language to use for completion.
		Must be a language code such as "en-us" or "de-de".
	
	.PARAMETER DefaultLanugage
		What language should be used as the default language.
		Must be a language code such as "en-us" or "de-de".
	
	.EXAMPLE
		PS C:\> Set-LCLanguage -Language de-de

		Changes the current completion language to German.
	#>
	[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
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