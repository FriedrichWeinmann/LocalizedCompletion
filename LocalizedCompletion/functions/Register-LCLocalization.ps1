function Register-LCLocalization {
	<#
	.SYNOPSIS
		Registers localization data for tab completion.
	
	.DESCRIPTION
		Registers localization data for tab completion.
	
	.PARAMETER CommandName
		Name of the command to complete.
	
	.PARAMETER Tooltip
		Tooltip that should be shown when completing the command.
	
	.PARAMETER Alias
		Alternative command name that should be completed to.
		No alias will actually be created - be sure the new name actually exists.
	
	.PARAMETER ListItem
		Alternative command name to display in a completion menu.
	
	.PARAMETER ParameterName
		Name of the parameter to localized for completion.
	
	.PARAMETER ParameterAlias
		Alternative name of the parameter to complete to.
		This alias is not actually added to the parameter, so be sure it actually exists on the actual command before assigning it here.
	
	.PARAMETER ParameterListItem
		Alternative parameter name to show during a completion menu.
	
	.PARAMETER ParameterTooltip
		Tooltip for the parameter to show during completion.
	
	.PARAMETER ParameterHash
		A set of parameters to update in bulk.
		Each key is a parameter name, each value a hashtable with the keys Alias, ListItem and Tooltip.
		Each of these three should then contain a hashtable mapping language-code to text.
	
	.PARAMETER LoadHelp
		NOT YET IMPLEMENTED	
		Whether the command help should be loaded and cached to the entry.
		This would then be used to provide automatic Tooltip content.
	
	.EXAMPLE
		PS C:\> Register-LCLocalization -CommandName Get-ChildItem -ListItem @{ 'de-de' = 'Lese-Kindobjekte' } -Alias @{ 'de-de' = 'Lese-KindObjekt' } -Tooltip @{ 'de-de' = 'Macht seltsame Dinge' }

		Provides localized completion for Get-ChildItem in German
	#>
	[CmdletBinding(DefaultParameterSetName = 'default')]
	param (
		[Parameter(Mandatory = $true)]
		[string]
		$CommandName,

		[hashtable]
		$Tooltip,

		[hashtable]
		$Alias,

		[hashtable]
		$ListItem,

		[Parameter(Mandatory = $true, ParameterSetName = 'Parameter')]
		[string]
		$ParameterName,

		[Parameter(ParameterSetName = 'Parameter')]
		[hashtable]
		$ParameterAlias,

		[Parameter(ParameterSetName = 'Parameter')]
		[hashtable]
		$ParameterListItem,

		[Parameter(ParameterSetName = 'Parameter')]
		[hashtable]
		$ParameterTooltip,

		[Parameter(Mandatory = $true, ParameterSetName = 'Hash')]
		[hashtable]
		$ParameterHash,

		[switch]
		$LoadHelp
	)
	begin {
		#region Functions
		function Update-Parameter {
			[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
			[CmdletBinding()]
			param (
				[hashtable]
				$CommandHash,

				[string]
				$ParameterName,

				[AllowNull()]
				$Alias,
				[AllowNull()]
				$ListItem,
				[AllowNull()]
				$Tooltip
			)

			if (-not $CommandHash.Parameter[$ParameterName]) {
				$CommandHash.Parameter[$ParameterName] = @{
					Alias = @{}
					ListItem = @{}
					Tooltip = @{}
				}
			}

			$parameterHash = $CommandHash.Parameter[$ParameterName]

			$aspects = 'Alias', 'ListItem', 'Tooltip'
			foreach ($aspect in $aspects) {
				if (-not $PSBoundParameters.$aspect) { continue }
				if ($PSBoundParameters.$aspect -isnot [hashtable]) {
					Write-Warning "Invalid $aspect datatype! Ensure to provide a hashtable for that."
					continue
				}

				foreach ($pair in $PSBoundParameters.$aspect.GetEnumerator()) {
					$parameterHash[$aspect][$pair.Key] = $pair.Value
				}
			}
		}
		#endregion Functions
	}
	process {
		#region Main Command
		if (-not $script:localization[$CommandName]) {
			$script:localization[$CommandName] = @{
				Name = $CommandName
				Help = $null
				Tooltip = @{ }
				Alias = @{ }
				ListItem = @{ }
				Parameter = @{ }
			}
		}

		$commandHash = $script:localization[$CommandName]

		$aspects = 'Tooltip', 'Alias', 'ListItem'
		foreach ($aspect in $aspects) {
			if (-not $PSBoundParameters.$aspect) { continue }

			foreach ($pair in $PSBoundParameters.$aspect.GetEnumerator()) {
				$commandHash[$aspect][$pair.Key] = $pair.Value
			}
		}

		if ($LoadHelp -and -not $commandHash.Help) { $commandHash.Help = Get-Help -Name $CommandName -ErrorAction Ignore }
		#endregion Main Command

		#region Single Parameter
		if ($ParameterName) {
			Update-Parameter -CommandHash $commandHash -ParameterName $ParameterName -Alias $ParameterAlias -ListItem $ParameterListItem -Tooltip $ParameterTooltip
		}
		#endregion Single Parameter

		#region Parameter Hash
		if ($ParameterHash) {
			foreach ($pair in $ParameterHash.GetEnumerator()) {
				Update-Parameter -CommandHash $commandHash -ParameterName $pair.Key -Alias $pair.Value.Alias -ListItem $pair.Value.ListItem -Tooltip $pair.Value.Tooltip
			}
		}
		#endregion Parameter Hash
	}
}