#Import AD Module
Import-Module ActiveDirectory

#Create some OUs for Users and Computers
$domain = Get-ADDomain
New-ADOrganizationalUnit -Name "Nintendo Users" -Path $domain.DistinguishedName
New-ADOrganizationalUnit -Name "Nintendo Computers" -Path $domain.DistinguishedName
New-ADOrganizationalUnit -Name "Nintendo Groups" -Path $domain.DistinguishedName

$Password = ConvertTo-SecureString "agxsFX72xwsSAi" -AsPlainText -Force
$OU = Get-ADOrganizationalUnit -Identity "OU=Nintendo Users,$($domain.DistinguishedName)"

$users = Import-Csv -Path .\Fake_User_data.csv
foreach($item in $users){
    $userData = @{
        City = $item.City
        Country = $item.Country
        Department = $item.Department
        Company = "Nintendo"
        DisplayName = "$($item.GivenName) $($item.Surname)"
        Name = "$($item.GivenName) $($item.Surname)"
        GivenName = $item.GivenName
        Title = $item.Occupation
        SamAccountName = $item.Username
        UserPrincipalName = "$($item.Username)@$($domain.DNSRoot)"
        AccountPassword = $Password
        PostalCode = $item.ZipCode
        State = $item.State
        StreetAddress = $item.StreetAddress
        Surname = $item.Surname
        MobilePhone = $item.TelephoneNumber
        OfficePhone = $item.TelephoneNumber
        Enabled = $true
        ChangePasswordAtLogon = $false
        Path = $OU.DistinguishedName
    }
    New-ADUser @userData
}
