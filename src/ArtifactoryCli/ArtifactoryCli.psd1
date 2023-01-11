@{
    ModuleVersion = '0.0.1'

    PrivateData = @{
        PSData = @{
            LicenseUri = 'https://github.com/chris-peterson/pwsh-artifactory/blob/main/LICENSE'
            ProjectUri = 'https://github.com/chris-peterson/pwsh-artifactory'
            ReleaseNotes = 'initial release'
        }
    }

    GUID = 'bbd70209-995c-40c0-b270-836688ebfeea'

    Author = 'Chris Peterson'
    CompanyName = 'Chris Peterson'
    Copyright = '(c) 2023'

    Description = 'Interact with Artifactory via PowerShell'
    PowerShellVersion = '7.1'

    ScriptsToProcess = @()
    TypesToProcess = @('Types.ps1xml')
    FormatsToProcess = @('Formats.ps1xml')

    NestedModules = @(
        'Artifacts.psm1'
        'Storage.psm1'
        'Utilities.psm1'
    )
    FunctionsToExport = @(
        'Get-ArtifactoryStorageInfo'
        
        'Get-ArtifactoryItem'
        'Get-ArtifactoryChildItem'
        'Remove-ArtifactoryItem'
        
        'Invoke-ArtifactoryApi'
        'New-ArtifactoryCliObject'
        )
    AliasesToExport = @()
}
