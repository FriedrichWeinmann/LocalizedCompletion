# Localized Completion

Welcome to the Proof of Concept module for localized Tab Completion in PowerShell.

> Note: This module is still experimental.
> Things will change, bugs may exist, breaking changes are expected for future versions.

## Installation

```powershell
# PowerShell 7.4+
Install-PSResource LocalizedCompletion

# Otherwise
Install-Module Localizedcompletion -Scope CurrentUser
```

## Profit

To register localization for a parameter, use this:

```powershell
Register-LCLocalization -CommandName Get-ChildItem -ParameterName LiteralPath -ParameterListItem @{
  'de-de' = 'Wörtlicher Pfad'
} -ParameterTooltip @{
  'de-de' = 'Pfad ohne Wildcard Auswertung'
} -ParameterAlias @{
  'de-de' = 'WörtlicherPfad'
}
```

This will now provide customized tab completion for the LiteralPath parameter on a German console:

+ ParameterListItem: The way the parameter is being displayed in a tab menu
+ ParameterTooltip: The cyan tooltip for the parameter in a tab menu
+ ParameterAlias: Actual value inserted when completing (does _NOT_ magically add that alias to the parameter on the command. The example above will not work in a regular PowerShell console)

Providing localization for a command itself:

```powershell
Register-LCLocalization -CommandName Get-ChildItem -ListItem @{
  'de-de' = 'Lese-Kindobjekte'
} -Alias @{
  'de-de' = 'Lese-KindObjekt'
} -Tooltip @{
  'de-de' = 'Macht seltsame Dinge'
}
```
