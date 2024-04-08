function Resolve-LCCompletionCommand {
	[CmdletBinding()]
	param (
		[string]
		$Code,

		[int]
		$Position
	)
	process {
		$ast = [System.Management.Automation.Language.Parser]::ParseInput($Code, [ref]$null, [ref]$null)
		$item = $ast.FindAll({
				$args[0].Extent.StartOffSet -le $Position -and $args[0].Extent.EndOffset -ge $Position
			}, $true) | Sort-Object { $_.Extent.StartOffset } -Descending | Select-Object -First 1

		#region Parameter Completion
		if ($item.Parent -is [System.Management.Automation.Language.CommandAst]) {
			$commandName = $item.Parent.CommandElements[0].Value
			$command = $ExecutionContext.InvokeCommand.GetCommand($item.Parent.CommandElements[0].Value, 'Function,Cmdlet,Alias')

			# To ensure precedence is respected
			if ($commandObject = @($command).Where{ $_.CommandType -eq 'Alias' }) {
				$resolvedCommand = $commandObject.ResolvedCommand
				$commandName = $resolvedCommand.Name
			}
			elseif ($commandObject = @($command).Where{ $_.CommandType -eq 'Function' }) {
				$resolvedCommand = $commandObject
				$commandName = $resolvedCommand.Name
			}
			elseif ($commandObject = @($command).Where{ $_.CommandType -eq 'Cmdlet' }) {
				$resolvedCommand = $commandObject
				$commandName = $resolvedCommand.Name
			}

			$isParameterCompletion = (
				$item -is [System.Management.Automation.Language.CommandParameterAst] -or
				(
					$item -is [System.Management.Automation.Language.StringConstantExpressionAst] -and
					$item.Extent.Text -match '^-'
				)
			)

			[PSCustomObject]@{
				Type                  = 'ParameterCompletion'
				CommandText           = $item.Parent.CommandElements[0].Value
				Command               = $resolvedCommand
				CommandName           = $commandName
				CompletionAst         = $item
				IsParameterCompletion = $isParameterCompletion
			}

			return
		}
		#endregion Parameter Completion

		#region Command Completion
		# Case: First Command
		if ($item -is [System.Management.Automation.Language.ScriptBlockAst] -and $item.Extent.Text -notmatch '^\$') {
			[PSCustomObject]@{
				Type                  = 'CommandCompletion'
				CommandText           = $item.Extent.Text
				Command               = $null
				CommandName           = $null
				CompletionAst         = $item
				IsParameterCompletion = $false
			}
			return
		}

		# Case: Subsequent command in pipeline
		if ($item -is [System.Management.Automation.Language.CommandAst]) {
			[PSCustomObject]@{
				Type                  = 'CommandCompletion'
				CommandText           = $item.CommandElements[0].Value
				Command               = $null
				CommandName           = $null
				CompletionAst         = $item
				IsParameterCompletion = $false
			}
			return
		}
		#endregion Command Completion

		[PSCustomObject]@{
			Type                  = 'Unknown'
			CommandText           = $item
			Command               = $null
			CommandName           = $null
			CompletionAst         = $item
			IsParameterCompletion = $false
		}
	}
}