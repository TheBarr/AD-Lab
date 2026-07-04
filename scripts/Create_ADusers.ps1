<#
.SYNOPSIS
Automatyzacja masowego tworzenia uzytkownikow w Active Directory.

.DESCRIPTION
Skrypt pobiera dane z pliku CSV, generuje standaryzowane loginy, 
przypisuje domyslne hasla i bezpiecznie tworzy konta w wybranym OU.
Zawiera weryfikacje duplikatow oraz obsluge bledow (Try/Catch).
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$CsvPath,

    [Parameter(Mandatory=$false)]
    [string]$TargetOU = "OU=HR,OU=6_Departments,OU=BartekCorp,DC=bartek,DC=com"
)

Import-Module ActiveDirectory

try {
    $users = Import-Csv -Path $CsvPath -Delimiter ";"
} catch {
    Write-Error "KRYTYCZNY BLAD: Nie mozna wczytac pliku CSV. Sprawdz sciezke."
    exit
}

foreach ($user in $users) {
    
    $firstName = $user.Imie
    $lastName = $user.Nazwisko
    
    $firstLetter = $firstName.Substring(0,1).ToLower()
    $samAccountName = "$firstLetter$($lastName.ToLower())"
    $displayName = "$firstName $lastName"
    $upn = "$samAccountName@bartek.com"
    
    $securePassword = ConvertTo-SecureString "Start123!" -AsPlainText -Force
    
    if (Get-ADUser -Filter "sAMAccountName -eq '$samAccountName'") {
        Write-Warning "Uzytkownik $samAccountName juz istnieje w bazie AD. Pomijam proces."
    } else {
        try {
            Write-Host "Trwa wdrazanie uzytkownika: $displayName ($samAccountName)..." -ForegroundColor Green
            
            New-ADUser -Name $displayName `
                       -SamAccountName $samAccountName `
                       -GivenName $firstName `
                       -Surname $lastName `
                       -DisplayName $displayName `
                       -UserPrincipalName $upn `
                       -Path $TargetOU `
                       -AccountPassword $securePassword `
                       -ChangePasswordAtLogon $true `
                       -Enabled $true
                       
        } catch {
            Write-Error "Wystapil blad podczas tworzenia konta $samAccountName : $_"
        }
    }
}