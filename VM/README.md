# Virtual Machines

This module deploys one or multiple Virtual Machines.

## Resources

- Microsoft.Network/publicIPAddresses
- Microsoft.Network/publicIPAddresses/providers/diagnosticSettings
- Microsoft.Network/networkInterfaces
- Microsoft.Network/networkInterfaces/providers/diagnosticSettings
- Microsoft.Compute/availabilitySets
- Microsoft.Compute/virtualMachineScaleSets
- Microsoft.Compute/proximityPlacementGroups
- Microsoft.Compute/virtualMachines
- providers/locks
- providers/diagnosticSettings
- Microsoft.Compute/virtualMachines/extensions

## Parameters

| Parameter Name | Type | Default Value | Possible values | Description |
| :-             | :-   | :-            | :-              | :-          |
| `vmNames` | array | | | Required. Name(s) of the virtual machine(s) |
| `location` | string | `[resourceGroup().location]` | | Optional. Location for all resources. |
| `vmSize` | string | `Standard_D2s_v3` | | Optional. Specifies the size for the VMs. |
| `standardImage` | object | {} | Complex structure, see below. | OS image used for the VM. |
| `osDisk` | object | | Complex structure, see below. | Required. Specifies the OS disk. |
| `dataDisks` | array | [] | Complex structure, see below. | Optional. Specifies the data disks. |
| `ultraSSDEnabled` | bool | `false` | | Optional. The flag that enables or disables a capability to have one or more managed data disks with UltraSSD_LRS storage account type on the VM or VMSS. Managed disks with storage account type UltraSSD_LRS can be added to a virtual machine or virtual machine scale set only if this property is enabled. |
| `adminUsername` | securestring | | | Required. Administrator username. |
| `adminPassword` | securestring | `""` | | Optional. When specifying a Windows Virtual Machine, this value should be passed. |
| `customData` | securestring | `""` | | Optional. Custom data associated to the VM, this value will be automatically converted into base64 to account for the expected VM format. |
| `windowsConfiguration` | object | {} | Complex structure, see below. | Optional. Specifies Windows operating system settings on the virtual machine. |
| `linuxConfiguration` | object | {} | Complex structure, see below. | Optional. Specifies Linux operating system settings on the virtual machine. |
| `certificatesToBeInstalled` | array | [] | | Optional. Specifies set of certificates that should be installed onto the virtual machine. |
| `allowExtensionOperations` | bool | `true` | | Optional. Specifies whether extension operations should be allowed on the virtual machine. This may only be set to False when no extensions are present on the virtual machine. |
| `requireGuestProvisionSignal` | bool | `false` | | Optional. Specifies whether the guest provision signal is required from the virtual machine. |
| `availabilitySetName` | string | `""` | | Optional. Creates an availability set with the given name and adds the VMs to it. Cannot be used in combination with availability zone nor scale set. |
| `availabilitySetFaultDomain` | int | `2` | | Optional. The number of fault domains to use. |
| `availabilitySetUpdateDomain` | int | `5` | | Optional. The number of update domains to use. |
| `availabilitySetSku` | string | `"Aligned"` | | Optional. Sku of the availability set. Use 'Aligned' for virtual machines with managed disks and 'Classic' for virtual machines with unmanaged disks. |
| `scaleSetName` | string | `""` | | Optional. Creates a virtual machine scale set with the given name and adds the VMs to it. Cannot be used in combination with availability zone nor availability set. |
| `scaleSetFaultDomain` | int | `2` | | Optional. Fault Domain count for each placement group. |
| `proximityPlacementGroupName` | string | `""` | | Optional. Creates an proximity placement group and adds the VMs to it. |
| `proximityPlacementGroupType` | string | `"Standard"` | Standard/Ultra| Optional. Specifies the type of the proximity placement group. |
| `useAvailabilityZone` | bool | `false` | | Optional. Creates an availability zone and adds the VMs to it. Cannot be used in combination with availability set nor scale set. |
| `subnetId` | string | | | Required. Full qualified subnet Id. |
| `vmIPAddress` | string | `""` | | Optional. IP address used as initial IP address. If left empty, the VM will use the next available IP. |
| `enablePublicIP` | bool | `false` | | Optional. Enables the creation of a Public IP and assigns it to the Network Interface. |
| `enableIPForwarding` | bool | `false` | | Optional. Indicates whether IP forwarding is enabled on this network interface. |
| `enableAcceleratedNetworking` | bool | `false` | | Optional. If the network interface is accelerated networking enabled. |
| `loadBalancerBackendPoolId` | string | `""` | | Optional. Represents a Load Balancer backend pool resource identifier, if left blank, no Load Balancer will be associated to the VMSS. |
| `applicationSecurityGroupId` | string | `""` | | Optional. Application Security Group to associate to the Network Interface. If left empty, the Network Interface would not be associated to any Application Security Group. |
| `vmPriority` | string | `"Regular"` | Regular/Low| Optional. Specifies the priority for the virtual machine. |
| `enableEvictionPolicy` | bool | `false` | | Optional. Specifies the eviction policy for the low priority virtual machine. Will result in 'Deallocate' eviction policy. |
| `maxPriceForLowPriorityVm` | string | `""` | | Optional. Specifies the maximum price you are willing to pay for a low priority VM/VMSS. This price is in US Dollars. |
| `dedicatedHostId` | string | `""` | | Optional. Specifies resource Id about the dedicated host that the virtual machine resides in. |
| `licenseType` | string | `""` | Windows_Client/Windows_Server/""| Optional. Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system. |
| `enableMicrosoftAntiMalware` | bool | `false` | | Optional. Enables Microsoft Windows Defender AV. |
| `microsoftAntiMalwareSettings` | object | {} | Complex structure, see below. | Optional. Settings for Microsoft Windows Defender AV extension. |
| `enableWindowsMMA-Agent` | bool | `false` | | Optional. Specifies if MMA agent for Windows VM should be enabled. |
| `enableLinuxMMA-Agent` | bool | `false` | | Optional. Specifies if MMA agent for Linux VM should be enabled. |
| `enableWindowsDiskEncryption` | bool | `false` | | Optional. Specifies if Windows VM disks should be encrypted. If enabled, boot diagnostics must be enabled as well. |
| `enableLinuxDiskEncryption` | bool | `false` | | Optional. Specifies if Linux VM disks should be encrypted. If enabled, boot diagnostics must be enabled as well. |
| `diskKeyEncryptionAlgorithm` | string | `"RSA-OAEP"` | RSA-OAEP/RSA-OAEP-256/RSA1_5 | Optional. Specifies disk key encryption algorithm. |
| `keyEncryptionKeyURL` | string | `""` | | Optional. URL of the KeyEncryptionKey used to encrypt the volume encryption key. |
| `keyVaultUri` | string | `""` | | Optional. URL of the Key Vault instance where the Key Encryption Key (KEK) resides. |
| `keyVaultId` | string | `""` | | Optional. Resource identifier of the Key Vault instance where the Key Encryption Key (KEK) resides. |
| `diskEncryptionVolumeType` | string | `"All"` | OS/Data/All | Optional. Type of the volume OS or Data to perform encryption operation |
| `windowsScriptExtensionFileUris` | array | [] |  | Optional. Specifies URIs of the scripts that need to be downloaded and run on a Windows VM. |
| `windowsScriptExtensionFileUrisSasToken` | securestring | "" |  | Optional. Specifies the SaS token of the URIs for scripts that need to be downloaded and run on a Windows VM. |
| `windowsScriptExtensionCommandToExecute` | securestring | "" |  | Optional. Specifies the command that should be run on a Windows VM. |
| `forceUpdateTag` | string | `"1.0"` | | Optional. Pass in an unique value like a GUID everytime the operation needs to be force run. |
| `resizeOSDisk` | bool | `false` | | Optional. Should the OS partition be resized to occupy full OS VHD before splitting system volume. |
| `enableBootDiagnostics` | bool | `false` | | Optional. Whether boot diagnostics should be enabled on the Virtual Machine. |
| `bootDiagnosticStorageAccountName` | string | `` | | Optional. Storage account used to store boot diagnostic information. |
| `diagnosticLogsRetentionInDays` | int | `365` | | Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| `diagnosticStorageAccountId` | string | "" | | Optional. Resource identifier of the Diagnostic Storage Account. |
| `workspaceId` | string | "" | | Optional. Resource identifier of Log Analytics. |
| `eventHubAuthorizationRuleId` | string | "" | | Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| `eventHubName` | string | "" | | Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. |
| `lockForDeletion` | bool | `true` | | Optional. Switch to lock Virtual Machine from deletion. |
| `tags` | object | {} | Complex structure, see below. | Optional. Tags of the Virtual Machine resource. |

### Parameter Usage: `standardImage`

```json
"imageResourceId": {
    "value": {
        "publisher": "MicrosoftWindowsServer",
        "offer": "WindowsServer",
        "sku": "2016-Datacenter",
        "version": "latest"
    }
}
```

### Parameter Usage: `marketImage`

```json
"imageResourceId": {
    "value": {
        "id": "/subscriptions/12345-6789-1011-1213-15161718/resourceGroups/rg-name/providers/Microsoft.Compute/images/imagename"
    }
}

### Parameter Usage: `osDisk`

```json
 "osDisk": {
    "value": {
        "createOption": "fromImage",
        "diskSizeGB": "128",
        "managedDisk": {
            "storageAccountType": "Premium_LRS"
        }
    }
}
```

### Parameter Usage: `dataDisks`

```json
"dataDisks": {
    "value": [{
        "caching": "ReadOnly",
        "createOption": "Empty",
        "diskSizeGB": "256",
        "managedDisk": {
            "storageAccountType": "Premium_LRS"
        }
    },
    {
        "caching": "ReadOnly",
        "createOption": "Empty",
        "diskSizeGB": "128",
        "managedDisk": {
            "storageAccountType": "Premium_LRS"
        }
    }]
}
```

### Parameter Usage: `windowsConfiguration`

```json
"windowsConfiguration": {
    "provisionVMAgent": "boolean",
    "enableAutomaticUpdates": "boolean",
    "timeZone": "string",
    "additionalUnattendContent": [
        {
        "passName": "OobeSystem",
        "componentName": "Microsoft-Windows-Shell-Setup",
        "settingName": "string",
        "content": "string"
        }
    ],
    "winRM": {
        "listeners": [
        {
            "protocol": "string",
            "certificateUrl": "string"
        }
        ]
    }
}
```

### Parameter Usage: `linuxConfiguration`

```json
"linuxConfiguration": {
    "disablePasswordAuthentication": "boolean",
    "ssh": {
        "publicKeys": [
        {
            "path": "string",
            "keyData": "string"
        }
        ]
    },
    "provisionVMAgent": "boolean"
    },
    "secrets": [
    {
        "sourceVault": {
        "id": "string"
        },
        "vaultCertificates": [
        {
            "certificateUrl": "string",
            "certificateStore": "string"
        }
        ]
    }
    ],
    "allowExtensionOperations": "boolean",
    "requireGuestProvisionSignal": "boolean"
}
```

### Parameter Usage: `microsoftAntiMalwareSettings`

```json
"microsoftAntiMalwareSettings": {
    "AntimalwareEnabled": true,
    "Exclusions": {
        "Extensions": ".log;.ldf",
        "Paths": "D:\\IISlogs;D:\\DatabaseLogs",
        "Processes": "mssence.svc"
    },
    "RealtimeProtectionEnabled": true,
    "ScheduledScanSettings": {
        "isEnabled": "true",
        "scanType": "Quick",
        "day": "7",
        "time": "120"
    }
}
```

### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

```json
"tags": {
    "value": {
        "ApplicationName":"Azure Core Resources",
        "ContactEmail": "Infra_Apps@pima.gov",
        "Department": "ITD",
        "CostCenter":"12345",
        "OwnerName":"Ken Mayer",
        "DisasterRecovery": "No",
        "Environment": "Prod",
        "Tier": "0"
    }
}
```

## Outputs

No outputs

## Considerations

*N/A*

## Additional resources

- [Overview of Windows virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/overview)
- [Microsoft.Compute virtualMachines template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/allversions)
- [Use tags to organize your Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-using-tags)