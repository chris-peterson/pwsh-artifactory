@{
    ModuleVersion = '0.0.3'

    PrivateData = @{
        PSData = @{
            LicenseUri = 'https://github.com/chris-peterson/pwsh-artifactory/blob/main/LICENSE'
            ProjectUri = 'https://github.com/chris-peterson/pwsh-artifactory'
            ReleaseNotes = 'Add a way of invoking UI functions that are not available in REST API'
        }
    }

    GUID = 'bbd70209-995c-40c0-b270-836688ebfeea'

    Author = 'Chris Peterson'
    CompanyName = 'Chris Peterson'
    Copyright = '(c) 2023-2024'

    Description = 'Interact with Artifactory via PowerShell'
    PowerShellVersion = '7.1'

    ScriptsToProcess = @()
    TypesToProcess = @('Types.ps1xml')
    FormatsToProcess = @('Formats.ps1xml')

    NestedModules = @(
        'Artifacts.psm1'
        'Repositories.psm1'
        'Storage.psm1'
        'Utilities.psm1'
    )
    FunctionsToExport = @(
        'Get-ArtifactoryRepository'
        'Update-ArtifactoryRepositoryReplication'

        'Get-ArtifactoryItem'
        'Get-ArtifactoryChildItem'
        'Remove-ArtifactoryItem'

        'Get-ArtifactoryStorageInfo'

        'Invoke-ArtifactoryApi'
        'Invoke-ArtifactoryUi'
        'New-ArtifactoryCliObject'
        )
    AliasesToExport = @(
        'gai'
        'gaci'
    )
}
