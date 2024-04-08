# Language to complete to
$script:language = $Host.CurrentUICulture.Name
if (-not $script:language) { $script:language = 'en-us' }
$script:defaultLanguage = 'en-us'

# Registered Localization
$script:localization = @{
<#
<CommandName> = @{
	Help = [help]
	Synopsis = @{ <language> = <override> }
	Alias = @{ <language> = <override> }
	ListItem = @{ <language> = <override> }
	Parameter = @{
		<name> = @{
			Alias = @{ <language> = <override> }
			ListItem = @{ <language> = <override> }
			Tooltip = @{ <language> = <override> }
		}
	}
}
#>
}