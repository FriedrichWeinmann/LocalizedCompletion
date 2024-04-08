function Enable-LocalizedCompletion {
	<#
	.SYNOPSIS
		Enables the localized tab completion.
	
	.DESCRIPTION
		Enables the localized tab completion.
		Use Register-LCLocalization to provide localized completion.
		Use Set-LCLanguage to define the language used for completion.
	
	.EXAMPLE
		PS C:\> Enable-LocalizedCompletion
		
		Enables the localized tab completion.
	#>
	[CmdletBinding()]
	param ()
	process {
		& "$script:ModuleRoot\internal\expander\TabExpansion3.ps1"
	}
}