# API Docs:
# https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API
function Invoke-ArtifactoryApi {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='ByPath')]
    param (
        [Parameter(Mandatory, Position=0)]
        [string]
        $Method,

        [Parameter(ParameterSetName='ByPath', Position=1, Mandatory)]
        [string]
        $Path,

        [Parameter(ParameterSetName='ByUri', Position=1, Mandatory)]
        [string]
        $Uri
    )

    $Resource = switch ($PSCmdlet.ParameterSetName) {
        ByPath { "$env:ARTIFACTORY_ENDPOINT/$Path" }
        ByUri  { "$Uri" }
    }

    if ($PSCmdlet.ShouldProcess($Resource, "$Method")) {
        Invoke-RestMethod -Headers @{ 'X-JFrog-Art-Api' = $env:ARTIFACTORY_API_KEY } -Method $Method -Uri $Resource
    }
}

function New-ArtifactoryCliObject {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $InputObject,

        [Parameter(Position=0, Mandatory=$false)]
        [string]
        $DisplayType
    )
    Begin{}
    Process {
        foreach ($Item in $InputObject) {
            $Wrapper = New-Object PSObject
            $Item.PSObject.Properties |
                Sort-Object Name |
                ForEach-Object {
                    $Wrapper | Add-Member -MemberType NoteProperty -Name $($_.Name | ConvertTo-TitleCase) -Value $_.Value
                }
            
            
            if ($DisplayType) {
                $Wrapper.PSTypeNames.Insert(0, $DisplayType)
            }
            Write-Output $Wrapper
        }
    }
    End{}
}

function ConvertTo-TitleCase
{
    param(
        [Parameter(Position=0, ValueFromPipeline=$true)]
        [string] $Value
    )

    if ($Value -and $Value.Length -gt 0) {
        "$($Value.Substring(0, 1).ToUpper())$($Value.Substring(1))"
    }
}
