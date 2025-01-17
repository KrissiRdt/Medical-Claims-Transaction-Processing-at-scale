#!/usr/bin/pwsh
 
 Param(
    [parameter(Mandatory=$true)][string]$resourceGroup,
    [parameter(Mandatory=$true)][string]$storageAccount
 )

Push-Location $($MyInvocation.InvocationName | Split-Path)
Push-Location $(./Join-Path-Recursively.ps1 -pathParts "..,..,ui,medical-claims-ui".Split(","))

Write-Host "===========================================================" -ForegroundColor Yellow
Write-Host " Building the website" -ForegroundColor Yellow
Write-Host "===========================================================" -ForegroundColor Yellow
if (Test-Path ./out)
{
   Remove-Item -Path ./out -Recurse -Force
}
npm ci
npm run build

Write-Host "===========================================================" -ForegroundColor Yellow
Write-Host " Deploying to website" -ForegroundColor Yellow
Write-Host "===========================================================" -ForegroundColor Yellow
az storage azcopy blob upload -c `$web --account-name $storageAccount -s './out/*' --recursive

$webUri=(az storage account show --name $storageAccount --resource-group $resourceGroup --query "primaryEndpoints.web" -o tsv)

Write-Host "===========================================================" -ForegroundColor Yellow
Write-Host " Website Url: $webUri" -ForegroundColor Yellow
Write-Host "===========================================================" -ForegroundColor Yellow

Pop-Location
Pop-Location
