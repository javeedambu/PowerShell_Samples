# Build a map of Volume DeviceID to DiskNumber
$partitionMap = @{}

Get-Partition | Sort-Object DiskNumber | ForEach-Object {
    $partition = $_
    $volume = Get-Volume -Partition $partition -ErrorAction SilentlyContinue
    if ($volume) {
        $partitionMap[$volume.UniqueId] = $partition.DiskNumber
    }
}

# Now get volumes and join DiskNumber
Get-CimInstance -ClassName Win32_Volume | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
    $diskNumber = $partitionMap[$_.DeviceID]  # Use DeviceID as key
    [PSCustomObject]@{
        DiskNumber     = $diskNumber
        DriveLetter    = $_.DriveLetter
        MountPath      = $_.Name
        Label          = $_.Label
        FileSystem     = $_.FileSystem
        BlockSize_KB   = $_.BlockSize / 1KB
        Capacity_GB    = [math]::Round($_.Capacity / 1GB, 2)
        FreeSpace_GB   = [math]::Round($_.FreeSpace / 1GB, 2)
        DeviceID       = $_.DeviceID
    }
} | Sort-Object DiskNumber | Format-Table -AutoSize
