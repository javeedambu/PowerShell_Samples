Get-Disk | 
    Select-Object Number, @{Name="Disk ID";Expression={$_.UniqueId}}, FriendlyName, OperationalStatus, @{Name="Size(GB)";Expression={[math]::round($_.Size / 1GB, 2)}}, Model, SerialNumber |
    ForEach-Object {
        $disk = $_
        $partitions = Get-Partition -DiskNumber $disk.Number
        $partitions | ForEach-Object {
            $partition = $_
            $volume = Get-Volume -DriveLetter $partition.DriveLetter -ErrorAction SilentlyContinue

            # If the partition has a volume, calculate used and free space
            if ($volume) {
                $usedSpaceGB = [math]::round(($volume.Size - $volume.FreeSpace) / 1GB, 2)
                $freeSpaceGB = [math]::round($volume.FreeSpace / 1GB, 2)
            } else {
                # If no volume, set both used and free space to null or zero
                $usedSpaceGB = 0
                $freeSpaceGB = 0
            }

            [PSCustomObject]@{
                "Disk Number"            = $disk.Number
                "Disk ID"                = $disk.'Disk ID'
                "Disk FriendlyName"      = $disk.FriendlyName
                "Disk Model"             = $disk.Model
                "Disk Size(GB)"          = $disk.'Size(GB)'
                "Disk Serial Number"     = $disk.SerialNumber
                "Partition Number"       = $partition.PartitionNumber
                "Partition DriveLetter"  = $partition.DriveLetter
                "Partition Size(GB)"     = [math]::round($partition.Size / 1GB, 2)
                "Used Space(GB)"         = $usedSpaceGB
                "Free Space(GB)"         = $freeSpaceGB
            }
        }
    } | Export-Csv C:\TEMP\mydisks.csv -NoTypeInformation
