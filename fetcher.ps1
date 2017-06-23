function ComputerSystemInformation(){
    Get-WmiObject Win32_ComputerSystem | Select-Object -Property AdminPasswordStatus, Caption, CurrentTimeZone, DNSHostName, Domain , DomainRole, InstallDate, KeyboardPasswordStatus, LastLoadInfo, Manufacturer, Model, Name, NetworkServerModeEnabled, OEMLogoBitmap, PartOfDomain, PrimaryOwnerName, PrimaryOwnerContact, UserName,@{Name="OEMStringArray";Expression={$_.OEMStringArray -join ";"}},@{Name="TotalPhysicalMemory";Expression={"$($_.TotalPhysicalMemory) bytes or $([math]::Round($_.TotalPhysicalMemory/([math]::pow(10,9)),2)) GB "}} | Export-Csv -Force -NoTypeInformation ComputerSystem.csv 
}

function NetworkShareInformation(){
    Get-WmiObject Win32_Share | Select-Object -Property PSComputerName, AccessMask, AllowMaximum, Caption, Description, InstallDate , MaximumAllowed, Name, Path, Status | Export-Csv -Force -NoTypeInformation SystemShare.csv
}

function NetworkingInformation(){
    ##netstat -aenrst | Out-File NetworkStatistics.txt
    #Interface statistics, list
    #IPv4/6,ICMPv4/6,TCP IPv4,IPv6,UDP IPv4/6 statistics
    #IPv4/6 route table
    #Persistent routes
    #..\Tools\Tcpvcon.exe -ac > resolved_traffic.csv
    #..\Tools\Tcpvcon.exe -acn > unresolved_traffic.csv
    ##Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object -Property * | Export-Csv -Force -NoTypeInformation NetworkAdapterConfiguration.csv
    ##Get-WmiObject Win32_NetworkAdapter | Select-Object -Property * | Export-Csv -Force -NoTypeInformation NetworkAdapter.csv
}

function UserInformation(){
    Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'" | Select-Object PSComputerName, AccountType, Caption, Description, Disabled, Domain, FullName, InstallDate, LocalAccount, Lockout, Name, PasswordChangeable, PasswordExpires, PasswordRequired, SID, SIDType, Status | Export-Csv -Force -NoTypeInformation UserAccounts.csv
    #..\Tools\logonsessions.exe /accepteula -c -p -nobanner > logonsessions.csv
    ##net localgroup Administrators > local_administrators.txt
}

function USBInformation(){
    Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\services\USBSTOR -Name Start | Export-Csv -Force -NoTypeInformation USBStatus.csv
    Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\* | Select-Object -Property DeviceDesc, FriendlyName, PSPath |Export-Csv -Force -NoTypeInformation USBHistory.csv
}

function ASEPInformation(){
..\Tools\autorunsc.exe -a * -c -h -s -t -nobanner > autorunsc.csv
}

function SignatureInformation(){
#..\Tools\sigcheck.exe -a -c -e -h -s -nobanner -accepteula C:\ > sigcheck.csv
}

function OSInformation(){
    Get-WmiObject Win32_OperatingSystem | Select-Object -Property PSComputerName, BootDeviceBootDevice, BuildNumber, BuildType, Caption, CountryCode, CurrentTimeZone, DataExecutionPrevention_32BitApplications, DataExecutionPrevention_Available, DataExecutionPrevention_Drivers, DataExecutionPrevention_SupportPolicy, Debug, Description, Distributed, EncryptionLevel, InstallDate, LastBootUpTime, LocalDateTime, Locale, Manufacturer, NumberOfLicensedUsers, NumberOfUsers, Organization, OSArchitecture, OSLanguage, OSProductSuite, PAEEnabled, PlusProductID, PlusVersionNumber, Primary, ProductType, RegisteredUser, SerialNumber, ServicePackMajorVersion, ServicePackMinorVersion, Status, SystemDevice, SystemDirectory, SystemDrive, WindowsDirectory, Version | Export-Csv -Force -NoTypeInformation OperatingSystem.csv
}

function BIOSInformation(){
    Get-WmiObject Win32_BIOS | Select-Object -Property BuildNumber, Caption, CurrentLanguage, Description, IdentificationCode, InstallableLanguages, InstallDate, LanguageEdition, Manufacturer, Name, OtherTargetOS, PrimaryBIOS, ReleaseDate, SerialNumber, SMBIOSBIOSVersion, SMBIOSMajorVersion, SMBIOSMinorVersion, SMBIOSPresent, Status, TargetOperatingSystem, Version,@{Name="BiosCharacteristics";Expression={$_.BiosCharacteristics -join ";"}},@{Name="BIOSVersion";Expression={$_.BIOSVersion -join ";"}},@{Name="ListOfLanguages";Expression={$_.ListOfLanguages -join ";"}} | Export-Csv -Force -NoTypeInformation BIOSInformation.csv
}

function DiskInformation(){
    Get-WmiObject Win32_DiskDrive | Select-Object -Property Caption, Description, FirmwareRevision, Manufacturer, Name, Partitions, Size | Export-Csv -Force -NoTypeInformation PhysicalDisk.csv
    Get-WmiObject Win32_DiskPartition | Select-Object -Property Bootable, BootPartition, Caption, Description, InstallDate, Name, Status, StatusInfo, SystemName, Type, Size, Index | Export-Csv -Force -NoTypeInformation Partitions.csv
    Get-WmiObject Win32_LogicalDisk | Select-Object -Property Availability, Caption, Description, DeviceId, DriveType, FileSystem, ProviderName, FreeSpace, InstallDate, Name, Size, Status, StatusInfo, VolumeName | Export-Csv -Force -NoTypeInformation FilesystemInPartition.csv
}

function UpdateInformation(){
    Get-WmiObject Win32_ReliabilityRecords | Select-Object -Property EventIdentifier, Logfile, Message, ProductName, RecordNumber, SourceName, TimeGenerated, User, @{Name="InsertionStrings";Expression={$_.InsertionStrings -join ";"}} | Export-Csv -Force -NoTypeInformation InstalledPatches.csv
}

function AVInformation(){
    Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntiVirusProduct | Select-Object -Property displayName, pathToSignedProductExe, pathToSignedReportingExe, productState | Export-Csv -Force -NoTypeInformation AntiVirus.csv
}

function SoftwareInformation(){
    Get-WmiObject Win32_Product | Select-Object -Property Caption, Description, InstallLocation, InstallSource, InstallState, Language, LocalPackage, Name, PackageCache, PackageCode, PackageName, ProductID, RegCompany, RegOwner, URLInfoAbout, URLUpdateInfo, Vendor, Version | Export-Csv -Force -NoTypeInformation InstalledProductInformation.csv
}

function ServiceInformation(){
    Get-WmiObject Win32_Service | Select-Object -Property Caption, Description, DisplayName, InstallDate, Name, PathName, State, Status, StartMode, TotalSessions | Export-Csv -Force -NoTypeInformation ServicesInformation.csv
}

function PrinterInformation(){
    Get-WmiObject Win32_Printer | Select-Object -Property Caption, Description, DriverName, InstallDate, JobCountSinceLastReset, Name, PrinterState, PrinterStatus, ServerName, Shared, ShareName, Status, StatusInfo, SystemName | Export-Csv -Force -NoTypeInformation PrinterInformation.csv
}

function Initialization(){
New-Item -Name Output -ItemType Directory -ErrorAction Stop
Set-Location Output
}

function Cleanup(){

}

Initialization
ComputerSystemInformation
NetworkShareInformation
NetworkingInformation
UserInformation
USBInformation
ASEPInformation
SignatureInformation
OSInformation
BIOSInformation
DiskInformation
UpdateInformation
AVInformation
SoftwareInformation
ServiceInformation
PrinterInformation
Cleanup