function global:TabExpansion2 {
	<# Options include:
     RelativeFilePaths - [bool]
         Always resolve file paths using Resolve-Path -Relative.
         The default is to use some heuristics to guess if relative or absolute is better.

   To customize your own custom options, pass a hashtable to CompleteInput, e.g.
         return [System.Management.Automation.CommandCompletion]::CompleteInput($inputScript, $cursorColumn,
             @{ RelativeFilePaths=$false }
#>

	[CmdletBinding(DefaultParameterSetName = 'ScriptInputSet')]
	[OutputType([System.Management.Automation.CommandCompletion])]
	Param(
		[Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 0)]
		[AllowEmptyString()]
		[string] $inputScript,

		[Parameter(ParameterSetName = 'ScriptInputSet', Position = 1)]
		[int] $cursorColumn = $inputScript.Length,

		[Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 0)]
		[System.Management.Automation.Language.Ast] $ast,

		[Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 1)]
		[System.Management.Automation.Language.Token[]] $tokens,

		[Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 2)]
		[System.Management.Automation.Language.IScriptPosition] $positionOfCursor,

		[Parameter(ParameterSetName = 'ScriptInputSet', Position = 2)]
		[Parameter(ParameterSetName = 'AstInputSet', Position = 3)]
		[Hashtable] $options = $null
	)

	End {
		if ($psCmdlet.ParameterSetName -eq 'ScriptInputSet') {
			$result = [System.Management.Automation.CommandCompletion]::CompleteInput(
				<#inputScript#>  $inputScript,
				<#cursorColumn#> $cursorColumn,
				<#options#>      $options)

			# Debugging Data
			if (-not $global:__lc_compl) {
				$global:__lc_compl = $result
				$global:__lc_param = $PSBoundParameters
			}
			ConvertTo-LocalizedCompletion -Completion $result -Code $inputScript -Offset $cursorColumn
		}
		else {
			return [System.Management.Automation.CommandCompletion]::CompleteInput(
				<#ast#>              $ast,
				<#tokens#>           $tokens,
				<#positionOfCursor#> $positionOfCursor,
				<#options#>          $options)
		}
	}
}