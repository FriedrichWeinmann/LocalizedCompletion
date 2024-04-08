function Disable-LocalizedCompletion {
	[CmdletBinding()]
	param ()
	process {
		& "$script:ModuleRoot\internal\expander\TabExpansion2.ps1"
	}
}