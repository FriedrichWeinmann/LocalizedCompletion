function Enable-LocalizedCompletion {
	[CmdletBinding()]
	param ()
	process {
		& "$script:ModuleRoot\internal\expander\TabExpansion3.ps1"
	}
}