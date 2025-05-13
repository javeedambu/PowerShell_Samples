# DISK PARTITIONS
Get-Volume | Select-Object `
    DriveLetter, `
    FileSystemLabel, `
    FileSystem, `
    @{Name="Size(GB)";Expression={"{0:N2}" -f ($_.Size / 1GB)}}, `
    @{Name="AllocationUnitSize(KB)";Expression={"{0:N0}" -f ($_.AllocationUnitSize / 1KB)}}, `
    HealthStatus, `
    OperationalStatus, `
    Path | Export-Csv "C:\temp\DiskPartitions.csv" -NoTypeInformation


# PHYSICAL DISK INFO
Get-PhysicalDisk | Select-Object FriendlyName, SerialNumber, MediaType, Size, OperationalStatus | Export-Csv "C:\temp\PhysicalDisks.csv" -NoTypeInformation
