param([string] $GPOBackupDir = "C:\GPOBackups",
      [string] $GPOReportsDir = "C:\GPOReports",
      [string] $ReportType = "HTML")

# This Script Backs up all GPOs and then creates individual reports for each GPO
# Default Directories are C:\GPOBackups and C:\GPOReports
# Default type is HTML , but XML is Supported
$location = $GPOBackupDir
$domain = Get-ADDomain
$GPOs = Get-GPO -all

md -Force $GPOBackupDir
md -Force $GPOReportsDir

#Backup All GPOs and create a text file with the inventory
(Backup-GPO -All -Path "$GPOBackupDir" > "$GPOBackupDir\!GPOLIST.TXT" )

#Report on GPOs and create individual files to Given Directory and Format

If ($ReportType.ToUpper() -eq "XML") {$GPOs | ForEach-Object {$dname = $_.DisplayName 
    Get-GPOReport -name ($dname) -ReportType $ReportType -Path ("$GPOReportsDir\$dname.xml")}}
Elseif ($ReportType.ToUpper() -eq "HTML")  {$GPOs | ForEach-Object {$dname = $_.DisplayName 
    Get-GPOReport -name ($dname) -ReportType $ReportType -Path ("$GPOReportsDir\$dname.html")}}
Else { Write-Host "Invalid Report type , please try either XML or HTML"}
