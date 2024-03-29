function Get-ArtifactoryItem {
    [Alias('gai')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]
        $Path,

        [Parameter()]
        [switch]
        $FromTrash
    )

    $Api = 'storage/'
    if ($FromTrash) {
        $Api += 'auto-trashcan/'
    }

    # https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-FileInfo
    Invoke-ArtifactoryApi GET $Api$Path | New-ArtifactoryCliObject 'Artifactory.Item'
}

function Get-ArtifactoryChildItem {
    [Alias('gaci')]
    [CmdletBinding(DefaultParameterSetName='ByUri')]
    param(
        [Parameter(ParameterSetName='ByUri', Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $AbsoluteUri,

        [Parameter(ParameterSetName='ByPath', Mandatory)]
        [string]
        $Path
    )

    if ($PSCmdlet.ParameterSetName -eq 'ByUri') {
        $Path = $AbsoluteUri.Replace($env:ARTIFACTORY_ENDPOINT, '')
        $Path = $Path.Replace('/api/storage/', '')
    }

    Get-ArtifactoryItem -Path $Path  | Select-Object -ExpandProperty Children |
        Add-Member -NotePropertyName 'Path' -NotePropertyValue $Path -PassThru |
        New-ArtifactoryCliObject 'Artifactory.ChildItem'
}

function Remove-ArtifactoryItem {
    [CmdletBinding(DefaultParameterSetName='ByUri', SupportsShouldProcess)]
    param(
        [Parameter(ParameterSetName='ByUri', Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $AbsoluteUri,

        [Parameter(ParameterSetName='ByPath', Mandatory)]
        [string]
        $Path
    )

    $Resource = switch ($PSCmdlet.ParameterSetName) {
        ByUri  { $AbsoluteUri }
        ByPath { "$env:ARTIFACTORY_ENDPOINT/$Path" }
    }

    if ($PSCmdlet.ShouldProcess($Resource, "delete item")) {
        if ($Resource.Contains('auto-trashcan')) {
            $Artifact = $Resource.Replace("$env:ARTIFACTORY_ENDPOINT/auto-trashcan", '')
            # https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-DeleteItemFromTrashCan
            Invoke-ArtifactoryApi DELETE "trash/clean$($Artifact)" | Out-Null
            Write-Host "Removed $Artifact from trash"
        } else {
            # https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-DeleteItem
            Invoke-ArtifactoryApi DELETE -Uri $Resource | Out-Null
            Write-Host "Removed $Resource"
        }
    }
}
