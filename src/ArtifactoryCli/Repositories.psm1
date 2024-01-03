# https://jfrog.com/help/r/jfrog-rest-apis/get-repositories
function Get-ArtifactoryRepository {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Alias('Name')]
        [string]
        $RepoKey,

        [Parameter()]
        [switch]
        $IncludeReplicationConfiguration
    )

    $Path = 'repositories'
    if ($RepoKey) {
        $Path += "/$RepoKey"
    }

    $Repositories = Invoke-ArtifactoryApi GET $Path | New-ArtifactoryCliObject 'Artifactory.Repository'
    if ($IncludeReplicationConfiguration) {
        $Repositories | ForEach-Object {
            # https://jfrog.com/help/r/jfrog-rest-apis/get-repository-replication-configuration
            try {
                $ReplicationConfig = Invoke-ArtifactoryApi GET "replications/$($_.Key)"
                if ($ReplicationConfig) {
                    $_ | Add-Member -NotePropertyMembers @{
                        ReplicationConfig = $ReplicationConfig
                    }
                }
            } catch {
                # API throws an error if there is no replication config
            }
        }
    }

    $Repositories
}

function Update-ArtifactoryRepositoryReplication {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias('Name')]
        [string]
        $RepoKey,

        [Parameter()]
        [ValidateSet($null, 'false', 'true')]
        [string]
        $EventReplication,

        [Parameter()]
        [ValidateSet($null, 'false', 'true')]
        [string]
        $SyncDeletes,

        [Parameter()]
        [string]
        $CronExpression,

        [Parameter()]
        [string]
        $Url
    )

    $Request = @{
        repoKey = $RepoKey
    }
    if ($EventReplication) {
        $Request.enableEventReplication = $EventReplication
    }
    if ($SyncDeletes) {
        $Request.syncDeletes = $SyncDeletes
    }
    if ($CronExpression) {
        $Request.cronExp = $CronExpression
    }
    if ($Url) {
        $Request.url = $Url
    }
    if ($PSCmdlet.ShouldProcess("replication for $RepoKey", "set to $($Request | ConvertTo-Json)")) {
        throw "this method hasn't been validated yet"
        # https://jfrog.com/help/r/jfrog-rest-apis/set-repository-replication-configuration
        Invoke-ArtifactoryApi PUT "replications/$RepoKey" -Body $Request
    }
}