# Overview

Cmdlets to interact with the [Artifactory REST API](https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API#ArtifactoryRESTAPI-DeleteItemFromTrashCan).

## Setup

```powershell
$env:ARTIFACTORY_ENDPOINT='https://myartifactory.mydomain.local/artifactory'
$env:ARTIFACTORY_API_KEY ='my-artifactory-api-key"

Import-Module ArtifactoryCli
```

## Examples

### `Get-ArtifactoryItem`

```powershell
Get-ArtifactoryItem 'docker'
```
```text
Repo   Path Last Modified        Child Count Uri
----   ---- -------------        ----------- ---
docker /    2/2/2018 10:21:32 PM         197 https://myartifactory.mydomain.local/artifactory/api/storage/docker
```

### `Get-ArtifactoryChildItem`

```powershell
Get-ArtifactoryChildItem 'docker'
```
OR
```powershell
Get-ArtifactoryItem 'docker' | Get-ArtifactoryChildItem
```
```text
Uri                                                            IsFolder
---                                                            --------
https://myartifactory.mydomain.local/artifactory/docker/imagea True
https://myartifactory.mydomain.local/artifactory/docker/imageb True
...
```

### `Remove-ArtifactoryItem`

In order to avoid timeouts (and to minimize risk), the best way to remove items is by specific tags as opposed to by folder / repository.

Example:

```powershell
Get-ArtifactoryItem 'docker/imagea' | Get-ArtifactoryChildItem | ForEach-Object { $_ | Remove-ArtifactoryItem -Confirm }
```
```text
Performing the operation "delete item" on target
""https://myartifactory.mydomain.local/artifactory/docker/imagea/build123456".
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help
(default is "Y"):
```

### `Get-ArtifactoryStorageInfo`

```powershell
Get-ArtifactoryStorageInfo
```
```text
Binaries                   Files                         Repos                      Repo Count Largest Repos
--------                   -----                         -----                      ---------- -------------
21.14 TB (1,546,703 items) 12.70 GB (17.23%) of 73.70 GB 64.95 TB (4,620,805 items)        151 docker, auto-trashcan, foo, bar, xyz
```

```powershell
Get-ArtifactoryStorageInfo 'docker'
```
```text
FilesCount   : 3252590
FoldersCount : 183569
ItemsCount   : 3436159
PackageType  : Docker
Percentage   : 84.55%
RepoKey      : docker
RepoType     : LOCAL
UsedSpace    : 54.92 TB
```