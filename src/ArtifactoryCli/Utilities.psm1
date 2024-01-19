# API Docs:
# https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API
function Invoke-ArtifactoryApi {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='ByPath')]
    param (
        [Parameter(Mandatory, Position=0)]
        [string]
        $Method,

        [Parameter(ParameterSetName='ByPath', Mandatory, Position=1)]
        [string]
        $Path,

        [Parameter()]
        $Body,

        [Parameter(ParameterSetName='ByUri', Mandatory, Position=1)]
        [string]
        $Uri
    )

    $Resource = switch ($PSCmdlet.ParameterSetName) {
        ByPath { "$env:ARTIFACTORY_ENDPOINT/artifactory/api/$Path" }
        ByUri  { "$Uri" }
    }

    if ($PSCmdlet.ShouldProcess($Resource, "$Method")) {
        Write-Debug "Artifactory API: $Method $Resource"
        Invoke-RestMethod -Headers @{ 'Authorization' = "Bearer $env:ARTIFACTORY_ACCESS_TOKEN" } -Method $Method -Uri $Resource -Body $Body
    }
}

# there are a lot of things that can't be done using the REST API.  this provides a very HACKy way to leverage some undocumented UI features
function Invoke-ArtifactoryUi {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, Position=0)]
        [string]
        $Method,

        [Parameter(Mandatory, Position=1)]
        [string]
        $Path,

        [Parameter()]
        [hashtable]
        $Query = @{},

        [Parameter()]
        [hashtable]
        $Body = @{}
    )

    $Resource = "$env:ARTIFACTORY_ENDPOINT/ui/api/$Path"
    $Headers = @{
        'X-Requested-With' = 'XMLHttpRequest'
    }

    if ($Query.Count -gt 0) {
        $SerializedQuery = ''
        $Delimiter = '?'
        foreach($Name in $Query.Keys) {
            $Value = $Query[$Name]
            if ($Value) {
                $SerializedQuery += $Delimiter
                $SerializedQuery += "$Name="
                $SerializedQuery += [System.Net.WebUtility]::UrlEncode($Value)
                $Delimiter = '&'
            }
        }
        $Resource += $SerializedQuery
    }

    if ($Body.Count -gt 0) {
        $Headers.'Content-Type' = 'application/json'
        $SerializedBody = $Body | ConvertTo-Json
    }

    if ($PSCmdlet.ShouldProcess($Resource, "$Method ($($($SerializedQuery ?? $Body).GetEnumerator() | ForEach-Object { "$($_.Name)=$($_.Value)" }))")) {
        Write-Debug "Artifactory UI: $Method $Resource"
        Invoke-RestMethod -Headers $Headers -Method $Method -Uri $Resource -Body $SerializedBody
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
