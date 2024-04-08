function Register-LCLocalization {
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