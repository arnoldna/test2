param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
    [Alias("Parameters", "p")]
    [string]$ParametersJson
)

#Change these variables to respresent your environment

$storageAccountResourceGroup = 'central-westus-prod-automation-rg'
$storageAccountName = 'pimadeployments'
$blobContainer = 'vmdeployments'
$blobName = 'WindowsLinkedDeployments/windowsVM.nested.azuredeploy.json'

# Parse the provided parameters file to get the VMName and the resource group to deploy to.
$json = Get-Content -Path $ParametersJson
$json2 = $json|convertFrom-json
$vmName = $json2.parameters.vmName.value
$vmResourceGroup = $json2.parameters.deploymentEnvironmentName.value

Set-AzCurrentStorageAccount -ResourceGroupName $storageAccountResourceGroup -Name $storageAccountName
$token = New-AzStorageContainerSASToken -Name $blobContainer -Permission r -ExpiryTime (Get-Date).AddMinutes(30.0)
$url = (Get-AzStorageBlob -Container $blobContainer -Blob $blobName).ICloudBlob.uri.AbsoluteUri

#Write-Output "-ResourceGroupName $vmResourceGroup -templateParameterFile $ParametersJson -TemplateUri $($url + $token)"
New-AzResourceGroupDeployment -name $vmName -ResourceGroupName $vmResourceGroup -templateParameterFile $ParametersJson -TemplateUri $($url + $token) -Debug