Function Remove-AzVMInstanceResource {
    [cmdletbinding(SupportsShouldProcess,ConfirmImpact='High')]
    Param (
        [parameter(mandatory)]
        [String]$ResourceGroup,

        # The VM name to remove, regex are supported
        [parameter(mandatory)]
        [String]$VMName,

        # A configuration setting to also delete public IP's, off by default
        $RemovePublicIP = $False
    )

        # Remove the VM's and then remove the datadisks, osdisk, NICs, Availability Set
        Get-AzVM -ResourceGroupName $ResourceGroup | Where-Object Name -Match $VMName  | ForEach-Object {
            $a=$_
            $DataDisks = if (![string]::IsNullOrWhiteSpace($a.StorageProfile.DataDisks.Name))
                            {
                                @($a.StorageProfile.DataDisks.Name)
                            }
            #write-output $DataDisks
            $OSDisk = if (![string]::IsNullOrWhiteSpace($a.StorageProfile.OSDisk.Name))
                        {
                            @($a.StorageProfile.OSDisk.Name)
                        }
                        write-output $OSDisk
            $AvailSet = if (![string]::IsNullOrWhiteSpace($a.AvailabilitySetReference.Id))
                            {
                                @($a.AvailabilitySetReference.Id).split('/')[8]
                            }
            if (![string]::IsNullOrWhiteSpace($(($a.NetworkProfile.NetworkInterfaces.Id).split('/')[8]).NetworkSecurityGroup.id))
            {
                $NSGName = $((Get-AzNetworkInterface -name $($a.NetworkProfile.NetworkInterfaces.Id).split('/')[8]).NetworkSecurityGroup.id).split('/')[8]
            }

            if ($pscmdlet.ShouldProcess("$($_.Name)", "Removing VM, Disks, NIC (PublicIP), Availability Set: $($_.Name)"))
            {
                Write-Warning -Message "Removing VM: $($_.Name)"
                $_ | Remove-AzVM -Force -Confirm:$false
                $_.NetworkProfile.NetworkInterfaces | Where-Object {$_.ID} | ForEach-Object {
                    $NICName = Split-Path -Path $_.ID -leaf
                    Write-Warning -Message "Removing NIC: $NICName"
                    $Nic = Get-AzNetworkInterface -ResourceGroupName $ResourceGroup -Name $NICName
                    $Nic | Remove-AzNetworkInterface -Force
                    write-output $Nic
                    #
                    # Optionally remove public ip's, will not save the static ip, if you need the same one, do not delete it.
                    #
                    if ($RemovePublicIP)
                    {
                        $nic.IpConfigurations.PublicIpAddress | where {$_.ID} | ForEach-Object {
                            $PublicIPName = Split-Path -Path $_.ID -leaf
                            Write-Warning -Message "Removing PublicIP: $PublicIPName"
                            $PublicIP = Get-AzPublicIpAddress -ResourceGroupName $ResourceGroup -Name $PublicIPName
                            write-output $PublicIP
                            $PublicIP | Remove-AzPublicIpAddress -Force
                        }
                    }
                }
                if ($NSGName) {
                    Write-Warning -Message "Removing Network Security Group: $NSGName"
                    Remove-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroup -Name $NSGName -Force
                }
                # Support to remove managed disks
                if ($DataDisks) {
                    $DataDisks | ForEach-Object {
                        Write-Warning -Message "Removing Disk: $_"
                        Get-AzDisk -ResourceGroupName $ResourceGroup -DiskName $_ | Remove-AzDisk -Force
                    }
                }
                if ($OSDisks) {
                    $OSDisks | ForEach-Object {
                        Write-Warning -Message "Removing Disk: $_"
                        Get-AzDisk -ResourceGroupName $ResourceGroup -DiskName $_ | Remove-AzDisk -Force
                    }
                # Support to remove unmanaged disks (from Storage Account Blob)
                else {
                    # This assumes that OSDISK and DATADisks are on the same blob storage account
                    # Modify the function if that is not the case.
                    $saname = ($a.StorageProfile.OsDisk.Vhd.Uri -split '\.' | Select-Object -First 1) -split '//' |  Select-Object -Last 1
                    $sa = Get-AzStorageAccount -ResourceGroupName $ResourceGroup -Name $saname
                    # Remove DATA disks
                    $a.StorageProfile.DataDisks | ForEach-Object {
                        $disk = $_.Vhd.Uri | Split-Path -Leaf
                        Get-AzStorageContainer -Name vhds -Context $Sa.Context |
                        Get-AzStorageBlob -Blob  $disk |
                        Remove-AzStorageBlob
                    }
                    # Remove OSDisk disk
                    $disk = $a.StorageProfile.OsDisk.Vhd.Uri | Split-Path -Leaf
                    Get-AzStorageContainer -Name vhds -Context $Sa.Context |
                    Get-AzStorageBlob -Blob  $disk |
                    Remove-AzStorageBlob
                }
                if($AvailSet) {
                    Write-Warning -Message "Removing Availability Set: $AvailSet"
                    Remove-AzAvailabilitySet -Name $AvailSet -ResourceGroupName $ResourceGroup -Force
                }
                # If you are on the network you can cleanup the Computer Account in AD
                # Get-ADComputer -Identity $a.OSProfile.ComputerName | Remove-ADObject -Recursive -confirm:$false
            }
            #PSCmdlet(ShouldProcess)
        }
    }
}
    Remove-AzVMInstanceResource