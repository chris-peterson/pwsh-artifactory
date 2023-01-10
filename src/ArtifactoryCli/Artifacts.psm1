# https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-FileInfo
function Get-ArtifactoryItem {
    param(
        [Parameter(Mandatory, Position=0)]
        [string]
        $Path
    )

    Invoke-ArtifactoryApi GET -Path "api/storage/$Path" | New-ArtifactoryCliObject 'Artifactory.Item'
}

function Get-ArtifactoryChildItem {
    param(
        [Parameter(Mandatory, Position=0)]
        [string]
        $Path
    )

    Get-ArtifactoryItem $Path | Select-Object -ExpandProperty Children |
        Add-Member -NotePropertyName 'Path' -NotePropertyValue $Path -PassThru |
        Add-Member -NotePropertyName 'FullPath' -NotePropertyValue "$env:ARTIFACTORY_ENDPOINT/$Path" -PassThru |
        New-ArtifactoryCliObject 'Artifactory.ChildItem'
}

# https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-DeleteItem
function Remove-ArtifactoryItem {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, Position=0)]
        [string]
        $Uri
    )

    if ($PSCmdlet.ShouldProcess($Uri, "delete from artifactory")) { 
        if (Invoke-ArtifactoryApi DELETE -Uri $Uri | Out-Null) {
            Write-Host "`tRemoved $Uri"
        }
    }
}
