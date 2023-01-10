# https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-GetStorageSummaryInfo
function Get-ArtifactoryStorageInfo {
    param(
        [Parameter(Position=0)]
        [string]
        $RepoName
    )

    $StorageInfo = Invoke-ArtifactoryApi GET "api/storageinfo"

    if ([string]::IsNullOrWhiteSpace($RepoName)) {
        $StorageInfo | New-ArtifactoryCliObject 'Artifactory.StorageInfo'
    }
    else {
        $StorageInfo | Select-Object -ExpandProperty repositoriesSummaryList | Where-Object RepoKey -eq $RepoName | New-ArtifactoryCliObject
    }
}
