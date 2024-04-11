function Disable-LocalizedCompletion {
	<#
	.SYNOPSIS
		Disables the localized tab completion, restoring the default behavior.
	
	.DESCRIPTION
		Disables the localized tab completion, restoring the default behavior.
		Should end any completion-related bugs.
	
	.EXAMPLE
		PS C:\> Disable-LocalizedCompletion

		Disables the localized tab completion, restoring the default behavior.
	#>
	[CmdletBinding()]
	param ()
	process {
		& "$script:ModuleRoot\expander\TabExpansion2.ps1"
	}
}