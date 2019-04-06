# Generated by SQL Server Management Studio at 20:04 on 02/04/2019

Import-Module SqlServer
# Load reflected assemblies

[reflection.assembly]::LoadwithPartialName('System.Data.SqlClient') | Out-Null
[reflection.assembly]::LoadwithPartialName('Microsoft.SQLServer.SMO') | Out-Null
[reflection.assembly]::LoadwithPartialName('Microsoft.SQLServer.ConnectionInfo') | Out-Null

# Set up connection and database SMO objects

$sqlConnectionString = 'Data Source=TCDBA;Integrated Security=True;MultipleActiveResultSets=False;Encrypt=False;TrustServerCertificate=True;Packet Size=4096;Application Name="Microsoft SQL Server Management Studio"'
$sqlConnection = New-Object 'System.Data.SqlClient.SqlConnection' $sqlConnectionString
$serverConnection = New-Object 'Microsoft.SqlServer.Management.Common.ServerConnection' $sqlConnection
$smoServer = New-Object 'Microsoft.SqlServer.Management.Smo.Server' $serverConnection
$smoDatabase = $smoServer.Databases['Casino']

# If your encryption changes involve keys in Azure Key Vault, uncomment one of the lines below in order to authenticate:
#   * Prompt for a username and password:
#Add-SqlAzureAuthenticationContext -Interactive

#   * Enter a Client ID, Secret, and Tenant ID:
#Add-SqlAzureAuthenticationContext -ClientID '<Client ID>' -Secret '<Secret>' -Tenant '<Tenant ID>'

# Change encryption schema

$encryptionChanges = @()

# Add changes for table [Admin].[utbl_CreditCard]
$encryptionChanges += New-SqlColumnEncryptionSettings -ColumnName Admin.utbl_CreditCard.CardNumber_Encrypted -EncryptionType Randomized -EncryptionKey CEK_Auto1

Set-SqlColumnEncryption -ColumnEncryptionSettings $encryptionChanges -InputObject $smoDatabase
