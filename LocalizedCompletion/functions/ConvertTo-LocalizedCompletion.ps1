function ConvertTo-LocalizedCompletion {
	<#
	.SYNOPSIS
		Converts a completion result into a localized version of itself.
	
	.DESCRIPTION
		Converts a completion result into a localized version of itself.
		Use Register-LCLocalization to provide localization values.

		For internal use and troubleshooting.
	
	.PARAMETER Completion
		The completion result provided by the PowerShell engine.
	
	.PARAMETER Code
		The line of code that is being completed for.
	
	.PARAMETER Offset
		Where in the line of code the cursor is.
	
	.EXAMPLE
		PS C:\> ConvertTo-LocalizedCompletion -Completion $ompletion -Code $code -Offset $offset

		Converts a completion result into a localized version of itself.
	#>
	[OutputType([System.Management.Automation.CommandCompletion])]
	[CmdletBinding()]
	param (
		[System.Management.Automation.CommandCompletion]
		$Completion,

		[string]
		$Code,

		[int]
		$Offset
	)
	process {
		$type = Resolve-LCCompletionCommand -Code $Code -Position $Offset
		if ($type.Type -eq 'unknown') { return $Completion }

		$selector = [LocalizedCompletion.Selector]::new($script:language,$script:defaultLanguage)

		if ($type.Type -eq 'ParameterCompletion') {
			if (-not $type.IsParameterCompletion) { return $Completion }
			if (-not $script:localization[$type.CommandName]) { return $Completion }

			$parameterHash = $script:localization[$type.CommandName].Parameter
			if ($parameterHash.Count -lt 1) { return $Completion }

			$allItems = $($Completion.CompletionMatches)
			$Completion.CompletionMatches.Clear()

			foreach ($item in $allItems) {
				# Skip Irrelevant
				if ($item.ResultType -ne 'ParameterName') {
					$Completion.CompletionMatches.Add($item)
					continue
				}

				$itemName = $item.CompletionText.TrimStart('-')
				if ($parameterHash.Keys -notcontains $itemName) {
					$Completion.CompletionMatches.Add($item)
					continue
				}

				$Completion.CompletionMatches.Add(
					[System.Management.Automation.CompletionResult]::new(
						$selector.SelectParameter($item.CompletionText, $parameterHash.$itemName.Alias),
						$selector.Select($item.ListItemText, $parameterHash.$itemName.ListItem),
						'ParameterName',
						$selector.Select($item.ToolTip, $parameterHash.$itemName.ToolTip)
					)
				)
			}

			return $Completion
		}

		if ($type.Type -eq 'CommandCompletion') {
			$allItems = $($Completion.CompletionMatches)
			$Completion.CompletionMatches.Clear()
			foreach ($item in $allItems) {
				if ($item.CompletionText -notin $script:localization.Keys) {
					$Completion.CompletionMatches.Add($item)
					continue
				}

				$commandHash = $script:localization[$item.CompletionText]
				$Completion.CompletionMatches.Add(
					[System.Management.Automation.CompletionResult]::new(
						$selector.Select($item.CompletionText, $commandHash.Alias),
						$selector.Select($item.ListItemText, $commandHash.ListItem),
						'ParameterName',
						$selector.Select($item.ToolTip, $commandHash.Tooltip)
					)
				)
			}

			return $Completion
		}

		$Completion
	}
}